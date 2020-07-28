Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2461F22FF73
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 04:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgG1CTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 22:19:13 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8286 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbgG1CTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 22:19:12 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8C8081CFD7E6C69A53A6;
        Tue, 28 Jul 2020 10:19:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 28 Jul 2020 10:19:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 4/5] net: hns3: fix aRFS FD rules leftover after add a user FD rule
Date:   Tue, 28 Jul 2020 10:16:51 +0800
Message-ID: <1595902612-12880-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595902612-12880-1-git-send-email-tanhuazhong@huawei.com>
References: <1595902612-12880-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

When user had created a FD rule, all the aRFS rules should be clear up.
HNS3 process flow as below:
1.get spin lock of fd_ruls_list
2.clear up all aRFS rules
3.release lock
4.get spin lock of fd_ruls_list
5.creat a rules
6.release lock;

There is a short period of time between step 3 and step 4, which would
creatting some new aRFS FD rules if driver was receiving packet.
So refactor the fd_rule_lock to fix it.

Fixes: 441228875706 ("net: hns3: refine the flow director handle")
Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 28 ++++++++++++----------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index bb4a632..cee84e7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5806,9 +5806,9 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 	/* to avoid rule conflict, when user configure rule by ethtool,
 	 * we need to clear all arfs rules
 	 */
+	spin_lock_bh(&hdev->fd_rule_lock);
 	hclge_clear_arfs_rules(handle);
 
-	spin_lock_bh(&hdev->fd_rule_lock);
 	ret = hclge_fd_config_rule(hdev, rule);
 
 	spin_unlock_bh(&hdev->fd_rule_lock);
@@ -5851,6 +5851,7 @@ static int hclge_del_fd_entry(struct hnae3_handle *handle,
 	return ret;
 }
 
+/* make sure being called after lock up with fd_rule_lock */
 static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
 				     bool clear_list)
 {
@@ -5863,7 +5864,6 @@ static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
 	if (!hnae3_dev_fd_supported(hdev))
 		return;
 
-	spin_lock_bh(&hdev->fd_rule_lock);
 	for_each_set_bit(location, hdev->fd_bmap,
 			 hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1])
 		hclge_fd_tcam_config(hdev, HCLGE_FD_STAGE_1, true, location,
@@ -5880,8 +5880,6 @@ static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
 		bitmap_zero(hdev->fd_bmap,
 			    hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1]);
 	}
-
-	spin_unlock_bh(&hdev->fd_rule_lock);
 }
 
 static int hclge_restore_fd_entries(struct hnae3_handle *handle)
@@ -6263,7 +6261,7 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 				      u16 flow_id, struct flow_keys *fkeys)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hclge_fd_rule_tuples new_tuples;
+	struct hclge_fd_rule_tuples new_tuples = {};
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_fd_rule *rule;
 	u16 tmp_queue_id;
@@ -6273,19 +6271,17 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 	if (!hnae3_dev_fd_supported(hdev))
 		return -EOPNOTSUPP;
 
-	memset(&new_tuples, 0, sizeof(new_tuples));
-	hclge_fd_get_flow_tuples(fkeys, &new_tuples);
-
-	spin_lock_bh(&hdev->fd_rule_lock);
-
 	/* when there is already fd rule existed add by user,
 	 * arfs should not work
 	 */
+	spin_lock_bh(&hdev->fd_rule_lock);
 	if (hdev->fd_active_type == HCLGE_FD_EP_ACTIVE) {
 		spin_unlock_bh(&hdev->fd_rule_lock);
 		return -EOPNOTSUPP;
 	}
 
+	hclge_fd_get_flow_tuples(fkeys, &new_tuples);
+
 	/* check is there flow director filter existed for this flow,
 	 * if not, create a new filter for it;
 	 * if filter exist with different queue id, modify the filter;
@@ -6368,6 +6364,7 @@ static void hclge_rfs_filter_expire(struct hclge_dev *hdev)
 #endif
 }
 
+/* make sure being called after lock up with fd_rule_lock */
 static void hclge_clear_arfs_rules(struct hnae3_handle *handle)
 {
 #ifdef CONFIG_RFS_ACCEL
@@ -6420,10 +6417,14 @@ static void hclge_enable_fd(struct hnae3_handle *handle, bool enable)
 
 	hdev->fd_en = enable;
 	clear = hdev->fd_active_type == HCLGE_FD_ARFS_ACTIVE;
-	if (!enable)
+
+	if (!enable) {
+		spin_lock_bh(&hdev->fd_rule_lock);
 		hclge_del_all_fd_entries(handle, clear);
-	else
+		spin_unlock_bh(&hdev->fd_rule_lock);
+	} else {
 		hclge_restore_fd_entries(handle);
+	}
 }
 
 static void hclge_cfg_mac_mode(struct hclge_dev *hdev, bool enable)
@@ -6886,8 +6887,9 @@ static void hclge_ae_stop(struct hnae3_handle *handle)
 	int i;
 
 	set_bit(HCLGE_STATE_DOWN, &hdev->state);
-
+	spin_lock_bh(&hdev->fd_rule_lock);
 	hclge_clear_arfs_rules(handle);
+	spin_unlock_bh(&hdev->fd_rule_lock);
 
 	/* If it is not PF reset, the firmware will disable the MAC,
 	 * so it only need to stop phy here.
-- 
2.7.4

