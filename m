Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95893953F6
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 04:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhEaClK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 22:41:10 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6086 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhEaCku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 22:40:50 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FtfYk6HrmzYprB;
        Mon, 31 May 2021 10:36:26 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 10:39:08 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 10:39:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/8] net: hns3: add support for modify VLAN filter state
Date:   Mon, 31 May 2021 10:38:42 +0800
Message-ID: <1622428725-30049-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622428725-30049-1-git-send-email-tanhuazhong@huawei.com>
References: <1622428725-30049-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Previously, with hardware limitation, the port VLAN filter are
effective for both PF and its VFs simultaneously, so a single
function is not able to enable/disable separately, and the VLAN
filter state is default enabled. Now some device supports each
function to bypass port VLAN filter, then each function can
switch VLAN filter separately. Add capability flag to check
whether the device supports modify VLAN filter state. If flag
on, user will be able to modify the VLAN filter state by ethtool
-K.

Furtherly, the default VLAN filter state is also changed
according to whether non-zero VLAN used. Then the device can
receive packet with any VLAN tag if only VLAN 0 used.

The function hclge_need_enable_vport_vlan_filter() is used to
help implement above changes. And the VLAN filter handle for
promisc mode can also be simplified by this function.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   5 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   8 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  39 ++---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   1 -
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   8 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   4 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  12 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 183 ++++++++++++++++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   8 +
 9 files changed, 214 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 57fa7fc..c79fef9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -92,6 +92,8 @@ enum HNAE3_DEV_CAP_BITS {
 	HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B,
 	HNAE3_DEV_SUPPORT_PAUSE_B,
 	HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B,
+	HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B,
+	HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B,
 };
 
 #define hnae3_dev_fd_supported(hdev) \
@@ -631,7 +633,7 @@ struct hnae3_ae_ops {
 	void (*get_mdix_mode)(struct hnae3_handle *handle,
 			      u8 *tp_mdix_ctrl, u8 *tp_mdix);
 
-	void (*enable_vlan_filter)(struct hnae3_handle *handle, bool enable);
+	int (*enable_vlan_filter)(struct hnae3_handle *handle, bool enable);
 	int (*set_vlan_filter)(struct hnae3_handle *handle, __be16 proto,
 			       u16 vlan_id, bool is_kill);
 	int (*set_vf_vlan_filter)(struct hnae3_handle *handle, int vfid,
@@ -783,7 +785,6 @@ struct hnae3_roce_private_info {
 #define HNAE3_BPE		BIT(2)	/* broadcast promisc enable */
 #define HNAE3_OVERFLOW_UPE	BIT(3)	/* unicast mac vlan overflow */
 #define HNAE3_OVERFLOW_MPE	BIT(4)	/* multicast mac vlan overflow */
-#define HNAE3_VLAN_FLTR		BIT(5)	/* enable vlan filter */
 #define HNAE3_UPE		(HNAE3_USER_UPE | HNAE3_OVERFLOW_UPE)
 #define HNAE3_MPE		(HNAE3_USER_MPE | HNAE3_OVERFLOW_MPE)
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 57ba5a1..3feba43 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -345,7 +345,13 @@ static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
 	}, {
 		.name = "support rxd advanced layout",
 		.cap_bit = HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B,
-	},
+	}, {
+		.name = "support port vlan bypass",
+		.cap_bit = HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B,
+	}, {
+		.name = "support modify vlan filter state",
+		.cap_bit = HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B,
+	}
 };
 
 static void hns3_dbg_fill_content(char *content, u16 len,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 43dcf3f..393979b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -908,13 +908,10 @@ static u8 hns3_get_netdev_flags(struct net_device *netdev)
 {
 	u8 flags = 0;
 
-	if (netdev->flags & IFF_PROMISC) {
+	if (netdev->flags & IFF_PROMISC)
 		flags = HNAE3_USER_UPE | HNAE3_USER_MPE | HNAE3_BPE;
-	} else {
-		flags |= HNAE3_VLAN_FLTR;
-		if (netdev->flags & IFF_ALLMULTI)
-			flags |= HNAE3_USER_MPE;
-	}
+	else if (netdev->flags & IFF_ALLMULTI)
+		flags = HNAE3_USER_MPE;
 
 	return flags;
 }
@@ -944,25 +941,6 @@ void hns3_request_update_promisc_mode(struct hnae3_handle *handle)
 		ops->request_update_promisc_mode(handle);
 }
 
