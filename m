Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1150546B0EA
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhLGCwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:52:00 -0500
Received: from mga07.intel.com ([134.134.136.100]:27273 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231158AbhLGCvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 21:51:44 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="300860596"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="300860596"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 18:47:52 -0800
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="748524186"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 18:47:51 -0800
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, mika.westerberg@linux.intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, suresh.nagaraj@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH net-next v3 11/12] net: wwan: t7xx: Device deep sleep lock/unlock
Date:   Mon,  6 Dec 2021 19:47:10 -0700
Message-Id: <20211207024711.2765-12-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haijun Liu <haijun.liu@mediatek.com>

Introduce the mechanism to lock/unlock the device 'deep sleep' mode.
When the PCIe link state is L1.2 or L2, the host side still can keep
the device is in D0 state from the host side point of view. At the same
time, if the device's 'deep sleep' mode is unlocked, the device will
go to 'deep sleep' while it is still in D0 state on the host side.

Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c     | 12 +++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c | 14 +++-
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c | 37 ++++++---
 drivers/net/wwan/t7xx/t7xx_mhccif.c        |  3 +
 drivers/net/wwan/t7xx/t7xx_pci.c           | 97 ++++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_pci.h           | 10 +++
 6 files changed, 159 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
index cdeb79bb006e..7b8c135600cf 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -997,6 +997,7 @@ int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct sk_buff *skb
 	if (ret < 0 && ret != -EACCES)
 		return ret;
 
+	t7xx_pci_disable_sleep(md_ctrl->t7xx_dev);
 	queue = &md_ctrl->txq[qno];
 
 	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
@@ -1017,6 +1018,11 @@ int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct sk_buff *skb
 			queue->tx_xmit = t7xx_cldma_ring_step_forward(queue->tr_ring, tx_req);
 			spin_unlock_irqrestore(&queue->ring_lock, flags);
 
+			if (!t7xx_pci_sleep_disable_complete(md_ctrl->t7xx_dev)) {
+				ret = -EBUSY;
+				break;
+			}
+
 			/* Protect the access to the modem for queues operations (resume/start)
 			 * which access shared locations by all the queues.
 			 * cldma_lock is independent of ring_lock which is per queue.
@@ -1029,6 +1035,11 @@ int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct sk_buff *skb
 
 		spin_unlock_irqrestore(&queue->ring_lock, flags);
 
+		if (!t7xx_pci_sleep_disable_complete(md_ctrl->t7xx_dev)) {
+			ret = -EBUSY;
+			break;
+		}
+
 		if (!t7xx_cldma_hw_queue_status(&md_ctrl->hw_info, qno, MTK_TX)) {
 			spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
 			t7xx_cldma_hw_resume_queue(&md_ctrl->hw_info, qno, MTK_TX);
@@ -1044,6 +1055,7 @@ int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct sk_buff *skb
 	} while (!ret);
 
 allow_sleep:
+	t7xx_pci_enable_sleep(md_ctrl->t7xx_dev);
 	pm_runtime_mark_last_busy(md_ctrl->dev);
 	pm_runtime_put_autosuspend(md_ctrl->dev);
 	return ret;
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
index 710e4727ea84..1a4694f405ea 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
@@ -929,8 +929,11 @@ static void t7xx_dpmaif_rxq_work(struct work_struct *work)
 	if (ret < 0 && ret != -EACCES)
 		return;
 
-	t7xx_dpmaif_do_rx(dpmaif_ctrl, rxq);
+	t7xx_pci_disable_sleep(dpmaif_ctrl->t7xx_dev);
+	if (t7xx_pci_sleep_disable_complete(dpmaif_ctrl->t7xx_dev))
+		t7xx_dpmaif_do_rx(dpmaif_ctrl, rxq);
 
+	t7xx_pci_enable_sleep(dpmaif_ctrl->t7xx_dev);
 	pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
 	pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 	atomic_set(&rxq->rx_processing, 0);
@@ -1168,11 +1171,16 @@ static void t7xx_dpmaif_bat_release_work(struct work_struct *work)
 	if (ret < 0 && ret != -EACCES)
 		return;
 
+	t7xx_pci_disable_sleep(dpmaif_ctrl->t7xx_dev);
+
 	/* ALL RXQ use one BAT table, so choose DPF_RX_QNO_DFT */
 	rxq = &dpmaif_ctrl->rxq[DPF_RX_QNO_DFT];
