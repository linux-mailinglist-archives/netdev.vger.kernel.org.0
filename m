Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF3AC43E5E
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389608AbfFMPtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:49:09 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18151 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731707AbfFMJO2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 05:14:28 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 42CEAAE6DE5E87B10A48;
        Thu, 13 Jun 2019 17:14:14 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 13 Jun 2019 17:14:08 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 06/12] net: hns3: extract handling of mpf/pf msi-x errors into functions
Date:   Thu, 13 Jun 2019 17:12:26 +0800
Message-ID: <1560417152-53050-7-git-send-email-tanhuazhong@huawei.com>
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

From: Weihang Li <liweihang@hisilicon.com>

Function hclge_handle_all_hw_msix_error() contains four parts:
1. Query buffer descriptors for MSI-X errors.
2. Query and clear all main PF MSI-X errors.
3. Query and clear all PF MSI-X errors.
4. Handle mac tunnel interrupts.
Part 2 and part 3 handle errors of some different modules respectively,
this patch extracts them into dividual functions, which makes the logic
clearer.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 122 ++++++++++++++-------
 1 file changed, 83 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 3e0d6ee..fb616cb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1727,44 +1727,31 @@ static void hclge_handle_over_8bd_err(struct hclge_dev *hdev,
 	}
 }
 
-static int hclge_handle_all_hw_msix_error(struct hclge_dev *hdev,
-					  unsigned long *reset_requests)
+/* hclge_handle_mpf_msix_error: handle all main PF MSI-X errors
+ * @hdev: pointer to struct hclge_dev
+ * @desc: descriptor for describing the command
+ * @mpf_bd_num: number of extended command structures
+ * @reset_requests: record of the reset level that we need
+ *
+ * This function handles all the main PF MSI-X errors in the hw register/s
+ * using command.
+ */
+static int hclge_handle_mpf_msix_error(struct hclge_dev *hdev,
+				       struct hclge_desc *desc,
+				       int mpf_bd_num,
+				       unsigned long *reset_requests)
 {
-	struct hclge_mac_tnl_stats mac_tnl_stats;
 	struct device *dev = &hdev->pdev->dev;
-	u32 mpf_bd_num, pf_bd_num, bd_num;
-	struct hclge_desc desc_bd;
-	struct hclge_desc *desc;
 	__le32 *desc_data;
 	u32 status;
 	int ret;
-
-	/* query the number of bds for the MSIx int status */
-	hclge_cmd_setup_basic_desc(&desc_bd, HCLGE_QUERY_MSIX_INT_STS_BD_NUM,
-				   true);
-	ret = hclge_cmd_send(&hdev->hw, &desc_bd, 1);
-	if (ret) {
-		dev_err(dev, "fail(%d) to query msix int status bd num\n",
-			ret);
-		return ret;
-	}
-
-	mpf_bd_num = le32_to_cpu(desc_bd.data[0]);
-	pf_bd_num = le32_to_cpu(desc_bd.data[1]);
-	bd_num = max_t(u32, mpf_bd_num, pf_bd_num);
-
-	desc = kcalloc(bd_num, sizeof(struct hclge_desc), GFP_KERNEL);
-	if (!desc)
-		goto out;
-
 	/* query all main PF MSIx errors */
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_QUERY_CLEAR_ALL_MPF_MSIX_INT,
 				   true);
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], mpf_bd_num);
 	if (ret) {
-		dev_err(dev, "query all mpf msix int cmd failed (%d)\n",
-			ret);
-		goto msi_error;
+		dev_err(dev, "query all mpf msix int cmd failed (%d)\n", ret);
+		return ret;
 	}
 
 	/* log MAC errors */
