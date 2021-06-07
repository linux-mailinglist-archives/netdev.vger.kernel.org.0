Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC89239D74C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 10:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhFGI3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 04:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbhFGI33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 04:29:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AAAC06178B
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 01:27:38 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lqAbb-0004fH-Tt; Mon, 07 Jun 2021 10:27:31 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lqAbb-0006oJ-Az; Mon, 07 Jun 2021 10:27:31 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2 6/8] net: usb: asix: add error handling for asix_mdio_* functions
Date:   Mon,  7 Jun 2021 10:27:25 +0200
Message-Id: <20210607082727.26045-7-o.rempel@pengutronix.de>
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

This usb devices can be removed at any time, so we need to forward
correct error value if device was detached.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/usb/asix_common.c | 42 +++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 085bc8281082..ac92bc52a85e 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -485,18 +485,23 @@ int asix_mdio_read(struct net_device *netdev, int phy_id, int loc)
 		return ret;
 	}
 
-	asix_read_cmd(dev, AX_CMD_READ_MII_REG, phy_id,
-				(__u16)loc, 2, &res, 0);
-	asix_set_hw_mii(dev, 0);
+	ret = asix_read_cmd(dev, AX_CMD_READ_MII_REG, phy_id, (__u16)loc, 2,
+			    &res, 0);
+	if (ret < 0)
+		goto out;
+
+	ret = asix_set_hw_mii(dev, 0);
+out:
 	mutex_unlock(&dev->phy_mutex);
 
 	netdev_dbg(dev->net, "asix_mdio_read() phy_id=0x%02x, loc=0x%02x, returns=0x%04x\n",
 			phy_id, loc, le16_to_cpu(res));
 
-	return le16_to_cpu(res);
+	return ret < 0 ? ret : le16_to_cpu(res);
 }
 
-void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val)
+static int __asix_mdio_write(struct net_device *netdev, int phy_id, int loc,
+			     int val)
 {
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res = cpu_to_le16(val);
@@ -516,15 +521,25 @@ void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val)
 		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
 				    0, 0, 1, &smsr, 0);
 	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
-	if (ret == -ENODEV) {
-		mutex_unlock(&dev->phy_mutex);
-		return;
-	}
 
-	asix_write_cmd(dev, AX_CMD_WRITE_MII_REG, phy_id,
-		       (__u16)loc, 2, &res, 0);
-	asix_set_hw_mii(dev, 0);
+	if (ret == -ENODEV)
+		goto out;
+
+	ret = asix_write_cmd(dev, AX_CMD_WRITE_MII_REG, phy_id, (__u16)loc, 2,
+			     &res, 0);
+	if (ret < 0)
+		goto out;
+
+	ret = asix_set_hw_mii(dev, 0);
+out:
 	mutex_unlock(&dev->phy_mutex);
+
+	return ret < 0 ? ret : 0;
+}
+
+void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val)
+{
+	__asix_mdio_write(netdev, phy_id, loc, val);
 }
 
 /* MDIO read and write wrappers for phylib */
@@ -539,8 +554,7 @@ int asix_mdio_bus_write(struct mii_bus *bus, int phy_id, int regnum, u16 val)
 {
 	struct usbnet *priv = bus->priv;
 
-	asix_mdio_write(priv->net, phy_id, regnum, val);
-	return 0;
+	return __asix_mdio_write(priv->net, phy_id, regnum, val);
 }
 
 int asix_mdio_read_nopm(struct net_device *netdev, int phy_id, int loc)
-- 
2.29.2

