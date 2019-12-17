Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA67122D10
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbfLQNjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:39:18 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56738 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfLQNjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:39:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Fme94Vw8u2x8kGHY17Hut2FkVlP1qTuXxjYWkJUaFDc=; b=CyN73ncPtPxKhN80vkN+qi92Sy
        Tbm81PIdhfnqsctMOSajYr4ESFdQeC9HQ8Z4J7xKGg2DoWIMPXsIfEwVzqqbhIB7ndRdoPcySPQqL
        aWWZYsgdwavZkorJjmLamy5cLUDkn8p5fVXh1jSpuyDFvHYQoa04P4RSk9jUkp8HawH+m946kdzOr
        Vn0Ekoy1760MKuwmW7QPTYFsaG+2pKgdyHOF1HEclCxZhJdrvz96SfhhioO2a8IKs0+YiwyFo2jcl
        Wr8aLwPU2aWtZaN803ogSUsFNC8483/5XVl/sBpYCAucvN6sSZCXrlK88arWkyA/pBxRdeA9t03jk
        YN8y0qkA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:35580 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD48-0006Ej-1f; Tue, 17 Dec 2019 13:39:08 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD46-0001yP-0u; Tue, 17 Dec 2019 13:39:06 +0000
In-Reply-To: <20191217133827.GQ25745@shell.armlinux.org.uk>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 02/11] net: phy: use phy_resolve_aneg_pause()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ihD46-0001yP-0u@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Dec 2019 13:39:06 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several drivers code their own version of this, working from the LPA
register, after setting the ethtool link partner advertisement bitmask.
Use the generic function instead.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/lxt.c      | 5 +----
 drivers/net/phy/marvell.c  | 5 +----
 drivers/net/phy/uPD60620.c | 7 +------
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/lxt.c b/drivers/net/phy/lxt.c
index 356bd6472f49..30172852e36e 100644
--- a/drivers/net/phy/lxt.c
+++ b/drivers/net/phy/lxt.c
@@ -190,10 +190,7 @@ static int lxt973a2_read_status(struct phy_device *phydev)
 				phydev->duplex = DUPLEX_FULL;
 		}
 
-		if (phydev->duplex == DUPLEX_FULL) {
-			phydev->pause = lpa & LPA_PAUSE_CAP ? 1 : 0;
-			phydev->asym_pause = lpa & LPA_PAUSE_ASYM ? 1 : 0;
-		}
+		phy_resolve_aneg_pause(phydev);
 	} else {
 		int bmcr = phy_read(phydev, MII_BMCR);
 
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index b55b07edcd67..fa1b9c7bbf6c 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1260,10 +1260,7 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
 		mii_lpa_to_linkmode_lpa_t(phydev->lp_advertising, lpa);
 		mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising, lpagb);
 
-		if (phydev->duplex == DUPLEX_FULL) {
-			phydev->pause = lpa & LPA_PAUSE_CAP ? 1 : 0;
-			phydev->asym_pause = lpa & LPA_PAUSE_ASYM ? 1 : 0;
-		}
+		phy_resolve_aneg_pause(phydev);
 	} else {
 		/* The fiber link is only 1000M capable */
 		fiber_lpa_mod_linkmode_lpa_t(phydev->lp_advertising, lpa);
diff --git a/drivers/net/phy/uPD60620.c b/drivers/net/phy/uPD60620.c
index a32b3fd8a370..38834347a427 100644
--- a/drivers/net/phy/uPD60620.c
+++ b/drivers/net/phy/uPD60620.c
@@ -68,12 +68,7 @@ static int upd60620_read_status(struct phy_device *phydev)
 			mii_lpa_to_linkmode_lpa_t(phydev->lp_advertising,
 						  phy_state);
 
-			if (phydev->duplex == DUPLEX_FULL) {
-				if (phy_state & LPA_PAUSE_CAP)
-					phydev->pause = 1;
-				if (phy_state & LPA_PAUSE_ASYM)
-					phydev->asym_pause = 1;
-			}
+			phy_resolve_aneg_pause(phydev);
 		}
 	}
 	return 0;
-- 
2.20.1

