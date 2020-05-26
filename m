Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97061B6B4B
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgDXCYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:24:30 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2882 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbgDXCY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:24:28 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8B6FC649B2A10B4FE3F1;
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
Subject: [PATCH net-next 4/8] net: hns3: refactor the MAC address configure
Date:   Fri, 24 Apr 2020 10:23:09 +0800
Message-ID: <1587694993-25183-5-git-send-email-tanhuazhong@huawei.com>
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

Currently, the HNS3 driver sync and unsync MAC address in function
hns3_set_rx_mode(). For PF, it adds and deletes MAC address directly
in the path of dev_set_rx_mode(). If failed, it won't retry until
next calling of hns3_set_rx_mode(). On the other hand, if request
add and remove a same address many times at a short interval, each
request must be done one by one, can't be merged. For VF, it sends
mailbox messages to PF to request adding or deleting MAC address in
the path of function hns3_set_rx_mode(), no matter the address is
configured success.

This patch refines it by recording the MAC address in function
hns3_set_rx_mode(), and updating MAC address in the service task.
If failed, it will retry by the next calling of periodical service
task. It also uses some state to mark the state of each MAC address
in the MAC list, which can help merge configure request for a same
address. With these changes, when global reset or IMP reset occurs,
we can restore the MAC table with the MAC list.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  79 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 592 +++++++++++++++++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  27 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  42 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 313 ++++++++++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  25 +
 6 files changed, 860 insertions(+), 218 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index ac3a48a..341e8b5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -40,7 +40,6 @@
 	} while (0)
 
 static void hns3_clear_all_ring(struct hnae3_handle *h, bool force);
-static void hns3_remove_hw_addr(struct net_device *netdev);
 
 static const char hns3_driver_name[] = "hns3";
 static const char hns3_driver_string[] =
@@ -548,6 +547,13 @@ static int hns3_nic_uc_unsync(struct net_device *netdev,
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 
+	/* need ignore the request of removing device address, because
+	 * we store the device address and other addresses of uc list
+	 * in the function's mac filter list.
+	 */
+	if (ether_addr_equal(addr, netdev->dev_addr))
+		return 0;
+
 	if (h->ae_algo->ops->rm_uc_addr)
 		return h->ae_algo->ops->rm_uc_addr(h, addr);
 
@@ -3907,9 +3913,11 @@ static int hns3_init_mac_addr(struct net_device *netdev)
 		eth_hw_addr_random(netdev);
 		dev_warn(priv->dev, "using random MAC address %pM\n",
 			 netdev->dev_addr);
-	} else {
+	} else if (!ether_addr_equal(netdev->dev_addr, mac_addr_temp)) {
 		ether_addr_copy(netdev->dev_addr, mac_addr_temp);
 		ether_addr_copy(netdev->perm_addr, mac_addr_temp);
+	} else {
+		return 0;
 	}
 
 	if (h->ae_algo->ops->set_mac_addr)
@@ -4119,8 +4127,6 @@ static void hns3_client_uninit(struct hnae3_handle *handle, bool reset)
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	int ret;
 
-	hns3_remove_hw_addr(netdev);
-
 	if (netdev->reg_state != NETREG_UNINITIALIZED)
 		unregister_netdev(netdev);
 
@@ -4191,56 +4197,6 @@ static int hns3_client_setup_tc(struct hnae3_handle *handle, u8 tc)
 	return hns3_nic_set_real_num_queue(ndev);
 }
 
