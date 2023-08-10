#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != "year" ]]
  then
    # get ids
    WINNER_NAME_ID=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    OPPONENT_NAME_ID=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")

    if [[ -z $WINNER_NAME_ID ]]
    then
      INSERT_WINNER_NAME_RESULTS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      if [[ $INSERT_WINNER_NAME_RESULTS == "INSERT 0 1" ]]
        then
          echo Inserted into teams: $WINNER
        fi
    fi

    if [[ -z $OPPONENT_NAME_ID ]]
    then
      INSERT_OPPONENT_RESULTS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      if [[ $INSERT_OPPONENT_RESULTS == "INSERT 0 1" ]]
        then
          echo Inserted into teams: $OPPONENT
        fi
    fi
    
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    INSERT_RESULTS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
    if [[ $INSERT_RESULTS == "INSERT 0 1" ]]
    then
      echo Inserted into games: $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS
    fi


  fi
done