-void hns3_enable_vlan_filter(struct net_device *netdev, bool enable)
-{
-	struct hns3_nic_priv *priv = netdev_priv(netdev);
-	struct hnae3_handle *h = priv->ae_handle;
-	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
-	bool last_state;
-
-	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2 &&
-	    h->ae_algo->ops->enable_vlan_filter) {
-		last_state = h->netdev_flags & HNAE3_VLAN_FLTR ? true : false;
-		if (enable != last_state) {
-			netdev_info(netdev,
-				    "%s vlan filter\n",
-				    enable ? "enable" : "disable");
-			h->ae_algo->ops->enable_vlan_filter(h, enable);
-		}
-	}
-}
-
 static int hns3_set_tso(struct sk_buff *skb, u32 *paylen_fdop_ol4cs,
 			u16 *mss, u32 *type_cs_vlan_tso, u32 *send_bytes)
 {
@@ -1980,6 +1958,14 @@ static int hns3_nic_set_features(struct net_device *netdev,
 		return -EINVAL;
 	}
 
+	if ((changed & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	    h->ae_algo->ops->enable_vlan_filter) {
+		enable = !!(features & NETIF_F_HW_VLAN_CTAG_FILTER);
+		ret = h->ae_algo->ops->enable_vlan_filter(h, enable);
+		if (ret)
+			return ret;
+	}
+
 	netdev->features = features;
 	return 0;
 }
@@ -2825,6 +2811,9 @@ static void hns3_set_default_feature(struct net_device *netdev)
 		netdev->hw_features |= NETIF_F_HW_TC;
 		netdev->features |= NETIF_F_HW_TC;
 	}
