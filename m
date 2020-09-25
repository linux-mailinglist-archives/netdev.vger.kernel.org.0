Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756DA277CE1
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgIYA3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:29:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14232 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726694AbgIYA3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:29:06 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D58DD4C9783D967ED50D;
        Fri, 25 Sep 2020 08:29:03 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Fri, 25 Sep 2020 08:28:53 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/6] net: hns3: add support for 200G device
Date:   Fri, 25 Sep 2020 08:26:17 +0800
Message-ID: <1600993578-41008-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600993578-41008-1-git-send-email-tanhuazhong@huawei.com>
References: <1600993578-41008-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

The 200G device has a new device id 0xA228, so adds this device id to
pci table, then the driver can probe it.

As speed_ability queried from firmware has only 8 bits and already be
used up, so firmware adds extra speed_ability_ext to indicate more
speed abilities to support 200G and driver needs to parse it.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  3 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 54 ++++++++++++++++++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  6 ++-
 5 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 55843ad..56c8969 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -42,6 +42,7 @@
 #define HNAE3_DEV_ID_50GE_RDMA			0xA224
 #define HNAE3_DEV_ID_50GE_RDMA_MACSEC		0xA225
 #define HNAE3_DEV_ID_100G_RDMA_MACSEC		0xA226
+#define HNAE3_DEV_ID_200G_RDMA			0xA228
 #define HNAE3_DEV_ID_100G_VF			0xA22E
 #define HNAE3_DEV_ID_100G_RDMA_DCB_PFC_VF	0xA22F
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index e886700..5126ad8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -81,6 +81,8 @@ static const struct pci_device_id hns3_pci_tbl[] = {
 	 HNAE3_DEV_SUPPORT_ROCE_DCB_BITS},
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_100G_RDMA_MACSEC),
 	 HNAE3_DEV_SUPPORT_ROCE_DCB_BITS},
+	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_200G_RDMA),
+	 HNAE3_DEV_SUPPORT_ROCE_DCB_BITS},
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_100G_VF), 0},
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_100G_RDMA_DCB_PFC_VF),
 	 HNAE3_DEV_SUPPORT_ROCE_DCB_BITS},
@@ -2044,6 +2046,7 @@ bool hns3_is_phys_func(struct pci_dev *pdev)
 	case HNAE3_DEV_ID_50GE_RDMA:
 	case HNAE3_DEV_ID_50GE_RDMA_MACSEC:
 	case HNAE3_DEV_ID_100G_RDMA_MACSEC:
+	case HNAE3_DEV_ID_200G_RDMA:
 		return true;
 	case HNAE3_DEV_ID_100G_VF:
 	case HNAE3_DEV_ID_100G_RDMA_DCB_PFC_VF:
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 463f291..30983f0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -491,6 +491,8 @@ struct hclge_pf_res_cmd {
 #define HCLGE_CFG_RSS_SIZE_M	GENMASK(31, 24)
 #define HCLGE_CFG_SPEED_ABILITY_S	0
 #define HCLGE_CFG_SPEED_ABILITY_M	GENMASK(7, 0)
+#define HCLGE_CFG_SPEED_ABILITY_EXT_S	10
+#define HCLGE_CFG_SPEED_ABILITY_EXT_M	GENMASK(15, 10)
 #define HCLGE_CFG_UMV_TBL_SPACE_S	16
 #define HCLGE_CFG_UMV_TBL_SPACE_M	GENMASK(31, 16)
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 279e627..9bdad64 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -84,6 +84,7 @@ static const struct pci_device_id ae_algo_pci_tbl[] = {
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_50GE_RDMA), 0},
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_50GE_RDMA_MACSEC), 0},
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_100G_RDMA_MACSEC), 0},
+	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_200G_RDMA), 0},
 	/* required last entry */
 	{0, }
 };
@@ -965,6 +966,9 @@ static int hclge_parse_speed(int speed_cmd, int *speed)
 	case 5:
 		*speed = HCLGE_MAC_SPEED_100G;
 		break;
+	case 8:
+		*speed = HCLGE_MAC_SPEED_200G;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1004,6 +1008,9 @@ static int hclge_check_port_speed(struct hnae3_handle *handle, u32 speed)
 	case HCLGE_MAC_SPEED_100G:
 		speed_bit = HCLGE_SUPPORT_100G_BIT;
 		break;
+	case HCLGE_MAC_SPEED_200G:
+		speed_bit = HCLGE_SUPPORT_200G_BIT;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1014,7 +1021,7 @@ static int hclge_check_port_speed(struct hnae3_handle *handle, u32 speed)
 	return -EINVAL;
 }
 
