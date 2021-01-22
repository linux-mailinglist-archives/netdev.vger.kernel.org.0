Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE32300F5F
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 22:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbhAVVwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 16:52:06 -0500
Received: from 95-165-96-9.static.spd-mgts.ru ([95.165.96.9]:58478 "EHLO
        blackbox.su" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1730082AbhAVVv3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 16:51:29 -0500
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jan 2021 16:51:24 EST
Received: from metamini.metanet (metamini.metanet [192.168.2.5])
        by blackbox.su (Postfix) with ESMTP id 2F0D282100;
        Sat, 23 Jan 2021 00:43:05 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1611351785; bh=aqeiVjw+8ulvSa/IDwt9iXnzGFAnD49G+w9w92yf+Jw=;
        h=From:To:Cc:Subject:Date:From;
        b=FJgesnc1GyVtQVId00AycBS1gKOECwtoPJN+ZQYe75qEf/T7xKR0CAQf1vAXmLoes
         oW0VFuhXFCW9ywd5s/XRscowiU6hrAQmNKKaypWLBYMlDC9gOwI2KnA8cdBvTT0dUJ
         hEUvIKcrQ3VVmNCWV948QyltIhJGBZrD6+Ufr+7dOBBtcEcyrcvbUoohZK32vwtRY7
         d4R78MTtx1kn/LXMIdA4srtxvZBcM1JgY00H5RvFdCRWw9yRcPmgwzWR3vTrWN2Ykj
         /Yl9BbupQXb+r9Lh+7QGKD2A1tjHNARO02BehcRwxStiGxYLkQq9M+5BS/hXFnrX2D
         LBBBgBPu5jN8w==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, sbauer@blackbox.su,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Simon Horman <simon.horman@netronome.com>,
        Mark Einon <mark.einon@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] lan743x: add virtual PHY for PHY-less devices
Date:   Sat, 23 Jan 2021 00:42:41 +0300
Message-Id: <20210122214247.6536-1-sbauer@blackbox.su>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sbauer@blackbox.su

v1->v2:
	switch to using of fixed_phy as was suggested by Andrew and Florian
	also features-related parts are removed

Previous versions can be found at:
v1:
initial version
	https://lkml.org/lkml/2020/9/17/1272

Signed-off-by: Sergej Bauer <sbauer@blackbox.su>

diff --git a/MAINTAINERS b/MAINTAINERS
index 650deb973913..86304efd7691 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11699,6 +11699,12 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/microchip/lan743x_*
 
+MICROCHIP LAN743X VIRTUAL PHY
+M:	Sergej Bauer <sbauer@blackbox.su>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/ethernet/microchip/lan743x_virtual_phy.*
+
 MICROCHIP LCDFB DRIVER
 M:	Nicolas Ferre <nicolas.ferre@microchip.com>
 L:	linux-fbdev@vger.kernel.org
diff --git a/drivers/net/ethernet/microchip/Kconfig b/drivers/net/ethernet/microchip/Kconfig
index d0f6dfe0dcf3..fbc94cf115bd 100644
--- a/drivers/net/ethernet/microchip/Kconfig
+++ b/drivers/net/ethernet/microchip/Kconfig
@@ -48,6 +48,7 @@ config LAN743X
 	select PHYLIB
 	select CRC16
 	select CRC32
+	select FIXED_PHY
 	help
 	  Support for the Microchip LAN743x PCI Express Gigabit Ethernet chip
 
diff --git a/drivers/net/ethernet/microchip/Makefile b/drivers/net/ethernet/microchip/Makefile
index da603540ca57..dc3a2d66c286 100644
--- a/drivers/net/ethernet/microchip/Makefile
+++ b/drivers/net/ethernet/microchip/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_ENC28J60) += enc28j60.o
 obj-$(CONFIG_ENCX24J600) += encx24j600.o encx24j600-regmap.o
 obj-$(CONFIG_LAN743X) += lan743x.o
 
-lan743x-objs := lan743x_main.o lan743x_ethtool.o lan743x_ptp.o
+lan743x-objs := lan743x_main.o lan743x_ethtool.o lan743x_ptp.o lan743x_virtual_phy.o
diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index c5de8f46cdd3..22636366d0db 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -816,6 +816,17 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
 }
 #endif /* CONFIG_PM */
 
