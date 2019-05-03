Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9370A12B10
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 11:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfECJvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 05:51:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7717 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725777AbfECJv3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 05:51:29 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 968568EC41FD42738A69;
        Fri,  3 May 2019 17:51:27 +0800 (CST)
Received: from linux-ioko.site (10.71.200.31) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Fri, 3 May 2019 17:51:19 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>
Subject: [PATCH V2 net-next 3/3] net: hns3: add support for FEC encoding control
Date:   Fri, 3 May 2019 17:50:39 +0800
Message-ID: <1556877039-1692-4-git-send-email-lipeng321@huawei.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556877039-1692-1-git-send-email-lipeng321@huawei.com>
References: <1556877039-1692-1-git-send-email-lipeng321@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.71.200.31]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

This patch adds support for FEC encoding control, user can change
FEC mode by command ethtool --set-fec, and get FEC mode by command
ethtool --show-fec. The fec capability is changed follow the port
speed. If autoneg on, the user configure fec mode will be overwritten
by autoneg result.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  10 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  77 +++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  16 ++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 106 +++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   5 +-
 5 files changed, 213 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 7ee40ec..ad21b0e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -132,6 +132,13 @@ enum hnae3_module_type {
 
 };
 
+enum hnae3_fec_mode {
+	HNAE3_FEC_AUTO = 0,
+	HNAE3_FEC_BASER,
+	HNAE3_FEC_RS,
+	HNAE3_FEC_USER_DEF,
+};
+
 enum hnae3_reset_notify_type {
 	HNAE3_UP_CLIENT,
 	HNAE3_DOWN_CLIENT,
@@ -360,6 +367,9 @@ struct hnae3_ae_ops {
 	void (*get_media_type)(struct hnae3_handle *handle, u8 *media_type,
 			       u8 *module_type);
 	int (*check_port_speed)(struct hnae3_handle *handle, u32 speed);
+	void (*get_fec)(struct hnae3_handle *handle, u8 *fec_ability,
+			u8 *fec_mode);
+	int (*set_fec)(struct hnae3_handle *handle, u32 fec_mode);
 	void (*adjust_link)(struct hnae3_handle *handle, int speed, int duplex);
 	int (*set_loopback)(struct hnae3_handle *handle,
 			    enum hnae3_loop loop_mode, bool en);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 23ded8a..1746943 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1211,6 +1211,81 @@ static void hns3_set_msglevel(struct net_device *netdev, u32 msg_level)
 	h->msg_enable = msg_level;
 }
 
+/* Translate local fec value into ethtool value. */
+static unsigned int loc_to_eth_fec(u8 loc_fec)
+{
+	u32 eth_fec = 0;
+
+	if (loc_fec & BIT(HNAE3_FEC_AUTO))
+		eth_fec |= ETHTOOL_FEC_AUTO;
+	if (loc_fec & BIT(HNAE3_FEC_RS))
+		eth_fec |= ETHTOOL_FEC_RS;
+	if (loc_fec & BIT(HNAE3_FEC_BASER))
+		eth_fec |= ETHTOOL_FEC_BASER;
+
+	/* if nothing is set, then FEC is off */
+	if (!eth_fec)
+		eth_fec = ETHTOOL_FEC_OFF;
+
+	return eth_fec;
+}
+
+/* Translate ethtool fec value into local value. */
+static unsigned int eth_to_loc_fec(unsigned int eth_fec)
+{
+	u32 loc_fec = 0;
+
+	if (eth_fec & ETHTOOL_FEC_OFF)
+		return loc_fec;
+
+	if (eth_fec & ETHTOOL_FEC_AUTO)
+		loc_fec |= BIT(HNAE3_FEC_AUTO);
+	if (eth_fec & ETHTOOL_FEC_RS)
+		loc_fec |= BIT(HNAE3_FEC_RS);
+	if (eth_fec & ETHTOOL_FEC_BASER)
+		loc_fec |= BIT(HNAE3_FEC_BASER);
+
+	return loc_fec;
+}
+
+static int hns3_get_fecparam(struct net_device *netdev,
+			     struct ethtool_fecparam *fec)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	u8 fec_ability;
+	u8 fec_mode;
+
+	if (handle->pdev->revision == 0x20)
+		return -EOPNOTSUPP;
+
+	if (!ops->get_fec)
+		return -EOPNOTSUPP;
+
+	ops->get_fec(handle, &fec_ability, &fec_mode);
+
+	fec->fec = loc_to_eth_fec(fec_ability);
+	fec->active_fec = loc_to_eth_fec(fec_mode);
+
+	return 0;
+}
+
+static int hns3_set_fecparam(struct net_device *netdev,
+			     struct ethtool_fecparam *fec)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	u32 fec_mode;
+
+	if (handle->pdev->revision == 0x20)
+		return -EOPNOTSUPP;
+
+	if (!ops->set_fec)
+		return -EOPNOTSUPP;
+	fec_mode = eth_to_loc_fec(fec->fec);
+	return ops->set_fec(handle, fec_mode);
+}
+
 static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.get_drvinfo = hns3_get_drvinfo,
 	.get_ringparam = hns3_get_ringparam,
