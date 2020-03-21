Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13BC218E02B
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 12:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgCULfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 07:35:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38496 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728521AbgCULe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 07:34:57 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFcOT-0001zi-1B; Sat, 21 Mar 2020 12:34:21 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 16805FFBBF;
        Sat, 21 Mar 2020 12:34:20 +0100 (CET)
Message-Id: <20200321113241.824030968@linutronix.de>
User-Agent: quilt/0.65
Date:   Sat, 21 Mar 2020 12:25:55 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
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
        linuxppc-dev@lists.ozlabs.org,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [patch V3 11/20] rcuwait: Add @state argument to rcuwait_wait_event()
References: <20200321112544.878032781@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Zijlstra (Intel) <peterz@infradead.org>

Extend rcuwait_wait_event() with a state variable so that it is not
restricted to UNINTERRUPTIBLE waits.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>

---
 include/linux/rcuwait.h       |   12 ++++++++++--
 kernel/locking/percpu-rwsem.c |    2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/include/linux/rcuwait.h
+++ b/include/linux/rcuwait.h
@@ -3,6 +3,7 @@
 #define _LINUX_RCUWAIT_H_
 
 #include <linux/rcupdate.h>
+#include <linux/sched/signal.h>
 
 /*
  * rcuwait provides a way of blocking and waking up a single
@@ -30,23 +31,30 @@ extern void rcuwait_wake_up(struct rcuwa
  * The caller is responsible for locking around rcuwait_wait_event(),
  * such that writes to @task are properly serialized.
  */
-#define rcuwait_wait_event(w, condition)				\
+#define rcuwait_wait_event(w, condition, state)				\
 ({									\
+	int __ret = 0;							\
 	rcu_assign_pointer((w)->task, current);				\
 	for (;;) {							\
 		/*							\
 		 * Implicit barrier (A) pairs with (B) in		\
 		 * rcuwait_wake_up().					\
 		 */							\
-		set_current_state(TASK_UNINTERRUPTIBLE);		\
+		set_current_state(state);				\
 		if (condition)						\
 			break;						\
 									\
+		if (signal_pending_state(state, current)) {		\
+			__ret = -EINTR;					\
+			break;						\
+		}							\
+									\
 		schedule();						\
 	}								\
 									\
 	WRITE_ONCE((w)->task, NULL);					\
 	__set_current_state(TASK_RUNNING);				\
+	__ret;								\
 })
 
 #endif /* _LINUX_RCUWAIT_H_ */
--- a/kernel/locking/percpu-rwsem.c
+++ b/kernel/locking/percpu-rwsem.c
@@ -162,7 +162,7 @@ void percpu_down_write(struct percpu_rw_
 	 */
 
 	/* Wait for all now active readers to complete. */
-	rcuwait_wait_event(&sem->writer, readers_active_check(sem));
+	rcuwait_wait_event(&sem->writer, readers_active_check(sem), TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL_GPL(percpu_down_write);
 


