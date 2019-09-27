Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82470C034C
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbfI0KQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:16:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:56926 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727314AbfI0KPA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:15:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D8CCBAE99;
        Fri, 27 Sep 2019 10:14:54 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/17] staging: qlge: Remove irq_cnt
Date:   Fri, 27 Sep 2019 19:11:56 +0900
Message-Id: <20190927101210.23856-3-bpoirier@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190927101210.23856-1-bpoirier@suse.com>
References: <20190927101210.23856-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qlge uses an irq enable/disable refcounting scheme that is:
* poorly implemented
	Uses a spin_lock to protect accesses to the irq_cnt atomic
	variable.
* buggy
	Breaks when there is not a 1:1 sequence of irq - napi_poll, such as
	when using SO_BUSY_POLL.
* unnecessary
	The purpose or irq_cnt is to reduce irq control writes when
	multiple work items result from one irq: the irq is re-enabled
	after all work is done.
	Analysis of the irq handler shows that there is only one case where
	there might be two workers scheduled at once, and those have
	separate irq masking bits.

Therefore, remove irq_cnt.

Additionally, we get a performance improvement:
perf stat -e cycles -a -r5 super_netperf 100 -H 192.168.33.1 -t TCP_RR

Before:
628560
628056
622103
622744
627202
[...]
   268,803,947,669      cycles                 ( +-  0.09% )

After:
636300
634106
634984
638555
634188
[...]
   259,237,291,449      cycles                 ( +-  0.19% )

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/staging/qlge/qlge.h      |  7 ---
 drivers/staging/qlge/qlge_main.c | 98 +++++++++-----------------------
 drivers/staging/qlge/qlge_mpi.c  |  1 -
 3 files changed, 27 insertions(+), 79 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index ad7c5eb8a3b6..5d9a36deda08 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -1982,11 +1982,6 @@ struct intr_context {
 	u32 intr_dis_mask;	/* value/mask used to disable this intr */
 	u32 intr_read_mask;	/* value/mask used to read this intr */
 	char name[IFNAMSIZ * 2];
-	atomic_t irq_cnt;	/* irq_cnt is used in single vector
-				 * environment.  It's incremented for each
-				 * irq handler that is scheduled.  When each
-				 * handler finishes it decrements irq_cnt and
-				 * enables interrupts if it's zero. */
 	irq_handler_t handler;
 };
 
@@ -2074,7 +2069,6 @@ struct ql_adapter {
 	u32 port;		/* Port number this adapter */
 
 	spinlock_t adapter_lock;
-	spinlock_t hw_lock;
 	spinlock_t stats_lock;
 
 	/* PCI Bus Relative Register Addresses */
@@ -2235,7 +2229,6 @@ void ql_mpi_reset_work(struct work_struct *work);
 void ql_mpi_core_to_log(struct work_struct *work);
 int ql_wait_reg_rdy(struct ql_adapter *qdev, u32 reg, u32 bit, u32 ebit);
 void ql_queue_asic_error(struct ql_adapter *qdev);
-u32 ql_enable_completion_interrupt(struct ql_adapter *qdev, u32 intr);
 void ql_set_ethtool_ops(struct net_device *ndev);
 int ql_read_xgmac_reg64(struct ql_adapter *qdev, u32 reg, u64 *data);
 void ql_mpi_idc_work(struct work_struct *work);
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index d7b64d360ea8..7a8d6390d5de 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -625,75 +625,26 @@ static void ql_disable_interrupts(struct ql_adapter *qdev)
 	ql_write32(qdev, INTR_EN, (INTR_EN_EI << 16));
 }
 
-/* If we're running with multiple MSI-X vectors then we enable on the fly.
- * Otherwise, we may have multiple outstanding workers and don't want to
- * enable until the last one finishes. In this case, the irq_cnt gets
- * incremented every time we queue a worker and decremented every time
- * a worker finishes.  Once it hits zero we enable the interrupt.
- */
-u32 ql_enable_completion_interrupt(struct ql_adapter *qdev, u32 intr)
+static void ql_enable_completion_interrupt(struct ql_adapter *qdev, u32 intr)
 {
-	u32 var = 0;
-	unsigned long hw_flags = 0;
-	struct intr_context *ctx = qdev->intr_context + intr;
-
-	if (likely(test_bit(QL_MSIX_ENABLED, &qdev->flags) && intr)) {
-		/* Always enable if we're MSIX multi interrupts and
-		 * it's not the default (zeroeth) interrupt.
-		 */
-		ql_write32(qdev, INTR_EN,
-			   ctx->intr_en_mask);
-		var = ql_read32(qdev, STS);
-		return var;
-	}
+	struct intr_context *ctx = &qdev->intr_context[intr];
 
-	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
-	if (atomic_dec_and_test(&ctx->irq_cnt)) {
-		ql_write32(qdev, INTR_EN,
-			   ctx->intr_en_mask);
-		var = ql_read32(qdev, STS);
-	}
-	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
-	return var;
+	ql_write32(qdev, INTR_EN, ctx->intr_en_mask);
 }
 
