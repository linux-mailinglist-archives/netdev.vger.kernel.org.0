Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4882483A6
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 13:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgHRLMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 07:12:42 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:34575 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbgHRLMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 07:12:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1597749154; x=1629285154;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=akihujkA5bf0hrAeq18zPx9nqroF2gB/5E4YGuJTw0g=;
  b=UtC7DxnlWsMMd+gYR+CAop+LoqMSvPYexcVFpKlIYNQlTSHb5AIoLpcR
   BZKhhnX2tGEljO4OJP4OVi2BLkoCY+pJ3GH/pprKBwm/lXzO0ufpBJstG
   gyqSdB81vjD0u4QLnF8J3SjNXURiHjNV7bhsMJjenUVIZBwCGlbg2WiH2
   APQwqWkeHcHbW226eGiiXK9yQO9rF2b3ylcD63Esmi6+PnnqYdrT0d/YA
   g3egG3nhSypSFud77r6d5U1MDOf2iK1vlEDmFSaFK3+FZ+U/OQMFJP5Wv
   Xr3Ji5jyVZS0uoZKcfMFt8hry6i3UWczjfDbT7wp7X9a+JES+oinqfpLy
   Q==;
IronPort-SDR: swZ9YOEOd8grS8WT90T4UG7mAuU8Z9AkrfCh9ybI5KUh+YHO8ItfD6d9wohvDCWRewqb4wwhCB
 4dPGG4ImGkISzuifymnG7ZHRZIPuGgBiiMzezLyZZQXFOgidm7MD8Ivy2uUMdN/5CZ3rToC1zQ
 8Ig7HG9X1wifpkmRtQgdC3klSx4+yCBDpZiBK6NtAn2eZw1SldNvzg6KhMRo2y51ExS2RDO7vB
 ueZUk3P4x3jnHr47gwp1+vpIJs9/qPbZeF09/c1tsWJy9a4nEUUNU/VxlmtSHwbrcNzpyGMOxL
 rd0=
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="92169778"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Aug 2020 04:12:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 04:11:45 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 18 Aug 2020 04:12:30 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net-next v3 3/3] smsc95xx: add phylib support
Date:   Tue, 18 Aug 2020 13:11:27 +0200
Message-ID: <20200818111127.176422-4-andre.edich@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200818111127.176422-1-andre.edich@microchip.com>
References: <20200818111127.176422-1-andre.edich@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Generally, each PHY has their own configuration and it can be done
through an external PHY driver.  The smsc95xx driver uses only the
hard-coded internal PHY configuration.

This patch adds phylib support to probe external PHY drivers for
configuring external PHYs.

The MDI-X configuration for the internal PHYs moves from
drivers/net/usb/smsc95xx.c to drivers/net/phy/smsc.c.

Signed-off-by: Andre Edich <andre.edich@microchip.com>
---
 drivers/net/phy/smsc.c     |  67 +++++++
 drivers/net/usb/Kconfig    |   2 +
 drivers/net/usb/smsc95xx.c | 389 +++++++++++++------------------------
 3 files changed, 203 insertions(+), 255 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 74568ae16125..be24cd359202 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -21,6 +21,17 @@
 #include <linux/netdevice.h>
 #include <linux/smscphy.h>
 
+/* Vendor-specific PHY Definitions */
+/* EDPD NLP / crossover time configuration */
+#define PHY_EDPD_CONFIG			16
+#define PHY_EDPD_CONFIG_EXT_CROSSOVER_	0x0001
+
+/* Control/Status Indication Register */
+#define SPECIAL_CTRL_STS		27
+#define SPECIAL_CTRL_STS_OVRRD_AMDIX_	0x8000
+#define SPECIAL_CTRL_STS_AMDIX_ENABLE_	0x4000
+#define SPECIAL_CTRL_STS_AMDIX_STATE_	0x2000
+
 struct smsc_hw_stat {
 	const char *string;
 	u8 reg;
@@ -96,6 +107,54 @@ static int lan911x_config_init(struct phy_device *phydev)
 	return smsc_phy_ack_interrupt(phydev);
 }
 
