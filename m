Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DCB32A34B
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378821AbhCBIzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:55:14 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13406 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835935AbhCBG2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 01:28:15 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DqRwL0kBPzjTHs;
        Tue,  2 Mar 2021 14:26:10 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Mar 2021 14:27:23 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC net-next 6/9] net: hns3: refine for hns3_del_all_fd_entries()
Date:   Tue, 2 Mar 2021 14:27:52 +0800
Message-ID: <1614666475-13059-7-git-send-email-tanhuazhong@huawei.com>
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

For only PF driver can configure flow director rule, it's
better to call hclge_del_all_fd_entries() directly in hclge
layer, rather than call hns3_del_all_fd_entries() in hns3
layer. Then we can remove the ae_algo->ops.del_all_fd_entries.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             |  2 --
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c         | 10 ----------
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 10 +++-------
 3 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index e9e60a9..f2eec5c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -608,8 +608,6 @@ struct hnae3_ae_ops {
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
index 8ba07cf..bbeb541 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6271,13 +6271,9 @@ static void hclge_clear_fd_rules_in_list(struct hclge_dev *hdev,
 	}
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
@@ -11334,6 +11330,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_misc_affinity_teardown(hdev);
 	hclge_state_uninit(hdev);
 	hclge_uninit_mac_table(hdev);
+	hclge_del_all_fd_entries(hdev);
 
 	if (mac->phydev)
 		mdiobus_unregister(mac->mdio_bus);
@@ -12157,7 +12154,6 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.get_link_mode = hclge_get_link_mode,
 	.add_fd_entry = hclge_add_fd_entry,
 	.del_fd_entry = hclge_del_fd_entry,
-	.del_all_fd_entries = hclge_del_all_fd_entries,
 	.get_fd_rule_cnt = hclge_get_fd_rule_cnt,
 	.get_fd_rule_info = hclge_get_fd_rule_info,
 	.get_fd_all_rules = hclge_get_all_rules,
-- 
2.7.4

