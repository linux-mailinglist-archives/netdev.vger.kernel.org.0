Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5301436C0F
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 22:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhJUUbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 16:31:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:57398 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231666AbhJUUbI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 16:31:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="292598284"
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="292598284"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:22 -0700
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="527625048"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:21 -0700
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH 02/14] net: wwan: t7xx: Add control DMA interface
Date:   Thu, 21 Oct 2021 13:27:26 -0700
Message-Id: <20211021202738.729-3-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Signed-off-by: Haijun Lio <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/t7xx_cldma.c     |  270 +++++
 drivers/net/wwan/t7xx/t7xx_cldma.h     |  162 +++
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c | 1509 ++++++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_cldma.h |  147 +++
 4 files changed, 2088 insertions(+)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_cldma.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_cldma.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_cldma.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_cldma.h

diff --git a/drivers/net/wwan/t7xx/t7xx_cldma.c b/drivers/net/wwan/t7xx/t7xx_cldma.c
new file mode 100644
index 000000000000..3988d1b8205e
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_cldma.c
@@ -0,0 +1,270 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+
+#include "t7xx_cldma.h"
+
+void cldma_clear_ip_busy(struct cldma_hw_info *hw_info)
+{
+	/* write 1 to clear IP busy register wake up CPU case */
+	iowrite32(ioread32(hw_info->ap_pdn_base + REG_CLDMA_IP_BUSY) | IP_BUSY_WAKEUP,
+		  hw_info->ap_pdn_base + REG_CLDMA_IP_BUSY);
+}
+
+/**
+ * cldma_hw_restore() - Restore CLDMA HW registers
+ * @hw_info: Pointer to struct cldma_hw_info
+ *
+ * Restore HW after resume. Writes uplink configuration for CLDMA HW.
+ *
+ */
+void cldma_hw_restore(struct cldma_hw_info *hw_info)
+{
+	u32 ul_cfg;
+
+	ul_cfg = ioread32(hw_info->ap_pdn_base + REG_CLDMA_UL_CFG);
+	ul_cfg &= ~UL_CFG_BIT_MODE_MASK;
+	if (hw_info->hw_mode == MODE_BIT_64)
+		ul_cfg |= UL_CFG_BIT_MODE_64;
+	else if (hw_info->hw_mode == MODE_BIT_40)
+		ul_cfg |= UL_CFG_BIT_MODE_40;
+	else if (hw_info->hw_mode == MODE_BIT_36)
+		ul_cfg |= UL_CFG_BIT_MODE_36;
+
+	iowrite32(ul_cfg, hw_info->ap_pdn_base + REG_CLDMA_UL_CFG);
+	/* disable TX and RX invalid address check */
+	iowrite32(UL_MEM_CHECK_DIS, hw_info->ap_pdn_base + REG_CLDMA_UL_MEM);
+	iowrite32(DL_MEM_CHECK_DIS, hw_info->ap_pdn_base + REG_CLDMA_DL_MEM);
+}
+
+void cldma_hw_start_queue(struct cldma_hw_info *hw_info, u8 qno, bool is_rx)
+{
+	void __iomem *reg_start_cmd;
+	u32 val;
+
+	mb(); /* prevents outstanding GPD updates */
+	reg_start_cmd = is_rx ? hw_info->ap_pdn_base + REG_CLDMA_DL_START_CMD :
+				hw_info->ap_pdn_base + REG_CLDMA_UL_START_CMD;
+
+	val = (qno == CLDMA_ALL_Q) ? CLDMA_ALL_Q : BIT(qno);
+	iowrite32(val, reg_start_cmd);
+}
+
+void cldma_hw_start(struct cldma_hw_info *hw_info)
+{
+	/* unmask txrx interrupt */
+	iowrite32(TXRX_STATUS_BITMASK, hw_info->ap_pdn_base + REG_CLDMA_L2TIMCR0);
+	iowrite32(TXRX_STATUS_BITMASK, hw_info->ap_ao_base + REG_CLDMA_L2RIMCR0);
+	/* unmask empty queue interrupt */
+	iowrite32(EMPTY_STATUS_BITMASK, hw_info->ap_pdn_base + REG_CLDMA_L2TIMCR0);
+	iowrite32(EMPTY_STATUS_BITMASK, hw_info->ap_ao_base + REG_CLDMA_L2RIMCR0);
+}
+
+void cldma_hw_reset(void __iomem *ao_base)
+{
+	iowrite32(ioread32(ao_base + REG_INFRA_RST4_SET) | RST4_CLDMA1_SW_RST_SET,
+		  ao_base + REG_INFRA_RST4_SET);
+	iowrite32(ioread32(ao_base + REG_INFRA_RST2_SET) | RST2_CLDMA1_AO_SW_RST_SET,
+		  ao_base + REG_INFRA_RST2_SET);
+	udelay(1);
+	iowrite32(ioread32(ao_base + REG_INFRA_RST4_CLR) | RST4_CLDMA1_SW_RST_CLR,
+		  ao_base + REG_INFRA_RST4_CLR);
+	iowrite32(ioread32(ao_base + REG_INFRA_RST2_CLR) | RST2_CLDMA1_AO_SW_RST_CLR,
+		  ao_base + REG_INFRA_RST2_CLR);
+}
+
+bool cldma_tx_addr_is_set(struct cldma_hw_info *hw_info, unsigned char qno)
+{
+	return !!ioread64(hw_info->ap_pdn_base + REG_CLDMA_UL_START_ADDRL_0 + qno * 8);
+}
+
+void cldma_hw_set_start_address(struct cldma_hw_info *hw_info, unsigned char qno, u64 address,
+				bool is_rx)
+{
+	void __iomem *base;
+
+	if (is_rx) {
+		base = hw_info->ap_ao_base;
+		iowrite64(address, base + REG_CLDMA_DL_START_ADDRL_0 + qno * 8);
+	} else {
+		base = hw_info->ap_pdn_base;
+		iowrite64(address, base + REG_CLDMA_UL_START_ADDRL_0 + qno * 8);
+	}
+}
+
+void cldma_hw_resume_queue(struct cldma_hw_info *hw_info, unsigned char qno, bool is_rx)
+{
+	void __iomem *base;
+
+	base = hw_info->ap_pdn_base;
+	mb(); /* prevents outstanding GPD updates */
+
+	if (is_rx)
+		iowrite32(BIT(qno), base + REG_CLDMA_DL_RESUME_CMD);
+	else
+		iowrite32(BIT(qno), base + REG_CLDMA_UL_RESUME_CMD);
+}
+
+unsigned int cldma_hw_queue_status(struct cldma_hw_info *hw_info, unsigned char qno, bool is_rx)
+{
+	u32 mask;
+
+	mask = (qno == CLDMA_ALL_Q) ? CLDMA_ALL_Q : BIT(qno);
+	if (is_rx)
+		return ioread32(hw_info->ap_ao_base + REG_CLDMA_DL_STATUS) & mask;
+	else
+		return ioread32(hw_info->ap_pdn_base + REG_CLDMA_UL_STATUS) & mask;
+}
+
+void cldma_hw_tx_done(struct cldma_hw_info *hw_info, unsigned int bitmask)
+{
+	unsigned int ch_id;
+
+	ch_id = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2TISAR0) & bitmask;
+	/* ack interrupt */
+	iowrite32(ch_id, hw_info->ap_pdn_base + REG_CLDMA_L2TISAR0);
+	ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2TISAR0);
+}
+
+void cldma_hw_rx_done(struct cldma_hw_info *hw_info, unsigned int bitmask)
+{
+	unsigned int ch_id;
+
+	ch_id = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2RISAR0) & bitmask;
+	/* ack interrupt */
+	iowrite32(ch_id, hw_info->ap_pdn_base + REG_CLDMA_L2RISAR0);
+	ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2RISAR0);
+}
+
+unsigned int cldma_hw_int_status(struct cldma_hw_info *hw_info, unsigned int bitmask, bool is_rx)
+{
+	void __iomem *reg_int_sta;
+
+	reg_int_sta = is_rx ? hw_info->ap_pdn_base + REG_CLDMA_L2RISAR0 :
+			      hw_info->ap_pdn_base + REG_CLDMA_L2TISAR0;
+
+	return ioread32(reg_int_sta) & bitmask;
+}
+
+void cldma_hw_mask_txrxirq(struct cldma_hw_info *hw_info, unsigned char qno, bool is_rx)
+{
+	void __iomem *reg_ims;
+	u32 val;
+
+	/* select the right interrupt mask set register */
+	reg_ims = is_rx ? hw_info->ap_ao_base + REG_CLDMA_L2RIMSR0 :
+			  hw_info->ap_pdn_base + REG_CLDMA_L2TIMSR0;
+
+	val = (qno == CLDMA_ALL_Q) ? CLDMA_ALL_Q : BIT(qno);
+	iowrite32(val, reg_ims);
+}
+
+void cldma_hw_mask_eqirq(struct cldma_hw_info *hw_info, unsigned char qno, bool is_rx)
+{
+	void __iomem *reg_ims;
+	u32 val;
+
+	/* select the right interrupt mask set register */
+	reg_ims = is_rx ? hw_info->ap_ao_base + REG_CLDMA_L2RIMSR0 :
+			  hw_info->ap_pdn_base + REG_CLDMA_L2TIMSR0;
+
+	val = (qno == CLDMA_ALL_Q) ? CLDMA_ALL_Q : BIT(qno);
+	iowrite32(val << EQ_STA_BIT_OFFSET, reg_ims);
+}
+
+void cldma_hw_dismask_txrxirq(struct cldma_hw_info *hw_info, unsigned char qno, bool is_rx)
+{
+	void __iomem *reg_imc;
+	u32 val;
+
+	/* select the right interrupt mask clear register */
+	reg_imc = is_rx ? hw_info->ap_ao_base + REG_CLDMA_L2RIMCR0 :
+			  hw_info->ap_pdn_base + REG_CLDMA_L2TIMCR0;
+
+	val = (qno == CLDMA_ALL_Q) ? CLDMA_ALL_Q : BIT(qno);
+	iowrite32(val, reg_imc);
+}
+
+void cldma_hw_dismask_eqirq(struct cldma_hw_info *hw_info, unsigned char qno, bool is_rx)
+{
+	void __iomem *reg_imc;
+	u32 val;
+
+	/* select the right interrupt mask clear register */
+	reg_imc = is_rx ? hw_info->ap_ao_base + REG_CLDMA_L2RIMCR0 :
+			  hw_info->ap_pdn_base + REG_CLDMA_L2TIMCR0;
+
+	val = (qno == CLDMA_ALL_Q) ? CLDMA_ALL_Q : BIT(qno);
+	iowrite32(val << EQ_STA_BIT_OFFSET, reg_imc);
+}
+
+/**
+ * cldma_hw_init() - Initialize CLDMA HW
+ * @hw_info: Pointer to struct cldma_hw_info
+ *
+ * Write uplink and downlink configuration to CLDMA HW.
+ *
+ */
+void cldma_hw_init(struct cldma_hw_info *hw_info)
+{
+	u32 ul_cfg;
+	u32 dl_cfg;
+
+	ul_cfg = ioread32(hw_info->ap_pdn_base + REG_CLDMA_UL_CFG);
+	dl_cfg = ioread32(hw_info->ap_ao_base + REG_CLDMA_DL_CFG);
+
+	/* configure the DRAM address mode */
+	ul_cfg &= ~UL_CFG_BIT_MODE_MASK;
+	dl_cfg &= ~DL_CFG_BIT_MODE_MASK;
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
+	/* enable interrupt */
+	iowrite32(0, hw_info->ap_ao_base + REG_CLDMA_INT_MASK);
+	/* mask wakeup signal */
+	iowrite32(BUSY_MASK_MD, hw_info->ap_ao_base + REG_CLDMA_BUSY_MASK);
+	/* disable TX and RX invalid address check */
+	iowrite32(UL_MEM_CHECK_DIS, hw_info->ap_pdn_base + REG_CLDMA_UL_MEM);
+	iowrite32(DL_MEM_CHECK_DIS, hw_info->ap_pdn_base + REG_CLDMA_DL_MEM);
+}
+
+void cldma_hw_stop_queue(struct cldma_hw_info *hw_info, u8 qno, bool is_rx)
+{
+	void __iomem *reg_stop_cmd;
+	u32 val;
+
+	reg_stop_cmd = is_rx ? hw_info->ap_pdn_base + REG_CLDMA_DL_STOP_CMD :
+			       hw_info->ap_pdn_base + REG_CLDMA_UL_STOP_CMD;
+
+	val = (qno == CLDMA_ALL_Q) ? CLDMA_ALL_Q : BIT(qno);
+	iowrite32(val, reg_stop_cmd);
+}
+
+void cldma_hw_stop(struct cldma_hw_info *hw_info, bool is_rx)
+{
+	void __iomem *reg_ims;
+
+	/* select the right L2 interrupt mask set register */
+	reg_ims = is_rx ? hw_info->ap_ao_base + REG_CLDMA_L2RIMSR0 :
+			  hw_info->ap_pdn_base + REG_CLDMA_L2TIMSR0;
+
+	iowrite32(TXRX_STATUS_BITMASK, reg_ims);
+	iowrite32(EMPTY_STATUS_BITMASK, reg_ims);
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_cldma.h b/drivers/net/wwan/t7xx/t7xx_cldma.h
new file mode 100644
index 000000000000..4a3b66955c33
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_cldma.h
@@ -0,0 +1,162 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_CLDMA_H__
+#define __T7XX_CLDMA_H__
+
+#include <linux/bits.h>
+#include <linux/types.h>
+
+#define CLDMA_TXQ_NUM			8
+#define CLDMA_RXQ_NUM			8
+#define CLDMA_ALL_Q			0xff
+
+/* interrupt status bit meaning, bitmask */
+#define EMPTY_STATUS_BITMASK		0xff00
+#define TXRX_STATUS_BITMASK		0x00ff
+#define EQ_STA_BIT_OFFSET		8
+#define EQ_STA_BIT(index)		(BIT((index) + EQ_STA_BIT_OFFSET) & EMPTY_STATUS_BITMASK)
+
+/* L2RISAR0 */
+#define TQ_ERR_INT_BITMASK		0x00ff0000
+#define TQ_ACTIVE_START_ERR_INT_BITMASK	0xff000000
+
+#define RQ_ERR_INT_BITMASK		0x00ff0000
+#define RQ_ACTIVE_START_ERR_INT_BITMASK	0xff000000
+
+/* HW address @sAP view for reference */
+#define RIGHT_CLDMA_OFFSET		0x1000
+
+#define CLDMA0_AO_BASE			0x10049000
+#define CLDMA0_PD_BASE			0x1021d000
+#define CLDMA1_AO_BASE			0x1004b000
+#define CLDMA1_PD_BASE			0x1021f000
+
+#define CLDMA_R_AO_BASE			0x10023000
+#define CLDMA_R_PD_BASE			0x1023d000
+
+/* CLDMA IN(TX) PD */
+#define REG_CLDMA_UL_START_ADDRL_0	0x0004
+#define REG_CLDMA_UL_START_ADDRH_0	0x0008
+#define REG_CLDMA_UL_CURRENT_ADDRL_0	0x0044
+#define REG_CLDMA_UL_CURRENT_ADDRH_0	0x0048
+#define REG_CLDMA_UL_STATUS		0x0084
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
+/* CLDMA OUT(RX) PD */
+#define REG_CLDMA_DL_START_CMD		0x05bc
+#define REG_CLDMA_DL_RESUME_CMD		0x05c0
+#define REG_CLDMA_DL_STOP_CMD		0x05c4
+#define REG_CLDMA_DL_MEM		0x0508
+#define DL_MEM_CHECK_DIS		BIT(0)
+
+/* CLDMA OUT(RX) AO */
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
+/* CLDMA MISC PD */
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
+/* CLDMA MISC AO */
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
+#define RST2_CLDMA1_AO_SW_RST_SET	BIT(18)
+
+#define REG_INFRA_RST2_CLR		0x0144
+#define RST2_CLDMA1_AO_SW_RST_CLR	BIT(18)
+
+enum hw_mode {
+	MODE_BIT_32,
+	MODE_BIT_36,
+	MODE_BIT_40,
+	MODE_BIT_64,
+};
+
+struct cldma_hw_info {
+	enum hw_mode hw_mode;
+	void __iomem *ap_ao_base;
+	void __iomem *ap_pdn_base;
+	u32 phy_interrupt_id;
+};
+
+void cldma_hw_mask_txrxirq(struct cldma_hw_info *hw_info, unsigned char qno, bool is_rx);
+void cldma_hw_mask_eqirq(struct cldma_hw_info *hw_info, unsigned char qno, bool is_rx);
+void cldma_hw_dismask_txrxirq(struct cldma_hw_info *hw_info, unsigned char qno, bool is_rx);
+void cldma_hw_dismask_eqirq(struct cldma_hw_info *hw_info, unsigned char qno, bool is_rx);
+unsigned int cldma_hw_queue_status(struct cldma_hw_info *hw_info, unsigned char qno, bool is_rx);
+void cldma_hw_init(struct cldma_hw_info *hw_info);
+void cldma_hw_resume_queue(struct cldma_hw_info *hw_info, unsigned char qno, bool is_rx);
+void cldma_hw_start(struct cldma_hw_info *hw_info);
+void cldma_hw_start_queue(struct cldma_hw_info *hw_info, u8 qno, bool is_rx);
+void cldma_hw_tx_done(struct cldma_hw_info *hw_info, unsigned int bitmask);
+void cldma_hw_rx_done(struct cldma_hw_info *hw_info, unsigned int bitmask);
+void cldma_hw_stop_queue(struct cldma_hw_info *hw_info, u8 qno, bool is_rx);
+void cldma_hw_set_start_address(struct cldma_hw_info *hw_info,
+				unsigned char qno, u64 address, bool is_rx);
+void cldma_hw_reset(void __iomem *ao_base);
+void cldma_hw_stop(struct cldma_hw_info *hw_info, bool is_rx);
+unsigned int cldma_hw_int_status(struct cldma_hw_info *hw_info, unsigned int bitmask, bool is_rx);
+void cldma_hw_restore(struct cldma_hw_info *hw_info);
+void cldma_clear_ip_busy(struct cldma_hw_info *hw_info);
+bool cldma_tx_addr_is_set(struct cldma_hw_info *hw_info, unsigned char qno);
+#endif
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
new file mode 100644
index 000000000000..ef1c46c1ac10
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -0,0 +1,1509 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dmapool.h>
+#include <linux/dma-mapping.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/skbuff.h>
+
+#include "t7xx_common.h"
+#include "t7xx_hif_cldma.h"
+#include "t7xx_mhccif.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_monitor.h"
+#include "t7xx_pcie_mac.h"
+#include "t7xx_skb_util.h"
+
+#define MAX_TX_BUDGET			16
+#define MAX_RX_BUDGET			16
+
+#define CHECK_Q_STOP_TIMEOUT_US		1000000
+#define CHECK_Q_STOP_STEP_US		10000
+
+static struct cldma_ctrl *cldma_md_ctrl[CLDMA_NUM];
+
+static DEFINE_MUTEX(ctl_cfg_mutex); /* protects CLDMA late init config */
+
+static enum cldma_queue_type rxq_type[CLDMA_RXQ_NUM];
+static enum cldma_queue_type txq_type[CLDMA_TXQ_NUM];
+static int rxq_buff_size[CLDMA_RXQ_NUM];
+static int rxq_buff_num[CLDMA_RXQ_NUM];
+static int txq_buff_num[CLDMA_TXQ_NUM];
+
+static struct cldma_ctrl *md_cd_get(enum cldma_id hif_id)
+{
+	return cldma_md_ctrl[hif_id];
+}
+
+static inline void md_cd_set(enum cldma_id hif_id, struct cldma_ctrl *md_ctrl)
+{
+	cldma_md_ctrl[hif_id] = md_ctrl;
+}
+
+static inline void md_cd_queue_struct_reset(struct cldma_queue *queue, enum cldma_id hif_id,
+					    enum direction dir, unsigned char index)
+{
+	queue->dir = dir;
+	queue->index = index;
+	queue->hif_id = hif_id;
+	queue->tr_ring = NULL;
+	queue->tr_done = NULL;
+	queue->tx_xmit = NULL;
+}
+
+static inline void md_cd_queue_struct_init(struct cldma_queue *queue, enum cldma_id hif_id,
+					   enum direction dir, unsigned char index)
+{
+	md_cd_queue_struct_reset(queue, hif_id, dir, index);
+	init_waitqueue_head(&queue->req_wq);
+	spin_lock_init(&queue->ring_lock);
+}
+
+static inline void cldma_tgpd_set_data_ptr(struct cldma_tgpd *tgpd, dma_addr_t data_ptr)
+{
+	tgpd->data_buff_bd_ptr_h = upper_32_bits(data_ptr);
+	tgpd->data_buff_bd_ptr_l = lower_32_bits(data_ptr);
+}
+
+static inline void cldma_tgpd_set_next_ptr(struct cldma_tgpd *tgpd, dma_addr_t next_ptr)
+{
+	tgpd->next_gpd_ptr_h = upper_32_bits(next_ptr);
+	tgpd->next_gpd_ptr_l = lower_32_bits(next_ptr);
+}
+
+static inline void cldma_rgpd_set_data_ptr(struct cldma_rgpd *rgpd, dma_addr_t data_ptr)
+{
+	rgpd->data_buff_bd_ptr_h = upper_32_bits(data_ptr);
+	rgpd->data_buff_bd_ptr_l = lower_32_bits(data_ptr);
+}
+
+static inline void cldma_rgpd_set_next_ptr(struct cldma_rgpd *rgpd, dma_addr_t next_ptr)
+{
+	rgpd->next_gpd_ptr_h = upper_32_bits(next_ptr);
+	rgpd->next_gpd_ptr_l = lower_32_bits(next_ptr);
+}
+
+static struct cldma_request *cldma_ring_step_forward(struct cldma_ring *ring,
+						     struct cldma_request *req)
+{
+	struct cldma_request *next_req;
+
+	if (req->entry.next == &ring->gpd_ring)
+		next_req = list_first_entry(&ring->gpd_ring, struct cldma_request, entry);
+	else
+		next_req = list_entry(req->entry.next, struct cldma_request, entry);
+
+	return next_req;
+}
+
+static struct cldma_request *cldma_ring_step_backward(struct cldma_ring *ring,
+						      struct cldma_request *req)
+{
+	struct cldma_request *prev_req;
+
+	if (req->entry.prev == &ring->gpd_ring)
+		prev_req = list_last_entry(&ring->gpd_ring, struct cldma_request, entry);
+	else
+		prev_req = list_entry(req->entry.prev, struct cldma_request, entry);
+
+	return prev_req;
+}
+
+static int cldma_gpd_rx_from_queue(struct cldma_queue *queue, int budget, bool *over_budget)
+{
+	unsigned char hwo_polling_count = 0;
+	struct cldma_hw_info *hw_info;
+	struct cldma_ctrl *md_ctrl;
+	struct cldma_request *req;
+	struct cldma_rgpd *rgpd;
+	struct sk_buff *new_skb;
+	bool rx_done = false;
+	struct sk_buff *skb;
+	int count = 0;
+	int ret = 0;
+
+	md_ctrl = md_cd_get(queue->hif_id);
+	hw_info = &md_ctrl->hw_info;
+
+	while (!rx_done) {
+		req = queue->tr_done;
+		if (!req) {
+			dev_err(md_ctrl->dev, "RXQ was released\n");
+			return -ENODATA;
+		}
+
+		rgpd = req->gpd;
+		if ((rgpd->gpd_flags & GPD_FLAGS_HWO) || !req->skb) {
+			u64 gpd_addr;
+
+			/* current 64 bit address is in a table by Q index */
+			gpd_addr = ioread64(hw_info->ap_pdn_base +
+					    REG_CLDMA_DL_CURRENT_ADDRL_0 +
+					    queue->index * sizeof(u64));
+			if (gpd_addr == GENMASK_ULL(63, 0)) {
+				dev_err(md_ctrl->dev, "PCIe Link disconnected\n");
+				return -ENODATA;
+			}
+
+			if ((u64)queue->tr_done->gpd_addr != gpd_addr &&
+			    hwo_polling_count++ < 100) {
+				udelay(1);
+				continue;
+			}
+
+			break;
+		}
+
+		hwo_polling_count = 0;
+		skb = req->skb;
+
+		if (req->mapped_buff) {
+			dma_unmap_single(md_ctrl->dev, req->mapped_buff,
+					 skb_data_size(skb), DMA_FROM_DEVICE);
+			req->mapped_buff = 0;
+		}
+
+		/* init skb struct */
+		skb->len = 0;
+		skb_reset_tail_pointer(skb);
+		skb_put(skb, rgpd->data_buff_len);
+
+		/* consume skb */
+		if (md_ctrl->recv_skb) {
+			ret = md_ctrl->recv_skb(queue, skb);
+		} else {
+			ccci_free_skb(&md_ctrl->mtk_dev->pools, skb);
+			ret = -ENETDOWN;
+		}
+
+		new_skb = NULL;
+		if (ret >= 0 || ret == -ENETDOWN)
+			new_skb = ccci_alloc_skb_from_pool(&md_ctrl->mtk_dev->pools,
+							   queue->tr_ring->pkt_size,
+							   GFS_BLOCKING);
+
+		if (!new_skb) {
+			/* either the port was busy or the skb pool was empty */
+			usleep_range(5000, 10000);
+			return -EAGAIN;
+		}
+
+		/* mark cldma_request as available */
+		req->skb = NULL;
+		cldma_rgpd_set_data_ptr(rgpd, 0);
+		queue->tr_done = cldma_ring_step_forward(queue->tr_ring, req);
+
+		req = queue->rx_refill;
+		rgpd = req->gpd;
+		req->mapped_buff = dma_map_single(md_ctrl->dev, new_skb->data,
+						  skb_data_size(new_skb), DMA_FROM_DEVICE);
+		if (dma_mapping_error(md_ctrl->dev, req->mapped_buff)) {
+			dev_err(md_ctrl->dev, "DMA mapping failed\n");
+			req->mapped_buff = 0;
+			ccci_free_skb(&md_ctrl->mtk_dev->pools, new_skb);
+			return -ENOMEM;
+		}
+
+		cldma_rgpd_set_data_ptr(rgpd, req->mapped_buff);
+		rgpd->data_buff_len = 0;
+		/* set HWO, no need to hold ring_lock */
+		rgpd->gpd_flags = GPD_FLAGS_IOC | GPD_FLAGS_HWO;
+		/* mark cldma_request as available */
+		req->skb = new_skb;
+		queue->rx_refill = cldma_ring_step_forward(queue->tr_ring, req);
+
+		if (++count >= budget && need_resched()) {
+			*over_budget = true;
+			rx_done = true;
+		}
+	}
+
+	return 0;
+}
+
+static int cldma_gpd_rx_collect(struct cldma_queue *queue, int budget)
+{
+	struct cldma_hw_info *hw_info;
+	struct cldma_ctrl *md_ctrl;
+	bool over_budget = false;
+	bool rx_not_done = true;
+	unsigned int l2_rx_int;
+	unsigned long flags;
+	int ret;
+
+	md_ctrl = md_cd_get(queue->hif_id);
+	hw_info = &md_ctrl->hw_info;
+
+	while (rx_not_done) {
+		rx_not_done = false;
+		ret = cldma_gpd_rx_from_queue(queue, budget, &over_budget);
+		if (ret == -ENODATA)
+			return 0;
+
+		if (ret)
+			return ret;
+
+		spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+		if (md_ctrl->rxq_active & BIT(queue->index)) {
+			/* resume Rx queue */
+			if (!cldma_hw_queue_status(hw_info, queue->index, true))
+				cldma_hw_resume_queue(hw_info, queue->index, true);
+
+			/* greedy mode */
+			l2_rx_int = cldma_hw_int_status(hw_info, BIT(queue->index), true);
+
+			if (l2_rx_int) {
+				/* need be scheduled again, avoid the soft lockup */
+				cldma_hw_rx_done(hw_info, l2_rx_int);
+				if (over_budget) {
+					spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+					return -EAGAIN;
+				}
+
+				/* clear IP busy register wake up CPU case */
+				rx_not_done = true;
+			}
+		}
+
+		spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+	}
+
+	return 0;
+}
+
+static void cldma_rx_done(struct work_struct *work)
+{
+	struct cldma_ctrl *md_ctrl;
+	struct cldma_queue *queue;
+	int value;
+
+	queue = container_of(work, struct cldma_queue, cldma_rx_work);
+	md_ctrl = md_cd_get(queue->hif_id);
+	value = queue->tr_ring->handle_rx_done(queue, queue->budget);
+
+	if (value && md_ctrl->rxq_active & BIT(queue->index)) {
+		queue_work(queue->worker, &queue->cldma_rx_work);
+		return;
+	}
+
+	/* clear IP busy register wake up CPU case */
+	cldma_clear_ip_busy(&md_ctrl->hw_info);
+	/* enable RX_DONE && EMPTY interrupt */
+	cldma_hw_dismask_txrxirq(&md_ctrl->hw_info, queue->index, true);
+	cldma_hw_dismask_eqirq(&md_ctrl->hw_info, queue->index, true);
+}
+
+static int cldma_gpd_tx_collect(struct cldma_queue *queue)
+{
+	struct cldma_ctrl *md_ctrl;
+	struct cldma_request *req;
+	struct sk_buff *skb_free;
+	struct cldma_tgpd *tgpd;
+	unsigned int dma_len;
+	unsigned long flags;
+	dma_addr_t dma_free;
+	int count = 0;
+
+	md_ctrl = md_cd_get(queue->hif_id);
+
+	while (!kthread_should_stop()) {
+		spin_lock_irqsave(&queue->ring_lock, flags);
+		req = queue->tr_done;
+		if (!req) {
+			dev_err(md_ctrl->dev, "TXQ was released\n");
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
+		/* restore IOC setting */
+		if (req->ioc_override & GPD_FLAGS_IOC) {
+			if (req->ioc_override & GPD_FLAGS_HWO)
+				tgpd->gpd_flags |= GPD_FLAGS_IOC;
+			else
+				tgpd->gpd_flags &= ~GPD_FLAGS_IOC;
+			dev_notice(md_ctrl->dev,
+				   "qno%u, req->ioc_override=0x%x,tgpd->gpd_flags=0x%x\n",
+				   queue->index, req->ioc_override, tgpd->gpd_flags);
+		}
+
+		queue->budget++;
+		/* save skb reference */
+		dma_free = req->mapped_buff;
+		dma_len = tgpd->data_buff_len;
+		skb_free = req->skb;
+		/* mark cldma_request as available */
+		req->skb = NULL;
+		queue->tr_done = cldma_ring_step_forward(queue->tr_ring, req);
+		spin_unlock_irqrestore(&queue->ring_lock, flags);
+		count++;
+		dma_unmap_single(md_ctrl->dev, dma_free, dma_len, DMA_TO_DEVICE);
+
+		ccci_free_skb(&md_ctrl->mtk_dev->pools, skb_free);
+	}
+
+	if (count)
+		wake_up_nr(&queue->req_wq, count);
+
+	return count;
+}
+
+static void cldma_tx_queue_empty_handler(struct cldma_queue *queue)
+{
+	struct cldma_hw_info *hw_info;
+	struct cldma_ctrl *md_ctrl;
+	struct cldma_request *req;
+	struct cldma_tgpd *tgpd;
+	dma_addr_t ul_curr_addr;
+	unsigned long flags;
+	bool pending_gpd;
+
+	md_ctrl = md_cd_get(queue->hif_id);
+	hw_info = &md_ctrl->hw_info;
+	if (!(md_ctrl->txq_active & BIT(queue->index)))
+		return;
+
+	/* check if there is any pending TGPD with HWO=1 */
+	spin_lock_irqsave(&queue->ring_lock, flags);
+	req = cldma_ring_step_backward(queue->tr_ring, queue->tx_xmit);
+	tgpd = req->gpd;
+	pending_gpd = (tgpd->gpd_flags & GPD_FLAGS_HWO) && req->skb;
+
+	spin_unlock_irqrestore(&queue->ring_lock, flags);
+
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	if (pending_gpd) {
+		/* Check current processing TGPD
+		 * current 64-bit address is in a table by Q index.
+		 */
+		ul_curr_addr = ioread64(hw_info->ap_pdn_base +
+					REG_CLDMA_UL_CURRENT_ADDRL_0 +
+					queue->index * sizeof(u64));
+		if (req->gpd_addr != ul_curr_addr)
+			dev_err(md_ctrl->dev,
+				"CLDMA%d Q%d TGPD addr, SW:%pad, HW:%pad\n", md_ctrl->hif_id,
+				queue->index, &req->gpd_addr, &ul_curr_addr);
+		else
+			/* retry */
+			cldma_hw_resume_queue(&md_ctrl->hw_info, queue->index, false);
+	}
+
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+}
+
+static void cldma_tx_done(struct work_struct *work)
+{
+	struct cldma_hw_info *hw_info;
+	struct cldma_ctrl *md_ctrl;
+	struct cldma_queue *queue;
+	unsigned int l2_tx_int;
+	unsigned long flags;
+
+	queue = container_of(work, struct cldma_queue, cldma_tx_work);
+	md_ctrl = md_cd_get(queue->hif_id);
+	hw_info = &md_ctrl->hw_info;
+	queue->tr_ring->handle_tx_done(queue);
+
+	/* greedy mode */
+	l2_tx_int = cldma_hw_int_status(hw_info, BIT(queue->index) | EQ_STA_BIT(queue->index),
+					false);
+	if (l2_tx_int & EQ_STA_BIT(queue->index)) {
+		cldma_hw_tx_done(hw_info, EQ_STA_BIT(queue->index));
+		cldma_tx_queue_empty_handler(queue);
+	}
+
+	if (l2_tx_int & BIT(queue->index)) {
+		cldma_hw_tx_done(hw_info, BIT(queue->index));
+		queue_work(queue->worker, &queue->cldma_tx_work);
+		return;
+	}
+
+	/* enable TX_DONE interrupt */
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	if (md_ctrl->txq_active & BIT(queue->index)) {
+		cldma_clear_ip_busy(hw_info);
+		cldma_hw_dismask_eqirq(hw_info, queue->index, false);
+		cldma_hw_dismask_txrxirq(hw_info, queue->index, false);
+	}
+
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+}
+
+static void cldma_ring_free(struct cldma_ctrl *md_ctrl,
+			    struct cldma_ring *ring, enum dma_data_direction dir)
+{
+	struct cldma_request *req_cur, *req_next;
+
+	list_for_each_entry_safe(req_cur, req_next, &ring->gpd_ring, entry) {
+		if (req_cur->mapped_buff && req_cur->skb) {
+			dma_unmap_single(md_ctrl->dev, req_cur->mapped_buff,
+					 skb_data_size(req_cur->skb), dir);
+			req_cur->mapped_buff = 0;
+		}
+
+		if (req_cur->skb)
+			ccci_free_skb(&md_ctrl->mtk_dev->pools, req_cur->skb);
+
+		if (req_cur->gpd)
+			dma_pool_free(md_ctrl->gpd_dmapool, req_cur->gpd,
+				      req_cur->gpd_addr);
+
+		list_del(&req_cur->entry);
+		kfree_sensitive(req_cur);
+	}
+}
+
+static struct cldma_request *alloc_rx_request(struct cldma_ctrl *md_ctrl, size_t pkt_size)
+{
+	struct cldma_request *item;
+	unsigned long flags;
+
+	item = kzalloc(sizeof(*item), GFP_KERNEL);
+	if (!item)
+		return NULL;
+
+	item->skb = ccci_alloc_skb_from_pool(&md_ctrl->mtk_dev->pools, pkt_size, GFS_BLOCKING);
+	if (!item->skb)
+		goto err_skb_alloc;
+
+	item->gpd = dma_pool_alloc(md_ctrl->gpd_dmapool, GFP_KERNEL | __GFP_ZERO,
+				   &item->gpd_addr);
+	if (!item->gpd)
+		goto err_gpd_alloc;
+
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	item->mapped_buff = dma_map_single(md_ctrl->dev, item->skb->data,
+					   skb_data_size(item->skb), DMA_FROM_DEVICE);
+	if (dma_mapping_error(md_ctrl->dev, item->mapped_buff)) {
+		dev_err(md_ctrl->dev, "DMA mapping failed\n");
+		item->mapped_buff = 0;
+		spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+		goto err_dma_map;
+	}
+
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+	return item;
+
+err_dma_map:
+	dma_pool_free(md_ctrl->gpd_dmapool, item->gpd, item->gpd_addr);
+err_gpd_alloc:
+	ccci_free_skb(&md_ctrl->mtk_dev->pools, item->skb);
+err_skb_alloc:
+	kfree(item);
+	return NULL;
+}
+
+static int cldma_rx_ring_init(struct cldma_ctrl *md_ctrl, struct cldma_ring *ring)
+{
+	struct cldma_request *item, *first_item = NULL;
+	struct cldma_rgpd *prev_gpd, *gpd = NULL;
+	int i;
+
+	for (i = 0; i < ring->length; i++) {
+		item = alloc_rx_request(md_ctrl, ring->pkt_size);
+		if (!item) {
+			cldma_ring_free(md_ctrl, ring, DMA_FROM_DEVICE);
+			return -ENOMEM;
+		}
+
+		gpd = (struct cldma_rgpd *)item->gpd;
+		cldma_rgpd_set_data_ptr(gpd, item->mapped_buff);
+		gpd->data_allow_len = ring->pkt_size;
+		gpd->gpd_flags = GPD_FLAGS_IOC | GPD_FLAGS_HWO;
+		if (!i)
+			first_item = item;
+		else
+			cldma_rgpd_set_next_ptr(prev_gpd, item->gpd_addr);
+
+		INIT_LIST_HEAD(&item->entry);
+		list_add_tail(&item->entry, &ring->gpd_ring);
+		prev_gpd = gpd;
+	}
+
+	if (first_item)
+		cldma_rgpd_set_next_ptr(gpd, first_item->gpd_addr);
+
+	return 0;
+}
+
+static struct cldma_request *alloc_tx_request(struct cldma_ctrl *md_ctrl)
+{
+	struct cldma_request *item;
+
+	item = kzalloc(sizeof(*item), GFP_KERNEL);
+	if (!item)
+		return NULL;
+
+	item->gpd = dma_pool_alloc(md_ctrl->gpd_dmapool, GFP_KERNEL | __GFP_ZERO,
+				   &item->gpd_addr);
+	if (!item->gpd) {
+		kfree(item);
+		return NULL;
+	}
+
+	return item;
+}
+
+static int cldma_tx_ring_init(struct cldma_ctrl *md_ctrl, struct cldma_ring *ring)
+{
+	struct cldma_request *item, *first_item = NULL;
+	struct cldma_tgpd *tgpd, *prev_gpd;
+	int i;
+
+	for (i = 0; i < ring->length; i++) {
+		item = alloc_tx_request(md_ctrl);
+		if (!item) {
+			cldma_ring_free(md_ctrl, ring, DMA_TO_DEVICE);
+			return -ENOMEM;
+		}
+
+		tgpd = item->gpd;
+		tgpd->gpd_flags = GPD_FLAGS_IOC;
+		if (!first_item)
+			first_item = item;
+		else
+			cldma_tgpd_set_next_ptr(prev_gpd, item->gpd_addr);
+		INIT_LIST_HEAD(&item->bd);
+		INIT_LIST_HEAD(&item->entry);
+		list_add_tail(&item->entry, &ring->gpd_ring);
+		prev_gpd = tgpd;
+	}
+
+	if (first_item)
+		cldma_tgpd_set_next_ptr(tgpd, first_item->gpd_addr);
+
+	return 0;
+}
+
+static void cldma_queue_switch_ring(struct cldma_queue *queue)
+{
+	struct cldma_ctrl *md_ctrl;
+	struct cldma_request *req;
+
+	md_ctrl = md_cd_get(queue->hif_id);
+
+	if (queue->dir == MTK_OUT) {
+		queue->tr_ring = &md_ctrl->tx_ring[queue->index];
+		req = list_first_entry(&queue->tr_ring->gpd_ring, struct cldma_request, entry);
+		queue->tr_done = req;
+		queue->tx_xmit = req;
+		queue->budget = queue->tr_ring->length;
+	} else if (queue->dir == MTK_IN) {
+		queue->tr_ring = &md_ctrl->rx_ring[queue->index];
+		req = list_first_entry(&queue->tr_ring->gpd_ring, struct cldma_request, entry);
+		queue->tr_done = req;
+		queue->rx_refill = req;
+		queue->budget = queue->tr_ring->length;
+	}
+}
+
+static void cldma_rx_queue_init(struct cldma_queue *queue)
+{
+	queue->dir = MTK_IN;
+	cldma_queue_switch_ring(queue);
+	queue->q_type = rxq_type[queue->index];
+}
+
+static void cldma_tx_queue_init(struct cldma_queue *queue)
+{
+	queue->dir = MTK_OUT;
+	cldma_queue_switch_ring(queue);
+	queue->q_type = txq_type[queue->index];
+}
+
+static inline void cldma_enable_irq(struct cldma_ctrl *md_ctrl)
+{
+	mtk_pcie_mac_set_int(md_ctrl->mtk_dev, md_ctrl->hw_info.phy_interrupt_id);
+}
+
+static inline void cldma_disable_irq(struct cldma_ctrl *md_ctrl)
+{
+	mtk_pcie_mac_clear_int(md_ctrl->mtk_dev, md_ctrl->hw_info.phy_interrupt_id);
+}
+
+static void cldma_irq_work_cb(struct cldma_ctrl *md_ctrl)
+{
+	u32 l2_tx_int_msk, l2_rx_int_msk, l2_tx_int, l2_rx_int, val;
+	struct cldma_hw_info *hw_info = &md_ctrl->hw_info;
+	int i;
+
+	/* L2 raw interrupt status */
+	l2_tx_int = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2TISAR0);
+	l2_rx_int = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2RISAR0);
+	l2_tx_int_msk = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2TIMR0);
+	l2_rx_int_msk = ioread32(hw_info->ap_ao_base + REG_CLDMA_L2RIMR0);
+
+	l2_tx_int &= ~l2_tx_int_msk;
+	l2_rx_int &= ~l2_rx_int_msk;
+
+	if (l2_tx_int) {
+		if (l2_tx_int & (TQ_ERR_INT_BITMASK | TQ_ACTIVE_START_ERR_INT_BITMASK)) {
+			/* read and clear L3 TX interrupt status */
+			val = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L3TISAR0);
+			iowrite32(val, hw_info->ap_pdn_base + REG_CLDMA_L3TISAR0);
+			val = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L3TISAR1);
+			iowrite32(val, hw_info->ap_pdn_base + REG_CLDMA_L3TISAR1);
+		}
+
+		cldma_hw_tx_done(hw_info, l2_tx_int);
+
+		if (l2_tx_int & (TXRX_STATUS_BITMASK | EMPTY_STATUS_BITMASK)) {
+			for (i = 0; i < CLDMA_TXQ_NUM; i++) {
+				if (l2_tx_int & BIT(i)) {
+					/* disable TX_DONE interrupt */
+					cldma_hw_mask_eqirq(hw_info, i, false);
+					cldma_hw_mask_txrxirq(hw_info, i, false);
+					queue_work(md_ctrl->txq[i].worker,
+						   &md_ctrl->txq[i].cldma_tx_work);
+				}
+
+				if (l2_tx_int & EQ_STA_BIT(i))
+					cldma_tx_queue_empty_handler(&md_ctrl->txq[i]);
+			}
+		}
+	}
+
+	if (l2_rx_int) {
+		/* clear IP busy register wake up CPU case */
+		if (l2_rx_int & (RQ_ERR_INT_BITMASK | RQ_ACTIVE_START_ERR_INT_BITMASK)) {
+			/* read and clear L3 RX interrupt status */
+			val = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L3RISAR0);
+			iowrite32(val, hw_info->ap_pdn_base + REG_CLDMA_L3RISAR0);
+			val = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L3RISAR1);
+			iowrite32(val, hw_info->ap_pdn_base + REG_CLDMA_L3RISAR1);
+		}
+
+		cldma_hw_rx_done(hw_info, l2_rx_int);
+
+		if (l2_rx_int & (TXRX_STATUS_BITMASK | EMPTY_STATUS_BITMASK)) {
+			for (i = 0; i < CLDMA_RXQ_NUM; i++) {
+				if (l2_rx_int & (BIT(i) | EQ_STA_BIT(i))) {
+					/* disable RX_DONE and QUEUE_EMPTY interrupt */
+					cldma_hw_mask_eqirq(hw_info, i, true);
+					cldma_hw_mask_txrxirq(hw_info, i, true);
+					queue_work(md_ctrl->rxq[i].worker,
+						   &md_ctrl->rxq[i].cldma_rx_work);
+				}
+			}
+		}
+	}
+}
+
+static bool queues_active(struct cldma_hw_info *hw_info)
+{
+	unsigned int tx_active;
+	unsigned int rx_active;
+
+	tx_active = cldma_hw_queue_status(hw_info, CLDMA_ALL_Q, false);
+	rx_active = cldma_hw_queue_status(hw_info, CLDMA_ALL_Q, true);
+
+	return ((tx_active || rx_active) && tx_active != CLDMA_ALL_Q && rx_active != CLDMA_ALL_Q);
+}
+
+/**
+ * cldma_stop() - Stop CLDMA
+ * @hif_id: CLDMA ID (ID_CLDMA0 or ID_CLDMA1)
+ *
+ * stop TX RX queue
+ * disable L1 and L2 interrupt
+ * clear TX/RX empty interrupt status
+ *
+ * Return: 0 on success, a negative error code on failure
+ */
+int cldma_stop(enum cldma_id hif_id)
+{
+	struct cldma_hw_info *hw_info;
+	struct cldma_ctrl *md_ctrl;
+	bool active;
+	int i;
+
+	md_ctrl = md_cd_get(hif_id);
+	if (!md_ctrl)
+		return -EINVAL;
+
+	hw_info = &md_ctrl->hw_info;
+
+	/* stop TX/RX queue */
+	md_ctrl->rxq_active = 0;
+	cldma_hw_stop_queue(hw_info, CLDMA_ALL_Q, true);
+	md_ctrl->txq_active = 0;
+	cldma_hw_stop_queue(hw_info, CLDMA_ALL_Q, false);
+	md_ctrl->txq_started = 0;
+
+	/* disable L1 and L2 interrupt */
+	cldma_disable_irq(md_ctrl);
+	cldma_hw_stop(hw_info, true);
+	cldma_hw_stop(hw_info, false);
+
+	/* clear TX/RX empty interrupt status */
+	cldma_hw_tx_done(hw_info, CLDMA_L2TISAR0_ALL_INT_MASK);
+	cldma_hw_rx_done(hw_info, CLDMA_L2RISAR0_ALL_INT_MASK);
+
+	if (md_ctrl->is_late_init) {
+		for (i = 0; i < CLDMA_TXQ_NUM; i++)
+			flush_work(&md_ctrl->txq[i].cldma_tx_work);
+
+		for (i = 0; i < CLDMA_RXQ_NUM; i++)
+			flush_work(&md_ctrl->rxq[i].cldma_rx_work);
+	}
+
+	if (read_poll_timeout(queues_active, active, !active, CHECK_Q_STOP_STEP_US,
+			      CHECK_Q_STOP_TIMEOUT_US, true, hw_info)) {
+		dev_err(md_ctrl->dev, "Could not stop CLDMA%d queues", hif_id);
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
+static void cldma_late_release(struct cldma_ctrl *md_ctrl)
+{
+	int i;
+
+	if (md_ctrl->is_late_init) {
+		/* free all TX/RX CLDMA request/GBD/skb buffer */
+		for (i = 0; i < CLDMA_TXQ_NUM; i++)
+			cldma_ring_free(md_ctrl, &md_ctrl->tx_ring[i], DMA_TO_DEVICE);
+
+		for (i = 0; i < CLDMA_RXQ_NUM; i++)
+			cldma_ring_free(md_ctrl, &md_ctrl->rx_ring[i], DMA_FROM_DEVICE);
+
+		dma_pool_destroy(md_ctrl->gpd_dmapool);
+		md_ctrl->gpd_dmapool = NULL;
+		md_ctrl->is_late_init = false;
+	}
+}
+
+void cldma_reset(enum cldma_id hif_id)
+{
+	struct cldma_ctrl *md_ctrl;
+	struct mtk_modem *md;
+	unsigned long flags;
+	int i;
+
+	md_ctrl = md_cd_get(hif_id);
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	md_ctrl->hif_id = hif_id;
+	md_ctrl->txq_active = 0;
+	md_ctrl->rxq_active = 0;
+	md = md_ctrl->mtk_dev->md;
+
+	cldma_disable_irq(md_ctrl);
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+
+	for (i = 0; i < CLDMA_TXQ_NUM; i++) {
+		md_ctrl->txq[i].md = md;
+		cancel_work_sync(&md_ctrl->txq[i].cldma_tx_work);
+		spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+		md_cd_queue_struct_reset(&md_ctrl->txq[i], md_ctrl->hif_id, MTK_OUT, i);
+		spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+	}
+
+	for (i = 0; i < CLDMA_RXQ_NUM; i++) {
+		md_ctrl->rxq[i].md = md;
+		cancel_work_sync(&md_ctrl->rxq[i].cldma_rx_work);
+		spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+		md_cd_queue_struct_reset(&md_ctrl->rxq[i], md_ctrl->hif_id, MTK_IN, i);
+		spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+	}
+
+	cldma_late_release(md_ctrl);
+}
+
+/**
+ * cldma_start() - Start CLDMA
+ * @hif_id: CLDMA ID (ID_CLDMA0 or ID_CLDMA1)
+ *
+ * set TX/RX start address
+ * start all RX queues and enable L2 interrupt
+ *
+ */
+void cldma_start(enum cldma_id hif_id)
+{
+	struct cldma_hw_info *hw_info;
+	struct cldma_ctrl *md_ctrl;
+	unsigned long flags;
+
+	md_ctrl = md_cd_get(hif_id);
+	hw_info = &md_ctrl->hw_info;
+
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	if (md_ctrl->is_late_init) {
+		int i;
+
+		cldma_enable_irq(md_ctrl);
+		/* set start address */
+		for (i = 0; i < CLDMA_TXQ_NUM; i++) {
+			if (md_ctrl->txq[i].tr_done)
+				cldma_hw_set_start_address(hw_info, i,
+							   md_ctrl->txq[i].tr_done->gpd_addr, 0);
+		}
+
+		for (i = 0; i < CLDMA_RXQ_NUM; i++) {
+			if (md_ctrl->rxq[i].tr_done)
+				cldma_hw_set_start_address(hw_info, i,
+							   md_ctrl->rxq[i].tr_done->gpd_addr, 1);
+		}
+
+		/* start all RX queues and enable L2 interrupt */
+		cldma_hw_start_queue(hw_info, 0xff, 1);
+		cldma_hw_start(hw_info);
+		/* wait write done */
+		wmb();
+		md_ctrl->txq_started = 0;
+		md_ctrl->txq_active |= TXRX_STATUS_BITMASK;
+		md_ctrl->rxq_active |= TXRX_STATUS_BITMASK;
+	}
+
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+}
+
+static void clear_txq(struct cldma_ctrl *md_ctrl, int qnum)
+{
+	struct cldma_request *req;
+	struct cldma_queue *txq;
+	struct cldma_tgpd *tgpd;
+	unsigned long flags;
+
+	txq = &md_ctrl->txq[qnum];
+	spin_lock_irqsave(&txq->ring_lock, flags);
+	req = list_first_entry(&txq->tr_ring->gpd_ring, struct cldma_request, entry);
+	txq->tr_done = req;
+	txq->tx_xmit = req;
+	txq->budget = txq->tr_ring->length;
+	list_for_each_entry(req, &txq->tr_ring->gpd_ring, entry) {
+		tgpd = req->gpd;
+		tgpd->gpd_flags &= ~GPD_FLAGS_HWO;
+		cldma_tgpd_set_data_ptr(tgpd, 0);
+		tgpd->data_buff_len = 0;
+		if (req->skb) {
+			ccci_free_skb(&md_ctrl->mtk_dev->pools, req->skb);
+			req->skb = NULL;
+		}
+	}
+
+	spin_unlock_irqrestore(&txq->ring_lock, flags);
+}
+
+static int clear_rxq(struct cldma_ctrl *md_ctrl, int qnum)
+{
+	struct cldma_request *req;
+	struct cldma_queue *rxq;
+	struct cldma_rgpd *rgpd;
+	unsigned long flags;
+
+	rxq = &md_ctrl->rxq[qnum];
+	spin_lock_irqsave(&rxq->ring_lock, flags);
+	req = list_first_entry(&rxq->tr_ring->gpd_ring, struct cldma_request, entry);
+	rxq->tr_done = req;
+	rxq->rx_refill = req;
+	list_for_each_entry(req, &rxq->tr_ring->gpd_ring, entry) {
+		rgpd = req->gpd;
+		rgpd->gpd_flags = GPD_FLAGS_IOC | GPD_FLAGS_HWO;
+		rgpd->data_buff_len = 0;
+		if (req->skb) {
+			req->skb->len = 0;
+			skb_reset_tail_pointer(req->skb);
+		}
+	}
+
+	spin_unlock_irqrestore(&rxq->ring_lock, flags);
+	list_for_each_entry(req, &rxq->tr_ring->gpd_ring, entry) {
+		rgpd = req->gpd;
+		if (req->skb)
+			continue;
+
+		req->skb = ccci_alloc_skb_from_pool(&md_ctrl->mtk_dev->pools,
+						    rxq->tr_ring->pkt_size, GFS_BLOCKING);
+		if (!req->skb) {
+			dev_err(md_ctrl->dev, "skb not allocated\n");
+			return -ENOMEM;
+		}
+
+		req->mapped_buff = dma_map_single(md_ctrl->dev, req->skb->data,
+						  skb_data_size(req->skb), DMA_FROM_DEVICE);
+		if (dma_mapping_error(md_ctrl->dev, req->mapped_buff)) {
+			dev_err(md_ctrl->dev, "DMA mapping failed\n");
+			return -ENOMEM;
+		}
+
+		cldma_rgpd_set_data_ptr(rgpd, req->mapped_buff);
+	}
+
+	return 0;
+}
+
+/* only allowed when CLDMA is stopped */
+static void cldma_clear_all_queue(struct cldma_ctrl *md_ctrl, enum direction dir)
+{
+	int i;
+
+	if (dir == MTK_OUT || dir == MTK_INOUT) {
+		for (i = 0; i < CLDMA_TXQ_NUM; i++)
+			clear_txq(md_ctrl, i);
+	}
+
+	if (dir == MTK_IN || dir == MTK_INOUT) {
+		for (i = 0; i < CLDMA_RXQ_NUM; i++)
+			clear_rxq(md_ctrl, i);
+	}
+}
+
+static void cldma_stop_queue(struct cldma_ctrl *md_ctrl, unsigned char qno, enum direction dir)
+{
+	struct cldma_hw_info *hw_info;
+	unsigned long flags;
+
+	hw_info = &md_ctrl->hw_info;
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	if (dir == MTK_IN) {
+		/* disable RX_DONE and QUEUE_EMPTY interrupt */
+		cldma_hw_mask_eqirq(hw_info, qno, true);
+		cldma_hw_mask_txrxirq(hw_info, qno, true);
+		if (qno == CLDMA_ALL_Q)
+			md_ctrl->rxq_active &= ~TXRX_STATUS_BITMASK;
+		else
+			md_ctrl->rxq_active &= ~(TXRX_STATUS_BITMASK & BIT(qno));
+
+		cldma_hw_stop_queue(hw_info, qno, true);
+	} else if (dir == MTK_OUT) {
+		cldma_hw_mask_eqirq(hw_info, qno, false);
+		cldma_hw_mask_txrxirq(hw_info, qno, false);
+		if (qno == CLDMA_ALL_Q)
+			md_ctrl->txq_active &= ~TXRX_STATUS_BITMASK;
+		else
+			md_ctrl->txq_active &= ~(TXRX_STATUS_BITMASK & BIT(qno));
+
+		cldma_hw_stop_queue(hw_info, qno, false);
+	}
+
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+}
+
+/* this is called inside queue->ring_lock */
+static int cldma_gpd_handle_tx_request(struct cldma_queue *queue, struct cldma_request *tx_req,
+				       struct sk_buff *skb, unsigned int ioc_override)
+{
+	struct cldma_ctrl *md_ctrl;
+	struct cldma_tgpd *tgpd;
+	unsigned long flags;
+
+	md_ctrl = md_cd_get(queue->hif_id);
+	tgpd = tx_req->gpd;
+	/* override current IOC setting */
+	if (ioc_override & GPD_FLAGS_IOC) {
+		/* backup current IOC setting */
+		if (tgpd->gpd_flags & GPD_FLAGS_IOC)
+			tx_req->ioc_override = GPD_FLAGS_IOC | GPD_FLAGS_HWO;
+		else
+			tx_req->ioc_override = GPD_FLAGS_IOC;
+		if (ioc_override & GPD_FLAGS_HWO)
+			tgpd->gpd_flags |= GPD_FLAGS_IOC;
+		else
+			tgpd->gpd_flags &= ~GPD_FLAGS_IOC;
+	}
+
+	/* update GPD */
+	tx_req->mapped_buff = dma_map_single(md_ctrl->dev, skb->data,
+					     skb->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(md_ctrl->dev, tx_req->mapped_buff)) {
+		dev_err(md_ctrl->dev, "DMA mapping failed\n");
+		return -ENOMEM;
+	}
+
+	cldma_tgpd_set_data_ptr(tgpd, tx_req->mapped_buff);
+	tgpd->data_buff_len = skb->len;
+
+	/* Set HWO. Use cldma_lock to avoid race condition
+	 * with cldma_stop. This lock must cover TGPD setting,
+	 * as even without a resume operation.
+	 * CLDMA still can start sending next HWO=1,
+	 * if last TGPD was just finished.
+	 */
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	if (md_ctrl->txq_active & BIT(queue->index))
+		tgpd->gpd_flags |= GPD_FLAGS_HWO;
+
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+	/* mark cldma_request as available */
+	tx_req->skb = skb;
+
+	return 0;
+}
+
+static void cldma_hw_start_send(struct cldma_ctrl *md_ctrl, u8 qno)
+{
+	struct cldma_hw_info *hw_info;
+	struct cldma_request *req;
+
+	hw_info = &md_ctrl->hw_info;
+
+	/* check whether the device was powered off (CLDMA start address is not set) */
+	if (!cldma_tx_addr_is_set(hw_info, qno)) {
+		cldma_hw_init(hw_info);
+		req = cldma_ring_step_backward(md_ctrl->txq[qno].tr_ring,
+					       md_ctrl->txq[qno].tx_xmit);
+		cldma_hw_set_start_address(hw_info, qno, req->gpd_addr, false);
+		md_ctrl->txq_started &= ~BIT(qno);
+	}
+
+	/* resume or start queue */
+	if (!cldma_hw_queue_status(hw_info, qno, false)) {
+		if (md_ctrl->txq_started & BIT(qno))
+			cldma_hw_resume_queue(hw_info, qno, false);
+		else
+			cldma_hw_start_queue(hw_info, qno, false);
+		md_ctrl->txq_started |= BIT(qno);
+	}
+}
+
+int cldma_write_room(enum cldma_id hif_id, unsigned char qno)
+{
+	struct cldma_ctrl *md_ctrl;
+	struct cldma_queue *queue;
+
+	md_ctrl = md_cd_get(hif_id);
+	queue = &md_ctrl->txq[qno];
+	if (!queue)
+		return -EINVAL;
+
+	if (queue->budget > (MAX_TX_BUDGET - 1))
+		return queue->budget;
+
+	return 0;
+}
+
+/**
+ * cldma_set_recv_skb() - Set the callback to handle RX packets
+ * @hif_id: CLDMA ID (ID_CLDMA0 or ID_CLDMA1)
+ * @recv_skb: processing callback
+ */
+void cldma_set_recv_skb(enum cldma_id hif_id,
+			int (*recv_skb)(struct cldma_queue *queue, struct sk_buff *skb))
+{
+	struct cldma_ctrl *md_ctrl = md_cd_get(hif_id);
+
+	md_ctrl->recv_skb = recv_skb;
+}
+
+/**
+ * cldma_send_skb() - Send control data to modem
+ * @hif_id: CLDMA ID (ID_CLDMA0 or ID_CLDMA1)
+ * @qno: queue number
+ * @skb: socket buffer
+ * @skb_from_pool: set to true to reuse skb from the pool
+ * @blocking: true for blocking operation
+ *
+ * Send control packet to modem using a ring buffer.
+ * If blocking is set, it will wait for completion.
+ *
+ * Return: 0 on success, -ENOMEM on allocation failure, -EINVAL on invalid queue request, or
+ *         -EBUSY on resource lock failure.
+ */
+int cldma_send_skb(enum cldma_id hif_id, int qno, struct sk_buff *skb, bool skb_from_pool,
+		   bool blocking)
+{
+	unsigned int ioc_override = 0;
+	struct cldma_request *tx_req;
+	struct cldma_ctrl *md_ctrl;
+	struct cldma_queue *queue;
+	unsigned long flags;
+	int ret = 0;
+
+	md_ctrl = md_cd_get(hif_id);
+
+	if (qno >= CLDMA_TXQ_NUM) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	if (skb_from_pool && skb_headroom(skb) == NET_SKB_PAD) {
+		struct ccci_buffer_ctrl *buf_ctrl;
+
+		buf_ctrl = skb_push(skb, sizeof(*buf_ctrl));
+		if (buf_ctrl->head_magic == CCCI_BUF_MAGIC)
+			ioc_override = buf_ctrl->ioc_override;
+		skb_pull(skb, sizeof(*buf_ctrl));
+	}
+
+	queue = &md_ctrl->txq[qno];
+
+	/* check if queue is active */
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	if (!(md_ctrl->txq_active & BIT(qno))) {
+		ret = -EBUSY;
+		spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+		goto exit;
+	}
+
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+
+	do {
+		spin_lock_irqsave(&queue->ring_lock, flags);
+		tx_req = queue->tx_xmit;
+		if (queue->budget > 0 && !tx_req->skb) {
+			queue->budget--;
+			queue->tr_ring->handle_tx_request(queue, tx_req, skb, ioc_override);
+			queue->tx_xmit = cldma_ring_step_forward(queue->tr_ring, tx_req);
+			spin_unlock_irqrestore(&queue->ring_lock, flags);
+
+			spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+			cldma_hw_start_send(md_ctrl, qno);
+			spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+			break;
+		}
+
+		spin_unlock_irqrestore(&queue->ring_lock, flags);
+
+		/* check CLDMA status */
+		if (!cldma_hw_queue_status(&md_ctrl->hw_info, qno, false)) {
+			/* resume channel */
+			spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+			cldma_hw_resume_queue(&md_ctrl->hw_info, qno, false);
+			spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+		}
+
+		if (!blocking) {
+			ret = -EBUSY;
+			break;
+		}
+
+		ret = wait_event_interruptible_exclusive(queue->req_wq, queue->budget > 0);
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+
+	} while (!ret);
+
+exit:
+	return ret;
+}
+
+static void ccci_cldma_adjust_config(void)
+{
+	int qno;
+
+	/* set default config */
+	for (qno = 0; qno < CLDMA_RXQ_NUM; qno++) {
+		rxq_buff_size[qno] = MTK_SKB_4K;
+		rxq_type[qno] = CLDMA_SHARED_Q;
+		rxq_buff_num[qno] = MAX_RX_BUDGET;
+	}
+
+	rxq_buff_size[CLDMA_RXQ_NUM - 1] = MTK_SKB_64K;
+
+	for (qno = 0; qno < CLDMA_TXQ_NUM; qno++) {
+		txq_type[qno] = CLDMA_SHARED_Q;
+		txq_buff_num[qno] = MAX_TX_BUDGET;
+	}
+}
+
+/* this function contains longer duration initializations */
+static int cldma_late_init(struct cldma_ctrl *md_ctrl)
+{
+	char dma_pool_name[32];
+	int i, ret;
+
+	if (md_ctrl->is_late_init) {
+		dev_err(md_ctrl->dev, "CLDMA late init was already done\n");
+		return -EALREADY;
+	}
+
+	mutex_lock(&ctl_cfg_mutex);
+	ccci_cldma_adjust_config();
+	/* init ring buffers */
+	snprintf(dma_pool_name, 32, "cldma_request_dma_hif%d", md_ctrl->hif_id);
+	md_ctrl->gpd_dmapool = dma_pool_create(dma_pool_name, md_ctrl->dev,
+					       sizeof(struct cldma_tgpd), 16, 0);
+	if (!md_ctrl->gpd_dmapool) {
+		mutex_unlock(&ctl_cfg_mutex);
+		dev_err(md_ctrl->dev, "DMA pool alloc fail\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < CLDMA_TXQ_NUM; i++) {
+		INIT_LIST_HEAD(&md_ctrl->tx_ring[i].gpd_ring);
+		md_ctrl->tx_ring[i].length = txq_buff_num[i];
+		md_ctrl->tx_ring[i].handle_tx_request = &cldma_gpd_handle_tx_request;
+		md_ctrl->tx_ring[i].handle_tx_done = &cldma_gpd_tx_collect;
+		ret = cldma_tx_ring_init(md_ctrl, &md_ctrl->tx_ring[i]);
+		if (ret) {
+			dev_err(md_ctrl->dev, "control TX ring init fail\n");
+			goto err_tx_ring;
+		}
+	}
+
+	for (i = 0; i < CLDMA_RXQ_NUM; i++) {
+		INIT_LIST_HEAD(&md_ctrl->rx_ring[i].gpd_ring);
+		md_ctrl->rx_ring[i].length = rxq_buff_num[i];
+		md_ctrl->rx_ring[i].pkt_size = rxq_buff_size[i];
+		md_ctrl->rx_ring[i].handle_rx_done = &cldma_gpd_rx_collect;
+		ret = cldma_rx_ring_init(md_ctrl, &md_ctrl->rx_ring[i]);
+		if (ret) {
+			dev_err(md_ctrl->dev, "control RX ring init fail\n");
+			goto err_rx_ring;
+		}
+	}
+
+	/* init queue */
+	for (i = 0; i < CLDMA_TXQ_NUM; i++)
+		cldma_tx_queue_init(&md_ctrl->txq[i]);
+
+	for (i = 0; i < CLDMA_RXQ_NUM; i++)
+		cldma_rx_queue_init(&md_ctrl->rxq[i]);
+	mutex_unlock(&ctl_cfg_mutex);
+
+	md_ctrl->is_late_init = true;
+	return 0;
+
+err_rx_ring:
+	while (i--)
+		cldma_ring_free(md_ctrl, &md_ctrl->rx_ring[i], DMA_FROM_DEVICE);
+
+	i = CLDMA_TXQ_NUM;
+err_tx_ring:
+	while (i--)
+		cldma_ring_free(md_ctrl, &md_ctrl->tx_ring[i], DMA_TO_DEVICE);
+
+	mutex_unlock(&ctl_cfg_mutex);
+	return ret;
+}
+
+static inline void __iomem *pcie_addr_transfer(void __iomem *addr, u32 addr_trs1, u32 phy_addr)
+{
+	return addr + phy_addr - addr_trs1;
+}
+
+static void hw_info_init(struct cldma_ctrl *md_ctrl)
+{
+	struct cldma_hw_info *hw_info;
+	u32 phy_ao_base, phy_pd_base;
+	struct mtk_addr_base *pbase;
+
+	pbase = &md_ctrl->mtk_dev->base_addr;
+	hw_info = &md_ctrl->hw_info;
+	if (md_ctrl->hif_id != ID_CLDMA1)
+		return;
+
+	phy_ao_base = CLDMA1_AO_BASE;
+	phy_pd_base = CLDMA1_PD_BASE;
+	hw_info->phy_interrupt_id = CLDMA1_INT;
+
+	hw_info->hw_mode = MODE_BIT_64;
+	hw_info->ap_ao_base = pcie_addr_transfer(pbase->pcie_ext_reg_base,
+						 pbase->pcie_dev_reg_trsl_addr,
+						 phy_ao_base);
+	hw_info->ap_pdn_base = pcie_addr_transfer(pbase->pcie_ext_reg_base,
+						  pbase->pcie_dev_reg_trsl_addr,
+						  phy_pd_base);
+}
+
+int cldma_alloc(enum cldma_id hif_id, struct mtk_pci_dev *mtk_dev)
+{
+	struct cldma_ctrl *md_ctrl;
+
+	md_ctrl = devm_kzalloc(&mtk_dev->pdev->dev, sizeof(*md_ctrl), GFP_KERNEL);
+	if (!md_ctrl)
+		return -ENOMEM;
+
+	md_ctrl->mtk_dev = mtk_dev;
+	md_ctrl->dev = &mtk_dev->pdev->dev;
+	md_ctrl->hif_id = hif_id;
+	hw_info_init(md_ctrl);
+	md_cd_set(hif_id, md_ctrl);
+	return 0;
+}
+
+/**
+ * cldma_exception() - CLDMA exception handler
+ * @hif_id: CLDMA ID (ID_CLDMA0 or ID_CLDMA1)
+ * @stage: exception stage
+ *
+ * disable/flush/stop/start CLDMA/queues based on exception stage.
+ *
+ */
+void cldma_exception(enum cldma_id hif_id, enum hif_ex_stage stage)
+{
+	struct cldma_ctrl *md_ctrl;
+
+	md_ctrl = md_cd_get(hif_id);
+	switch (stage) {
+	case HIF_EX_INIT:
+		/* disable CLDMA TX queues */
+		cldma_stop_queue(md_ctrl, CLDMA_ALL_Q, MTK_OUT);
+		/* Clear TX queue */
+		cldma_clear_all_queue(md_ctrl, MTK_OUT);
+		break;
+
+	case HIF_EX_CLEARQ_DONE:
+		/* Stop CLDMA, we do not want to get CLDMA IRQ when MD is
+		 * resetting CLDMA after it got clearq_ack.
+		 */
+		cldma_stop_queue(md_ctrl, CLDMA_ALL_Q, MTK_IN);
+		/* flush all TX&RX workqueues */
+		cldma_stop(hif_id);
+		if (md_ctrl->hif_id == ID_CLDMA1)
+			cldma_hw_reset(md_ctrl->mtk_dev->base_addr.infracfg_ao_base);
+
+		/* clear the RX queue */
+		cldma_clear_all_queue(md_ctrl, MTK_IN);
+		break;
+
+	case HIF_EX_ALLQ_RESET:
+		cldma_hw_init(&md_ctrl->hw_info);
+		cldma_start(hif_id);
+		break;
+
+	default:
+		break;
+	}
+}
+
+void cldma_hif_hw_init(enum cldma_id hif_id)
+{
+	struct cldma_hw_info *hw_info;
+	struct cldma_ctrl *md_ctrl;
+	unsigned long flags;
+
+	md_ctrl = md_cd_get(hif_id);
+	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
+	hw_info = &md_ctrl->hw_info;
+
+	/* mask CLDMA interrupt */
+	cldma_hw_stop(hw_info, false);
+	cldma_hw_stop(hw_info, true);
+
+	/* clear CLDMA interrupt */
+	cldma_hw_rx_done(hw_info, EMPTY_STATUS_BITMASK | TXRX_STATUS_BITMASK);
+	cldma_hw_tx_done(hw_info, EMPTY_STATUS_BITMASK | TXRX_STATUS_BITMASK);
+
+	/* initialize CLDMA hardware */
+	cldma_hw_init(hw_info);
+	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
+}
+
+static irqreturn_t cldma_isr_handler(int irq, void *data)
+{
+	struct cldma_hw_info *hw_info;
+	struct cldma_ctrl *md_ctrl;
+
+	md_ctrl = data;
+	hw_info = &md_ctrl->hw_info;
+	mtk_pcie_mac_clear_int(md_ctrl->mtk_dev, hw_info->phy_interrupt_id);
+	cldma_irq_work_cb(md_ctrl);
+	mtk_pcie_mac_clear_int_status(md_ctrl->mtk_dev, hw_info->phy_interrupt_id);
+	mtk_pcie_mac_set_int(md_ctrl->mtk_dev, hw_info->phy_interrupt_id);
+	return IRQ_HANDLED;
+}
+
+/**
+ * cldma_init() - Initialize CLDMA
+ * @hif_id: CLDMA ID (ID_CLDMA0 or ID_CLDMA1)
+ *
+ * initialize HIF TX/RX queue structure
+ * register CLDMA callback isr with PCIe driver
+ *
+ * Return: 0 on success, a negative error code on failure
+ */
+int cldma_init(enum cldma_id hif_id)
+{
+	struct cldma_hw_info *hw_info;
+	struct cldma_ctrl *md_ctrl;
+	struct mtk_modem *md;
+	int i;
+
+	md_ctrl = md_cd_get(hif_id);
+	md = md_ctrl->mtk_dev->md;
+	md_ctrl->hif_id = hif_id;
+	md_ctrl->txq_active = 0;
+	md_ctrl->rxq_active = 0;
+	md_ctrl->is_late_init = false;
+	hw_info = &md_ctrl->hw_info;
+
+	spin_lock_init(&md_ctrl->cldma_lock);
+	/* initialize HIF queue structure */
+	for (i = 0; i < CLDMA_TXQ_NUM; i++) {
+		md_cd_queue_struct_init(&md_ctrl->txq[i], md_ctrl->hif_id, MTK_OUT, i);
+		md_ctrl->txq[i].md = md;
+		md_ctrl->txq[i].worker =
+			alloc_workqueue("md_hif%d_tx%d_worker",
+					WQ_UNBOUND | WQ_MEM_RECLAIM | (!i ? WQ_HIGHPRI : 0),
+					1, hif_id, i);
+		if (!md_ctrl->txq[i].worker)
+			return -ENOMEM;
+
+		INIT_WORK(&md_ctrl->txq[i].cldma_tx_work, cldma_tx_done);
+	}
+
+	for (i = 0; i < CLDMA_RXQ_NUM; i++) {
+		md_cd_queue_struct_init(&md_ctrl->rxq[i], md_ctrl->hif_id, MTK_IN, i);
+		md_ctrl->rxq[i].md = md;
+		INIT_WORK(&md_ctrl->rxq[i].cldma_rx_work, cldma_rx_done);
+		md_ctrl->rxq[i].worker = alloc_workqueue("md_hif%d_rx%d_worker",
+							 WQ_UNBOUND | WQ_MEM_RECLAIM,
+							 1, hif_id, i);
+		if (!md_ctrl->rxq[i].worker)
+			return -ENOMEM;
+	}
+
+	mtk_pcie_mac_clear_int(md_ctrl->mtk_dev, hw_info->phy_interrupt_id);
+
+	/* registers CLDMA callback ISR with PCIe driver */
+	md_ctrl->mtk_dev->intr_handler[hw_info->phy_interrupt_id] = cldma_isr_handler;
+	md_ctrl->mtk_dev->intr_thread[hw_info->phy_interrupt_id] = NULL;
+	md_ctrl->mtk_dev->callback_param[hw_info->phy_interrupt_id] = md_ctrl;
+	mtk_pcie_mac_clear_int_status(md_ctrl->mtk_dev, hw_info->phy_interrupt_id);
+	return 0;
+}
+
+void cldma_switch_cfg(enum cldma_id hif_id)
+{
+	struct cldma_ctrl *md_ctrl;
+
+	md_ctrl = md_cd_get(hif_id);
+	if (md_ctrl) {
+		cldma_late_release(md_ctrl);
+		cldma_late_init(md_ctrl);
+	}
+}
+
+void cldma_exit(enum cldma_id hif_id)
+{
+	struct cldma_ctrl *md_ctrl;
+	int i;
+
+	md_ctrl = md_cd_get(hif_id);
+	if (!md_ctrl)
+		return;
+
+	/* stop CLDMA work */
+	cldma_stop(hif_id);
+	cldma_late_release(md_ctrl);
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
index 000000000000..8cea9d612e6a
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.h
@@ -0,0 +1,147 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_HIF_CLDMA_H__
+#define __T7XX_HIF_CLDMA_H__
+
+#include <linux/pci.h>
+#include <linux/sched.h>
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
+#define CLDMA_NUM 2
+
+enum cldma_id {
+	ID_CLDMA0,
+	ID_CLDMA1,
+};
+
+enum cldma_queue_type {
+	CLDMA_SHARED_Q,
+	CLDMA_DEDICATED_Q,
+};
+
+struct cldma_request {
+	void *gpd;		/* virtual address for CPU */
+	dma_addr_t gpd_addr;	/* physical address for DMA */
+	struct sk_buff *skb;
+	dma_addr_t mapped_buff;
+	struct list_head entry;
+	struct list_head bd;
+	/* inherit from skb */
+	/* bit7: override or not; bit0: IOC setting */
+	unsigned char ioc_override;
+};
+
+struct cldma_queue;
+
+/* cldma_ring is quite light, most of ring buffer operations require queue struct. */
+struct cldma_ring {
+	struct list_head gpd_ring;	/* ring of struct cldma_request */
+	int length;			/* number of struct cldma_request */
+	int pkt_size;			/* size of each packet in ring */
+
+	int (*handle_tx_request)(struct cldma_queue *queue, struct cldma_request *req,
+				 struct sk_buff *skb, unsigned int ioc_override);
+	int (*handle_rx_done)(struct cldma_queue *queue, int budget);
+	int (*handle_tx_done)(struct cldma_queue *queue);
+};
+
+struct cldma_queue {
+	unsigned char index;
+	struct mtk_modem *md;
+	struct cldma_ring *tr_ring;
+	struct cldma_request *tr_done;
+	int budget;			/* same as ring buffer size by default */
+	struct cldma_request *rx_refill;
+	struct cldma_request *tx_xmit;
+	enum cldma_queue_type q_type;
+	wait_queue_head_t req_wq;	/* only for Tx */
+	spinlock_t ring_lock;
+
+	struct workqueue_struct *worker;
+	struct work_struct cldma_rx_work;
+	struct work_struct cldma_tx_work;
+
+	wait_queue_head_t rx_wq;
+	struct task_struct *rx_thread;
+
+	enum cldma_id hif_id;
+	enum direction dir;
+};
+
+struct cldma_ctrl {
+	enum cldma_id hif_id;
+	struct device *dev;
+	struct mtk_pci_dev *mtk_dev;
+	struct cldma_queue txq[CLDMA_TXQ_NUM];
+	struct cldma_queue rxq[CLDMA_RXQ_NUM];
+	unsigned short txq_active;
+	unsigned short rxq_active;
+	unsigned short txq_started;
+	spinlock_t cldma_lock; /* protects CLDMA structure */
+	/* assuming T/R GPD/BD/SPD have the same size */
+	struct dma_pool *gpd_dmapool;
+	struct cldma_ring tx_ring[CLDMA_TXQ_NUM];
+	struct cldma_ring rx_ring[CLDMA_RXQ_NUM];
+	struct cldma_hw_info hw_info;
+	bool is_late_init;
+	int (*recv_skb)(struct cldma_queue *queue, struct sk_buff *skb);
+};
+
+#define GPD_FLAGS_HWO	BIT(0)
+#define GPD_FLAGS_BDP	BIT(1)
+#define GPD_FLAGS_BPS	BIT(2)
+#define GPD_FLAGS_IOC	BIT(7)
+
+struct cldma_tgpd {
+	u8 gpd_flags;
+	u16 non_used;
+	u8 debug_id;
+	u32 next_gpd_ptr_h;
+	u32 next_gpd_ptr_l;
+	u32 data_buff_bd_ptr_h;
+	u32 data_buff_bd_ptr_l;
+	u16 data_buff_len;
+	u16 non_used1;
+} __packed;
+
+struct cldma_rgpd {
+	u8 gpd_flags;
+	u8 non_used;
+	u16 data_allow_len;
+	u32 next_gpd_ptr_h;
+	u32 next_gpd_ptr_l;
+	u32 data_buff_bd_ptr_h;
+	u32 data_buff_bd_ptr_l;
+	u16 data_buff_len;
+	u8 non_used1;
+	u8 debug_id;
+} __packed;
+
+int cldma_alloc(enum cldma_id hif_id, struct mtk_pci_dev *mtk_dev);
+void cldma_hif_hw_init(enum cldma_id hif_id);
+int cldma_init(enum cldma_id hif_id);
+void cldma_exception(enum cldma_id hif_id, enum hif_ex_stage stage);
+void cldma_exit(enum cldma_id hif_id);
+void cldma_switch_cfg(enum cldma_id hif_id);
+int cldma_write_room(enum cldma_id hif_id, unsigned char qno);
+void cldma_start(enum cldma_id hif_id);
+int cldma_stop(enum cldma_id hif_id);
+void cldma_reset(enum cldma_id hif_id);
+void cldma_set_recv_skb(enum cldma_id hif_id,
+			int (*recv_skb)(struct cldma_queue *queue, struct sk_buff *skb));
+int cldma_send_skb(enum cldma_id hif_id, int qno, struct sk_buff *skb,
+		   bool skb_from_pool, bool blocking);
+
+#endif /* __T7XX_HIF_CLDMA_H__ */
-- 
2.17.1

