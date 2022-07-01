Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56393563B9C
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 23:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiGAUwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiGAUwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:52:53 -0400
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5fcc:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A2D60501;
        Fri,  1 Jul 2022 13:52:51 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 63C5B10192636;
        Fri,  1 Jul 2022 22:52:50 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 394F561A6B50;
        Fri,  1 Jul 2022 22:52:50 +0200 (CEST)
X-Mailbox-Line: From 01b2de12163b222e99375c34591b02cc47077614 Mon Sep 17 00:00:00 2001
Message-Id: <01b2de12163b222e99375c34591b02cc47077614.1656707954.git.lukas@wunner.de>
In-Reply-To: <cover.1656707954.git.lukas@wunner.de>
References: <cover.1656707954.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Fri, 1 Jul 2022 22:47:52 +0200
Subject: [PATCH net-next v2 2/3] usbnet: smsc95xx: Clean up nopm handling
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Ferry Toth <fntoth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Alan Stern <stern@rowland.harvard.edu>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LAN95xx driver has just been amended to auto-detect whether the
_nopm variant of usbnet_read_cmd() / usbnet_write_cmd() shall be used.

Drop all the now unnecessary open coding of that distinction.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/usb/smsc95xx.c | 172 ++++++++++++++-----------------------
 1 file changed, 66 insertions(+), 106 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 0316c80c3fc4..5458629cf694 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -78,8 +78,8 @@ static bool turbo_mode = true;
 module_param(turbo_mode, bool, 0644);
 MODULE_PARM_DESC(turbo_mode, "Enable multiple frames per Rx transaction");
 
-static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
-					    u32 *data, int in_pm)
+static int __must_check smsc95xx_read_reg(struct usbnet *dev, u32 index,
+					  u32 *data)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 buf;
@@ -109,8 +109,8 @@ static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
 	return ret;
 }
 
-static int __must_check __smsc95xx_write_reg(struct usbnet *dev, u32 index,
-					     u32 data, int in_pm)
+static int __must_check smsc95xx_write_reg(struct usbnet *dev, u32 index,
+					   u32 data)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 buf;
@@ -137,41 +137,16 @@ static int __must_check __smsc95xx_write_reg(struct usbnet *dev, u32 index,
 	return ret;
 }
 
-static int __must_check smsc95xx_read_reg_nopm(struct usbnet *dev, u32 index,
-					       u32 *data)
-{
-	return __smsc95xx_read_reg(dev, index, data, 1);
-}
-
-static int __must_check smsc95xx_write_reg_nopm(struct usbnet *dev, u32 index,
-						u32 data)
-{
-	return __smsc95xx_write_reg(dev, index, data, 1);
-}
-
-static int __must_check smsc95xx_read_reg(struct usbnet *dev, u32 index,
-					  u32 *data)
-{
-	return __smsc95xx_read_reg(dev, index, data, 0);
-}
-
-static int __must_check smsc95xx_write_reg(struct usbnet *dev, u32 index,
-					   u32 data)
-{
-	return __smsc95xx_write_reg(dev, index, data, 0);
-}
-
 /* Loop until the read is completed with timeout
  * called with phy_mutex held */
