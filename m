Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0B31DCC3F
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 13:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgEULjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 07:39:55 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38054 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728442AbgEULjx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 07:39:53 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B49FD873553E99206E3E;
        Thu, 21 May 2020 19:39:49 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 21 May 2020 19:39:43 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        GuoJia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 1/2] net: hns3: adds support for dynamic VLAN mode
Date:   Thu, 21 May 2020 19:38:24 +0800
Message-ID: <1590061105-36478-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590061105-36478-1-git-send-email-tanhuazhong@huawei.com>
References: <1590061105-36478-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: GuoJia Liao <liaoguojia@huawei.com>

There is a scenario which needs vNICs enable the VLAN filter
in access port, while disable the VLAN filter in trunk port.
Access port and trunk port can switch according to the user's
configuration.

This patch adds a new VLAN mode called dynamic mode for it.
So there are two VLAN modes supported in HNS3 driver: default
VLAN mode and dynamic VLAN mode, chosen by firmware.

For default VLAN mode, both port VLAN filter and VF VLAN filter
are enabled.

For dynamic VLAN mode, port VLAN filter is always disabled, and
VF VLAN filter is keep disable until a non-zero VLAN ID being
used for the function.

Furthermore, in original implement the port VLAN filter and VF
VLAN filter is enabled when user disable promisc mode. Now for
dynamic VLAN mode, it should also take account of whether a
non-zero VLAN ID used.

