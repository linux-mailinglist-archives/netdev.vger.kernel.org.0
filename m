Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AADD6829F2
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjAaKH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbjAaKHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:07:22 -0500
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9541F366A2
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 02:07:16 -0800 (PST)
X-QQ-mid: bizesmtp69t1675159561tqn9k58m
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 31 Jan 2023 18:05:55 +0800 (CST)
X-QQ-SSF: 01400000000000M0O000000A0000000
X-QQ-FEAT: bNBJYFvbx27tMy6xlSPV0NE6Lhxm3+tUSLr4vVdgnSZy9WYFOy5B8uJ/O4NAU
        ZAZc+gAF3Imu0Uhn9oXPSUoC1IoCHDgvoUW5HXzOSgPag3pHqVJqJKIJ7P8bgdV1o79nTix
        1d8u7z4ROxDInR5cCDdJwWSFFTbu48Yq3PF/xp8aKgfVhUDZY9tT3EoMXX1GvX3c5gsLLcu
        qbgVOct1kMo14yYq/zKMe2y31OFr8M+frZ1bd1xSicTmgfbc2xYVOjJGu/Q3xswMElHJ+4j
        +5wzqRhh/Wm0UKPzV8mIHQFNL/xumz6LslINttl5BdO/cNy+jlgfonCv3jRi3Mp38tuYpvV
        Gv7En/zZgnSBZcBZLhF8wPk/ETNbQD7j2jFm42cCDn2lfdPczSr0wFglYNsJHoaQFshdJbA
        tT6jksQTxP1Mylbh9ojRIQ==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v2 01/10] net: libwx: Add irq flow functions
Date:   Tue, 31 Jan 2023 18:05:32 +0800
Message-Id: <20230131100541.73757-2-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131100541.73757-1-mengyuanlou@net-swift.com>
References: <20230131100541.73757-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add irq flow functions for ngbe and txgbe.
Alloc pcie msix irqs for drivers, otherwise fall back to msi/legacy.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/Makefile  |   2 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.c   |  55 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h   |   3 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c  | 613 +++++++++++++++++++
 drivers/net/ethernet/wangxun/libwx/wx_lib.h  |  20 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h | 102 +++
 6 files changed, 793 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_lib.c
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_lib.h

diff --git a/drivers/net/ethernet/wangxun/libwx/Makefile b/drivers/net/ethernet/wangxun/libwx/Makefile
index 1ed5e23af944..850d1615cd18 100644
--- a/drivers/net/ethernet/wangxun/libwx/Makefile
+++ b/drivers/net/ethernet/wangxun/libwx/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_LIBWX) += libwx.o
 
-libwx-objs := wx_hw.o
+libwx-objs := wx_hw.o wx_lib.o
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 3d7ba0c0df38..a72b02c72189 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -14,7 +14,7 @@ static void wx_intr_disable(struct wx *wx, u64 qmask)
 {
 	u32 mask;
 
-	mask = (qmask & 0xFFFFFFFF);
+	mask = (qmask & U32_MAX);
 	if (mask)
 		wr32(wx, WX_PX_IMS(0), mask);
 
@@ -25,6 +25,45 @@ static void wx_intr_disable(struct wx *wx, u64 qmask)
 	}
 }
 
