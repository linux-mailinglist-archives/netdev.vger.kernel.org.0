Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4EC465FAE
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345879AbhLBIoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 03:44:11 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:28149 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345674AbhLBIoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 03:44:08 -0500
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J4TqY6tkkz1DJqg;
        Thu,  2 Dec 2021 16:38:01 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:44 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:44 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 4/9] net: hns3: split function hclge_get_fd_rule_info()
Date:   Thu, 2 Dec 2021 16:35:58 +0800
Message-ID: <20211202083603.25176-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211202083603.25176-1-huangguangbin2@huawei.com>
References: <20211202083603.25176-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently the function hclge_get_fd_rule_info() is a bit long.
Split it to several small functions, to improve readability.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 52 ++++++++++++-------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fd8988d77d06..b691f306138a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7172,6 +7172,37 @@ static void hclge_fd_get_ext_info(struct ethtool_rx_flow_spec *fs,
 	}
 }
 
+static struct hclge_fd_rule *hclge_get_fd_rule(struct hclge_dev *hdev,
+					       u16 location)
+{
+	struct hclge_fd_rule *rule = NULL;
+	struct hlist_node *node2;
+
+	hlist_for_each_entry_safe(rule, node2, &hdev->fd_rule_list, rule_node) {
+		if (rule->location == location)
+			return rule;
+		else if (rule->location > location)
+			return NULL;
+	}
+
+	return NULL;
+}
+
+static void hclge_fd_get_ring_cookie(struct ethtool_rx_flow_spec *fs,
+				     struct hclge_fd_rule *rule)
+{
+	if (rule->action == HCLGE_FD_ACTION_DROP_PACKET) {
+		fs->ring_cookie = RX_CLS_FLOW_DISC;
+	} else {
+		u64 vf_id;
+
+		fs->ring_cookie = rule->queue_id;
+		vf_id = rule->vf_id;
+		vf_id <<= ETHTOOL_RX_FLOW_SPEC_RING_VF_OFF;
+		fs->ring_cookie |= vf_id;
+	}
+}
+
 static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 				  struct ethtool_rxnfc *cmd)
 {
@@ -7179,7 +7210,6 @@ static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 	struct hclge_fd_rule *rule = NULL;
 	struct hclge_dev *hdev = vport->back;
 	struct ethtool_rx_flow_spec *fs;
-	struct hlist_node *node2;
 
 	if (!hnae3_dev_fd_supported(hdev))
 		return -EOPNOTSUPP;
@@ -7188,14 +7218,9 @@ static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 
 	spin_lock_bh(&hdev->fd_rule_lock);
 
-	hlist_for_each_entry_safe(rule, node2, &hdev->fd_rule_list, rule_node) {
-		if (rule->location >= fs->location)
-			break;
-	}
-
-	if (!rule || fs->location != rule->location) {
+	rule = hclge_get_fd_rule(hdev, fs->location);
+	if (!rule) {
 		spin_unlock_bh(&hdev->fd_rule_lock);
-
 		return -ENOENT;
 	}
 
@@ -7233,16 +7258,7 @@ static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 
 	hclge_fd_get_ext_info(fs, rule);
 
-	if (rule->action == HCLGE_FD_ACTION_DROP_PACKET) {
-		fs->ring_cookie = RX_CLS_FLOW_DISC;
-	} else {
-		u64 vf_id;
-
-		fs->ring_cookie = rule->queue_id;
-		vf_id = rule->vf_id;
-		vf_id <<= ETHTOOL_RX_FLOW_SPEC_RING_VF_OFF;
-		fs->ring_cookie |= vf_id;
-	}
+	hclge_fd_get_ring_cookie(fs, rule);
 
 	spin_unlock_bh(&hdev->fd_rule_lock);
 
-- 
2.33.0

