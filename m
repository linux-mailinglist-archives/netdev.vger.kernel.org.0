Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792F02970A
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391154AbfEXLVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:21:32 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17565 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391059AbfEXLVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 07:21:23 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E70289EA8DA70ED59714;
        Fri, 24 May 2019 19:21:20 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Fri, 24 May 2019 19:21:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/4] net: hns3: refine the flow director handle
Date:   Fri, 24 May 2019 19:19:46 +0800
Message-ID: <1558696788-12944-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558696788-12944-1-git-send-email-tanhuazhong@huawei.com>
References: <1558696788-12944-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

In order to be compatible with aRFS rules, this patch adds
spin_lock for flow director rule adding, deleting, querying,
and packages the rule configuration.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 131 ++++++++++++++++-----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  13 ++
 2 files changed, 112 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d3b1f8c..58a6a4d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1226,8 +1226,10 @@ static int hclge_configure(struct hclge_dev *hdev)
 	hdev->tm_info.hw_pfc_map = 0;
 	hdev->wanted_umv_size = cfg.umv_space;
 
-	if (hnae3_dev_fd_supported(hdev))
+	if (hnae3_dev_fd_supported(hdev)) {
 		hdev->fd_en = true;
+		hdev->fd_active_type = HCLGE_FD_RULE_NONE;
+	}
 
 	ret = hclge_parse_speed(cfg.default_speed, &hdev->hw.mac.speed);
 	if (ret) {
@@ -4906,14 +4908,18 @@ static bool hclge_fd_rule_exist(struct hclge_dev *hdev, u16 location)
 	struct hclge_fd_rule *rule = NULL;
 	struct hlist_node *node2;
 
+	spin_lock_bh(&hdev->fd_rule_lock);
 	hlist_for_each_entry_safe(rule, node2, &hdev->fd_rule_list, rule_node) {
 		if (rule->location >= location)
 			break;
 	}
 
+	spin_unlock_bh(&hdev->fd_rule_lock);
+
 	return  rule && rule->location == location;
 }
 
