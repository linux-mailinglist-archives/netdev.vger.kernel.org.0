Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70FD39D753
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 10:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhFGI35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 04:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbhFGI33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 04:29:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A23C0617A8
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 01:27:38 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lqAbb-0004fF-Mf; Mon, 07 Jun 2021 10:27:31 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lqAbb-0006o1-98; Mon, 07 Jun 2021 10:27:31 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2 4/8] net: usb: asix: ax88772: add phylib support
Date:   Mon,  7 Jun 2021 10:27:23 +0200
Message-Id: <20210607082727.26045-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210607082727.26045-1-o.rempel@pengutronix.de>
References: <20210607082727.26045-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To be able to use ax88772 with external PHYs and use advantage of
existing PHY drivers, we need to port at least ax88772 part of asix
driver to the phylib framework.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/asix.h         |   9 +++
 drivers/net/usb/asix_common.c  |  37 ++++++++++
 drivers/net/usb/asix_devices.c | 120 +++++++++++++++++++++------------
 drivers/net/usb/ax88172a.c     |  14 ----
 4 files changed, 122 insertions(+), 58 deletions(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index edb94efd265e..2122d302e643 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -25,6 +25,7 @@
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
 #include <linux/if_vlan.h>
+#include <linux/phy.h>
 
 #define DRIVER_VERSION "22-Dec-2011"
 #define DRIVER_NAME "asix"
@@ -178,6 +179,10 @@ struct asix_common_private {
 	u16 presvd_phy_advertise;
 	u16 presvd_phy_bmcr;
 	struct asix_rx_fixup_info rx_fixup_info;
+	struct mii_bus *mdio;
+	struct phy_device *phydev;
+	u16 phy_addr;
+	char phy_name[20];
 };
 
 extern const struct driver_info ax88172a_info;
@@ -214,6 +219,7 @@ int asix_write_rx_ctl(struct usbnet *dev, u16 mode, int in_pm);
 
 u16 asix_read_medium_status(struct usbnet *dev, int in_pm);
 int asix_write_medium_mode(struct usbnet *dev, u16 mode, int in_pm);
+void asix_adjust_link(struct net_device *netdev);
 
 int asix_write_gpio(struct usbnet *dev, u16 value, int sleep, int in_pm);
 
@@ -222,6 +228,9 @@ void asix_set_multicast(struct net_device *net);
 int asix_mdio_read(struct net_device *netdev, int phy_id, int loc);
 void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val);
 
+int asix_mdio_bus_read(struct mii_bus *bus, int phy_id, int regnum);
+int asix_mdio_bus_write(struct mii_bus *bus, int phy_id, int regnum, u16 val);
+
 int asix_mdio_read_nopm(struct net_device *netdev, int phy_id, int loc);
 void asix_mdio_write_nopm(struct net_device *netdev, int phy_id, int loc,
 			  int val);
diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index e1109f1a8dd5..085bc8281082 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -384,6 +384,27 @@ int asix_write_medium_mode(struct usbnet *dev, u16 mode, int in_pm)
 	return ret;
 }
 
+/* set MAC link settings according to information from phylib */
+void asix_adjust_link(struct net_device *netdev)
+{
+	struct phy_device *phydev = netdev->phydev;
+	struct usbnet *dev = netdev_priv(netdev);
+	u16 mode = 0;
+
+	if (phydev->link) {
+		mode = AX88772_MEDIUM_DEFAULT;
+
+		if (phydev->duplex == DUPLEX_HALF)
+			mode &= ~AX_MEDIUM_FD;
+
+		if (phydev->speed != SPEED_100)
+			mode &= ~AX_MEDIUM_PS;
+	}
+
+	asix_write_medium_mode(dev, mode, 0);
+	phy_print_status(phydev);
+}
+
 int asix_write_gpio(struct usbnet *dev, u16 value, int sleep, int in_pm)
 {
 	int ret;
@@ -506,6 +527,22 @@ void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val)
 	mutex_unlock(&dev->phy_mutex);
 }
 
