Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E05E118A417
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgCRUrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:47:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58409 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbgCRUr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 16:47:28 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jEfaM-00066P-DH; Wed, 18 Mar 2020 21:46:42 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id D1C191040D0;
        Wed, 18 Mar 2020 21:46:36 +0100 (CET)
Message-Id: <20200318204408.211530902@linutronix.de>
User-Agent: quilt/0.65
Date:   Wed, 18 Mar 2020 21:43:10 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
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
Subject: [patch V2 08/15] Documentation: Add lock ordering and nesting documentation
References: <20200318204302.693307984@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The kernel provides a variety of locking primitives. The nesting of these
lock types and the implications of them on RT enabled kernels is nowhere
documented.

Add initial documentation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V2: Addressed review comments from Randy
---
 Documentation/locking/index.rst     |    1 
 Documentation/locking/locktypes.rst |  298 ++++++++++++++++++++++++++++++++++++
 2 files changed, 299 insertions(+)
 create mode 100644 Documentation/locking/locktypes.rst

--- a/Documentation/locking/index.rst
+++ b/Documentation/locking/index.rst
@@ -7,6 +7,7 @@ locking
 .. toctree::
     :maxdepth: 1
 
+    locktypes
     lockdep-design
     lockstat
     locktorture
--- /dev/null
+++ b/Documentation/locking/locktypes.rst
@@ -0,0 +1,298 @@
+.. _kernel_hacking_locktypes:
+
+==========================
+Lock types and their rules
+==========================
+
+Introduction
+============
+
+The kernel provides a variety of locking primitives which can be divided
+into two categories:
+
+ - Sleeping locks
+ - Spinning locks
+
+This document describes the lock types at least at the conceptual level and
+provides rules for nesting of lock types also under the aspect of PREEMPT_RT.
+
+Lock categories
+===============
+
+Sleeping locks
+--------------
+
+Sleeping locks can only be acquired in preemptible task context.
+
+Some of the implementations allow try_lock() attempts from other contexts,
+but that has to be really evaluated carefully including the question
+whether the unlock can be done from that context safely as well.
+
+Note that some lock types change their implementation details when
+debugging is enabled, so this should be really only considered if there is
+no other option.
+
+Sleeping lock types:
+
+ - mutex
+ - rt_mutex
+ - semaphore
+ - rw_semaphore
+ - ww_mutex
+ - percpu_rw_semaphore
+
+On a PREEMPT_RT enabled kernel the following lock types are converted to
+sleeping locks:
+
+ - spinlock_t
+ - rwlock_t
+
+Spinning locks
+--------------
+
+ - raw_spinlock_t
+ - bit spinlocks
+
+On a non PREEMPT_RT enabled kernel the following lock types are spinning
+locks as well:
+
+ - spinlock_t
+ - rwlock_t
+
+Spinning locks implicitly disable preemption and the lock / unlock functions
+can have suffixes which apply further protections:
+
+ ===================  ====================================================
+ _bh()                Disable / enable bottom halves (soft interrupts)
+ _irq()               Disable / enable interrupts
+ _irqsave/restore()   Save and disable / restore interrupt disabled state
+ ===================  ====================================================
+
+
+rtmutex
+=======
+
+RT-mutexes are mutexes with support for priority inheritance (PI).
+
+PI has limitations on non PREEMPT_RT enabled kernels due to preemption and
+interrupt disabled sections.
+
+On a PREEMPT_RT enabled kernel most of these sections are fully
+preemptible. This is possible because PREEMPT_RT forces most executions
+into task context, especially interrupt handlers and soft interrupts, which
+allows to substitute spinlock_t and rwlock_t with RT-mutex based
+implementations.
+
+
+raw_spinlock_t and spinlock_t
+=============================
+
+raw_spinlock_t
+--------------
+
+raw_spinlock_t is a strict spinning lock implementation regardless of the
+kernel configuration including PREEMPT_RT enabled kernels.
+
+raw_spinlock_t is to be used only in real critical core code, low level
+interrupt handling and places where protecting (hardware) state is required
+to be safe against preemption and eventually interrupts.
+
+Another reason to use raw_spinlock_t is when the critical section is tiny
+to avoid the overhead of spinlock_t on a PREEMPT_RT enabled kernel in the
+contended case.
+
+spinlock_t
+----------
+
+The semantics of spinlock_t change with the state of CONFIG_PREEMPT_RT.
+
+On a non PREEMPT_RT enabled kernel spinlock_t is mapped to raw_spinlock_t
+and has exactly the same semantics.
+
+spinlock_t and PREEMPT_RT
+-------------------------
+
+On a PREEMPT_RT enabled kernel spinlock_t is mapped to a separate
+implementation based on rt_mutex which changes the semantics:
+
+ - Preemption is not disabled
+
+ - The hard interrupt related suffixes for spin_lock / spin_unlock
+   operations (_irq, _irqsave / _irqrestore) do not affect the CPUs
+   interrupt disabled state
+
+ - The soft interrupt related suffix (_bh()) is still disabling the
+   execution of soft interrupts, but contrary to a non PREEMPT_RT enabled
+   kernel, which utilizes the preemption count, this is achieved by a per
+   CPU bottom half locking mechanism.
+
+All other semantics of spinlock_t are preserved:
+
+ - Migration of tasks which hold a spinlock_t is prevented. On a non
+   PREEMPT_RT enabled kernel this is implicit due to preemption disable.
+   PREEMPT_RT has a separate mechanism to achieve this. This ensures that
+   pointers to per CPU variables stay valid even if the task is preempted.
+
+ - Task state preservation. The task state is not affected when a lock is
+   contended and the task has to schedule out and wait for the lock to
+   become available. The lock wake up restores the task state unless there
+   was a regular (not lock related) wake up on the task. This ensures that
+   the task state rules are always correct independent of the kernel
+   configuration.
+
+rwlock_t
+========
+
+rwlock_t is a multiple readers and single writer lock mechanism.
+
+On a non PREEMPT_RT enabled kernel rwlock_t is implemented as a spinning
+lock and the suffix rules of spinlock_t apply accordingly. The
+implementation is fair and prevents writer starvation.
+
+rwlock_t and PREEMPT_RT
+-----------------------
+
+On a PREEMPT_RT enabled kernel rwlock_t is mapped to a separate
+implementation based on rt_mutex which changes the semantics:
+
+ - Same changes as for spinlock_t
+
+ - The implementation is not fair and can cause writer starvation under
+   certain circumstances. The reason for this is that a writer cannot grant
+   its priority to multiple readers. Readers which are blocked on a writer
+   fully support the priority inheritance protocol.
+
+
+PREEMPT_RT caveats
+==================
+
+spinlock_t and rwlock_t
+-----------------------
+
+The substitution of spinlock_t and rwlock_t on PREEMPT_RT enabled kernels
+with RT-mutex based implementations has a few implications.
+
+On a non PREEMPT_RT enabled kernel the following code construct is
+perfectly fine::
+
+   local_irq_disable();
+   spin_lock(&lock);
+
+and fully equivalent to::
+
+   spin_lock_irq(&lock);
+
+Same applies to rwlock_t and the _irqsave() suffix variant.
+
+On a PREEMPT_RT enabled kernel this breaks because the RT-mutex
+substitution expects a fully preemptible context.
+
+The preferred solution is to use :c:func:`spin_lock_irq()` or
+:c:func:`spin_lock_irqsave()` and their unlock counterparts.
+
+PREEMPT_RT also offers a local_lock mechanism to substitute the
+local_irq_disable/save() constructs in cases where a separation of the
+interrupt disabling and the locking is really unavoidable. This should be
+restricted to very rare cases.
+
+
+raw_spinlock_t
+--------------
+
+Locking of a raw_spinlock_t disables preemption and eventually interrupts.
+Therefore code inside the critical region has to be careful to avoid calls
+into code which takes a regular spinlock_t or rwlock_t. A prime example is
+memory allocation.
+
+On a non PREEMPT_RT enabled kernel the following code construct is
+perfectly fine code::
+
+  raw_spin_lock(&lock);
+  p = kmalloc(sizeof(*p), GFP_ATOMIC);
+
+On a PREEMPT_RT enabled kernel this breaks because the memory allocator is
+fully preemptible and therefore does not support allocations from truly
+atomic contexts.
+
+Contrary to that the following code construct is perfectly fine on
+PREEMPT_RT as spin_lock() does not disable preemption::
+
+  spin_lock(&lock);
+  p = kmalloc(sizeof(*p), GFP_ATOMIC);
+
+Most places which use GFP_ATOMIC allocations are safe on PREEMPT_RT as the
+execution is forced into thread context and the lock substitution is
+ensuring preemptibility.
+
+
+bit spinlocks
+-------------
+
+Bit spinlocks are problematic for PREEMPT_RT as they cannot be easily
+substituted by an RT-mutex based implementation for obvious reasons.
+
+The semantics of bit spinlocks are preserved on a PREEMPT_RT enabled kernel
+and the caveats vs. raw_spinlock_t apply.
+
+Some bit spinlocks are substituted by regular spinlock_t for PREEMPT_RT but
+this requires conditional (#ifdef'ed) code changes at the usage side while
+the spinlock_t substitution is simply done by the compiler and the
+conditionals are restricted to header files and core implementation of the
+locking primitives and the usage sites do not require any changes.
+
+
+Lock type nesting rules
+=======================
+
+The most basic rules are:
+
+  - Lock types of the same lock category (sleeping, spinning) can nest
+    arbitrarily as long as they respect the general lock ordering rules to
+    prevent deadlocks.
+
+  - Sleeping lock types cannot nest inside spinning lock types.
+
+  - Spinning lock types can nest inside sleeping lock types.
+
+These rules apply in general independent of CONFIG_PREEMPT_RT.
+
+As PREEMPT_RT changes the lock category of spinlock_t and rwlock_t from
+spinning to sleeping this has obviously restrictions how they can nest with
+raw_spinlock_t.
+
+This results in the following nest ordering:
+
+  1) Sleeping locks
+  2) spinlock_t and rwlock_t
+  3) raw_spinlock_t and bit spinlocks
+
+Lockdep is aware of these constraints to ensure that they are respected.
+
+
+Owner semantics
+===============
+
+Most lock types in the Linux kernel have strict owner semantics, i.e. the
+context (task) which acquires a lock has to release it.
+
+There are two exceptions:
+
+  - semaphores
+  - rwsems
+
+semaphores have no strict owner semantics for historical reasons. They are
+often used for both serialization and waiting purposes. That's generally
+discouraged and should be replaced by separate serialization and wait
+mechanisms.
+
+rwsems have grown interfaces which allow non owner release for special
+purposes. This usage is problematic on PREEMPT_RT because PREEMPT_RT
+substitutes all locking primitives except semaphores with RT-mutex based
+implementations to provide priority inheritance for all lock types except
+the truly spinning ones. Priority inheritance on ownerless locks is
+obviously impossible.
+
+For now the rwsem non-owner release excludes code which utilizes it from
+being used on PREEMPT_RT enabled kernels. In same cases this can be
+mitigated by disabling portions of the code, in other cases the complete
+functionality has to be disabled until a workable solution has been found.

