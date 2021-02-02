Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D7A30C717
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbhBBRKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:10:30 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:37726 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbhBBRCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 12:02:00 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612285268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b5SGDplQXLax7IynxXZfYWhpyjl0bZS/RcTiGBygrQI=;
        b=gwkktjlYjU0ks9Cqpa57WY4JjPngonxO7mtxLAlgPVJt85rvMHdc81WvPFV62y7A8FJLzj
        cf4Q7hGYd8AYkZXnT0DuBb5UQmPOIoFZsjnLUqYXogAOzPKXftq/0AKVsJlKizo/7TJFg/
        rW5UviIupL60mRG7xRazog8HzK7JVYa8wFsJqhl4i+ciNV6QcPls3yIhrBIpY4WZ5/7NV1
        SdKdUqRG9jVhNbgbq6aSd8vRQpeM4tBHD8Waa5uENZyWxK5m3FKa8HcKRnDj0r9qD3F0Pa
        dBbzqKhGXL1GgFCijptUxCVgV3gnNLxd6ynE9UrXycTUVvSARhY4Vzv3VgTKBA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612285268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b5SGDplQXLax7IynxXZfYWhpyjl0bZS/RcTiGBygrQI=;
        b=5/qMgSBWbkGsYPm+BMGYIQFdL03fAQQqrWpX96cjseb7nEkzc4zWkRVLwuJUmdXgQ8NXA5
        Px0KTRLLFs6uUhAg==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/2] chelsio: cxgb: Replace the workqueue with threaded interrupt
Date:   Tue,  2 Feb 2021 18:01:03 +0100
Message-Id: <20210202170104.1909200-2-bigeasy@linutronix.de>
In-Reply-To: <20210202170104.1909200-1-bigeasy@linutronix.de>
References: <20210202170104.1909200-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The external interrupt (F_PL_INTR_EXT) needs to be handled in a process
context and this is accomplished by utilizing a workqueue.

The process context can also be provided by a threaded interrupt instead
of a workqueue. The threaded interrupt can be used later for other
interrupt related processing which require non-atomic context without
using yet another workqueue. free_irq() also ensures that the thread is
done which is currently missing (the worker could continue after the
module has been removed).

Save pending flags in pending_thread_intr. Use the same mechanism
to disable F_PL_INTR_EXT as interrupt source like it is used before the
worker is scheduled. Enable the interrupt again once
t1_elmer0_ext_intr_handler() is done.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/ethernet/chelsio/cxgb/common.h |  5 +--
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c  | 44 ++--------------------
 drivers/net/ethernet/chelsio/cxgb/sge.c    | 33 ++++++++++++++--
 drivers/net/ethernet/chelsio/cxgb/sge.h    |  1 +
 drivers/net/ethernet/chelsio/cxgb/subr.c   | 26 +++++++++----
 5 files changed, 55 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb/common.h b/drivers/net/ether=
