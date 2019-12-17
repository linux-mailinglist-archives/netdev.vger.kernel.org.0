Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7220E122D14
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbfLQNjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:39:43 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56782 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfLQNjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:39:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6ABseZTtCOvz5+bnrWBkbykH4WovF2sCldNaMGoFPTY=; b=Ynl2gKyDOmad56bfcfW6Bn/kbi
        ejDDK2ucLFwociYrIsxSZSXlOXR9Mg4H6KQqTuNVzcSSD6f4DfvZ3t4nUi4JwZPu+QEaZTbx9x3mz
        OQJ9D7Mlh1PHZdio2pv8qak31iyHbaUg9FRxZDFuUfFA6mzml9mE5j3S/AYXfv30cNqTLQ7cSqFwm
        oDrSRchdNA6N8pR+0MFoDMwe5VndtFieEODsN1EMCHJ0XO55tmHj6hbT7lhSHCbfpEbJFdY+1ftmd
        nGgrxzO81gfS58yV7UE7S5j6Rn60xybDHiNtB4g+LR4bMUKvo44XZCk1MD/AqIbw24qO0/g84Z63/
        VNq1jeHQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39830 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4S-0006FJ-GS; Tue, 17 Dec 2019 13:39:28 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4Q-0001yt-JM; Tue, 17 Dec 2019 13:39:26 +0000
In-Reply-To: <20191217133827.GQ25745@shell.armlinux.org.uk>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 06/11] net: phy: marvell: initialise link partner
 state earlier
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ihD4Q-0001yt-JM@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Dec 2019 13:39:26 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the initialisation of the link partner state earlier, inside
marvell_read_status_page(), so we don't have the same initialisation
scattered amongst the other files.  This is in a similar place to
the genphy implementation, so would result in the same behaviour if
a PHY read error occurs.

This allows us to get rid of marvell_read_status_page_fixed(), which
became a pointless wrapper around genphy_read_status_fixed().

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 18080d9c0cd9..d57df48b3568 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1230,8 +1230,6 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
 		if (err < 0)
 			return err;
 
-		phydev->pause = 0;
-		phydev->asym_pause = 0;
 		phy_resolve_aneg_pause(phydev);
 	} else {
 		lpa = phy_read(phydev, MII_LPA);
@@ -1241,8 +1239,6 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
 		/* The fiber link is only 1000M capable */
 		fiber_lpa_mod_linkmode_lpa_t(phydev->lp_advertising, lpa);
 
-		phydev->pause = 0;
-		phydev->asym_pause = 0;
 		if (phydev->duplex == DUPLEX_FULL) {
 			if (!(lpa & LPA_PAUSE_FIBER)) {
 				phydev->pause = 0;
@@ -1279,21 +1275,6 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
 	return 0;
 }
 
-static int marvell_read_status_page_fixed(struct phy_device *phydev)
-{
-	int err;
-
-	err = genphy_read_status_fixed(phydev);
-	if (err < 0)
-		return err;
-
-	phydev->pause = 0;
-	phydev->asym_pause = 0;
-	linkmode_zero(phydev->lp_advertising);
-
-	return 0;
-}
-
 /* marvell_read_status_page
  *
  * Description:
@@ -1319,10 +1300,14 @@ static int marvell_read_status_page(struct phy_device *phydev, int page)
 	if (err)
 		return err;
 
+	linkmode_zero(phydev->lp_advertising);
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
 	if (phydev->autoneg == AUTONEG_ENABLE)
 		err = marvell_read_status_page_an(phydev, fiber);
 	else
-		err = marvell_read_status_page_fixed(phydev);
+		err = genphy_read_status_fixed(phydev);
 
 	return err;
 }
-- 
2.20.1

