Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0876918E09D
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 12:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgCULha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 07:37:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38469 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbgCULez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 07:34:55 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFcOW-0002EM-Vk; Sat, 21 Mar 2020 12:34:25 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 1C9FE1040C6;
        Sat, 21 Mar 2020 12:34:21 +0100 (CET)
Message-Id: <20200321113242.228481202@linutronix.de>
User-Agent: quilt/0.65
Date:   Sat, 21 Mar 2020 12:25:59 +0100
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
Subject: [patch V3 15/20] sched/swait: Prepare usage in completions
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

From: Thomas Gleixner <tglx@linutronix.de>

As a preparation to use simple wait queues for completions:

  - Provide swake_up_all_locked() to support complete_all()
  - Make __prepare_to_swait() public available

This is done to enable the usage of complete() within truly atomic contexts
on a PREEMPT_RT enabled kernel.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
V2: Add comment to swake_up_all_locked()
---
 kernel/sched/sched.h |    3 +++
 kernel/sched/swait.c |   15 ++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2492,3 +2492,6 @@ static inline bool is_per_cpu_kthread(st
 	return true;
 }
 #endif
+
+void swake_up_all_locked(struct swait_queue_head *q);
+void __prepare_to_swait(struct swait_queue_head *q, struct swait_queue *wait);
--- a/kernel/sched/swait.c
+++ b/kernel/sched/swait.c
@@ -32,6 +32,19 @@ void swake_up_locked(struct swait_queue_
 }
 EXPORT_SYMBOL(swake_up_locked);
 
+/*
+ * Wake up all waiters. This is an interface which is solely exposed for
+ * completions and not for general usage.
+ *
+ * It is intentionally different from swake_up_all() to allow usage from
+ * hard interrupt context and interrupt disabled regions.
+ */
+void swake_up_all_locked(struct swait_queue_head *q)
+{
+	while (!list_empty(&q->task_list))
+		swake_up_locked(q);
+}
+
 void swake_up_one(struct swait_queue_head *q)
 {
 	unsigned long flags;
@@ -69,7 +82,7 @@ void swake_up_all(struct swait_queue_hea
 }
 EXPORT_SYMBOL(swake_up_all);
 
-static void __prepare_to_swait(struct swait_queue_head *q, struct swait_queue *wait)
+void __prepare_to_swait(struct swait_queue_head *q, struct swait_queue *wait)
 {
 	wait->task = current;
 	if (list_empty(&wait->task_list))