-static int hns3_recover_hw_addr(struct net_device *ndev)
-{
-	struct netdev_hw_addr_list *list;
-	struct netdev_hw_addr *ha, *tmp;
-	int ret = 0;
-
-	netif_addr_lock_bh(ndev);
-	/* go through and sync uc_addr entries to the device */
-	list = &ndev->uc;
-	list_for_each_entry_safe(ha, tmp, &list->list, list) {
-		ret = hns3_nic_uc_sync(ndev, ha->addr);
-		if (ret)
-			goto out;
-	}
-
-	/* go through and sync mc_addr entries to the device */
-	list = &ndev->mc;
-	list_for_each_entry_safe(ha, tmp, &list->list, list) {
-		ret = hns3_nic_mc_sync(ndev, ha->addr);
-		if (ret)
-			goto out;
-	}
-
-out:
-	netif_addr_unlock_bh(ndev);
-	return ret;
-}
-
-static void hns3_remove_hw_addr(struct net_device *netdev)
-{
-	struct netdev_hw_addr_list *list;
-	struct netdev_hw_addr *ha, *tmp;
-
-	hns3_nic_uc_unsync(netdev, netdev->dev_addr);
-
-	netif_addr_lock_bh(netdev);
-	/* go through and unsync uc_addr entries to the device */
-	list = &netdev->uc;
-	list_for_each_entry_safe(ha, tmp, &list->list, list)
-		hns3_nic_uc_unsync(netdev, ha->addr);
-
-	/* go through and unsync mc_addr entries to the device */
-	list = &netdev->mc;
-	list_for_each_entry_safe(ha, tmp, &list->list, list)
-		if (ha->refcount > 1)
-			hns3_nic_mc_unsync(netdev, ha->addr);
-
-	netif_addr_unlock_bh(netdev);
-}
-
 static void hns3_clear_tx_ring(struct hns3_enet_ring *ring)
 {
 	while (ring->next_to_clean != ring->next_to_use) {
@@ -4411,10 +4367,8 @@ static int hns3_reset_notify_down_enet(struct hnae3_handle *handle)
 	 * from table space. Hence, for function reset software intervention is
 	 * required to delete the entries
 	 */
-	if (hns3_dev_ongoing_func_reset(ae_dev)) {
-		hns3_remove_hw_addr(ndev);
+	if (hns3_dev_ongoing_func_reset(ae_dev))
 		hns3_del_all_fd_rules(ndev, false);
-	}
 
 	if (!netif_running(ndev))
 		return 0;
@@ -4482,6 +4436,9 @@ static int hns3_reset_notify_init_enet(struct hnae3_handle *handle)
 		goto err_init_irq_fail;
 	}
 
+	if (!hns3_is_phys_func(handle->pdev))
+		hns3_init_mac_addr(netdev);
+
 	ret = hns3_client_start(handle);
 	if (ret) {
 		dev_err(priv->dev, "hns3_client_start fail! ret=%d\n", ret);
@@ -4513,14 +4470,6 @@ static int hns3_reset_notify_restore_enet(struct hnae3_handle *handle)
 	bool vlan_filter_enable;
 	int ret;
 
-	ret = hns3_init_mac_addr(netdev);
-	if (ret)
-		return ret;
-
-	ret = hns3_recover_hw_addr(netdev);
-	if (ret)
-		return ret;
-
 	ret = hns3_update_promisc_mode(netdev, handle->netdev_flags);
 	if (ret)
 		return ret;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a268004..c3205ae 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -68,6 +68,8 @@ static enum hnae3_reset_type hclge_get_reset_level(struct hnae3_ae_dev *ae_dev,
 						   unsigned long *addr);
 static int hclge_set_default_loopback(struct hclge_dev *hdev);
 
+static void hclge_sync_mac_table(struct hclge_dev *hdev);
+
 static struct hnae3_ae_algo ae_algo;
 
 static struct workqueue_struct *hclge_wq;
@@ -1685,6 +1687,7 @@ static int hclge_alloc_vport(struct hclge_dev *hdev)
 		INIT_LIST_HEAD(&vport->vlan_list);
 		INIT_LIST_HEAD(&vport->uc_mac_list);
 		INIT_LIST_HEAD(&vport->mc_mac_list);
+		spin_lock_init(&vport->mac_list_lock);
 
 		if (i == 0)
 			ret = hclge_vport_setup(vport, tqp_main_vport);
@@ -3971,6 +3974,7 @@ static void hclge_periodic_service_task(struct hclge_dev *hdev)
 	 * updated when it is triggered by mbx.
 	 */
 	hclge_update_link_status(hdev);
+	hclge_sync_mac_table(hdev);
 
 	if (time_is_after_jiffies(hdev->last_serv_processed + HZ)) {
 		delta = jiffies - hdev->last_serv_processed;
@@ -6922,8 +6926,16 @@ static void hclge_ae_stop(struct hnae3_handle *handle)
 
 int hclge_vport_start(struct hclge_vport *vport)
 {
+	struct hclge_dev *hdev = vport->back;
+
 	set_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
 	vport->last_active_jiffies = jiffies;
+
+	if (test_bit(vport->vport_id, hdev->vport_config_block))
+		hclge_restore_mac_table_common(vport);
+
+	clear_bit(vport->vport_id, hdev->vport_config_block);
+
 	return 0;
 }
 
@@ -7291,12 +7303,106 @@ static void hclge_update_umv_space(struct hclge_vport *vport, bool is_free)
 	mutex_unlock(&hdev->umv_mutex);
 }
 
+static struct hclge_mac_node *hclge_find_mac_node(struct list_head *list,
+						  const u8 *mac_addr)
+{
+	struct hclge_mac_node *mac_node, *tmp;
+
+	list_for_each_entry_safe(mac_node, tmp, list, node)
+		if (ether_addr_equal(mac_addr, mac_node->mac_addr))
+			return mac_node;
+
+	return NULL;
+}
+
+static void hclge_update_mac_node(struct hclge_mac_node *mac_node,
+				  enum HCLGE_MAC_NODE_STATE state)
+{
+	switch (state) {
+	/* from set_rx_mode or tmp_add_list */
+	case HCLGE_MAC_TO_ADD:
+		if (mac_node->state == HCLGE_MAC_TO_DEL)
+			mac_node->state = HCLGE_MAC_ACTIVE;
+		break;
+	/* only from set_rx_mode */
+	case HCLGE_MAC_TO_DEL:
+		if (mac_node->state == HCLGE_MAC_TO_ADD) {
+			list_del(&mac_node->node);
+			kfree(mac_node);
+		} else {
+			mac_node->state = HCLGE_MAC_TO_DEL;
+		}
+		break;
+	/* only from tmp_add_list, the mac_node->state won't be
+	 * ACTIVE.
+	 */
+	case HCLGE_MAC_ACTIVE:
+		if (mac_node->state == HCLGE_MAC_TO_ADD)
+			mac_node->state = HCLGE_MAC_ACTIVE;
+
+		break;
+	}
+}
+
+int hclge_update_mac_list(struct hclge_vport *vport,
+			  enum HCLGE_MAC_NODE_STATE state,
+			  enum HCLGE_MAC_ADDR_TYPE mac_type,
+			  const unsigned char *addr)
+{
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_mac_node *mac_node;
+	struct list_head *list;
+
+	list = (mac_type == HCLGE_MAC_ADDR_UC) ?
+		&vport->uc_mac_list : &vport->mc_mac_list;
+
+	spin_lock_bh(&vport->mac_list_lock);
+
+	/* if the mac addr is already in the mac list, no need to add a new
+	 * one into it, just check the mac addr state, convert it to a new
+	 * new state, or just remove it, or do nothing.
+	 */
+	mac_node = hclge_find_mac_node(list, addr);
+	if (mac_node) {
+		hclge_update_mac_node(mac_node, state);
+		spin_unlock_bh(&vport->mac_list_lock);
+		set_bit(HCLGE_VPORT_STATE_MAC_TBL_CHANGE, &vport->state);
+		return 0;
+	}
+
+	/* if this address is never added, unnecessary to delete */
+	if (state == HCLGE_MAC_TO_DEL) {
+		spin_unlock_bh(&vport->mac_list_lock);
+		dev_err(&hdev->pdev->dev,
+			"failed to delete address %pM from mac list\n",
+			addr);
+		return -ENOENT;
+	}
+
+	mac_node = kzalloc(sizeof(*mac_node), GFP_ATOMIC);
+	if (!mac_node) {
+		spin_unlock_bh(&vport->mac_list_lock);
+		return -ENOMEM;
+	}
+
+	set_bit(HCLGE_VPORT_STATE_MAC_TBL_CHANGE, &vport->state);
+
+	mac_node->state = state;
+	ether_addr_copy(mac_node->mac_addr, addr);
+	list_add_tail(&mac_node->node, list);
+
+	spin_unlock_bh(&vport->mac_list_lock);
+
+	return 0;
+}
+
 static int hclge_add_uc_addr(struct hnae3_handle *handle,
 			     const unsigned char *addr)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 
-	return hclge_add_uc_addr_common(vport, addr);
+	return hclge_update_mac_list(vport, HCLGE_MAC_TO_ADD, HCLGE_MAC_ADDR_UC,
+				     addr);
 }
 
 int hclge_add_uc_addr_common(struct hclge_vport *vport,
@@ -7367,7 +7473,8 @@ static int hclge_rm_uc_addr(struct hnae3_handle *handle,
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 
-	return hclge_rm_uc_addr_common(vport, addr);
+	return hclge_update_mac_list(vport, HCLGE_MAC_TO_DEL, HCLGE_MAC_ADDR_UC,
+				     addr);
 }
 
 int hclge_rm_uc_addr_common(struct hclge_vport *vport,
@@ -7392,6 +7499,8 @@ int hclge_rm_uc_addr_common(struct hclge_vport *vport,
 	ret = hclge_remove_mac_vlan_tbl(vport, &req);
 	if (!ret)
 		hclge_update_umv_space(vport, true);
+	else if (ret == -ENOENT)
+		ret = 0;
 
 	return ret;
 }
@@ -7401,7 +7510,8 @@ static int hclge_add_mc_addr(struct hnae3_handle *handle,
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 
-	return hclge_add_mc_addr_common(vport, addr);
+	return hclge_update_mac_list(vport, HCLGE_MAC_TO_ADD, HCLGE_MAC_ADDR_MC,
+				     addr);
 }
 
 int hclge_add_mc_addr_common(struct hclge_vport *vport,
@@ -7444,7 +7554,8 @@ static int hclge_rm_mc_addr(struct hnae3_handle *handle,
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 
-	return hclge_rm_mc_addr_common(vport, addr);
+	return hclge_update_mac_list(vport, HCLGE_MAC_TO_DEL, HCLGE_MAC_ADDR_MC,
+				     addr);
 }
 
 int hclge_rm_mc_addr_common(struct hclge_vport *vport,
@@ -7479,111 +7590,328 @@ int hclge_rm_mc_addr_common(struct hclge_vport *vport,
 			/* Not all the vfid is zero, update the vfid */
 			status = hclge_add_mac_vlan_tbl(vport, &req, desc);
 
-	} else {
-		/* Maybe this mac address is in mta table, but it cannot be
-		 * deleted here because an entry of mta represents an address
-		 * range rather than a specific address. the delete action to
-		 * all entries will take effect in update_mta_status called by
-		 * hns3_nic_set_rx_mode.
-		 */
+	} else if (status == -ENOENT) {
 		status = 0;
 	}
 
 	return status;
 }
 
-void hclge_add_vport_mac_table(struct hclge_vport *vport, const u8 *mac_addr,
-			       enum HCLGE_MAC_ADDR_TYPE mac_type)
+static void hclge_sync_vport_mac_list(struct hclge_vport *vport,
+				      struct list_head *list,
+				      int (*sync)(struct hclge_vport *,
+						  const unsigned char *))
 {
-	struct hclge_vport_mac_addr_cfg *mac_cfg;
-	struct list_head *list;
+	struct hclge_mac_node *mac_node, *tmp;
+	int ret;
 
-	if (!vport->vport_id)
-		return;
+	list_for_each_entry_safe(mac_node, tmp, list, node) {
+		ret = sync(vport, mac_node->mac_addr);
+		if (!ret) {
+			mac_node->state = HCLGE_MAC_ACTIVE;
+		} else {
+			set_bit(HCLGE_VPORT_STATE_MAC_TBL_CHANGE,
+				&vport->state);
+			break;
+		}
+	}
+}
 
-	mac_cfg = kzalloc(sizeof(*mac_cfg), GFP_KERNEL);
-	if (!mac_cfg)
-		return;
+static void hclge_unsync_vport_mac_list(struct hclge_vport *vport,
+					struct list_head *list,
+					int (*unsync)(struct hclge_vport *,
+						      const unsigned char *))
+{
+	struct hclge_mac_node *mac_node, *tmp;
+	int ret;
 
-	mac_cfg->hd_tbl_status = true;
-	memcpy(mac_cfg->mac_addr, mac_addr, ETH_ALEN);
+	list_for_each_entry_safe(mac_node, tmp, list, node) {
+		ret = unsync(vport, mac_node->mac_addr);
+		if (!ret || ret == -ENOENT) {
+			list_del(&mac_node->node);
+			kfree(mac_node);
+		} else {
+			set_bit(HCLGE_VPORT_STATE_MAC_TBL_CHANGE,
+				&vport->state);
+			break;
+		}
+	}
+}
 
-	list = (mac_type == HCLGE_MAC_ADDR_UC) ?
-	       &vport->uc_mac_list : &vport->mc_mac_list;
+static void hclge_sync_from_add_list(struct list_head *add_list,
+				     struct list_head *mac_list)
+{
+	struct hclge_mac_node *mac_node, *tmp, *new_node;
 
-	list_add_tail(&mac_cfg->node, list);
+	list_for_each_entry_safe(mac_node, tmp, add_list, node) {
+		/* if the mac address from tmp_add_list is not in the
+		 * uc/mc_mac_list, it means have received a TO_DEL request
+		 * during the time window of adding the mac address into mac
+		 * table. if mac_node state is ACTIVE, then change it to TO_DEL,
+		 * then it will be removed at next time. else it must be TO_ADD,
+		 * this address hasn't been added into mac table,
+		 * so just remove the mac node.
+		 */
+		new_node = hclge_find_mac_node(mac_list, mac_node->mac_addr);
+		if (new_node) {
+			hclge_update_mac_node(new_node, mac_node->state);
+			list_del(&mac_node->node);
+			kfree(mac_node);
+		} else if (mac_node->state == HCLGE_MAC_ACTIVE) {
+			mac_node->state = HCLGE_MAC_TO_DEL;
+			list_del(&mac_node->node);
+			list_add_tail(&mac_node->node, mac_list);
+		} else {
+			list_del(&mac_node->node);
+			kfree(mac_node);
+		}
+	}
 }
 
-void hclge_rm_vport_mac_table(struct hclge_vport *vport, const u8 *mac_addr,
-			      bool is_write_tbl,
-			      enum HCLGE_MAC_ADDR_TYPE mac_type)
+static void hclge_sync_from_del_list(struct list_head *del_list,
+				     struct list_head *mac_list)
 {
-	struct hclge_vport_mac_addr_cfg *mac_cfg, *tmp;
-	struct list_head *list;
-	bool uc_flag, mc_flag;
+	struct hclge_mac_node *mac_node, *tmp, *new_node;
 
-	list = (mac_type == HCLGE_MAC_ADDR_UC) ?
-	       &vport->uc_mac_list : &vport->mc_mac_list;
+	list_for_each_entry_safe(mac_node, tmp, del_list, node) {
+		new_node = hclge_find_mac_node(mac_list, mac_node->mac_addr);
+		if (new_node) {
+			/* If the mac addr exists in the mac list, it means
+			 * received a new TO_ADD request during the time window
+			 * of configuring the mac address. For the mac node
+			 * state is TO_ADD, and the address is already in the
+			 * in the hardware(due to delete fail), so we just need
+			 * to change the mac node state to ACTIVE.
+			 */
+			new_node->state = HCLGE_MAC_ACTIVE;
+			list_del(&mac_node->node);
+			kfree(mac_node);
+		} else {
+			list_del(&mac_node->node);
+			list_add_tail(&mac_node->node, mac_list);
+		}
+	}
+}
 
-	uc_flag = is_write_tbl && mac_type == HCLGE_MAC_ADDR_UC;
-	mc_flag = is_write_tbl && mac_type == HCLGE_MAC_ADDR_MC;
+static void hclge_sync_vport_mac_table(struct hclge_vport *vport,
+				       enum HCLGE_MAC_ADDR_TYPE mac_type)
+{
+	struct hclge_mac_node *mac_node, *tmp, *new_node;
+	struct list_head tmp_add_list, tmp_del_list;
+	struct list_head *list;
 
-	list_for_each_entry_safe(mac_cfg, tmp, list, node) {
-		if (ether_addr_equal(mac_cfg->mac_addr, mac_addr)) {
-			if (uc_flag && mac_cfg->hd_tbl_status)
-				hclge_rm_uc_addr_common(vport, mac_addr);
+	INIT_LIST_HEAD(&tmp_add_list);
+	INIT_LIST_HEAD(&tmp_del_list);
 
-			if (mc_flag && mac_cfg->hd_tbl_status)
-				hclge_rm_mc_addr_common(vport, mac_addr);
+	/* move the mac addr to the tmp_add_list and tmp_del_list, then
+	 * we can add/delete these mac addr outside the spin lock
+	 */
+	list = (mac_type == HCLGE_MAC_ADDR_UC) ?
+		&vport->uc_mac_list : &vport->mc_mac_list;
 
-			list_del(&mac_cfg->node);
-			kfree(mac_cfg);
+	spin_lock_bh(&vport->mac_list_lock);
+
+	list_for_each_entry_safe(mac_node, tmp, list, node) {
+		switch (mac_node->state) {
+		case HCLGE_MAC_TO_DEL:
+			list_del(&mac_node->node);
+			list_add_tail(&mac_node->node, &tmp_del_list);
+			break;
+		case HCLGE_MAC_TO_ADD:
+			new_node = kzalloc(sizeof(*new_node), GFP_ATOMIC);
+			if (!new_node)
+				goto stop_traverse;
+			ether_addr_copy(new_node->mac_addr, mac_node->mac_addr);
+			new_node->state = mac_node->state;
+			list_add_tail(&new_node->node, &tmp_add_list);
+			break;
+		default:
 			break;
 		}
 	}
+
+stop_traverse:
+	spin_unlock_bh(&vport->mac_list_lock);
+
+	/* delete first, in order to get max mac table space for adding */
+	if (mac_type == HCLGE_MAC_ADDR_UC) {
+		hclge_unsync_vport_mac_list(vport, &tmp_del_list,
+					    hclge_rm_uc_addr_common);
+		hclge_sync_vport_mac_list(vport, &tmp_add_list,
+					  hclge_add_uc_addr_common);
+	} else {
+		hclge_unsync_vport_mac_list(vport, &tmp_del_list,
+					    hclge_rm_mc_addr_common);
+		hclge_sync_vport_mac_list(vport, &tmp_add_list,
+					  hclge_add_mc_addr_common);
+	}
+
+	/* if some mac addresses were added/deleted fail, move back to the
+	 * mac_list, and retry at next time.
+	 */
+	spin_lock_bh(&vport->mac_list_lock);
+
+	hclge_sync_from_del_list(&tmp_del_list, list);
+	hclge_sync_from_add_list(&tmp_add_list, list);
+
+	spin_unlock_bh(&vport->mac_list_lock);
+}
+
+static bool hclge_need_sync_mac_table(struct hclge_vport *vport)
+{
+	struct hclge_dev *hdev = vport->back;
+
+	if (test_bit(vport->vport_id, hdev->vport_config_block))
+		return false;
+
+	if (test_and_clear_bit(HCLGE_VPORT_STATE_MAC_TBL_CHANGE, &vport->state))
+		return true;
+
+	return false;
+}
+
+static void hclge_sync_mac_table(struct hclge_dev *hdev)
+{
+	int i;
+
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		struct hclge_vport *vport = &hdev->vport[i];
+
+		if (!hclge_need_sync_mac_table(vport))
+			continue;
+
+		hclge_sync_vport_mac_table(vport, HCLGE_MAC_ADDR_UC);
+		hclge_sync_vport_mac_table(vport, HCLGE_MAC_ADDR_MC);
+	}
 }
 
 void hclge_rm_vport_all_mac_table(struct hclge_vport *vport, bool is_del_list,
 				  enum HCLGE_MAC_ADDR_TYPE mac_type)
 {
-	struct hclge_vport_mac_addr_cfg *mac_cfg, *tmp;
-	struct list_head *list;
+	int (*unsync)(struct hclge_vport *vport, const unsigned char *addr);
+	struct hclge_mac_node *mac_cfg, *tmp;
+	struct hclge_dev *hdev = vport->back;
+	struct list_head tmp_del_list, *list;
+	int ret;
 
-	list = (mac_type == HCLGE_MAC_ADDR_UC) ?
-	       &vport->uc_mac_list : &vport->mc_mac_list;
+	if (mac_type == HCLGE_MAC_ADDR_UC) {
+		list = &vport->uc_mac_list;
+		unsync = hclge_rm_uc_addr_common;
+	} else {
+		list = &vport->mc_mac_list;
+		unsync = hclge_rm_mc_addr_common;
+	}
 
-	list_for_each_entry_safe(mac_cfg, tmp, list, node) {
-		if (mac_type == HCLGE_MAC_ADDR_UC && mac_cfg->hd_tbl_status)
-			hclge_rm_uc_addr_common(vport, mac_cfg->mac_addr);
+	INIT_LIST_HEAD(&tmp_del_list);
 
-		if (mac_type == HCLGE_MAC_ADDR_MC && mac_cfg->hd_tbl_status)
-			hclge_rm_mc_addr_common(vport, mac_cfg->mac_addr);
+	if (!is_del_list)
+		set_bit(vport->vport_id, hdev->vport_config_block);
 
-		mac_cfg->hd_tbl_status = false;
-		if (is_del_list) {
+	spin_lock_bh(&vport->mac_list_lock);
+
+	list_for_each_entry_safe(mac_cfg, tmp, list, node) {
+		switch (mac_cfg->state) {
+		case HCLGE_MAC_TO_DEL:
+		case HCLGE_MAC_ACTIVE:
 			list_del(&mac_cfg->node);
-			kfree(mac_cfg);
+			list_add_tail(&mac_cfg->node, &tmp_del_list);
+			break;
+		case HCLGE_MAC_TO_ADD:
+			if (is_del_list) {
+				list_del(&mac_cfg->node);
+				kfree(mac_cfg);
+			}
+			break;
 		}
 	}
+
+	spin_unlock_bh(&vport->mac_list_lock);
+
+	list_for_each_entry_safe(mac_cfg, tmp, &tmp_del_list, node) {
+		ret = unsync(vport, mac_cfg->mac_addr);
+		if (!ret || ret == -ENOENT) {
+			/* clear all mac addr from hardware, but remain these
+			 * mac addr in the mac list, and restore them after
+			 * vf reset finished.
+			 */
+			if (!is_del_list &&
+			    mac_cfg->state == HCLGE_MAC_ACTIVE) {
+				mac_cfg->state = HCLGE_MAC_TO_ADD;
+			} else {
+				list_del(&mac_cfg->node);
+				kfree(mac_cfg);
+			}
+		} else if (is_del_list) {
+			mac_cfg->state = HCLGE_MAC_TO_DEL;
+		}
+	}
+
+	spin_lock_bh(&vport->mac_list_lock);
+
+	hclge_sync_from_del_list(&tmp_del_list, list);
+
+	spin_unlock_bh(&vport->mac_list_lock);
+}
+
+/* remove all mac address when uninitailize */
+static void hclge_uninit_vport_mac_list(struct hclge_vport *vport,
+					enum HCLGE_MAC_ADDR_TYPE mac_type)
+{
+	struct hclge_mac_node *mac_node, *tmp;
+	struct hclge_dev *hdev = vport->back;
+	struct list_head tmp_del_list, *list;
+
+	INIT_LIST_HEAD(&tmp_del_list);
+
+	list = (mac_type == HCLGE_MAC_ADDR_UC) ?
+		&vport->uc_mac_list : &vport->mc_mac_list;
+
+	spin_lock_bh(&vport->mac_list_lock);
+
+	list_for_each_entry_safe(mac_node, tmp, list, node) {
+		switch (mac_node->state) {
+		case HCLGE_MAC_TO_DEL:
+		case HCLGE_MAC_ACTIVE:
+			list_del(&mac_node->node);
+			list_add_tail(&mac_node->node, &tmp_del_list);
+			break;
+		case HCLGE_MAC_TO_ADD:
+			list_del(&mac_node->node);
+			kfree(mac_node);
+			break;
+		}
+	}
+
+	spin_unlock_bh(&vport->mac_list_lock);
+
+	if (mac_type == HCLGE_MAC_ADDR_UC)
+		hclge_unsync_vport_mac_list(vport, &tmp_del_list,
+					    hclge_rm_uc_addr_common);
+	else
+		hclge_unsync_vport_mac_list(vport, &tmp_del_list,
+					    hclge_rm_mc_addr_common);
+
+	if (!list_empty(&tmp_del_list))
+		dev_warn(&hdev->pdev->dev,
+			 "uninit %s mac list for vport %u not completely.\n",
+			 mac_type == HCLGE_MAC_ADDR_UC ? "uc" : "mc",
+			 vport->vport_id);
+
+	list_for_each_entry_safe(mac_node, tmp, &tmp_del_list, node) {
+		list_del(&mac_node->node);
+		kfree(mac_node);
+	}
 }
 
-void hclge_uninit_vport_mac_table(struct hclge_dev *hdev)
+static void hclge_uninit_mac_table(struct hclge_dev *hdev)
 {
-	struct hclge_vport_mac_addr_cfg *mac, *tmp;
 	struct hclge_vport *vport;
 	int i;
 
 	for (i = 0; i < hdev->num_alloc_vport; i++) {
 		vport = &hdev->vport[i];
-		list_for_each_entry_safe(mac, tmp, &vport->uc_mac_list, node) {
-			list_del(&mac->node);
-			kfree(mac);
-		}
-
-		list_for_each_entry_safe(mac, tmp, &vport->mc_mac_list, node) {
-			list_del(&mac->node);
-			kfree(mac);
-		}
+		hclge_uninit_vport_mac_list(vport, HCLGE_MAC_ADDR_UC);
+		hclge_uninit_vport_mac_list(vport, HCLGE_MAC_ADDR_MC);
 	}
 }
 
@@ -7747,12 +8075,57 @@ static void hclge_get_mac_addr(struct hnae3_handle *handle, u8 *p)
 	ether_addr_copy(p, hdev->hw.mac.mac_addr);
 }
 
+int hclge_update_mac_node_for_dev_addr(struct hclge_vport *vport,
+				       const u8 *old_addr, const u8 *new_addr)
+{
+	struct list_head *list = &vport->uc_mac_list;
+	struct hclge_mac_node *old_node, *new_node;
+
+	new_node = hclge_find_mac_node(list, new_addr);
+	if (!new_node) {
+		new_node = kzalloc(sizeof(*new_node), GFP_ATOMIC);
+		if (!new_node)
+			return -ENOMEM;
+
+		new_node->state = HCLGE_MAC_TO_ADD;
+		ether_addr_copy(new_node->mac_addr, new_addr);
+		list_add(&new_node->node, list);
+	} else {
+		if (new_node->state == HCLGE_MAC_TO_DEL)
+			new_node->state = HCLGE_MAC_ACTIVE;
+
+		/* make sure the new addr is in the list head, avoid dev
+		 * addr may be not re-added into mac table for the umv space
+		 * limitation after global/imp reset which will clear mac
+		 * table by hardware.
+		 */
+		list_move(&new_node->node, list);
+	}
+
+	if (old_addr && !ether_addr_equal(old_addr, new_addr)) {
+		old_node = hclge_find_mac_node(list, old_addr);
+		if (old_node) {
+			if (old_node->state == HCLGE_MAC_TO_ADD) {
+				list_del(&old_node->node);
+				kfree(old_node);
+			} else {
+				old_node->state = HCLGE_MAC_TO_DEL;
+			}
+		}
+	}
+
+	set_bit(HCLGE_VPORT_STATE_MAC_TBL_CHANGE, &vport->state);
+
+	return 0;
+}
+
 static int hclge_set_mac_addr(struct hnae3_handle *handle, void *p,
 			      bool is_first)
 {
 	const unsigned char *new_addr = (const unsigned char *)p;
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
+	unsigned char *old_addr = NULL;
 	int ret;
 
 	/* mac addr check */
@@ -7760,39 +8133,42 @@ static int hclge_set_mac_addr(struct hnae3_handle *handle, void *p,
 	    is_broadcast_ether_addr(new_addr) ||
 	    is_multicast_ether_addr(new_addr)) {
 		dev_err(&hdev->pdev->dev,
-			"Change uc mac err! invalid mac:%pM.\n",
+			"change uc mac err! invalid mac: %pM.\n",
 			 new_addr);
 		return -EINVAL;
 	}
 
-	if ((!is_first || is_kdump_kernel()) &&
-	    hclge_rm_uc_addr(handle, hdev->hw.mac.mac_addr))
-		dev_warn(&hdev->pdev->dev,
-			 "remove old uc mac address fail.\n");
-
-	ret = hclge_add_uc_addr(handle, new_addr);
+	ret = hclge_pause_addr_cfg(hdev, new_addr);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"add uc mac address fail, ret =%d.\n",
+			"failed to configure mac pause address, ret = %d\n",
 			ret);
-
-		if (!is_first &&
-		    hclge_add_uc_addr(handle, hdev->hw.mac.mac_addr))
-			dev_err(&hdev->pdev->dev,
-				"restore uc mac address fail.\n");
-
-		return -EIO;
+		return ret;
 	}
 
-	ret = hclge_pause_addr_cfg(hdev, new_addr);
+	if (!is_first)
+		old_addr = hdev->hw.mac.mac_addr;
+
+	spin_lock_bh(&vport->mac_list_lock);
+	ret = hclge_update_mac_node_for_dev_addr(vport, old_addr, new_addr);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"configure mac pause address fail, ret =%d.\n",
-			ret);
-		return -EIO;
-	}
+			"failed to change the mac addr:%pM, ret = %d\n",
+			new_addr, ret);
+		spin_unlock_bh(&vport->mac_list_lock);
+
+		if (!is_first)
+			hclge_pause_addr_cfg(hdev, old_addr);
 
+		return ret;
+	}
+	/* we must update dev addr with spin lock protect, preventing dev addr
+	 * being removed by set_rx_mode path.
+	 */
 	ether_addr_copy(hdev->hw.mac.mac_addr, new_addr);
+	spin_unlock_bh(&vport->mac_list_lock);
+
+	hclge_task_schedule(hdev, 0);
 
 	return 0;
 }
