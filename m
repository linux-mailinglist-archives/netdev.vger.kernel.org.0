Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1655334AA7
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 16:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfFDOoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 10:44:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49324 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727562AbfFDOoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 10:44:19 -0400
Received: (qmail 3471 invoked by uid 2102); 4 Jun 2019 10:44:18 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 4 Jun 2019 10:44:18 -0400
Date:   Tue, 4 Jun 2019 10:44:18 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
cc:     Boqun Feng <boqun.feng@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Subject: Re: rcu_read_lock lost its compiler barrier
In-Reply-To: <20190603200301.GM28207@linux.ibm.com>
Message-ID: <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019, Paul E. McKenney wrote:

> On Mon, Jun 03, 2019 at 02:42:00PM +0800, Boqun Feng wrote:
> > On Mon, Jun 03, 2019 at 01:26:26PM +0800, Herbert Xu wrote:
> > > On Sun, Jun 02, 2019 at 08:47:07PM -0700, Paul E. McKenney wrote:
> > > > 
> > > > 1.	These guarantees are of full memory barriers, -not- compiler
> > > > 	barriers.
> > > 
> > > What I'm saying is that wherever they are, they must come with
> > > compiler barriers.  I'm not aware of any synchronisation mechanism
> > > in the kernel that gives a memory barrier without a compiler barrier.
> > > 
> > > > 2.	These rules don't say exactly where these full memory barriers
> > > > 	go.  SRCU is at one extreme, placing those full barriers in
> > > > 	srcu_read_lock() and srcu_read_unlock(), and !PREEMPT Tree RCU
> > > > 	at the other, placing these barriers entirely within the callback
> > > > 	queueing/invocation, grace-period computation, and the scheduler.
> > > > 	Preemptible Tree RCU is in the middle, with rcu_read_unlock()
> > > > 	sometimes including a full memory barrier, but other times with
> > > > 	the full memory barrier being confined as it is with !PREEMPT
> > > > 	Tree RCU.
> > > 
> > > The rules do say that the (full) memory barrier must precede any
> > > RCU read-side that occur after the synchronize_rcu and after the
> > > end of any RCU read-side that occur before the synchronize_rcu.
> > > 
> > > All I'm arguing is that wherever that full mb is, as long as it
> > > also carries with it a barrier() (which it must do if it's done
> > > using an existing kernel mb/locking primitive), then we're fine.
> > > 
> > > > Interleaving and inserting full memory barriers as per the rules above:
> > > > 
> > > > 	CPU1: WRITE_ONCE(a, 1)
> > > > 	CPU1: synchronize_rcu	
> > > > 	/* Could put a full memory barrier here, but it wouldn't help. */
> > > 
> > > 	CPU1: smp_mb();
> > > 	CPU2: smp_mb();
> > > 
> > > Let's put them in because I think they are critical.  smp_mb() also
> > > carries with it a barrier().
> > > 
> > > > 	CPU2: rcu_read_lock();
> > > > 	CPU1: b = 2;	
> > > > 	CPU2: if (READ_ONCE(a) == 0)
> > > > 	CPU2:         if (b != 1)  /* Weakly ordered CPU moved this up! */
> > > > 	CPU2:                 b = 1;
> > > > 	CPU2: rcu_read_unlock
> > > > 
> > > > In fact, CPU2's load from b might be moved up to race with CPU1's store,
> > > > which (I believe) is why the model complains in this case.
> > > 
> > > Let's put aside my doubt over how we're even allowing a compiler
> > > to turn
> > > 
> > > 	b = 1
> > > 
> > > into
> > > 
> > > 	if (b != 1)
> > > 		b = 1

Even if you don't think the compiler will ever do this, the C standard
gives compilers the right to invent read accesses if a plain (i.e.,
non-atomic and non-volatile) write is present.  The Linux Kernel Memory
Model has to assume that compilers will sometimes do this, even if it
doesn't take the exact form of checking a variable's value before
writing to it.

(Incidentally, regardless of whether the compiler will ever do this, I 
have seen examples in the kernel where people did exactly this 
manually, in order to avoid dirtying a cache line unnecessarily.)

> > > Since you seem to be assuming that (a == 0) is true in this case
> > 
> > I think Paul's example assuming (a == 0) is false, and maybe
> 
> Yes, otherwise, P0()'s write to "b" cannot have happened.
> 
> > speculative writes (by compilers) needs to added into consideration?

On the other hand, the C standard does not allow compilers to add
speculative writes.  The LKMM assumes they will never occur.

> I would instead call it the compiler eliminating needless writes
> by inventing reads -- if the variable already has the correct value,
> no write happens.  So no compiler speculation.
> 
> However, it is difficult to create a solid defensible example.  Yes,
> from LKMM's viewpoint, the weakly reordered invented read from "b"
> can be concurrent with P0()'s write to "b", but in that case the value
> loaded would have to manage to be equal to 1 for anything bad to happen.
> This does feel wrong to me, but again, it is difficult to create a solid
> defensible example.
> 
> > Please consider the following case (I add a few smp_mb()s), the case may
> > be a little bit crasy, you have been warned ;-)
> > 
> >  	CPU1: WRITE_ONCE(a, 1)
> >  	CPU1: synchronize_rcu called
> > 
> >  	CPU1: smp_mb(); /* let assume there is one here */
> > 
> >  	CPU2: rcu_read_lock();
> >  	CPU2: smp_mb(); /* let assume there is one here */
> > 
> > 	/* "if (b != 1) b = 1" reordered  */
> >  	CPU2: r0 = b;       /* if (b != 1) reordered here, r0 == 0 */
> >  	CPU2: if (r0 != 1)  /* true */
> > 	CPU2:     b = 1;    /* b == 1 now, this is a speculative write
> > 	                       by compiler
> > 			     */
> > 
> > 	CPU1: b = 2;        /* b == 2 */
> > 
> >  	CPU2: if (READ_ONCE(a) == 0) /* false */
> > 	CPU2: ...
> > 	CPU2  else                   /* undo the speculative write */
> > 	CPU2:	  b = r0;   /* b == 0 */
> > 
> >  	CPU2: smp_mb();
> > 	CPU2: read_read_unlock();
> > 
> > I know this is too crasy for us to think a compiler like this, but this
> > might be the reason why the model complain about this.
> > 
> > Paul, did I get this right? Or you mean something else?
> 
> Mostly there, except that I am not yet desperate enough to appeal to
> compilers speculating stores.  ;-)

This example really does point out a weakness in the LKMM's handling of 
data races.  Herbert's litmus test is a great starting point:


C xu

{}

P0(int *a, int *b)
{
	WRITE_ONCE(*a, 1);
	synchronize_rcu();
	*b = 2;
}

P1(int *a, int *b)
{
	rcu_read_lock();
	if (READ_ONCE(*a) == 0)
		*b = 1;
	rcu_read_unlock();
}

exists (~b=2)


Currently the LKMM says the test is allowed and there is a data race, 
but this answer clearly is wrong since it would violate the RCU 
guarantee.

The problem is that the LKMM currently requires all ordering/visibility
of plain accesses to be mediated by marked accesses.  But in this case,
the visibility is mediated by RCU.  Technically, we need to add a
relation like

	([M] ; po ; rcu-fence ; po ; [M])

into the definitions of ww-vis, wr-vis, and rw-xbstar.  Doing so
changes the litmus test's result to "not allowed" and no data race.  
However, I'm not certain that this single change is the entire fix;  
more thought is needed.

Alan

