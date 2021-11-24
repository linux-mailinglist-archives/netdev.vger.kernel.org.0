Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02E945B10A
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 02:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbhKXBOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 20:14:47 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:15859 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbhKXBOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 20:14:41 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HzNHW164cz91Gc;
        Wed, 24 Nov 2021 09:11:03 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 09:11:29 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 09:11:29 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 2/4] net: hns3: format the output of the MAC address
Date:   Wed, 24 Nov 2021 09:06:52 +0800
Message-ID: <20211124010654.6753-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124010654.6753-1-huangguangbin2@huawei.com>
References: <20211124010654.6753-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Printing the whole MAC addresse may bring security risks. Therefore,
the MAC address is partially encrypted to improve security.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   | 14 +++++
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 29 +++++++---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 55 ++++++++++++-------
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  7 ++-
 4 files changed, 74 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 3f7a9a4c59d5..54caf0dd1204 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -859,6 +859,20 @@ struct hnae3_handle {
 #define hnae3_get_bit(origin, shift) \
 	hnae3_get_field(origin, 0x1 << (shift), shift)
 
+#define HNAE3_FORMAT_MAC_ADDR_LEN	18
+#define HNAE3_FORMAT_MAC_ADDR_OFFSET_0	0
+#define HNAE3_FORMAT_MAC_ADDR_OFFSET_4	4
+#define HNAE3_FORMAT_MAC_ADDR_OFFSET_5	5
+
+static inline void hnae3_format_mac_addr(char *format_mac_addr,
+					 const u8 *mac_addr)
+{
+	snprintf(format_mac_addr, HNAE3_FORMAT_MAC_ADDR_LEN, "%02x:**:**:**:%02x:%02x",
+		 mac_addr[HNAE3_FORMAT_MAC_ADDR_OFFSET_0],
+		 mac_addr[HNAE3_FORMAT_MAC_ADDR_OFFSET_4],
+		 mac_addr[HNAE3_FORMAT_MAC_ADDR_OFFSET_5]);
+}
+
 int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev);
 void hnae3_unregister_ae_dev(struct hnae3_ae_dev *ae_dev);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 1429235d3a06..0225d6091cf2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2251,6 +2251,8 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 static int hns3_nic_net_set_mac_address(struct net_device *netdev, void *p)
 {
+	char format_mac_addr_perm[HNAE3_FORMAT_MAC_ADDR_LEN];
+	char format_mac_addr_sa[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct sockaddr *mac_addr = p;
 	int ret;
@@ -2259,8 +2261,9 @@ static int hns3_nic_net_set_mac_address(struct net_device *netdev, void *p)
 		return -EADDRNOTAVAIL;
 
 	if (ether_addr_equal(netdev->dev_addr, mac_addr->sa_data)) {
-		netdev_info(netdev, "already using mac address %pM\n",
-			    mac_addr->sa_data);
+		hnae3_format_mac_addr(format_mac_addr_sa, mac_addr->sa_data);
+		netdev_info(netdev, "already using mac address %s\n",
+			    format_mac_addr_sa);
 		return 0;
 	}
 
@@ -2269,8 +2272,10 @@ static int hns3_nic_net_set_mac_address(struct net_device *netdev, void *p)
 	 */
 	if (!hns3_is_phys_func(h->pdev) &&
 	    !is_zero_ether_addr(netdev->perm_addr)) {
-		netdev_err(netdev, "has permanent MAC %pM, user MAC %pM not allow\n",
-			   netdev->perm_addr, mac_addr->sa_data);
+		hnae3_format_mac_addr(format_mac_addr_perm, netdev->perm_addr);
+		hnae3_format_mac_addr(format_mac_addr_sa, mac_addr->sa_data);
+		netdev_err(netdev, "has permanent MAC %s, user MAC %s not allow\n",
+			   format_mac_addr_perm, format_mac_addr_sa);
 		return -EPERM;
 	}
 
@@ -2832,14 +2837,16 @@ static int hns3_nic_set_vf_rate(struct net_device *ndev, int vf,
 static int hns3_nic_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 
 	if (!h->ae_algo->ops->set_vf_mac)
 		return -EOPNOTSUPP;
 
 	if (is_multicast_ether_addr(mac)) {
+		hnae3_format_mac_addr(format_mac_addr, mac);
 		netdev_err(netdev,
-			   "Invalid MAC:%pM specified. Could not set MAC\n",
-			   mac);
+			   "Invalid MAC:%s specified. Could not set MAC\n",
+			   format_mac_addr);
 		return -EINVAL;
 	}
 
@@ -4930,6 +4937,7 @@ static void hns3_uninit_all_ring(struct hns3_nic_priv *priv)
 static int hns3_init_mac_addr(struct net_device *netdev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hnae3_handle *h = priv->ae_handle;
 	u8 mac_addr_temp[ETH_ALEN];
 	int ret = 0;
@@ -4940,8 +4948,9 @@ static int hns3_init_mac_addr(struct net_device *netdev)
 	/* Check if the MAC address is valid, if not get a random one */
 	if (!is_valid_ether_addr(mac_addr_temp)) {
 		eth_hw_addr_random(netdev);
-		dev_warn(priv->dev, "using random MAC address %pM\n",
-			 netdev->dev_addr);
+		hnae3_format_mac_addr(format_mac_addr, netdev->dev_addr);
+		dev_warn(priv->dev, "using random MAC address %s\n",
+			 format_mac_addr);
 	} else if (!ether_addr_equal(netdev->dev_addr, mac_addr_temp)) {
 		eth_hw_addr_set(netdev, mac_addr_temp);
 		ether_addr_copy(netdev->perm_addr, mac_addr_temp);
@@ -4993,8 +5002,10 @@ static void hns3_client_stop(struct hnae3_handle *handle)
 static void hns3_info_show(struct hns3_nic_priv *priv)
 {
 	struct hnae3_knic_private_info *kinfo = &priv->ae_handle->kinfo;
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 
-	dev_info(priv->dev, "MAC address: %pM\n", priv->netdev->dev_addr);
+	hnae3_format_mac_addr(format_mac_addr, priv->netdev->dev_addr);
+	dev_info(priv->dev, "MAC address: %s\n", format_mac_addr);
 	dev_info(priv->dev, "Task queue pairs numbers: %u\n", kinfo->num_tqps);
 	dev_info(priv->dev, "RSS size: %u\n", kinfo->rss_size);
 	dev_info(priv->dev, "Allocated RSS size: %u\n", kinfo->req_rss_size);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index dd98143a65ee..a0628d139149 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8761,6 +8761,7 @@ int hclge_update_mac_list(struct hclge_vport *vport,
 			  enum HCLGE_MAC_ADDR_TYPE mac_type,
 			  const unsigned char *addr)
 {
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_mac_node *mac_node;
 	struct list_head *list;
@@ -8785,9 +8786,10 @@ int hclge_update_mac_list(struct hclge_vport *vport,
 	/* if this address is never added, unnecessary to delete */
 	if (state == HCLGE_MAC_TO_DEL) {
 		spin_unlock_bh(&vport->mac_list_lock);
+		hnae3_format_mac_addr(format_mac_addr, addr);
 		dev_err(&hdev->pdev->dev,
-			"failed to delete address %pM from mac list\n",
-			addr);
+			"failed to delete address %s from mac list\n",
+			format_mac_addr);
 		return -ENOENT;
 	}
 
@@ -8820,6 +8822,7 @@ static int hclge_add_uc_addr(struct hnae3_handle *handle,
 int hclge_add_uc_addr_common(struct hclge_vport *vport,
 			     const unsigned char *addr)
 {
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_mac_vlan_tbl_entry_cmd req;
 	struct hclge_desc desc;
@@ -8830,9 +8833,10 @@ int hclge_add_uc_addr_common(struct hclge_vport *vport,
 	if (is_zero_ether_addr(addr) ||
 	    is_broadcast_ether_addr(addr) ||
 	    is_multicast_ether_addr(addr)) {
+		hnae3_format_mac_addr(format_mac_addr, addr);
 		dev_err(&hdev->pdev->dev,
-			"Set_uc mac err! invalid mac:%pM. is_zero:%d,is_br=%d,is_mul=%d\n",
-			 addr, is_zero_ether_addr(addr),
+			"Set_uc mac err! invalid mac:%s. is_zero:%d,is_br=%d,is_mul=%d\n",
+			 format_mac_addr, is_zero_ether_addr(addr),
 			 is_broadcast_ether_addr(addr),
 			 is_multicast_ether_addr(addr));
 		return -EINVAL;
@@ -8889,6 +8893,7 @@ static int hclge_rm_uc_addr(struct hnae3_handle *handle,
 int hclge_rm_uc_addr_common(struct hclge_vport *vport,
 			    const unsigned char *addr)
 {
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_mac_vlan_tbl_entry_cmd req;
 	int ret;
@@ -8897,8 +8902,9 @@ int hclge_rm_uc_addr_common(struct hclge_vport *vport,
 	if (is_zero_ether_addr(addr) ||
 	    is_broadcast_ether_addr(addr) ||
 	    is_multicast_ether_addr(addr)) {
-		dev_dbg(&hdev->pdev->dev, "Remove mac err! invalid mac:%pM.\n",
-			addr);
+		hnae3_format_mac_addr(format_mac_addr, addr);
+		dev_dbg(&hdev->pdev->dev, "Remove mac err! invalid mac:%s.\n",
+			format_mac_addr);
 		return -EINVAL;
 	}
 
@@ -8929,6 +8935,7 @@ static int hclge_add_mc_addr(struct hnae3_handle *handle,
 int hclge_add_mc_addr_common(struct hclge_vport *vport,
 			     const unsigned char *addr)
 {
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_mac_vlan_tbl_entry_cmd req;
 	struct hclge_desc desc[3];
@@ -8937,9 +8944,10 @@ int hclge_add_mc_addr_common(struct hclge_vport *vport,
 
 	/* mac addr check */
 	if (!is_multicast_ether_addr(addr)) {
+		hnae3_format_mac_addr(format_mac_addr, addr);
 		dev_err(&hdev->pdev->dev,
-			"Add mc mac err! invalid mac:%pM.\n",
-			 addr);
+			"Add mc mac err! invalid mac:%s.\n",
+			 format_mac_addr);
 		return -EINVAL;
 	}
 	memset(&req, 0, sizeof(req));
@@ -8991,6 +8999,7 @@ static int hclge_rm_mc_addr(struct hnae3_handle *handle,
 int hclge_rm_mc_addr_common(struct hclge_vport *vport,
 			    const unsigned char *addr)
 {
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_mac_vlan_tbl_entry_cmd req;
 	enum hclge_cmd_status status;
@@ -8998,9 +9007,10 @@ int hclge_rm_mc_addr_common(struct hclge_vport *vport,
 
 	/* mac addr check */
 	if (!is_multicast_ether_addr(addr)) {
+		hnae3_format_mac_addr(format_mac_addr, addr);
 		dev_dbg(&hdev->pdev->dev,
-			"Remove mc mac err! invalid mac:%pM.\n",
-			 addr);
+			"Remove mc mac err! invalid mac:%s.\n",
+			 format_mac_addr);
 		return -EINVAL;
 	}
 
@@ -9440,16 +9450,18 @@ static int hclge_set_vf_mac(struct hnae3_handle *handle, int vf,
 			    u8 *mac_addr)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclge_dev *hdev = vport->back;
 
 	vport = hclge_get_vf_vport(hdev, vf);
 	if (!vport)
 		return -EINVAL;
 
+	hnae3_format_mac_addr(format_mac_addr, mac_addr);
 	if (ether_addr_equal(mac_addr, vport->vf_info.mac)) {
 		dev_info(&hdev->pdev->dev,
-			 "Specified MAC(=%pM) is same as before, no change committed!\n",
-			 mac_addr);
+			 "Specified MAC(=%s) is same as before, no change committed!\n",
+			 format_mac_addr);
 		return 0;
 	}
 
@@ -9457,13 +9469,13 @@ static int hclge_set_vf_mac(struct hnae3_handle *handle, int vf,
 
 	if (test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state)) {
 		dev_info(&hdev->pdev->dev,
-			 "MAC of VF %d has been set to %pM, and it will be reinitialized!\n",
-			 vf, mac_addr);
+			 "MAC of VF %d has been set to %s, and it will be reinitialized!\n",
+			 vf, format_mac_addr);
 		return hclge_inform_reset_assert_to_vf(vport);
 	}
 
-	dev_info(&hdev->pdev->dev, "MAC of VF %d has been set to %pM\n",
-		 vf, mac_addr);
+	dev_info(&hdev->pdev->dev, "MAC of VF %d has been set to %s\n",
+		 vf, format_mac_addr);
 	return 0;
 }
 
@@ -9567,6 +9579,7 @@ static int hclge_set_mac_addr(struct hnae3_handle *handle, const void *p,
 {
 	const unsigned char *new_addr = (const unsigned char *)p;
 	struct hclge_vport *vport = hclge_get_vport(handle);
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclge_dev *hdev = vport->back;
 	unsigned char *old_addr = NULL;
 	int ret;
@@ -9575,9 +9588,10 @@ static int hclge_set_mac_addr(struct hnae3_handle *handle, const void *p,
 	if (is_zero_ether_addr(new_addr) ||
 	    is_broadcast_ether_addr(new_addr) ||
 	    is_multicast_ether_addr(new_addr)) {
+		hnae3_format_mac_addr(format_mac_addr, new_addr);
 		dev_err(&hdev->pdev->dev,
-			"change uc mac err! invalid mac: %pM.\n",
-			 new_addr);
+			"change uc mac err! invalid mac: %s.\n",
+			 format_mac_addr);
 		return -EINVAL;
 	}
 
@@ -9595,9 +9609,10 @@ static int hclge_set_mac_addr(struct hnae3_handle *handle, const void *p,
 	spin_lock_bh(&vport->mac_list_lock);
 	ret = hclge_update_mac_node_for_dev_addr(vport, old_addr, new_addr);
 	if (ret) {
+		hnae3_format_mac_addr(format_mac_addr, new_addr);
 		dev_err(&hdev->pdev->dev,
-			"failed to change the mac addr:%pM, ret = %d\n",
-			new_addr, ret);
+			"failed to change the mac addr:%s, ret = %d\n",
+			format_mac_addr, ret);
 		spin_unlock_bh(&vport->mac_list_lock);
 
 		if (!is_first)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 25c419d40066..9b6829e6e54c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1514,15 +1514,18 @@ static void hclgevf_config_mac_list(struct hclgevf_dev *hdev,
 				    struct list_head *list,
 				    enum HCLGEVF_MAC_ADDR_TYPE mac_type)
 {
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclgevf_mac_addr_node *mac_node, *tmp;
 	int ret;
 
 	list_for_each_entry_safe(mac_node, tmp, list, node) {
 		ret = hclgevf_add_del_mac_addr(hdev, mac_node, mac_type);
 		if  (ret) {
+			hnae3_format_mac_addr(format_mac_addr,
+					      mac_node->mac_addr);
 			dev_err(&hdev->pdev->dev,
-				"failed to configure mac %pM, state = %d, ret = %d\n",
-				mac_node->mac_addr, mac_node->state, ret);
+				"failed to configure mac %s, state = %d, ret = %d\n",
+				format_mac_addr, mac_node->state, ret);
 			return;
 		}
 		if (mac_node->state == HCLGEVF_MAC_TO_ADD) {
-- 
2.33.0

