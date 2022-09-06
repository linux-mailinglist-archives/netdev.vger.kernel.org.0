Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6661A5AE3F3
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 11:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239089AbiIFJPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 05:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbiIFJPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 05:15:04 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B63183AD;
        Tue,  6 Sep 2022 02:15:02 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MMKPX6xnXz1P6pc;
        Tue,  6 Sep 2022 17:11:12 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 6 Sep 2022 17:14:59 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 6 Sep 2022 17:14:59 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH V2 net-next 5/5] net: hns3: add support to query and set lane number by ethtool
Date:   Tue, 6 Sep 2022 17:12:23 +0800
Message-ID: <20220906091223.46142-6-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220906091223.46142-1-huangguangbin2@huawei.com>
References: <20220906091223.46142-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao418@huawei.com>

When serdes lane support setting 25Gb/s or 50Gb/s speed and user wants to
set port speed as 50Gb/s, it can be setted as one 50Gb/s serdes lane or
two 25Gb/s serdes lanes.

So, this patch adds support to query and set lane number by ethtool
to satisfy this scenario.

Signed-off-by: Hao Chen <chenhao418@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  9 +++++--
 .../hns3/hns3_common/hclge_comm_cmd.c         |  1 +
 .../hns3/hns3_common/hclge_comm_cmd.h         |  1 +
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  3 +++
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 19 +++++++++-----
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  7 +++--
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 26 ++++++++++++-------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  3 ++-
 .../hisilicon/hns3/hns3pf/hclge_mdio.c        |  2 +-
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  2 +-
 10 files changed, 50 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 74f7395a36a6..9fb4cc303301 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -98,6 +98,7 @@ enum HNAE3_DEV_CAP_BITS {
 	HNAE3_DEV_SUPPORT_MC_MAC_MNG_B,
 	HNAE3_DEV_SUPPORT_CQ_B,
 	HNAE3_DEV_SUPPORT_FEC_STATS_B,
+	HNAE3_DEV_SUPPORT_LANE_NUM_B,
 };
 
 #define hnae3_ae_dev_fd_supported(ae_dev) \
@@ -163,6 +164,9 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_fec_stats_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_FEC_STATS_B, (ae_dev)->caps)
 
+#define hnae3_ae_dev_lane_num_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_LANE_NUM_B, (ae_dev)->caps)
+
 enum HNAE3_PF_CAP_BITS {
 	HNAE3_PF_SUPPORT_VLAN_FLTR_MDF_B = 0,
 };
@@ -572,10 +576,11 @@ struct hnae3_ae_ops {
 	void (*client_stop)(struct hnae3_handle *handle);
 	int (*get_status)(struct hnae3_handle *handle);
 	void (*get_ksettings_an_result)(struct hnae3_handle *handle,
-					u8 *auto_neg, u32 *speed, u8 *duplex);
+					u8 *auto_neg, u32 *speed, u8 *duplex,
+					u32 *lane_num);
 
 	int (*cfg_mac_speed_dup_h)(struct hnae3_handle *handle, int speed,
-				   u8 duplex);
+				   u8 duplex, u8 lane_num);
 
 	void (*get_media_type)(struct hnae3_handle *handle, u8 *media_type,
 			       u8 *module_type);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index ca4efdd6e018..f671a63cecde 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -154,6 +154,7 @@ static const struct hclge_comm_caps_bit_map hclge_pf_cmd_caps[] = {
 	{HCLGE_COMM_CAP_GRO_B, HNAE3_DEV_SUPPORT_GRO_B},
 	{HCLGE_COMM_CAP_FD_B, HNAE3_DEV_SUPPORT_FD_B},
 	{HCLGE_COMM_CAP_FEC_STATS_B, HNAE3_DEV_SUPPORT_FEC_STATS_B},
+	{HCLGE_COMM_CAP_LANE_NUM_B, HNAE3_DEV_SUPPORT_LANE_NUM_B},
 };
 
 static const struct hclge_comm_caps_bit_map hclge_vf_cmd_caps[] = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index 5b66c7d8246d..b1f9383b418f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -344,6 +344,7 @@ enum HCLGE_COMM_CAP_BITS {
 	HCLGE_COMM_CAP_GRO_B = 20,
 	HCLGE_COMM_CAP_FD_B = 21,
 	HCLGE_COMM_CAP_FEC_STATS_B = 25,
+	HCLGE_COMM_CAP_LANE_NUM_B = 27,
 };
 
 enum HCLGE_COMM_API_CAP_BITS {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index a3d47724742b..66feb23f7b7b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -405,6 +405,9 @@ static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
 	}, {
 		.name = "support FEC statistics",
 		.cap_bit = HNAE3_DEV_SUPPORT_FEC_STATS_B,
+	}, {
+		.name = "support lane num",
+		.cap_bit = HNAE3_DEV_SUPPORT_LANE_NUM_B,
 	}
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 31d181118be1..45cd19ef3c5b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -712,7 +712,8 @@ static void hns3_get_ksettings(struct hnae3_handle *h,
 		ops->get_ksettings_an_result(h,
 					     &cmd->base.autoneg,
 					     &cmd->base.speed,
-					     &cmd->base.duplex);
+					     &cmd->base.duplex,
+					     &cmd->lanes);
 
 	/* 2.get link mode */
 	if (ops->get_link_mode)