@@ -8408,6 +8784,37 @@ static void hclge_restore_vlan_table(struct hnae3_handle *handle)
 	}
 }
 
+/* For global reset and imp reset, hardware will clear the mac table,
+ * so we change the mac address state from ACTIVE to TO_ADD, then they
+ * can be restored in the service task after reset complete. Furtherly,
+ * the mac addresses with state TO_DEL or DEL_FAIL are unnecessary to
+ * be restored after reset, so just remove these mac nodes from mac_list.
+ */
+static void hclge_mac_node_convert_for_reset(struct list_head *list)
+{
+	struct hclge_mac_node *mac_node, *tmp;
+
+	list_for_each_entry_safe(mac_node, tmp, list, node) {
+		if (mac_node->state == HCLGE_MAC_ACTIVE) {
+			mac_node->state = HCLGE_MAC_TO_ADD;
+		} else if (mac_node->state == HCLGE_MAC_TO_DEL) {
+			list_del(&mac_node->node);
+			kfree(mac_node);
+		}
+	}
+}
+
+void hclge_restore_mac_table_common(struct hclge_vport *vport)
+{
+	spin_lock_bh(&vport->mac_list_lock);
+
+	hclge_mac_node_convert_for_reset(&vport->uc_mac_list);
+	hclge_mac_node_convert_for_reset(&vport->mc_mac_list);
+	set_bit(HCLGE_VPORT_STATE_MAC_TBL_CHANGE, &vport->state);
+
+	spin_unlock_bh(&vport->mac_list_lock);
+}
+
 int hclge_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
