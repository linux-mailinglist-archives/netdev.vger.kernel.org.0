Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A425D43E78
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388991AbfFMPuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:50:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18147 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731689AbfFMJOT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 05:14:19 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2FDF6C301C1D0A26ADCA;
        Thu, 13 Jun 2019 17:14:14 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 13 Jun 2019 17:14:06 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Shiju Jose <shiju.jose@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 02/12] net: hns3: fix avoid unnecessary resetting for the H/W errors which do not require reset
Date:   Thu, 13 Jun 2019 17:12:22 +0800
Message-ID: <1560417152-53050-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560417152-53050-1-git-send-email-tanhuazhong@huawei.com>
References: <1560417152-53050-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiju Jose <shiju.jose@huawei.com>

HNS does not need to be reset when errors occur in some bits.
However presently the HNAE3_FUNC_RESET is set in this case and
as a result the default_reset is done when these errors are reported.
This patch fix this issue. Also patch does some optimization
in setting the reset level for the error recovery.

Reported-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 280 ++++++++-------------
 1 file changed, 109 insertions(+), 171 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 1a2ea1b..3ea305e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -631,29 +631,20 @@ static const struct hclge_hw_error hclge_rocee_qmm_ovf_err_int[] = {
 	{ /* sentinel */ }
 };
 
-static enum hnae3_reset_type hclge_log_error(struct device *dev, char *reg,
-					     const struct hclge_hw_error *err,
-					     u32 err_sts)
+static void hclge_log_error(struct device *dev, char *reg,
+			    const struct hclge_hw_error *err,
+			    u32 err_sts, unsigned long *reset_requests)
 {
-	enum hnae3_reset_type reset_level = HNAE3_FUNC_RESET;
-	bool need_reset = false;
-
 	while (err->msg) {
 		if (err->int_msk & err_sts) {
 			dev_warn(dev, "%s %s found [error status=0x%x]\n",
 				 reg, err->msg, err_sts);
-			if (err->reset_level != HNAE3_NONE_RESET &&
-			    err->reset_level >= reset_level) {
-				reset_level = err->reset_level;
-				need_reset = true;
-			}
+			if (err->reset_level &&
+			    err->reset_level != HNAE3_NONE_RESET)
+				set_bit(err->reset_level, reset_requests);
 		}
 		err++;
 	}
-	if (need_reset)
-		return reset_level;
-	else
-		return HNAE3_NONE_RESET;
 }
 
 /* hclge_cmd_query_error: read the error information
@@ -1082,7 +1073,6 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 				      int num)
 {
 	struct hnae3_ae_dev *ae_dev = hdev->ae_dev;
-	enum hnae3_reset_type reset_level;
 	struct device *dev = &hdev->pdev->dev;
 	__le32 *desc_data;
 	u32 status;
@@ -1099,49 +1089,39 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 
 	/* log HNS common errors */
 	status = le32_to_cpu(desc[0].data[0]);
