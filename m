Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A30191D4E
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 00:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgCXXO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 19:14:27 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46547 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgCXXO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 19:14:27 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGsjn-0007lV-Qr; Wed, 25 Mar 2020 00:13:36 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id DC4A4100C51; Wed, 25 Mar 2020 00:13:34 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     paulmck@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        platform-driver-x86@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Guo Ren <guoren@kernel.org>, linux-csky@vger.kernel.org,
        Brian Cain <bcain@codeaurora.org>,
        linux-hexagon@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Geoff Levand <geoff@infradead.org>,
        linuxppc-dev@lists.ozlabs.org, Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [patch V3 13/20] Documentation: Add lock ordering and nesting documentation
In-Reply-To: <20200323025501.GE3199@paulmck-ThinkPad-P72>
Date:   Wed, 25 Mar 2020 00:13:34 +0100
Message-ID: <87r1xhz6qp.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul,

"Paul E. McKenney" <paulmck@kernel.org> writes:
> On Sat, Mar 21, 2020 at 12:25:57PM +0100, Thomas Gleixner wrote:
> In the normal case where the task sleeps through the entire lock
> acquisition, the sequence of events is as follows:
>
>      state = UNINTERRUPTIBLE
>      lock()
>        block()
>          real_state = state
>          state = SLEEPONLOCK
>
>                                lock wakeup
>                                  state = real_state == UNINTERRUPTIBLE
>
> This sequence of events can occur when the task acquires spinlocks
> on its way to sleeping, for example, in a call to wait_event().
>
> The non-lock wakeup can occur when a wakeup races with this wait_event(),
> which can result in the following sequence of events:
>
>      state = UNINTERRUPTIBLE
>      lock()
>        block()
>          real_state = state
>          state = SLEEPONLOCK
>
>                              non lock wakeup
>                                  real_state = RUNNING
>
>                                lock wakeup
>                                  state = real_state == RUNNING
>
> Without this real_state subterfuge, the wakeup might be lost.

I added this with a few modifications which reflect the actual
implementation. Conceptually the same.

> rwsems have grown special-purpose interfaces that allow non-owner release.
> This non-owner release prevents PREEMPT_RT from substituting RT-mutex
> implementations, for example, by defeating priority inheritance.
> After all, if the lock has no owner, whose priority should be boosted?
> As a result, PREEMPT_RT does not currently support rwsem, which in turn
> means that code using it must therefore be disabled until a workable
> solution presents itself.
>
> [ Note: Not as confident as I would like to be in the above. ]

I'm not confident either especially not after looking at the actual
code.

In fact I feel really stupid because the rw_semaphore reader non-owner
restriction on RT simply does not exist anymore and my history biased
memory tricked me.

The first rw_semaphore implementation of RT was simple and restricted
the reader side to a single reader to support PI on both the reader and
the writer side. That obviosuly did not scale well and made mmap_sem
heavy use cases pretty unhappy.

The short interlude with multi-reader boosting turned out to be a failed
experiment - Steven might still disagree though :)

At some point we gave up and I myself (sic!) reimplemented the RT
variant of rw_semaphore with a reader biased mechanism.

The reader never holds the underlying rt_mutex accross the read side
critical section. It merily increments the reader count and drops it on
release.

The only time a reader takes the rt_mutex is when it blocks on a
writer. Writers hold the rt_mutex across the write side critical section
to allow incoming readers to boost them. Once the writer releases the
rw_semaphore it unlocks the rt_mutex which is then handed off to the
readers. They increment the reader count and then drop the rt_mutex
before continuing in the read side critical section.

So while I changed the implementation it did obviously not occur to me
that this also lifted the non-owner release restriction. Nobody else
noticed either. So we kept dragging this along in both memory and
implementation. Both will be fixed now :)

The owner semantics of down/up_read() are only enforced by lockdep. That
applies to both RT and !RT. The up/down_read_non_owner() variants are
just there to tell lockdep about it.

