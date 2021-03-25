Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395A03492E3
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhCYNOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230260AbhCYNNh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:13:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76F1961A40;
        Thu, 25 Mar 2021 13:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616678016;
        bh=HtnNEpMDvH9xaCq97fCpG41bYejqVE/v2dFNuPhpvy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPxE+AA+5rCwsB99SeVOzyIvtdjCIkBQJUUtgspXskhD7kj75vggGXnK7bnzyZEZx
         uFKlJ/ETjysEokh3MeWjc/AAUvnyREqnlIgCZiiXaOQ/ThugzHOy8s2QRuSzMzIGtp
         lycyBhD+9ylNlBrvHstDyM3ZkVB9vqtLhnfk+aitb7uLt2huhsEKA8hYcs25S/locx
         Aix6SmugwVG5L7X6Vp0clcrQTbKXC6t3yh0fO4asaqBJ0Uh0D9isyd+GNboRoNmgqW
         AxIheECta5EsZMUuWuv66NZEXkg53FUr2pt/PTJaipifiQhGz2IhuR6kAxwRHEyFDP
         OXPE/9TxCBEUg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 07/12] net: phy: marvell10g: add code to determine number of ports
Date:   Thu, 25 Mar 2021 14:12:45 +0100
Message-Id: <20210325131250.15901-8-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325131250.15901-1-kabel@kernel.org>
References: <20210325131250.15901-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add code to determine number of ports, from which we differentiate
88E211X from 88E218X and 88X3310 from 88X3340.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 44 +++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 556c9b43860e..b49cff895cdd 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -78,6 +78,10 @@ enum {
 	/* Temperature read register (88E2110 only) */
 	MV_PCS_TEMP		= 0x8042,
 
+	MV_PCS_ID		= 0xd00d,
+	MV_PCS_ID_NPORTS_MASK	= 0x0380,
+	MV_PCS_ID_NPORTS_SHIFT	= 7,
+
 	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
 	 * registers appear to set themselves to the 0x800X when AN is
 	 * restarted, but status registers appear readable from either.
@@ -108,7 +112,17 @@ enum {
 	MV_V2_TEMP_UNKNOWN	= 0x9600, /* unknown function */
 };
 
+enum mv3310_model {
+	MV_MODEL_NA = 0,
+	MV_MODEL_88E211X,
+	MV_MODEL_88E218X,
+	MV_MODEL_88X3310,
+	MV_MODEL_88X3340,
+};
+
 struct mv3310_priv {
+	enum mv3310_model model;
+
 	u32 firmware_ver;
 	bool rate_match;
 
@@ -382,7 +396,7 @@ static int mv3310_probe(struct phy_device *phydev)
 {
 	struct mv3310_priv *priv;
 	u32 mmd_mask = MDIO_DEVS_PMAPMD | MDIO_DEVS_AN;
-	int ret;
+	int ret, nports;
 
 	if (!phydev->is_c45 ||
 	    (phydev->c45_ids.devices_in_package & mmd_mask) != mmd_mask)
@@ -420,6 +434,34 @@ static int mv3310_probe(struct phy_device *phydev)
 		    priv->firmware_ver >> 24, (priv->firmware_ver >> 16) & 255,
 		    (priv->firmware_ver >> 8) & 255, priv->firmware_ver & 255);
 
+	ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_ID);
+	if (ret < 0)
+		return ret;
+
+	nports = ((ret & MV_PCS_ID_NPORTS_MASK) >> MV_PCS_ID_NPORTS_SHIFT) + 1;
+
+	switch (phydev->drv->phy_id) {
+	case MARVELL_PHY_ID_88X3310:
+		if (nports == 4)
+			priv->model = MV_MODEL_88X3340;
+		else if (nports == 1)
+			priv->model = MV_MODEL_88X3310;
+		break;
+	case MARVELL_PHY_ID_88E2110:
+		if (nports == 8)
+			priv->model = MV_MODEL_88E218X;
+		else if (nports == 1)
+			priv->model = MV_MODEL_88E211X;
+		break;
+	default:
+		unreachable();
+	}
+
+	if (!priv->model) {
+		phydev_err(phydev, "unknown PHY model (nports = %i)\n", nports);
+		return -ENODEV;
+	}
+
 	/* Powering down the port when not in use saves about 600mW */
 	ret = mv3310_power_down(phydev);
 	if (ret)
-- 
2.26.2