+
+	if (test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
+		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index b038441..5698a14 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -643,7 +643,6 @@ void hns3_set_vector_coalesce_rx_ql(struct hns3_enet_tqp_vector *tqp_vector,
 void hns3_set_vector_coalesce_tx_ql(struct hns3_enet_tqp_vector *tqp_vector,
 				    u32 ql_value);
 
-void hns3_enable_vlan_filter(struct net_device *netdev, bool enable);
 void hns3_request_update_promisc_mode(struct hnae3_handle *handle);
 
 #ifdef CONFIG_HNS3_DCB
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index c1ea403..bb7c2ec 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -88,7 +88,6 @@ static int hns3_lp_setup(struct net_device *ndev, enum hnae3_loop loop, bool en)
 {
 	struct hnae3_handle *h = hns3_get_handle(ndev);
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
-	bool vlan_filter_enable;
 	int ret;
 
 	if (!h->ae_algo->ops->set_loopback ||
@@ -110,14 +109,11 @@ static int hns3_lp_setup(struct net_device *ndev, enum hnae3_loop loop, bool en)
 	if (ret || ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
 		return ret;
 
-	if (en) {
+	if (en)
 		h->ae_algo->ops->set_promisc_mode(h, true, true);
-	} else {
+	else
 		/* recover promisc mode before loopback test */
 		hns3_request_update_promisc_mode(h);
-		vlan_filter_enable = ndev->flags & IFF_PROMISC ? false : true;
-		hns3_enable_vlan_filter(ndev, vlan_filter_enable);
-	}
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 6aed30c..8f6ed85 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -388,6 +388,10 @@ static void hclge_parse_capability(struct hclge_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGE_CAP_RXD_ADV_LAYOUT_B))
 		set_bit(HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGE_CAP_PORT_VLAN_BYPASS_B)) {
+		set_bit(HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B, ae_dev->caps);
+		set_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps);
+	}
 }
 
 static __le32 hclge_build_api_caps(void)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 12558aa..da78a64 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -236,6 +236,7 @@ enum hclge_opcode_type {
 	HCLGE_OPC_VLAN_FILTER_CTRL	    = 0x1100,
 	HCLGE_OPC_VLAN_FILTER_PF_CFG	= 0x1101,
 	HCLGE_OPC_VLAN_FILTER_VF_CFG	= 0x1102,
+	HCLGE_OPC_PORT_VLAN_BYPASS	= 0x1103,
 
 	/* Flow Director commands */
 	HCLGE_OPC_FD_MODE_CTRL		= 0x1200,
@@ -392,6 +393,7 @@ enum HCLGE_CAP_BITS {
 	HCLGE_CAP_FEC_B = 13,
 	HCLGE_CAP_PAUSE_B = 14,
 	HCLGE_CAP_RXD_ADV_LAYOUT_B = 15,
+	HCLGE_CAP_PORT_VLAN_BYPASS_B = 17,
 };
 
 enum HCLGE_API_CAP_BITS {
@@ -527,6 +529,8 @@ struct hclge_pf_res_cmd {
 #define HCLGE_CFG_SPEED_ABILITY_M	GENMASK(7, 0)
 #define HCLGE_CFG_SPEED_ABILITY_EXT_S	10
 #define HCLGE_CFG_SPEED_ABILITY_EXT_M	GENMASK(15, 10)
+#define HCLGE_CFG_VLAN_FLTR_CAP_S	8
+#define HCLGE_CFG_VLAN_FLTR_CAP_M	GENMASK(9, 8)
 #define HCLGE_CFG_UMV_TBL_SPACE_S	16
 #define HCLGE_CFG_UMV_TBL_SPACE_M	GENMASK(31, 16)
 #define HCLGE_CFG_PF_RSS_SIZE_S		0
@@ -811,6 +815,14 @@ struct hclge_vlan_filter_vf_cfg_cmd {
 	u8  vf_bitmap[HCLGE_MAX_VF_BYTES];
 };
 
+#define HCLGE_INGRESS_BYPASS_B		0
+struct hclge_port_vlan_filter_bypass_cmd {
+	u8 bypass_state;
+	u8 rsv1[3];
+	u8 vf_id;
+	u8 rsv2[19];
+};
+
 #define HCLGE_SWITCH_ANTI_SPOOF_B	0U
 #define HCLGE_SWITCH_ALW_LPBK_B		1U
 #define HCLGE_SWITCH_ALW_LCL_LPBK_B	2U
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7c6b51f..c6444d2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1334,6 +1334,10 @@ static void hclge_parse_cfg(struct hclge_cfg *cfg, struct hclge_desc *desc)
 					    HCLGE_CFG_SPEED_ABILITY_EXT_S);
 	cfg->speed_ability |= speed_ability_ext << SPEED_ABILITY_EXT_SHIFT;
 
+	cfg->vlan_fliter_cap = hnae3_get_field(__le32_to_cpu(req->param[1]),
+					       HCLGE_CFG_VLAN_FLTR_CAP_M,
+					       HCLGE_CFG_VLAN_FLTR_CAP_S);
+
 	cfg->umv_space = hnae3_get_field(__le32_to_cpu(req->param[1]),
 					 HCLGE_CFG_UMV_TBL_SPACE_M,
 					 HCLGE_CFG_UMV_TBL_SPACE_S);
@@ -1513,6 +1517,7 @@ static void hclge_init_kdump_kernel_config(struct hclge_dev *hdev)
 
 static int hclge_configure(struct hclge_dev *hdev)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct hclge_cfg cfg;
 	unsigned int i;
 	int ret;
@@ -1534,6 +1539,8 @@ static int hclge_configure(struct hclge_dev *hdev)
 	hdev->tc_max = cfg.tc_num;
 	hdev->tm_info.hw_pfc_map = 0;
 	hdev->wanted_umv_size = cfg.umv_space;
+	if (cfg.vlan_fliter_cap == HCLGE_VLAN_FLTR_CAN_MDF)
+		set_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps);
 
 	if (hnae3_dev_fd_supported(hdev)) {
 		hdev->fd_en = true;
@@ -1843,6 +1850,7 @@ static int hclge_alloc_vport(struct hclge_dev *hdev)
 		vport->mps = HCLGE_MAC_DEFAULT_FRAME;
 		vport->port_base_vlan_cfg.state = HNAE3_PORT_BASE_VLAN_DISABLE;
 		vport->rxvlan_cfg.rx_vlan_offload_en = true;
+		vport->req_vlan_fltr_en = true;
 		INIT_LIST_HEAD(&vport->vlan_list);
 		INIT_LIST_HEAD(&vport->uc_mac_list);
 		INIT_LIST_HEAD(&vport->mc_mac_list);
@@ -9381,6 +9389,28 @@ static int hclge_do_ioctl(struct hnae3_handle *handle, struct ifreq *ifr,
 	return phy_mii_ioctl(hdev->hw.mac.phydev, ifr, cmd);
 }
 
+static int hclge_set_port_vlan_filter_bypass(struct hclge_dev *hdev, u8 vf_id,
+					     bool bypass_en)
+{
+	struct hclge_port_vlan_filter_bypass_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_PORT_VLAN_BYPASS, false);
+	req = (struct hclge_port_vlan_filter_bypass_cmd *)desc.data;
+	req->vf_id = vf_id;
+	hnae3_set_bit(req->bypass_state, HCLGE_INGRESS_BYPASS_B,
+		      bypass_en ? 1 : 0);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to set vport%u port vlan filter bypass state, ret = %d.\n",
+			vf_id, ret);
+
+	return ret;
+}
+
 static int hclge_set_vlan_filter_ctrl(struct hclge_dev *hdev, u8 vlan_type,
 				      u8 fe_type, bool filter_en, u8 vf_id)
 {
@@ -9426,25 +9456,100 @@ static int hclge_set_vlan_filter_ctrl(struct hclge_dev *hdev, u8 vlan_type,
 #define HCLGE_FILTER_FE_INGRESS		(HCLGE_FILTER_FE_NIC_INGRESS_B \
 					| HCLGE_FILTER_FE_ROCE_INGRESS_B)
 
-static void hclge_enable_vlan_filter(struct hnae3_handle *handle, bool enable)
+static int hclge_set_vport_vlan_filter(struct hclge_vport *vport, bool enable)
 {
-	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
+	struct hnae3_ae_dev *ae_dev = hdev->ae_dev;
+	int ret;
 
-	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_VF,
-					   HCLGE_FILTER_FE_EGRESS, enable, 0);
-		hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_PORT,
-					   HCLGE_FILTER_FE_INGRESS, enable, 0);
-	} else {
-		hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_VF,
-					   HCLGE_FILTER_FE_EGRESS_V1_B, enable,
-					   0);
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
+		return hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_VF,
+						  HCLGE_FILTER_FE_EGRESS_V1_B,
+						  enable, vport->vport_id);
+
+	ret = hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_VF,
+					 HCLGE_FILTER_FE_EGRESS, enable,
+					 vport->vport_id);
+	if (ret)
+		return ret;
+
+	if (test_bit(HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B, ae_dev->caps))
+		ret = hclge_set_port_vlan_filter_bypass(hdev, vport->vport_id,
+							!enable);
+	else if (!vport->vport_id)
+		ret = hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_PORT,
+						 HCLGE_FILTER_FE_INGRESS,
+						 enable, 0);
+
+	return ret;
+}
+
+static bool hclge_need_enable_vport_vlan_filter(struct hclge_vport *vport)
+{
+	struct hnae3_handle *handle = &vport->nic;
+	struct hclge_vport_vlan_cfg *vlan, *tmp;
+	struct hclge_dev *hdev = vport->back;
+
+	if (vport->vport_id) {
+		if (vport->port_base_vlan_cfg.state !=
+			HNAE3_PORT_BASE_VLAN_DISABLE)
+			return true;
+
+		if (vport->vf_info.trusted && vport->vf_info.request_uc_en)
+			return false;
+	} else if (handle->netdev_flags & HNAE3_USER_UPE) {
+		return false;
 	}
-	if (enable)
-		handle->netdev_flags |= HNAE3_VLAN_FLTR;
-	else
-		handle->netdev_flags &= ~HNAE3_VLAN_FLTR;
+
+	if (!vport->req_vlan_fltr_en)
+		return false;
+
+	/* compatible with former device, always enable vlan filter */
+	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, hdev->ae_dev->caps))
+		return true;
+
+	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node)
+		if (vlan->vlan_id != 0)
+			return true;
+
+	return false;
+}
+
+static int hclge_enable_vport_vlan_filter(struct hclge_vport *vport,
+					  bool request_en)
+{
+	struct hclge_dev *hdev = vport->back;
+	bool need_en;
+	int ret;
+
+	mutex_lock(&hdev->vport_lock);
+
+	vport->req_vlan_fltr_en = request_en;
+
+	need_en = hclge_need_enable_vport_vlan_filter(vport);
+	if (need_en == vport->cur_vlan_fltr_en) {
+		mutex_unlock(&hdev->vport_lock);
+		return 0;
+	}
+
+	ret = hclge_set_vport_vlan_filter(vport, need_en);
+	if (ret) {
+		mutex_unlock(&hdev->vport_lock);
+		return ret;
+	}
+
+	vport->cur_vlan_fltr_en = need_en;
+
+	mutex_unlock(&hdev->vport_lock);
+
+	return 0;
+}
+
+static int hclge_enable_vlan_filter(struct hnae3_handle *handle, bool enable)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+
+	return hclge_enable_vport_vlan_filter(vport, enable);
 }
 
 static int hclge_set_vf_vlan_filter_cmd(struct hclge_dev *hdev, u16 vfid,
@@ -9838,6 +9943,7 @@ static int hclge_init_vlan_config(struct hclge_dev *hdev)
 							 vport->vport_id);
 			if (ret)
 				return ret;