+/* MDIO read and write wrappers for phylib */
+int asix_mdio_bus_read(struct mii_bus *bus, int phy_id, int regnum)
+{
+	struct usbnet *priv = bus->priv;
+
+	return asix_mdio_read(priv->net, phy_id, regnum);
+}
+
+int asix_mdio_bus_write(struct mii_bus *bus, int phy_id, int regnum, u16 val)
+{
+	struct usbnet *priv = bus->priv;
+
+	asix_mdio_write(priv->net, phy_id, regnum, val);
+	return 0;
+}
+
 int asix_mdio_read_nopm(struct net_device *netdev, int phy_id, int loc)
 {
 	struct usbnet *dev = netdev_priv(netdev);
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 00b6ac0570eb..e4cd85e38edd 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -285,7 +285,7 @@ static int ax88172_bind(struct usbnet *dev, struct usb_interface *intf)
 
 static const struct ethtool_ops ax88772_ethtool_ops = {
 	.get_drvinfo		= asix_get_drvinfo,
-	.get_link		= asix_get_link,
+	.get_link		= usbnet_get_link,
 	.get_msglevel		= usbnet_get_msglevel,
 	.set_msglevel		= usbnet_set_msglevel,
 	.get_wol		= asix_get_wol,
@@ -293,37 +293,15 @@ static const struct ethtool_ops ax88772_ethtool_ops = {
 	.get_eeprom_len		= asix_get_eeprom_len,
 	.get_eeprom		= asix_get_eeprom,
 	.set_eeprom		= asix_set_eeprom,
-	.nway_reset		= usbnet_nway_reset,
-	.get_link_ksettings	= usbnet_get_link_ksettings_mii,
-	.set_link_ksettings	= usbnet_set_link_ksettings_mii,
+	.nway_reset		= phy_ethtool_nway_reset,
+	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
+	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
 };
 
-static int ax88772_link_reset(struct usbnet *dev)
-{
-	u16 mode;
-	struct ethtool_cmd ecmd = { .cmd = ETHTOOL_GSET };
-
-	mii_check_media(&dev->mii, 1, 1);
-	mii_ethtool_gset(&dev->mii, &ecmd);
-	mode = AX88772_MEDIUM_DEFAULT;
-
-	if (ethtool_cmd_speed(&ecmd) != SPEED_100)
-		mode &= ~AX_MEDIUM_PS;
-
-	if (ecmd.duplex != DUPLEX_FULL)
-		mode &= ~AX_MEDIUM_FD;
-
-	netdev_dbg(dev->net, "ax88772_link_reset() speed: %u duplex: %d setting mode to 0x%04x\n",
-		   ethtool_cmd_speed(&ecmd), ecmd.duplex, mode);
-
-	asix_write_medium_mode(dev, mode, 0);
-
-	return 0;
-}
-
 static int ax88772_reset(struct usbnet *dev)
 {
 	struct asix_data *data = (struct asix_data *)&dev->data;
+	struct asix_common_private *priv = dev->driver_priv;
 	int ret;
 
 	/* Rewrite MAC address */
@@ -342,6 +320,8 @@ static int ax88772_reset(struct usbnet *dev)
 	if (ret < 0)
 		goto out;
 
+	phy_start(priv->phydev);
+
 	return 0;
 
 out:
@@ -586,7 +566,7 @@ static const struct net_device_ops ax88772_netdev_ops = {
 	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address 	= asix_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= asix_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_set_rx_mode        = asix_set_multicast,
 };
 
@@ -677,12 +657,57 @@ static int asix_resume(struct usb_interface *intf)
 	return usbnet_resume(intf);
 }
 
+static int ax88772_init_mdio(struct usbnet *dev)
+{
+	struct asix_common_private *priv = dev->driver_priv;
+
+	priv->mdio = devm_mdiobus_alloc(&dev->udev->dev);
+	if (!priv->mdio)
+		return -ENOMEM;
+
+	priv->mdio->priv = dev;
+	priv->mdio->read = &asix_mdio_bus_read;
+	priv->mdio->write = &asix_mdio_bus_write;
+	priv->mdio->name = "Asix MDIO Bus";
+	/* mii bus name is usb-<usb bus number>-<usb device number> */
+	snprintf(priv->mdio->id, MII_BUS_ID_SIZE, "usb-%03d:%03d",
+		 dev->udev->bus->busnum, dev->udev->devnum);
+
+	return devm_mdiobus_register(&dev->udev->dev, priv->mdio);
+}
+
+static int ax88772_init_phy(struct usbnet *dev)
+{
+	struct asix_common_private *priv = dev->driver_priv;
+	int ret;
+
+	priv->phy_addr = asix_read_phy_addr(dev, true);
+	if (priv->phy_addr < 0)
+		return priv->phy_addr;
+
+	snprintf(priv->phy_name, sizeof(priv->phy_name), PHY_ID_FMT,
+		 priv->mdio->id, priv->phy_addr);
+
+	priv->phydev = phy_connect(dev->net, priv->phy_name, &asix_adjust_link,
+				   PHY_INTERFACE_MODE_INTERNAL);
+	if (IS_ERR(priv->phydev)) {
+		netdev_err(dev->net, "Could not connect to PHY device %s\n",
+			   priv->phy_name);
+		ret = PTR_ERR(priv->phydev);
+		return ret;
+	}
+
+	phy_attached_info(priv->phydev);
+
+	return 0;
+}
+
 static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 {
-	int ret, i;
 	u8 buf[ETH_ALEN] = {0}, chipcode = 0;
-	u32 phyid;
 	struct asix_common_private *priv;
+	int ret, i;
+	u32 phyid;
 
 	usbnet_get_endpoints(dev, intf);
 
@@ -714,17 +739,6 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	asix_set_netdev_dev_addr(dev, buf);
 
-	/* Initialize MII structure */
-	dev->mii.dev = dev->net;
-	dev->mii.mdio_read = asix_mdio_read;
-	dev->mii.mdio_write = asix_mdio_write;
-	dev->mii.phy_id_mask = 0x1f;
-	dev->mii.reg_num_mask = 0x1f;
-
-	dev->mii.phy_id = asix_read_phy_addr(dev, true);
-	if (dev->mii.phy_id < 0)
-		return dev->mii.phy_id;
-
 	dev->net->netdev_ops = &ax88772_netdev_ops;
 	dev->net->ethtool_ops = &ax88772_ethtool_ops;
 	dev->net->needed_headroom = 4; /* cf asix_tx_fixup() */
@@ -768,11 +782,31 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 		priv->suspend = ax88772_suspend;
 	}
 
+	ret = ax88772_init_mdio(dev);
+	if (ret)
+		return ret;
+
+	return ax88772_init_phy(dev);
+}
+
+static int ax88772_stop(struct usbnet *dev)
+{
+	struct asix_common_private *priv = dev->driver_priv;
+
+	/* On unplugged USB, we will get MDIO communication errors and the
+	 * PHY will be set in to PHY_HALTED state.
+	 */
+	if (priv->phydev->state != PHY_HALTED)
+		phy_stop(priv->phydev);
+
 	return 0;
 }
 
 static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
+	struct asix_common_private *priv = dev->driver_priv;
+
+	phy_disconnect(priv->phydev);
 	asix_rx_fixup_common_free(dev->driver_priv);
 }
 
