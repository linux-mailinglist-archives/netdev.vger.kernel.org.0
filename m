Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4FB18D372
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgCTQBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgCTQBr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 12:01:47 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18CCE20739;
        Fri, 20 Mar 2020 16:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584720106;
        bh=IddRK8gwlo5hf9UdFSGcNsytcHNuEaq+Sg/jpSjttec=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=X2VnTlWRbJwFtX0vMXAGib6Of9JdC1AuCMzNpOnQ0gV2h4yIBBtMAyV2bPgISZnMt
         OztzDLryZo29cWeWsowvTybSj3N/f/Yo0zMlOmtmIf85skjL/SYoKSh7giSoQmPZdW
         h8N1menAs1TKbTN20e3yYE1AF8ib/7G+rNCQ0KkE=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id DC90A35226B4; Fri, 20 Mar 2020 09:01:45 -0700 (PDT)
Date:   Fri, 20 Mar 2020 09:01:45 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 08/15] Documentation: Add lock ordering and nesting
 documentation
Message-ID: <20200320160145.GN3199@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.211530902@linutronix.de>
 <20200318223137.GW3199@paulmck-ThinkPad-P72>
 <874kuk5il2.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kuk5il2.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 07:02:17PM +0100, Thomas Gleixner wrote:
> Paul,
> 
> "Paul E. McKenney" <paulmck@kernel.org> writes:
> 
> > On Wed, Mar 18, 2020 at 09:43:10PM +0100, Thomas Gleixner wrote:
> >
> > Mostly native-English-speaker services below, so please feel free to
> > ignore.  The one place I made a substantive change, I marked it "@@@".
> > I only did about half of this document, but should this prove useful,
> > I will do the other half later.
> 
> Native speaker services are always useful and appreciated.

Glad it is helpful.  ;-)

[ . . . ]

> >> +
> >> +raw_spinlock_t and spinlock_t
> >> +=============================
> >> +
> >> +raw_spinlock_t
> >> +--------------
> >> +
> >> +raw_spinlock_t is a strict spinning lock implementation regardless of the
> >> +kernel configuration including PREEMPT_RT enabled kernels.
> >> +
> >> +raw_spinlock_t is to be used only in real critical core code, low level
> >> +interrupt handling and places where protecting (hardware) state is required
> >> +to be safe against preemption and eventually interrupts.
> >> +
> >> +Another reason to use raw_spinlock_t is when the critical section is tiny
> >> +to avoid the overhead of spinlock_t on a PREEMPT_RT enabled kernel in the
> >> +contended case.
> >
> > raw_spinlock_t is a strict spinning lock implementation in all kernels,
> > including PREEMPT_RT kernels.  Use raw_spinlock_t only in real critical
> > core code, low level interrupt handling and places where disabling
> > preemption or interrupts is required, for example, to safely access
> > hardware state.  raw_spinlock_t can sometimes also be used when the
> > critical section is tiny and the lock is lightly contended, thus avoiding
> > RT-mutex overhead.
> >
> > @@@  I added the point about the lock being lightly contended.
> 
> Hmm, not sure. The point is that if the critical section is small the
> overhead of cross CPU boosting along with the resulting IPIs is going to
> be at least an order of magnitude larger. And on contention this is just
> pushing the raw_spinlock contention off to the raw_spinlock in the rt
> mutex plus the owning tasks pi_lock which makes things even worse.

Fair enough.  So, leaving that out:

raw_spinlock_t is a strict spinning lock implementation in all kernels,
including PREEMPT_RT kernels.  Use raw_spinlock_t only in real critical
core code, low level interrupt handling and places where disabling
preemption or interrupts is required, for example, to safely access
hardware state.  In addition, raw_spinlock_t can sometimes be used when
the critical section is tiny, thus avoiding RT-mutex overhead.

> >> + - The hard interrupt related suffixes for spin_lock / spin_unlock
> >> +   operations (_irq, _irqsave / _irqrestore) do not affect the CPUs
> 
> Si senor!

;-)

> >> +   interrupt disabled state
> >> +
> >> + - The soft interrupt related suffix (_bh()) is still disabling the
> >> +   execution of soft interrupts, but contrary to a non PREEMPT_RT enabled
> >> +   kernel, which utilizes the preemption count, this is achieved by a per
> >> +   CPU bottom half locking mechanism.
> >
> >  - The soft interrupt related suffix (_bh()) still disables softirq
> >    handlers.  However, unlike non-PREEMPT_RT kernels (which disable
> >    preemption to get this effect), PREEMPT_RT kernels use a per-CPU
> >    per-bottom-half locking mechanism.
> 
> it's not per-bottom-half anymore. That turned out to be dangerous due to
> dependencies between BH types, e.g. network and timers.

Ah!  OK, how about this?

 - The soft interrupt related suffix (_bh()) still disables softirq
   handlers.  However, unlike non-PREEMPT_RT kernels (which disable
   preemption to get this effect), PREEMPT_RT kernels use a per-CPU
   lock to exclude softirq handlers.

