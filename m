Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482C63387E9
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 09:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbhCLIua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 03:50:30 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13155 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhCLIty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 03:49:54 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DxfZr52xnzmWY3;
        Fri, 12 Mar 2021 16:47:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Mar 2021 16:49:39 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/4] net: hns3: add support for imp-controlled PHYs
Date:   Fri, 12 Mar 2021 16:50:13 +0800
Message-ID: <1615539016-45698-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1615539016-45698-1-git-send-email-tanhuazhong@huawei.com>
References: <1615539016-45698-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

IMP(Intelligent Management Processor) firmware add a new feature
to take control of PHYs for some new devices, PF driver adds
support for this feature.

Driver queries device's capability to check whether IMP supports
this feature, it will tell IMP to enable this feature by firmware
compatible command if it is supported.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   9 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   4 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  27 ++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 149 ++++++++++++++++++++-
 6 files changed, 192 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 9e9076f..3a6bf1a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -653,6 +653,10 @@ struct hnae3_ae_ops {
 	int (*del_cls_flower)(struct hnae3_handle *handle,
 			      struct flow_cls_offload *cls_flower);
 	bool (*cls_flower_active)(struct hnae3_handle *handle);
+	int (*get_phy_link_ksettings)(struct hnae3_handle *handle,
+				      struct ethtool_link_ksettings *cmd);
+	int (*set_phy_link_ksettings)(struct hnae3_handle *handle,
+				      const struct ethtool_link_ksettings *cmd);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index ded92ea..9d702bd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -365,6 +365,8 @@ static void hns3_dbg_dev_caps(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "support PAUSE: %s\n",
 		 test_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps) ?
 		 "yes" : "no");
+	dev_info(&h->pdev->dev, "support imp-controlled PHY: %s\n",
+		 test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, caps) ? "yes" : "no");
 }
 
 static void hns3_dbg_dev_specs(struct hnae3_handle *h)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 28afb27..a1d69c5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -700,6 +700,7 @@ static int hns3_get_link_ksettings(struct net_device *netdev,
 				   struct ethtool_link_ksettings *cmd)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
 	const struct hnae3_ae_ops *ops;
 	u8 module_type;
 	u8 media_type;
@@ -730,7 +731,10 @@ static int hns3_get_link_ksettings(struct net_device *netdev,
 		break;
 	case HNAE3_MEDIA_TYPE_COPPER:
 		cmd->base.port = PORT_TP;
-		if (!netdev->phydev)
+		if (test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, ae_dev->caps) &&
+		    ops->get_phy_link_ksettings)
+			ops->get_phy_link_ksettings(h, cmd);
+		else if (!netdev->phydev)
 			hns3_get_ksettings(h, cmd);
 		else
 			phy_ethtool_ksettings_get(netdev->phydev, cmd);
@@ -823,6 +827,9 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 			return -EINVAL;
 
 		return phy_ethtool_ksettings_set(netdev->phydev, cmd);
+	} else if (test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, ae_dev->caps) &&
+		   ops->set_phy_link_ksettings) {
+		return ops->set_phy_link_ksettings(handle, cmd);
 	}
 
 	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 1c90c6b..3284a2c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -385,6 +385,8 @@ static void hclge_parse_capability(struct hclge_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGE_CAP_PAUSE_B))
 		set_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGE_CAP_PHY_IMP_B))
+		set_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, ae_dev->caps);
 }
 
 static __le32 hclge_build_api_caps(void)
@@ -474,6 +476,8 @@ static int hclge_firmware_compat_config(struct hclge_dev *hdev)
 
 	hnae3_set_bit(compat, HCLGE_LINK_EVENT_REPORT_EN_B, 1);
 	hnae3_set_bit(compat, HCLGE_NCSI_ERROR_REPORT_EN_B, 1);
+	if (hnae3_dev_phy_imp_supported(hdev))
+		hnae3_set_bit(compat, HCLGE_PHY_IMP_EN_B, 1);
 	req->compat = cpu_to_le32(compat);
 
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 774a9ad..f45ceaa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -303,6 +303,9 @@ enum hclge_opcode_type {
 	HCLGE_PPP_CMD1_INT_CMD		= 0x2101,
 	HCLGE_MAC_ETHERTYPE_IDX_RD      = 0x2105,
 	HCLGE_NCSI_INT_EN		= 0x2401,
+
+	/* PHY command */
+	HCLGE_OPC_PHY_LINK_KSETTING	= 0x7025,
 };
 
 #define HCLGE_TQP_REG_OFFSET		0x80000
