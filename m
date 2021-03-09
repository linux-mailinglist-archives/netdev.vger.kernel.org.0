Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416413323F4
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 12:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhCIL0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 06:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhCIL03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 06:26:29 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32538C06175F
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 03:26:29 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lJaVF-0006wj-8H; Tue, 09 Mar 2021 12:26:17 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lJaVE-0000CO-7b; Tue, 09 Mar 2021 12:26:16 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH v2 7/7] ARM: imx7d: remove Atheros AR8031 PHY fixup
Date:   Tue,  9 Mar 2021 12:26:15 +0100
Message-Id: <20210309112615.625-8-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309112615.625-1-o.rempel@pengutronix.de>
References: <20210309112615.625-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixup configures the IO voltage and disables the SmartEEE
functionality.

If this patch breaks your system, enable AT803X_PHY driver and configure
the PHY by the device tree:

	phy-connection-type = "rgmii-id";
	ethernet-phy@X {
		reg = <0xX>;

		qca,smarteee-tw-us-1g = <24>;

		vddio-supply = <&vddh>;

		vddio: vddio-regulator {
			regulator-name = "VDDIO";
			regulator-min-microvolt = <1800000>;
			regulator-max-microvolt = <1800000>;
		};

		vddh: vddh-regulator {
			regulator-name = "VDDH";
		};
	};

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/arm/mach-imx/mach-imx7d.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx7d.c b/arch/arm/mach-imx/mach-imx7d.c
index 879c35929a13..ccf64ddf8b7e 100644
--- a/arch/arm/mach-imx/mach-imx7d.c
+++ b/arch/arm/mach-imx/mach-imx7d.c
@@ -14,25 +14,6 @@
 
 #include "common.h"
 
-static int ar8031_phy_fixup(struct phy_device *dev)
-{
-	u16 val;
-
-	/* Set RGMII IO voltage to 1.8V */
-	phy_write(dev, 0x1d, 0x1f);
-	phy_write(dev, 0x1e, 0x8);
-
-	/* disable phy AR8031 SmartEEE function. */
-	phy_write(dev, 0xd, 0x3);
-	phy_write(dev, 0xe, 0x805d);
-	phy_write(dev, 0xd, 0x4003);
-	val = phy_read(dev, 0xe);
-	val &= ~(0x1 << 8);
-	phy_write(dev, 0xe, val);
-
-	return 0;
-}
-
 static int bcm54220_phy_fixup(struct phy_device *dev)
 {
 	/* enable RXC skew select RGMII copper mode */
@@ -44,14 +25,11 @@ static int bcm54220_phy_fixup(struct phy_device *dev)
 	return 0;
 }
 
-#define PHY_ID_AR8031	0x004dd074
 #define PHY_ID_BCM54220	0x600d8589
 
 static void __init imx7d_enet_phy_init(void)
 {
 	if (IS_BUILTIN(CONFIG_PHYLIB)) {
-		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffff,
-					   ar8031_phy_fixup);
 		phy_register_fixup_for_uid(PHY_ID_BCM54220, 0xffffffff,
 					   bcm54220_phy_fixup);
 	}
-- 
2.29.2