> I hope I was able to encourage you to comment on the other half as well :)

OK, here goes...

> +All other semantics of spinlock_t are preserved:
> +
> + - Migration of tasks which hold a spinlock_t is prevented. On a non
> +   PREEMPT_RT enabled kernel this is implicit due to preemption disable.
> +   PREEMPT_RT has a separate mechanism to achieve this. This ensures that
> +   pointers to per CPU variables stay valid even if the task is preempted.
> +
> + - Task state preservation. The task state is not affected when a lock is
> +   contended and the task has to schedule out and wait for the lock to
> +   become available. The lock wake up restores the task state unless there
> +   was a regular (not lock related) wake up on the task. This ensures that
> +   the task state rules are always correct independent of the kernel
> +   configuration.

How about this?

PREEMPT_RT kernels preserve all other spinlock_t semantics:

 - Tasks holding a spinlock_t do not migrate.  Non-PREEMPT_RT kernels
   avoid migration by disabling preemption.  PREEMPT_RT kernels instead
   disable migration, which ensures that pointers to per-CPU variables
   remain valid even if the task is preempted.

 - Task state is preserved across spinlock acquisition, ensuring that the
   task-state rules apply to all kernel configurations.  In non-PREEMPT_RT
   kernels leave task state untouched.  However, PREEMPT_RT must change
   task state if the task blocks during acquisition.  Therefore, the
   corresponding lock wakeup restores the task state.  Note that regular
   (not lock related) wakeups do not restore task state.

> +rwlock_t
> +========
> +
> +rwlock_t is a multiple readers and single writer lock mechanism.
> +
> +On a non PREEMPT_RT enabled kernel rwlock_t is implemented as a spinning
> +lock and the suffix rules of spinlock_t apply accordingly. The
> +implementation is fair and prevents writer starvation.

Non-PREEMPT_RT kernels implement rwlock_t as a spinning lock and the
suffix rules of spinlock_t apply accordingly. The implementation is fair,
thus preventing writer starvation.

> +rwlock_t and PREEMPT_RT
> +-----------------------
> +
> +On a PREEMPT_RT enabled kernel rwlock_t is mapped to a separate
> +implementation based on rt_mutex which changes the semantics:
> +
> + - Same changes as for spinlock_t
> +
> + - The implementation is not fair and can cause writer starvation under
> +   certain circumstances. The reason for this is that a writer cannot grant
> +   its priority to multiple readers. Readers which are blocked on a writer
> +   fully support the priority inheritance protocol.

PREEMPT_RT kernels map rwlock_t to a separate rt_mutex-based
implementation, thus changing semantics:

 - All the spinlock_t changes also apply to rwlock_t.

 - Because an rwlock_t writer cannot grant its priority to multiple
   readers, a preempted low-priority reader will continue holding its
   lock, thus starving even high-priority writers.  In contrast, because
   readers can grant their priority to a writer, a preempted low-priority
   writer will have its priority boosted until it releases the lock,
   thus preventing that writer from starving readers.

> +PREEMPT_RT caveats
> +==================
> +
> +spinlock_t and rwlock_t
> +-----------------------
> +
> +The substitution of spinlock_t and rwlock_t on PREEMPT_RT enabled kernels
> +with RT-mutex based implementations has a few implications.
> +
> +On a non PREEMPT_RT enabled kernel the following code construct is
> +perfectly fine::

These changes in spinlock_t and rwlock_t semantics on PREEMPT_RT kernels
have a few implications.  For example, on a non-PREEMPT_RT kernel the
following code sequence works as expected::

> +   local_irq_disable();
> +   spin_lock(&lock);
> +
> +and fully equivalent to::

and is fully equivalent to::

> +   spin_lock_irq(&lock);
> +
> +Same applies to rwlock_t and the _irqsave() suffix variant.

The same applies to rwlock_t and its _irqsave() variant.

> +On a PREEMPT_RT enabled kernel this breaks because the RT-mutex
> +substitution expects a fully preemptible context.
> +
> +The preferred solution is to use :c:func:`spin_lock_irq()` or
> +:c:func:`spin_lock_irqsave()` and their unlock counterparts.
> +
> +PREEMPT_RT also offers a local_lock mechanism to substitute the
> +local_irq_disable/save() constructs in cases where a separation of the
> +interrupt disabling and the locking is really unavoidable. This should be
> +restricted to very rare cases.

On PREEMPT_RT kernel this code sequence breaks because RT-mutex
requires a fully preemptible context.  Instead, use spin_lock_irq() or
spin_lock_irqsave() and their unlock counterparts.  In cases where the
interrupt disabling and locking must remain separate, PREEMPT_RT offers
a local_lock mechanism.  Acquiring the local_lock pins the task to a
CPU, allowing things like per-CPU irq-disabled locks to be acquired.
However, this approach should be used only where absolutely necessary.


