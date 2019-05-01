Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31E8A1041C
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 05:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfEADGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 23:06:43 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55904 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725973AbfEADGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 23:06:42 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 48D384E95F997A087DC7;
        Wed,  1 May 2019 11:06:39 +0800 (CST)
Received: from linux-ioko.site (10.71.200.31) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Wed, 1 May 2019 11:06:31 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>
Subject: [PATCH net-next 2/3] net: hns3: add autoneg and change speed support for fibre port
Date:   Wed, 1 May 2019 11:05:43 +0800
Message-ID: <1556679944-100941-3-git-send-email-lipeng321@huawei.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556679944-100941-1-git-send-email-lipeng321@huawei.com>
References: <1556679944-100941-1-git-send-email-lipeng321@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.71.200.31]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Previously, our driver only supports phydev to autoneg or change
port speed. This patch adds support for fibre port, driver gets
media speed capability and autoneg capability from firmware. If
the media supports multiple speeds, user can change port speed
with command "ethtool -s <devname> speed xxxx autoneg off duplex
full". If autoneg on, the user configuration may be overwritten
by the autoneg result.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  6 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 90 ++++++++++++++++++++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 78 +++++++++++++++++--
 3 files changed, 163 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 8b46c6c..7ee40ec 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -244,6 +244,8 @@ struct hnae3_ae_dev {
  *   Get negotiation status,speed and duplex
  * get_media_type()
  *   Get media type of MAC
+ * check_port_speed()
+ *   Check target speed whether is supported
  * adjust_link()
  *   Adjust link status
  * set_loopback()
@@ -260,6 +262,8 @@ struct hnae3_ae_dev {
  *   set auto autonegotiation of pause frame use
  * get_autoneg()
  *   get auto autonegotiation of pause frame use
+ * restart_autoneg()
+ *   restart autonegotiation
  * get_coalesce_usecs()
  *   get usecs to delay a TX interrupt after a packet is sent
  * get_rx_max_coalesced_frames()
@@ -355,6 +359,7 @@ struct hnae3_ae_ops {
 
 	void (*get_media_type)(struct hnae3_handle *handle, u8 *media_type,
 			       u8 *module_type);
+	int (*check_port_speed)(struct hnae3_handle *handle, u32 speed);
 	void (*adjust_link)(struct hnae3_handle *handle, int speed, int duplex);
 	int (*set_loopback)(struct hnae3_handle *handle,
 			    enum hnae3_loop loop_mode, bool en);
@@ -370,6 +375,7 @@ struct hnae3_ae_ops {
 
 	int (*set_autoneg)(struct hnae3_handle *handle, bool enable);
 	int (*get_autoneg)(struct hnae3_handle *handle);
+	int (*restart_autoneg)(struct hnae3_handle *handle);
 
 	void (*get_coalesce_usecs)(struct hnae3_handle *handle,
 				   u32 *tx_usecs, u32 *rx_usecs);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index bf7fdb8..23ded8a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -659,10 +659,54 @@ static int hns3_get_link_ksettings(struct net_device *netdev,
 	return 0;
 }
 
+static int hns3_check_ksettings_param(struct net_device *netdev,
+				      const struct ethtool_link_ksettings *cmd)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	u8 module_type = HNAE3_MODULE_TYPE_UNKNOWN;
+	u8 media_type = HNAE3_MEDIA_TYPE_UNKNOWN;
+	u8 autoneg;
+	u32 speed;
+	u8 duplex;
+	int ret;
+
+	if (ops->get_ksettings_an_result) {
+		ops->get_ksettings_an_result(handle, &autoneg, &speed, &duplex);
+		if (cmd->base.autoneg == autoneg && cmd->base.speed == speed &&
+		    cmd->base.duplex == duplex)
+			return 0;
+	}
+
+	if (ops->get_media_type)
+		ops->get_media_type(handle, &media_type, &module_type);
+
+	if (cmd->base.duplex != DUPLEX_FULL &&
+	    media_type != HNAE3_MEDIA_TYPE_COPPER) {
+		netdev_err(netdev,
+			   "only copper port supports half duplex!");
+		return -EINVAL;
+	}
+
+	if (ops->check_port_speed) {
+		ret = ops->check_port_speed(handle, cmd->base.speed);
+		if (ret) {
+			netdev_err(netdev, "unsupported speed\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static int hns3_set_link_ksettings(struct net_device *netdev,
 				   const struct ethtool_link_ksettings *cmd)
 {
-	/* Chip doesn't support this mode. */
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	int ret = 0;
+
+	/* Chip don't support this mode. */
 	if (cmd->base.speed == SPEED_1000 && cmd->base.duplex == DUPLEX_HALF)
 		return -EINVAL;
 
@@ -670,7 +714,24 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 	if (netdev->phydev)
 		return phy_ethtool_ksettings_set(netdev->phydev, cmd);
 
-	return -EOPNOTSUPP;
+	if (handle->pdev->revision == 0x20)
+		return -EOPNOTSUPP;
+
+	ret = hns3_check_ksettings_param(netdev, cmd);
+	if (ret)
+		return ret;
+
+	if (ops->set_autoneg) {
+		ret = ops->set_autoneg(handle, cmd->base.autoneg);
+		if (ret)
+			return ret;
+	}
+
+	if (ops->cfg_mac_speed_dup_h)
+		ret = ops->cfg_mac_speed_dup_h(handle, cmd->base.speed,
+					       cmd->base.duplex);
+
+	return ret;
 }
 
 static u32 hns3_get_rss_key_size(struct net_device *netdev)
@@ -875,19 +936,36 @@ static int hns3_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
 
 static int hns3_nway_reset(struct net_device *netdev)
 {
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
 	struct phy_device *phy = netdev->phydev;
+	int autoneg;
 
 	if (!netif_running(netdev))
 		return 0;
 
-	/* Only support nway_reset for netdev with phy attached for now */
-	if (!phy)
+	if (hns3_nic_resetting(netdev)) {
+		netdev_err(netdev, "dev resetting!");
+		return -EBUSY;
+	}
+
+	if (!ops->get_autoneg || !ops->restart_autoneg)
 		return -EOPNOTSUPP;
 
-	if (phy->autoneg != AUTONEG_ENABLE)
+	autoneg = ops->get_autoneg(handle);
+	if (autoneg != AUTONEG_ENABLE) {
+		netdev_err(netdev,
+			   "Autoneg is off, don't support to restart it\n");
 		return -EINVAL;
+	}
+
+	if (phy)
+		return genphy_restart_aneg(phy);
+
+	if (handle->pdev->revision == 0x20)
+		return -EOPNOTSUPP;
 
-	return genphy_restart_aneg(phy);
+	return ops->restart_autoneg(handle);
 }
 
 static void hns3_get_channels(struct net_device *netdev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d1e5b43..335215d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -845,6 +845,48 @@ static int hclge_parse_speed(int speed_cmd, int *speed)
 	return 0;
 }
 
+static int hclge_check_port_speed(struct hnae3_handle *handle, u32 speed)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	u32 speed_ability = hdev->hw.mac.speed_ability;
+	u32 speed_bit = 0;
+
+	switch (speed) {
+	case HCLGE_MAC_SPEED_10M:
+		speed_bit = HCLGE_SUPPORT_10M_BIT;
+		break;
+	case HCLGE_MAC_SPEED_100M:
+		speed_bit = HCLGE_SUPPORT_100M_BIT;
+		break;
+	case HCLGE_MAC_SPEED_1G:
+		speed_bit = HCLGE_SUPPORT_1G_BIT;
+		break;
+	case HCLGE_MAC_SPEED_10G:
+		speed_bit = HCLGE_SUPPORT_10G_BIT;
+		break;
+	case HCLGE_MAC_SPEED_25G:
+		speed_bit = HCLGE_SUPPORT_25G_BIT;
+		break;
+	case HCLGE_MAC_SPEED_40G:
+		speed_bit = HCLGE_SUPPORT_40G_BIT;
+		break;
+	case HCLGE_MAC_SPEED_50G:
+		speed_bit = HCLGE_SUPPORT_50G_BIT;
+		break;
+	case HCLGE_MAC_SPEED_100G:
+		speed_bit = HCLGE_SUPPORT_100G_BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (speed_bit & speed_ability)
+		return 0;
+
+	return -EINVAL;
+}
+
 static void hclge_convert_setting_sr(struct hclge_mac *mac, u8 speed_ability)
 {
 	if (speed_ability & HCLGE_SUPPORT_10G_BIT)
@@ -2200,6 +2242,16 @@ static int hclge_set_autoneg(struct hnae3_handle *handle, bool enable)
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
+	if (!hdev->hw.mac.support_autoneg) {
+		if (enable) {
+			dev_err(&hdev->pdev->dev,
+				"autoneg is not supported by current port\n");
+			return -EOPNOTSUPP;
+		} else {
+			return 0;
+		}
+	}
+
 	return hclge_set_autoneg_en(hdev, enable);
 }
 
@@ -2215,6 +2267,20 @@ static int hclge_get_autoneg(struct hnae3_handle *handle)
 	return hdev->hw.mac.autoneg;
 }
 
+static int hclge_restart_autoneg(struct hnae3_handle *handle)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	int ret;
+
+	dev_dbg(&hdev->pdev->dev, "restart autoneg\n");
+
+	ret = hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
+	if (ret)
+		return ret;
+	return hclge_notify_client(hdev, HNAE3_UP_CLIENT);
+}
+
 static int hclge_mac_init(struct hclge_dev *hdev)
 {
 	struct hclge_mac *mac = &hdev->hw.mac;
@@ -7613,13 +7679,13 @@ static int hclge_set_pauseparam(struct hnae3_handle *handle, u32 auto_neg,
 	if (!fc_autoneg)
 		return hclge_cfg_pauseparam(hdev, rx_en, tx_en);
 
-	/* Only support flow control negotiation for netdev with
-	 * phy attached for now.
-	 */
-	if (!phydev)
+	if (phydev)
+		return phy_start_aneg(phydev);
+
+	if (hdev->pdev->revision == 0x20)
 		return -EOPNOTSUPP;
 
-	return phy_start_aneg(phydev);
+	return hclge_restart_autoneg(handle);
 }
 
 static void hclge_get_ksettings_an_result(struct hnae3_handle *handle,
@@ -8686,6 +8752,7 @@ static int hclge_gro_en(struct hnae3_handle *handle, bool enable)
 	.get_ksettings_an_result = hclge_get_ksettings_an_result,
 	.cfg_mac_speed_dup_h = hclge_cfg_mac_speed_dup_h,
 	.get_media_type = hclge_get_media_type,
+	.check_port_speed = hclge_check_port_speed,
 	.get_rss_key_size = hclge_get_rss_key_size,
 	.get_rss_indir_size = hclge_get_rss_indir_size,
 	.get_rss = hclge_get_rss,
@@ -8702,6 +8769,7 @@ static int hclge_gro_en(struct hnae3_handle *handle, bool enable)
 	.rm_mc_addr = hclge_rm_mc_addr,
 	.set_autoneg = hclge_set_autoneg,
 	.get_autoneg = hclge_get_autoneg,
+	.restart_autoneg = hclge_restart_autoneg,
 	.get_pauseparam = hclge_get_pauseparam,
 	.set_pauseparam = hclge_set_pauseparam,
 	.set_mtu = hclge_set_mtu,
-- 
1.9.1

