Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C1E48E202
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 02:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238712AbiANBHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 20:07:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:16346 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238626AbiANBG5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 20:06:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642122417; x=1673658417;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=V0UteZoYYjAQniSAclDdLDI4ql1/qLvj4dB+Op5XrHY=;
  b=T9yzEDNe4kk3ei5/gft9T4nXYox2PQzwh1eFLdXKxV4f+oa70vHbGM/O
   6N0rpjmYYs8cCNsSpQ++h+FaNCCzfe35Ps8wX+ZiTd/AyQ/DR+rC7a4zg
   OYhkHLeAUY3/m06o3ep/mgLwiGnCuEVh0hlcVh7ffhin0DmB7ApfCTxiI
   F046YBcuTFAaDmXOF9ZOvIqBTELj6U08BwfoTAaWi+GyusPB8fCUCocBd
   WKlsTEzww0COcDzSX9GqH28E2cCa4SIu42E//PnWC82Oe1fbbnPgw7p88
   +3Je684qBoMl+4Lr7g0fsK3ex+FHh8vonhIW5P3fSwP2Pxxr9QDgc8bLd
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="231503640"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="231503640"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:55 -0800
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="692014221"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:53 -0800
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, ilpo.johannes.jarvinen@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH net-next v4 11/13] net: wwan: t7xx: Runtime PM
Date:   Thu, 13 Jan 2022 18:06:25 -0700
Message-Id: <20220114010627.21104-12-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haijun Liu <haijun.liu@mediatek.com>

Enables runtime power management callbacks including runtime_suspend
and runtime_resume. Autosuspend is used to prevent overhead by frequent
wake-ups.

Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Co-developed-by: Eliot Lee <eliot.lee@intel.com>
Signed-off-by: Eliot Lee <eliot.lee@intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c     | 13 +++++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c | 16 ++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c | 15 +++++++++++++++
 drivers/net/wwan/t7xx/t7xx_pci.c           | 21 +++++++++++++++++++++
 4 files changed, 65 insertions(+)

diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
index 31e32c10dabb..1678caef679c 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -34,6 +34,7 @@
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/pci.h>
+#include <linux/pm_runtime.h>
 #include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
@@ -257,6 +258,8 @@ static void t7xx_cldma_rx_done(struct work_struct *work)
 	t7xx_cldma_clear_ip_busy(&md_ctrl->hw_info);
 	t7xx_cldma_hw_irq_en_txrx(&md_ctrl->hw_info, queue->index, MTK_RX);
 	t7xx_cldma_hw_irq_en_eq(&md_ctrl->hw_info, queue->index, MTK_RX);
+	pm_runtime_mark_last_busy(md_ctrl->dev);
+	pm_runtime_put_autosuspend(md_ctrl->dev);
 }
 
 static int t7xx_cldma_gpd_tx_collect(struct cldma_queue *queue)
@@ -370,6 +373,8 @@ static void t7xx_cldma_tx_done(struct work_struct *work)
 	}
 
 	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+	pm_runtime_mark_last_busy(md_ctrl->dev);
