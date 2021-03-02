Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AA032A357
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382115AbhCBIz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:55:59 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13411 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835945AbhCBG3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 01:29:52 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DqRwL1wNNzjTLm;
        Tue,  2 Mar 2021 14:26:10 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Mar 2021 14:27:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC net-next 5/9] net: hns3: refactor flow director configuration
Date:   Tue, 2 Mar 2021 14:27:51 +0800
Message-ID: <1614666475-13059-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614666475-13059-1-git-send-email-tanhuazhong@huawei.com>
References: <1614666475-13059-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, there are 3 flow director work modes in HNS3 driver,
include EP(ethtool), tc flower and aRFS. The flow director rules
are configured synchronously and need holding spin lock. With this
limitation, all the commands with firmware are also needed to use
spin lock.

To eliminate the limitation, configure flow director rules
asynchronously. The rules are still kept in the fd_rule_list
with below states.
TO_ADD: the rule is waiting to add to hardware
TO_DEL: the rule is waiting to remove from hardware
ADDING: the rule is adding to hardware
ACTIVE: the rule is already added in hardware

When receive a new request to add or delete flow director rule,
check whether the rule location is existent, update the rule
content and state, and request to schedule the service task to
finish the configuration.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 629 ++++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  10 +
 2 files changed, 420 insertions(+), 219 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 0a121ee..8ba07cf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -62,7 +62,7 @@ static void hclge_sync_vlan_filter(struct hclge_dev *hdev);
 static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev);
 static bool hclge_get_hw_reset_stat(struct hnae3_handle *handle);
 static void hclge_rfs_filter_expire(struct hclge_dev *hdev);
-static void hclge_clear_arfs_rules(struct hnae3_handle *handle);
+static void hclge_clear_arfs_rules(struct hclge_dev *hdev);
 static enum hnae3_reset_type hclge_get_reset_level(struct hnae3_ae_dev *ae_dev,
 						   unsigned long *addr);
 static int hclge_set_default_loopback(struct hclge_dev *hdev);
@@ -70,6 +70,7 @@ static int hclge_set_default_loopback(struct hclge_dev *hdev);
 static void hclge_sync_mac_table(struct hclge_dev *hdev);
 static void hclge_restore_hw_table(struct hclge_dev *hdev);
 static void hclge_sync_promisc_mode(struct hclge_dev *hdev);
+static void hclge_sync_fd_table(struct hclge_dev *hdev);
 
 static struct hnae3_ae_algo ae_algo;
 
@@ -4115,6 +4116,7 @@ static void hclge_periodic_service_task(struct hclge_dev *hdev)
 	hclge_update_link_status(hdev);
 	hclge_sync_mac_table(hdev);
 	hclge_sync_promisc_mode(hdev);
+	hclge_sync_fd_table(hdev);
 
 	if (time_is_after_jiffies(hdev->last_serv_processed + HZ)) {
 		delta = jiffies - hdev->last_serv_processed;
@@ -5016,6 +5018,198 @@ static void hclge_request_update_promisc_mode(struct hnae3_handle *handle)
 	set_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state);
 }
 