-	t7xx_dpmaif_bat_release_and_add(rxq);
-	t7xx_dpmaif_frag_bat_release_and_add(rxq);
+	if (t7xx_pci_sleep_disable_complete(dpmaif_ctrl->t7xx_dev)) {
+		t7xx_dpmaif_bat_release_and_add(rxq);
+		t7xx_dpmaif_frag_bat_release_and_add(rxq);
+	}
 
+	t7xx_pci_enable_sleep(dpmaif_ctrl->t7xx_dev);
 	pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
 	pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 }
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
index f8e7a10273a4..17f473d8e5ae 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
@@ -175,19 +175,24 @@ static void t7xx_dpmaif_tx_done(struct work_struct *work)
 	if (ret < 0 && ret != -EACCES)
 		return;
 
-	ret = t7xx_dpmaif_tx_release(dpmaif_ctrl, txq->index, txq->drb_size_cnt);
-	if (ret == -EAGAIN ||
-	    (t7xx_dpmaif_ul_clr_done(&dpmaif_ctrl->hif_hw_info, txq->index) &&
-	     t7xx_dpmaif_drb_ring_not_empty(txq))) {
-		queue_work(dpmaif_ctrl->txq[txq->index].worker,
-			   &dpmaif_ctrl->txq[txq->index].dpmaif_tx_work);
-		/* Give the device time to enter the low power state */
-		t7xx_dpmaif_clr_ip_busy_sts(&dpmaif_ctrl->hif_hw_info);
-	} else {
-		t7xx_dpmaif_clr_ip_busy_sts(&dpmaif_ctrl->hif_hw_info);
-		t7xx_dpmaif_unmask_ulq_intr(dpmaif_ctrl, txq->index);
+	/* The device may be in low power state. Disable sleep if needed */
+	t7xx_pci_disable_sleep(dpmaif_ctrl->t7xx_dev);
+	if (t7xx_pci_sleep_disable_complete(dpmaif_ctrl->t7xx_dev)) {
+		ret = t7xx_dpmaif_tx_release(dpmaif_ctrl, txq->index, txq->drb_size_cnt);
+		if (ret == -EAGAIN ||
+		    (t7xx_dpmaif_ul_clr_done(&dpmaif_ctrl->hif_hw_info, txq->index) &&
+		     t7xx_dpmaif_drb_ring_not_empty(txq))) {
+			queue_work(dpmaif_ctrl->txq[txq->index].worker,
+				   &dpmaif_ctrl->txq[txq->index].dpmaif_tx_work);
+			/* Give the device time to enter the low power state */
+			t7xx_dpmaif_clr_ip_busy_sts(&dpmaif_ctrl->hif_hw_info);
+		} else {
+			t7xx_dpmaif_clr_ip_busy_sts(&dpmaif_ctrl->hif_hw_info);
+			t7xx_dpmaif_unmask_ulq_intr(dpmaif_ctrl, txq->index);
+		}
 	}
 
+	t7xx_pci_enable_sleep(dpmaif_ctrl->t7xx_dev);
 	pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
 	pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 }
@@ -429,6 +434,8 @@ static bool t7xx_check_all_txq_drb_lack(const struct dpmaif_ctrl *dpmaif_ctrl)
 
 static void t7xx_do_tx_hw_push(struct dpmaif_ctrl *dpmaif_ctrl)
 {
+	bool first_time = true;
+
 	dpmaif_ctrl->txq_select_times = 0;
 	do {
 		int txq_id;
@@ -444,6 +451,11 @@ static void t7xx_do_tx_hw_push(struct dpmaif_ctrl *dpmaif_ctrl)
 			if (ret > 0) {
 				int drb_send_cnt = ret;
 
+				/* Wait for the PCIe resource to unlock */
+				if (first_time &&
+				    !t7xx_pci_sleep_disable_complete(dpmaif_ctrl->t7xx_dev))
+					return;
+
 				ret = t7xx_dpmaif_ul_update_hw_drb_cnt(dpmaif_ctrl,
 								       (unsigned char)txq_id,
 								       drb_send_cnt *
@@ -457,6 +469,7 @@ static void t7xx_do_tx_hw_push(struct dpmaif_ctrl *dpmaif_ctrl)
 			}
 		}
 
+		first_time = false;
 		cond_resched();
 	} while (!t7xx_tx_lists_are_all_empty(dpmaif_ctrl) && !kthread_should_stop() &&
 		 (dpmaif_ctrl->state == DPMAIF_STATE_PWRON));
@@ -483,7 +496,9 @@ static int t7xx_dpmaif_tx_hw_push_thread(void *arg)
 		if (ret < 0 && ret != -EACCES)
 			return ret;
 
+		t7xx_pci_disable_sleep(dpmaif_ctrl->t7xx_dev);
 		t7xx_do_tx_hw_push(dpmaif_ctrl);
+		t7xx_pci_enable_sleep(dpmaif_ctrl->t7xx_dev);
 		pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
 		pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 	}
