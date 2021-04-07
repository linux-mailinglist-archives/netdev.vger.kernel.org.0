Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896253575D9
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356135AbhDGUYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356093AbhDGUX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:23:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 157A6611C1;
        Wed,  7 Apr 2021 20:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827027;
        bh=SOU+bSYobPOpQWz3m5IIcFdD5rItJj5CT5SwXjwCn9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjRJXmCrV6aYqTRGnVlZhlgV/yCqVeo317fNeBI8xBnw38tRRvoQuttUSIcex779T
         vhvGa004IDx1JJf9OrVrK/MI/qsTO/U15RSmFxpTZcDpLgRMN8mbUWu5So6gJ3ESZ7
         18CHoKPJ4c9FeB9ND9akDVghIH4ZS+AFvfVvhg0f5G+PEPiwRGUimYR2VoNUpJwO2q
         TkD9U2wFulluVioMns0qJUAjYfZ0cmnTBirnV5s0i/7xC6sTiy3/wcVBxylpOmTJVa
         TZlumSCS3R9V16Y1a8XbQ1sHRp2fGOwiK3fXCnPxSZva1ja84LWxFrYMKe4rnmnKJ0
         +mED+7Ca287Gw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 08/16] net: phy: marvell10g: check for correct supported interface mode
Date:   Wed,  7 Apr 2021 22:22:46 +0200
Message-Id: <20210407202254.29417-9-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
References: <20210407202254.29417-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 88E2110 does not support xaui nor rxaui modes. Check for correct
interface mode for different chips.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 37 +++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index b0b3fccac65f..a7c6b1944b05 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -109,11 +109,14 @@ enum {
 };
 
 struct mv3310_chip {
+	void (*init_supported_interfaces)(unsigned long *mask);
 	int (*get_mactype)(struct phy_device *phydev);
 	int (*init_interface)(struct phy_device *phydev, int mactype);
 };
 
 struct mv3310_priv {
+	DECLARE_BITMAP(supported_interfaces, PHY_INTERFACE_MODE_MAX);
+
 	u32 firmware_ver;
 	bool rate_match;
 	phy_interface_t const_interface;
@@ -391,6 +394,7 @@ static const struct sfp_upstream_ops mv3310_sfp_ops = {
 
 static int mv3310_probe(struct phy_device *phydev)
 {
+	const struct mv3310_chip *chip = to_mv3310_chip(phydev);
 	struct mv3310_priv *priv;
 	u32 mmd_mask = MDIO_DEVS_PMAPMD | MDIO_DEVS_AN;
 	int ret;
@@ -440,6 +444,8 @@ static int mv3310_probe(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	chip->init_supported_interfaces(priv->supported_interfaces);
+
 	return phy_sfp_probe(phydev, &mv3310_sfp_ops);
 }
 
@@ -540,17 +546,12 @@ static int mv3310_init_interface(struct phy_device *phydev, int mactype)
 
 static int mv3310_config_init(struct phy_device *phydev)
 {
+	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
 	const struct mv3310_chip *chip = to_mv3310_chip(phydev);
 	int err, mactype;
 
 	/* Check that the PHY interface type is compatible */
-	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
-	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
-	    phydev->interface != PHY_INTERFACE_MODE_5GBASER &&
-	    phydev->interface != PHY_INTERFACE_MODE_XAUI &&
-	    phydev->interface != PHY_INTERFACE_MODE_RXAUI &&
-	    phydev->interface != PHY_INTERFACE_MODE_10GBASER &&
-	    phydev->interface != PHY_INTERFACE_MODE_USXGMII)
+	if (!test_bit(phydev->interface, priv->supported_interfaces))
 		return -ENODEV;
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
@@ -857,12 +858,34 @@ static int mv3310_set_tunable(struct phy_device *phydev,
 	}
 }
 
+static void mv3310_init_supported_interfaces(unsigned long *mask)
+{
+	__set_bit(PHY_INTERFACE_MODE_SGMII, mask);
+	__set_bit(PHY_INTERFACE_MODE_2500BASEX, mask);
+	__set_bit(PHY_INTERFACE_MODE_5GBASER, mask);
+	__set_bit(PHY_INTERFACE_MODE_XAUI, mask);
+	__set_bit(PHY_INTERFACE_MODE_RXAUI, mask);
+	__set_bit(PHY_INTERFACE_MODE_10GBASER, mask);
+	__set_bit(PHY_INTERFACE_MODE_USXGMII, mask);
+}
+
+static void mv2110_init_supported_interfaces(unsigned long *mask)
+{
+	__set_bit(PHY_INTERFACE_MODE_SGMII, mask);
+	__set_bit(PHY_INTERFACE_MODE_2500BASEX, mask);
+	__set_bit(PHY_INTERFACE_MODE_5GBASER, mask);
+	__set_bit(PHY_INTERFACE_MODE_10GBASER, mask);
+	__set_bit(PHY_INTERFACE_MODE_USXGMII, mask);
+}
+
 static const struct mv3310_chip mv3310_type = {
+	.init_supported_interfaces = mv3310_init_supported_interfaces,
 	.get_mactype = mv3310_get_mactype,
 	.init_interface = mv3310_init_interface,
 };
 
 static const struct mv3310_chip mv2110_type = {
+	.init_supported_interfaces = mv2110_init_supported_interfaces,
 	.get_mactype = mv2110_get_mactype,
 	.init_interface = mv2110_init_interface,
 };
-- 
2.26.2

