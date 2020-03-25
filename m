Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 762E4191E0D
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 01:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgCYA2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 20:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbgCYA2N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 20:28:13 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 954EA206F8;
        Wed, 25 Mar 2020 00:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585096091;
        bh=EIB4psQiicWyBHK1xib2qJY5nR2j8FLOWc8y1NLiBAI=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=FovNZdkSctBXV5lafbQcX+Ej9wZG7UsrCCuMHXx2oA0wS9t18Dd3dwPhTTYckcJJQ
         m2GRrN5OxbovkLoZNpu4ZLngU+C7TcI02VmUDKg5NNMnsw/kIqzECLpp9fpIvm/YB+
         y+RLg1x1ncKHeKB1RupgozuHVzSmbq1COMmILmbY=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 62D773522AC8; Tue, 24 Mar 2020 17:28:11 -0700 (PDT)
Date:   Tue, 24 Mar 2020 17:28:11 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
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
Subject: Re: [patch V3 13/20] Documentation: Add lock ordering and nesting
 documentation
Message-ID: <20200325002811.GO19865@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200323025501.GE3199@paulmck-ThinkPad-P72>
 <87r1xhz6qp.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1xhz6qp.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 12:13:34AM +0100, Thomas Gleixner wrote:
> Paul,
> 
> "Paul E. McKenney" <paulmck@kernel.org> writes:
> > On Sat, Mar 21, 2020 at 12:25:57PM +0100, Thomas Gleixner wrote:
> > In the normal case where the task sleeps through the entire lock
> > acquisition, the sequence of events is as follows:
> >
> >      state = UNINTERRUPTIBLE
> >      lock()
> >        block()
> >          real_state = state
> >          state = SLEEPONLOCK
> >
> >                                lock wakeup
> >                                  state = real_state == UNINTERRUPTIBLE
> >
> > This sequence of events can occur when the task acquires spinlocks
> > on its way to sleeping, for example, in a call to wait_event().
> >
> > The non-lock wakeup can occur when a wakeup races with this wait_event(),
> > which can result in the following sequence of events:
> >
> >      state = UNINTERRUPTIBLE
> >      lock()
> >        block()
> >          real_state = state
> >          state = SLEEPONLOCK
> >
> >                              non lock wakeup
> >                                  real_state = RUNNING
> >
> >                                lock wakeup
> >                                  state = real_state == RUNNING
> >
> > Without this real_state subterfuge, the wakeup might be lost.
> 
> I added this with a few modifications which reflect the actual
> implementation. Conceptually the same.

Looks good!

> > rwsems have grown special-purpose interfaces that allow non-owner release.
> > This non-owner release prevents PREEMPT_RT from substituting RT-mutex
> > implementations, for example, by defeating priority inheritance.
> > After all, if the lock has no owner, whose priority should be boosted?
> > As a result, PREEMPT_RT does not currently support rwsem, which in turn
> > means that code using it must therefore be disabled until a workable
> > solution presents itself.
> >
> > [ Note: Not as confident as I would like to be in the above. ]
> 
> I'm not confident either especially not after looking at the actual
> code.
> 
> In fact I feel really stupid because the rw_semaphore reader non-owner
> restriction on RT simply does not exist anymore and my history biased
> memory tricked me.

I guess I am glad that it is not just me.  ;-)

> The first rw_semaphore implementation of RT was simple and restricted
> the reader side to a single reader to support PI on both the reader and
> the writer side. That obviosuly did not scale well and made mmap_sem
> heavy use cases pretty unhappy.
> 
> The short interlude with multi-reader boosting turned out to be a failed
> experiment - Steven might still disagree though :)
> 
> At some point we gave up and I myself (sic!) reimplemented the RT
> variant of rw_semaphore with a reader biased mechanism.
> 
> The reader never holds the underlying rt_mutex accross the read side
> critical section. It merily increments the reader count and drops it on
> release.
> 
> The only time a reader takes the rt_mutex is when it blocks on a
> writer. Writers hold the rt_mutex across the write side critical section
> to allow incoming readers to boost them. Once the writer releases the
> rw_semaphore it unlocks the rt_mutex which is then handed off to the
> readers. They increment the reader count and then drop the rt_mutex
> before continuing in the read side critical section.
> 
> So while I changed the implementation it did obviously not occur to me
> that this also lifted the non-owner release restriction. Nobody else
> noticed either. So we kept dragging this along in both memory and
> implementation. Both will be fixed now :)
> 
> The owner semantics of down/up_read() are only enforced by lockdep. That
> applies to both RT and !RT. The up/down_read_non_owner() variants are
> just there to tell lockdep about it.
> 
> So, I picked up your other suggestions with slight modifications and
> adjusted the owner, semaphore and rw_semaphore docs accordingly.
> 
> Please have a close look at the patch below (applies on tip core/locking).
> 
> Thanks,
> 
>         tglx, who is searching a brown paperbag