diff --git a/drivers/net/wwan/t7xx/t7xx_mhccif.c b/drivers/net/wwan/t7xx/t7xx_mhccif.c
index 74c79d520d88..da076416da10 100644
--- a/drivers/net/wwan/t7xx/t7xx_mhccif.c
+++ b/drivers/net/wwan/t7xx/t7xx_mhccif.c
@@ -55,6 +55,9 @@ static irqreturn_t t7xx_mhccif_isr_thread(int irq, void *data)
 
 	t7xx_mhccif_clear_interrupts(t7xx_dev, int_sts);
 
+	if (int_sts & D2H_INT_DS_LOCK_ACK)
+		complete_all(&t7xx_dev->sleep_lock_acquire);
+
 	if (int_sts & D2H_INT_SR_ACK)
 		complete(&t7xx_dev->pm_sr_ack);
 
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index a1a0824c1e11..8d70847826fb 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -34,6 +34,7 @@
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
 #include <linux/pm_wakeup.h>
+#include <linux/spinlock.h>
 
 #include "t7xx_mhccif.h"
 #include "t7xx_modem_ops.h"
@@ -45,6 +46,7 @@
 #define PCI_IREG_BASE			0
 #define PCI_EREG_BASE			2
 
+#define MTK_WAIT_TIMEOUT_MS		10
 #define PM_ACK_TIMEOUT_MS		1500
 #define PM_AUTOSUSPEND_MS		20000
 #define PM_RESOURCE_POLL_TIMEOUT_US	10000
@@ -57,6 +59,21 @@ enum t7xx_pm_state {
 	MTK_PM_RESUMED,
 };
 
