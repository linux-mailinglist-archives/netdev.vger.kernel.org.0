Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB98436C19
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 22:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhJUUbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 16:31:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:57401 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231934AbhJUUbK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 16:31:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="292598317"
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="292598317"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:25 -0700
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="527625111"
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
Subject: [PATCH 12/14] net: wwan: t7xx: Device deep sleep lock/unlock
Date:   Thu, 21 Oct 2021 13:27:36 -0700
Message-Id: <20211021202738.729-13-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the mechanism to lock/unlock the device 'deep sleep' mode.
When the PCIe link state is L1.2 or L2, the host side still can keep
the device is in D0 state from the host side point of view. At the same
time, if the device's 'deep sleep' mode is unlocked, the device will
go to 'deep sleep' while it is still in D0 state on the host side.

Signed-off-by: Haijun Lio <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c     | 11 +++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c | 24 ++++--
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c | 39 ++++++---
 drivers/net/wwan/t7xx/t7xx_mhccif.c        |  3 +
 drivers/net/wwan/t7xx/t7xx_pci.c           | 95 ++++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_pci.h           | 10 +++
 6 files changed, 166 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
index 358b4727f7db..4a8288340cfc 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -1137,6 +1137,7 @@ int cldma_send_skb(enum cldma_id hif_id, int qno, struct sk_buff *skb, bool skb_
 	if (val < 0 && val != -EACCES)
 		return val;
 
+	mtk_pci_disable_sleep(md_ctrl->mtk_dev);
 	if (qno >= CLDMA_TXQ_NUM) {
 		ret = -EINVAL;
 		goto exit;
@@ -1172,6 +1173,11 @@ int cldma_send_skb(enum cldma_id hif_id, int qno, struct sk_buff *skb, bool skb_
 			queue->tx_xmit = cldma_ring_step_forward(queue->tr_ring, tx_req);
 			spin_unlock_irqrestore(&queue->ring_lock, flags);
 
+			if (!mtk_pci_sleep_disable_complete(md_ctrl->mtk_dev)) {
+				ret = -EBUSY;
+				break;
+			}
+
 			spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
 			cldma_hw_start_send(md_ctrl, qno);
 			spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
@@ -1179,6 +1185,10 @@ int cldma_send_skb(enum cldma_id hif_id, int qno, struct sk_buff *skb, bool skb_
 		}
 
 		spin_unlock_irqrestore(&queue->ring_lock, flags);
+		if (!mtk_pci_sleep_disable_complete(md_ctrl->mtk_dev)) {
+			ret = -EBUSY;
+			break;
+		}
 
 		/* check CLDMA status */
 		if (!cldma_hw_queue_status(&md_ctrl->hw_info, qno, false)) {
@@ -1200,6 +1210,7 @@ int cldma_send_skb(enum cldma_id hif_id, int qno, struct sk_buff *skb, bool skb_
 	} while (!ret);
 
 exit:
+	mtk_pci_enable_sleep(md_ctrl->mtk_dev);
 	pm_runtime_mark_last_busy(md_ctrl->dev);
 	pm_runtime_put_autosuspend(md_ctrl->dev);
 	return ret;
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
index 1c29e5576959..4383b0b3f14b 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
@@ -31,6 +31,8 @@
 #define DPMAIF_RX_PUSH_THRESHOLD_MASK	0x7
 #define DPMAIF_NOTIFY_RELEASE_COUNT	128
 #define DPMAIF_POLL_PIT_TIME_US		20
+#define DPMAIF_POLL_RX_TIME_US		10
+#define DPMAIF_POLL_RX_TIMEOUT_US	200
 #define DPMAIF_POLL_PIT_MAX_TIME_US	2000
 #define DPMAIF_WQ_TIME_LIMIT_MS		2
 #define DPMAIF_CS_RESULT_PASS		0
@@ -1011,6 +1013,7 @@ static int dpmaif_rx_data_collect(struct dpmaif_ctrl *dpmaif_ctrl,
 	return 0;
 }
 
+/* call after mtk_pci_disable_sleep */
 static void dpmaif_do_rx(struct dpmaif_ctrl *dpmaif_ctrl, struct dpmaif_rx_queue *rxq)
 {
 	int ret;
@@ -1050,7 +1053,13 @@ static void dpmaif_rxq_work(struct work_struct *work)
 	if (ret < 0 && ret != -EACCES)
 		return;
 
-	dpmaif_do_rx(dpmaif_ctrl, rxq);
+	mtk_pci_disable_sleep(dpmaif_ctrl->mtk_dev);
+
+	/* we can try blocking wait for lock resource here in process context */
+	if (mtk_pci_sleep_disable_complete(dpmaif_ctrl->mtk_dev))
+		dpmaif_do_rx(dpmaif_ctrl, rxq);
+
+	mtk_pci_enable_sleep(dpmaif_ctrl->mtk_dev);
 
 	pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
 	pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
@@ -1424,14 +1433,19 @@ static void dpmaif_bat_release_work(struct work_struct *work)
 	if (ret < 0 && ret != -EACCES)
 		return;
 
+	mtk_pci_disable_sleep(dpmaif_ctrl->mtk_dev);
+
 	/* ALL RXQ use one BAT table, so choose DPF_RX_QNO_DFT */
 	rxq = &dpmaif_ctrl->rxq[DPF_RX_QNO_DFT];
 
-	/* normal BAT release and add */
-	dpmaif_dl_pkt_bat_release_and_add(rxq);
-	/* frag BAT release and add */
-	dpmaif_dl_frag_bat_release_and_add(rxq);
+	if (mtk_pci_sleep_disable_complete(dpmaif_ctrl->mtk_dev)) {
+		/* normal BAT release and add */
+		dpmaif_dl_pkt_bat_release_and_add(rxq);
+		/* frag BAT release and add */
+		dpmaif_dl_frag_bat_release_and_add(rxq);
+	}
 
+	mtk_pci_enable_sleep(dpmaif_ctrl->mtk_dev);
 	pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
 	pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 }
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
index afb53ed12b12..c1fe78874b46 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
@@ -164,19 +164,26 @@ static void dpmaif_tx_done(struct work_struct *work)
 	if (ret < 0 && ret != -EACCES)
 		return;
 
-	ret = dpmaif_tx_release(dpmaif_ctrl, txq->index, txq->drb_size_cnt);
-	if (ret == -EAGAIN ||
-	    (dpmaif_hw_check_clr_ul_done_status(&dpmaif_ctrl->hif_hw_info, txq->index) &&
-	     dpmaif_no_remain_spurious_tx_done_intr(txq))) {
-		queue_work(dpmaif_ctrl->txq[txq->index].worker,
-			   &dpmaif_ctrl->txq[txq->index].dpmaif_tx_work);
-		/* clear IP busy to give the device time to enter the low power state */
-		dpmaif_clr_ip_busy_sts(&dpmaif_ctrl->hif_hw_info);
-	} else {
-		dpmaif_clr_ip_busy_sts(&dpmaif_ctrl->hif_hw_info);
-		dpmaif_unmask_ulq_interrupt(dpmaif_ctrl, txq->index);
+	/* The device may be in low power state. disable sleep if needed */
+	mtk_pci_disable_sleep(dpmaif_ctrl->mtk_dev);
+
+	/* ensure that we are not in deep sleep */
+	if (mtk_pci_sleep_disable_complete(dpmaif_ctrl->mtk_dev)) {
+		ret = dpmaif_tx_release(dpmaif_ctrl, txq->index, txq->drb_size_cnt);
+		if (ret == -EAGAIN ||
+		    (dpmaif_hw_check_clr_ul_done_status(&dpmaif_ctrl->hif_hw_info, txq->index) &&
+		     dpmaif_no_remain_spurious_tx_done_intr(txq))) {
+			queue_work(dpmaif_ctrl->txq[txq->index].worker,
+				   &dpmaif_ctrl->txq[txq->index].dpmaif_tx_work);
+			/* clear IP busy to give the device time to enter the low power state */
+			dpmaif_clr_ip_busy_sts(&dpmaif_ctrl->hif_hw_info);
+		} else {
+			dpmaif_clr_ip_busy_sts(&dpmaif_ctrl->hif_hw_info);
+			dpmaif_unmask_ulq_interrupt(dpmaif_ctrl, txq->index);
+		}
 	}
 
+	mtk_pci_enable_sleep(dpmaif_ctrl->mtk_dev);
 	pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
 	pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 }
@@ -477,6 +484,8 @@ static bool check_all_txq_drb_lack(const struct dpmaif_ctrl *dpmaif_ctrl)
 
 static void do_tx_hw_push(struct dpmaif_ctrl *dpmaif_ctrl)
 {
+	bool first_time = true;
+
 	dpmaif_ctrl->txq_select_times = 0;
 	do {
 		int txq_id;
@@ -491,6 +500,11 @@ static void do_tx_hw_push(struct dpmaif_ctrl *dpmaif_ctrl)
 			if (ret > 0) {
 				int drb_send_cnt = ret;
 
+				/* wait for the PCIe resource locked done */
+				if (first_time &&
+				    !mtk_pci_sleep_disable_complete(dpmaif_ctrl->mtk_dev))
+					return;
+
 				/* notify the dpmaif HW */
 				ret = dpmaif_ul_add_wcnt(dpmaif_ctrl, (unsigned char)txq_id,
 							 drb_send_cnt * DPMAIF_UL_DRB_ENTRY_WORD);
@@ -504,6 +518,7 @@ static void do_tx_hw_push(struct dpmaif_ctrl *dpmaif_ctrl)
 			}
 		}
 
+		first_time = false;
 		cond_resched();
 
 	} while (!tx_lists_are_all_empty(dpmaif_ctrl) && !kthread_should_stop() &&
@@ -533,7 +548,9 @@ static int dpmaif_tx_hw_push_thread(void *arg)
 		if (ret < 0 && ret != -EACCES)
 			return ret;
 
+		mtk_pci_disable_sleep(dpmaif_ctrl->mtk_dev);
 		do_tx_hw_push(dpmaif_ctrl);
+		mtk_pci_enable_sleep(dpmaif_ctrl->mtk_dev);
 		pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
 		pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 	}
diff --git a/drivers/net/wwan/t7xx/t7xx_mhccif.c b/drivers/net/wwan/t7xx/t7xx_mhccif.c
index 68acf1ca0555..2bc976e0d7f2 100644
--- a/drivers/net/wwan/t7xx/t7xx_mhccif.c
+++ b/drivers/net/wwan/t7xx/t7xx_mhccif.c
@@ -51,6 +51,9 @@ static irqreturn_t mhccif_isr_thread(int irq, void *data)
 	/* Clear 2 & 1 level interrupts */
 	mhccif_clear_interrupts(mtk_dev, int_sts);
 
+	if (int_sts & D2H_INT_DS_LOCK_ACK)
+		complete_all(&mtk_dev->sleep_lock_acquire);
+
 	if (int_sts & D2H_INT_SR_ACK)
 		complete(&mtk_dev->pm_sr_ack);
 
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index 260fe87ea631..559d3648e368 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -25,6 +25,7 @@
 #define	PCI_IREG_BASE			0
 #define	PCI_EREG_BASE			2
 
+#define MTK_WAIT_TIMEOUT_MS		10
 #define PM_ACK_TIMEOUT_MS		1500
 #define PM_AUTOSUSPEND_MS		20000
 #define PM_RESOURCE_POLL_TIMEOUT_US	10000
@@ -37,6 +38,22 @@ enum mtk_pm_state {
 	MTK_PM_RESUMED,		/* Device in resume state */
 };
 
+static void mtk_dev_set_sleep_capability(struct mtk_pci_dev *mtk_dev, bool enable)
+{
+	void __iomem *ctrl_reg;
+	u32 value;
+
+	ctrl_reg = IREG_BASE(mtk_dev) + PCIE_MISC_CTRL;
+	value = ioread32(ctrl_reg);
+
+	if (enable)
+		value &= ~PCIE_MISC_MAC_SLEEP_DIS;
+	else
+		value |= PCIE_MISC_MAC_SLEEP_DIS;
+
+	iowrite32(value, ctrl_reg);
+}
+
 static int mtk_wait_pm_config(struct mtk_pci_dev *mtk_dev)
 {
 	int ret, val;
@@ -59,10 +76,14 @@ static int mtk_pci_pm_init(struct mtk_pci_dev *mtk_dev)
 
 	INIT_LIST_HEAD(&mtk_dev->md_pm_entities);
 
+	spin_lock_init(&mtk_dev->md_pm_lock);
+
 	mutex_init(&mtk_dev->md_pm_entity_mtx);
 
+	init_completion(&mtk_dev->sleep_lock_acquire);
 	init_completion(&mtk_dev->pm_sr_ack);
 
+	atomic_set(&mtk_dev->sleep_disable_count, 0);
 	device_init_wakeup(&pdev->dev, true);
 
 	dev_pm_set_driver_flags(&pdev->dev, pdev->dev.power.driver_flags |
@@ -81,6 +102,7 @@ void mtk_pci_pm_init_late(struct mtk_pci_dev *mtk_dev)
 {
 	/* enable the PCIe Resource Lock only after MD deep sleep is done */
 	mhccif_mask_clr(mtk_dev,
+			D2H_INT_DS_LOCK_ACK |
 			D2H_INT_SUSPEND_ACK |
 			D2H_INT_RESUME_ACK |
 			D2H_INT_SUSPEND_ACK_AP |
@@ -147,6 +169,79 @@ int mtk_pci_pm_entity_unregister(struct mtk_pci_dev *mtk_dev, struct md_pm_entit
 	return -ENXIO;
 }
 
+int mtk_pci_sleep_disable_complete(struct mtk_pci_dev *mtk_dev)
+{
+	int ret;
+
+	ret = wait_for_completion_timeout(&mtk_dev->sleep_lock_acquire,
+					  msecs_to_jiffies(MTK_WAIT_TIMEOUT_MS));
+	if (!ret)
+		dev_err_ratelimited(&mtk_dev->pdev->dev, "Resource wait complete timed out\n");
+
+	return ret;
+}
+
+/**
+ * mtk_pci_disable_sleep() - disable deep sleep capability
+ * @mtk_dev: MTK device
+ *
+ * Lock the deep sleep capabitily, note that the device can go into deep sleep
+ * state while it is still in D0 state from the host point of view.
+ *
+ * If device is in deep sleep state then wake up the device and disable deep sleep capability.
+ */
+void mtk_pci_disable_sleep(struct mtk_pci_dev *mtk_dev)
+{
+	unsigned long flags;
+
+	if (atomic_read(&mtk_dev->md_pm_state) < MTK_PM_RESUMED) {
+		atomic_inc(&mtk_dev->sleep_disable_count);
+		complete_all(&mtk_dev->sleep_lock_acquire);
+		return;
+	}
+
+	spin_lock_irqsave(&mtk_dev->md_pm_lock, flags);
+	if (atomic_inc_return(&mtk_dev->sleep_disable_count) == 1) {
+		reinit_completion(&mtk_dev->sleep_lock_acquire);
+		mtk_dev_set_sleep_capability(mtk_dev, false);
+		/* read register status to check whether the device's
+		 * deep sleep is disabled or not.
+		 */
+		if ((ioread32(IREG_BASE(mtk_dev) + PCIE_RESOURCE_STATUS) &
+		     PCIE_RESOURCE_STATUS_MSK) == PCIE_RESOURCE_STATUS_MSK) {
+			spin_unlock_irqrestore(&mtk_dev->md_pm_lock, flags);
+			complete_all(&mtk_dev->sleep_lock_acquire);
+			return;
+		}
+
+		mhccif_h2d_swint_trigger(mtk_dev, H2D_CH_DS_LOCK);
+	}
+
+	spin_unlock_irqrestore(&mtk_dev->md_pm_lock, flags);
+}
+
+/**
+ * mtk_pci_enable_sleep() - enable deep sleep capability
+ * @mtk_dev: MTK device
+ *
+ * After enabling deep sleep, device can enter into deep sleep state.
+ */
+void mtk_pci_enable_sleep(struct mtk_pci_dev *mtk_dev)
+{
+	unsigned long flags;
+
+	if (atomic_read(&mtk_dev->md_pm_state) < MTK_PM_RESUMED) {
+		atomic_dec(&mtk_dev->sleep_disable_count);
+		return;
+	}
+
+	if (atomic_dec_and_test(&mtk_dev->sleep_disable_count)) {
+		spin_lock_irqsave(&mtk_dev->md_pm_lock, flags);
+		mtk_dev_set_sleep_capability(mtk_dev, true);
+		spin_unlock_irqrestore(&mtk_dev->md_pm_lock, flags);
+	}
+}
+
 static int __mtk_pci_pm_suspend(struct pci_dev *pdev)
 {
 	struct mtk_pci_dev *mtk_dev;
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.h b/drivers/net/wwan/t7xx/t7xx_pci.h
index 57c58d47c031..669ca3d56606 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.h
+++ b/drivers/net/wwan/t7xx/t7xx_pci.h
@@ -10,6 +10,7 @@
 #include <linux/completion.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
+#include <linux/spinlock.h>
 #include <linux/types.h>
 
 #include "t7xx_reg.h"
@@ -41,7 +42,10 @@ typedef irqreturn_t (*mtk_intr_callback)(int irq, void *param);
  * @base_addr: memory base addresses of HW components
  * @md: modem interface
  * @md_pm_entities: list of pm entities
+ * @md_pm_lock: protects PCIe sleep lock
  * @md_pm_entity_mtx: protects md_pm_entities list
+ * @sleep_disable_count: PCIe L1.2 lock counter
+ * @sleep_lock_acquire: indicates that sleep has been disabled
  * @pm_sr_ack: ack from the device when went to sleep or woke up
  * @md_pm_state: state for resume/suspend
  * @ccmni_ctlb: context structure used to control the network data path
@@ -59,7 +63,10 @@ struct mtk_pci_dev {
 
 	/* Low Power Items */
 	struct list_head	md_pm_entities;
+	spinlock_t		md_pm_lock;		/* protects PCI resource lock */
 	struct mutex		md_pm_entity_mtx;	/* protects md_pm_entities list */
+	atomic_t		sleep_disable_count;
+	struct completion	sleep_lock_acquire;
 	struct completion	pm_sr_ack;
 	atomic_t		md_pm_state;
 
@@ -96,6 +103,9 @@ struct md_pm_entity {
 	void			*entity_param;
 };
 
+void mtk_pci_disable_sleep(struct mtk_pci_dev *mtk_dev);
+void mtk_pci_enable_sleep(struct mtk_pci_dev *mtk_dev);
+int mtk_pci_sleep_disable_complete(struct mtk_pci_dev *mtk_dev);
 int mtk_pci_pm_entity_register(struct mtk_pci_dev *mtk_dev, struct md_pm_entity *pm_entity);
 int mtk_pci_pm_entity_unregister(struct mtk_pci_dev *mtk_dev, struct md_pm_entity *pm_entity);
 void mtk_pci_pm_init_late(struct mtk_pci_dev *mtk_dev);
-- 
2.17.1