+			vport->cur_vlan_fltr_en = true;
 		}
 
 		ret = hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_PORT,
@@ -9853,8 +9959,6 @@ static int hclge_init_vlan_config(struct hclge_dev *hdev)
 			return ret;
 	}
 
-	handle->netdev_flags |= HNAE3_VLAN_FLTR;
-
 	hdev->vlan_type_cfg.rx_in_fst_vlan_type = HCLGE_DEF_VLAN_TYPE;
 	hdev->vlan_type_cfg.rx_in_sec_vlan_type = HCLGE_DEF_VLAN_TYPE;
 	hdev->vlan_type_cfg.rx_ot_fst_vlan_type = HCLGE_DEF_VLAN_TYPE;
@@ -10077,6 +10181,14 @@ int hclge_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable)
 	return hclge_set_vlan_rx_offload_cfg(vport);
 }
 
+static void hclge_set_vport_vlan_fltr_change(struct hclge_vport *vport)
+{
+	struct hclge_dev *hdev = vport->back;
+
+	if (test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, hdev->ae_dev->caps))
+		set_bit(HCLGE_VPORT_STATE_VLAN_FLTR_CHANGE, &vport->state);
+}
+
 static int hclge_update_vlan_filter_entries(struct hclge_vport *vport,
 					    u16 port_base_vlan_state,
 					    struct hclge_vlan_info *new_info,
@@ -10185,6 +10297,7 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 		nic->port_base_vlan_state = HNAE3_PORT_BASE_VLAN_ENABLE;
 
 	vport->port_base_vlan_cfg.vlan_info = *vlan_info;
+	hclge_set_vport_vlan_fltr_change(vport);
 
 	return 0;
 }