@@ -1264,6 +1339,8 @@ static void hns3_set_msglevel(struct net_device *netdev, u32 msg_level)
 	.set_phys_id = hns3_set_phys_id,
 	.get_msglevel = hns3_get_msglevel,
 	.set_msglevel = hns3_set_msglevel,
+	.get_fecparam = hns3_get_fecparam,
+	.set_fecparam = hns3_set_fecparam,
 };
 
 void hns3_ethtool_set_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 653ef6ad..d79a209 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -113,6 +113,7 @@ enum hclge_opcode_type {
 	HCLGE_OPC_MAC_TNL_INT_EN	= 0x0311,
 	HCLGE_OPC_CLEAR_MAC_TNL_INT	= 0x0312,
 	HCLGE_OPC_SERDES_LOOPBACK       = 0x0315,
+	HCLGE_OPC_CONFIG_FEC_MODE	= 0x031A,
 
 	/* PFC/Pause commands */
 	HCLGE_OPC_CFG_MAC_PAUSE_EN      = 0x0701,
@@ -610,6 +611,21 @@ struct hclge_sfp_info_cmd {
 	u8 rsv[8];
 };
 
+#define HCLGE_MAC_CFG_FEC_AUTO_EN_B	0
+#define HCLGE_MAC_CFG_FEC_MODE_S	1
+#define HCLGE_MAC_CFG_FEC_MODE_M	GENMASK(3, 1)
+#define HCLGE_MAC_CFG_FEC_SET_DEF_B	0
+#define HCLGE_MAC_CFG_FEC_CLR_DEF_B	1
+
+#define HCLGE_MAC_FEC_OFF		0
+#define HCLGE_MAC_FEC_BASER		1
+#define HCLGE_MAC_FEC_RS		2
+struct hclge_config_fec_cmd {
+	u8 fec_mode;
+	u8 default_config;
+	u8 rsv[22];
+};
+
 #define HCLGE_MAC_UPLINK_PORT		0x100
 
 struct hclge_config_max_frm_size_cmd {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 87615c9..d3b1f8c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -966,6 +966,37 @@ static void hclge_convert_setting_kr(struct hclge_mac *mac, u8 speed_ability)
 				 mac->supported);
 }
 
+static void hclge_convert_setting_fec(struct hclge_mac *mac)
+{
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT, mac->supported);
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT, mac->supported);
+
+	switch (mac->speed) {
+	case HCLGE_MAC_SPEED_10G:
+	case HCLGE_MAC_SPEED_40G:
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT,
+				 mac->supported);
+		mac->fec_ability =
+			BIT(HNAE3_FEC_BASER) | BIT(HNAE3_FEC_AUTO);
+		break;
+	case HCLGE_MAC_SPEED_25G:
+	case HCLGE_MAC_SPEED_50G:
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT,
+				 mac->supported);
+		mac->fec_ability =
+			BIT(HNAE3_FEC_BASER) | BIT(HNAE3_FEC_RS) |
+			BIT(HNAE3_FEC_AUTO);
+		break;
+	case HCLGE_MAC_SPEED_100G:
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT, mac->supported);
+		mac->fec_ability = BIT(HNAE3_FEC_RS) | BIT(HNAE3_FEC_AUTO);
+		break;
+	default:
+		mac->fec_ability = 0;
+		break;
+	}
+}
+
 static void hclge_parse_fiber_link_mode(struct hclge_dev *hdev,
 					u8 speed_ability)
 {
@@ -978,9 +1009,12 @@ static void hclge_parse_fiber_link_mode(struct hclge_dev *hdev,
 	hclge_convert_setting_sr(mac, speed_ability);
 	hclge_convert_setting_lr(mac, speed_ability);
 	hclge_convert_setting_cr(mac, speed_ability);
+	if (hdev->pdev->revision >= 0x21)
+		hclge_convert_setting_fec(mac);
 
 	linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, mac->supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, mac->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_NONE_BIT, mac->supported);
 }
 
 static void hclge_parse_backplane_link_mode(struct hclge_dev *hdev,
@@ -989,8 +1023,11 @@ static void hclge_parse_backplane_link_mode(struct hclge_dev *hdev,
 	struct hclge_mac *mac = &hdev->hw.mac;
 
 	hclge_convert_setting_kr(mac, speed_ability);
+	if (hdev->pdev->revision >= 0x21)
+		hclge_convert_setting_fec(mac);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_Backplane_BIT, mac->supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, mac->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_NONE_BIT, mac->supported);
 }
 
 static void hclge_parse_copper_link_mode(struct hclge_dev *hdev,
@@ -2279,6 +2316,64 @@ static int hclge_restart_autoneg(struct hnae3_handle *handle)
 	return hclge_notify_client(hdev, HNAE3_UP_CLIENT);
 }
 
