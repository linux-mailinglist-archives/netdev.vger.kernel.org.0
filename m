Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F720122D13
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbfLQNjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:39:36 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56772 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfLQNjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:39:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sULKxD7LcJaPpLoqwy07Mi1df0W2jCtZgHoxrZOmXy0=; b=eHiL7/cYOAVt4zlX1Dpz8ZLN9f
        u7F7dSC92bfUuxFI3WfJA2lIv8DZwe6yh8tpJN4X49mpD8b4BA7ssGObm+qv+UIMuxFjQ+EO3T0Nn
        DfcNU2YM4quRuKOYEYDqdc3bnufS6i5hM2UJkeuIxMECFbTdcDQDz3iWqBEtc/wvGOmf0EL6HObPi
        Vrpzz+7Ar5K62dxedZtD+aNO8MbdMGN1cvVMN0zf3o8XO53cUWyrUYiEqT+lnoEAe1Ntp/a9XR1oR
        PRrVSFnJ0QndktJ1UoTujQrZ2td94deKPhDCQdSrZf6/KB3IE68J9cm9mGVqzS/w8T//AU23Nc3/p
        V7FFzPfg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39828 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4N-0006FB-C7; Tue, 17 Dec 2019 13:39:23 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4L-0001ym-FK; Tue, 17 Dec 2019 13:39:21 +0000
In-Reply-To: <20191217133827.GQ25745@shell.armlinux.org.uk>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 05/11] net: phy: marvell: rearrange to use
 genphy_read_lpa()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ihD4L-0001ym-FK@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Dec 2019 13:39:21 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rearrange the Marvell PHY driver to use genphy_read_lpa() rather than
open-coding this functionality.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell.c | 66 +++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index fa0ec116960e..18080d9c0cd9 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1219,52 +1219,30 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
 {
 	int status;
 	int lpa;
-	int lpagb;
+	int err;
 
 	status = phy_read(phydev, MII_M1011_PHY_STATUS);
 	if (status < 0)
 		return status;
 
-	lpa = phy_read(phydev, MII_LPA);
-	if (lpa < 0)
-		return lpa;
-
-	lpagb = phy_read(phydev, MII_STAT1000);
-	if (lpagb < 0)
-		return lpagb;
-
-	if (status & MII_M1011_PHY_STATUS_FULLDUPLEX)
-		phydev->duplex = DUPLEX_FULL;
-	else
-		phydev->duplex = DUPLEX_HALF;
-
-	status = status & MII_M1011_PHY_STATUS_SPD_MASK;
-	phydev->pause = 0;
-	phydev->asym_pause = 0;
-
-	switch (status) {
-	case MII_M1011_PHY_STATUS_1000:
-		phydev->speed = SPEED_1000;
-		break;
-
-	case MII_M1011_PHY_STATUS_100:
-		phydev->speed = SPEED_100;
-		break;
-
-	default:
-		phydev->speed = SPEED_10;
-		break;
-	}
-
 	if (!fiber) {
-		mii_lpa_to_linkmode_lpa_t(phydev->lp_advertising, lpa);
-		mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising, lpagb);
+		err = genphy_read_lpa(phydev);
+		if (err < 0)
+			return err;
 
+		phydev->pause = 0;
+		phydev->asym_pause = 0;
 		phy_resolve_aneg_pause(phydev);
 	} else {
+		lpa = phy_read(phydev, MII_LPA);
+		if (lpa < 0)
+			return lpa;
+
 		/* The fiber link is only 1000M capable */
 		fiber_lpa_mod_linkmode_lpa_t(phydev->lp_advertising, lpa);
 
+		phydev->pause = 0;
+		phydev->asym_pause = 0;
 		if (phydev->duplex == DUPLEX_FULL) {
 			if (!(lpa & LPA_PAUSE_FIBER)) {
 				phydev->pause = 0;
@@ -1278,6 +1256,26 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
 			}
 		}
 	}
+
+	if (status & MII_M1011_PHY_STATUS_FULLDUPLEX)
+		phydev->duplex = DUPLEX_FULL;
+	else
+		phydev->duplex = DUPLEX_HALF;
+
+	switch (status & MII_M1011_PHY_STATUS_SPD_MASK) {
+	case MII_M1011_PHY_STATUS_1000:
+		phydev->speed = SPEED_1000;
+		break;
+
+	case MII_M1011_PHY_STATUS_100:
+		phydev->speed = SPEED_100;
+		break;
+
+	default:
+		phydev->speed = SPEED_10;
+		break;
+	}
+
 	return 0;
 }
 
-- 
2.20.1

