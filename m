Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0584C10FE
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 12:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239743AbiBWLHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 06:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239750AbiBWLHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 06:07:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E94C366B8
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 03:06:47 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nMpTh-0005jo-Nk; Wed, 23 Feb 2022 12:06:37 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nMpTg-00Cc9d-KQ; Wed, 23 Feb 2022 12:06:36 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com
Subject: [PATCH net-next v1 1/1] net: asix: remove code duplicates in asix_mdio_read/write and asix_mdio_read/write_nopm
Date:   Wed, 23 Feb 2022 12:06:33 +0100
Message-Id: <20220223110633.3006551-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
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

This functions are mostly same except of one hard coded "in_pm" variable.
So, rework them to reduce maintenance overhead.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/asix_common.c | 74 +++++++++--------------------------
 1 file changed, 19 insertions(+), 55 deletions(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 524805285019..632fa6c1d5e3 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -491,7 +491,8 @@ void asix_set_multicast(struct net_device *net)
 	asix_write_cmd_async(dev, AX_CMD_WRITE_RX_CTL, rx_ctl, 0, 0, NULL);
 }
 
-int asix_mdio_read(struct net_device *netdev, int phy_id, int loc)
+static int __asix_mdio_read(struct net_device *netdev, int phy_id, int loc,
+			    bool in_pm)
 {
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res;
@@ -499,18 +500,18 @@ int asix_mdio_read(struct net_device *netdev, int phy_id, int loc)
 
 	mutex_lock(&dev->phy_mutex);
 
-	ret = asix_check_host_enable(dev, 0);
+	ret = asix_check_host_enable(dev, in_pm);
 	if (ret == -ENODEV || ret == -ETIMEDOUT) {
 		mutex_unlock(&dev->phy_mutex);
 		return ret;
 	}
 
 	ret = asix_read_cmd(dev, AX_CMD_READ_MII_REG, phy_id, (__u16)loc, 2,
-			    &res, 0);
+			    &res, in_pm);
 	if (ret < 0)
 		goto out;
 
-	ret = asix_set_hw_mii(dev, 0);
+	ret = asix_set_hw_mii(dev, in_pm);
 out:
 	mutex_unlock(&dev->phy_mutex);
 
@@ -520,8 +521,13 @@ int asix_mdio_read(struct net_device *netdev, int phy_id, int loc)
 	return ret < 0 ? ret : le16_to_cpu(res);
 }
 
+int asix_mdio_read(struct net_device *netdev, int phy_id, int loc)
+{
+	return __asix_mdio_read(netdev, phy_id, loc, false);
+}
+
 static int __asix_mdio_write(struct net_device *netdev, int phy_id, int loc,
-			     int val)
+			     int val, bool in_pm)
 {
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res = cpu_to_le16(val);
@@ -532,16 +538,16 @@ static int __asix_mdio_write(struct net_device *netdev, int phy_id, int loc,
 
 	mutex_lock(&dev->phy_mutex);
 
-	ret = asix_check_host_enable(dev, 0);
+	ret = asix_check_host_enable(dev, in_pm);
 	if (ret == -ENODEV)
 		goto out;
 
 	ret = asix_write_cmd(dev, AX_CMD_WRITE_MII_REG, phy_id, (__u16)loc, 2,
-			     &res, 0);
+			     &res, in_pm);
 	if (ret < 0)
 		goto out;
 
-	ret = asix_set_hw_mii(dev, 0);
+	ret = asix_set_hw_mii(dev, in_pm);
 out:
 	mutex_unlock(&dev->phy_mutex);
 
@@ -550,7 +556,7 @@ static int __asix_mdio_write(struct net_device *netdev, int phy_id, int loc,
 
 void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val)
 {
-	__asix_mdio_write(netdev, phy_id, loc, val);
+	__asix_mdio_write(netdev, phy_id, loc, val, false);
 }
 
 /* MDIO read and write wrappers for phylib */
@@ -558,67 +564,25 @@ int asix_mdio_bus_read(struct mii_bus *bus, int phy_id, int regnum)
 {
 	struct usbnet *priv = bus->priv;
 
-	return asix_mdio_read(priv->net, phy_id, regnum);
+	return __asix_mdio_read(priv->net, phy_id, regnum, false);
 }
 
 int asix_mdio_bus_write(struct mii_bus *bus, int phy_id, int regnum, u16 val)
 {
 	struct usbnet *priv = bus->priv;
 
-	return __asix_mdio_write(priv->net, phy_id, regnum, val);
+	return __asix_mdio_write(priv->net, phy_id, regnum, val, false);
 }
 
 int asix_mdio_read_nopm(struct net_device *netdev, int phy_id, int loc)
 {
-	struct usbnet *dev = netdev_priv(netdev);
-	__le16 res;
-	int ret;
-
-	mutex_lock(&dev->phy_mutex);
-
-	ret = asix_check_host_enable(dev, 1);
-	if (ret == -ENODEV || ret == -ETIMEDOUT) {
-		mutex_unlock(&dev->phy_mutex);
-		return ret;
-	}
-
-	ret = asix_read_cmd(dev, AX_CMD_READ_MII_REG, phy_id,
-			    (__u16)loc, 2, &res, 1);
-	if (ret < 0) {
-		mutex_unlock(&dev->phy_mutex);
-		return ret;
-	}
-	asix_set_hw_mii(dev, 1);
-	mutex_unlock(&dev->phy_mutex);
-
-	netdev_dbg(dev->net, "asix_mdio_read_nopm() phy_id=0x%02x, loc=0x%02x, returns=0x%04x\n",
-			phy_id, loc, le16_to_cpu(res));
-
-	return le16_to_cpu(res);
+	return __asix_mdio_read(netdev, phy_id, loc, true);
 }
 
 void
 asix_mdio_write_nopm(struct net_device *netdev, int phy_id, int loc, int val)
 {
-	struct usbnet *dev = netdev_priv(netdev);
-	__le16 res = cpu_to_le16(val);
-	int ret;
-
-	netdev_dbg(dev->net, "asix_mdio_write() phy_id=0x%02x, loc=0x%02x, val=0x%04x\n",
-			phy_id, loc, val);
-
-	mutex_lock(&dev->phy_mutex);
-
-	ret = asix_check_host_enable(dev, 1);
-	if (ret == -ENODEV) {
-		mutex_unlock(&dev->phy_mutex);
-		return;
-	}
-
-	asix_write_cmd(dev, AX_CMD_WRITE_MII_REG, phy_id,
-		       (__u16)loc, 2, &res, 1);
-	asix_set_hw_mii(dev, 1);
-	mutex_unlock(&dev->phy_mutex);
+	__asix_mdio_write(netdev, phy_id, loc, val, true);
 }
 
 void asix_get_wol(struct net_device *net, struct ethtool_wolinfo *wolinfo)
-- 
2.30.2

