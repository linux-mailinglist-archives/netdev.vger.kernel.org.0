Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C6222AE77
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgGWLzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:55:53 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:50689 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGWLzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:55:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595505351; x=1627041351;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rWTHd3bxZhPPKurRgmQvPYXRTQCJhhcfWPzM/pjeFMA=;
  b=Bz4iiIM4aV2ZuXX4Q5exv4EYcGRrhXzFNCBQNj/zB8vjhzEPC/xi7uqj
   4hDS1U5+YinBpNAZkJfTtUzkcALqBcyZ10KFnKy9rh6j3j0FCsrM3lp1W
   Oe+eVJgIRCuAEHGB2Afaq1pr9T2ImoHbgRzJBZJbf16MT9gCZMQh6PHkr
   hwg9ILoupdppgzw9Lt1jF1zDFf5v2gEnlZFhaJm2sQP4n4QEmR2g2O4CV
   JYXKzX04I/lIZP/diHi7Z4gloZ9v8WkX350v/9cATZe/0YkgEXexXRJ82
   Max1EfLjbOMYpOiT+Z4xsnn1caeBcxmqLisOAPpcZ3CL3BQpdCtRJMf1y
   Q==;
IronPort-SDR: U2Eumpyj5WPWmpDmTUoS0sZiTzuW4OC07CyzQ3qafjn/ksf7tRHSFu/CyGrbcY+JdJDq+FAyeb
 R1OQ3FdDWJCzdVlxEa9EZ9Ko7PibSLfxNccVAeWFGhFf69v5SNucX807Ng21MQ75w1qYcZsWqu
 sOKhzVZhb4bsN+2m3Tw6Tc391zLUXSMV67cfcZXpv5opcRS8tj9EWO1AlNJZpkWCHfnh7KzksN
 0S29I9RRq670lXmT+gQP2fL6yBvnBPE88hoWF8rThmqkRI37eVUFEJrG0zAoGKPKFaMy9gwZGH
 RVQ=
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="81033807"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2020 04:55:51 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 04:55:51 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 23 Jul 2020 04:55:08 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net-next v2 3/6] smsc95xx: add PAL support to use external PHY drivers
Date:   Thu, 23 Jul 2020 13:55:04 +0200
Message-ID: <20200723115507.26194-4-andre.edich@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723115507.26194-1-andre.edich@microchip.com>
References: <20200723115507.26194-1-andre.edich@microchip.com>
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

This patch adds PAL (PHY Abstraction Layer) support to probe external
PHY drivers for configuring external PHYs.

Signed-off-by: Andre Edich <andre.edich@microchip.com>
---
 drivers/net/usb/smsc95xx.c | 201 ++++++++++++++++++++++++-------------
 1 file changed, 132 insertions(+), 69 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index f200684875fb..9d2710f6d396 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -18,6 +18,8 @@
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
 #include <linux/of_net.h>
+#include <linux/mdio.h>
+#include <linux/phy.h>
 #include "smsc95xx.h"
 
 #define SMSC_CHIPNAME			"smsc95xx"
@@ -64,6 +66,9 @@ struct smsc95xx_priv {
 	bool link_ok;
 	struct delayed_work carrier_check;
 	struct usbnet *dev;
+	struct mii_bus *mdiobus;
+	struct phy_device *phydev;
+	bool internal_phy;
 };
 
 static bool turbo_mode = true;
@@ -286,6 +291,22 @@ static void smsc95xx_mdio_write(struct net_device *netdev, int phy_id, int idx,
 	__smsc95xx_mdio_write(netdev, phy_id, idx, regval, 0);
 }
 
