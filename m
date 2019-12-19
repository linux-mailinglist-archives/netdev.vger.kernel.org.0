Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8505C125BB6
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfLSG54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:57:56 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:51228 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726752AbfLSG5v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 01:57:51 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 020DB855D61D7D951F2F;
        Thu, 19 Dec 2019 14:57:46 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Thu, 19 Dec 2019 14:57:38 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/8] net: hns3: get FD rules location before dump in debugfs
Date:   Thu, 19 Dec 2019 14:57:43 +0800
Message-ID: <1576738667-37960-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576738667-37960-1-git-send-email-tanhuazhong@huawei.com>
References: <1576738667-37960-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Currently, the dump FD tcam mode in debugfs is to query all FD tcams,
including empty rules, which is unnecessary. This patch modify to
find the position of useful rules before dump FD tcam, so that it does
not need to query empty rules.

This patch also modifies some help information in debugfs.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 74 ++++++++++++++++++++--
 1 file changed, 67 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 92a99e4..f3d4cbd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -886,8 +886,8 @@ static void hclge_dbg_dump_mng_table(struct hclge_dev *hdev)
 	}
 }
 
-static void hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, u8 stage,
-				   bool sel_x, u32 loc)
+static int hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, u8 stage,
+				  bool sel_x, u32 loc)
 {
 	struct hclge_fd_tcam_config_1_cmd *req1;
 	struct hclge_fd_tcam_config_2_cmd *req2;
@@ -912,7 +912,7 @@ static void hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, u8 stage,
 
 	ret = hclge_cmd_send(&hdev->hw, desc, 3);
 	if (ret)
-		return;
+		return ret;
 
 	dev_info(&hdev->pdev->dev, " read result tcam key %s(%u):\n",
 		 sel_x ? "x" : "y", loc);
@@ -931,16 +931,76 @@ static void hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, u8 stage,
 	req = (u32 *)req3->tcam_data;
 	for (i = 0; i < 5; i++)
 		dev_info(&hdev->pdev->dev, "%08x\n", *req++);
+
+	return ret;
+}
+
+static int hclge_dbg_get_rules_location(struct hclge_dev *hdev, u16 *rule_locs)
+{
+	struct hclge_fd_rule *rule;
+	struct hlist_node *node;
+	int cnt = 0;
+
+	spin_lock_bh(&hdev->fd_rule_lock);
+	hlist_for_each_entry_safe(rule, node, &hdev->fd_rule_list, rule_node) {
+		rule_locs[cnt] = rule->location;
+		cnt++;
+	}
+	spin_unlock_bh(&hdev->fd_rule_lock);
+
+	if (cnt != hdev->hclge_fd_rule_num)
+		return -EINVAL;
+
+	return cnt;
 }
 
 static void hclge_dbg_fd_tcam(struct hclge_dev *hdev)
 {
-	u32 i;
+	int i, ret, rule_cnt;
+	u16 *rule_locs;
+
+	if (!hnae3_dev_fd_supported(hdev)) {
+		dev_err(&hdev->pdev->dev,
+			"Only FD-supported dev supports dump fd tcam\n");
+		return;
+	}
+
+	if (!hdev->hclge_fd_rule_num ||
+	    !hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1])
+		return;
+
+	rule_locs = kcalloc(hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1],
+			    sizeof(u16), GFP_KERNEL);
+	if (!rule_locs)
+		return;
 
-	for (i = 0; i < hdev->fd_cfg.rule_num[0]; i++) {
-		hclge_dbg_fd_tcam_read(hdev, 0, true, i);
-		hclge_dbg_fd_tcam_read(hdev, 0, false, i);
+	rule_cnt = hclge_dbg_get_rules_location(hdev, rule_locs);
+	if (rule_cnt <= 0) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get rule number, ret = %d\n", rule_cnt);
+		kfree(rule_locs);
+		return;
 	}
+
+	for (i = 0; i < rule_cnt; i++) {
+		ret = hclge_dbg_fd_tcam_read(hdev, 0, true, rule_locs[i]);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to get fd tcam key x, ret = %d\n", ret);
+			kfree(rule_locs);
+			return;
+		}
+
+		ret = hclge_dbg_fd_tcam_read(hdev, 0, false, rule_locs[i]);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to get fd tcam key y, ret = %d\n", ret);
+			kfree(rule_locs);
+			return;
+		}
+	}
+
+	kfree(rule_locs);
 }
 
 void hclge_dbg_dump_rst_info(struct hclge_dev *hdev)
-- 
2.7.4