+void wx_intr_enable(struct wx *wx, u64 qmask)
+{
+	u32 mask;
+
+	mask = (qmask & U32_MAX);
+	if (mask)
+		wr32(wx, WX_PX_IMC(0), mask);
+	if (wx->mac.type == wx_mac_sp) {
+		mask = (qmask >> 32);
+		if (mask)
+			wr32(wx, WX_PX_IMC(1), mask);
+	}
+}
+EXPORT_SYMBOL(wx_intr_enable);
+
+/**
+ * wx_irq_disable - Mask off interrupt generation on the NIC
+ * @wx: board private structure
+ **/
+void wx_irq_disable(struct wx *wx)
+{
+	struct pci_dev *pdev = wx->pdev;
+
+	wr32(wx, WX_PX_MISC_IEN, 0);
+	wx_intr_disable(wx, WX_INTR_ALL);
+
+	if (pdev->msix_enabled) {
+		int vector;
+
+		for (vector = 0; vector < wx->num_q_vectors; vector++)
+			synchronize_irq(wx->msix_entries[vector].vector);
+
+		synchronize_irq(wx->msix_entries[vector].vector);
+	} else {
+		synchronize_irq(pdev->irq);
+	}
+}
+EXPORT_SYMBOL(wx_irq_disable);
+
 /* cmd_addr is used for some special command:
  * 1. to be sector address, when implemented erase sector command
  * 2. to be flash address when implemented read, write flash address
@@ -844,6 +883,20 @@ void wx_disable_rx(struct wx *wx)
 }
 EXPORT_SYMBOL(wx_disable_rx);
 
+static void wx_configure_isb(struct wx *wx)
+{
+	/* set ISB Address */
+	wr32(wx, WX_PX_ISB_ADDR_L, wx->isb_dma & DMA_BIT_MASK(32));
+	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
+		wr32(wx, WX_PX_ISB_ADDR_H, wx->isb_dma >> 32);
+}
+
+void wx_configure(struct wx *wx)
+{
+	wx_configure_isb(wx);
+}
+EXPORT_SYMBOL(wx_configure);
+
 /**
  *  wx_disable_pcie_master - Disable PCI-express master access
  *  @wx: pointer to hardware structure
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.h b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
index 803983546f3a..60bda129cfa6 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
@@ -4,6 +4,8 @@
 #ifndef _WX_HW_H_
 #define _WX_HW_H_
 
+void wx_intr_enable(struct wx *wx, u64 qmask);
+void wx_irq_disable(struct wx *wx);
 int wx_check_flash_load(struct wx *wx, u32 check_bit);
 void wx_control_hw(struct wx *wx, bool drv);
 int wx_mng_present(struct wx *wx);
@@ -20,6 +22,7 @@ void wx_mac_set_default_filter(struct wx *wx, u8 *addr);
 void wx_flush_sw_mac_table(struct wx *wx);
 int wx_set_mac(struct net_device *netdev, void *p);
 void wx_disable_rx(struct wx *wx);
+void wx_configure(struct wx *wx);
 int wx_disable_pcie_master(struct wx *wx);
 int wx_stop_adapter(struct wx *wx);
 void wx_reset_misc(struct wx *wx);
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
new file mode 100644
index 000000000000..76711087c184
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -0,0 +1,613 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/etherdevice.h>
+#include <linux/iopoll.h>
+#include <linux/pci.h>
+
+#include "wx_type.h"
+#include "wx_lib.h"
+
+/**
+ * wx_poll - NAPI polling RX/TX cleanup routine
+ * @napi: napi struct with our devices info in it
+ * @budget: amount of work driver is allowed to do this pass, in packets
+ *
+ * This function will clean all queues associated with a q_vector.
+ **/
+static int wx_poll(struct napi_struct *napi, int budget)
+{
+	return 0;
+}
+
+/**
+ * wx_set_rss_queues: Allocate queues for RSS
+ * @wx: board private structure to initialize
+ *
+ * This is our "base" multiqueue mode.  RSS (Receive Side Scaling) will try
+ * to allocate one Rx queue per CPU, and if available, one Tx queue per CPU.
+ *
+ **/
+static void wx_set_rss_queues(struct wx *wx)
+{
+	wx->num_rx_queues = wx->mac.max_rx_queues;
+	wx->num_tx_queues = wx->mac.max_tx_queues;
+}
+
+static void wx_set_num_queues(struct wx *wx)
+{
+	/* Start with base case */
+	wx->num_rx_queues = 1;
+	wx->num_tx_queues = 1;
+	wx->queues_per_pool = 1;
+
+	wx_set_rss_queues(wx);
+}
+
+/**
+ * wx_acquire_msix_vectors - acquire MSI-X vectors
+ * @wx: board private structure
+ *
+ * Attempts to acquire a suitable range of MSI-X vector interrupts. Will
+ * return a negative error code if unable to acquire MSI-X vectors for any
+ * reason.
+ */
+static int wx_acquire_msix_vectors(struct wx *wx)
+{
+	struct irq_affinity affd = {0, };
+	int nvecs, i;
+
+	nvecs = min_t(int, num_online_cpus(), wx->mac.max_msix_vectors);
+
+	wx->msix_entries = kcalloc(nvecs,
+				   sizeof(struct msix_entry),
+				   GFP_KERNEL);
+	if (!wx->msix_entries)
+		return -ENOMEM;
+
+	nvecs = pci_alloc_irq_vectors_affinity(wx->pdev, nvecs,
+					       nvecs,
+					       PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
+					       &affd);
+	if (nvecs < 0) {
+		wx_err(wx, "Failed to allocate MSI-X interrupts. Err: %d\n", nvecs);
+		kfree(wx->msix_entries);
+		wx->msix_entries = NULL;
+		return nvecs;
+	}
+
+	for (i = 0; i < nvecs; i++) {
+		wx->msix_entries[i].entry = i;
+		wx->msix_entries[i].vector = pci_irq_vector(wx->pdev, i);
+	}
+
+	/* one for msix_other */
+	nvecs -= 1;
+	wx->num_q_vectors = nvecs;
+	wx->num_rx_queues = nvecs;
+	wx->num_tx_queues = nvecs;
+
+	return 0;
+}
+
+/**
+ * wx_set_interrupt_capability - set MSI-X or MSI if supported
+ * @wx: board private structure to initialize
+ *
+ * Attempt to configure the interrupts using the best available
+ * capabilities of the hardware and the kernel.
+ **/
+static int wx_set_interrupt_capability(struct wx *wx)
+{
+	struct pci_dev *pdev = wx->pdev;
+	int nvecs, ret;
+
+	/* We will try to get MSI-X interrupts first */
+	ret = wx_acquire_msix_vectors(wx);
+	if (ret == 0 || (ret == -ENOMEM))
+		return ret;
+
+	wx->num_rx_queues = 1;
+	wx->num_tx_queues = 1;
+	wx->num_q_vectors = 1;
+
+	/* minmum one for queue, one for misc*/
+	nvecs = 1;
+	nvecs = pci_alloc_irq_vectors(pdev, nvecs,
+				      nvecs, PCI_IRQ_MSI | PCI_IRQ_LEGACY);
+	if (nvecs == 1) {
+		if (pdev->msi_enabled)
+			wx_err(wx, "Fallback to MSI.\n");
+		else
+			wx_err(wx, "Fallback to LEGACY.\n");
+	} else {
+		wx_err(wx, "Failed to allocate MSI/LEGACY interrupts. Error: %d\n", nvecs);
+		return nvecs;
+	}
+
+	pdev->irq = pci_irq_vector(pdev, 0);
+
+	return 0;
+}
+
+/**
+ * wx_cache_ring_rss - Descriptor ring to register mapping for RSS
+ * @wx: board private structure to initialize
+ *
+ * Cache the descriptor ring offsets for RSS, ATR, FCoE, and SR-IOV.
+ *
+ **/
+static void wx_cache_ring_rss(struct wx *wx)
+{
+	u16 i;
+
+	for (i = 0; i < wx->num_rx_queues; i++)
+		wx->rx_ring[i]->reg_idx = i;
+
+	for (i = 0; i < wx->num_tx_queues; i++)
+		wx->tx_ring[i]->reg_idx = i;
+}
+
+static void wx_add_ring(struct wx_ring *ring, struct wx_ring_container *head)
+{
+	ring->next = head->ring;
+	head->ring = ring;
+	head->count++;
+}
+
+/**
+ * wx_alloc_q_vector - Allocate memory for a single interrupt vector
+ * @wx: board private structure to initialize
+ * @v_count: q_vectors allocated on wx, used for ring interleaving
+ * @v_idx: index of vector in wx struct
+ * @txr_count: total number of Tx rings to allocate
+ * @txr_idx: index of first Tx ring to allocate
+ * @rxr_count: total number of Rx rings to allocate
+ * @rxr_idx: index of first Rx ring to allocate
+ *
+ * We allocate one q_vector.  If allocation fails we return -ENOMEM.
+ **/
+static int wx_alloc_q_vector(struct wx *wx,
+			     unsigned int v_count, unsigned int v_idx,
+			     unsigned int txr_count, unsigned int txr_idx,
+			     unsigned int rxr_count, unsigned int rxr_idx)
+{
+	struct wx_q_vector *q_vector;
+	int ring_count, default_itr;
+	struct wx_ring *ring;
+
+	/* note this will allocate space for the ring structure as well! */
+	ring_count = txr_count + rxr_count;
+
+	q_vector = kzalloc(struct_size(q_vector, ring, ring_count),
+			   GFP_KERNEL);
+	if (!q_vector)
+		return -ENOMEM;
+
+	/* initialize NAPI */
+	netif_napi_add(wx->netdev, &q_vector->napi,
+		       wx_poll);
+
+	/* tie q_vector and wx together */
+	wx->q_vector[v_idx] = q_vector;
+	q_vector->wx = wx;
+	q_vector->v_idx = v_idx;
+
+	/* initialize work limits */
+	q_vector->tx.work_limit = wx->tx_work_limit;
+	q_vector->rx.work_limit = wx->rx_work_limit;
+
+	/* initialize pointer to rings */
+	ring = q_vector->ring;
+
+	if (wx->mac.type == wx_mac_sp)
+		default_itr = WX_12K_ITR;
+	else
+		default_itr = WX_7K_ITR;
+	/* initialize ITR */
+	if (txr_count && !rxr_count)
+		/* tx only vector */
+		q_vector->itr = wx->tx_itr_setting ?
+				default_itr : wx->tx_itr_setting;
+	else
+		/* rx or rx/tx vector */
+		q_vector->itr = wx->rx_itr_setting ?
+				default_itr : wx->rx_itr_setting;
+
+	while (txr_count) {
+		/* assign generic ring traits */
+		ring->dev = &wx->pdev->dev;
+		ring->netdev = wx->netdev;
+
+		/* configure backlink on ring */
+		ring->q_vector = q_vector;
+
+		/* update q_vector Tx values */
+		wx_add_ring(ring, &q_vector->tx);
+
+		/* apply Tx specific ring traits */
+		ring->count = wx->tx_ring_count;
+
+		ring->queue_index = txr_idx;
+
+		/* assign ring to wx */
+		wx->tx_ring[txr_idx] = ring;
+
+		/* update count and index */
+		txr_count--;
+		txr_idx += v_count;
+
+		/* push pointer to next ring */
+		ring++;
+	}
+
+	while (rxr_count) {
+		/* assign generic ring traits */
+		ring->dev = &wx->pdev->dev;
+		ring->netdev = wx->netdev;
+
+		/* configure backlink on ring */
+		ring->q_vector = q_vector;
+
+		/* update q_vector Rx values */
+		wx_add_ring(ring, &q_vector->rx);
+
+		/* apply Rx specific ring traits */
+		ring->count = wx->rx_ring_count;
+		ring->queue_index = rxr_idx;
+
+		/* assign ring to wx */
+		wx->rx_ring[rxr_idx] = ring;
+
+		/* update count and index */
+		rxr_count--;
+		rxr_idx += v_count;
+
+		/* push pointer to next ring */
+		ring++;
+	}
+
+	return 0;
+}
+
+/**
+ * wx_free_q_vector - Free memory allocated for specific interrupt vector
+ * @wx: board private structure to initialize
+ * @v_idx: Index of vector to be freed
+ *
+ * This function frees the memory allocated to the q_vector.  In addition if
+ * NAPI is enabled it will delete any references to the NAPI struct prior
+ * to freeing the q_vector.
+ **/
+static void wx_free_q_vector(struct wx *wx, int v_idx)
+{
+	struct wx_q_vector *q_vector = wx->q_vector[v_idx];
+	struct wx_ring *ring;
+
+	wx_for_each_ring(ring, q_vector->tx)
+		wx->tx_ring[ring->queue_index] = NULL;
+
+	wx_for_each_ring(ring, q_vector->rx)
+		wx->rx_ring[ring->queue_index] = NULL;
+
+	wx->q_vector[v_idx] = NULL;
+	netif_napi_del(&q_vector->napi);
+	kfree_rcu(q_vector, rcu);
+}
+
+/**
+ * wx_alloc_q_vectors - Allocate memory for interrupt vectors
+ * @wx: board private structure to initialize
+ *
+ * We allocate one q_vector per queue interrupt.  If allocation fails we
+ * return -ENOMEM.
+ **/
+static int wx_alloc_q_vectors(struct wx *wx)
+{
+	unsigned int rxr_idx = 0, txr_idx = 0, v_idx = 0;
+	unsigned int rxr_remaining = wx->num_rx_queues;
+	unsigned int txr_remaining = wx->num_tx_queues;
+	unsigned int q_vectors = wx->num_q_vectors;
+	int rqpv, tqpv;
+	int err;
+
+	for (; v_idx < q_vectors; v_idx++) {
+		rqpv = DIV_ROUND_UP(rxr_remaining, q_vectors - v_idx);
+		tqpv = DIV_ROUND_UP(txr_remaining, q_vectors - v_idx);
+		err = wx_alloc_q_vector(wx, q_vectors, v_idx,
+					tqpv, txr_idx,
+					rqpv, rxr_idx);
+
+		if (err)
+			goto err_out;
+
+		/* update counts and index */
+		rxr_remaining -= rqpv;
+		txr_remaining -= tqpv;
+		rxr_idx++;
+		txr_idx++;
+	}
+
+	return 0;
+
+err_out:
+	wx->num_tx_queues = 0;
+	wx->num_rx_queues = 0;
+	wx->num_q_vectors = 0;
+
+	while (v_idx--)
+		wx_free_q_vector(wx, v_idx);
+
+	return -ENOMEM;
+}
+
+/**
+ * wx_free_q_vectors - Free memory allocated for interrupt vectors
+ * @wx: board private structure to initialize
+ *
+ * This function frees the memory allocated to the q_vectors.  In addition if
+ * NAPI is enabled it will delete any references to the NAPI struct prior
+ * to freeing the q_vector.
+ **/
+static void wx_free_q_vectors(struct wx *wx)
+{
+	int v_idx = wx->num_q_vectors;
+
+	wx->num_tx_queues = 0;
+	wx->num_rx_queues = 0;
+	wx->num_q_vectors = 0;
+
+	while (v_idx--)
+		wx_free_q_vector(wx, v_idx);
+}
+
+void wx_reset_interrupt_capability(struct wx *wx)
+{
+	struct pci_dev *pdev = wx->pdev;
+
+	if (!pdev->msi_enabled && !pdev->msix_enabled)
+		return;
+
+	pci_free_irq_vectors(wx->pdev);
+	if (pdev->msix_enabled) {
+		kfree(wx->msix_entries);
+		wx->msix_entries = NULL;
+	}
+}
+EXPORT_SYMBOL(wx_reset_interrupt_capability);
+
+/**
+ * wx_clear_interrupt_scheme - Clear the current interrupt scheme settings
+ * @wx: board private structure to clear interrupt scheme on
+ *
+ * We go through and clear interrupt specific resources and reset the structure
+ * to pre-load conditions
+ **/
+void wx_clear_interrupt_scheme(struct wx *wx)
+{
+	wx_free_q_vectors(wx);
+	wx_reset_interrupt_capability(wx);
+}
+EXPORT_SYMBOL(wx_clear_interrupt_scheme);
+
+int wx_init_interrupt_scheme(struct wx *wx)
+{
+	int ret;
+
+	/* Number of supported queues */
+	wx_set_num_queues(wx);
+
+	/* Set interrupt mode */
+	ret = wx_set_interrupt_capability(wx);
+	if (ret) {
+		wx_err(wx, "Allocate irq vectors for failed.\n");
+		return ret;
+	}
+
+	/* Allocate memory for queues */
+	ret = wx_alloc_q_vectors(wx);
+	if (ret) {
+		wx_err(wx, "Unable to allocate memory for queue vectors.\n");
+		wx_reset_interrupt_capability(wx);
+		return ret;
+	}
+
+	wx_cache_ring_rss(wx);
+
+	return 0;
+}
+EXPORT_SYMBOL(wx_init_interrupt_scheme);
+
+irqreturn_t wx_msix_clean_rings(int __always_unused irq, void *data)
+{
+	struct wx_q_vector *q_vector = data;
+
+	/* EIAM disabled interrupts (on this vector) for us */
+	if (q_vector->rx.ring || q_vector->tx.ring)
+		napi_schedule_irqoff(&q_vector->napi);
+
+	return IRQ_HANDLED;
+}
+EXPORT_SYMBOL(wx_msix_clean_rings);
+
+void wx_free_irq(struct wx *wx)
+{
+	struct pci_dev *pdev = wx->pdev;
+	int vector;
+
+	if (!(pdev->msix_enabled)) {
+		free_irq(pdev->irq, wx);
+		return;
+	}
+
+	for (vector = 0; vector < wx->num_q_vectors; vector++) {
+		struct wx_q_vector *q_vector = wx->q_vector[vector];
+		struct msix_entry *entry = &wx->msix_entries[vector];
+
+		/* free only the irqs that were actually requested */
+		if (!q_vector->rx.ring && !q_vector->tx.ring)
+			continue;
+
+		free_irq(entry->vector, q_vector);
+	}
+
+	free_irq(wx->msix_entries[vector].vector, wx);
+}
+EXPORT_SYMBOL(wx_free_irq);
+
+/**
+ * wx_setup_isb_resources - allocate interrupt status resources
+ * @wx: board private structure
+ *
+ * Return 0 on success, negative on failure
+ **/
+int wx_setup_isb_resources(struct wx *wx)
+{
+	struct pci_dev *pdev = wx->pdev;
+
+	wx->isb_mem = dma_alloc_coherent(&pdev->dev,
+					 sizeof(u32) * 4,
+					 &wx->isb_dma,
+					 GFP_KERNEL);
+	if (!wx->isb_mem) {
+		wx_err(wx, "Alloc isb_mem failed\n");
+		return -ENOMEM;
+	}
+	memset(wx->isb_mem, 0, sizeof(u32) * 4);
+	return 0;
+}
+EXPORT_SYMBOL(wx_setup_isb_resources);
+
+/**
+ * wx_free_isb_resources - allocate all queues Rx resources
+ * @wx: board private structure
+ *
+ * Return 0 on success, negative on failure
+ **/
+void wx_free_isb_resources(struct wx *wx)
+{
+	struct pci_dev *pdev = wx->pdev;
+
+	dma_free_coherent(&pdev->dev, sizeof(u32) * 4,
+			  wx->isb_mem, wx->isb_dma);
+	wx->isb_mem = NULL;
+}
+EXPORT_SYMBOL(wx_free_isb_resources);
+
+u32 wx_misc_isb(struct wx *wx, enum wx_isb_idx idx)
+{
+	u32 cur_tag = 0;
+
+	cur_tag = wx->isb_mem[WX_ISB_HEADER];
+	wx->isb_tag[idx] = cur_tag;
+
+	return (__force u32)cpu_to_le32(wx->isb_mem[idx]);
+}
+EXPORT_SYMBOL(wx_misc_isb);
+
+/**
+ * wx_set_ivar - set the IVAR registers, mapping interrupt causes to vectors
+ * @wx: pointer to wx struct
+ * @direction: 0 for Rx, 1 for Tx, -1 for other causes
+ * @queue: queue to map the corresponding interrupt to
+ * @msix_vector: the vector to map to the corresponding queue
+ *
+ **/
+static void wx_set_ivar(struct wx *wx, s8 direction,
+			u16 queue, u16 msix_vector)
+{
+	u32 ivar, index;
+
+	if (direction == -1) {
+		/* other causes */
+		msix_vector |= WX_PX_IVAR_ALLOC_VAL;
+		index = 0;
+		ivar = rd32(wx, WX_PX_MISC_IVAR);
+		ivar &= ~(0xFF << index);
+		ivar |= (msix_vector << index);
+		wr32(wx, WX_PX_MISC_IVAR, ivar);
+	} else {
+		/* tx or rx causes */
+		msix_vector |= WX_PX_IVAR_ALLOC_VAL;
+		index = ((16 * (queue & 1)) + (8 * direction));
+		ivar = rd32(wx, WX_PX_IVAR(queue >> 1));
+		ivar &= ~(0xFF << index);
+		ivar |= (msix_vector << index);
+		wr32(wx, WX_PX_IVAR(queue >> 1), ivar);
+	}
+}
+
+/**
+ * wx_write_eitr - write EITR register in hardware specific way
+ * @q_vector: structure containing interrupt and ring information
+ *
+ * This function is made to be called by ethtool and by the driver
+ * when it needs to update EITR registers at runtime.  Hardware
+ * specific quirks/differences are taken care of here.
+ */
+static void wx_write_eitr(struct wx_q_vector *q_vector)
+{
+	struct wx *wx = q_vector->wx;
+	int v_idx = q_vector->v_idx;
+	u32 itr_reg;
+
+	if (wx->mac.type == wx_mac_sp)
+		itr_reg = q_vector->itr & WX_SP_MAX_EITR;
+	else
+		itr_reg = q_vector->itr & WX_EM_MAX_EITR;
+
+	itr_reg |= WX_PX_ITR_CNT_WDIS;
+
+	wr32(wx, WX_PX_ITR(v_idx), itr_reg);
+}
+
+/**
+ * wx_configure_vectors - Configure vectors for hardware
+ * @wx: board private structure
+ *
+ * wx_configure_vectors sets up the hardware to properly generate MSI-X/MSI/LEGACY
+ * interrupts.
+ **/
+void wx_configure_vectors(struct wx *wx)
+{
+	struct pci_dev *pdev = wx->pdev;
+	u32 eitrsel = 0;
+	u16 v_idx;
+
+	if (pdev->msix_enabled) {
+		/* Populate MSIX to EITR Select */
+		wr32(wx, WX_PX_ITRSEL, eitrsel);
+		/* use EIAM to auto-mask when MSI-X interrupt is asserted
+		 * this saves a register write for every interrupt
+		 */
+		wr32(wx, WX_PX_GPIE, WX_PX_GPIE_MODEL);
+	} else {
+		/* legacy interrupts, use EIAM to auto-mask when reading EICR,
+		 * specifically only auto mask tx and rx interrupts.
+		 */
+		wr32(wx, WX_PX_GPIE, 0);
+	}
+
+	/* Populate the IVAR table and set the ITR values to the
+	 * corresponding register.
+	 */
+	for (v_idx = 0; v_idx < wx->num_q_vectors; v_idx++) {
+		struct wx_q_vector *q_vector = wx->q_vector[v_idx];
+		struct wx_ring *ring;
+
+		wx_for_each_ring(ring, q_vector->rx)
+			wx_set_ivar(wx, 0, ring->reg_idx, v_idx);
+
+		wx_for_each_ring(ring, q_vector->tx)
+			wx_set_ivar(wx, 1, ring->reg_idx, v_idx);
+
+		wx_write_eitr(q_vector);
+	}
+
+	wx_set_ivar(wx, -1, 0, v_idx);
+	if (pdev->msix_enabled)
+		wr32(wx, WX_PX_ITR(v_idx), 1950);
+}
+EXPORT_SYMBOL(wx_configure_vectors);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.h b/drivers/net/ethernet/wangxun/libwx/wx_lib.h
new file mode 100644
index 000000000000..8ae657155f34
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * WangXun Gigabit PCI Express Linux driver
+ * Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd.
+ */
+
+#ifndef _WX_LIB_H_
+#define _WX_LIB_H_
+
+void wx_reset_interrupt_capability(struct wx *wx);
+void wx_clear_interrupt_scheme(struct wx *wx);
+int wx_init_interrupt_scheme(struct wx *wx);
+irqreturn_t wx_msix_clean_rings(int __always_unused irq, void *data);
+void wx_free_irq(struct wx *wx);
+int wx_setup_isb_resources(struct wx *wx);
+void wx_free_isb_resources(struct wx *wx);
+u32 wx_misc_isb(struct wx *wx, enum wx_isb_idx idx);
+void wx_configure_vectors(struct wx *wx);
+
+#endif /* _NGBE_LIB_H_ */
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index c86a37914d43..7368c681221f 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -5,6 +5,7 @@
 #define _WX_TYPE_H_
 
 #include <linux/bitfield.h>
