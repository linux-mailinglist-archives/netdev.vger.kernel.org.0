Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279E53323F6
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 12:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhCIL0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 06:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbhCIL0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 06:26:33 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5173C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 03:26:32 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lJaVF-0006wc-8A; Tue, 09 Mar 2021 12:26:17 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lJaVE-0000BD-1Y; Tue, 09 Mar 2021 12:26:16 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v2 1/7] ARM: imx6q: remove PHY fixup for KSZ9031
Date:   Tue,  9 Mar 2021 12:26:09 +0100
Message-Id: <20210309112615.625-2-o.rempel@pengutronix.de>
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

Starting with:

    bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")

the micrel phy driver started respecting phy-mode for the KSZ9031 PHY.
At least with kernel v5.8 configuration provided by this fixup was
overwritten by the micrel driver.

This fixup was providing following configuration:

RX path: 2.58ns delay
    rx -0.42 (left shift) + rx_clk  +0.96ns (right shift) =
        1,38 + 1,2 internal RX delay = 2.58ns
TX path: 0.96ns delay
    tx (no delay) + tx_clk 0.96ns (right shift) = 0.96ns

This configuration is outside of the recommended RGMII clock skew delays
and about in the middle of: rgmii-idrx and rgmii-id

Since most embedded systems do not have enough place to introduce
significant clock skew, rgmii-id is the way to go.

In case this patch breaks network functionality on your system, build
kernel with enabled MICREL_PHY. If it is still not working then try
following device tree options:
1. Set (or change) phy-mode in DT to:
   phy-mode = "rgmii-id";
   This actives internal delay for both RX and TX.
1. Set (or change) phy-mode in DT to:
   phy-mode = "rgmii-idrx";
   This actives internal delay for RX only.
3. Use following DT properties:
   phy-mode = "rgmii";
   txen-skew-psec = <0>;
   rxdv-skew-psec = <0>;
   rxd0-skew-psec = <0>;
   rxd1-skew-psec = <0>;
   rxd2-skew-psec = <0>;
   rxd3-skew-psec = <0>;
   rxc-skew-psec = <1860>;
   txc-skew-psec = <1860>;
   This activates the internal delays for RX and TX, with the value as
   the fixup that is removed in this patch.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Philippe Schenker <philippe.schenker@toradex.com>
---
 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts |  2 +-
 arch/arm/mach-imx/mach-imx6q.c          | 23 -----------------------
 2 files changed, 1 insertion(+), 24 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts b/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
index fa2307d8ce86..c713ac03b3b9 100644
--- a/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
+++ b/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
@@ -112,7 +112,7 @@ flash: m25p80@0 {
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
 	phy-supply = <&vgen2_1v2_eth>;
 	status = "okay";
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 703998ebb52e..78205f90da27 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -40,27 +40,6 @@ static int ksz9021rn_phy_fixup(struct phy_device *phydev)
 	return 0;
 }
 
-static void mmd_write_reg(struct phy_device *dev, int device, int reg, int val)
-{
-	phy_write(dev, 0x0d, device);
-	phy_write(dev, 0x0e, reg);
-	phy_write(dev, 0x0d, (1 << 14) | device);
-	phy_write(dev, 0x0e, val);
-}
-
-static int ksz9031rn_phy_fixup(struct phy_device *dev)
-{
-	/*
-	 * min rx data delay, max rx/tx clock delay,
-	 * min rx/tx control delay
-	 */
-	mmd_write_reg(dev, 2, 4, 0);
-	mmd_write_reg(dev, 2, 5, 0);
-	mmd_write_reg(dev, 2, 8, 0x003ff);
-
-	return 0;
-}
-
 /*
  * fixup for PLX PEX8909 bridge to configure GPIO1-7 as output High
  * as they are used for slots1-7 PERST#
@@ -152,8 +131,6 @@ static void __init imx6q_enet_phy_init(void)
 	if (IS_BUILTIN(CONFIG_PHYLIB)) {
 		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
 				ksz9021rn_phy_fixup);
-		phy_register_fixup_for_uid(PHY_ID_KSZ9031, MICREL_PHY_ID_MASK,
-				ksz9031rn_phy_fixup);
 		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffef,
 				ar8031_phy_fixup);
 		phy_register_fixup_for_uid(PHY_ID_AR8035, 0xffffffef,
-- 
2.29.2

