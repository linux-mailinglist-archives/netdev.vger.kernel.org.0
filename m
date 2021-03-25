Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FAE3492E8
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhCYNOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:14:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230447AbhCYNNj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:13:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E600619AB;
        Thu, 25 Mar 2021 13:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616678018;
        bh=SU4/OBPxMwNPXzLqu65mukDmGKUUnfnnnaECcXsYwjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c47bRiKJ0MIhhjijnITxedbXgf94FyIt8koK1Q6HYp0IRtdzpzW5yIPv6EP9kqgWP
         mEe34a8NrxSCTt917ciwQWhtsTBSZ6wTkgL1DnBPPZYNF+XH/w0wGMuXwQpBi9Br7s
         TjviWI/pF4CgqHqY3hHNefYwOHMo1NFnX0OmSHKCxiMK1QHsL8syxggxZh971jwhLN
         ErFi4azk9lRU3ZhskuTDLM4F3c5mFujoPcyGlH2JN6vfIZf7rw+3FxR6+grGrffoaH
         ReF43/uc3vWC9ULw9VKOSUrpgqDs7vtD1ZykCUoCsCy2jHNZ3a3zdTuSR+INZuwBkg
         dOzbEsFc+bT9g==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 08/12] net: phy: marvell10g: support all rate matching modes
Date:   Thu, 25 Mar 2021 14:12:46 +0100
Message-Id: <20210325131250.15901-9-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325131250.15901-1-kabel@kernel.org>
References: <20210325131250.15901-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for all rate matching modes, not only for 10gbase-r.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 67 ++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index b49cff895cdd..025473512581 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -124,6 +124,7 @@ struct mv3310_priv {
 	enum mv3310_model model;
 
 	u32 firmware_ver;
+	phy_interface_t const_interface;
 	bool rate_match;
 
 	struct device *hwmon_dev;
@@ -512,11 +513,56 @@ static bool mv3310_has_pma_ngbaset_quirk(struct phy_device *phydev)
 		MV_PHY_ALASKA_NBT_QUIRK_MASK) == MV_PHY_ALASKA_NBT_QUIRK_REV;
 }
 
-static int mv3310_config_init(struct phy_device *phydev)
+static int mv2110_init_interface(struct phy_device *phydev)
+{
+	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
+	int mactype;
+
+	mactype = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_21X0_PORT_CTRL);
+	if (mactype < 0)
+		return mactype;
+
+	mactype &= MV_PMA_21X0_PORT_CTRL_MACTYPE_MASK;
+
+	if (mactype == MV_PMA_21X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH) {
+		priv->rate_match = true;
+		priv->const_interface = PHY_INTERFACE_MODE_10GBASER;
+	}
+
+	return 0;
+}
+
+static int mv3310_init_interface(struct phy_device *phydev)
 {
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
+	int mactype;
+
+	mactype = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
+	if (mactype < 0)
+		return mactype;
+
+	mactype &= MV_V2_33X0_PORT_CTRL_MACTYPE_MASK;
+
+	if (mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH ||
+	    mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH ||
+	    (mactype == MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH &&
+	     priv->model == MV_MODEL_88X3310))
+		priv->rate_match = true;
+
+	if (mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH)
+		priv->const_interface = PHY_INTERFACE_MODE_10GBASER;
+	else if (mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH)
+		priv->const_interface = PHY_INTERFACE_MODE_RXAUI;
+	else if (priv->model == MV_MODEL_88X3310 &&
+		 mactype == MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH)
+		priv->const_interface = PHY_INTERFACE_MODE_XAUI;
+
+	return 0;
+}
+
+static int mv3310_config_init(struct phy_device *phydev)
+{
 	int err;
-	int val;
 
 	/* Check that the PHY interface type is compatible */
 	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
@@ -535,11 +581,12 @@ static int mv3310_config_init(struct phy_device *phydev)
 	if (err)
 		return err;
 
-	val = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
-	if (val < 0)
-		return val;
-	priv->rate_match = ((val & MV_V2_33X0_PORT_CTRL_MACTYPE_MASK) ==
-			MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH);
+	if (phydev->drv->phy_id == MARVELL_PHY_ID_88E2110)
+		err = mv2110_init_interface(phydev);
+	else
+		err = mv3310_init_interface(phydev);
+	if (err < 0)
+		return err;
 
 	/* Enable EDPD mode - saving 600mW */
 	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
@@ -649,12 +696,12 @@ static void mv3310_update_interface(struct phy_device *phydev)
 {
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
 
-	/* In "XFI with Rate Matching" mode the PHY interface is fixed at
-	 * 10Gb. The PHY adapts the rate to actual wire speed with help of
+	/* In all of the "* with Rate Matching" modes the PHY interface is fixed
+	 * at 10Gb. The PHY adapts the rate to actual wire speed with help of
 	 * internal 16KB buffer.
 	 */
 	if (priv->rate_match) {
-		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
+		phydev->interface = priv->const_interface;
 		return;
 	}
 
-- 
2.26.2

