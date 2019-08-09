Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E2686FB8
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 04:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404950AbfHICde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 22:33:34 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58896 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732708AbfHICdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 22:33:33 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 07D9D13CAE8475920C99;
        Fri,  9 Aug 2019 10:33:32 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 9 Aug 2019 10:33:24 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 09/12] net: hns3: add function display NCL_CONFIG info
Date:   Fri, 9 Aug 2019 10:31:15 +0800
Message-ID: <1565317878-31806-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
References: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

This adds a new function hclge_ncl_config_data_print()
to print the data of NCL_CONFIG, to make the code more
readable. Also, using macro replaces some magic number.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 52 +++++++++++++---------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 933dec5..f0295d1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -995,6 +995,33 @@ void hclge_dbg_get_m7_stats_info(struct hclge_dev *hdev)
 	kfree(desc_src);
 }
 
+#define HCLGE_CMD_NCL_CONFIG_BD_NUM	5
+
+static void hclge_ncl_config_data_print(struct hclge_dev *hdev,
+					struct hclge_desc *desc, int *offset,
+					int *length)
+{
+#define HCLGE_CMD_DATA_NUM		6
+
+	int i;
+	int j;
+
+	for (i = 0; i < HCLGE_CMD_NCL_CONFIG_BD_NUM; i++) {
+		for (j = 0; j < HCLGE_CMD_DATA_NUM; j++) {
+			if (i == 0 && j == 0)
+				continue;
+
+			dev_info(&hdev->pdev->dev, "0x%04x | 0x%08x\n",
+				 *offset,
+				 le32_to_cpu(desc[i].data[j]));
+			*offset += sizeof(u32);
+			*length -= sizeof(u32);
+			if (*length <= 0)
+				return;
+		}
+	}
+}
+
 /* hclge_dbg_dump_ncl_config: print specified range of NCL_CONFIG file
  * @hdev: pointer to struct hclge_dev
  * @cmd_buf: string that contains offset and length
@@ -1004,17 +1031,13 @@ static void hclge_dbg_dump_ncl_config(struct hclge_dev *hdev,
 {
 #define HCLGE_MAX_NCL_CONFIG_OFFSET	4096
 #define HCLGE_MAX_NCL_CONFIG_LENGTH	(20 + 24 * 4)
-#define HCLGE_CMD_DATA_NUM		6
 
-	struct hclge_desc desc[5];
-	u32 byte_offset;
-	int bd_num = 5;
+	struct hclge_desc desc[HCLGE_CMD_NCL_CONFIG_BD_NUM];
+	int bd_num = HCLGE_CMD_NCL_CONFIG_BD_NUM;
 	int offset;
 	int length;
 	int data0;
 	int ret;
-	int i;
-	int j;
 
 	ret = sscanf(cmd_buf, "%x %x", &offset, &length);
 	if (ret != 2 || offset >= HCLGE_MAX_NCL_CONFIG_OFFSET ||
@@ -1040,22 +1063,7 @@ static void hclge_dbg_dump_ncl_config(struct hclge_dev *hdev,
 		if (ret)
 			return;
 
-		byte_offset = offset;
-		for (i = 0; i < bd_num; i++) {
-			for (j = 0; j < HCLGE_CMD_DATA_NUM; j++) {
-				if (i == 0 && j == 0)
-					continue;
-
-				dev_info(&hdev->pdev->dev, "0x%04x | 0x%08x\n",
-					 byte_offset,
-					 le32_to_cpu(desc[i].data[j]));
-				byte_offset += sizeof(u32);
-				length -= sizeof(u32);
-				if (length <= 0)
-					return;
-			}
-		}
-		offset += HCLGE_MAX_NCL_CONFIG_LENGTH;
+		hclge_ncl_config_data_print(hdev, desc, &offset, &length);
 	}
 }
 
-- 
2.7.4