+static inline int lan87xx_config_aneg(struct phy_device *phydev)
+{
+	int rc;
+	int val;
+
+	switch (phydev->mdix_ctrl) {
+	case ETH_TP_MDI:
+		val = SPECIAL_CTRL_STS_OVRRD_AMDIX_;
+		break;
+	case ETH_TP_MDI_X:
+		val = SPECIAL_CTRL_STS_OVRRD_AMDIX_ |
+			SPECIAL_CTRL_STS_AMDIX_STATE_;
+		break;
+	case ETH_TP_MDI_AUTO:
+		val = SPECIAL_CTRL_STS_AMDIX_ENABLE_;
+		break;
+	default:
+		return genphy_config_aneg(phydev);
+	}
+
+	rc = phy_read(phydev, SPECIAL_CTRL_STS);
+	if (rc < 0)
+		return rc;
+
+	rc &= ~(SPECIAL_CTRL_STS_OVRRD_AMDIX_ |
+		SPECIAL_CTRL_STS_AMDIX_ENABLE_ |
+		SPECIAL_CTRL_STS_AMDIX_STATE_);
+	rc |= val;
+	phy_write(phydev, SPECIAL_CTRL_STS, rc);
+
+	phydev->mdix = phydev->mdix_ctrl;
+	return genphy_config_aneg(phydev);
+}
+
+static inline int lan87xx_config_aneg_ext(struct phy_device *phydev)
+{
+	int rc;
+
+	/* Extend Manual AutoMDIX timer */
+	rc = phy_read(phydev, PHY_EDPD_CONFIG);
+	if (rc < 0)
+		return rc;
+
+	rc |= PHY_EDPD_CONFIG_EXT_CROSSOVER_;
+	phy_write(phydev, PHY_EDPD_CONFIG, rc);
+	return lan87xx_config_aneg(phydev);
+}
+
 /*
  * The LAN87xx suffers from rare absence of the ENERGYON-bit when Ethernet cable
  * plugs in while LAN87xx is in Energy Detect Power-Down mode. This leads to
@@ -250,6 +309,9 @@ static struct phy_driver smsc_phy_driver[] = {
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
+	/* This covers internal PHY (phy_id: 0x0007C0C3) for
+	 * LAN9500 (PID: 0x9500), LAN9514 (PID: 0xec00), LAN9505 (PID: 0x9505)
+	 */
 	.phy_id		= 0x0007c0c0, /* OUI=0x00800f, Model#=0x0c */
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "SMSC LAN8700",
@@ -262,6 +324,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	.read_status	= lan87xx_read_status,
 	.config_init	= smsc_phy_config_init,
 	.soft_reset	= smsc_phy_reset,
+	.config_aneg	= lan87xx_config_aneg,
 
 	/* IRQ related */
 	.ack_interrupt	= smsc_phy_ack_interrupt,
@@ -293,6 +356,9 @@ static struct phy_driver smsc_phy_driver[] = {
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
+	/* This covers internal PHY (phy_id: 0x0007C0F0) for
+	 * LAN9500A (PID: 0x9E00), LAN9505A (PID: 0x9E01)
+	 */
 	.phy_id		= 0x0007c0f0, /* OUI=0x00800f, Model#=0x0f */
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "SMSC LAN8710/LAN8720",
@@ -306,6 +372,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	.read_status	= lan87xx_read_status,
 	.config_init	= smsc_phy_config_init,
 	.soft_reset	= smsc_phy_reset,
+	.config_aneg	= lan87xx_config_aneg_ext,
 
 	/* IRQ related */
 	.ack_interrupt	= smsc_phy_ack_interrupt,
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index a7fbc3ccd29e..0863f01937b3 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -345,6 +345,8 @@ config USB_NET_SMSC75XX
 config USB_NET_SMSC95XX
 	tristate "SMSC LAN95XX based USB 2.0 10/100 ethernet devices"
 	depends on USB_USBNET
+	select PHYLIB
+	select SMSC_PHY
 	select BITREVERSE
 	select CRC16
 	select CRC32
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index f200684875fb..b479909e49aa 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -18,10 +18,12 @@
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
 #include <linux/of_net.h>
+#include <linux/mdio.h>
+#include <linux/phy.h>
 #include "smsc95xx.h"
 
 #define SMSC_CHIPNAME			"smsc95xx"
-#define SMSC_DRIVER_VERSION		"1.0.6"
+#define SMSC_DRIVER_VERSION		"2.0.0"
 #define HS_USB_PKT_SIZE			(512)
 #define FS_USB_PKT_SIZE			(64)
 #define DEFAULT_HS_BURST_CAP_SIZE	(16 * 1024 + 5 * HS_USB_PKT_SIZE)
@@ -49,10 +51,7 @@
 #define SUSPEND_ALLMODES		(SUSPEND_SUSPEND0 | SUSPEND_SUSPEND1 | \
 					 SUSPEND_SUSPEND2 | SUSPEND_SUSPEND3)
 
