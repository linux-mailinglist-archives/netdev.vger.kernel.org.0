Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDA0436C20
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 22:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhJUUcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 16:32:46 -0400
Received: from mga05.intel.com ([192.55.52.43]:46172 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231934AbhJUUcp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 16:32:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="315343873"
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="315343873"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:24 -0700
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="527625107"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:24 -0700
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH 11/14] net: wwan: t7xx: Runtime PM
Date:   Thu, 21 Oct 2021 13:27:35 -0700
Message-Id: <20211021202738.729-12-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enables runtime power management callbacks including runtime_suspend
and runtime_resume. Autosuspend is used to prevent overhead by frequent
wake-ups.

Signed-off-by: Haijun Lio <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c     | 13 +++++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c | 16 ++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c | 15 +++++++++++++++
 drivers/net/wwan/t7xx/t7xx_pci.c           | 21 +++++++++++++++++++++
 4 files changed, 65 insertions(+)

diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
index 0f15f9283eca..358b4727f7db 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/pm_runtime.h>
 #include <linux/skbuff.h>
 
 #include "t7xx_common.h"
@@ -300,6 +301,8 @@ static void cldma_rx_done(struct work_struct *work)
 	/* enable RX_DONE && EMPTY interrupt */
 	cldma_hw_dismask_txrxirq(&md_ctrl->hw_info, queue->index, true);
 	cldma_hw_dismask_eqirq(&md_ctrl->hw_info, queue->index, true);
+	pm_runtime_mark_last_busy(md_ctrl->dev);
+	pm_runtime_put_autosuspend(md_ctrl->dev);
 }
 
 static int cldma_gpd_tx_collect(struct cldma_queue *queue)
@@ -441,6 +444,8 @@ static void cldma_tx_done(struct work_struct *work)
 	}
 
 	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+	pm_runtime_mark_last_busy(md_ctrl->dev);