+static void t7xx_dev_set_sleep_capability(struct t7xx_pci_dev *t7xx_dev, bool enable)
+{
+	void __iomem *ctrl_reg = IREG_BASE(t7xx_dev) + PCIE_MISC_CTRL;
+	u32 value;
+
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
 static int t7xx_wait_pm_config(struct t7xx_pci_dev *t7xx_dev)
 {
 	int ret, val;
@@ -77,10 +94,14 @@ static int t7xx_pci_pm_init(struct t7xx_pci_dev *t7xx_dev)
 
 	INIT_LIST_HEAD(&t7xx_dev->md_pm_entities);
 
+	spin_lock_init(&t7xx_dev->md_pm_lock);
+
 	mutex_init(&t7xx_dev->md_pm_entity_mtx);
 
+	init_completion(&t7xx_dev->sleep_lock_acquire);
 	init_completion(&t7xx_dev->pm_sr_ack);
 
+	atomic_set(&t7xx_dev->sleep_disable_count, 0);
 	device_init_wakeup(&pdev->dev, true);
 
 	dev_pm_set_driver_flags(&pdev->dev, pdev->dev.power.driver_flags |
@@ -99,6 +120,7 @@ void t7xx_pci_pm_init_late(struct t7xx_pci_dev *t7xx_dev)
 {
 	/* Enable the PCIe resource lock only after MD deep sleep is done */
 	t7xx_mhccif_mask_clr(t7xx_dev,
+			     D2H_INT_DS_LOCK_ACK |
 			     D2H_INT_SUSPEND_ACK |
 			     D2H_INT_RESUME_ACK |
 			     D2H_INT_SUSPEND_ACK_AP |
@@ -164,6 +186,81 @@ int t7xx_pci_pm_entity_unregister(struct t7xx_pci_dev *t7xx_dev, struct md_pm_en
 	return -ENXIO;
 }
 
+int t7xx_pci_sleep_disable_complete(struct t7xx_pci_dev *t7xx_dev)
+{
+	struct device *dev = &t7xx_dev->pdev->dev;
+	int ret;
+
+	ret = wait_for_completion_timeout(&t7xx_dev->sleep_lock_acquire,
+					  msecs_to_jiffies(MTK_WAIT_TIMEOUT_MS));
+	if (!ret)
+		dev_err_ratelimited(dev, "Resource wait complete timed out\n");
+
+	return ret;
+}
+
+/**
+ * t7xx_pci_disable_sleep() - Disable deep sleep capability.
+ * @t7xx_dev: MTK device.
+ *
+ * Lock the deep sleep capability, note that the device can still go into deep sleep
+ * state while device is in D0 state, from the host's point-of-view.
+ *
+ * If device is in deep sleep state, wake up the device and disable deep sleep capability.
+ */
+void t7xx_pci_disable_sleep(struct t7xx_pci_dev *t7xx_dev)
+{
+	unsigned long flags;
+
+	if (atomic_read(&t7xx_dev->md_pm_state) < MTK_PM_RESUMED) {
+		atomic_inc(&t7xx_dev->sleep_disable_count);
+		complete_all(&t7xx_dev->sleep_lock_acquire);
+		return;
+	}
+
+	spin_lock_irqsave(&t7xx_dev->md_pm_lock, flags);
+	if (atomic_inc_return(&t7xx_dev->sleep_disable_count) == 1) {
+		u32 deep_sleep_enabled;
+
+		reinit_completion(&t7xx_dev->sleep_lock_acquire);
+		t7xx_dev_set_sleep_capability(t7xx_dev, false);
+
+		deep_sleep_enabled = ioread32(IREG_BASE(t7xx_dev) + PCIE_RESOURCE_STATUS);
+		deep_sleep_enabled &= PCIE_RESOURCE_STATUS_MSK;
+		if (deep_sleep_enabled) {
+			spin_unlock_irqrestore(&t7xx_dev->md_pm_lock, flags);
+			complete_all(&t7xx_dev->sleep_lock_acquire);
+			return;
+		}
+
+		t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_DS_LOCK);
+	}
+
+	spin_unlock_irqrestore(&t7xx_dev->md_pm_lock, flags);
+}
+
+/**
+ * t7xx_pci_enable_sleep() - Enable deep sleep capability.
+ * @t7xx_dev: MTK device.
+ *
+ * After enabling deep sleep, device can enter into deep sleep state.
+ */
+void t7xx_pci_enable_sleep(struct t7xx_pci_dev *t7xx_dev)
+{
+	unsigned long flags;
+
+	if (atomic_read(&t7xx_dev->md_pm_state) < MTK_PM_RESUMED) {
+		atomic_dec(&t7xx_dev->sleep_disable_count);
+		return;
+	}
+
+	if (atomic_dec_and_test(&t7xx_dev->sleep_disable_count)) {
+		spin_lock_irqsave(&t7xx_dev->md_pm_lock, flags);
+		t7xx_dev_set_sleep_capability(t7xx_dev, true);
+		spin_unlock_irqrestore(&t7xx_dev->md_pm_lock, flags);
+	}
+}
+
 static int __t7xx_pci_pm_suspend(struct pci_dev *pdev)
 {
 	struct t7xx_pci_dev *t7xx_dev;
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.h b/drivers/net/wwan/t7xx/t7xx_pci.h
index 6310f31540ca..90d358bff54c 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.h
+++ b/drivers/net/wwan/t7xx/t7xx_pci.h
@@ -21,6 +21,7 @@
 #include <linux/irqreturn.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
+#include <linux/spinlock.h>
 #include <linux/types.h>
 
 #include "t7xx_reg.h"
@@ -51,7 +52,10 @@ typedef irqreturn_t (*t7xx_intr_callback)(int irq, void *param);
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
@@ -69,7 +73,10 @@ struct t7xx_pci_dev {
 
 	/* Low Power Items */
 	struct list_head	md_pm_entities;
+	spinlock_t		md_pm_lock;		/* Protects PCI resource lock */
 	struct mutex		md_pm_entity_mtx;	/* Protects MD PM entities list */
+	atomic_t		sleep_disable_count;
+	struct completion	sleep_lock_acquire;
 	struct completion	pm_sr_ack;
 	atomic_t		md_pm_state;
 
@@ -105,6 +112,9 @@ struct md_pm_entity {
 	void			*entity_param;
 };
 
+void t7xx_pci_disable_sleep(struct t7xx_pci_dev *t7xx_dev);
+void t7xx_pci_enable_sleep(struct t7xx_pci_dev *t7xx_dev);
+int t7xx_pci_sleep_disable_complete(struct t7xx_pci_dev *t7xx_dev);
 int t7xx_pci_pm_entity_register(struct t7xx_pci_dev *t7xx_dev, struct md_pm_entity *pm_entity);
 int t7xx_pci_pm_entity_unregister(struct t7xx_pci_dev *t7xx_dev, struct md_pm_entity *pm_entity);
 void t7xx_pci_pm_init_late(struct t7xx_pci_dev *t7xx_dev);
-- 
2.17.1

