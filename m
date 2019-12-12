Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9DE011D44D
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 18:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbfLLRnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 12:43:43 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33754 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730114AbfLLRnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 12:43:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SltXWcvZ7dN2oldZQNome5UIBaq/Hyb5rgTcJzCM5IM=; b=IBEJvLHAyvXjkzdW8p+fpzIpOu
        aFNnrpAQZ/L5no5L8Qpzx8+dpY+2phNxh7AGqBUPTLyvdbSs/ov8bNEGnfHzTLA6Gvi/DQgpnn/uN
        oYv4SsENIJ5QDfw/QD5DcsL3uUceoOn9lXao2iVxvDlFx/+BVT8/FYiK/RWdQqcRCv8nIkONOFj1u
        y00OFdoHiFSNzMnOlzYuDqsiZXtqzKRE8SaFFf8/o2htBLJ8EDsiM6K+m/AbErdCxkXAT9t6SXvHu
        aR6TUPyhmQjIfnx+yjv94nbzPhqT4wMhIcckwSRN1OtFpMV123G7CLq2g4h1zZ779b9joJPe/aEZo
        jwLLGmPQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:33584 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ifSUz-0008CE-0P; Thu, 12 Dec 2019 17:43:37 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ifSUy-0000am-7G; Thu, 12 Dec 2019 17:43:36 +0000
In-Reply-To: <20191212174309.GM25745@shell.armlinux.org.uk>
References: <20191212174309.GM25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] net: phylink: improve clause 45 PHY
 ksettings_set implementation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ifSUy-0000am-7G@rmk-PC.armlinux.org.uk>
Date:   Thu, 12 Dec 2019 17:43:36 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing ethtool with the Methode DM7052 module, it was noticed
that attempting to set the advertising mask results in the mask being
truncated to the support offered by the currently chosen PHY interface
mode.

When a PHY dynamically changes the PHY interface mode, limiting the
advertising mask in this way is not correct - if the PHY happened to
negotiate 10GBASE-T, and selected 10GBASE-R as the host interface, we
don't want to restrict the advertisement to just 10GBASE-* modes.

Rework setting the advertisement to take account of this; do not pass
the requested advertisement through phylink_validate(), but rely on
the advertisement restriction (supported mask) set when the PHY was
initially setup.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 84 ++++++++++++++++++++++++---------------
 1 file changed, 53 insertions(+), 31 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 8d20cf3ba0b7..2e5bc63c1dfa 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1229,44 +1229,66 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		__set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, config.advertising);
 	}
 
-	if (phylink_validate(pl, support, &config))
-		return -EINVAL;
-
-	/* If autonegotiation is enabled, we must have an advertisement */
-	if (config.an_enabled && phylink_is_empty_linkmode(config.advertising))
-		return -EINVAL;
-
-	our_kset = *kset;
-	linkmode_copy(our_kset.link_modes.advertising, config.advertising);
-	our_kset.base.speed = config.speed;
-	our_kset.base.duplex = config.duplex;
-
-	/* If we have a PHY, configure the phy */
 	if (pl->phydev) {
+		/* If we have a PHY, we process the kset change via phylib.
+		 * phylib will call our link state function if the PHY
+		 * parameters have changed, which will trigger a resolve
+		 * and update the MAC configuration.
+		 */
+		our_kset = *kset;
+		linkmode_copy(our_kset.link_modes.advertising,
+			      config.advertising);
+		our_kset.base.speed = config.speed;
+		our_kset.base.duplex = config.duplex;
+
 		ret = phy_ethtool_ksettings_set(pl->phydev, &our_kset);
 		if (ret)
 			return ret;
-	}
 
-	mutex_lock(&pl->state_mutex);
-	/* Configure the MAC to match the new settings */
-	linkmode_copy(pl->link_config.advertising, our_kset.link_modes.advertising);
-	pl->link_config.interface = config.interface;
-	pl->link_config.speed = our_kset.base.speed;
-	pl->link_config.duplex = our_kset.base.duplex;
-	pl->link_config.an_enabled = our_kset.base.autoneg != AUTONEG_DISABLE;
+		mutex_lock(&pl->state_mutex);
+		/* Save the new configuration */
+		linkmode_copy(pl->link_config.advertising,
+			      our_kset.link_modes.advertising);
+		pl->link_config.interface = config.interface;
+		pl->link_config.speed = our_kset.base.speed;
+		pl->link_config.duplex = our_kset.base.duplex;
+		pl->link_config.an_enabled = our_kset.base.autoneg !=
+					     AUTONEG_DISABLE;
+		mutex_unlock(&pl->state_mutex);
+	} else {
+		/* For a fixed link, this isn't able to change any parameters,
+		 * which just leaves inband mode.
+		 */
+		if (phylink_validate(pl, support, &config))
+			return -EINVAL;
 
-	/* If we have a PHY, phylib will call our link state function if the
-	 * mode has changed, which will trigger a resolve and update the MAC
-	 * configuration. For a fixed link, this isn't able to change any
-	 * parameters, which just leaves inband mode.
-	 */
-	if (pl->cur_link_an_mode == MLO_AN_INBAND &&
-	    !test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state)) {
-		phylink_mac_config(pl, &pl->link_config);
-		phylink_mac_an_restart(pl);
+		/* If autonegotiation is enabled, we must have an advertisement */
+		if (config.an_enabled &&
+		    phylink_is_empty_linkmode(config.advertising))
+			return -EINVAL;
+
+		mutex_lock(&pl->state_mutex);
+		linkmode_copy(pl->link_config.advertising, config.advertising);
+		pl->link_config.interface = config.interface;
+		pl->link_config.speed = config.speed;
+		pl->link_config.duplex = config.duplex;
+		pl->link_config.an_enabled = kset->base.autoneg !=
+					     AUTONEG_DISABLE;
+
+		if (pl->cur_link_an_mode == MLO_AN_INBAND &&
+		    !test_bit(PHYLINK_DISABLE_STOPPED,
+			      &pl->phylink_disable_state)) {
+			/* If in 802.3z mode, this updates the advertisement.
+			 *
+			 * If we are in SGMII mode without a PHY, there is no
+			 * advertisement; the only thing we have is the pause
+			 * modes which can only come from a PHY.
+			 */
+			phylink_mac_config(pl, &pl->link_config);
+			phylink_mac_an_restart(pl);
+		}
+		mutex_unlock(&pl->state_mutex);
 	}
-	mutex_unlock(&pl->state_mutex);
 
 	return 0;
 }
-- 
2.20.1

