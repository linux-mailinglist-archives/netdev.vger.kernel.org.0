Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5698D1074B2
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 16:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfKVPSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 10:18:18 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46842 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfKVPSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 10:18:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=S5L7BjZHO8thiPv1QWa60O7ILswwEmqo2zhf/pLdDog=; b=rrrtkt13z/ntlIm8yKQ9ejrqEE
        1D8fF4yxyyR4TGPluPPn0iKYjN0LRLoeVPgN3eQhpIysOUi1PSNBx23ORoH7z6+0/NFeySk/tges/
        a2xvGG91yQkrIn2EJzESz/N0yJZ7cn6tUU0/Sl/bbkKYPAL1rznBWofIvcLjKlgis2n5qiqAmfFOZ
        qwx9Y3NNbngeutmAestB3l+nvkmwL25sE0aoHM1Aaice7C5m+q+Y6E146Hrbw3B/xZAVoayYAcwGQ
        Hpy0zWK/vWDaX1cyn+0f8nl1ZPH1eJ+Wqsm/yc8Sva3bse0lBt7ODnGSEkBYxem08qN4/xiEZ1tz0
        4X/Lw/aw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:36126 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iYAhH-0005uL-0w; Fri, 22 Nov 2019 15:18:11 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iYAhG-0005c2-8H; Fri, 22 Nov 2019 15:18:10 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [RFC] net: phy: allow ethtool to set any supported fixed speed
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iYAhG-0005c2-8H@rmk-PC.armlinux.org.uk>
Date:   Fri, 22 Nov 2019 15:18:10 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phylib restricts the fixed speed to 1000, 100 or 10Mbps, even if the
PHY supports other speeds, or doesn't even support these speeds.
Validate the fixed speed against the PHY capabilities, and return an
error if we are unable to find a match.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
NOTE: is this correct behaviour - or should we do something like:

	s = phy_lookup_setting(speed, duplex, phydev->support, false);
	if (!s)
		return -EINVAL;

	phydev->speed = speed;
	phydev->duplex = duplex;

IOW, set either an exact match, or a slower supported speed than was
requested, or the slowest?  That's how phy_sanitize_settings() is
implemented, which I replicated for phylink's ethtool implementation.

Another issue here is with the validation of the settings that the
user passed in - this looks very racy.  Consider the following:

- another thread calls phy_ethtool_ksettings_set(), which sets
  phydev->speed and phydev->duplex, and disables autoneg.
- the phylib state machine is running, and overwrites the
  phydev->speed and phydev->duplex settings
- phy_ethtool_ksettings_set() then calls phy_start_aneg() which
  sets the PHY up with the phylib-read settings rather than the
  settings the user requested.

IMHO, phylib needs to keep the user requested settings separate from
the readback state from the PHY.

Yet another issue is what to do when a PHY doesn't support disabled
autoneg (or it's not known how to make it work) - the PHY driver
doesn't get a look-in to validate the settings, phylib just expects
every PHY out there to support it.  The best the PHY driver can do
is to cause it's config_aneg() method to return -EINVAL, dropping
the PHY state machine into PHY_HALTED mode via phy_error() - which
will then provoke a nice big stack dump in phy_stop() when the
network device is downed as phy_is_started() will return false.
Clearly not a good user experience on any level (API or kernel
behaviour.)

 drivers/net/phy/phy.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 9e431b9f9d87..75d11c48afce 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -270,31 +270,32 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 	linkmode_and(advertising, advertising, phydev->supported);
 
 	/* Verify the settings we care about. */
-	if (autoneg != AUTONEG_ENABLE && autoneg != AUTONEG_DISABLE)
-		return -EINVAL;
+	switch (autoneg) {
+	case AUTONEG_ENABLE:
+		if (linkmode_empty(advertising))
+			return -EINVAL;
+		break;
+	
+	case AUTONEG_DISABLE:
+		if (duplex != DUPLEX_HALF && duplex != DUPLEX_FULL)
+			return -EINVAL;
 
-	if (autoneg == AUTONEG_ENABLE && linkmode_empty(advertising))
-		return -EINVAL;
+		if (!phy_lookup_setting(speed, duplex, phydev->supported, true))
+			return -EINVAL;
+		break;
 
-	if (autoneg == AUTONEG_DISABLE &&
-	    ((speed != SPEED_1000 &&
-	      speed != SPEED_100 &&
-	      speed != SPEED_10) ||
-	     (duplex != DUPLEX_HALF &&
-	      duplex != DUPLEX_FULL)))
+	default:
 		return -EINVAL;
+	}
 
 	phydev->autoneg = autoneg;
-
+	phydev->duplex = duplex;
 	phydev->speed = speed;
 
 	linkmode_copy(phydev->advertising, advertising);
-
 	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
 			 phydev->advertising, autoneg == AUTONEG_ENABLE);
 
-	phydev->duplex = duplex;
-
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 
 	/* Restart the PHY */
-- 
2.20.1