+static void hclge_sync_fd_state(struct hclge_dev *hdev)
+{
+	if (hlist_empty(&hdev->fd_rule_list))
+		hdev->fd_active_type = HCLGE_FD_RULE_NONE;
+}
+
+static void hclge_update_fd_rule_node(struct hclge_dev *hdev,
+				      struct hclge_fd_rule *old_rule,
+				      struct hclge_fd_rule *new_rule,
+				      enum HCLGE_FD_NODE_STATE state)
+{
+	switch (state) {
+	case HCLGE_FD_TO_ADD:
+		/* if new request is TO_ADD, we should configure the
+		 * new rule to hardware, no matter what the state of
+		 * old rule is. Even though the old rule is already
+		 * configured in the hardware, the new rule will replace
+		 * it.
+		 */
+		new_rule->rule_node.next = old_rule->rule_node.next;
+		new_rule->rule_node.pprev = old_rule->rule_node.pprev;
+		memcpy(old_rule, new_rule, sizeof(*old_rule));
+		kfree(new_rule);
+		break;
+	case HCLGE_FD_TO_DEL:
+		/* if new request is TO_DEL, and old rule is existent
+		 * 1) the state of old rule is TO_DEL, we need do nothing,
+		 * because we delete rule by location, other rule content
+		 * is unncessary.
+		 * 2) the state of old rule is ACTIVE, we need to change its
+		 * state to TO_DEL, so the rule will be deleted when periodic
+		 * task being scheduled.
+		 * 3) the state of old rule is TO_ADD, it means the rule hasn't
+		 * been added to hardware, so we just delete the rule node from
+		 * fd_rule_list directly.
+		 * 4) the state of old rule is ADDING, it means the rule is
+		 * being configured to hardware. We also delete the rule node
+		 * from fd_rule_list directly, and will handle configuration
+		 * result of old rule in hclge_fd_sync_from_add_list().
+		 */
+		if (old_rule->state == HCLGE_FD_TO_ADD ||
+		    old_rule->state == HCLGE_FD_ADDING) {
+			if (test_bit(old_rule->location, hdev->fd_bmap)) {
+				clear_bit(old_rule->location, hdev->fd_bmap);
+				hdev->hclge_fd_rule_num--;
+			}
+			hlist_del(&old_rule->rule_node);
+			kfree(old_rule);
+			hclge_sync_fd_state(hdev);
+			return;
+		}
+		old_rule->state = HCLGE_FD_TO_DEL;
+		break;
+	default:
+		break;
+	}
+}
+
+static struct hclge_fd_rule *hclge_find_fd_rule(struct hlist_head *hlist,
+						u16 location,
+						struct hclge_fd_rule **parent)
+{
+	struct hclge_fd_rule *rule;
+	struct hlist_node *node;
+
+	hlist_for_each_entry_safe(rule, node, hlist, rule_node) {
+		if (rule->location == location)
+			return rule;
+		else if (rule->location > location)
+			return NULL;
+		/* record the parent node, use to keep the nodes in fd_rule_list
+		 * in ascend order.
+		 */
+		*parent = rule;
+	}
+
+	return NULL;
+}
+
+/* insert fd rule node in ascend order according to rule->location */
+static void hclge_fd_insert_rule_node(struct hlist_head *hlist,
+				      struct hclge_fd_rule *rule,
+				      struct hclge_fd_rule *parent)
+{
+	INIT_HLIST_NODE(&rule->rule_node);
+
+	if (parent)
+		hlist_add_behind(&rule->rule_node, &parent->rule_node);
+	else
+		hlist_add_head(&rule->rule_node, hlist);
+}
+
+static int hclge_update_fd_list(struct hclge_dev *hdev,
+				enum HCLGE_FD_NODE_STATE state, u16 location,
+				struct hclge_fd_rule *new_rule)
+{
+	struct hlist_head *hlist = &hdev->fd_rule_list;
+	struct hclge_fd_rule *fd_rule, *parent = NULL;
+
+	fd_rule = hclge_find_fd_rule(hlist, location, &parent);
+	if (fd_rule) {
+		hclge_update_fd_rule_node(hdev, fd_rule, new_rule, state);
+		set_bit(HCLGE_STATE_FD_TBL_CHANGED, &hdev->state);
+		hclge_task_schedule(hdev, 0);
+		return 0;
+	}
+
+	/* if this rule is never added, unnecessary to delete */
+	if (state == HCLGE_FD_TO_DEL) {
+		dev_err(&hdev->pdev->dev,
+			"failed to delete fd rule %u , it's inexistent\n",
+			location);
+		return -ENOENT;
+	}
+
+	hclge_fd_insert_rule_node(hlist, new_rule, parent);
+	if (!test_bit(location, hdev->fd_bmap)) {
+		set_bit(location, hdev->fd_bmap);
+		hdev->hclge_fd_rule_num++;
+	}
+	set_bit(HCLGE_STATE_FD_TBL_CHANGED, &hdev->state);
+	hclge_task_schedule(hdev, 0);
+
+	return 0;
+}
+
+static void hclge_fd_sync_from_add_list(struct hlist_head *add_list,
+					struct hlist_head *hlist)
+{
+	struct hclge_fd_rule *rule, *new_rule, *parent = NULL;
+	struct hlist_node *node;
+
+	hlist_for_each_entry_safe(rule, node, add_list, rule_node) {
+		new_rule = hclge_find_fd_rule(hlist, rule->location, &parent);
+		if (new_rule) {
+			/* if new_rule state is TO_ADD, it means received a new
+			 * TO_ADD request while adding the rule to hardware, so
+			 * ignore the adding result, keep the new rule state.
+			 * if still ADDING, change the rule state according to
+			 * the adding result.
+			 */
+			if (new_rule->state == HCLGE_FD_ADDING)
+				new_rule->state = rule->state;
+
+			hlist_del(&rule->rule_node);
+			kfree(rule);
+			continue;
+		}
+		/* if new_rule is inexist, it means received a new TO_DEL
+		 * request while adding fd rule to hardware.
+		 * if adding fail, unnecessary to retry;
+		 * if adding success, sync it to the fd_rule_list, and change
+		 * state to TO_DEL
+		 */
+		if (rule->state == HCLGE_FD_TO_ADD) {
+			hlist_del(&rule->rule_node);
+			kfree(rule);
+		} else if (rule->state == HCLGE_FD_ACTIVE) {
+			rule->state = HCLGE_FD_TO_DEL;
+			hlist_del(&rule->rule_node);
+			hclge_fd_insert_rule_node(hlist, rule, parent);
+		}
+	}
+}
+
+static void hclge_fd_sync_from_del_list(struct hlist_head *del_list,
+					struct hlist_head *hlist)
+{
+	struct hclge_fd_rule *rule, *new_rule, *parent = NULL;
+	struct hlist_node *node;
+
+	hlist_for_each_entry_safe(rule, node, del_list, rule_node) {
+		new_rule = hclge_find_fd_rule(hlist, rule->location, &parent);
+		if (new_rule) {
+			/* if new_rule exists, its state must be TO_ADD, it
+			 * means received a new TO_ADD request with same
+			 * location while removing the rule from hardware, so
+			 * ignore the removing result, keep the new rule state.
+			 */
+			hlist_del(&rule->rule_node);
+			kfree(rule);
+			continue;
+		}
+		/* if new_rule is inexistent, it means no new request received
+		 * for the location while removing fd rule to hardware.
+		 * sync the fail removing fd rule nodes to the fd_rule_list;
+		 */
+		hlist_del(&rule->rule_node);
+		hclge_fd_insert_rule_node(hlist, rule, parent);
+	}
+}
+
 static int hclge_get_fd_mode(struct hclge_dev *hdev, u8 *fd_mode)
 {
 	struct hclge_get_fd_mode_cmd *req;
@@ -5701,74 +5895,6 @@ static int hclge_fd_check_spec(struct hclge_dev *hdev,
 	return hclge_fd_check_ext_tuple(hdev, fs, unused_tuple);
 }
 
-static bool hclge_fd_rule_exist(struct hclge_dev *hdev, u16 location)
-{
-	struct hclge_fd_rule *rule = NULL;
-	struct hlist_node *node2;
-
-	spin_lock_bh(&hdev->fd_rule_lock);
-	hlist_for_each_entry_safe(rule, node2, &hdev->fd_rule_list, rule_node) {
-		if (rule->location >= location)
-			break;
-	}
-
-	spin_unlock_bh(&hdev->fd_rule_lock);
-
-	return  rule && rule->location == location;
-}
-
-/* make sure being called after lock up with fd_rule_lock */
-static int hclge_fd_update_rule_list(struct hclge_dev *hdev,
-				     struct hclge_fd_rule *new_rule,
-				     u16 location,
-				     bool is_add)
-{
-	struct hclge_fd_rule *rule = NULL, *parent = NULL;
-	struct hlist_node *node2;
-
-	if (is_add && !new_rule)
-		return -EINVAL;
-
-	hlist_for_each_entry_safe(rule, node2,
-				  &hdev->fd_rule_list, rule_node) {
-		if (rule->location >= location)
-			break;
-		parent = rule;
-	}
-
-	if (rule && rule->location == location) {
-		hlist_del(&rule->rule_node);
-		kfree(rule);
-		hdev->hclge_fd_rule_num--;
-
-		if (!is_add) {
-			if (!hdev->hclge_fd_rule_num)
-				hdev->fd_active_type = HCLGE_FD_RULE_NONE;
-			clear_bit(location, hdev->fd_bmap);
-
-			return 0;
-		}
-	} else if (!is_add) {
-		dev_err(&hdev->pdev->dev,
-			"delete fail, rule %u is inexistent\n",
-			location);
-		return -EINVAL;
-	}
-
-	INIT_HLIST_NODE(&new_rule->rule_node);
-
-	if (parent)
-		hlist_add_behind(&new_rule->rule_node, &parent->rule_node);
-	else
-		hlist_add_head(&new_rule->rule_node, &hdev->fd_rule_list);
-
-	set_bit(location, hdev->fd_bmap);
-	hdev->hclge_fd_rule_num++;
-	hdev->fd_active_type = new_rule->rule_type;
-
-	return 0;
-}
-
 static void hclge_fd_get_tcpip4_tuple(struct hclge_dev *hdev,
 				      struct ethtool_rx_flow_spec *fs,
 				      struct hclge_fd_rule *rule, u8 ip_proto)
@@ -5942,33 +6068,42 @@ static int hclge_fd_get_tuple(struct hclge_dev *hdev,
 	return 0;
 }
 
-/* make sure being called after lock up with fd_rule_lock */
 static int hclge_fd_config_rule(struct hclge_dev *hdev,
 				struct hclge_fd_rule *rule)
 {
 	int ret;
 
-	if (!rule) {
+	ret = hclge_config_action(hdev, HCLGE_FD_STAGE_1, rule);
+	if (ret)
+		return ret;
+
+	return hclge_config_key(hdev, HCLGE_FD_STAGE_1, rule);
+}
+
+static int hclge_add_fd_entry_common(struct hclge_dev *hdev,
+				     struct hclge_fd_rule *rule)
+{
+	int ret;
+
+	spin_lock_bh(&hdev->fd_rule_lock);
+
+	if (hdev->fd_active_type != rule->rule_type &&
+	    (hdev->fd_active_type == HCLGE_FD_TC_FLOWER_ACTIVE ||
+	     hdev->fd_active_type == HCLGE_FD_EP_ACTIVE)) {
 		dev_err(&hdev->pdev->dev,
-			"The flow director rule is NULL\n");
+			"mode conflict(new type %d, active type %d), please delete existent rules first\n",
+			rule->rule_type, hdev->fd_active_type);
+		spin_unlock_bh(&hdev->fd_rule_lock);
 		return -EINVAL;
 	}
 
-	/* it will never fail here, so needn't to check return value */
-	hclge_fd_update_rule_list(hdev, rule, rule->location, true);
+	hclge_clear_arfs_rules(hdev);
 
-	ret = hclge_config_action(hdev, HCLGE_FD_STAGE_1, rule);
-	if (ret)
-		goto clear_rule;
-
-	ret = hclge_config_key(hdev, HCLGE_FD_STAGE_1, rule);
-	if (ret)
-		goto clear_rule;
+	ret = hclge_update_fd_list(hdev, HCLGE_FD_TO_ADD, rule->location, rule);
+	hdev->fd_active_type = rule->rule_type;
 
-	return 0;
+	spin_unlock_bh(&hdev->fd_rule_lock);
 
-clear_rule:
-	hclge_fd_update_rule_list(hdev, rule, rule->location, false);
 	return ret;
 }
 
@@ -6040,12 +6175,6 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 		return -EOPNOTSUPP;
 	}
 
