Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10ED7332139
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhCIIqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:46:13 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51322 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhCIIpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:45:38 -0500
Message-Id: <20210309084241.988908275@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615279537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=GYa4T+wysmchbWGyEHnP5D3R0q7070Yof//eaYXU1t4=;
        b=yxyplOX4MXWNGUVOFyrXPOpSoz5Xwyp0qFq/PKDiLxB/oLCssT4uIrk0eh2pqbVlBbzI13
        cVnrEX/vsYWP+i5SJ/Pm4awxHaL97/sJ5hT7Zp64PGIhiuDN3PwGW2MBj5qi+WGBo+fjTy
        cFpnOcxJbCseftcCMRVBWgAGI8Eh7x3xYezUVHRZQZ3h5aDjV2yEY/eBwuPS9/6f2tjX2w
        jTGnCw7JWlCYzG6d7GW9EKZTZ5p50ogEvi79Tvxy0ER8kF26iO3NF3IZ11ea/GV8tQwFnd
        CiJE8PwenQN7BPD+Q1TAoUM6ruuq1Va68m8d8EKDQPUE/mOSfhuY3efshhyVjg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615279537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=GYa4T+wysmchbWGyEHnP5D3R0q7070Yof//eaYXU1t4=;
        b=uVSheKue6bDObKaJ12syhv7eSNkzNhgwmrD8T0lvpUxqFVWjK3FZc04NfNq0pEDVDjsSWe
        k8TZrQM0mccfYkDw==
Date:   Tue, 09 Mar 2021 09:42:10 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-hyperv@vger.kernel.org, linux-pci@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: [patch 07/14] tasklets: Prevent tasklet_unlock_spin_wait() deadlock on RT
References: <20210309084203.995862150@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tasklet_unlock_spin_wait() spin waits for the TASKLET_STATE_SCHED bit in
the tasklet state to be cleared. This works on !RT nicely because the
corresponding execution can only happen on a different CPU.

On RT softirq processing is preemptible, therefore a task preempting the
softirq processing thread can spin forever.

Prevent this by invoking local_bh_disable()/enable() inside the loop. In
case that the softirq processing thread was preempted by the current task,
current will block on the local lock which yields the CPU to the preempted
softirq processing thread. If the tasklet is processed on a different CPU
then the local_bh_disable()/enable() pair is just a waste of processor
cycles.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/interrupt.h |    2 +-
 kernel/softirq.c          |   28 +++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -658,7 +658,7 @@ enum
 	TASKLET_STATE_RUN	/* Tasklet is running (SMP only) */
 };
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
 static inline int tasklet_trylock(struct tasklet_struct *t)
 {
 	return !test_and_set_bit(TASKLET_STATE_RUN, &(t)->state);
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -616,6 +616,32 @@ void tasklet_init(struct tasklet_struct
 }
 EXPORT_SYMBOL(tasklet_init);
 
+#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
+/*
+ * Do not use in new code. There is no real reason to invoke this from
+ * atomic contexts.
+ */
+void tasklet_unlock_spin_wait(struct tasklet_struct *t)
+{
+	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) {
+		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
+			/*
+			 * Prevent a live lock when current preempted soft
+			 * interrupt processing or prevents ksoftirqd from
+			 * running. If the tasklet runs on a different CPU
+			 * then this has no effect other than doing the BH
+			 * disable/enable dance for nothing.
+			 */
+			local_bh_disable();
+			local_bh_enable();
+		} else {
+			cpu_relax();
+		}
+	}
+}
+EXPORT_SYMBOL(tasklet_unlock_spin_wait);
+#endif
+
 void tasklet_kill(struct tasklet_struct *t)
 {
 	if (in_interrupt())
@@ -629,7 +655,7 @@ void tasklet_kill(struct tasklet_struct
 }
 EXPORT_SYMBOL(tasklet_kill);
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
 void tasklet_unlock(struct tasklet_struct *t)
 {
 	smp_mb__before_atomic();