-static int __must_check __smsc95xx_phy_wait_not_busy(struct usbnet *dev,
-						     int in_pm)
+static int __must_check smsc95xx_phy_wait_not_busy(struct usbnet *dev)
 {
 	unsigned long start_time = jiffies;
 	u32 val;
 	int ret;
 
 	do {
-		ret = __smsc95xx_read_reg(dev, MII_ADDR, &val, in_pm);
+		ret = smsc95xx_read_reg(dev, MII_ADDR, &val);
 		if (ret < 0) {
 			/* Ignore -ENODEV error during disconnect() */
 			if (ret == -ENODEV)
@@ -192,8 +167,7 @@ static u32 mii_address_cmd(int phy_id, int idx, u16 op)
 	return (phy_id & 0x1f) << 11 | (idx & 0x1f) << 6 | op;
 }
 
-static int __smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx,
-				int in_pm)
+static int smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx)
 {
 	u32 val, addr;
 	int ret;
@@ -201,7 +175,7 @@ static int __smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx,
 	mutex_lock(&dev->phy_mutex);
 
 	/* confirm MII not busy */
-	ret = __smsc95xx_phy_wait_not_busy(dev, in_pm);
+	ret = smsc95xx_phy_wait_not_busy(dev);
 	if (ret < 0) {
 		netdev_warn(dev->net, "%s: MII is busy\n", __func__);
 		goto done;
@@ -209,20 +183,20 @@ static int __smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx,
 
 	/* set the address, index & direction (read from PHY) */
 	addr = mii_address_cmd(phy_id, idx, MII_READ_ | MII_BUSY_);
-	ret = __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
+	ret = smsc95xx_write_reg(dev, MII_ADDR, addr);
 	if (ret < 0) {
 		if (ret != -ENODEV)
 			netdev_warn(dev->net, "Error writing MII_ADDR\n");
 		goto done;
 	}
 
-	ret = __smsc95xx_phy_wait_not_busy(dev, in_pm);
+	ret = smsc95xx_phy_wait_not_busy(dev);
 	if (ret < 0) {
 		netdev_warn(dev->net, "Timed out reading MII reg %02X\n", idx);
 		goto done;
 	}
 
-	ret = __smsc95xx_read_reg(dev, MII_DATA, &val, in_pm);
+	ret = smsc95xx_read_reg(dev, MII_DATA, &val);
 	if (ret < 0) {
 		if (ret != -ENODEV)
 			netdev_warn(dev->net, "Error reading MII_DATA\n");
@@ -240,8 +214,8 @@ static int __smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx,
 	return ret;
 }
 
-static void __smsc95xx_mdio_write(struct usbnet *dev, int phy_id,
-				  int idx, int regval, int in_pm)
+static void smsc95xx_mdio_write(struct usbnet *dev, int phy_id, int idx,
+				int regval)
 {
 	u32 val, addr;
 	int ret;
@@ -249,14 +223,14 @@ static void __smsc95xx_mdio_write(struct usbnet *dev, int phy_id,
 	mutex_lock(&dev->phy_mutex);
 
 	/* confirm MII not busy */
-	ret = __smsc95xx_phy_wait_not_busy(dev, in_pm);
+	ret = smsc95xx_phy_wait_not_busy(dev);
 	if (ret < 0) {
 		netdev_warn(dev->net, "%s: MII is busy\n", __func__);
 		goto done;
 	}
 
 	val = regval;
-	ret = __smsc95xx_write_reg(dev, MII_DATA, val, in_pm);
+	ret = smsc95xx_write_reg(dev, MII_DATA, val);
 	if (ret < 0) {
 		if (ret != -ENODEV)
 			netdev_warn(dev->net, "Error writing MII_DATA\n");
@@ -265,14 +239,14 @@ static void __smsc95xx_mdio_write(struct usbnet *dev, int phy_id,
 
 	/* set the address, index & direction (write to PHY) */
 	addr = mii_address_cmd(phy_id, idx, MII_WRITE_ | MII_BUSY_);
-	ret = __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
+	ret = smsc95xx_write_reg(dev, MII_ADDR, addr);
 	if (ret < 0) {
 		if (ret != -ENODEV)
 			netdev_warn(dev->net, "Error writing MII_ADDR\n");
 		goto done;
 	}
 
-	ret = __smsc95xx_phy_wait_not_busy(dev, in_pm);
+	ret = smsc95xx_phy_wait_not_busy(dev);
 	if (ret < 0) {
 		netdev_warn(dev->net, "Timed out writing MII reg %02X\n", idx);
 		goto done;
@@ -282,25 +256,11 @@ static void __smsc95xx_mdio_write(struct usbnet *dev, int phy_id,
 	mutex_unlock(&dev->phy_mutex);
 }
 
-static int smsc95xx_mdio_read_nopm(struct usbnet *dev, int idx)
-{
-	struct smsc95xx_priv *pdata = dev->driver_priv;
-
-	return __smsc95xx_mdio_read(dev, pdata->phydev->mdio.addr, idx, 1);
-}
-
-static void smsc95xx_mdio_write_nopm(struct usbnet *dev, int idx, int regval)
-{
-	struct smsc95xx_priv *pdata = dev->driver_priv;
-
-	__smsc95xx_mdio_write(dev, pdata->phydev->mdio.addr, idx, regval, 1);
-}
-
 static int smsc95xx_mdiobus_read(struct mii_bus *bus, int phy_id, int idx)
 {
 	struct usbnet *dev = bus->priv;
 
-	return __smsc95xx_mdio_read(dev, phy_id, idx, 0);
+	return smsc95xx_mdio_read(dev, phy_id, idx);
 }
 
 static int smsc95xx_mdiobus_write(struct mii_bus *bus, int phy_id, int idx,
@@ -308,7 +268,7 @@ static int smsc95xx_mdiobus_write(struct mii_bus *bus, int phy_id, int idx,
 {
 	struct usbnet *dev = bus->priv;
 
-	__smsc95xx_mdio_write(dev, phy_id, idx, regval, 0);
+	smsc95xx_mdio_write(dev, phy_id, idx, regval);
 	return 0;
 }
 
@@ -868,7 +828,7 @@ static int smsc95xx_start_tx_path(struct usbnet *dev)
 }
 
 /* Starts the Receive path */
-static int smsc95xx_start_rx_path(struct usbnet *dev, int in_pm)
+static int smsc95xx_start_rx_path(struct usbnet *dev)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
 	unsigned long flags;
@@ -877,7 +837,7 @@ static int smsc95xx_start_rx_path(struct usbnet *dev, int in_pm)
 	pdata->mac_cr |= MAC_CR_RXEN_;
 	spin_unlock_irqrestore(&pdata->mac_cr_lock, flags);
 
-	return __smsc95xx_write_reg(dev, MAC_CR, pdata->mac_cr, in_pm);
+	return smsc95xx_write_reg(dev, MAC_CR, pdata->mac_cr);
 }
 
 static int smsc95xx_reset(struct usbnet *dev)
@@ -1060,7 +1020,7 @@ static int smsc95xx_reset(struct usbnet *dev)
 		return ret;
 	}
 
-	ret = smsc95xx_start_rx_path(dev, 0);
+	ret = smsc95xx_start_rx_path(dev);
 	if (ret < 0) {
 		netdev_warn(dev->net, "Failed to start RX path\n");
 		return ret;
@@ -1294,16 +1254,17 @@ static u32 smsc_crc(const u8 *buffer, size_t len, int filter)
 	return crc << ((filter % 2) * 16);
 }
 
-static int smsc95xx_link_ok_nopm(struct usbnet *dev)
+static int smsc95xx_link_ok(struct usbnet *dev)
 {
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int ret;
 
 	/* first, a dummy read, needed to latch some MII phys */
-	ret = smsc95xx_mdio_read_nopm(dev, MII_BMSR);
+	ret = smsc95xx_mdio_read(dev, pdata->phydev->mdio.addr, MII_BMSR);
 	if (ret < 0)
 		return ret;
 
-	ret = smsc95xx_mdio_read_nopm(dev, MII_BMSR);
+	ret = smsc95xx_mdio_read(dev, pdata->phydev->mdio.addr, MII_BMSR);
 	if (ret < 0)
 		return ret;
 
@@ -1316,14 +1277,14 @@ static int smsc95xx_enter_suspend0(struct usbnet *dev)
 	u32 val;
 	int ret;
 
-	ret = smsc95xx_read_reg_nopm(dev, PM_CTRL, &val);
+	ret = smsc95xx_read_reg(dev, PM_CTRL, &val);
 	if (ret < 0)
 		return ret;
 
 	val &= (~(PM_CTL_SUS_MODE_ | PM_CTL_WUPS_ | PM_CTL_PHY_RST_));
 	val |= PM_CTL_SUS_MODE_0;
 
-	ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
+	ret = smsc95xx_write_reg(dev, PM_CTRL, val);
 	if (ret < 0)
 		return ret;
 
@@ -1335,12 +1296,12 @@ static int smsc95xx_enter_suspend0(struct usbnet *dev)
 	if (pdata->wolopts & WAKE_PHY)
 		val |= PM_CTL_WUPS_ED_;
 
-	ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
+	ret = smsc95xx_write_reg(dev, PM_CTRL, val);
 	if (ret < 0)
 		return ret;
 
 	/* read back PM_CTRL */
-	ret = smsc95xx_read_reg_nopm(dev, PM_CTRL, &val);
+	ret = smsc95xx_read_reg(dev, PM_CTRL, &val);
 	if (ret < 0)
 		return ret;
 
@@ -1352,34 +1313,34 @@ static int smsc95xx_enter_suspend0(struct usbnet *dev)
 static int smsc95xx_enter_suspend1(struct usbnet *dev)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
+	int ret, phy_id = pdata->phydev->mdio.addr;
 	u32 val;
-	int ret;
 
 	/* reconfigure link pulse detection timing for
 	 * compatibility with non-standard link partners
 	 */
 	if (pdata->features & FEATURE_PHY_NLP_CROSSOVER)
-		smsc95xx_mdio_write_nopm(dev, PHY_EDPD_CONFIG,
-					 PHY_EDPD_CONFIG_DEFAULT);
+		smsc95xx_mdio_write(dev, phy_id, PHY_EDPD_CONFIG,
+				    PHY_EDPD_CONFIG_DEFAULT);
 
 	/* enable energy detect power-down mode */
-	ret = smsc95xx_mdio_read_nopm(dev, PHY_MODE_CTRL_STS);
+	ret = smsc95xx_mdio_read(dev, phy_id, PHY_MODE_CTRL_STS);
 	if (ret < 0)
 		return ret;
 
 	ret |= MODE_CTRL_STS_EDPWRDOWN_;
 
-	smsc95xx_mdio_write_nopm(dev, PHY_MODE_CTRL_STS, ret);
+	smsc95xx_mdio_write(dev, phy_id, PHY_MODE_CTRL_STS, ret);
 
 	/* enter SUSPEND1 mode */
-	ret = smsc95xx_read_reg_nopm(dev, PM_CTRL, &val);
+	ret = smsc95xx_read_reg(dev, PM_CTRL, &val);
 	if (ret < 0)
 		return ret;
 
 	val &= ~(PM_CTL_SUS_MODE_ | PM_CTL_WUPS_ | PM_CTL_PHY_RST_);
 	val |= PM_CTL_SUS_MODE_1;
 
-	ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
+	ret = smsc95xx_write_reg(dev, PM_CTRL, val);
 	if (ret < 0)
 		return ret;
 
@@ -1387,7 +1348,7 @@ static int smsc95xx_enter_suspend1(struct usbnet *dev)
 	val &= ~PM_CTL_WUPS_;
 	val |= (PM_CTL_WUPS_ED_ | PM_CTL_ED_EN_);
 
-	ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
+	ret = smsc95xx_write_reg(dev, PM_CTRL, val);
 	if (ret < 0)
 		return ret;
 
@@ -1402,14 +1363,14 @@ static int smsc95xx_enter_suspend2(struct usbnet *dev)
 	u32 val;
 	int ret;
 
-	ret = smsc95xx_read_reg_nopm(dev, PM_CTRL, &val);
+	ret = smsc95xx_read_reg(dev, PM_CTRL, &val);
 	if (ret < 0)
 		return ret;
 
 	val &= ~(PM_CTL_SUS_MODE_ | PM_CTL_WUPS_ | PM_CTL_PHY_RST_);
 	val |= PM_CTL_SUS_MODE_2;
 
-	ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
+	ret = smsc95xx_write_reg(dev, PM_CTRL, val);
 	if (ret < 0)
 		return ret;
 
@@ -1424,7 +1385,7 @@ static int smsc95xx_enter_suspend3(struct usbnet *dev)
 	u32 val;
 	int ret;
 
-	ret = smsc95xx_read_reg_nopm(dev, RX_FIFO_INF, &val);
+	ret = smsc95xx_read_reg(dev, RX_FIFO_INF, &val);
 	if (ret < 0)
 		return ret;
 
@@ -1433,14 +1394,14 @@ static int smsc95xx_enter_suspend3(struct usbnet *dev)
 		return -EBUSY;
 	}
 
-	ret = smsc95xx_read_reg_nopm(dev, PM_CTRL, &val);
+	ret = smsc95xx_read_reg(dev, PM_CTRL, &val);
 	if (ret < 0)
 		return ret;
 
 	val &= ~(PM_CTL_SUS_MODE_ | PM_CTL_WUPS_ | PM_CTL_PHY_RST_);
 	val |= PM_CTL_SUS_MODE_3 | PM_CTL_RES_CLR_WKP_STS;
 
-	ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
+	ret = smsc95xx_write_reg(dev, PM_CTRL, val);
 	if (ret < 0)
 		return ret;
 
@@ -1448,7 +1409,7 @@ static int smsc95xx_enter_suspend3(struct usbnet *dev)
 	val &= ~PM_CTL_WUPS_;
 	val |= PM_CTL_WUPS_WOL_;
 
-	ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
+	ret = smsc95xx_write_reg(dev, PM_CTRL, val);
 	if (ret < 0)
 		return ret;
 
@@ -1507,8 +1468,7 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 		pdata->suspend_flags = 0;
 	}
 
-	/* determine if link is up using only _nopm functions */
-	link_up = smsc95xx_link_ok_nopm(dev);
+	link_up = smsc95xx_link_ok(dev);
 
 	if (message.event == PM_EVENT_AUTO_SUSPEND &&
 	    (pdata->features & FEATURE_REMOTE_WAKEUP)) {
@@ -1525,23 +1485,23 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 		netdev_info(dev->net, "entering SUSPEND2 mode\n");
 
 		/* disable energy detect (link up) & wake up events */
-		ret = smsc95xx_read_reg_nopm(dev, WUCSR, &val);
+		ret = smsc95xx_read_reg(dev, WUCSR, &val);
 		if (ret < 0)
 			goto done;
 
 		val &= ~(WUCSR_MPEN_ | WUCSR_WAKE_EN_);
 
-		ret = smsc95xx_write_reg_nopm(dev, WUCSR, val);
+		ret = smsc95xx_write_reg(dev, WUCSR, val);
 		if (ret < 0)
 			goto done;
 
-		ret = smsc95xx_read_reg_nopm(dev, PM_CTRL, &val);
+		ret = smsc95xx_read_reg(dev, PM_CTRL, &val);
 		if (ret < 0)
 			goto done;
 
 		val &= ~(PM_CTL_ED_EN_ | PM_CTL_WOL_EN_);
 
-		ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
+		ret = smsc95xx_write_reg(dev, PM_CTRL, val);
 		if (ret < 0)
 			goto done;
 
@@ -1632,7 +1592,7 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 		}
 
 		for (i = 0; i < (wuff_filter_count * 4); i++) {
-			ret = smsc95xx_write_reg_nopm(dev, WUFF, filter_mask[i]);
+			ret = smsc95xx_write_reg(dev, WUFF, filter_mask[i]);
 			if (ret < 0) {
 				kfree(filter_mask);
 				goto done;
@@ -1641,50 +1601,50 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 		kfree(filter_mask);
 
 		for (i = 0; i < (wuff_filter_count / 4); i++) {
-			ret = smsc95xx_write_reg_nopm(dev, WUFF, command[i]);
+			ret = smsc95xx_write_reg(dev, WUFF, command[i]);
 			if (ret < 0)
 				goto done;
 		}
 
 		for (i = 0; i < (wuff_filter_count / 4); i++) {
-			ret = smsc95xx_write_reg_nopm(dev, WUFF, offset[i]);
+			ret = smsc95xx_write_reg(dev, WUFF, offset[i]);
 			if (ret < 0)
 				goto done;
 		}
 
 		for (i = 0; i < (wuff_filter_count / 2); i++) {
-			ret = smsc95xx_write_reg_nopm(dev, WUFF, crc[i]);
+			ret = smsc95xx_write_reg(dev, WUFF, crc[i]);
 			if (ret < 0)
 				goto done;
 		}
 
 		/* clear any pending pattern match packet status */
-		ret = smsc95xx_read_reg_nopm(dev, WUCSR, &val);
+		ret = smsc95xx_read_reg(dev, WUCSR, &val);
 		if (ret < 0)
 			goto done;
 
 		val |= WUCSR_WUFR_;
 
-		ret = smsc95xx_write_reg_nopm(dev, WUCSR, val);
+		ret = smsc95xx_write_reg(dev, WUCSR, val);
 		if (ret < 0)
 			goto done;
 	}
 
 	if (pdata->wolopts & WAKE_MAGIC) {
 		/* clear any pending magic packet status */
-		ret = smsc95xx_read_reg_nopm(dev, WUCSR, &val);
+		ret = smsc95xx_read_reg(dev, WUCSR, &val);
 		if (ret < 0)
 			goto done;
 
 		val |= WUCSR_MPR_;
 
-		ret = smsc95xx_write_reg_nopm(dev, WUCSR, val);
+		ret = smsc95xx_write_reg(dev, WUCSR, val);
 		if (ret < 0)
 			goto done;
 	}
 
 	/* enable/disable wakeup sources */
-	ret = smsc95xx_read_reg_nopm(dev, WUCSR, &val);
+	ret = smsc95xx_read_reg(dev, WUCSR, &val);
 	if (ret < 0)
 		goto done;
 
@@ -1704,12 +1664,12 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 		val &= ~WUCSR_MPEN_;
 	}
 
-	ret = smsc95xx_write_reg_nopm(dev, WUCSR, val);
+	ret = smsc95xx_write_reg(dev, WUCSR, val);
 	if (ret < 0)
 		goto done;
 
 	/* enable wol wakeup source */
-	ret = smsc95xx_read_reg_nopm(dev, PM_CTRL, &val);
+	ret = smsc95xx_read_reg(dev, PM_CTRL, &val);
 	if (ret < 0)
 		goto done;
 
@@ -1719,12 +1679,12 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 	if (pdata->wolopts & WAKE_PHY)
 		val |= PM_CTL_ED_EN_;
 
-	ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
+	ret = smsc95xx_write_reg(dev, PM_CTRL, val);
 	if (ret < 0)
 		goto done;
 
 	/* enable receiver to enable frame reception */
-	smsc95xx_start_rx_path(dev, 1);
+	smsc95xx_start_rx_path(dev);
 
 	/* some wol options are enabled, so enter SUSPEND0 */
 	netdev_info(dev->net, "entering SUSPEND0 mode\n");
@@ -1763,25 +1723,25 @@ static int smsc95xx_resume(struct usb_interface *intf)
 
 	if (suspend_flags & SUSPEND_ALLMODES) {
 		/* clear wake-up sources */
-		ret = smsc95xx_read_reg_nopm(dev, WUCSR, &val);
+		ret = smsc95xx_read_reg(dev, WUCSR, &val);
 		if (ret < 0)
 			goto done;
 
 		val &= ~(WUCSR_WAKE_EN_ | WUCSR_MPEN_);
 
-		ret = smsc95xx_write_reg_nopm(dev, WUCSR, val);
+		ret = smsc95xx_write_reg(dev, WUCSR, val);
 		if (ret < 0)
 			goto done;
 
 		/* clear wake-up status */
-		ret = smsc95xx_read_reg_nopm(dev, PM_CTRL, &val);
+		ret = smsc95xx_read_reg(dev, PM_CTRL, &val);
 		if (ret < 0)
 			goto done;
 
 		val &= ~PM_CTL_WOL_EN_;
 		val |= PM_CTL_WUPS_;
 
-		ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
+		ret = smsc95xx_write_reg(dev, PM_CTRL, val);
 		if (ret < 0)
 			goto done;
 	}
-- 
2.36.1