@@ -1098,6 +1101,7 @@ struct hclge_query_ppu_pf_other_int_dfx_cmd {
 
 #define HCLGE_LINK_EVENT_REPORT_EN_B	0
 #define HCLGE_NCSI_ERROR_REPORT_EN_B	1
+#define HCLGE_PHY_IMP_EN_B		2
 struct hclge_firmware_compat_cmd {
 	__le32 compat;
 	u8 rsv[20];
@@ -1139,6 +1143,29 @@ struct hclge_dev_specs_1_cmd {
 	u8 rsv1[18];
 };
 
+#define HCLGE_PHY_LINK_SETTING_BD_NUM		2
+
+struct hclge_phy_link_ksetting_0_cmd {
+	__le32 speed;
+	u8 duplex;
+	u8 autoneg;
+	u8 eth_tp_mdix;
+	u8 eth_tp_mdix_ctrl;
+	u8 port;
+	u8 transceiver;
+	u8 phy_address;
+	u8 rsv;
+	__le32 supported;
+	__le32 advertising;
+	__le32 lp_advertising;
+};
+
+struct hclge_phy_link_ksetting_1_cmd {
+	u8 master_slave_cfg;
+	u8 master_slave_state;
+	u8 rsv[22];
+};
+
 int hclge_cmd_init(struct hclge_dev *hdev);
 static inline void hclge_write_reg(void __iomem *base, u32 reg, u32 value)
 {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 26269d6..a39afcd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2994,6 +2994,141 @@ static int hclge_get_sfp_info(struct hclge_dev *hdev, struct hclge_mac *mac)
 	return 0;
 }
 
+static int hclge_get_phy_link_ksettings(struct hnae3_handle *handle,
+					struct ethtool_link_ksettings *cmd)
+{
+	struct hclge_desc desc[HCLGE_PHY_LINK_SETTING_BD_NUM];
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_phy_link_ksetting_0_cmd *req0;
+	struct hclge_phy_link_ksetting_1_cmd *req1;
+	u32 supported, advertising, lp_advertising;
+	struct hclge_dev *hdev = vport->back;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_PHY_LINK_KSETTING,
+				   true);
+	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_PHY_LINK_KSETTING,
+				   true);
+
+	ret = hclge_cmd_send(&hdev->hw, desc, HCLGE_PHY_LINK_SETTING_BD_NUM);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get phy link ksetting, ret = %d.\n", ret);
+		return ret;
+	}
+
+	req0 = (struct hclge_phy_link_ksetting_0_cmd *)desc[0].data;
+	cmd->base.autoneg = req0->autoneg;
+	cmd->base.speed = le32_to_cpu(req0->speed);
+	cmd->base.duplex = req0->duplex;
+	cmd->base.port = req0->port;
+	cmd->base.transceiver = req0->transceiver;
+	cmd->base.phy_address = req0->phy_address;
+	cmd->base.eth_tp_mdix = req0->eth_tp_mdix;
+	cmd->base.eth_tp_mdix_ctrl = req0->eth_tp_mdix_ctrl;
+	supported = le32_to_cpu(req0->supported);
+	advertising = le32_to_cpu(req0->advertising);
+	lp_advertising = le32_to_cpu(req0->lp_advertising);
+	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
+						supported);
+	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
+						advertising);
+	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.lp_advertising,
+						lp_advertising);
+
+	req1 = (struct hclge_phy_link_ksetting_1_cmd *)desc[1].data;
+	cmd->base.master_slave_cfg = req1->master_slave_cfg;
+	cmd->base.master_slave_state = req1->master_slave_state;
+
+	return 0;
+}
+
+static int
+hclge_set_phy_link_ksettings(struct hnae3_handle *handle,
+			     const struct ethtool_link_ksettings *cmd)
+{
+	struct hclge_desc desc[HCLGE_PHY_LINK_SETTING_BD_NUM];
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_phy_link_ksetting_0_cmd *req0;
+	struct hclge_phy_link_ksetting_1_cmd *req1;
+	struct hclge_dev *hdev = vport->back;
+	u32 advertising;
+	int ret;
+
+	if (cmd->base.autoneg == AUTONEG_DISABLE &&
+	    ((cmd->base.speed != SPEED_100 && cmd->base.speed != SPEED_10) ||
+	     (cmd->base.duplex != DUPLEX_HALF &&
+	      cmd->base.duplex != DUPLEX_FULL)))
+		return -EINVAL;
+
+	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_PHY_LINK_KSETTING,
+				   false);
+	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_PHY_LINK_KSETTING,
+				   false);
+
+	req0 = (struct hclge_phy_link_ksetting_0_cmd *)desc[0].data;
+	req0->autoneg = cmd->base.autoneg;
+	req0->speed = cpu_to_le32(cmd->base.speed);
+	req0->duplex = cmd->base.duplex;
+	ethtool_convert_link_mode_to_legacy_u32(&advertising,
+						cmd->link_modes.advertising);
+	req0->advertising = cpu_to_le32(advertising);
+	req0->eth_tp_mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
+
+	req1 = (struct hclge_phy_link_ksetting_1_cmd *)desc[1].data;
+	req1->master_slave_cfg = cmd->base.master_slave_cfg;
+
+	ret = hclge_cmd_send(&hdev->hw, desc, HCLGE_PHY_LINK_SETTING_BD_NUM);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to set phy link ksettings, ret = %d.\n", ret);
+		return ret;
+	}
+
+	hdev->hw.mac.autoneg = cmd->base.autoneg;
+	hdev->hw.mac.speed = cmd->base.speed;
+	hdev->hw.mac.duplex = cmd->base.duplex;
+	linkmode_copy(hdev->hw.mac.advertising, cmd->link_modes.advertising);
+
+	return 0;
+}
+
+static int hclge_update_tp_port_info(struct hclge_dev *hdev)
+{
+	struct ethtool_link_ksettings cmd;
+	int ret;
+
+	if (!hnae3_dev_phy_imp_supported(hdev))
+		return 0;
+
+	ret = hclge_get_phy_link_ksettings(&hdev->vport->nic, &cmd);
+	if (ret)
+		return ret;
+
+	hdev->hw.mac.autoneg = cmd.base.autoneg;
+	hdev->hw.mac.speed = cmd.base.speed;
+	hdev->hw.mac.duplex = cmd.base.duplex;
+
+	return 0;
+}
+
+static int hclge_tp_port_init(struct hclge_dev *hdev)
+{
+	struct ethtool_link_ksettings cmd;
+
+	if (!hnae3_dev_phy_imp_supported(hdev))
+		return 0;
+
+	cmd.base.autoneg = hdev->hw.mac.autoneg;
+	cmd.base.speed = hdev->hw.mac.speed;
+	cmd.base.duplex = hdev->hw.mac.duplex;
+	linkmode_copy(cmd.link_modes.advertising, hdev->hw.mac.advertising);
+
+	return hclge_set_phy_link_ksettings(&hdev->vport->nic, &cmd);
+}
+
 static int hclge_update_port_info(struct hclge_dev *hdev)
 {
 	struct hclge_mac *mac = &hdev->hw.mac;
@@ -3002,7 +3137,7 @@ static int hclge_update_port_info(struct hclge_dev *hdev)
 
 	/* get the port info from SFP cmd if not copper port */
 	if (mac->media_type == HNAE3_MEDIA_TYPE_COPPER)
-		return 0;
+		return hclge_update_tp_port_info(hdev);
 
 	/* if IMP does not support get SFP/qSFP info, return directly */
 	if (!hdev->support_sfp_query)
@@ -10648,7 +10783,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto err_msi_irq_uninit;
 
-	if (hdev->hw.mac.media_type == HNAE3_MEDIA_TYPE_COPPER) {
+	if (hdev->hw.mac.media_type == HNAE3_MEDIA_TYPE_COPPER &&
+	    !hnae3_dev_phy_imp_supported(hdev)) {
 		ret = hclge_mac_mdio_config(hdev);
 		if (ret)
 			goto err_msi_irq_uninit;
@@ -11041,6 +11177,13 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 		return ret;
 	}
 
+	ret = hclge_tp_port_init(hdev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to init tp port, ret = %d\n",
+			ret);
+		return ret;
+	}
+
 	ret = hclge_config_tso(hdev, HCLGE_TSO_MSS_MIN, HCLGE_TSO_MSS_MAX);
 	if (ret) {
 		dev_err(&pdev->dev, "Enable tso fail, ret =%d\n", ret);
@@ -11982,6 +12125,8 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.add_cls_flower = hclge_add_cls_flower,
 	.del_cls_flower = hclge_del_cls_flower,
 	.cls_flower_active = hclge_is_cls_flower_active,
+	.get_phy_link_ksettings = hclge_get_phy_link_ksettings,
+	.set_phy_link_ksettings = hclge_set_phy_link_ksettings,
 };
 
 static struct hnae3_ae_algo ae_algo = {
-- 
2.7.4