-	if (hclge_is_cls_flower_active(handle)) {
-		dev_err(&hdev->pdev->dev,
-			"please delete all exist cls flower rules first\n");
-		return -EINVAL;
-	}
-
 	fs = (struct ethtool_rx_flow_spec *)&cmd->fs;
 
 	ret = hclge_fd_check_spec(hdev, fs, &unused);
@@ -6075,15 +6204,9 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 	rule->action = action;
 	rule->rule_type = HCLGE_FD_EP_ACTIVE;
 
-	/* to avoid rule conflict, when user configure rule by ethtool,
-	 * we need to clear all arfs rules
-	 */
-	spin_lock_bh(&hdev->fd_rule_lock);
-	hclge_clear_arfs_rules(handle);
-
-	ret = hclge_fd_config_rule(hdev, rule);
-
-	spin_unlock_bh(&hdev->fd_rule_lock);
+	ret = hclge_add_fd_entry_common(hdev, rule);
+	if (ret)
+		kfree(rule);
 
 	return ret;
 }
@@ -6104,32 +6227,23 @@ static int hclge_del_fd_entry(struct hnae3_handle *handle,
 	if (fs->location >= hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1])
 		return -EINVAL;
 
-	if (hclge_is_cls_flower_active(handle) || !hdev->hclge_fd_rule_num ||
-	    !hclge_fd_rule_exist(hdev, fs->location)) {
+	spin_lock_bh(&hdev->fd_rule_lock);
+	if (hdev->fd_active_type == HCLGE_FD_TC_FLOWER_ACTIVE ||
+	    !hdev->hclge_fd_rule_num) {
 		dev_err(&hdev->pdev->dev,
 			"Delete fail, rule %u is inexistent\n", fs->location);
+		spin_unlock_bh(&hdev->fd_rule_lock);
 		return -ENOENT;
 	}
-
-	ret = hclge_fd_tcam_config(hdev, HCLGE_FD_STAGE_1, true, fs->location,
-				   NULL, false);
-	if (ret)
-		return ret;
-
-	spin_lock_bh(&hdev->fd_rule_lock);
-	ret = hclge_fd_update_rule_list(hdev, NULL, fs->location, false);
-
+	ret = hclge_update_fd_list(hdev, HCLGE_FD_TO_DEL, fs->location, NULL);
 	spin_unlock_bh(&hdev->fd_rule_lock);
 
 	return ret;
 }
 
