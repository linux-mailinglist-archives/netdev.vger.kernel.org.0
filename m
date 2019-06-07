Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F0F38292
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 04:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbfFGCGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 22:06:21 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58476 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728168AbfFGCFX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 22:05:23 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E2044615EF010D7F2157;
        Fri,  7 Jun 2019 10:05:17 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Fri, 7 Jun 2019 10:05:08 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Xiaofei Tan <tanxiaofei@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 01/12] net: hns3: log detail error info of ROCEE ECC and AXI errors
Date:   Fri, 7 Jun 2019 10:03:02 +0800
Message-ID: <1559872993-14507-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559872993-14507-1-git-send-email-tanhuazhong@huawei.com>
References: <1559872993-14507-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

This patch logs detail error info of ROCEE ECC and AXI errors for
debug purpose, and remove unnecessary reset for ROCEE overflow
errors.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
V1->V2: fixes comments from David Miller
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 81 ++++++++++++++++++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |  1 +
 3 files changed, 77 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 61cb10d..5e6c749 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -268,6 +268,8 @@ enum hclge_opcode_type {
 	HCLGE_CONFIG_ROCEE_RAS_INT_EN	= 0x1580,
 	HCLGE_QUERY_CLEAR_ROCEE_RAS_INT = 0x1581,
 	HCLGE_ROCEE_PF_RAS_INT_CMD	= 0x1584,
+	HCLGE_QUERY_ROCEE_ECC_RAS_INFO_CMD	= 0x1585,
+	HCLGE_QUERY_ROCEE_AXI_RAS_INFO_CMD	= 0x1586,
 	HCLGE_IGU_EGU_TNL_INT_EN	= 0x1803,
 	HCLGE_IGU_COMMON_INT_EN		= 0x1806,
 	HCLGE_TM_QCN_MEM_INT_CFG	= 0x1A14,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 784512d..4f2af3d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1388,6 +1388,66 @@ static int hclge_handle_all_ras_errors(struct hclge_dev *hdev)
 	return ret;
 }
 
