Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BB13D1EF1
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhGVGn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 02:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbhGVGnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 02:43:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE07C061799
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 00:23:52 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m6T3Y-00033Q-JC; Thu, 22 Jul 2021 09:23:44 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m6T3X-0004CG-46; Thu, 22 Jul 2021 09:23:43 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v1 1/1] net: usb: asix: ax88772: do not poll for PHY before registering it
Date:   Thu, 22 Jul 2021 09:23:38 +0200
Message-Id: <20210722072338.16083-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

asix_get_phyid() is used for two reasons here. To print debug message
with the PHY ID and to wait until the PHY is powered up.

After migrating to the phylib, we can read PHYID from sysfs. If polling
for the PHY is really needed, then we will need to handle it in the
phylib as well.

This change was tested with:
- ax88772a + internal PHY
- ax88772b + external PHY

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/asix_devices.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 2c115216420a..049c20342a0b 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -714,7 +714,6 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 	u8 buf[ETH_ALEN] = {0}, chipcode = 0;
 	struct asix_common_private *priv;
 	int ret, i;
-	u32 phyid;
 
 	usbnet_get_endpoints(dev, intf);
 
@@ -762,10 +761,6 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 		return ret;
 	}
 
-	/* Read PHYID register *AFTER* the PHY was reset properly */
-	phyid = asix_get_phyid(dev);
-	netdev_dbg(dev->net, "PHYID=0x%08x\n", phyid);
-
 	/* Asix framing packs multiple eth frames into a 2K usb bulk transfer */
 	if (dev->driver_info->flags & FLAG_FRAMING_AX) {
 		/* hard_mtu  is still the default - the device does not support
-- 
2.30.2

