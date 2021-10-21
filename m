Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F165F436C28
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 22:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhJUUcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 16:32:50 -0400
Received: from mga05.intel.com ([192.55.52.43]:46172 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232139AbhJUUcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 16:32:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="315343868"
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="315343868"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:24 -0700
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="527625092"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:23 -0700
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH 08/14] net: wwan: t7xx: Add data path interface
Date:   Thu, 21 Oct 2021 13:27:32 -0700
Message-Id: <20211021202738.729-9-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Data Path Modem AP Interface (DPMAIF) HIF layer provides methods
for initialization, ISR, control and event handling of TX/RX flows.

DPMAIF TX
Exposes the `dmpaif_tx_send_skb` function which can be used by the
network device to transmit packets.
The uplink data management uses a Descriptor Ring Buffer (DRB).
First DRB entry is a message type that will be followed by 1 or more
normal DRB entries. Message type DRB will hold the skb information
and each normal DRB entry holds a pointer to the skb payload.

DPMAIF RX
The downlink buffer management uses Buffer Address Table (BAT) and
Packet Information Table (PIT) rings.
The BAT ring holds the address of skb data buffer for the HW to use,
while the PIT contains metadata about a whole network packet including
a reference to the BAT entry holding the data buffer address.
The driver reads the PIT and BAT entries written by the modem, when
reaching a threshold, the driver will reload the PIT and BAT rings.

Signed-off-by: Haijun Lio <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/Makefile             |    4 +
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c    |  532 +++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h    |  270 ++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c | 1523 ++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h |  110 ++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c |  802 +++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.h |   74 +
 7 files changed, 3315 insertions(+)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.h

diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index 9b3cc4c5ebae..a2c97a66dfbe 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -14,3 +14,7 @@ mtk_t7xx-y:=	t7xx_pci.o \
 		t7xx_port_proxy.o  \
 		t7xx_port_ctrl_msg.o \
 		t7xx_port_wwan.o \