+static int hclge_log_rocee_axi_error(struct hclge_dev *hdev)
+{
+	struct device *dev = &hdev->pdev->dev;
+	struct hclge_desc desc[3];
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_QUERY_ROCEE_AXI_RAS_INFO_CMD,
+				   true);
+	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_QUERY_ROCEE_AXI_RAS_INFO_CMD,
+				   true);
+	hclge_cmd_setup_basic_desc(&desc[2], HCLGE_QUERY_ROCEE_AXI_RAS_INFO_CMD,
+				   true);
+	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	desc[1].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc[0], 3);
+	if (ret) {
+		dev_err(dev, "failed(%d) to query ROCEE AXI error sts\n", ret);
+		return ret;
+	}
+
+	dev_info(dev, "AXI1: %08X %08X %08X %08X %08X %08X\n",
+		 le32_to_cpu(desc[0].data[0]), le32_to_cpu(desc[0].data[1]),
+		 le32_to_cpu(desc[0].data[2]), le32_to_cpu(desc[0].data[3]),
+		 le32_to_cpu(desc[0].data[4]), le32_to_cpu(desc[0].data[5]));
+	dev_info(dev, "AXI2: %08X %08X %08X %08X %08X %08X\n",
+		 le32_to_cpu(desc[1].data[0]), le32_to_cpu(desc[1].data[1]),
+		 le32_to_cpu(desc[1].data[2]), le32_to_cpu(desc[1].data[3]),
+		 le32_to_cpu(desc[1].data[4]), le32_to_cpu(desc[1].data[5]));
+	dev_info(dev, "AXI3: %08X %08X %08X %08X\n",
+		 le32_to_cpu(desc[2].data[0]), le32_to_cpu(desc[2].data[1]),
+		 le32_to_cpu(desc[2].data[2]), le32_to_cpu(desc[2].data[3]));
+
+	return 0;
+}
+
+static int hclge_log_rocee_ecc_error(struct hclge_dev *hdev)
+{
+	struct device *dev = &hdev->pdev->dev;
+	struct hclge_desc desc[2];
+	int ret;
+
+	ret = hclge_cmd_query_error(hdev, &desc[0],
+				    HCLGE_QUERY_ROCEE_ECC_RAS_INFO_CMD,
+				    HCLGE_CMD_FLAG_NEXT, 0, 0);
+	if (ret) {
+		dev_err(dev, "failed(%d) to query ROCEE ECC error sts\n", ret);
+		return ret;
+	}
+
+	dev_info(dev, "ECC1: %08X %08X %08X %08X %08X %08X\n",
+		 le32_to_cpu(desc[0].data[0]), le32_to_cpu(desc[0].data[1]),
+		 le32_to_cpu(desc[0].data[2]), le32_to_cpu(desc[0].data[3]),
+		 le32_to_cpu(desc[0].data[4]), le32_to_cpu(desc[0].data[5]));
+	dev_info(dev, "ECC2: %08X %08X %08X\n", le32_to_cpu(desc[1].data[0]),
+		 le32_to_cpu(desc[1].data[1]), le32_to_cpu(desc[1].data[2]));
+
+	return 0;
+}
+
 static int hclge_log_rocee_ovf_error(struct hclge_dev *hdev)
 {
 	struct device *dev = &hdev->pdev->dev;
@@ -1456,19 +1516,27 @@ hclge_log_and_clear_rocee_ras_error(struct hclge_dev *hdev)
 
 	status = le32_to_cpu(desc[0].data[0]);
 
-	if (status & HCLGE_ROCEE_RERR_INT_MASK) {
-		dev_warn(dev, "ROCEE RAS AXI rresp error\n");
-		reset_type = HNAE3_FUNC_RESET;
-	}
+	if (status & HCLGE_ROCEE_AXI_ERR_INT_MASK) {
+		if (status & HCLGE_ROCEE_RERR_INT_MASK)
+			dev_warn(dev, "ROCEE RAS AXI rresp error\n");
+
+		if (status & HCLGE_ROCEE_BERR_INT_MASK)
+			dev_warn(dev, "ROCEE RAS AXI bresp error\n");
 
-	if (status & HCLGE_ROCEE_BERR_INT_MASK) {
-		dev_warn(dev, "ROCEE RAS AXI bresp error\n");
 		reset_type = HNAE3_FUNC_RESET;
+
+		ret = hclge_log_rocee_axi_error(hdev);
+		if (ret)
+			return HNAE3_GLOBAL_RESET;
 	}
 
 	if (status & HCLGE_ROCEE_ECC_INT_MASK) {
 		dev_warn(dev, "ROCEE RAS 2bit ECC error\n");
 		reset_type = HNAE3_GLOBAL_RESET;
+
+		ret = hclge_log_rocee_ecc_error(hdev);
+		if (ret)
+			return HNAE3_GLOBAL_RESET;
 	}
 
 	if (status & HCLGE_ROCEE_OVF_INT_MASK) {
@@ -1478,7 +1546,6 @@ hclge_log_and_clear_rocee_ras_error(struct hclge_dev *hdev)
 			/* reset everything for now */
 			return HNAE3_GLOBAL_RESET;
 		}
-		reset_type = HNAE3_FUNC_RESET;
 	}
 
 	/* clear error status */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index 81d115a..6684733 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -94,6 +94,7 @@
 #define HCLGE_ROCEE_RAS_CE_INT_EN_MASK		0x1
 #define HCLGE_ROCEE_RERR_INT_MASK		BIT(0)
 #define HCLGE_ROCEE_BERR_INT_MASK		BIT(1)
+#define HCLGE_ROCEE_AXI_ERR_INT_MASK		GENMASK(1, 0)
 #define HCLGE_ROCEE_ECC_INT_MASK		BIT(2)
 #define HCLGE_ROCEE_OVF_INT_MASK		BIT(3)
 #define HCLGE_ROCEE_OVF_ERR_INT_MASK		0x10000
-- 
2.7.4

