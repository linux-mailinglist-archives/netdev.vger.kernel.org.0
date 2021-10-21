Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120E1436C1C
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 22:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhJUUbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 16:31:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:57403 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232095AbhJUUbR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 16:31:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="292598315"
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="292598315"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:24 -0700
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="527625103"
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
Subject: [PATCH 10/14] net: wwan: t7xx: Introduce power management support
Date:   Thu, 21 Oct 2021 13:27:34 -0700
Message-Id: <20211021202738.729-11-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implements suspend, resumes, freeze, thaw, poweroff, and restore
`dev_pm_ops` callbacks.

From the host point of view, the t7xx driver is one entity. But, the
device has several modules that need to be addressed in different ways
during power management (PM) flows.
The driver uses the term 'PM entities' to refer to the 2 DPMA and
2 CLDMA HW blocks that need to be managed during PM flows.
When a dev_pm_ops function is called, the PM entities list is iterated
and the matching function is called for each entry in the list.

Signed-off-by: Haijun Lio <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c     | 122 +++++-
 drivers/net/wwan/t7xx/t7xx_hif_cldma.h     |   1 +
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c    |  98 +++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h    |   1 +
 drivers/net/wwan/t7xx/t7xx_mhccif.c        |  16 +
 drivers/net/wwan/t7xx/t7xx_pci.c           | 435 +++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_pci.h           |  45 +++
 drivers/net/wwan/t7xx/t7xx_state_monitor.c |   2 +
 8 files changed, 719 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
index ef1c46c1ac10..0f15f9283eca 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -1372,6 +1372,120 @@ void cldma_exception(enum cldma_id hif_id, enum hif_ex_stage stage)
 	}
 }
 
+static void cldma_resume_early(struct mtk_pci_dev *mtk_dev, void *entity_param)
+{
+	struct cldma_hw_info *hw_info;
+	struct cldma_ctrl *md_ctrl;
+	unsigned long flags;
+	int qno_t;
+
+	md_ctrl = entity_param;
+	hw_info = &md_ctrl->hw_info;
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	cldma_hw_restore(hw_info);
+
+	for (qno_t = 0; qno_t < CLDMA_TXQ_NUM; qno_t++) {
+		cldma_hw_set_start_address(hw_info, qno_t, md_ctrl->txq[qno_t].tx_xmit->gpd_addr,
+					   false);
+		cldma_hw_set_start_address(hw_info, qno_t, md_ctrl->rxq[qno_t].tr_done->gpd_addr,
+					   true);
+	}
+
+	cldma_enable_irq(md_ctrl);
+	cldma_hw_start_queue(hw_info, CLDMA_ALL_Q, true);
+	md_ctrl->rxq_active |= TXRX_STATUS_BITMASK;
+	cldma_hw_dismask_eqirq(hw_info, CLDMA_ALL_Q, true);
+	cldma_hw_dismask_txrxirq(hw_info, CLDMA_ALL_Q, true);
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+}
+
+static int cldma_resume(struct mtk_pci_dev *mtk_dev, void *entity_param)
+{
+	struct cldma_ctrl *md_ctrl;
+	unsigned long flags;
+
+	md_ctrl = entity_param;
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	md_ctrl->txq_active |= TXRX_STATUS_BITMASK;
+	cldma_hw_dismask_txrxirq(&md_ctrl->hw_info, CLDMA_ALL_Q, false);
+	cldma_hw_dismask_eqirq(&md_ctrl->hw_info, CLDMA_ALL_Q, false);
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+	if (md_ctrl->hif_id == ID_CLDMA1)
+		mhccif_mask_clr(mtk_dev, D2H_SW_INT_MASK);
+
+	return 0;
+}
+
+static void cldma_suspend_late(struct mtk_pci_dev *mtk_dev, void *entity_param)
+{
+	struct cldma_hw_info *hw_info;
+	struct cldma_ctrl *md_ctrl;
+	unsigned long flags;
+
+	md_ctrl = entity_param;
+	hw_info = &md_ctrl->hw_info;
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	cldma_hw_mask_eqirq(hw_info, CLDMA_ALL_Q, true);
+	cldma_hw_mask_txrxirq(hw_info, CLDMA_ALL_Q, true);
+	md_ctrl->rxq_active &= ~TXRX_STATUS_BITMASK;
+	cldma_hw_stop_queue(hw_info, CLDMA_ALL_Q, true);
+	cldma_clear_ip_busy(hw_info);
+	cldma_disable_irq(md_ctrl);
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+}
+
+static int cldma_suspend(struct mtk_pci_dev *mtk_dev, void *entity_param)
+{
+	struct cldma_hw_info *hw_info;
+	struct cldma_ctrl *md_ctrl;
+	unsigned long flags;
+
+	md_ctrl = entity_param;
+	hw_info = &md_ctrl->hw_info;
+	if (md_ctrl->hif_id == ID_CLDMA1)
+		mhccif_mask_set(mtk_dev, D2H_SW_INT_MASK);
+
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	cldma_hw_mask_eqirq(hw_info, CLDMA_ALL_Q, false);
+	cldma_hw_mask_txrxirq(hw_info, CLDMA_ALL_Q, false);
+	md_ctrl->txq_active &= ~TXRX_STATUS_BITMASK;
+	cldma_hw_stop_queue(hw_info, CLDMA_ALL_Q, false);
+	md_ctrl->txq_started = 0;
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+	return 0;
+}
+
+static int cldma_pm_init(struct cldma_ctrl *md_ctrl)
+{
+	md_ctrl->pm_entity = kzalloc(sizeof(*md_ctrl->pm_entity), GFP_KERNEL);
+	if (!md_ctrl->pm_entity)
+		return -ENOMEM;
+
+	md_ctrl->pm_entity->entity_param = md_ctrl;
+	if (md_ctrl->hif_id == ID_CLDMA1)
+		md_ctrl->pm_entity->id = PM_ENTITY_ID_CTRL1;
+	else
+		md_ctrl->pm_entity->id = PM_ENTITY_ID_CTRL2;
+
+	md_ctrl->pm_entity->suspend = cldma_suspend;
+	md_ctrl->pm_entity->suspend_late = cldma_suspend_late;
+	md_ctrl->pm_entity->resume = cldma_resume;
+	md_ctrl->pm_entity->resume_early = cldma_resume_early;
+
+	return mtk_pci_pm_entity_register(md_ctrl->mtk_dev, md_ctrl->pm_entity);
+}
+
+static int cldma_pm_uninit(struct cldma_ctrl *md_ctrl)
+{
+	if (!md_ctrl->pm_entity)
+		return -EINVAL;
+
+	mtk_pci_pm_entity_unregister(md_ctrl->mtk_dev, md_ctrl->pm_entity);
+	kfree_sensitive(md_ctrl->pm_entity);
+	md_ctrl->pm_entity = NULL;
+	return 0;
+}
+
 void cldma_hif_hw_init(enum cldma_id hif_id)
 {
 	struct cldma_hw_info *hw_info;
@@ -1413,6 +1527,7 @@ static irqreturn_t cldma_isr_handler(int irq, void *data)
  * cldma_init() - Initialize CLDMA
  * @hif_id: CLDMA ID (ID_CLDMA0 or ID_CLDMA1)
  *
+ * allocate and initialize device power management entity
  * initialize HIF TX/RX queue structure
  * register CLDMA callback isr with PCIe driver
  *
@@ -1423,7 +1538,7 @@ int cldma_init(enum cldma_id hif_id)
 	struct cldma_hw_info *hw_info;
 	struct cldma_ctrl *md_ctrl;
 	struct mtk_modem *md;
-	int i;
+	int ret, i;
 
 	md_ctrl = md_cd_get(hif_id);
 	md = md_ctrl->mtk_dev->md;
@@ -1432,6 +1547,9 @@ int cldma_init(enum cldma_id hif_id)
 	md_ctrl->rxq_active = 0;
 	md_ctrl->is_late_init = false;
 	hw_info = &md_ctrl->hw_info;
+	ret = cldma_pm_init(md_ctrl);
+	if (ret)
+		return ret;
 
 	spin_lock_init(&md_ctrl->cldma_lock);
 	/* initialize HIF queue structure */
@@ -1506,4 +1624,6 @@ void cldma_exit(enum cldma_id hif_id)
 			md_ctrl->rxq[i].worker = NULL;
 		}
 	}