+static int hclge_set_fec_hw(struct hclge_dev *hdev, u32 fec_mode)
+{
+	struct hclge_config_fec_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CONFIG_FEC_MODE, false);
+
+	req = (struct hclge_config_fec_cmd *)desc.data;
+	if (fec_mode & BIT(HNAE3_FEC_AUTO))
+		hnae3_set_bit(req->fec_mode, HCLGE_MAC_CFG_FEC_AUTO_EN_B, 1);
+	if (fec_mode & BIT(HNAE3_FEC_RS))
+		hnae3_set_field(req->fec_mode, HCLGE_MAC_CFG_FEC_MODE_M,
+				HCLGE_MAC_CFG_FEC_MODE_S, HCLGE_MAC_FEC_RS);
+	if (fec_mode & BIT(HNAE3_FEC_BASER))
+		hnae3_set_field(req->fec_mode, HCLGE_MAC_CFG_FEC_MODE_M,
+				HCLGE_MAC_CFG_FEC_MODE_S, HCLGE_MAC_FEC_BASER);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev, "set fec mode failed %d.\n", ret);
+
+	return ret;
+}
+
+static int hclge_set_fec(struct hnae3_handle *handle, u32 fec_mode)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_mac *mac = &hdev->hw.mac;
+	int ret;
+
+	if (fec_mode && !(mac->fec_ability & fec_mode)) {
+		dev_err(&hdev->pdev->dev, "unsupported fec mode\n");
+		return -EINVAL;
+	}
+
+	ret = hclge_set_fec_hw(hdev, fec_mode);
+	if (ret)
+		return ret;
+
+	mac->user_fec_mode = fec_mode | BIT(HNAE3_FEC_USER_DEF);
+	return 0;
+}
+
+static void hclge_get_fec(struct hnae3_handle *handle, u8 *fec_ability,
+			  u8 *fec_mode)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_mac *mac = &hdev->hw.mac;
+
+	if (fec_ability)
+		*fec_ability = mac->fec_ability;
+	if (fec_mode)
+		*fec_mode = mac->fec_mode;
+}
+
 static int hclge_mac_init(struct hclge_dev *hdev)
 {
 	struct hclge_mac *mac = &hdev->hw.mac;
@@ -2296,6 +2391,15 @@ static int hclge_mac_init(struct hclge_dev *hdev)
 
 	mac->link = 0;
 
+	if (mac->user_fec_mode & BIT(HNAE3_FEC_USER_DEF)) {
+		ret = hclge_set_fec_hw(hdev, mac->user_fec_mode);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"Fec mode init fail, ret = %d\n", ret);
+			return ret;
+		}
+	}
+
 	ret = hclge_set_mac_mtu(hdev, hdev->mps);
 	if (ret) {
 		dev_err(&hdev->pdev->dev, "set mtu failed ret=%d\n", ret);
@@ -8753,6 +8857,8 @@ static int hclge_gro_en(struct hnae3_handle *handle, bool enable)
 	.cfg_mac_speed_dup_h = hclge_cfg_mac_speed_dup_h,
 	.get_media_type = hclge_get_media_type,
 	.check_port_speed = hclge_check_port_speed,
+	.get_fec = hclge_get_fec,
+	.set_fec = hclge_set_fec,
 	.get_rss_key_size = hclge_get_rss_key_size,
 	.get_rss_indir_size = hclge_get_rss_indir_size,
 	.get_rss = hclge_get_rss,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 197e702..dd06b11 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -253,7 +253,10 @@ struct hclge_mac {
 	u32 speed;
 	u32 speed_ability; /* speed ability supported by current media */
 	u32 module_type; /* sub media type, e.g. kr/cr/sr/lr */
-	int link;	/* store the link status of mac & phy (if phy exit)*/
+	u32 fec_mode; /* active fec mode */
+	u32 user_fec_mode;
+	u32 fec_ability;
+	int link;	/* store the link status of mac & phy (if phy exit) */
 	struct phy_device *phydev;
 	struct mii_bus *mdio_bus;
 	phy_interface_t phy_if;
-- 
1.9.1

