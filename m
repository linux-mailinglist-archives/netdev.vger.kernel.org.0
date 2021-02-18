Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E234331EF8F
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbhBRTSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhBRSxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 13:53:39 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DE0C06178C;
        Thu, 18 Feb 2021 10:52:52 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 13F2322249;
        Thu, 18 Feb 2021 19:52:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613674371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eE7bZqE4KOXzGdBolpgtv1VTUe+mz8S4A5Hnvx/FUpk=;
        b=evEidoX4NXOmRJsKJ60JpPt39oxKzKOLn8cnHSX0Xs22L9q7mIbf2Q6TCbptfQweruaK2+
        v74sw79hgE1Cb46R7WkdwSqoQDX9i5UEdkWjq2fUOn70dnqnPAnndRir4hyuHPFVKVjfrO
        jFenWSEOTv/INMSFjKeLHMALAPEpa7M=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 2/2] net: phy: at803x: remove at803x_aneg_done()
Date:   Thu, 18 Feb 2021 19:52:40 +0100
Message-Id: <20210218185240.23615-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210218185240.23615-1-michael@walle.cc>
References: <20210218185240.23615-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

at803x_aneg_done() is pretty much dead code since the patch series
"net: phy: improve and simplify phylib state machine" [1]. Just remove
it.

[1] https://lore.kernel.org/netdev/922c223b-7bc0-e0ec-345d-2034b796af91@gmail.com/

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/at803x.c | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 194b414207d3..479dc2590236 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -754,36 +754,6 @@ static void at803x_link_change_notify(struct phy_device *phydev)
 	}
 }
 
-static int at803x_aneg_done(struct phy_device *phydev)
-{
-	int ccr;
-
-	int aneg_done = genphy_aneg_done(phydev);
-	if (aneg_done != BMSR_ANEGCOMPLETE)
-		return aneg_done;
-
-	/*
-	 * in SGMII mode, if copper side autoneg is successful,
-	 * also check SGMII side autoneg result
-	 */
-	ccr = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
-	if ((ccr & AT803X_MODE_CFG_MASK) != AT803X_MODE_CFG_SGMII)
-		return aneg_done;
-
-	/* switch to SGMII/fiber page */
-	phy_write(phydev, AT803X_REG_CHIP_CONFIG, ccr & ~AT803X_BT_BX_REG_SEL);
-
-	/* check if the SGMII link is OK. */
-	if (!(phy_read(phydev, AT803X_PSSR) & AT803X_PSSR_MR_AN_COMPLETE)) {
-		phydev_warn(phydev, "803x_aneg_done: SGMII link is not ok\n");
-		aneg_done = 0;
-	}
-	/* switch back to copper page */
-	phy_write(phydev, AT803X_REG_CHIP_CONFIG, ccr | AT803X_BT_BX_REG_SEL);
-
-	return aneg_done;
-}
-
 static int at803x_read_status(struct phy_device *phydev)
 {
 	int ss, err, old_link = phydev->link;
@@ -1233,7 +1203,6 @@ static struct phy_driver at803x_driver[] = {
 	.resume			= at803x_resume,
 	/* PHY_GBIT_FEATURES */
 	.read_status		= at803x_read_status,
-	.aneg_done		= at803x_aneg_done,
 	.config_intr		= &at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
-- 
2.20.1

