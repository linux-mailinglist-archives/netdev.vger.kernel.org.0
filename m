Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD0548E1F2
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 02:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238636AbiANBG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 20:06:59 -0500
Received: from mga04.intel.com ([192.55.52.120]:27438 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238606AbiANBGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 20:06:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642122415; x=1673658415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=WFjDPvzmHsdIPm0RtqicYiyoJo+nx4//3nlKt98Hdk8=;
  b=RRH9nkJZA0CM4fBLWxif58tjjChgaRMyA+AN+6cNykRNRFvn9n+OLiho
   FBrIuc5RfYWntErq6TeerXXGmuzzk1zHnMApbYkdDTTrt5+8cbn0/+JzV
   lsQiVB7jdK4GJJZsWLXcSZVFDAvYoDdNx5iCFfqHIvexN9M7sg8bE8eDu
   wexruKYpLaFOfNKQMcAQw/ZyVxDL4qy+6MFaWCiXlTI4LvjfbaaU4l+Zc
   dWe+ZNcPHhmQ5+ZQFy/TWzB7eUz4Bky/pyEYw6MYSP+DkgLp88dZsGa2U
   Hi8spZPN8/mr1ulO49FxUVpLFiaRDFJ+IDFn//4GnauZ20m9thsjeFn0X
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="242970852"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="242970852"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:54 -0800
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="692014206"
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
Subject: [PATCH net-next v4 07/13] net: wwan: t7xx: Data path HW layer
Date:   Thu, 13 Jan 2022 18:06:21 -0700
Message-Id: <20220114010627.21104-8-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haijun Liu <haijun.liu@mediatek.com>

Data Path Modem AP Interface (DPMAIF) HW layer provides HW abstraction
for the upper layer (DPMAIF HIF). It implements functions to do the HW
configuration, TX/RX control and interrupt handling.

Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/t7xx_dpmaif.c | 1372 +++++++++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_dpmaif.h |  146 +++
 2 files changed, 1518 insertions(+)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_dpmaif.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_dpmaif.h

diff --git a/drivers/net/wwan/t7xx/t7xx_dpmaif.c b/drivers/net/wwan/t7xx/t7xx_dpmaif.c
new file mode 100644
index 000000000000..e9ecedce70ea
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_dpmaif.c
@@ -0,0 +1,1372 @@
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
+ *
+ * Contributors:
+ *  Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#include <linux/bits.h>
+#include <linux/bitfield.h>
+#include <linux/bitops.h>
+#include <linux/delay.h>
+#include <linux/dev_printk.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/types.h>
+
+#include "t7xx_dpmaif.h"
+#include "t7xx_hif_dpmaif.h"
+#include "t7xx_reg.h"
+
+#define ioread32_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout_atomic(ioread32, addr, val, cond, delay_us, timeout_us)
+
+static int t7xx_dpmaif_init_intr(struct dpmaif_hw_info *hw_info)
+{
+	struct dpmaif_isr_en_mask *isr_en_msk = &hw_info->isr_en_mask;
+	u32 value, ul_intr_enable, dl_intr_enable;
+	int ret;
+
+	ul_intr_enable = DP_UL_INT_ERR_MSK | DP_UL_INT_QDONE_MSK;
+	isr_en_msk->ap_ul_l2intr_en_msk = ul_intr_enable;
+	iowrite32(DPMAIF_AP_ALL_L2TISAR0_MASK, hw_info->pcie_base + DPMAIF_AP_L2TISAR0);
+
+	/* Set interrupt enable mask */
+	iowrite32(ul_intr_enable, hw_info->pcie_base + DPMAIF_AO_UL_AP_L2TIMCR0);
+	iowrite32(~ul_intr_enable, hw_info->pcie_base + DPMAIF_AO_UL_AP_L2TIMSR0);
+
+	/* Check mask status */
+	ret = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_AO_UL_AP_L2TIMR0,
+					   value, (value & ul_intr_enable) != ul_intr_enable, 0,
+					   DPMAIF_CHECK_INIT_TIMEOUT_US);
+	if (ret)
+		return ret;
+
+	dl_intr_enable = DP_DL_INT_PITCNT_LEN_ERR | DP_DL_INT_BATCNT_LEN_ERR;
+	isr_en_msk->ap_dl_l2intr_err_en_msk = dl_intr_enable;
+	ul_intr_enable = DPMAIF_DL_INT_DLQ0_QDONE | DPMAIF_DL_INT_DLQ0_PITCNT_LEN |
+		    DPMAIF_DL_INT_DLQ1_QDONE | DPMAIF_DL_INT_DLQ1_PITCNT_LEN;
+	isr_en_msk->ap_ul_l2intr_en_msk = ul_intr_enable;
+	iowrite32(DPMAIF_AP_APDL_ALL_L2TISAR0_MASK, hw_info->pcie_base + DPMAIF_AP_APDL_L2TISAR0);
+
+	/* Set DL ISR PD enable mask */
+	iowrite32(~ul_intr_enable, hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMSR0);
+	ret = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMR0,
+					   value, (value & ul_intr_enable) != ul_intr_enable, 0,
+					   DPMAIF_CHECK_INIT_TIMEOUT_US);
+	if (ret)
+		return ret;
+
+	isr_en_msk->ap_udl_ip_busy_en_msk = DPMAIF_UDL_IP_BUSY;
+	iowrite32(DPMAIF_AP_IP_BUSY_MASK, hw_info->pcie_base + DPMAIF_AP_IP_BUSY);
+	iowrite32(isr_en_msk->ap_udl_ip_busy_en_msk,
+		  hw_info->pcie_base + DPMAIF_AO_AP_DLUL_IP_BUSY_MASK);
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_UL_AP_L1TIMR0);
+	value |= DPMAIF_DL_INT_Q2APTOP | DPMAIF_DL_INT_Q2TOQ1;
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_UL_AP_L1TIMR0);
+	iowrite32(DPMA_HPC_ALL_INT_MASK, hw_info->pcie_base + DPMAIF_HPC_INTR_MASK);
+
+	return 0;
+}
+
+static void t7xx_dpmaif_mask_ulq_intr(struct dpmaif_ctrl *dpmaif_ctrl, unsigned int q_num)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	struct dpmaif_isr_en_mask *isr_en_msk;
+	u32 value, ul_int_que_done;
+	int ret;
+
+	isr_en_msk = &hw_info->isr_en_mask;
+	ul_int_que_done = BIT(q_num + DP_UL_INT_DONE_OFFSET) & DP_UL_INT_QDONE_MSK;
+	isr_en_msk->ap_ul_l2intr_en_msk &= ~ul_int_que_done;
+	iowrite32(ul_int_que_done, hw_info->pcie_base + DPMAIF_AO_UL_AP_L2TIMSR0);
+
+	ret = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_AO_UL_AP_L2TIMR0,
+					   value, (value & ul_int_que_done) == ul_int_que_done, 0,
+					   DPMAIF_CHECK_TIMEOUT_US);
+	if (ret)
+		dev_err(dpmaif_ctrl->dev,
+			"Could not mask the UL interrupt. DPMAIF_AO_UL_AP_L2TIMR0 is 0x%x\n",
+			value);
+}
+
+void t7xx_dpmaif_unmask_ulq_intr(struct dpmaif_ctrl *dpmaif_ctrl, unsigned int q_num)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	struct dpmaif_isr_en_mask *isr_en_msk;
+	u32 value, ul_int_que_done;
+	int ret;
+
+	isr_en_msk = &hw_info->isr_en_mask;
+	ul_int_que_done = BIT(q_num + DP_UL_INT_DONE_OFFSET) & DP_UL_INT_QDONE_MSK;
+	isr_en_msk->ap_ul_l2intr_en_msk |= ul_int_que_done;
+	iowrite32(ul_int_que_done, hw_info->pcie_base + DPMAIF_AO_UL_AP_L2TIMCR0);
+
+	ret = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_AO_UL_AP_L2TIMR0,
+					   value, (value & ul_int_que_done) != ul_int_que_done, 0,
+					   DPMAIF_CHECK_TIMEOUT_US);
+	if (ret)
+		dev_err(dpmaif_ctrl->dev,
+			"Could not unmask the UL interrupt. DPMAIF_AO_UL_AP_L2TIMR0 is 0x%x\n",
+			value);
+}
+
+void t7xx_dpmaif_dl_unmask_batcnt_len_err_intr(struct dpmaif_hw_info *hw_info)
+{
+	hw_info->isr_en_mask.ap_dl_l2intr_en_msk |= DP_DL_INT_BATCNT_LEN_ERR;
+	iowrite32(DP_DL_INT_BATCNT_LEN_ERR, hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMCR0);
+}
+
+void t7xx_dpmaif_dl_unmask_pitcnt_len_err_intr(struct dpmaif_hw_info *hw_info)
+{
+	hw_info->isr_en_mask.ap_dl_l2intr_en_msk |= DP_DL_INT_PITCNT_LEN_ERR;
+	iowrite32(DP_DL_INT_PITCNT_LEN_ERR, hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMCR0);
+}
+
+static u32 t7xx_update_dlq_intr(struct dpmaif_hw_info *hw_info, u32 q_done)
+{
+	u32 value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_UL_AP_L2TIMR0);
+	iowrite32(q_done, hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMSR0);
+	return value;
+}
+
+static int t7xx_mask_dlq_intr(struct dpmaif_ctrl *dpmaif_ctrl, unsigned char qno)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	u32 value, q_done;
+	int ret;
+
+	q_done = qno == DPF_RX_QNO0 ? DPMAIF_DL_INT_DLQ0_QDONE : DPMAIF_DL_INT_DLQ1_QDONE;
+	iowrite32(q_done, hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMSR0);
+
+	ret = read_poll_timeout_atomic(t7xx_update_dlq_intr, value, value & q_done,
+				       0, DPMAIF_CHECK_TIMEOUT_US, false, hw_info, q_done);
+	if (ret) {
+		dev_err(dpmaif_ctrl->dev,
+			"Could not mask the DL interrupt. DPMAIF_AO_UL_AP_L2TIMR0 is 0x%x\n",
+			value);
+		return -ETIMEDOUT;
+	}
+
+	hw_info->isr_en_mask.ap_dl_l2intr_en_msk &= ~q_done;
+	return 0;
+}
+
+void t7xx_dpmaif_dlq_unmask_rx_done(struct dpmaif_hw_info *hw_info, unsigned char qno)
+{
+	u32 mask;
+
+	mask = qno == DPF_RX_QNO0 ? DPMAIF_DL_INT_DLQ0_QDONE : DPMAIF_DL_INT_DLQ1_QDONE;
+	iowrite32(mask, hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMCR0);
+	hw_info->isr_en_mask.ap_dl_l2intr_en_msk |= mask;
+}
+
+void t7xx_dpmaif_clr_ip_busy_sts(struct dpmaif_hw_info *hw_info)
+{
+	u32 ip_busy_sts;
+
+	ip_busy_sts = ioread32(hw_info->pcie_base + DPMAIF_AP_IP_BUSY);
+	iowrite32(ip_busy_sts, hw_info->pcie_base + DPMAIF_AP_IP_BUSY);
+}
+
+static void t7xx_dpmaif_dlq_mask_rx_pitcnt_len_err_intr(struct dpmaif_hw_info *hw_info,
+							unsigned char qno)
+{
+	if (qno == DPF_RX_QNO0)
+		iowrite32(DPMAIF_DL_INT_DLQ0_PITCNT_LEN,
+			  hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMSR0);
+	else
+		iowrite32(DPMAIF_DL_INT_DLQ1_PITCNT_LEN,
+			  hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMSR0);
+}
+
+void t7xx_dpmaif_dlq_unmask_pitcnt_len_err_intr(struct dpmaif_hw_info *hw_info,
+						unsigned char qno)
+{
+	if (qno == DPF_RX_QNO0)
+		iowrite32(DPMAIF_DL_INT_DLQ0_PITCNT_LEN,
+			  hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMCR0);
+	else
+		iowrite32(DPMAIF_DL_INT_DLQ1_PITCNT_LEN,
+			  hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMCR0);
+}
+
+void t7xx_dpmaif_ul_clr_all_intr(struct dpmaif_hw_info *hw_info)
+{
+	iowrite32(DPMAIF_AP_ALL_L2TISAR0_MASK, hw_info->pcie_base + DPMAIF_AP_L2TISAR0);
+}
+
+void t7xx_dpmaif_dl_clr_all_intr(struct dpmaif_hw_info *hw_info)
+{
+	iowrite32(DPMAIF_AP_APDL_ALL_L2TISAR0_MASK, hw_info->pcie_base + DPMAIF_AP_APDL_L2TISAR0);
+}
+
+static void t7xx_dpmaif_set_intr_para(struct dpmaif_hw_intr_st_para *para,
+				      enum dpmaif_hw_intr_type intr_type, unsigned int intr_queue)
+{
+	para->intr_types[para->intr_cnt] = intr_type;
+	para->intr_queues[para->intr_cnt] = intr_queue;
+	para->intr_cnt++;
+}
+
+/* The para->intr_cnt counter is set to zero before this function is called.
+ * It does not check for overflow as there is no risk of overflowing intr_types or intr_queues.
+ */
+static void t7xx_dpmaif_hw_check_tx_intr(struct dpmaif_ctrl *dpmaif_ctrl,
+					 unsigned int l2_txisar0,
+					 struct dpmaif_hw_intr_st_para *para)
+{
+	unsigned long value;
+
+	value = FIELD_GET(DP_UL_INT_QDONE_MSK, l2_txisar0);
+	if (value) {
+		unsigned int index;
+
+		t7xx_dpmaif_set_intr_para(para, DPF_INTR_UL_DONE, value);
+
+		for_each_set_bit(index, &value, DPMAIF_TXQ_NUM)
+			t7xx_dpmaif_mask_ulq_intr(dpmaif_ctrl, index);
+	}
+
+	value = FIELD_GET(DP_UL_INT_EMPTY_MSK, l2_txisar0);
+	if (value)
+		t7xx_dpmaif_set_intr_para(para, DPF_INTR_UL_DRB_EMPTY, value);
+
+	value = FIELD_GET(DP_UL_INT_MD_NOTREADY_MSK, l2_txisar0);
+	if (value)
+		t7xx_dpmaif_set_intr_para(para, DPF_INTR_UL_MD_NOTREADY, value);
+
+	value = FIELD_GET(DP_UL_INT_MD_PWR_NOTREADY_MSK, l2_txisar0);
+	if (value)
+		t7xx_dpmaif_set_intr_para(para, DPF_INTR_UL_MD_PWR_NOTREADY, value);
+
+	value = FIELD_GET(DP_UL_INT_ERR_MSK, l2_txisar0);
+	if (value)
+		t7xx_dpmaif_set_intr_para(para, DPF_INTR_UL_LEN_ERR, value);
+}
+
+/* The para->intr_cnt counter is set to zero before this function is called.
+ * It does not check for overflow as there is no risk of overflowing intr_types or intr_queues.
+ */
+static void t7xx_dpmaif_hw_check_rx_intr(struct dpmaif_ctrl *dpmaif_ctrl,
+					 unsigned int *pl2_rxisar0,
+					 struct dpmaif_hw_intr_st_para *para, int qno)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	unsigned int l2_rxisar0 = *pl2_rxisar0;
+	unsigned int value;
+
+	if (qno == DPF_RX_QNO_DFT) {
+		value = l2_rxisar0 & DP_DL_INT_SKB_LEN_ERR;
+		if (value)
+			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_SKB_LEN_ERR, DPF_RX_QNO_DFT);
+
+		value = l2_rxisar0 & DP_DL_INT_BATCNT_LEN_ERR;
+		if (value) {
+			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_BATCNT_LEN_ERR, DPF_RX_QNO_DFT);
+			hw_info->isr_en_mask.ap_dl_l2intr_en_msk &= ~DP_DL_INT_BATCNT_LEN_ERR;
+			iowrite32(DP_DL_INT_BATCNT_LEN_ERR,
+				  hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMSR0);
+		}
+
+		value = l2_rxisar0 & DP_DL_INT_PITCNT_LEN_ERR;
+		if (value) {
+			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_PITCNT_LEN_ERR, DPF_RX_QNO_DFT);
+			hw_info->isr_en_mask.ap_dl_l2intr_en_msk &= ~DP_DL_INT_PITCNT_LEN_ERR;
+			iowrite32(DP_DL_INT_PITCNT_LEN_ERR,
+				  hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMSR0);
+		}
+
+		value = l2_rxisar0 & DP_DL_INT_PKT_EMPTY_MSK;
+		if (value)
+			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_PKT_EMPTY_SET, DPF_RX_QNO_DFT);
+
+		value = l2_rxisar0 & DP_DL_INT_FRG_EMPTY_MSK;
+		if (value)
+			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_FRG_EMPTY_SET, DPF_RX_QNO_DFT);
+
+		value = l2_rxisar0 & DP_DL_INT_MTU_ERR_MSK;
+		if (value)
+			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_MTU_ERR, DPF_RX_QNO_DFT);
+
+		value = l2_rxisar0 & DP_DL_INT_FRG_LENERR_MSK;
+		if (value)
+			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_FRGCNT_LEN_ERR, DPF_RX_QNO_DFT);
+
+		value = l2_rxisar0 & DP_DL_INT_Q0_PITCNT_LEN_ERR;
+		if (value) {
+			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_Q0_PITCNT_LEN_ERR, BIT(qno));
+			t7xx_dpmaif_dlq_mask_rx_pitcnt_len_err_intr(hw_info, qno);
+		}
+
+		value = l2_rxisar0 & DP_DL_INT_HPC_ENT_TYPE_ERR;
+		if (value)
+			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_HPC_ENT_TYPE_ERR,
+						  DPF_RX_QNO_DFT);
+
+		value = l2_rxisar0 & DP_DL_INT_Q0_DONE;
+		if (value) {
+			/* Mask RX done interrupt immediately after it occurs */
+			if (!t7xx_mask_dlq_intr(dpmaif_ctrl, qno)) {
+				t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_Q0_DONE, BIT(qno));
+			} else {
+				/* Unable to clear the interrupt, try again on the next one
+				 * device entered low power mode or suffer exception
+				 */
+				*pl2_rxisar0 = l2_rxisar0 & ~DP_DL_INT_Q0_DONE;
+			}
+		}
+	} else {
+		value = l2_rxisar0 & DP_DL_INT_Q1_PITCNT_LEN_ERR;
+		if (value) {
+			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_Q1_PITCNT_LEN_ERR, BIT(qno));
+			t7xx_dpmaif_dlq_mask_rx_pitcnt_len_err_intr(hw_info, qno);
+		}
+
+		value = l2_rxisar0 & DP_DL_INT_Q1_DONE;
+		if (value) {
+			if (!t7xx_mask_dlq_intr(dpmaif_ctrl, qno))
+				t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_Q1_DONE, BIT(qno));
+			else
+				*pl2_rxisar0 = l2_rxisar0 & ~DP_DL_INT_Q1_DONE;
+		}
+	}
+}
+
+/**
+ * t7xx_dpmaif_hw_get_intr_cnt() - Reads interrupt status and count from HW.
+ * @dpmaif_ctrl: Pointer to struct dpmaif_ctrl.
+ * @para: Pointer to struct dpmaif_hw_intr_st_para.
+ * @qno: Queue number.
+ *
+ * Reads RX/TX interrupt status from HW and clears UL/DL status as needed.
+ *
+ * Return: Interrupt count.
+ */
+int t7xx_dpmaif_hw_get_intr_cnt(struct dpmaif_ctrl *dpmaif_ctrl,
+				struct dpmaif_hw_intr_st_para *para, int qno)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	u32 rx_intr_status, tx_intr_status = 0;
+	u32 rx_intr_qdone, tx_intr_qdone = 0;
+
+	rx_intr_status = ioread32(hw_info->pcie_base + DPMAIF_AP_APDL_L2TISAR0);
+	rx_intr_qdone = ioread32(hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMR0);
+
+	/* TX interrupt status */
+	if (qno == DPF_RX_QNO_DFT) {
+		/* All ULQ and DLQ0 interrupts use the same source no need to check ULQ interrupts
+		 * when a DLQ1 interrupt has occurred.
+		 */
+		tx_intr_status = ioread32(hw_info->pcie_base + DPMAIF_AP_L2TISAR0);
+		tx_intr_qdone = ioread32(hw_info->pcie_base + DPMAIF_AO_UL_AP_L2TIMR0);
+	}
+
+	t7xx_dpmaif_clr_ip_busy_sts(hw_info);
+
+	if (qno == DPF_RX_QNO_DFT) {
+		/* Do not schedule bottom half again or clear UL interrupt status when we
+		 * have already masked it.
+		 */
+		tx_intr_status &= ~tx_intr_qdone;
+		if (tx_intr_status) {
+			t7xx_dpmaif_hw_check_tx_intr(dpmaif_ctrl, tx_intr_status, para);
+			/* Clear interrupt status */
+			iowrite32(tx_intr_status, hw_info->pcie_base + DPMAIF_AP_L2TISAR0);
+		}
+	}
+
+	if (rx_intr_status) {
+		if (qno == DPF_RX_QNO0) {
+			rx_intr_status &= DP_DL_Q0_STATUS_MASK;
+			if (rx_intr_qdone & DPMAIF_DL_INT_DLQ0_QDONE)
+				/* Do not schedule bottom half again or clear DL
+				 * queue done interrupt status when we have already masked it.
+				 */
+				rx_intr_status &= ~DP_DL_INT_Q0_DONE;
+		} else {
+			rx_intr_status &= DP_DL_Q1_STATUS_MASK;
+			if (rx_intr_qdone & DPMAIF_DL_INT_DLQ1_QDONE)
+				rx_intr_status &= ~DP_DL_INT_Q1_DONE;
+		}
+
+		if (rx_intr_status) {
+			t7xx_dpmaif_hw_check_rx_intr(dpmaif_ctrl, &rx_intr_status, para, qno);
+			rx_intr_status |= DP_DL_INT_BATCNT_LEN_ERR;
+			/* Clear interrupt status */
+			iowrite32(rx_intr_status, hw_info->pcie_base + DPMAIF_AP_APDL_L2TISAR0);
+		}
+	}
+
+	return para->intr_cnt;
+}
+
+static int t7xx_dpmaif_sram_init(struct dpmaif_hw_info *hw_info)
+{
+	u32 value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AP_MEM_CLR);
+	value |= DPMAIF_MEM_CLR;
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AP_MEM_CLR);
+
+	return ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_AP_MEM_CLR,
+					    value, !(value & DPMAIF_MEM_CLR), 0,
+					    DPMAIF_CHECK_INIT_TIMEOUT_US);
+}
+
+static void t7xx_dpmaif_hw_reset(struct dpmaif_hw_info *hw_info)
+{
+	iowrite32(DPMAIF_AP_AO_RST_BIT, hw_info->pcie_base + DPMAIF_AP_AO_RGU_ASSERT);
+	udelay(2);
+	iowrite32(DPMAIF_AP_RST_BIT, hw_info->pcie_base + DPMAIF_AP_RGU_ASSERT);
+	udelay(2);
+	iowrite32(DPMAIF_AP_AO_RST_BIT, hw_info->pcie_base + DPMAIF_AP_AO_RGU_DEASSERT);
+	udelay(2);
+	iowrite32(DPMAIF_AP_RST_BIT, hw_info->pcie_base + DPMAIF_AP_RGU_DEASSERT);
+	udelay(2);
+}
+
+static int t7xx_dpmaif_hw_config(struct dpmaif_hw_info *hw_info)
+{
+	u32 ap_port_mode;
+	int ret;
+
+	t7xx_dpmaif_hw_reset(hw_info);
+
+	ret = t7xx_dpmaif_sram_init(hw_info);
+	if (ret)
+		return ret;
+
+	ap_port_mode = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_THRES);
+	ap_port_mode |= DPMAIF_PORT_MODE_PCIE;
+	iowrite32(ap_port_mode, hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_THRES);
+	iowrite32(DPMAIF_CG_EN, hw_info->pcie_base + DPMAIF_AP_CG_EN);
+	return 0;
+}
+
+static void t7xx_dpmaif_pcie_dpmaif_sign(struct dpmaif_hw_info *hw_info)
+{
+	iowrite32(DPMAIF_PCIE_MODE_SET_VALUE, hw_info->pcie_base + DPMAIF_UL_RESERVE_AO_RW);
+}
+
+static void t7xx_dpmaif_dl_performance(struct dpmaif_hw_info *hw_info)
+{
+	u32 enable_bat_cache, enable_pit_burst;
+
+	enable_bat_cache = ioread32(hw_info->pcie_base + DPMAIF_DL_BAT_INIT_CON1);
+	enable_bat_cache |= DPMAIF_DL_BAT_CACHE_PRI;
+	iowrite32(enable_bat_cache, hw_info->pcie_base + DPMAIF_DL_BAT_INIT_CON1);
+
+	enable_pit_burst = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_THRES);
+	enable_pit_burst |= DPMAIF_DL_BURST_PIT_EN;
+	iowrite32(enable_pit_burst, hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_THRES);
+}
+
+ /* DPMAIF DL DLQ part HW setting */
+
+static void t7xx_dpmaif_hw_hpc_cntl_set(struct dpmaif_hw_info *hw_info)
+{
+	unsigned int value;
+
+	value = DPMAIF_HPC_DLQ_PATH_MODE | DPMAIF_HPC_ADD_MODE_DF << 2;
+	value |= DPMAIF_HASH_PRIME_DF << 4;
+	value |= DPMAIF_HPC_TOTAL_NUM << 8;
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_DL_HPC_CNTL);
+}
+
+static void t7xx_dpmaif_hw_agg_cfg_set(struct dpmaif_hw_info *hw_info)
+{
+	unsigned int value;
+
+	value = DPMAIF_AGG_MAX_LEN_DF | DPMAIF_AGG_TBL_ENT_NUM_DF << 16;
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_DL_DLQ_AGG_CFG);
+}
+
+static void t7xx_dpmaif_hw_hash_bit_choose_set(struct dpmaif_hw_info *hw_info)
+{
+	iowrite32(DPMAIF_DLQ_HASH_BIT_CHOOSE_DF,
+		  hw_info->pcie_base + DPMAIF_AO_DL_DLQPIT_INIT_CON5);
+}
+
+static void t7xx_dpmaif_hw_mid_pit_timeout_thres_set(struct dpmaif_hw_info *hw_info)
+{
+	iowrite32(DPMAIF_MID_TIMEOUT_THRES_DF, hw_info->pcie_base + DPMAIF_AO_DL_DLQPIT_TIMEOUT0);
+}
+
+static void t7xx_dpmaif_hw_dlq_timeout_thres_set(struct dpmaif_hw_info *hw_info)
+{
+	unsigned int value, i;
+
+	/* Each register holds two DLQ threshold timeout values */
+	for (i = 0; i < DPMAIF_HPC_MAX_TOTAL_NUM / 2; i++) {
+		value = FIELD_PREP(DPMAIF_DLQ_LOW_TIMEOUT_THRES_MKS, DPMAIF_DLQ_TIMEOUT_THRES_DF);
+		value |= FIELD_PREP(DPMAIF_DLQ_HIGH_TIMEOUT_THRES_MSK,
+				    DPMAIF_DLQ_TIMEOUT_THRES_DF);
+		iowrite32(value,
+			  hw_info->pcie_base + DPMAIF_AO_DL_DLQPIT_TIMEOUT1 + sizeof(u32) * i);
+	}
+}
+
+static void t7xx_dpmaif_hw_dlq_start_prs_thres_set(struct dpmaif_hw_info *hw_info)
+{
+	iowrite32(DPMAIF_DLQ_PRS_THRES_DF, hw_info->pcie_base + DPMAIF_AO_DL_DLQPIT_TRIG_THRES);
+}
+
+static void t7xx_dpmaif_dl_dlq_hpc_hw_init(struct dpmaif_hw_info *hw_info)
+{
+	t7xx_dpmaif_hw_hpc_cntl_set(hw_info);
+	t7xx_dpmaif_hw_agg_cfg_set(hw_info);
+	t7xx_dpmaif_hw_hash_bit_choose_set(hw_info);
+	t7xx_dpmaif_hw_mid_pit_timeout_thres_set(hw_info);
+	t7xx_dpmaif_hw_dlq_timeout_thres_set(hw_info);
+	t7xx_dpmaif_hw_dlq_start_prs_thres_set(hw_info);
+}
+
+static int t7xx_dpmaif_dl_bat_init_done(struct dpmaif_ctrl *dpmaif_ctrl,
+					unsigned char q_num, bool frg_en)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	u32 value, dl_bat_init = 0;
+	int ret;
+
+	if (frg_en)
+		dl_bat_init = DPMAIF_DL_BAT_FRG_INIT;
+
+	dl_bat_init |= DPMAIF_DL_BAT_INIT_ALLSET;
+	dl_bat_init |= DPMAIF_DL_BAT_INIT_EN;
+
+	ret = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_DL_BAT_INIT,
+					   value, !(value & DPMAIF_DL_BAT_INIT_NOT_READY), 0,
+					   DPMAIF_CHECK_INIT_TIMEOUT_US);
+	if (ret) {
+		dev_err(dpmaif_ctrl->dev, "Data plane modem DL BAT is not ready\n");
+		return ret;
+	}
+
+	iowrite32(dl_bat_init, hw_info->pcie_base + DPMAIF_DL_BAT_INIT);
+
+	ret = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_DL_BAT_INIT,
+					   value, !(value & DPMAIF_DL_BAT_INIT_NOT_READY), 0,
+					   DPMAIF_CHECK_INIT_TIMEOUT_US);
+	if (ret)
+		dev_err(dpmaif_ctrl->dev, "Data plane modem DL BAT initialization failed\n");
+
+	return ret;
+}
+
+static void t7xx_dpmaif_dl_set_bat_base_addr(struct dpmaif_hw_info *hw_info,
+					     unsigned char q_num, dma_addr_t addr)
+{
+	iowrite32(lower_32_bits(addr), hw_info->pcie_base + DPMAIF_DL_BAT_INIT_CON0);
+	iowrite32(upper_32_bits(addr), hw_info->pcie_base + DPMAIF_DL_BAT_INIT_CON3);
+}
+
+static void t7xx_dpmaif_dl_set_bat_size(struct dpmaif_hw_info *hw_info,
+					unsigned char q_num, unsigned int size)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_DL_BAT_INIT_CON1);
+	value &= ~DPMAIF_BAT_SIZE_MSK;
+	value |= size & DPMAIF_BAT_SIZE_MSK;
+	iowrite32(value, hw_info->pcie_base + DPMAIF_DL_BAT_INIT_CON1);
+}
+
+static void t7xx_dpmaif_dl_bat_en(struct dpmaif_hw_info *hw_info, unsigned char q_num, bool enable)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_DL_BAT_INIT_CON1);
+
+	if (enable)
+		value |= DPMAIF_BAT_EN_MSK;
+	else
+		value &= ~DPMAIF_BAT_EN_MSK;
+
+	iowrite32(value, hw_info->pcie_base + DPMAIF_DL_BAT_INIT_CON1);
+}
+
+static void t7xx_dpmaif_dl_set_ao_bid_maxcnt(struct dpmaif_hw_info *hw_info,
+					     unsigned char q_num, unsigned int cnt)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_PKTINFO_CON0);
+	value &= ~DPMAIF_BAT_BID_MAXCNT_MSK;
+	value |= FIELD_PREP(DPMAIF_BAT_BID_MAXCNT_MSK, cnt);
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_DL_PKTINFO_CON0);
+}
+
+static void t7xx_dpmaif_dl_set_ao_mtu(struct dpmaif_hw_info *hw_info, unsigned int mtu_sz)
+{
+	iowrite32(mtu_sz, hw_info->pcie_base + DPMAIF_AO_DL_PKTINFO_CON1);
+}
+
+static void t7xx_dpmaif_dl_set_ao_pit_chknum(struct dpmaif_hw_info *hw_info, unsigned char q_num,
+					     unsigned int number)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_PKTINFO_CON2);
+	value &= ~DPMAIF_PIT_CHK_NUM_MSK;
+	value |= FIELD_PREP(DPMAIF_PIT_CHK_NUM_MSK, number);
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_DL_PKTINFO_CON2);
+}
+
+static void t7xx_dpmaif_dl_set_ao_remain_minsz(struct dpmaif_hw_info *hw_info, unsigned char q_num,
+					       size_t min_sz)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_PKTINFO_CON0);
+	value &= ~DPMAIF_BAT_REMAIN_MINSZ_MSK;
+	value |= FIELD_PREP(DPMAIF_BAT_REMAIN_MINSZ_MSK, min_sz / DPMAIF_BAT_REMAIN_SZ_BASE);
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_DL_PKTINFO_CON0);
+}
+
+static void t7xx_dpmaif_dl_set_ao_bat_bufsz(struct dpmaif_hw_info *hw_info,
+					    unsigned char q_num, size_t buf_sz)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_PKTINFO_CON2);
+	value &= ~DPMAIF_BAT_BUF_SZ_MSK;
+	value |= FIELD_PREP(DPMAIF_BAT_BUF_SZ_MSK, buf_sz / DPMAIF_BAT_BUFFER_SZ_BASE);
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_DL_PKTINFO_CON2);
+}
+
+static void t7xx_dpmaif_dl_set_ao_bat_rsv_length(struct dpmaif_hw_info *hw_info,
+						 unsigned char q_num, unsigned int length)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_PKTINFO_CON2);
+	value &= ~DPMAIF_BAT_RSV_LEN_MSK;
+	value |= length & DPMAIF_BAT_RSV_LEN_MSK;
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_DL_PKTINFO_CON2);
+}
+
+static void t7xx_dpmaif_dl_set_pkt_alignment(struct dpmaif_hw_info *hw_info, unsigned char q_num,
+					     bool enable, unsigned int mode)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_THRES);
+	value &= ~DPMAIF_PKT_ALIGN_MSK;
+
+	if (enable) {
+		value |= DPMAIF_PKT_ALIGN_EN;
+		value |= FIELD_PREP(DPMAIF_PKT_ALIGN_MSK, mode);
+	}
+
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_THRES);
+}
+
+static void t7xx_dpmaif_dl_set_pkt_checksum(struct dpmaif_hw_info *hw_info)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_THRES);
+	value |= DPMAIF_DL_PKT_CHECKSUM_EN;
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_THRES);
+}
+
+static void t7xx_dpmaif_dl_set_ao_frg_check_thres(struct dpmaif_hw_info *hw_info,
+						  unsigned char q_num, unsigned int size)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_FRG_THRES);
+	value &= ~DPMAIF_FRG_CHECK_THRES_MSK;
+	value |= (size & DPMAIF_FRG_CHECK_THRES_MSK);
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_FRG_THRES);
+}
+
+static void t7xx_dpmaif_dl_set_ao_frg_bufsz(struct dpmaif_hw_info *hw_info,
+					    unsigned char q_num, unsigned int buf_sz)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_FRG_THRES);
+	value &= ~DPMAIF_FRG_BUF_SZ_MSK;
+	value |= FIELD_PREP(DPMAIF_FRG_BUF_SZ_MSK, buf_sz / DPMAIF_FRG_BUFFER_SZ_BASE);
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_FRG_THRES);
+}
+
+static void t7xx_dpmaif_dl_frg_ao_en(struct dpmaif_hw_info *hw_info, unsigned char q_num,
+				     bool enable)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_FRG_THRES);
+
+	if (enable)
+		value |= DPMAIF_FRG_EN_MSK;
+	else
+		value &= ~DPMAIF_FRG_EN_MSK;
+
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_FRG_THRES);
+}
+
+static void t7xx_dpmaif_dl_set_ao_bat_check_thres(struct dpmaif_hw_info *hw_info,
+						  unsigned char q_num, unsigned int size)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_THRES);
+	value &= ~DPMAIF_BAT_CHECK_THRES_MSK;
+	value |= FIELD_PREP(DPMAIF_BAT_CHECK_THRES_MSK, size);
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_THRES);
+}
+
+static void t7xx_dpmaif_dl_set_pit_seqnum(struct dpmaif_hw_info *hw_info,
+					  unsigned char q_num, unsigned int seq)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_PIT_SEQ_END);
+	value &= ~DPMAIF_DL_PIT_SEQ_MSK;
+	value |= seq & DPMAIF_DL_PIT_SEQ_MSK;
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_DL_PIT_SEQ_END);
+}
+
+static void t7xx_dpmaif_dl_set_dlq_pit_base_addr(struct dpmaif_hw_info *hw_info,
+						 unsigned char q_num, dma_addr_t addr)
+{
+	iowrite32(lower_32_bits(addr), hw_info->pcie_base + DPMAIF_DL_DLQPIT_INIT_CON0);
+	iowrite32(upper_32_bits(addr), hw_info->pcie_base + DPMAIF_DL_DLQPIT_INIT_CON4);
+}
+
+static void t7xx_dpmaif_dl_set_dlq_pit_size(struct dpmaif_hw_info *hw_info,
+					    unsigned char q_num, unsigned int size)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_DL_DLQPIT_INIT_CON1);
+	value &= ~DPMAIF_PIT_SIZE_MSK;
+	value |= size & DPMAIF_PIT_SIZE_MSK;
+	iowrite32(value, hw_info->pcie_base + DPMAIF_DL_DLQPIT_INIT_CON1);
+	iowrite32(0, hw_info->pcie_base + DPMAIF_DL_DLQPIT_INIT_CON2);
+	iowrite32(0, hw_info->pcie_base + DPMAIF_DL_DLQPIT_INIT_CON3);
+	iowrite32(0, hw_info->pcie_base + DPMAIF_DL_DLQPIT_INIT_CON5);
+	iowrite32(0, hw_info->pcie_base + DPMAIF_DL_DLQPIT_INIT_CON6);
+}
+
+static void t7xx_dpmaif_dl_dlq_pit_en(struct dpmaif_hw_info *hw_info, unsigned char q_num,
+				      bool enable)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_DL_DLQPIT_INIT_CON3);
+
+	if (enable)
+		value |= DPMAIF_DLQPIT_EN_MSK;
+	else
+		value &= ~DPMAIF_DLQPIT_EN_MSK;
+
+	iowrite32(value, hw_info->pcie_base + DPMAIF_DL_DLQPIT_INIT_CON3);
+}
+
+static void t7xx_dpmaif_dl_dlq_pit_init_done(struct dpmaif_ctrl *dpmaif_ctrl,
+					     unsigned char q_num, unsigned int pit_idx)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	unsigned int dl_pit_init;
+	int timeout;
+	u32 value;
+
+	dl_pit_init = DPMAIF_DL_PIT_INIT_ALLSET;
+	dl_pit_init |= (pit_idx << DPMAIF_DLQPIT_CHAN_OFS);
+	dl_pit_init |= DPMAIF_DL_PIT_INIT_EN;
+
+	timeout = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_DL_DLQPIT_INIT,
+					       value, !(value & DPMAIF_DL_PIT_INIT_NOT_READY),
+					       DPMAIF_CHECK_DELAY_US,
+					       DPMAIF_CHECK_INIT_TIMEOUT_US);
+	if (timeout) {
+		dev_err(dpmaif_ctrl->dev, "Data plane modem DL PIT is not ready\n");
+		return;
+	}
+
+	iowrite32(dl_pit_init, hw_info->pcie_base + DPMAIF_DL_DLQPIT_INIT);
+	timeout = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_DL_DLQPIT_INIT,
+					       value, !(value & DPMAIF_DL_PIT_INIT_NOT_READY),
+					       DPMAIF_CHECK_DELAY_US,
+					       DPMAIF_CHECK_INIT_TIMEOUT_US);
+	if (timeout)
+		dev_err(dpmaif_ctrl->dev, "Data plane modem DL PIT initialization failed\n");
+}
+
+static void t7xx_dpmaif_config_dlq_pit_hw(struct dpmaif_ctrl *dpmaif_ctrl, unsigned char q_num,
+					  struct dpmaif_dl *dl_que)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	unsigned int pit_idx = q_num;
+
+	t7xx_dpmaif_dl_set_dlq_pit_base_addr(hw_info, q_num, dl_que->pit_base);
+	t7xx_dpmaif_dl_set_dlq_pit_size(hw_info, q_num, dl_que->pit_size_cnt);
+	t7xx_dpmaif_dl_dlq_pit_en(hw_info, q_num, true);
+	t7xx_dpmaif_dl_dlq_pit_init_done(dpmaif_ctrl, q_num, pit_idx);
+}
+
+static void t7xx_dpmaif_config_all_dlq_hw(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	int i;
+
+	for (i = 0; i < DPMAIF_RXQ_NUM; i++)
+		t7xx_dpmaif_config_dlq_pit_hw(dpmaif_ctrl, i, &hw_info->dl_que[i]);
+}
+
+static void t7xx_dpmaif_dl_all_q_en(struct dpmaif_ctrl *dpmaif_ctrl, bool enable)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	u32 dl_bat_init, value;
+	int timeout;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_DL_BAT_INIT_CON1);
+
+	if (enable)
+		value |= DPMAIF_BAT_EN_MSK;
+	else
+		value &= ~DPMAIF_BAT_EN_MSK;
+
+	iowrite32(value, hw_info->pcie_base + DPMAIF_DL_BAT_INIT_CON1);
+	dl_bat_init = DPMAIF_DL_BAT_INIT_ONLY_ENABLE_BIT;
+	dl_bat_init |= DPMAIF_DL_BAT_INIT_EN;
+
+	timeout = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_DL_BAT_INIT,
+					       value, !(value & DPMAIF_DL_BAT_INIT_NOT_READY), 0,
+					       DPMAIF_CHECK_TIMEOUT_US);
+	if (timeout)
+		dev_err(dpmaif_ctrl->dev, "Timeout updating BAT setting to HW\n");
+
+	iowrite32(dl_bat_init, hw_info->pcie_base + DPMAIF_DL_BAT_INIT);
+	timeout = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_DL_BAT_INIT,
+					       value, !(value & DPMAIF_DL_BAT_INIT_NOT_READY), 0,
+					       DPMAIF_CHECK_TIMEOUT_US);
+	if (timeout)
+		dev_err(dpmaif_ctrl->dev, "Data plane modem DL BAT is not ready\n");
+}
+
+static int t7xx_dpmaif_config_dlq_hw(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	struct dpmaif_dl_hwq *dl_hw;
+	struct dpmaif_dl *dl_que;
+	unsigned int queue = 0; /* All queues share one BAT/frag BAT table */
+	int ret;
+
+	t7xx_dpmaif_dl_dlq_hpc_hw_init(hw_info);
+	dl_hw = &hw_info->dl_que_hw[queue];
+
+	dl_que = &hw_info->dl_que[queue];
+	if (!dl_que->que_started)
+		return -EBUSY;
+
+	t7xx_dpmaif_dl_set_ao_remain_minsz(hw_info, queue, dl_hw->bat_remain_size);
+	t7xx_dpmaif_dl_set_ao_bat_bufsz(hw_info, queue, dl_hw->bat_pkt_bufsz);
+	t7xx_dpmaif_dl_set_ao_frg_bufsz(hw_info, queue, dl_hw->frg_pkt_bufsz);
+	t7xx_dpmaif_dl_set_ao_bat_rsv_length(hw_info, queue, dl_hw->bat_rsv_length);
+	t7xx_dpmaif_dl_set_ao_bid_maxcnt(hw_info, queue, dl_hw->pkt_bid_max_cnt);
+
+	if (dl_hw->pkt_alignment == 64)
+		t7xx_dpmaif_dl_set_pkt_alignment(hw_info, queue, true, DPMAIF_PKT_ALIGN64_MODE);
+	else if (dl_hw->pkt_alignment == 128)
+		t7xx_dpmaif_dl_set_pkt_alignment(hw_info, queue, true, DPMAIF_PKT_ALIGN128_MODE);
+	else
+		t7xx_dpmaif_dl_set_pkt_alignment(hw_info, queue, false, 0);
+
+	t7xx_dpmaif_dl_set_pit_seqnum(hw_info, queue, DPMAIF_DL_PIT_SEQ_VALUE);
+	t7xx_dpmaif_dl_set_ao_mtu(hw_info, dl_hw->mtu_size);
+	t7xx_dpmaif_dl_set_ao_pit_chknum(hw_info, queue, dl_hw->chk_pit_num);
+	t7xx_dpmaif_dl_set_ao_bat_check_thres(hw_info, queue, dl_hw->chk_bat_num);
+	t7xx_dpmaif_dl_set_ao_frg_check_thres(hw_info, queue, dl_hw->chk_frg_num);
+	t7xx_dpmaif_dl_frg_ao_en(hw_info, queue, true);
+
+	t7xx_dpmaif_dl_set_bat_base_addr(hw_info, queue, dl_que->frg_base);
+	t7xx_dpmaif_dl_set_bat_size(hw_info, queue, dl_que->frg_size_cnt);
+	t7xx_dpmaif_dl_bat_en(hw_info, queue, true);
+
+	ret = t7xx_dpmaif_dl_bat_init_done(dpmaif_ctrl, queue, true);
+	if (ret)
+		return ret;
+
+	t7xx_dpmaif_dl_set_bat_base_addr(hw_info, queue, dl_que->bat_base);
+	t7xx_dpmaif_dl_set_bat_size(hw_info, queue, dl_que->bat_size_cnt);
+	t7xx_dpmaif_dl_bat_en(hw_info, queue, false);
+
+	ret = t7xx_dpmaif_dl_bat_init_done(dpmaif_ctrl, queue, false);
+	if (ret)
+		return ret;
+
+	/* Init PIT (two PIT table) */
+	t7xx_dpmaif_config_all_dlq_hw(dpmaif_ctrl);
+	t7xx_dpmaif_dl_all_q_en(dpmaif_ctrl, true);
+	t7xx_dpmaif_dl_set_pkt_checksum(hw_info);
+	return 0;
+}
+
+static void t7xx_dpmaif_ul_update_drb_size(struct dpmaif_hw_info *hw_info,
+					   unsigned char q_num, unsigned int size)
+{
+	unsigned int value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_UL_DRBSIZE_ADDRH_n(q_num));
+	value &= ~DPMAIF_DRB_SIZE_MSK;
+	value |= size & DPMAIF_DRB_SIZE_MSK;
+	iowrite32(value, hw_info->pcie_base + DPMAIF_UL_DRBSIZE_ADDRH_n(q_num));
+}
+
+static void t7xx_dpmaif_ul_update_drb_base_addr(struct dpmaif_hw_info *hw_info,
+						unsigned char q_num, dma_addr_t addr)
+{
+	iowrite32(lower_32_bits(addr), hw_info->pcie_base + DPMAIF_ULQSAR_n(q_num));
+	iowrite32(upper_32_bits(addr), hw_info->pcie_base + DPMAIF_UL_DRB_ADDRH_n(q_num));
+}
+
+static void t7xx_dpmaif_ul_rdy_en(struct dpmaif_hw_info *hw_info,
+				  unsigned char q_num, bool ready)
+{
+	u32 value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_UL_CHNL_ARB0);
+
+	if (ready)
+		value |= BIT(q_num);
+	else
+		value &= ~BIT(q_num);
+
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_UL_CHNL_ARB0);
+}
+
+static void t7xx_dpmaif_ul_arb_en(struct dpmaif_hw_info *hw_info,
+				  unsigned char q_num, bool enable)
+{
+	u32 value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_UL_CHNL_ARB0);
+
+	if (enable)
+		value |= BIT(q_num + 8);
+	else
+		value &= ~BIT(q_num + 8);
+
+	iowrite32(value, hw_info->pcie_base + DPMAIF_AO_UL_CHNL_ARB0);
+}
+
+static void t7xx_dpmaif_config_ulq_hw(struct dpmaif_hw_info *hw_info)
+{
+	struct dpmaif_ul *ul_que;
+	int i;
+
+	for (i = 0; i < DPMAIF_TXQ_NUM; i++) {
+		ul_que = &hw_info->ul_que[i];
+		if (ul_que->que_started) {
+			t7xx_dpmaif_ul_update_drb_size(hw_info, i, ul_que->drb_size_cnt *
+						       DPMAIF_UL_DRB_ENTRY_WORD);
+			t7xx_dpmaif_ul_update_drb_base_addr(hw_info, i, ul_que->drb_base);
+			t7xx_dpmaif_ul_rdy_en(hw_info, i, true);
+			t7xx_dpmaif_ul_arb_en(hw_info, i, true);
+		} else {
+			t7xx_dpmaif_ul_arb_en(hw_info, i, false);
+		}
+	}
+}
+
+static int t7xx_dpmaif_hw_init_done(struct dpmaif_hw_info *hw_info)
+{
+	u32 ap_cfg;
+	int ret;
+
+	ap_cfg = ioread32(hw_info->pcie_base + DPMAIF_AP_OVERWRITE_CFG);
+	ap_cfg |= DPMAIF_SRAM_SYNC;
+	iowrite32(ap_cfg, hw_info->pcie_base + DPMAIF_AP_OVERWRITE_CFG);
+
+	ret = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_AP_OVERWRITE_CFG,
+					   ap_cfg, !(ap_cfg & DPMAIF_SRAM_SYNC), 0,
+					   DPMAIF_CHECK_TIMEOUT_US);
+	if (ret)
+		return ret;
+
+	iowrite32(DPMAIF_UL_INIT_DONE, hw_info->pcie_base + DPMAIF_AO_UL_INIT_SET);
+	iowrite32(DPMAIF_DL_INIT_DONE, hw_info->pcie_base + DPMAIF_AO_DL_INIT_SET);
+	return 0;
+}
+
+static bool t7xx_dpmaif_dl_idle_check(struct dpmaif_hw_info *hw_info)
+{
+	u32 dpmaif_dl_is_busy = ioread32(hw_info->pcie_base + DPMAIF_DL_CHK_BUSY);
+
+	return !(dpmaif_dl_is_busy & DPMAIF_DL_IDLE_STS);
+}
+
+static void t7xx_dpmaif_ul_all_q_en(struct dpmaif_hw_info *hw_info, bool enable)
+{
+	u32 ul_arb_en = ioread32(hw_info->pcie_base + DPMAIF_AO_UL_CHNL_ARB0);
+
+	if (enable)
+		ul_arb_en |= DPMAIF_UL_ALL_QUE_ARB_EN;
+	else
+		ul_arb_en &= ~DPMAIF_UL_ALL_QUE_ARB_EN;
+
+	iowrite32(ul_arb_en, hw_info->pcie_base + DPMAIF_AO_UL_CHNL_ARB0);
+}
+
+static bool t7xx_dpmaif_ul_idle_check(struct dpmaif_hw_info *hw_info)
+{
+	u32 dpmaif_ul_is_busy = ioread32(hw_info->pcie_base + DPMAIF_UL_CHK_BUSY);
+
+	return !(dpmaif_ul_is_busy & DPMAIF_UL_IDLE_STS);
+}
+
+ /* DPMAIF UL Part HW setting */
+
+int t7xx_dpmaif_ul_update_hw_drb_cnt(struct dpmaif_ctrl *dpmaif_ctrl, unsigned char q_num,
+				     unsigned int drb_entry_cnt)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	u32 ul_update, value;
+	int ret;
+
+	ul_update = drb_entry_cnt & DPMAIF_UL_ADD_COUNT_MASK;
+	ul_update |= DPMAIF_UL_ADD_UPDATE;
+
+	ret = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_ULQ_ADD_DESC_CH_n(q_num),
+					   value, !(value & DPMAIF_UL_ADD_NOT_READY), 0,
+					   DPMAIF_CHECK_TIMEOUT_US);
+	if (ret) {
+		dev_err(dpmaif_ctrl->dev, "UL add is not ready\n");
+		return ret;
+	}
+
+	iowrite32(ul_update, hw_info->pcie_base + DPMAIF_ULQ_ADD_DESC_CH_n(q_num));
+
+	ret = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_ULQ_ADD_DESC_CH_n(q_num),
+					   value, !(value & DPMAIF_UL_ADD_NOT_READY), 0,
+					   DPMAIF_CHECK_TIMEOUT_US);
+	if (ret) {
+		dev_err(dpmaif_ctrl->dev, "Timeout updating UL add\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+unsigned int t7xx_dpmaif_ul_get_rd_idx(struct dpmaif_hw_info *hw_info, unsigned char q_num)
+{
+	unsigned int value = ioread32(hw_info->pcie_base + DPMAIF_ULQ_STA0_n(q_num));
+
+	return value >> DPMAIF_UL_DRB_RIDX_OFFSET;
+}
+
+int t7xx_dpmaif_dlq_add_pit_remain_cnt(struct dpmaif_ctrl *dpmaif_ctrl, unsigned int dlq_pit_idx,
+				       unsigned int pit_remain_cnt)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	u32 dl_update, value;
+	int ret;
+
+	dl_update = pit_remain_cnt & DPMAIF_PIT_REM_CNT_MSK;
+	dl_update |= DPMAIF_DL_ADD_UPDATE | (dlq_pit_idx << DPMAIF_ADD_DLQ_PIT_CHAN_OFS);
+
+	ret = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_DL_DLQPIT_ADD,
+					   value, !(value & DPMAIF_DL_ADD_NOT_READY), 0,
+					   DPMAIF_CHECK_TIMEOUT_US);
+	if (ret) {
+		dev_err(dpmaif_ctrl->dev, "Data plane modem is not ready to add dlq\n");
+		return ret;
+	}
+
+	iowrite32(dl_update, hw_info->pcie_base + DPMAIF_DL_DLQPIT_ADD);
+
+	ret = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_DL_DLQPIT_ADD,
+					   value, !(value & DPMAIF_DL_ADD_NOT_READY), 0,
+					   DPMAIF_CHECK_TIMEOUT_US);
+	if (ret) {
+		dev_err(dpmaif_ctrl->dev, "Data plane modem add dlq failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+unsigned int t7xx_dpmaif_dl_dlq_pit_get_wr_idx(struct dpmaif_hw_info *hw_info,
+					       unsigned int dlq_pit_idx)
+{
+	u32 value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_DLQ_WRIDX +
+			 dlq_pit_idx * DLQ_PIT_IDX_SIZE);
+	return value & DPMAIF_DL_PIT_WRIDX_MSK;
+}
+
+static bool t7xx_dl_add_timedout(struct dpmaif_hw_info *hw_info)
+{
+	u32 value;
+	int ret;
+
+	ret = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_DL_BAT_ADD,
+					   value, !(value & DPMAIF_DL_ADD_NOT_READY), 0,
+					   DPMAIF_CHECK_TIMEOUT_US);
+	return !!ret;
+}
+
+int t7xx_dpmaif_dl_snd_hw_bat_cnt(struct dpmaif_ctrl *dpmaif_ctrl, unsigned int bat_entry_cnt)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	unsigned int value;
+
+	if (t7xx_dl_add_timedout(hw_info)) {
+		dev_err(dpmaif_ctrl->dev, "DL add BAT not ready\n");
+		return -EBUSY;
+	}
+
+	value = bat_entry_cnt & DPMAIF_DL_ADD_COUNT_MASK;
+	value |= DPMAIF_DL_ADD_UPDATE;
+	iowrite32(value, hw_info->pcie_base + DPMAIF_DL_BAT_ADD);
+
+	if (t7xx_dl_add_timedout(hw_info)) {
+		dev_err(dpmaif_ctrl->dev, "DL add BAT timeout\n");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+unsigned int t7xx_dpmaif_dl_get_bat_rd_idx(struct dpmaif_hw_info *hw_info, unsigned char q_num)
+{
+	u32 value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_BAT_RIDX);
+	return value & DPMAIF_DL_BAT_WRIDX_MSK;
+}
+
+unsigned int t7xx_dpmaif_dl_get_bat_wr_idx(struct dpmaif_hw_info *hw_info, unsigned char q_num)
+{
+	u32 value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_BAT_WRIDX);
+	return value & DPMAIF_DL_BAT_WRIDX_MSK;
+}
+
+int t7xx_dpmaif_dl_snd_hw_frg_cnt(struct dpmaif_ctrl *dpmaif_ctrl, unsigned int frg_entry_cnt)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	unsigned int value;
+
+	if (t7xx_dl_add_timedout(hw_info)) {
+		dev_err(dpmaif_ctrl->dev, "Data plane modem is not ready to add frag DLQ\n");
+		return -EBUSY;
+	}
+
+	value = frg_entry_cnt & DPMAIF_DL_ADD_COUNT_MASK;
+	value |= DPMAIF_DL_FRG_ADD_UPDATE | DPMAIF_DL_ADD_UPDATE;
+	iowrite32(value, hw_info->pcie_base + DPMAIF_DL_BAT_ADD);
+
+	if (t7xx_dl_add_timedout(hw_info)) {
+		dev_err(dpmaif_ctrl->dev, "Data plane modem add frag DLQ failed");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+unsigned int t7xx_dpmaif_dl_get_frg_rd_idx(struct dpmaif_hw_info *hw_info, unsigned char q_num)
+{
+	u32 value;
+
+	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_FRGBAT_WRIDX);
+	return value & DPMAIF_DL_FRG_WRIDX_MSK;
+}
+
+static void t7xx_dpmaif_set_queue_property(struct dpmaif_hw_info *hw_info,
+					   struct dpmaif_hw_params *init_para)
+{
+	struct dpmaif_dl_hwq *dl_hwq;
+	struct dpmaif_dl *dl_que;
+	struct dpmaif_ul *ul_que;
+	int i;
+
+	for (i = 0; i < DPMAIF_RXQ_NUM; i++) {
+		dl_hwq = &hw_info->dl_que_hw[i];
+		dl_hwq->bat_remain_size = DPMAIF_HW_BAT_REMAIN;
+		dl_hwq->bat_pkt_bufsz = DPMAIF_HW_BAT_PKTBUF;
+		dl_hwq->frg_pkt_bufsz = DPMAIF_HW_FRG_PKTBUF;
+		dl_hwq->bat_rsv_length = DPMAIF_HW_BAT_RSVLEN;
+		dl_hwq->pkt_bid_max_cnt = DPMAIF_HW_PKT_BIDCNT;
+		dl_hwq->pkt_alignment = DPMAIF_HW_PKT_ALIGN;
+		dl_hwq->mtu_size = DPMAIF_HW_MTU_SIZE;
+		dl_hwq->chk_bat_num = DPMAIF_HW_CHK_BAT_NUM;
+		dl_hwq->chk_frg_num = DPMAIF_HW_CHK_FRG_NUM;
+		dl_hwq->chk_pit_num = DPMAIF_HW_CHK_PIT_NUM;
+
+		dl_que = &hw_info->dl_que[i];
+		dl_que->bat_base = init_para->pkt_bat_base_addr[i];
+		dl_que->bat_size_cnt = init_para->pkt_bat_size_cnt[i];
+		dl_que->pit_base = init_para->pit_base_addr[i];
+		dl_que->pit_size_cnt = init_para->pit_size_cnt[i];
+		dl_que->frg_base = init_para->frg_bat_base_addr[i];
+		dl_que->frg_size_cnt = init_para->frg_bat_size_cnt[i];
+		dl_que->que_started = true;
+	}
+
+	for (i = 0; i < DPMAIF_TXQ_NUM; i++) {
+		ul_que = &hw_info->ul_que[i];
+		ul_que->drb_base = init_para->drb_base_addr[i];
+		ul_que->drb_size_cnt = init_para->drb_size_cnt[i];
+		ul_que->que_started = true;
+	}
+}
+
+/**
+ * t7xx_dpmaif_hw_stop_all_txq() - Stop all TX queues.
+ * @dpmaif_ctrl: Pointer to struct dpmaif_ctrl.
+ *
+ * Disable HW UL queues. Checks busy UL queues to go to idle
+ * with an attempt count of 1000000.
+ *
+ * Return:
+ * * 0			- Success
+ * * -ETIMEDOUT		- Timed out checking busy queues
+ */
+int t7xx_dpmaif_hw_stop_all_txq(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	int count = 0;
+
+	t7xx_dpmaif_ul_all_q_en(hw_info, false);
+	while (t7xx_dpmaif_ul_idle_check(hw_info)) {
+		if (++count >= DPMAIF_MAX_CHECK_COUNT) {
+			dev_err(dpmaif_ctrl->dev, "Failed to stop TX, status: 0x%x\n",
+				ioread32(hw_info->pcie_base + DPMAIF_UL_CHK_BUSY));
+			return -ETIMEDOUT;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * t7xx_dpmaif_hw_stop_all_rxq() - Stop all RX queues.
+ * @dpmaif_ctrl: Pointer to struct dpmaif_ctrl.
+ *
+ * Disable HW DL queue. Checks busy UL queues to go to idle
+ * with an attempt count of 1000000.
+ * Check that HW PIT write index equals read index with the same
+ * attempt count.
+ *
+ * Return:
+ * * 0			- Success.
+ * * -ETIMEDOUT		- Timed out checking busy queues.
+ */
+int t7xx_dpmaif_hw_stop_all_rxq(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	unsigned int wr_idx, rd_idx;
+	int count = 0;
+
+	t7xx_dpmaif_dl_all_q_en(dpmaif_ctrl, false);
+	while (t7xx_dpmaif_dl_idle_check(hw_info)) {
+		if (++count >= DPMAIF_MAX_CHECK_COUNT) {
+			dev_err(dpmaif_ctrl->dev, "Failed to stop RX, status: 0x%x\n",
+				ioread32(hw_info->pcie_base + DPMAIF_DL_CHK_BUSY));
+			return -ETIMEDOUT;
+		}
+	}
+
+	/* Check middle PIT sync done */
+	count = 0;
+	do {
+		wr_idx = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_PIT_WRIDX);
+		wr_idx &= DPMAIF_DL_PIT_WRIDX_MSK;
+		rd_idx = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_PIT_RIDX);
+		rd_idx &= DPMAIF_DL_PIT_WRIDX_MSK;
+
+		if (wr_idx == rd_idx)
+			return 0;
+	} while (++count < DPMAIF_MAX_CHECK_COUNT);
+
+	dev_err(dpmaif_ctrl->dev, "Check middle PIT sync fail\n");
+	return -ETIMEDOUT;
+}
+
+void t7xx_dpmaif_start_hw(struct dpmaif_ctrl *dpmaif_ctrl)
+{
+	t7xx_dpmaif_ul_all_q_en(&dpmaif_ctrl->hif_hw_info, true);
+	t7xx_dpmaif_dl_all_q_en(dpmaif_ctrl, true);
+}
+
+/**
+ * t7xx_dpmaif_hw_init() - Initialize HW data path API.
+ * @dpmaif_ctrl: Pointer to struct dpmaif_ctrl.
+ * @init_param: Pointer to struct dpmaif_hw_params.
+ *
+ * Configures port mode, clock config, HW interrupt initialization, and HW queue.
+ *
+ * Return:
+ * * 0		- Success.
+ * * -ERROR	- Error code from failure sub-initializations.
+ */
+int t7xx_dpmaif_hw_init(struct dpmaif_ctrl *dpmaif_ctrl, struct dpmaif_hw_params *init_param)
+{
+	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
+	int ret;
+
+	ret = t7xx_dpmaif_hw_config(hw_info);
+	if (ret) {
+		dev_err(dpmaif_ctrl->dev, "DPMAIF HW config failed\n");
+		return ret;
+	}
+
+	ret = t7xx_dpmaif_init_intr(hw_info);
+	if (ret) {
+		dev_err(dpmaif_ctrl->dev, "DPMAIF HW interrupts init failed\n");
+		return ret;
+	}
+
+	t7xx_dpmaif_set_queue_property(hw_info, init_param);
+	t7xx_dpmaif_pcie_dpmaif_sign(hw_info);
+	t7xx_dpmaif_dl_performance(hw_info);
+
+	ret = t7xx_dpmaif_config_dlq_hw(dpmaif_ctrl);
+	if (ret) {
+		dev_err(dpmaif_ctrl->dev, "DPMAIF HW dlq config failed\n");
+		return ret;
+	}
+
+	t7xx_dpmaif_config_ulq_hw(hw_info);
+
+	ret = t7xx_dpmaif_hw_init_done(hw_info);
+	if (ret)
+		dev_err(dpmaif_ctrl->dev, "DPMAIF HW queue init failed\n");
+
+	return ret;
+}
+
+bool t7xx_dpmaif_ul_clr_done(struct dpmaif_hw_info *hw_info, unsigned char qno)
+{
+	u32 intr_status;
+
+	intr_status = ioread32(hw_info->pcie_base + DPMAIF_AP_L2TISAR0);
+	intr_status &= BIT(DP_UL_INT_DONE_OFFSET + qno);
+	if (intr_status) {
+		iowrite32(intr_status, hw_info->pcie_base + DPMAIF_AP_L2TISAR0);
+		return true;
+	}
+
+	return false;
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_dpmaif.h b/drivers/net/wwan/t7xx/t7xx_dpmaif.h
new file mode 100644
index 000000000000..da67fcbab387
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_dpmaif.h
@@ -0,0 +1,146 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *
+ * Contributors:
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#ifndef __T7XX_DPMAIF_H__
+#define __T7XX_DPMAIF_H__
+
+#include <linux/bits.h>
+#include <linux/types.h>
+
+#include "t7xx_hif_dpmaif.h"
+
+#define DPMAIF_DL_PIT_SEQ_VALUE		251
+#define DPMAIF_UL_DRB_BYTE_SIZE		16
+#define DPMAIF_UL_DRB_ENTRY_WORD	(DPMAIF_UL_DRB_BYTE_SIZE >> 2)
+
+#define DPMAIF_MAX_CHECK_COUNT		1000000
+#define DPMAIF_CHECK_TIMEOUT_US		10000
+#define DPMAIF_CHECK_INIT_TIMEOUT_US	100000
+#define DPMAIF_CHECK_DELAY_US		10
+
+/* DPMAIF HW Initialization parameter structure */
+struct dpmaif_hw_params {
+	/* UL part */
+	dma_addr_t			drb_base_addr[DPMAIF_TXQ_NUM];
+	unsigned int			drb_size_cnt[DPMAIF_TXQ_NUM];
+	/* DL part */
+	dma_addr_t			pkt_bat_base_addr[DPMAIF_RXQ_NUM];
+	unsigned int			pkt_bat_size_cnt[DPMAIF_RXQ_NUM];
+	dma_addr_t			frg_bat_base_addr[DPMAIF_RXQ_NUM];
+	unsigned int			frg_bat_size_cnt[DPMAIF_RXQ_NUM];
+	dma_addr_t			pit_base_addr[DPMAIF_RXQ_NUM];
+	unsigned int			pit_size_cnt[DPMAIF_RXQ_NUM];
+};
+
+enum dpmaif_hw_intr_type {
+	DPF_INTR_INVALID_MIN,
+	DPF_INTR_UL_DONE,
+	DPF_INTR_UL_DRB_EMPTY,
+	DPF_INTR_UL_MD_NOTREADY,
+	DPF_INTR_UL_MD_PWR_NOTREADY,
+	DPF_INTR_UL_LEN_ERR,
+	DPF_INTR_DL_DONE,
+	DPF_INTR_DL_SKB_LEN_ERR,
+	DPF_INTR_DL_BATCNT_LEN_ERR,
+	DPF_INTR_DL_PITCNT_LEN_ERR,
+	DPF_INTR_DL_PKT_EMPTY_SET,
+	DPF_INTR_DL_FRG_EMPTY_SET,
+	DPF_INTR_DL_MTU_ERR,
+	DPF_INTR_DL_FRGCNT_LEN_ERR,
+	DPF_INTR_DL_Q0_PITCNT_LEN_ERR,
+	DPF_INTR_DL_Q1_PITCNT_LEN_ERR,
+	DPF_INTR_DL_HPC_ENT_TYPE_ERR,
+	DPF_INTR_DL_Q0_DONE,
+	DPF_INTR_DL_Q1_DONE,
+	DPF_INTR_INVALID_MAX
+};
+
+#define DPF_RX_QNO0			0
+#define DPF_RX_QNO1			1
+#define DPF_RX_QNO_DFT			DPF_RX_QNO0
+
+struct dpmaif_hw_intr_st_para {
+	unsigned int intr_cnt;
+	enum dpmaif_hw_intr_type intr_types[DPF_INTR_INVALID_MAX - 1];
+	unsigned int intr_queues[DPF_INTR_INVALID_MAX - 1];
+};
+
+#define DPMAIF_HW_BAT_REMAIN		64
+#define DPMAIF_HW_BAT_PKTBUF		(128 * 28)
+#define DPMAIF_HW_FRG_PKTBUF		128
+#define DPMAIF_HW_BAT_RSVLEN		64
+#define DPMAIF_HW_PKT_BIDCNT		1
+#define DPMAIF_HW_PKT_ALIGN		64
+#define DPMAIF_HW_MTU_SIZE		(3 * 1024 + 8)
+#define DPMAIF_HW_CHK_BAT_NUM		62
+#define DPMAIF_HW_CHK_FRG_NUM		3
+#define DPMAIF_HW_CHK_PIT_NUM		(2 * DPMAIF_HW_CHK_BAT_NUM)
+
+#define DP_UL_INT_DONE_OFFSET		0
+#define DP_UL_INT_QDONE_MSK		GENMASK(4, 0)
+#define DP_UL_INT_EMPTY_MSK		GENMASK(9, 5)
+#define DP_UL_INT_MD_NOTREADY_MSK	GENMASK(14, 10)
+#define DP_UL_INT_MD_PWR_NOTREADY_MSK	GENMASK(19, 15)
+#define DP_UL_INT_ERR_MSK		GENMASK(24, 20)
+
+#define DP_DL_INT_QDONE_MSK		BIT(0)
+#define DP_DL_INT_SKB_LEN_ERR		BIT(1)
+#define DP_DL_INT_BATCNT_LEN_ERR	BIT(2)
+#define DP_DL_INT_PITCNT_LEN_ERR	BIT(3)
+#define DP_DL_INT_PKT_EMPTY_MSK		BIT(4)
+#define DP_DL_INT_FRG_EMPTY_MSK		BIT(5)
+#define DP_DL_INT_MTU_ERR_MSK		BIT(6)
+#define DP_DL_INT_FRG_LENERR_MSK	BIT(7)
+#define DP_DL_INT_Q0_PITCNT_LEN_ERR	BIT(8)
+#define DP_DL_INT_Q1_PITCNT_LEN_ERR	BIT(9)
+#define DP_DL_INT_HPC_ENT_TYPE_ERR	BIT(10)
+#define DP_DL_INT_Q0_DONE		BIT(13)
+#define DP_DL_INT_Q1_DONE		BIT(14)
+
+#define DP_DL_Q0_STATUS_MASK		(DP_DL_INT_Q0_PITCNT_LEN_ERR | DP_DL_INT_Q0_DONE)
+#define DP_DL_Q1_STATUS_MASK		(DP_DL_INT_Q1_PITCNT_LEN_ERR | DP_DL_INT_Q1_DONE)
+
+int t7xx_dpmaif_hw_init(struct dpmaif_ctrl *dpmaif_ctrl, struct dpmaif_hw_params *init_param);
+int t7xx_dpmaif_hw_stop_all_txq(struct dpmaif_ctrl *dpmaif_ctrl);
+int t7xx_dpmaif_hw_stop_all_rxq(struct dpmaif_ctrl *dpmaif_ctrl);
+void t7xx_dpmaif_start_hw(struct dpmaif_ctrl *dpmaif_ctrl);
+int t7xx_dpmaif_hw_get_intr_cnt(struct dpmaif_ctrl *dpmaif_ctrl,
+				struct dpmaif_hw_intr_st_para *para, int qno);
+void t7xx_dpmaif_unmask_ulq_intr(struct dpmaif_ctrl *dpmaif_ctrl, unsigned int q_num);
+int t7xx_dpmaif_ul_update_hw_drb_cnt(struct dpmaif_ctrl *dpmaif_ctrl, unsigned char q_num,
+				     unsigned int drb_entry_cnt);
+int t7xx_dpmaif_dl_snd_hw_bat_cnt(struct dpmaif_ctrl *dpmaif_ctrl, unsigned int bat_entry_cnt);
+int t7xx_dpmaif_dl_snd_hw_frg_cnt(struct dpmaif_ctrl *dpmaif_ctrl, unsigned int frg_entry_cnt);
+int t7xx_dpmaif_dlq_add_pit_remain_cnt(struct dpmaif_ctrl *dpmaif_ctrl, unsigned int dlq_pit_idx,
+				       unsigned int pit_remain_cnt);
+void t7xx_dpmaif_dlq_unmask_pitcnt_len_err_intr(struct dpmaif_hw_info *hw_info,
+						unsigned char qno);
+void t7xx_dpmaif_dlq_unmask_rx_done(struct dpmaif_hw_info *hw_info, unsigned char qno);
+bool t7xx_dpmaif_ul_clr_done(struct dpmaif_hw_info *hw_info, unsigned char qno);
+unsigned int t7xx_dpmaif_ul_get_rd_idx(struct dpmaif_hw_info *hw_info, unsigned char q_num);
+void t7xx_dpmaif_ul_clr_all_intr(struct dpmaif_hw_info *hw_info);
+void t7xx_dpmaif_dl_clr_all_intr(struct dpmaif_hw_info *hw_info);
+void t7xx_dpmaif_clr_ip_busy_sts(struct dpmaif_hw_info *hw_info);
+void t7xx_dpmaif_dl_unmask_batcnt_len_err_intr(struct dpmaif_hw_info *hw_info);
+void t7xx_dpmaif_dl_unmask_pitcnt_len_err_intr(struct dpmaif_hw_info *hw_info);
+unsigned int t7xx_dpmaif_dl_get_bat_rd_idx(struct dpmaif_hw_info *hw_info, unsigned char q_num);
+unsigned int t7xx_dpmaif_dl_get_bat_wr_idx(struct dpmaif_hw_info *hw_info, unsigned char q_num);
+unsigned int t7xx_dpmaif_dl_get_frg_rd_idx(struct dpmaif_hw_info *hw_info, unsigned char q_num);
+unsigned int t7xx_dpmaif_dl_dlq_pit_get_wr_idx(struct dpmaif_hw_info *hw_info,
+					       unsigned int dlq_pit_idx);
+
+#endif /* __T7XX_DPMAIF_H__ */
-- 
2.17.1