-#define CARRIER_CHECK_DELAY (2 * HZ)
-
 struct smsc95xx_priv {
-	u32 chip_id;
 	u32 mac_cr;
 	u32 hash_hi;
 	u32 hash_lo;
@@ -60,10 +59,8 @@ struct smsc95xx_priv {
 	spinlock_t mac_cr_lock;
 	u8 features;
 	u8 suspend_flags;
-	u8 mdix_ctrl;
-	bool link_ok;
-	struct delayed_work carrier_check;
-	struct usbnet *dev;
+	struct mii_bus *mdiobus;
+	struct phy_device *phydev;
 };
 
 static bool turbo_mode = true;
@@ -173,10 +170,14 @@ static int __must_check __smsc95xx_phy_wait_not_busy(struct usbnet *dev,
 	return -EIO;
 }
 
-static int __smsc95xx_mdio_read(struct net_device *netdev, int phy_id, int idx,
+static u32 mii_address_cmd(int phy_id, int idx, u16 op)
+{
+	return (phy_id & 0x1f) << 11 | (idx & 0x1f) << 6 | op;
+}
+
+static int __smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx,
 				int in_pm)
 {
-	struct usbnet *dev = netdev_priv(netdev);
 	u32 val, addr;
 	int ret;
 
@@ -185,14 +186,12 @@ static int __smsc95xx_mdio_read(struct net_device *netdev, int phy_id, int idx,
 	/* confirm MII not busy */
 	ret = __smsc95xx_phy_wait_not_busy(dev, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "MII is busy in smsc95xx_mdio_read\n");
+		netdev_warn(dev->net, "%s: MII is busy\n", __func__);
 		goto done;
 	}
 
 	/* set the address, index & direction (read from PHY) */
-	phy_id &= dev->mii.phy_id_mask;
-	idx &= dev->mii.reg_num_mask;
-	addr = (phy_id << 11) | (idx << 6) | MII_READ_ | MII_BUSY_;
+	addr = mii_address_cmd(phy_id, idx, MII_READ_ | MII_BUSY_);
 	ret = __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
 	if (ret < 0) {
 		netdev_warn(dev->net, "Error writing MII_ADDR\n");
@@ -218,10 +217,9 @@ static int __smsc95xx_mdio_read(struct net_device *netdev, int phy_id, int idx,
 	return ret;
 }
 
-static void __smsc95xx_mdio_write(struct net_device *netdev, int phy_id,
+static void __smsc95xx_mdio_write(struct usbnet *dev, int phy_id,
 				  int idx, int regval, int in_pm)
 {
-	struct usbnet *dev = netdev_priv(netdev);
 	u32 val, addr;
 	int ret;
 
@@ -230,7 +228,7 @@ static void __smsc95xx_mdio_write(struct net_device *netdev, int phy_id,
 	/* confirm MII not busy */
 	ret = __smsc95xx_phy_wait_not_busy(dev, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "MII is busy in smsc95xx_mdio_write\n");
+		netdev_warn(dev->net, "%s: MII is busy\n", __func__);
 		goto done;
 	}
 
@@ -242,9 +240,7 @@ static void __smsc95xx_mdio_write(struct net_device *netdev, int phy_id,
 	}
 
 	/* set the address, index & direction (write to PHY) */
-	phy_id &= dev->mii.phy_id_mask;
-	idx &= dev->mii.reg_num_mask;
-	addr = (phy_id << 11) | (idx << 6) | MII_WRITE_ | MII_BUSY_;
+	addr = mii_address_cmd(phy_id, idx, MII_WRITE_ | MII_BUSY_);
 	ret = __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
 	if (ret < 0) {
 		netdev_warn(dev->net, "Error writing MII_ADDR\n");
@@ -263,27 +259,32 @@ static void __smsc95xx_mdio_write(struct net_device *netdev, int phy_id,
 
 static int smsc95xx_mdio_read_nopm(struct usbnet *dev, int idx)
 {
-	struct mii_if_info *mii = &dev->mii;
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 
-	return __smsc95xx_mdio_read(dev->net, mii->phy_id, idx, 1);
+	return __smsc95xx_mdio_read(dev, pdata->phydev->mdio.addr, idx, 1);
 }
 
 static void smsc95xx_mdio_write_nopm(struct usbnet *dev, int idx, int regval)
 {
-	struct mii_if_info *mii = &dev->mii;
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 
-	__smsc95xx_mdio_write(dev->net, mii->phy_id, idx, regval, 1);
+	__smsc95xx_mdio_write(dev, pdata->phydev->mdio.addr, idx, regval, 1);
 }
 
-static int smsc95xx_mdio_read(struct net_device *netdev, int phy_id, int idx)
+static int smsc95xx_mdiobus_read(struct mii_bus *bus, int phy_id, int idx)
 {
-	return __smsc95xx_mdio_read(netdev, phy_id, idx, 0);
+	struct usbnet *dev = bus->priv;
+
+	return __smsc95xx_mdio_read(dev, phy_id, idx, 0);
 }
 
-static void smsc95xx_mdio_write(struct net_device *netdev, int phy_id, int idx,
-				int regval)
+static int smsc95xx_mdiobus_write(struct mii_bus *bus, int phy_id, int idx,
+				  u16 regval)
 {
-	__smsc95xx_mdio_write(netdev, phy_id, idx, regval, 0);
+	struct usbnet *dev = bus->priv;
+
+	__smsc95xx_mdio_write(dev, phy_id, idx, regval, 0);
+	return 0;
 }
 
 static int __must_check smsc95xx_wait_eeprom(struct usbnet *dev)
@@ -553,32 +554,21 @@ static int smsc95xx_phy_update_flowcontrol(struct usbnet *dev, u8 duplex,
 static int smsc95xx_link_reset(struct usbnet *dev)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
-	struct mii_if_info *mii = &dev->mii;
-	struct ethtool_cmd ecmd = { .cmd = ETHTOOL_GSET };
+	struct ethtool_link_ksettings cmd;
 	unsigned long flags;
 	u16 lcladv, rmtadv;
 	int ret;
 
-	/* clear interrupt status */
-	ret = smsc95xx_mdio_read(dev->net, mii->phy_id, PHY_INT_SRC);
-	if (ret < 0)
-		return ret;
-
 	ret = smsc95xx_write_reg(dev, INT_STS, INT_STS_CLEAR_ALL_);
 	if (ret < 0)
 		return ret;
 
-	mii_check_media(mii, 1, 1);
-	mii_ethtool_gset(&dev->mii, &ecmd);
-	lcladv = smsc95xx_mdio_read(dev->net, mii->phy_id, MII_ADVERTISE);
-	rmtadv = smsc95xx_mdio_read(dev->net, mii->phy_id, MII_LPA);
-
-	netif_dbg(dev, link, dev->net,
-		  "speed: %u duplex: %d lcladv: %04x rmtadv: %04x\n",
-		  ethtool_cmd_speed(&ecmd), ecmd.duplex, lcladv, rmtadv);
+	phy_ethtool_ksettings_get(pdata->phydev, &cmd);
+	lcladv = phy_read(pdata->phydev, MII_ADVERTISE);
+	rmtadv = phy_read(pdata->phydev, MII_LPA);
 
 	spin_lock_irqsave(&pdata->mac_cr_lock, flags);
-	if (ecmd.duplex != DUPLEX_FULL) {
+	if (cmd.base.duplex != DUPLEX_FULL) {
 		pdata->mac_cr &= ~MAC_CR_FDPX_;
 		pdata->mac_cr |= MAC_CR_RCVOWN_;
 	} else {
@@ -591,7 +581,8 @@ static int smsc95xx_link_reset(struct usbnet *dev)
 	if (ret < 0)
 		return ret;
 
-	ret = smsc95xx_phy_update_flowcontrol(dev, ecmd.duplex, lcladv, rmtadv);
+	ret = smsc95xx_phy_update_flowcontrol(dev, cmd.base.duplex, lcladv,
+					      rmtadv);
 	if (ret < 0)
 		netdev_warn(dev->net, "Error updating PHY flow control\n");
 
@@ -618,44 +609,6 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 			    intdata);
 }
 
-static void set_carrier(struct usbnet *dev, bool link)
-{
-	struct smsc95xx_priv *pdata = dev->driver_priv;
-
-	if (pdata->link_ok == link)
-		return;
-
-	pdata->link_ok = link;
-
-	if (link)
-		usbnet_link_change(dev, 1, 0);
-	else
-		usbnet_link_change(dev, 0, 0);
-}
-
-static void check_carrier(struct work_struct *work)
-{
-	struct smsc95xx_priv *pdata = container_of(work, struct smsc95xx_priv,
-						carrier_check.work);
-	struct usbnet *dev = pdata->dev;
-	int ret;
-
-	if (pdata->suspend_flags != 0)
-		return;
-
-	ret = smsc95xx_mdio_read(dev->net, dev->mii.phy_id, MII_BMSR);
-	if (ret < 0) {
-		netdev_warn(dev->net, "Failed to read MII_BMSR\n");
-		return;
-	}
-	if (ret & BMSR_LSTATUS)
-		set_carrier(dev, 1);
-	else
-		set_carrier(dev, 0);
-
-	schedule_delayed_work(&pdata->carrier_check, CARRIER_CHECK_DELAY);
-}
-
 /* Enable or disable Tx & Rx checksum offload engines */
 static int smsc95xx_set_features(struct net_device *netdev,
 	netdev_features_t features)
@@ -774,108 +727,15 @@ static int smsc95xx_ethtool_set_wol(struct net_device *net,
 	return ret;
 }
 
-static int get_mdix_status(struct net_device *net)
-{
-	struct usbnet *dev = netdev_priv(net);
-	u32 val;
-	int buf;
-
-	buf = smsc95xx_mdio_read(dev->net, dev->mii.phy_id, SPECIAL_CTRL_STS);
-	if (buf & SPECIAL_CTRL_STS_OVRRD_AMDIX_) {
-		if (buf & SPECIAL_CTRL_STS_AMDIX_ENABLE_)
-			return ETH_TP_MDI_AUTO;
-		else if (buf & SPECIAL_CTRL_STS_AMDIX_STATE_)
-			return ETH_TP_MDI_X;
-	} else {
-		buf = smsc95xx_read_reg(dev, STRAP_STATUS, &val);
-		if (val & STRAP_STATUS_AMDIX_EN_)
-			return ETH_TP_MDI_AUTO;
-	}
-
-	return ETH_TP_MDI;
-}
-
-static void set_mdix_status(struct net_device *net, __u8 mdix_ctrl)
-{
-	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = dev->driver_priv;
-	int buf;
-
-	if ((pdata->chip_id == ID_REV_CHIP_ID_9500A_) ||
-	    (pdata->chip_id == ID_REV_CHIP_ID_9530_) ||
-	    (pdata->chip_id == ID_REV_CHIP_ID_89530_) ||
-	    (pdata->chip_id == ID_REV_CHIP_ID_9730_)) {
-		/* Extend Manual AutoMDIX timer for 9500A/9500Ai */
-		buf = smsc95xx_mdio_read(dev->net, dev->mii.phy_id,
-					 PHY_EDPD_CONFIG);
-		buf |= PHY_EDPD_CONFIG_EXT_CROSSOVER_;
-		smsc95xx_mdio_write(dev->net, dev->mii.phy_id,
-				    PHY_EDPD_CONFIG, buf);
-	}
-
-	if (mdix_ctrl == ETH_TP_MDI) {
-		buf = smsc95xx_mdio_read(dev->net, dev->mii.phy_id,
-					 SPECIAL_CTRL_STS);
-		buf |= SPECIAL_CTRL_STS_OVRRD_AMDIX_;
-		buf &= ~(SPECIAL_CTRL_STS_AMDIX_ENABLE_ |
-			 SPECIAL_CTRL_STS_AMDIX_STATE_);
-		smsc95xx_mdio_write(dev->net, dev->mii.phy_id,
-				    SPECIAL_CTRL_STS, buf);
-	} else if (mdix_ctrl == ETH_TP_MDI_X) {
-		buf = smsc95xx_mdio_read(dev->net, dev->mii.phy_id,
-					 SPECIAL_CTRL_STS);
-		buf |= SPECIAL_CTRL_STS_OVRRD_AMDIX_;
-		buf &= ~(SPECIAL_CTRL_STS_AMDIX_ENABLE_ |
-			 SPECIAL_CTRL_STS_AMDIX_STATE_);
-		buf |= SPECIAL_CTRL_STS_AMDIX_STATE_;
-		smsc95xx_mdio_write(dev->net, dev->mii.phy_id,
-				    SPECIAL_CTRL_STS, buf);
-	} else if (mdix_ctrl == ETH_TP_MDI_AUTO) {
-		buf = smsc95xx_mdio_read(dev->net, dev->mii.phy_id,
-					 SPECIAL_CTRL_STS);
-		buf &= ~SPECIAL_CTRL_STS_OVRRD_AMDIX_;
-		buf &= ~(SPECIAL_CTRL_STS_AMDIX_ENABLE_ |
-			 SPECIAL_CTRL_STS_AMDIX_STATE_);
-		buf |= SPECIAL_CTRL_STS_AMDIX_ENABLE_;
-		smsc95xx_mdio_write(dev->net, dev->mii.phy_id,
-				    SPECIAL_CTRL_STS, buf);
-	}
-	pdata->mdix_ctrl = mdix_ctrl;
-}
-
-static int smsc95xx_get_link_ksettings(struct net_device *net,
-				       struct ethtool_link_ksettings *cmd)
+static u32 smsc95xx_get_link(struct net_device *net)
 {
-	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = dev->driver_priv;
-	int retval;
-
-	retval = usbnet_get_link_ksettings(net, cmd);
-
-	cmd->base.eth_tp_mdix = pdata->mdix_ctrl;
-	cmd->base.eth_tp_mdix_ctrl = pdata->mdix_ctrl;
-
-	return retval;
-}
-
-static int smsc95xx_set_link_ksettings(struct net_device *net,
-				       const struct ethtool_link_ksettings *cmd)
-{
-	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = dev->driver_priv;
-	int retval;
-
-	if (pdata->mdix_ctrl != cmd->base.eth_tp_mdix_ctrl)
-		set_mdix_status(net, cmd->base.eth_tp_mdix_ctrl);
-
-	retval = usbnet_set_link_ksettings(net, cmd);
-
-	return retval;
+	phy_read_status(net->phydev);
+	return net->phydev->link;
 }
 
 static const struct ethtool_ops smsc95xx_ethtool_ops = {
-	.get_link	= usbnet_get_link,
-	.nway_reset	= usbnet_nway_reset,
+	.get_link	= smsc95xx_get_link,
+	.nway_reset	= phy_ethtool_nway_reset,
 	.get_drvinfo	= usbnet_get_drvinfo,
 	.get_msglevel	= usbnet_get_msglevel,
 	.set_msglevel	= usbnet_set_msglevel,
@@ -886,19 +746,17 @@ static const struct ethtool_ops smsc95xx_ethtool_ops = {
 	.get_regs	= smsc95xx_ethtool_getregs,
 	.get_wol	= smsc95xx_ethtool_get_wol,
 	.set_wol	= smsc95xx_ethtool_set_wol,
-	.get_link_ksettings	= smsc95xx_get_link_ksettings,
-	.set_link_ksettings	= smsc95xx_set_link_ksettings,
+	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
+	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
 	.get_ts_info	= ethtool_op_get_ts_info,
 };
 
 static int smsc95xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 {
-	struct usbnet *dev = netdev_priv(netdev);
-
 	if (!netif_running(netdev))
 		return -EINVAL;
 
-	return generic_mii_ioctl(&dev->mii, if_mii(rq), cmd, NULL);
+	return phy_mii_ioctl(netdev->phydev, rq, cmd);
 }
 
 static void smsc95xx_init_mac_address(struct usbnet *dev)
@@ -974,51 +832,6 @@ static int smsc95xx_start_rx_path(struct usbnet *dev, int in_pm)
 	return __smsc95xx_write_reg(dev, MAC_CR, pdata->mac_cr, in_pm);
 }
 
-static int smsc95xx_phy_initialize(struct usbnet *dev)
-{
-	int bmcr, ret, timeout = 0;
-
-	/* Initialize MII structure */
-	dev->mii.dev = dev->net;
-	dev->mii.mdio_read = smsc95xx_mdio_read;
-	dev->mii.mdio_write = smsc95xx_mdio_write;
-	dev->mii.phy_id_mask = 0x1f;
-	dev->mii.reg_num_mask = 0x1f;
-	dev->mii.phy_id = SMSC95XX_INTERNAL_PHY_ID;
-
-	/* reset phy and wait for reset to complete */
-	smsc95xx_mdio_write(dev->net, dev->mii.phy_id, MII_BMCR, BMCR_RESET);
-
-	do {
-		msleep(10);
-		bmcr = smsc95xx_mdio_read(dev->net, dev->mii.phy_id, MII_BMCR);
-		timeout++;
-	} while ((bmcr & BMCR_RESET) && (timeout < 100));
-
-	if (timeout >= 100) {
-		netdev_warn(dev->net, "timeout on PHY Reset");
-		return -EIO;
-	}
-
-	smsc95xx_mdio_write(dev->net, dev->mii.phy_id, MII_ADVERTISE,
-		ADVERTISE_ALL | ADVERTISE_CSMA | ADVERTISE_PAUSE_CAP |
-		ADVERTISE_PAUSE_ASYM);
-
-	/* read to clear */
-	ret = smsc95xx_mdio_read(dev->net, dev->mii.phy_id, PHY_INT_SRC);
-	if (ret < 0) {
-		netdev_warn(dev->net, "Failed to read PHY_INT_SRC during init\n");
-		return ret;
-	}
-
-	smsc95xx_mdio_write(dev->net, dev->mii.phy_id, PHY_INT_MASK,
-		PHY_INT_MASK_DEFAULT_);
-	mii_nway_restart(&dev->mii);
-
-	netif_dbg(dev, ifup, dev->net, "phy initialised successfully\n");
-	return 0;
-}
-
 static int smsc95xx_reset(struct usbnet *dev)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
@@ -1200,12 +1013,6 @@ static int smsc95xx_reset(struct usbnet *dev)
 
 	smsc95xx_set_multicast(dev->net);
 
-	ret = smsc95xx_phy_initialize(dev);
-	if (ret < 0) {
-		netdev_warn(dev->net, "Failed to init PHY\n");
-		return ret;
-	}
-
 	ret = smsc95xx_read_reg(dev, INT_EP_CTL, &read_buf);
 	if (ret < 0)
 		return ret;
@@ -1250,6 +1057,7 @@ static const struct net_device_ops smsc95xx_netdev_ops = {
 static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct smsc95xx_priv *pdata;
+	bool is_internal_phy;
 	u32 val;
 	int ret;
 
@@ -1291,15 +1099,50 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (ret)
 		goto free_pdata;
 
+	pdata->mdiobus = mdiobus_alloc();
+	if (!pdata->mdiobus) {
+		ret = -ENOMEM;
+		goto free_pdata;
+	}
+
+	ret = smsc95xx_read_reg(dev, HW_CFG, &val);
+	if (ret < 0)
+		goto free_mdio;
+
+	is_internal_phy = !(val & HW_CFG_PSEL_);
+	if (is_internal_phy)
+		pdata->mdiobus->phy_mask = ~(1u << SMSC95XX_INTERNAL_PHY_ID);
+
+	pdata->mdiobus->priv = dev;
+	pdata->mdiobus->read = smsc95xx_mdiobus_read;
+	pdata->mdiobus->write = smsc95xx_mdiobus_write;
+	pdata->mdiobus->name = "smsc95xx-mdiobus";
+	pdata->mdiobus->parent = &dev->udev->dev;
+
+	snprintf(pdata->mdiobus->id, ARRAY_SIZE(pdata->mdiobus->id),
+		 "usb-%03d:%03d", dev->udev->bus->busnum, dev->udev->devnum);
+
+	ret = mdiobus_register(pdata->mdiobus);
+	if (ret) {
+		netdev_err(dev->net, "Could not register MDIO bus\n");
+		goto free_mdio;
+	}
+
+	pdata->phydev = phy_find_first(pdata->mdiobus);
+	if (!pdata->phydev) {
+		netdev_err(dev->net, "no PHY found\n");
+		ret = -ENODEV;
+		goto unregister_mdio;
+	}
+
+	pdata->phydev->is_internal = is_internal_phy;
+
 	/* detect device revision as different features may be available */
 	ret = smsc95xx_read_reg(dev, ID_REV, &val);
 	if (ret < 0)
-		goto free_pdata;
+		goto unregister_mdio;
 
 	val >>= 16;
-	pdata->chip_id = val;
-	pdata->mdix_ctrl = get_mdix_status(dev->net);
-
 	if ((val == ID_REV_CHIP_ID_9500A_) || (val == ID_REV_CHIP_ID_9530_) ||
 	    (val == ID_REV_CHIP_ID_89530_) || (val == ID_REV_CHIP_ID_9730_))
 		pdata->features = (FEATURE_8_WAKEUP_FILTERS |
@@ -1315,12 +1158,13 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->min_mtu = ETH_MIN_MTU;
 	dev->net->max_mtu = ETH_DATA_LEN;
 	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
+	return 0;
 
-	pdata->dev = dev;
-	INIT_DELAYED_WORK(&pdata->carrier_check, check_carrier);
-	schedule_delayed_work(&pdata->carrier_check, CARRIER_CHECK_DELAY);
+unregister_mdio:
+	mdiobus_unregister(pdata->mdiobus);
 
-	return 0;
+free_mdio:
+	mdiobus_free(pdata->mdiobus);
 
 free_pdata:
 	kfree(pdata);
@@ -1331,11 +1175,51 @@ static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
 
-	cancel_delayed_work_sync(&pdata->carrier_check);
+	mdiobus_unregister(pdata->mdiobus);
+	mdiobus_free(pdata->mdiobus);
 	netif_dbg(dev, ifdown, dev->net, "free pdata\n");
 	kfree(pdata);
 }
 
+static void smsc95xx_handle_link_change(struct net_device *net)
+{
+	phy_print_status(net->phydev);
+}
+
+static int smsc95xx_start_phy(struct usbnet *dev)
+{
+	struct smsc95xx_priv *pdata = dev->driver_priv;
+	struct net_device *net = dev->net;
+	int ret;
+
+	ret = smsc95xx_reset(dev);
+	if (ret < 0)
+		return ret;
+
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+			   pdata->phydev->supported);
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			   pdata->phydev->supported);
+	ret = phy_connect_direct(net, pdata->phydev,
+				 &smsc95xx_handle_link_change,
+				 PHY_INTERFACE_MODE_MII);
+	if (ret) {
+		netdev_err(net, "can't attach PHY to %s\n", pdata->mdiobus->id);
+		return ret;
+	}
+
+	phy_attached_info(net->phydev);
+	phy_start(net->phydev);
+	return 0;
+}
+
+static int smsc95xx_disconnect_phy(struct usbnet *dev)
+{
+	phy_stop(dev->net->phydev);
+	phy_disconnect(dev->net->phydev);
+	return 0;
+}
+
 static u32 smsc_crc(const u8 *buffer, size_t len, int filter)
 {
 	u32 crc = bitrev16(crc16(0xFFFF, buffer, len));
@@ -1588,8 +1472,6 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 		return ret;
 	}
 
-	cancel_delayed_work_sync(&pdata->carrier_check);
-
 	if (pdata->suspend_flags) {
 		netdev_warn(dev->net, "error during last resume\n");
 		pdata->suspend_flags = 0;
@@ -1833,10 +1715,6 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 	if (ret && PMSG_IS_AUTO(message))
 		usbnet_resume(intf);
 
-	if (ret)
-		schedule_delayed_work(&pdata->carrier_check,
-				      CARRIER_CHECK_DELAY);
-
 	return ret;
 }
 
@@ -1856,7 +1734,6 @@ static int smsc95xx_resume(struct usb_interface *intf)
 
 	/* do this first to ensure it's cleared even in error case */
 	pdata->suspend_flags = 0;
-	schedule_delayed_work(&pdata->carrier_check, CARRIER_CHECK_DELAY);
 
 	if (suspend_flags & SUSPEND_ALLMODES) {
 		/* clear wake-up sources */
@@ -1887,6 +1764,7 @@ static int smsc95xx_resume(struct usb_interface *intf)
 	if (ret < 0)
 		netdev_warn(dev->net, "usbnet_resume error\n");
 
+	phy_init_hw(pdata->phydev);
 	return ret;
 }
 
@@ -2092,7 +1970,8 @@ static const struct driver_info smsc95xx_info = {
 	.bind		= smsc95xx_bind,
 	.unbind		= smsc95xx_unbind,
 	.link_reset	= smsc95xx_link_reset,
-	.reset		= smsc95xx_reset,
+	.reset		= smsc95xx_start_phy,
+	.stop		= smsc95xx_disconnect_phy,
 	.rx_fixup	= smsc95xx_rx_fixup,
 	.tx_fixup	= smsc95xx_tx_fixup,
 	.status		= smsc95xx_status,
-- 
2.28.0

