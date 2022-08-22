Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21EA59BF9C
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 14:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbiHVMkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 08:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235132AbiHVMj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 08:39:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928793AB0A
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 05:39:55 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oQ6iZ-0002K8-GJ; Mon, 22 Aug 2022 14:39:47 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQ6iX-001J6u-22; Mon, 22 Aug 2022 14:39:45 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQ6iW-00A6xf-BM; Mon, 22 Aug 2022 14:39:44 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v2 1/2] net: asix: ax88772: migrate to phylink
Date:   Mon, 22 Aug 2022 14:39:42 +0200
Message-Id: <20220822123943.2409987-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some exotic ax88772 based devices which may require
functionality provide by the phylink framework. For example:
- US100A20SFP, USB 2.0 auf LWL Converter with SFP Cage
- AX88772B USB to 100Base-TX Ethernet (with RMII) demo board, where it
  is possible to switch between internal PHY and external RMII based
  connection.

So, convert this driver to phylink as soon as possible.

Tested with:
- AX88772A + internal PHY
- AX88772B + external DP83TD510E T1L PHY

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
changes v2:
- phylink_destroy() on errors or unbind()
- attach phy on bind and detach on unbind.
---
 drivers/net/usb/Kconfig        |   2 +-
 drivers/net/usb/asix.h         |   3 +
 drivers/net/usb/asix_devices.c | 122 ++++++++++++++++++++++++++++++---
 3 files changed, 116 insertions(+), 11 deletions(-)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 76659c1c525a2..4402eedb3d1a2 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -168,7 +168,7 @@ config USB_NET_AX8817X
 	tristate "ASIX AX88xxx Based USB 2.0 Ethernet Adapters"
 	depends on USB_USBNET
 	select CRC32
-	select PHYLIB
+	select PHYLINK
 	select AX88796B_PHY
 	imply NET_SELFTESTS
 	default y
diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index 21c1ca275cc44..74162190bccc1 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -27,6 +27,7 @@
 #include <linux/if_vlan.h>
 #include <linux/phy.h>
 #include <net/selftests.h>
+#include <linux/phylink.h>
 
 #define DRIVER_VERSION "22-Dec-2011"
 #define DRIVER_NAME "asix"
@@ -185,6 +186,8 @@ struct asix_common_private {
 	struct mii_bus *mdio;
 	struct phy_device *phydev;
 	struct phy_device *phydev_int;
+	struct phylink *phylink;
+	struct phylink_config phylink_config;
 	u16 phy_addr;
 	bool embd_phy;
 	u8 chipcode;
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 5b5eb630c4b79..caa1bed1fe341 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -343,7 +343,7 @@ static int ax88772_reset(struct usbnet *dev)
 	if (ret < 0)
 		goto out;
 
-	phy_start(priv->phydev);
+	phylink_start(priv->phylink);
 
 	return 0;
 
@@ -590,8 +590,11 @@ static void ax88772_suspend(struct usbnet *dev)
 	struct asix_common_private *priv = dev->driver_priv;
 	u16 medium;
 
-	if (netif_running(dev->net))
-		phy_stop(priv->phydev);
+	if (netif_running(dev->net)) {
+		rtnl_lock();
+		phylink_suspend(priv->phylink, false);
+		rtnl_unlock();
+	}
 
 	/* Stop MAC operation */
 	medium = asix_read_medium_status(dev, 1);
@@ -622,8 +625,11 @@ static void ax88772_resume(struct usbnet *dev)
 		if (!priv->reset(dev, 1))
 			break;
 
-	if (netif_running(dev->net))
-		phy_start(priv->phydev);
+	if (netif_running(dev->net)) {
+		rtnl_lock();
+		phylink_resume(priv->phylink);
+		rtnl_unlock();
+	}
 }
 
 static int asix_resume(struct usb_interface *intf)
@@ -667,8 +673,7 @@ static int ax88772_init_phy(struct usbnet *dev)
 		return -ENODEV;
 	}
 