+		t7xx_dpmaif.o \
+		t7xx_hif_dpmaif.o  \
+		t7xx_hif_dpmaif_tx.o \
+		t7xx_hif_dpmaif_rx.o  \
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c
new file mode 100644
index 000000000000..69956c65eae4
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c
@@ -0,0 +1,532 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/sched.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+
+#include "t7xx_common.h"
+#include "t7xx_dpmaif.h"
+#include "t7xx_hif_dpmaif.h"
+#include "t7xx_hif_dpmaif_rx.h"
+#include "t7xx_hif_dpmaif_tx.h"
+#include "t7xx_pcie_mac.h"
+
+unsigned int ring_buf_get_next_wrdx(unsigned int buf_len, unsigned int buf_idx)
+{
+	buf_idx++;
+
+	return buf_idx < buf_len ? buf_idx : 0;
+}
+
+unsigned int ring_buf_read_write_count(unsigned int total_cnt, unsigned int rd_idx,
+				       unsigned int wrt_idx, bool rd_wrt)
+{
+	int pkt_cnt;
+
+	if (rd_wrt)
+		pkt_cnt = wrt_idx - rd_idx;
+	else
+		pkt_cnt = rd_idx - wrt_idx - 1;
+
+	if (pkt_cnt < 0)
+		pkt_cnt += total_cnt;
+
+	return (unsigned int)pkt_cnt;
+}
+
+static void dpmaif_enable_irq(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct dpmaif_isr_para *isr_para;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dpmaif_ctrl->isr_para); i++) {
+		isr_para = &dpmaif_ctrl->isr_para[i];
+		mtk_pcie_mac_set_int(dpmaif_ctrl->mtk_dev, isr_para->pcie_int);
+	}
+}
+
+static void dpmaif_disable_irq(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct dpmaif_isr_para *isr_para;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dpmaif_ctrl->isr_para); i++) {
+		isr_para = &dpmaif_ctrl->isr_para[i];
+		mtk_pcie_mac_clear_int(dpmaif_ctrl->mtk_dev, isr_para->pcie_int);
+	}
+}
+
+static void dpmaif_irq_cb(struct dpmaif_isr_para *isr_para)
+{
+	struct dpmaif_hw_intr_st_para intr_status;
+	struct dpmaif_ctrl *dpmaif_ctrl;
+	struct device *dev;
+	int i;
+
+	dpmaif_ctrl = isr_para->dpmaif_ctrl;
+	dev = dpmaif_ctrl->dev;
+	memset(&intr_status, 0, sizeof(intr_status));
+
+	/* gets HW interrupt types */
+	if (dpmaif_hw_get_interrupt_status(dpmaif_ctrl, &intr_status, isr_para->dlq_id) < 0) {
+		dev_err(dev, "Get HW interrupt status failed!\n");
+		return;
+	}
+
+	/* Clear level 1 interrupt status */
+	/* Clear level 2 DPMAIF interrupt status first,
+	 * then clear level 1 PCIe interrupt status
+	 * to avoid an empty interrupt.
+	 */
+	mtk_pcie_mac_clear_int_status(dpmaif_ctrl->mtk_dev, isr_para->pcie_int);
+
+	/* handles interrupts */
+	for (i = 0; i < intr_status.intr_cnt; i++) {
+		switch (intr_status.intr_types[i]) {
+		case DPF_INTR_UL_DONE:
+			dpmaif_irq_tx_done(dpmaif_ctrl, intr_status.intr_queues[i]);
+			break;
+
+		case DPF_INTR_UL_DRB_EMPTY:
+		case DPF_INTR_UL_MD_NOTREADY:
+		case DPF_INTR_UL_MD_PWR_NOTREADY:
+			/* no need to log an error for these cases. */
+			break;
+
+		case DPF_INTR_DL_BATCNT_LEN_ERR:
+			dev_err_ratelimited(dev, "DL interrupt: packet BAT count length error!\n");
+			dpmaif_unmask_dl_batcnt_len_err_interrupt(&dpmaif_ctrl->hif_hw_info);
+			break;
+
+		case DPF_INTR_DL_PITCNT_LEN_ERR:
+			dev_err_ratelimited(dev, "DL interrupt: PIT count length error!\n");
+			dpmaif_unmask_dl_pitcnt_len_err_interrupt(&dpmaif_ctrl->hif_hw_info);
+			break;
+
+		case DPF_DL_INT_DLQ0_PITCNT_LEN_ERR:
+			dev_err_ratelimited(dev, "DL interrupt: DLQ0 PIT count length error!\n");
+			dpmaif_dlq_unmask_rx_pitcnt_len_err_intr(&dpmaif_ctrl->hif_hw_info,
+								 DPF_RX_QNO_DFT);
+			break;
+
+		case DPF_DL_INT_DLQ1_PITCNT_LEN_ERR:
+			dev_err_ratelimited(dev, "DL interrupt: DLQ1 PIT count length error!\n");
+			dpmaif_dlq_unmask_rx_pitcnt_len_err_intr(&dpmaif_ctrl->hif_hw_info,
+								 DPF_RX_QNO1);
+			break;
+
+		case DPF_INTR_DL_DONE:
+		case DPF_INTR_DL_DLQ0_DONE:
+		case DPF_INTR_DL_DLQ1_DONE:
+			dpmaif_irq_rx_done(dpmaif_ctrl, intr_status.intr_queues[i]);
+			break;
+
+		default:
+			dev_err_ratelimited(dev, "DL interrupt error: type : %d\n",
+					    intr_status.intr_types[i]);
+		}
+	}
+}
+
+static irqreturn_t dpmaif_isr_handler(int irq, void *data)
+{
+	struct dpmaif_ctrl *dpmaif_ctrl;
+	struct dpmaif_isr_para *isr_para;
+
+	isr_para = data;
+	dpmaif_ctrl = isr_para->dpmaif_ctrl;
+
+	if (dpmaif_ctrl->state != DPMAIF_STATE_PWRON) {
+		dev_err(dpmaif_ctrl->dev, "interrupt received before initializing DPMAIF\n");
+		return IRQ_HANDLED;
+	}
+
+	mtk_pcie_mac_clear_int(dpmaif_ctrl->mtk_dev, isr_para->pcie_int);
+	dpmaif_irq_cb(isr_para);
+	mtk_pcie_mac_set_int(dpmaif_ctrl->mtk_dev, isr_para->pcie_int);
+	return IRQ_HANDLED;
+}
+
+static void dpmaif_isr_parameter_init(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct dpmaif_isr_para *isr_para;
+	unsigned char i;
+
+	/* set up the RXQ and isr relation */
+	dpmaif_ctrl->rxq_int_mapping[DPF_RX_QNO0] = DPMAIF_INT;
+	dpmaif_ctrl->rxq_int_mapping[DPF_RX_QNO1] = DPMAIF2_INT;
+
+	/* init the isr parameter */
+	for (i = 0; i < DPMAIF_RXQ_NUM; i++) {
+		isr_para = &dpmaif_ctrl->isr_para[i];
+		isr_para->dpmaif_ctrl = dpmaif_ctrl;
+		isr_para->dlq_id = i;
+		isr_para->pcie_int = dpmaif_ctrl->rxq_int_mapping[i];
+	}
+}
+
+static void dpmaif_platform_irq_init(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct dpmaif_isr_para *isr_para;
+	struct mtk_pci_dev *mtk_dev;
+	enum pcie_int int_type;
+	int i;
+
+	mtk_dev = dpmaif_ctrl->mtk_dev;
+	/* PCIe isr parameter init */
+	dpmaif_isr_parameter_init(dpmaif_ctrl);
+
+	/* register isr */
+	for (i = 0; i < DPMAIF_RXQ_NUM; i++) {
+		isr_para = &dpmaif_ctrl->isr_para[i];
+		int_type = isr_para->pcie_int;
+		mtk_pcie_mac_clear_int(mtk_dev, int_type);
+
+		mtk_dev->intr_handler[int_type] = dpmaif_isr_handler;
+		mtk_dev->intr_thread[int_type] = NULL;
+		mtk_dev->callback_param[int_type] = isr_para;
+
+		mtk_pcie_mac_clear_int_status(mtk_dev, int_type);
+		mtk_pcie_mac_set_int(mtk_dev, int_type);
+	}
+}
+
+static void dpmaif_skb_pool_free(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct dpmaif_skb_pool *pool;
+	unsigned int i;
+
+	pool = &dpmaif_ctrl->skb_pool;
+	flush_work(&pool->reload_work);
+
+	if (pool->reload_work_queue) {
+		destroy_workqueue(pool->reload_work_queue);
+		pool->reload_work_queue = NULL;
+	}
+
+	for (i = 0; i < DPMA_SKB_QUEUE_CNT; i++)
+		dpmaif_skb_queue_free(dpmaif_ctrl, i);
+}
+
+/* we put initializations which takes too much time here: SW init only */
+static int dpmaif_sw_init(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct dpmaif_rx_queue *rx_q;
+	struct dpmaif_tx_queue *tx_q;
+	int ret, i, j;
+
+	/* RX normal BAT table init */
+	ret = dpmaif_bat_alloc(dpmaif_ctrl, &dpmaif_ctrl->bat_req, BAT_TYPE_NORMAL);
+	if (ret) {
+		dev_err(dpmaif_ctrl->dev, "normal BAT table init fail, %d!\n", ret);
+		return ret;
+	}
+
+	/* RX frag BAT table init */
+	ret = dpmaif_bat_alloc(dpmaif_ctrl, &dpmaif_ctrl->bat_frag, BAT_TYPE_FRAG);
+	if (ret) {
+		dev_err(dpmaif_ctrl->dev, "frag BAT table init fail, %d!\n", ret);
+		goto bat_frag_err;
+	}
+
+	/* dpmaif RXQ resource init */
+	for (i = 0; i < DPMAIF_RXQ_NUM; i++) {
+		rx_q = &dpmaif_ctrl->rxq[i];
+		rx_q->index = i;
+		rx_q->dpmaif_ctrl = dpmaif_ctrl;
+		ret = dpmaif_rxq_alloc(rx_q);
+		if (ret)
+			goto rxq_init_err;
+	}
+
+	/* dpmaif TXQ resource init */
+	for (i = 0; i < DPMAIF_TXQ_NUM; i++) {
+		tx_q = &dpmaif_ctrl->txq[i];
+		tx_q->index = i;
+		tx_q->dpmaif_ctrl = dpmaif_ctrl;
+		ret = dpmaif_txq_init(tx_q);
+		if (ret)
+			goto txq_init_err;
+	}
+
+	/* Init TX thread: send skb data to dpmaif HW */
+	ret = dpmaif_tx_thread_init(dpmaif_ctrl);
+	if (ret)
+		goto tx_thread_err;
+
+	/* Init the RX skb pool */
+	ret = dpmaif_skb_pool_init(dpmaif_ctrl);
+	if (ret)
+		goto pool_init_err;
+
+	/* Init BAT rel workqueue */
+	ret = dpmaif_bat_release_work_alloc(dpmaif_ctrl);
+	if (ret)
+		goto bat_work_init_err;
+
+	return 0;
+
+bat_work_init_err:
+	dpmaif_skb_pool_free(dpmaif_ctrl);
+pool_init_err:
+	dpmaif_tx_thread_release(dpmaif_ctrl);
+tx_thread_err:
+	i = DPMAIF_TXQ_NUM;
+txq_init_err:
+	for (j = 0; j < i; j++) {
+		tx_q = &dpmaif_ctrl->txq[j];
+		dpmaif_txq_free(tx_q);
+	}
+
+	i = DPMAIF_RXQ_NUM;
+rxq_init_err:
+	for (j = 0; j < i; j++) {
+		rx_q = &dpmaif_ctrl->rxq[j];
+		dpmaif_rxq_free(rx_q);
+	}
+
+	dpmaif_bat_free(dpmaif_ctrl, &dpmaif_ctrl->bat_frag);
+bat_frag_err:
+	dpmaif_bat_free(dpmaif_ctrl, &dpmaif_ctrl->bat_req);
+
+	return ret;
+}
+
+static void dpmaif_sw_release(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct dpmaif_rx_queue *rx_q;
+	struct dpmaif_tx_queue *tx_q;
+	int i;
+
+	/* release the tx thread */
+	dpmaif_tx_thread_release(dpmaif_ctrl);
+
+	/* release the BAT release workqueue */
+	dpmaif_bat_release_work_free(dpmaif_ctrl);
+
+	for (i = 0; i < DPMAIF_TXQ_NUM; i++) {
+		tx_q = &dpmaif_ctrl->txq[i];
+		dpmaif_txq_free(tx_q);
+	}
+
+	for (i = 0; i < DPMAIF_RXQ_NUM; i++) {
+		rx_q = &dpmaif_ctrl->rxq[i];
+		dpmaif_rxq_free(rx_q);
+	}
+
+	/* release the skb pool */
+	dpmaif_skb_pool_free(dpmaif_ctrl);
+}
+
+static int dpmaif_start(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct dpmaif_hw_params hw_init_para;
+	struct dpmaif_rx_queue *rxq;
+	struct dpmaif_tx_queue *txq;
+	unsigned int buf_cnt;
+	int i, ret = 0;
+
+	if (dpmaif_ctrl->state == DPMAIF_STATE_PWRON)
+		return -EFAULT;
+
+	memset(&hw_init_para, 0, sizeof(hw_init_para));
+
+	/* rx */
+	for (i = 0; i < DPMAIF_RXQ_NUM; i++) {
+		rxq = &dpmaif_ctrl->rxq[i];
+		rxq->que_started = true;
+		rxq->index = i;
+		rxq->budget = rxq->bat_req->bat_size_cnt - 1;
+
+		/* DPMAIF HW RX queue init parameter */
+		hw_init_para.pkt_bat_base_addr[i] = rxq->bat_req->bat_bus_addr;
+		hw_init_para.pkt_bat_size_cnt[i] = rxq->bat_req->bat_size_cnt;
+		hw_init_para.pit_base_addr[i] = rxq->pit_bus_addr;
+		hw_init_para.pit_size_cnt[i] = rxq->pit_size_cnt;
+		hw_init_para.frg_bat_base_addr[i] = rxq->bat_frag->bat_bus_addr;
+		hw_init_para.frg_bat_size_cnt[i] = rxq->bat_frag->bat_size_cnt;
+	}
+
+	/* rx normal BAT mask init */
+	memset(dpmaif_ctrl->bat_req.bat_mask, 0,
+	       dpmaif_ctrl->bat_req.bat_size_cnt * sizeof(unsigned char));
+	/* normal BAT - skb buffer and submit BAT */
+	buf_cnt = dpmaif_ctrl->bat_req.bat_size_cnt - 1;
+	ret = dpmaif_rx_buf_alloc(dpmaif_ctrl, &dpmaif_ctrl->bat_req, 0, buf_cnt, true);
+	if (ret) {
+		dev_err(dpmaif_ctrl->dev, "dpmaif_rx_buf_alloc fail, ret:%d\n", ret);
+		return ret;
+	}
+
+	/* frag BAT - page buffer init */
+	buf_cnt = dpmaif_ctrl->bat_frag.bat_size_cnt - 1;
+	ret = dpmaif_rx_frag_alloc(dpmaif_ctrl, &dpmaif_ctrl->bat_frag, 0, buf_cnt, true);
+	if (ret) {
+		dev_err(dpmaif_ctrl->dev, "dpmaif_rx_frag_alloc fail, ret:%d\n", ret);
+		goto err_bat;
+	}
+
+	/* tx */
+	for (i = 0; i < DPMAIF_TXQ_NUM; i++) {
+		txq = &dpmaif_ctrl->txq[i];
+		txq->que_started = true;
+
+		/* DPMAIF HW TX queue init parameter */
+		hw_init_para.drb_base_addr[i] = txq->drb_bus_addr;
+		hw_init_para.drb_size_cnt[i] = txq->drb_size_cnt;
+	}
+
+	ret = dpmaif_hw_init(dpmaif_ctrl, &hw_init_para);
+	if (ret) {
+		dev_err(dpmaif_ctrl->dev, "dpmaif_hw_init fail, ret:%d\n", ret);
+		goto err_frag;
+	}
+
+	/* notifies DPMAIF HW for available BAT count */
+	ret = dpmaif_dl_add_bat_cnt(dpmaif_ctrl, 0, rxq->bat_req->bat_size_cnt - 1);
+	if (ret)
+		goto err_frag;
+
+	ret = dpmaif_dl_add_frg_cnt(dpmaif_ctrl, 0, rxq->bat_frag->bat_size_cnt - 1);
+	if (ret)
+		goto err_frag;
+
+	dpmaif_clr_ul_all_interrupt(&dpmaif_ctrl->hif_hw_info);
+	dpmaif_clr_dl_all_interrupt(&dpmaif_ctrl->hif_hw_info);
+
+	dpmaif_ctrl->state = DPMAIF_STATE_PWRON;
+	dpmaif_enable_irq(dpmaif_ctrl);
+
+	/* wake up the dpmaif tx thread */
+	wake_up(&dpmaif_ctrl->tx_wq);
+	return 0;
+err_frag:
+	dpmaif_bat_free(rxq->dpmaif_ctrl, rxq->bat_frag);
+err_bat:
+	dpmaif_bat_free(rxq->dpmaif_ctrl, rxq->bat_req);
+	return ret;
+}
+
+static void dpmaif_pos_stop_hw(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	dpmaif_suspend_tx_sw_stop(dpmaif_ctrl);
+	dpmaif_suspend_rx_sw_stop(dpmaif_ctrl);
+}
+
+static void dpmaif_stop_hw(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	dpmaif_hw_stop_tx_queue(dpmaif_ctrl);
+	dpmaif_hw_stop_rx_queue(dpmaif_ctrl);
+}
+
+static int dpmaif_stop(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	if (!dpmaif_ctrl->dpmaif_sw_init_done) {
+		dev_err(dpmaif_ctrl->dev, "dpmaif SW init fail\n");
+		return -EFAULT;
+	}
+
+	if (dpmaif_ctrl->state == DPMAIF_STATE_PWROFF)
+		return -EFAULT;
+
+	dpmaif_disable_irq(dpmaif_ctrl);
+	dpmaif_ctrl->state = DPMAIF_STATE_PWROFF;
+	dpmaif_pos_stop_hw(dpmaif_ctrl);
+	flush_work(&dpmaif_ctrl->skb_pool.reload_work);
+	dpmaif_stop_tx_sw(dpmaif_ctrl);
+	dpmaif_stop_rx_sw(dpmaif_ctrl);
+	return 0;
+}
+
+int dpmaif_md_state_callback(struct dpmaif_ctrl *dpmaif_ctrl, unsigned char state)
+{
+	int ret = 0;
+
+	switch (state) {
+	case MD_STATE_WAITING_FOR_HS1:
+		ret = dpmaif_start(dpmaif_ctrl);
+		break;
+
+	case MD_STATE_EXCEPTION:
+		ret = dpmaif_stop(dpmaif_ctrl);
+		break;
+
+	case MD_STATE_STOPPED:
+		ret = dpmaif_stop(dpmaif_ctrl);
+		break;
+
+	case MD_STATE_WAITING_TO_STOP:
+		dpmaif_stop_hw(dpmaif_ctrl);
+		break;
+
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * dpmaif_hif_init() - Initialize data path
+ * @mtk_dev: MTK context structure
+ * @callbacks: Callbacks implemented by the network layer to handle RX skb and
+ *	       event notifications
+ *
+ * Allocate and initialize datapath control block
+ * Register datapath ISR, TX and RX resources
+ *
+ * Return: pointer to DPMAIF context structure or NULL in case of error
+ */
+struct dpmaif_ctrl *dpmaif_hif_init(struct mtk_pci_dev *mtk_dev,
+				    struct dpmaif_callbacks *callbacks)
+{
+	struct dpmaif_ctrl *dpmaif_ctrl;
+	int ret;
+
+	if (!callbacks)
+		return NULL;
+
+	dpmaif_ctrl = devm_kzalloc(&mtk_dev->pdev->dev, sizeof(*dpmaif_ctrl), GFP_KERNEL);
+	if (!dpmaif_ctrl)
+		return NULL;
+
+	dpmaif_ctrl->mtk_dev = mtk_dev;
+	dpmaif_ctrl->callbacks = callbacks;
+	dpmaif_ctrl->dev = &mtk_dev->pdev->dev;
+	dpmaif_ctrl->dpmaif_sw_init_done = false;
+	dpmaif_ctrl->hif_hw_info.pcie_base = mtk_dev->base_addr.pcie_ext_reg_base -
+					     mtk_dev->base_addr.pcie_dev_reg_trsl_addr;
+
+	/* registers dpmaif irq by PCIe driver API */
+	dpmaif_platform_irq_init(dpmaif_ctrl);
+	dpmaif_disable_irq(dpmaif_ctrl);
+
+	/* Alloc TX/RX resource */
+	ret = dpmaif_sw_init(dpmaif_ctrl);
+	if (ret) {
+		dev_err(&mtk_dev->pdev->dev, "DPMAIF SW initialization fail! %d\n", ret);
+		return NULL;
+	}
+
+	dpmaif_ctrl->dpmaif_sw_init_done = true;
+	return dpmaif_ctrl;
+}
+
+void dpmaif_hif_exit(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	if (dpmaif_ctrl->dpmaif_sw_init_done) {
+		dpmaif_stop(dpmaif_ctrl);
+		dpmaif_sw_release(dpmaif_ctrl);
+		dpmaif_ctrl->dpmaif_sw_init_done = false;
+	}
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
new file mode 100644
index 000000000000..1a8f15904806
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
@@ -0,0 +1,270 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_DPMA_TX_H__
+#define __T7XX_DPMA_TX_H__
+
+#include <linux/netdevice.h>
+#include <linux/workqueue.h>
+#include <linux/wait.h>
+#include <linux/types.h>
+
+#include "t7xx_common.h"
+#include "t7xx_pci.h"
+#include "t7xx_skb_util.h"
+
+#define DPMAIF_RXQ_NUM		2
+#define DPMAIF_TXQ_NUM		5
+
+#define DPMA_SKB_QUEUE_CNT	1
+
+struct dpmaif_isr_en_mask {
+	unsigned int		ap_ul_l2intr_en_msk;
+	unsigned int		ap_dl_l2intr_en_msk;
+	unsigned int		ap_udl_ip_busy_en_msk;
+	unsigned int		ap_dl_l2intr_err_en_msk;
+};
+
+struct dpmaif_ul {
+	bool			que_started;
+	unsigned char		reserve[3];
+	dma_addr_t		drb_base;
+	unsigned int		drb_size_cnt;
+};
+
+struct dpmaif_dl {
+	bool			que_started;
+	unsigned char		reserve[3];
+	dma_addr_t		pit_base;
+	unsigned int		pit_size_cnt;
+	dma_addr_t		bat_base;
+	unsigned int		bat_size_cnt;
+	dma_addr_t		frg_base;
+	unsigned int		frg_size_cnt;
+	unsigned int		pit_seq;
+};
+
+struct dpmaif_dl_hwq {
+	unsigned int		bat_remain_size;
+	unsigned int		bat_pkt_bufsz;
+	unsigned int		frg_pkt_bufsz;
+	unsigned int		bat_rsv_length;
+	unsigned int		pkt_bid_max_cnt;
+	unsigned int		pkt_alignment;
+	unsigned int		mtu_size;
+	unsigned int		chk_pit_num;
+	unsigned int		chk_bat_num;
+	unsigned int		chk_frg_num;
+};
+
+/* Structure of DL BAT */
+struct dpmaif_cur_rx_skb_info {
+	bool			msg_pit_received;
+	struct sk_buff		*cur_skb;
+	unsigned int		cur_chn_idx;
+	unsigned int		check_sum;
+	unsigned int		pit_dp;
+	int			err_payload;
+};
+
+struct dpmaif_bat {
+	unsigned int		p_buffer_addr;
+	unsigned int		buffer_addr_ext;
+};
+
+struct dpmaif_bat_skb {
+	struct sk_buff		*skb;
+	dma_addr_t		data_bus_addr;
+	unsigned int		data_len;
+};
+
+struct dpmaif_bat_page {
+	struct page		*page;
+	dma_addr_t		data_bus_addr;
+	unsigned int		offset;
+	unsigned int		data_len;
+};
+
+enum bat_type {
+	BAT_TYPE_NORMAL = 0,
+	BAT_TYPE_FRAG = 1,
+};
+
+struct dpmaif_bat_request {
+	void			*bat_base;
+	dma_addr_t		bat_bus_addr;
+	unsigned int		bat_size_cnt;
+	unsigned short		bat_wr_idx;
+	unsigned short		bat_release_rd_idx;
+	void			*bat_skb_ptr;
+	unsigned int		skb_pkt_cnt;
+	unsigned int		pkt_buf_sz;
+	unsigned char		*bat_mask;
+	atomic_t		refcnt;
+	spinlock_t		mask_lock; /* protects bat_mask */
+	enum bat_type		type;
+};
+
+struct dpmaif_rx_queue {
+	unsigned char		index;
+	bool			que_started;
+	unsigned short		budget;
+
+	void			*pit_base;
+	dma_addr_t		pit_bus_addr;
+	unsigned int		pit_size_cnt;
+
+	unsigned short		pit_rd_idx;
+	unsigned short		pit_wr_idx;
+	unsigned short		pit_release_rd_idx;
+
+	struct dpmaif_bat_request *bat_req;
+	struct dpmaif_bat_request *bat_frag;
+
+	wait_queue_head_t	rx_wq;
+	struct task_struct	*rx_thread;
+	struct ccci_skb_queue	skb_queue;
+
+	struct workqueue_struct	*worker;
+	struct work_struct	dpmaif_rxq_work;
+
+	atomic_t		rx_processing;
+
+	struct dpmaif_ctrl	*dpmaif_ctrl;
+	unsigned int		expect_pit_seq;
+	unsigned int		pit_remain_release_cnt;
+	struct dpmaif_cur_rx_skb_info rx_data_info;
+};
+
+struct dpmaif_tx_queue {
+	unsigned char		index;
+	bool			que_started;
+	atomic_t		tx_budget;
+	void			*drb_base;
+	dma_addr_t		drb_bus_addr;
+	unsigned int		drb_size_cnt;
+	unsigned short		drb_wr_idx;
+	unsigned short		drb_rd_idx;
+	unsigned short		drb_release_rd_idx;
+	unsigned short		last_ch_id;
+	void			*drb_skb_base;
+	wait_queue_head_t	req_wq;
+	struct workqueue_struct	*worker;
+	struct work_struct	dpmaif_tx_work;
+	spinlock_t		tx_lock; /* protects txq DRB */
+	atomic_t		tx_processing;
+
+	struct dpmaif_ctrl	*dpmaif_ctrl;
+	/* tx thread skb_list */
+	spinlock_t		tx_event_lock;
+	struct list_head	tx_event_queue;
+	unsigned int		tx_submit_skb_cnt;
+	unsigned int		tx_list_max_len;
+	unsigned int		tx_skb_stat;
+	bool			drb_lack;
+};
+
+/* data path skb pool */
+struct dpmaif_map_skb {
+	struct list_head	head;
+	u32			qlen;
+	spinlock_t		lock; /* protects skb queue*/
+};
+
+struct dpmaif_skb_info {
+	struct list_head	entry;
+	struct sk_buff		*skb;
+	unsigned int		data_len;
+	dma_addr_t		data_bus_addr;
+};
+
+struct dpmaif_skb_queue {
+	struct dpmaif_map_skb	skb_list;
+	unsigned int		size;
+	unsigned int		max_len;
+};
+
+struct dpmaif_skb_pool {
+	struct dpmaif_skb_queue	queue[DPMA_SKB_QUEUE_CNT];
+	struct workqueue_struct	*reload_work_queue;
+	struct work_struct	reload_work;
+	unsigned int		queue_cnt;
+};
+
+struct dpmaif_isr_para {
+	struct dpmaif_ctrl	*dpmaif_ctrl;
+	unsigned char		pcie_int;
+	unsigned char		dlq_id;
+};
+
+struct dpmaif_tx_event {
+	struct list_head	entry;
+	int			qno;
+	struct sk_buff		*skb;
+	unsigned int		drb_cnt;
+};
+
+enum dpmaif_state {
+	DPMAIF_STATE_MIN,
+	DPMAIF_STATE_PWROFF,
+	DPMAIF_STATE_PWRON,
+	DPMAIF_STATE_EXCEPTION,
+	DPMAIF_STATE_MAX
+};
+
+struct dpmaif_hw_info {
+	void __iomem			*pcie_base;
+	struct dpmaif_dl		dl_que[DPMAIF_RXQ_NUM];
+	struct dpmaif_ul		ul_que[DPMAIF_TXQ_NUM];
+	struct dpmaif_dl_hwq		dl_que_hw[DPMAIF_RXQ_NUM];
+	struct dpmaif_isr_en_mask	isr_en_mask;
+};
+
+enum dpmaif_txq_state {
+	DMPAIF_TXQ_STATE_IRQ,
+	DMPAIF_TXQ_STATE_FULL,
+};
+
+struct dpmaif_callbacks {
+	void (*state_notify)(struct mtk_pci_dev *mtk_dev,
+			     enum dpmaif_txq_state state, int txqt);
+	void (*recv_skb)(struct mtk_pci_dev *mtk_dev, int netif_id, struct sk_buff *skb);
+};
+
+struct dpmaif_ctrl {
+	struct device			*dev;
+	struct mtk_pci_dev		*mtk_dev;
+	enum dpmaif_state		state;
+	bool				dpmaif_sw_init_done;
+	struct dpmaif_hw_info		hif_hw_info;
+	struct dpmaif_tx_queue		txq[DPMAIF_TXQ_NUM];
+	struct dpmaif_rx_queue		rxq[DPMAIF_RXQ_NUM];
+
+	unsigned char			rxq_int_mapping[DPMAIF_RXQ_NUM];
+	struct dpmaif_isr_para		isr_para[DPMAIF_RXQ_NUM];
+
+	struct dpmaif_bat_request	bat_req;
+	struct dpmaif_bat_request	bat_frag;
+	struct workqueue_struct		*bat_release_work_queue;
+	struct work_struct		bat_release_work;
+	struct dpmaif_skb_pool		skb_pool;
+
+	wait_queue_head_t		tx_wq;
+	struct task_struct		*tx_thread;
+	unsigned char			txq_select_times;
+
+	struct dpmaif_callbacks		*callbacks;
+};
+
+struct dpmaif_ctrl *dpmaif_hif_init(struct mtk_pci_dev *mtk_dev,
+				    struct dpmaif_callbacks *callbacks);
+void dpmaif_hif_exit(struct dpmaif_ctrl *dpmaif_ctrl);
+int dpmaif_md_state_callback(struct dpmaif_ctrl *dpmaif_ctrl, unsigned char state);
+unsigned int ring_buf_get_next_wrdx(unsigned int buf_len, unsigned int buf_idx);
+unsigned int ring_buf_read_write_count(unsigned int total_cnt, unsigned int rd_idx,
+				       unsigned int wrt_idx, bool rd_wrt);
+
+#endif /* __T7XX_DPMA_TX_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
new file mode 100644
index 000000000000..a902f1ffa4c2
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
@@ -0,0 +1,1523 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/iopoll.h>
+#include <linux/jiffies.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include "t7xx_dpmaif.h"
+#include "t7xx_hif_dpmaif.h"
+#include "t7xx_hif_dpmaif_rx.h"
+
+#define DPMAIF_BAT_COUNT		8192
+#define DPMAIF_FRG_COUNT		4814
+#define DPMAIF_PIT_COUNT		(DPMAIF_BAT_COUNT * 2)
+
+#define DPMAIF_BAT_CNT_THRESHOLD	30
+#define DPMAIF_PIT_CNT_THRESHOLD	60
+#define DPMAIF_RX_PUSH_THRESHOLD_MASK	0x7
+#define DPMAIF_NOTIFY_RELEASE_COUNT	128
+#define DPMAIF_POLL_PIT_TIME_US		20
+#define DPMAIF_POLL_PIT_MAX_TIME_US	2000
+#define DPMAIF_WQ_TIME_LIMIT_MS		2
+#define DPMAIF_CS_RESULT_PASS		0
+
+#define DPMAIF_SKB_OVER_HEAD		SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
+#define DPMAIF_SKB_SIZE_EXTRA		SKB_DATA_ALIGN(NET_SKB_PAD + DPMAIF_SKB_OVER_HEAD)
+#define DPMAIF_SKB_SIZE(s)		((s) + DPMAIF_SKB_SIZE_EXTRA)
+#define DPMAIF_SKB_Q_SIZE		(DPMAIF_BAT_COUNT * DPMAIF_SKB_SIZE(DPMAIF_HW_BAT_PKTBUF))
+#define DPMAIF_SKB_SIZE_MIN		32
+#define DPMAIF_RELOAD_TH_1		4
+#define DPMAIF_RELOAD_TH_2		5
+
+/* packet_type */
+#define DES_PT_PD			0x00
+#define DES_PT_MSG			0x01
+/* buffer_type */
+#define PKT_BUF_FRAG			0x01
+
+static inline unsigned int normal_pit_bid(const struct dpmaif_normal_pit *pit_info)
+{
+	return (FIELD_GET(NORMAL_PIT_H_BID, pit_info->pit_footer) << 13) +
+		FIELD_GET(NORMAL_PIT_BUFFER_ID, pit_info->pit_header);
+}
+
+static void dpmaif_set_skb_cs_type(const unsigned int cs_result, struct sk_buff *skb)
+{
+	if (cs_result == DPMAIF_CS_RESULT_PASS)
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+	else
+		skb->ip_summed = CHECKSUM_NONE;
+}
+
+static int dpmaif_net_rx_push_thread(void *arg)
+{
+	struct dpmaif_ctrl *hif_ctrl;
+	struct dpmaif_callbacks *cb;
+	struct dpmaif_rx_queue *q;
+	struct sk_buff *skb;
+	u32 *lhif_header;
+	int netif_id;
+
+	q = arg;
+	hif_ctrl = q->dpmaif_ctrl;
+	cb = hif_ctrl->callbacks;
+	while (!kthread_should_stop()) {
+		if (skb_queue_empty(&q->skb_queue.skb_list)) {
+			if (wait_event_interruptible(q->rx_wq,
+						     !skb_queue_empty(&q->skb_queue.skb_list) ||
+						     kthread_should_stop()))
+				continue;
+		}
+
+		if (kthread_should_stop())
+			break;
+
+		skb = ccci_skb_dequeue(hif_ctrl->mtk_dev->pools.reload_work_queue,
+				       &q->skb_queue);
+		if (!skb)
+			continue;
+
+		lhif_header = (u32 *)skb->data;
+		netif_id = FIELD_GET(LHIF_HEADER_NETIF, *lhif_header);
+		skb_pull(skb, sizeof(*lhif_header));
+		cb->recv_skb(hif_ctrl->mtk_dev, netif_id, skb);
+
+		cond_resched();
+	}
+
+	return 0;
+}
+
+static int dpmaif_update_bat_wr_idx(struct dpmaif_ctrl *dpmaif_ctrl,
+				    const unsigned char q_num, const unsigned int bat_cnt)
+{
+	unsigned short old_rl_idx, new_wr_idx, old_wr_idx;
+	struct dpmaif_bat_request *bat_req;
+	struct dpmaif_rx_queue *rxq;
+
+	rxq = &dpmaif_ctrl->rxq[q_num];
+	bat_req = rxq->bat_req;
+
+	if (!rxq->que_started) {
+		dev_err(dpmaif_ctrl->dev, "RX queue %d has not been started\n", rxq->index);
+		return -EINVAL;
+	}
+
+	old_rl_idx = bat_req->bat_release_rd_idx;
+	old_wr_idx = bat_req->bat_wr_idx;
+	new_wr_idx = old_wr_idx + bat_cnt;
+
+	if (old_rl_idx > old_wr_idx) {
+		if (new_wr_idx >= old_rl_idx) {
+			dev_err(dpmaif_ctrl->dev, "RX BAT flow check fail\n");
+			return -EINVAL;
+		}
+	} else if (new_wr_idx >= bat_req->bat_size_cnt) {
+		new_wr_idx -= bat_req->bat_size_cnt;
+		if (new_wr_idx >= old_rl_idx) {
+			dev_err(dpmaif_ctrl->dev, "RX BAT flow check fail\n");
+			return -EINVAL;
+		}
+	}
+
+	bat_req->bat_wr_idx = new_wr_idx;
+	return 0;
+}
+
+#define GET_SKB_BY_ENTRY(skb_entry)\
+	((struct dpmaif_skb_info *)list_entry(skb_entry, struct dpmaif_skb_info, entry))
+
+static struct dpmaif_skb_info *alloc_and_map_skb_info(const struct dpmaif_ctrl *dpmaif_ctrl,
+						      struct sk_buff *skb)
+{
+	struct dpmaif_skb_info *skb_info;
+	dma_addr_t data_bus_addr;
+	size_t data_len;
+
+	skb_info = kmalloc(sizeof(*skb_info), GFP_KERNEL);
+	if (!skb_info)
+		return NULL;
+
+	/* DMA mapping */
+	data_len = skb_data_size(skb);
+	data_bus_addr = dma_map_single(dpmaif_ctrl->dev, skb->data, data_len, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dpmaif_ctrl->dev, data_bus_addr)) {
+		dev_err_ratelimited(dpmaif_ctrl->dev, "DMA mapping error\n");
+		kfree(skb_info);
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&skb_info->entry);
+	skb_info->skb = skb;
+	skb_info->data_len = data_len;
+	skb_info->data_bus_addr = data_bus_addr;
+	return skb_info;
+}
+
+static struct list_head *dpmaif_map_skb_deq(struct dpmaif_map_skb *skb_list)
+{
+	struct list_head *entry;
+
+	entry = skb_list->head.next;
+	if (!list_empty(&skb_list->head) && entry) {
+		list_del(entry);
+		skb_list->qlen--;
+		return entry;
+	}
+
+	return NULL;
+}
+
+static struct dpmaif_skb_info *dpmaif_skb_dequeue(struct dpmaif_skb_pool *pool,
+						  struct dpmaif_skb_queue *queue)
+{
+	unsigned int max_len, qlen;
+	struct list_head *entry;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->skb_list.lock, flags);
+	entry = dpmaif_map_skb_deq(&queue->skb_list);
+	max_len = queue->max_len;
+	qlen = queue->skb_list.qlen;
+	spin_unlock_irqrestore(&queue->skb_list.lock, flags);
+	if (!entry)
+		return NULL;
+
+	if (qlen < max_len * DPMAIF_RELOAD_TH_1 / DPMAIF_RELOAD_TH_2)
+		queue_work(pool->reload_work_queue, &pool->reload_work);
+
+	return GET_SKB_BY_ENTRY(entry);
+}
+
+static struct dpmaif_skb_info *dpmaif_dev_alloc_skb(struct dpmaif_ctrl *dpmaif_ctrl,
+						    const unsigned int size)
+{
+	struct dpmaif_skb_info *skb_info;
+	struct sk_buff *skb;
+
+	skb = __dev_alloc_skb(size, GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	skb_info = alloc_and_map_skb_info(dpmaif_ctrl, skb);
+	if (!skb_info)
+		dev_kfree_skb_any(skb);
+
+	return skb_info;
+}
+
+static struct dpmaif_skb_info *dpmaif_alloc_skb(struct dpmaif_ctrl *dpmaif_ctrl,
+						const unsigned int size)
+{
+	unsigned int i;
+
+	if (size > DPMAIF_HW_BAT_PKTBUF)
+		return dpmaif_dev_alloc_skb(dpmaif_ctrl, size);
+
+	for (i = 0; i < dpmaif_ctrl->skb_pool.queue_cnt; i++) {
+		struct dpmaif_skb_info *skb_info;
+		struct dpmaif_skb_queue *queue;
+
+		queue = &dpmaif_ctrl->skb_pool.queue[DPMA_SKB_QUEUE_CNT - 1 - i];
+
+		if (size <= queue->size) {
+			skb_info = dpmaif_skb_dequeue(&dpmaif_ctrl->skb_pool, queue);
+			if (skb_info && skb_info->skb)
+				return skb_info;
+
+			kfree(skb_info);
+			return dpmaif_dev_alloc_skb(dpmaif_ctrl, size);
+		}
+	}
+
+	return NULL;
+}
+
+/**
+ * dpmaif_rx_buf_alloc() - Allocates buffers for the BAT ring
+ * @dpmaif_ctrl: Pointer to DPMAIF context structure
+ * @bat_req: Pointer to BAT request structure
+ * @q_num: Queue number
+ * @buf_cnt: Number of buffers to allocate
+ * @first_time: Indicates if the ring is being populated for the first time
+ *
+ * Allocates skb and store the start address of the data buffer into the BAT ring.
+ * If the this is not the initial call then notify the HW about the new entries.
+ *
+ * Return: 0 on success, a negative error code on failure
+ */
+int dpmaif_rx_buf_alloc(struct dpmaif_ctrl *dpmaif_ctrl,
+			const struct dpmaif_bat_request *bat_req,
+			const unsigned char q_num, const unsigned int buf_cnt,
+			const bool first_time)
+{
+	unsigned int alloc_cnt, i, hw_wr_idx;
+	unsigned int bat_cnt, bat_max_cnt;
+	unsigned short bat_start_idx;
+	int ret;
+
+	alloc_cnt = buf_cnt;
+	if (!alloc_cnt || alloc_cnt > bat_req->bat_size_cnt)
+		return -EINVAL;
+
+	/* check BAT buffer space */
+	bat_max_cnt = bat_req->bat_size_cnt;
+	bat_cnt = ring_buf_read_write_count(bat_max_cnt, bat_req->bat_release_rd_idx,
+					    bat_req->bat_wr_idx, false);
+
+	if (alloc_cnt > bat_cnt)
+		return -ENOMEM;
+
+	bat_start_idx = bat_req->bat_wr_idx;
+
+	/* Set buffer to be used */
+	for (i = 0; i < alloc_cnt; i++) {
+		unsigned short cur_bat_idx = bat_start_idx + i;
+		struct dpmaif_bat_skb *cur_skb;
+		struct dpmaif_bat *cur_bat;
+
+		if (cur_bat_idx >= bat_max_cnt)
+			cur_bat_idx -= bat_max_cnt;
+
+		cur_skb = (struct dpmaif_bat_skb *)bat_req->bat_skb_ptr + cur_bat_idx;
+		if (!cur_skb->skb) {
+			struct dpmaif_skb_info *skb_info;
+
+			skb_info = dpmaif_alloc_skb(dpmaif_ctrl, bat_req->pkt_buf_sz);
+			if (!skb_info)
+				break;
+
+			cur_skb->skb = skb_info->skb;
+			cur_skb->data_bus_addr = skb_info->data_bus_addr;
+			cur_skb->data_len = skb_info->data_len;
+			kfree(skb_info);
+		}
+
+		cur_bat = (struct dpmaif_bat *)bat_req->bat_base + cur_bat_idx;
+		cur_bat->buffer_addr_ext = upper_32_bits(cur_skb->data_bus_addr);
+		cur_bat->p_buffer_addr = lower_32_bits(cur_skb->data_bus_addr);
+	}
+
+	if (!i)
+		return -ENOMEM;
+
+	ret = dpmaif_update_bat_wr_idx(dpmaif_ctrl, q_num, i);
+	if (ret)
+		return ret;
+
+	if (!first_time) {
+		ret = dpmaif_dl_add_bat_cnt(dpmaif_ctrl, q_num, i);
+		if (ret)
+			return ret;
+
+		hw_wr_idx = dpmaif_dl_get_bat_wridx(&dpmaif_ctrl->hif_hw_info, DPF_RX_QNO_DFT);
+		if (hw_wr_idx != bat_req->bat_wr_idx) {
+			ret = -EFAULT;
+			dev_err(dpmaif_ctrl->dev, "Write index mismatch in Rx ring\n");
+		}
+	}
+
+	return ret;
+}
+
+static int dpmaifq_release_rx_pit_entry(struct dpmaif_rx_queue *rxq,
+					const unsigned short rel_entry_num)
+{
+	unsigned short old_sw_rel_idx, new_sw_rel_idx, old_hw_wr_idx;
+	int ret;
+
+	if (!rxq->que_started)
+		return 0;
+
+	if (rel_entry_num >= rxq->pit_size_cnt) {
+		dev_err(rxq->dpmaif_ctrl->dev, "Invalid PIT entry release index.\n");
+		return -EINVAL;
+	}
+
+	old_sw_rel_idx = rxq->pit_release_rd_idx;
+	new_sw_rel_idx = old_sw_rel_idx + rel_entry_num;
+
+	old_hw_wr_idx = rxq->pit_wr_idx;
+
+	if (old_hw_wr_idx < old_sw_rel_idx && new_sw_rel_idx >= rxq->pit_size_cnt)
+		new_sw_rel_idx = new_sw_rel_idx - rxq->pit_size_cnt;
+
+	ret = dpmaif_dl_add_dlq_pit_remain_cnt(rxq->dpmaif_ctrl, rxq->index, rel_entry_num);
+
+	if (ret) {
+		dev_err(rxq->dpmaif_ctrl->dev,
+			"PIT release failure, PIT-r/w/rel-%d,%d%d; rel_entry_num = %d, ret=%d\n",
+			rxq->pit_rd_idx, rxq->pit_wr_idx,
+			rxq->pit_release_rd_idx, rel_entry_num, ret);
+		return ret;
+	}
+	rxq->pit_release_rd_idx = new_sw_rel_idx;
+	return 0;
+}
+
+static void dpmaif_set_bat_mask(struct device *dev,
+				struct dpmaif_bat_request *bat_req, unsigned int idx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&bat_req->mask_lock, flags);
+	if (!bat_req->bat_mask[idx])
+		bat_req->bat_mask[idx] = 1;
+	else
+		dev_err(dev, "%s BAT mask was already set\n",
+			bat_req->type == BAT_TYPE_NORMAL ? "Normal" : "Frag");
+
+	spin_unlock_irqrestore(&bat_req->mask_lock, flags);
+}
+
+static int frag_bat_cur_bid_check(struct dpmaif_rx_queue *rxq,
+				  const unsigned int cur_bid)
+{
+	struct dpmaif_bat_request *bat_frag;
+	struct page *page;
+
+	bat_frag = rxq->bat_frag;
+
+	if (cur_bid >= DPMAIF_FRG_COUNT) {
+		dev_err(rxq->dpmaif_ctrl->dev, "frag BAT cur_bid[%d] err\n", cur_bid);
+		return -EINVAL;
+	}
+
+	page = ((struct dpmaif_bat_page *)bat_frag->bat_skb_ptr + cur_bid)->page;
+	if (!page)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * dpmaif_rx_frag_alloc() - Allocates buffers for the Fragment BAT ring
+ * @dpmaif_ctrl: Pointer to DPMAIF context structure
+ * @bat_req: Pointer to BAT request structure
+ * @q_num: Queue number
+ * @buf_cnt: Number of buffers to allocate
+ * @first_time: Indicates if the ring is being populated for the first time
+ *
+ * Fragment BAT is used when the received packet won't fit in a regular BAT entry.
+ * This function allocates a page fragment and store the start address of the page
+ * into the Fragment BAT ring.
+ * If the this is not the initial call then notify the HW about the new entries.
+ *
+ * Return: 0 on success, a negative error code on failure
+ */
+int dpmaif_rx_frag_alloc(struct dpmaif_ctrl *dpmaif_ctrl, struct dpmaif_bat_request *bat_req,
+			 unsigned char q_num, const unsigned int buf_cnt, const bool first_time)
+{
+	unsigned short cur_bat_idx;
+	unsigned int buf_space;
+	int i, ret = 0;
+
+	if (!buf_cnt || buf_cnt > bat_req->bat_size_cnt)
+		return -EINVAL;
+
+	buf_space = ring_buf_read_write_count(bat_req->bat_size_cnt, bat_req->bat_release_rd_idx,
+					      bat_req->bat_wr_idx, false);
+
+	if (buf_cnt > buf_space) {
+		dev_err(dpmaif_ctrl->dev,
+			"Requested more buffers than the space available in Rx frag ring\n");
+		return -EINVAL;
+	}
+
+	cur_bat_idx = bat_req->bat_wr_idx;
+
+	for (i = 0; i < buf_cnt; i++) {
+		struct dpmaif_bat_page *cur_page;
+		struct dpmaif_bat *cur_bat;
+		dma_addr_t data_base_addr;
+
+		cur_page = (struct dpmaif_bat_page *)bat_req->bat_skb_ptr + cur_bat_idx;
+		if (!cur_page->page) {
+			unsigned long offset;
+			struct page *page;
+			void *data;
+
+			data = netdev_alloc_frag(bat_req->pkt_buf_sz);
+			if (!data)
+				break;
+
+			page = virt_to_head_page(data);
+			offset = data - page_address(page);
+			data_base_addr = dma_map_page(dpmaif_ctrl->dev, page, offset,
+						      bat_req->pkt_buf_sz, DMA_FROM_DEVICE);
+
+			if (dma_mapping_error(dpmaif_ctrl->dev, data_base_addr)) {
+				dev_err(dpmaif_ctrl->dev, "DMA mapping fail\n");
+				put_page(virt_to_head_page(data));
+				break;
+			}
+
+			/* record frag information */
+			cur_page->page = page;
+			cur_page->data_bus_addr = data_base_addr;
+			cur_page->offset = offset;
+			cur_page->data_len = bat_req->pkt_buf_sz;
+		}
+
+		/* set to dpmaif HW */
+		data_base_addr = cur_page->data_bus_addr;
+		cur_bat = (struct dpmaif_bat *)bat_req->bat_base + cur_bat_idx;
+		cur_bat->buffer_addr_ext = upper_32_bits(data_base_addr);
+		cur_bat->p_buffer_addr = lower_32_bits(data_base_addr);
+
+		cur_bat_idx = ring_buf_get_next_wrdx(bat_req->bat_size_cnt, cur_bat_idx);
+	}
+
+	if (i < buf_cnt)
+		return -ENOMEM;
+
+	bat_req->bat_wr_idx = cur_bat_idx;
+
+	/* all rxq share one frag_bat table */
+	q_num = DPF_RX_QNO_DFT;
+
+	/* notify to HW */
+	if (!first_time)
+		dpmaif_dl_add_frg_cnt(dpmaif_ctrl, q_num, i);
+
+	return ret;
+}
+
+static int dpmaif_set_rx_frag_to_skb(const struct dpmaif_rx_queue *rxq,
+				     const struct dpmaif_normal_pit *pkt_info,
+				     const struct dpmaif_cur_rx_skb_info *rx_skb_info)
+{
+	unsigned long long data_bus_addr, data_base_addr;
+	struct dpmaif_bat_page *cur_page_info;
+	struct sk_buff *base_skb;
+	unsigned int data_len;
+	struct device *dev;
+	struct page *page;
+	int data_offset;
+
+	base_skb = rx_skb_info->cur_skb;
+	dev = rxq->dpmaif_ctrl->dev;
+	cur_page_info = rxq->bat_frag->bat_skb_ptr;
+	cur_page_info += normal_pit_bid(pkt_info);
+	page = cur_page_info->page;
+
+	/* rx current frag data unmapping */
+	dma_unmap_page(dev, cur_page_info->data_bus_addr,
+		       cur_page_info->data_len, DMA_FROM_DEVICE);
+	if (!page) {
+		dev_err(dev, "frag check fail, bid:%d", normal_pit_bid(pkt_info));
+		return -EINVAL;
+	}
+
+	/* calculate data address && data len. */
+	data_bus_addr = pkt_info->data_addr_ext;
+	data_bus_addr = (data_bus_addr << 32) + pkt_info->p_data_addr;
+	data_base_addr = (unsigned long long)cur_page_info->data_bus_addr;
+	data_offset = (int)(data_bus_addr - data_base_addr);
+
+	data_len = FIELD_GET(NORMAL_PIT_DATA_LEN, pkt_info->pit_header);
+
+	/* record to skb for user: fragment data to nr_frags */
+	skb_add_rx_frag(base_skb, skb_shinfo(base_skb)->nr_frags, page,
+			cur_page_info->offset + data_offset, data_len, cur_page_info->data_len);
+
+	cur_page_info->page = NULL;
+	cur_page_info->offset = 0;
+	cur_page_info->data_len = 0;
+	return 0;
+}
+
+static int dpmaif_get_rx_frag(struct dpmaif_rx_queue *rxq,
+			      const struct dpmaif_normal_pit *pkt_info,
+			      const struct dpmaif_cur_rx_skb_info *rx_skb_info)
+{
+	unsigned int cur_bid;
+	int ret;
+
+	cur_bid = normal_pit_bid(pkt_info);
+
+	/* check frag bid */
+	ret = frag_bat_cur_bid_check(rxq, cur_bid);
+	if (ret < 0)
+		return ret;
+
+	/* set frag data to cur_skb skb_shinfo->frags[] */
+	ret = dpmaif_set_rx_frag_to_skb(rxq, pkt_info, rx_skb_info);
+	if (ret < 0) {
+		dev_err(rxq->dpmaif_ctrl->dev, "dpmaif_set_rx_frag_to_skb fail, ret = %d\n", ret);
+		return ret;
+	}
+
+	dpmaif_set_bat_mask(rxq->dpmaif_ctrl->dev, rxq->bat_frag, cur_bid);
+	return 0;
+}
+
+static inline int bat_cur_bid_check(struct dpmaif_rx_queue *rxq,
+				    const unsigned int cur_bid)
+{
+	struct dpmaif_bat_skb *bat_req;
+	struct dpmaif_bat_skb *bat_skb;
+
+	bat_req = rxq->bat_req->bat_skb_ptr;
+	bat_skb = bat_req + cur_bid;
+
+	if (cur_bid >= DPMAIF_BAT_COUNT || !bat_skb->skb)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int dpmaif_check_read_pit_seq(const struct dpmaif_normal_pit *pit)
+{
+	return FIELD_GET(NORMAL_PIT_PIT_SEQ, pit->pit_footer);
+}
+
+static int dpmaif_check_pit_seq(struct dpmaif_rx_queue *rxq,
+				const struct dpmaif_normal_pit *pit)
+{
+	unsigned int cur_pit_seq, expect_pit_seq = rxq->expect_pit_seq;
+
+	/* Running in soft interrupt therefore cannot sleep */
+	if (read_poll_timeout_atomic(dpmaif_check_read_pit_seq, cur_pit_seq,
+				     cur_pit_seq == expect_pit_seq, DPMAIF_POLL_PIT_TIME_US,
+				     DPMAIF_POLL_PIT_MAX_TIME_US, false, pit))
+		return -EFAULT;
+
+	rxq->expect_pit_seq++;
+	if (rxq->expect_pit_seq >= DPMAIF_DL_PIT_SEQ_VALUE)
+		rxq->expect_pit_seq = 0;
+
+	return 0;
+}
+
+static unsigned int dpmaif_avail_pkt_bat_cnt(struct dpmaif_bat_request *bat_req)
+{
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&bat_req->mask_lock, flags);
+	for (i = 0; i < bat_req->bat_size_cnt; i++) {
+		unsigned int index = bat_req->bat_release_rd_idx + i;
+
+		if (index >= bat_req->bat_size_cnt)
+			index -= bat_req->bat_size_cnt;
+
+		if (!bat_req->bat_mask[index])
+			break;
+	}
+
+	spin_unlock_irqrestore(&bat_req->mask_lock, flags);
+
+	return i;
+}
+
+static int dpmaif_release_dl_bat_entry(const struct dpmaif_rx_queue *rxq,
+				       const unsigned int rel_entry_num,
+				       const enum bat_type buf_type)
+{
+	unsigned short old_sw_rel_idx, new_sw_rel_idx, hw_rd_idx;
+	struct dpmaif_ctrl *dpmaif_ctrl;
+	struct dpmaif_bat_request *bat;
+	unsigned long flags;
+	unsigned int i;
+
+	dpmaif_ctrl = rxq->dpmaif_ctrl;
+
+	if (!rxq->que_started)
+		return -EINVAL;
+
+	if (buf_type == BAT_TYPE_FRAG) {
+		bat = rxq->bat_frag;
+		hw_rd_idx = dpmaif_dl_get_frg_ridx(&dpmaif_ctrl->hif_hw_info, rxq->index);
+	} else {
+		bat = rxq->bat_req;
+		hw_rd_idx = dpmaif_dl_get_bat_ridx(&dpmaif_ctrl->hif_hw_info, rxq->index);
+	}
+
+	if (rel_entry_num >= bat->bat_size_cnt || !rel_entry_num)
+		return -EINVAL;
+
+	old_sw_rel_idx = bat->bat_release_rd_idx;
+	new_sw_rel_idx = old_sw_rel_idx + rel_entry_num;
+
+	/* queue had empty and no need to release */
+	if (bat->bat_wr_idx == old_sw_rel_idx)
+		return 0;
+
+	if (hw_rd_idx >= old_sw_rel_idx) {
+		if (new_sw_rel_idx > hw_rd_idx)
+			return -EINVAL;
+	} else if (new_sw_rel_idx >= bat->bat_size_cnt) {
+		new_sw_rel_idx -= bat->bat_size_cnt;
+		if (new_sw_rel_idx > hw_rd_idx)
+			return -EINVAL;
+	}
+
+	/* reset BAT mask value */
+	spin_lock_irqsave(&bat->mask_lock, flags);
+	for (i = 0; i < rel_entry_num; i++) {
+		unsigned int index = bat->bat_release_rd_idx + i;
+
+		if (index >= bat->bat_size_cnt)
+			index -= bat->bat_size_cnt;
+
+		bat->bat_mask[index] = 0;
+	}
+
+	spin_unlock_irqrestore(&bat->mask_lock, flags);
+	bat->bat_release_rd_idx = new_sw_rel_idx;
+
+	return rel_entry_num;
+}
+
+static int dpmaif_dl_pit_release_and_add(struct dpmaif_rx_queue *rxq)
+{
+	int ret;
+
+	if (rxq->pit_remain_release_cnt < DPMAIF_PIT_CNT_THRESHOLD)
+		return 0;
+
+	ret = dpmaifq_release_rx_pit_entry(rxq, rxq->pit_remain_release_cnt);
+	if (ret)
+		dev_err(rxq->dpmaif_ctrl->dev, "release PIT fail\n");
+	else
+		rxq->pit_remain_release_cnt = 0;
+
+	return ret;
+}
+
+static int dpmaif_dl_pkt_bat_release_and_add(const struct dpmaif_rx_queue *rxq)
+{
+	unsigned int bid_cnt;
+	int ret;
+
+	bid_cnt = dpmaif_avail_pkt_bat_cnt(rxq->bat_req);
+
+	if (bid_cnt < DPMAIF_BAT_CNT_THRESHOLD)
+		return 0;
+
+	ret = dpmaif_release_dl_bat_entry(rxq, bid_cnt, BAT_TYPE_NORMAL);
+	if (ret <= 0) {
+		dev_err(rxq->dpmaif_ctrl->dev, "release PKT BAT failed, ret:%d\n", ret);
+		return ret;
+	}
+
+	ret = dpmaif_rx_buf_alloc(rxq->dpmaif_ctrl, rxq->bat_req, rxq->index, bid_cnt, false);
+
+	if (ret < 0)
+		dev_err(rxq->dpmaif_ctrl->dev, "allocate new RX buffer failed, ret:%d\n", ret);
+
+	return ret;
+}
+
+static int dpmaif_dl_frag_bat_release_and_add(const struct dpmaif_rx_queue *rxq)
+{
+	unsigned int bid_cnt;
+	int ret;
+
+	bid_cnt = dpmaif_avail_pkt_bat_cnt(rxq->bat_frag);
+
+	if (bid_cnt < DPMAIF_BAT_CNT_THRESHOLD)
+		return 0;
+
+	ret = dpmaif_release_dl_bat_entry(rxq, bid_cnt, BAT_TYPE_FRAG);
+	if (ret <= 0) {
+		dev_err(rxq->dpmaif_ctrl->dev, "release PKT BAT failed, ret:%d\n", ret);
+		return ret;
+	}
+
+	return dpmaif_rx_frag_alloc(rxq->dpmaif_ctrl, rxq->bat_frag, rxq->index, bid_cnt, false);
+}
+
+static inline void dpmaif_rx_msg_pit(const struct dpmaif_rx_queue *rxq,
+				     const struct dpmaif_msg_pit *msg_pit,
+				     struct dpmaif_cur_rx_skb_info *rx_skb_info)
+{
+	rx_skb_info->cur_chn_idx = FIELD_GET(MSG_PIT_CHANNEL_ID, msg_pit->dword1);
+	rx_skb_info->check_sum = FIELD_GET(MSG_PIT_CHECKSUM, msg_pit->dword1);
+	rx_skb_info->pit_dp = FIELD_GET(MSG_PIT_DP, msg_pit->dword1);
+}
+
+static int dpmaif_rx_set_data_to_skb(const struct dpmaif_rx_queue *rxq,
+				     const struct dpmaif_normal_pit *pkt_info,
+				     struct dpmaif_cur_rx_skb_info *rx_skb_info)
+{
+	unsigned long long data_bus_addr, data_base_addr;
+	struct dpmaif_bat_skb *cur_bat_skb;
+	struct sk_buff *new_skb;
+	unsigned int data_len;
+	struct device *dev;
+	int data_offset;
+
+	dev = rxq->dpmaif_ctrl->dev;
+	cur_bat_skb = rxq->bat_req->bat_skb_ptr;
+	cur_bat_skb += normal_pit_bid(pkt_info);
+	dma_unmap_single(dev, cur_bat_skb->data_bus_addr, cur_bat_skb->data_len, DMA_FROM_DEVICE);
+
+	/* calculate data address && data len. */
+	/* cur pkt physical address(in a buffer bid pointed) */
+	data_bus_addr = pkt_info->data_addr_ext;
+	data_bus_addr = (data_bus_addr << 32) + pkt_info->p_data_addr;
+	data_base_addr = (unsigned long long)cur_bat_skb->data_bus_addr;
+	data_offset = (int)(data_bus_addr - data_base_addr);
+
+	data_len = FIELD_GET(NORMAL_PIT_DATA_LEN, pkt_info->pit_header);
+	/* cur pkt data len */
+	/* record to skb for user: wapper, enqueue */
+	/* get skb which data contained pkt data */
+	new_skb = cur_bat_skb->skb;
+	new_skb->len = 0;
+	skb_reset_tail_pointer(new_skb);
+	/* set data len, data pointer */
+	skb_reserve(new_skb, data_offset);
+
+	if (new_skb->tail + data_len > new_skb->end) {
+		dev_err(dev, "No buffer space available\n");
+		return -ENOBUFS;
+	}
+
+	skb_put(new_skb, data_len);
+
+	rx_skb_info->cur_skb = new_skb;
+	cur_bat_skb->skb = NULL;
+	return 0;
+}
+
+static int dpmaif_get_rx_pkt(struct dpmaif_rx_queue *rxq,
+			     const struct dpmaif_normal_pit *pkt_info,
+			     struct dpmaif_cur_rx_skb_info *rx_skb_info)
+{
+	unsigned int cur_bid;
+	int ret;
+
+	cur_bid = normal_pit_bid(pkt_info);
+	ret = bat_cur_bid_check(rxq, cur_bid);
+	if (ret < 0)
+		return ret;
+
+	ret = dpmaif_rx_set_data_to_skb(rxq, pkt_info, rx_skb_info);
+	if (ret < 0) {
+		dev_err(rxq->dpmaif_ctrl->dev, "rx set data to skb failed, ret = %d\n", ret);
+		return ret;
+	}
+
+	dpmaif_set_bat_mask(rxq->dpmaif_ctrl->dev, rxq->bat_req, cur_bid);
+	return 0;
+}
+
+static int dpmaifq_rx_notify_hw(struct dpmaif_rx_queue *rxq)
+{
+	struct dpmaif_ctrl *dpmaif_ctrl;
+	int ret;
+
+	dpmaif_ctrl = rxq->dpmaif_ctrl;
+
+	/* normal BAT release and add */
+	queue_work(dpmaif_ctrl->bat_release_work_queue, &dpmaif_ctrl->bat_release_work);
+
+	ret = dpmaif_dl_pit_release_and_add(rxq);
+	if (ret < 0)
+		dev_err(dpmaif_ctrl->dev, "dlq%d update PIT fail\n", rxq->index);
+
+	return ret;
+}
+
+static void dpmaif_rx_skb(struct dpmaif_rx_queue *rxq, struct dpmaif_cur_rx_skb_info *rx_skb_info)
+{
+	struct sk_buff *new_skb;
+	u32 *lhif_header;
+
+	new_skb = rx_skb_info->cur_skb;
+	rx_skb_info->cur_skb = NULL;
+
+	if (rx_skb_info->pit_dp) {
+		dev_kfree_skb_any(new_skb);
+		return;
+	}
+
+	dpmaif_set_skb_cs_type(rx_skb_info->check_sum, new_skb);
+
+	/* MD put the ccmni_index to the msg pkt,
+	 * so we need push it alone. Maybe not needed.
+	 */
+	lhif_header = skb_push(new_skb, sizeof(*lhif_header));
+	*lhif_header &= ~LHIF_HEADER_NETIF;
+	*lhif_header |= FIELD_PREP(LHIF_HEADER_NETIF, rx_skb_info->cur_chn_idx);
+
+	/* add data to rx thread skb list */
+	ccci_skb_enqueue(&rxq->skb_queue, new_skb);
+}
+
+static int dpmaif_rx_start(struct dpmaif_rx_queue *rxq, const unsigned short pit_cnt,
+			   const unsigned long timeout)
+{
+	struct dpmaif_cur_rx_skb_info *cur_rx_skb_info;
+	unsigned short rx_cnt, recv_skb_cnt = 0;
+	unsigned int cur_pit, pit_len;
+	int ret = 0, ret_hw = 0;
+	struct device *dev;
+
+	dev = rxq->dpmaif_ctrl->dev;
+	if (!rxq->pit_base)
+		return -EAGAIN;
+
+	pit_len = rxq->pit_size_cnt;
+	cur_rx_skb_info = &rxq->rx_data_info;
+	cur_pit = rxq->pit_rd_idx;
+
+	for (rx_cnt = 0; rx_cnt < pit_cnt; rx_cnt++) {
+		struct dpmaif_normal_pit *pkt_info;
+
+		if (!cur_rx_skb_info->msg_pit_received && time_after_eq(jiffies, timeout))
+			break;
+
+		pkt_info = (struct dpmaif_normal_pit *)rxq->pit_base + cur_pit;
+
+		if (dpmaif_check_pit_seq(rxq, pkt_info)) {
+			dev_err_ratelimited(dev, "dlq%u checks PIT SEQ fail\n", rxq->index);
+			return -EAGAIN;
+		}
+
+		if (FIELD_GET(NORMAL_PIT_PACKET_TYPE, pkt_info->pit_header) == DES_PT_MSG) {
+			if (cur_rx_skb_info->msg_pit_received)
+				dev_err(dev, "dlq%u receive repeat msg_pit err\n", rxq->index);
+			cur_rx_skb_info->msg_pit_received = true;
+			dpmaif_rx_msg_pit(rxq, (struct dpmaif_msg_pit *)pkt_info,
+					  cur_rx_skb_info);
+		} else { /* DES_PT_PD */
+			if (FIELD_GET(NORMAL_PIT_BUFFER_TYPE, pkt_info->pit_header) !=
+			    PKT_BUF_FRAG) {
+				/* skb->data: add to skb ptr && record ptr */
+				ret = dpmaif_get_rx_pkt(rxq, pkt_info, cur_rx_skb_info);
+			} else if (!cur_rx_skb_info->cur_skb) {
+				/* msg + frag PIT, no data pkt received */
+				dev_err(dev,
+					"rxq%d skb_idx < 0 PIT/BAT = %d, %d; buf: %ld; %d, %d\n",
+					rxq->index, cur_pit, normal_pit_bid(pkt_info),
+					FIELD_GET(NORMAL_PIT_BUFFER_TYPE, pkt_info->pit_header),
+					rx_cnt, pit_cnt);
+				ret = -EINVAL;
+			} else {
+				/* skb->frags[]: add to frags[] */
+				ret = dpmaif_get_rx_frag(rxq, pkt_info, cur_rx_skb_info);
+			}
+
+			/* check rx status */
+			if (ret < 0) {
+				cur_rx_skb_info->err_payload = 1;
+				dev_err_ratelimited(dev, "rxq%d error payload\n", rxq->index);
+			}
+
+			if (!FIELD_GET(NORMAL_PIT_CONT, pkt_info->pit_header)) {
+				if (!cur_rx_skb_info->err_payload) {
+					dpmaif_rx_skb(rxq, cur_rx_skb_info);
+				} else if (cur_rx_skb_info->cur_skb) {
+					dev_kfree_skb_any(cur_rx_skb_info->cur_skb);
+					cur_rx_skb_info->cur_skb = NULL;
+				}
+
+				/* reinit cur_rx_skb_info */
+				memset(cur_rx_skb_info, 0, sizeof(*cur_rx_skb_info));
+				recv_skb_cnt++;
+				if (!(recv_skb_cnt & DPMAIF_RX_PUSH_THRESHOLD_MASK)) {
+					wake_up_all(&rxq->rx_wq);
+					recv_skb_cnt = 0;
+				}
+			}
+		}
+
+		/* get next pointer to get pkt data */
+		cur_pit = ring_buf_get_next_wrdx(pit_len, cur_pit);
+		rxq->pit_rd_idx = cur_pit;
+
+		/* notify HW++ */
+		rxq->pit_remain_release_cnt++;
+		if (rx_cnt > 0 && !(rx_cnt % DPMAIF_NOTIFY_RELEASE_COUNT)) {
+			ret_hw = dpmaifq_rx_notify_hw(rxq);
+			if (ret_hw < 0)
+				break;
+		}
+	}
+
+	/* still need sync to SW/HW cnt */
+	if (recv_skb_cnt)
+		wake_up_all(&rxq->rx_wq);
+
+	/* update to HW */
+	if (!ret_hw)
+		ret_hw = dpmaifq_rx_notify_hw(rxq);
+
+	if (ret_hw < 0 && !ret)
+		ret = ret_hw;
+
+	return ret < 0 ? ret : rx_cnt;
+}
+
+static unsigned int dpmaifq_poll_rx_pit(struct dpmaif_rx_queue *rxq)
+{
+	unsigned short hw_wr_idx;
+	unsigned int pit_cnt;
+
+	if (!rxq->que_started)
+		return 0;
+
+	hw_wr_idx = dpmaif_dl_dlq_pit_get_wridx(&rxq->dpmaif_ctrl->hif_hw_info, rxq->index);
+	pit_cnt = ring_buf_read_write_count(rxq->pit_size_cnt, rxq->pit_rd_idx, hw_wr_idx, true);
+	rxq->pit_wr_idx = hw_wr_idx;
+	return pit_cnt;
+}
+
+static int dpmaif_rx_data_collect(struct dpmaif_ctrl *dpmaif_ctrl,
+				  const unsigned char q_num, const int budget)
+{
+	struct dpmaif_rx_queue *rxq;
+	unsigned long time_limit;
+	unsigned int cnt;
+
+	time_limit = jiffies + msecs_to_jiffies(DPMAIF_WQ_TIME_LIMIT_MS);
+	rxq = &dpmaif_ctrl->rxq[q_num];
+
+	do {
+		cnt = dpmaifq_poll_rx_pit(rxq);
+		if (cnt) {
+			unsigned int rd_cnt = (cnt > budget) ? budget : cnt;
+			int real_cnt = dpmaif_rx_start(rxq, rd_cnt, time_limit);
+
+			if (real_cnt < 0) {
+				if (real_cnt != -EAGAIN)
+					dev_err(dpmaif_ctrl->dev, "dlq%u rx err: %d\n",
+						rxq->index, real_cnt);
+				return real_cnt;
+			} else if (real_cnt < cnt) {
+				return -EAGAIN;
+			}
+		}
+	} while (cnt);
+
+	return 0;
+}
+
+static void dpmaif_do_rx(struct dpmaif_ctrl *dpmaif_ctrl, struct dpmaif_rx_queue *rxq)
+{
+	int ret;
+
+	ret = dpmaif_rx_data_collect(dpmaif_ctrl, rxq->index, rxq->budget);
+	if (ret < 0) {
+		/* Rx done and empty interrupt will be enabled in workqueue */
+		/* Try one more time */
+		queue_work(rxq->worker, &rxq->dpmaif_rxq_work);
+		dpmaif_clr_ip_busy_sts(&dpmaif_ctrl->hif_hw_info);
+	} else {
+		dpmaif_clr_ip_busy_sts(&dpmaif_ctrl->hif_hw_info);
+		dpmaif_hw_dlq_unmask_rx_done(&dpmaif_ctrl->hif_hw_info, rxq->index);
+	}
+}
+
+static void dpmaif_rxq_work(struct work_struct *work)
+{
+	struct dpmaif_ctrl *dpmaif_ctrl;
+	struct dpmaif_rx_queue *rxq;
+
+	rxq = container_of(work, struct dpmaif_rx_queue, dpmaif_rxq_work);
+	dpmaif_ctrl = rxq->dpmaif_ctrl;
+
+	atomic_set(&rxq->rx_processing, 1);
+	 /* Ensure rx_processing is changed to 1 before actually begin RX flow */
+	smp_mb();
+
+	if (!rxq->que_started) {
+		atomic_set(&rxq->rx_processing, 0);
+		dev_err(dpmaif_ctrl->dev, "work RXQ: %d has not been started\n", rxq->index);
+		return;
+	}
+
+	dpmaif_do_rx(dpmaif_ctrl, rxq);
+
+	atomic_set(&rxq->rx_processing, 0);
+}
+
+void dpmaif_irq_rx_done(struct dpmaif_ctrl *dpmaif_ctrl, const unsigned int que_mask)
+{
+	struct dpmaif_rx_queue *rxq;
+	int qno;
+
+	/* get the queue id */
+	qno = ffs(que_mask) - 1;
+	if (qno < 0 || qno > DPMAIF_RXQ_NUM - 1) {
+		dev_err(dpmaif_ctrl->dev, "rxq number err, qno:%u\n", qno);
+		return;
+	}
+
+	rxq = &dpmaif_ctrl->rxq[qno];
+	queue_work(rxq->worker, &rxq->dpmaif_rxq_work);
+}
+
+static void dpmaif_base_free(const struct dpmaif_ctrl *dpmaif_ctrl,
+			     const struct dpmaif_bat_request *bat_req)
+{
+	if (bat_req->bat_base)
+		dma_free_coherent(dpmaif_ctrl->dev,
+				  bat_req->bat_size_cnt * sizeof(struct dpmaif_bat),
+				  bat_req->bat_base, bat_req->bat_bus_addr);
+}
+
+/**
+ * dpmaif_bat_alloc() - Allocate the BAT ring buffer
+ * @dpmaif_ctrl: Pointer to DPMAIF context structure
+ * @bat_req: Pointer to BAT request structure
+ * @buf_type: BAT ring type
+ *
+ * This function allocates the BAT ring buffer shared with the HW device, also allocates
+ * a buffer used to store information about the BAT skbs for further release.
+ *
+ * Return: 0 on success, a negative error code on failure
+ */
+int dpmaif_bat_alloc(const struct dpmaif_ctrl *dpmaif_ctrl,
+		     struct dpmaif_bat_request *bat_req,
+		     const enum bat_type buf_type)
+{
+	int sw_buf_size;
+
+	sw_buf_size = (buf_type == BAT_TYPE_FRAG) ?
+		sizeof(struct dpmaif_bat_page) : sizeof(struct dpmaif_bat_skb);
+
+	bat_req->bat_size_cnt = (buf_type == BAT_TYPE_FRAG) ? DPMAIF_FRG_COUNT : DPMAIF_BAT_COUNT;
+
+	bat_req->skb_pkt_cnt = bat_req->bat_size_cnt;
+	bat_req->pkt_buf_sz = (buf_type == BAT_TYPE_FRAG) ? DPMAIF_HW_FRG_PKTBUF : NET_RX_BUF;
+
+	bat_req->type = buf_type;
+	bat_req->bat_wr_idx = 0;
+	bat_req->bat_release_rd_idx = 0;
+
+	/* alloc buffer for HW && AP SW */
+	bat_req->bat_base = dma_alloc_coherent(dpmaif_ctrl->dev,
+					       bat_req->bat_size_cnt * sizeof(struct dpmaif_bat),
+					       &bat_req->bat_bus_addr, GFP_KERNEL | __GFP_ZERO);
+
+	if (!bat_req->bat_base)
+		return -ENOMEM;
+
+	/* alloc buffer for AP SW to record skb information */
+	bat_req->bat_skb_ptr = devm_kzalloc(dpmaif_ctrl->dev, bat_req->skb_pkt_cnt * sw_buf_size,
+					    GFP_KERNEL);
+
+	if (!bat_req->bat_skb_ptr)
+		goto err_base;
+
+	/* alloc buffer for BAT mask */
+	bat_req->bat_mask = kcalloc(bat_req->bat_size_cnt, sizeof(unsigned char), GFP_KERNEL);
+	if (!bat_req->bat_mask)
+		goto err_base;
+
+	spin_lock_init(&bat_req->mask_lock);
+	atomic_set(&bat_req->refcnt, 0);
+	return 0;
+
+err_base:
+	dpmaif_base_free(dpmaif_ctrl, bat_req);
+
+	return -ENOMEM;
+}
+
+static void unmap_bat_skb(struct device *dev, struct dpmaif_bat_skb *bat_skb_base,
+			  unsigned int index)
+{
+	struct dpmaif_bat_skb *bat_skb;
+
+	bat_skb = bat_skb_base + index;
+
+	if (bat_skb->skb) {
+		dma_unmap_single(dev, bat_skb->data_bus_addr, bat_skb->data_len,
+				 DMA_FROM_DEVICE);
+		kfree_skb(bat_skb->skb);
+		bat_skb->skb = NULL;
+	}
+}
+
+static void unmap_bat_page(struct device *dev, struct dpmaif_bat_page *bat_page_base,
+			   unsigned int index)
+{
+	struct dpmaif_bat_page *bat_page;
+
+	bat_page = bat_page_base + index;
+
+	if (bat_page->page) {
+		dma_unmap_page(dev, bat_page->data_bus_addr, bat_page->data_len,
+			       DMA_FROM_DEVICE);
+		put_page(bat_page->page);
+		bat_page->page = NULL;
+	}
+}
+
+void dpmaif_bat_free(const struct dpmaif_ctrl *dpmaif_ctrl,
+		     struct dpmaif_bat_request *bat_req)
+{
+	if (!bat_req)
+		return;
+
+	if (!atomic_dec_and_test(&bat_req->refcnt))
+		return;
+
+	kfree(bat_req->bat_mask);
+	bat_req->bat_mask = NULL;
+
+	if (bat_req->bat_skb_ptr) {
+		unsigned int i;
+
+		for (i = 0; i < bat_req->bat_size_cnt; i++) {
+			if (bat_req->type == BAT_TYPE_FRAG)
+				unmap_bat_page(dpmaif_ctrl->dev, bat_req->bat_skb_ptr, i);
+			else
+				unmap_bat_skb(dpmaif_ctrl->dev, bat_req->bat_skb_ptr, i);
+		}
+	}
+
+	dpmaif_base_free(dpmaif_ctrl, bat_req);
+}
+
+static int dpmaif_rx_alloc(struct dpmaif_rx_queue *rxq)
+{
+	/* PIT buffer init */
+	rxq->pit_size_cnt = DPMAIF_PIT_COUNT;
+	rxq->pit_rd_idx = 0;
+	rxq->pit_wr_idx = 0;
+	rxq->pit_release_rd_idx = 0;
+	rxq->expect_pit_seq = 0;
+	rxq->pit_remain_release_cnt = 0;
+
+	memset(&rxq->rx_data_info, 0, sizeof(rxq->rx_data_info));
+
+	/* PIT allocation */
+	rxq->pit_base = dma_alloc_coherent(rxq->dpmaif_ctrl->dev,
+					   rxq->pit_size_cnt * sizeof(struct dpmaif_normal_pit),
+					   &rxq->pit_bus_addr, GFP_KERNEL | __GFP_ZERO);
+
+	if (!rxq->pit_base)
+		return -ENOMEM;
+
+	/* RXQ BAT table init */
+	rxq->bat_req = &rxq->dpmaif_ctrl->bat_req;
+	atomic_inc(&rxq->bat_req->refcnt);
+
+	/* RXQ Frag BAT table init */
+	rxq->bat_frag = &rxq->dpmaif_ctrl->bat_frag;
+	atomic_inc(&rxq->bat_frag->refcnt);
+	return 0;
+}
+
+static void dpmaif_rx_buf_free(const struct dpmaif_rx_queue *rxq)
+{
+	if (!rxq->dpmaif_ctrl)
+		return;
+
+	dpmaif_bat_free(rxq->dpmaif_ctrl, rxq->bat_req);
+	dpmaif_bat_free(rxq->dpmaif_ctrl, rxq->bat_frag);
+
+	if (rxq->pit_base)
+		dma_free_coherent(rxq->dpmaif_ctrl->dev,
+				  rxq->pit_size_cnt * sizeof(struct dpmaif_normal_pit),
+				  rxq->pit_base, rxq->pit_bus_addr);
+}
+
+int dpmaif_rxq_alloc(struct dpmaif_rx_queue *queue)
+{
+	int ret;
+
+	/* rxq data (PIT, BAT...) allocation */
+	ret = dpmaif_rx_alloc(queue);
+	if (ret < 0) {
+		dev_err(queue->dpmaif_ctrl->dev, "rx buffer alloc fail, %d\n", ret);
+		return ret;
+	}
+
+	INIT_WORK(&queue->dpmaif_rxq_work, dpmaif_rxq_work);
+	queue->worker = alloc_workqueue("dpmaif_rx%d_worker",
+					WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI,
+					1, queue->index);
+	if (!queue->worker)
+		return -ENOMEM;
+
+	/* rx push thread and skb list init */
+	init_waitqueue_head(&queue->rx_wq);
+	ccci_skb_queue_alloc(&queue->skb_queue, queue->bat_req->skb_pkt_cnt,
+			     queue->bat_req->pkt_buf_sz, false);
+	queue->rx_thread = kthread_run(dpmaif_net_rx_push_thread,
+				       queue, "dpmaif_rx%d_push", queue->index);
+	if (IS_ERR(queue->rx_thread)) {
+		dev_err(queue->dpmaif_ctrl->dev, "failed to start rx thread\n");
+		return PTR_ERR(queue->rx_thread);
+	}
+
+	return 0;
+}
+
+void dpmaif_rxq_free(struct dpmaif_rx_queue *queue)
+{
+	struct sk_buff *skb;
+
+	if (queue->worker)
+		destroy_workqueue(queue->worker);
+
+	if (queue->rx_thread)
+		kthread_stop(queue->rx_thread);
+
+	while ((skb = skb_dequeue(&queue->skb_queue.skb_list)))
+		kfree_skb(skb);
+
+	dpmaif_rx_buf_free(queue);
+}
+
+void dpmaif_skb_queue_free(struct dpmaif_ctrl *dpmaif_ctrl, const unsigned int index)
+{
+	struct dpmaif_skb_queue *queue;
+
+	queue = &dpmaif_ctrl->skb_pool.queue[index];
+	while (!list_empty(&queue->skb_list.head)) {
+		struct list_head *entry = dpmaif_map_skb_deq(&queue->skb_list);
+
+		if (entry) {
+			struct dpmaif_skb_info *skb_info = GET_SKB_BY_ENTRY(entry);
+
+			if (skb_info) {
+				if (skb_info->skb) {
+					dev_kfree_skb_any(skb_info->skb);
+					skb_info->skb = NULL;
+				}
+
+				kfree(skb_info);
+			}
+		}
+	}
+}
+
+static void skb_reload_work(struct work_struct *work)
+{
+	struct dpmaif_ctrl *dpmaif_ctrl;
+	struct dpmaif_skb_pool *pool;
+	unsigned int i;
+
+	pool = container_of(work, struct dpmaif_skb_pool, reload_work);
+	dpmaif_ctrl = container_of(pool, struct dpmaif_ctrl, skb_pool);
+
+	for (i = 0; i < DPMA_SKB_QUEUE_CNT; i++) {
+		struct dpmaif_skb_queue *queue = &pool->queue[i];
+		unsigned int cnt, qlen, size, max_cnt;
+		unsigned long flags;
+
+		spin_lock_irqsave(&queue->skb_list.lock, flags);
+		size = queue->size;
+		max_cnt = queue->max_len;
+		qlen = queue->skb_list.qlen;
+		spin_unlock_irqrestore(&queue->skb_list.lock, flags);
+
+		if (qlen >= max_cnt * DPMAIF_RELOAD_TH_1 / DPMAIF_RELOAD_TH_2)
+			continue;
+
+		cnt = max_cnt - qlen;
+		while (cnt--) {
+			struct dpmaif_skb_info *skb_info;
+
+			skb_info = dpmaif_dev_alloc_skb(dpmaif_ctrl, size);
+			if (!skb_info)
+				return;
+
+			spin_lock_irqsave(&queue->skb_list.lock, flags);
+			list_add_tail(&skb_info->entry, &queue->skb_list.head);
+			queue->skb_list.qlen++;
+			spin_unlock_irqrestore(&queue->skb_list.lock, flags);
+		}
+	}
+}
+
+static int dpmaif_skb_queue_init_struct(struct dpmaif_ctrl *dpmaif_ctrl,
+					const unsigned int index)
+{
+	struct dpmaif_skb_queue *queue;
+	unsigned int max_cnt, size;
+
+	queue = &dpmaif_ctrl->skb_pool.queue[index];
+	size = DPMAIF_HW_BAT_PKTBUF / BIT(index);
+	max_cnt = DPMAIF_SKB_Q_SIZE / DPMAIF_SKB_SIZE(size);
+
+	if (size < DPMAIF_SKB_SIZE_MIN)
+		return -EINVAL;
+
+	INIT_LIST_HEAD(&queue->skb_list.head);
+	spin_lock_init(&queue->skb_list.lock);
+	queue->skb_list.qlen = 0;
+	queue->size = size;
+	queue->max_len = max_cnt;
+	return 0;
+}
+
+/**
+ * dpmaif_skb_pool_init() - Initialize DPMAIF SKB pool
+ * @dpmaif_ctrl: Pointer to data path control struct dpmaif_ctrl
+ *
+ * Init the DPMAIF SKB queue structures that includes SKB pool, work and workqueue.
+ *
+ * Return: Zero on success and negative errno on failure
+ */
+int dpmaif_skb_pool_init(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct dpmaif_skb_pool *pool;
+	int i;
+
+	pool = &dpmaif_ctrl->skb_pool;
+	pool->queue_cnt = DPMA_SKB_QUEUE_CNT;
+
+	/* init the skb queue structure */
+	for (i = 0; i < pool->queue_cnt; i++) {
+		int ret = dpmaif_skb_queue_init_struct(dpmaif_ctrl, i);
+
+		if (ret) {
+			dev_err(dpmaif_ctrl->dev, "Init skb_queue:%d fail\n", i);
+			return ret;
+		}
+	}
+
+	/* init pool reload work */
+	pool->reload_work_queue = alloc_workqueue("dpmaif_skb_pool_reload_work",
+						  WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
+	if (!pool->reload_work_queue) {
+		dev_err(dpmaif_ctrl->dev, "Create the reload_work_queue fail\n");
+		return -ENOMEM;
+	}
+
+	INIT_WORK(&pool->reload_work, skb_reload_work);
+	queue_work(pool->reload_work_queue, &pool->reload_work);
+
+	return 0;
+}
+
+static void dpmaif_bat_release_work(struct work_struct *work)
+{
+	struct dpmaif_ctrl *dpmaif_ctrl;
+	struct dpmaif_rx_queue *rxq;
+
+	dpmaif_ctrl = container_of(work, struct dpmaif_ctrl, bat_release_work);
+
+	/* ALL RXQ use one BAT table, so choose DPF_RX_QNO_DFT */
+	rxq = &dpmaif_ctrl->rxq[DPF_RX_QNO_DFT];
+
+	/* normal BAT release and add */
+	dpmaif_dl_pkt_bat_release_and_add(rxq);
+	/* frag BAT release and add */
+	dpmaif_dl_frag_bat_release_and_add(rxq);
+}
+
+int dpmaif_bat_release_work_alloc(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	dpmaif_ctrl->bat_release_work_queue =
+		alloc_workqueue("dpmaif_bat_release_work_queue", WQ_MEM_RECLAIM, 1);
+
+	if (!dpmaif_ctrl->bat_release_work_queue)
+		return -ENOMEM;
+
+	INIT_WORK(&dpmaif_ctrl->bat_release_work, dpmaif_bat_release_work);
+
+	return 0;
+}
+
+void dpmaif_bat_release_work_free(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	flush_work(&dpmaif_ctrl->bat_release_work);
+
+	if (dpmaif_ctrl->bat_release_work_queue) {
+		destroy_workqueue(dpmaif_ctrl->bat_release_work_queue);
+		dpmaif_ctrl->bat_release_work_queue = NULL;
+	}
+}
+
+/**
+ * dpmaif_suspend_rx_sw_stop() - Suspend RX flow
+ * @dpmaif_ctrl: Pointer to data path control struct dpmaif_ctrl
+ *
+ * Wait for all the RX work to finish executing and mark the RX queue as paused
+ *
+ */
+void dpmaif_suspend_rx_sw_stop(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	unsigned int i;
+
+	/* Disable DL/RX SW active */
+	for (i = 0; i < DPMAIF_RXQ_NUM; i++) {
+		struct dpmaif_rx_queue *rxq;
+		int timeout, value;
+
+		rxq = &dpmaif_ctrl->rxq[i];
+		flush_work(&rxq->dpmaif_rxq_work);
+
+		timeout = readx_poll_timeout_atomic(atomic_read, &rxq->rx_processing, value,
+						    !value, 0, DPMAIF_CHECK_INIT_TIMEOUT_US);
+
+		if (timeout)
+			dev_err(dpmaif_ctrl->dev, "Stop RX SW failed\n");
+
+		/* Ensure RX processing has already been stopped before we toggle
+		 * the rxq->que_started to false during RX suspend flow.
+		 */
+		smp_mb();
+		rxq->que_started = false;
+	}
+}
+
+static void dpmaif_stop_rxq(struct dpmaif_rx_queue *rxq)
+{
+	int cnt, j = 0;
+
+	flush_work(&rxq->dpmaif_rxq_work);
+
+	/* reset SW */
+	rxq->que_started = false;
+	do {
+		/* disable HW arb and check idle */
+		cnt = ring_buf_read_write_count(rxq->pit_size_cnt, rxq->pit_rd_idx,
+						rxq->pit_wr_idx, true);
+		/* retry handler */
+		if (++j >= DPMAIF_MAX_CHECK_COUNT) {
+			dev_err(rxq->dpmaif_ctrl->dev, "stop RX SW failed, %d\n", cnt);
+			break;
+		}
+	} while (cnt);
+
+	memset(rxq->pit_base, 0, rxq->pit_size_cnt * sizeof(struct dpmaif_normal_pit));
+	memset(rxq->bat_req->bat_base, 0, rxq->bat_req->bat_size_cnt * sizeof(struct dpmaif_bat));
+	memset(rxq->bat_req->bat_mask, 0, rxq->bat_req->bat_size_cnt * sizeof(unsigned char));
+	memset(&rxq->rx_data_info, 0, sizeof(rxq->rx_data_info));
+
+	rxq->pit_rd_idx = 0;
+	rxq->pit_wr_idx = 0;
+	rxq->pit_release_rd_idx = 0;
+
+	rxq->expect_pit_seq = 0;
+	rxq->pit_remain_release_cnt = 0;
+
+	rxq->bat_req->bat_release_rd_idx = 0;
+	rxq->bat_req->bat_wr_idx = 0;
+
+	rxq->bat_frag->bat_release_rd_idx = 0;
+	rxq->bat_frag->bat_wr_idx = 0;
+}
+
+void dpmaif_stop_rx_sw(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	int i;
+
+	for (i = 0; i < DPMAIF_RXQ_NUM; i++)
+		dpmaif_stop_rxq(&dpmaif_ctrl->rxq[i]);
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h
new file mode 100644
index 000000000000..4d571593be3e
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h
@@ -0,0 +1,110 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_HIF_DPMA_RX_H__
+#define __T7XX_HIF_DPMA_RX_H__
+
+#include <linux/bitfield.h>
+#include <linux/types.h>
+
+#include "t7xx_hif_dpmaif.h"
+
+/* lhif header feilds */
+#define LHIF_HEADER_NW_TYPE	GENMASK(31, 29)
+#define LHIF_HEADER_NETIF	GENMASK(28, 24)
+#define LHIF_HEADER_F		GENMASK(22, 20)
+#define LHIF_HEADER_FLOW	GENMASK(19, 16)
+
+/* Structure of DL PIT */
+struct dpmaif_normal_pit {
+	unsigned int	pit_header;
+	unsigned int	p_data_addr;
+	unsigned int	data_addr_ext;
+	unsigned int	pit_footer;
+};
+
+/* pit_header fields */
+#define NORMAL_PIT_DATA_LEN	GENMASK(31, 16)
+#define NORMAL_PIT_BUFFER_ID	GENMASK(15, 3)
+#define NORMAL_PIT_BUFFER_TYPE	BIT(2)
+#define NORMAL_PIT_CONT		BIT(1)
+#define NORMAL_PIT_PACKET_TYPE	BIT(0)
+/* pit_footer fields */
+#define NORMAL_PIT_DLQ_DONE	GENMASK(31, 30)
+#define NORMAL_PIT_ULQ_DONE	GENMASK(29, 24)
+#define NORMAL_PIT_HEADER_OFFSET GENMASK(23, 19)
+#define NORMAL_PIT_BI_F		GENMASK(18, 17)
+#define NORMAL_PIT_IG		BIT(16)
+#define NORMAL_PIT_RES		GENMASK(15, 11)
+#define NORMAL_PIT_H_BID	GENMASK(10, 8)
+#define NORMAL_PIT_PIT_SEQ	GENMASK(7, 0)
+
+struct dpmaif_msg_pit {
+	unsigned int	dword1;
+	unsigned int	dword2;
+	unsigned int	dword3;
+	unsigned int	dword4;
+};
+
+/* double word 1 */
+#define MSG_PIT_DP		BIT(31)
+#define MSG_PIT_RES		GENMASK(30, 27)
+#define MSG_PIT_NETWORK_TYPE	GENMASK(26, 24)
+#define MSG_PIT_CHANNEL_ID	GENMASK(23, 16)
+#define MSG_PIT_RES2		GENMASK(15, 12)
+#define MSG_PIT_HPC_IDX		GENMASK(11, 8)
+#define MSG_PIT_SRC_QID		GENMASK(7, 5)
+#define MSG_PIT_ERROR_BIT	BIT(4)
+#define MSG_PIT_CHECKSUM	GENMASK(3, 2)
+#define MSG_PIT_CONT		BIT(1)
+#define MSG_PIT_PACKET_TYPE	BIT(0)
+
+/* double word 2 */
+#define MSG_PIT_HP_IDX		GENMASK(31, 27)
+#define MSG_PIT_CMD		GENMASK(26, 24)
+#define MSG_PIT_RES3		GENMASK(23, 21)
+#define MSG_PIT_FLOW		GENMASK(20, 16)
+#define MSG_PIT_COUNT		GENMASK(15, 0)
+
+/* double word 3 */
+#define MSG_PIT_HASH		GENMASK(31, 24)
+#define MSG_PIT_RES4		GENMASK(23, 18)
+#define MSG_PIT_PRO		GENMASK(17, 16)
+#define MSG_PIT_VBID		GENMASK(15, 3)
+#define MSG_PIT_RES5		GENMASK(2, 0)
+
+/* dwourd 4 */
+#define MSG_PIT_DLQ_DONE	GENMASK(31, 30)
+#define MSG_PIT_ULQ_DONE	GENMASK(29, 24)
+#define MSG_PIT_IP		BIT(23)
+#define MSG_PIT_RES6		BIT(22)
+#define MSG_PIT_MR		GENMASK(21, 20)
+#define MSG_PIT_RES7		GENMASK(19, 17)
+#define MSG_PIT_IG		BIT(16)
+#define MSG_PIT_RES8		GENMASK(15, 11)
+#define MSG_PIT_H_BID		GENMASK(10, 8)
+#define MSG_PIT_PIT_SEQ		GENMASK(7, 0)
+
+int dpmaif_rxq_alloc(struct dpmaif_rx_queue *queue);
+void dpmaif_stop_rx_sw(struct dpmaif_ctrl *dpmaif_ctrl);
+int dpmaif_bat_release_work_alloc(struct dpmaif_ctrl *dpmaif_ctrl);
+int dpmaif_rx_buf_alloc(struct dpmaif_ctrl *dpmaif_ctrl,
+			const struct dpmaif_bat_request *bat_req, const unsigned char q_num,
+			const unsigned int buf_cnt, const bool first_time);
+void dpmaif_skb_queue_free(struct dpmaif_ctrl *dpmaif_ctrl, const unsigned int index);
+int dpmaif_skb_pool_init(struct dpmaif_ctrl *dpmaif_ctrl);
+int dpmaif_rx_frag_alloc(struct dpmaif_ctrl *dpmaif_ctrl, struct dpmaif_bat_request *bat_req,
+			 unsigned char q_num, const unsigned int buf_cnt, const bool first_time);
+void dpmaif_suspend_rx_sw_stop(struct dpmaif_ctrl *dpmaif_ctrl);
+void dpmaif_irq_rx_done(struct dpmaif_ctrl *dpmaif_ctrl, const unsigned int que_mask);
+void dpmaif_rxq_free(struct dpmaif_rx_queue *queue);
+void dpmaif_bat_release_work_free(struct dpmaif_ctrl *dpmaif_ctrl);
+int dpmaif_bat_alloc(const struct dpmaif_ctrl *dpmaif_ctrl, struct dpmaif_bat_request *bat_req,
+		     const enum bat_type buf_type);
+void dpmaif_bat_free(const struct dpmaif_ctrl *dpmaif_ctrl,
+		     struct dpmaif_bat_request *bat_req);
+
+#endif /* __T7XX_HIF_DPMA_RX_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
new file mode 100644
index 000000000000..70f1547fbaff
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
@@ -0,0 +1,802 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+#include "t7xx_common.h"
+#include "t7xx_dpmaif.h"
+#include "t7xx_hif_dpmaif.h"
+#include "t7xx_hif_dpmaif_tx.h"
+
+#define DPMAIF_SKB_TX_BURST_CNT	5
+#define DPMAIF_DRB_ENTRY_SIZE	6144
+
+/* DRB dtype */
+#define DES_DTYP_PD		0
+#define DES_DTYP_MSG		1
+
+static unsigned int dpmaifq_poll_tx_drb(struct dpmaif_ctrl *dpmaif_ctrl, unsigned char q_num)
+{
+	unsigned short old_sw_rd_idx, new_hw_rd_idx;
+	struct dpmaif_tx_queue *txq;
+	unsigned int hw_read_idx;
+	unsigned int drb_cnt = 0;
+	unsigned long flags;
+
+	txq = &dpmaif_ctrl->txq[q_num];
+	if (!txq->que_started)
+		return drb_cnt;
+
+	old_sw_rd_idx = txq->drb_rd_idx;
+
+	hw_read_idx = dpmaif_ul_get_ridx(&dpmaif_ctrl->hif_hw_info, q_num);
+
+	new_hw_rd_idx = hw_read_idx / DPMAIF_UL_DRB_ENTRY_WORD;
+
+	if (new_hw_rd_idx >= DPMAIF_DRB_ENTRY_SIZE) {
+		dev_err(dpmaif_ctrl->dev, "out of range read index: %u\n", new_hw_rd_idx);
+		return 0;
+	}
+
+	if (old_sw_rd_idx <= new_hw_rd_idx)
+		drb_cnt = new_hw_rd_idx - old_sw_rd_idx;
+	else
+		drb_cnt = txq->drb_size_cnt - old_sw_rd_idx + new_hw_rd_idx;
+
+	spin_lock_irqsave(&txq->tx_lock, flags);
+	txq->drb_rd_idx = new_hw_rd_idx;
+	spin_unlock_irqrestore(&txq->tx_lock, flags);
+	return drb_cnt;
+}
+
+static unsigned short dpmaif_release_tx_buffer(struct dpmaif_ctrl *dpmaif_ctrl,
+					       unsigned char q_num, unsigned int release_cnt)
+{
+	struct dpmaif_drb_skb *cur_drb_skb, *drb_skb_base;
+	struct dpmaif_drb_pd *cur_drb, *drb_base;
+	struct dpmaif_tx_queue *txq;
+	struct dpmaif_callbacks *cb;
+	unsigned int drb_cnt, i;
+	unsigned short cur_idx;
+	unsigned long flags;
+
+	if (!release_cnt)
+		return 0;
+
+	txq = &dpmaif_ctrl->txq[q_num];
+	drb_skb_base = txq->drb_skb_base;
+	drb_base = txq->drb_base;
+	cb = dpmaif_ctrl->callbacks;
+
+	spin_lock_irqsave(&txq->tx_lock, flags);
+	drb_cnt = txq->drb_size_cnt;
+	cur_idx = txq->drb_release_rd_idx;
+	spin_unlock_irqrestore(&txq->tx_lock, flags);
+
+	for (i = 0; i < release_cnt; i++) {
+		cur_drb = drb_base + cur_idx;
+		if (FIELD_GET(DRB_PD_DTYP, cur_drb->header) == DES_DTYP_PD) {
+			cur_drb_skb = drb_skb_base + cur_idx;
+			dma_unmap_single(dpmaif_ctrl->dev, cur_drb_skb->bus_addr,
+					 cur_drb_skb->data_len, DMA_TO_DEVICE);
+
+			if (!FIELD_GET(DRB_PD_CONT, cur_drb->header)) {
+				if (!cur_drb_skb->skb) {
+					dev_err(dpmaif_ctrl->dev,
+						"txq%u: DRB check fail, invalid skb\n", q_num);
+					continue;
+				}
+
+				dev_kfree_skb_any(cur_drb_skb->skb);
+			}
+
+			cur_drb_skb->skb = NULL;
+		} else {
+			txq->last_ch_id = FIELD_GET(DRB_MSG_CHANNEL_ID,
+						    ((struct dpmaif_drb_msg *)cur_drb)->header_dw2);
+		}
+
+		spin_lock_irqsave(&txq->tx_lock, flags);
+		cur_idx = ring_buf_get_next_wrdx(drb_cnt, cur_idx);
+		txq->drb_release_rd_idx = cur_idx;
+		spin_unlock_irqrestore(&txq->tx_lock, flags);
+
+		if (atomic_inc_return(&txq->tx_budget) > txq->drb_size_cnt / 8)
+			cb->state_notify(dpmaif_ctrl->mtk_dev,
+					 DMPAIF_TXQ_STATE_IRQ, txq->index);
+	}
+
+	if (FIELD_GET(DRB_PD_CONT, cur_drb->header))
+		dev_err(dpmaif_ctrl->dev, "txq%u: DRB not marked as the last one\n", q_num);
+
+	return i;
+}
+
+static int dpmaif_tx_release(struct dpmaif_ctrl *dpmaif_ctrl,
+			     unsigned char q_num, unsigned int budget)
+{
+	unsigned int rel_cnt, real_rel_cnt;
+	struct dpmaif_tx_queue *txq;
+
+	txq = &dpmaif_ctrl->txq[q_num];
+
+	/* update rd idx: from HW */
+	dpmaifq_poll_tx_drb(dpmaif_ctrl, q_num);
+	/* release the readable pkts */
+	rel_cnt = ring_buf_read_write_count(txq->drb_size_cnt, txq->drb_release_rd_idx,
+					    txq->drb_rd_idx, true);
+
+	real_rel_cnt = min_not_zero(budget, rel_cnt);
+
+	/* release data buff */
+	if (real_rel_cnt)
+		real_rel_cnt = dpmaif_release_tx_buffer(dpmaif_ctrl, q_num, real_rel_cnt);
+
+	return ((real_rel_cnt < rel_cnt) ? -EAGAIN : 0);
+}
+
+/* return false indicates there are remaining spurious interrupts */
+static inline bool dpmaif_no_remain_spurious_tx_done_intr(struct dpmaif_tx_queue *txq)
+{
+	return (dpmaifq_poll_tx_drb(txq->dpmaif_ctrl, txq->index) > 0);
+}
+
+static void dpmaif_tx_done(struct work_struct *work)
+{
+	struct dpmaif_ctrl *dpmaif_ctrl;
+	struct dpmaif_tx_queue *txq;
+	int ret;
+
+	txq = container_of(work, struct dpmaif_tx_queue, dpmaif_tx_work);
+	dpmaif_ctrl = txq->dpmaif_ctrl;
+
+	ret = dpmaif_tx_release(dpmaif_ctrl, txq->index, txq->drb_size_cnt);
+	if (ret == -EAGAIN ||
+	    (dpmaif_hw_check_clr_ul_done_status(&dpmaif_ctrl->hif_hw_info, txq->index) &&
+	     dpmaif_no_remain_spurious_tx_done_intr(txq))) {
+		queue_work(dpmaif_ctrl->txq[txq->index].worker,
+			   &dpmaif_ctrl->txq[txq->index].dpmaif_tx_work);
+		/* clear IP busy to give the device time to enter the low power state */
+		dpmaif_clr_ip_busy_sts(&dpmaif_ctrl->hif_hw_info);
+	} else {
+		dpmaif_clr_ip_busy_sts(&dpmaif_ctrl->hif_hw_info);
+		dpmaif_unmask_ulq_interrupt(dpmaif_ctrl, txq->index);
+	}
+}
+
+static void set_drb_msg(struct dpmaif_ctrl *dpmaif_ctrl,
+			unsigned char q_num, unsigned short cur_idx,
+			unsigned int pkt_len, unsigned short count_l,
+			unsigned char channel_id, __be16 network_type)
+{
+	struct dpmaif_drb_msg *drb_base;
+	struct dpmaif_drb_msg *drb;
+
+	drb_base = dpmaif_ctrl->txq[q_num].drb_base;
+	drb = drb_base + cur_idx;
+
+	drb->header_dw1 = FIELD_PREP(DRB_MSG_DTYP, DES_DTYP_MSG);
+	drb->header_dw1 |= FIELD_PREP(DRB_MSG_CONT, 1);
+	drb->header_dw1 |= FIELD_PREP(DRB_MSG_PACKET_LEN, pkt_len);
+
+	drb->header_dw2 = FIELD_PREP(DRB_MSG_COUNT_L, count_l);
+	drb->header_dw2 |= FIELD_PREP(DRB_MSG_CHANNEL_ID, channel_id);
+	drb->header_dw2 |= FIELD_PREP(DRB_MSG_L4_CHK, 1);
+}
+
+static void set_drb_payload(struct dpmaif_ctrl *dpmaif_ctrl, unsigned char q_num,
+			    unsigned short cur_idx, dma_addr_t data_addr,
+			    unsigned int pkt_size, char last_one)
+{
+	struct dpmaif_drb_pd *drb_base;
+	struct dpmaif_drb_pd *drb;
+
+	drb_base = dpmaif_ctrl->txq[q_num].drb_base;
+	drb = drb_base + cur_idx;
+
+	drb->header &= ~DRB_PD_DTYP;
+	drb->header |= FIELD_PREP(DRB_PD_DTYP, DES_DTYP_PD);
+
+	drb->header &= ~DRB_PD_CONT;
+	if (!last_one)
+		drb->header |= FIELD_PREP(DRB_PD_CONT, 1);
+
+	drb->header &= ~DRB_PD_DATA_LEN;
+	drb->header |= FIELD_PREP(DRB_PD_DATA_LEN, pkt_size);
+	drb->p_data_addr = lower_32_bits(data_addr);
+	drb->data_addr_ext = upper_32_bits(data_addr);
+}
+
+static void record_drb_skb(struct dpmaif_ctrl *dpmaif_ctrl, unsigned char q_num,
+			   unsigned short cur_idx, struct sk_buff *skb, unsigned short is_msg,
+			   bool is_frag, bool is_last_one, dma_addr_t bus_addr,
+			   unsigned int data_len)
+{
+	struct dpmaif_drb_skb *drb_skb_base;
+	struct dpmaif_drb_skb *drb_skb;
+
+	drb_skb_base = dpmaif_ctrl->txq[q_num].drb_skb_base;
+	drb_skb = drb_skb_base + cur_idx;
+
+	drb_skb->skb = skb;
+	drb_skb->bus_addr = bus_addr;
+	drb_skb->data_len = data_len;
+	drb_skb->config = FIELD_PREP(DRB_SKB_DRB_IDX, cur_idx);
+	drb_skb->config |= FIELD_PREP(DRB_SKB_IS_MSG, is_msg);
+	drb_skb->config |= FIELD_PREP(DRB_SKB_IS_FRAG, is_frag);
+	drb_skb->config |= FIELD_PREP(DRB_SKB_IS_LAST, is_last_one);
+}
+
+static int dpmaif_tx_send_skb_on_tx_thread(struct dpmaif_ctrl *dpmaif_ctrl,
+					   struct dpmaif_tx_event *event)
+{
+	unsigned int wt_cnt, send_cnt, payload_cnt;
+	struct skb_shared_info *info;
+	struct dpmaif_tx_queue *txq;
+	int drb_wr_idx_backup = -1;
+	struct ccci_header ccci_h;
+	bool is_frag, is_last_one;
+	bool skb_pulled = false;
+	unsigned short cur_idx;
+	unsigned int data_len;
+	int qno = event->qno;
+	dma_addr_t bus_addr;
+	unsigned long flags;
+	struct sk_buff *skb;
+	void *data_addr;
+	int ret = 0;
+
+	skb = event->skb;
+	txq = &dpmaif_ctrl->txq[qno];
+	if (!txq->que_started || dpmaif_ctrl->state != DPMAIF_STATE_PWRON)
+		return -ENODEV;
+
+	atomic_set(&txq->tx_processing, 1);
+
+	 /* Ensure tx_processing is changed to 1 before actually begin TX flow */
+	smp_mb();
+
+	info = skb_shinfo(skb);
+
+	if (info->frag_list)
+		dev_err(dpmaif_ctrl->dev, "ulq%d skb frag_list not supported!\n", qno);
+
+	payload_cnt = info->nr_frags + 1;
+	/* nr_frags: frag cnt, 1: skb->data, 1: msg DRB */
+	send_cnt = payload_cnt + 1;
+
+	ccci_h = *(struct ccci_header *)skb->data;
+	skb_pull(skb, sizeof(struct ccci_header));
+	skb_pulled = true;
+
+	spin_lock_irqsave(&txq->tx_lock, flags);
+	/* update the drb_wr_idx */
+	cur_idx = txq->drb_wr_idx;
+	drb_wr_idx_backup = cur_idx;
+	txq->drb_wr_idx += send_cnt;
+	if (txq->drb_wr_idx >= txq->drb_size_cnt)
+		txq->drb_wr_idx -= txq->drb_size_cnt;
+
+	/* 3 send data. */
+	/* 3.1 a msg drb first, then payload DRB. */
+	set_drb_msg(dpmaif_ctrl, txq->index, cur_idx, skb->len, 0, ccci_h.data[0], skb->protocol);
+	record_drb_skb(dpmaif_ctrl, txq->index, cur_idx, skb, 1, 0, 0, 0, 0);
+	spin_unlock_irqrestore(&txq->tx_lock, flags);
+
+	cur_idx = ring_buf_get_next_wrdx(txq->drb_size_cnt, cur_idx);
+
+	/* 3.2 DRB payload: skb->data + frags[] */
+	for (wt_cnt = 0; wt_cnt < payload_cnt; wt_cnt++) {
+		/* get data_addr && data_len */
+		if (!wt_cnt) {
+			data_len = skb_headlen(skb);
+			data_addr = skb->data;
+			is_frag = false;
+		} else {
+			skb_frag_t *frag = info->frags + wt_cnt - 1;
+
+			data_len = skb_frag_size(frag);
+			data_addr = skb_frag_address(frag);
+			is_frag = true;
+		}
+
+		if (wt_cnt == payload_cnt - 1)
+			is_last_one = true;
+		else
+			/* set 0~(n-1) DRB, maybe none */
+			is_last_one = false;
+
+		/* tx mapping */
+		bus_addr = dma_map_single(dpmaif_ctrl->dev, data_addr, data_len, DMA_TO_DEVICE);
+		if (dma_mapping_error(dpmaif_ctrl->dev, bus_addr)) {
+			dev_err(dpmaif_ctrl->dev, "DMA mapping fail\n");
+			ret = -ENOMEM;
+			break;
+		}
+
+		spin_lock_irqsave(&txq->tx_lock, flags);
+		set_drb_payload(dpmaif_ctrl, txq->index, cur_idx, bus_addr, data_len,
+				is_last_one);
+		record_drb_skb(dpmaif_ctrl, txq->index, cur_idx, skb, 0, is_frag,
+			       is_last_one, bus_addr, data_len);
+		spin_unlock_irqrestore(&txq->tx_lock, flags);
+
+		cur_idx = ring_buf_get_next_wrdx(txq->drb_size_cnt, cur_idx);
+	}
+
+	if (ret < 0) {
+		atomic_set(&txq->tx_processing, 0);
+		dev_err(dpmaif_ctrl->dev,
+			"send fail: drb_wr_idx_backup:%d, ret:%d\n", drb_wr_idx_backup, ret);
+
+		if (skb_pulled)
+			skb_push(skb, sizeof(struct ccci_header));
+
+		if (drb_wr_idx_backup >= 0) {
+			spin_lock_irqsave(&txq->tx_lock, flags);
+			txq->drb_wr_idx = drb_wr_idx_backup;
+			spin_unlock_irqrestore(&txq->tx_lock, flags);
+		}
+	} else {
+		atomic_sub(send_cnt, &txq->tx_budget);
+		atomic_set(&txq->tx_processing, 0);
+	}
+
+	return ret;
+}
+
+/* must be called within protection of event_lock */
+static inline void dpmaif_finish_event(struct dpmaif_tx_event *event)
+{
+	list_del(&event->entry);
+	kfree(event);
+}
+
+static bool tx_lists_are_all_empty(const struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	int i;
+
+	for (i = 0; i < DPMAIF_TXQ_NUM; i++) {
+		if (!list_empty(&dpmaif_ctrl->txq[i].tx_event_queue))
+			return false;
+	}
+
+	return true;
+}
+
+static int select_tx_queue(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	unsigned char txq_prio[TXQ_TYPE_CNT] = {TXQ_FAST, TXQ_NORMAL};
+	unsigned char txq_id, i;
+
+	for (i = 0; i < TXQ_TYPE_CNT; i++) {
+		txq_id = txq_prio[dpmaif_ctrl->txq_select_times % TXQ_TYPE_CNT];
+		if (!dpmaif_ctrl->txq[txq_id].que_started)
+			break;
+
+		if (!list_empty(&dpmaif_ctrl->txq[txq_id].tx_event_queue)) {
+			dpmaif_ctrl->txq_select_times++;
+			return txq_id;
+		}
+
+		dpmaif_ctrl->txq_select_times++;
+	}
+
+	return -EAGAIN;
+}
+
+static int txq_burst_send_skb(struct dpmaif_tx_queue *txq)
+{
+	int drb_remain_cnt, i;
+	unsigned long flags;
+	int drb_cnt = 0;
+	int ret = 0;
+
+	spin_lock_irqsave(&txq->tx_lock, flags);
+	drb_remain_cnt = ring_buf_read_write_count(txq->drb_size_cnt, txq->drb_release_rd_idx,
+						   txq->drb_wr_idx, false);
+	spin_unlock_irqrestore(&txq->tx_lock, flags);
+
+	/* write DRB descriptor information */
+	for (i = 0; i < DPMAIF_SKB_TX_BURST_CNT; i++) {
+		struct dpmaif_tx_event *event;
+
+		spin_lock_irqsave(&txq->tx_event_lock, flags);
+		if (list_empty(&txq->tx_event_queue)) {
+			spin_unlock_irqrestore(&txq->tx_event_lock, flags);
+			break;
+		}
+		event = list_first_entry(&txq->tx_event_queue, struct dpmaif_tx_event, entry);
+		spin_unlock_irqrestore(&txq->tx_event_lock, flags);
+
+		if (drb_remain_cnt < event->drb_cnt) {
+			spin_lock_irqsave(&txq->tx_lock, flags);
+			drb_remain_cnt = ring_buf_read_write_count(txq->drb_size_cnt,
+								   txq->drb_release_rd_idx,
+								   txq->drb_wr_idx,
+								   false);
+			spin_unlock_irqrestore(&txq->tx_lock, flags);
+			continue;
+		}
+
+		drb_remain_cnt -= event->drb_cnt;
+
+		ret = dpmaif_tx_send_skb_on_tx_thread(txq->dpmaif_ctrl, event);
+
+		if (ret < 0) {
+			dev_crit(txq->dpmaif_ctrl->dev,
+				 "txq%d send skb fail, ret=%d\n", event->qno, ret);
+			break;
+		}
+
+		drb_cnt += event->drb_cnt;
+		spin_lock_irqsave(&txq->tx_event_lock, flags);
+		dpmaif_finish_event(event);
+		txq->tx_submit_skb_cnt--;
+		spin_unlock_irqrestore(&txq->tx_event_lock, flags);
+	}
+
+	if (drb_cnt > 0) {
+		txq->drb_lack = false;
+		ret = drb_cnt;
+	} else if (ret == -ENOMEM) {
+		txq->drb_lack = true;
+	}
+
+	return ret;
+}
+
+static bool check_all_txq_drb_lack(const struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	unsigned char i;
+
+	for (i = 0; i < DPMAIF_TXQ_NUM; i++)
+		if (!list_empty(&dpmaif_ctrl->txq[i].tx_event_queue) &&
+		    !dpmaif_ctrl->txq[i].drb_lack)
+			return false;
+
+	return true;
+}
+
+static void do_tx_hw_push(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	dpmaif_ctrl->txq_select_times = 0;
+	do {
+		int txq_id;
+
+		txq_id = select_tx_queue(dpmaif_ctrl);
+		if (txq_id >= 0) {
+			struct dpmaif_tx_queue *txq;
+			int ret;
+
+			txq = &dpmaif_ctrl->txq[txq_id];
+			ret = txq_burst_send_skb(txq);
+			if (ret > 0) {
+				int drb_send_cnt = ret;
+
+				/* notify the dpmaif HW */
+				ret = dpmaif_ul_add_wcnt(dpmaif_ctrl, (unsigned char)txq_id,
+							 drb_send_cnt * DPMAIF_UL_DRB_ENTRY_WORD);
+				if (ret < 0)
+					dev_err(dpmaif_ctrl->dev,
+						"txq%d: dpmaif_ul_add_wcnt fail.\n", txq_id);
+			} else {
+				/* all txq the lack of DRB count */
+				if (check_all_txq_drb_lack(dpmaif_ctrl))
+					usleep_range(10, 20);
+			}
+		}
+
+		cond_resched();
+
+	} while (!tx_lists_are_all_empty(dpmaif_ctrl) && !kthread_should_stop() &&
+		 (dpmaif_ctrl->state == DPMAIF_STATE_PWRON));
+}
+
+static int dpmaif_tx_hw_push_thread(void *arg)
+{
+	struct dpmaif_ctrl *dpmaif_ctrl;
+
+	dpmaif_ctrl = arg;
+	while (!kthread_should_stop()) {
+		if (tx_lists_are_all_empty(dpmaif_ctrl) ||
+		    dpmaif_ctrl->state != DPMAIF_STATE_PWRON) {
+			if (wait_event_interruptible(dpmaif_ctrl->tx_wq,
+						     (!tx_lists_are_all_empty(dpmaif_ctrl) &&
+						     dpmaif_ctrl->state == DPMAIF_STATE_PWRON) ||
+						     kthread_should_stop()))
+				continue;
+		}
+
+		if (kthread_should_stop())
+			break;
+
+		do_tx_hw_push(dpmaif_ctrl);
+	}
+
+	return 0;
+}
+
+int dpmaif_tx_thread_init(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	init_waitqueue_head(&dpmaif_ctrl->tx_wq);
+	dpmaif_ctrl->tx_thread = kthread_run(dpmaif_tx_hw_push_thread,
+					     dpmaif_ctrl, "dpmaif_tx_hw_push");
+	if (IS_ERR(dpmaif_ctrl->tx_thread)) {
+		dev_err(dpmaif_ctrl->dev, "failed to start tx thread\n");
+		return PTR_ERR(dpmaif_ctrl->tx_thread);
+	}
+
+	return 0;
+}
+
+void dpmaif_tx_thread_release(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	if (dpmaif_ctrl->tx_thread)
+		kthread_stop(dpmaif_ctrl->tx_thread);
+}
+
+static inline unsigned char get_drb_cnt_per_skb(struct sk_buff *skb)
+{
+	/* normal DRB (frags data + skb linear data) + msg DRB */
+	return (skb_shinfo(skb)->nr_frags + 1 + 1);
+}
+
+static bool check_tx_queue_drb_available(struct dpmaif_tx_queue *txq, unsigned int send_drb_cnt)
+{
+	unsigned int drb_remain_cnt;
+	unsigned long flags;
+
+	spin_lock_irqsave(&txq->tx_lock, flags);
+	drb_remain_cnt = ring_buf_read_write_count(txq->drb_size_cnt, txq->drb_release_rd_idx,
+						   txq->drb_wr_idx, false);
+	spin_unlock_irqrestore(&txq->tx_lock, flags);
+
+	return drb_remain_cnt >= send_drb_cnt;
+}
+
+/**
+ * dpmaif_tx_send_skb() - Add SKB to the xmit queue
+ * @dpmaif_ctrl: Pointer to struct dpmaif_ctrl
+ * @txqt: Queue type to xmit on (normal or fast)
+ * @skb: Pointer to the SKB to xmit
+ *
+ * Add the SKB to the queue of the SKBs to be xmit.
+ * Wake up the thread that push the SKBs from the queue to the HW.
+ *
+ * Return: Zero on success and negative errno on failure
+ */
+int dpmaif_tx_send_skb(struct dpmaif_ctrl *dpmaif_ctrl, enum txq_type txqt, struct sk_buff *skb)
+{
+	bool tx_drb_available = true;
+	struct dpmaif_tx_queue *txq;
+	struct dpmaif_callbacks *cb;
+	unsigned int send_drb_cnt;
+
+	send_drb_cnt = get_drb_cnt_per_skb(skb);
+	txq = &dpmaif_ctrl->txq[txqt];
+
+	/* check tx queue DRB full */
+	if (!(txq->tx_skb_stat++ % DPMAIF_SKB_TX_BURST_CNT))
+		tx_drb_available = check_tx_queue_drb_available(txq, send_drb_cnt);
+
+	if (txq->tx_submit_skb_cnt < txq->tx_list_max_len && tx_drb_available) {
+		struct dpmaif_tx_event *event;
+		unsigned long flags;
+
+		event = kmalloc(sizeof(*event), GFP_ATOMIC);
+		if (!event)
+			return -ENOMEM;
+
+		INIT_LIST_HEAD(&event->entry);
+		event->qno = txqt;
+		event->skb = skb;
+		event->drb_cnt = send_drb_cnt;
+
+		spin_lock_irqsave(&txq->tx_event_lock, flags);
+		list_add_tail(&event->entry, &txq->tx_event_queue);
+		txq->tx_submit_skb_cnt++;
+		spin_unlock_irqrestore(&txq->tx_event_lock, flags);
+		wake_up(&dpmaif_ctrl->tx_wq);
+
+		return 0;
+	}
+
+	cb = dpmaif_ctrl->callbacks;
+	cb->state_notify(dpmaif_ctrl->mtk_dev, DMPAIF_TXQ_STATE_FULL, txqt);
+
+	return -EBUSY;
+}
+
+void dpmaif_irq_tx_done(struct dpmaif_ctrl *dpmaif_ctrl, unsigned int que_mask)
+{
+	int i;
+
+	for (i = 0; i < DPMAIF_TXQ_NUM; i++) {
+		if (que_mask & BIT(i))
+			queue_work(dpmaif_ctrl->txq[i].worker, &dpmaif_ctrl->txq[i].dpmaif_tx_work);
+	}
+}
+
+static int dpmaif_tx_buf_init(struct dpmaif_tx_queue *txq)
+{
+	size_t brb_skb_size;
+	size_t brb_pd_size;
+
+	brb_pd_size = DPMAIF_DRB_ENTRY_SIZE * sizeof(struct dpmaif_drb_pd);
+	brb_skb_size = DPMAIF_DRB_ENTRY_SIZE * sizeof(struct dpmaif_drb_skb);
+
+	txq->drb_size_cnt = DPMAIF_DRB_ENTRY_SIZE;
+
+	/* alloc buffer for HW && AP SW */
+	txq->drb_base = dma_alloc_coherent(txq->dpmaif_ctrl->dev, brb_pd_size,
+					   &txq->drb_bus_addr, GFP_KERNEL | __GFP_ZERO);
+	if (!txq->drb_base)
+		return -ENOMEM;
+
+	/* alloc buffer for AP SW to record the skb information */
+	txq->drb_skb_base = devm_kzalloc(txq->dpmaif_ctrl->dev, brb_skb_size, GFP_KERNEL);
+	if (!txq->drb_skb_base) {
+		dma_free_coherent(txq->dpmaif_ctrl->dev, brb_pd_size,
+				  txq->drb_base, txq->drb_bus_addr);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void dpmaif_tx_buf_rel(struct dpmaif_tx_queue *txq)
+{
+	if (txq->drb_base)
+		dma_free_coherent(txq->dpmaif_ctrl->dev,
+				  txq->drb_size_cnt * sizeof(struct dpmaif_drb_pd),
+				  txq->drb_base, txq->drb_bus_addr);
+
+	if (txq->drb_skb_base) {
+		struct dpmaif_drb_skb *drb_skb, *drb_skb_base = txq->drb_skb_base;
+		unsigned int i;
+
+		for (i = 0; i < txq->drb_size_cnt; i++) {
+			drb_skb = drb_skb_base + i;
+			if (drb_skb->skb) {
+				dma_unmap_single(txq->dpmaif_ctrl->dev, drb_skb->bus_addr,
+						 drb_skb->data_len, DMA_TO_DEVICE);
+				if (FIELD_GET(DRB_SKB_IS_LAST, drb_skb->config)) {
+					kfree_skb(drb_skb->skb);
+					drb_skb->skb = NULL;
+				}
+			}
+		}
+	}
+}
+
+/**
+ * dpmaif_txq_init() - Initialize TX queue
+ * @txq: Pointer to struct dpmaif_tx_queue
+ *
+ * Initialize the TX queue data structure and allocate memory for it to use.
+ *
+ * Return: Zero on success and negative errno on failure
+ */
+int dpmaif_txq_init(struct dpmaif_tx_queue *txq)
+{
+	int ret;
+
+	spin_lock_init(&txq->tx_event_lock);
+	INIT_LIST_HEAD(&txq->tx_event_queue);
+	txq->tx_submit_skb_cnt = 0;
+	txq->tx_skb_stat = 0;
+	txq->tx_list_max_len = DPMAIF_DRB_ENTRY_SIZE / 2;
+	txq->drb_lack = false;
+
+	init_waitqueue_head(&txq->req_wq);
+	atomic_set(&txq->tx_budget, DPMAIF_DRB_ENTRY_SIZE);
+
+	/* init the DRB DMA buffer and tx skb record info buffer */
+	ret = dpmaif_tx_buf_init(txq);
+	if (ret) {
+		dev_err(txq->dpmaif_ctrl->dev, "tx buffer init fail %d\n", ret);
+		return ret;
+	}
+
+	txq->worker = alloc_workqueue("md_dpmaif_tx%d_worker", WQ_UNBOUND | WQ_MEM_RECLAIM |
+				      (txq->index ? 0 : WQ_HIGHPRI), 1, txq->index);
+	if (!txq->worker)
+		return -ENOMEM;
+
+	INIT_WORK(&txq->dpmaif_tx_work, dpmaif_tx_done);
+	spin_lock_init(&txq->tx_lock);
+	return 0;
+}
+
+void dpmaif_txq_free(struct dpmaif_tx_queue *txq)
+{
+	struct dpmaif_tx_event *event, *event_next;
+	unsigned long flags;
+
+	if (txq->worker)
+		destroy_workqueue(txq->worker);
+
+	spin_lock_irqsave(&txq->tx_event_lock, flags);
+	list_for_each_entry_safe(event, event_next, &txq->tx_event_queue, entry) {
+		if (event->skb)
+			dev_kfree_skb_any(event->skb);
+
+		dpmaif_finish_event(event);
+	}
+
+	spin_unlock_irqrestore(&txq->tx_event_lock, flags);
+	dpmaif_tx_buf_rel(txq);
+}
+
+void dpmaif_suspend_tx_sw_stop(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	int i;
+
+	for (i = 0; i < DPMAIF_TXQ_NUM; i++) {
+		struct dpmaif_tx_queue *txq;
+		int count;
+
+		txq = &dpmaif_ctrl->txq[i];
+
+		txq->que_started = false;
+		/* Ensure tx_processing is changed to 1 before actually begin TX flow */
+		smp_mb();
+
+		/* Confirm that SW will not transmit */
+		count = 0;
+		do {
+			if (++count >= DPMAIF_MAX_CHECK_COUNT) {
+				dev_err(dpmaif_ctrl->dev, "tx queue stop failed\n");
+				break;
+			}
+		} while (atomic_read(&txq->tx_processing));
+	}
+}
+
+static void dpmaif_stop_txq(struct dpmaif_tx_queue *txq)
+{
+	txq->que_started = false;
+
+	cancel_work_sync(&txq->dpmaif_tx_work);
+	flush_work(&txq->dpmaif_tx_work);
+
+	if (txq->drb_skb_base) {
+		struct dpmaif_drb_skb *drb_skb, *drb_skb_base = txq->drb_skb_base;
+		unsigned int i;
+
+		for (i = 0; i < txq->drb_size_cnt; i++) {
+			drb_skb = drb_skb_base + i;
+			if (drb_skb->skb) {
+				dma_unmap_single(txq->dpmaif_ctrl->dev, drb_skb->bus_addr,
+						 drb_skb->data_len, DMA_TO_DEVICE);
+				if (FIELD_GET(DRB_SKB_IS_LAST, drb_skb->config)) {
+					kfree_skb(drb_skb->skb);
+					drb_skb->skb = NULL;
+				}
+			}
+		}
+	}
+
+	txq->drb_rd_idx = 0;
+	txq->drb_wr_idx = 0;
+	txq->drb_release_rd_idx = 0;
+}
+
+void dpmaif_stop_tx_sw(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	int i;
+
+	/* flush and release UL descriptor */
+	for (i = 0; i < DPMAIF_TXQ_NUM; i++)
+		dpmaif_stop_txq(&dpmaif_ctrl->txq[i]);
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.h b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.h
new file mode 100644
index 000000000000..6d51bd60c345
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_HIF_DPMA_TX_H__
+#define __T7XX_HIF_DPMA_TX_H__
+
+#include <linux/bitfield.h>
+#include <linux/skbuff.h>
+
+#include "t7xx_common.h"
+#include "t7xx_hif_dpmaif.h"
+
+/* UL DRB */
+struct dpmaif_drb_pd {
+	unsigned int		header;
+	unsigned int		p_data_addr;
+	unsigned int		data_addr_ext;
+	unsigned int		reserved2;
+};
+
+/* header's fields */
+#define DRB_PD_DATA_LEN		GENMASK(31, 16)
+#define DRB_PD_RES		GENMASK(15, 3)
+#define DRB_PD_CONT		BIT(2)
+#define DRB_PD_DTYP		GENMASK(1, 0)
+
+struct dpmaif_drb_msg {
+	unsigned int		header_dw1;
+	unsigned int		header_dw2;
+	unsigned int		reserved4;
+	unsigned int		reserved5;
+};
+
+/* first double word header fields */
+#define DRB_MSG_PACKET_LEN	GENMASK(31, 16)
+#define DRB_MSG_DW1_RES		GENMASK(15, 3)
+#define DRB_MSG_CONT		BIT(2)
+#define DRB_MSG_DTYP		GENMASK(1, 0)
+
+/* second double word header fields */
+#define DRB_MSG_DW2_RES		GENMASK(31, 30)
+#define DRB_MSG_L4_CHK		BIT(29)
+#define DRB_MSG_IP_CHK		BIT(28)
+#define DRB_MSG_RES2		BIT(27)
+#define DRB_MSG_NETWORK_TYPE	GENMASK(26, 24)
+#define DRB_MSG_CHANNEL_ID	GENMASK(23, 16)
+#define DRB_MSG_COUNT_L		GENMASK(15, 0)
+
+struct dpmaif_drb_skb {
+	struct sk_buff		*skb;
+	dma_addr_t		bus_addr;
+	unsigned short		data_len;
+	u16			config;
+};
+
+#define DRB_SKB_IS_LAST		BIT(15)
+#define DRB_SKB_IS_FRAG		BIT(14)
+#define DRB_SKB_IS_MSG		BIT(13)
+#define DRB_SKB_DRB_IDX		GENMASK(12, 0)
+
+int dpmaif_tx_send_skb(struct dpmaif_ctrl *dpmaif_ctrl, enum txq_type txqt,
+		       struct sk_buff *skb);
+void dpmaif_tx_thread_release(struct dpmaif_ctrl *dpmaif_ctrl);
+int dpmaif_tx_thread_init(struct dpmaif_ctrl *dpmaif_ctrl);
+void dpmaif_txq_free(struct dpmaif_tx_queue *txq);
+void dpmaif_irq_tx_done(struct dpmaif_ctrl *dpmaif_ctrl, unsigned int que_mask);
+int dpmaif_txq_init(struct dpmaif_tx_queue *txq);
+void dpmaif_suspend_tx_sw_stop(struct dpmaif_ctrl *dpmaif_ctrl);
+void dpmaif_stop_tx_sw(struct dpmaif_ctrl *dpmaif_ctrl);
+
+#endif /* __T7XX_HIF_DPMA_TX_H__ */
-- 
2.17.1