@@ -1785,21 +1772,38 @@ static int hclge_handle_all_hw_msix_error(struct hclge_dev *hdev,
 
 	/* clear all main PF MSIx errors */
 	ret = hclge_clear_hw_msix_error(hdev, desc, true, mpf_bd_num);
-	if (ret) {
-		dev_err(dev, "clear all mpf msix int cmd failed (%d)\n",
-			ret);
-		goto msi_error;
-	}
+	if (ret)
+		dev_err(dev, "clear all mpf msix int cmd failed (%d)\n", ret);
+
+	return ret;
+}
+
+/* hclge_handle_pf_msix_error: handle all PF MSI-X errors
+ * @hdev: pointer to struct hclge_dev
+ * @desc: descriptor for describing the command
+ * @mpf_bd_num: number of extended command structures
+ * @reset_requests: record of the reset level that we need
+ *
+ * This function handles all the PF MSI-X errors in the hw register/s using
+ * command.
+ */
+static int hclge_handle_pf_msix_error(struct hclge_dev *hdev,
+				      struct hclge_desc *desc,
+				      int pf_bd_num,
+				      unsigned long *reset_requests)
+{
+	struct device *dev = &hdev->pdev->dev;
+	__le32 *desc_data;
+	u32 status;
+	int ret;
 
 	/* query all PF MSIx errors */
-	memset(desc, 0, bd_num * sizeof(struct hclge_desc));
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_QUERY_CLEAR_ALL_PF_MSIX_INT,
 				   true);
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], pf_bd_num);
 	if (ret) {
-		dev_err(dev, "query all pf msix int cmd failed (%d)\n",
-			ret);
-		goto msi_error;
+		dev_err(dev, "query all pf msix int cmd failed (%d)\n", ret);
+		return ret;
 	}
 
 	/* log SSU PF errors */
@@ -1831,11 +1835,51 @@ static int hclge_handle_all_hw_msix_error(struct hclge_dev *hdev,
 
 	/* clear all PF MSIx errors */
 	ret = hclge_clear_hw_msix_error(hdev, desc, false, pf_bd_num);
-	if (ret) {
+	if (ret)
 		dev_err(dev, "clear all pf msix int cmd failed (%d)\n", ret);
-		goto msi_error;
+
+	return ret;
+}
+
+static int hclge_handle_all_hw_msix_error(struct hclge_dev *hdev,
+					  unsigned long *reset_requests)
+{
+	struct hclge_mac_tnl_stats mac_tnl_stats;
+	struct device *dev = &hdev->pdev->dev;
+	u32 mpf_bd_num, pf_bd_num, bd_num;
+	struct hclge_desc desc_bd;
+	struct hclge_desc *desc;
+	u32 status;
+	int ret;
+
+	/* query the number of bds for the MSIx int status */
+	hclge_cmd_setup_basic_desc(&desc_bd, HCLGE_QUERY_MSIX_INT_STS_BD_NUM,
+				   true);
+	ret = hclge_cmd_send(&hdev->hw, &desc_bd, 1);
+	if (ret) {
+		dev_err(dev, "fail(%d) to query msix int status bd num\n",
+			ret);
+		return ret;
 	}
 
+	mpf_bd_num = le32_to_cpu(desc_bd.data[0]);
+	pf_bd_num = le32_to_cpu(desc_bd.data[1]);
+	bd_num = max_t(u32, mpf_bd_num, pf_bd_num);
+
+	desc = kcalloc(bd_num, sizeof(struct hclge_desc), GFP_KERNEL);
+	if (!desc)
+		goto out;
+
+	ret = hclge_handle_mpf_msix_error(hdev, desc, mpf_bd_num,
+					  reset_requests);
+	if (ret)
+		goto msi_error;
+
+	memset(desc, 0, bd_num * sizeof(struct hclge_desc));
+	ret = hclge_handle_pf_msix_error(hdev, desc, pf_bd_num, reset_requests);
+	if (ret)
+		goto msi_error;
+
 	/* query and clear mac tnl interruptions */
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_QUERY_MAC_TNL_INT,
 				   true);
-- 
2.7.4

