Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E34818A426
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgCRUrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:47:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58406 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgCRUrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 16:47:24 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jEfaR-0006Fi-0w; Wed, 18 Mar 2020 21:46:47 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 49D23101161;
        Wed, 18 Mar 2020 21:46:37 +0100 (CET)
Message-Id: <20200318204408.428468767@linutronix.de>
User-Agent: quilt/0.65
Date:   Wed, 18 Mar 2020 21:43:12 +0100
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
Subject: [patch V2 10/15] sched/swait: Prepare usage in completions
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

As a preparation to use simple wait queues for completions:

  - Provide swake_up_all_locked() to support complete_all()
  - Make __prepare_to_swait() public available

This is done to enable the usage of complete() within truly atomic contexts
on a PREEMPT_RT enabled kernel.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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

