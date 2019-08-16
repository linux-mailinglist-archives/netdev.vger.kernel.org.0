Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 495D28FD55
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfHPIMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:12:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50782 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726822AbfHPIMD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 04:12:03 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7F8F49FA0B1892C6A3D4;
        Fri, 16 Aug 2019 16:11:58 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 16 Aug 2019 16:11:49 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "Weihang Li" <liweihang@hisilicon.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/6] net: hns3: change print level of RAS error log from warning to error
Date:   Fri, 16 Aug 2019 16:09:40 +0800
Message-ID: <1565942982-12105-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565942982-12105-1-git-send-email-tanhuazhong@huawei.com>
References: <1565942982-12105-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

This patch changes print level of RAS error log from warning to error.
Because RAS error and its recovery process could cause application
failure. Also uses %u instead of %d when the parameter is unsigned.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 88 +++++++++++-----------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 5ce9a8a..2425b3f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -637,8 +637,8 @@ static void hclge_log_error(struct device *dev, char *reg,
 {
 	while (err->msg) {
 		if (err->int_msk & err_sts) {
-			dev_warn(dev, "%s %s found [error status=0x%x]\n",
-				 reg, err->msg, err_sts);
+			dev_err(dev, "%s %s found [error status=0x%x]\n",
+				reg, err->msg, err_sts);
 			if (err->reset_level &&
 			    err->reset_level != HNAE3_NONE_RESET)
 				set_bit(err->reset_level, reset_requests);
@@ -1163,8 +1163,8 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 
 	status = le32_to_cpu(*(desc_data + 3)) & BIT(0);
 	if (status) {
-		dev_warn(dev, "SSU_ECC_MULTI_BIT_INT_1 ssu_mem32_ecc_mbit_err found [error status=0x%x]\n",
-			 status);
+		dev_err(dev, "SSU_ECC_MULTI_BIT_INT_1 ssu_mem32_ecc_mbit_err found [error status=0x%x]\n",
+			status);
 		set_bit(HNAE3_GLOBAL_RESET, &ae_dev->hw_err_reset_req);
 	}
 
@@ -1200,8 +1200,8 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 	desc_data = (__le32 *)&desc[5];
 	status = le32_to_cpu(*(desc_data + 1));
 	if (status) {
-		dev_warn(dev, "PPU_MPF_ABNORMAL_INT_ST1 %s found\n",
-			 "rpu_rx_pkt_ecc_mbit_err");
+		dev_err(dev,
+			"PPU_MPF_ABNORMAL_INT_ST1 rpu_rx_pkt_ecc_mbit_err found\n");
 		set_bit(HNAE3_GLOBAL_RESET, &ae_dev->hw_err_reset_req);
 	}
 
@@ -1379,17 +1379,17 @@ static int hclge_log_rocee_axi_error(struct hclge_dev *hdev)
 		return ret;
 	}
 
-	dev_info(dev, "AXI1: %08X %08X %08X %08X %08X %08X\n",
-		 le32_to_cpu(desc[0].data[0]), le32_to_cpu(desc[0].data[1]),
-		 le32_to_cpu(desc[0].data[2]), le32_to_cpu(desc[0].data[3]),
-		 le32_to_cpu(desc[0].data[4]), le32_to_cpu(desc[0].data[5]));
-	dev_info(dev, "AXI2: %08X %08X %08X %08X %08X %08X\n",
-		 le32_to_cpu(desc[1].data[0]), le32_to_cpu(desc[1].data[1]),
-		 le32_to_cpu(desc[1].data[2]), le32_to_cpu(desc[1].data[3]),
-		 le32_to_cpu(desc[1].data[4]), le32_to_cpu(desc[1].data[5]));
-	dev_info(dev, "AXI3: %08X %08X %08X %08X\n",
-		 le32_to_cpu(desc[2].data[0]), le32_to_cpu(desc[2].data[1]),
-		 le32_to_cpu(desc[2].data[2]), le32_to_cpu(desc[2].data[3]));
+	dev_err(dev, "AXI1: %08X %08X %08X %08X %08X %08X\n",
+		le32_to_cpu(desc[0].data[0]), le32_to_cpu(desc[0].data[1]),
+		le32_to_cpu(desc[0].data[2]), le32_to_cpu(desc[0].data[3]),
+		le32_to_cpu(desc[0].data[4]), le32_to_cpu(desc[0].data[5]));
+	dev_err(dev, "AXI2: %08X %08X %08X %08X %08X %08X\n",
+		le32_to_cpu(desc[1].data[0]), le32_to_cpu(desc[1].data[1]),
+		le32_to_cpu(desc[1].data[2]), le32_to_cpu(desc[1].data[3]),
+		le32_to_cpu(desc[1].data[4]), le32_to_cpu(desc[1].data[5]));
+	dev_err(dev, "AXI3: %08X %08X %08X %08X\n",
+		le32_to_cpu(desc[2].data[0]), le32_to_cpu(desc[2].data[1]),
+		le32_to_cpu(desc[2].data[2]), le32_to_cpu(desc[2].data[3]));
 
 	return 0;
 }
@@ -1408,12 +1408,12 @@ static int hclge_log_rocee_ecc_error(struct hclge_dev *hdev)
 		return ret;
 	}
 
-	dev_info(dev, "ECC1: %08X %08X %08X %08X %08X %08X\n",
-		 le32_to_cpu(desc[0].data[0]), le32_to_cpu(desc[0].data[1]),
-		 le32_to_cpu(desc[0].data[2]), le32_to_cpu(desc[0].data[3]),
-		 le32_to_cpu(desc[0].data[4]), le32_to_cpu(desc[0].data[5]));
-	dev_info(dev, "ECC2: %08X %08X %08X\n", le32_to_cpu(desc[1].data[0]),
-		 le32_to_cpu(desc[1].data[1]), le32_to_cpu(desc[1].data[2]));
+	dev_err(dev, "ECC1: %08X %08X %08X %08X %08X %08X\n",
+		le32_to_cpu(desc[0].data[0]), le32_to_cpu(desc[0].data[1]),
+		le32_to_cpu(desc[0].data[2]), le32_to_cpu(desc[0].data[3]),
+		le32_to_cpu(desc[0].data[4]), le32_to_cpu(desc[0].data[5]));
+	dev_err(dev, "ECC2: %08X %08X %08X\n", le32_to_cpu(desc[1].data[0]),
+		le32_to_cpu(desc[1].data[1]), le32_to_cpu(desc[1].data[2]));
 
 	return 0;
 }
