Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8257D437
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbfHAD5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:57:54 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3723 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728171AbfHAD5y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:57:54 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6F71627422940C6723FD;
        Thu,  1 Aug 2019 11:57:51 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 1 Aug 2019 11:57:45 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 05/12] net: hns3: remove unnecessary variable in hclge_get_mac_vlan_cmd_status()
Date:   Thu, 1 Aug 2019 11:55:38 +0800
Message-ID: <1564631745-36733-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
References: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

The local variable return_status in hclge_get_mac_val_cmd_status()
is useless. So this patch returns the error code directly, instead of
using this variable. Also, replace some '%d' with '%u' in
hclge_get_mac_val_cmd_status().

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 50 +++++++++++-----------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 855b65e..4317c8f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6268,7 +6268,6 @@ static int hclge_get_mac_vlan_cmd_status(struct hclge_vport *vport,
 					 enum hclge_mac_vlan_tbl_opcode op)
 {
 	struct hclge_dev *hdev = vport->back;
-	int return_status = -EIO;
 
 	if (cmdq_resp) {
 		dev_err(&hdev->pdev->dev,
@@ -6279,52 +6278,53 @@ static int hclge_get_mac_vlan_cmd_status(struct hclge_vport *vport,
 
 	if (op == HCLGE_MAC_VLAN_ADD) {
 		if ((!resp_code) || (resp_code == 1)) {
-			return_status = 0;
+			return 0;
 		} else if (resp_code == HCLGE_ADD_UC_OVERFLOW) {
-			return_status = -ENOSPC;
 			dev_err(&hdev->pdev->dev,
 				"add mac addr failed for uc_overflow.\n");
+			return -ENOSPC;
 		} else if (resp_code == HCLGE_ADD_MC_OVERFLOW) {
-			return_status = -ENOSPC;
 			dev_err(&hdev->pdev->dev,
 				"add mac addr failed for mc_overflow.\n");
-		} else {
-			dev_err(&hdev->pdev->dev,
-				"add mac addr failed for undefined, code=%d.\n",
-				resp_code);
+			return -ENOSPC;
 		}
+
+		dev_err(&hdev->pdev->dev,
+			"add mac addr failed for undefined, code=%u.\n",
+			resp_code);
+		return -EIO;
 	} else if (op == HCLGE_MAC_VLAN_REMOVE) {
 		if (!resp_code) {
-			return_status = 0;
+			return 0;
 		} else if (resp_code == 1) {
-			return_status = -ENOENT;
 			dev_dbg(&hdev->pdev->dev,
 				"remove mac addr failed for miss.\n");
-		} else {
-			dev_err(&hdev->pdev->dev,
-				"remove mac addr failed for undefined, code=%d.\n",
-				resp_code);
+			return -ENOENT;
 		}
+
+		dev_err(&hdev->pdev->dev,
+			"remove mac addr failed for undefined, code=%u.\n",
+			resp_code);
+		return -EIO;
 	} else if (op == HCLGE_MAC_VLAN_LKUP) {
 		if (!resp_code) {
-			return_status = 0;
+			return 0;
 		} else if (resp_code == 1) {
-			return_status = -ENOENT;
 			dev_dbg(&hdev->pdev->dev,
 				"lookup mac addr failed for miss.\n");
-		} else {
-			dev_err(&hdev->pdev->dev,
-				"lookup mac addr failed for undefined, code=%d.\n",
-				resp_code);
+			return -ENOENT;
 		}
-	} else {
-		return_status = -EINVAL;
+
 		dev_err(&hdev->pdev->dev,
-			"unknown opcode for get_mac_vlan_cmd_status,opcode=%d.\n",
-			op);
+			"lookup mac addr failed for undefined, code=%u.\n",
+			resp_code);
+		return -EIO;
 	}
 
-	return return_status;
+	dev_err(&hdev->pdev->dev,
+		"unknown opcode for get_mac_vlan_cmd_status, opcode=%d.\n", op);
+
+	return -EINVAL;
 }
 
 static int hclge_update_desc_vfid(struct hclge_desc *desc, int vfid, bool clr)
-- 
2.7.4