So, I picked up your other suggestions with slight modifications and
adjusted the owner, semaphore and rw_semaphore docs accordingly.

Please have a close look at the patch below (applies on tip core/locking).

Thanks,

        tglx, who is searching a brown paperbag

8<----------

 Documentation/locking/locktypes.rst |  148 +++++++++++++++++++++++-------------
 1 file changed, 98 insertions(+), 50 deletions(-)

--- a/Documentation/locking/locktypes.rst
+++ b/Documentation/locking/locktypes.rst
@@ -67,6 +67,17 @@ Spinning locks implicitly disable preemp
  _irqsave/restore()   Save and disable / restore interrupt disabled state
  ===================  ====================================================
 
+Owner semantics
+===============
+
+The aforementioned lock types except semaphores have strict owner
+semantics:
+
+  The context (task) that acquired the lock must release it.
+
+rw_semaphores have a special interface which allows non-owner release for
+readers.
+
 
 rtmutex
 =======
@@ -83,6 +94,51 @@ interrupt handlers and soft interrupts.
 and rwlock_t to be implemented via RT-mutexes.
 
 
+sempahore
+=========
+
+semaphore is a counting semaphore implementation.
+
+Semaphores are often used for both serialization and waiting, but new use
+cases should instead use separate serialization and wait mechanisms, such
+as mutexes and completions.
+
+sempahores and PREEMPT_RT
+----------------------------
+
+PREEMPT_RT does not change the sempahore implementation. That's impossible
+due to the counting semaphore semantics which have no concept of owners.
+The lack of an owner conflicts with priority inheritance. After all an
+unknown owner cannot be boosted. As a consequence blocking on semaphores
+can be subject to priority inversion.
+
+
+rw_sempahore
+============
+
+rw_semaphore is a multiple readers and single writer lock mechanism.
+
+On non-PREEMPT_RT kernels the implementation is fair, thus preventing
+writer starvation.
+
+rw_semaphore complies by default with the strict owner semantics, but there
+exist special-purpose interfaces that allow non-owner release for readers.
+These work independent of the kernel configuration.
+
+rw_sempahore and PREEMPT_RT
+---------------------------
+
+PREEMPT_RT kernels map rw_sempahore to a separate rt_mutex-based
+implementation, thus changing the fairness:
+
+ Because an rw_sempaphore writer cannot grant its priority to multiple
+ readers, a preempted low-priority reader will continue holding its lock,
+ thus starving even high-priority writers.  In contrast, because readers
+ can grant their priority to a writer, a preempted low-priority writer will
+ have its priority boosted until it releases the lock, thus preventing that
+ writer from starving readers.
+
+
 raw_spinlock_t and spinlock_t
 =============================
 
@@ -140,7 +196,16 @@ On a PREEMPT_RT enabled kernel spinlock_
    kernels leave task state untouched.  However, PREEMPT_RT must change
    task state if the task blocks during acquisition.  Therefore, it saves
    the current task state before blocking and the corresponding lock wakeup
-   restores it.
+   restores it::
+
+    task->state = TASK_INTERRUPTIBLE
+     lock()
+       block()
+         task->saved_state = task->state
+	 task->state = TASK_UNINTERRUPTIBLE
+	 schedule()
+					lock wakeup
+					  task->state = task->saved_state
 
    Other types of wakeups would normally unconditionally set the task state
    to RUNNING, but that does not work here because the task must remain
@@ -148,7 +213,22 @@ On a PREEMPT_RT enabled kernel spinlock_
    wakeup attempts to awaken a task blocked waiting for a spinlock, it
    instead sets the saved state to RUNNING.  Then, when the lock
    acquisition completes, the lock wakeup sets the task state to the saved
