Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7636122D12
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbfLQNjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:39:31 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56760 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfLQNja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:39:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XYIOiwSWBmp8/JZZhydw96RIDNhdJ6eK1+P3g43+4u4=; b=N/YYdLR4r6YSIx/cnErLiNq8sd
        3eavkYa+CSuaOul5tVpadzvKePW7KQM4gwGp/FXxyIWRdY0HkOx2CTXYNgNxtproK+0LVfYcOtcwe
        SmEjqwlujMok3mjG/OMLoPcIyoW3JAmrlQq5Ix4oi4Y75zlPxtMBcHM92txWbwi61NkCQ0v0NIXFE
        EoOKPtgyup7bcIPuuTCXpegb5np9rQE7tZvhKRtUw9T+7KeAw45XK9FEbx8iXY9zh3tDDyAWrSi2W
        /VxDaDwPegYIhROBLWFxKI6hVaTu++K0oLTS5g+SyFLFzrHt3PKOhOeC+iLgm7quRmE6wIUIftq5z
        dYqV33Tw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:35584 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4I-0006F3-2z; Tue, 17 Dec 2019 13:39:18 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4G-0001yf-BK; Tue, 17 Dec 2019 13:39:16 +0000
In-Reply-To: <20191217133827.GQ25745@shell.armlinux.org.uk>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 04/11] net: phy: provide and use
 genphy_read_status_fixed()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ihD4G-0001yf-BK@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Dec 2019 13:39:16 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two drivers and generic code which contain exactly the same
code to read the status of a PHY operating without autonegotiation
enabled. Rather than duplicate this code, provide a helper to read
this information.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/lxt.c        | 19 +++-----------
 drivers/net/phy/marvell.c    | 19 +++-----------
 drivers/net/phy/phy_device.c | 49 ++++++++++++++++++++++++------------
 include/linux/phy.h          |  1 +
 4 files changed, 41 insertions(+), 47 deletions(-)

diff --git a/drivers/net/phy/lxt.c b/drivers/net/phy/lxt.c
index 30172852e36e..fec58ad69e02 100644
--- a/drivers/net/phy/lxt.c
+++ b/drivers/net/phy/lxt.c
@@ -192,22 +192,9 @@ static int lxt973a2_read_status(struct phy_device *phydev)
 
 		phy_resolve_aneg_pause(phydev);
 	} else {
-		int bmcr = phy_read(phydev, MII_BMCR);
-
-		if (bmcr < 0)
-			return bmcr;
-
-		if (bmcr & BMCR_FULLDPLX)
-			phydev->duplex = DUPLEX_FULL;
-		else
-			phydev->duplex = DUPLEX_HALF;
-
-		if (bmcr & BMCR_SPEED1000)
-			phydev->speed = SPEED_1000;
-		else if (bmcr & BMCR_SPEED100)
-			phydev->speed = SPEED_100;
-		else
-			phydev->speed = SPEED_10;
+		err = genphy_read_status_fixed(phydev);
+		if (err < 0)
+			return err;
 
 		phydev->pause = phydev->asym_pause = 0;
 		linkmode_zero(phydev->lp_advertising);
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index fa1b9c7bbf6c..fa0ec116960e 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1283,22 +1283,11 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
 
 static int marvell_read_status_page_fixed(struct phy_device *phydev)
 {
-	int bmcr = phy_read(phydev, MII_BMCR);
-
-	if (bmcr < 0)
-		return bmcr;
-
-	if (bmcr & BMCR_FULLDPLX)
-		phydev->duplex = DUPLEX_FULL;
-	else
-		phydev->duplex = DUPLEX_HALF;
+	int err;
 
-	if (bmcr & BMCR_SPEED1000)
-		phydev->speed = SPEED_1000;
-	else if (bmcr & BMCR_SPEED100)
-		phydev->speed = SPEED_100;
-	else
-		phydev->speed = SPEED_10;
+	err = genphy_read_status_fixed(phydev);
+	if (err < 0)
+		return err;
 
 	phydev->pause = 0;
 	phydev->asym_pause = 0;
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index e5854508627b..86a0f5f77278 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1897,6 +1897,36 @@ int genphy_read_lpa(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_read_lpa);
 
+/**
+ * genphy_read_status_fixed - read the link parameters for !aneg mode
+ * @phydev: target phy_device struct
+ *
+ * Read the current duplex and speed state for a PHY operating with
+ * autonegotiation disabled.
+ */
+int genphy_read_status_fixed(struct phy_device *phydev)
+{
+	int bmcr = phy_read(phydev, MII_BMCR);
+
+	if (bmcr < 0)
+		return bmcr;
+
+	if (bmcr & BMCR_FULLDPLX)
+		phydev->duplex = DUPLEX_FULL;
+	else
+		phydev->duplex = DUPLEX_HALF;
+
+	if (bmcr & BMCR_SPEED1000)
+		phydev->speed = SPEED_1000;
+	else if (bmcr & BMCR_SPEED100)
+		phydev->speed = SPEED_100;
+	else
+		phydev->speed = SPEED_10;
+
+	return 0;
+}
+EXPORT_SYMBOL(genphy_read_status_fixed);
+
 /**
  * genphy_read_status - check the link status and update current link state
  * @phydev: target phy_device struct
@@ -1931,22 +1961,9 @@ int genphy_read_status(struct phy_device *phydev)
 	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
 		phy_resolve_aneg_linkmode(phydev);
 	} else if (phydev->autoneg == AUTONEG_DISABLE) {
-		int bmcr = phy_read(phydev, MII_BMCR);
-
-		if (bmcr < 0)
-			return bmcr;
-
-		if (bmcr & BMCR_FULLDPLX)
-			phydev->duplex = DUPLEX_FULL;
-		else
-			phydev->duplex = DUPLEX_HALF;
-
-		if (bmcr & BMCR_SPEED1000)
-			phydev->speed = SPEED_1000;
-		else if (bmcr & BMCR_SPEED100)
-			phydev->speed = SPEED_100;
-		else
-			phydev->speed = SPEED_10;
+		err = genphy_read_status_fixed(phydev);
+		if (err < 0)
+			return err;
 	}
 
 	return 0;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index dbcd887f9015..11d25556f803 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1101,6 +1101,7 @@ int __genphy_config_aneg(struct phy_device *phydev, bool changed);
 int genphy_aneg_done(struct phy_device *phydev);
 int genphy_update_link(struct phy_device *phydev);
 int genphy_read_lpa(struct phy_device *phydev);
+int genphy_read_status_fixed(struct phy_device *phydev);
 int genphy_read_status(struct phy_device *phydev);
 int genphy_suspend(struct phy_device *phydev);
 int genphy_resume(struct phy_device *phydev);
-- 
2.20.1

