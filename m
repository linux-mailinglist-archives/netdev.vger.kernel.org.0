Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFA0BA1EC
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 13:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfIVLAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 07:00:23 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35614 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728396AbfIVLAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 07:00:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=X2gYjMQ4XJHcOR8Bfr7EokAsraZC40DECTwmGAxvifQ=; b=ZbUNsjlpztR3/vwTL9fXReUKKH
        8CtKob1PBnDwUnOcm4rv0SrxJk17Kyv6sPpz4Pz2N5ZIZpdzmkr97pcPS5+xQFjtLRSJgaXyQJ54U
        zvHNfcN8qpzDAQdq7WfTERjed36W2WAL9XRcEVMY7KHt1SWJCzdiupLUX3Tuvot7mpQq+F0GSd+tz
        NmCBKRA4dh1xueXGo2UYf/MCEiUjKQjksztq2NolER2pURk+oMJJmB4NVbBZKzxTJIQGh1ZH/zhJv
        s4yYpUruwf/9gbtV3e2gX/izRGy/+ur7UDgaaXWFZYzSli7jypB8V2UdVndQxmoU92JOhKjVI3CO/
        ttLazebg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:43954 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iBzbE-0006aq-Hg; Sun, 22 Sep 2019 12:00:16 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iBzbD-00006v-Fb; Sun, 22 Sep 2019 12:00:15 +0100
In-Reply-To: <20190922105932.GP25745@shell.armlinux.org.uk>
References: <20190922105932.GP25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 2/4] net: phy: extract link partner advertisement reading
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iBzbD-00006v-Fb@rmk-PC.armlinux.org.uk>
Date:   Sun, 22 Sep 2019 12:00:15 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move reading the link partner advertisement out of genphy_read_status()
into its own separate function.  This will allow re-use of this code by
PHY drivers that are able to read the resolved status from the PHY.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 65 +++++++++++++++++++++++++++-----------------
 include/linux/phy.h          |  1 +
 2 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2c506c3c6c7b..d17aafcde5a1 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1782,32 +1782,9 @@ int genphy_update_link(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_update_link);
 
-/**
- * genphy_read_status - check the link status and update current link state
- * @phydev: target phy_device struct
- *
- * Description: Check the link, then figure out the current state
- *   by comparing what we advertise with what the link partner
- *   advertises.  Start by checking the gigabit possibilities,
- *   then move on to 10/100.
- */
-int genphy_read_status(struct phy_device *phydev)
+int genphy_read_lpa(struct phy_device *phydev)
 {
-	int adv, lpa, lpagb, err, old_link = phydev->link;
-
-	/* Update the link, but return if there was an error */
-	err = genphy_update_link(phydev);
-	if (err)
-		return err;
-
-	/* why bother the PHY if nothing can have changed */
-	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
-		return 0;
-
-	phydev->speed = SPEED_UNKNOWN;
-	phydev->duplex = DUPLEX_UNKNOWN;
-	phydev->pause = 0;
-	phydev->asym_pause = 0;
+	int adv, lpa, lpagb;
 
 	linkmode_zero(phydev->lp_advertising);
 
@@ -1838,6 +1815,44 @@ int genphy_read_status(struct phy_device *phydev)
 			return lpa;
 
 		mii_lpa_mod_linkmode_lpa_t(phydev->lp_advertising, lpa);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(genphy_read_lpa);
+
+/**
+ * genphy_read_status - check the link status and update current link state
+ * @phydev: target phy_device struct
+ *
+ * Description: Check the link, then figure out the current state
+ *   by comparing what we advertise with what the link partner
+ *   advertises.  Start by checking the gigabit possibilities,
+ *   then move on to 10/100.
+ */
+int genphy_read_status(struct phy_device *phydev)
+{
+	int err, old_link = phydev->link;
+
+	/* Update the link, but return if there was an error */
+	err = genphy_update_link(phydev);
+	if (err)
+		return err;
+
+	/* why bother the PHY if nothing can have changed */
+	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
+		return 0;
+
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	err = genphy_read_lpa(phydev);
+	if (err < 0)
+		return err;
+
+	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
 		phy_resolve_aneg_linkmode(phydev);
 	} else if (phydev->autoneg == AUTONEG_DISABLE) {
 		int bmcr = phy_read(phydev, MII_BMCR);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0600754ce5e7..bef7f30af22d 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1085,6 +1085,7 @@ int genphy_config_eee_advert(struct phy_device *phydev);
 int genphy_config_aneg(struct phy_device *phydev);
 int genphy_aneg_done(struct phy_device *phydev);
 int genphy_update_link(struct phy_device *phydev);
+int genphy_read_lpa(struct phy_device *phydev);
 int genphy_read_status(struct phy_device *phydev);
 int genphy_suspend(struct phy_device *phydev);
 int genphy_resume(struct phy_device *phydev);
-- 
2.7.4