+
+	cldma_pm_uninit(md_ctrl);
 }
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.h b/drivers/net/wwan/t7xx/t7xx_hif_cldma.h
index 8cea9d612e6a..b6ad9ecd78c9 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.h
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.h
@@ -94,6 +94,7 @@ struct cldma_ctrl {
 	struct dma_pool *gpd_dmapool;
 	struct cldma_ring tx_ring[CLDMA_TXQ_NUM];
 	struct cldma_ring rx_ring[CLDMA_RXQ_NUM];
+	struct md_pm_entity *pm_entity;
 	struct cldma_hw_info hw_info;
 	bool is_late_init;
 	int (*recv_skb)(struct cldma_queue *queue, struct sk_buff *skb);
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c
index 69956c65eae4..05ea9b2de38f 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c
@@ -448,6 +448,98 @@ static int dpmaif_stop(struct dpmaif_ctrl *dpmaif_ctrl)
 	return 0;
 }
 
+static int dpmaif_suspend(struct mtk_pci_dev *mtk_dev, void *param)
+{
+	struct dpmaif_ctrl *dpmaif_ctrl;
+
+	dpmaif_ctrl = param;
+	dpmaif_suspend_tx_sw_stop(dpmaif_ctrl);
+	dpmaif_hw_stop_tx_queue(dpmaif_ctrl);
+	dpmaif_hw_stop_rx_queue(dpmaif_ctrl);
+	dpmaif_disable_irq(dpmaif_ctrl);
+	dpmaif_suspend_rx_sw_stop(dpmaif_ctrl);
+	return 0;
+}
+
+static void dpmaif_unmask_dlq_interrupt(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	int qno;
+
+	for (qno = 0; qno < DPMAIF_RXQ_NUM; qno++)
+		dpmaif_hw_dlq_unmask_rx_done(&dpmaif_ctrl->hif_hw_info, qno);
+}
+
+static void dpmaif_pre_start_hw(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct dpmaif_rx_queue *rxq;
+	struct dpmaif_tx_queue *txq;
+	unsigned int que_cnt;
+
+	/* Enable UL SW active */
+	for (que_cnt = 0; que_cnt < DPMAIF_TXQ_NUM; que_cnt++) {
+		txq = &dpmaif_ctrl->txq[que_cnt];
+		txq->que_started = true;
+	}
+
+	/* Enable DL/RX SW active */
+	for (que_cnt = 0; que_cnt < DPMAIF_RXQ_NUM; que_cnt++) {
+		rxq = &dpmaif_ctrl->rxq[que_cnt];
+		rxq->que_started = true;
+	}
+}
+
+static int dpmaif_resume(struct mtk_pci_dev *mtk_dev, void *param)
+{
+	struct dpmaif_ctrl *dpmaif_ctrl;
+
+	dpmaif_ctrl = param;
+	if (!dpmaif_ctrl)
+		return 0;
+
+	/* start dpmaif tx/rx queue SW */
+	dpmaif_pre_start_hw(dpmaif_ctrl);
+	/* unmask PCIe DPMAIF interrupt */
+	dpmaif_enable_irq(dpmaif_ctrl);
+	dpmaif_unmask_dlq_interrupt(dpmaif_ctrl);
+	dpmaif_start_hw(dpmaif_ctrl);
+	wake_up(&dpmaif_ctrl->tx_wq);
+	return 0;
+}
+
+static int dpmaif_pm_entity_init(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct md_pm_entity *dpmaif_pm_entity;
+	int ret;
+
+	dpmaif_pm_entity = &dpmaif_ctrl->dpmaif_pm_entity;
+	INIT_LIST_HEAD(&dpmaif_pm_entity->entity);
+	dpmaif_pm_entity->suspend = &dpmaif_suspend;
+	dpmaif_pm_entity->suspend_late = NULL;
+	dpmaif_pm_entity->resume_early = NULL;
+	dpmaif_pm_entity->resume = &dpmaif_resume;
+	dpmaif_pm_entity->id = PM_ENTITY_ID_DATA;
+	dpmaif_pm_entity->entity_param = dpmaif_ctrl;
+
+	ret = mtk_pci_pm_entity_register(dpmaif_ctrl->mtk_dev, dpmaif_pm_entity);
+	if (ret)
+		dev_err(dpmaif_ctrl->dev, "dpmaif register pm_entity fail\n");
+
+	return ret;
+}
+
+static int dpmaif_pm_entity_release(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct md_pm_entity *dpmaif_pm_entity;
+	int ret;
+
+	dpmaif_pm_entity = &dpmaif_ctrl->dpmaif_pm_entity;
+	ret = mtk_pci_pm_entity_unregister(dpmaif_ctrl->mtk_dev, dpmaif_pm_entity);
+	if (ret < 0)
+		dev_err(dpmaif_ctrl->dev, "dpmaif register pm_entity fail\n");
+
+	return ret;
+}
+
 int dpmaif_md_state_callback(struct dpmaif_ctrl *dpmaif_ctrl, unsigned char state)
 {
 	int ret = 0;
@@ -507,6 +599,10 @@ struct dpmaif_ctrl *dpmaif_hif_init(struct mtk_pci_dev *mtk_dev,
 	dpmaif_ctrl->hif_hw_info.pcie_base = mtk_dev->base_addr.pcie_ext_reg_base -
 					     mtk_dev->base_addr.pcie_dev_reg_trsl_addr;
 
+	ret = dpmaif_pm_entity_init(dpmaif_ctrl);
+	if (ret)
+		return NULL;
+
 	/* registers dpmaif irq by PCIe driver API */
 	dpmaif_platform_irq_init(dpmaif_ctrl);
 	dpmaif_disable_irq(dpmaif_ctrl);
@@ -515,6 +611,7 @@ struct dpmaif_ctrl *dpmaif_hif_init(struct mtk_pci_dev *mtk_dev,
 	ret = dpmaif_sw_init(dpmaif_ctrl);
 	if (ret) {
 		dev_err(&mtk_dev->pdev->dev, "DPMAIF SW initialization fail! %d\n", ret);
+		dpmaif_pm_entity_release(dpmaif_ctrl);
 		return NULL;
 	}
 
@@ -526,6 +623,7 @@ void dpmaif_hif_exit(struct dpmaif_ctrl *dpmaif_ctrl)
 {
 	if (dpmaif_ctrl->dpmaif_sw_init_done) {
 		dpmaif_stop(dpmaif_ctrl);
+		dpmaif_pm_entity_release(dpmaif_ctrl);
 		dpmaif_sw_release(dpmaif_ctrl);
 		dpmaif_ctrl->dpmaif_sw_init_done = false;
 	}
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
index 1a8f15904806..684b6f68e9e5 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
@@ -237,6 +237,7 @@ struct dpmaif_callbacks {
 struct dpmaif_ctrl {
 	struct device			*dev;
 	struct mtk_pci_dev		*mtk_dev;
+	struct md_pm_entity		dpmaif_pm_entity;
 	enum dpmaif_state		state;
 	bool				dpmaif_sw_init_done;
 	struct dpmaif_hw_info		hif_hw_info;
diff --git a/drivers/net/wwan/t7xx/t7xx_mhccif.c b/drivers/net/wwan/t7xx/t7xx_mhccif.c
index c68d98a3d765..68acf1ca0555 100644
--- a/drivers/net/wwan/t7xx/t7xx_mhccif.c
+++ b/drivers/net/wwan/t7xx/t7xx_mhccif.c
@@ -12,6 +12,11 @@
 #include "t7xx_pci.h"
 #include "t7xx_pcie_mac.h"
 
+#define D2H_INT_SR_ACK		(D2H_INT_SUSPEND_ACK |		\
+				 D2H_INT_RESUME_ACK |		\
+				 D2H_INT_SUSPEND_ACK_AP |	\
+				 D2H_INT_RESUME_ACK_AP)
+
 static void mhccif_clear_interrupts(struct mtk_pci_dev *mtk_dev, u32 mask)
 {
 	void __iomem *mhccif_pbase;
@@ -46,6 +51,17 @@ static irqreturn_t mhccif_isr_thread(int irq, void *data)
 	/* Clear 2 & 1 level interrupts */
 	mhccif_clear_interrupts(mtk_dev, int_sts);
 
+	if (int_sts & D2H_INT_SR_ACK)
+		complete(&mtk_dev->pm_sr_ack);
+
+	/* Use the 1 bits to avoid low power bits */
+	iowrite32(L1_DISABLE_BIT(1), IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_CLR_0);
+
+	int_sts = mhccif_read_sw_int_sts(mtk_dev);
+	if (!int_sts)
+		iowrite32(L1_1_DISABLE_BIT(1) | L1_2_DISABLE_BIT(1),
+			  IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_CLR_0);
+
 	/* Enable corresponding interrupt */
 	mtk_pcie_mac_set_int(mtk_dev, MHCCIF_INT);
 	return IRQ_HANDLED;
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index c16b3a2557f1..788bd6db8bc5 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -4,13 +4,18 @@
  * Copyright (c) 2021, Intel Corporation.
  */
 
+#include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/iopoll.h>
+#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
+#include <linux/spinlock.h>
 
 #include "t7xx_mhccif.h"
 #include "t7xx_modem_ops.h"
+#include "t7xx_monitor.h"
 #include "t7xx_pci.h"
 #include "t7xx_pcie_mac.h"
 #include "t7xx_reg.h"
@@ -19,6 +24,430 @@
 #define	PCI_IREG_BASE			0
 #define	PCI_EREG_BASE			2
 
+#define PM_ACK_TIMEOUT_MS		1500
+#define PM_RESOURCE_POLL_TIMEOUT_US	10000
+#define PM_RESOURCE_POLL_STEP_US	100
+
+enum mtk_pm_state {
+	MTK_PM_EXCEPTION,	/* Exception flow */
+	MTK_PM_INIT,		/* Device initialized, but handshake not completed */
+	MTK_PM_SUSPENDED,	/* Device in suspend state */
+	MTK_PM_RESUMED,		/* Device in resume state */
+};
+
+static int mtk_wait_pm_config(struct mtk_pci_dev *mtk_dev)
+{
+	int ret, val;
+
+	ret = read_poll_timeout(ioread32, val,
+				(val & PCIE_RESOURCE_STATUS_MSK) == PCIE_RESOURCE_STATUS_MSK,
+				PM_RESOURCE_POLL_STEP_US, PM_RESOURCE_POLL_TIMEOUT_US, true,
+				IREG_BASE(mtk_dev) + PCIE_RESOURCE_STATUS);
+	if (ret == -ETIMEDOUT)
+		dev_err(&mtk_dev->pdev->dev, "PM configuration timed out\n");
+
+	return ret;
+}
+
+static int mtk_pci_pm_init(struct mtk_pci_dev *mtk_dev)
+{
+	struct pci_dev *pdev;
+
+	pdev = mtk_dev->pdev;
+
+	INIT_LIST_HEAD(&mtk_dev->md_pm_entities);
+
+	mutex_init(&mtk_dev->md_pm_entity_mtx);
+
+	init_completion(&mtk_dev->pm_sr_ack);
+
+	device_init_wakeup(&pdev->dev, true);
+
+	dev_pm_set_driver_flags(&pdev->dev, pdev->dev.power.driver_flags |
+				DPM_FLAG_NO_DIRECT_COMPLETE);
+
+	atomic_set(&mtk_dev->md_pm_state, MTK_PM_INIT);
+
+	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_SET_0);
+
+	return mtk_wait_pm_config(mtk_dev);
+}
+
+void mtk_pci_pm_init_late(struct mtk_pci_dev *mtk_dev)
+{
+	/* enable the PCIe Resource Lock only after MD deep sleep is done */
+	mhccif_mask_clr(mtk_dev,
+			D2H_INT_SUSPEND_ACK |
+			D2H_INT_RESUME_ACK |
+			D2H_INT_SUSPEND_ACK_AP |
+			D2H_INT_RESUME_ACK_AP);
+	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_CLR_0);
+	atomic_set(&mtk_dev->md_pm_state, MTK_PM_RESUMED);
+}
+
+static int mtk_pci_pm_reinit(struct mtk_pci_dev *mtk_dev)
+{
+	/* The device is kept in FSM re-init flow
+	 * so just roll back PM setting to the init setting.
+	 */
+	atomic_set(&mtk_dev->md_pm_state, MTK_PM_INIT);
+
+	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_SET_0);
+	return mtk_wait_pm_config(mtk_dev);
+}
+
+void mtk_pci_pm_exp_detected(struct mtk_pci_dev *mtk_dev)
+{
+	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_SET_0);
+	mtk_wait_pm_config(mtk_dev);
+	atomic_set(&mtk_dev->md_pm_state, MTK_PM_EXCEPTION);
+}
+
+int mtk_pci_pm_entity_register(struct mtk_pci_dev *mtk_dev, struct md_pm_entity *pm_entity)
+{
+	struct md_pm_entity *entity;
+
+	mutex_lock(&mtk_dev->md_pm_entity_mtx);
+	list_for_each_entry(entity, &mtk_dev->md_pm_entities, entity) {
+		if (entity->id == pm_entity->id) {
+			mutex_unlock(&mtk_dev->md_pm_entity_mtx);
+			return -EEXIST;
+		}
+	}
+
+	list_add_tail(&pm_entity->entity, &mtk_dev->md_pm_entities);
+	mutex_unlock(&mtk_dev->md_pm_entity_mtx);
+	return 0;
+}
+
+int mtk_pci_pm_entity_unregister(struct mtk_pci_dev *mtk_dev, struct md_pm_entity *pm_entity)
+{
+	struct md_pm_entity *entity, *tmp_entity;
+
+	mutex_lock(&mtk_dev->md_pm_entity_mtx);
+
+	list_for_each_entry_safe(entity, tmp_entity, &mtk_dev->md_pm_entities, entity) {
+		if (entity->id == pm_entity->id) {
+			list_del(&pm_entity->entity);
+			mutex_unlock(&mtk_dev->md_pm_entity_mtx);
+			return 0;
+		}
+	}
+
+	mutex_unlock(&mtk_dev->md_pm_entity_mtx);
+
+	return -ENXIO;
+}
+
+static int __mtk_pci_pm_suspend(struct pci_dev *pdev)
+{
+	struct mtk_pci_dev *mtk_dev;
+	struct md_pm_entity *entity;
+	unsigned long wait_ret;
+	enum mtk_pm_id id;
+	int ret = 0;
+
+	mtk_dev = pci_get_drvdata(pdev);
+
+	if (atomic_read(&mtk_dev->md_pm_state) <= MTK_PM_INIT) {
+		dev_err(&pdev->dev,
+			"[PM] Exiting suspend, because handshake failure or in an exception\n");
+		return -EFAULT;
+	}
+
+	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_SET_0);
+	ret = mtk_wait_pm_config(mtk_dev);
+	if (ret)
+		return ret;
+
+	atomic_set(&mtk_dev->md_pm_state, MTK_PM_SUSPENDED);
+
+	mtk_pcie_mac_clear_int(mtk_dev, SAP_RGU_INT);
+	mtk_dev->rgu_pci_irq_en = false;
+
+	list_for_each_entry(entity, &mtk_dev->md_pm_entities, entity) {
+		if (entity->suspend) {
+			ret = entity->suspend(mtk_dev, entity->entity_param);
+			if (ret) {
+				id = entity->id;
+				break;
+			}
+		}
+	}
+
+	if (ret) {
+		dev_err(&pdev->dev, "[PM] Suspend error: %d, id: %d\n", ret, id);
+
+		list_for_each_entry(entity, &mtk_dev->md_pm_entities, entity) {
+			if (id == entity->id)
+				break;
+
+			if (entity->resume)
+				entity->resume(mtk_dev, entity->entity_param);
+		}
+
+		goto suspend_complete;
+	}
+
+	reinit_completion(&mtk_dev->pm_sr_ack);
+	/* send D3 enter request to MD */
+	mhccif_h2d_swint_trigger(mtk_dev, H2D_CH_SUSPEND_REQ);
+	wait_ret = wait_for_completion_timeout(&mtk_dev->pm_sr_ack,
+					       msecs_to_jiffies(PM_ACK_TIMEOUT_MS));
+	if (!wait_ret)
+		dev_err(&pdev->dev, "[PM] Wait for device suspend ACK timeout-MD\n");
+
+	reinit_completion(&mtk_dev->pm_sr_ack);
+	/* send D3 enter request to sAP */
+	mhccif_h2d_swint_trigger(mtk_dev, H2D_CH_SUSPEND_REQ_AP);
+	wait_ret = wait_for_completion_timeout(&mtk_dev->pm_sr_ack,
+					       msecs_to_jiffies(PM_ACK_TIMEOUT_MS));
+	if (!wait_ret)
+		dev_err(&pdev->dev, "[PM] Wait for device suspend ACK timeout-SAP\n");
+
+	/* Each HW's final work */
+	list_for_each_entry(entity, &mtk_dev->md_pm_entities, entity) {
+		if (entity->suspend_late)
+			entity->suspend_late(mtk_dev, entity->entity_param);
+	}
+
+suspend_complete:
+	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_CLR_0);
+	if (ret) {
+		atomic_set(&mtk_dev->md_pm_state, MTK_PM_RESUMED);
+		mtk_pcie_mac_set_int(mtk_dev, SAP_RGU_INT);
+	}
+
+	return ret;
+}
+
+static void mtk_pcie_interrupt_reinit(struct mtk_pci_dev *mtk_dev)
+{
+	mtk_pcie_mac_msix_cfg(mtk_dev, EXT_INT_NUM);
+
+	/* Disable interrupt first and let the IPs enable them */
+	iowrite32(MSIX_MSK_SET_ALL, IREG_BASE(mtk_dev) + IMASK_HOST_MSIX_CLR_GRP0_0);
+
+	/* Device disables PCIe interrupts during resume and
+	 * following function will re-enable PCIe interrupts.
+	 */
+	mtk_pcie_mac_interrupts_en(mtk_dev);
+	mtk_pcie_mac_set_int(mtk_dev, MHCCIF_INT);
+}
+
+static int mtk_pcie_reinit(struct mtk_pci_dev *mtk_dev, bool is_d3)
+{
+	int ret;
+
+	ret = pcim_enable_device(mtk_dev->pdev);
+	if (ret)
+		return ret;
+
+	mtk_pcie_mac_atr_init(mtk_dev);
+	mtk_pcie_interrupt_reinit(mtk_dev);
+
+	if (is_d3) {
+		mhccif_init(mtk_dev);
+		return mtk_pci_pm_reinit(mtk_dev);
+	}
+
+	return 0;
+}
+
+static int mtk_send_fsm_command(struct mtk_pci_dev *mtk_dev, u32 event)
+{
+	struct ccci_fsm_ctl *fsm_ctl;
+	int ret = -EINVAL;
+
+	fsm_ctl = fsm_get_entry();
+
+	switch (event) {
+	case CCCI_COMMAND_STOP:
+		ret = fsm_append_command(fsm_ctl, CCCI_COMMAND_STOP, 1);
+		break;
+
+	case CCCI_COMMAND_START:
+		mtk_pcie_mac_clear_int(mtk_dev, SAP_RGU_INT);
+		mtk_pcie_mac_clear_int_status(mtk_dev, SAP_RGU_INT);
+		mtk_dev->rgu_pci_irq_en = true;
+		mtk_pcie_mac_set_int(mtk_dev, SAP_RGU_INT);
+		ret = fsm_append_command(fsm_ctl, CCCI_COMMAND_START, 0);
+		break;
+
+	default:
+		break;
+	}
+	if (ret)
+		dev_err(&mtk_dev->pdev->dev, "handling FSM CMD event: %u error: %d\n", event, ret);
+
+	return ret;
+}
+
+static int __mtk_pci_pm_resume(struct pci_dev *pdev, bool state_check)
+{
+	struct mtk_pci_dev *mtk_dev;
+	struct md_pm_entity *entity;
+	unsigned long wait_ret;
+	u32 resume_reg_state;
+	int ret = 0;
+
+	mtk_dev = pci_get_drvdata(pdev);
+
+	if (atomic_read(&mtk_dev->md_pm_state) <= MTK_PM_INIT) {
+		iowrite32(L1_DISABLE_BIT(0), IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_CLR_0);
+		return 0;
+	}
+
+	/* Get the previous state */
+	resume_reg_state = ioread32(IREG_BASE(mtk_dev) + PCIE_PM_RESUME_STATE);
+
+	if (state_check) {
+		/* For D3/L3 resume, the device could boot so quickly that the
+		 * initial value of the dummy register might be overwritten.
+		 * Identify new boots if the ATR source address register is not initialized.
+		 */
+		u32 atr_reg_val = ioread32(IREG_BASE(mtk_dev) +
+					   ATR_PCIE_WIN0_T0_ATR_PARAM_SRC_ADDR);
+
+		if (resume_reg_state == PM_RESUME_REG_STATE_L3 ||
+		    (resume_reg_state == PM_RESUME_REG_STATE_INIT &&
+		     atr_reg_val == ATR_SRC_ADDR_INVALID)) {
+			ret = mtk_send_fsm_command(mtk_dev, CCCI_COMMAND_STOP);
+			if (ret)
+				return ret;
+
+			ret = mtk_pcie_reinit(mtk_dev, true);
+			if (ret)
+				return ret;
+
+			mtk_clear_rgu_irq(mtk_dev);
+			return mtk_send_fsm_command(mtk_dev, CCCI_COMMAND_START);
+		} else if (resume_reg_state == PM_RESUME_REG_STATE_EXP ||
+			   resume_reg_state == PM_RESUME_REG_STATE_L2_EXP) {
+			if (resume_reg_state == PM_RESUME_REG_STATE_L2_EXP) {
+				ret = mtk_pcie_reinit(mtk_dev, false);
+				if (ret)
+					return ret;
+			}
+
+			atomic_set(&mtk_dev->md_pm_state, MTK_PM_SUSPENDED);
+			mtk_dev->rgu_pci_irq_en = true;
+			mtk_pcie_mac_set_int(mtk_dev, SAP_RGU_INT);
+
+			mhccif_mask_clr(mtk_dev,
+					D2H_INT_EXCEPTION_INIT |
+					D2H_INT_EXCEPTION_INIT_DONE |
+					D2H_INT_EXCEPTION_CLEARQ_DONE |
+					D2H_INT_EXCEPTION_ALLQ_RESET |
+					D2H_INT_PORT_ENUM);
+
+			return ret;
+		} else if (resume_reg_state == PM_RESUME_REG_STATE_L2) {
+			ret = mtk_pcie_reinit(mtk_dev, false);
+			if (ret)
+				return ret;
+
+		} else if (resume_reg_state != PM_RESUME_REG_STATE_L1 &&
+			   resume_reg_state != PM_RESUME_REG_STATE_INIT) {
+			ret = mtk_send_fsm_command(mtk_dev, CCCI_COMMAND_STOP);
+			if (ret)
+				return ret;
+
+			mtk_clear_rgu_irq(mtk_dev);
+			atomic_set(&mtk_dev->md_pm_state, MTK_PM_SUSPENDED);
+			return 0;
+		}
+	}
+
+	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_SET_0);
+	mtk_wait_pm_config(mtk_dev);
+
+	list_for_each_entry(entity, &mtk_dev->md_pm_entities, entity) {
+		if (entity->resume_early)
+			entity->resume_early(mtk_dev, entity->entity_param);
+	}
+
+	reinit_completion(&mtk_dev->pm_sr_ack);
+	/* send D3 exit request to MD */
+	mhccif_h2d_swint_trigger(mtk_dev, H2D_CH_RESUME_REQ);
+	wait_ret = wait_for_completion_timeout(&mtk_dev->pm_sr_ack,
+					       msecs_to_jiffies(PM_ACK_TIMEOUT_MS));
+	if (!wait_ret)
+		dev_err(&pdev->dev, "[PM] Timed out waiting for device MD resume ACK\n");
+
+	reinit_completion(&mtk_dev->pm_sr_ack);
+	/* send D3 exit request to sAP */
+	mhccif_h2d_swint_trigger(mtk_dev, H2D_CH_RESUME_REQ_AP);
+	wait_ret = wait_for_completion_timeout(&mtk_dev->pm_sr_ack,
+					       msecs_to_jiffies(PM_ACK_TIMEOUT_MS));
+	if (!wait_ret)
+		dev_err(&pdev->dev, "[PM] Timed out waiting for device SAP resume ACK\n");
+
+	/* Each HW final restore works */
+	list_for_each_entry(entity, &mtk_dev->md_pm_entities, entity) {
+		if (entity->resume) {
+			ret = entity->resume(mtk_dev, entity->entity_param);
+			if (ret)
+				dev_err(&pdev->dev, "[PM] Resume entry ID: %d err: %d\n",
+					entity->id, ret);
+		}
+	}
+
+	mtk_dev->rgu_pci_irq_en = true;
+	mtk_pcie_mac_set_int(mtk_dev, SAP_RGU_INT);
+	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_CLR_0);
+	atomic_set(&mtk_dev->md_pm_state, MTK_PM_RESUMED);
+
+	return ret;
+}
+
+static int mtk_pci_pm_resume_noirq(struct device *dev)
+{
+	struct mtk_pci_dev *mtk_dev;
+	struct pci_dev *pdev;
+	void __iomem *pbase;
+
+	pdev = to_pci_dev(dev);
+	mtk_dev = pci_get_drvdata(pdev);
+	pbase = IREG_BASE(mtk_dev);
+
+	/* disable interrupt first and let the IPs enable them */
+	iowrite32(MSIX_MSK_SET_ALL, pbase + IMASK_HOST_MSIX_CLR_GRP0_0);
+
+	return 0;
+}
+
+static void mtk_pci_shutdown(struct pci_dev *pdev)
+{
+	__mtk_pci_pm_suspend(pdev);
+}
+
+static int mtk_pci_pm_suspend(struct device *dev)
+{
+	return __mtk_pci_pm_suspend(to_pci_dev(dev));
+}
+
+static int mtk_pci_pm_resume(struct device *dev)
+{
+	return __mtk_pci_pm_resume(to_pci_dev(dev), true);
+}
+
+static int mtk_pci_pm_thaw(struct device *dev)
+{
+	return __mtk_pci_pm_resume(to_pci_dev(dev), false);
+}
+
+static const struct dev_pm_ops mtk_pci_pm_ops = {
+	.suspend = mtk_pci_pm_suspend,
+	.resume = mtk_pci_pm_resume,
+	.resume_noirq = mtk_pci_pm_resume_noirq,
+	.freeze = mtk_pci_pm_suspend,
+	.thaw = mtk_pci_pm_thaw,
+	.poweroff = mtk_pci_pm_suspend,
+	.restore = mtk_pci_pm_resume,
+	.restore_noirq = mtk_pci_pm_resume_noirq,
+};
+
 static int mtk_request_irq(struct pci_dev *pdev)
 {
 	struct mtk_pci_dev *mtk_dev;
@@ -155,6 +584,10 @@ static int mtk_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		return ret;
 
+	ret = mtk_pci_pm_init(mtk_dev);
+	if (ret)
+		goto err;
+
 	mtk_pcie_mac_atr_init(mtk_dev);
 	mtk_pci_infracfg_ao_calc(mtk_dev);
 	mhccif_init(mtk_dev);
@@ -209,6 +642,8 @@ static struct pci_driver mtk_pci_driver = {
 	.id_table = t7xx_pci_table,
 	.probe = mtk_pci_probe,
 	.remove = mtk_pci_remove,
+	.driver.pm = &mtk_pci_pm_ops,
+	.shutdown = mtk_pci_shutdown,
 };
 
 static int __init mtk_pci_init(void)
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.h b/drivers/net/wwan/t7xx/t7xx_pci.h
index fc27c8c9bf12..57c58d47c031 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.h
+++ b/drivers/net/wwan/t7xx/t7xx_pci.h
@@ -7,6 +7,8 @@
 #ifndef __T7XX_PCI_H__
 #define __T7XX_PCI_H__
 
+#include <linux/completion.h>
+#include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/types.h>
 
@@ -38,6 +40,10 @@ typedef irqreturn_t (*mtk_intr_callback)(int irq, void *param);
  * @pdev: pci device
  * @base_addr: memory base addresses of HW components
  * @md: modem interface
+ * @md_pm_entities: list of pm entities
+ * @md_pm_entity_mtx: protects md_pm_entities list
+ * @pm_sr_ack: ack from the device when went to sleep or woke up
+ * @md_pm_state: state for resume/suspend
  * @ccmni_ctlb: context structure used to control the network data path
  * @rgu_pci_irq_en: RGU callback isr registered and active
  * @pools: pre allocated skb pools
@@ -51,9 +57,48 @@ struct mtk_pci_dev {
 	struct mtk_addr_base	base_addr;
 	struct mtk_modem	*md;
 
+	/* Low Power Items */
+	struct list_head	md_pm_entities;
+	struct mutex		md_pm_entity_mtx;	/* protects md_pm_entities list */
+	struct completion	pm_sr_ack;
+	atomic_t		md_pm_state;
+
 	struct ccmni_ctl_block	*ccmni_ctlb;
 	bool			rgu_pci_irq_en;
 	struct skb_pools	pools;
 };
 
+enum mtk_pm_id {
+	PM_ENTITY_ID_CTRL1,
+	PM_ENTITY_ID_CTRL2,
+	PM_ENTITY_ID_DATA,
+};
+
+/* struct md_pm_entity - device power management entity
+ * @entity: list of PM Entities
+ * @suspend: callback invoked before sending D3 request to device
+ * @suspend_late: callback invoked after getting D3 ACK from device
+ * @resume_early: callback invoked before sending the resume request to device
+ * @resume: callback invoked after getting resume ACK from device
+ * @id: unique PM entity identifier
+ * @entity_param: parameter passed to the registered callbacks
+ *
+ *  This structure is used to indicate PM operations required by internal
+ *  HW modules such as CLDMA and DPMA.
+ */
+struct md_pm_entity {
+	struct list_head	entity;
+	int (*suspend)(struct mtk_pci_dev *mtk_dev, void *entity_param);
+	void (*suspend_late)(struct mtk_pci_dev *mtk_dev, void *entity_param);
+	void (*resume_early)(struct mtk_pci_dev *mtk_dev, void *entity_param);
+	int (*resume)(struct mtk_pci_dev *mtk_dev, void *entity_param);
+	enum mtk_pm_id		id;
+	void			*entity_param;
+};
+
+int mtk_pci_pm_entity_register(struct mtk_pci_dev *mtk_dev, struct md_pm_entity *pm_entity);
+int mtk_pci_pm_entity_unregister(struct mtk_pci_dev *mtk_dev, struct md_pm_entity *pm_entity);
+void mtk_pci_pm_init_late(struct mtk_pci_dev *mtk_dev);
+void mtk_pci_pm_exp_detected(struct mtk_pci_dev *mtk_dev);
+
 #endif /* __T7XX_PCI_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
index 9c9dd3c03678..e386e2bddd31 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
@@ -166,6 +166,7 @@ static void fsm_routine_exception(struct ccci_fsm_ctl *ctl, struct ccci_fsm_comm
 
 	case EXCEPTION_EVENT:
 		fsm_broadcast_state(ctl, MD_STATE_EXCEPTION);
+		mtk_pci_pm_exp_detected(ctl->md->mtk_dev);
 		mtk_md_exception_handshake(ctl->md);
 		cnt = 0;
 		while (cnt < MD_EX_REC_OK_TIMEOUT_MS / EVENT_POLL_INTERVAL_MS) {
@@ -332,6 +333,7 @@ static void fsm_routine_starting(struct ccci_fsm_ctl *ctl)
 
 		fsm_routine_exception(ctl, NULL, EXCEPTION_HS_TIMEOUT);
 	} else {
+		mtk_pci_pm_init_late(md->mtk_dev);
 		fsm_routine_ready(ctl);
 	}
 }
-- 
2.17.1