-	ret = phy_connect_direct(dev->net, priv->phydev, &asix_adjust_link,
-				 PHY_INTERFACE_MODE_INTERNAL);
+	ret = phylink_connect_phy(priv->phylink, priv->phydev);
 	if (ret) {
 		netdev_err(dev->net, "Could not connect PHY\n");
 		return ret;
@@ -688,6 +693,9 @@ static int ax88772_init_phy(struct usbnet *dev)
 	 */
 	priv->phydev_int = mdiobus_get_phy(priv->mdio, AX_EMBD_PHY_ADDR);
 	if (!priv->phydev_int) {
+		rtnl_lock();
+		phylink_disconnect_phy(priv->phylink);
+		rtnl_unlock();
 		netdev_err(dev->net, "Could not find internal PHY\n");
 		return -ENODEV;
 	}
@@ -698,6 +706,89 @@ static int ax88772_init_phy(struct usbnet *dev)
 	return 0;
 }
 
+static void ax88772_mac_config(struct phylink_config *config, unsigned int mode,
+			      const struct phylink_link_state *state)
+{
+	/* Nothing to do */
+}
+
+static void ax88772_mac_link_down(struct phylink_config *config,
+				 unsigned int mode, phy_interface_t interface)
+{
+	struct usbnet *dev = netdev_priv(to_net_dev(config->dev));
+
+	asix_write_medium_mode(dev, 0, 0);
+	usbnet_link_change(dev, false, false);
+}
+
+static void ax88772_mac_link_up(struct phylink_config *config,
+			       struct phy_device *phy,
+			       unsigned int mode, phy_interface_t interface,
+			       int speed, int duplex,
+			       bool tx_pause, bool rx_pause)
+{
+	struct usbnet *dev = netdev_priv(to_net_dev(config->dev));
+	u16 m = AX_MEDIUM_AC | AX_MEDIUM_RE;
+
+	m |= duplex ? AX_MEDIUM_FD : 0;
+
+	switch (speed) {
+	case SPEED_100:
+		m |= AX_MEDIUM_PS;
+		break;
+	case SPEED_10:
+		break;
+	default:
+		return;
+	}
+
+	if (tx_pause)
+		m |= AX_MEDIUM_TFC;
+
+	if (rx_pause)
+		m |= AX_MEDIUM_RFC;
+
+	asix_write_medium_mode(dev, m, 0);
+	usbnet_link_change(dev, true, false);
+}
+
+static const struct phylink_mac_ops ax88772_phylink_mac_ops = {
+	.validate = phylink_generic_validate,
+	.mac_config = ax88772_mac_config,
+	.mac_link_down = ax88772_mac_link_down,
+	.mac_link_up = ax88772_mac_link_up,
+};
+
+static int ax88772_phylink_setup(struct usbnet *dev)
+{
+	struct asix_common_private *priv = dev->driver_priv;
+	phy_interface_t phy_if_mode;
+	struct phylink *phylink;
+
+	priv->phylink_config.dev = &dev->net->dev;
+	priv->phylink_config.type = PHYLINK_NETDEV;
+	priv->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
+		MAC_10 | MAC_100;
+
+	__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+		  priv->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_RMII,
+		  priv->phylink_config.supported_interfaces);
+
+	if (priv->embd_phy)
+		phy_if_mode = PHY_INTERFACE_MODE_INTERNAL;
+	else
+		phy_if_mode = PHY_INTERFACE_MODE_RMII;
+
+	phylink = phylink_create(&priv->phylink_config, dev->net->dev.fwnode,
+				 phy_if_mode, &ax88772_phylink_mac_ops);
+	if (IS_ERR(phylink))
+		return PTR_ERR(phylink);
+
+	priv->phylink = phylink;
+	return 0;
+}
+
 static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct asix_common_private *priv;
@@ -788,14 +879,22 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (ret)
 		return ret;
 
-	return ax88772_init_phy(dev);
+	ret = ax88772_phylink_setup(dev);
+	if (ret)
+		return ret;
+
+	ret = ax88772_init_phy(dev);
+	if (ret)
+		phylink_destroy(priv->phylink);
+
+	return ret;
 }
 
 static int ax88772_stop(struct usbnet *dev)
 {
 	struct asix_common_private *priv = dev->driver_priv;
 
-	phy_stop(priv->phydev);
+	phylink_stop(priv->phylink);
 
 	return 0;
 }
@@ -804,7 +903,10 @@ static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct asix_common_private *priv = dev->driver_priv;
 
-	phy_disconnect(priv->phydev);
+	rtnl_lock();
+	phylink_disconnect_phy(priv->phylink);
+	rtnl_unlock();
+	phylink_destroy(priv->phylink);
 	asix_rx_fixup_common_free(dev->driver_priv);
 }
 
-- 
2.30.2