net/chelsio/cxgb/common.h
index 6475060649e90..e999a9b9fe6cc 100644
--- a/drivers/net/ethernet/chelsio/cxgb/common.h
+++ b/drivers/net/ethernet/chelsio/cxgb/common.h
@@ -238,7 +238,6 @@ struct adapter {
 	int msg_enable;
 	u32 mmio_len;
=20
-	struct work_struct ext_intr_handler_task;
 	struct adapter_params params;
=20
 	/* Terminator modules. */
@@ -257,6 +256,7 @@ struct adapter {
=20
 	/* guards async operations */
 	spinlock_t async_lock ____cacheline_aligned;
+	u32 pending_thread_intr;
 	u32 slow_intr_mask;
 	int t1powersave;
 };
@@ -334,8 +334,7 @@ void t1_interrupts_enable(adapter_t *adapter);
 void t1_interrupts_disable(adapter_t *adapter);
 void t1_interrupts_clear(adapter_t *adapter);
 int t1_elmer0_ext_intr_handler(adapter_t *adapter);
-void t1_elmer0_ext_intr(adapter_t *adapter);
-int t1_slow_intr_handler(adapter_t *adapter);
+irqreturn_t t1_slow_intr_handler(adapter_t *adapter);
=20
 int t1_link_start(struct cphy *phy, struct cmac *mac, struct link_config *=
lc);
 const struct board_info *t1_get_board_info(unsigned int board_id);
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethern=
et/chelsio/cxgb/cxgb2.c
index 0e4a0f413960a..bd6f3c532d72e 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -211,9 +211,10 @@ static int cxgb_up(struct adapter *adapter)
 	t1_interrupts_clear(adapter);
=20
 	adapter->params.has_msi =3D !disable_msi && !pci_enable_msi(adapter->pdev=
);
-	err =3D request_irq(adapter->pdev->irq, t1_interrupt,
-			  adapter->params.has_msi ? 0 : IRQF_SHARED,
-			  adapter->name, adapter);
+	err =3D request_threaded_irq(adapter->pdev->irq, t1_interrupt,
+				   t1_interrupt_thread,
+				   adapter->params.has_msi ? 0 : IRQF_SHARED,
+				   adapter->name, adapter);
 	if (err) {
 		if (adapter->params.has_msi)
 			pci_disable_msi(adapter->pdev);
@@ -916,41 +917,6 @@ static void mac_stats_task(struct work_struct *work)
 	spin_unlock(&adapter->work_lock);
 }
=20
-/*
- * Processes elmer0 external interrupts in process context.
- */
-static void ext_intr_task(struct work_struct *work)
-{
-	struct adapter *adapter =3D
-		container_of(work, struct adapter, ext_intr_handler_task);
-
-	t1_elmer0_ext_intr_handler(adapter);
-
-	/* Now reenable external interrupts */
-	spin_lock_irq(&adapter->async_lock);
-	adapter->slow_intr_mask |=3D F_PL_INTR_EXT;
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
-	adapter->slow_intr_mask &=3D ~F_PL_INTR_EXT;
-	writel(adapter->slow_intr_mask | F_PL_INTR_SGE_DATA,
-		   adapter->regs + A_PL_ENABLE);
-	schedule_work(&adapter->ext_intr_handler_task);
-}
-
 void t1_fatal_err(struct adapter *adapter)
 {
 	if (adapter->flags & FULL_INIT_DONE) {
@@ -1062,8 +1028,6 @@ static int init_one(struct pci_dev *pdev, const struc=
t pci_device_id *ent)
 			spin_lock_init(&adapter->async_lock);
 			spin_lock_init(&adapter->mac_lock);
=20
-			INIT_WORK(&adapter->ext_intr_handler_task,
-				  ext_intr_task);
 			INIT_DELAYED_WORK(&adapter->stats_update_task,
 					  mac_stats_task);
=20
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet=
/chelsio/cxgb/sge.c
index 2d9c2b5a690a3..5aef9ae1ecfed 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -1619,11 +1619,38 @@ int t1_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
=20
+irqreturn_t t1_interrupt_thread(int irq, void *data)
+{
+	struct adapter *adapter =3D data;
+	u32 pending_thread_intr;
+
+	spin_lock_irq(&adapter->async_lock);
+	pending_thread_intr =3D adapter->pending_thread_intr;
+	adapter->pending_thread_intr =3D 0;
+	spin_unlock_irq(&adapter->async_lock);
+
+	if (!pending_thread_intr)
+		return IRQ_NONE;
+
+	if (pending_thread_intr & F_PL_INTR_EXT)
+		t1_elmer0_ext_intr_handler(adapter);
+
+	spin_lock_irq(&adapter->async_lock);
+	adapter->slow_intr_mask |=3D F_PL_INTR_EXT;
+
+	writel(F_PL_INTR_EXT, adapter->regs + A_PL_CAUSE);
+	writel(adapter->slow_intr_mask | F_PL_INTR_SGE_DATA,
+	       adapter->regs + A_PL_ENABLE);
+	spin_unlock_irq(&adapter->async_lock);
+
+	return IRQ_HANDLED;
+}
+
 irqreturn_t t1_interrupt(int irq, void *data)
 {
 	struct adapter *adapter =3D data;
 	struct sge *sge =3D adapter->sge;
-	int handled;
+	irqreturn_t handled;
=20
 	if (likely(responses_pending(adapter))) {
 		writel(F_PL_INTR_SGE_DATA, adapter->regs + A_PL_CAUSE);
@@ -1645,10 +1672,10 @@ irqreturn_t t1_interrupt(int irq, void *data)
 	handled =3D t1_slow_intr_handler(adapter);
 	spin_unlock(&adapter->async_lock);
=20
-	if (!handled)
+	if (handled =3D=3D IRQ_NONE)
 		sge->stats.unhandled_irqs++;
=20
-	return IRQ_RETVAL(handled !=3D 0);
+	return handled;
 }
=20
 /*
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.h b/drivers/net/ethernet=
/chelsio/cxgb/sge.h
index a1ba591b34312..76516d2a8aa9e 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.h
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.h
@@ -74,6 +74,7 @@ struct sge *t1_sge_create(struct adapter *, struct sge_pa=
rams *);
 int t1_sge_configure(struct sge *, struct sge_params *);
 int t1_sge_set_coalesce_params(struct sge *, struct sge_params *);
 void t1_sge_destroy(struct sge *);
+irqreturn_t t1_interrupt_thread(int irq, void *data);
 irqreturn_t t1_interrupt(int irq, void *cookie);
 int t1_poll(struct napi_struct *, int);
=20
diff --git a/drivers/net/ethernet/chelsio/cxgb/subr.c b/drivers/net/etherne=
t/chelsio/cxgb/subr.c
index ea0f8741d7cfd..d90ad07ff1a40 100644
--- a/drivers/net/ethernet/chelsio/cxgb/subr.c
+++ b/drivers/net/ethernet/chelsio/cxgb/subr.c
@@ -210,7 +210,7 @@ static int fpga_phy_intr_handler(adapter_t *adapter)
 /*
  * Slow path interrupt handler for FPGAs.
  */
-static int fpga_slow_intr(adapter_t *adapter)
+static irqreturn_t fpga_slow_intr(adapter_t *adapter)
 {
 	u32 cause =3D readl(adapter->regs + A_PL_CAUSE);
=20
@@ -238,7 +238,7 @@ static int fpga_slow_intr(adapter_t *adapter)
 	if (cause)
 		writel(cause, adapter->regs + A_PL_CAUSE);
=20
-	return cause !=3D 0;
+	return cause =3D=3D 0 ? IRQ_NONE : IRQ_HANDLED;
 }
 #endif
=20
@@ -842,13 +842,14 @@ void t1_interrupts_clear(adapter_t* adapter)
 /*
  * Slow path interrupt handler for ASICs.
  */
-static int asic_slow_intr(adapter_t *adapter)
+static irqreturn_t asic_slow_intr(adapter_t *adapter)
 {
 	u32 cause =3D readl(adapter->regs + A_PL_CAUSE);
+	irqreturn_t ret =3D IRQ_HANDLED;
=20
 	cause &=3D adapter->slow_intr_mask;
 	if (!cause)
-		return 0;
+		return IRQ_NONE;
 	if (cause & F_PL_INTR_SGE_ERR)
 		t1_sge_intr_error_handler(adapter->sge);
 	if (cause & F_PL_INTR_TP)
@@ -857,16 +858,25 @@ static int asic_slow_intr(adapter_t *adapter)
 		t1_espi_intr_handler(adapter->espi);
 	if (cause & F_PL_INTR_PCIX)
 		t1_pci_intr_handler(adapter);
-	if (cause & F_PL_INTR_EXT)
-		t1_elmer0_ext_intr(adapter);
+	if (cause & F_PL_INTR_EXT) {
+		/* Wake the threaded interrupt to handle external interrupts as
+		 * we require a process context. We disable EXT interrupts in
+		 * the interim and let the thread reenable them when it's done.
+		 */
+		adapter->pending_thread_intr |=3D F_PL_INTR_EXT;
+		adapter->slow_intr_mask &=3D ~F_PL_INTR_EXT;
+		writel(adapter->slow_intr_mask | F_PL_INTR_SGE_DATA,
+		       adapter->regs + A_PL_ENABLE);
+		ret =3D IRQ_WAKE_THREAD;
+	}
=20
 	/* Clear the interrupts just processed. */
 	writel(cause, adapter->regs + A_PL_CAUSE);
 	readl(adapter->regs + A_PL_CAUSE); /* flush writes */
-	return 1;
+	return ret;
 }
=20
-int t1_slow_intr_handler(adapter_t *adapter)
+irqreturn_t t1_slow_intr_handler(adapter_t *adapter)
 {
 #ifdef CONFIG_CHELSIO_T1_1G
 	if (!t1_is_asic(adapter))
--=20
2.30.0

