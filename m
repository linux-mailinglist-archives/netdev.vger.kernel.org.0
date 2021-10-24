Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9729F438806
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 11:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhJXJr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 05:47:59 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:29929 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbhJXJr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 05:47:58 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HcY4B6C8bzbnCB;
        Sun, 24 Oct 2021 17:40:58 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:34 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 3/8] net: hns3: device specifications add number of mac statistics
Date:   Sun, 24 Oct 2021 17:41:10 +0800
Message-ID: <20211024094115.42158-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211024094115.42158-1-huangguangbin2@huawei.com>
References: <20211024094115.42158-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, driver queries number of mac statistics before querying mac
statistics. As the number of mac statistics is a fixed value in firmware,
it is redundant to query this number everytime before querying mac
statistics, it can just be queried once in initialization process and
saved in device specifications.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 +
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  2 ++
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 34 +++++++++++++------
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 07c83af36831..3f7a9a4c59d5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -349,6 +349,7 @@ struct hnae3_dev_specs {
 	u16 max_qset_num;
 	u16 umv_size;
 	u16 mc_mac_size;
+	u32 mac_stats_num;
 };
 
 struct hnae3_client_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 578d693b23c2..1a1bebd453d3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -1050,6 +1050,8 @@ hns3_dbg_dev_specs(struct hnae3_handle *h, char *buf, int len, int *pos)
 			  dev_specs->umv_size);
 	*pos += scnprintf(buf + *pos, len - *pos, "mc mac size: %u\n",
 			  dev_specs->mc_mac_size);
+	*pos += scnprintf(buf + *pos, len - *pos, "MAC statistics number: %u\n",
+			  dev_specs->mac_stats_num);
 }
 
 static int hns3_dbg_dev_info(struct hnae3_handle *h, char *buf, int len)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a4e3349d2157..7c807abe968a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -480,10 +480,11 @@ static int hclge_mac_update_stats_defective(struct hclge_dev *hdev)
 	return 0;
 }
 
-static int hclge_mac_update_stats_complete(struct hclge_dev *hdev, u32 reg_num)
+static int hclge_mac_update_stats_complete(struct hclge_dev *hdev)
 {
 #define HCLGE_REG_NUM_PER_DESC		4
 
+	u32 reg_num = hdev->ae_dev->dev_specs.mac_stats_num;
 	u64 *data = (u64 *)(&hdev->mac_stats);
 	struct hclge_desc *desc;
 	__le64 *desc_data;
@@ -552,17 +553,11 @@ static int hclge_mac_query_reg_num(struct hclge_dev *hdev, u32 *reg_num)
 
 static int hclge_mac_update_stats(struct hclge_dev *hdev)
 {
-	u32 reg_num;
-	int ret;
-
-	ret = hclge_mac_query_reg_num(hdev, &reg_num);
 	/* The firmware supports the new statistics acquisition method */
-	if (!ret)
-		ret = hclge_mac_update_stats_complete(hdev, reg_num);
-	else if (ret == -EOPNOTSUPP)
-		ret = hclge_mac_update_stats_defective(hdev);
-
-	return ret;
+	if (hdev->ae_dev->dev_specs.mac_stats_num)
+		return hclge_mac_update_stats_complete(hdev);
+	else
+		return hclge_mac_update_stats_defective(hdev);
 }
 
 static int hclge_tqps_update_stats(struct hnae3_handle *handle)
@@ -1465,12 +1460,29 @@ static void hclge_check_dev_specs(struct hclge_dev *hdev)
 		dev_specs->umv_size = HCLGE_DEFAULT_UMV_SPACE_PER_PF;
 }
 
+static int hclge_query_mac_stats_num(struct hclge_dev *hdev)
+{
+	u32 reg_num = 0;
+	int ret;
+
+	ret = hclge_mac_query_reg_num(hdev, &reg_num);
+	if (ret && ret != -EOPNOTSUPP)
+		return ret;
+
+	hdev->ae_dev->dev_specs.mac_stats_num = reg_num;
+	return 0;
+}
+
 static int hclge_query_dev_specs(struct hclge_dev *hdev)
 {
 	struct hclge_desc desc[HCLGE_QUERY_DEV_SPECS_BD_NUM];
 	int ret;
 	int i;
 
+	ret = hclge_query_mac_stats_num(hdev);
+	if (ret)
+		return ret;
+
 	/* set default specifications as devices lower than version V3 do not
 	 * support querying specifications from firmware.
 	 */
-- 
2.33.0