-static void hclge_convert_setting_sr(struct hclge_mac *mac, u8 speed_ability)
+static void hclge_convert_setting_sr(struct hclge_mac *mac, u16 speed_ability)
 {
 	if (speed_ability & HCLGE_SUPPORT_10G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
@@ -1031,9 +1038,12 @@ static void hclge_convert_setting_sr(struct hclge_mac *mac, u8 speed_ability)
 	if (speed_ability & HCLGE_SUPPORT_100G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
 				 mac->supported);
+	if (speed_ability & HCLGE_SUPPORT_200G_BIT)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_200000baseSR4_Full_BIT,
+				 mac->supported);
 }
 
-static void hclge_convert_setting_lr(struct hclge_mac *mac, u8 speed_ability)
+static void hclge_convert_setting_lr(struct hclge_mac *mac, u16 speed_ability)
 {
 	if (speed_ability & HCLGE_SUPPORT_10G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
@@ -1050,9 +1060,13 @@ static void hclge_convert_setting_lr(struct hclge_mac *mac, u8 speed_ability)
 	if (speed_ability & HCLGE_SUPPORT_100G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT,
 				 mac->supported);
+	if (speed_ability & HCLGE_SUPPORT_200G_BIT)
+		linkmode_set_bit(
+			ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT,
+			mac->supported);
 }
 
-static void hclge_convert_setting_cr(struct hclge_mac *mac, u8 speed_ability)
+static void hclge_convert_setting_cr(struct hclge_mac *mac, u16 speed_ability)
 {
 	if (speed_ability & HCLGE_SUPPORT_10G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseCR_Full_BIT,
@@ -1069,9 +1083,12 @@ static void hclge_convert_setting_cr(struct hclge_mac *mac, u8 speed_ability)
 	if (speed_ability & HCLGE_SUPPORT_100G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
 				 mac->supported);
+	if (speed_ability & HCLGE_SUPPORT_200G_BIT)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT,
+				 mac->supported);
 }
 
-static void hclge_convert_setting_kr(struct hclge_mac *mac, u8 speed_ability)
+static void hclge_convert_setting_kr(struct hclge_mac *mac, u16 speed_ability)
 {
 	if (speed_ability & HCLGE_SUPPORT_1G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
@@ -1091,6 +1108,9 @@ static void hclge_convert_setting_kr(struct hclge_mac *mac, u8 speed_ability)
 	if (speed_ability & HCLGE_SUPPORT_100G_BIT)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
 				 mac->supported);
+	if (speed_ability & HCLGE_SUPPORT_200G_BIT)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_200000baseKR4_Full_BIT,
+				 mac->supported);
 }
 
 static void hclge_convert_setting_fec(struct hclge_mac *mac)
@@ -1115,6 +1135,7 @@ static void hclge_convert_setting_fec(struct hclge_mac *mac)
 			BIT(HNAE3_FEC_AUTO);
 		break;
 	case HCLGE_MAC_SPEED_100G:
+	case HCLGE_MAC_SPEED_200G:
 		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT, mac->supported);
 		mac->fec_ability = BIT(HNAE3_FEC_RS) | BIT(HNAE3_FEC_AUTO);
 		break;
@@ -1125,7 +1146,7 @@ static void hclge_convert_setting_fec(struct hclge_mac *mac)
 }
 
 static void hclge_parse_fiber_link_mode(struct hclge_dev *hdev,
-					u8 speed_ability)
+					u16 speed_ability)
 {
 	struct hclge_mac *mac = &hdev->hw.mac;
 
@@ -1145,7 +1166,7 @@ static void hclge_parse_fiber_link_mode(struct hclge_dev *hdev,
 }
 
 static void hclge_parse_backplane_link_mode(struct hclge_dev *hdev,
-					    u8 speed_ability)
+					    u16 speed_ability)
 {
 	struct hclge_mac *mac = &hdev->hw.mac;
 
@@ -1158,7 +1179,7 @@ static void hclge_parse_backplane_link_mode(struct hclge_dev *hdev,
 }
 
 static void hclge_parse_copper_link_mode(struct hclge_dev *hdev,
-					 u8 speed_ability)
+					 u16 speed_ability)
 {
 	unsigned long *supported = hdev->hw.mac.supported;
 
@@ -1188,7 +1209,7 @@ static void hclge_parse_copper_link_mode(struct hclge_dev *hdev,
 	linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, supported);
 }
 
