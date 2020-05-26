Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11AD1B6B47
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgDXCY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:24:29 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2885 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726027AbgDXCY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:24:28 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9FB14EB905CBE5D341F9;
        Fri, 24 Apr 2020 10:24:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Fri, 24 Apr 2020 10:24:17 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 6/8] net: hns3: refactor the promisc mode setting
Date:   Fri, 24 Apr 2020 10:23:11 +0800
Message-ID: <1587694993-25183-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
References: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

As the HNS3 driver doesn't update the MAC address directly in
function hns3_set_rx_mode() now, it can't know whether the
MAC table is full from __dev_uc_sync() and __dev_mc_sync(),
so it's senseless to handle the overflow promisc here.

This patch removes the handle of overflow promisc from function
hns3_set_rx_mode(), and updates the promisc mode in the service
task.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  3 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 42 +++-------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 89 ++++++++++++++++++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  4 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 26 +++++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  1 +
 8 files changed, 122 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 5587605..a56f8d6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -270,6 +270,8 @@ struct hnae3_ae_dev {
  *   Set loopback
  * set_promisc_mode
  *   Set promisc mode
+ * request_update_promisc_mode
+ *   request to hclge(vf) to update promisc mode
  * set_mtu()
  *   set mtu
  * get_pauseparam()
@@ -408,6 +410,7 @@ struct hnae3_ae_ops {
 
 	int (*set_promisc_mode)(struct hnae3_handle *handle, bool en_uc_pmc,
 				bool en_mc_pmc);
+	void (*request_update_promisc_mode)(struct hnae3_handle *handle);
 	int (*set_mtu)(struct hnae3_handle *handle, int new_mtu);
 
 	void (*get_pauseparam)(struct hnae3_handle *handle,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 341e8b5..6b9535c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -601,34 +601,25 @@ static void hns3_nic_set_rx_mode(struct net_device *netdev)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	u8 new_flags;
-	int ret;
 
 	new_flags = hns3_get_netdev_flags(netdev);
 
-	ret = __dev_uc_sync(netdev, hns3_nic_uc_sync, hns3_nic_uc_unsync);
-	if (ret) {
-		netdev_err(netdev, "sync uc address fail\n");
-		if (ret == -ENOSPC)
-			new_flags |= HNAE3_OVERFLOW_UPE;
-	}
-
-	if (netdev->flags & IFF_MULTICAST) {
-		ret = __dev_mc_sync(netdev, hns3_nic_mc_sync,
-				    hns3_nic_mc_unsync);
-		if (ret) {
-			netdev_err(netdev, "sync mc address fail\n");
-			if (ret == -ENOSPC)
-				new_flags |= HNAE3_OVERFLOW_MPE;
-		}
-	}
+	__dev_uc_sync(netdev, hns3_nic_uc_sync, hns3_nic_uc_unsync);
+	__dev_mc_sync(netdev, hns3_nic_mc_sync, hns3_nic_mc_unsync);
 
 	/* User mode Promisc mode enable and vlan filtering is disabled to
-	 * let all packets in. MAC-VLAN Table overflow Promisc enabled and
-	 * vlan fitering is enabled
+	 * let all packets in.
 	 */
-	hns3_enable_vlan_filter(netdev, new_flags & HNAE3_VLAN_FLTR);
 	h->netdev_flags = new_flags;
-	hns3_update_promisc_mode(netdev, new_flags);
+	hns3_request_update_promisc_mode(h);
+}
+
+void hns3_request_update_promisc_mode(struct hnae3_handle *handle)
+{
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+
+	if (ops->request_update_promisc_mode)
+		ops->request_update_promisc_mode(handle);
 }
 
 int hns3_update_promisc_mode(struct net_device *netdev, u8 promisc_flags)
@@ -4467,15 +4458,6 @@ static int hns3_reset_notify_init_enet(struct hnae3_handle *handle)
 static int hns3_reset_notify_restore_enet(struct hnae3_handle *handle)
 {
 	struct net_device *netdev = handle->kinfo.netdev;
-	bool vlan_filter_enable;
-	int ret;
-
-	ret = hns3_update_promisc_mode(netdev, handle->netdev_flags);
-	if (ret)
-		return ret;
-
-	vlan_filter_enable = netdev->flags & IFF_PROMISC ? false : true;
-	hns3_enable_vlan_filter(netdev, vlan_filter_enable);
 
 	if (handle->ae_algo->ops->restore_vlan_table)
 		handle->ae_algo->ops->restore_vlan_table(handle);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 4b3f0ab..53bc0ed 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -658,6 +658,7 @@ void hns3_set_vector_coalesce_rl(struct hns3_enet_tqp_vector *tqp_vector,
 
 void hns3_enable_vlan_filter(struct net_device *netdev, bool enable);
 int hns3_update_promisc_mode(struct net_device *netdev, u8 promisc_flags);
+void hns3_request_update_promisc_mode(struct hnae3_handle *handle);
 
 #ifdef CONFIG_HNS3_DCB
 void hns3_dcbnl_setup(struct hnae3_handle *handle);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 6a0734b..4d9c85f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -99,7 +99,7 @@ static int hns3_lp_setup(struct net_device *ndev, enum hnae3_loop loop, bool en)
 		h->ae_algo->ops->set_promisc_mode(h, true, true);
 	} else {
 		/* recover promisc mode before loopback test */
-		hns3_update_promisc_mode(ndev, h->netdev_flags);
+		hns3_request_update_promisc_mode(h);
 		vlan_filter_enable = ndev->flags & IFF_PROMISC ? false : true;
 		hns3_enable_vlan_filter(ndev, vlan_filter_enable);
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c3205ae..71ff0fa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -69,6 +69,7 @@ static enum hnae3_reset_type hclge_get_reset_level(struct hnae3_ae_dev *ae_dev,
 static int hclge_set_default_loopback(struct hclge_dev *hdev);
 
 static void hclge_sync_mac_table(struct hclge_dev *hdev);
+static void hclge_sync_promisc_mode(struct hclge_dev *hdev);
 
 static struct hnae3_ae_algo ae_algo;
 
@@ -3975,6 +3976,7 @@ static void hclge_periodic_service_task(struct hclge_dev *hdev)
 	 */
 	hclge_update_link_status(hdev);
 	hclge_sync_mac_table(hdev);
+	hclge_sync_promisc_mode(hdev);
 
 	if (time_is_after_jiffies(hdev->last_serv_processed + HZ)) {
 		delta = jiffies - hdev->last_serv_processed;
@@ -4724,7 +4726,8 @@ static int hclge_cmd_set_promisc_mode(struct hclge_dev *hdev,
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
 		dev_err(&hdev->pdev->dev,
-			"Set promisc mode fail, status is %d.\n", ret);
+			"failed to set vport %d promisc mode, ret = %d.\n",
+			param->vf_id, ret);
 
 	return ret;
 }
@@ -4774,6 +4777,14 @@ static int hclge_set_promisc_mode(struct hnae3_handle *handle, bool en_uc_pmc,
 					    en_bc_pmc);
 }
 
+static void hclge_request_update_promisc_mode(struct hnae3_handle *handle)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+
+	set_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state);
+}
+
 static int hclge_get_fd_mode(struct hclge_dev *hdev, u8 *fd_mode)
 {
 	struct hclge_get_fd_mode_cmd *req;
@@ -6972,17 +6983,11 @@ static int hclge_get_mac_vlan_cmd_status(struct hclge_vport *vport,
 	}
 
 	if (op == HCLGE_MAC_VLAN_ADD) {
-		if ((!resp_code) || (resp_code == 1)) {
+		if (!resp_code || resp_code == 1)
 			return 0;
-		} else if (resp_code == HCLGE_ADD_UC_OVERFLOW) {
-			dev_err(&hdev->pdev->dev,
-				"add mac addr failed for uc_overflow.\n");
-			return -ENOSPC;
-		} else if (resp_code == HCLGE_ADD_MC_OVERFLOW) {
-			dev_err(&hdev->pdev->dev,
-				"add mac addr failed for mc_overflow.\n");
+		else if (resp_code == HCLGE_ADD_UC_OVERFLOW ||
+			 resp_code == HCLGE_ADD_MC_OVERFLOW)
 			return -ENOSPC;
-		}
 
 		dev_err(&hdev->pdev->dev,
 			"add mac addr failed for undefined, code=%u.\n",
@@ -7448,8 +7453,9 @@ int hclge_add_uc_addr_common(struct hclge_vport *vport,
 			return ret;
 		}
 
-		dev_err(&hdev->pdev->dev, "UC MAC table full(%u)\n",
-			hdev->priv_umv_size);
+		if (!(vport->overflow_promisc_flags & HNAE3_OVERFLOW_UPE))
+			dev_err(&hdev->pdev->dev, "UC MAC table full(%u)\n",
+				hdev->priv_umv_size);
 
 		return -ENOSPC;
 	}
@@ -7543,7 +7549,9 @@ int hclge_add_mc_addr_common(struct hclge_vport *vport,
 		return status;
 	status = hclge_add_mac_vlan_tbl(vport, &req, desc);
 
-	if (status == -ENOSPC)
+	/* if already overflow, not to print each time */
+	if (status == -ENOSPC &&
+	    !(vport->overflow_promisc_flags & HNAE3_OVERFLOW_MPE))
 		dev_err(&hdev->pdev->dev, "mc mac vlan table is full\n");
 
 	return status;
@@ -7638,12 +7646,16 @@ static void hclge_unsync_vport_mac_list(struct hclge_vport *vport,
 	}
 }
 
-static void hclge_sync_from_add_list(struct list_head *add_list,
+static bool hclge_sync_from_add_list(struct list_head *add_list,
 				     struct list_head *mac_list)
 {
 	struct hclge_mac_node *mac_node, *tmp, *new_node;
+	bool all_added = true;
 
 	list_for_each_entry_safe(mac_node, tmp, add_list, node) {
+		if (mac_node->state == HCLGE_MAC_TO_ADD)
+			all_added = false;
+
 		/* if the mac address from tmp_add_list is not in the
 		 * uc/mc_mac_list, it means have received a TO_DEL request
 		 * during the time window of adding the mac address into mac
@@ -7666,6 +7678,8 @@ static void hclge_sync_from_add_list(struct list_head *add_list,
 			kfree(mac_node);
 		}
 	}
+
+	return all_added;
 }
 
 static void hclge_sync_from_del_list(struct list_head *del_list,
@@ -7693,12 +7707,30 @@ static void hclge_sync_from_del_list(struct list_head *del_list,
 	}
 }
 
+static void hclge_update_overflow_flags(struct hclge_vport *vport,
+					enum HCLGE_MAC_ADDR_TYPE mac_type,
+					bool is_all_added)
+{
+	if (mac_type == HCLGE_MAC_ADDR_UC) {
+		if (is_all_added)
+			vport->overflow_promisc_flags &= ~HNAE3_OVERFLOW_UPE;
+		else
+			vport->overflow_promisc_flags |= HNAE3_OVERFLOW_UPE;
+	} else {
+		if (is_all_added)
+			vport->overflow_promisc_flags &= ~HNAE3_OVERFLOW_MPE;
+		else
+			vport->overflow_promisc_flags |= HNAE3_OVERFLOW_MPE;
+	}
+}
+
 static void hclge_sync_vport_mac_table(struct hclge_vport *vport,
 				       enum HCLGE_MAC_ADDR_TYPE mac_type)
 {
 	struct hclge_mac_node *mac_node, *tmp, *new_node;
 	struct list_head tmp_add_list, tmp_del_list;
 	struct list_head *list;
+	bool all_added;
 
 	INIT_LIST_HEAD(&tmp_add_list);
 	INIT_LIST_HEAD(&tmp_del_list);
@@ -7752,9 +7784,11 @@ static void hclge_sync_vport_mac_table(struct hclge_vport *vport,
 	spin_lock_bh(&vport->mac_list_lock);
 
 	hclge_sync_from_del_list(&tmp_del_list, list);
-	hclge_sync_from_add_list(&tmp_add_list, list);
+	all_added = hclge_sync_from_add_list(&tmp_add_list, list);
 
 	spin_unlock_bh(&vport->mac_list_lock);
+
+	hclge_update_overflow_flags(vport, mac_type, all_added);
 }
 
 static bool hclge_need_sync_mac_table(struct hclge_vport *vport)
@@ -11052,6 +11086,30 @@ static int hclge_gro_en(struct hnae3_handle *handle, bool enable)
 	return hclge_config_gro(hdev, enable);
 }
 
+static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
+{
+	struct hclge_vport *vport = &hdev->vport[0];
+	struct hnae3_handle *handle = &vport->nic;
+	u8 tmp_flags = 0;
+	int ret;
+
+	if (vport->last_promisc_flags != vport->overflow_promisc_flags) {
+		set_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state);
+		vport->last_promisc_flags = vport->overflow_promisc_flags;
+	}
+
+	if (test_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state)) {
+		tmp_flags = handle->netdev_flags | vport->last_promisc_flags;
+		ret = hclge_set_promisc_mode(handle, tmp_flags & HNAE3_UPE,
+					     tmp_flags & HNAE3_MPE);
+		if (!ret) {
+			clear_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state);
+			hclge_enable_vlan_filter(handle,
+						 tmp_flags & HNAE3_VLAN_FLTR);
+		}
+	}
+}
+
 static const struct hnae3_ae_ops hclge_ops = {
 	.init_ae_dev = hclge_init_ae_dev,
 	.uninit_ae_dev = hclge_uninit_ae_dev,
@@ -11064,6 +11122,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.get_vector = hclge_get_vector,
 	.put_vector = hclge_put_vector,
 	.set_promisc_mode = hclge_set_promisc_mode,
+	.request_update_promisc_mode = hclge_request_update_promisc_mode,
 	.set_loopback = hclge_set_loopback,
 	.start = hclge_ae_start,
 	.stop = hclge_ae_stop,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 5fcbc3d..85180f4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -217,6 +217,7 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_STATISTICS_UPDATING,
 	HCLGE_STATE_CMD_DISABLE,
 	HCLGE_STATE_LINK_UPDATING,
+	HCLGE_STATE_PROMISC_CHANGED,
 	HCLGE_STATE_RST_FAIL,
 	HCLGE_STATE_MAX
 };
@@ -931,6 +932,9 @@ struct hclge_vport {
 	u32 mps; /* Max packet size */
 	struct hclge_vf_info vf_info;
 
+	u8 overflow_promisc_flags;
+	u8 last_promisc_flags;
+
 	spinlock_t mac_list_lock; /* protect mac address need to add/detele */
 	struct list_head uc_mac_list;   /* Store VF unicast table */
 	struct list_head mc_mac_list;   /* Store VF multicast table */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 05d485a..fea197f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1164,6 +1164,27 @@ static int hclgevf_set_promisc_mode(struct hnae3_handle *handle, bool en_uc_pmc,
 					    en_bc_pmc);
 }
 
+static void hclgevf_request_update_promisc_mode(struct hnae3_handle *handle)
+{
+	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+
+	set_bit(HCLGEVF_STATE_PROMISC_CHANGED, &hdev->state);
+}
+
+static void hclgevf_sync_promisc_mode(struct hclgevf_dev *hdev)
+{
+	struct hnae3_handle *handle = &hdev->nic;
+	bool en_uc_pmc = handle->netdev_flags & HNAE3_UPE;
+	bool en_mc_pmc = handle->netdev_flags & HNAE3_MPE;
+	int ret;
+
+	if (test_bit(HCLGEVF_STATE_PROMISC_CHANGED, &hdev->state)) {
+		ret = hclgevf_set_promisc_mode(handle, en_uc_pmc, en_mc_pmc);
+		if (!ret)
+			clear_bit(HCLGEVF_STATE_PROMISC_CHANGED, &hdev->state);
+	}
+}
+
 static int hclgevf_tqp_enable(struct hclgevf_dev *hdev, unsigned int tqp_id,
 			      int stream_id, bool enable)
 {
@@ -2203,6 +2224,8 @@ static void hclgevf_periodic_service_task(struct hclgevf_dev *hdev)
 
 	hclgevf_sync_mac_table(hdev);
 
+	hclgevf_sync_promisc_mode(hdev);
+
 	hdev->last_serv_processed = jiffies;
 
 out:
@@ -2986,6 +3009,8 @@ static int hclgevf_reset_hdev(struct hclgevf_dev *hdev)
 		return ret;
 	}
 
+	set_bit(HCLGEVF_STATE_PROMISC_CHANGED, &hdev->state);
+
 	dev_info(&hdev->pdev->dev, "Reset done\n");
 
 	return 0;
@@ -3470,6 +3495,7 @@ static const struct hnae3_ae_ops hclgevf_ops = {
 	.set_timer_task = hclgevf_set_timer_task,
 	.get_link_mode = hclgevf_get_link_mode,
 	.set_promisc_mode = hclgevf_set_promisc_mode,
+	.request_update_promisc_mode = hclgevf_request_update_promisc_mode,
 };
 
 static struct hnae3_ae_algo ae_algovf = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 0222d9b..f19583c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -148,6 +148,7 @@ enum hclgevf_states {
 	HCLGEVF_STATE_MBX_HANDLING,
 	HCLGEVF_STATE_CMD_DISABLE,
 	HCLGEVF_STATE_LINK_UPDATING,
+	HCLGEVF_STATE_PROMISC_CHANGED,
 	HCLGEVF_STATE_RST_FAIL,
 };
 
-- 
2.7.4