-static u32 ql_disable_completion_interrupt(struct ql_adapter *qdev, u32 intr)
+static void ql_disable_completion_interrupt(struct ql_adapter *qdev, u32 intr)
 {
-	u32 var = 0;
-	struct intr_context *ctx;
+	struct intr_context *ctx = &qdev->intr_context[intr];
 
-	/* HW disables for us if we're MSIX multi interrupts and
-	 * it's not the default (zeroeth) interrupt.
-	 */
-	if (likely(test_bit(QL_MSIX_ENABLED, &qdev->flags) && intr))
-		return 0;
-
-	ctx = qdev->intr_context + intr;
-	spin_lock(&qdev->hw_lock);
-	if (!atomic_read(&ctx->irq_cnt)) {
-		ql_write32(qdev, INTR_EN,
-		ctx->intr_dis_mask);
-		var = ql_read32(qdev, STS);
-	}
-	atomic_inc(&ctx->irq_cnt);
-	spin_unlock(&qdev->hw_lock);
-	return var;
+	ql_write32(qdev, INTR_EN, ctx->intr_dis_mask);
 }
 
 static void ql_enable_all_completion_interrupts(struct ql_adapter *qdev)
 {
 	int i;
-	for (i = 0; i < qdev->intr_count; i++) {
-		/* The enable call does a atomic_dec_and_test
-		 * and enables only if the result is zero.
-		 * So we precharge it here.
-		 */
-		if (unlikely(!test_bit(QL_MSIX_ENABLED, &qdev->flags) ||
-			i == 0))
-			atomic_set(&qdev->intr_context[i].irq_cnt, 1);
-		ql_enable_completion_interrupt(qdev, i);
-	}
 
+	for (i = 0; i < qdev->intr_count; i++)
+		ql_enable_completion_interrupt(qdev, i);
 }
 
 static int ql_validate_flash(struct ql_adapter *qdev, u32 size, const char *str)
@@ -2500,21 +2451,22 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 	u32 var;
 	int work_done = 0;
 
-	spin_lock(&qdev->hw_lock);
-	if (atomic_read(&qdev->intr_context[0].irq_cnt)) {
-		netif_printk(qdev, intr, KERN_DEBUG, qdev->ndev,
-			     "Shared Interrupt, Not ours!\n");
-		spin_unlock(&qdev->hw_lock);
-		return IRQ_NONE;
-	}
-	spin_unlock(&qdev->hw_lock);
+	/* Experience shows that when using INTx interrupts, interrupts must
+	 * be masked manually.
+	 * When using MSI mode, INTR_EN_EN must be explicitly disabled
+	 * (even though it is auto-masked), otherwise a later command to
+	 * enable it is not effective.
+	 */
+	if (!test_bit(QL_MSIX_ENABLED, &qdev->flags))
+		ql_disable_completion_interrupt(qdev, 0);
 
-	var = ql_disable_completion_interrupt(qdev, intr_context->intr);
+	var = ql_read32(qdev, STS);
 
 	/*
 	 * Check for fatal error.
 	 */
 	if (var & STS_FE) {
+		ql_disable_completion_interrupt(qdev, 0);
 		ql_queue_asic_error(qdev);
 		netdev_err(qdev->ndev, "Got fatal error, STS = %x.\n", var);
 		var = ql_read32(qdev, ERR_STS);
@@ -2534,7 +2486,6 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 		 */
 		netif_err(qdev, intr, qdev->ndev,
 			  "Got MPI processor interrupt.\n");
-		ql_disable_completion_interrupt(qdev, intr_context->intr);
 		ql_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));
 		queue_delayed_work_on(smp_processor_id(),
 				qdev->workqueue, &qdev->mpi_work, 0);
@@ -2550,11 +2501,18 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 	if (var & intr_context->irq_mask) {
 		netif_info(qdev, intr, qdev->ndev,
 			   "Waking handler for rx_ring[0].\n");
-		ql_disable_completion_interrupt(qdev, intr_context->intr);
 		napi_schedule(&rx_ring->napi);
 		work_done++;
+	} else {
+		/* Experience shows that the device sometimes signals an
+		 * interrupt but no work is scheduled from this function.
+		 * Nevertheless, the interrupt is auto-masked. Therefore, we
+		 * systematically re-enable the interrupt if we didn't
+		 * schedule napi.
+		 */
+		ql_enable_completion_interrupt(qdev, 0);
 	}
-	ql_enable_completion_interrupt(qdev, intr_context->intr);
+
 	return work_done ? IRQ_HANDLED : IRQ_NONE;
 }
 
@@ -3568,7 +3526,6 @@ static int ql_request_irq(struct ql_adapter *qdev)
 	ql_resolve_queues_to_irqs(qdev);
 
 	for (i = 0; i < qdev->intr_count; i++, intr_context++) {
-		atomic_set(&intr_context->irq_cnt, 0);
 		if (test_bit(QL_MSIX_ENABLED, &qdev->flags)) {
 			status = request_irq(qdev->msi_x_entry[i].vector,
 					     intr_context->handler,
@@ -4653,7 +4610,6 @@ static int ql_init_device(struct pci_dev *pdev, struct net_device *ndev,
 		goto err_out2;
 	}
 	qdev->msg_enable = netif_msg_init(debug, default_msg);
-	spin_lock_init(&qdev->hw_lock);
 	spin_lock_init(&qdev->stats_lock);
 
 	if (qlge_mpi_coredump) {
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index 957c72985a06..9e422bbbb6ab 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -1257,7 +1257,6 @@ void ql_mpi_work(struct work_struct *work)
 	/* End polled mode for MPI */
 	ql_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16) | INTR_MASK_PI);
 	mutex_unlock(&qdev->mpi_mutex);
-	ql_enable_completion_interrupt(qdev, 0);
 }
 
 void ql_mpi_reset_work(struct work_struct *work)
-- 
2.23.0