+#include <linux/netdevice.h>
 
 /* Vendor ID */
 #ifndef PCI_VENDOR_ID_WANGXUN
@@ -66,6 +67,22 @@
 #define WX_CFG_PORT_CTL              0x14400
 #define WX_CFG_PORT_CTL_DRV_LOAD     BIT(3)
 
+/* GPIO Registers */
+#define WX_GPIO_DR                   0x14800
+#define WX_GPIO_DR_0                 BIT(0) /* SDP0 Data Value */
+#define WX_GPIO_DR_1                 BIT(1) /* SDP1 Data Value */
+#define WX_GPIO_DDR                  0x14804
+#define WX_GPIO_DDR_0                BIT(0) /* SDP0 IO direction */
+#define WX_GPIO_DDR_1                BIT(1) /* SDP1 IO direction */
+#define WX_GPIO_CTL                  0x14808
+#define WX_GPIO_INTEN                0x14830
+#define WX_GPIO_INTEN_0              BIT(0)
+#define WX_GPIO_INTEN_1              BIT(1)
+#define WX_GPIO_INTMASK              0x14834
+#define WX_GPIO_INTTYPE_LEVEL        0x14838
+#define WX_GPIO_POLARITY             0x1483C
+#define WX_GPIO_EOI                  0x1484C
+
 /*********************** Transmit DMA registers **************************/
 /* transmit global control */
 #define WX_TDM_CTL                   0x18000
