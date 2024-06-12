with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Semaphores; use GNAT.Semaphores;

procedure Main is
   task type Philosopher is
      entry Start(PhilosopherId : Integer);
   end Philosopher;

   Forks : array (1..5) of Counting_Semaphore(1, Default_Ceiling);

task body Philosopher is
      Id : Integer;
      LeftForkId, RightForkId : Integer;
   begin
      accept Start(PhilosopherId : in Integer) do
         Id := PhilosopherId;
         LeftForkId := Id;
         RightForkId := Id rem 5 + 1;

      end Start;
      Put_Line("P " & Id'Img & " is thinking");
      if Id mod 2 = 0 then
         Forks(LeftForkId).Seize;
         Put_Line("P " & Id'Img & " took left");
         Forks(RightForkId).Seize;
         Put_Line("P " & Id'Img & " took right");
      else
         Forks(RightForkId).Seize;
         Put_Line("P " & Id'Img & " took right");
         Forks(LeftForkId).Seize;
         Put_Line("P " & Id'Img & " took left");
      end if;

      delay(Standard.Duration(0.2));

      Put_Line("P " & Id'Img & " is eating" );

      Forks(RightForkId).Release;
      Put_Line("P " & Id'Img & " put right");
      Forks(LeftForkId).Release;
      Put_Line("P " & Id'Img & " put left");

   end Philosopher;

   Philosophers : array (1..5) of Philosopher;

begin
   for Id in Philosophers'Range loop
      Philosophers(Id).Start(Id);
   end loop;
end Main;