+/* make sure being called after lock up with fd_rule_lock */
 static int hclge_fd_update_rule_list(struct hclge_dev *hdev,
 				     struct hclge_fd_rule *new_rule,
 				     u16 location,
@@ -4937,9 +4943,13 @@ static int hclge_fd_update_rule_list(struct hclge_dev *hdev,
 		kfree(rule);
 		hdev->hclge_fd_rule_num--;
 
-		if (!is_add)
-			return 0;
+		if (!is_add) {
+			if (!hdev->hclge_fd_rule_num)
+				hdev->fd_active_type = HCLGE_FD_RULE_NONE;
+			clear_bit(location, hdev->fd_bmap);
 
+			return 0;
+		}
 	} else if (!is_add) {
 		dev_err(&hdev->pdev->dev,
 			"delete fail, rule %d is inexistent\n",
@@ -4954,7 +4964,9 @@ static int hclge_fd_update_rule_list(struct hclge_dev *hdev,
 	else
 		hlist_add_head(&new_rule->rule_node, &hdev->fd_rule_list);
 
+	set_bit(location, hdev->fd_bmap);
 	hdev->hclge_fd_rule_num++;
+	hdev->fd_active_type = new_rule->rule_type;
 
 	return 0;
 }
@@ -5112,6 +5124,36 @@ static int hclge_fd_get_tuple(struct hclge_dev *hdev,
 	return 0;
 }
 
+/* make sure being called after lock up with fd_rule_lock */
+static int hclge_fd_config_rule(struct hclge_dev *hdev,
+				struct hclge_fd_rule *rule)
+{
+	int ret;
+
+	if (!rule) {
+		dev_err(&hdev->pdev->dev,
+			"The flow director rule is NULL\n");
+		return -EINVAL;
+	}
+
+	/* it will never fail here, so needn't to check return value */
+	hclge_fd_update_rule_list(hdev, rule, rule->location, true);
+
+	ret = hclge_config_action(hdev, HCLGE_FD_STAGE_1, rule);
+	if (ret)
+		goto clear_rule;
+
+	ret = hclge_config_key(hdev, HCLGE_FD_STAGE_1, rule);
+	if (ret)
+		goto clear_rule;
+
+	return 0;
+
+clear_rule:
+	hclge_fd_update_rule_list(hdev, rule, rule->location, false);
+	return ret;
+}
+
 static int hclge_add_fd_entry(struct hnae3_handle *handle,
 			      struct ethtool_rxnfc *cmd)
 {
@@ -5174,8 +5216,10 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 		return -ENOMEM;
 
 	ret = hclge_fd_get_tuple(hdev, fs, rule);
-	if (ret)
-		goto free_rule;
+	if (ret) {
+		kfree(rule);
+		return ret;
+	}
 
 	rule->flow_type = fs->flow_type;
 
@@ -5184,23 +5228,13 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 	rule->vf_id = dst_vport_id;
 	rule->queue_id = q_index;
 	rule->action = action;
+	rule->rule_type = HCLGE_FD_EP_ACTIVE;
 
-	ret = hclge_config_action(hdev, HCLGE_FD_STAGE_1, rule);
-	if (ret)
-		goto free_rule;
-
-	ret = hclge_config_key(hdev, HCLGE_FD_STAGE_1, rule);
-	if (ret)
-		goto free_rule;
-
-	ret = hclge_fd_update_rule_list(hdev, rule, fs->location, true);
-	if (ret)
-		goto free_rule;
+	spin_lock_bh(&hdev->fd_rule_lock);
+	ret = hclge_fd_config_rule(hdev, rule);
 
-	return ret;
+	spin_unlock_bh(&hdev->fd_rule_lock);
 
-free_rule:
-	kfree(rule);
 	return ret;
 }
 
@@ -5232,8 +5266,12 @@ static int hclge_del_fd_entry(struct hnae3_handle *handle,
 	if (ret)
 		return ret;
 
-	return hclge_fd_update_rule_list(hdev, NULL, fs->location,
-					 false);
+	spin_lock_bh(&hdev->fd_rule_lock);
+	ret = hclge_fd_update_rule_list(hdev, NULL, fs->location, false);
+
+	spin_unlock_bh(&hdev->fd_rule_lock);
+
+	return ret;
 }
 
 static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
@@ -5243,25 +5281,30 @@ static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_fd_rule *rule;
 	struct hlist_node *node;
+	u16 location;
 
 	if (!hnae3_dev_fd_supported(hdev))
 		return;
 
+	spin_lock_bh(&hdev->fd_rule_lock);
+	for_each_set_bit(location, hdev->fd_bmap,
+			 hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1])
+		hclge_fd_tcam_config(hdev, HCLGE_FD_STAGE_1, true, location,
+				     NULL, false);
+
 	if (clear_list) {
 		hlist_for_each_entry_safe(rule, node, &hdev->fd_rule_list,
 					  rule_node) {
-			hclge_fd_tcam_config(hdev, HCLGE_FD_STAGE_1, true,
-					     rule->location, NULL, false);
 			hlist_del(&rule->rule_node);
 			kfree(rule);
-			hdev->hclge_fd_rule_num--;
 		}
-	} else {
-		hlist_for_each_entry_safe(rule, node, &hdev->fd_rule_list,
-					  rule_node)
-			hclge_fd_tcam_config(hdev, HCLGE_FD_STAGE_1, true,
-					     rule->location, NULL, false);
+		hdev->fd_active_type = HCLGE_FD_RULE_NONE;
+		hdev->hclge_fd_rule_num = 0;
+		bitmap_zero(hdev->fd_bmap,
+			    hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1]);
 	}
+
+	spin_unlock_bh(&hdev->fd_rule_lock);
 }
 
 static int hclge_restore_fd_entries(struct hnae3_handle *handle)
@@ -5283,6 +5326,7 @@ static int hclge_restore_fd_entries(struct hnae3_handle *handle)
 	if (!hdev->fd_en)
 		return 0;
 
+	spin_lock_bh(&hdev->fd_rule_lock);
 	hlist_for_each_entry_safe(rule, node, &hdev->fd_rule_list, rule_node) {
 		ret = hclge_config_action(hdev, HCLGE_FD_STAGE_1, rule);
 		if (!ret)
@@ -5292,11 +5336,18 @@ static int hclge_restore_fd_entries(struct hnae3_handle *handle)
 			dev_warn(&hdev->pdev->dev,
 				 "Restore rule %d failed, remove it\n",
 				 rule->location);
+			clear_bit(rule->location, hdev->fd_bmap);
 			hlist_del(&rule->rule_node);
 			kfree(rule);
 			hdev->hclge_fd_rule_num--;
 		}
 	}