@@ -9899,6 +10306,15 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 	set_bit(HCLGE_STATE_DOWN, &hdev->state);
 
 	hclge_stats_clear(hdev);
+	/* NOTE: pf reset needn't to clear or restore pf and vf table entry.
+	 * so here should not clean table in memory.
+	 */
+	if (hdev->reset_type == HNAE3_IMP_RESET ||
+	    hdev->reset_type == HNAE3_GLOBAL_RESET) {
+		bitmap_set(hdev->vport_config_block, 0, hdev->num_alloc_vport);
+		hclge_reset_umv_space(hdev);
+	}
+
 	memset(hdev->vlan_table, 0, sizeof(hdev->vlan_table));
 	memset(hdev->vf_vlan_full, 0, sizeof(hdev->vf_vlan_full));
 
@@ -9914,8 +10330,6 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 		return ret;
 	}
 
-	hclge_reset_umv_space(hdev);
-
 	ret = hclge_mac_init(hdev);
 	if (ret) {
 		dev_err(&pdev->dev, "Mac init error, ret = %d\n", ret);
@@ -10011,6 +10425,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_clear_vf_vlan(hdev);
 	hclge_misc_affinity_teardown(hdev);
 	hclge_state_uninit(hdev);
+	hclge_uninit_mac_table(hdev);
 
 	if (mac->phydev)
 		mdiobus_unregister(mac->mdio_bus);
@@ -10028,7 +10443,6 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_misc_irq_uninit(hdev);
 	hclge_pci_uninit(hdev);
 	mutex_destroy(&hdev->vport_lock);
-	hclge_uninit_vport_mac_table(hdev);
 	hclge_uninit_vport_vlan_table(hdev);
 	ae_dev->priv = NULL;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index a58c262..5fcbc3d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -630,9 +630,15 @@ struct hclge_fd_ad_data {
 	u16 rule_id;
 };
 
-struct hclge_vport_mac_addr_cfg {
+enum HCLGE_MAC_NODE_STATE {
+	HCLGE_MAC_TO_ADD,
+	HCLGE_MAC_TO_DEL,
+	HCLGE_MAC_ACTIVE
+};
+
+struct hclge_mac_node {
 	struct list_head node;
-	int hd_tbl_status;
+	enum HCLGE_MAC_NODE_STATE state;
 	u8 mac_addr[ETH_ALEN];
 };
 
@@ -805,6 +811,8 @@ struct hclge_dev {
 	unsigned long vlan_table[VLAN_N_VID][BITS_TO_LONGS(HCLGE_VPORT_NUM)];
 	unsigned long vf_vlan_full[BITS_TO_LONGS(HCLGE_VPORT_NUM)];
 
+	unsigned long vport_config_block[BITS_TO_LONGS(HCLGE_VPORT_NUM)];
+
 	struct hclge_fd_cfg fd_cfg;
 	struct hlist_head fd_rule_list;
 	spinlock_t fd_rule_lock; /* protect fd_rule_list and fd_bmap */
@@ -866,6 +874,7 @@ struct hclge_rss_tuple_cfg {
 
 enum HCLGE_VPORT_STATE {
 	HCLGE_VPORT_STATE_ALIVE,
+	HCLGE_VPORT_STATE_MAC_TBL_CHANGE,
 	HCLGE_VPORT_STATE_MAX
 };
 
@@ -922,6 +931,7 @@ struct hclge_vport {
 	u32 mps; /* Max packet size */
 	struct hclge_vf_info vf_info;
 
+	spinlock_t mac_list_lock; /* protect mac address need to add/detele */
 	struct list_head uc_mac_list;   /* Store VF unicast table */
 	struct list_head mc_mac_list;   /* Store VF multicast table */
 	struct list_head vlan_list;     /* Store VF vlan table */
@@ -977,16 +987,17 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf);
 u16 hclge_covert_handle_qid_global(struct hnae3_handle *handle, u16 queue_id);
 int hclge_notify_client(struct hclge_dev *hdev,
 			enum hnae3_reset_notify_type type);
-void hclge_add_vport_mac_table(struct hclge_vport *vport, const u8 *mac_addr,
-			       enum HCLGE_MAC_ADDR_TYPE mac_type);
-void hclge_rm_vport_mac_table(struct hclge_vport *vport, const u8 *mac_addr,
-			      bool is_write_tbl,
-			      enum HCLGE_MAC_ADDR_TYPE mac_type);
+int hclge_update_mac_list(struct hclge_vport *vport,
+			  enum HCLGE_MAC_NODE_STATE state,
+			  enum HCLGE_MAC_ADDR_TYPE mac_type,
+			  const unsigned char *addr);
+int hclge_update_mac_node_for_dev_addr(struct hclge_vport *vport,
+				       const u8 *old_addr, const u8 *new_addr);
 void hclge_rm_vport_all_mac_table(struct hclge_vport *vport, bool is_del_list,
 				  enum HCLGE_MAC_ADDR_TYPE mac_type);
-void hclge_uninit_vport_mac_table(struct hclge_dev *hdev);
 void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list);
 void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev);
+void hclge_restore_mac_table_common(struct hclge_vport *vport);
 int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 				    struct hclge_vlan_info *vlan_info);
 int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 103c2ec..0efc045 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -275,26 +275,17 @@ static int hclge_set_vf_uc_mac_addr(struct hclge_vport *vport,
 		if (!is_valid_ether_addr(mac_addr))
 			return -EINVAL;
 
-		hclge_rm_uc_addr_common(vport, old_addr);
-		status = hclge_add_uc_addr_common(vport, mac_addr);
-		if (status) {
-			hclge_add_uc_addr_common(vport, old_addr);
-		} else {
-			hclge_rm_vport_mac_table(vport, mac_addr,
-						 false, HCLGE_MAC_ADDR_UC);
-			hclge_add_vport_mac_table(vport, mac_addr,
-						  HCLGE_MAC_ADDR_UC);
-		}
+		spin_lock_bh(&vport->mac_list_lock);
+		status = hclge_update_mac_node_for_dev_addr(vport, old_addr,
+							    mac_addr);
+		spin_unlock_bh(&vport->mac_list_lock);
+		hclge_task_schedule(hdev, 0);
 	} else if (mbx_req->msg.subcode == HCLGE_MBX_MAC_VLAN_UC_ADD) {
-		status = hclge_add_uc_addr_common(vport, mac_addr);
-		if (!status)
-			hclge_add_vport_mac_table(vport, mac_addr,
-						  HCLGE_MAC_ADDR_UC);
+		status = hclge_update_mac_list(vport, HCLGE_MAC_TO_ADD,
+					       HCLGE_MAC_ADDR_UC, mac_addr);
 	} else if (mbx_req->msg.subcode == HCLGE_MBX_MAC_VLAN_UC_REMOVE) {
-		status = hclge_rm_uc_addr_common(vport, mac_addr);
-		if (!status)
-			hclge_rm_vport_mac_table(vport, mac_addr,
-						 false, HCLGE_MAC_ADDR_UC);
+		status = hclge_update_mac_list(vport, HCLGE_MAC_TO_DEL,
+					       HCLGE_MAC_ADDR_UC, mac_addr);
 	} else {
 		dev_err(&hdev->pdev->dev,
 			"failed to set unicast mac addr, unknown subcode %u\n",
@@ -310,18 +301,13 @@ static int hclge_set_vf_mc_mac_addr(struct hclge_vport *vport,
 {
 	const u8 *mac_addr = (const u8 *)(mbx_req->msg.data);
 	struct hclge_dev *hdev = vport->back;
-	int status;
 
 	if (mbx_req->msg.subcode == HCLGE_MBX_MAC_VLAN_MC_ADD) {
-		status = hclge_add_mc_addr_common(vport, mac_addr);
-		if (!status)
-			hclge_add_vport_mac_table(vport, mac_addr,
-						  HCLGE_MAC_ADDR_MC);
+		hclge_update_mac_list(vport, HCLGE_MAC_TO_ADD,
+				      HCLGE_MAC_ADDR_MC, mac_addr);
 	} else if (mbx_req->msg.subcode == HCLGE_MBX_MAC_VLAN_MC_REMOVE) {
-		status = hclge_rm_mc_addr_common(vport, mac_addr);
-		if (!status)
-			hclge_rm_vport_mac_table(vport, mac_addr,
-						 false, HCLGE_MAC_ADDR_MC);
+		hclge_update_mac_list(vport, HCLGE_MAC_TO_DEL,
+				      HCLGE_MAC_ADDR_MC, mac_addr);
 	} else {
 		dev_err(&hdev->pdev->dev,
 			"failed to set mcast mac addr, unknown subcode %u\n",
@@ -329,7 +315,7 @@ static int hclge_set_vf_mc_mac_addr(struct hclge_vport *vport,
 		return -EIO;
 	}
 
-	return status;
+	return 0;
 }
 
 int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index e02d427..05d485a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1245,10 +1245,12 @@ static int hclgevf_set_mac_addr(struct hnae3_handle *handle, void *p,
 	int status;
 
 	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_UNICAST, 0);
-	send_msg.subcode = is_first ? HCLGE_MBX_MAC_VLAN_UC_ADD :
-			HCLGE_MBX_MAC_VLAN_UC_MODIFY;
+	send_msg.subcode = HCLGE_MBX_MAC_VLAN_UC_MODIFY;
 	ether_addr_copy(send_msg.data, new_mac_addr);
-	ether_addr_copy(&send_msg.data[ETH_ALEN], old_mac_addr);
+	if (is_first && !hdev->has_pf_mac)
+		eth_zero_addr(&send_msg.data[ETH_ALEN]);
+	else
+		ether_addr_copy(&send_msg.data[ETH_ALEN], old_mac_addr);
 	status = hclgevf_send_mbx_msg(hdev, &send_msg, true, NULL, 0);
 	if (!status)
 		ether_addr_copy(hdev->hw.mac.mac_addr, new_mac_addr);
@@ -1256,54 +1258,302 @@ static int hclgevf_set_mac_addr(struct hnae3_handle *handle, void *p,
 	return status;
 }
 
-static int hclgevf_add_uc_addr(struct hnae3_handle *handle,
-			       const unsigned char *addr)
+static struct hclgevf_mac_addr_node *
+hclgevf_find_mac_node(struct list_head *list, const u8 *mac_addr)
+{
+	struct hclgevf_mac_addr_node *mac_node, *tmp;
+
+	list_for_each_entry_safe(mac_node, tmp, list, node)
+		if (ether_addr_equal(mac_addr, mac_node->mac_addr))
+			return mac_node;
+
+	return NULL;
+}
+
+static void hclgevf_update_mac_node(struct hclgevf_mac_addr_node *mac_node,
+				    enum HCLGEVF_MAC_NODE_STATE state)
+{
+	switch (state) {
+	/* from set_rx_mode or tmp_add_list */
+	case HCLGEVF_MAC_TO_ADD:
+		if (mac_node->state == HCLGEVF_MAC_TO_DEL)
+			mac_node->state = HCLGEVF_MAC_ACTIVE;
+		break;
+	/* only from set_rx_mode */
+	case HCLGEVF_MAC_TO_DEL:
+		if (mac_node->state == HCLGEVF_MAC_TO_ADD) {
+			list_del(&mac_node->node);
+			kfree(mac_node);
+		} else {
+			mac_node->state = HCLGEVF_MAC_TO_DEL;
+		}
+		break;
+	/* only from tmp_add_list, the mac_node->state won't be
+	 * HCLGEVF_MAC_ACTIVE
+	 */
+	case HCLGEVF_MAC_ACTIVE:
+		if (mac_node->state == HCLGEVF_MAC_TO_ADD)
+			mac_node->state = HCLGEVF_MAC_ACTIVE;
+		break;
+	}
+}
+
+static int hclgevf_update_mac_list(struct hnae3_handle *handle,
+				   enum HCLGEVF_MAC_NODE_STATE state,
+				   enum HCLGEVF_MAC_ADDR_TYPE mac_type,
+				   const unsigned char *addr)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	struct hclge_vf_to_pf_msg send_msg;
+	struct hclgevf_mac_addr_node *mac_node;
+	struct list_head *list;
 
-	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_UNICAST,
-			       HCLGE_MBX_MAC_VLAN_UC_ADD);
-	ether_addr_copy(send_msg.data, addr);
-	return hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
+	list = (mac_type == HCLGEVF_MAC_ADDR_UC) ?
+	       &hdev->mac_table.uc_mac_list : &hdev->mac_table.mc_mac_list;
+
+	spin_lock_bh(&hdev->mac_table.mac_list_lock);
+
+	/* if the mac addr is already in the mac list, no need to add a new
+	 * one into it, just check the mac addr state, convert it to a new
+	 * new state, or just remove it, or do nothing.
+	 */
+	mac_node = hclgevf_find_mac_node(list, addr);
+	if (mac_node) {
+		hclgevf_update_mac_node(mac_node, state);
+		spin_unlock_bh(&hdev->mac_table.mac_list_lock);
+		return 0;
+	}
+	/* if this address is never added, unnecessary to delete */
+	if (state == HCLGEVF_MAC_TO_DEL) {
+		spin_unlock_bh(&hdev->mac_table.mac_list_lock);
+		return -ENOENT;
+	}
+
+	mac_node = kzalloc(sizeof(*mac_node), GFP_ATOMIC);
+	if (!mac_node) {
+		spin_unlock_bh(&hdev->mac_table.mac_list_lock);
+		return -ENOMEM;
+	}
+
+	mac_node->state = state;
+	ether_addr_copy(mac_node->mac_addr, addr);
+	list_add_tail(&mac_node->node, list);
+
+	spin_unlock_bh(&hdev->mac_table.mac_list_lock);
+	return 0;
+}
+
+static int hclgevf_add_uc_addr(struct hnae3_handle *handle,
+			       const unsigned char *addr)
+{
+	return hclgevf_update_mac_list(handle, HCLGEVF_MAC_TO_ADD,
+				       HCLGEVF_MAC_ADDR_UC, addr);
 }
 
 static int hclgevf_rm_uc_addr(struct hnae3_handle *handle,
 			      const unsigned char *addr)
 {
-	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	struct hclge_vf_to_pf_msg send_msg;
-
-	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_UNICAST,
-			       HCLGE_MBX_MAC_VLAN_UC_REMOVE);
-	ether_addr_copy(send_msg.data, addr);
-	return hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
+	return hclgevf_update_mac_list(handle, HCLGEVF_MAC_TO_DEL,
+				       HCLGEVF_MAC_ADDR_UC, addr);
 }
 
 static int hclgevf_add_mc_addr(struct hnae3_handle *handle,
 			       const unsigned char *addr)
 {
-	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	struct hclge_vf_to_pf_msg send_msg;
-
-	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_MULTICAST,
-			       HCLGE_MBX_MAC_VLAN_MC_ADD);
-	ether_addr_copy(send_msg.data, addr);
-	return hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
+	return hclgevf_update_mac_list(handle, HCLGEVF_MAC_TO_ADD,
+				       HCLGEVF_MAC_ADDR_MC, addr);
 }
 
 static int hclgevf_rm_mc_addr(struct hnae3_handle *handle,
 			      const unsigned char *addr)
 {
-	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	return hclgevf_update_mac_list(handle, HCLGEVF_MAC_TO_DEL,
+				       HCLGEVF_MAC_ADDR_MC, addr);
+}
+
+static int hclgevf_add_del_mac_addr(struct hclgevf_dev *hdev,
+				    struct hclgevf_mac_addr_node *mac_node,
+				    enum HCLGEVF_MAC_ADDR_TYPE mac_type)
+{
 	struct hclge_vf_to_pf_msg send_msg;
+	u8 code, subcode;
 
-	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_MULTICAST,
-			       HCLGE_MBX_MAC_VLAN_MC_REMOVE);
-	ether_addr_copy(send_msg.data, addr);
+	if (mac_type == HCLGEVF_MAC_ADDR_UC) {
+		code = HCLGE_MBX_SET_UNICAST;
+		if (mac_node->state == HCLGEVF_MAC_TO_ADD)
+			subcode = HCLGE_MBX_MAC_VLAN_UC_ADD;
+		else
+			subcode = HCLGE_MBX_MAC_VLAN_UC_REMOVE;
+	} else {
+		code = HCLGE_MBX_SET_MULTICAST;
+		if (mac_node->state == HCLGEVF_MAC_TO_ADD)
+			subcode = HCLGE_MBX_MAC_VLAN_MC_ADD;
+		else
+			subcode = HCLGE_MBX_MAC_VLAN_MC_REMOVE;
+	}
+
+	hclgevf_build_send_msg(&send_msg, code, subcode);
+	ether_addr_copy(send_msg.data, mac_node->mac_addr);
 	return hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 }
 
+static void hclgevf_config_mac_list(struct hclgevf_dev *hdev,
+				    struct list_head *list,
+				    enum HCLGEVF_MAC_ADDR_TYPE mac_type)
+{
+	struct hclgevf_mac_addr_node *mac_node, *tmp;
+	int ret;
+
+	list_for_each_entry_safe(mac_node, tmp, list, node) {
+		ret = hclgevf_add_del_mac_addr(hdev, mac_node, mac_type);
+		if  (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to configure mac %pM, state = %d, ret = %d\n",
+				mac_node->mac_addr, mac_node->state, ret);
+			return;
+		}
+		if (mac_node->state == HCLGEVF_MAC_TO_ADD) {
+			mac_node->state = HCLGEVF_MAC_ACTIVE;
+		} else {
+			list_del(&mac_node->node);
+			kfree(mac_node);
+		}
+	}
+}
+
+static void hclgevf_sync_from_add_list(struct list_head *add_list,
+				       struct list_head *mac_list)
+{
+	struct hclgevf_mac_addr_node *mac_node, *tmp, *new_node;
+
+	list_for_each_entry_safe(mac_node, tmp, add_list, node) {
+		/* if the mac address from tmp_add_list is not in the
+		 * uc/mc_mac_list, it means have received a TO_DEL request
+		 * during the time window of sending mac config request to PF
+		 * If mac_node state is ACTIVE, then change its state to TO_DEL,
+		 * then it will be removed at next time. If is TO_ADD, it means
+		 * send TO_ADD request failed, so just remove the mac node.
+		 */
+		new_node = hclgevf_find_mac_node(mac_list, mac_node->mac_addr);
+		if (new_node) {
+			hclgevf_update_mac_node(new_node, mac_node->state);
+			list_del(&mac_node->node);
+			kfree(mac_node);
+		} else if (mac_node->state == HCLGEVF_MAC_ACTIVE) {
+			mac_node->state = HCLGEVF_MAC_TO_DEL;
+			list_del(&mac_node->node);
+			list_add_tail(&mac_node->node, mac_list);
+		} else {
+			list_del(&mac_node->node);
+			kfree(mac_node);
+		}
+	}
+}
+
+static void hclgevf_sync_from_del_list(struct list_head *del_list,
+				       struct list_head *mac_list)
+{
+	struct hclgevf_mac_addr_node *mac_node, *tmp, *new_node;
+
+	list_for_each_entry_safe(mac_node, tmp, del_list, node) {
+		new_node = hclgevf_find_mac_node(mac_list, mac_node->mac_addr);
+		if (new_node) {
+			/* If the mac addr is exist in the mac list, it means
+			 * received a new request TO_ADD during the time window
+			 * of sending mac addr configurrequest to PF, so just
+			 * change the mac state to ACTIVE.
+			 */
+			new_node->state = HCLGEVF_MAC_ACTIVE;
+			list_del(&mac_node->node);
+			kfree(mac_node);
+		} else {
+			list_del(&mac_node->node);
+			list_add_tail(&mac_node->node, mac_list);
+		}
+	}
+}
+
+static void hclgevf_clear_list(struct list_head *list)
+{
+	struct hclgevf_mac_addr_node *mac_node, *tmp;
+
+	list_for_each_entry_safe(mac_node, tmp, list, node) {
+		list_del(&mac_node->node);
+		kfree(mac_node);
+	}
+}
+
+static void hclgevf_sync_mac_list(struct hclgevf_dev *hdev,
+				  enum HCLGEVF_MAC_ADDR_TYPE mac_type)
+{
+	struct hclgevf_mac_addr_node *mac_node, *tmp, *new_node;
+	struct list_head tmp_add_list, tmp_del_list;
+	struct list_head *list;
+
+	INIT_LIST_HEAD(&tmp_add_list);
+	INIT_LIST_HEAD(&tmp_del_list);
+
+	/* move the mac addr to the tmp_add_list and tmp_del_list, then
+	 * we can add/delete these mac addr outside the spin lock
+	 */
+	list = (mac_type == HCLGEVF_MAC_ADDR_UC) ?
+		&hdev->mac_table.uc_mac_list : &hdev->mac_table.mc_mac_list;
+
+	spin_lock_bh(&hdev->mac_table.mac_list_lock);
+
+	list_for_each_entry_safe(mac_node, tmp, list, node) {
+		switch (mac_node->state) {
+		case HCLGEVF_MAC_TO_DEL:
+			list_del(&mac_node->node);
+			list_add_tail(&mac_node->node, &tmp_del_list);
+			break;
+		case HCLGEVF_MAC_TO_ADD:
+			new_node = kzalloc(sizeof(*new_node), GFP_ATOMIC);
+			if (!new_node)
+				goto stop_traverse;
+
+			ether_addr_copy(new_node->mac_addr, mac_node->mac_addr);
+			new_node->state = mac_node->state;
+			list_add_tail(&new_node->node, &tmp_add_list);
+			break;
+		default:
+			break;
+		}
+	}
+
+stop_traverse:
+	spin_unlock_bh(&hdev->mac_table.mac_list_lock);
+
+	/* delete first, in order to get max mac table space for adding */
+	hclgevf_config_mac_list(hdev, &tmp_del_list, mac_type);
+	hclgevf_config_mac_list(hdev, &tmp_add_list, mac_type);
+
+	/* if some mac addresses were added/deleted fail, move back to the
+	 * mac_list, and retry at next time.
+	 */
+	spin_lock_bh(&hdev->mac_table.mac_list_lock);
+
+	hclgevf_sync_from_del_list(&tmp_del_list, list);
+	hclgevf_sync_from_add_list(&tmp_add_list, list);
+
+	spin_unlock_bh(&hdev->mac_table.mac_list_lock);
+}
+
+static void hclgevf_sync_mac_table(struct hclgevf_dev *hdev)
+{
+	hclgevf_sync_mac_list(hdev, HCLGEVF_MAC_ADDR_UC);
+	hclgevf_sync_mac_list(hdev, HCLGEVF_MAC_ADDR_MC);
+}
+
+static void hclgevf_uninit_mac_list(struct hclgevf_dev *hdev)
+{
+	spin_lock_bh(&hdev->mac_table.mac_list_lock);
+
+	hclgevf_clear_list(&hdev->mac_table.uc_mac_list);
+	hclgevf_clear_list(&hdev->mac_table.mc_mac_list);
+
+	spin_unlock_bh(&hdev->mac_table.mac_list_lock);
+}
+
 static int hclgevf_set_vlan_filter(struct hnae3_handle *handle,
 				   __be16 proto, u16 vlan_id,
 				   bool is_kill)
