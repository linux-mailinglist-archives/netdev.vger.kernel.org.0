Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC739D74F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 10:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhFGI3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 04:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbhFGI33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 04:29:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B87C0617A6
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 01:27:38 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lqAbb-0004f4-Md; Mon, 07 Jun 2021 10:27:31 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lqAbb-0006nj-7I; Mon, 07 Jun 2021 10:27:31 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/8] net: usb: asix: refactor asix_read_phy_addr() and handle errors on return
Date:   Mon,  7 Jun 2021 10:27:21 +0200
Message-Id: <20210607082727.26045-3-o.rempel@pengutronix.de>
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

Refactor asix_read_phy_addr() to return usable error value directly and
make sure all callers handle this error.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/asix.h         |  3 +--
 drivers/net/usb/asix_common.c  | 31 ++++++++++++++++---------------
 drivers/net/usb/asix_devices.c | 15 ++++++++++++---
 drivers/net/usb/ax88172a.c     |  5 +++++
 4 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index 3b53685301de..edb94efd265e 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -205,8 +205,7 @@ struct sk_buff *asix_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 int asix_set_sw_mii(struct usbnet *dev, int in_pm);
 int asix_set_hw_mii(struct usbnet *dev, int in_pm);
 
-int asix_read_phy_addr(struct usbnet *dev, int internal);
-int asix_get_phy_addr(struct usbnet *dev);
+int asix_read_phy_addr(struct usbnet *dev, bool internal);
 
 int asix_sw_reset(struct usbnet *dev, u8 flags, int in_pm);
 
diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 7bc6e8f856fe..e1109f1a8dd5 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -288,32 +288,33 @@ int asix_set_hw_mii(struct usbnet *dev, int in_pm)
 	return ret;
 }
 
-int asix_read_phy_addr(struct usbnet *dev, int internal)
+int asix_read_phy_addr(struct usbnet *dev, bool internal)
 {
-	int offset = (internal ? 1 : 0);
+	int ret, offset;
 	u8 buf[2];
-	int ret = asix_read_cmd(dev, AX_CMD_READ_PHY_ID, 0, 0, 2, buf, 0);
 
-	netdev_dbg(dev->net, "asix_get_phy_addr()\n");
+	ret = asix_read_cmd(dev, AX_CMD_READ_PHY_ID, 0, 0, 2, buf, 0);
+	if (ret < 0)
+		goto error;
 
 	if (ret < 2) {
-		netdev_err(dev->net, "Error reading PHYID register: %02x\n", ret);
-		goto out;
+		ret = -EIO;
+		goto error;
 	}
-	netdev_dbg(dev->net, "asix_get_phy_addr() returning 0x%04x\n",
-		   *((__le16 *)buf));
+
+	offset = (internal ? 1 : 0);
 	ret = buf[offset];
 
-out:
+	netdev_dbg(dev->net, "%s PHY address 0x%x\n",
+		   internal ? "internal" : "external", ret);
+
 	return ret;
-}
 
-int asix_get_phy_addr(struct usbnet *dev)
-{
-	/* return the address of the internal phy */
-	return asix_read_phy_addr(dev, 1);
-}
+error:
+	netdev_err(dev->net, "Error reading PHY_ID register: %02x\n", ret);
 
+	return ret;
+}
 
 int asix_sw_reset(struct usbnet *dev, u8 flags, int in_pm)
 {
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 5f767a33264e..00b6ac0570eb 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -262,7 +262,10 @@ static int ax88172_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->mii.mdio_write = asix_mdio_write;
 	dev->mii.phy_id_mask = 0x3f;
 	dev->mii.reg_num_mask = 0x1f;
-	dev->mii.phy_id = asix_get_phy_addr(dev);
+
+	dev->mii.phy_id = asix_read_phy_addr(dev, true);
+	if (dev->mii.phy_id < 0)
+		return dev->mii.phy_id;
 
 	dev->net->netdev_ops = &ax88172_netdev_ops;
 	dev->net->ethtool_ops = &ax88172_ethtool_ops;
@@ -717,7 +720,10 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->mii.mdio_write = asix_mdio_write;
 	dev->mii.phy_id_mask = 0x1f;
 	dev->mii.reg_num_mask = 0x1f;
-	dev->mii.phy_id = asix_get_phy_addr(dev);
+
+	dev->mii.phy_id = asix_read_phy_addr(dev, true);
+	if (dev->mii.phy_id < 0)
+		return dev->mii.phy_id;
 
 	dev->net->netdev_ops = &ax88772_netdev_ops;
 	dev->net->ethtool_ops = &ax88772_ethtool_ops;
@@ -1080,7 +1086,10 @@ static int ax88178_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->mii.phy_id_mask = 0x1f;
 	dev->mii.reg_num_mask = 0xff;
 	dev->mii.supports_gmii = 1;
-	dev->mii.phy_id = asix_get_phy_addr(dev);
+
+	dev->mii.phy_id = asix_read_phy_addr(dev, true);
+	if (dev->mii.phy_id < 0)
+		return dev->mii.phy_id;
 
 	dev->net->netdev_ops = &ax88178_netdev_ops;
 	dev->net->ethtool_ops = &ax88178_ethtool_ops;
diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index b404c9462dce..c8ca5187eece 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -220,6 +220,11 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
 	}
 
 	priv->phy_addr = asix_read_phy_addr(dev, priv->use_embdphy);
+	if (priv->phy_addr < 0) {
+		ret = priv->phy_addr;
+		goto free;
+	}
+
 	ax88172a_reset_phy(dev, priv->use_embdphy);
 
 	/* Asix framing packs multiple eth frames into a 2K usb bulk transfer */
-- 
2.29.2