-/* make sure being called after lock up with fd_rule_lock */
-static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
-				     bool clear_list)
+static void hclge_clear_fd_rules_in_list(struct hclge_dev *hdev,
+					 bool clear_list)
 {
-	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hclge_dev *hdev = vport->back;
 	struct hclge_fd_rule *rule;
 	struct hlist_node *node;
 	u16 location;
@@ -6143,6 +6257,7 @@ static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
 				     NULL, false);
 
 	if (clear_list) {
+		spin_lock_bh(&hdev->fd_rule_lock);
 		hlist_for_each_entry_safe(rule, node, &hdev->fd_rule_list,
 					  rule_node) {
 			hlist_del(&rule->rule_node);
@@ -6152,16 +6267,25 @@ static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
 		hdev->hclge_fd_rule_num = 0;
 		bitmap_zero(hdev->fd_bmap,
 			    hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1]);
+		spin_unlock_bh(&hdev->fd_rule_lock);
 	}
 }
 
+static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
+				     bool clear_list)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+
+	hclge_clear_fd_rules_in_list(hdev, clear_list);
+}
+
 static int hclge_restore_fd_entries(struct hnae3_handle *handle)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_fd_rule *rule;
 	struct hlist_node *node;
-	int ret;
 
 	/* Return ok here, because reset error handling will check this
 	 * return value. If error is returned here, the reset process will
@@ -6176,25 +6300,11 @@ static int hclge_restore_fd_entries(struct hnae3_handle *handle)
 
 	spin_lock_bh(&hdev->fd_rule_lock);
 	hlist_for_each_entry_safe(rule, node, &hdev->fd_rule_list, rule_node) {
-		ret = hclge_config_action(hdev, HCLGE_FD_STAGE_1, rule);
-		if (!ret)
-			ret = hclge_config_key(hdev, HCLGE_FD_STAGE_1, rule);
-
-		if (ret) {
-			dev_warn(&hdev->pdev->dev,
-				 "Restore rule %u failed, remove it\n",
-				 rule->location);
-			clear_bit(rule->location, hdev->fd_bmap);
-			hlist_del(&rule->rule_node);
-			kfree(rule);
-			hdev->hclge_fd_rule_num--;
-		}
+		if (rule->state == HCLGE_FD_ACTIVE)
+			rule->state = HCLGE_FD_TO_ADD;
 	}
-
-	if (hdev->hclge_fd_rule_num)
-		hdev->fd_active_type = HCLGE_FD_EP_ACTIVE;
-
 	spin_unlock_bh(&hdev->fd_rule_lock);
+	set_bit(HCLGE_STATE_FD_TBL_CHANGED, &hdev->state);
 
 	return 0;
 }
@@ -6464,6 +6574,9 @@ static int hclge_get_all_rules(struct hnae3_handle *handle,
 			return -EMSGSIZE;
 		}
 
+		if (rule->state == HCLGE_FD_TO_DEL)
+			continue;
+
 		rule_locs[cnt] = rule->location;
 		cnt++;
 	}
@@ -6545,7 +6658,6 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 	struct hclge_fd_rule_tuples new_tuples = {};
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_fd_rule *rule;
-	u16 tmp_queue_id;
 	u16 bit_id;
 	int ret;
 
@@ -6583,34 +6695,25 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 			return -ENOMEM;
 		}
 
-		set_bit(bit_id, hdev->fd_bmap);
 		rule->location = bit_id;
 		rule->arfs.flow_id = flow_id;
 		rule->queue_id = queue_id;
 		hclge_fd_build_arfs_rule(&new_tuples, rule);
-		ret = hclge_fd_config_rule(hdev, rule);
-
-		spin_unlock_bh(&hdev->fd_rule_lock);
-
-		if (ret)
+		ret = hclge_update_fd_list(hdev, HCLGE_FD_TO_ADD,
+					   rule->location, rule);
+		if (ret) {
+			kfree(rule);
+			spin_unlock_bh(&hdev->fd_rule_lock);
 			return ret;
-
-		return rule->location;
+		}
+		hdev->fd_active_type = HCLGE_FD_ARFS_ACTIVE;
+	} else if (rule->queue_id != queue_id) {
+		rule->queue_id = queue_id;
+		rule->state = HCLGE_FD_TO_ADD;
+		set_bit(HCLGE_STATE_FD_TBL_CHANGED, &hdev->state);
+		hclge_task_schedule(hdev, 0);
 	}
-
 	spin_unlock_bh(&hdev->fd_rule_lock);
-
-	if (rule->queue_id == queue_id)
-		return rule->location;
-
-	tmp_queue_id = rule->queue_id;
-	rule->queue_id = queue_id;
-	ret = hclge_config_action(hdev, HCLGE_FD_STAGE_1, rule);
-	if (ret) {
-		rule->queue_id = tmp_queue_id;
-		return ret;
-	}
-
 	return rule->location;
 }
 
@@ -6620,7 +6723,6 @@ static void hclge_rfs_filter_expire(struct hclge_dev *hdev)
 	struct hnae3_handle *handle = &hdev->vport[0].nic;
 	struct hclge_fd_rule *rule;
 	struct hlist_node *node;
-	HLIST_HEAD(del_list);
 
 	spin_lock_bh(&hdev->fd_rule_lock);
 	if (hdev->fd_active_type != HCLGE_FD_ARFS_ACTIVE) {
@@ -6628,33 +6730,38 @@ static void hclge_rfs_filter_expire(struct hclge_dev *hdev)
 		return;
 	}
 	hlist_for_each_entry_safe(rule, node, &hdev->fd_rule_list, rule_node) {
+		if (rule->state != HCLGE_FD_ACTIVE)
+			continue;
 		if (rps_may_expire_flow(handle->netdev, rule->queue_id,
 					rule->arfs.flow_id, rule->location)) {
-			hlist_del_init(&rule->rule_node);
-			hlist_add_head(&rule->rule_node, &del_list);
-			hdev->hclge_fd_rule_num--;
-			clear_bit(rule->location, hdev->fd_bmap);
+			rule->state = HCLGE_FD_TO_DEL;
+			set_bit(HCLGE_STATE_FD_TBL_CHANGED, &hdev->state);
 		}
 	}
 	spin_unlock_bh(&hdev->fd_rule_lock);
-
-	hlist_for_each_entry_safe(rule, node, &del_list, rule_node) {
-		hclge_fd_tcam_config(hdev, HCLGE_FD_STAGE_1, true,
-				     rule->location, NULL, false);
-		kfree(rule);
-	}
 #endif
 }
 
 /* make sure being called after lock up with fd_rule_lock */
