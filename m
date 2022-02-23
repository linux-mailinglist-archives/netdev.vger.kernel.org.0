Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950CF4C1EA6
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244604AbiBWWgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244179AbiBWWfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:35:46 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF6650E16;
        Wed, 23 Feb 2022 14:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645655715; x=1677191715;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=AH2/ebpy69FuJ9XIE9uNyKFc+8Z4TgjHKUOxPIbe+yQ=;
  b=DFO6aesvKpOPBLHvOgpg0qqo5FIJt8dKtzFEVw4DLQkUGjPw7yP//bu3
   T/pKvtg90ASTxU4AcYqesrYOsj86WeM+NBSikLH9JI3coFQIE9+qT0+B0
   foSpPS3nY4sMwCxY3mEE+126jHvqNLYZEi1HhdcdVCIRLnadMTEwC3pbv
   vdKJQpdRyWJbnz49aquZSu67fs4tVDzJCcQTUyJxDlDZRsD55j7Axa4m0
   cVukFQ4fs+6m82KlrVn1dnexJl0llA/TMqMUMChvy0cuukSmkwNUn8xZ+
   40bONoHRKVX6WaRQSmh001TA2ShhlZlBD6LgjWIvDMCEH1+VUrhG8ApHl
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="232718024"
X-IronPort-AV: E=Sophos;i="5.88,392,1635231600"; 
   d="scan'208";a="232718024"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 14:35:14 -0800
X-IronPort-AV: E=Sophos;i="5.88,392,1635231600"; 
   d="scan'208";a="628252283"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 14:35:13 -0800
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
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH net-next v5 11/13] net: wwan: t7xx: Runtime PM
Date:   Wed, 23 Feb 2022 15:33:24 -0700
Message-Id: <20220223223326.28021-12-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220223223326.28021-1-ricardo.martinez@linux.intel.com>
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c     | 14 ++++++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c | 17 +++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c | 15 +++++++++++++++
 drivers/net/wwan/t7xx/t7xx_pci.c           | 22 ++++++++++++++++++++++
 4 files changed, 68 insertions(+)

diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
index 114b67ebb270..c67eacfd69b5 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -33,6 +33,7 @@
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/pci.h>
+#include <linux/pm_runtime.h>
 #include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
@@ -262,6 +263,8 @@ static void t7xx_cldma_rx_done(struct work_struct *work)
 	t7xx_cldma_clear_ip_busy(&md_ctrl->hw_info);
 	t7xx_cldma_hw_irq_en_txrx(&md_ctrl->hw_info, queue->index, MTK_RX);
 	t7xx_cldma_hw_irq_en_eq(&md_ctrl->hw_info, queue->index, MTK_RX);
+	pm_runtime_mark_last_busy(md_ctrl->dev);
+	pm_runtime_put_autosuspend(md_ctrl->dev);
 }
 
 static int t7xx_cldma_gpd_tx_collect(struct cldma_queue *queue)
@@ -373,6 +376,9 @@ static void t7xx_cldma_tx_done(struct work_struct *work)
 		t7xx_cldma_hw_irq_en_txrx(hw_info, queue->index, MTK_TX);
 	}
 	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+
