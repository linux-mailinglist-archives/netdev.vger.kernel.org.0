Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C5531AE9A
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBNBFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:05:07 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:52673 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhBNBFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:05:03 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 3483F23E65;
        Sun, 14 Feb 2021 02:04:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613264661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6eWXt0pmqIuh7EZysx1TvDwVH9UcTFdMs2NIAS8KTVQ=;
        b=K7sRVqY3UhenvOpyGj4M2qmIc9WxpPHunDr42cygwiElGEBRYSY5bKI2a+2DZdljF/sThw
        nEmBh06tEmaunVaCMDAdKaIFKvs4t8C0L+T/rM7W2B39XypOLPtMjvVq7wbMtS6vRWkDhe
        UOi0517kxP8GLA5TIJawKVGUZyKrruk=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 2/2] net: phy: at803x: use proper locking in at803x_aneg_done()
Date:   Sun, 14 Feb 2021 02:04:05 +0100
Message-Id: <20210214010405.32019-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210214010405.32019-1-michael@walle.cc>
References: <20210214010405.32019-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

at803x_aneg_done() checks if auto-negotiation is completed on the SGMII
side. This doesn't take the mdio bus lock and the page switching is
open-coded. Now that we have proper page support, just use
phy_read_paged(). Also use phydev->interface to check if we have an
SGMII link instead of reading the mode register and be a bit more
precise on the warning message.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/at803x.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index a3aa10f14638..8abaea7ae6bd 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -756,32 +756,27 @@ static void at803x_link_change_notify(struct phy_device *phydev)
 
 static int at803x_aneg_done(struct phy_device *phydev)
 {
-	int ccr;
-
-	int aneg_done = genphy_aneg_done(phydev);
-	if (aneg_done != BMSR_ANEGCOMPLETE)
-		return aneg_done;
+	int ret, val;
 
-	/*
-	 * in SGMII mode, if copper side autoneg is successful,
-	 * also check SGMII side autoneg result
-	 */
-	ccr = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
-	if ((ccr & AT803X_MODE_CFG_MASK) != AT803X_MODE_CFG_SGMII)
-		return aneg_done;
 
-	/* switch to SGMII/fiber page */
-	phy_write(phydev, AT803X_REG_CHIP_CONFIG, ccr & ~AT803X_BT_BX_REG_SEL);
+	ret = genphy_aneg_done(phydev);
 
-	/* check if the SGMII link is OK. */
-	if (!(phy_read(phydev, AT803X_PSSR) & AT803X_PSSR_MR_AN_COMPLETE)) {
-		phydev_warn(phydev, "803x_aneg_done: SGMII link is not ok\n");
-		aneg_done = 0;
+	/* In SGMII mode, if copper side autoneg is successful, also check
+	 * SGMII side autoneg result.
+	 */
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII &&
+	    ret == BMSR_ANEGCOMPLETE) {
+		val = phy_read_paged(phydev, AT803X_FIBER_PAGE, AT803X_PSSR);
+		if (val < 0)
+			return val;
+
+		if (!(val & AT803X_PSSR_MR_AN_COMPLETE)) {
+			phydev_warn(phydev, "SGMII autoneg isn't completed\n");
+			return 0;
+		}
 	}
-	/* switch back to copper page */
-	phy_write(phydev, AT803X_REG_CHIP_CONFIG, ccr | AT803X_BT_BX_REG_SEL);
 
-	return aneg_done;
+	return ret;
 }
 
 static int at803x_read_status(struct phy_device *phydev)
-- 
2.20.1