-static void hclge_clear_arfs_rules(struct hnae3_handle *handle)
+static void hclge_clear_arfs_rules(struct hclge_dev *hdev)
 {
 #ifdef CONFIG_RFS_ACCEL
-	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hclge_dev *hdev = vport->back;
+	struct hclge_fd_rule *rule;
+	struct hlist_node *node;
+
+	if (hdev->fd_active_type != HCLGE_FD_ARFS_ACTIVE)
+		return;
 
-	if (hdev->fd_active_type == HCLGE_FD_ARFS_ACTIVE)
-		hclge_del_all_fd_entries(handle, true);
+	hlist_for_each_entry_safe(rule, node, &hdev->fd_rule_list, rule_node) {
+		if (rule->state == HCLGE_FD_ACTIVE) {
+			rule->state = HCLGE_FD_TO_DEL;
+		} else if (rule->state == HCLGE_FD_TO_ADD ||
+			   rule->state == HCLGE_FD_ADDING) {
+			hlist_del(&rule->rule_node);
+			kfree(rule);
+		}
+	}
+	set_bit(HCLGE_STATE_FD_TBL_CHANGED, &hdev->state);
 #endif
 }
 
@@ -6837,12 +6944,6 @@ static int hclge_add_cls_flower(struct hnae3_handle *handle,
 	struct hclge_fd_rule *rule;
 	int ret;
 
-	if (hdev->fd_active_type == HCLGE_FD_EP_ACTIVE) {
-		dev_err(&hdev->pdev->dev,
-			"please remove all exist fd rules via ethtool first\n");
-		return -EINVAL;
-	}
-
 	ret = hclge_check_cls_flower(hdev, cls_flower, tc);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
@@ -6855,8 +6956,10 @@ static int hclge_add_cls_flower(struct hnae3_handle *handle,
 		return -ENOMEM;
 
 	ret = hclge_parse_cls_flower(hdev, cls_flower, rule);
-	if (ret)
-		goto err;
+	if (ret) {
+		kfree(rule);
+		return ret;
+	}
 
 	rule->action = HCLGE_FD_ACTION_SELECT_TC;
 	rule->cls_flower.tc = tc;
@@ -6865,22 +6968,10 @@ static int hclge_add_cls_flower(struct hnae3_handle *handle,
 	rule->cls_flower.cookie = cls_flower->cookie;
 	rule->rule_type = HCLGE_FD_TC_FLOWER_ACTIVE;
 
-	spin_lock_bh(&hdev->fd_rule_lock);
-	hclge_clear_arfs_rules(handle);
-
-	ret = hclge_fd_config_rule(hdev, rule);
-
-	spin_unlock_bh(&hdev->fd_rule_lock);
-
-	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"failed to add cls flower rule, ret = %d\n", ret);
-		goto err;
-	}
+	ret = hclge_add_fd_entry_common(hdev, rule);
+	if (ret)
+		kfree(rule);
 
-	return 0;
-err:
-	kfree(rule);
 	return ret;
 }
 