+	pm_runtime_put_autosuspend(md_ctrl->dev);
 }
 
 static void cldma_ring_free(struct cldma_ctrl *md_ctrl,
@@ -664,6 +669,7 @@ static void cldma_irq_work_cb(struct cldma_ctrl *md_ctrl)
 		if (l2_tx_int & (TXRX_STATUS_BITMASK | EMPTY_STATUS_BITMASK)) {
 			for (i = 0; i < CLDMA_TXQ_NUM; i++) {
 				if (l2_tx_int & BIT(i)) {
+					pm_runtime_get(md_ctrl->dev);
 					/* disable TX_DONE interrupt */
 					cldma_hw_mask_eqirq(hw_info, i, false);
 					cldma_hw_mask_txrxirq(hw_info, i, false);
@@ -692,6 +698,7 @@ static void cldma_irq_work_cb(struct cldma_ctrl *md_ctrl)
 		if (l2_rx_int & (TXRX_STATUS_BITMASK | EMPTY_STATUS_BITMASK)) {
 			for (i = 0; i < CLDMA_RXQ_NUM; i++) {
 				if (l2_rx_int & (BIT(i) | EQ_STA_BIT(i))) {
+					pm_runtime_get(md_ctrl->dev);
 					/* disable RX_DONE and QUEUE_EMPTY interrupt */
 					cldma_hw_mask_eqirq(hw_info, i, true);
 					cldma_hw_mask_txrxirq(hw_info, i, true);
@@ -1123,8 +1130,12 @@ int cldma_send_skb(enum cldma_id hif_id, int qno, struct sk_buff *skb, bool skb_
 	struct cldma_queue *queue;
 	unsigned long flags;
 	int ret = 0;
+	int val;
 
 	md_ctrl = md_cd_get(hif_id);
+	val = pm_runtime_resume_and_get(md_ctrl->dev);
+	if (val < 0 && val != -EACCES)
+		return val;
 
 	if (qno >= CLDMA_TXQ_NUM) {
 		ret = -EINVAL;
@@ -1189,6 +1200,8 @@ int cldma_send_skb(enum cldma_id hif_id, int qno, struct sk_buff *skb, bool skb_
 	} while (!ret);
 
 exit:
+	pm_runtime_mark_last_busy(md_ctrl->dev);
+	pm_runtime_put_autosuspend(md_ctrl->dev);
 	return ret;
 }
 
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
index a902f1ffa4c2..1c29e5576959 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
@@ -13,6 +13,7 @@
 #include <linux/kthread.h>
 #include <linux/list.h>
 #include <linux/mm.h>
+#include <linux/pm_runtime.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -1030,6 +1031,7 @@ static void dpmaif_rxq_work(struct work_struct *work)
 {
 	struct dpmaif_ctrl *dpmaif_ctrl;
 	struct dpmaif_rx_queue *rxq;
+	int ret;
 
 	rxq = container_of(work, struct dpmaif_rx_queue, dpmaif_rxq_work);
 	dpmaif_ctrl = rxq->dpmaif_ctrl;
@@ -1044,8 +1046,14 @@ static void dpmaif_rxq_work(struct work_struct *work)
 		return;
 	}
 
+	ret = pm_runtime_resume_and_get(dpmaif_ctrl->dev);
+	if (ret < 0 && ret != -EACCES)
+		return;
+
 	dpmaif_do_rx(dpmaif_ctrl, rxq);
 
+	pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
+	pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 	atomic_set(&rxq->rx_processing, 0);
 }
 
@@ -1408,9 +1416,14 @@ static void dpmaif_bat_release_work(struct work_struct *work)
 {
 	struct dpmaif_ctrl *dpmaif_ctrl;
 	struct dpmaif_rx_queue *rxq;
+	int ret;
 
 	dpmaif_ctrl = container_of(work, struct dpmaif_ctrl, bat_release_work);
 
+	ret = pm_runtime_resume_and_get(dpmaif_ctrl->dev);
+	if (ret < 0 && ret != -EACCES)
+		return;
+
 	/* ALL RXQ use one BAT table, so choose DPF_RX_QNO_DFT */
 	rxq = &dpmaif_ctrl->rxq[DPF_RX_QNO_DFT];
 
@@ -1418,6 +1431,9 @@ static void dpmaif_bat_release_work(struct work_struct *work)
 	dpmaif_dl_pkt_bat_release_and_add(rxq);
 	/* frag BAT release and add */
 	dpmaif_dl_frag_bat_release_and_add(rxq);
+
+	pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
+	pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 }
 
 int dpmaif_bat_release_work_alloc(struct dpmaif_ctrl *dpmaif_ctrl)
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
index 70f1547fbaff..afb53ed12b12 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/list.h>
+#include <linux/pm_runtime.h>
 #include <linux/spinlock.h>
 
 #include "t7xx_common.h"
@@ -159,6 +160,10 @@ static void dpmaif_tx_done(struct work_struct *work)
 	txq = container_of(work, struct dpmaif_tx_queue, dpmaif_tx_work);
 	dpmaif_ctrl = txq->dpmaif_ctrl;
 
+	ret = pm_runtime_resume_and_get(dpmaif_ctrl->dev);
+	if (ret < 0 && ret != -EACCES)
+		return;
+
 	ret = dpmaif_tx_release(dpmaif_ctrl, txq->index, txq->drb_size_cnt);
 	if (ret == -EAGAIN ||
 	    (dpmaif_hw_check_clr_ul_done_status(&dpmaif_ctrl->hif_hw_info, txq->index) &&
@@ -171,6 +176,9 @@ static void dpmaif_tx_done(struct work_struct *work)
 		dpmaif_clr_ip_busy_sts(&dpmaif_ctrl->hif_hw_info);
 		dpmaif_unmask_ulq_interrupt(dpmaif_ctrl, txq->index);
 	}
+
+	pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
+	pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 }
 
 static void set_drb_msg(struct dpmaif_ctrl *dpmaif_ctrl,
@@ -505,6 +513,7 @@ static void do_tx_hw_push(struct dpmaif_ctrl *dpmaif_ctrl)
 static int dpmaif_tx_hw_push_thread(void *arg)
 {
 	struct dpmaif_ctrl *dpmaif_ctrl;
+	int ret;
 
 	dpmaif_ctrl = arg;
 	while (!kthread_should_stop()) {
@@ -520,7 +529,13 @@ static int dpmaif_tx_hw_push_thread(void *arg)
 		if (kthread_should_stop())
 			break;
 
+		ret = pm_runtime_resume_and_get(dpmaif_ctrl->dev);
+		if (ret < 0 && ret != -EACCES)
+			return ret;
+
 		do_tx_hw_push(dpmaif_ctrl);
+		pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
+		pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 	}
 
 	return 0;
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index 788bd6db8bc5..260fe87ea631 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
+#include <linux/pm_runtime.h>
 #include <linux/spinlock.h>
 
 #include "t7xx_mhccif.h"
@@ -25,6 +26,7 @@
 #define	PCI_EREG_BASE			2
 
 #define PM_ACK_TIMEOUT_MS		1500
+#define PM_AUTOSUSPEND_MS		20000
 #define PM_RESOURCE_POLL_TIMEOUT_US	10000
 #define PM_RESOURCE_POLL_STEP_US	100
 
@@ -69,6 +71,8 @@ static int mtk_pci_pm_init(struct mtk_pci_dev *mtk_dev)
 	atomic_set(&mtk_dev->md_pm_state, MTK_PM_INIT);
 
 	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_SET_0);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, PM_AUTOSUSPEND_MS);
+	pm_runtime_use_autosuspend(&pdev->dev);
 
 	return mtk_wait_pm_config(mtk_dev);
 }
@@ -83,6 +87,8 @@ void mtk_pci_pm_init_late(struct mtk_pci_dev *mtk_dev)
 			D2H_INT_RESUME_ACK_AP);
 	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_CLR_0);
 	atomic_set(&mtk_dev->md_pm_state, MTK_PM_RESUMED);
+
+	pm_runtime_put_noidle(&mtk_dev->pdev->dev);
 }
 
 static int mtk_pci_pm_reinit(struct mtk_pci_dev *mtk_dev)
@@ -92,6 +98,8 @@ static int mtk_pci_pm_reinit(struct mtk_pci_dev *mtk_dev)
 	 */
 	atomic_set(&mtk_dev->md_pm_state, MTK_PM_INIT);
 
+	pm_runtime_get_noresume(&mtk_dev->pdev->dev);
+
 	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_SET_0);
 	return mtk_wait_pm_config(mtk_dev);
 }
@@ -396,6 +404,7 @@ static int __mtk_pci_pm_resume(struct pci_dev *pdev, bool state_check)
 	mtk_dev->rgu_pci_irq_en = true;
 	mtk_pcie_mac_set_int(mtk_dev, SAP_RGU_INT);
 	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_CLR_0);
