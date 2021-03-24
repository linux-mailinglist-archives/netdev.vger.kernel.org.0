Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9ED347E37
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbhCXQvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 12:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236794AbhCXQvI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 12:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7042619F3;
        Wed, 24 Mar 2021 16:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616604668;
        bh=nO0rdJOckCx5r3n49T0yn9+navnCZWJe3TcAr5ewsx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFEZYcYjTbErnKIOijV3EJOa2JyT5lxtZkexCyPfWfw+eGza8M07XBm9TCr/gRwvF
         bjTJy0EmHOvUwd3BAlMZ8o6elzLfiYkLbOBY8xdE3lXpc0d2kpb3a5OCYe1/wW3OUE
         rWejyhshlOI8zmDJ7j82km5In/rWQoEtI6z3o0VOQ76TAFQbP28sbJdEkJdvJ7sT4W
         ZAZs5Z9ZiVxi7tPfvXVBoYtVDrgcRlyTDKkLh+sZSHWRkqqCMO2tfuEsCr5/JQTSL9
         njSZeOCIitGpJdkTiLhB1dR2Ibu4dLGELdCTcBin60NMVJ4XUhccixKvfeAqfYNuyS
         Ix++2cv0psmLw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 6/7] net: phy: marvell10g: support more rate matching modes
Date:   Wed, 24 Mar 2021 17:50:22 +0100
Message-Id: <20210324165023.32352-7-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210324165023.32352-1-kabel@kernel.org>
References: <20210324165023.32352-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 88X3310P supports rate matching mode also for XAUI and RXAUI.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index b4f9831b4db6..c764795a142a 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -596,13 +596,22 @@ static void mv3310_update_interface(struct phy_device *phydev)
 {
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
 
-	/* In "XFI with Rate Matching" mode the PHY interface is fixed at
-	 * 10Gb. The PHY adapts the rate to actual wire speed with help of
+	/* In all of the "* with Rate Matching" modes the PHY interface is fixed
+	 * at 10Gb. The PHY adapts the rate to actual wire speed with help of
 	 * internal 16KB buffer.
 	 */
-	if (priv->mactype == MV_V2_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH) {
+	switch (priv->mactype) {
+	case MV_V2_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH:
 		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
 		return;
+	case MV_V2_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH:
+		phydev->interface = PHY_INTERFACE_MODE_XAUI;
+		return;
+	case MV_V2_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH:
+		phydev->interface = PHY_INTERFACE_MODE_RXAUI;
+		return;
+	default:
+		break;
 	}
 
 	if ((phydev->interface == PHY_INTERFACE_MODE_SGMII ||
-- 
2.26.2

