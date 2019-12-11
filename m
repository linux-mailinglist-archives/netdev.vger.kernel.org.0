Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08E1E11A95D
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 11:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbfLKK4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 05:56:50 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39566 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfLKK4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 05:56:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oCwuSA1BWZf9b2MRiMExNybJPpwAFuuZODLKwmjRiUU=; b=Xgjc7wgy+MprIGqdLz77OWyFmM
        p9QMrpLuu3Cqn0/wvhvOFp0DZrdk5F51MCFfDwNmSbNwqZ2Zek1It1jvPWqy0XvXk1hMd6JxEViNd
        wtWHRR8l5y3oSYf8XP73EF5L6Fc2LiTYpOfFd8Isvx+41qsUTEuysnDrx8AI6/cLucsLft1OSdU62
        oXJxDG5dWJiHg/LXyr3gtZJaumUHobkR1ALZ/4zjvp0BzgtZi9CUXkUw1a3cSB9Wgt6C+upa9RgR5
        ZFRqCKJdTwqFLtYKOt76iWaR/0Ybl08Trn6CvGTNVhZJEm4L0g+mWfUxsFBi/O52BXVzkSfFOIBMh
        QUpFnMsg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60984 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfU-0007vA-W7; Wed, 11 Dec 2019 10:56:33 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfS-0002yR-Al; Wed, 11 Dec 2019 10:56:30 +0000
In-Reply-To: <20191211104821.GB25745@shell.armlinux.org.uk>
References: <20191211104821.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 08/14] net: phylink: support Clause 45 PHYs on
 SFP+ modules
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iezfS-0002yR-Al@rmk-PC.armlinux.org.uk>
Date:   Wed, 11 Dec 2019 10:56:30 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some SFP+ modules have Clause 45 PHYs embedded on them, which need a
little more handling in order to ensure that they are correctly setup,
as they switch the PHY link mode according to the negotiated speed.

With Clause 22 PHYs, we assumed that they would operate in SGMII mode,
but this assumption is now false.  Adapt phylink to support Clause 45
PHYs on SFP+ modules.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index e6157534d3bd..370c9fcb0cda 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -711,7 +711,8 @@ static void phylink_phy_change(struct phy_device *phydev, bool up,
 		    phy_duplex_to_str(phydev->duplex));
 }
 
-static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy)
+static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
+			       phy_interface_t interface)
 {
 	struct phylink_link_state config;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
@@ -729,7 +730,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy)
 	memset(&config, 0, sizeof(config));
 	linkmode_copy(supported, phy->supported);
 	linkmode_copy(config.advertising, phy->advertising);
-	config.interface = pl->link_config.interface;
+	config.interface = interface;
 
 	ret = phylink_validate(pl, supported, &config);
 	if (ret)
@@ -745,6 +746,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy)
 	mutex_lock(&phy->lock);
 	mutex_lock(&pl->state_mutex);
 	pl->phydev = phy;
+	pl->phy_state.interface = interface;
 	linkmode_copy(pl->supported, supported);
 	linkmode_copy(pl->link_config.advertising, config.advertising);
 
@@ -807,7 +809,7 @@ int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
 	if (ret < 0)
 		return ret;
 
-	ret = phylink_bringup_phy(pl, phy);
+	ret = phylink_bringup_phy(pl, phy, pl->link_config.interface);
 	if (ret)
 		phy_detach(phy);
 
@@ -860,7 +862,7 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 	if (!phy_dev)
 		return -ENODEV;
 
-	ret = phylink_bringup_phy(pl, phy_dev);
+	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
 	if (ret)
 		phy_detach(phy_dev);
 
@@ -1812,13 +1814,22 @@ static void phylink_sfp_link_up(void *upstream)
 static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 {
 	struct phylink *pl = upstream;
+	phy_interface_t interface = pl->link_config.interface;
 	int ret;
 
 	ret = phylink_attach_phy(pl, phy, pl->link_config.interface);
 	if (ret < 0)
 		return ret;
 
-	ret = phylink_bringup_phy(pl, phy);
+	/* Clause 45 PHYs switch their Serdes lane between several different
+	 * modes, normally 10GBASE-R, SGMII. Some use 2500BASE-X for 2.5G
+	 * speeds.  We really need to know which interface modes the PHY and
+	 * MAC supports to properly work out which linkmodes can be supported.
+	 */
+	if (phy->is_c45)
+		interface = PHY_INTERFACE_MODE_NA;
+
+	ret = phylink_bringup_phy(pl, phy, interface);
 	if (ret)
 		phy_detach(phy);
 
-- 
2.20.1