Signed-off-by: GuoJia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   5 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   3 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   6 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 121 +++++++++++++++++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  21 ++++
 6 files changed, 132 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 7506cab..e5973d6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -643,9 +643,12 @@ struct hnae3_unic_private_info {
 #define HNAE3_BPE		BIT(2)	/* broadcast promisc enable */
 #define HNAE3_OVERFLOW_UPE	BIT(3)	/* unicast mac vlan overflow */
 #define HNAE3_OVERFLOW_MPE	BIT(4)	/* multicast mac vlan overflow */
-#define HNAE3_VLAN_FLTR		BIT(5)	/* enable vlan filter */
+#define HNAE3_VLAN_FLTR		BIT(5)	/* enable vlan filter by promisc mode */
+#define HNAE3_VF_VLAN_EN	BIT(6)	/* enable vf vlan filter by vlan used */
 #define HNAE3_UPE		(HNAE3_USER_UPE | HNAE3_OVERFLOW_UPE)
 #define HNAE3_MPE		(HNAE3_USER_MPE | HNAE3_OVERFLOW_MPE)
+#define HNAE3_OVERFLOW_UMPE	(HNAE3_OVERFLOW_UPE | HNAE3_OVERFLOW_MPE)
+#define HNAE3_VLAN_FLTR_EN	(HNAE3_VLAN_FLTR | HNAE3_VF_VLAN_EN)
 
 struct hnae3_handle {
 	struct hnae3_client *client;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 9fe40c7..80b07ee 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -584,6 +584,7 @@ static int hns3_nic_mc_unsync(struct net_device *netdev,
 
 static u8 hns3_get_netdev_flags(struct net_device *netdev)
 {
+	struct hnae3_handle *h = hns3_get_handle(netdev);
 	u8 flags = 0;
 
 	if (netdev->flags & IFF_PROMISC) {
@@ -594,6 +595,8 @@ static u8 hns3_get_netdev_flags(struct net_device *netdev)
 			flags |= HNAE3_USER_MPE;
 	}
 
+	flags |= (h->netdev_flags & HNAE3_VF_VLAN_EN);
+
 	return flags;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 6b1545f..10dfdfd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -106,7 +106,8 @@ static int hns3_lp_setup(struct net_device *ndev, enum hnae3_loop loop, bool en)
 	} else {
 		/* recover promisc mode before loopback test */
 		hns3_request_update_promisc_mode(h);
-		vlan_filter_enable = ndev->flags & IFF_PROMISC ? false : true;
+		vlan_filter_enable = (h->netdev_flags & HNAE3_VLAN_FLTR_EN) ?
+				      false : true;
 		hns3_enable_vlan_filter(ndev, vlan_filter_enable);
 	}
 
@@ -386,7 +387,8 @@ static void hns3_self_test(struct net_device *ndev,
 
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 	if (dis_vlan_filter)
-		h->ae_algo->ops->enable_vlan_filter(h, true);
+		h->ae_algo->ops->enable_vlan_filter(h,
+					h->netdev_flags & HNAE3_VLAN_FLTR_EN);
 #endif
 
 	if (if_running)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index e3bab8f..85aa879 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -491,6 +491,8 @@ struct hclge_pf_res_cmd {
 #define HCLGE_CFG_RSS_SIZE_M	GENMASK(31, 24)
 #define HCLGE_CFG_SPEED_ABILITY_S	0
 #define HCLGE_CFG_SPEED_ABILITY_M	GENMASK(7, 0)
+#define HCLGE_CFG_VLAN_MODE_S		8
+#define HCLGE_CFG_VLAN_MODE_M		GENMASK(9, 8)
 #define HCLGE_CFG_UMV_TBL_SPACE_S	16
 #define HCLGE_CFG_UMV_TBL_SPACE_M	GENMASK(31, 16)
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b796d3f..bdacda4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -71,6 +71,7 @@ static int hclge_set_default_loopback(struct hclge_dev *hdev);
 static void hclge_sync_mac_table(struct hclge_dev *hdev);
 static void hclge_restore_hw_table(struct hclge_dev *hdev);
 static void hclge_sync_promisc_mode(struct hclge_dev *hdev);
+static int hclge_vf_vlan_filter_switch(struct hclge_vport *vport);
 
 static struct hnae3_ae_algo ae_algo;
 
@@ -1281,6 +1282,11 @@ static void hclge_parse_cfg(struct hclge_cfg *cfg, struct hclge_desc *desc)
 	cfg->speed_ability = hnae3_get_field(__le32_to_cpu(req->param[1]),
 					     HCLGE_CFG_SPEED_ABILITY_M,
 					     HCLGE_CFG_SPEED_ABILITY_S);
+
+	cfg->vlan_mode_sel = hnae3_get_field(__le32_to_cpu(req->param[1]),
+					     HCLGE_CFG_VLAN_MODE_M,
+					     HCLGE_CFG_VLAN_MODE_S);
+
 	cfg->umv_space = hnae3_get_field(__le32_to_cpu(req->param[1]),
 					 HCLGE_CFG_UMV_TBL_SPACE_M,
 					 HCLGE_CFG_UMV_TBL_SPACE_S);
@@ -1379,6 +1385,7 @@ static int hclge_configure(struct hclge_dev *hdev)
 	hdev->tc_max = cfg.tc_num;
 	hdev->tm_info.hw_pfc_map = 0;
 	hdev->wanted_umv_size = cfg.umv_space;
+	hdev->vlan_mode = cfg.vlan_mode_sel;
 
 	if (hnae3_dev_fd_supported(hdev)) {
 		hdev->fd_en = true;
@@ -8233,6 +8240,11 @@ static int hclge_set_vlan_filter_ctrl(struct hclge_dev *hdev, u8 vlan_type,
 	struct hclge_desc desc;
 	int ret;
 
+	/* bypass port vlan filter when dynamic vlan mode on */
+	if (vlan_type == HCLGE_FILTER_TYPE_PORT &&
+	    hdev->vlan_mode == HCLGE_VLAN_DYNAMIC_MODE)
+		return 0;
+
 	/* read current vlan filter parameter */
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_VLAN_FILTER_CTRL, true);
 	req = (struct hclge_vlan_filter_ctrl_cmd *)desc.data;
@@ -8259,18 +8271,6 @@ static int hclge_set_vlan_filter_ctrl(struct hclge_dev *hdev, u8 vlan_type,
 	return ret;
 }
 
-#define HCLGE_FILTER_TYPE_VF		0
-#define HCLGE_FILTER_TYPE_PORT		1
-#define HCLGE_FILTER_FE_EGRESS_V1_B	BIT(0)
-#define HCLGE_FILTER_FE_NIC_INGRESS_B	BIT(0)
-#define HCLGE_FILTER_FE_NIC_EGRESS_B	BIT(1)
-#define HCLGE_FILTER_FE_ROCE_INGRESS_B	BIT(2)
-#define HCLGE_FILTER_FE_ROCE_EGRESS_B	BIT(3)
-#define HCLGE_FILTER_FE_EGRESS		(HCLGE_FILTER_FE_NIC_EGRESS_B \
-					| HCLGE_FILTER_FE_ROCE_EGRESS_B)
-#define HCLGE_FILTER_FE_INGRESS		(HCLGE_FILTER_FE_NIC_INGRESS_B \
-					| HCLGE_FILTER_FE_ROCE_INGRESS_B)
-
 static void hclge_enable_vlan_filter(struct hnae3_handle *handle, bool enable)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
@@ -8451,6 +8451,10 @@ static int hclge_set_vlan_filter_hw(struct hclge_dev *hdev, __be16 proto,
 		return -EINVAL;
 	}
 
+	/* bypass port vlan filter when dynamic vlan mode on */
+	if (hdev->vlan_mode == HCLGE_VLAN_DYNAMIC_MODE)
+		return 0;
+
 	for_each_set_bit(vport_idx, hdev->vlan_table[vlan_id], HCLGE_VPORT_NUM)
 		vport_num++;
 
@@ -8640,6 +8644,12 @@ static int hclge_init_vlan_config(struct hclge_dev *hdev)
 		/* for revision 0x21, vf vlan filter is per function */
 		for (i = 0; i < hdev->num_alloc_vport; i++) {
 			vport = &hdev->vport[i];
+			vport->vf_vlan_en =
+				hdev->vlan_mode == HCLGE_VLAN_DEFAULT_MODE;
+
+			if (!vport->vf_vlan_en)
+				continue;
+
 			ret = hclge_set_vlan_filter_ctrl(hdev,
 							 HCLGE_FILTER_TYPE_VF,
 							 HCLGE_FILTER_FE_EGRESS,
@@ -8818,6 +8828,8 @@ void hclge_restore_vport_vlan_table(struct hclge_vport *vport)
 			break;
 		vlan->hd_tbl_status = true;
 	}
+
+	hclge_vf_vlan_filter_switch(vport);
 }
 
 /* For global reset and imp reset, hardware will clear the mac table,
@@ -8881,6 +8893,56 @@ int hclge_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable)
 	return hclge_set_vlan_rx_offload_cfg(vport);
 }
 
+static bool hclge_has_vlan_used(struct hclge_dev *hdev, u16 vport_id)
+{
+#define VLAN_CHECK_START_ID	1
+
+	u16 vlan_id;
+
+	/* if set as vlan default mode, vf vlan filter always on */
+	if (hdev->vlan_mode == HCLGE_VLAN_DEFAULT_MODE)
+		return true;
+
+	/* check all vlan tag in vf vlan table except 0 */
+	for (vlan_id = VLAN_CHECK_START_ID; vlan_id < VLAN_N_VID; vlan_id++)
+		if (test_bit(vport_id, hdev->vlan_table[vlan_id]))
+			return true;
+
+	return false;
+}
+
+static int hclge_vf_vlan_filter_switch(struct hclge_vport *vport)
+{
+	struct hnae3_handle *nic = &vport->nic;
+	struct hclge_dev *hdev = vport->back;
+	bool filter_en;
+	int ret;
+
+	filter_en = hclge_has_vlan_used(hdev, vport->vport_id) ||
+		vport->port_base_vlan_cfg.state != HNAE3_PORT_BASE_VLAN_DISABLE;
+
+	if (filter_en == vport->vf_vlan_en)
+		return 0;
+
+	ret = hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_VF,
+					 HCLGE_FILTER_FE_EGRESS,
+					 filter_en, vport->vport_id);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to %s vport%u vf vlan filter, ret = %d.\n",
+			filter_en ? "enable" : "disable", vport->vport_id, ret);
+		return ret;
+	}
+
+	vport->vf_vlan_en = filter_en;
+	if (filter_en)
+		nic->netdev_flags |= HNAE3_VF_VLAN_EN;
+	else
+		nic->netdev_flags &= ~HNAE3_VF_VLAN_EN;
+
+	return 0;
+}
+
 static int hclge_update_vlan_filter_entries(struct hclge_vport *vport,
 					    u16 port_base_vlan_state,
 					    struct hclge_vlan_info *new_info,
@@ -8921,6 +8983,9 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 	if (ret)
 		return ret;
 
+	if (old_vlan_info->vlan_tag == vlan_info->vlan_tag)
+		goto update;
+
 	if (state == HNAE3_PORT_BASE_VLAN_MODIFY) {
 		/* add new VLAN tag */
 		ret = hclge_set_vlan_filter_hw(hdev,
@@ -8948,19 +9013,18 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 	if (ret)
 		return ret;
 
-	/* update state only when disable/enable port based VLAN */
+update:
 	vport->port_base_vlan_cfg.state = state;
 	if (state == HNAE3_PORT_BASE_VLAN_DISABLE)
 		nic->port_base_vlan_state = HNAE3_PORT_BASE_VLAN_DISABLE;
 	else
 		nic->port_base_vlan_state = HNAE3_PORT_BASE_VLAN_ENABLE;
 
-update:
 	vport->port_base_vlan_cfg.vlan_info.vlan_tag = vlan_info->vlan_tag;
 	vport->port_base_vlan_cfg.vlan_info.qos = vlan_info->qos;
 	vport->port_base_vlan_cfg.vlan_info.vlan_proto = vlan_info->vlan_proto;
 
-	return 0;
+	return hclge_vf_vlan_filter_switch(vport);
 }
 
 static u16 hclge_get_port_base_vlan_state(struct hclge_vport *vport,
@@ -8970,15 +9034,16 @@ static u16 hclge_get_port_base_vlan_state(struct hclge_vport *vport,
 	if (state == HNAE3_PORT_BASE_VLAN_DISABLE) {
 		if (!vlan)
 			return HNAE3_PORT_BASE_VLAN_NOCHANGE;
-		else
-			return HNAE3_PORT_BASE_VLAN_ENABLE;
+
+		return HNAE3_PORT_BASE_VLAN_ENABLE;
 	} else {
 		if (!vlan)
 			return HNAE3_PORT_BASE_VLAN_DISABLE;
-		else if (vport->port_base_vlan_cfg.vlan_info.vlan_tag == vlan)
+
+		if (vport->port_base_vlan_cfg.vlan_info.vlan_tag == vlan)
 			return HNAE3_PORT_BASE_VLAN_NOCHANGE;
-		else
-			return HNAE3_PORT_BASE_VLAN_MODIFY;
+
+		return HNAE3_PORT_BASE_VLAN_MODIFY;
 	}
 }
 
@@ -9090,7 +9155,14 @@ int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 		 */
 		set_bit(vlan_id, vport->vlan_del_fail_bmap);
 	}
-	return ret;
+
+	if (ret) {
+		dev_info(&hdev->pdev->dev, "failed to set vf vlan, ret = %d!\n",
+			 ret);
+		return ret;
+	}
+
+	return hclge_vf_vlan_filter_switch(vport);
 }
 
 static void hclge_sync_vlan_filter(struct hclge_dev *hdev)
@@ -11104,6 +11176,7 @@ static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
 	struct hclge_vport *vport = &hdev->vport[0];
 	struct hnae3_handle *handle = &vport->nic;
 	u8 tmp_flags = 0;
+	u32 filter_en;
 	int ret;
 
 	if (vport->last_promisc_flags != vport->overflow_promisc_flags) {
@@ -11117,8 +11190,10 @@ static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
 					     tmp_flags & HNAE3_MPE);
 		if (!ret) {
 			clear_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state);
-			hclge_enable_vlan_filter(handle,
-						 tmp_flags & HNAE3_VLAN_FLTR);
+
+			filter_en = hclge_has_vlan_used(hdev, 0) ?
+							HNAE3_VLAN_FLTR : 0;
+			hclge_enable_vlan_filter(handle, tmp_flags & filter_en);
 		}
 	}
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 913c4f6..1a1a88a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -202,6 +202,18 @@ enum HLCGE_PORT_TYPE {
 #define HCLGE_SUPPORT_GE \
 	(HCLGE_SUPPORT_1G_BIT | HCLGE_SUPPORT_100M_BIT | HCLGE_SUPPORT_10M_BIT)
 
+#define HCLGE_FILTER_TYPE_VF		0
+#define HCLGE_FILTER_TYPE_PORT		1
+#define HCLGE_FILTER_FE_EGRESS_V1_B	BIT(0)
+#define HCLGE_FILTER_FE_NIC_INGRESS_B	BIT(0)
+#define HCLGE_FILTER_FE_NIC_EGRESS_B	BIT(1)
+#define HCLGE_FILTER_FE_ROCE_INGRESS_B	BIT(2)
+#define HCLGE_FILTER_FE_ROCE_EGRESS_B	BIT(3)
+#define HCLGE_FILTER_FE_EGRESS		(HCLGE_FILTER_FE_NIC_EGRESS_B \
+					| HCLGE_FILTER_FE_ROCE_EGRESS_B)
+#define HCLGE_FILTER_FE_INGRESS		(HCLGE_FILTER_FE_NIC_INGRESS_B \
+					| HCLGE_FILTER_FE_ROCE_INGRESS_B)
+
 enum HCLGE_DEV_STATE {
 	HCLGE_STATE_REINITING,
 	HCLGE_STATE_DOWN,
@@ -310,6 +322,11 @@ enum hclge_fc_mode {
 	HCLGE_FC_DEFAULT
 };
 
+enum hclge_vlan_mode_sel {
+	HCLGE_VLAN_DEFAULT_MODE,
+	HCLGE_VLAN_DYNAMIC_MODE
+};
+
 enum hclge_link_fail_code {
 	HCLGE_LF_NORMAL,
 	HCLGE_LF_REF_CLOCK_LOST,
@@ -347,6 +364,7 @@ struct hclge_cfg {
 	u8 default_speed;
 	u32 numa_node_map;
 	u8 speed_ability;
+	u8 vlan_mode_sel;
 	u16 umv_space;
 };
 
@@ -824,6 +842,8 @@ struct hclge_dev {
 	enum HCLGE_FD_ACTIVE_RULE_TYPE fd_active_type;
 	u8 fd_en;
 
+	u8 vlan_mode;
+
 	u16 wanted_umv_size;
 	/* max available unicast mac vlan space */
 	u16 max_umv_size;
@@ -914,6 +934,7 @@ struct hclge_vport {
 	u32 bw_limit;		/* VSI BW Limit (0 = disabled) */
 	u8  dwrr;
 
+	bool vf_vlan_en;
 	unsigned long vlan_del_fail_bmap[BITS_TO_LONGS(VLAN_N_VID)];
 	struct hclge_port_base_vlan_config port_base_vlan_cfg;
 	struct hclge_tx_vtag_cfg  txvlan_cfg;
-- 
2.7.4

