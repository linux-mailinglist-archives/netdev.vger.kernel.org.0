Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449521CDB7D
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbgEKNln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:41:43 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:35122 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726438AbgEKNln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 09:41:43 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C2A16CA4093FAFFD82C1;
        Mon, 11 May 2020 21:41:40 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Mon, 11 May 2020 21:41:33 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <luobin9@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next] hinic: add link_ksettings ethtool_ops support
Date:   Mon, 11 May 2020 05:58:57 +0000
Message-ID: <20200511055857.4966-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add set_link_ksettings implementation and improve the implementation
of get_link_ksettings

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 420 +++++++++++++++++-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  13 +
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  19 +
 .../net/ethernet/huawei/hinic/hinic_hw_if.h   |   2 +-
 .../net/ethernet/huawei/hinic/hinic_port.c    | 129 ++++++
 .../net/ethernet/huawei/hinic/hinic_port.h    | 108 +++++
 6 files changed, 682 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index 966aea949c0b..b426eeced069 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -33,6 +33,99 @@
 #include "hinic_rx.h"
 #include "hinic_dev.h"
 
+#define SET_LINK_STR_MAX_LEN	128
+
+#define GET_SUPPORTED_MODE	0
+#define GET_ADVERTISED_MODE	1
+
+#define ETHTOOL_ADD_SUPPORTED_SPEED_LINK_MODE(ecmd, mode)	\
+		((ecmd)->supported |=	\
+		(1UL << hw_to_ethtool_link_mode_table[mode].link_mode_bit))
+#define ETHTOOL_ADD_ADVERTISED_SPEED_LINK_MODE(ecmd, mode)	\
+		((ecmd)->advertising |=	\
+		(1UL << hw_to_ethtool_link_mode_table[mode].link_mode_bit))
+#define ETHTOOL_ADD_SUPPORTED_LINK_MODE(ecmd, mode)	\
+				((ecmd)->supported |= SUPPORTED_##mode)
+#define ETHTOOL_ADD_ADVERTISED_LINK_MODE(ecmd, mode)	\
+				((ecmd)->advertising |= ADVERTISED_##mode)
+
+struct hw2ethtool_link_mode {
+	enum ethtool_link_mode_bit_indices link_mode_bit;
+	u32 speed;
+	enum hinic_link_mode hw_link_mode;
+};
+
+struct cmd_link_settings {
+	u64	supported;
+	u64	advertising;
+
+	u32	speed;
+	u8	duplex;
+	u8	port;
+	u8	autoneg;
+};
+
+static u32 hw_to_ethtool_speed[LINK_SPEED_LEVELS] = {
+	SPEED_10, SPEED_100,
+	SPEED_1000, SPEED_10000,
+	SPEED_25000, SPEED_40000,
+	SPEED_100000
+};
+
+static struct hw2ethtool_link_mode
+	hw_to_ethtool_link_mode_table[HINIC_LINK_MODE_NUMBERS] = {
+	{
+		.link_mode_bit = ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+		.speed = SPEED_10000,
+		.hw_link_mode = HINIC_10GE_BASE_KR,
+	},
+	{
+		.link_mode_bit = ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+		.speed = SPEED_40000,
+		.hw_link_mode = HINIC_40GE_BASE_KR4,
+	},
+	{
+		.link_mode_bit = ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+		.speed = SPEED_40000,
+		.hw_link_mode = HINIC_40GE_BASE_CR4,
+	},
+	{
+		.link_mode_bit = ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+		.speed = SPEED_100000,
+		.hw_link_mode = HINIC_100GE_BASE_KR4,
+	},
+	{
+		.link_mode_bit = ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+		.speed = SPEED_100000,
+		.hw_link_mode = HINIC_100GE_BASE_CR4,
+	},
+	{
+		.link_mode_bit = ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+		.speed = SPEED_25000,
+		.hw_link_mode = HINIC_25GE_BASE_KR_S,
+	},
+	{
+		.link_mode_bit = ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+		.speed = SPEED_25000,
+		.hw_link_mode = HINIC_25GE_BASE_CR_S,
+	},
+	{
+		.link_mode_bit = ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+		.speed = SPEED_25000,
+		.hw_link_mode = HINIC_25GE_BASE_KR,
+	},
+	{
+		.link_mode_bit = ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+		.speed = SPEED_25000,
+		.hw_link_mode = HINIC_25GE_BASE_CR,
+	},
+	{
+		.link_mode_bit = ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+		.speed = SPEED_1000,
+		.hw_link_mode = HINIC_GE_BASE_KX,
+	},
+};
+
 static void set_link_speed(struct ethtool_link_ksettings *link_ksettings,
 			   enum hinic_speed speed)
 {
@@ -71,18 +164,91 @@ static void set_link_speed(struct ethtool_link_ksettings *link_ksettings,
 	}
 }
 
+static int hinic_get_link_mode_index(enum hinic_link_mode link_mode)
+{
+	int i = 0;
+
+	for (i = 0; i < HINIC_LINK_MODE_NUMBERS; i++) {
+		if (link_mode == hw_to_ethtool_link_mode_table[i].hw_link_mode)
+			break;
+	}
+
+	return i;
+}
+
+static void hinic_add_ethtool_link_mode(struct cmd_link_settings *link_settings,
+					enum hinic_link_mode hw_link_mode,
+					u32 name)
+{
+	enum hinic_link_mode link_mode;
+	int idx = 0;
+
+	for (link_mode = 0; link_mode < HINIC_LINK_MODE_NUMBERS; link_mode++) {
+		if (hw_link_mode & ((u32)1 << link_mode)) {
+			idx = hinic_get_link_mode_index(link_mode);
+			if (idx >= HINIC_LINK_MODE_NUMBERS)
+				continue;
+
+			if (name == GET_SUPPORTED_MODE)
+				ETHTOOL_ADD_SUPPORTED_SPEED_LINK_MODE
+					(link_settings, idx);
+			else
+				ETHTOOL_ADD_ADVERTISED_SPEED_LINK_MODE
+					(link_settings, idx);
+		}
+	}
+}
+
+static void hinic_link_port_type(struct cmd_link_settings *link_settings,
+				 enum hinic_port_type port_type)
+{
+	switch (port_type) {
+	case HINIC_PORT_ELEC:
+	case HINIC_PORT_TP:
+		ETHTOOL_ADD_SUPPORTED_LINK_MODE(link_settings, TP);
+		ETHTOOL_ADD_ADVERTISED_LINK_MODE(link_settings, TP);
+		link_settings->port = PORT_TP;
+		break;
+
+	case HINIC_PORT_AOC:
+	case HINIC_PORT_FIBRE:
+		ETHTOOL_ADD_SUPPORTED_LINK_MODE(link_settings, FIBRE);
+		ETHTOOL_ADD_ADVERTISED_LINK_MODE(link_settings, FIBRE);
+		link_settings->port = PORT_FIBRE;
+		break;
+
+	case HINIC_PORT_COPPER:
+		ETHTOOL_ADD_SUPPORTED_LINK_MODE(link_settings, FIBRE);
+		ETHTOOL_ADD_ADVERTISED_LINK_MODE(link_settings, FIBRE);
+		link_settings->port = PORT_DA;
+		break;
+
+	case HINIC_PORT_BACKPLANE:
+		ETHTOOL_ADD_SUPPORTED_LINK_MODE(link_settings, Backplane);
+		ETHTOOL_ADD_ADVERTISED_LINK_MODE(link_settings, Backplane);
+		link_settings->port = PORT_NONE;
+		break;
+
+	default:
+		link_settings->port = PORT_OTHER;
+		break;
+	}
+}
+
 static int hinic_get_link_ksettings(struct net_device *netdev,
 				    struct ethtool_link_ksettings
 				    *link_ksettings)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	struct hinic_link_mode_cmd link_mode = { 0 };
+	struct hinic_pause_config pause_info = { 0 };
+	struct cmd_link_settings settings = { 0 };
 	enum hinic_port_link_state link_state;
 	struct hinic_port_cap port_cap;
 	int err;
 
+	ethtool_link_ksettings_zero_link_mode(link_ksettings, supported);
 	ethtool_link_ksettings_zero_link_mode(link_ksettings, advertising);
-	ethtool_link_ksettings_add_link_mode(link_ksettings, supported,
-					     Autoneg);
 
 	link_ksettings->base.speed = SPEED_UNKNOWN;
 	link_ksettings->base.autoneg = AUTONEG_DISABLE;
@@ -92,14 +258,19 @@ static int hinic_get_link_ksettings(struct net_device *netdev,
 	if (err)
 		return err;
 
+	hinic_link_port_type(&settings, port_cap.port_type);
+	link_ksettings->base.port = settings.port;
+
 	err = hinic_port_link_state(nic_dev, &link_state);
 	if (err)
 		return err;
 
-	if (link_state != HINIC_LINK_STATE_UP)
-		return err;
-
-	set_link_speed(link_ksettings, port_cap.speed);
+	if (link_state == HINIC_LINK_STATE_UP) {
+		set_link_speed(link_ksettings, port_cap.speed);
+		link_ksettings->base.duplex =
+			(port_cap.duplex == HINIC_DUPLEX_FULL) ?
+			DUPLEX_FULL : DUPLEX_HALF;
+	}
 
 	if (!!(port_cap.autoneg_cap & HINIC_AUTONEG_SUPPORTED))
 		ethtool_link_ksettings_add_link_mode(link_ksettings,
@@ -108,11 +279,243 @@ static int hinic_get_link_ksettings(struct net_device *netdev,
 	if (port_cap.autoneg_state == HINIC_AUTONEG_ACTIVE)
 		link_ksettings->base.autoneg = AUTONEG_ENABLE;
 
-	link_ksettings->base.duplex = (port_cap.duplex == HINIC_DUPLEX_FULL) ?
-					   DUPLEX_FULL : DUPLEX_HALF;
+	err = hinic_get_link_mode(nic_dev->hwdev, &link_mode);
+	if (err || link_mode.supported == HINIC_SUPPORTED_UNKNOWN ||
+	    link_mode.advertised == HINIC_SUPPORTED_UNKNOWN)
+		return -EIO;
+
+	hinic_add_ethtool_link_mode(&settings, link_mode.supported,
+				    GET_SUPPORTED_MODE);
+	hinic_add_ethtool_link_mode(&settings, link_mode.advertised,
+				    GET_ADVERTISED_MODE);
+
+	if (!HINIC_IS_VF(nic_dev->hwdev->hwif)) {
+		err = hinic_get_hw_pause_info(nic_dev->hwdev, &pause_info);
+		if (err)
+			return err;
+		ETHTOOL_ADD_SUPPORTED_LINK_MODE(&settings, Pause);
+		if (pause_info.rx_pause && pause_info.tx_pause) {
+			ETHTOOL_ADD_ADVERTISED_LINK_MODE(&settings, Pause);
+		} else if (pause_info.tx_pause) {
+			ETHTOOL_ADD_ADVERTISED_LINK_MODE(&settings, Asym_Pause);
+		} else if (pause_info.rx_pause) {
+			ETHTOOL_ADD_ADVERTISED_LINK_MODE(&settings, Pause);
+			ETHTOOL_ADD_ADVERTISED_LINK_MODE(&settings, Asym_Pause);
+		}
+	}
+
+	bitmap_copy(link_ksettings->link_modes.supported,
+		    (unsigned long *)&settings.supported,
+		    __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_copy(link_ksettings->link_modes.advertising,
+		    (unsigned long *)&settings.advertising,
+		    __ETHTOOL_LINK_MODE_MASK_NBITS);
+
 	return 0;
 }
 
+static int hinic_ethtool_to_hw_speed_level(u32 speed)
+{
+	int i;
+
+	for (i = 0; i < LINK_SPEED_LEVELS; i++) {
+		if (hw_to_ethtool_speed[i] == speed)
+			break;
+	}
+
+	return i;
+}
+
+static bool hinic_is_support_speed(enum hinic_link_mode supported_link,
+				   u32 speed)
+{
+	enum hinic_link_mode link_mode;
+	int idx;
+
+	for (link_mode = 0; link_mode < HINIC_LINK_MODE_NUMBERS; link_mode++) {
+		if (!(supported_link & ((u32)1 << link_mode)))
+			continue;
+
+		idx = hinic_get_link_mode_index(link_mode);
+		if (idx >= HINIC_LINK_MODE_NUMBERS)
+			continue;
+
+		if (hw_to_ethtool_link_mode_table[idx].speed == speed)
+			return true;
+	}
+
+	return false;
+}
+
+static bool hinic_is_speed_legal(struct hinic_dev *nic_dev, u32 speed)
+{
+	struct hinic_link_mode_cmd link_mode = { 0 };
+	struct net_device *netdev = nic_dev->netdev;
+	enum nic_speed_level speed_level = 0;
+	int err;
+
+	err = hinic_get_link_mode(nic_dev->hwdev, &link_mode);
+	if (err)
+		return false;
+
+	if (link_mode.supported == HINIC_SUPPORTED_UNKNOWN ||
+	    link_mode.advertised == HINIC_SUPPORTED_UNKNOWN)
+		return false;
+
+	speed_level = hinic_ethtool_to_hw_speed_level(speed);
+	if (speed_level >= LINK_SPEED_LEVELS ||
+	    !hinic_is_support_speed(link_mode.supported, speed)) {
+		netif_err(nic_dev, drv, netdev,
+			  "Unsupported speed: %d\n", speed);
+		return false;
+	}
+
+	return true;
+}
+
+static int get_link_settings_type(struct hinic_dev *nic_dev,
+				  u8 autoneg, u32 speed, u32 *set_settings)
+{
+	struct hinic_port_cap port_cap = { 0 };
+	int err;
+
+	err = hinic_port_get_cap(nic_dev, &port_cap);
+	if (err)
+		return err;
+
+	/* always set autonegotiation */
+	if (port_cap.autoneg_cap)
+		*set_settings |= HILINK_LINK_SET_AUTONEG;
+
+	if (autoneg == AUTONEG_ENABLE) {
+		if (!port_cap.autoneg_cap) {
+			netif_err(nic_dev, drv, nic_dev->netdev, "Not support autoneg\n");
+			return -EOPNOTSUPP;
+		}
+	} else if (speed != (u32)SPEED_UNKNOWN) {
+		/* set speed only when autoneg is disabled */
+		if (!hinic_is_speed_legal(nic_dev, speed))
+			return -EINVAL;
+		*set_settings |= HILINK_LINK_SET_SPEED;
+	} else {
+		netif_err(nic_dev, drv, nic_dev->netdev, "Need to set speed when autoneg is off\n");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int set_link_settings_separate_cmd(struct hinic_dev *nic_dev,
+					  u32 set_settings, u8 autoneg,
+					  u32 speed)
+{
+	enum nic_speed_level speed_level = 0;
+	int err = 0;
+
+	if (set_settings & HILINK_LINK_SET_AUTONEG) {
+		err = hinic_set_autoneg(nic_dev->hwdev,
+					(autoneg == AUTONEG_ENABLE));
+		if (err)
+			netif_err(nic_dev, drv, nic_dev->netdev, "%s autoneg failed\n",
+				  (autoneg == AUTONEG_ENABLE) ?
+				  "Enable" : "Disable");
+		else
+			netif_info(nic_dev, drv, nic_dev->netdev, "%s autoneg successfully\n",
+				   (autoneg == AUTONEG_ENABLE) ?
+				   "Enable" : "Disable");
+	}
+
+	if (!err && (set_settings & HILINK_LINK_SET_SPEED)) {
+		speed_level = hinic_ethtool_to_hw_speed_level(speed);
+		err = hinic_set_speed(nic_dev->hwdev, speed_level);
+		if (err)
+			netif_err(nic_dev, drv, nic_dev->netdev, "Set speed %d failed\n",
+				  speed);
+		else
+			netif_info(nic_dev, drv, nic_dev->netdev, "Set speed %d successfully\n",
+				   speed);
+	}
+
+	return err;
+}
+
+static int hinic_set_settings_to_hw(struct hinic_dev *nic_dev,
+				    u32 set_settings, u8 autoneg, u32 speed)
+{
+	struct hinic_link_ksettings_info settings = {0};
+	char set_link_str[SET_LINK_STR_MAX_LEN] = {0};
+	struct net_device *netdev = nic_dev->netdev;
+	enum nic_speed_level speed_level = 0;
+	int err;
+
+	err = snprintf(set_link_str, SET_LINK_STR_MAX_LEN, "%s",
+		       (set_settings & HILINK_LINK_SET_AUTONEG) ?
+		       (autoneg ? "autong enable " : "autong disable ") : "");
+	if (err < 0 || err >= SET_LINK_STR_MAX_LEN) {
+		netif_err(nic_dev, drv, netdev, "Failed to snprintf link state, function return(%d) and dest_len(%d)\n",
+			  err, SET_LINK_STR_MAX_LEN);
+		return -EFAULT;
+	}
+
+	if (set_settings & HILINK_LINK_SET_SPEED) {
+		speed_level = hinic_ethtool_to_hw_speed_level(speed);
+		err = snprintf(set_link_str, SET_LINK_STR_MAX_LEN,
+			       "%sspeed %d ", set_link_str, speed);
+		if (err <= 0 || err >= SET_LINK_STR_MAX_LEN) {
+			netif_err(nic_dev, drv, netdev, "Failed to snprintf link speed, function return(%d) and dest_len(%d)\n",
+				  err, SET_LINK_STR_MAX_LEN);
+			return -EFAULT;
+		}
+	}
+
+	settings.func_id = HINIC_HWIF_FUNC_IDX(nic_dev->hwdev->hwif);
+	settings.valid_bitmap = set_settings;
+	settings.autoneg = autoneg;
+	settings.speed = speed_level;
+
+	err = hinic_set_link_settings(nic_dev->hwdev, &settings);
+	if (err != HINIC_MGMT_CMD_UNSUPPORTED) {
+		if (err)
+			netif_err(nic_dev, drv, netdev, "Set %s failed\n",
+				  set_link_str);
+		else
+			netif_info(nic_dev, drv, netdev, "Set %s successfully\n",
+				   set_link_str);
+
+		return err;
+	}
+
+	return set_link_settings_separate_cmd(nic_dev, set_settings, autoneg,
+					      speed);
+}
+
+static int set_link_settings(struct net_device *netdev, u8 autoneg, u32 speed)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	u32 set_settings = 0;
+	int err;
+
+	err = get_link_settings_type(nic_dev, autoneg, speed, &set_settings);
+	if (err)
+		return err;
+
+	if (set_settings)
+		err = hinic_set_settings_to_hw(nic_dev, set_settings,
+					       autoneg, speed);
+	else
+		netif_info(nic_dev, drv, netdev, "Nothing changed, exit without setting anything\n");
+
+	return err;
+}
+
+static int hinic_set_link_ksettings(struct net_device *netdev, const struct
+				    ethtool_link_ksettings *link_settings)
+{
+	/* only support to set autoneg and speed */
+	return set_link_settings(netdev, link_settings->base.autoneg,
+				 link_settings->base.speed);
+}
+
 static void hinic_get_drvinfo(struct net_device *netdev,
 			      struct ethtool_drvinfo *info)
 {
@@ -741,6 +1144,7 @@ static void hinic_get_strings(struct net_device *netdev,
 
 static const struct ethtool_ops hinic_ethtool_ops = {
 	.get_link_ksettings = hinic_get_link_ksettings,
+	.set_link_ksettings = hinic_set_link_ksettings,
 	.get_drvinfo = hinic_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_ringparam = hinic_get_ringparam,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 1ce8b8d572cf..2879b0445eba 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -219,6 +219,19 @@ int hinic_port_msg_cmd(struct hinic_hwdev *hwdev, enum hinic_port_cmd cmd,
 				 HINIC_MGMT_MSG_SYNC);
 }
 
+int hinic_hilink_msg_cmd(struct hinic_hwdev *hwdev, enum hinic_hilink_cmd cmd,
+			 void *buf_in, u16 in_size, void *buf_out,
+			 u16 *out_size)
+{
+	struct hinic_pfhwdev *pfhwdev;
+
+	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
+
+	return hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_HILINK, cmd,
+				 buf_in, in_size, buf_out, out_size,
+				 HINIC_MGMT_MSG_SYNC);
+}
+
 /**
  * init_fw_ctxt- Init Firmware tables before network mgmt and io operations
  * @hwdev: the NIC HW device
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index c8f62a024a58..ce57914bef72 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -54,6 +54,9 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_SET_RX_MODE      = 12,
 
+	HINIC_PORT_CMD_GET_PAUSE_INFO	= 20,
+	HINIC_PORT_CMD_SET_PAUSE_INFO	= 21,
+
 	HINIC_PORT_CMD_GET_LINK_STATE   = 24,
 
 	HINIC_PORT_CMD_SET_LRO		= 25,
@@ -116,11 +119,23 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_GET_CAP          = 170,
 
+	HINIC_PORT_CMD_GET_LINK_MODE	= 217,
+
+	HINIC_PORT_CMD_SET_SPEED	= 218,
+
+	HINIC_PORT_CMD_SET_AUTONEG	= 219,
+
 	HINIC_PORT_CMD_SET_LRO_TIMER	= 244,
 
 	HINIC_PORT_CMD_SET_VF_MAX_MIN_RATE = 249,
 };
 
+/* cmd of mgmt CPU message for HILINK module */
+enum hinic_hilink_cmd {
+	HINIC_HILINK_CMD_GET_LINK_INFO		= 0x3,
+	HINIC_HILINK_CMD_SET_LINK_SETTINGS	= 0x8,
+};
+
 enum hinic_ucode_cmd {
 	HINIC_UCODE_CMD_MODIFY_QUEUE_CONTEXT    = 0,
 	HINIC_UCODE_CMD_CLEAN_QUEUE_CONTEXT,
@@ -328,6 +343,10 @@ int hinic_port_msg_cmd(struct hinic_hwdev *hwdev, enum hinic_port_cmd cmd,
 		       void *buf_in, u16 in_size, void *buf_out,
 		       u16 *out_size);
 
+int hinic_hilink_msg_cmd(struct hinic_hwdev *hwdev, enum hinic_hilink_cmd cmd,
+			 void *buf_in, u16 in_size, void *buf_out,
+			 u16 *out_size);
+
 int hinic_hwdev_ifup(struct hinic_hwdev *hwdev);
 
 void hinic_hwdev_ifdown(struct hinic_hwdev *hwdev);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
index 5bb6ec4dcb7c..0872e035faa1 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
@@ -192,7 +192,7 @@ enum hinic_mod_type {
 	HINIC_MOD_COMM  = 0,    /* HW communication module */
 	HINIC_MOD_L2NIC = 1,    /* L2NIC module */
 	HINIC_MOD_CFGM  = 7,    /* Configuration module */
-
+	HINIC_MOD_HILINK = 14,  /* Hilink module */
 	HINIC_MOD_MAX   = 15
 };
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 714d8279c591..2edb6127f9fb 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -1072,3 +1072,132 @@ int hinic_get_mgmt_version(struct hinic_dev *nic_dev, u8 *mgmt_ver)
 
 	return 0;
 }
+
+int hinic_get_link_mode(struct hinic_hwdev *hwdev,
+			struct hinic_link_mode_cmd *link_mode)
+{
+	u16 out_size;
+	int err;
+
+	if (!hwdev || !link_mode)
+		return -EINVAL;
+
+	out_size = sizeof(*link_mode);
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_LINK_MODE,
+				 link_mode, sizeof(*link_mode),
+				 link_mode, &out_size);
+	if (err || !out_size || link_mode->status) {
+		dev_err(&hwdev->hwif->pdev->dev,
+			"Failed to get link mode, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, link_mode->status, out_size);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+int hinic_set_autoneg(struct hinic_hwdev *hwdev, bool enable)
+{
+	struct hinic_set_autoneg_cmd autoneg = {0};
+	u16 out_size = sizeof(autoneg);
+	int err;
+
+	if (!hwdev)
+		return -EINVAL;
+
+	autoneg.func_id = HINIC_HWIF_FUNC_IDX(hwdev->hwif);
+	autoneg.enable = enable;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_AUTONEG,
+				 &autoneg, sizeof(autoneg),
+				 &autoneg, &out_size);
+	if (err || !out_size || autoneg.status) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to %s autoneg, err: %d, status: 0x%x, out size: 0x%x\n",
+			enable ? "enable" : "disable", err, autoneg.status,
+			out_size);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+int hinic_set_speed(struct hinic_hwdev *hwdev, enum nic_speed_level speed)
+{
+	struct hinic_speed_cmd speed_info = {0};
+	u16 out_size = sizeof(speed_info);
+	int err;
+
+	if (!hwdev)
+		return -EINVAL;
+
+	speed_info.func_id = HINIC_HWIF_FUNC_IDX(hwdev->hwif);
+	speed_info.speed = speed;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_SPEED,
+				 &speed_info, sizeof(speed_info),
+				 &speed_info, &out_size);
+	if (err || !out_size || speed_info.status) {
+		dev_err(&hwdev->hwif->pdev->dev,
+			"Failed to set speed, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, speed_info.status, out_size);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+int hinic_set_link_settings(struct hinic_hwdev *hwdev,
+			    struct hinic_link_ksettings_info *info)
+{
+	u16 out_size = sizeof(*info);
+	int err;
+
+	err = hinic_hilink_msg_cmd(hwdev, HINIC_HILINK_CMD_SET_LINK_SETTINGS,
+				   info, sizeof(*info), info, &out_size);
+	if ((info->status != HINIC_MGMT_CMD_UNSUPPORTED &&
+	     info->status) || err || !out_size) {
+		dev_err(&hwdev->hwif->pdev->dev,
+			"Failed to set link settings, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, info->status, out_size);
+		return -EFAULT;
+	}
+
+	return info->status;
+}
+
+int hinic_get_hw_pause_info(struct hinic_hwdev *hwdev,
+			    struct hinic_pause_config *pause_info)
+{
+	u16 out_size = sizeof(*pause_info);
+	int err;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_PAUSE_INFO,
+				 pause_info, sizeof(*pause_info),
+				 pause_info, &out_size);
+	if (err || !out_size || pause_info->status) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to get pause info, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, pause_info->status, out_size);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+int hinic_set_hw_pause_info(struct hinic_hwdev *hwdev,
+			    struct hinic_pause_config *pause_info)
+{
+	u16 out_size = sizeof(*pause_info);
+	int err;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_PAUSE_INFO,
+				 pause_info, sizeof(*pause_info),
+				 pause_info, &out_size);
+	if (err || !out_size || pause_info->status) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to set pause info, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, pause_info->status, out_size);
+		return -EIO;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index f2781521970e..5f34308abd2b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -79,6 +79,42 @@ enum hinic_speed {
 	HINIC_SPEED_UNKNOWN = 0xFF,
 };
 
+enum hinic_link_mode {
+	HINIC_10GE_BASE_KR = 0,
+	HINIC_40GE_BASE_KR4 = 1,
+	HINIC_40GE_BASE_CR4 = 2,
+	HINIC_100GE_BASE_KR4 = 3,
+	HINIC_100GE_BASE_CR4 = 4,
+	HINIC_25GE_BASE_KR_S = 5,
+	HINIC_25GE_BASE_CR_S = 6,
+	HINIC_25GE_BASE_KR = 7,
+	HINIC_25GE_BASE_CR = 8,
+	HINIC_GE_BASE_KX = 9,
+	HINIC_LINK_MODE_NUMBERS,
+
+	HINIC_SUPPORTED_UNKNOWN = 0xFFFF,
+};
+
+enum hinic_port_type {
+	HINIC_PORT_TP,		/* BASET */
+	HINIC_PORT_AUI,
+	HINIC_PORT_MII,
+	HINIC_PORT_FIBRE,	/* OPTICAL */
+	HINIC_PORT_BNC,
+	HINIC_PORT_ELEC,
+	HINIC_PORT_COPPER,	/* PORT_DA */
+	HINIC_PORT_AOC,
+	HINIC_PORT_BACKPLANE,
+	HINIC_PORT_NONE = 0xEF,
+	HINIC_PORT_OTHER = 0xFF,
+};
+
+enum hinic_valid_link_settings {
+	HILINK_LINK_SET_SPEED = 0x1,
+	HILINK_LINK_SET_AUTONEG = 0x2,
+	HILINK_LINK_SET_FEC = 0x4,
+};
+
 enum hinic_tso_state {
 	HINIC_TSO_DISABLE = 0,
 	HINIC_TSO_ENABLE  = 1,
@@ -179,6 +215,50 @@ struct hinic_port_cap {
 	u8      rsvd2[3];
 };
 
+struct hinic_link_mode_cmd {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u16	rsvd1;
+	u16	supported;	/* 0xFFFF represents invalid value */
+	u16	advertised;
+};
+
+struct hinic_speed_cmd {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u16	speed;
+};
+
+struct hinic_set_autoneg_cmd {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u16	enable;	/* 1: enable , 0: disable */
+};
+
+struct hinic_link_ksettings_info {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u16	rsvd1;
+
+	u32	valid_bitmap;
+	u32	speed;		/* enum nic_speed_level */
+	u8	autoneg;	/* 0 - off; 1 - on */
+	u8	fec;		/* 0 - RSFEC; 1 - BASEFEC; 2 - NOFEC */
+	u8	rsvd2[18];	/* reserved for duplex, port, etc. */
+};
+
 struct hinic_tso_config {
 	u8	status;
 	u8	version;
@@ -549,6 +629,18 @@ struct hinic_spoofchk_set {
 	u16	func_id;
 };
 
+struct hinic_pause_config {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u16	rsvd1;
+	u32	auto_neg;
+	u32	rx_pause;
+	u32	tx_pause;
+};
+
 int hinic_port_add_mac(struct hinic_dev *nic_dev, const u8 *addr,
 		       u16 vlan_id);
 
@@ -628,4 +720,20 @@ int hinic_set_rx_vlan_offload(struct hinic_dev *nic_dev, u8 en);
 
 int hinic_get_mgmt_version(struct hinic_dev *nic_dev, u8 *mgmt_ver);
 
+int hinic_set_link_settings(struct hinic_hwdev *hwdev,
+			    struct hinic_link_ksettings_info *info);
+
+int hinic_get_link_mode(struct hinic_hwdev *hwdev,
+			struct hinic_link_mode_cmd *link_mode);
+
+int hinic_set_autoneg(struct hinic_hwdev *hwdev, bool enable);
+
+int hinic_set_speed(struct hinic_hwdev *hwdev, enum nic_speed_level speed);
+
+int hinic_get_hw_pause_info(struct hinic_hwdev *hwdev,
+			    struct hinic_pause_config *pause_info);
+
+int hinic_set_hw_pause_info(struct hinic_hwdev *hwdev,
+			    struct hinic_pause_config *pause_info);
+
 #endif
-- 
2.17.1