@@ -1951,6 +2201,8 @@ static void hclgevf_periodic_service_task(struct hclgevf_dev *hdev)
 
 	hclgevf_sync_vlan_filter(hdev);
 
+	hclgevf_sync_mac_table(hdev);
+
 	hdev->last_serv_processed = jiffies;
 
 out:
@@ -2313,6 +2565,10 @@ static void hclgevf_state_init(struct hclgevf_dev *hdev)
 	mutex_init(&hdev->mbx_resp.mbx_mutex);
 	sema_init(&hdev->reset_sem, 1);
 
+	spin_lock_init(&hdev->mac_table.mac_list_lock);
+	INIT_LIST_HEAD(&hdev->mac_table.uc_mac_list);
+	INIT_LIST_HEAD(&hdev->mac_table.mc_mac_list);
+
 	/* bring the device down */
 	set_bit(HCLGEVF_STATE_DOWN, &hdev->state);
 }
@@ -2846,6 +3102,7 @@ static void hclgevf_uninit_hdev(struct hclgevf_dev *hdev)
 
 	hclgevf_pci_uninit(hdev);
 	hclgevf_cmd_uninit(hdev);
+	hclgevf_uninit_mac_list(hdev);
 }
 
 static int hclgevf_init_ae_dev(struct hnae3_ae_dev *ae_dev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 3b88d86..0222d9b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -234,6 +234,29 @@ struct hclgevf_rst_stats {
 	u32 rst_fail_cnt;		/* the number of VF reset fail */
 };
 
+enum HCLGEVF_MAC_ADDR_TYPE {
+	HCLGEVF_MAC_ADDR_UC,
+	HCLGEVF_MAC_ADDR_MC
+};
+
+enum HCLGEVF_MAC_NODE_STATE {
+	HCLGEVF_MAC_TO_ADD,
+	HCLGEVF_MAC_TO_DEL,
+	HCLGEVF_MAC_ACTIVE
+};
+
+struct hclgevf_mac_addr_node {
+	struct list_head node;
+	enum HCLGEVF_MAC_NODE_STATE state;
+	u8 mac_addr[ETH_ALEN];
+};
+
+struct hclgevf_mac_table_cfg {
+	spinlock_t mac_list_lock; /* protect mac address need to add/detele */
+	struct list_head uc_mac_list;
+	struct list_head mc_mac_list;
+};
+
 struct hclgevf_dev {
 	struct pci_dev *pdev;
 	struct hnae3_ae_dev *ae_dev;
@@ -282,6 +305,8 @@ struct hclgevf_dev {
 
 	unsigned long vlan_del_fail_bmap[BITS_TO_LONGS(VLAN_N_VID)];
 
+	struct hclgevf_mac_table_cfg mac_table;
+
 	bool mbx_event_pending;
 	struct hclgevf_mbx_resp_status mbx_resp; /* mailbox response */
 	struct hclgevf_mbx_arq_ring arq; /* mailbox async rx queue */
-- 
2.7.4