@@ -1442,9 +1442,9 @@ static int hclge_log_rocee_ovf_error(struct hclge_dev *hdev)
 			  le32_to_cpu(desc[0].data[0]);
 		while (err->msg) {
 			if (err->int_msk == err_sts) {
-				dev_warn(dev, "%s [error status=0x%x] found\n",
-					 err->msg,
-					 le32_to_cpu(desc[0].data[0]));
+				dev_err(dev, "%s [error status=0x%x] found\n",
+					err->msg,
+					le32_to_cpu(desc[0].data[0]));
 				break;
 			}
 			err++;
@@ -1452,13 +1452,13 @@ static int hclge_log_rocee_ovf_error(struct hclge_dev *hdev)
 	}
 
 	if (le32_to_cpu(desc[0].data[1]) & HCLGE_ROCEE_OVF_ERR_INT_MASK) {
-		dev_warn(dev, "ROCEE TSP OVF [error status=0x%x] found\n",
-			 le32_to_cpu(desc[0].data[1]));
+		dev_err(dev, "ROCEE TSP OVF [error status=0x%x] found\n",
+			le32_to_cpu(desc[0].data[1]));
 	}
 
 	if (le32_to_cpu(desc[0].data[2]) & HCLGE_ROCEE_OVF_ERR_INT_MASK) {
-		dev_warn(dev, "ROCEE SCC OVF [error status=0x%x] found\n",
-			 le32_to_cpu(desc[0].data[2]));
+		dev_err(dev, "ROCEE SCC OVF [error status=0x%x] found\n",
+			le32_to_cpu(desc[0].data[2]));
 	}
 
 	return 0;
