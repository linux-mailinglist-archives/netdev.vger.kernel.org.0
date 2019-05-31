Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E15DC30AD2
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfEaI4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:56:42 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37044 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726485AbfEaI4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:56:35 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2E185DFFA0789037CEC9;
        Fri, 31 May 2019 16:56:32 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Fri, 31 May 2019 16:56:26 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 03/12] net: hns3: fix VLAN filter restore issue after reset
Date:   Fri, 31 May 2019 16:54:49 +0800
Message-ID: <1559292898-64090-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
References: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

In orginal codes, the driver only restore VLAN filter entries
for PF after reset, the VLAN entries of VF will lose in this
case.

This patch fixes it by recording VLAN IDs for each function
when add VLAN, and restore the VLAN IDs after reset.

Fixes: 681ec3999b3d ("net: hns3: fix for vlan table lost problem when resetting")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  3 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 34 ++----------------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  1 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 42 +++++++++++++++++++---
 4 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 51c2ff1..2e478d9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -338,6 +338,8 @@ struct hnae3_ae_dev {
  *   Set vlan filter config of Ports
  * set_vf_vlan_filter()
  *   Set vlan filter config of vf
+ * restore_vlan_table()
+ *   Restore vlan filter entries after reset
  * enable_hw_strip_rxvtag()
  *   Enable/disable hardware strip vlan tag of packets received
  * set_gro_en
@@ -505,6 +507,7 @@ struct hnae3_ae_ops {
 	void (*set_timer_task)(struct hnae3_handle *handle, bool enable);
 	int (*mac_connect_phy)(struct hnae3_handle *handle);
 	void (*mac_disconnect_phy)(struct hnae3_handle *handle);
+	void (*restore_vlan_table)(struct hnae3_handle *handle);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index f6dc305..1e68bcb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1548,15 +1548,11 @@ static int hns3_vlan_rx_add_vid(struct net_device *netdev,
 				__be16 proto, u16 vid)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
-	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	int ret = -EIO;
 
 	if (h->ae_algo->ops->set_vlan_filter)
 		ret = h->ae_algo->ops->set_vlan_filter(h, proto, vid, false);
 
-	if (!ret)
-		set_bit(vid, priv->active_vlans);
-
 	return ret;
 }
 
@@ -1564,33 +1560,11 @@ static int hns3_vlan_rx_kill_vid(struct net_device *netdev,
 				 __be16 proto, u16 vid)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
-	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	int ret = -EIO;
 
 	if (h->ae_algo->ops->set_vlan_filter)
 		ret = h->ae_algo->ops->set_vlan_filter(h, proto, vid, true);
 
-	if (!ret)
-		clear_bit(vid, priv->active_vlans);
-
-	return ret;
-}
-
-static int hns3_restore_vlan(struct net_device *netdev)
-{
-	struct hns3_nic_priv *priv = netdev_priv(netdev);
-	int ret = 0;
-	u16 vid;
-
-	for_each_set_bit(vid, priv->active_vlans, VLAN_N_VID) {
-		ret = hns3_vlan_rx_add_vid(netdev, htons(ETH_P_8021Q), vid);
-		if (ret) {
-			netdev_err(netdev, "Restore vlan: %d filter, ret:%d\n",
-				   vid, ret);
-			return ret;
-		}
-	}
-
 	return ret;
 }
 
@@ -4301,12 +4275,8 @@ static int hns3_reset_notify_restore_enet(struct hnae3_handle *handle)
 	vlan_filter_enable = netdev->flags & IFF_PROMISC ? false : true;
 	hns3_enable_vlan_filter(netdev, vlan_filter_enable);
 
-	/* Hardware table is only clear when pf resets */
-	if (!(handle->flags & HNAE3_SUPPORT_VF)) {
-		ret = hns3_restore_vlan(netdev);
-		if (ret)
-			return ret;
-	}
+	if (handle->ae_algo->ops->restore_vlan_table)
+		handle->ae_algo->ops->restore_vlan_table(handle);
 
 	return hns3_restore_fd_rules(netdev);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 408efd5..efab15f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -550,7 +550,6 @@ struct hns3_nic_priv {
 	struct notifier_block notifier_block;
 	/* Vxlan/Geneve information */
 	struct hns3_udp_tunnel udp_tnl[HNS3_UDP_TNL_MAX];
-	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
 	struct hns3_enet_coalesce tx_coal;
 	struct hns3_enet_coalesce rx_coal;
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 1215455..4873a8e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7401,10 +7401,6 @@ static void hclge_add_vport_vlan_table(struct hclge_vport *vport, u16 vlan_id,
 {
 	struct hclge_vport_vlan_cfg *vlan;
 
-	/* vlan 0 is reserved */
-	if (!vlan_id)
-		return;
-
 	vlan = kzalloc(sizeof(*vlan), GFP_KERNEL);
 	if (!vlan)
 		return;
@@ -7499,6 +7495,43 @@ void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
 	mutex_unlock(&hdev->vport_cfg_mutex);
 }
 
+static void hclge_restore_vlan_table(struct hnae3_handle *handle)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_vport_vlan_cfg *vlan, *tmp;
+	struct hclge_dev *hdev = vport->back;
+	u16 vlan_proto, qos;
+	u16 state, vlan_id;
+	int i;
+
+	mutex_lock(&hdev->vport_cfg_mutex);
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		vport = &hdev->vport[i];
+		vlan_proto = vport->port_base_vlan_cfg.vlan_info.vlan_proto;
+		vlan_id = vport->port_base_vlan_cfg.vlan_info.vlan_tag;
+		qos = vport->port_base_vlan_cfg.vlan_info.qos;
+		state = vport->port_base_vlan_cfg.state;
+
+		if (state != HNAE3_PORT_BASE_VLAN_DISABLE) {
+			hclge_set_vlan_filter_hw(hdev, htons(vlan_proto),
+						 vport->vport_id, vlan_id, qos,
+						 false);
+			continue;
+		}
+
+		list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
+			if (vlan->hd_tbl_status)
+				hclge_set_vlan_filter_hw(hdev,
+							 htons(ETH_P_8021Q),
+							 vport->vport_id,
+							 vlan->vlan_id, 0,
+							 false);
+		}
+	}
+
+	mutex_unlock(&hdev->vport_cfg_mutex);
+}
+
 int hclge_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
@@ -9206,6 +9239,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.set_timer_task = hclge_set_timer_task,
 	.mac_connect_phy = hclge_mac_connect_phy,
 	.mac_disconnect_phy = hclge_mac_disconnect_phy,
+	.restore_vlan_table = hclge_restore_vlan_table,
 };
 
 static struct hnae3_ae_algo ae_algo = {
-- 
2.7.4