+	pm_runtime_put_autosuspend(md_ctrl->dev);
 }
 
 static void t7xx_cldma_ring_free(struct cldma_ctrl *md_ctrl,
@@ -579,6 +584,7 @@ static void t7xx_cldma_irq_work_cb(struct cldma_ctrl *md_ctrl)
 		if (l2_tx_int & (TXRX_STATUS_BITMASK | EMPTY_STATUS_BITMASK)) {
 			for_each_set_bit(i, (unsigned long *)&l2_tx_int, L2_INT_BIT_COUNT) {
 				if (i < CLDMA_TXQ_NUM) {
+					pm_runtime_get(md_ctrl->dev);
 					t7xx_cldma_hw_irq_dis_eq(hw_info, i, MTK_TX);
 					t7xx_cldma_hw_irq_dis_txrx(hw_info, i, MTK_TX);
 					queue_work(md_ctrl->txq[i].worker,
@@ -603,6 +609,7 @@ static void t7xx_cldma_irq_work_cb(struct cldma_ctrl *md_ctrl)
 		if (l2_rx_int & (TXRX_STATUS_BITMASK | EMPTY_STATUS_BITMASK)) {
 			l2_rx_int |= l2_rx_int >> CLDMA_RXQ_NUM;
 			for_each_set_bit(i, (unsigned long *)&l2_rx_int, CLDMA_RXQ_NUM) {
+				pm_runtime_get(md_ctrl->dev);
 				t7xx_cldma_hw_irq_dis_eq(hw_info, i, MTK_RX);
 				t7xx_cldma_hw_irq_dis_txrx(hw_info, i, MTK_RX);
 				queue_work(md_ctrl->rxq[i].worker, &md_ctrl->rxq[i].cldma_work);
@@ -952,6 +959,10 @@ int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct sk_buff *skb
 	if (qno >= CLDMA_TXQ_NUM)
 		return -EINVAL;
 
+	ret = pm_runtime_resume_and_get(md_ctrl->dev);
+	if (ret < 0 && ret != -EACCES)
+		return ret;
+
 	queue = &md_ctrl->txq[qno];
 
 	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
@@ -1001,6 +1012,8 @@ int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct sk_buff *skb
 	} while (!ret);
 
 allow_sleep:
+	pm_runtime_mark_last_busy(md_ctrl->dev);
+	pm_runtime_put_autosuspend(md_ctrl->dev);
 	return ret;
 }
 
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
index 7df7ffea8b14..279a7e72f203 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
@@ -32,6 +32,7 @@
 #include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/netdevice.h>
+#include <linux/pm_runtime.h>
 #include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
@@ -915,6 +916,7 @@ static void t7xx_dpmaif_rxq_work(struct work_struct *work)
 {
 	struct dpmaif_rx_queue *rxq = container_of(work, struct dpmaif_rx_queue, dpmaif_rxq_work);
 	struct dpmaif_ctrl *dpmaif_ctrl = rxq->dpmaif_ctrl;
+	int ret;
 
 	atomic_set(&rxq->rx_processing, 1);
 	/* Ensure rx_processing is changed to 1 before actually begin RX flow */
@@ -926,8 +928,14 @@ static void t7xx_dpmaif_rxq_work(struct work_struct *work)
 		return;
 	}
 
+	ret = pm_runtime_resume_and_get(dpmaif_ctrl->dev);
+	if (ret < 0 && ret != -EACCES)
+		return;
+
 	t7xx_dpmaif_do_rx(dpmaif_ctrl, rxq);
 
+	pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
+	pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 	atomic_set(&rxq->rx_processing, 0);
 }
 
@@ -1130,11 +1138,19 @@ static void t7xx_dpmaif_bat_release_work(struct work_struct *work)
 {
 	struct dpmaif_ctrl *dpmaif_ctrl = container_of(work, struct dpmaif_ctrl, bat_release_work);
 	struct dpmaif_rx_queue *rxq;
+	int ret;
+
+	ret = pm_runtime_resume_and_get(dpmaif_ctrl->dev);
+	if (ret < 0 && ret != -EACCES)
+		return;
 
 	/* ALL RXQ use one BAT table, so choose DPF_RX_QNO_DFT */
 	rxq = &dpmaif_ctrl->rxq[DPF_RX_QNO_DFT];
 	t7xx_dpmaif_bat_release_and_add(rxq);
 	t7xx_dpmaif_frag_bat_release_and_add(rxq);
+
+	pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
+	pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 }
 
 int t7xx_dpmaif_bat_rel_wq_alloc(struct dpmaif_ctrl *dpmaif_ctrl)
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
index 3c601492aa16..12362892a334 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
@@ -29,6 +29,7 @@
 #include <linux/list.h>
 #include <linux/minmax.h>
 #include <linux/netdevice.h>
+#include <linux/pm_runtime.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/skbuff.h>
@@ -171,6 +172,10 @@ static void t7xx_dpmaif_tx_done(struct work_struct *work)
 	struct dpmaif_ctrl *dpmaif_ctrl = txq->dpmaif_ctrl;
 	int ret;
 
+	ret = pm_runtime_resume_and_get(dpmaif_ctrl->dev);
+	if (ret < 0 && ret != -EACCES)
+		return;
+
 	ret = t7xx_dpmaif_tx_release(dpmaif_ctrl, txq->index, txq->drb_size_cnt);
 	if (ret == -EAGAIN ||
 	    (t7xx_dpmaif_ul_clr_done(&dpmaif_ctrl->hif_hw_info, txq->index) &&
@@ -183,6 +188,9 @@ static void t7xx_dpmaif_tx_done(struct work_struct *work)
 		t7xx_dpmaif_clr_ip_busy_sts(&dpmaif_ctrl->hif_hw_info);
 		t7xx_dpmaif_unmask_ulq_intr(dpmaif_ctrl, txq->index);
 	}
+
+	pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
+	pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 }
 
 static void t7xx_setup_msg_drb(struct dpmaif_ctrl *dpmaif_ctrl, unsigned char q_num,
@@ -449,6 +457,7 @@ static void t7xx_do_tx_hw_push(struct dpmaif_ctrl *dpmaif_ctrl)
 static int t7xx_dpmaif_tx_hw_push_thread(void *arg)
 {
 	struct dpmaif_ctrl *dpmaif_ctrl = arg;
+	int ret;
 
 	while (!kthread_should_stop()) {
 		if (t7xx_tx_lists_are_all_empty(dpmaif_ctrl) ||
@@ -463,7 +472,13 @@ static int t7xx_dpmaif_tx_hw_push_thread(void *arg)
 				break;
 		}
 
+		ret = pm_runtime_resume_and_get(dpmaif_ctrl->dev);
+		if (ret < 0 && ret != -EACCES)
+			return ret;
+
 		t7xx_do_tx_hw_push(dpmaif_ctrl);
+		pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
+		pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 	}
 
 	return 0;
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index 7d30f597c7e9..03ed951ddfbe 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -32,6 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/pm.h>
+#include <linux/pm_runtime.h>
 #include <linux/pm_wakeup.h>
 
 #include "t7xx_mhccif.h"
@@ -45,6 +46,7 @@
 #define PCI_EREG_BASE			2
 
 #define PM_ACK_TIMEOUT_MS		1500
+#define PM_AUTOSUSPEND_MS		20000
 #define PM_RESOURCE_POLL_TIMEOUT_US	10000
 #define PM_RESOURCE_POLL_STEP_US	100
 
@@ -87,6 +89,8 @@ static int t7xx_pci_pm_init(struct t7xx_pci_dev *t7xx_dev)
 	atomic_set(&t7xx_dev->md_pm_state, MTK_PM_INIT);
 
 	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(t7xx_dev) + DIS_ASPM_LOWPWR_SET_0);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, PM_AUTOSUSPEND_MS);
+	pm_runtime_use_autosuspend(&pdev->dev);
 
 	return t7xx_wait_pm_config(t7xx_dev);
 }
@@ -101,6 +105,8 @@ void t7xx_pci_pm_init_late(struct t7xx_pci_dev *t7xx_dev)
 			     D2H_INT_RESUME_ACK_AP);
 	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(t7xx_dev) + DIS_ASPM_LOWPWR_CLR_0);
 	atomic_set(&t7xx_dev->md_pm_state, MTK_PM_RESUMED);
+
+	pm_runtime_put_noidle(&t7xx_dev->pdev->dev);
 }
 
 static int t7xx_pci_pm_reinit(struct t7xx_pci_dev *t7xx_dev)