@@ -794,6 +795,7 @@ static int hns3_check_ksettings_param(const struct net_device *netdev,
 	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
 	u8 module_type = HNAE3_MODULE_TYPE_UNKNOWN;
 	u8 media_type = HNAE3_MEDIA_TYPE_UNKNOWN;
+	u32 lane_num;
 	u8 autoneg;
 	u32 speed;
 	u8 duplex;
@@ -806,9 +808,9 @@ static int hns3_check_ksettings_param(const struct net_device *netdev,
 		return 0;
 
 	if (ops->get_ksettings_an_result) {
-		ops->get_ksettings_an_result(handle, &autoneg, &speed, &duplex);
+		ops->get_ksettings_an_result(handle, &autoneg, &speed, &duplex, &lane_num);
 		if (cmd->base.autoneg == autoneg && cmd->base.speed == speed &&
-		    cmd->base.duplex == duplex)
+		    cmd->base.duplex == duplex && cmd->lanes == lane_num)
 			return 0;
 	}
 
@@ -845,10 +847,14 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 	if (cmd->base.speed == SPEED_1000 && cmd->base.duplex == DUPLEX_HALF)
 		return -EINVAL;
 
+	if (cmd->lanes && !hnae3_ae_dev_lane_num_supported(ae_dev))
+		return -EOPNOTSUPP;
+
 	netif_dbg(handle, drv, netdev,
-		  "set link(%s): autoneg=%u, speed=%u, duplex=%u\n",
+		  "set link(%s): autoneg=%u, speed=%u, duplex=%u, lanes=%u\n",
 		  netdev->phydev ? "phy" : "mac",
-		  cmd->base.autoneg, cmd->base.speed, cmd->base.duplex);
+		  cmd->base.autoneg, cmd->base.speed, cmd->base.duplex,
+		  cmd->lanes);
 
 	/* Only support ksettings_set for netdev with phy attached for now */
 	if (netdev->phydev) {
@@ -886,7 +892,7 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 
 	if (ops->cfg_mac_speed_dup_h)
 		ret = ops->cfg_mac_speed_dup_h(handle, cmd->base.speed,
-					       cmd->base.duplex);
+					       cmd->base.duplex, (u8)(cmd->lanes));
 
 	return ret;
 }