> +raw_spinlock_t
> +--------------
> +
> +Locking of a raw_spinlock_t disables preemption and eventually interrupts.
> +Therefore code inside the critical region has to be careful to avoid calls
> +into code which takes a regular spinlock_t or rwlock_t. A prime example is
> +memory allocation.
> +
> +On a non PREEMPT_RT enabled kernel the following code construct is
> +perfectly fine code::

Acquiring a raw_spinlock_t disables preemption and possibly also
interrupts, so the critical section must avoid acquiring a regular
spinlock_t or rwlock_t, for example, the critical section must avoid
allocating memory.  Thus, on a non-PREEMPT_RT kernel the following code
works perfectly::

> +  raw_spin_lock(&lock);
> +  p = kmalloc(sizeof(*p), GFP_ATOMIC);
> +
> +On a PREEMPT_RT enabled kernel this breaks because the memory allocator is
> +fully preemptible and therefore does not support allocations from truly
> +atomic contexts.
> +
> +Contrary to that the following code construct is perfectly fine on
> +PREEMPT_RT as spin_lock() does not disable preemption::

But this code failes on PREEMPT_RT kernels because the memory allocator
is fully preemptible and therefore cannot be invoked from truly atomic
contexts.  However, it is perfectly fine to invoke the memory allocator
while holding a normal non-raw spinlocks because they do not disable
preemption::

> +  spin_lock(&lock);
> +  p = kmalloc(sizeof(*p), GFP_ATOMIC);
> +
> +Most places which use GFP_ATOMIC allocations are safe on PREEMPT_RT as the
> +execution is forced into thread context and the lock substitution is
> +ensuring preemptibility.

Interestingly enough, most uses of GFP_ATOMIC allocations are
actually safe on PREEMPT_RT because the the lock substitution ensures
preemptibility.  Only those GFP_ATOMIC allocations that are invoke
while holding a raw spinlock or with preemption otherwise disabled need
adjustment to work correctly on PREEMPT_RT.

[ I am not as confident of the above as I would like to be... ]

And meeting time, will continue later!

							Thanx, Paul

> +bit spinlocks
> +-------------
> +
> +Bit spinlocks are problematic for PREEMPT_RT as they cannot be easily
> +substituted by an RT-mutex based implementation for obvious reasons.
> +
> +The semantics of bit spinlocks are preserved on a PREEMPT_RT enabled kernel
> +and the caveats vs. raw_spinlock_t apply.
> +
> +Some bit spinlocks are substituted by regular spinlock_t for PREEMPT_RT but
> +this requires conditional (#ifdef'ed) code changes at the usage side while
> +the spinlock_t substitution is simply done by the compiler and the
> +conditionals are restricted to header files and core implementation of the
> +locking primitives and the usage sites do not require any changes.
> +
> +
> +Lock type nesting rules
> +=======================
> +
> +The most basic rules are:
> +
> +  - Lock types of the same lock category (sleeping, spinning) can nest
> +    arbitrarily as long as they respect the general lock ordering rules to
> +    prevent deadlocks.
> +
> +  - Sleeping lock types cannot nest inside spinning lock types.
> +
> +  - Spinning lock types can nest inside sleeping lock types.
> +
> +These rules apply in general independent of CONFIG_PREEMPT_RT.
> +
> +As PREEMPT_RT changes the lock category of spinlock_t and rwlock_t from
> +spinning to sleeping this has obviously restrictions how they can nest with
> +raw_spinlock_t.
> +
> +This results in the following nest ordering:
> +
> +  1) Sleeping locks
> +  2) spinlock_t and rwlock_t
> +  3) raw_spinlock_t and bit spinlocks
> +
> +Lockdep is aware of these constraints to ensure that they are respected.
> +
> +
> +Owner semantics
> +===============
> +
> +Most lock types in the Linux kernel have strict owner semantics, i.e. the
> +context (task) which acquires a lock has to release it.
> +
> +There are two exceptions:
> +
> +  - semaphores
> +  - rwsems
> +
> +semaphores have no strict owner semantics for historical reasons. They are
> +often used for both serialization and waiting purposes. That's generally
> +discouraged and should be replaced by separate serialization and wait
> +mechanisms.
> +
> +rwsems have grown interfaces which allow non owner release for special
> +purposes. This usage is problematic on PREEMPT_RT because PREEMPT_RT
> +substitutes all locking primitives except semaphores with RT-mutex based
> +implementations to provide priority inheritance for all lock types except
> +the truly spinning ones. Priority inheritance on ownerless locks is
> +obviously impossible.
> +
> +For now the rwsem non-owner release excludes code which utilizes it from
> +being used on PREEMPT_RT enabled kernels. In same cases this can be
> +mitigated by disabling portions of the code, in other cases the complete
> +functionality has to be disabled until a workable solution has been found.
> 