@@ -6914,28 +7005,131 @@ static int hclge_del_cls_flower(struct hnae3_handle *handle,
 		return -EINVAL;
 	}
 
-	ret = hclge_fd_tcam_config(hdev, HCLGE_FD_STAGE_1, true, rule->location,
-				   NULL, false);
-	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"failed to delete cls flower rule %u, ret = %d\n",
-			rule->location, ret);
-		spin_unlock_bh(&hdev->fd_rule_lock);
-		return ret;
+	ret = hclge_update_fd_list(hdev, HCLGE_FD_TO_DEL, rule->location, NULL);
+
+	spin_unlock_bh(&hdev->fd_rule_lock);
+
+	return ret;
+}
+
+static void hclge_unsync_fd_list(struct hclge_dev *hdev,
+				 struct hlist_head *hlist)
+{
+	struct hclge_fd_rule *rule;
+	struct hlist_node *node;
+	int ret;
+
+	hlist_for_each_entry_safe(rule, node, hlist, rule_node) {
+		ret = hclge_fd_tcam_config(hdev, HCLGE_FD_STAGE_1, true,
+					   rule->location, NULL, false);
+		if (ret) {
+			set_bit(HCLGE_STATE_FD_TBL_CHANGED, &hdev->state);
+			return;
+		}
+		hlist_del(&rule->rule_node);
+		kfree(rule);
 	}
+}
 