@@ -151,8 +168,28 @@
 /* Interrupt Registers */
 #define WX_BME_CTL                   0x12020
 #define WX_PX_MISC_IC                0x100
+#define WX_PX_MISC_ICS               0x104
+#define WX_PX_MISC_IEN               0x108
+#define WX_PX_INTA                   0x110
+#define WX_PX_GPIE                   0x118
+#define WX_PX_GPIE_MODEL             BIT(0)
+#define WX_PX_IC                     0x120
 #define WX_PX_IMS(_i)                (0x140 + (_i) * 4)
+#define WX_PX_IMC(_i)                (0x150 + (_i) * 4)
+#define WX_PX_ISB_ADDR_L             0x160
+#define WX_PX_ISB_ADDR_H             0x164
 #define WX_PX_TRANSACTION_PENDING    0x168
+#define WX_PX_ITRSEL                 0x180
+#define WX_PX_ITR(_i)                (0x200 + (_i) * 4)
+#define WX_PX_ITR_CNT_WDIS           BIT(31)
+#define WX_PX_MISC_IVAR              0x4FC
+#define WX_PX_IVAR(_i)               (0x500 + (_i) * 4)
+
+#define WX_PX_IVAR_ALLOC_VAL         0x80 /* Interrupt Allocation valid */
+#define WX_7K_ITR                    595
+#define WX_12K_ITR                   336
+#define WX_SP_MAX_EITR               0x00000FF8U
+#define WX_EM_MAX_EITR               0x00007FFCU
 
 /* transmit DMA Registers */
 #define WX_PX_TR_CFG(_i)             (0x03010 + ((_i) * 0x40))
