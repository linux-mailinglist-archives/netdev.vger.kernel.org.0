Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9290ACF064
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 03:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbfJHBWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 21:22:53 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:52992 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729375AbfJHBWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 21:22:53 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 547A0C915A3F05747E90;
        Tue,  8 Oct 2019 09:22:51 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 8 Oct 2019 09:22:42 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next 1/6] net: hns3: add support for setting VF link status on the host
Date:   Tue, 8 Oct 2019 09:20:04 +0800
Message-ID: <1570497609-36349-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570497609-36349-1-git-send-email-tanhuazhong@huawei.com>
References: <1570497609-36349-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

This patch adds support to configure VF link properties.
The options are auto, enable, and disable. Even if the PF
is down, the communication between VFs will be normal
if the VFs are set to enable. The commands are as follows:

'ip link set <pf> vf <vf_id> state <auto|enable|disable>'
change the VF status

'ip link show'
show the setting status

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  8 +++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 24 +++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 57 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  6 +++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 17 ++++++-
 5 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index c4b7bf8..1fc3728 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -364,6 +364,10 @@ struct hnae3_ae_dev {
  *   Enable/disable HW GRO
  * add_arfs_entry
  *   Check the 5-tuples of flow, and create flow director rule
+ * get_vf_config
+ *   Get the VF configuration setting by the host
+ * set_vf_link_state
+ *   Set VF link status
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -529,6 +533,10 @@ struct hnae3_ae_ops {
 	int (*mac_connect_phy)(struct hnae3_handle *handle);
 	void (*mac_disconnect_phy)(struct hnae3_handle *handle);
 	void (*restore_vlan_table)(struct hnae3_handle *handle);
+	int (*get_vf_config)(struct hnae3_handle *handle, int vf,
+			     struct ifla_vf_info *ivf);
+	int (*set_vf_link_state)(struct hnae3_handle *handle, int vf,
+				 int link_state);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 616cad0..2136323 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1805,6 +1805,28 @@ static int hns3_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
 }
 #endif
 
+static int hns3_nic_get_vf_config(struct net_device *ndev, int vf,
+				  struct ifla_vf_info *ivf)
+{
+	struct hnae3_handle *h = hns3_get_handle(ndev);
+
+	if (!h->ae_algo->ops->get_vf_config)
+		return -EOPNOTSUPP;
+
+	return h->ae_algo->ops->get_vf_config(h, vf, ivf);
+}
+
+static int hns3_nic_set_vf_link_state(struct net_device *ndev, int vf,
+				      int link_state)
+{
+	struct hnae3_handle *h = hns3_get_handle(ndev);
+
+	if (!h->ae_algo->ops->set_vf_link_state)
+		return -EOPNOTSUPP;
+
+	return h->ae_algo->ops->set_vf_link_state(h, vf, link_state);
+}
+
 static const struct net_device_ops hns3_nic_netdev_ops = {
 	.ndo_open		= hns3_nic_net_open,
 	.ndo_stop		= hns3_nic_net_stop,
@@ -1823,6 +1845,8 @@ static const struct net_device_ops hns3_nic_netdev_ops = {
 #ifdef CONFIG_RFS_ACCEL
 	.ndo_rx_flow_steer	= hns3_rx_flow_steer,
 #endif
+	.ndo_get_vf_config	= hns3_nic_get_vf_config,
+	.ndo_set_vf_link_state	= hns3_nic_set_vf_link_state,
 
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fd7f943..931a311 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -55,6 +55,8 @@
 
 #define HCLGE_LINK_STATUS_MS	10
 
+#define HCLGE_VF_VPORT_START_NUM	1
+
 static int hclge_set_mac_mtu(struct hclge_dev *hdev, int new_mps);
 static int hclge_init_vlan_config(struct hclge_dev *hdev);
 static void hclge_sync_vlan_filter(struct hclge_dev *hdev);
@@ -1633,6 +1635,7 @@ static int hclge_alloc_vport(struct hclge_dev *hdev)
 	for (i = 0; i < num_vport; i++) {
 		vport->back = hdev;
 		vport->vport_id = i;
+		vport->vf_info.link_state = IFLA_VF_LINK_STATE_AUTO;
 		vport->mps = HCLGE_MAC_DEFAULT_FRAME;
 		vport->port_base_vlan_cfg.state = HNAE3_PORT_BASE_VLAN_DISABLE;
 		vport->rxvlan_cfg.rx_vlan_offload_en = true;
@@ -2853,6 +2856,58 @@ static int hclge_get_status(struct hnae3_handle *handle)
 	return hdev->hw.mac.link;
 }
 
+static struct hclge_vport *hclge_get_vf_vport(struct hclge_dev *hdev, int vf)
+{
+	if (pci_num_vf(hdev->pdev) == 0) {
+		dev_err(&hdev->pdev->dev,
+			"SRIOV is disabled, can not get vport(%d) info.\n", vf);
+		return NULL;
+	}
+
+	if (vf < 0 || vf >= pci_num_vf(hdev->pdev)) {
+		dev_err(&hdev->pdev->dev,
+			"vf id(%d) is out of range(0 <= vfid < %d)\n",
+			vf, pci_num_vf(hdev->pdev));
+		return NULL;
+	}
+
+	/* VF start from 1 in vport */
+	vf += HCLGE_VF_VPORT_START_NUM;
+	return &hdev->vport[vf];
+}
+
+static int hclge_get_vf_config(struct hnae3_handle *handle, int vf,
+			       struct ifla_vf_info *ivf)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+
+	vport = hclge_get_vf_vport(hdev, vf);
+	if (!vport)
+		return -EINVAL;
+
+	ivf->vf = vf;
+	ivf->linkstate = vport->vf_info.link_state;
+	ether_addr_copy(ivf->mac, vport->vf_info.mac);
+
+	return 0;
+}
+
+static int hclge_set_vf_link_state(struct hnae3_handle *handle, int vf,
+				   int link_state)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+
+	vport = hclge_get_vf_vport(hdev, vf);
+	if (!vport)
+		return -EINVAL;
+
+	vport->vf_info.link_state = link_state;
+
+	return 0;
+}
+
 static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 {
 	u32 rst_src_reg, cmdq_src_reg, msix_src_reg;
@@ -10152,6 +10207,8 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.mac_connect_phy = hclge_mac_connect_phy,
 	.mac_disconnect_phy = hclge_mac_disconnect_phy,
 	.restore_vlan_table = hclge_restore_vlan_table,
+	.get_vf_config = hclge_get_vf_config,
+	.set_vf_link_state = hclge_set_vf_link_state,
 };
 
 static struct hnae3_ae_algo ae_algo = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 3e9574a..6a3ccda 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -885,6 +885,11 @@ struct hclge_port_base_vlan_config {
 	struct hclge_vlan_info vlan_info;
 };
 
+struct hclge_vf_info {
+	int link_state;
+	u8 mac[ETH_ALEN];
+};
+
 struct hclge_vport {
 	u16 alloc_tqps;	/* Allocated Tx/Rx queues */
 
@@ -916,6 +921,7 @@ struct hclge_vport {
 	unsigned long state;
 	unsigned long last_active_jiffies;
 	u32 mps; /* Max packet size */
+	struct hclge_vf_info vf_info;
 
 	struct list_head uc_mac_list;   /* Store VF unicast table */
 	struct list_head mc_mac_list;   /* Store VF multicast table */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index f5da28a..b842291 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -428,6 +428,9 @@ static int hclge_get_vf_media_type(struct hclge_vport *vport,
 static int hclge_get_link_info(struct hclge_vport *vport,
 			       struct hclge_mbx_vf_to_pf_cmd *mbx_req)
 {
+#define HCLGE_VF_LINK_STATE_UP		1U
+#define HCLGE_VF_LINK_STATE_DOWN	0U
+
 	struct hclge_dev *hdev = vport->back;
 	u16 link_status;
 	u8 msg_data[8];
@@ -435,7 +438,19 @@ static int hclge_get_link_info(struct hclge_vport *vport,
 	u16 duplex;
 
 	/* mac.link can only be 0 or 1 */
-	link_status = (u16)hdev->hw.mac.link;
+	switch (vport->vf_info.link_state) {
+	case IFLA_VF_LINK_STATE_ENABLE:
+		link_status = HCLGE_VF_LINK_STATE_UP;
+		break;
+	case IFLA_VF_LINK_STATE_DISABLE:
+		link_status = HCLGE_VF_LINK_STATE_DOWN;
+		break;
+	case IFLA_VF_LINK_STATE_AUTO:
+	default:
+		link_status = (u16)hdev->hw.mac.link;
+		break;
+	}
+
 	duplex = hdev->hw.mac.duplex;
 	memcpy(&msg_data[0], &link_status, sizeof(u16));
 	memcpy(&msg_data[2], &hdev->hw.mac.speed, sizeof(u32));
-- 
2.7.4

