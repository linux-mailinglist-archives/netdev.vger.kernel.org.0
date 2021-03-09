Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD3D33210F
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhCIIqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:46:08 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51322 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhCIIpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:45:36 -0500
Message-Id: <20210309084241.783936921@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615279534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=4ZkB40PRvDpu0j2eO3bdXGRRAGc3lWp6vGTyvByr3WU=;
        b=VcarJNiF3W/kOySvc+Kvt2sQr5CNHHpp+0KYJEleYBLkSSGLsDjUwbCZ+ttJ66D0Q1ispq
        LuRXtaqhWDyEut2StVllxi6+rFKscZM/LnQ7WRE38ws1p90R5jOzjF3RGp8xTp1gVoWSa0
        AFlD1vHkzSo1ZnTK5lrFXP8+CsljZy+7SBVIkHB7ZpzUMvgg9a8CuTb8Qg8LFpXXp1u+5r
        kxo6StGdFp30rNx+PoJZH29hxZ8OVFJMuEBiHq1Sk/221OQwzxW8wU2qLCqDHq5LytyQq/
        +GfzqO8TQeQ/UAx+e4qL3/amdtsXJ+7A3seZTJd4Z3dgN2l9d2EEZfnQePdMXQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615279534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=4ZkB40PRvDpu0j2eO3bdXGRRAGc3lWp6vGTyvByr3WU=;
        b=jIsPkF+4WMvgAlsbmhzYBMM16NCTQ90FLvCon97O1Nn0XD+z/XvKPcjTwIPn9fDlcPJR+N
        2rD7FRipxQ1yX2Bw==
Date:   Tue, 09 Mar 2021 09:42:08 +0100
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
Subject: [patch 05/14] tasklets: Replace spin wait in tasklet_unlock_wait()
References: <20210309084203.995862150@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

tasklet_unlock_wait() spin waits for TASKLET_STATE_RUN to be cleared. This
is wasting CPU cycles in a tight loop which is especially painful in a
guest when the CPU running the tasklet is scheduled out.

tasklet_unlock_wait() is invoked from tasklet_kill() which is used in
teardown paths and not performance critical at all. Replace the spin wait
with wait_var_event().

There are no users of tasklet_unlock_wait() which are invoked from atomic
contexts. The usage in tasklet_disable() has been replaced temporarily with
the spin waiting variant until the atomic users are fixed up and will be
converted to the sleep wait variant later.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |   13 ++-----------
 kernel/softirq.c          |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 11 deletions(-)

--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -664,17 +664,8 @@ static inline int tasklet_trylock(struct
 	return !test_and_set_bit(TASKLET_STATE_RUN, &(t)->state);
 }
 
-static inline void tasklet_unlock(struct tasklet_struct *t)
-{
-	smp_mb__before_atomic();
-	clear_bit(TASKLET_STATE_RUN, &(t)->state);
-}
-
-static inline void tasklet_unlock_wait(struct tasklet_struct *t)
-{
-	while (test_bit(TASKLET_STATE_RUN, &t->state))
-		cpu_relax();
-}
+void tasklet_unlock(struct tasklet_struct *t);
+void tasklet_unlock_wait(struct tasklet_struct *t);
 
 /*
  * Do not use in new code. Waiting for tasklets from atomic contexts is
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -25,6 +25,7 @@
 #include <linux/smpboot.h>
 #include <linux/tick.h>
 #include <linux/irq.h>
+#include <linux/wait_bit.h>
 
 #include <asm/softirq_stack.h>
 
@@ -621,6 +622,23 @@ void tasklet_kill(struct tasklet_struct
 }
 EXPORT_SYMBOL(tasklet_kill);
 
+#ifdef CONFIG_SMP
+void tasklet_unlock(struct tasklet_struct *t)
+{
+	smp_mb__before_atomic();
+	clear_bit(TASKLET_STATE_RUN, &t->state);
+	smp_mb__after_atomic();
+	wake_up_var(&t->state);
+}
+EXPORT_SYMBOL_GPL(tasklet_unlock);
+
+void tasklet_unlock_wait(struct tasklet_struct *t)
+{
+	wait_var_event(&t->state, !test_bit(TASKLET_STATE_RUN, &t->state));
+}
+EXPORT_SYMBOL_GPL(tasklet_unlock_wait);
+#endif
+
 void __init softirq_init(void)
 {
 	int cpu;

