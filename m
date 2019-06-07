Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E15E38295
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 04:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfFGCFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 22:05:20 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58414 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727104AbfFGCFU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 22:05:20 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CA4D75E453A727DCBAC5;
        Fri,  7 Jun 2019 10:05:17 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Fri, 7 Jun 2019 10:05:11 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        "Weihang Li" <liweihang@hisilicon.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 10/12] net: hns3: refactor PF/VF RSS hash key configuration
Date:   Fri, 7 Jun 2019 10:03:11 +0800
Message-ID: <1559872993-14507-11-git-send-email-tanhuazhong@huawei.com>
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

From: Yufeng Mo <moyufeng@huawei.com>

In order to make it more readable, this patch modifies PF/VF's
RSS hash key configuring function.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 15 +++++++--------
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 15 +++++++--------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 755cc43..ee4e163 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3609,28 +3609,27 @@ static int hclge_set_rss_algo_key(struct hclge_dev *hdev,
 {
 	struct hclge_rss_config_cmd *req;
 	struct hclge_desc desc;
-	int key_offset;
+	int key_offset = 0;
+	int key_counts;
 	int key_size;
 	int ret;
 
+	key_counts = HCLGE_RSS_KEY_SIZE;
 	req = (struct hclge_rss_config_cmd *)desc.data;
 
-	for (key_offset = 0; key_offset < 3; key_offset++) {
+	while (key_counts) {
 		hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_RSS_GENERIC_CONFIG,
 					   false);
 
 		req->hash_config |= (hfunc & HCLGE_RSS_HASH_ALGO_MASK);
 		req->hash_config |= (key_offset << HCLGE_RSS_HASH_KEY_OFFSET_B);
 
-		if (key_offset == 2)
-			key_size =
-			HCLGE_RSS_KEY_SIZE - HCLGE_RSS_HASH_KEY_NUM * 2;
-		else
-			key_size = HCLGE_RSS_HASH_KEY_NUM;
-
+		key_size = min(HCLGE_RSS_HASH_KEY_NUM, key_counts);
 		memcpy(req->hash_key,
 		       key + key_offset * HCLGE_RSS_HASH_KEY_NUM, key_size);
 
+		key_counts -= key_size;
+		key_offset++;
 		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 7fd25ab..c448774 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -539,13 +539,15 @@ static int hclgevf_set_rss_algo_key(struct hclgevf_dev *hdev,
 {
 	struct hclgevf_rss_config_cmd *req;
 	struct hclgevf_desc desc;
-	int key_offset;
+	int key_offset = 0;
+	int key_counts;
 	int key_size;
 	int ret;
 
+	key_counts = HCLGEVF_RSS_KEY_SIZE;
 	req = (struct hclgevf_rss_config_cmd *)desc.data;
 
-	for (key_offset = 0; key_offset < 3; key_offset++) {
+	while (key_counts) {
 		hclgevf_cmd_setup_basic_desc(&desc,
 					     HCLGEVF_OPC_RSS_GENERIC_CONFIG,
 					     false);
@@ -554,15 +556,12 @@ static int hclgevf_set_rss_algo_key(struct hclgevf_dev *hdev,
 		req->hash_config |=
 			(key_offset << HCLGEVF_RSS_HASH_KEY_OFFSET_B);
 
-		if (key_offset == 2)
-			key_size =
-			HCLGEVF_RSS_KEY_SIZE - HCLGEVF_RSS_HASH_KEY_NUM * 2;
-		else
-			key_size = HCLGEVF_RSS_HASH_KEY_NUM;
-
+		key_size = min(HCLGEVF_RSS_HASH_KEY_NUM, key_counts);
 		memcpy(req->hash_key,
 		       key + key_offset * HCLGEVF_RSS_HASH_KEY_NUM, key_size);
 
+		key_counts -= key_size;
+		key_offset++;
 		ret = hclgevf_cmd_send(&hdev->hw, &desc, 1);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
-- 
2.7.4

