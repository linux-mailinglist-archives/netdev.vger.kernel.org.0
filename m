Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661593437A4
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 04:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhCVDwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 23:52:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14416 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhCVDvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 23:51:53 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F3gWC4mylzkd6s;
        Mon, 22 Mar 2021 11:50:15 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Mar 2021 11:51:41 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 6/7] net: hns3: refine for hns3_del_all_fd_entries()
Date:   Mon, 22 Mar 2021 11:52:01 +0800
Message-ID: <1616385122-48198-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616385122-48198-1-git-send-email-tanhuazhong@huawei.com>
References: <1616385122-48198-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

For only PF driver can configure flow director rule, it's
better to call hclge_del_all_fd_entries() directly in hclge
layer, rather than call hns3_del_all_fd_entries() in hns3
layer. Then the ae_algo->ops.del_all_fd_entries can be removed.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             |  2 --
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c         | 10 ----------
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 10 +++-------
 3 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 3a6bf1a..01d6bfc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -612,8 +612,6 @@ struct hnae3_ae_ops {
 			    struct ethtool_rxnfc *cmd);
 	int (*del_fd_entry)(struct hnae3_handle *handle,
 			    struct ethtool_rxnfc *cmd);
-	void (*del_all_fd_entries)(struct hnae3_handle *handle,
-				   bool clear_list);
 	int (*get_fd_rule_cnt)(struct hnae3_handle *handle,
 			       struct ethtool_rxnfc *cmd);
 	int (*get_fd_rule_info)(struct hnae3_handle *handle,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index bf4302a..44b775e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4143,14 +4143,6 @@ static void hns3_uninit_phy(struct net_device *netdev)
 		h->ae_algo->ops->mac_disconnect_phy(h);
 }
 
-static void hns3_del_all_fd_rules(struct net_device *netdev, bool clear_list)
-{
-	struct hnae3_handle *h = hns3_get_handle(netdev);
-
-	if (h->ae_algo->ops->del_all_fd_entries)
-		h->ae_algo->ops->del_all_fd_entries(h, clear_list);
-}
-
 static int hns3_client_start(struct hnae3_handle *handle)
 {
 	if (!handle->ae_algo->ops->client_start)
@@ -4337,8 +4329,6 @@ static void hns3_client_uninit(struct hnae3_handle *handle, bool reset)
 
 	hns3_nic_uninit_irq(priv);
 
-	hns3_del_all_fd_rules(netdev, true);
-
 	hns3_clear_all_ring(handle, true);
 
 	hns3_nic_uninit_vector_data(priv);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a41bc12..6a24bda 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6384,13 +6384,9 @@ static void hclge_clear_fd_rules_in_list(struct hclge_dev *hdev,
 	spin_unlock_bh(&hdev->fd_rule_lock);
 }
 
-static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
-				     bool clear_list)
+static void hclge_del_all_fd_entries(struct hclge_dev *hdev)
 {
-	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hclge_dev *hdev = vport->back;
-
-	hclge_clear_fd_rules_in_list(hdev, clear_list);
+	hclge_clear_fd_rules_in_list(hdev, true);
 }
 
 static int hclge_restore_fd_entries(struct hnae3_handle *handle)
@@ -11427,6 +11423,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_misc_affinity_teardown(hdev);
 	hclge_state_uninit(hdev);
 	hclge_uninit_mac_table(hdev);
+	hclge_del_all_fd_entries(hdev);
 
 	if (mac->phydev)
 		mdiobus_unregister(mac->mdio_bus);
@@ -12250,7 +12247,6 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.get_link_mode = hclge_get_link_mode,
 	.add_fd_entry = hclge_add_fd_entry,
 	.del_fd_entry = hclge_del_fd_entry,
-	.del_all_fd_entries = hclge_del_all_fd_entries,
 	.get_fd_rule_cnt = hclge_get_fd_rule_cnt,
 	.get_fd_rule_info = hclge_get_fd_rule_info,
 	.get_fd_all_rules = hclge_get_all_rules,
-- 
2.7.4

