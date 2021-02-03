Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A0C30D627
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 10:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbhBCJV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 04:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbhBCJU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 04:20:28 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97358C06178C
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 01:19:11 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1l7EJP-0003qz-TT; Wed, 03 Feb 2021 10:18:59 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1l7EJO-0004R0-7R; Wed, 03 Feb 2021 10:18:58 +0100
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
Subject: [PATCH v1 6/7] ARM: imx6sx: remove Atheros AR8031 PHY fixup
Date:   Wed,  3 Feb 2021 10:18:56 +0100
Message-Id: <20210203091857.16936-7-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210203091857.16936-1-o.rempel@pengutronix.de>
References: <20210203091857.16936-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If this patch breaks your system, enable AT803X_PHY driver and add a PHY
node to the board device tree:

	phy-connection-type = "rgmii-txid"; (or rgmii-id)
	ethernet-phy@X {
		reg = <0xX>;

		qca,clk-out-frequency = <125000000>;

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
 arch/arm/mach-imx/mach-imx6sx.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx6sx.c b/arch/arm/mach-imx/mach-imx6sx.c
index 781e2a94fdd7..e65ed5218f53 100644
--- a/arch/arm/mach-imx/mach-imx6sx.c
+++ b/arch/arm/mach-imx/mach-imx6sx.c
@@ -15,31 +15,6 @@
 #include "common.h"
 #include "cpuidle.h"
 
-static int ar8031_phy_fixup(struct phy_device *dev)
-{
-	u16 val;
-
-	/* Set RGMII IO voltage to 1.8V */
-	phy_write(dev, 0x1d, 0x1f);
-	phy_write(dev, 0x1e, 0x8);
-
-	/* introduce tx clock delay */
-	phy_write(dev, 0x1d, 0x5);
-	val = phy_read(dev, 0x1e);
-	val |= 0x0100;
-	phy_write(dev, 0x1e, val);
-
-	return 0;
-}
-
-#define PHY_ID_AR8031   0x004dd074
-static void __init imx6sx_enet_phy_init(void)
-{
-	if (IS_BUILTIN(CONFIG_PHYLIB))
-		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffff,
-					   ar8031_phy_fixup);
-}
-
 static void __init imx6sx_enet_clk_sel(void)
 {
 	struct regmap *gpr;
@@ -57,7 +32,6 @@ static void __init imx6sx_enet_clk_sel(void)
 
 static inline void imx6sx_enet_init(void)
 {
-	imx6sx_enet_phy_init();
 	imx6sx_enet_clk_sel();
 }
 
-- 
2.30.0