+int lan743x_set_link_ksettings(struct net_device *netdev,
+			       const struct ethtool_link_ksettings *cmd)
+{
+	if (!netdev->phydev)
+		return -ENETDOWN;
+
+	return phy_is_pseudo_fixed_link(netdev->phydev) ?
+			lan743x_set_virtual_link_ksettings(netdev, cmd)
+			: phy_ethtool_set_link_ksettings(netdev, cmd);
+}
+
 const struct ethtool_ops lan743x_ethtool_ops = {
 	.get_drvinfo = lan743x_ethtool_get_drvinfo,
 	.get_msglevel = lan743x_ethtool_get_msglevel,
@@ -839,7 +850,7 @@ const struct ethtool_ops lan743x_ethtool_ops = {
 	.get_eee = lan743x_ethtool_get_eee,
 	.set_eee = lan743x_ethtool_set_eee,
 	.get_link_ksettings = phy_ethtool_get_link_ksettings,
-	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+	.set_link_ksettings = lan743x_set_link_ksettings,
 #ifdef CONFIG_PM
 	.get_wol = lan743x_ethtool_get_wol,
 	.set_wol = lan743x_ethtool_set_wol,
diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.h b/drivers/net/ethernet/microchip/lan743x_ethtool.h
index d0d11a777a58..7287474d4a5c 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.h
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.h
@@ -8,4 +8,7 @@
 
 extern const struct ethtool_ops lan743x_ethtool_ops;
 
+int lan743x_set_virtual_link_ksettings(struct net_device *netdev,
+				       const struct ethtool_link_ksettings *cmd);
+
 #endif /* _LAN743X_ETHTOOL_H */
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 3804310c853a..d8c00fa298d0 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -17,6 +17,11 @@
 #include <linux/crc16.h>
 #include "lan743x_main.h"
 #include "lan743x_ethtool.h"
+#include "lan743x_virtual_phy.h"
+
+static char *mii_regs[32];
+static int mii_regs_count;
+module_param_array(mii_regs, charp, &mii_regs_count, 0644);
 
 static void lan743x_pci_cleanup(struct lan743x_adapter *adapter)
 {
@@ -821,7 +826,7 @@ static int lan743x_mac_init(struct lan743x_adapter *adapter)
 	return 0;
 }
 
-static int lan743x_mac_open(struct lan743x_adapter *adapter)
+int lan743x_mac_open(struct lan743x_adapter *adapter)
 {
 	u32 temp;
 
@@ -832,7 +837,7 @@ static int lan743x_mac_open(struct lan743x_adapter *adapter)
 	return 0;
 }
 
-static void lan743x_mac_close(struct lan743x_adapter *adapter)
+void lan743x_mac_close(struct lan743x_adapter *adapter)
 {
 	u32 temp;
 
@@ -1000,8 +1005,10 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
 	struct net_device *netdev = adapter->netdev;
 
 	phy_stop(netdev->phydev);
-	phy_disconnect(netdev->phydev);
-	netdev->phydev = NULL;
+	if (phy_is_pseudo_fixed_link(netdev->phydev))
+		lan743x_virtual_phy_disconnect(netdev->phydev);
+	else
+		phy_disconnect(netdev->phydev);
 }
 
 static int lan743x_phy_open(struct lan743x_adapter *adapter)
@@ -1019,11 +1026,22 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 		/* try internal phy */
 		phydev = phy_find_first(adapter->mdiobus);
 		if (!phydev)
+			phydev = lan743x_virtual_phy(adapter, mii_regs,
+						     mii_regs_count);
+
+		if (!phydev || IS_ERR(phydev))
 			goto return_error;
 
-		ret = phy_connect_direct(netdev, phydev,
-					 lan743x_phy_link_status_change,
-					 PHY_INTERFACE_MODE_GMII);
+		if (phy_is_pseudo_fixed_link(phydev)) {
+			ret = phy_connect_direct(netdev, phydev,
+						 lan743x_virtual_phy_status_change,
+						 PHY_INTERFACE_MODE_MII);
+		} else {
+			ret = phy_connect_direct(netdev, phydev,
+						 lan743x_phy_link_status_change,
+						 PHY_INTERFACE_MODE_GMII);
+		}
+
 		if (ret)
 			goto return_error;
 	}
@@ -1031,6 +1049,15 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 	/* MAC doesn't support 1000T Half */
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
 
+	if (phy_is_pseudo_fixed_link(phydev)) {
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_TP_BIT);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
+				 phydev->supported);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+				 phydev->supported);
+		phy_advertise_supported(phydev);
+	}
+
 	/* support both flow controls */
 	phy_support_asym_pause(phydev);
 	phy->fc_request_control = (FLOW_CTRL_RX | FLOW_CTRL_TX);
