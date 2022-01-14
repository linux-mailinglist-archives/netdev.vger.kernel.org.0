Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB1948E1F0
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 02:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238622AbiANBG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 20:06:57 -0500
Received: from mga04.intel.com ([192.55.52.120]:27440 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238608AbiANBGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 20:06:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642122415; x=1673658415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=giGY56eQUmlMPdyOGmzJ8PpGpOXf12ACaM3C1XUPFnU=;
  b=fsz+BnPVtHVs2Wr8wAs6XRAlW6gFiDVFwQ4m4/eGv1YYQcpT/aoMCDWV
   zQw7R8hTuyEmM8YalJSqoO9CeYftYDM57hG9ZukrPqiKxf7vCndHDo4b4
   xmUxQy6VP1emc0FJpHbLwBcQ4nKFvtWAN4NnZxf5LeGucFq2MyaJL2uXV
   Q6F4GFO/sbkCEAwsFNxHuXdcwUuvtIj6O4qPlal7fGBrBrqBZyjXLsYHn
   7SCQFjquTKSNsDQcQLl+lfBLiPgjMhk24kDgUeLTMRgKxlGDBhLUBHKuy
   HQtBt5iJeA4feZQFE0m7HVELjp7HXwNScBdXcTgvKOf+fK6uvGtHCWojU
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="242970850"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="242970850"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:54 -0800
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="692014188"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:52 -0800
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
Subject: [PATCH net-next v4 02/13] net: wwan: t7xx: Add control DMA interface
Date:   Thu, 13 Jan 2022 18:06:16 -0700
Message-Id: <20220114010627.21104-3-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haijun Liu <haijun.liu@mediatek.com>

Cross Layer DMA (CLDMA) Hardware interface (HIF) enables the control
path of Host-Modem data transfers. CLDMA HIF layer provides a common
interface to the Port Layer.

CLDMA manages 8 independent RX/TX physical channels with data flow
control in HW queues. CLDMA uses ring buffers of General Packet
Descriptors (GPD) for TX/RX. GPDs can represent multiple or single
data buffers (DB).

CLDMA HIF initializes GPD rings, registers ISR handlers for CLDMA
interrupts, and initializes CLDMA HW registers.

CLDMA TX flow:
1. Port Layer write
2. Get DB address
3. Configure GPD
4. Triggering processing via HW register write

CLDMA RX flow:
1. CLDMA HW sends a RX "done" to host
2. Driver starts thread to safely read GPD
3. DB is sent to Port layer
4. Create a new buffer for GPD ring

Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/t7xx_cldma.c     |  282 ++++++
 drivers/net/wwan/t7xx/t7xx_cldma.h     |  177 ++++
 drivers/net/wwan/t7xx/t7xx_common.h    |   95 ++
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c | 1296 ++++++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_cldma.h |  138 +++
 5 files changed, 1988 insertions(+)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_cldma.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_cldma.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_common.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_cldma.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_cldma.h

diff --git a/drivers/net/wwan/t7xx/t7xx_cldma.c b/drivers/net/wwan/t7xx/t7xx_cldma.c
new file mode 100644
index 000000000000..e560f6ed454c
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_cldma.c
@@ -0,0 +1,282 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#include <linux/bits.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/types.h>
+
+#include "t7xx_common.h"
+#include "t7xx_cldma.h"
+
+#define ADDR_SIZE	8
+
+void t7xx_cldma_clear_ip_busy(struct t7xx_cldma_hw *hw_info)
+{
+	u32 val;
+
+	val = ioread32(hw_info->ap_pdn_base + REG_CLDMA_IP_BUSY);
+	val |= IP_BUSY_WAKEUP;
+	iowrite32(val, hw_info->ap_pdn_base + REG_CLDMA_IP_BUSY);
+}
+
+/**
+ * t7xx_cldma_hw_restore() - Restore CLDMA HW registers.
+ * @hw_info: Pointer to struct t7xx_cldma_hw.
+ *
+ * Restore HW after resume. Writes uplink configuration for CLDMA HW.
+ */
+void t7xx_cldma_hw_restore(struct t7xx_cldma_hw *hw_info)
+{
+	u32 ul_cfg;
+
+	ul_cfg = ioread32(hw_info->ap_pdn_base + REG_CLDMA_UL_CFG);
+	ul_cfg &= ~UL_CFG_BIT_MODE_MASK;
+
+	if (hw_info->hw_mode == MODE_BIT_64)
+		ul_cfg |= UL_CFG_BIT_MODE_64;
+	else if (hw_info->hw_mode == MODE_BIT_40)
+		ul_cfg |= UL_CFG_BIT_MODE_40;
+	else if (hw_info->hw_mode == MODE_BIT_36)
+		ul_cfg |= UL_CFG_BIT_MODE_36;
+
+	iowrite32(ul_cfg, hw_info->ap_pdn_base + REG_CLDMA_UL_CFG);
+	/* Disable TX and RX invalid address check */
+	iowrite32(UL_MEM_CHECK_DIS, hw_info->ap_pdn_base + REG_CLDMA_UL_MEM);
+	iowrite32(DL_MEM_CHECK_DIS, hw_info->ap_pdn_base + REG_CLDMA_DL_MEM);
+}
+
+void t7xx_cldma_hw_start_queue(struct t7xx_cldma_hw *hw_info, u8 qno, enum mtk_txrx tx_rx)
+{
+	void __iomem *reg;
+	u32 val;
+
+	reg = tx_rx == MTK_RX ? hw_info->ap_pdn_base + REG_CLDMA_DL_START_CMD :
+				hw_info->ap_pdn_base + REG_CLDMA_UL_START_CMD;
+	val = qno == CLDMA_ALL_Q ? CLDMA_ALL_Q : BIT(qno);
+	iowrite32(val, reg);
+}
+
+void t7xx_cldma_hw_start(struct t7xx_cldma_hw *hw_info)
+{
+	/* Enable the TX & RX interrupts */
+	iowrite32(TXRX_STATUS_BITMASK, hw_info->ap_pdn_base + REG_CLDMA_L2TIMCR0);
+	iowrite32(TXRX_STATUS_BITMASK, hw_info->ap_ao_base + REG_CLDMA_L2RIMCR0);
+	/* Enable the empty queue interrupt */
+	iowrite32(EMPTY_STATUS_BITMASK, hw_info->ap_pdn_base + REG_CLDMA_L2TIMCR0);
+	iowrite32(EMPTY_STATUS_BITMASK, hw_info->ap_ao_base + REG_CLDMA_L2RIMCR0);
+}
+
+void t7xx_cldma_hw_reset(void __iomem *ao_base)
+{
+	u32 val;
+
+	val = ioread32(ao_base + REG_INFRA_RST2_SET);
+	val |= RST2_PMIC_SW_RST_SET;
+	iowrite32(val, ao_base + REG_INFRA_RST2_SET);
+	val = ioread32(ao_base + REG_INFRA_RST4_SET);
+	val |= RST4_CLDMA1_SW_RST_SET;
+	iowrite32(val, ao_base + REG_INFRA_RST4_SET);
+	udelay(1);
+
+	val = ioread32(ao_base + REG_INFRA_RST4_CLR);
+	val |= RST4_CLDMA1_SW_RST_CLR;
+	iowrite32(val, ao_base + REG_INFRA_RST4_CLR);
+	val = ioread32(ao_base + REG_INFRA_RST2_CLR);
+	val |= RST2_PMIC_SW_RST_CLR;
+	iowrite32(val, ao_base + REG_INFRA_RST2_CLR);
+}
+
+bool t7xx_cldma_tx_addr_is_set(struct t7xx_cldma_hw *hw_info, unsigned char qno)
+{
+	u32 offset = REG_CLDMA_UL_START_ADDRL_0 + qno * ADDR_SIZE;
+
+	return !!ioread64(hw_info->ap_pdn_base + offset);
+}
+
+void t7xx_cldma_hw_set_start_addr(struct t7xx_cldma_hw *hw_info, unsigned char qno, u64 address,
+				  enum mtk_txrx tx_rx)
+{
+	u32 offset = qno * ADDR_SIZE;
+	void __iomem *reg;
+
+	reg = tx_rx == MTK_RX ? hw_info->ap_ao_base + REG_CLDMA_DL_START_ADDRL_0 :
+				hw_info->ap_pdn_base + REG_CLDMA_UL_START_ADDRL_0;
+	iowrite64(address, reg + offset);
+}
+
+void t7xx_cldma_hw_resume_queue(struct t7xx_cldma_hw *hw_info, unsigned char qno,
+				enum mtk_txrx tx_rx)
+{
+	void __iomem *base = hw_info->ap_pdn_base;
+
+	if (tx_rx == MTK_RX)
+		iowrite32(BIT(qno), base + REG_CLDMA_DL_RESUME_CMD);
+	else
+		iowrite32(BIT(qno), base + REG_CLDMA_UL_RESUME_CMD);
+}
+
+unsigned int t7xx_cldma_hw_queue_status(struct t7xx_cldma_hw *hw_info, unsigned char qno,
+					enum mtk_txrx tx_rx)
+{
+	void __iomem *reg;
+	u32 mask, val;
+
+	mask = qno == CLDMA_ALL_Q ? CLDMA_ALL_Q : BIT(qno);
+	reg = tx_rx == MTK_RX ? hw_info->ap_ao_base + REG_CLDMA_DL_STATUS :
+				hw_info->ap_pdn_base + REG_CLDMA_UL_STATUS;
+	val = ioread32(reg);
+	return val & mask;
+}
+
+void t7xx_cldma_hw_tx_done(struct t7xx_cldma_hw *hw_info, unsigned int bitmask)
+{
+	unsigned int ch_id;
+
+	ch_id = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2TISAR0);
+	ch_id &= bitmask;
+	/* Clear the ch IDs in the TX interrupt status register */
+	iowrite32(ch_id, hw_info->ap_pdn_base + REG_CLDMA_L2TISAR0);
+	ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2TISAR0);
+}
+
+void t7xx_cldma_hw_rx_done(struct t7xx_cldma_hw *hw_info, unsigned int bitmask)
+{
+	unsigned int ch_id;
+
+	ch_id = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2RISAR0);
+	ch_id &= bitmask;
+	/* Clear the ch IDs in the RX interrupt status register */
+	iowrite32(ch_id, hw_info->ap_pdn_base + REG_CLDMA_L2RISAR0);
+	ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2RISAR0);
+}
+
+unsigned int t7xx_cldma_hw_int_status(struct t7xx_cldma_hw *hw_info, unsigned int bitmask,
+				      enum mtk_txrx tx_rx)
+{
+	void __iomem *reg;
+	u32 val;
+
+	reg = tx_rx == MTK_RX ? hw_info->ap_pdn_base + REG_CLDMA_L2RISAR0 :
+				hw_info->ap_pdn_base + REG_CLDMA_L2TISAR0;
+	val = ioread32(reg);
+	return val & bitmask;
+}
+
+void t7xx_cldma_hw_irq_dis_txrx(struct t7xx_cldma_hw *hw_info, unsigned char qno,
+				enum mtk_txrx tx_rx)
+{
+	void __iomem *reg;
+	u32 val;
+
+	reg = tx_rx == MTK_RX ? hw_info->ap_ao_base + REG_CLDMA_L2RIMSR0 :
+				hw_info->ap_pdn_base + REG_CLDMA_L2TIMSR0;
+	val = qno == CLDMA_ALL_Q ? CLDMA_ALL_Q : BIT(qno);
+	iowrite32(val, reg);
+}
+
+void t7xx_cldma_hw_irq_dis_eq(struct t7xx_cldma_hw *hw_info, unsigned char qno, enum mtk_txrx tx_rx)
+{
+	void __iomem *reg;
+	u32 val;
+
+	reg = tx_rx == MTK_RX ? hw_info->ap_ao_base + REG_CLDMA_L2RIMSR0 :
+				hw_info->ap_pdn_base + REG_CLDMA_L2TIMSR0;
+	val = qno == CLDMA_ALL_Q ? CLDMA_ALL_Q : BIT(qno);
+	iowrite32(val << EQ_STA_BIT_OFFSET, reg);
+}
+
+void t7xx_cldma_hw_irq_en_txrx(struct t7xx_cldma_hw *hw_info, unsigned char qno,
+			       enum mtk_txrx tx_rx)
+{
+	void __iomem *reg;
+	u32 val;
+
+	reg = tx_rx == MTK_RX ? hw_info->ap_ao_base + REG_CLDMA_L2RIMCR0 :
+				hw_info->ap_pdn_base + REG_CLDMA_L2TIMCR0;
+	val = qno == CLDMA_ALL_Q ? CLDMA_ALL_Q : BIT(qno);
+	iowrite32(val, reg);
+}
+
+void t7xx_cldma_hw_irq_en_eq(struct t7xx_cldma_hw *hw_info, unsigned char qno, enum mtk_txrx tx_rx)
+{
+	void __iomem *reg;
+	u32 val;
+
+	reg = tx_rx == MTK_RX ? hw_info->ap_ao_base + REG_CLDMA_L2RIMCR0 :
+				hw_info->ap_pdn_base + REG_CLDMA_L2TIMCR0;
+	val = qno == CLDMA_ALL_Q ? CLDMA_ALL_Q : BIT(qno);
+	iowrite32(val << EQ_STA_BIT_OFFSET, reg);
+}
+
+/**
+ * t7xx_cldma_hw_init() - Initialize CLDMA HW.
+ * @hw_info: Pointer to struct t7xx_cldma_hw.
+ *
+ * Write uplink and downlink configuration to CLDMA HW.
+ */
+void t7xx_cldma_hw_init(struct t7xx_cldma_hw *hw_info)
+{
+	u32 ul_cfg, dl_cfg;
+
+	ul_cfg = ioread32(hw_info->ap_pdn_base + REG_CLDMA_UL_CFG);
+	dl_cfg = ioread32(hw_info->ap_ao_base + REG_CLDMA_DL_CFG);
+	/* Configure the DRAM address mode */
+	ul_cfg &= ~UL_CFG_BIT_MODE_MASK;
+	dl_cfg &= ~DL_CFG_BIT_MODE_MASK;
+
+	if (hw_info->hw_mode == MODE_BIT_64) {
+		ul_cfg |= UL_CFG_BIT_MODE_64;
+		dl_cfg |= DL_CFG_BIT_MODE_64;
+	} else if (hw_info->hw_mode == MODE_BIT_40) {
+		ul_cfg |= UL_CFG_BIT_MODE_40;
+		dl_cfg |= DL_CFG_BIT_MODE_40;
+	} else if (hw_info->hw_mode == MODE_BIT_36) {
+		ul_cfg |= UL_CFG_BIT_MODE_36;
+		dl_cfg |= DL_CFG_BIT_MODE_36;
+	}
+
+	iowrite32(ul_cfg, hw_info->ap_pdn_base + REG_CLDMA_UL_CFG);
+	dl_cfg |= DL_CFG_UP_HW_LAST;
+	iowrite32(dl_cfg, hw_info->ap_ao_base + REG_CLDMA_DL_CFG);
+	iowrite32(0, hw_info->ap_ao_base + REG_CLDMA_INT_MASK);
+	iowrite32(BUSY_MASK_MD, hw_info->ap_ao_base + REG_CLDMA_BUSY_MASK);
+	iowrite32(UL_MEM_CHECK_DIS, hw_info->ap_pdn_base + REG_CLDMA_UL_MEM);
+	iowrite32(DL_MEM_CHECK_DIS, hw_info->ap_pdn_base + REG_CLDMA_DL_MEM);
+}
+
+void t7xx_cldma_hw_stop_queue(struct t7xx_cldma_hw *hw_info, u8 qno, enum mtk_txrx tx_rx)
+{
+	void __iomem *reg;
+	u32 val;
+
+	reg = tx_rx == MTK_RX ? hw_info->ap_pdn_base + REG_CLDMA_DL_STOP_CMD :
+				hw_info->ap_pdn_base + REG_CLDMA_UL_STOP_CMD;
+	val = qno == CLDMA_ALL_Q ? CLDMA_ALL_Q : BIT(qno);
+	iowrite32(val, reg);
+}
+
+void t7xx_cldma_hw_stop(struct t7xx_cldma_hw *hw_info, enum mtk_txrx tx_rx)
+{
+	void __iomem *reg;
+
+	reg = tx_rx == MTK_RX ? hw_info->ap_ao_base + REG_CLDMA_L2RIMSR0 :
+				hw_info->ap_pdn_base + REG_CLDMA_L2TIMSR0;
+	iowrite32(TXRX_STATUS_BITMASK, reg);
+	iowrite32(EMPTY_STATUS_BITMASK, reg);
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_cldma.h b/drivers/net/wwan/t7xx/t7xx_cldma.h
new file mode 100644
index 000000000000..1b5e5bf15a3e
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_cldma.h
@@ -0,0 +1,177 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#ifndef __T7XX_CLDMA_H__
+#define __T7XX_CLDMA_H__
+
+#include <linux/bits.h>
+#include <linux/types.h>
+
+#include "t7xx_common.h"
+
+#define CLDMA_TXQ_NUM			8
+#define CLDMA_RXQ_NUM			8
+#define CLDMA_ALL_Q			GENMASK(7, 0)
+
+/* Interrupt status bits */
+#define EMPTY_STATUS_BITMASK		GENMASK(15, 8)
+#define TXRX_STATUS_BITMASK		GENMASK(7, 0)
+#define EQ_STA_BIT_OFFSET		8
+#define L2_INT_BIT_COUNT		16
+#define EQ_STA_BIT(index)		(BIT((index) + EQ_STA_BIT_OFFSET) & EMPTY_STATUS_BITMASK)
+
+#define TQ_ERR_INT_BITMASK		GENMASK(23, 16)
+#define TQ_ACTIVE_START_ERR_INT_BITMASK	GENMASK(31, 24)
+
+#define RQ_ERR_INT_BITMASK		GENMASK(23, 16)
+#define RQ_ACTIVE_START_ERR_INT_BITMASK	GENMASK(31, 24)
+
+#define CLDMA0_AO_BASE			0x10049000
+#define CLDMA0_PD_BASE			0x1021d000
+#define CLDMA1_AO_BASE			0x1004b000
+#define CLDMA1_PD_BASE			0x1021f000
+
+#define CLDMA_R_AO_BASE			0x10023000
+#define CLDMA_R_PD_BASE			0x1023d000
+
+/* CLDMA TX */
+#define REG_CLDMA_UL_START_ADDRL_0	0x0004
+#define REG_CLDMA_UL_START_ADDRH_0	0x0008
+#define REG_CLDMA_UL_CURRENT_ADDRL_0	0x0044
+#define REG_CLDMA_UL_CURRENT_ADDRH_0	0x0048
+#define REG_CLDMA_UL_STATUS		0x0084
+#define CLDMA_INVALID_STATUS		GENMASK(31, 0)
+#define REG_CLDMA_UL_START_CMD		0x0088
+#define REG_CLDMA_UL_RESUME_CMD		0x008c
+#define REG_CLDMA_UL_STOP_CMD		0x0090
+#define REG_CLDMA_UL_ERROR		0x0094
+#define REG_CLDMA_UL_CFG		0x0098
+#define UL_CFG_BIT_MODE_36		BIT(5)
+#define UL_CFG_BIT_MODE_40		BIT(6)
+#define UL_CFG_BIT_MODE_64		BIT(7)
+#define UL_CFG_BIT_MODE_MASK		GENMASK(7, 5)
+
+#define REG_CLDMA_UL_MEM		0x009c
+#define UL_MEM_CHECK_DIS		BIT(0)
+
+/* CLDMA RX */
+#define REG_CLDMA_DL_START_CMD		0x05bc
+#define REG_CLDMA_DL_RESUME_CMD		0x05c0
+#define REG_CLDMA_DL_STOP_CMD		0x05c4
+#define REG_CLDMA_DL_MEM		0x0508
+#define DL_MEM_CHECK_DIS		BIT(0)
+
+#define REG_CLDMA_DL_CFG		0x0404
+#define DL_CFG_UP_HW_LAST		BIT(2)
+#define DL_CFG_BIT_MODE_36		BIT(10)
+#define DL_CFG_BIT_MODE_40		BIT(11)
+#define DL_CFG_BIT_MODE_64		BIT(12)
+#define DL_CFG_BIT_MODE_MASK		GENMASK(12, 10)
+
+#define REG_CLDMA_DL_START_ADDRL_0	0x0478
+#define REG_CLDMA_DL_START_ADDRH_0	0x047c
+#define REG_CLDMA_DL_CURRENT_ADDRL_0	0x04b8
+#define REG_CLDMA_DL_CURRENT_ADDRH_0	0x04bc
+#define REG_CLDMA_DL_STATUS		0x04f8
+
+/* CLDMA MISC */
+#define REG_CLDMA_L2TISAR0		0x0810
+#define REG_CLDMA_L2TISAR1		0x0814
+#define REG_CLDMA_L2TIMR0		0x0818
+#define REG_CLDMA_L2TIMR1		0x081c
+#define REG_CLDMA_L2TIMCR0		0x0820
+#define REG_CLDMA_L2TIMCR1		0x0824
+#define REG_CLDMA_L2TIMSR0		0x0828
+#define REG_CLDMA_L2TIMSR1		0x082c
+#define REG_CLDMA_L3TISAR0		0x0830
+#define REG_CLDMA_L3TISAR1		0x0834
+#define REG_CLDMA_L2RISAR0		0x0850
+#define REG_CLDMA_L2RISAR1		0x0854
+#define REG_CLDMA_L3RISAR0		0x0870
+#define REG_CLDMA_L3RISAR1		0x0874
+#define REG_CLDMA_IP_BUSY		0x08b4
+#define IP_BUSY_WAKEUP			BIT(0)
+#define CLDMA_L2TISAR0_ALL_INT_MASK	GENMASK(15, 0)
+#define CLDMA_L2RISAR0_ALL_INT_MASK	GENMASK(15, 0)
+
+/* CLDMA MISC */
+#define REG_CLDMA_L2RIMR0		0x0858
+#define REG_CLDMA_L2RIMR1		0x085c
+#define REG_CLDMA_L2RIMCR0		0x0860
+#define REG_CLDMA_L2RIMCR1		0x0864
+#define REG_CLDMA_L2RIMSR0		0x0868
+#define REG_CLDMA_L2RIMSR1		0x086c
+#define REG_CLDMA_BUSY_MASK		0x0954
+#define BUSY_MASK_PCIE			BIT(0)
+#define BUSY_MASK_AP			BIT(1)
+#define BUSY_MASK_MD			BIT(2)
+
+#define REG_CLDMA_INT_MASK		0x0960
+
+/* CLDMA RESET */
+#define REG_INFRA_RST4_SET		0x0730
+#define RST4_CLDMA1_SW_RST_SET		BIT(20)
+
+#define REG_INFRA_RST4_CLR		0x0734
+#define RST4_CLDMA1_SW_RST_CLR		BIT(20)
+
+#define REG_INFRA_RST2_SET		0x0140
+#define RST2_PMIC_SW_RST_SET		BIT(18)
+
+#define REG_INFRA_RST2_CLR		0x0144
+#define RST2_PMIC_SW_RST_CLR		BIT(18)
+
+enum t7xx_hw_mode {
+	MODE_BIT_32,
+	MODE_BIT_36,
+	MODE_BIT_40,
+	MODE_BIT_64,
+};
+
+struct t7xx_cldma_hw {
+	enum t7xx_hw_mode		hw_mode;
+	void __iomem			*ap_ao_base;
+	void __iomem			*ap_pdn_base;
+	u32				phy_interrupt_id;
+};
+
+void t7xx_cldma_hw_irq_dis_txrx(struct t7xx_cldma_hw *hw_info, unsigned char qno,
+				enum mtk_txrx tx_rx);
+void t7xx_cldma_hw_irq_dis_eq(struct t7xx_cldma_hw *hw_info, unsigned char qno,
+			      enum mtk_txrx tx_rx);
+void t7xx_cldma_hw_irq_en_txrx(struct t7xx_cldma_hw *hw_info, unsigned char qno,
+			       enum mtk_txrx tx_rx);
+void t7xx_cldma_hw_irq_en_eq(struct t7xx_cldma_hw *hw_info, unsigned char qno, enum mtk_txrx tx_rx);
+unsigned int t7xx_cldma_hw_queue_status(struct t7xx_cldma_hw *hw_info, unsigned char qno,
+					enum mtk_txrx tx_rx);
+void t7xx_cldma_hw_init(struct t7xx_cldma_hw *hw_info);
+void t7xx_cldma_hw_resume_queue(struct t7xx_cldma_hw *hw_info, unsigned char qno,
+				enum mtk_txrx tx_rx);
+void t7xx_cldma_hw_start(struct t7xx_cldma_hw *hw_info);
+void t7xx_cldma_hw_start_queue(struct t7xx_cldma_hw *hw_info, u8 qno, enum mtk_txrx tx_rx);
+void t7xx_cldma_hw_tx_done(struct t7xx_cldma_hw *hw_info, unsigned int bitmask);
+void t7xx_cldma_hw_rx_done(struct t7xx_cldma_hw *hw_info, unsigned int bitmask);
+void t7xx_cldma_hw_stop_queue(struct t7xx_cldma_hw *hw_info, u8 qno, enum mtk_txrx tx_rx);
+void t7xx_cldma_hw_set_start_addr(struct t7xx_cldma_hw *hw_info,
+				  unsigned char qno, u64 address, enum mtk_txrx tx_rx);
+void t7xx_cldma_hw_reset(void __iomem *ao_base);
+void t7xx_cldma_hw_stop(struct t7xx_cldma_hw *hw_info, enum mtk_txrx tx_rx);
+unsigned int t7xx_cldma_hw_int_status(struct t7xx_cldma_hw *hw_info, unsigned int bitmask,
+				      enum mtk_txrx tx_rx);
+void t7xx_cldma_hw_restore(struct t7xx_cldma_hw *hw_info);
+void t7xx_cldma_clear_ip_busy(struct t7xx_cldma_hw *hw_info);
+bool t7xx_cldma_tx_addr_is_set(struct t7xx_cldma_hw *hw_info, unsigned char qno);
+#endif
diff --git a/drivers/net/wwan/t7xx/t7xx_common.h b/drivers/net/wwan/t7xx/t7xx_common.h
new file mode 100644
index 000000000000..360875a8bd96
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_common.h
@@ -0,0 +1,95 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *
+ * Contributors:
+ *  Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#ifndef __T7XX_COMMON_H__
+#define __T7XX_COMMON_H__
+
+#include <linux/bits.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+
+struct ccci_header {
+	__le32 packet_header;
+	__le32 packet_len;
+	__le32 status;
+	__le32 ex_msg;
+};
+
+enum mtk_txrx {
+	MTK_TX,
+	MTK_RX,
+};
+
+#define TXQ_TYPE_DEFAULT	0
+
+#define CLDMA_NUM 2
+
+#define MTK_SKB_64K		64528		/* 63kB + CCCI header */
+#define MTK_SKB_4K		3584		/* 3.5kB */
+#define NET_RX_BUF		MTK_SKB_4K
+
+#define HDR_FLD_AST		((u32)BIT(31))
+#define HDR_FLD_SEQ		GENMASK(30, 16)
+#define HDR_FLD_CHN		GENMASK(15, 0)
+
+#define CCCI_H_LEN		16
+/* For exception flow use CCCI_H_LEN + reserved space */
+#define CCCI_H_ELEN		128
+
+/* Coupled with HW - indicates if there is data following the CCCI header or not */
+#define CCCI_HEADER_NO_DATA	0xffffffff
+
+/* Control identification numbers for AP<->MD messages  */
+#define CTL_ID_HS1_MSG		0x0
+#define CTL_ID_HS2_MSG		0x1
+#define CTL_ID_HS3_MSG		0x2
+#define CTL_ID_MD_EX		0x4
+#define CTL_ID_DRV_VER_ERROR	0x5
+#define CTL_ID_MD_EX_ACK	0x6
+#define CTL_ID_MD_EX_PASS	0x8
+#define CTL_ID_PORT_ENUM	0x9
+
+/* Modem exception check identification code - "EXCP" */
+#define MD_EX_CHK_ID		0x45584350
+/* Modem exception check acknowledge identification code - "EREC" */
+#define MD_EX_CHK_ACK_ID	0x45524543
+
+enum md_state {
+	MD_STATE_INVALID,		/* No traffic */
+	MD_STATE_GATED,			/* No traffic */
+	MD_STATE_WAITING_FOR_HS1,
+	MD_STATE_WAITING_FOR_HS2,
+	MD_STATE_READY,
+	MD_STATE_EXCEPTION,
+	MD_STATE_RESET,			/* No traffic */
+	MD_STATE_WAITING_TO_STOP,
+	MD_STATE_STOPPED,
+};
+
+#ifdef NET_SKBUFF_DATA_USES_OFFSET
+static inline unsigned int t7xx_skb_data_area_size(struct sk_buff *skb)
+{
+	return skb->head + skb->end - skb->data;
+}
+#else
+static inline unsigned int t7xx_skb_data_area_size(struct sk_buff *skb)
+{
+	return skb->end - skb->data;
+}
+#endif
+
+#endif
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
new file mode 100644
index 000000000000..3b49f7b81b01
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -0,0 +1,1296 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ *
+ * Contributors:
+ *  Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ */
+
+#include <linux/bits.h>
+#include <linux/bitops.h>
+#include <linux/delay.h>
+#include <linux/dev_printk.h>
+#include <linux/device.h>
+#include <linux/dmapool.h>
+#include <linux/dma-mapping.h>
+#include <linux/dma-direction.h>
+#include <linux/gfp.h>
+#include <linux/io.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/iopoll.h>
+#include <linux/irqreturn.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/netdevice.h>
+#include <linux/pci.h>
+#include <linux/sched.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+
+#include "t7xx_cldma.h"
+#include "t7xx_common.h"
+#include "t7xx_hif_cldma.h"
+#include "t7xx_mhccif.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_pci.h"
+#include "t7xx_pcie_mac.h"
+#include "t7xx_reg.h"
+#include "t7xx_state_monitor.h"
+
+#define MAX_TX_BUDGET			16
+#define MAX_RX_BUDGET			16
+
+#define CHECK_Q_STOP_TIMEOUT_US		1000000
+#define CHECK_Q_STOP_STEP_US		10000
+
+static void md_cd_queue_struct_reset(struct cldma_queue *queue, struct cldma_ctrl *md_ctrl,
+				     enum mtk_txrx tx_rx, unsigned char index)
+{
+	queue->dir = tx_rx;
+	queue->index = index;
+	queue->md_ctrl = md_ctrl;
+	queue->tr_ring = NULL;
+	queue->tr_done = NULL;
+	queue->tx_xmit = NULL;
+}
+
+static void md_cd_queue_struct_init(struct cldma_queue *queue, struct cldma_ctrl *md_ctrl,
+				    enum mtk_txrx tx_rx, unsigned char index)
+{
+	md_cd_queue_struct_reset(queue, md_ctrl, tx_rx, index);
+	init_waitqueue_head(&queue->req_wq);
+	spin_lock_init(&queue->ring_lock);
+}
+
+static void t7xx_cldma_tgpd_set_data_ptr(struct cldma_tgpd *tgpd, dma_addr_t data_ptr)
+{
+	tgpd->data_buff_bd_ptr_h = cpu_to_le32(upper_32_bits(data_ptr));
+	tgpd->data_buff_bd_ptr_l = cpu_to_le32(lower_32_bits(data_ptr));
+}
+
+static void t7xx_cldma_tgpd_set_next_ptr(struct cldma_tgpd *tgpd, dma_addr_t next_ptr)
+{
+	tgpd->next_gpd_ptr_h = cpu_to_le32(upper_32_bits(next_ptr));
+	tgpd->next_gpd_ptr_l = cpu_to_le32(lower_32_bits(next_ptr));
+}
+
+static void t7xx_cldma_rgpd_set_data_ptr(struct cldma_rgpd *rgpd, dma_addr_t data_ptr)
+{
+	rgpd->data_buff_bd_ptr_h = cpu_to_le32(upper_32_bits(data_ptr));
+	rgpd->data_buff_bd_ptr_l = cpu_to_le32(lower_32_bits(data_ptr));
+}
+
+static void t7xx_cldma_rgpd_set_next_ptr(struct cldma_rgpd *rgpd, dma_addr_t next_ptr)
+{
+	rgpd->next_gpd_ptr_h = cpu_to_le32(upper_32_bits(next_ptr));
+	rgpd->next_gpd_ptr_l = cpu_to_le32(lower_32_bits(next_ptr));
+}
+
+static int t7xx_cldma_alloc_and_map_skb(struct cldma_ctrl *md_ctrl, struct cldma_request *req,
+					size_t size)
+{
+	req->skb = __dev_alloc_skb(size, GFP_KERNEL);
+	if (!req->skb)
+		return -ENOMEM;
+
+	req->mapped_buff = dma_map_single(md_ctrl->dev, req->skb->data,
+					  t7xx_skb_data_area_size(req->skb), DMA_FROM_DEVICE);
+	if (dma_mapping_error(md_ctrl->dev, req->mapped_buff)) {
+		dev_err(md_ctrl->dev, "DMA mapping failed\n");
+		dev_kfree_skb_any(req->skb);
+		req->skb = NULL;
+		req->mapped_buff = 0;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int t7xx_cldma_gpd_rx_from_q(struct cldma_queue *queue, int budget, bool *over_budget)
+{
+	struct cldma_ctrl *md_ctrl = queue->md_ctrl;
+	unsigned char hwo_polling_count = 0;
+	struct t7xx_cldma_hw *hw_info;
+	bool rx_not_done = true;
+	int count = 0;
+
+	hw_info = &md_ctrl->hw_info;
+
+	do {
+		struct cldma_request *req;
+		struct cldma_rgpd *rgpd;
+		struct sk_buff *skb;
+		int ret;
+
+		req = queue->tr_done;
+		if (!req)
+			return -ENODATA;
+
+		rgpd = req->gpd;
+		if ((rgpd->gpd_flags & GPD_FLAGS_HWO) || !req->skb) {
+			dma_addr_t gpd_addr;
+
+			if (!pci_device_is_present(to_pci_dev(md_ctrl->dev))) {
+				dev_err(md_ctrl->dev, "PCIe Link disconnected\n");
+				return -ENODEV;
+			}
+
+			gpd_addr = ioread64(hw_info->ap_pdn_base + REG_CLDMA_DL_CURRENT_ADDRL_0 +
+					    queue->index * sizeof(u64));
+			if (req->gpd_addr == gpd_addr || hwo_polling_count++ >= 100)
+				return 0;
+
+			udelay(1);
+			continue;
+		}
+
+		hwo_polling_count = 0;
+		skb = req->skb;
+
+		if (req->mapped_buff) {
+			dma_unmap_single(md_ctrl->dev, req->mapped_buff,
+					 t7xx_skb_data_area_size(skb), DMA_FROM_DEVICE);
+			req->mapped_buff = 0;
+		}
+
+		skb->len = 0;
+		skb_reset_tail_pointer(skb);
+		skb_put(skb, le16_to_cpu(rgpd->data_buff_len));
+
+		ret = md_ctrl->recv_skb(queue, skb);
+		if (ret < 0)
+			return ret;
+
+		req->skb = NULL;
+		t7xx_cldma_rgpd_set_data_ptr(rgpd, 0);
+		queue->tr_done = list_next_entry_circular(req, &queue->tr_ring->gpd_ring, entry);
+		req = queue->rx_refill;
+
+		ret = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, queue->tr_ring->pkt_size);
+		if (ret)
+			return ret;
+
+		rgpd = req->gpd;
+		t7xx_cldma_rgpd_set_data_ptr(rgpd, req->mapped_buff);
+		rgpd->data_buff_len = 0;
+		rgpd->gpd_flags = GPD_FLAGS_IOC | GPD_FLAGS_HWO;
+		queue->rx_refill = list_next_entry_circular(req, &queue->tr_ring->gpd_ring, entry);
+		rx_not_done = ++count < budget || !need_resched();
+	} while (rx_not_done);
+
+	*over_budget = true;
+	return 0;
+}
+
+static int t7xx_cldma_gpd_rx_collect(struct cldma_queue *queue, int budget)
+{
+	struct cldma_ctrl *md_ctrl = queue->md_ctrl;
+	bool rx_not_done, over_budget = false;
+	struct t7xx_cldma_hw *hw_info;
+	unsigned int l2_rx_int;
+	unsigned long flags;
+	int ret;
+
+	hw_info = &md_ctrl->hw_info;
+
+	do {
+		rx_not_done = false;
+
+		ret = t7xx_cldma_gpd_rx_from_q(queue, budget, &over_budget);
+		if (ret == -ENODATA)
+			return 0;
+
+		if (ret)
+			return ret;
+
+		spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+		if (md_ctrl->rxq_active & BIT(queue->index)) {
+			if (!t7xx_cldma_hw_queue_status(hw_info, queue->index, MTK_RX))
+				t7xx_cldma_hw_resume_queue(hw_info, queue->index, MTK_RX);
+
+			l2_rx_int = t7xx_cldma_hw_int_status(hw_info, BIT(queue->index), MTK_RX);
+			if (l2_rx_int) {
+				t7xx_cldma_hw_rx_done(hw_info, l2_rx_int);
+
+				if (over_budget) {
+					spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+					return -EAGAIN;
+				}
+
+				rx_not_done = true;
+			}
+		}
+
+		spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+	} while (rx_not_done);
+
+	return 0;
+}
+
+static void t7xx_cldma_rx_done(struct work_struct *work)
+{
+	struct cldma_queue *queue = container_of(work, struct cldma_queue, cldma_work);
+	struct cldma_ctrl *md_ctrl = queue->md_ctrl;
+	int value;
+
+	value = t7xx_cldma_gpd_rx_collect(queue, queue->budget);
+	if (value && md_ctrl->rxq_active & BIT(queue->index)) {
+		queue_work(queue->worker, &queue->cldma_work);
+		return;
+	}
+
+	t7xx_cldma_clear_ip_busy(&md_ctrl->hw_info);
+	t7xx_cldma_hw_irq_en_txrx(&md_ctrl->hw_info, queue->index, MTK_RX);
+	t7xx_cldma_hw_irq_en_eq(&md_ctrl->hw_info, queue->index, MTK_RX);
+}
+
+static int t7xx_cldma_gpd_tx_collect(struct cldma_queue *queue)
+{
+	struct cldma_ctrl *md_ctrl = queue->md_ctrl;
+	unsigned int dma_len, count = 0;
+	struct cldma_request *req;
+	struct cldma_tgpd *tgpd;
+	unsigned long flags;
+	dma_addr_t dma_free;
+	struct sk_buff *skb;
+
+	while (!kthread_should_stop()) {
+		spin_lock_irqsave(&queue->ring_lock, flags);
+		req = queue->tr_done;
+		if (!req) {
+			spin_unlock_irqrestore(&queue->ring_lock, flags);
+			break;
+		}
+
+		tgpd = req->gpd;
+		if ((tgpd->gpd_flags & GPD_FLAGS_HWO) || !req->skb) {
+			spin_unlock_irqrestore(&queue->ring_lock, flags);
+			break;
+		}
+
+		queue->budget++;
+		dma_free = req->mapped_buff;
+		dma_len = le16_to_cpu(tgpd->data_buff_len);
+		skb = req->skb;
+		req->skb = NULL;
+		queue->tr_done = list_next_entry_circular(req, &queue->tr_ring->gpd_ring, entry);
+		spin_unlock_irqrestore(&queue->ring_lock, flags);
+		count++;
+		dma_unmap_single(md_ctrl->dev, dma_free, dma_len, DMA_TO_DEVICE);
+		dev_kfree_skb_any(skb);
+	}
+
+	if (count)
+		wake_up_nr(&queue->req_wq, count);
+
+	return count;
+}
+
+static void t7xx_cldma_txq_empty_hndl(struct cldma_queue *queue)
+{
+	struct cldma_ctrl *md_ctrl = queue->md_ctrl;
+	struct cldma_request *req;
+	struct cldma_tgpd *tgpd;
+	dma_addr_t ul_curr_addr;
+	unsigned long flags;
+	bool pending_gpd;
+
+	if (!(md_ctrl->txq_active & BIT(queue->index)))
+		return;
+
+	spin_lock_irqsave(&queue->ring_lock, flags);
+	req = list_prev_entry_circular(queue->tx_xmit, &queue->tr_ring->gpd_ring, entry);
+	tgpd = req->gpd;
+	pending_gpd = (tgpd->gpd_flags & GPD_FLAGS_HWO) && req->skb;
+	spin_unlock_irqrestore(&queue->ring_lock, flags);
+
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	if (pending_gpd) {
+		struct t7xx_cldma_hw *hw_info = &md_ctrl->hw_info;
+
+		/* Check current processing TGPD, 64-bit address is in a table by Q index */
+		ul_curr_addr = ioread64(hw_info->ap_pdn_base + REG_CLDMA_UL_CURRENT_ADDRL_0 +
+					queue->index * sizeof(u64));
+		if (req->gpd_addr != ul_curr_addr) {
+			spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+			dev_err(md_ctrl->dev, "CLDMA%d queue %d is not empty\n",
+				md_ctrl->hif_id, queue->index);
+			return;
+		}
+
+		t7xx_cldma_hw_resume_queue(hw_info, queue->index, MTK_TX);
+	}
+
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+}
+
+static void t7xx_cldma_tx_done(struct work_struct *work)
+{
+	struct cldma_queue *queue = container_of(work, struct cldma_queue, cldma_work);
+	struct cldma_ctrl *md_ctrl = queue->md_ctrl;
+	struct t7xx_cldma_hw *hw_info;
+	unsigned int l2_tx_int;
+	unsigned long flags;
+
+	hw_info = &md_ctrl->hw_info;
+	t7xx_cldma_gpd_tx_collect(queue);
+	l2_tx_int = t7xx_cldma_hw_int_status(hw_info, BIT(queue->index) | EQ_STA_BIT(queue->index),
+					     MTK_TX);
+	if (l2_tx_int & EQ_STA_BIT(queue->index)) {
+		t7xx_cldma_hw_tx_done(hw_info, EQ_STA_BIT(queue->index));
+		t7xx_cldma_txq_empty_hndl(queue);
+	}
+
+	if (l2_tx_int & BIT(queue->index)) {
+		t7xx_cldma_hw_tx_done(hw_info, BIT(queue->index));
+		queue_work(queue->worker, &queue->cldma_work);
+		return;
+	}
+
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	if (md_ctrl->txq_active & BIT(queue->index)) {
+		t7xx_cldma_clear_ip_busy(hw_info);
+		t7xx_cldma_hw_irq_en_eq(hw_info, queue->index, MTK_TX);
+		t7xx_cldma_hw_irq_en_txrx(hw_info, queue->index, MTK_TX);
+	}
+
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+}
+
+static void t7xx_cldma_ring_free(struct cldma_ctrl *md_ctrl,
+				 struct cldma_ring *ring, enum dma_data_direction tx_rx)
+{
+	struct cldma_request *req_cur, *req_next;
+
+	list_for_each_entry_safe(req_cur, req_next, &ring->gpd_ring, entry) {
+		if (req_cur->mapped_buff && req_cur->skb) {
+			dma_unmap_single(md_ctrl->dev, req_cur->mapped_buff,
+					 t7xx_skb_data_area_size(req_cur->skb), tx_rx);
+			req_cur->mapped_buff = 0;
+		}
+
+		dev_kfree_skb_any(req_cur->skb);
+
+		if (req_cur->gpd)
+			dma_pool_free(md_ctrl->gpd_dmapool, req_cur->gpd, req_cur->gpd_addr);
+
+		list_del(&req_cur->entry);
+		kfree_sensitive(req_cur);
+	}
+}
+
+static struct cldma_request *t7xx_alloc_rx_request(struct cldma_ctrl *md_ctrl, size_t pkt_size)
+{
+	struct cldma_request *req;
+	int val;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return NULL;
+
+	req->gpd = dma_pool_zalloc(md_ctrl->gpd_dmapool, GFP_KERNEL, &req->gpd_addr);
+	if (!req->gpd)
+		goto err_free_req;
+
+	val = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, pkt_size);
+	if (val)
+		goto err_free_pool;
+
+	return req;
+
+err_free_pool:
+	dma_pool_free(md_ctrl->gpd_dmapool, req->gpd, req->gpd_addr);
+
+err_free_req:
+	kfree(req);
+
+	return NULL;
+}
+
+static int t7xx_cldma_rx_ring_init(struct cldma_ctrl *md_ctrl, struct cldma_ring *ring)
+{
+	struct cldma_request *req, *first_req = NULL;
+	struct cldma_rgpd *prev_gpd, *gpd = NULL;
+	int i;
+
+	for (i = 0; i < ring->length; i++) {
+		req = t7xx_alloc_rx_request(md_ctrl, ring->pkt_size);
+		if (!req) {
+			t7xx_cldma_ring_free(md_ctrl, ring, DMA_FROM_DEVICE);
+			return -ENOMEM;
+		}
+
+		gpd = req->gpd;
+		t7xx_cldma_rgpd_set_data_ptr(gpd, req->mapped_buff);
+		gpd->data_allow_len = cpu_to_le16(ring->pkt_size);
+		gpd->gpd_flags = GPD_FLAGS_IOC | GPD_FLAGS_HWO;
+
+		if (i)
+			t7xx_cldma_rgpd_set_next_ptr(prev_gpd, req->gpd_addr);
+		else
+			first_req = req;
+
+		INIT_LIST_HEAD(&req->entry);
+		list_add_tail(&req->entry, &ring->gpd_ring);
+		prev_gpd = gpd;
+	}
+
+	if (first_req)
+		t7xx_cldma_rgpd_set_next_ptr(gpd, first_req->gpd_addr);
+
+	return 0;
+}
+
+static struct cldma_request *t7xx_alloc_tx_request(struct cldma_ctrl *md_ctrl)
+{
+	struct cldma_request *req;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return NULL;
+
+	req->gpd = dma_pool_zalloc(md_ctrl->gpd_dmapool, GFP_KERNEL, &req->gpd_addr);
+	if (!req->gpd) {
+		kfree(req);
+		return NULL;
+	}
+
+	return req;
+}
+
+static int t7xx_cldma_tx_ring_init(struct cldma_ctrl *md_ctrl, struct cldma_ring *ring)
+{
+	struct cldma_request *req, *first_req = NULL;
+	struct cldma_tgpd *tgpd, *prev_gpd;
+	int i;
+
+	for (i = 0; i < ring->length; i++) {
+		req = t7xx_alloc_tx_request(md_ctrl);
+		if (!req) {
+			t7xx_cldma_ring_free(md_ctrl, ring, DMA_TO_DEVICE);
+			return -ENOMEM;
+		}
+
+		tgpd = req->gpd;
+		tgpd->gpd_flags = GPD_FLAGS_IOC;
+
+		if (!first_req)
+			first_req = req;
+		else
+			t7xx_cldma_tgpd_set_next_ptr(prev_gpd, req->gpd_addr);
+
+		INIT_LIST_HEAD(&req->entry);
+		list_add_tail(&req->entry, &ring->gpd_ring);
+		prev_gpd = tgpd;
+	}
+
+	if (first_req)
+		t7xx_cldma_tgpd_set_next_ptr(tgpd, first_req->gpd_addr);
+
+	return 0;
+}
+
+/**
+ * t7xx_cldma_q_reset() - Reset CLDMA request pointers to their initial values.
+ * @queue: Pointer to the queue structure.
+ *
+ */
+static void t7xx_cldma_q_reset(struct cldma_queue *queue)
+{
+	struct cldma_request *req;
+
+	req = list_first_entry(&queue->tr_ring->gpd_ring, struct cldma_request, entry);
+	queue->tr_done = req;
+	queue->budget = queue->tr_ring->length;
+
+	if (queue->dir == MTK_TX)
+		queue->tx_xmit = req;
+	else
+		queue->rx_refill = req;
+}
+
+static void t7xx_cldma_rxq_init(struct cldma_queue *queue)
+{
+	struct cldma_ctrl *md_ctrl = queue->md_ctrl;
+
+	queue->dir = MTK_RX;
+	queue->tr_ring = &md_ctrl->rx_ring[queue->index];
+	t7xx_cldma_q_reset(queue);
+}
+
+static void t7xx_cldma_txq_init(struct cldma_queue *queue)
+{
+	struct cldma_ctrl *md_ctrl = queue->md_ctrl;
+
+	queue->dir = MTK_TX;
+	queue->tr_ring = &md_ctrl->tx_ring[queue->index];
+	t7xx_cldma_q_reset(queue);
+}
+
+static void t7xx_cldma_enable_irq(struct cldma_ctrl *md_ctrl)
+{
+	t7xx_pcie_mac_set_int(md_ctrl->t7xx_dev, md_ctrl->hw_info.phy_interrupt_id);
+}
+
+static void t7xx_cldma_disable_irq(struct cldma_ctrl *md_ctrl)
+{
+	t7xx_pcie_mac_clear_int(md_ctrl->t7xx_dev, md_ctrl->hw_info.phy_interrupt_id);
+}
+
+static void t7xx_cldma_irq_work_cb(struct cldma_ctrl *md_ctrl)
+{
+	u32 l2_tx_int_msk, l2_rx_int_msk, l2_tx_int, l2_rx_int, val;
+	struct t7xx_cldma_hw *hw_info = &md_ctrl->hw_info;
+	int i;
+
+	/* L2 raw interrupt status */
+	l2_tx_int = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2TISAR0);
+	l2_rx_int = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2RISAR0);
+	l2_tx_int_msk = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2TIMR0);
+	l2_rx_int_msk = ioread32(hw_info->ap_ao_base + REG_CLDMA_L2RIMR0);
+	l2_tx_int &= ~l2_tx_int_msk;
+	l2_rx_int &= ~l2_rx_int_msk;
+
+	if (l2_tx_int) {
+		if (l2_tx_int & (TQ_ERR_INT_BITMASK | TQ_ACTIVE_START_ERR_INT_BITMASK)) {
+			/* Read and clear L3 TX interrupt status */
+			val = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L3TISAR0);
+			iowrite32(val, hw_info->ap_pdn_base + REG_CLDMA_L3TISAR0);
+			val = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L3TISAR1);
+			iowrite32(val, hw_info->ap_pdn_base + REG_CLDMA_L3TISAR1);
+		}
+
+		t7xx_cldma_hw_tx_done(hw_info, l2_tx_int);
+		if (l2_tx_int & (TXRX_STATUS_BITMASK | EMPTY_STATUS_BITMASK)) {
+			for_each_set_bit(i, (unsigned long *)&l2_tx_int, L2_INT_BIT_COUNT) {
+				if (i < CLDMA_TXQ_NUM) {
+					t7xx_cldma_hw_irq_dis_eq(hw_info, i, MTK_TX);
+					t7xx_cldma_hw_irq_dis_txrx(hw_info, i, MTK_TX);
+					queue_work(md_ctrl->txq[i].worker,
+						   &md_ctrl->txq[i].cldma_work);
+				} else {
+					t7xx_cldma_txq_empty_hndl(&md_ctrl->txq[i - CLDMA_TXQ_NUM]);
+				}
+			}
+		}
+	}
+
+	if (l2_rx_int) {
+		if (l2_rx_int & (RQ_ERR_INT_BITMASK | RQ_ACTIVE_START_ERR_INT_BITMASK)) {
+			/* Read and clear L3 RX interrupt status */
+			val = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L3RISAR0);
+			iowrite32(val, hw_info->ap_pdn_base + REG_CLDMA_L3RISAR0);
+			val = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L3RISAR1);
+			iowrite32(val, hw_info->ap_pdn_base + REG_CLDMA_L3RISAR1);
+		}
+
+		t7xx_cldma_hw_rx_done(hw_info, l2_rx_int);
+		if (l2_rx_int & (TXRX_STATUS_BITMASK | EMPTY_STATUS_BITMASK)) {
+			l2_rx_int |= l2_rx_int >> CLDMA_RXQ_NUM;
+			for_each_set_bit(i, (unsigned long *)&l2_rx_int, CLDMA_RXQ_NUM) {
+				t7xx_cldma_hw_irq_dis_eq(hw_info, i, MTK_RX);
+				t7xx_cldma_hw_irq_dis_txrx(hw_info, i, MTK_RX);
+				queue_work(md_ctrl->rxq[i].worker, &md_ctrl->rxq[i].cldma_work);
+			}
+		}
+	}
+}
+
+static bool t7xx_cldma_qs_are_active(struct t7xx_cldma_hw *hw_info)
+{
+	unsigned int tx_active;
+	unsigned int rx_active;
+
+	tx_active = t7xx_cldma_hw_queue_status(hw_info, CLDMA_ALL_Q, MTK_TX);
+	rx_active = t7xx_cldma_hw_queue_status(hw_info, CLDMA_ALL_Q, MTK_RX);
+	if (tx_active == CLDMA_INVALID_STATUS || rx_active == CLDMA_INVALID_STATUS)
+		return false;
+
+	return tx_active || rx_active;
+}
+
+/**
+ * t7xx_cldma_stop() - Stop CLDMA.
+ * @md_ctrl: CLDMA context structure.
+ *
+ * Stop TX and RX queues. Disable L1 and L2 interrupts.
+ * Clear status registers.
+ *
+ * Return:
+ * * 0		- Success.
+ * * -ERROR	- Error code from polling cldma_queues_active.
+ */
+int t7xx_cldma_stop(struct cldma_ctrl *md_ctrl)
+{
+	struct t7xx_cldma_hw *hw_info = &md_ctrl->hw_info;
+	bool active;
+	int i, ret;
+
+	md_ctrl->rxq_active = 0;
+	t7xx_cldma_hw_stop_queue(hw_info, CLDMA_ALL_Q, MTK_RX);
+	md_ctrl->txq_active = 0;
+	t7xx_cldma_hw_stop_queue(hw_info, CLDMA_ALL_Q, MTK_TX);
+	md_ctrl->txq_started = 0;
+	t7xx_cldma_disable_irq(md_ctrl);
+	t7xx_cldma_hw_stop(hw_info, MTK_RX);
+	t7xx_cldma_hw_stop(hw_info, MTK_TX);
+	t7xx_cldma_hw_tx_done(hw_info, CLDMA_L2TISAR0_ALL_INT_MASK);
+	t7xx_cldma_hw_rx_done(hw_info, CLDMA_L2RISAR0_ALL_INT_MASK);
+
+	if (md_ctrl->is_late_init) {
+		for (i = 0; i < CLDMA_TXQ_NUM; i++)
+			flush_work(&md_ctrl->txq[i].cldma_work);
+
+		for (i = 0; i < CLDMA_RXQ_NUM; i++)
+			flush_work(&md_ctrl->rxq[i].cldma_work);
+	}
+
+	ret = read_poll_timeout(t7xx_cldma_qs_are_active, active, !active, CHECK_Q_STOP_STEP_US,
+				CHECK_Q_STOP_TIMEOUT_US, true, hw_info);
+	if (ret)
+		dev_err(md_ctrl->dev, "Could not stop CLDMA%d queues", md_ctrl->hif_id);
+
+	return ret;
+}
+
+static void t7xx_cldma_late_release(struct cldma_ctrl *md_ctrl)
+{
+	int i;
+
+	if (!md_ctrl->is_late_init)
+		return;
+
+	for (i = 0; i < CLDMA_TXQ_NUM; i++)
+		t7xx_cldma_ring_free(md_ctrl, &md_ctrl->tx_ring[i], DMA_TO_DEVICE);
+
+	for (i = 0; i < CLDMA_RXQ_NUM; i++)
+		t7xx_cldma_ring_free(md_ctrl, &md_ctrl->rx_ring[i], DMA_FROM_DEVICE);
+
+	dma_pool_destroy(md_ctrl->gpd_dmapool);
+	md_ctrl->gpd_dmapool = NULL;
+	md_ctrl->is_late_init = false;
+}
+
+void t7xx_cldma_reset(struct cldma_ctrl *md_ctrl)
+{
+	struct t7xx_modem *md = md_ctrl->t7xx_dev->md;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	md_ctrl->txq_active = 0;
+	md_ctrl->rxq_active = 0;
+	t7xx_cldma_disable_irq(md_ctrl);
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+	for (i = 0; i < CLDMA_TXQ_NUM; i++) {
+		md_ctrl->txq[i].md = md;
+		cancel_work_sync(&md_ctrl->txq[i].cldma_work);
+		spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+		md_cd_queue_struct_reset(&md_ctrl->txq[i], md_ctrl, MTK_TX, i);
+		spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+	}
+
+	for (i = 0; i < CLDMA_RXQ_NUM; i++) {
+		md_ctrl->rxq[i].md = md;
+		cancel_work_sync(&md_ctrl->rxq[i].cldma_work);
+		spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+		md_cd_queue_struct_reset(&md_ctrl->rxq[i], md_ctrl, MTK_RX, i);
+		spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+	}
+
+	t7xx_cldma_late_release(md_ctrl);
+}
+
+/**
+ * t7xx_cldma_start() - Start CLDMA.
+ * @md_ctrl: CLDMA context structure.
+ *
+ * Set TX/RX start address.
+ * Start all RX queues and enable L2 interrupt.
+ */
+void t7xx_cldma_start(struct cldma_ctrl *md_ctrl)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	if (md_ctrl->is_late_init) {
+		struct t7xx_cldma_hw *hw_info = &md_ctrl->hw_info;
+		int i;
+
+		t7xx_cldma_enable_irq(md_ctrl);
+
+		for (i = 0; i < CLDMA_TXQ_NUM; i++) {
+			if (md_ctrl->txq[i].tr_done)
+				t7xx_cldma_hw_set_start_addr(hw_info, i,
+							     md_ctrl->txq[i].tr_done->gpd_addr,
+							     MTK_TX);
+		}
+
+		for (i = 0; i < CLDMA_RXQ_NUM; i++) {
+			if (md_ctrl->rxq[i].tr_done)
+				t7xx_cldma_hw_set_start_addr(hw_info, i,
+							     md_ctrl->rxq[i].tr_done->gpd_addr,
+							     MTK_RX);
+		}
+
+		/* Enable L2 interrupt */
+		t7xx_cldma_hw_start_queue(hw_info, CLDMA_ALL_Q, MTK_RX);
+		t7xx_cldma_hw_start(hw_info);
+		md_ctrl->txq_started = 0;
+		md_ctrl->txq_active |= TXRX_STATUS_BITMASK;
+		md_ctrl->rxq_active |= TXRX_STATUS_BITMASK;
+	}
+
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+}
+
+static void t7xx_cldma_clear_txq(struct cldma_ctrl *md_ctrl, int qnum)
+{
+	struct cldma_queue *txq = &md_ctrl->txq[qnum];
+	struct cldma_request *req;
+	struct cldma_tgpd *tgpd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&txq->ring_lock, flags);
+	t7xx_cldma_q_reset(txq);
+	list_for_each_entry(req, &txq->tr_ring->gpd_ring, entry) {
+		tgpd = req->gpd;
+		tgpd->gpd_flags &= ~GPD_FLAGS_HWO;
+		t7xx_cldma_tgpd_set_data_ptr(tgpd, 0);
+		tgpd->data_buff_len = 0;
+		dev_kfree_skb_any(req->skb);
+		req->skb = NULL;
+	}
+
+	spin_unlock_irqrestore(&txq->ring_lock, flags);
+}
+
+static int t7xx_cldma_clear_rxq(struct cldma_ctrl *md_ctrl, int qnum)
+{
+	struct cldma_queue *rxq = &md_ctrl->rxq[qnum];
+	struct cldma_request *req;
+	struct cldma_rgpd *rgpd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rxq->ring_lock, flags);
+	t7xx_cldma_q_reset(rxq);
+	list_for_each_entry(req, &rxq->tr_ring->gpd_ring, entry) {
+		rgpd = req->gpd;
+		rgpd->gpd_flags = GPD_FLAGS_IOC | GPD_FLAGS_HWO;
+		rgpd->data_buff_len = 0;
+
+		if (req->skb) {
+			req->skb->len = 0;
+			skb_reset_tail_pointer(req->skb);
+		}
+	}
+
+	spin_unlock_irqrestore(&rxq->ring_lock, flags);
+	list_for_each_entry(req, &rxq->tr_ring->gpd_ring, entry) {
+		int ret;
+
+		if (req->skb)
+			continue;
+
+		ret = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, rxq->tr_ring->pkt_size);
+		if (ret)
+			return ret;
+
+		t7xx_cldma_rgpd_set_data_ptr(req->gpd, req->mapped_buff);
+	}
+
+	return 0;
+}
+
+static void t7xx_cldma_clear_all_qs(struct cldma_ctrl *md_ctrl, enum mtk_txrx tx_rx)
+{
+	int i;
+
+	if (tx_rx == MTK_TX) {
+		for (i = 0; i < CLDMA_TXQ_NUM; i++)
+			t7xx_cldma_clear_txq(md_ctrl, i);
+	} else {
+		for (i = 0; i < CLDMA_RXQ_NUM; i++)
+			t7xx_cldma_clear_rxq(md_ctrl, i);
+	}
+}
+
+static void t7xx_cldma_stop_q(struct cldma_ctrl *md_ctrl, unsigned char qno, enum mtk_txrx tx_rx)
+{
+	struct t7xx_cldma_hw *hw_info = &md_ctrl->hw_info;
+	unsigned long flags;
+
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	if (tx_rx == MTK_RX) {
+		t7xx_cldma_hw_irq_dis_eq(hw_info, qno, MTK_RX);
+		t7xx_cldma_hw_irq_dis_txrx(hw_info, qno, MTK_RX);
+
+		if (qno == CLDMA_ALL_Q)
+			md_ctrl->rxq_active &= ~TXRX_STATUS_BITMASK;
+		else
+			md_ctrl->rxq_active &= ~(TXRX_STATUS_BITMASK & BIT(qno));
+
+		t7xx_cldma_hw_stop_queue(hw_info, qno, MTK_RX);
+	} else if (tx_rx == MTK_TX) {
+		t7xx_cldma_hw_irq_dis_eq(hw_info, qno, MTK_TX);
+		t7xx_cldma_hw_irq_dis_txrx(hw_info, qno, MTK_TX);
+
+		if (qno == CLDMA_ALL_Q)
+			md_ctrl->txq_active &= ~TXRX_STATUS_BITMASK;
+		else
+			md_ctrl->txq_active &= ~(TXRX_STATUS_BITMASK & BIT(qno));
+
+		t7xx_cldma_hw_stop_queue(hw_info, qno, MTK_TX);
+	}
+
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+}
+
+static int t7xx_cldma_gpd_handle_tx_request(struct cldma_queue *queue, struct cldma_request *tx_req,
+					    struct sk_buff *skb)
+{
+	struct cldma_ctrl *md_ctrl = queue->md_ctrl;
+	struct cldma_tgpd *tgpd = tx_req->gpd;
+	unsigned long flags;
+
+	/* Update GPD */
+	tx_req->mapped_buff = dma_map_single(md_ctrl->dev, skb->data, skb->len, DMA_TO_DEVICE);
+
+	if (dma_mapping_error(md_ctrl->dev, tx_req->mapped_buff)) {
+		dev_err(md_ctrl->dev, "DMA mapping failed\n");
+		return -ENOMEM;
+	}
+
+	t7xx_cldma_tgpd_set_data_ptr(tgpd, tx_req->mapped_buff);
+	tgpd->data_buff_len = cpu_to_le16(skb->len);
+
+	/* This lock must cover TGPD setting, as even without a resume operation,
+	 * CLDMA can send next HWO=1 if last TGPD just finished.
+	 */
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	if (md_ctrl->txq_active & BIT(queue->index))
+		tgpd->gpd_flags |= GPD_FLAGS_HWO;
+
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+	tx_req->skb = skb;
+	return 0;
+}
+
+static void t7xx_cldma_hw_start_send(struct cldma_ctrl *md_ctrl, u8 qno)
+{
+	struct t7xx_cldma_hw *hw_info = &md_ctrl->hw_info;
+	struct cldma_request *req;
+
+	/* Check whether the device was powered off (CLDMA start address is not set) */
+	if (!t7xx_cldma_tx_addr_is_set(hw_info, qno)) {
+		t7xx_cldma_hw_init(hw_info);
+		req = list_prev_entry_circular(md_ctrl->txq[qno].tx_xmit,
+					       &md_ctrl->txq[qno].tr_ring->gpd_ring, entry);
+		t7xx_cldma_hw_set_start_addr(hw_info, qno, req->gpd_addr, MTK_TX);
+		md_ctrl->txq_started &= ~BIT(qno);
+	}
+
+	if (!t7xx_cldma_hw_queue_status(hw_info, qno, MTK_TX)) {
+		if (md_ctrl->txq_started & BIT(qno))
+			t7xx_cldma_hw_resume_queue(hw_info, qno, MTK_TX);
+		else
+			t7xx_cldma_hw_start_queue(hw_info, qno, MTK_TX);
+
+		md_ctrl->txq_started |= BIT(qno);
+	}
+}
+
+/**
+ * t7xx_cldma_set_recv_skb() - Set the callback to handle RX packets.
+ * @md_ctrl: CLDMA context structure.
+ * @recv_skb: Receiving skb callback.
+ */
+void t7xx_cldma_set_recv_skb(struct cldma_ctrl *md_ctrl,
+			     int (*recv_skb)(struct cldma_queue *queue, struct sk_buff *skb))
+{
+	md_ctrl->recv_skb = recv_skb;
+}
+
+/**
+ * t7xx_cldma_send_skb() - Send control data to modem.
+ * @md_ctrl: CLDMA context structure.
+ * @qno: Queue number.
+ * @skb: Socket buffer.
+ * @blocking: True for blocking operation.
+ *
+ * Send control packet to modem using a ring buffer.
+ * If blocking is set, it will wait for completion.
+ *
+ * Return:
+ * * 0		- Success.
+ * * -ENOMEM	- Allocation failure.
+ * * -EINVAL	- Invalid queue request.
+ * * -EBUSY	- Resource lock failure.
+ */
+int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct sk_buff *skb, bool blocking)
+{
+	struct cldma_request *tx_req;
+	struct cldma_queue *queue;
+	unsigned long flags;
+	int ret;
+
+	if (qno >= CLDMA_TXQ_NUM)
+		return -EINVAL;
+
+	queue = &md_ctrl->txq[qno];
+
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	if (!(md_ctrl->txq_active & BIT(qno))) {
+		ret = -EBUSY;
+		spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+		goto allow_sleep;
+	}
+
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+
+	do {
+		spin_lock_irqsave(&queue->ring_lock, flags);
+		tx_req = queue->tx_xmit;
+		if (queue->budget > 0 && !tx_req->skb) {
+			struct list_head *gpd_ring = &queue->tr_ring->gpd_ring;
+
+			queue->budget--;
+			t7xx_cldma_gpd_handle_tx_request(queue, tx_req, skb);
+			queue->tx_xmit = list_next_entry_circular(tx_req, gpd_ring, entry);
+			spin_unlock_irqrestore(&queue->ring_lock, flags);
+
+			/* Protect the access to the modem for queues operations (resume/start)
+			 * which access shared locations by all the queues.
+			 * cldma_lock is independent of ring_lock which is per queue.
+			 */
+			spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+			t7xx_cldma_hw_start_send(md_ctrl, qno);
+			spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+			break;
+		}
+
+		spin_unlock_irqrestore(&queue->ring_lock, flags);
+
+		if (!t7xx_cldma_hw_queue_status(&md_ctrl->hw_info, qno, MTK_TX)) {
+			spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+			t7xx_cldma_hw_resume_queue(&md_ctrl->hw_info, qno, MTK_TX);
+			spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+		}
+
+		if (!blocking) {
+			ret = -EBUSY;
+			break;
+		}
+
+		ret = wait_event_interruptible_exclusive(queue->req_wq, queue->budget > 0);
+	} while (!ret);
+
+allow_sleep:
+	return ret;
+}
+
+static int t7xx_cldma_late_init(struct cldma_ctrl *md_ctrl)
+{
+	char dma_pool_name[32];
+	int i, j, ret;
+
+	if (md_ctrl->is_late_init) {
+		dev_err(md_ctrl->dev, "CLDMA late init was already done\n");
+		return -EALREADY;
+	}
+
+	snprintf(dma_pool_name, sizeof(dma_pool_name), "cldma_req_hif%d", md_ctrl->hif_id);
+
+	md_ctrl->gpd_dmapool = dma_pool_create(dma_pool_name, md_ctrl->dev,
+					       sizeof(struct cldma_tgpd), GPD_DMAPOOL_ALIGN, 0);
+	if (!md_ctrl->gpd_dmapool) {
+		dev_err(md_ctrl->dev, "DMA pool alloc fail\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < CLDMA_TXQ_NUM; i++) {
+		INIT_LIST_HEAD(&md_ctrl->tx_ring[i].gpd_ring);
+		md_ctrl->tx_ring[i].length = MAX_TX_BUDGET;
+
+		ret = t7xx_cldma_tx_ring_init(md_ctrl, &md_ctrl->tx_ring[i]);
+		if (ret) {
+			dev_err(md_ctrl->dev, "control TX ring init fail\n");
+			goto err_free_tx_ring;
+		}
+	}
+
+	for (j = 0; j < CLDMA_RXQ_NUM; j++) {
+		INIT_LIST_HEAD(&md_ctrl->rx_ring[j].gpd_ring);
+		md_ctrl->rx_ring[j].length = MAX_RX_BUDGET;
+		md_ctrl->rx_ring[j].pkt_size = MTK_SKB_4K;
+
+		if (j == CLDMA_RXQ_NUM - 1)
+			md_ctrl->rx_ring[j].pkt_size = MTK_SKB_64K;
+
+		ret = t7xx_cldma_rx_ring_init(md_ctrl, &md_ctrl->rx_ring[j]);
+		if (ret) {
+			dev_err(md_ctrl->dev, "Control RX ring init fail\n");
+			goto err_free_rx_ring;
+		}
+	}
+
+	for (i = 0; i < CLDMA_TXQ_NUM; i++)
+		t7xx_cldma_txq_init(&md_ctrl->txq[i]);
+
+	for (j = 0; j < CLDMA_RXQ_NUM; j++)
+		t7xx_cldma_rxq_init(&md_ctrl->rxq[j]);
+
+	md_ctrl->is_late_init = true;
+	return 0;
+
+err_free_rx_ring:
+	while (j--)
+		t7xx_cldma_ring_free(md_ctrl, &md_ctrl->rx_ring[j], DMA_FROM_DEVICE);
+
+err_free_tx_ring:
+	while (i--)
+		t7xx_cldma_ring_free(md_ctrl, &md_ctrl->tx_ring[i], DMA_TO_DEVICE);
+
+	return ret;
+}
+
+static void __iomem *pcie_addr_transfer(void __iomem *addr, u32 addr_trs1, u32 phy_addr)
+{
+	return addr + phy_addr - addr_trs1;
+}
+
+static void t7xx_hw_info_init(struct cldma_ctrl *md_ctrl)
+{
+	struct t7xx_cldma_hw *hw_info;
+	u32 phy_ao_base, phy_pd_base;
+	struct t7xx_addr_base *pbase;
+
+	if (md_ctrl->hif_id != ID_CLDMA1)
+		return;
+
+	phy_ao_base = CLDMA1_AO_BASE;
+	phy_pd_base = CLDMA1_PD_BASE;
+	hw_info = &md_ctrl->hw_info;
+	hw_info->phy_interrupt_id = CLDMA1_INT;
+	hw_info->hw_mode = MODE_BIT_64;
+	pbase = &md_ctrl->t7xx_dev->base_addr;
+	hw_info->ap_ao_base = pcie_addr_transfer(pbase->pcie_ext_reg_base,
+						 pbase->pcie_dev_reg_trsl_addr, phy_ao_base);
+	hw_info->ap_pdn_base = pcie_addr_transfer(pbase->pcie_ext_reg_base,
+						  pbase->pcie_dev_reg_trsl_addr, phy_pd_base);
+}
+
+static int t7xx_cldma_default_recv_skb(struct cldma_queue *queue, struct sk_buff *skb)
+{
+	dev_kfree_skb_any(skb);
+	return 0;
+}
+
+int t7xx_cldma_alloc(enum cldma_id hif_id, struct t7xx_pci_dev *t7xx_dev)
+{
+	struct device *dev = &t7xx_dev->pdev->dev;
+	struct cldma_ctrl *md_ctrl;
+
+	md_ctrl = devm_kzalloc(dev, sizeof(*md_ctrl), GFP_KERNEL);
+	if (!md_ctrl)
+		return -ENOMEM;
+
+	md_ctrl->t7xx_dev = t7xx_dev;
+	md_ctrl->dev = dev;
+	md_ctrl->hif_id = hif_id;
+	md_ctrl->recv_skb = t7xx_cldma_default_recv_skb;
+	t7xx_hw_info_init(md_ctrl);
+	t7xx_dev->md->md_ctrl[hif_id] = md_ctrl;
+	return 0;
+}
+
+/**
+ * t7xx_cldma_exception() - CLDMA exception handler.
+ * @md_ctrl: CLDMA context structure.
+ * @stage: exception stage.
+ *
+ * Part of the modem exception recovery.
+ * Stages are one after the other as describe below:
+ * HIF_EX_INIT:		Disable and clear TXQ.
+ * HIF_EX_CLEARQ_DONE:	Disable RX, flush TX/RX workqueues and clear RX.
+ * HIF_EX_ALLQ_RESET:	HW is back in safe mode for re-initialization and restart.
+ */
+
+/*
+ * Modem Exception Handshake Flow
+ *
+ * Modem HW Exception interrupt received
+ *           (MD_IRQ_CCIF_EX)
+ *                   |
+ *         +---------v--------+
+ *         |   HIF_EX_INIT    | : Disable and clear TXQ
+ *         +------------------+
+ *                   |
+ *         +---------v--------+
+ *         | HIF_EX_INIT_DONE | : Wait for the init to be done
+ *         +------------------+
+ *                   |
+ *         +---------v--------+
+ *         |HIF_EX_CLEARQ_DONE| : Disable and clear RXQ
+ *         +------------------+ : Flush TX/RX workqueues
+ *                   |
+ *         +---------v--------+
+ *         |HIF_EX_ALLQ_RESET | : Restart HW and CLDMA
+ *         +------------------+
+ */
+void t7xx_cldma_exception(struct cldma_ctrl *md_ctrl, enum hif_ex_stage stage)
+{
+	switch (stage) {
+	case HIF_EX_INIT:
+		t7xx_cldma_stop_q(md_ctrl, CLDMA_ALL_Q, MTK_TX);
+		t7xx_cldma_clear_all_qs(md_ctrl, MTK_TX);
+		break;
+
+	case HIF_EX_CLEARQ_DONE:
+		/* We do not want to get CLDMA IRQ when MD is
+		 * resetting CLDMA after it got clearq_ack.
+		 */
+		t7xx_cldma_stop_q(md_ctrl, CLDMA_ALL_Q, MTK_RX);
+		t7xx_cldma_stop(md_ctrl);
+
+		if (md_ctrl->hif_id == ID_CLDMA1)
+			t7xx_cldma_hw_reset(md_ctrl->t7xx_dev->base_addr.infracfg_ao_base);
+
+		t7xx_cldma_clear_all_qs(md_ctrl, MTK_RX);
+		break;
+
+	case HIF_EX_ALLQ_RESET:
+		t7xx_cldma_hw_init(&md_ctrl->hw_info);
+		t7xx_cldma_start(md_ctrl);
+		break;
+
+	default:
+		break;
+	}
+}
+
+void t7xx_cldma_hif_hw_init(struct cldma_ctrl *md_ctrl)
+{
+	struct t7xx_cldma_hw *hw_info = &md_ctrl->hw_info;
+	unsigned long flags;
+
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	t7xx_cldma_hw_stop(hw_info, MTK_TX);
+	t7xx_cldma_hw_stop(hw_info, MTK_RX);
+	t7xx_cldma_hw_rx_done(hw_info, EMPTY_STATUS_BITMASK | TXRX_STATUS_BITMASK);
+	t7xx_cldma_hw_tx_done(hw_info, EMPTY_STATUS_BITMASK | TXRX_STATUS_BITMASK);
+	t7xx_cldma_hw_init(hw_info);
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+}
+
+static irqreturn_t t7xx_cldma_isr_handler(int irq, void *data)
+{
+	struct cldma_ctrl *md_ctrl = data;
+	u32 interrupt;
+
+	interrupt = md_ctrl->hw_info.phy_interrupt_id;
+	t7xx_pcie_mac_clear_int(md_ctrl->t7xx_dev, interrupt);
+	t7xx_cldma_irq_work_cb(md_ctrl);
+	t7xx_pcie_mac_clear_int_status(md_ctrl->t7xx_dev, interrupt);
+	t7xx_pcie_mac_set_int(md_ctrl->t7xx_dev, interrupt);
+	return IRQ_HANDLED;
+}
+
+/**
+ * t7xx_cldma_init() - Initialize CLDMA.
+ * @md: Modem context structure.
+ * @md_ctrl: CLDMA context structure.
+ *
+ * Initialize HIF TX/RX queue structure.
+ * Register CLDMA callback ISR with PCIe driver.
+ *
+ * Return:
+ * * 0		- Success.
+ * * -ERROR	- Error code from failure sub-initializations.
+ */
+int t7xx_cldma_init(struct t7xx_modem *md, struct cldma_ctrl *md_ctrl)
+{
+	struct t7xx_cldma_hw *hw_info = &md_ctrl->hw_info;
+	int i;
+
+	md_ctrl->txq_active = 0;
+	md_ctrl->rxq_active = 0;
+	md_ctrl->is_late_init = false;
+
+	spin_lock_init(&md_ctrl->cldma_lock);
+	for (i = 0; i < CLDMA_TXQ_NUM; i++) {
+		md_cd_queue_struct_init(&md_ctrl->txq[i], md_ctrl, MTK_TX, i);
+		md_ctrl->txq[i].md = md;
+
+		md_ctrl->txq[i].worker =
+			alloc_workqueue("md_hif%d_tx%d_worker",
+					WQ_UNBOUND | WQ_MEM_RECLAIM | (i ? 0 : WQ_HIGHPRI),
+					1, md_ctrl->hif_id, i);
+		if (!md_ctrl->txq[i].worker)
+			return -ENOMEM;
+
+		INIT_WORK(&md_ctrl->txq[i].cldma_work, t7xx_cldma_tx_done);
+	}
+
+	for (i = 0; i < CLDMA_RXQ_NUM; i++) {
+		md_cd_queue_struct_init(&md_ctrl->rxq[i], md_ctrl, MTK_RX, i);
+		md_ctrl->rxq[i].md = md;
+		INIT_WORK(&md_ctrl->rxq[i].cldma_work, t7xx_cldma_rx_done);
+
+		md_ctrl->rxq[i].worker = alloc_workqueue("md_hif%d_rx%d_worker",
+							 WQ_UNBOUND | WQ_MEM_RECLAIM,
+							 1, md_ctrl->hif_id, i);
+		if (!md_ctrl->rxq[i].worker)
+			return -ENOMEM;
+	}
+
+	t7xx_pcie_mac_clear_int(md_ctrl->t7xx_dev, hw_info->phy_interrupt_id);
+	md_ctrl->t7xx_dev->intr_handler[hw_info->phy_interrupt_id] = t7xx_cldma_isr_handler;
+	md_ctrl->t7xx_dev->intr_thread[hw_info->phy_interrupt_id] = NULL;
+	md_ctrl->t7xx_dev->callback_param[hw_info->phy_interrupt_id] = md_ctrl;
+	t7xx_pcie_mac_clear_int_status(md_ctrl->t7xx_dev, hw_info->phy_interrupt_id);
+	return 0;
+}
+
+void t7xx_cldma_switch_cfg(struct cldma_ctrl *md_ctrl)
+{
+	t7xx_cldma_late_release(md_ctrl);
+	t7xx_cldma_late_init(md_ctrl);
+}
+
+void t7xx_cldma_exit(struct cldma_ctrl *md_ctrl)
+{
+	int i;
+
+	t7xx_cldma_stop(md_ctrl);
+	t7xx_cldma_late_release(md_ctrl);
+
+	for (i = 0; i < CLDMA_TXQ_NUM; i++) {
+		if (md_ctrl->txq[i].worker) {
+			destroy_workqueue(md_ctrl->txq[i].worker);
+			md_ctrl->txq[i].worker = NULL;
+		}
+	}
+
+	for (i = 0; i < CLDMA_RXQ_NUM; i++) {
+		if (md_ctrl->rxq[i].worker) {
+			destroy_workqueue(md_ctrl->rxq[i].worker);
+			md_ctrl->rxq[i].worker = NULL;
+		}
+	}
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.h b/drivers/net/wwan/t7xx/t7xx_hif_cldma.h
new file mode 100644
index 000000000000..5f8100c2b9bd
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.h
@@ -0,0 +1,138 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ */
+
+#ifndef __T7XX_HIF_CLDMA_H__
+#define __T7XX_HIF_CLDMA_H__
+
+#include <linux/bits.h>
+#include <linux/device.h>
+#include <linux/dmapool.h>
+#include <linux/pci.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+#include <linux/types.h>
+
+#include "t7xx_cldma.h"
+#include "t7xx_common.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_pci.h"
+
+enum cldma_id {
+	ID_CLDMA0,
+	ID_CLDMA1,
+};
+
+struct cldma_request {
+	void *gpd;		/* Virtual address for CPU */
+	dma_addr_t gpd_addr;	/* Physical address for DMA */
+	struct sk_buff *skb;
+	dma_addr_t mapped_buff;
+	struct list_head entry;
+};
+
+struct cldma_queue;
+struct cldma_ctrl;
+
+struct cldma_ring {
+	struct list_head gpd_ring;	/* Ring of struct cldma_request */
+	int length;			/* Number of struct cldma_request */
+	int pkt_size;
+};
+
+struct cldma_queue {
+	struct t7xx_modem *md;
+	struct cldma_ctrl *md_ctrl;
+	enum mtk_txrx dir;
+	unsigned char index;
+	struct cldma_ring *tr_ring;
+	struct cldma_request *tr_done;
+	struct cldma_request *rx_refill;
+	struct cldma_request *tx_xmit;
+	int budget;			/* Same as ring buffer size by default */
+	spinlock_t ring_lock;
+	wait_queue_head_t req_wq;	/* Only for TX */
+	struct workqueue_struct *worker;
+	struct work_struct cldma_work;
+};
+
+struct cldma_ctrl {
+	enum cldma_id hif_id;
+	struct device *dev;
+	struct t7xx_pci_dev *t7xx_dev;
+	struct cldma_queue txq[CLDMA_TXQ_NUM];
+	struct cldma_queue rxq[CLDMA_RXQ_NUM];
+	unsigned short txq_active;
+	unsigned short rxq_active;
+	unsigned short txq_started;
+	spinlock_t cldma_lock; /* Protects CLDMA structure */
+	/* Assumes T/R GPD/BD/SPD have the same size */
+	struct dma_pool *gpd_dmapool;
+	struct cldma_ring tx_ring[CLDMA_TXQ_NUM];
+	struct cldma_ring rx_ring[CLDMA_RXQ_NUM];
+	struct t7xx_cldma_hw hw_info;
+	bool is_late_init;
+	int (*recv_skb)(struct cldma_queue *queue, struct sk_buff *skb);
+};
+
+#define GPD_FLAGS_HWO		BIT(0)
+#define GPD_FLAGS_BDP		BIT(1)
+#define GPD_FLAGS_BPS		BIT(2)
+#define GPD_FLAGS_IOC		BIT(7)
+#define GPD_DMAPOOL_ALIGN	16
+
+struct cldma_tgpd {
+	u8 gpd_flags;
+	u8 not_used1;
+	u8 not_used2;
+	u8 debug_id;
+	__le32 next_gpd_ptr_h;
+	__le32 next_gpd_ptr_l;
+	__le32 data_buff_bd_ptr_h;
+	__le32 data_buff_bd_ptr_l;
+	__le16 data_buff_len;
+	__le16 not_used3;
+};
+
+struct cldma_rgpd {
+	u8 gpd_flags;
+	u8 not_used1;
+	__le16 data_allow_len;
+	__le32 next_gpd_ptr_h;
+	__le32 next_gpd_ptr_l;
+	__le32 data_buff_bd_ptr_h;
+	__le32 data_buff_bd_ptr_l;
+	__le16 data_buff_len;
+	u8 not_used2;
+	u8 debug_id;
+};
+
+int t7xx_cldma_alloc(enum cldma_id hif_id, struct t7xx_pci_dev *t7xx_dev);
+void t7xx_cldma_hif_hw_init(struct cldma_ctrl *md_ctrl);
+int t7xx_cldma_init(struct t7xx_modem *md, struct cldma_ctrl *md_ctrl);
+void t7xx_cldma_exception(struct cldma_ctrl *md_ctrl, enum hif_ex_stage stage);
+void t7xx_cldma_exit(struct cldma_ctrl *md_ctrl);
+void t7xx_cldma_switch_cfg(struct cldma_ctrl *md_ctrl);
+void t7xx_cldma_start(struct cldma_ctrl *md_ctrl);
+int t7xx_cldma_stop(struct cldma_ctrl *md_ctrl);
+void t7xx_cldma_reset(struct cldma_ctrl *md_ctrl);
+void t7xx_cldma_set_recv_skb(struct cldma_ctrl *md_ctrl,
+			     int (*recv_skb)(struct cldma_queue *queue, struct sk_buff *skb));
+int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct sk_buff *skb, bool blocking);
+
+#endif /* __T7XX_HIF_CLDMA_H__ */
-- 
2.17.1