+	pm_runtime_mark_last_busy(md_ctrl->dev);
+	pm_runtime_put_autosuspend(md_ctrl->dev);
 }
 
 static void t7xx_cldma_ring_free(struct cldma_ctrl *md_ctrl,
@@ -579,6 +585,7 @@ static void t7xx_cldma_irq_work_cb(struct cldma_ctrl *md_ctrl)
 		if (l2_tx_int & (TXRX_STATUS_BITMASK | EMPTY_STATUS_BITMASK)) {
 			for_each_set_bit(i, (unsigned long *)&l2_tx_int, L2_INT_BIT_COUNT) {
 				if (i < CLDMA_TXQ_NUM) {
+					pm_runtime_get(md_ctrl->dev);
 					t7xx_cldma_hw_irq_dis_eq(hw_info, i, MTK_TX);
 					t7xx_cldma_hw_irq_dis_txrx(hw_info, i, MTK_TX);
 					queue_work(md_ctrl->txq[i].worker,
@@ -603,6 +610,7 @@ static void t7xx_cldma_irq_work_cb(struct cldma_ctrl *md_ctrl)
 		if (l2_rx_int & (TXRX_STATUS_BITMASK | EMPTY_STATUS_BITMASK)) {
 			l2_rx_int |= l2_rx_int >> CLDMA_RXQ_NUM;
 			for_each_set_bit(i, (unsigned long *)&l2_rx_int, CLDMA_RXQ_NUM) {
+				pm_runtime_get(md_ctrl->dev);
 				t7xx_cldma_hw_irq_dis_eq(hw_info, i, MTK_RX);
 				t7xx_cldma_hw_irq_dis_txrx(hw_info, i, MTK_RX);
 				queue_work(md_ctrl->rxq[i].worker, &md_ctrl->rxq[i].cldma_work);
@@ -933,6 +941,10 @@ int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct sk_buff *skb
 	if (qno >= CLDMA_TXQ_NUM)
 		return -EINVAL;
 
+	ret = pm_runtime_resume_and_get(md_ctrl->dev);
+	if (ret < 0 && ret != -EACCES)
+		return ret;
+
 	queue = &md_ctrl->txq[qno];
 
 	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
@@ -976,6 +988,8 @@ int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct sk_buff *skb
 	} while (!ret);
 
 allow_sleep:
+	pm_runtime_mark_last_busy(md_ctrl->dev);
+	pm_runtime_put_autosuspend(md_ctrl->dev);
 	return ret;
 }
 
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
index 85fa747078bd..72dd76d90dbb 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
@@ -32,6 +32,7 @@
 #include <linux/minmax.h>
 #include <linux/mm.h>
 #include <linux/netdevice.h>
+#include <linux/pm_runtime.h>
 #include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
@@ -912,6 +913,7 @@ static void t7xx_dpmaif_rxq_work(struct work_struct *work)
 {
 	struct dpmaif_rx_queue *rxq = container_of(work, struct dpmaif_rx_queue, dpmaif_rxq_work);
 	struct dpmaif_ctrl *dpmaif_ctrl = rxq->dpmaif_ctrl;
+	int ret;
 
 	atomic_set(&rxq->rx_processing, 1);
 	/* Ensure rx_processing is changed to 1 before actually begin RX flow */
@@ -923,7 +925,14 @@ static void t7xx_dpmaif_rxq_work(struct work_struct *work)
 		return;
 	}
 
+	ret = pm_runtime_resume_and_get(dpmaif_ctrl->dev);
+	if (ret < 0 && ret != -EACCES)
+		return;
+
 	t7xx_dpmaif_do_rx(dpmaif_ctrl, rxq);
+
+	pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
+	pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 	atomic_set(&rxq->rx_processing, 0);
 }
 
@@ -1126,11 +1135,19 @@ static void t7xx_dpmaif_bat_release_work(struct work_struct *work)
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
index f588c729e957..6d1d084c404a 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
@@ -28,6 +28,7 @@
 #include <linux/list.h>
 #include <linux/minmax.h>
 #include <linux/netdevice.h>
+#include <linux/pm_runtime.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/skbuff.h>
@@ -164,6 +165,10 @@ static void t7xx_dpmaif_tx_done(struct work_struct *work)
 	struct dpmaif_hw_info *hw_info;
 	int ret;
 
+	ret = pm_runtime_resume_and_get(dpmaif_ctrl->dev);
+	if (ret < 0 && ret != -EACCES)
+		return;
+
 	hw_info = &dpmaif_ctrl->hw_info;
 	ret = t7xx_dpmaif_tx_release(dpmaif_ctrl, txq->index, txq->drb_size_cnt);
 	if (ret == -EAGAIN ||
@@ -177,6 +182,9 @@ static void t7xx_dpmaif_tx_done(struct work_struct *work)
 		t7xx_dpmaif_clr_ip_busy_sts(hw_info);
 		t7xx_dpmaif_unmask_ulq_intr(hw_info, txq->index);
 	}
+
+	pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
+	pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
 }
 
 static void t7xx_setup_msg_drb(struct dpmaif_ctrl *dpmaif_ctrl, unsigned char q_num,
@@ -438,6 +446,7 @@ static void t7xx_do_tx_hw_push(struct dpmaif_ctrl *dpmaif_ctrl)
 static int t7xx_dpmaif_tx_hw_push_thread(void *arg)
 {
 	struct dpmaif_ctrl *dpmaif_ctrl = arg;
+	int ret;
 
 	while (!kthread_should_stop()) {
 		if (t7xx_tx_lists_are_all_empty(dpmaif_ctrl) ||
@@ -452,7 +461,13 @@ static int t7xx_dpmaif_tx_hw_push_thread(void *arg)
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
index 880d9448d662..e027be718041 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -31,6 +31,7 @@
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/pm.h>
+#include <linux/pm_runtime.h>
 #include <linux/pm_wakeup.h>
 
 #include "t7xx_mhccif.h"
@@ -44,6 +45,7 @@
 #define T7XX_PCI_EREG_BASE		2
 
 #define PM_ACK_TIMEOUT_MS		1500
+#define PM_AUTOSUSPEND_MS		20000
 #define PM_RESOURCE_POLL_TIMEOUT_US	10000
 #define PM_RESOURCE_POLL_STEP_US	100
 
@@ -86,6 +88,8 @@ static int t7xx_pci_pm_init(struct t7xx_pci_dev *t7xx_dev)
 	atomic_set(&t7xx_dev->md_pm_state, MTK_PM_INIT);
 
 	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(t7xx_dev) + DIS_ASPM_LOWPWR_SET_0);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, PM_AUTOSUSPEND_MS);
+	pm_runtime_use_autosuspend(&pdev->dev);
 
 	return t7xx_wait_pm_config(t7xx_dev);
 }
@@ -100,6 +104,8 @@ void t7xx_pci_pm_init_late(struct t7xx_pci_dev *t7xx_dev)
 			     D2H_INT_RESUME_ACK_AP);
 	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(t7xx_dev) + DIS_ASPM_LOWPWR_CLR_0);
 	atomic_set(&t7xx_dev->md_pm_state, MTK_PM_RESUMED);
+
+	pm_runtime_put_noidle(&t7xx_dev->pdev->dev);
 }
 
 static int t7xx_pci_pm_reinit(struct t7xx_pci_dev *t7xx_dev)
@@ -108,6 +114,9 @@ static int t7xx_pci_pm_reinit(struct t7xx_pci_dev *t7xx_dev)
 	 * so just roll back PM setting to the init setting.
 	 */
 	atomic_set(&t7xx_dev->md_pm_state, MTK_PM_INIT);
+
+	pm_runtime_get_noresume(&t7xx_dev->pdev->dev);
+
 	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(t7xx_dev) + DIS_ASPM_LOWPWR_SET_0);
 	return t7xx_wait_pm_config(t7xx_dev);
 }
@@ -407,6 +416,7 @@ static int __t7xx_pci_pm_resume(struct pci_dev *pdev, bool state_check)
 	t7xx_dev->rgu_pci_irq_en = true;
 	t7xx_pcie_mac_set_int(t7xx_dev, SAP_RGU_INT);
 	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(t7xx_dev) + DIS_ASPM_LOWPWR_CLR_0);
+	pm_runtime_mark_last_busy(&pdev->dev);
 	atomic_set(&t7xx_dev->md_pm_state, MTK_PM_RESUMED);
 
 	return ret;
@@ -443,6 +453,16 @@ static int t7xx_pci_pm_thaw(struct device *dev)
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
@@ -452,6 +472,8 @@ static const struct dev_pm_ops t7xx_pci_pm_ops = {
 	.poweroff = t7xx_pci_pm_suspend,
 	.restore = t7xx_pci_pm_resume,
 	.restore_noirq = t7xx_pci_pm_resume_noirq,
+	.runtime_suspend = t7xx_pci_pm_runtime_suspend,
+	.runtime_resume = t7xx_pci_pm_runtime_resume
 };
 
 static int t7xx_request_irq(struct pci_dev *pdev)
-- 
2.17.1

