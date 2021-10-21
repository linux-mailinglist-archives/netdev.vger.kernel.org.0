Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A8A4359C8
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 06:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhJUETy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 00:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229452AbhJUETy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 00:19:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E23E5610FF;
        Thu, 21 Oct 2021 04:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634789858;
        bh=fqS/YjY250YzlKopBQTuUV3psAAy06i8yCpyscN0IBM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=NDSZMCY2VtnoFGpFgs+g3jcnkSYFiaSlonLCSLuO7cdxBXACnTGkR3rt7H6rb7EP7
         /iiq+VU0eEjO2ITBlWd91QCubWk3wXSY8e9hwNG9YnQMtGGrEGpy9VPydLjHBkzGkF
         jPCRrA9n7uMFEkBKEtJKXuxHKts1ba0A/2oNyJdRho4ZjFUPqejC19R+WyRaoKJx7N
         HsKx5n7WQga8Yq6OrxMS3i86WrIuwzlfFZhbjxFiyEsV7a1Sj9lHEaJ11qvSkrPcUW
         iXjY4q69AFWQ+QHkQPp6D5xaShufkuQvSBkKO4NaZxtDVec8iChoooWQp3FhvElyRN
         fpCs0elqzaEzA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 9C8EE5C0A46; Wed, 20 Oct 2021 21:17:38 -0700 (PDT)
Date:   Wed, 20 Oct 2021 21:17:38 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc:     donghai qiao <donghai.w.qiao@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, rcu <rcu@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: RCU: rcu stall issues and an approach to the fix
Message-ID: <20211021041738.GQ880162@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <CAOzhvcPLjH_qh4-PEA-MukiRhzkYHQ0UnE21Un+UP9dgpQV3zw@mail.gmail.com>
 <20211005163956.GV880162@paulmck-ThinkPad-P17-Gen-1>
 <CAOzhvcPv59zwq26a9wKbFudLBdxd8tDr6OVDvKwzje2cm2woJw@mail.gmail.com>
 <CAOzhvcOt1gaLiOKFOAYutfDLZy3xyZMPo1N6T+1HYYXzsCpxTw@mail.gmail.com>
 <20211018234646.GX880162@paulmck-ThinkPad-P17-Gen-1>
 <CAOzhvcMJ4zuTczUK07_FQB3q+=XV-k6bLh-K3+Jf_LR2CmYxwA@mail.gmail.com>
 <20211020183757.GL880162@paulmck-ThinkPad-P17-Gen-1>
 <CAOzhvcNiaFM9pAEURdoZSUo8nVfBMMA-+Fwd6QBWr2pk_j48cw@mail.gmail.com>
 <20211020213300.GN880162@paulmck-ThinkPad-P17-Gen-1>
 <CAABZP2xHJBz4HsHHj3bquXc+G=MJ3+SEtBTCTNZF5r9jsEs3DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAABZP2xHJBz4HsHHj3bquXc+G=MJ3+SEtBTCTNZF5r9jsEs3DQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 11:25:22AM +0800, Zhouyi Zhou wrote:
> hi,
> I try to run 5.15.0-rc6+ in a x86-64 qemu-kvm virtual machine with
> CONFIG_PREEMPT=n,  then modprobe rcutore, and run netstrain (a open
> source network performance stress tool) in it, and run following
> program on nohz_full cpus:
> int main()
> {
>     unsigned long l;
>     while (1) {
>       l*=0.3333;
>       l/=0.3333;
>     }
> }
> It seems nothing happens
> I am glad to study the knowledge around this email thread more
> thoroughly, and perform more tests on x86-64 host (instead of a
> virtual machine) and aarch64 host  later on ;-)

Good to hear that it survived, but rcutorture was not designed to play
nice or to share with other stress tests.  ;-)

							Thanx, Paul

