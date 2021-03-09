Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B19332104
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhCIIpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbhCIIpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:45:34 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C838DC06174A;
        Tue,  9 Mar 2021 00:45:33 -0800 (PST)
Message-Id: <20210309084241.563164193@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615279532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=/UnLzSVCcxvGNYKGpDDBRqhUSHTKrJGFJcYQa+vwSGQ=;
        b=V+AEQbNjhtRhuebeBrMCgL7RgzMORCcJrbG1jGSq7hEHhdZa2zglvU9O6hbOcZSe8p1E0X
        SYJ4HAGbI+7COvYN3irDSshZpa+VP0J0UsSFC8WOPjJuN6RgKiOz++rOeysNvCvsA+H3ta
        qgmhJcGq1HLPTiKt+a++NsDnKnz8wj0w01sLYRssdeQE0vE2WQO21ON17EPyhfcptOVxkt
        PwFXUIK+dJL66cPHdls57nImfbwrvZWVg842bG+sCSSpA5jEEHfUR5AC6JoPVC/N9jQvHs
        IUM72SU5FmiYKkLYTLpCdm9HsrUdZ2anEO03GaZhgiGaYsi2TVdiY9NrPbT36g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615279532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=/UnLzSVCcxvGNYKGpDDBRqhUSHTKrJGFJcYQa+vwSGQ=;
        b=9Az08VrqqTiGpFMvA7db/9zLQv1ZJFiYrsRHaDthCeMBa4+qgzNS/a62E51P751BGYBIY6
        Hs6xoBoJfJ4IJXBQ==
Date:   Tue, 09 Mar 2021 09:42:06 +0100
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
Subject: [patch 03/14] tasklets: Provide tasklet_disable_in_atomic()
References: <20210309084203.995862150@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replacing the spin wait loops in tasklet_unlock_wait() with
wait_var_event() is not possible as a handful of tasklet_disable()
invocations are happening in atomic context. All other invocations are in
teardown paths which can sleep.

Provide tasklet_disable_in_atomic() and tasklet_unlock_spin_wait() to
convert the few atomic use cases over, which allows to change
tasklet_disable() and tasklet_unlock_wait() in a later step.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -675,10 +675,21 @@ static inline void tasklet_unlock_wait(s
 	while (test_bit(TASKLET_STATE_RUN, &t->state))
 		cpu_relax();
 }
+
+/*
+ * Do not use in new code. Waiting for tasklets from atomic contexts is
+ * error prone and should be avoided.
+ */
+static inline void tasklet_unlock_spin_wait(struct tasklet_struct *t)
+{
+	while (test_bit(TASKLET_STATE_RUN, &t->state))
+		cpu_relax();
+}
 #else
 static inline int tasklet_trylock(struct tasklet_struct *t) { return 1; }
 static inline void tasklet_unlock(struct tasklet_struct *t) { }
 static inline void tasklet_unlock_wait(struct tasklet_struct *t) { }
+static inline void tasklet_unlock_spin_wait(struct tasklet_struct *t) { }
 #endif
 
 extern void __tasklet_schedule(struct tasklet_struct *t);
@@ -703,6 +714,17 @@ static inline void tasklet_disable_nosyn
 	smp_mb__after_atomic();
 }
 
+/*
+ * Do not use in new code. Disabling tasklets from atomic contexts is
+ * error prone and should be avoided.
+ */
+static inline void tasklet_disable_in_atomic(struct tasklet_struct *t)
+{
+	tasklet_disable_nosync(t);
+	tasklet_unlock_spin_wait(t);
+	smp_mb();
+}
+
 static inline void tasklet_disable(struct tasklet_struct *t)
 {
 	tasklet_disable_nosync(t);