@@ -10328,9 +10441,37 @@ int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 		 */
 		set_bit(vlan_id, vport->vlan_del_fail_bmap);
 	}
+
+	hclge_set_vport_vlan_fltr_change(vport);
+
 	return ret;
 }
 
+static void hclge_sync_vlan_fltr_state(struct hclge_dev *hdev)
+{
+	struct hclge_vport *vport;
+	int ret;
+	u16 i;
+
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		vport = &hdev->vport[i];
+		if (!test_and_clear_bit(HCLGE_VPORT_STATE_VLAN_FLTR_CHANGE,
+					&vport->state))
+			continue;
+
+		ret = hclge_enable_vport_vlan_filter(vport,
+						     vport->req_vlan_fltr_en);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to sync vlan filter state for vport%u, ret = %d\n",
+				vport->vport_id, ret);
+			set_bit(HCLGE_VPORT_STATE_VLAN_FLTR_CHANGE,
+				&vport->state);
+			return;
+		}
+	}
+}
+
 static void hclge_sync_vlan_filter(struct hclge_dev *hdev)
 {
 #define HCLGE_MAX_SYNC_COUNT	60
@@ -10353,6 +10494,7 @@ static void hclge_sync_vlan_filter(struct hclge_dev *hdev)
 
 			clear_bit(vlan_id, vport->vlan_del_fail_bmap);
 			hclge_rm_vport_vlan_table(vport, vlan_id, false);
+			hclge_set_vport_vlan_fltr_change(vport);
 
 			sync_cnt++;
 			if (sync_cnt >= HCLGE_MAX_SYNC_COUNT)
@@ -10362,6 +10504,8 @@ static void hclge_sync_vlan_filter(struct hclge_dev *hdev)
 						 VLAN_N_VID);
 		}
 	}