@@ -110,6 +116,8 @@ static int t7xx_pci_pm_reinit(struct t7xx_pci_dev *t7xx_dev)
 	 */
 	atomic_set(&t7xx_dev->md_pm_state, MTK_PM_INIT);
 
+	pm_runtime_get_noresume(&t7xx_dev->pdev->dev);
+
 	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(t7xx_dev) + DIS_ASPM_LOWPWR_SET_0);
 	return t7xx_wait_pm_config(t7xx_dev);
 }
@@ -409,6 +417,7 @@ static int __t7xx_pci_pm_resume(struct pci_dev *pdev, bool state_check)
 	t7xx_dev->rgu_pci_irq_en = true;
 	t7xx_pcie_mac_set_int(t7xx_dev, SAP_RGU_INT);
 	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(t7xx_dev) + DIS_ASPM_LOWPWR_CLR_0);
+	pm_runtime_mark_last_busy(&pdev->dev);
 	atomic_set(&t7xx_dev->md_pm_state, MTK_PM_RESUMED);
 
 	return ret;
@@ -445,6 +454,16 @@ static int t7xx_pci_pm_thaw(struct device *dev)
 	return __t7xx_pci_pm_resume(to_pci_dev(dev), false);
 }
 
+static int t7xx_pci_pm_runtime_suspend(struct device *dev)
+{
+	return __t7xx_pci_pm_suspend(to_pci_dev(dev));
+}
+
+static int t7xx_pci_pm_runtime_resume(struct device *dev)
+{
+	return __t7xx_pci_pm_resume(to_pci_dev(dev), true);
+}
+
 static const struct dev_pm_ops t7xx_pci_pm_ops = {
 	.suspend = t7xx_pci_pm_suspend,
 	.resume = t7xx_pci_pm_resume,
@@ -454,6 +473,8 @@ static const struct dev_pm_ops t7xx_pci_pm_ops = {
 	.poweroff = t7xx_pci_pm_suspend,
 	.restore = t7xx_pci_pm_resume,
 	.restore_noirq = t7xx_pci_pm_resume_noirq,
+	.runtime_suspend = t7xx_pci_pm_runtime_suspend,
+	.runtime_resume = t7xx_pci_pm_runtime_resume
 };
 
 static int t7xx_request_irq(struct pci_dev *pdev)
-- 
2.17.1

