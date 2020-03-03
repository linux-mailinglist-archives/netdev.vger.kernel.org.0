Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCDB17821B
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388378AbgCCSI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:08:56 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39422 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732575AbgCCSIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 13:08:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eRxaOrIkhqGO/zcKh1Lp1lTkT686ojmcOXafyrIdAKs=; b=Wxn1pgM9pbYpOSRhkNSBps0dJv
        3BWM8RlW5+M2sROLNjN/Zp9pvGgALJl0ICsdvJOJ1Kz6YU1o3GiLchWtVYuT5oVrvqdvH+og/dGbu
        WF+PJLpJgXg8IiVvKhxnT3U2A8rm3Sq2W9BgF/cHp1xWJXkbPKIZdjZe9mNEKIwHTHZcjkGkG1Z4S
        Es5/gPUEu/tAbHB/bktDnQ3grkCgQFXNGNu4nhoECXR22NucJIi2/OcFEFSFcNbJcW6i4DreWIvu2
        wWt4TpUloUCUZ+IV4OE1RZ449KtP1TjXLN+RsMdrZHsGSyVY1ercmerPfrVlhFjwiYhEjDn/9RUOO
        u5UMtJzw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:34288 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j9ByI-00016O-VE; Tue, 03 Mar 2020 18:08:47 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j9ByH-0003pR-6Q; Tue, 03 Mar 2020 18:08:45 +0000
In-Reply-To: <20200303180747.GT25745@shell.armlinux.org.uk>
References: <20200303180747.GT25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 3/3] net: phy: marvell10g: place in powersave mode
 at probe
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j9ByH-0003pR-6Q@rmk-PC.armlinux.org.uk>
Date:   Tue, 03 Mar 2020 18:08:45 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Place the 88x3310 into powersaving mode when probing, which saves 600mW
per PHY. For both PHYs on the Macchiatobin double-shot, this saves
about 10% of the board idle power.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell10g.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 7092feb9e6b5..7e05b92504f0 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -227,6 +227,18 @@ static int mv3310_hwmon_probe(struct phy_device *phydev)
 }
 #endif
 
+static int mv3310_power_down(struct phy_device *phydev)
+{
+	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
+				MV_V2_PORT_CTRL_PWRDOWN);
+}
+
+static int mv3310_power_up(struct phy_device *phydev)
+{
+	return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
+				  MV_V2_PORT_CTRL_PWRDOWN);
+}
+
 static int mv3310_reset(struct phy_device *phydev, u32 unit)
 {
 	int retries, val, err;
@@ -348,6 +360,11 @@ static int mv3310_probe(struct phy_device *phydev)
 
 	dev_set_drvdata(&phydev->mdio.dev, priv);
 
+	/* Powering down the port when not in use saves about 600mW */
+	ret = mv3310_power_down(phydev);
+	if (ret)
+		return ret;
+
 	ret = mv3310_hwmon_probe(phydev);
 	if (ret)
 		return ret;
@@ -357,16 +374,14 @@ static int mv3310_probe(struct phy_device *phydev)
 
 static int mv3310_suspend(struct phy_device *phydev)
 {
-	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
-				MV_V2_PORT_CTRL_PWRDOWN);
+	return mv3310_power_down(phydev);
 }
 
 static int mv3310_resume(struct phy_device *phydev)
 {
 	int ret;
 
-	ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
-				 MV_V2_PORT_CTRL_PWRDOWN);
+	ret = mv3310_power_up(phydev);
 	if (ret)
 		return ret;
 
@@ -392,6 +407,8 @@ static bool mv3310_has_pma_ngbaset_quirk(struct phy_device *phydev)
 
 static int mv3310_config_init(struct phy_device *phydev)
 {
+	int err;
+
 	/* Check that the PHY interface type is compatible */
 	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
@@ -402,6 +419,11 @@ static int mv3310_config_init(struct phy_device *phydev)
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
 
+	/* Power up so reset works */
+	err = mv3310_power_up(phydev);
+	if (err)
+		return err;
+
 	/* Enable EDPD mode - saving 600mW */
 	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
 }
-- 
2.20.1

