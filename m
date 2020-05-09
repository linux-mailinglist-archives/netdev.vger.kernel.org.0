Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780ED1CBFCA
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 11:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgEIJ3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 05:29:04 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4379 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728126AbgEIJ3C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 05:29:02 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6A64B25B68EA0FD6FCBA;
        Sat,  9 May 2020 17:29:00 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Sat, 9 May 2020 17:28:49 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/5] net: hns3: optimized the judgment of the input parameters of dump ncl config
Date:   Sat, 9 May 2020 17:27:40 +0800
Message-ID: <1589016461-10130-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589016461-10130-1-git-send-email-tanhuazhong@huawei.com>
References: <1589016461-10130-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

This patch optimizes the judgment of the input parameters of dump ncl
config by checking the number and value of the input parameters apart.
It's clearer and more reasonable.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c    | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 6cfa825..48c115c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1258,6 +1258,7 @@ static void hclge_dbg_dump_ncl_config(struct hclge_dev *hdev,
 {
 #define HCLGE_MAX_NCL_CONFIG_OFFSET	4096
 #define HCLGE_NCL_CONFIG_LENGTH_IN_EACH_CMD	(20 + 24 * 4)
+#define HCLGE_NCL_CONFIG_PARAM_NUM	2
 
 	struct hclge_desc desc[HCLGE_CMD_NCL_CONFIG_BD_NUM];
 	int bd_num = HCLGE_CMD_NCL_CONFIG_BD_NUM;
@@ -1267,13 +1268,17 @@ static void hclge_dbg_dump_ncl_config(struct hclge_dev *hdev,
 	int ret;
 
 	ret = sscanf(cmd_buf, "%x %x", &offset, &length);
-	if (ret != 2 || offset >= HCLGE_MAX_NCL_CONFIG_OFFSET ||
-	    length > HCLGE_MAX_NCL_CONFIG_OFFSET - offset) {
-		dev_err(&hdev->pdev->dev, "Invalid offset or length.\n");
+	if (ret != HCLGE_NCL_CONFIG_PARAM_NUM) {
+		dev_err(&hdev->pdev->dev,
+			"Too few parameters, num = %d.\n", ret);
 		return;
 	}
-	if (offset < 0 || length <= 0) {
-		dev_err(&hdev->pdev->dev, "Non-positive offset or length.\n");
+
+	if (offset < 0 || offset >= HCLGE_MAX_NCL_CONFIG_OFFSET ||
+	    length <= 0 || length > HCLGE_MAX_NCL_CONFIG_OFFSET - offset) {
+		dev_err(&hdev->pdev->dev,
+			"Invalid input, offset = %d, length = %d.\n",
+			offset, length);
 		return;
 	}
 
-- 
2.7.4

