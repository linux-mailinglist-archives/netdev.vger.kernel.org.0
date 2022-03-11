Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664414D5DE2
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 09:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238008AbiCKIvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 03:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241908AbiCKIvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 03:51:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C6D1BA93A
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 00:50:29 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nSayY-0004dq-AT; Fri, 11 Mar 2022 09:50:18 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nSayV-00552m-My; Fri, 11 Mar 2022 09:50:15 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com
Subject: [PATCH net-next v2 2/4] net: usb: asix: store chipid to avoid reading it on reset
Date:   Fri, 11 Mar 2022 09:50:12 +0100
Message-Id: <20220311085014.1210963-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220311085014.1210963-1-o.rempel@pengutronix.de>
References: <20220311085014.1210963-1-o.rempel@pengutronix.de>
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

We already read chipid on probe. There is no need to read it on reset.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/asix.h         |  1 +
 drivers/net/usb/asix_devices.c | 19 +++++++------------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index b5ac693cebf2..691f37f45238 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -186,6 +186,7 @@ struct asix_common_private {
 	u16 phy_addr;
 	char phy_name[20];
 	bool embd_phy;
+	u8 chipcode;
 };
 
 extern const struct driver_info ax88172a_info;
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 28bb98cdfa33..a0c02cd53472 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -450,7 +450,6 @@ static int ax88772a_hw_reset(struct usbnet *dev, int in_pm)
 	struct asix_data *data = (struct asix_data *)&dev->data;
 	struct asix_common_private *priv = dev->driver_priv;
 	u16 rx_ctl, phy14h, phy15h, phy16h;
-	u8 chipcode = 0;
 	int ret;
 
 	ret = asix_write_gpio(dev, AX_GPIO_RSE, 5, in_pm);
@@ -493,12 +492,7 @@ static int ax88772a_hw_reset(struct usbnet *dev, int in_pm)
 		goto out;
 	}
 
-	ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0,
-			    0, 1, &chipcode, in_pm);
-	if (ret < 0)
-		goto out;
-
-	if ((chipcode & AX_CHIPCODE_MASK) == AX_AX88772B_CHIPCODE) {
+	if (priv->chipcode == AX_AX88772B_CHIPCODE) {
 		ret = asix_write_cmd(dev, AX_QCTCTRL, 0x8000, 0x8001,
 				     0, NULL, in_pm);
 		if (ret < 0) {
@@ -506,7 +500,7 @@ static int ax88772a_hw_reset(struct usbnet *dev, int in_pm)
 				   ret);
 			goto out;
 		}
-	} else if ((chipcode & AX_CHIPCODE_MASK) == AX_AX88772A_CHIPCODE) {
+	} else if (priv->chipcode == AX_AX88772A_CHIPCODE) {
 		/* Check if the PHY registers have default settings */
 		phy14h = asix_mdio_read_nopm(dev->net, dev->mii.phy_id,
 					     AX88772A_PHY14H);
@@ -689,8 +683,8 @@ static int ax88772_init_phy(struct usbnet *dev)
 
 static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 {
-	u8 buf[ETH_ALEN] = {0}, chipcode = 0;
 	struct asix_common_private *priv;
+	u8 buf[ETH_ALEN] = {0};
 	int ret, i;
 
 	priv = devm_kzalloc(&dev->udev->dev, sizeof(*priv), GFP_KERNEL);
@@ -741,17 +735,18 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 	priv->phy_addr = ret;
 	priv->embd_phy = ((priv->phy_addr & 0x1f) == 0x10);
 
-	ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0, 0, 1, &chipcode, 0);
+	ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0, 0, 1,
+			    &priv->chipcode, 0);
 	if (ret < 0) {
 		netdev_dbg(dev->net, "Failed to read STATMNGSTS_REG: %d\n", ret);
 		return ret;
 	}
 
-	chipcode &= AX_CHIPCODE_MASK;
+	priv->chipcode &= AX_CHIPCODE_MASK;
 
 	priv->resume = ax88772_resume;
 	priv->suspend = ax88772_suspend;
-	if (chipcode == AX_AX88772_CHIPCODE)
+	if (priv->chipcode == AX_AX88772_CHIPCODE)
 		priv->reset = ax88772_hw_reset;
 	else
 		priv->reset = ax88772a_hw_reset;
-- 
2.30.2

