Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDA64CA01
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731733AbfFTIzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:55:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:19047 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731481AbfFTIyh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 04:54:37 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7B6EEA91A42848435355;
        Thu, 20 Jun 2019 16:54:33 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Jun 2019 16:54:24 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 08/11] net: hns3: add check to number of buffer descriptors
Date:   Thu, 20 Jun 2019 16:52:42 +0800
Message-ID: <1561020765-14481-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
References: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

This patch adds check to number of bds before we allocate memory for
them. If we get an invalid bd num in some cases, it will cause a memory
overflow.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 86 +++++++++++++---------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |  5 ++
 2 files changed, 58 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 3d8985f..0a72438 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1060,6 +1060,52 @@ static int hclge_config_ssu_hw_err_int(struct hclge_dev *hdev, bool en)
 	return ret;
 }
 
+/* hclge_query_bd_num: query number of buffer descriptors
+ * @hdev: pointer to struct hclge_dev
+ * @is_ras: true for ras, false for msix
+ * @mpf_bd_num: number of main PF interrupt buffer descriptors
+ * @pf_bd_num: number of not main PF interrupt buffer descriptors
+ *
+ * This function querys number of mpf and pf buffer descriptors.
+ */
+static int hclge_query_bd_num(struct hclge_dev *hdev, bool is_ras,
+			      int *mpf_bd_num, int *pf_bd_num)
+{
+	struct device *dev = &hdev->pdev->dev;
+	u32 mpf_min_bd_num, pf_min_bd_num;
+	enum hclge_opcode_type opcode;
+	struct hclge_desc desc_bd;
+	int ret;
+
+	if (is_ras) {
+		opcode = HCLGE_QUERY_RAS_INT_STS_BD_NUM;
+		mpf_min_bd_num = HCLGE_MPF_RAS_INT_MIN_BD_NUM;
+		pf_min_bd_num = HCLGE_PF_RAS_INT_MIN_BD_NUM;
+	} else {
+		opcode = HCLGE_QUERY_MSIX_INT_STS_BD_NUM;
+		mpf_min_bd_num = HCLGE_MPF_MSIX_INT_MIN_BD_NUM;
+		pf_min_bd_num = HCLGE_PF_MSIX_INT_MIN_BD_NUM;
+	}
+
+	hclge_cmd_setup_basic_desc(&desc_bd, opcode, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc_bd, 1);
+	if (ret) {
+		dev_err(dev, "fail(%d) to query msix int status bd num\n",
+			ret);
+		return ret;
+	}
+
+	*mpf_bd_num = le32_to_cpu(desc_bd.data[0]);
+	*pf_bd_num = le32_to_cpu(desc_bd.data[1]);
+	if (*mpf_bd_num < mpf_min_bd_num || *pf_bd_num < pf_min_bd_num) {
+		dev_err(dev, "Invalid bd num: mpf(%d), pf(%d)\n",
+			*mpf_bd_num, *pf_bd_num);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* hclge_handle_mpf_ras_error: handle all main PF RAS errors
  * @hdev: pointer to struct hclge_dev
  * @desc: descriptor for describing the command
@@ -1291,24 +1337,16 @@ static int hclge_handle_pf_ras_error(struct hclge_dev *hdev,
 
 static int hclge_handle_all_ras_errors(struct hclge_dev *hdev)
 {
-	struct device *dev = &hdev->pdev->dev;
 	u32 mpf_bd_num, pf_bd_num, bd_num;
-	struct hclge_desc desc_bd;
 	struct hclge_desc *desc;
 	int ret;
 
 	/* query the number of registers in the RAS int status */
-	hclge_cmd_setup_basic_desc(&desc_bd, HCLGE_QUERY_RAS_INT_STS_BD_NUM,
-				   true);
-	ret = hclge_cmd_send(&hdev->hw, &desc_bd, 1);
-	if (ret) {
-		dev_err(dev, "fail(%d) to query ras int status bd num\n", ret);
+	ret = hclge_query_bd_num(hdev, true, &mpf_bd_num, &pf_bd_num);
+	if (ret)
 		return ret;
-	}
-	mpf_bd_num = le32_to_cpu(desc_bd.data[0]);
-	pf_bd_num = le32_to_cpu(desc_bd.data[1]);
-	bd_num = max_t(u32, mpf_bd_num, pf_bd_num);
 
+	bd_num = max_t(u32, mpf_bd_num, pf_bd_num);
 	desc = kcalloc(bd_num, sizeof(struct hclge_desc), GFP_KERNEL);
 	if (!desc)
 		return -ENOMEM;
@@ -1844,25 +1882,16 @@ static int hclge_handle_all_hw_msix_error(struct hclge_dev *hdev,
 	struct hclge_mac_tnl_stats mac_tnl_stats;
 	struct device *dev = &hdev->pdev->dev;
 	u32 mpf_bd_num, pf_bd_num, bd_num;
-	struct hclge_desc desc_bd;
 	struct hclge_desc *desc;
 	u32 status;
 	int ret;
 
 	/* query the number of bds for the MSIx int status */
-	hclge_cmd_setup_basic_desc(&desc_bd, HCLGE_QUERY_MSIX_INT_STS_BD_NUM,
-				   true);
-	ret = hclge_cmd_send(&hdev->hw, &desc_bd, 1);
-	if (ret) {
-		dev_err(dev, "fail(%d) to query msix int status bd num\n",
-			ret);
+	ret = hclge_query_bd_num(hdev, false, &mpf_bd_num, &pf_bd_num);
+	if (ret)
 		goto out;
-	}
 
-	mpf_bd_num = le32_to_cpu(desc_bd.data[0]);
-	pf_bd_num = le32_to_cpu(desc_bd.data[1]);
 	bd_num = max_t(u32, mpf_bd_num, pf_bd_num);
-
 	desc = kcalloc(bd_num, sizeof(struct hclge_desc), GFP_KERNEL);
 	if (!desc) {
 		ret = -ENOMEM;
@@ -1930,7 +1959,6 @@ void hclge_handle_all_hns_hw_errors(struct hnae3_ae_dev *ae_dev)
 	struct hclge_dev *hdev = ae_dev->priv;
 	struct device *dev = &hdev->pdev->dev;
 	u32 mpf_bd_num, pf_bd_num, bd_num;
-	struct hclge_desc desc_bd;
 	struct hclge_desc *desc;
 	u32 status;
 	int ret;
@@ -1939,19 +1967,11 @@ void hclge_handle_all_hns_hw_errors(struct hnae3_ae_dev *ae_dev)
 	status = hclge_read_dev(&hdev->hw, HCLGE_RAS_PF_OTHER_INT_STS_REG);
 
 	/* query the number of bds for the MSIx int status */
-	hclge_cmd_setup_basic_desc(&desc_bd, HCLGE_QUERY_MSIX_INT_STS_BD_NUM,
-				   true);
-	ret = hclge_cmd_send(&hdev->hw, &desc_bd, 1);
-	if (ret) {
-		dev_err(dev, "fail(%d) to query msix int status bd num\n",
-			ret);
+	ret = hclge_query_bd_num(hdev, false, &mpf_bd_num, &pf_bd_num);
+	if (ret)
 		return;
-	}
 
-	mpf_bd_num = le32_to_cpu(desc_bd.data[0]);
-	pf_bd_num = le32_to_cpu(desc_bd.data[1]);
 	bd_num = max_t(u32, mpf_bd_num, pf_bd_num);
-
 	desc = kcalloc(bd_num, sizeof(struct hclge_desc), GFP_KERNEL);
 	if (!desc)
 		return;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index db318a4..7ea8bb2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -6,6 +6,11 @@
 
 #include "hclge_main.h"
 
+#define HCLGE_MPF_RAS_INT_MIN_BD_NUM	10
+#define HCLGE_PF_RAS_INT_MIN_BD_NUM	4
+#define HCLGE_MPF_MSIX_INT_MIN_BD_NUM	10
+#define HCLGE_PF_MSIX_INT_MIN_BD_NUM	4
+
 #define HCLGE_RAS_PF_OTHER_INT_STS_REG   0x20B00
 #define HCLGE_RAS_REG_NFE_MASK   0xFF00
 #define HCLGE_RAS_REG_ROCEE_ERR_MASK   0x3000000
-- 
2.7.4