@@ -1486,10 +1486,10 @@ hclge_log_and_clear_rocee_ras_error(struct hclge_dev *hdev)
 
 	if (status & HCLGE_ROCEE_AXI_ERR_INT_MASK) {
 		if (status & HCLGE_ROCEE_RERR_INT_MASK)
-			dev_warn(dev, "ROCEE RAS AXI rresp error\n");
+			dev_err(dev, "ROCEE RAS AXI rresp error\n");
 
 		if (status & HCLGE_ROCEE_BERR_INT_MASK)
-			dev_warn(dev, "ROCEE RAS AXI bresp error\n");
+			dev_err(dev, "ROCEE RAS AXI bresp error\n");
 
 		reset_type = HNAE3_FUNC_RESET;
 
@@ -1499,7 +1499,7 @@ hclge_log_and_clear_rocee_ras_error(struct hclge_dev *hdev)
 	}
 
 	if (status & HCLGE_ROCEE_ECC_INT_MASK) {
-		dev_warn(dev, "ROCEE RAS 2bit ECC error\n");
+		dev_err(dev, "ROCEE RAS 2bit ECC error\n");
 		reset_type = HNAE3_GLOBAL_RESET;
 
 		ret = hclge_log_rocee_ecc_error(hdev);
@@ -1640,16 +1640,16 @@ pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev)
 
 	/* Handling Non-fatal HNS RAS errors */
 	if (status & HCLGE_RAS_REG_NFE_MASK) {
-		dev_warn(dev,
-			 "HNS Non-Fatal RAS error(status=0x%x) identified\n",
-			 status);
+		dev_err(dev,
+			"HNS Non-Fatal RAS error(status=0x%x) identified\n",
+			status);
 		hclge_handle_all_ras_errors(hdev);
 	}
 
 	/* Handling Non-fatal Rocee RAS errors */
 	if (hdev->pdev->revision >= 0x21 &&
 	    status & HCLGE_RAS_REG_ROCEE_ERR_MASK) {
-		dev_warn(dev, "ROCEE Non-Fatal RAS error identified\n");
+		dev_err(dev, "ROCEE Non-Fatal RAS error identified\n");
 		hclge_handle_rocee_ras_error(ae_dev);
 	}
 
@@ -1728,8 +1728,8 @@ static void hclge_handle_over_8bd_err(struct hclge_dev *hdev,
 		return;
 	}
 
-	dev_warn(dev, "PPU_PF_ABNORMAL_INT_ST over_8bd_no_fe found, vf_id(%d), queue_id(%d)\n",
-		 vf_id, q_id);
+	dev_err(dev, "PPU_PF_ABNORMAL_INT_ST over_8bd_no_fe found, vf_id(%u), queue_id(%u)\n",
+		vf_id, q_id);
 
 	if (vf_id) {
 		if (vf_id >= hdev->num_alloc_vport) {
@@ -1746,8 +1746,8 @@ static void hclge_handle_over_8bd_err(struct hclge_dev *hdev,
 
 		ret = hclge_inform_reset_assert_to_vf(&hdev->vport[vf_id]);
 		if (ret)
-			dev_warn(dev, "inform reset to vf(%d) failed %d!\n",
-				 hdev->vport->vport_id, ret);
+			dev_err(dev, "inform reset to vf(%u) failed %d!\n",
+				hdev->vport->vport_id, ret);
 	} else {
 		set_bit(HNAE3_FUNC_RESET, reset_requests);
 	}
@@ -1793,8 +1793,8 @@ static int hclge_handle_mpf_msix_error(struct hclge_dev *hdev,
 	status = le32_to_cpu(*(desc_data + 2)) &
 			HCLGE_PPU_MPF_INT_ST2_MSIX_MASK;
 	if (status)
-		dev_warn(dev, "PPU_MPF_ABNORMAL_INT_ST2 rx_q_search_miss found [dfx status=0x%x\n]",
-			 status);
+		dev_err(dev, "PPU_MPF_ABNORMAL_INT_ST2 rx_q_search_miss found [dfx status=0x%x\n]",
+			status);
 
 	/* clear all main PF MSIx errors */
 	ret = hclge_clear_hw_msix_error(hdev, desc, true, mpf_bd_num);
@@ -1988,7 +1988,7 @@ void hclge_handle_all_hns_hw_errors(struct hnae3_ae_dev *ae_dev)
 
 	/* Handle Non-fatal HNS RAS errors */
 	if (status & HCLGE_RAS_REG_NFE_MASK) {
-		dev_warn(dev, "HNS hw error(RAS) identified during init\n");
+		dev_err(dev, "HNS hw error(RAS) identified during init\n");
 		hclge_handle_all_ras_errors(hdev);
 	}
 
-- 
2.7.4