+static int smsc95xx_mdiobus_read(struct mii_bus *bus, int phy_id, int idx)
+{
+	struct usbnet *dev = bus->priv;
+
+	return __smsc95xx_mdio_read(dev->net, phy_id, idx, 0);
+}
+
+static int smsc95xx_mdiobus_write(struct mii_bus *bus, int phy_id, int idx,
+				  u16 regval)
+{
+	struct usbnet *dev = bus->priv;
+
+	__smsc95xx_mdio_write(dev->net, phy_id, idx, regval, 0);
+	return 0;
+}
+
 static int __must_check smsc95xx_wait_eeprom(struct usbnet *dev)
 {
 	unsigned long start_time = jiffies;
@@ -559,15 +580,20 @@ static int smsc95xx_link_reset(struct usbnet *dev)
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
 
+	if (pdata->internal_phy) {
+		/* clear interrupt status */
+		ret = smsc95xx_mdio_read(dev->net, mii->phy_id, PHY_INT_SRC);
+		if (ret < 0)
+			return ret;
+
+		smsc95xx_mdio_write(dev->net, mii->phy_id, PHY_INT_MASK,
+				    PHY_INT_MASK_DEFAULT_);
+	}
+
 	mii_check_media(mii, 1, 1);
 	mii_ethtool_gset(&dev->mii, &ecmd);
 	lcladv = smsc95xx_mdio_read(dev->net, mii->phy_id, MII_ADVERTISE);
@@ -851,10 +877,10 @@ static int smsc95xx_get_link_ksettings(struct net_device *net,
 	int retval;
 
 	retval = usbnet_get_link_ksettings(net, cmd);
-
-	cmd->base.eth_tp_mdix = pdata->mdix_ctrl;
-	cmd->base.eth_tp_mdix_ctrl = pdata->mdix_ctrl;
-
+	if (pdata->internal_phy) {
+		cmd->base.eth_tp_mdix = pdata->mdix_ctrl;
+		cmd->base.eth_tp_mdix_ctrl = pdata->mdix_ctrl;
+	}
 	return retval;
 }
 
@@ -863,14 +889,12 @@ static int smsc95xx_set_link_ksettings(struct net_device *net,
 {
 	struct usbnet *dev = netdev_priv(net);
 	struct smsc95xx_priv *pdata = dev->driver_priv;
-	int retval;
-
-	if (pdata->mdix_ctrl != cmd->base.eth_tp_mdix_ctrl)
-		set_mdix_status(net, cmd->base.eth_tp_mdix_ctrl);
+	u8 mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 
-	retval = usbnet_set_link_ksettings(net, cmd);
+	if (pdata->mdix_ctrl != mdix_ctrl && pdata->internal_phy)
+		set_mdix_status(net, mdix_ctrl);
 
-	return retval;
+	return usbnet_set_link_ksettings(net, cmd);
 }
 
 static const struct ethtool_ops smsc95xx_ethtool_ops = {
@@ -974,51 +998,6 @@ static int smsc95xx_start_rx_path(struct usbnet *dev, int in_pm)
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
@@ -1200,12 +1179,6 @@ static int smsc95xx_reset(struct usbnet *dev)
 
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
@@ -1291,14 +1264,59 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
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
+	pdata->internal_phy = !(val & HW_CFG_PSEL_);
+	if (pdata->internal_phy)
+		pdata->mdiobus->phy_mask = ~(1u << SMSC95XX_INTERNAL_PHY_ID);
+
+	pdata->mdiobus->priv = dev;
+	pdata->mdiobus->read = smsc95xx_mdiobus_read;
+	pdata->mdiobus->write = smsc95xx_mdiobus_write;
+	pdata->mdiobus->name = "smsc95xx-mdiobus";
+	pdata->mdiobus->parent = &dev->udev->dev;
+
+	dev->mii.phy_id_mask = 0x1f;
+	dev->mii.reg_num_mask = 0x1f;
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
+	dev->mii.dev = dev->net;
+	dev->mii.mdio_read = smsc95xx_mdio_read;
+	dev->mii.mdio_write = smsc95xx_mdio_write;
+	dev->mii.phy_id = pdata->phydev->mdio.addr;
+
 	/* detect device revision as different features may be available */
 	ret = smsc95xx_read_reg(dev, ID_REV, &val);
 	if (ret < 0)
-		goto free_pdata;
+		goto unregister_mdio;
 
 	val >>= 16;
 	pdata->chip_id = val;
-	pdata->mdix_ctrl = get_mdix_status(dev->net);
+	if (pdata->internal_phy)
+		pdata->mdix_ctrl = get_mdix_status(dev->net);
 
 	if ((val == ID_REV_CHIP_ID_9500A_) || (val == ID_REV_CHIP_ID_9530_) ||
 	    (val == ID_REV_CHIP_ID_89530_) || (val == ID_REV_CHIP_ID_9730_))
@@ -1322,6 +1340,12 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	return 0;
 
+unregister_mdio:
+	mdiobus_unregister(pdata->mdiobus);
+
+free_mdio:
+	mdiobus_free(pdata->mdiobus);
+
 free_pdata:
 	kfree(pdata);
 	return ret;
@@ -1332,10 +1356,47 @@ static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 	struct smsc95xx_priv *pdata = dev->driver_priv;
 
 	cancel_delayed_work_sync(&pdata->carrier_check);
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
@@ -1887,6 +1948,7 @@ static int smsc95xx_resume(struct usb_interface *intf)
 	if (ret < 0)
 		netdev_warn(dev->net, "usbnet_resume error\n");
 
+	phy_init_hw(pdata->phydev);
 	return ret;
 }
 
@@ -2092,7 +2154,8 @@ static const struct driver_info smsc95xx_info = {
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
2.27.0