+	pm_runtime_mark_last_busy(&pdev->dev);
 	atomic_set(&mtk_dev->md_pm_state, MTK_PM_RESUMED);
 
 	return ret;
@@ -437,6 +446,16 @@ static int mtk_pci_pm_thaw(struct device *dev)
 	return __mtk_pci_pm_resume(to_pci_dev(dev), false);
 }
 
+static int mtk_pci_pm_runtime_suspend(struct device *dev)
+{
+	return __mtk_pci_pm_suspend(to_pci_dev(dev));
+}
+
+static int mtk_pci_pm_runtime_resume(struct device *dev)
+{
+	return __mtk_pci_pm_resume(to_pci_dev(dev), true);
+}
+
 static const struct dev_pm_ops mtk_pci_pm_ops = {
 	.suspend = mtk_pci_pm_suspend,
 	.resume = mtk_pci_pm_resume,
@@ -446,6 +465,8 @@ static const struct dev_pm_ops mtk_pci_pm_ops = {
 	.poweroff = mtk_pci_pm_suspend,
 	.restore = mtk_pci_pm_resume,
 	.restore_noirq = mtk_pci_pm_resume_noirq,
+	.runtime_suspend = mtk_pci_pm_runtime_suspend,
+	.runtime_resume = mtk_pci_pm_runtime_resume
 };
 
 static int mtk_request_irq(struct pci_dev *pdev)
-- 
2.17.1

