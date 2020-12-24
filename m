Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143222E2722
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 14:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgLXNMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 08:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728033AbgLXNMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 08:12:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9DBC0617A6;
        Thu, 24 Dec 2020 05:12:07 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608815525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2tkRs/sqATWLBVr8H6+Nv7Ft2PLbbPXnN1/yqJwLWw8=;
        b=S0XpGe2BHQMzo4lomRpk5bqY92nMehYU5K8wPmbED9WrAYHVFhQ9J9eGWEiMXutYMa6fsD
        aMjHTe6qxGsl+4VxRIbD/L2i8fwCzhX6J4YrdoGMC91SIF0LwBaFe/7WMa0N4ddFVFnq0z
        3Wc/RapKsGLTXtK/NQe+Ky9NxzIOmBYuMiIDsFcUxEi2oqRtPKigrmITGVArBT+YMwAWEM
        oFQG5sEBz2qQznt1VRymO4mx/9jdmDPuIBe+LngLVTH7ra70nYadeNqcPL5Yaq4Q7Ji9Uy
        Q0We4X+/ByH1ZT2dNHdg8oewzUHhUdhxBXTW3SOEMMiqKaPptnAb65X0+3qIuQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608815525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2tkRs/sqATWLBVr8H6+Nv7Ft2PLbbPXnN1/yqJwLWw8=;
        b=JfBLTWbLKwti3koIsxv+8W/960n1keowKXnWwSInhlmi0ZwEQKiH3c1rOj4lkrZxq0diuW
        c7zk88NLlkiqsfDA==
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [RFC PATCH 3/3] chelsio: cxgb: Do not schedule a workqueue for external interrupts
Date:   Thu, 24 Dec 2020 14:11:48 +0100
Message-Id: <20201224131148.300691-4-a.darwish@linutronix.de>
In-Reply-To: <20201224131148.300691-1-a.darwish@linutronix.de>
References: <20201224131148.300691-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cxgb's "elmer0" external interrupt handling code requires task context,
so originally a workqueue was scheduled for it from the hardirq handler.

Now that all of the external interrupt handling, elmer0 included, is run
from a threaded-irq context, just directly call the real handler.

Remove all the workqueue code that is now no longer needed, including
the spinlock used for synchronizing the workqueue's NIC regsiters access
against the irq handler.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
---
 drivers/net/ethernet/chelsio/cxgb/common.h |  2 --
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c  | 38 ----------------------
 drivers/net/ethernet/chelsio/cxgb/sge.c    |  3 --
 drivers/net/ethernet/chelsio/cxgb/subr.c   |  2 +-
 4 files changed, 1 insertion(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb/common.h b/drivers/net/ethernet/chelsio/cxgb/common.h
index 6475060649e9..504882e66831 100644
--- a/drivers/net/ethernet/chelsio/cxgb/common.h
+++ b/drivers/net/ethernet/chelsio/cxgb/common.h
@@ -238,7 +238,6 @@ struct adapter {
 	int msg_enable;
 	u32 mmio_len;
 
-	struct work_struct ext_intr_handler_task;
 	struct adapter_params params;
 
 	/* Terminator modules. */
@@ -256,7 +255,6 @@ struct adapter {
 	spinlock_t mac_lock;
 
 	/* guards async operations */
-	spinlock_t async_lock ____cacheline_aligned;
 	u32 slow_intr_mask;
 	int t1powersave;
 };
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index c96bdca4f270..b93e86d4d079 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -905,41 +905,6 @@ static void mac_stats_task(struct work_struct *work)
 	spin_unlock(&adapter->work_lock);
 }
 
-/*
- * Processes elmer0 external interrupts in process context.
- */
-static void ext_intr_task(struct work_struct *work)
-{
-	struct adapter *adapter =
-		container_of(work, struct adapter, ext_intr_handler_task);
-
-	t1_elmer0_ext_intr_handler(adapter);
-
-	/* Now reenable external interrupts */
-	spin_lock_irq(&adapter->async_lock);
-	adapter->slow_intr_mask |= F_PL_INTR_EXT;
-	writel(F_PL_INTR_EXT, adapter->regs + A_PL_CAUSE);
-	writel(adapter->slow_intr_mask | F_PL_INTR_SGE_DATA,
-		   adapter->regs + A_PL_ENABLE);
-	spin_unlock_irq(&adapter->async_lock);
-}
-
-/*
- * Interrupt-context handler for elmer0 external interrupts.
- */
-void t1_elmer0_ext_intr(struct adapter *adapter)
-{
-	/*
-	 * Schedule a task to handle external interrupts as we require
-	 * a process context.  We disable EXT interrupts in the interim
-	 * and let the task reenable them when it's done.
-	 */
-	adapter->slow_intr_mask &= ~F_PL_INTR_EXT;
-	writel(adapter->slow_intr_mask | F_PL_INTR_SGE_DATA,
-		   adapter->regs + A_PL_ENABLE);
-	schedule_work(&adapter->ext_intr_handler_task);
-}
-
 void t1_fatal_err(struct adapter *adapter)
 {
 	if (adapter->flags & FULL_INIT_DONE) {
@@ -1045,11 +1010,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 			spin_lock_init(&adapter->tpi_lock);
 			spin_lock_init(&adapter->work_lock);
-			spin_lock_init(&adapter->async_lock);
 			spin_lock_init(&adapter->mac_lock);
 
-			INIT_WORK(&adapter->ext_intr_handler_task,
-				  ext_intr_task);
 			INIT_DELAYED_WORK(&adapter->stats_update_task,
 					  mac_stats_task);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet/chelsio/cxgb/sge.c
index f1c402f6b889..9b4ffddbbc05 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -1657,10 +1657,7 @@ irqreturn_t t1_irq_thread(int irq, void *data)
 	struct sge *sge = adapter->sge;
 	int handled;
 
-	spin_lock(&adapter->async_lock);
 	handled = t1_slow_intr_handler(adapter);
-	spin_unlock(&adapter->async_lock);
-
 	if (!handled)
 		sge->stats.unhandled_irqs++;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb/subr.c b/drivers/net/ethernet/chelsio/cxgb/subr.c
index ea0f8741d7cf..197d3bb924ca 100644
--- a/drivers/net/ethernet/chelsio/cxgb/subr.c
+++ b/drivers/net/ethernet/chelsio/cxgb/subr.c
@@ -858,7 +858,7 @@ static int asic_slow_intr(adapter_t *adapter)
 	if (cause & F_PL_INTR_PCIX)
 		t1_pci_intr_handler(adapter);
 	if (cause & F_PL_INTR_EXT)
-		t1_elmer0_ext_intr(adapter);
+		t1_elmer0_ext_intr_handler(adapter);
 
 	/* Clear the interrupts just processed. */
 	writel(cause, adapter->regs + A_PL_CAUSE);
-- 
2.29.2