@@ -1161,8 +1195,8 @@ static const struct driver_info ax88772_info = {
 	.bind = ax88772_bind,
 	.unbind = ax88772_unbind,
 	.status = asix_status,
-	.link_reset = ax88772_link_reset,
 	.reset = ax88772_reset,
+	.stop = ax88772_stop,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR | FLAG_MULTI_PACKET,
 	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
@@ -1173,7 +1207,6 @@ static const struct driver_info ax88772b_info = {
 	.bind = ax88772_bind,
 	.unbind = ax88772_unbind,
 	.status = asix_status,
-	.link_reset = ax88772_link_reset,
 	.reset = ax88772_reset,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
 	         FLAG_MULTI_PACKET,
@@ -1209,7 +1242,6 @@ static const struct driver_info hg20f9_info = {
 	.bind = ax88772_bind,
 	.unbind = ax88772_unbind,
 	.status = asix_status,
-	.link_reset = ax88772_link_reset,
 	.reset = ax88772_reset,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
 	         FLAG_MULTI_PACKET,
diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index c8ca5187eece..2e2081346740 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -25,20 +25,6 @@ struct ax88172a_private {
 	struct asix_rx_fixup_info rx_fixup_info;
 };
 
-/* MDIO read and write wrappers for phylib */
-static int asix_mdio_bus_read(struct mii_bus *bus, int phy_id, int regnum)
-{
-	return asix_mdio_read(((struct usbnet *)bus->priv)->net, phy_id,
-			      regnum);
-}
-
-static int asix_mdio_bus_write(struct mii_bus *bus, int phy_id, int regnum,
-			       u16 val)
-{
-	asix_mdio_write(((struct usbnet *)bus->priv)->net, phy_id, regnum, val);
-	return 0;
-}
-
 /* set MAC link settings according to information from phylib */
 static void ax88172a_adjust_link(struct net_device *netdev)
 {
-- 
2.29.2

