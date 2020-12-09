Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A862B2D4217
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 13:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731503AbgLIMVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 07:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731475AbgLIMVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 07:21:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6654DC061793
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 04:21:01 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kmySm-0001Qs-R2; Wed, 09 Dec 2020 13:20:56 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kmySi-0006qb-Q4; Wed, 09 Dec 2020 13:20:52 +0100
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
Subject: [PATCH v1] ARM: imx: mach-imx6ul: remove 14x14 EVK specific PHY fixup
Date:   Wed,  9 Dec 2020 13:20:51 +0100
Message-Id: <20201209122051.26151-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove board specific PHY fixup introduced by commit:

| 709bc0657fe6f9f5 ("ARM: imx6ul: add fec MAC refrence clock and phy fixup init")

This fixup addresses boards with a specific configuration: a KSZ8081RNA
PHY with attached clock source to XI (Pin 8) of the PHY equal to 50MHz.

For the KSZ8081RND PHY, the meaning of the reg 0x1F bit 7 is different
(compared to the KSZ8081RNA). A set bit means:

- KSZ8081RNA: clock input to XI (Pin 8) is 50MHz for RMII
- KSZ8081RND: clock input to XI (Pin 8) is 25MHz for RMII

In other configurations, for example a KSZ8081RND PHY or a KSZ8081RNA
with 25Mhz clock source, the PHY will glitch and stay in not recoverable
state.

It is not possible to detect the clock source frequency of the PHY. And
it is not possible to automatically detect KSZ8081 PHY variant - both
have same PHY ID. It is not possible to overwrite the fixup
configuration by providing proper device tree description. The only way
is to remove this fixup.

If this patch breaks network functionality on your board, fix it by
adding PHY node with following properties:

	ethernet-phy@x {
		...
		micrel,led-mode = <1>;
		clocks = <&clks IMX6UL_CLK_ENET_REF>;
		clock-names = "rmii-ref";
		...
	};

The board which was referred in the initial patch is already fixed.
See: arch/arm/boot/dts/imx6ul-14x14-evk.dtsi

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/arm/mach-imx/mach-imx6ul.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx6ul.c b/arch/arm/mach-imx/mach-imx6ul.c
index e018e716735f..eabcd35c01a5 100644
--- a/arch/arm/mach-imx/mach-imx6ul.c
+++ b/arch/arm/mach-imx/mach-imx6ul.c
@@ -27,30 +27,9 @@ static void __init imx6ul_enet_clk_init(void)
 		pr_err("failed to find fsl,imx6ul-iomux-gpr regmap\n");
 }
 
-static int ksz8081_phy_fixup(struct phy_device *dev)
-{
-	if (dev && dev->interface == PHY_INTERFACE_MODE_MII) {
-		phy_write(dev, 0x1f, 0x8110);
-		phy_write(dev, 0x16, 0x201);
-	} else if (dev && dev->interface == PHY_INTERFACE_MODE_RMII) {
-		phy_write(dev, 0x1f, 0x8190);
-		phy_write(dev, 0x16, 0x202);
-	}
-
-	return 0;
-}
-
-static void __init imx6ul_enet_phy_init(void)
-{
-	if (IS_BUILTIN(CONFIG_PHYLIB))
-		phy_register_fixup_for_uid(PHY_ID_KSZ8081, MICREL_PHY_ID_MASK,
-					   ksz8081_phy_fixup);
-}
-
 static inline void imx6ul_enet_init(void)
 {
 	imx6ul_enet_clk_init();
-	imx6ul_enet_phy_init();
 }
 
 static void __init imx6ul_init_machine(void)
-- 
2.29.2

