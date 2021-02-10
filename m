Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5B0316BB2
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhBJQuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:50:13 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:54809 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbhBJQsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:48:43 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 9941123E75;
        Wed, 10 Feb 2021 17:47:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612975678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vHwD/kQTV4GxfMU/NM4MiuirE6H8vM6tOsxDscW3aic=;
        b=GDO9EKs9TYgzaMpGuck03Mqq1SA3B3cc4RgP48g6goq1y0XmtSfk/Kn4tzyQ8oySbOW9ey
        kSJKR2eO4Cgo1/wwf0ViehL3+LE7pGMFQPKN1Je8N/QqXusx4flIxZ0A90utFTCKDeyWve
        Np6ytgHnEmgPOcEScnO9g51vp6Ntf3w=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 4/9] net: phy: icplus: use the .soft_reset() of the phy-core
Date:   Wed, 10 Feb 2021 17:47:41 +0100
Message-Id: <20210210164746.26336-5-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210210164746.26336-1-michael@walle.cc>
References: <20210210164746.26336-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHY core already resets the PHY before .config_init() if a
.soft_reset() op is registered. Drop the open-coded ip1xx_reset().

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes since v1:
 - none

 drivers/net/phy/icplus.c | 32 ++------------------------------
 1 file changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index 43b69addc0ce..036bac628b11 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -120,36 +120,10 @@ static int ip175c_config_init(struct phy_device *phydev)
 	return 0;
 }
 
-static int ip1xx_reset(struct phy_device *phydev)
-{
-	int bmcr;
-
-	/* Software Reset PHY */
-	bmcr = phy_read(phydev, MII_BMCR);
-	if (bmcr < 0)
-		return bmcr;
-	bmcr |= BMCR_RESET;
-	bmcr = phy_write(phydev, MII_BMCR, bmcr);
-	if (bmcr < 0)
-		return bmcr;
-
-	do {
-		bmcr = phy_read(phydev, MII_BMCR);
-		if (bmcr < 0)
-			return bmcr;
-	} while (bmcr & BMCR_RESET);
-
-	return 0;
-}
-
 static int ip1001_config_init(struct phy_device *phydev)
 {
 	int c;
 
-	c = ip1xx_reset(phydev);
-	if (c < 0)
-		return c;
-
 	/* Enable Auto Power Saving mode */
 	c = phy_read(phydev, IP1001_SPEC_CTRL_STATUS_2);
 	if (c < 0)
@@ -237,10 +211,6 @@ static int ip101a_g_config_init(struct phy_device *phydev)
 	struct ip101a_g_phy_priv *priv = phydev->priv;
 	int err, c;
 
-	c = ip1xx_reset(phydev);
-	if (c < 0)
-		return c;
-
 	/* configure the RXER/INTR_32 pin of the 32-pin IP101GR if needed: */
 	switch (priv->sel_intr32) {
 	case IP101GR_SEL_INTR32_RXER:
@@ -346,6 +316,7 @@ static struct phy_driver icplus_driver[] = {
 	.name		= "ICPlus IP1001",
 	/* PHY_GBIT_FEATURES */
 	.config_init	= ip1001_config_init,
+	.soft_reset	= genphy_soft_reset,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -356,6 +327,7 @@ static struct phy_driver icplus_driver[] = {
 	.config_intr	= ip101a_g_config_intr,
 	.handle_interrupt = ip101a_g_handle_interrupt,
 	.config_init	= ip101a_g_config_init,
+	.soft_reset	= genphy_soft_reset,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 } };
-- 
2.20.1