+
+	hclge_sync_vlan_fltr_state(hdev);
 }
 
 static int hclge_set_mac_mtu(struct hclge_dev *hdev, int new_mps)
@@ -12452,8 +12596,8 @@ static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
 		if (!ret) {
 			clear_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
 				  &vport->state);
-			hclge_enable_vlan_filter(handle,
-						 tmp_flags & HNAE3_VLAN_FLTR);
+			set_bit(HCLGE_VPORT_STATE_VLAN_FLTR_CHANGE,
+				&vport->state);
 		}
 	}
 
@@ -12481,6 +12625,7 @@ static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
 				&vport->state);
 			return;
 		}
+		hclge_set_vport_vlan_fltr_change(vport);
 	}
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index cd1e401..eb03652 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -321,6 +321,10 @@ enum hclge_fc_mode {
 	HCLGE_FC_DEFAULT
 };
 
+enum hclge_vlan_fltr_cap {
+	HCLGE_VLAN_FLTR_DEF,
+	HCLGE_VLAN_FLTR_CAN_MDF,
+};
 enum hclge_link_fail_code {
 	HCLGE_LF_NORMAL,
 	HCLGE_LF_REF_CLOCK_LOST,
@@ -351,6 +355,7 @@ struct hclge_tc_info {
 
 struct hclge_cfg {
 	u8 tc_num;
+	u8 vlan_fliter_cap;
 	u16 tqp_desc_num;
 	u16 rx_buf_len;
 	u16 vf_rss_size_max;
@@ -957,6 +962,7 @@ enum HCLGE_VPORT_STATE {
 	HCLGE_VPORT_STATE_ALIVE,
 	HCLGE_VPORT_STATE_MAC_TBL_CHANGE,
 	HCLGE_VPORT_STATE_PROMISC_CHANGE,
+	HCLGE_VPORT_STATE_VLAN_FLTR_CHANGE,
 	HCLGE_VPORT_STATE_MAX
 };
 
@@ -998,6 +1004,8 @@ struct hclge_vport {
 	u32 bw_limit;		/* VSI BW Limit (0 = disabled) */
 	u8  dwrr;
 
+	bool req_vlan_fltr_en;
+	bool cur_vlan_fltr_en;
 	unsigned long vlan_del_fail_bmap[BITS_TO_LONGS(VLAN_N_VID)];
 	struct hclge_port_base_vlan_config port_base_vlan_cfg;
 	struct hclge_tx_vtag_cfg  txvlan_cfg;
-- 
2.7.4

