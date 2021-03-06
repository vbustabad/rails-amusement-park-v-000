require 'pry'

class Ride < ActiveRecord::Base
  belongs_to :attraction
  belongs_to :user

  validates :user, presence: true
  validates :attraction, presence: true

  def take_ride
    if !sufficient_tickets && tall_enough
      insufficient_tickets_message
    elsif !tall_enough && sufficient_tickets
      not_tall_enough_message
    elsif !sufficient_tickets && !tall_enough
      does_not_meet_both_requirements_message
    else
      begin_ride
    end
  end

  def sufficient_tickets
    self.user.tickets >= self.attraction.tickets ? true : false
  end

  def tall_enough
    self.user.height >= self.attraction.min_height ? true : false
  end

  def begin_ride
    self.user.tickets -= self.attraction.tickets
    self.user.happiness += self.attraction.happiness_rating
    self.user.nausea += self.attraction.nausea_rating
    self.user.save

    successful_ride_message
  end

  def successful_ride_message
    "Thanks for riding the #{self.attraction.name}!"
  end

  def not_tall_enough_message
    "Sorry. You are not tall enough to ride the #{self.attraction.name}."
  end

  def insufficient_tickets_message
    "Sorry. You do not have enough tickets to ride the #{self.attraction.name}."
  end

  def does_not_meet_both_requirements_message
    "Sorry. You do not have enough tickets to ride the #{self.attraction.name}. You are not tall enough to ride the #{self.attraction.name}."
  end
end