-	ret = hclge_fd_update_rule_list(hdev, NULL, rule->location, false);
-	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"failed to delete cls flower rule %u in list, ret = %d\n",
-			rule->location, ret);
-		spin_unlock_bh(&hdev->fd_rule_lock);
-		return ret;
+static void hclge_sync_fd_list(struct hclge_dev *hdev, struct hlist_head *hlist)
+{
+	struct hclge_fd_rule *rule;
+	struct hlist_node *node;
+	int ret;
+
+	hlist_for_each_entry_safe(rule, node, hlist, rule_node) {
+		ret = hclge_fd_config_rule(hdev, rule);
+		if (ret) {
+			set_bit(HCLGE_STATE_FD_TBL_CHANGED, &hdev->state);
+			return;
+		}
+		rule->state = HCLGE_FD_ACTIVE;
 	}
+}
+
+static void hclge_sync_fd_rule_num(struct hclge_dev *hdev)
+{
+	struct hclge_fd_rule *rule;
+	struct hlist_node *node;
 
+	hdev->hclge_fd_rule_num = 0;
+	bitmap_zero(hdev->fd_bmap, hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1]);
+	hlist_for_each_entry_safe(rule, node, &hdev->fd_rule_list, rule_node) {
+		if (rule->state == HCLGE_FD_TO_DEL)
+			continue;
+		set_bit(rule->location, hdev->fd_bmap);
+		hdev->hclge_fd_rule_num++;
+	}
+	hclge_sync_fd_state(hdev);
+}
+
+static void hclge_sync_fd_table(struct hclge_dev *hdev)
+{
+	struct hlist_head *hlist = &hdev->fd_rule_list;
+	struct hlist_head tmp_add_list, tmp_del_list;
+	struct hclge_fd_rule *parent_add = NULL;
+	struct hclge_fd_rule *parent_del = NULL;
+	struct hclge_fd_rule *rule, *new_rule;
+	struct hlist_node *node;
+
+	if (test_and_clear_bit(HCLGE_STATE_FD_CLEAR_ALL, &hdev->state)) {
+		bool clear_list = hdev->fd_active_type == HCLGE_FD_ARFS_ACTIVE;
+
+		hclge_clear_fd_rules_in_list(hdev, clear_list);
+	}
+
+	if (!test_and_clear_bit(HCLGE_STATE_FD_TBL_CHANGED, &hdev->state))
+		return;
+
+	INIT_HLIST_HEAD(&tmp_add_list);
+	INIT_HLIST_HEAD(&tmp_del_list);
+
+	spin_lock_bh(&hdev->fd_rule_lock);
+	/* move the fd rule node to the tmp_add_list and tmp_del_list, then
+	 * we can add/delete these fd rule outside the spin lock
+	 */
+	hlist_for_each_entry_safe(rule, node, hlist, rule_node) {
+		switch (rule->state) {
+		case HCLGE_FD_TO_DEL:
+			hlist_del(&rule->rule_node);
+			hclge_fd_insert_rule_node(&tmp_del_list, rule,
+						  parent_del);
+			parent_del = rule;
+			break;
+		case HCLGE_FD_TO_ADD:
+			if (!hdev->fd_en)
+				break;
+			new_rule = kmemdup(rule, sizeof(*new_rule), GFP_ATOMIC);
+			if (!new_rule)
+				goto stop_traverse;
+			rule->state = HCLGE_FD_ADDING;
+			new_rule->state = HCLGE_FD_TO_ADD;
+			hclge_fd_insert_rule_node(&tmp_add_list, new_rule,
+						  parent_add);
+			parent_add = new_rule;
+			break;
+		default:
+			break;
+		}
+	}
+
+stop_traverse:
 	spin_unlock_bh(&hdev->fd_rule_lock);
 
-	return 0;
+	hclge_unsync_fd_list(hdev, &tmp_del_list);
+	hclge_sync_fd_list(hdev, &tmp_add_list);
+
+	/* if some fd rule were added/deleted fail, move back to the
+	 * fd_rule_list, and retry at next time.
+	 */
+	spin_lock_bh(&hdev->fd_rule_lock);
+
+	hclge_fd_sync_from_del_list(&tmp_del_list, hlist);
+	hclge_fd_sync_from_add_list(&tmp_add_list, hlist);
+
+	hclge_sync_fd_rule_num(hdev);
+
+	spin_unlock_bh(&hdev->fd_rule_lock);
 }
 
 static bool hclge_get_hw_reset_stat(struct hnae3_handle *handle)
