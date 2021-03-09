Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6ED332143
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhCIIqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhCIIph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:45:37 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83949C06174A;
        Tue,  9 Mar 2021 00:45:37 -0800 (PST)
Message-Id: <20210309084241.890532921@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615279536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=RESPeTyJ6azVCnEuJ5GRmkpcsMaksLQmntYP94M96Us=;
        b=NUiBdRmSHOw8Uw7iGVCliq0SkijyDtSQeIlX2ttF5eYOB04ertkM2Uh8QIwMjzxknvM4Oi
        GRczvMwF4Chxks6EHIdFcxf994wpOVMid6LgETyt8/3xRgaKeoLH3aRoLE9+RzkxtdL95l
        p/LK6qN1CFSizLi9NxVul4Z4oW9fZhlPZNFfowy+hYy/bvs0/8AmGMrt7JSObaFS2zC75D
        OBOxtN7SqvtX0InkXzFW/YoC2AIebW82mdvRv82KClxkE3l8y1cRUmjDxOxpUto6ZjvTy6
        sOul2TdGNELQKcFbwi+hrqP2XMxO/1prGGp3y655xbR4HnXaPbUW0ukOcaLScQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615279536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=RESPeTyJ6azVCnEuJ5GRmkpcsMaksLQmntYP94M96Us=;
        b=ZlShNnj6ML8G8VM9soMkkHJnBGalF94sWxBHDfAV6jTJiZ89UrK4IDm7BXCH9G1FxgEGHe
        KVDQyUY1lmDetZBw==
Date:   Tue, 09 Mar 2021 09:42:09 +0100
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
Subject: [patch 06/14] tasklets: Replace spin wait in tasklet_kill()
References: <20210309084203.995862150@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

tasklet_kill() spin waits for TASKLET_STATE_SCHED to be cleared invoking
yield() from inside the loop. yield() is an ill defined mechanism and the
result might still be wasting CPU cycles in a tight loop which is
especially painful in a guest when the CPU running the tasklet is scheduled
out.

tasklet_kill() is used in teardown paths and not performance critical at
all. Replace the spin wait with wait_var_event().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/softirq.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -532,6 +532,16 @@ void __tasklet_hi_schedule(struct taskle
 }
 EXPORT_SYMBOL(__tasklet_hi_schedule);
 
+static inline bool tasklet_clear_sched(struct tasklet_struct *t)
+{
+	if (test_and_clear_bit(TASKLET_STATE_SCHED, &t->state)) {
+		wake_up_var(&t->state);
+		return true;
+	}
+
+	return false;
+}
+
 static void tasklet_action_common(struct softirq_action *a,
 				  struct tasklet_head *tl_head,
 				  unsigned int softirq_nr)
@@ -551,8 +561,7 @@ static void tasklet_action_common(struct
 
 		if (tasklet_trylock(t)) {
 			if (!atomic_read(&t->count)) {
-				if (!test_and_clear_bit(TASKLET_STATE_SCHED,
-							&t->state))
+				if (!tasklet_clear_sched(t))
 					BUG();
 				if (t->use_callback)
 					t->callback(t);
@@ -612,13 +621,11 @@ void tasklet_kill(struct tasklet_struct
 	if (in_interrupt())
 		pr_notice("Attempt to kill tasklet from interrupt\n");
 
-	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
-		do {
-			yield();
-		} while (test_bit(TASKLET_STATE_SCHED, &t->state));
-	}
+	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state))
+		wait_var_event(&t->state, !test_bit(TASKLET_STATE_SCHED, &t->state));
+
 	tasklet_unlock_wait(t);
-	clear_bit(TASKLET_STATE_SCHED, &t->state);
+	tasklet_clear_sched(t);
 }
 EXPORT_SYMBOL(tasklet_kill);
 

