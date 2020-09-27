Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6DC279F34
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbgI0HPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:15:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14243 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730331AbgI0HPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 03:15:43 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 67CF19890BD069C315A7;
        Sun, 27 Sep 2020 15:15:41 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sun, 27 Sep 2020 15:15:35 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 09/10] net: hns3: add a check for device specifications queried from firmware
Date:   Sun, 27 Sep 2020 15:12:47 +0800
Message-ID: <1601190768-50075-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
References: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

The device specifications querying is unsupported by the old
firmware, in this case, these specifications are 0. However,
some specifications should not be 0 or will cause problem.

So after querying from firmware, some device specifications
are needed to check their value and set to default value if
their values are 0.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 15 +++++++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 13 +++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 34b2932..1f02640 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1383,6 +1383,20 @@ static void hclge_parse_dev_specs(struct hclge_dev *hdev,
 	ae_dev->dev_specs.max_tm_rate = le32_to_cpu(req0->max_tm_rate);
 }
 
+static void hclge_check_dev_specs(struct hclge_dev *hdev)
+{
+	struct hnae3_dev_specs *dev_specs = &hdev->ae_dev->dev_specs;
+
+	if (!dev_specs->max_non_tso_bd_num)
+		dev_specs->max_non_tso_bd_num = HCLGE_MAX_NON_TSO_BD_NUM;
+	if (!dev_specs->rss_ind_tbl_size)
+		dev_specs->rss_ind_tbl_size = HCLGE_RSS_IND_TBL_SIZE;
+	if (!dev_specs->rss_key_size)
+		dev_specs->rss_key_size = HCLGE_RSS_KEY_SIZE;
+	if (!dev_specs->max_tm_rate)
+		dev_specs->max_tm_rate = HCLGE_ETHER_MAX_RATE;
+}
+
 static int hclge_query_dev_specs(struct hclge_dev *hdev)
 {
 	struct hclge_desc desc[HCLGE_QUERY_DEV_SPECS_BD_NUM];
@@ -1409,6 +1423,7 @@ static int hclge_query_dev_specs(struct hclge_dev *hdev)
 		return ret;
 
 	hclge_parse_dev_specs(hdev, desc);
+	hclge_check_dev_specs(hdev);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index b64fa0b..8c8e666 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2965,6 +2965,18 @@ static void hclgevf_parse_dev_specs(struct hclgevf_dev *hdev,
 	ae_dev->dev_specs.rss_key_size = le16_to_cpu(req0->rss_key_size);
 }
 
+static void hclgevf_check_dev_specs(struct hclgevf_dev *hdev)
+{
+	struct hnae3_dev_specs *dev_specs = &hdev->ae_dev->dev_specs;
+
+	if (!dev_specs->max_non_tso_bd_num)
+		dev_specs->max_non_tso_bd_num = HCLGEVF_MAX_NON_TSO_BD_NUM;
+	if (!dev_specs->rss_ind_tbl_size)
+		dev_specs->rss_ind_tbl_size = HCLGEVF_RSS_IND_TBL_SIZE;
+	if (!dev_specs->rss_key_size)
+		dev_specs->rss_key_size = HCLGEVF_RSS_KEY_SIZE;
+}
+
 static int hclgevf_query_dev_specs(struct hclgevf_dev *hdev)
 {
 	struct hclgevf_desc desc[HCLGEVF_QUERY_DEV_SPECS_BD_NUM];
@@ -2992,6 +3004,7 @@ static int hclgevf_query_dev_specs(struct hclgevf_dev *hdev)
 		return ret;
 
 	hclgevf_parse_dev_specs(hdev, desc);
+	hclgevf_check_dev_specs(hdev);
 
 	return 0;
 }
-- 
2.7.4