@@ -312,6 +349,59 @@ enum wx_reset_type {
 	WX_GLOBAL_RESET
 };
 
+/* iterator for handling rings in ring container */
+#define wx_for_each_ring(posm, headm) \
+	for (posm = (headm).ring; posm; posm = posm->next)
+
+struct wx_ring_container {
+	struct wx_ring *ring;           /* pointer to linked list of rings */
+	u16 work_limit;                 /* total work allowed per interrupt */
+	u8 count;                       /* total number of rings in vector */
+	u8 itr;                         /* current ITR setting for ring */
+};
+
+struct wx_ring {
+	struct wx_ring *next;           /* pointer to next ring in q_vector */
+	struct wx_q_vector *q_vector;   /* backpointer to host q_vector */
+	struct net_device *netdev;      /* netdev ring belongs to */
+	struct device *dev;             /* device for DMA mapping */
+
+	u16 count;                      /* amount of descriptors */
+
+	u8 queue_index; /* needed for multiqueue queue management */
+	u8 reg_idx;                     /* holds the special value that gets
+					 * the hardware register offset
+					 * associated with this ring, which is
+					 * different for DCB and RSS modes
+					 */
+} ____cacheline_internodealigned_in_smp;
+
+struct wx_q_vector {
+	struct wx *wx;
+	int cpu;        /* CPU for DCA */
+	u16 v_idx;      /* index of q_vector within array, also used for
+			 * finding the bit in EICR and friends that
+			 * represents the vector for this ring
+			 */
+	u16 itr;        /* Interrupt throttle rate written to EITR */
+	struct wx_ring_container rx, tx;
+	struct napi_struct napi;
+	struct rcu_head rcu;    /* to avoid race with update stats on free */
+
+	char name[IFNAMSIZ + 17];
+
+	/* for dynamic allocation of rings associated with this q_vector */
+	struct wx_ring ring[0] ____cacheline_internodealigned_in_smp;
+};
+
+enum wx_isb_idx {
+	WX_ISB_HEADER,
+	WX_ISB_MISC,
+	WX_ISB_VEC0,
+	WX_ISB_VEC1,
+	WX_ISB_MAX
+};
+
 struct wx {
 	u8 __iomem *hw_addr;
 	struct pci_dev *pdev;
@@ -360,6 +450,18 @@ struct wx {
 	u32 tx_ring_count;
 	u32 rx_ring_count;
 
+	struct wx_ring *tx_ring[64] ____cacheline_aligned_in_smp;
+	struct wx_ring *rx_ring[64];
+	struct wx_q_vector *q_vector[64];
+
+	unsigned int queues_per_pool;
+	struct msix_entry *msix_entries;
+
+	/* misc interrupt status block */
+	dma_addr_t isb_dma;
+	u32 *isb_mem;
+	u32 isb_tag[WX_ISB_MAX];
+
 #define WX_MAX_RETA_ENTRIES 128
 	u8 rss_indir_tbl[WX_MAX_RETA_ENTRIES];
 
-- 
2.39.1