@@ -6975,18 +7169,15 @@ static void hclge_enable_fd(struct hnae3_handle *handle, bool enable)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
-	bool clear;
 
 	hdev->fd_en = enable;
-	clear = hdev->fd_active_type == HCLGE_FD_ARFS_ACTIVE;
 
-	if (!enable) {
-		spin_lock_bh(&hdev->fd_rule_lock);
-		hclge_del_all_fd_entries(handle, clear);
-		spin_unlock_bh(&hdev->fd_rule_lock);
-	} else {
+	if (!enable)
+		set_bit(HCLGE_STATE_FD_CLEAR_ALL, &hdev->state);
+	else
 		hclge_restore_fd_entries(handle);
-	}
+
+	hclge_task_schedule(hdev, 0);
 }
 
 static void hclge_cfg_mac_mode(struct hclge_dev *hdev, bool enable)
@@ -7450,7 +7641,7 @@ static void hclge_ae_stop(struct hnae3_handle *handle)
 
 	set_bit(HCLGE_STATE_DOWN, &hdev->state);
 	spin_lock_bh(&hdev->fd_rule_lock);
-	hclge_clear_arfs_rules(handle);
+	hclge_clear_arfs_rules(hdev);
 	spin_unlock_bh(&hdev->fd_rule_lock);
 
 	/* If it is not PF reset, the firmware will disable the MAC,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 6fe7455..696bcc1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -223,6 +223,8 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_LINK_UPDATING,
 	HCLGE_STATE_PROMISC_CHANGED,
 	HCLGE_STATE_RST_FAIL,
+	HCLGE_STATE_FD_TBL_CHANGED,
+	HCLGE_STATE_FD_CLEAR_ALL,
 	HCLGE_STATE_MAX
 };
 
@@ -592,6 +594,13 @@ enum HCLGE_FD_ACTION {
 	HCLGE_FD_ACTION_SELECT_TC,
 };
 
+enum HCLGE_FD_NODE_STATE {
+	HCLGE_FD_TO_ADD,
+	HCLGE_FD_TO_DEL,
+	HCLGE_FD_ACTIVE,
+	HCLGE_FD_ADDING
+};
+
 struct hclge_fd_key_cfg {
 	u8 key_sel;
 	u8 inner_sipv6_word_en;
@@ -647,6 +656,7 @@ struct hclge_fd_rule {
 	u16 vf_id;
 	u16 location;
 	enum HCLGE_FD_ACTIVE_RULE_TYPE rule_type;
+	enum HCLGE_FD_NODE_STATE state;
 	u8 action;
 };
 
-- 
2.7.4

