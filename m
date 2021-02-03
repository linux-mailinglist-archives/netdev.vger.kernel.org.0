Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93F530D622
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 10:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhBCJUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 04:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbhBCJTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 04:19:45 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF51C061786
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 01:19:05 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1l7EJP-0003qx-TT; Wed, 03 Feb 2021 10:18:59 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1l7EJO-0004Qi-5T; Wed, 03 Feb 2021 10:18:58 +0100
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
Subject: [PATCH v1 4/7] ARM i.MX6q: remove clk-out fixup for the Atheros AR8031 and AR8035 PHYs
Date:   Wed,  3 Feb 2021 10:18:54 +0100
Message-Id: <20210203091857.16936-5-o.rempel@pengutronix.de>
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

This configuration should be set over device tree.

If this patch breaks network functionality on your system, enable the
AT803X_PHY driver and set following device tree property in the PHY
node:

    qca,clk-out-frequency = <125000000>;

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/arm/mach-imx/mach-imx6q.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 4c840e116003..d12b571a61ac 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -68,25 +68,6 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_PLX, 0x8609, ventana_pciesw_early_fixup);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_PLX, 0x8606, ventana_pciesw_early_fixup);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_PLX, 0x8604, ventana_pciesw_early_fixup);
 
-static int ar8031_phy_fixup(struct phy_device *dev)
-{
-	u16 val;
-
-	/* To enable AR8031 output a 125MHz clk from CLK_25M */
-	phy_write(dev, 0xd, 0x7);
-	phy_write(dev, 0xe, 0x8016);
-	phy_write(dev, 0xd, 0x4007);
-
-	val = phy_read(dev, 0xe);
-	val &= 0xffe3;
-	val |= 0x18;
-	phy_write(dev, 0xe, val);
-
-	return 0;
-}
-
-#define PHY_ID_AR8031	0x004dd074
-
 static int ar8035_phy_fixup(struct phy_device *dev)
 {
 	u16 val;
@@ -101,15 +82,6 @@ static int ar8035_phy_fixup(struct phy_device *dev)
 	val = phy_read(dev, 0xe);
 	phy_write(dev, 0xe, val & ~(1 << 8));
 
-	/*
-	 * Enable 125MHz clock from CLK_25M on the AR8031.  This
-	 * is fed in to the IMX6 on the ENET_REF_CLK (V22) pad.
-	 * Also, introduce a tx clock delay.
-	 *
-	 * This is the same as is the AR8031 fixup.
-	 */
-	ar8031_phy_fixup(dev);
-
 	return 0;
 }
 
@@ -120,8 +92,6 @@ static void __init imx6q_enet_phy_init(void)
 	if (IS_BUILTIN(CONFIG_PHYLIB)) {
 		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
 				ksz9021rn_phy_fixup);
-		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffef,
-				ar8031_phy_fixup);
 		phy_register_fixup_for_uid(PHY_ID_AR8035, 0xffffffef,
 				ar8035_phy_fixup);
 	}
-- 
2.30.0

