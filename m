Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A423492EA
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhCYNOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:14:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230163AbhCYNNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:13:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FBB1619A3;
        Thu, 25 Mar 2021 13:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616678026;
        bh=pYFKKdkwNtpe0POAWCWJVc+BLLceRhX5L8OI7ja2qt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3OH+Mgyi10kNKPKjllRXPcxe6rGpoBSz5aO8J92XjenT/ifZjXcfa9HYJIOeblgo
         ATqpkYIOI833BSPBcEr6lHyTMBP1BRxOvo6HPpygcdY7DV/54bcxkNSbKo2BjP+vz5
         LsYqO3g6qIgAANO7HvKNOP3JHlSc34wbg4LSTJdlRKxsJH8zeFay85sWz2FqYwYp/o
         DE92d2BEfbNYV2Qg8P+70H8m9l3z+ivloRqLXX4nyZ0qPbmpfhQ+KiQiCIEoT4QXIi
         SGPBjTOR3w+y0PckiPEPJ/YLzel1ZiBJ8yi7m2LuO8Sm34aLozP242HWHb57vkg4Vu
         ZpWSd8ke+Gisg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 12/12] net: phy: marvell10g: better check for compatible interface
Date:   Thu, 25 Mar 2021 14:12:50 +0100
Message-Id: <20210325131250.15901-13-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325131250.15901-1-kabel@kernel.org>
References: <20210325131250.15901-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do a model-specific check for compatible interface:
- 88X3340 does not support XAUI
- 88E21XX does not support XAUI and RXAUI
- 88E21X1 does not support 5gbase-r

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 38 ++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 84f24fcb832c..510e27c766e6 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -124,6 +124,7 @@ enum mv3310_model {
 
 struct mv3310_priv {
 	enum mv3310_model model;
+	bool has_5g;
 
 	u32 firmware_ver;
 	phy_interface_t const_interface;
@@ -399,7 +400,7 @@ static int mv3310_probe(struct phy_device *phydev)
 {
 	struct mv3310_priv *priv;
 	u32 mmd_mask = MDIO_DEVS_PMAPMD | MDIO_DEVS_AN;
-	bool has_5g, has_macsec;
+	bool has_macsec;
 	int ret, nports;
 
 	if (!phydev->is_c45 ||
@@ -451,6 +452,7 @@ static int mv3310_probe(struct phy_device *phydev)
 			return ret;
 
 		has_macsec = !(ret & MV_PMA_XGSTAT_NO_MACSEC);
+		priv->has_5g = true;
 
 		if (nports == 4)
 			priv->model = MV_MODEL_88X3340;
@@ -462,7 +464,7 @@ static int mv3310_probe(struct phy_device *phydev)
 		if (ret < 0)
 			return ret;
 
-		has_5g = ret & MDIO_PCS_SPEED_5G;
+		priv->has_5g = ret & MDIO_PCS_SPEED_5G;
 
 		if (nports == 8)
 			priv->model = MV_MODEL_88E218X;
@@ -476,7 +478,7 @@ static int mv3310_probe(struct phy_device *phydev)
 	switch (priv->model) {
 	case MV_MODEL_88E211X:
 	case MV_MODEL_88E218X:
-		phydev_info(phydev, "model 88E21%d%d\n", nports, !has_5g);
+		phydev_info(phydev, "model 88E21%d%d\n", nports, !priv->has_5g);
 		break;
 	case MV_MODEL_88X3310:
 	case MV_MODEL_88X3340:
@@ -543,6 +545,15 @@ static int mv2110_init_interface(struct phy_device *phydev)
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
 	int mactype;
 
+	/* Check that the PHY interface type is compatible */
+	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
+	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
+	    (phydev->interface != PHY_INTERFACE_MODE_5GBASER ||
+	     !priv->has_5g) &&
+	    phydev->interface != PHY_INTERFACE_MODE_10GBASER &&
+	    phydev->interface != PHY_INTERFACE_MODE_USXGMII)
+		return -ENODEV;
+
 	mactype = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_21X0_PORT_CTRL);
 	if (mactype < 0)
 		return mactype;
@@ -573,6 +584,17 @@ static int mv3310_init_interface(struct phy_device *phydev)
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
 	int mactype;
 
+	/* Check that the PHY interface type is compatible */
+	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
+	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
+	    phydev->interface != PHY_INTERFACE_MODE_5GBASER &&
+	    (phydev->interface != PHY_INTERFACE_MODE_XAUI ||
+	     priv->model == MV_MODEL_88X3340) &&
+	    phydev->interface != PHY_INTERFACE_MODE_RXAUI &&
+	    phydev->interface != PHY_INTERFACE_MODE_10GBASER &&
+	    phydev->interface != PHY_INTERFACE_MODE_USXGMII)
+		return -ENODEV;
+
 	mactype = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
 	if (mactype < 0)
 		return mactype;
@@ -610,16 +632,6 @@ static int mv3310_config_init(struct phy_device *phydev)
 {
 	int err;
 
-	/* Check that the PHY interface type is compatible */
-	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
-	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
-	    phydev->interface != PHY_INTERFACE_MODE_5GBASER &&
-	    phydev->interface != PHY_INTERFACE_MODE_XAUI &&
-	    phydev->interface != PHY_INTERFACE_MODE_RXAUI &&
-	    phydev->interface != PHY_INTERFACE_MODE_10GBASER &&
-	    phydev->interface != PHY_INTERFACE_MODE_USXGMII)
-		return -ENODEV;
-
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
 
 	/* Power up so reset works */
-- 
2.26.2