-static void hclge_parse_link_mode(struct hclge_dev *hdev, u8 speed_ability)
+static void hclge_parse_link_mode(struct hclge_dev *hdev, u16 speed_ability)
 {
 	u8 media_type = hdev->hw.mac.media_type;
 
@@ -1200,8 +1221,11 @@ static void hclge_parse_link_mode(struct hclge_dev *hdev, u8 speed_ability)
 		hclge_parse_backplane_link_mode(hdev, speed_ability);
 }
 
-static u32 hclge_get_max_speed(u8 speed_ability)
+static u32 hclge_get_max_speed(u16 speed_ability)
 {
+	if (speed_ability & HCLGE_SUPPORT_200G_BIT)
+		return HCLGE_MAC_SPEED_200G;
+
 	if (speed_ability & HCLGE_SUPPORT_100G_BIT)
 		return HCLGE_MAC_SPEED_100G;
 
@@ -1231,8 +1255,11 @@ static u32 hclge_get_max_speed(u8 speed_ability)
 
 static void hclge_parse_cfg(struct hclge_cfg *cfg, struct hclge_desc *desc)
 {
+#define SPEED_ABILITY_EXT_SHIFT			8
+
 	struct hclge_cfg_param_cmd *req;
 	u64 mac_addr_tmp_high;
+	u16 speed_ability_ext;
 	u64 mac_addr_tmp;
 	unsigned int i;
 
@@ -1281,6 +1308,11 @@ static void hclge_parse_cfg(struct hclge_cfg *cfg, struct hclge_desc *desc)
 	cfg->speed_ability = hnae3_get_field(__le32_to_cpu(req->param[1]),
 					     HCLGE_CFG_SPEED_ABILITY_M,
 					     HCLGE_CFG_SPEED_ABILITY_S);
+	speed_ability_ext = hnae3_get_field(__le32_to_cpu(req->param[1]),
+					    HCLGE_CFG_SPEED_ABILITY_EXT_M,
+					    HCLGE_CFG_SPEED_ABILITY_EXT_S);
+	cfg->speed_ability |= speed_ability_ext << SPEED_ABILITY_EXT_SHIFT;
+
 	cfg->umv_space = hnae3_get_field(__le32_to_cpu(req->param[1]),
 					 HCLGE_CFG_UMV_TBL_SPACE_M,
 					 HCLGE_CFG_UMV_TBL_SPACE_S);
@@ -2422,6 +2454,10 @@ static int hclge_cfg_mac_speed_dup_hw(struct hclge_dev *hdev, int speed,
 		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
 				HCLGE_CFG_SPEED_S, 5);
 		break;
+	case HCLGE_MAC_SPEED_200G:
+		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
+				HCLGE_CFG_SPEED_S, 8);
+		break;
 	default:
 		dev_err(&hdev->pdev->dev, "invalid speed (%d)\n", speed);
 		return -EINVAL;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 3975332..64e6afd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -199,6 +199,7 @@ enum HLCGE_PORT_TYPE {
 #define HCLGE_SUPPORT_40G_BIT		BIT(5)
 #define HCLGE_SUPPORT_100M_BIT		BIT(6)
 #define HCLGE_SUPPORT_10M_BIT		BIT(7)
+#define HCLGE_SUPPORT_200G_BIT		BIT(8)
 #define HCLGE_SUPPORT_GE \
 	(HCLGE_SUPPORT_1G_BIT | HCLGE_SUPPORT_100M_BIT | HCLGE_SUPPORT_10M_BIT)
 
@@ -238,7 +239,8 @@ enum HCLGE_MAC_SPEED {
 	HCLGE_MAC_SPEED_25G	= 25000,	/* 25000 Mbps  = 25 Gbps */
 	HCLGE_MAC_SPEED_40G	= 40000,	/* 40000 Mbps  = 40 Gbps */
 	HCLGE_MAC_SPEED_50G	= 50000,	/* 50000 Mbps  = 50 Gbps */
-	HCLGE_MAC_SPEED_100G	= 100000	/* 100000 Mbps = 100 Gbps */
+	HCLGE_MAC_SPEED_100G	= 100000,	/* 100000 Mbps = 100 Gbps */
+	HCLGE_MAC_SPEED_200G	= 200000	/* 200000 Mbps = 200 Gbps */
 };
 
 enum HCLGE_MAC_DUPLEX {
@@ -349,7 +351,7 @@ struct hclge_cfg {
 	u8 mac_addr[ETH_ALEN];
 	u8 default_speed;
 	u32 numa_node_map;
-	u8 speed_ability;
+	u16 speed_ability;
 	u16 umv_space;
 };
 
-- 
2.7.4