-   state, in this case setting it to RUNNING.
+   state, in this case setting it to RUNNING::
+
+    task->state = TASK_INTERRUPTIBLE
+     lock()
+       block()
+         task->saved_state = task->state
+	 task->state = TASK_UNINTERRUPTIBLE
+	 schedule()
+					non lock wakeup
+					  task->saved_state = TASK_RUNNING
+
+					lock wakeup
+					  task->state = task->saved_state
+
+   This ensures that the real wakeup cannot be lost.
+
 
 rwlock_t
 ========
@@ -228,17 +308,16 @@ while holding normal non-raw spinlocks b
 bit spinlocks
 -------------
 
-Bit spinlocks are problematic for PREEMPT_RT as they cannot be easily
-substituted by an RT-mutex based implementation for obvious reasons.
-
-The semantics of bit spinlocks are preserved on PREEMPT_RT kernels and the
-caveats vs. raw_spinlock_t apply.
-
-Some bit spinlocks are substituted by regular spinlock_t for PREEMPT_RT but
-this requires conditional (#ifdef'ed) code changes at the usage site while
-the spinlock_t substitution is simply done by the compiler and the
-conditionals are restricted to header files and core implementation of the
-locking primitives and the usage sites do not require any changes.
+PREEMPT_RT cannot substitute bit spinlocks because a single bit is too
+small to accommodate an RT-mutex.  Therefore, the semantics of bit
+spinlocks are preserved on PREEMPT_RT kernels, so that the raw_spinlock_t
+caveats also apply to bit spinlocks.
+
+Some bit spinlocks are replaced with regular spinlock_t for PREEMPT_RT
+using conditional (#ifdef'ed) code changes at the usage site.  In contrast,
+usage-site changes are not needed for the spinlock_t substitution.
+Instead, conditionals in header files and the core locking implemementation
+enable the compiler to do the substitution transparently.
 
 
 Lock type nesting rules
@@ -254,46 +333,15 @@ Lock type nesting rules
 
   - Spinning lock types can nest inside sleeping lock types.
 
-These rules apply in general independent of CONFIG_PREEMPT_RT.
+These constraints apply both in CONFIG_PREEMPT_RT and otherwise.
 
-As PREEMPT_RT changes the lock category of spinlock_t and rwlock_t from
-spinning to sleeping this has obviously restrictions how they can nest with
-raw_spinlock_t.
-
-This results in the following nest ordering:
+The fact that PREEMPT_RT changes the lock category of spinlock_t and
+rwlock_t from spinning to sleeping means that they cannot be acquired while
+holding a raw spinlock.  This results in the following nesting ordering:
 
   1) Sleeping locks
   2) spinlock_t and rwlock_t
   3) raw_spinlock_t and bit spinlocks
 
-Lockdep is aware of these constraints to ensure that they are respected.
-
-
-Owner semantics
-===============
-
-Most lock types in the Linux kernel have strict owner semantics, i.e. the
-context (task) which acquires a lock has to release it.
-
-There are two exceptions:
-
-  - semaphores
-  - rwsems
-
-semaphores have no owner semantics for historical reason, and as such
-trylock and release operations can be called from any context. They are
-often used for both serialization and waiting purposes. That's generally
-discouraged and should be replaced by separate serialization and wait
-mechanisms, such as mutexes and completions.
-
-rwsems have grown interfaces which allow non owner release for special
-purposes. This usage is problematic on PREEMPT_RT because PREEMPT_RT
-substitutes all locking primitives except semaphores with RT-mutex based
-implementations to provide priority inheritance for all lock types except
-the truly spinning ones. Priority inheritance on ownerless locks is
-obviously impossible.
-
-For now the rwsem non-owner release excludes code which utilizes it from
-being used on PREEMPT_RT enabled kernels. In same cases this can be
-mitigated by disabling portions of the code, in other cases the complete
-functionality has to be disabled until a workable solution has been found.
+Lockdep will complain if these constraints are violated, both in
+CONFIG_PREEMPT_RT and otherwise.