-	if (status) {
-		reset_level = hclge_log_error(dev, "IMP_TCM_ECC_INT_STS",
-					      &hclge_imp_tcm_ecc_int[0],
-					      status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "IMP_TCM_ECC_INT_STS",
+				&hclge_imp_tcm_ecc_int[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	status = le32_to_cpu(desc[0].data[1]);
-	if (status) {
-		reset_level = hclge_log_error(dev, "CMDQ_MEM_ECC_INT_STS",
-					      &hclge_cmdq_nic_mem_ecc_int[0],
-					      status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "CMDQ_MEM_ECC_INT_STS",
+				&hclge_cmdq_nic_mem_ecc_int[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	if ((le32_to_cpu(desc[0].data[2])) & BIT(0))
 		dev_warn(dev, "imp_rd_data_poison_err found\n");
 
 	status = le32_to_cpu(desc[0].data[3]);
-	if (status) {
-		reset_level = hclge_log_error(dev, "TQP_INT_ECC_INT_STS",
-					      &hclge_tqp_int_ecc_int[0],
-					      status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "TQP_INT_ECC_INT_STS",
+				&hclge_tqp_int_ecc_int[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	status = le32_to_cpu(desc[0].data[4]);
-	if (status) {
-		reset_level = hclge_log_error(dev, "MSIX_ECC_INT_STS",
-					      &hclge_msix_sram_ecc_int[0],
-					      status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "MSIX_ECC_INT_STS",
+				&hclge_msix_sram_ecc_int[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	/* log SSU(Storage Switch Unit) errors */
 	desc_data = (__le32 *)&desc[2];
 	status = le32_to_cpu(*(desc_data + 2));
-	if (status) {
-		reset_level = hclge_log_error(dev, "SSU_ECC_MULTI_BIT_INT_0",
-					      &hclge_ssu_mem_ecc_err_int[0],
-					      status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "SSU_ECC_MULTI_BIT_INT_0",
+				&hclge_ssu_mem_ecc_err_int[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	status = le32_to_cpu(*(desc_data + 3)) & BIT(0);
 	if (status) {
@@ -1151,41 +1131,32 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 	}
 
 	status = le32_to_cpu(*(desc_data + 4)) & HCLGE_SSU_COMMON_ERR_INT_MASK;
-	if (status) {
-		reset_level = hclge_log_error(dev, "SSU_COMMON_ERR_INT",
-					      &hclge_ssu_com_err_int[0],
-					      status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "SSU_COMMON_ERR_INT",
+				&hclge_ssu_com_err_int[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	/* log IGU(Ingress Unit) errors */
 	desc_data = (__le32 *)&desc[3];
 	status = le32_to_cpu(*desc_data) & HCLGE_IGU_INT_MASK;
-	if (status) {
-		reset_level = hclge_log_error(dev, "IGU_INT_STS",
-					      &hclge_igu_int[0], status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "IGU_INT_STS",
+				&hclge_igu_int[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	/* log PPP(Programmable Packet Process) errors */
 	desc_data = (__le32 *)&desc[4];
 	status = le32_to_cpu(*(desc_data + 1));
-	if (status) {
-		reset_level =
-			hclge_log_error(dev, "PPP_MPF_ABNORMAL_INT_ST1",
-					&hclge_ppp_mpf_abnormal_int_st1[0],
-					status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "PPP_MPF_ABNORMAL_INT_ST1",
+				&hclge_ppp_mpf_abnormal_int_st1[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	status = le32_to_cpu(*(desc_data + 3)) & HCLGE_PPP_MPF_INT_ST3_MASK;
-	if (status) {
-		reset_level =
-			hclge_log_error(dev, "PPP_MPF_ABNORMAL_INT_ST3",
-					&hclge_ppp_mpf_abnormal_int_st3[0],
-					status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "PPP_MPF_ABNORMAL_INT_ST3",
+				&hclge_ppp_mpf_abnormal_int_st3[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	/* log PPU(RCB) errors */
 	desc_data = (__le32 *)&desc[5];
@@ -1197,57 +1168,46 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 	}
 
 	status = le32_to_cpu(*(desc_data + 2));
-	if (status) {
-		reset_level =
-			hclge_log_error(dev, "PPU_MPF_ABNORMAL_INT_ST2",
-					&hclge_ppu_mpf_abnormal_int_st2[0],
-					status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "PPU_MPF_ABNORMAL_INT_ST2",
+				&hclge_ppu_mpf_abnormal_int_st2[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	status = le32_to_cpu(*(desc_data + 3)) & HCLGE_PPU_MPF_INT_ST3_MASK;
-	if (status) {
-		reset_level =
-			hclge_log_error(dev, "PPU_MPF_ABNORMAL_INT_ST3",
-					&hclge_ppu_mpf_abnormal_int_st3[0],
-					status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "PPU_MPF_ABNORMAL_INT_ST3",
+				&hclge_ppu_mpf_abnormal_int_st3[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	/* log TM(Traffic Manager) errors */
 	desc_data = (__le32 *)&desc[6];
 	status = le32_to_cpu(*desc_data);
-	if (status) {
-		reset_level = hclge_log_error(dev, "TM_SCH_RINT",
-					      &hclge_tm_sch_rint[0], status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "TM_SCH_RINT",
+				&hclge_tm_sch_rint[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	/* log QCN(Quantized Congestion Control) errors */
 	desc_data = (__le32 *)&desc[7];
 	status = le32_to_cpu(*desc_data) & HCLGE_QCN_FIFO_INT_MASK;
-	if (status) {
-		reset_level = hclge_log_error(dev, "QCN_FIFO_RINT",
-					      &hclge_qcn_fifo_rint[0], status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "QCN_FIFO_RINT",
+				&hclge_qcn_fifo_rint[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	status = le32_to_cpu(*(desc_data + 1)) & HCLGE_QCN_ECC_INT_MASK;
-	if (status) {
-		reset_level = hclge_log_error(dev, "QCN_ECC_RINT",
-					      &hclge_qcn_ecc_rint[0],
-					      status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "QCN_ECC_RINT",
+				&hclge_qcn_ecc_rint[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	/* log NCSI errors */
 	desc_data = (__le32 *)&desc[9];
 	status = le32_to_cpu(*desc_data) & HCLGE_NCSI_ECC_INT_MASK;
-	if (status) {
-		reset_level = hclge_log_error(dev, "NCSI_ECC_INT_RPT",
-					      &hclge_ncsi_err_int[0], status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "NCSI_ECC_INT_RPT",
+				&hclge_ncsi_err_int[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	/* clear all main PF RAS errors */
 	hclge_cmd_reuse_desc(&desc[0], false);
@@ -1272,7 +1232,6 @@ static int hclge_handle_pf_ras_error(struct hclge_dev *hdev,
 {
 	struct hnae3_ae_dev *ae_dev = hdev->ae_dev;
 	struct device *dev = &hdev->pdev->dev;
-	enum hnae3_reset_type reset_level;
 	__le32 *desc_data;
 	u32 status;
 	int ret;
@@ -1288,48 +1247,38 @@ static int hclge_handle_pf_ras_error(struct hclge_dev *hdev,
 
 	/* log SSU(Storage Switch Unit) errors */
 	status = le32_to_cpu(desc[0].data[0]);
-	if (status) {
-		reset_level = hclge_log_error(dev, "SSU_PORT_BASED_ERR_INT",
-					      &hclge_ssu_port_based_err_int[0],
-					      status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "SSU_PORT_BASED_ERR_INT",
+				&hclge_ssu_port_based_err_int[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	status = le32_to_cpu(desc[0].data[1]);
-	if (status) {
-		reset_level = hclge_log_error(dev, "SSU_FIFO_OVERFLOW_INT",
-					      &hclge_ssu_fifo_overflow_int[0],
-					      status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "SSU_FIFO_OVERFLOW_INT",
+				&hclge_ssu_fifo_overflow_int[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	status = le32_to_cpu(desc[0].data[2]);
-	if (status) {
-		reset_level = hclge_log_error(dev, "SSU_ETS_TCG_INT",
-					      &hclge_ssu_ets_tcg_int[0],
-					      status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "SSU_ETS_TCG_INT",
+				&hclge_ssu_ets_tcg_int[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	/* log IGU(Ingress Unit) EGU(Egress Unit) TNL errors */
 	desc_data = (__le32 *)&desc[1];
 	status = le32_to_cpu(*desc_data) & HCLGE_IGU_EGU_TNL_INT_MASK;
-	if (status) {
-		reset_level = hclge_log_error(dev, "IGU_EGU_TNL_INT_STS",
-					      &hclge_igu_egu_tnl_int[0],
-					      status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "IGU_EGU_TNL_INT_STS",
+				&hclge_igu_egu_tnl_int[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	/* log PPU(RCB) errors */
 	desc_data = (__le32 *)&desc[3];
 	status = le32_to_cpu(*desc_data) & HCLGE_PPU_PF_INT_RAS_MASK;
-	if (status) {
-		reset_level = hclge_log_error(dev, "PPU_PF_ABNORMAL_INT_ST0",
-					      &hclge_ppu_pf_abnormal_int[0],
-					      status);
-		set_bit(reset_level, &ae_dev->hw_err_reset_req);
-	}
+	if (status)
+		hclge_log_error(dev, "PPU_PF_ABNORMAL_INT_ST0",
+				&hclge_ppu_pf_abnormal_int[0], status,
+				&ae_dev->hw_err_reset_req);
 
 	/* clear all PF RAS errors */
 	hclge_cmd_reuse_desc(&desc[0], false);
@@ -1671,8 +1620,9 @@ pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev)
 		hclge_handle_rocee_ras_error(ae_dev);
 	}
 
-	if (status & HCLGE_RAS_REG_NFE_MASK ||
-	    status & HCLGE_RAS_REG_ROCEE_ERR_MASK) {
+	if ((status & HCLGE_RAS_REG_NFE_MASK ||
+	     status & HCLGE_RAS_REG_ROCEE_ERR_MASK) &&
+	     ae_dev->hw_err_reset_req) {
 		ae_dev->override_pci_need_reset = 0;
 		return PCI_ERS_RESULT_NEED_RESET;
 	}
@@ -1762,7 +1712,6 @@ int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 	struct hclge_mac_tnl_stats mac_tnl_stats;
 	struct device *dev = &hdev->pdev->dev;
 	u32 mpf_bd_num, pf_bd_num, bd_num;
-	enum hnae3_reset_type reset_level;
 	struct hclge_desc desc_bd;
 	struct hclge_desc *desc;
 	__le32 *desc_data;
@@ -1800,24 +1749,19 @@ int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 	/* log MAC errors */
 	desc_data = (__le32 *)&desc[1];
 	status = le32_to_cpu(*desc_data);
-	if (status) {
-		reset_level = hclge_log_error(dev, "MAC_AFIFO_TNL_INT_R",
-					      &hclge_mac_afifo_tnl_int[0],
-					      status);
-		set_bit(reset_level, reset_requests);
-	}
+	if (status)
+		hclge_log_error(dev, "MAC_AFIFO_TNL_INT_R",
+				&hclge_mac_afifo_tnl_int[0], status,
+				reset_requests);
 
 	/* log PPU(RCB) MPF errors */
 	desc_data = (__le32 *)&desc[5];
 	status = le32_to_cpu(*(desc_data + 2)) &
 			HCLGE_PPU_MPF_INT_ST2_MSIX_MASK;
-	if (status) {
-		reset_level =
-			hclge_log_error(dev, "PPU_MPF_ABNORMAL_INT_ST2",
-					&hclge_ppu_mpf_abnormal_int_st2[0],
-					status);
-		set_bit(reset_level, reset_requests);
-	}
+	if (status)
+		hclge_log_error(dev, "PPU_MPF_ABNORMAL_INT_ST2",
+				&hclge_ppu_mpf_abnormal_int_st2[0],
+				status, reset_requests);
 
 	/* clear all main PF MSIx errors */
 	hclge_cmd_reuse_desc(&desc[0], false);
@@ -1841,32 +1785,26 @@ int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 
 	/* log SSU PF errors */
 	status = le32_to_cpu(desc[0].data[0]) & HCLGE_SSU_PORT_INT_MSIX_MASK;
-	if (status) {
-		reset_level = hclge_log_error(dev, "SSU_PORT_BASED_ERR_INT",
-					      &hclge_ssu_port_based_pf_int[0],
-					      status);
-		set_bit(reset_level, reset_requests);
-	}
+	if (status)
+		hclge_log_error(dev, "SSU_PORT_BASED_ERR_INT",
+				&hclge_ssu_port_based_pf_int[0],
+				status, reset_requests);
 
 	/* read and log PPP PF errors */
 	desc_data = (__le32 *)&desc[2];
 	status = le32_to_cpu(*desc_data);
-	if (status) {
-		reset_level = hclge_log_error(dev, "PPP_PF_ABNORMAL_INT_ST0",
-					      &hclge_ppp_pf_abnormal_int[0],
-					      status);
-		set_bit(reset_level, reset_requests);
-	}
+	if (status)
+		hclge_log_error(dev, "PPP_PF_ABNORMAL_INT_ST0",
+				&hclge_ppp_pf_abnormal_int[0],
+				status, reset_requests);
 
 	/* log PPU(RCB) PF errors */
 	desc_data = (__le32 *)&desc[3];
 	status = le32_to_cpu(*desc_data) & HCLGE_PPU_PF_INT_MSIX_MASK;
-	if (status) {
-		reset_level = hclge_log_error(dev, "PPU_PF_ABNORMAL_INT_ST",
-					      &hclge_ppu_pf_abnormal_int[0],
-					      status);
-		set_bit(reset_level, reset_requests);
-	}
+	if (status)
+		hclge_log_error(dev, "PPU_PF_ABNORMAL_INT_ST",
+				&hclge_ppu_pf_abnormal_int[0],
+				status, reset_requests);
 
 	status = le32_to_cpu(*desc_data) & HCLGE_PPU_PF_OVER_8BD_ERR_MASK;
 	if (status)
-- 
2.7.4