@@ -2067,6 +2073,7 @@ static const struct ethtool_ops hns3vf_ethtool_ops = {
 static const struct ethtool_ops hns3_ethtool_ops = {
 	.supported_coalesce_params = HNS3_ETHTOOL_COALESCE,
 	.supported_ring_params = HNS3_ETHTOOL_RING,
+	.cap_link_lanes_supported = true,
 	.self_test = hns3_self_test,
 	.get_drvinfo = hns3_get_drvinfo,
 	.get_link = hns3_get_link,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 7461b7ecf716..43cada51d8cb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -321,7 +321,9 @@ struct hclge_config_mac_speed_dup_cmd {
 
 #define HCLGE_CFG_MAC_SPEED_CHANGE_EN_B	0
 	u8 mac_change_fec_en;
-	u8 rsv[22];
+	u8 rsv[4];
+	u8 lane_num;
+	u8 rsv1[17];
 };
 
 #define HCLGE_TQP_ENABLE_B		0
@@ -348,7 +350,8 @@ struct hclge_sfp_info_cmd {
 	__le32 speed_ability; /* speed ability for current media */
 	__le32 module_type;
 	u8 fec_ability;
-	u8 rsv[7];
+	u8 lane_num;
+	u8 rsv[6];
 };
 
 #define HCLGE_MAC_CFG_FEC_AUTO_EN_B	0
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a0136e234a08..c760fed50da2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2615,7 +2615,7 @@ static int hclge_convert_to_fw_speed(u32 speed_drv, u32 *speed_fw)
 }
 
 static int hclge_cfg_mac_speed_dup_hw(struct hclge_dev *hdev, int speed,
-				      u8 duplex)
+				      u8 duplex, u8 lane_num)
 {
 	struct hclge_config_mac_speed_dup_cmd *req;
 	struct hclge_desc desc;
@@ -2639,6 +2639,7 @@ static int hclge_cfg_mac_speed_dup_hw(struct hclge_dev *hdev, int speed,
 			speed_fw);
 	hnae3_set_bit(req->mac_change_fec_en, HCLGE_CFG_MAC_SPEED_CHANGE_EN_B,
 		      1);
+	req->lane_num = lane_num;
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
@@ -2650,33 +2651,35 @@ static int hclge_cfg_mac_speed_dup_hw(struct hclge_dev *hdev, int speed,
 	return 0;
 }
 
-int hclge_cfg_mac_speed_dup(struct hclge_dev *hdev, int speed, u8 duplex)
+int hclge_cfg_mac_speed_dup(struct hclge_dev *hdev, int speed, u8 duplex, u8 lane_num)
 {
 	struct hclge_mac *mac = &hdev->hw.mac;
 	int ret;
 
 	duplex = hclge_check_speed_dup(duplex, speed);
 	if (!mac->support_autoneg && mac->speed == speed &&
-	    mac->duplex == duplex)
+	    mac->duplex == duplex && (mac->lane_num == lane_num || lane_num == 0))
 		return 0;
 
-	ret = hclge_cfg_mac_speed_dup_hw(hdev, speed, duplex);
+	ret = hclge_cfg_mac_speed_dup_hw(hdev, speed, duplex, lane_num);
 	if (ret)
 		return ret;
 
 	hdev->hw.mac.speed = speed;
 	hdev->hw.mac.duplex = duplex;
+	if (!lane_num)
+		hdev->hw.mac.lane_num = lane_num;
 
 	return 0;
 }
 
 static int hclge_cfg_mac_speed_dup_h(struct hnae3_handle *handle, int speed,
-				     u8 duplex)
+				     u8 duplex, u8 lane_num)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	return hclge_cfg_mac_speed_dup(hdev, speed, duplex);
+	return hclge_cfg_mac_speed_dup(hdev, speed, duplex, lane_num);
 }
 
 static int hclge_set_autoneg_en(struct hclge_dev *hdev, bool enable)
@@ -2976,7 +2979,7 @@ static int hclge_mac_init(struct hclge_dev *hdev)
 	hdev->support_sfp_query = true;
 	hdev->hw.mac.duplex = HCLGE_MAC_FULL;
 	ret = hclge_cfg_mac_speed_dup_hw(hdev, hdev->hw.mac.speed,
-					 hdev->hw.mac.duplex);
+					 hdev->hw.mac.duplex, hdev->hw.mac.lane_num);
 	if (ret)
 		return ret;
 
