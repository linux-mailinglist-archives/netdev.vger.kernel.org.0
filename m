Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B8118A411
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgCRUrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:47:32 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58411 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbgCRUrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 16:47:31 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jEfaZ-0006IW-8z; Wed, 18 Mar 2020 21:46:55 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 800E91040C6;
        Wed, 18 Mar 2020 21:46:37 +0100 (CET)
Message-Id: <20200318204408.521507446@linutronix.de>
User-Agent: quilt/0.65
Date:   Wed, 18 Mar 2020 21:43:13 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
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
        linuxppc-dev@lists.ozlabs.org
Subject: [patch V2 11/15] completion: Use simple wait queues
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

completion uses a wait_queue_head_t to enqueue waiters.

wait_queue_head_t contains a spinlock_t to protect the list of waiters
which excludes it from being used in truly atomic context on a PREEMPT_RT
enabled kernel.

The spinlock in the wait queue head cannot be replaced by a raw_spinlock
because:

  - wait queues can have custom wakeup callbacks, which acquire other
    spinlock_t locks and have potentially long execution times

  - wake_up() walks an unbounded number of list entries during the wake up
    and may wake an unbounded number of waiters.

For simplicity and performance reasons complete() should be usable on
PREEMPT_RT enabled kernels.

completions do not use custom wakeup callbacks and are usually single
waiter, except for a few corner cases.

Replace the wait queue in the completion with a simple wait queue (swait),
which uses a raw_spinlock_t for protecting the waiter list and therefore is
safe to use inside truly atomic regions on PREEMPT_RT.

There is no semantical or functional change:

  - completions use the exclusive wait mode which is what swait provides

  - complete() wakes one exclusive waiter

  - complete_all() wakes all waiters while holding the lock which protects
    the wait queue against newly incoming waiters. The conversion to swait
    preserves this behaviour.

complete_all() might cause unbound latencies with a large number of waiters
being woken at once, but most complete_all() usage sites are either in
testing or initialization code or have only a really small number of
concurrent waiters which for now does not cause a latency problem. Keep it
simple for now.

The fixup of the warning check in the USB gadget driver is just a straight
forward conversion of the lockless waiter check from one waitqueue type to
the other.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
---
V2: Split out the orinoco and usb gadget parts and amended change log
---
 drivers/usb/gadget/function/f_fs.c |    2 +-
 include/linux/completion.h         |    8 ++++----
 kernel/sched/completion.c          |   36 +++++++++++++++++++-----------------
 3 files changed, 24 insertions(+), 22 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1703,7 +1703,7 @@ static void ffs_data_put(struct ffs_data
 		pr_info("%s(): freeing\n", __func__);
 		ffs_data_clear(ffs);
 		BUG_ON(waitqueue_active(&ffs->ev.waitq) ||
-		       waitqueue_active(&ffs->ep0req_completion.wait) ||
+		       swait_active(&ffs->ep0req_completion.wait) ||
 		       waitqueue_active(&ffs->wait));
 		destroy_workqueue(ffs->io_completion_wq);
 		kfree(ffs->dev_name);
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -9,7 +9,7 @@
  * See kernel/sched/completion.c for details.
  */
 
-#include <linux/wait.h>
+#include <linux/swait.h>
 
 /*
  * struct completion - structure used to maintain state for a "completion"
@@ -25,7 +25,7 @@
  */
 struct completion {
 	unsigned int done;
-	wait_queue_head_t wait;
+	struct swait_queue_head wait;
 };
 
 #define init_completion_map(x, m) __init_completion(x)
@@ -34,7 +34,7 @@ static inline void complete_acquire(stru
 static inline void complete_release(struct completion *x) {}
 
 #define COMPLETION_INITIALIZER(work) \
-	{ 0, __WAIT_QUEUE_HEAD_INITIALIZER((work).wait) }
+	{ 0, __SWAIT_QUEUE_HEAD_INITIALIZER((work).wait) }
 
 #define COMPLETION_INITIALIZER_ONSTACK_MAP(work, map) \
 	(*({ init_completion_map(&(work), &(map)); &(work); }))
@@ -85,7 +85,7 @@ static inline void complete_release(stru
 static inline void __init_completion(struct completion *x)
 {
 	x->done = 0;
-	init_waitqueue_head(&x->wait);
+	init_swait_queue_head(&x->wait);
 }
 
 /**
--- a/kernel/sched/completion.c
+++ b/kernel/sched/completion.c
@@ -29,12 +29,12 @@ void complete(struct completion *x)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&x->wait.lock, flags);
+	raw_spin_lock_irqsave(&x->wait.lock, flags);
 
 	if (x->done != UINT_MAX)
 		x->done++;
-	__wake_up_locked(&x->wait, TASK_NORMAL, 1);
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	swake_up_locked(&x->wait);
+	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete);
 
@@ -58,10 +58,12 @@ void complete_all(struct completion *x)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&x->wait.lock, flags);
+	WARN_ON(irqs_disabled());
+
+	raw_spin_lock_irqsave(&x->wait.lock, flags);
 	x->done = UINT_MAX;
-	__wake_up_locked(&x->wait, TASK_NORMAL, 0);
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	swake_up_all_locked(&x->wait);
+	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete_all);
 
@@ -70,20 +72,20 @@ do_wait_for_common(struct completion *x,
 		   long (*action)(long), long timeout, int state)
 {
 	if (!x->done) {
-		DECLARE_WAITQUEUE(wait, current);
+		DECLARE_SWAITQUEUE(wait);
 
-		__add_wait_queue_entry_tail_exclusive(&x->wait, &wait);
 		do {
 			if (signal_pending_state(state, current)) {
 				timeout = -ERESTARTSYS;
 				break;
 			}
+			__prepare_to_swait(&x->wait, &wait);
 			__set_current_state(state);
-			spin_unlock_irq(&x->wait.lock);
+			raw_spin_unlock_irq(&x->wait.lock);
 			timeout = action(timeout);
-			spin_lock_irq(&x->wait.lock);
+			raw_spin_lock_irq(&x->wait.lock);
 		} while (!x->done && timeout);
-		__remove_wait_queue(&x->wait, &wait);
+		__finish_swait(&x->wait, &wait);
 		if (!x->done)
 			return timeout;
 	}
@@ -100,9 +102,9 @@ static inline long __sched
 
 	complete_acquire(x);
 
-	spin_lock_irq(&x->wait.lock);
+	raw_spin_lock_irq(&x->wait.lock);
 	timeout = do_wait_for_common(x, action, timeout, state);
-	spin_unlock_irq(&x->wait.lock);
+	raw_spin_unlock_irq(&x->wait.lock);
 
 	complete_release(x);
 
@@ -291,12 +293,12 @@ bool try_wait_for_completion(struct comp
 	if (!READ_ONCE(x->done))
 		return false;
 
-	spin_lock_irqsave(&x->wait.lock, flags);
+	raw_spin_lock_irqsave(&x->wait.lock, flags);
 	if (!x->done)
 		ret = false;
 	else if (x->done != UINT_MAX)
 		x->done--;
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(try_wait_for_completion);
@@ -322,8 +324,8 @@ bool completion_done(struct completion *
 	 * otherwise we can end up freeing the completion before complete()
 	 * is done referencing it.
 	 */
-	spin_lock_irqsave(&x->wait.lock, flags);
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	raw_spin_lock_irqsave(&x->wait.lock, flags);
+	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 	return true;
 }
 EXPORT_SYMBOL(completion_done);