@@ -2580,11 +2607,20 @@ static netdev_tx_t lan743x_netdev_xmit_frame(struct sk_buff *skb,
 static int lan743x_netdev_ioctl(struct net_device *netdev,
 				struct ifreq *ifr, int cmd)
 {
+	int ret;
+
 	if (!netif_running(netdev))
 		return -EINVAL;
+
 	if (cmd == SIOCSHWTSTAMP)
 		return lan743x_ptp_ioctl(netdev, ifr, cmd);
-	return phy_mii_ioctl(netdev->phydev, ifr, cmd);
+
+	if (phy_is_pseudo_fixed_link(netdev->phydev))
+		ret = lan743x_virtual_phy_mii_ioctl(netdev->phydev, ifr, cmd);
+	else
+		ret = phy_mii_ioctl(netdev->phydev, ifr, cmd);
+
+	return ret;
 }
 
 static void lan743x_netdev_set_multicast(struct net_device *netdev)
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 404af3f4635e..8e16fd0f166a 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -109,6 +109,7 @@
 #define MAC_CR_EEE_EN_			BIT(17)
 #define MAC_CR_ADD_			BIT(12)
 #define MAC_CR_ASD_			BIT(11)
+#define MAC_CR_INT_LOOPBACK_		BIT(10)
 #define MAC_CR_CNTR_RST_		BIT(5)
 #define MAC_CR_DPX_			BIT(3)
 #define MAC_CR_CFG_H_			BIT(2)
diff --git a/drivers/net/ethernet/microchip/lan743x_virtual_phy.c b/drivers/net/ethernet/microchip/lan743x_virtual_phy.c
new file mode 100644
index 000000000000..b6bf7c016448
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan743x_virtual_phy.c
@@ -0,0 +1,335 @@
+// SPDX-License-Identifier: GPL-2.0+
+// Copyright (C) 2021 Sergej Bauer
+#include <linux/netdevice.h>
+#include <linux/phy.h>
+#include <linux/phy_fixed.h>
+#include <linux/ethtool.h>
+#include <linux/rtnetlink.h>
+#include "lan743x_main.h"
+#include "lan743x_ethtool.h"
+#include "lan743x_virtual_phy.h"
+
+static u16 regs802p3[32];
+
+int lan743x_virtual_phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr,
+				  int cmd)
+{
+	struct ethtool_link_ksettings ksettings;
+	struct net_device *netdev = phydev->attached_dev;
+	struct mii_ioctl_data *mii_data = if_mii(ifr);
+	int ret = 0;
+	u16 val = mii_data->val_in;
+	u16 reg_num = mii_data->reg_num;
+
+	if (reg_num > 0x1f)
+		return -ERANGE;
+
+	memset(&ksettings, 0, sizeof(ksettings));
+	phy_ethtool_get_link_ksettings(netdev, &ksettings);
+	ksettings.base.autoneg = AUTONEG_ENABLE;
+
+	switch (cmd) {
+	case SIOCGMIIPHY:
+		break;
+	case SIOCGMIIREG:
+		mii_data->val_out = regs802p3[reg_num];
+		break;
+	case SIOCSMIIREG:
+		switch (reg_num) {
+		case MII_BMCR:
+			val &= ~BMCR_RESET;
+			if (!(val & BMCR_FULLDPLX))
+				val |= BMCR_FULLDPLX;
+			val &= ~0x1f;
+
+			if (val & BMCR_ANRESTART)
+				val &= ~BMCR_ANRESTART;
+
+			if ((val & BMCR_SPEED1000) && (val & BMCR_SPEED100)) {
+				ret = -EINVAL;
+				netdev_err(netdev, "invalid bits 0.6 and 0.13");
+				break;
+			}
+
+			ksettings.base.duplex = DUPLEX_FULL;
+
+			if (val & BMCR_SPEED1000)
+				ksettings.base.speed = SPEED_1000;
+			else if (val & BMCR_SPEED100)
+				ksettings.base.speed = SPEED_100;
+			else
+				ksettings.base.speed = SPEED_10;
+
+			break;
+
+		case 1:
+		case 2:
+		case 3:
+		case 15:
+		default:
+			regs802p3[reg_num] = val;
+			break;
+		}
+		ret = lan743x_set_virtual_link_ksettings(netdev, &ksettings);
+		if (ret == 0)
+			regs802p3[reg_num] = val;
+
+		break;
+	default:
+		netdev_err(netdev, "not supported ioctl %X\n", cmd);
+		ret = -EOPNOTSUPP;
+	};
+
+	return ret;
+}
+
+void lan743x_virtual_phy_disconnect(struct phy_device *phydev)
+{
+	struct net_device *attached_dev = phydev->attached_dev;
+
+	if (phydev->sysfs_links) {
+		if (phydev->attached_dev)
+			sysfs_remove_link(&attached_dev->dev.kobj,
+					  "phydev");
+		sysfs_remove_link(&phydev->mdio.dev.kobj,
+				  "attached_dev");
+	}
+
+	fixed_phy_unregister(phydev);
+}
+
+void lan743x_virtual_phy_status_change(struct net_device *netdev)
+{
+	struct lan743x_adapter *adapter = netdev_priv(netdev);
+	struct phy_device *phydev = netdev->phydev;
+	u32 data;
+
+	if (!netdev->phydev)
+		return;
+
+	if (phydev->state == PHY_RUNNING) {
+		data = lan743x_csr_read(adapter, MAC_CR);
+		data |= MAC_CR_INT_LOOPBACK_;
+		data &= ~MAC_CR_MII_EN_;
+		data |= MAC_CR_DPX_;
+
+		switch (phydev->speed) {
+		case SPEED_10:
+			data &= ~MAC_CR_CFG_H_;
+			data &= ~MAC_CR_CFG_L_;
+		break;
+		case SPEED_100:
+			data &= ~MAC_CR_CFG_H_;
+			data |= MAC_CR_CFG_L_;
+		break;
+		case SPEED_1000:
+			data |= MAC_CR_CFG_H_;
+			data &= ~MAC_CR_CFG_L_;
+		break;
+		}
+		lan743x_csr_write(adapter, MAC_CR, data);
+	}
+	phy_print_status(phydev);
+}
+
+struct phy_device *lan743x_virtual_phy(struct lan743x_adapter *adapter,
+				       char *mii_regs[], int mii_regs_count)
+{
+	struct phy_device *phydev = NULL;
+	struct net_device *netdev = adapter->netdev;
+	struct mii_ioctl_data mii_data;
+	struct ifreq ifr;
+	long res;
+	int ret, i;
+
+	struct fixed_phy_status status = {
+		.link = 1,
+		.speed = SPEED_1000,
+		.duplex = DUPLEX_FULL,
+		.asym_pause = 1,
+	};
+
+	phydev = fixed_phy_register(PHY_POLL, &status, NULL);
+	if (!phydev || IS_ERR(phydev)) {
+		netif_err(adapter, ifup, adapter->netdev,
+			  "failed to regiter fixed_phy\n");
+		goto out;
+	}
+	phydev->attached_dev = netdev;
+	netdev->phydev = phydev;
+
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT,
+			   phydev->supported);
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
+			   phydev->supported);
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
+			   phydev->supported);
+
+	if (mii_regs_count > 0) {
+		for (i = 0; i < mii_regs_count; i++) {
+			mii_data.reg_num = i;
+			ret = kstrtol(mii_regs[i], 16, &res);
+
+			if (ret == 0)
+				mii_data.val_in = res;
+			else
+				mii_data.val_in = 0xffff;
+
+			memcpy(&ifr.ifr_ifru.ifru_data, &mii_data,
+			       sizeof(mii_data));
+			ret = lan743x_virtual_phy_mii_ioctl(phydev, &ifr,
+							    SIOCSMIIREG);
+			if (ret < 0)
+				return NULL;
+		}
+	} else {
+		mii_data.reg_num = MII_BMSR;
+		mii_data.val_in = BMSR_100FULL | BMSR_10FULL | BMSR_ESTATEN |
+			BMSR_ANEGCOMPLETE | BMSR_ANEGCAPABLE | BMSR_LSTATUS |
+			BMSR_ERCAP;
+		memcpy(&ifr.ifr_ifru.ifru_data, &mii_data, sizeof(mii_data));
+		lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+
+		mii_data.reg_num = MII_PHYSID1;
+		mii_data.val_in = (adapter->csr.id_rev & ID_REV_ID_MASK_) >> 16;
+		memcpy(&ifr.ifr_ifru.ifru_data, &mii_data, sizeof(mii_data));
+		lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+
+		mii_data.reg_num = MII_PHYSID2;
+		mii_data.val_in = adapter->csr.id_rev & ID_REV_CHIP_REV_MASK_;
+		memcpy(&ifr.ifr_ifru.ifru_data, &mii_data, sizeof(mii_data));
+		lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+
+		mii_data.reg_num = MII_ADVERTISE;
+		mii_data.val_in = ADVERTISE_100FULL | ADVERTISE_10FULL |
+			ADVERTISE_LPACK;
+		memcpy(&ifr.ifr_ifru.ifru_data, &mii_data, sizeof(mii_data));
+		lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+
+		mii_data.reg_num = MII_LPA;
+		mii_data.val_in = ADVERTISE_100FULL | ADVERTISE_10FULL |
+			ADVERTISE_LPACK;
+		memcpy(&ifr.ifr_ifru.ifru_data, &mii_data, sizeof(mii_data));
+		lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+
+		mii_data.reg_num = MII_EXPANSION;
+		mii_data.val_in = EXPANSION_NWAY | EXPANSION_ENABLENPAGE |
+			EXPANSION_NPCAPABLE;
+		memcpy(&ifr.ifr_ifru.ifru_data, &mii_data, sizeof(mii_data));
+		lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+
+		mii_data.reg_num = MII_CTRL1000;
+		mii_data.val_in = ADVERTISE_1000FULL;
+		memcpy(&ifr.ifr_ifru.ifru_data, &mii_data, sizeof(mii_data));
+		lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+
+		mii_data.reg_num = MII_STAT1000;
+		mii_data.val_in = LPA_1000FULL | LPA_1000REMRXOK |
+			LPA_1000LOCALRXOK | LPA_1000MSRES;
+		memcpy(&ifr.ifr_ifru.ifru_data, &mii_data, sizeof(mii_data));
+		lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+
+		mii_data.reg_num = MII_ESTATUS;
+		mii_data.val_in = ESTATUS_1000_TFULL;
+		memcpy(&ifr.ifr_ifru.ifru_data, &mii_data, sizeof(mii_data));
+		lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+
+		mii_data.reg_num = MII_BMCR;
+		mii_data.val_in = BMCR_SPEED1000 | BMCR_FULLDPLX |
+			BMCR_LOOPBACK | BMCR_ANENABLE;
+		memcpy(&ifr.ifr_ifru.ifru_data, &mii_data, sizeof(mii_data));
+		lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+	}
+
+	phydev->attached_dev = NULL;
+out:
+	return phydev;
+}
+
+int lan743x_set_virtual_link_ksettings(struct net_device *netdev,
+				       const struct ethtool_link_ksettings *cmd)
+{
+	struct ethtool_link_ksettings *cmd_ref =
+		(struct ethtool_link_ksettings *)cmd;
+	struct lan743x_adapter *adapter = netdev_priv(netdev);
+	u32 speed = cmd->base.speed;
+	u8 duplex = cmd->base.duplex;
+	u16 v = 0;
+	u32 data;
+
+	if (!netdev->phydev)
+		return -ENETDOWN;
+	if (speed &&
+	    speed != SPEED_10 && speed != SPEED_100 && speed != SPEED_1000) {
+		netdev_err(netdev, "%s: unknown speed %d\n", netdev->name,
+			   speed);
+		return -EINVAL;
+	}
+
+	v = regs802p3[0];
+	v &= ~(BMCR_SPEED1000 | BMCR_SPEED100);
+	data = lan743x_csr_read(adapter, MAC_CR);
+	duplex = DUPLEX_FULL;
+
+	if (speed != adapter->netdev->phydev->speed) {
+		lan743x_mac_close(adapter);
+		switch (speed) {
+		case 0:
+			break;
+		case SPEED_10:
+			data &= ~(MAC_CR_CFG_H_ | MAC_CR_CFG_L_);
+			lan743x_csr_write(adapter, MAC_CR, data);
+
+			regs802p3[MII_ADVERTISE] = ADVERTISE_10FULL |
+				ADVERTISE_100FULL |
+				ADVERTISE_LPACK;
+			regs802p3[MII_LPA] = LPA_10FULL | LPA_LPACK;
+			regs802p3[MII_EXPANSION] = ESTATUS_1000_TFULL;
+			regs802p3[MII_CTRL1000] = ADVERTISE_1000FULL;
+			regs802p3[MII_STAT1000] = 0;
+			break;
+		case SPEED_100:
+			v |= BMCR_SPEED100;
+			data &= ~MAC_CR_CFG_H_;
+			data |= MAC_CR_CFG_L_;
+			lan743x_csr_write(adapter, MAC_CR, data);
+
+			regs802p3[MII_ADVERTISE] = ADVERTISE_10FULL |
+				ADVERTISE_100FULL |
+				ADVERTISE_LPACK;
+			regs802p3[MII_LPA] = LPA_10FULL | LPA_100FULL |
+				LPA_LPACK;
+			regs802p3[MII_EXPANSION] = ESTATUS_1000_TFULL;
+			regs802p3[MII_CTRL1000] = ADVERTISE_1000FULL;
+			regs802p3[MII_STAT1000] = 0;
+			break;
+		case SPEED_1000:
+			v |= BMCR_SPEED1000;
+			data |= MAC_CR_CFG_H_;
+			data &= ~MAC_CR_CFG_L_;
+			lan743x_csr_write(adapter, MAC_CR, data);
+
+			regs802p3[MII_ADVERTISE] = ADVERTISE_10FULL |
+				ADVERTISE_100FULL |
+				ADVERTISE_LPACK;
+			regs802p3[MII_LPA] = LPA_10FULL | LPA_100FULL |
+				LPA_LPACK;
+			regs802p3[MII_EXPANSION] = ESTATUS_1000_TFULL;
+			regs802p3[MII_CTRL1000] = ADVERTISE_1000FULL;
+			regs802p3[MII_STAT1000] = LPA_1000FULL |
+				LPA_1000REMRXOK | LPA_1000LOCALRXOK |
+				LPA_1000MSRES;
+			break;
+		};
+		lan743x_mac_open(adapter);
+
+		v |= BMCR_LOOPBACK | BMCR_FULLDPLX | BMCR_ANENABLE;
+		regs802p3[0] = v;
+	}
+
+	cmd_ref->base.duplex = duplex;
+	cmd_ref->base.autoneg = AUTONEG_ENABLE;
+
+	return phy_ethtool_set_link_ksettings(netdev, cmd_ref);
+}
+
diff --git a/drivers/net/ethernet/microchip/lan743x_virtual_phy.h b/drivers/net/ethernet/microchip/lan743x_virtual_phy.h
new file mode 100644
index 000000000000..caef07d73d74
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan743x_virtual_phy.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (C) 2021 Sergej Bauer */
+#ifndef LAN743X_FAKE_PHY_H
+#define LAN743X_FAKE_PHY_H
+
+#include "lan743x_main.h"
+
+struct phy_device *lan743x_virtual_phy(struct lan743x_adapter *adapter,
+				       char *mii_regs[], int mii_regs_count);
+void lan743x_virtual_phy_disconnect(struct phy_device *phydev);
+int lan743x_virtual_phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr,
+				  int cmd);
+void lan743x_virtual_phy_status_change(struct net_device *netdev);
+int lan743x_set_virtual_link_ksettings(struct net_device *netdev,
+				       const struct ethtool_link_ksettings *cmd);
+
+int lan743x_mac_open(struct lan743x_adapter *adapter);
+void lan743x_mac_close(struct lan743x_adapter *adapter);
+
+#endif