Sorry, used all the ones here over the past few days.  :-/

Please see below for a wordsmithing patch to be applied on top of
or merged into the patch in your email.

							Thanx, Paul

------------------------------------------------------------------------

commit e38c64ce8db45e2b0a19082f1e1f988c3b25fb81
Author: Paul E. McKenney <paulmck@kernel.org>
Date:   Tue Mar 24 17:23:36 2020 -0700

    Documentation: Wordsmith lock ordering and nesting documentation
    
    This commit is strictly wordsmithing with no (intended) semantic
    changes.
    
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/Documentation/locking/locktypes.rst b/Documentation/locking/locktypes.rst
index ca7bf84..8eb52e9 100644
--- a/Documentation/locking/locktypes.rst
+++ b/Documentation/locking/locktypes.rst
@@ -94,7 +94,7 @@ interrupt handlers and soft interrupts.  This conversion allows spinlock_t
 and rwlock_t to be implemented via RT-mutexes.
 
 
-sempahore
+semaphore
 =========
 
 semaphore is a counting semaphore implementation.
@@ -103,17 +103,17 @@ Semaphores are often used for both serialization and waiting, but new use
 cases should instead use separate serialization and wait mechanisms, such
 as mutexes and completions.
 
-sempahores and PREEMPT_RT
+semaphores and PREEMPT_RT
 ----------------------------
 
-PREEMPT_RT does not change the sempahore implementation. That's impossible
-due to the counting semaphore semantics which have no concept of owners.
-The lack of an owner conflicts with priority inheritance. After all an
-unknown owner cannot be boosted. As a consequence blocking on semaphores
-can be subject to priority inversion.
+PREEMPT_RT does not change the semaphore implementation because counting
+semaphores have no concept of owners, thus preventing PREEMPT_RT from
+providing priority inheritance for semaphores.  After all, an unknown
+owner cannot be boosted. As a consequence, blocking on semaphores can
+result in priority inversion.
 
 
-rw_sempahore
+rw_semaphore
 ============
 
 rw_semaphore is a multiple readers and single writer lock mechanism.
@@ -125,13 +125,13 @@ rw_semaphore complies by default with the strict owner semantics, but there
 exist special-purpose interfaces that allow non-owner release for readers.
 These work independent of the kernel configuration.
 
-rw_sempahore and PREEMPT_RT
+rw_semaphore and PREEMPT_RT
 ---------------------------
 
-PREEMPT_RT kernels map rw_sempahore to a separate rt_mutex-based
+PREEMPT_RT kernels map rw_semaphore to a separate rt_mutex-based
 implementation, thus changing the fairness:
 
- Because an rw_sempaphore writer cannot grant its priority to multiple
+ Because an rw_semaphore writer cannot grant its priority to multiple
  readers, a preempted low-priority reader will continue holding its lock,
  thus starving even high-priority writers.  In contrast, because readers
  can grant their priority to a writer, a preempted low-priority writer will
@@ -158,7 +158,7 @@ critical section is tiny, thus avoiding RT-mutex overhead.
 spinlock_t
 ----------
 
-The semantics of spinlock_t change with the state of CONFIG_PREEMPT_RT.
+The semantics of spinlock_t change with the state of PREEMPT_RT.
 
 On a non PREEMPT_RT enabled kernel spinlock_t is mapped to raw_spinlock_t
 and has exactly the same semantics.
@@ -196,7 +196,7 @@ PREEMPT_RT kernels preserve all other spinlock_t semantics:
    kernels leave task state untouched.  However, PREEMPT_RT must change
    task state if the task blocks during acquisition.  Therefore, it saves
    the current task state before blocking and the corresponding lock wakeup
-   restores it::
+   restores it, as shown below::
 
     task->state = TASK_INTERRUPTIBLE
      lock()
@@ -333,7 +333,7 @@ The most basic rules are:
 
   - Spinning lock types can nest inside sleeping lock types.
 
-These constraints apply both in CONFIG_PREEMPT_RT and otherwise.
+These constraints apply both in PREEMPT_RT and otherwise.
 
 The fact that PREEMPT_RT changes the lock category of spinlock_t and
 rwlock_t from spinning to sleeping means that they cannot be acquired while
@@ -344,4 +344,4 @@ holding a raw spinlock.  This results in the following nesting ordering:
   3) raw_spinlock_t and bit spinlocks
 
 Lockdep will complain if these constraints are violated, both in
-CONFIG_PREEMPT_RT and otherwise.
+PREEMPT_RT and otherwise.