> Zhouyi
> 
> On Thu, Oct 21, 2021 at 5:33 AM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Wed, Oct 20, 2021 at 04:05:59PM -0400, donghai qiao wrote:
> > > On Wed, Oct 20, 2021 at 2:37 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > > >
> > > > On Wed, Oct 20, 2021 at 01:48:15PM -0400, donghai qiao wrote:
> > > > > On Mon, Oct 18, 2021 at 7:46 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > > > > >
> > > > > > On Mon, Oct 18, 2021 at 05:18:40PM -0400, donghai qiao wrote:
> > > > > > > I just want to follow up this discussion. First off, the latest issue
> > > > > > > I mentioned in the email of Oct 4th which
> > > > > > > exhibited a symptom of networking appeared to be a problem in
> > > > > > > qrwlock.c. Particularly the problem is
> > > > > > > caused by the 'if' statement in the function queued_read_lock_slowpath() below :
> > > > > > >
> > > > > > > void queued_read_lock_slowpath(struct qrwlock *lock)
> > > > > > > {
> > > > > > >         /*
> > > > > > >          * Readers come here when they cannot get the lock without waiting
> > > > > > >          */
> > > > > > >         if (unlikely(in_interrupt())) {
> > > > > > >                 /*
> > > > > > >                  * Readers in interrupt context will get the lock immediately
> > > > > > >                  * if the writer is just waiting (not holding the lock yet),
> > > > > > >                  * so spin with ACQUIRE semantics until the lock is available
> > > > > > >                  * without waiting in the queue.
> > > > > > >                  */
> > > > > > >                 atomic_cond_read_acquire(&lock->cnts, !(VAL & _QW_LOCKED));
> > > > > > >                 return;
> > > > > > >         }
> > > > > > >         ...
> > > > > > > }
> > > > > > >
> > > > > > > That 'if' statement said, if we are in an interrupt context and we are
> > > > > > > a reader, then
> > > > > > > we will be allowed to enter the lock as a reader no matter if there
> > > > > > > are writers waiting
> > > > > > > for it or not. So, in the circumstance when the network packets steadily come in
> > > > > > > and the intervals are relatively small enough, then the writers will
> > > > > > > have no chance to
> > > > > > > acquire the lock. This should be the root cause for that case.
> > > > > > >
> > > > > > > I have verified it by removing the 'if' and rerun the test multiple
> > > > > > > times.
> > > > > >
> > > > > > That could do it!
> > > > > >
> > > > > > Would it make sense to keep the current check, but to also check if a
> > > > > > writer had been waiting for more than (say) 100ms?  The reason that I
> > > > > > ask is that I believe that this "if" statement is there for a reason.
> > > > >
> > > > > The day before I also got this to Waiman Long who initially made these
> > > > > changes in
> > > > > the qrwlock.c file. Turns out, the 'if' block was introduced to
> > > > > resolve the particular
> > > > > requirement of tasklist_lock reentering as reader.  He said he will
> > > > > perhaps come up
> > > > > with another code change to take care of this new write lock
> > > > > starvation issue. The
> > > > > idea is to only allow the tasklist_lock clients to acquire the read
> > > > > lock through the 'if'
> > > > > statement,  others are not.
> > > > >
> > > > > This sounds like a temporary solution if we cannot think of other
> > > > > alternative ways
> > > > > to fix the tasklist_lock issue. The principle here is that we should
> > > > > not make the
> > > > > locking primitives more special just in favor of a particular usage or scenario.
> > > >
> > > > When principles meet practice, results can vary.  Still, it would be
> > > > better to have a less troublesome optimization.
> > >
> > > This is a philosophical debate. Let's put it aside.
> >
> > Exactly!
> >
> > > > > > >        The same
> > > > > > > symptom hasn't been reproduced.  As far as rcu stall is concerned as a
> > > > > > > broader range
> > > > > > > of problems,  this is absolutely not the only root cause I have seen.
> > > > > > > Actually too many
> > > > > > > things can delay context switching.  Do you have a long term plan to
> > > > > > > fix this issue,
> > > > > > > or just want to treat it case by case?
> > > > > >
> > > > > > If you are running a CONFIG_PREEMPT=n kernel, then the plan has been to
> > > > > > leverage the calls to cond_resched().  If the grace period is old enough,
> > > > > > cond_resched() will supply a quiescent state.
> > > > >
> > > > > So far, all types of rcu stall I am aware of are originated to the
> > > > > CONFIG_PREEMPT=n
> > > > > kernel. Isn't it impossible to let rcu not rely on context switch ?
> > > > > As we know too many
> > > > > things can delay context switch, so it is not a quite reliable
> > > > > mechanism if timing and
> > > > > performance are crucial.
> > > >
> > > > Yes, you could build with CONFIG_PREEMPT=y and RCU would not always
> > > > need to wait for an actual context switch.  But there can be
> > > > performance issues for some workloads.
> > > >
> > > I can give this config (CONFIG_PREEMPT=y) a try when I have time.
> >
> > Very good!
> >
> > > > But please note that cond_resched() is not necessarily a context switch.
> > > >
> > > > Besides, for a great many workloads, delaying a context switch for
> > > > very long is a first-class bug anyway.  For example, many internet data
> > > > centers are said to have sub-second response-time requirements, and such
> > > > requirements cannot be met if context switches are delayed too long.
> > > >
> > > Agreed.
> > >
> > > But on the other hand, if rcu relies on that,  the situation could be
> > > even worse.
> > > Simply put, when a gp cannot end soon, some rcu write-side will be delayed,
> > > and the callbacks on the rcu-stalled CPU will be delayed. Thus in the case of
> > > lack of free memory, this situation could form a deadlock.
> >
> > Would this situation exist in the first place if a blocking form of
> > allocation were not being (erroneously) invoked within an RCU read-side
> > critical section?  Either way, that bug needs to be fixed.
> >
> > > > > > In a CONFIG_PREEMPT=y kernel, when the grace period is old enough,
> > > > > > RCU forces a schedule on the holdout CPU.  As long as the CPU is not
> > > > > > eternally non-preemptible (for example, eternally in an interrupt
> > > > > > handler), the grace period will end.
> > > > >
> > > > > Among the rcu stall instances I have seen so far, quite a lot of them occurred
> > > > > on the CPUs which were running in the interrupt context or spinning on spinlocks
> > > > > with interrupt disabled. In these scenarios, forced schedules will be
> > > > > delayed until
> > > > > these activities end.
> > > >
> > > > But running for several seconds in interrupt context is not at all good.
> > > > As is spinning on a spinlock for several seconds.  These are performance
> > > > bugs in and of themselves.
> > >
> > > Agreed.
> > >
> > > >
> > > > More on this later in this email...
> > > >
> > > > > > But beyond a certain point, case-by-case analysis and handling is
> > > > > > required.
> > > > > >
> > > > > > > Secondly, back to the following code I brought up that day. Actually
> > > > > > > it is not as simple
> > > > > > > as spinlock.
> > > > > > >
> > > > > > >       rcu_read_lock();
> > > > > > >       ip_protocol_deliver_rcu(net, skb, ip_hdr(skb)->protocol);
> > > > > > >       rcu_read_unlock();
> > > > > > >
> > > > > > > Are you all aware of all the potential functions that
> > > > > > > ip_protocol_deliver_rcu will call?
> > > > > > > As I can see, there is a code path from ip_protocol_deliver_rcu to
> > > > > > > kmem_cache_alloc
> > > > > > > which will end up a call to cond_resched().
> > > > > >
> > > > > > Can't say that I am familiar with everything that ip_protocol_deliver_rcu().
> > > > > > There are some tens of millions of lines of code in the kernel, and I have
> > > > > > but one brain.  ;-)
> > > > > >
> > > > > > And this cond_resched() should set things straight for a CONFIG_PREEMPT=n
> > > > > > kernel.  Except that there should not be a call to cond_resched() within
> > > > > > an RCU read-side critical section.
> > > > >
> > > > > with that 3 line snippet from the networking, a call to cond_resched() would
> > > > > happen within the read-side critical section when the level of variable memory
> > > > > is very low.
> > > >
> > > > That is a bug.  If you build your kernel with CONFIG_PROVE_LOCKING=y,
> > > > it will complain about a cond_resched() in an RCU read-side critical
> > > > section.  But, as you say, perhaps only with the level of variable memory
> > > > is very low.
> > >
> > > There is a typo in my previous email. I meant available (or free).
> > > Sorry for that.
> >
> > OK, good, that was my guess.  But invoking a potentially blocking form
> > of a kernel memory allocator is still a bug.  And that bug needs to
> > be fixed.  And fixing it might clear up a large fraction of your RCU
> > grace-period issues.
> >
> > > > Please do not invoke cond_resched() within an RCU read-side critical
> > > > section.  Doing so can result in random memory corruption.
> > > >
> > > > > > Does the code momentarily exit that
> > > > > > critical section via something like rcu_read_unlock(); cond_resched();
> > > > > > rcu_read_lock()?
> > > > >
> > > > > As far as I can see, cond_resched would be called between a pair of
> > > > > rcu_read_lock and rcu_read_unlock.
> > > >
> > > > Again, this is a bug.  The usual fix is the GFP_ thing I noted below.
> > > >
> > > > > > Or does something prevent the code from getting there
> > > > > > while in an RCU read-side critical section?  (The usual trick here is
> > > > > > to have different GFP_ flags depending on the context.)
> > > > >
> > > > > Once we invoke kmem_cache_alloc or its variants, we cannot really
> > > > > predict where we will go and how long this whole process is going to
> > > > > take in this very large area from kmem to the virtual memory subsystem.
> > > > > There is a flag __GFP_NOFAIL that determines whether or not cond_resched
> > > > > should be called before retry, but this flag should be used from page level,
> > > > > not from the kmem consumer level.  So I think there is little we can do
> > > > > to avoid the resched.
> > > >
> > > > If you are invoking the allocator within an RCU read-side critical
> > > > section, you should be using GFP_ATOMIC.  Except that doing this has
> > > > many negative consequences, so it is better to allocate outside of
> > > > the RCU read-side critical section.
> > > >
> > > > The same rules apply when allocating while holding a spinlock, so
> > > > this is not just RCU placing restrictions on you.  ;-)
> > >
> > > yep, absolutely.
> > >
> > > >
> > > > > > >                                              Because the operations in memory
> > > > > > > allocation are too complicated, we cannot alway expect a prompt return
> > > > > > > with success.
> > > > > > > When the system is running out of memory, then rcu cannot close the
> > > > > > > current gp, then
> > > > > > > great number of callbacks will be delayed and the freeing of the
> > > > > > > memory they held
> > > > > > > will be delayed as well. This sounds like a deadlock in the resource flow.
> > > > > >
> > > > > > That would of course be bad.  Though I am not familiar with all of the
> > > > > > details of how the networking guys handle out-of-memory conditions.
> > > > > >
> > > > > > The usual advice would be to fail the request, but that does not appear
> > > > > > to be an easy option for ip_protocol_deliver_rcu().  At this point, I
> > > > > > must defer to the networking folks.
> > > > >
> > > > > Thanks for the advice.
> > > >
> > > > Another question...  Why the endless interrupts?  Or is it just one
> > > > very long interrupt?  Last I knew (admittedly a very long time ago),
> > > > the high-rate networking drivers used things like NAPI in order to avoid
> > > > this very problem.
> > >
> > > These should be long enough interrupts. The symptom in the networking
> > > as the previous email said is one of them.  In that case, due to  rwlock
> > > in favor of the readers in the interrupt context, the writer side would be
> > > blocked as long as the readers keep coming.
> >
> > OK, and hopefully Longman finds a way to get his optimization in some
> > less destructive way.
> >
> > > > Or is this some sort of special case where you are trying to do something
> > > > special, for example, to achieve extremely low communications latencies?
> > >
> > > No, nothing special I am trying to do.
> >
> > OK, good.
> >
> > > > If this is a deliberate design, and if it is endless interrupts instead
> > > > of one big long one, and if you are deliberately interrupt-storming
> > > > a particular CPU, another approach is to build the kernel with
> > > > CONFIG_NO_HZ_FULL=y, and boot with nohz_full=n, where "n" is the number of
> > > > the CPU that is to be interrupt-stormed.  If you are interrupt storming
> > > > multiple CPUs, you can specify them, for example, nohz_full=1-5,13 to
> > > > specify CPUs 1, 2, 3, 4, 5, and 13.  In recent kernels, "N" stands for
> > > > the CPU with the largest CPU number.
> > >
> > > I did this before, and I saw rcu stall as well with this kinda config.
> >
> > When you said you had long enough interrupts, how long were they?
> >
> > If they were long enough, then yes, you would get a stall.
> >
> > Suppose that some kernel code still executes on that CPU despite trying to
> > move things off of it.  As soon as the interrupt hits kernel execution
> > instead of nohz_full userspace execution, there will be no more RCU
> > quiescent states, and thus you can see stalls.
> >
> > > > Then read Documentation/admin-guide/kernel-per-CPU-kthreads.rst, which is
> > > > probably a bit outdated, but a good place to start.  Follow its guidelines
> > > > (and, as needed, come up with additional ones) to ensure that CPU "n"
> > > > is not doing anything.  If you do come up with additional guidelines,
> > > > please submit a patch to kernel-per-CPU-kthreads.rst so that others can
> > > > also benefit, as you are benefiting from those before you.
> > >
> > > Thanks for the suggestion.
> > > >
> > > > Create a CPU-bound usermode application (a "while (1) continue;" loop or
> > > > similar), and run that application on CPU "n".  Then start up whatever
> > > > it is that interrupt-storms CPU "n".
> > > >
> > > > Every time CPU "n" returns from interrupt, RCU will see a quiescent state,
> > > > which will prevent the interrupt storm from delaying RCU grace periods.
> > > >
> > > > On the other hand, if this is one big long interrupt, you need to make
> > > > that interrupt end every so often.  Or move some of the work out of
> > > > interrupt context, perhaps even to usermode.
> > > >
> > > > Much depends on exactly what you are trying to achieve.
> > >
> > > The things that can affect rcu stall are too many. So let's deal with
> > > it case by case
> > > before there is a permanent solution.
> >
> > Getting the bugs fixed should be a good start.
> >
> >                                                         Thanx, Paul
> >
> > > Thanks
> > > Donghai
> > >
> > >
> > >
> > >
> > > >
> > > >                                                         Thanx, Paul
> > > >
> > > > > Donghai
> > > > > >
> > > > > >                                                         Thanx, Paul
> > > > > >
> > > > > > > Thanks
> > > > > > > Donghai
> > > > > > >
> > > > > > >
> > > > > > > On Tue, Oct 5, 2021 at 8:25 PM donghai qiao <donghai.w.qiao@gmail.com> wrote:
> > > > > > > >
> > > > > > > > On Tue, Oct 5, 2021 at 12:39 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > > > > > > > >
> > > > > > > > > On Tue, Oct 05, 2021 at 12:10:25PM -0400, donghai qiao wrote:
> > > > > > > > > > On Mon, Oct 4, 2021 at 8:59 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Mon, Oct 04, 2021 at 05:22:52PM -0400, donghai qiao wrote:
> > > > > > > > > > > > Hello Paul,
> > > > > > > > > > > > Sorry it has been long..
> > > > > > > > > > >
> > > > > > > > > > > On this problem, your schedule is my schedule.  At least as long as your
> > > > > > > > > > > are not expecting instantaneous response.  ;-)
> > > > > > > > > > >
> > > > > > > > > > > > > > Because I am dealing with this issue in multiple kernel versions, sometimes
> > > > > > > > > > > > > > the configurations in these kernels may different. Initially the
> > > > > > > > > > > > > > problem I described
> > > > > > > > > > > > > > originated to rhel-8 on which the problem occurs more often and is a bit easier
> > > > > > > > > > > > > > to reproduce than others.
> > > > > > > > > > > > >
> > > > > > > > > > > > > Understood, that does make things more difficult.
> > > > > > > > > > > > >
> > > > > > > > > > > > > > Regarding these dynticks* parameters, I collected the data for CPU 0 as below :
> > > > > > > > > > > > > >    - dynticks = 0x6eab02    which indicated the CPU was not in eqs.
> > > > > > > > > > > > > >    - dynticks_nesting = 1    which is in its initial state, so it said
> > > > > > > > > > > > > > it was not in eqs either.
> > > > > > > > > > > > > >    - dynticks_nmi_nesting = 4000000000000004    which meant that this
> > > > > > > > > > > > > > CPU had been
> > > > > > > > > > > > > >      interrupted when it was in the middle of the first interrupt.
> > > > > > > > > > > > > > And this is true: the first
> > > > > > > > > > > > > >      interrupt was the sched_timer interrupt, and the second was a NMI
> > > > > > > > > > > > > > when another
> > > > > > > > > > > > > >     CPU detected the RCU stall on CPU 0.  So it looks all identical.
> > > > > > > > > > > > > > If the kernel missed
> > > > > > > > > > > > > >     a rcu_user_enter or rcu_user_exit, would these items remain
> > > > > > > > > > > > > > identical ?  But I'll
> > > > > > > > > > > > > >     investigate that possibility seriously as you pointed out.
> > > > > > > > > > > > >
> > > > > > > > > > > > > So is the initial state non-eqs because it was interrupted from kernel
> > > > > > > > > > > > > mode?  Or because a missing rcu_user_enter() left ->dynticks_nesting
> > > > > > > > > > > > > incorrectly equal to the value of 1?  Or something else?
> > > > > > > > > > > >
> > > > > > > > > > > > As far as the original problem is concerned, the user thread was interrupted by
> > > > > > > > > > > > the timer, so the CPU was not working in the nohz mode. But I saw the similar
> > > > > > > > > > > > problems on CPUs working in nohz mode with different configurations.
> > > > > > > > > > >
> > > > > > > > > > > OK.
> > > > > > > > > > >
> > > > > > > > > > > > > > > There were some issues of this sort around the v5.8 timeframe.  Might
> > > > > > > > > > > > > > > there be another patch that needs to be backported?  Or a patch that
> > > > > > > > > > > > > > > was backported, but should not have been?
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Good to know that clue. I'll take a look into the log history.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > > Is it possible to bisect this?
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > Or, again, to run with CONFIG_RCU_EQS_DEBUG=y?
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > I am building the latest 5.14 kernel with this config and give it a try when the
> > > > > > > > > > > > > > machine is set up, see how much it can help.
> > > > > > > > > > > > >
> > > > > > > > > > > > > Very good, as that will help determine whether or not the problem is
> > > > > > > > > > > > > due to backporting issues.
> > > > > > > > > > > >
> > > > > > > > > > > > I enabled CONFIG_RCU_EQS_DEBUG=y as you suggested and
> > > > > > > > > > > > tried it for both the latest rhel8 and a later upstream version 5.15.0-r1,
> > > > > > > > > > > > turns out no new warning messages related to this came out. So,
> > > > > > > > > > > > rcu_user_enter/rcu_user_exit() should be paired right.
> > > > > > > > > > >
> > > > > > > > > > > OK, good.
> > > > > > > > > > >
> > > > > > > > > > > > > > > Either way, what should happen is that dyntick_save_progress_counter() or
> > > > > > > > > > > > > > > rcu_implicit_dynticks_qs() should see the rdp->dynticks field indicating
> > > > > > > > > > > > > > > nohz_full user execution, and then the quiescent state will be supplied
> > > > > > > > > > > > > > > on behalf of that CPU.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Agreed. But the counter rdp->dynticks of the CPU can only be updated
> > > > > > > > > > > > > > by rcu_dynticks_eqs_enter() or rcu_dynticks_exit() when rcu_eqs_enter()
> > > > > > > > > > > > > > or rcu_eqs_exit() is called, which in turn depends on the context switch.
> > > > > > > > > > > > > > So, when the context switch never happens, the counter rdp->dynticks
> > > > > > > > > > > > > > never advances. That's the thing I try to fix here.
> > > > > > > > > > > > >
> > > > > > > > > > > > > First, understand the problem.  Otherwise, your fix is not so likely
> > > > > > > > > > > > > to actually fix anything.  ;-)
> > > > > > > > > > > > >
> > > > > > > > > > > > > If kernel mode was interrupted, there is probably a missing cond_resched().
> > > > > > > > > > > > > But in sufficiently old kernels, cond_resched() doesn't do anything for
> > > > > > > > > > > > > RCU unless a context switch actually happened.  In some of those kernels,
> > > > > > > > > > > > > you can use cond_resched_rcu_qs() instead to get RCU's attention.  In
> > > > > > > > > > > > > really old kernels, life is hard and you will need to do some backporting.
> > > > > > > > > > > > > Or move to newer kernels.
> > > > > > > > > > > > >
> > > > > > > > > > > > > In short, if an in-kernel code path runs for long enough without hitting
> > > > > > > > > > > > > a cond_resched() or similar, that is a bug.  The RCU CPU stall warning
> > > > > > > > > > > > > that you will get is your diagnostic.
> > > > > > > > > > > >
> > > > > > > > > > > > Probably this is the case. With the test for 5.15.0-r1, I have seen different
> > > > > > > > > > > > scenarios, among them the most frequent ones were caused by the networking
> > > > > > > > > > > > in which a bunch of networking threads were spinning on the same rwlock.
> > > > > > > > > > > >
> > > > > > > > > > > > For instance in one of them, the ticks_this_gp of a rcu_data could go as
> > > > > > > > > > > > large as 12166 (ticks) which is 12+ seconds. The thread on this cpu was
> > > > > > > > > > > > doing networking work and finally it was spinning as a writer on a rwlock
> > > > > > > > > > > > which had been locked by 16 readers.  By the way, there were 70 this
> > > > > > > > > > > > kinds of writers were blocked on the same rwlock.
> > > > > > > > > > >
> > > > > > > > > > > OK, a lock-contention problem.  The networking folks have fixed a
> > > > > > > > > > > very large number of these over the years, though, so I wonder what is
> > > > > > > > > > > special about this one so that it is just now showing up.  I have added
> > > > > > > > > > > a networking list on CC for their thoughts.
> > > > > > > > > >
> > > > > > > > > > Thanks for pulling the networking in. If they need the coredump, I can
> > > > > > > > > > forward it to them.  It's definitely worth analyzing it as this contention
> > > > > > > > > > might be a performance issue.  Or we can discuss this further in this
> > > > > > > > > > email thread if they are fine, or we can discuss it over with a separate
> > > > > > > > > > email thread with netdev@ only.
> > > > > > > > > >
> > > > > > > > > > So back to my original problem, this might be one of the possibilities that
> > > > > > > > > > led to RCU stall panic.  Just imagining this type of contention might have
> > > > > > > > > > occurred and lasted long enough. When it finally came to the end, the
> > > > > > > > > > timer interrupt occurred, therefore rcu_sched_clock_irq detected the RCU
> > > > > > > > > > stall on the CPU and panic.
> > > > > > > > > >
> > > > > > > > > > So definitely we need to understand these networking activities here as
> > > > > > > > > > to why the readers could hold the rwlock too long.
> > > > > > > > >
> > > > > > > > > I strongly suggest that you also continue to do your own analysis on this.
> > > > > > > > > So please see below.
> > > > > > > >
> > > > > > > > This is just a brief of my analysis and the stack info below is not enough
> > > > > > > > for other people to figure out anything useful. I meant if they are really
> > > > > > > > interested, I can upload the core file. I think this is fair.
> > > > > > > >
> > > > > > > > >
> > > > > > > > > > > > When examining the readers of the lock, except the following code,
> > > > > > > > > > > > don't see any other obvious problems: e.g
> > > > > > > > > > > >  #5 [ffffad3987254df8] __sock_queue_rcv_skb at ffffffffa49cd2ee
> > > > > > > > > > > >  #6 [ffffad3987254e18] raw_rcv at ffffffffa4ac75c8
> > > > > > > > > > > >  #7 [ffffad3987254e38] raw_local_deliver at ffffffffa4ac7819
> > > > > > > > > > > >  #8 [ffffad3987254e88] ip_protocol_deliver_rcu at ffffffffa4a8dea4
> > > > > > > > > > > >  #9 [ffffad3987254ea8] ip_local_deliver_finish at ffffffffa4a8e074
> > > > > > > > > > > > #10 [ffffad3987254eb0] __netif_receive_skb_one_core at ffffffffa49f3057
> > > > > > > > > > > > #11 [ffffad3987254ed0] process_backlog at ffffffffa49f3278
> > > > > > > > > > > > #12 [ffffad3987254f08] __napi_poll at ffffffffa49f2aba
> > > > > > > > > > > > #13 [ffffad3987254f30] net_rx_action at ffffffffa49f2f33
> > > > > > > > > > > > #14 [ffffad3987254fa0] __softirqentry_text_start at ffffffffa50000d0
> > > > > > > > > > > > #15 [ffffad3987254ff0] do_softirq at ffffffffa40e12f6
> > > > > > > > > > > >
> > > > > > > > > > > > In the function ip_local_deliver_finish() of this stack, a lot of the work needs
> > > > > > > > > > > > to be done with ip_protocol_deliver_rcu(). But this function is invoked from
> > > > > > > > > > > > a rcu reader side section.
> > > > > > > > > > > >
> > > > > > > > > > > > static int ip_local_deliver_finish(struct net *net, struct sock *sk,
> > > > > > > > > > > > struct sk_buff *skb)
> > > > > > > > > > > > {
> > > > > > > > > > > >         __skb_pull(skb, skb_network_header_len(skb));
> > > > > > > > > > > >
> > > > > > > > > > > >         rcu_read_lock();
> > > > > > > > > > > >         ip_protocol_deliver_rcu(net, skb, ip_hdr(skb)->protocol);
> > > > > > > > > > > >         rcu_read_unlock();
> > > > > > > > > > > >
> > > > > > > > > > > >         return 0;
> > > > > > > > > > > > }
> > > > > > > > > > > >
> > > > > > > > > > > > Actually there are multiple chances that this code path can hit
> > > > > > > > > > > > spinning locks starting from ip_protocol_deliver_rcu(). This kind
> > > > > > > > > > > > usage looks not quite right. But I'd like to know your opinion on this first ?
> > > > > > > > > > >
> > > > > > > > > > > It is perfectly legal to acquire spinlocks in RCU read-side critical
> > > > > > > > > > > sections.  In fact, this is one of the few ways to safely acquire a
> > > > > > > > > > > per-object lock while still maintaining good performance and
> > > > > > > > > > > scalability.
> > > > > > > > > >
> > > > > > > > > > Sure, understand. But the RCU related docs said that anything causing
> > > > > > > > > > the reader side to block must be avoided.
> > > > > > > > >
> > > > > > > > > True.  But this is the Linux kernel, where "block" means something
> > > > > > > > > like "invoke schedule()" or "sleep" instead of the academic-style
> > > > > > > > > non-blocking-synchronization definition.  So it is perfectly legal to
> > > > > > > > > acquire spinlocks within RCU read-side critical sections.
> > > > > > > > >
> > > > > > > > > And before you complain that practitioners are not following the academic
> > > > > > > > > definitions, please keep in mind that our definitions were here first.  ;-)
> > > > > > > > >
> > > > > > > > > > > My guess is that the thing to track down is the cause of the high contention
> > > > > > > > > > > on that reader-writer spinlock.  Missed patches, misconfiguration, etc.
> > > > > > > > > >
> > > > > > > > > > Actually, the test was against a recent upstream 5.15.0-r1  But I can try
> > > > > > > > > > the latest r4.  Regarding the network configure, I believe I didn't do anything
> > > > > > > > > > special, just use the default.
> > > > > > > > >
> > > > > > > > > Does this occur on older mainline kernels?  If not, I strongly suggest
> > > > > > > > > bisecting, as this often quickly and easily finds the problem.
> > > > > > > >
> > > > > > > > Actually It does. But let's focus on the latest upstream and the latest rhel8.
> > > > > > > > This way, we will not worry about missing the needed rcu patches.
> > > > > > > > However, in rhel8, the kernel stack running on the rcu-stalled CPU is not
> > > > > > > > networking related, which I am still working on.  So, there might be
> > > > > > > > multiple root causes.
> > > > > > > >
> > > > > > > > > Bisection can also help you find the patch to be backported if a later
> > > > > > > > > release fixes the bug, though things like gitk can also be helpful.
> > > > > > > >
> > > > > > > > Unfortunately, this is reproducible on the latest bit.
> > > > > > > >
> > > > > > > > Thanks
> > > > > > > > Donghai
> > > > > > > > >
> > > > > > > > >                                                         Thanx, Paul
