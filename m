Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039983F45E8
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 09:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235190AbhHWHlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 03:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235175AbhHWHk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 03:40:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6124AC061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 00:40:16 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mI4Wn-000376-ML; Mon, 23 Aug 2021 09:37:53 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mI4Wm-0005q9-Ol; Mon, 23 Aug 2021 09:37:52 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net v2 1/2] net: usb: asix: ax88772: move embedded PHY detection as early as possible
Date:   Mon, 23 Aug 2021 09:37:47 +0200
Message-Id: <20210823073748.22384-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823073748.22384-1-o.rempel@pengutronix.de>
References: <20210823073748.22384-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some HW revisions need additional MAC configuration before the embedded PHY
can be enabled. If this is not done, we won't be able to get response
from the internal PHY.

This issue was detected on chipcode == AX_AX88772_CHIPCODE variant,
where ax88772_hw_reset() was executed with missing embd_phy flag.

Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
Reported-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Tested-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/asix.h         |  1 +
 drivers/net/usb/asix_devices.c | 41 +++++++++++++++++-----------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index e1994a246122..2a1e31defe71 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -184,6 +184,7 @@ struct asix_common_private {
 	struct phy_device *phydev;
 	u16 phy_addr;
 	char phy_name[20];
+	bool embd_phy;
 };
 
 extern const struct driver_info ax88172a_info;
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 2c115216420a..15460d419e3f 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -354,24 +354,23 @@ static int ax88772_reset(struct usbnet *dev)
 static int ax88772_hw_reset(struct usbnet *dev, int in_pm)
 {
 	struct asix_data *data = (struct asix_data *)&dev->data;
-	int ret, embd_phy;
+	struct asix_common_private *priv = dev->driver_priv;
 	u16 rx_ctl;
+	int ret;
 
 	ret = asix_write_gpio(dev, AX_GPIO_RSE | AX_GPIO_GPO_2 |
 			      AX_GPIO_GPO2EN, 5, in_pm);
 	if (ret < 0)
 		goto out;
 
-	embd_phy = ((dev->mii.phy_id & 0x1f) == 0x10 ? 1 : 0);
-
-	ret = asix_write_cmd(dev, AX_CMD_SW_PHY_SELECT, embd_phy,
+	ret = asix_write_cmd(dev, AX_CMD_SW_PHY_SELECT, priv->embd_phy,
 			     0, 0, NULL, in_pm);
 	if (ret < 0) {
 		netdev_dbg(dev->net, "Select PHY #1 failed: %d\n", ret);
 		goto out;
 	}
 
-	if (embd_phy) {
+	if (priv->embd_phy) {
 		ret = asix_sw_reset(dev, AX_SWRESET_IPPD, in_pm);
 		if (ret < 0)
 			goto out;
@@ -449,17 +448,16 @@ static int ax88772_hw_reset(struct usbnet *dev, int in_pm)
 static int ax88772a_hw_reset(struct usbnet *dev, int in_pm)
 {
 	struct asix_data *data = (struct asix_data *)&dev->data;
-	int ret, embd_phy;
+	struct asix_common_private *priv = dev->driver_priv;
 	u16 rx_ctl, phy14h, phy15h, phy16h;
 	u8 chipcode = 0;
+	int ret;
 
 	ret = asix_write_gpio(dev, AX_GPIO_RSE, 5, in_pm);
 	if (ret < 0)
 		goto out;
 
-	embd_phy = ((dev->mii.phy_id & 0x1f) == 0x10 ? 1 : 0);
-
-	ret = asix_write_cmd(dev, AX_CMD_SW_PHY_SELECT, embd_phy |
+	ret = asix_write_cmd(dev, AX_CMD_SW_PHY_SELECT, priv->embd_phy |
 			     AX_PHYSEL_SSEN, 0, 0, NULL, in_pm);
 	if (ret < 0) {
 		netdev_dbg(dev->net, "Select PHY #1 failed: %d\n", ret);
@@ -683,12 +681,6 @@ static int ax88772_init_phy(struct usbnet *dev)
 	struct asix_common_private *priv = dev->driver_priv;
 	int ret;
 
-	ret = asix_read_phy_addr(dev, true);
-	if (ret < 0)
-		return ret;
-
-	priv->phy_addr = ret;
-
 	snprintf(priv->phy_name, sizeof(priv->phy_name), PHY_ID_FMT,
 		 priv->mdio->id, priv->phy_addr);
 
@@ -716,6 +708,12 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 	int ret, i;
 	u32 phyid;
 
+	priv = devm_kzalloc(&dev->udev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	dev->driver_priv = priv;
+
 	usbnet_get_endpoints(dev, intf);
 
 	/* Maybe the boot loader passed the MAC address via device tree */
@@ -751,6 +749,13 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->needed_headroom = 4; /* cf asix_tx_fixup() */
 	dev->net->needed_tailroom = 4; /* cf asix_tx_fixup() */
 
+	ret = asix_read_phy_addr(dev, true);
+	if (ret < 0)
+		return ret;
+
+	priv->phy_addr = ret;
+	priv->embd_phy = ((priv->phy_addr & 0x1f) == 0x10 ? true : false);
+
 	asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0, 0, 1, &chipcode, 0);
 	chipcode &= AX_CHIPCODE_MASK;
 
@@ -773,12 +778,6 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 		dev->rx_urb_size = 2048;
 	}
 
-	priv = devm_kzalloc(&dev->udev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	dev->driver_priv = priv;
-
 	priv->presvd_phy_bmcr = 0;
 	priv->presvd_phy_advertise = 0;
 	if (chipcode == AX_AX88772_CHIPCODE) {
-- 
2.30.2

