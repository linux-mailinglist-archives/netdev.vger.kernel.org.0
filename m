Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A227D18F868
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 16:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgCWPUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 11:20:49 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41746 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbgCWPUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 11:20:48 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jGOsF-000148-59; Mon, 23 Mar 2020 16:20:19 +0100
Date:   Mon, 23 Mar 2020 16:20:19 +0100
From:   Sebastian Siewior <bigeasy@linutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Davidlohr Bueso <dbueso@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        linux-pci@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
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
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] completion: Use lockdep_assert_RT_in_threaded_ctx() in
 complete_all()
Message-ID: <20200323152019.4qjwluldohuh3by5@linutronix.de>
References: <20200321112544.878032781@linutronix.de>
 <20200321113242.317954042@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200321113242.317954042@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The warning was intended to spot complete_all() users from hardirq
context on PREEMPT_RT. The warning as-is will also trigger in interrupt
handlers, which are threaded on PREEMPT_RT, which was not intended.

Use lockdep_assert_RT_in_threaded_ctx() which triggers in non-preemptive
context on PREEMPT_RT.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/lockdep.h   | 15 +++++++++++++++
 kernel/sched/completion.c |  2 +-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 425b4ceb7cd07..206774ac69460 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -711,6 +711,21 @@ do {									\
 # define lockdep_assert_in_irq() do { } while (0)
 #endif
 
+#ifdef CONFIG_PROVE_RAW_LOCK_NESTING
+
+# define lockdep_assert_RT_in_threaded_ctx() do {			\
+		WARN_ONCE(debug_locks && !current->lockdep_recursion &&	\
+			  current->hardirq_context &&			\
+			  !(current->hardirq_threaded || current->irq_config),	\
+			  "Not in threaded context on PREEMPT_RT as expected\n");	\
+} while (0)
+
+#else
+
+# define lockdep_assert_RT_in_threaded_ctx() do { } while (0)
+
+#endif
+
 #ifdef CONFIG_LOCKDEP
 void lockdep_rcu_suspicious(const char *file, const int line, const char *s);
 #else
diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
index f15e96164ff1e..a778554f9dad7 100644
--- a/kernel/sched/completion.c
+++ b/kernel/sched/completion.c
@@ -58,7 +58,7 @@ void complete_all(struct completion *x)
 {
 	unsigned long flags;
 
-	WARN_ON(irqs_disabled());
+	lockdep_assert_RT_in_threaded_ctx();
 
 	raw_spin_lock_irqsave(&x->wait.lock, flags);
 	x->done = UINT_MAX;
-- 
2.26.0.rc2