@@ -3301,6 +3304,7 @@ static int hclge_get_sfp_info(struct hclge_dev *hdev, struct hclge_mac *mac)
 		mac->autoneg = resp->autoneg;
 		mac->support_autoneg = resp->autoneg_ability;
 		mac->speed_type = QUERY_ACTIVE_SPEED;
+		mac->lane_num = resp->lane_num;
 		if (!resp->active_fec)
 			mac->fec_mode = 0;
 		else
@@ -3485,13 +3489,13 @@ static int hclge_update_port_info(struct hclge_dev *hdev)
 			return 0;
 		}
 		return hclge_cfg_mac_speed_dup(hdev, mac->speed,
-					       HCLGE_MAC_FULL);
+					       HCLGE_MAC_FULL, mac->lane_num);
 	} else {
 		if (speed == HCLGE_MAC_SPEED_UNKNOWN)
 			return 0; /* do nothing if no SFP */
 
 		/* must config full duplex for SFP */
-		return hclge_cfg_mac_speed_dup(hdev, speed, HCLGE_MAC_FULL);
+		return hclge_cfg_mac_speed_dup(hdev, speed, HCLGE_MAC_FULL, 0);
 	}
 }
 
@@ -10985,7 +10989,7 @@ static int hclge_set_pauseparam(struct hnae3_handle *handle, u32 auto_neg,
 }
 
 static void hclge_get_ksettings_an_result(struct hnae3_handle *handle,
-					  u8 *auto_neg, u32 *speed, u8 *duplex)
+					  u8 *auto_neg, u32 *speed, u8 *duplex, u32 *lane_num)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
@@ -10996,6 +11000,8 @@ static void hclge_get_ksettings_an_result(struct hnae3_handle *handle,
 		*duplex = hdev->hw.mac.duplex;
 	if (auto_neg)
 		*auto_neg = hdev->hw.mac.autoneg;
+	if (lane_num)
+		*lane_num = hdev->hw.mac.lane_num;
 }
 
 static void hclge_get_media_type(struct hnae3_handle *handle, u8 *media_type,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index ef0f67ed60c9..163240adbcce 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -259,6 +259,7 @@ struct hclge_mac {
 	u8 duplex;
 	u8 support_autoneg;
 	u8 speed_type;	/* 0: sfp speed, 1: active speed */
+	u8 lane_num;
 	u32 speed;
 	u32 max_speed;
 	u32 speed_ability; /* speed ability supported by current media */
@@ -1096,7 +1097,7 @@ static inline int hclge_get_queue_id(struct hnae3_queue *queue)
 }
 
 int hclge_inform_reset_assert_to_vf(struct hclge_vport *vport);
-int hclge_cfg_mac_speed_dup(struct hclge_dev *hdev, int speed, u8 duplex);
+int hclge_cfg_mac_speed_dup(struct hclge_dev *hdev, int speed, u8 duplex, u8 lane_num);
 int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 			  u16 vlan_id, bool is_kill);
 int hclge_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index 03d63b6a9b2b..85fb11de43a1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -187,7 +187,7 @@ static void hclge_mac_adjust_link(struct net_device *netdev)
 	speed = netdev->phydev->speed;
 	duplex = netdev->phydev->duplex;
 
-	ret = hclge_cfg_mac_speed_dup(hdev, speed, duplex);
+	ret = hclge_cfg_mac_speed_dup(hdev, speed, duplex, 0);
 	if (ret)
 		netdev_err(netdev, "failed to adjust link.\n");
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 14e338fbf1eb..34ac33783e97 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3177,7 +3177,7 @@ static int hclgevf_get_status(struct hnae3_handle *handle)
 
 static void hclgevf_get_ksettings_an_result(struct hnae3_handle *handle,
 					    u8 *auto_neg, u32 *speed,
-					    u8 *duplex)
+					    u8 *duplex, u32 *lane_num)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 
-- 
2.33.0