+
+	if (hdev->hclge_fd_rule_num)
+		hdev->fd_active_type = HCLGE_FD_EP_ACTIVE;
+
+	spin_unlock_bh(&hdev->fd_rule_lock);
+
 	return 0;
 }
 
@@ -5329,13 +5380,18 @@ static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 
 	fs = (struct ethtool_rx_flow_spec *)&cmd->fs;
 
+	spin_lock_bh(&hdev->fd_rule_lock);
+
 	hlist_for_each_entry_safe(rule, node2, &hdev->fd_rule_list, rule_node) {
 		if (rule->location >= fs->location)
 			break;
 	}
 
-	if (!rule || fs->location != rule->location)
+	if (!rule || fs->location != rule->location) {
+		spin_unlock_bh(&hdev->fd_rule_lock);
+
 		return -ENOENT;
+	}
 
 	fs->flow_type = rule->flow_type;
 	switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT)) {
@@ -5474,6 +5530,7 @@ static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 
 		break;
 	default:
+		spin_unlock_bh(&hdev->fd_rule_lock);
 		return -EOPNOTSUPP;
 	}
 
@@ -5505,6 +5562,8 @@ static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 		fs->ring_cookie |= vf_id;
 	}
 
+	spin_unlock_bh(&hdev->fd_rule_lock);
+
 	return 0;
 }
 
@@ -5522,15 +5581,20 @@ static int hclge_get_all_rules(struct hnae3_handle *handle,
 
 	cmd->data = hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1];
 
+	spin_lock_bh(&hdev->fd_rule_lock);
 	hlist_for_each_entry_safe(rule, node2,
 				  &hdev->fd_rule_list, rule_node) {
-		if (cnt == cmd->rule_cnt)
+		if (cnt == cmd->rule_cnt) {
+			spin_unlock_bh(&hdev->fd_rule_lock);
 			return -EMSGSIZE;
+		}
 
 		rule_locs[cnt] = rule->location;
 		cnt++;
 	}
 
+	spin_unlock_bh(&hdev->fd_rule_lock);
+
 	cmd->rule_cnt = cnt;
 
 	return 0;
@@ -5565,10 +5629,12 @@ static void hclge_enable_fd(struct hnae3_handle *handle, bool enable)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
+	bool clear;
 
 	hdev->fd_en = enable;
+	clear = hdev->fd_active_type == HCLGE_FD_ARFS_ACTIVE ? true : false;
 	if (!enable)
-		hclge_del_all_fd_entries(handle, false);
+		hclge_del_all_fd_entries(handle, clear);
 	else
 		hclge_restore_fd_entries(handle);
 }
@@ -8143,6 +8209,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	mutex_init(&hdev->vport_lock);
 	mutex_init(&hdev->vport_cfg_mutex);
+	spin_lock_init(&hdev->fd_rule_lock);
 
 	ret = hclge_pci_init(hdev);
 	if (ret) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index dd06b11..2976bad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -578,6 +578,15 @@ static const struct key_info tuple_key_info[] = {
 #define MAX_KEY_BYTES	(MAX_KEY_DWORDS * 4)
 #define MAX_META_DATA_LENGTH	32
 
+/* assigned by firmware, the real filter number for each pf may be less */
+#define MAX_FD_FILTER_NUM	4096
+
+enum HCLGE_FD_ACTIVE_RULE_TYPE {
+	HCLGE_FD_RULE_NONE,
+	HCLGE_FD_ARFS_ACTIVE,
+	HCLGE_FD_EP_ACTIVE,
+};
+
 enum HCLGE_FD_PACKET_TYPE {
 	NIC_PACKET,
 	ROCE_PACKET,
@@ -630,6 +639,7 @@ struct hclge_fd_rule {
 	u16 vf_id;
 	u16 queue_id;
 	u16 location;
+	enum HCLGE_FD_ACTIVE_RULE_TYPE rule_type;
 };
 
 struct hclge_fd_ad_data {
@@ -809,7 +819,10 @@ struct hclge_dev {
 
 	struct hclge_fd_cfg fd_cfg;
 	struct hlist_head fd_rule_list;
+	spinlock_t fd_rule_lock; /* protect fd_rule_list and fd_bmap */
 	u16 hclge_fd_rule_num;
+	unsigned long fd_bmap[BITS_TO_LONGS(MAX_FD_FILTER_NUM)];
+	enum HCLGE_FD_ACTIVE_RULE_TYPE fd_active_type;
 	u8 fd_en;
 
 	u16 wanted_umv_size;
-- 
2.7.4

