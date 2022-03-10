Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163C14D4628
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 12:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241789AbiCJLpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 06:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241723AbiCJLpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 06:45:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6044314560F
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 03:44:49 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nSHDh-0001NO-34; Thu, 10 Mar 2022 12:44:37 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nSHDf-00EXXl-C5; Thu, 10 Mar 2022 12:44:35 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com
Subject: [PATCH net-next v1 1/4] net: usb: asix: unify ax88772_resume code
Date:   Thu, 10 Mar 2022 12:44:31 +0100
Message-Id: <20220310114434.3465481-1-o.rempel@pengutronix.de>
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

The only difference is the reset code, so remove not needed duplicates.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/asix.h         |  1 +
 drivers/net/usb/asix_devices.c | 32 ++++++++------------------------
 2 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index 4334aafab59a..b5ac693cebf2 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -177,6 +177,7 @@ struct asix_rx_fixup_info {
 struct asix_common_private {
 	void (*resume)(struct usbnet *dev);
 	void (*suspend)(struct usbnet *dev);
+	int (*reset)(struct usbnet *dev, int in_pm);
 	u16 presvd_phy_advertise;
 	u16 presvd_phy_bmcr;
 	struct asix_rx_fixup_info rx_fixup_info;
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 6ea44e53713a..bb09181596c5 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -625,27 +625,13 @@ static void ax88772_resume(struct usbnet *dev)
 	int i;
 
 	for (i = 0; i < 3; i++)
-		if (!ax88772_hw_reset(dev, 1))
+		if (!priv->reset(dev, 1))
 			break;
 
 	if (netif_running(dev->net))
 		phy_start(priv->phydev);
 }
 
-static void ax88772a_resume(struct usbnet *dev)
-{
-	struct asix_common_private *priv = dev->driver_priv;
-	int i;
-
-	for (i = 0; i < 3; i++) {
-		if (!ax88772a_hw_reset(dev, 1))
-			break;
-	}
-
-	if (netif_running(dev->net))
-		phy_start(priv->phydev);
-}
-
 static int asix_resume(struct usb_interface *intf)
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
@@ -763,9 +749,14 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	chipcode &= AX_CHIPCODE_MASK;
 
-	ret = (chipcode == AX_AX88772_CHIPCODE) ? ax88772_hw_reset(dev, 0) :
-						  ax88772a_hw_reset(dev, 0);
+	priv->resume = ax88772_resume;
+	priv->suspend = ax88772_suspend;
+	if (chipcode == AX_AX88772_CHIPCODE)
+		priv->reset = ax88772_hw_reset;
+	else
+		priv->reset = ax88772a_hw_reset;
 
+	ret = priv->reset(dev, 0);
 	if (ret < 0) {
 		netdev_dbg(dev->net, "Failed to reset AX88772: %d\n", ret);
 		return ret;
@@ -780,13 +771,6 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	priv->presvd_phy_bmcr = 0;
 	priv->presvd_phy_advertise = 0;
-	if (chipcode == AX_AX88772_CHIPCODE) {
-		priv->resume = ax88772_resume;
-		priv->suspend = ax88772_suspend;
-	} else {
-		priv->resume = ax88772a_resume;
-		priv->suspend = ax88772_suspend;
-	}
 
 	ret = ax88772_init_mdio(dev);
 	if (ret)
-- 
2.30.2

