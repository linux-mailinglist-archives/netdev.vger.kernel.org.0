Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA086227E08
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgGULEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgGULEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 07:04:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47BCC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 04:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=e/myFuW2bbLC3yi1tkqL4NVSZCgEETvwLtnZfvUdXzE=; b=zC6dAjj+NyQXoxNWiHZAF5u20v
        rbCzvZ0DtNavmpSq7AH0MAFzlY9FG6ZcZeEd7bQKglgejQoV2/qR1Mn02F5oYShLA+YuFGuadoL0R
        YFQaBB75taeca75/6KDOEOb1y94yB9cAtTftTEfo5gc9QPzL5+feGUJXpir6tT/FhyNKlosDePiax
        uotrNlmDXA9f52vwJ9ck/KBb/DdQ46ciS2SiADDzsQr0UbbaCjSOWrLVQSm37ja59uDmwDDa3PxMd
        fSc4/tsQujjmYwXhr2oRq0p+Hqe6psSA8c9iESioIJRpK7BSb8s8I+0JOEnu/XrgM8YoexgOnchvQ
        a/gXaLsg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41770 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq4L-0004Fp-CO; Tue, 21 Jul 2020 12:04:21 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq4L-0004SM-5w; Tue, 21 Jul 2020 12:04:21 +0100
In-Reply-To: <20200721110152.GY1551@shell.armlinux.org.uk>
References: <20200721110152.GY1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 08/14] net: phylink: simplify phy case for
 ksettings_set method
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jxq4L-0004SM-5w@rmk-PC.armlinux.org.uk>
Date:   Tue, 21 Jul 2020 12:04:21 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we have a PHY attached, an ethtool ksettings_set() call only
really needs to call through to the phylib equivalent; phylib will
call back to us when the link changes so we can update our state.
Therefore, we can bypass most of our ksettings_set() call for this
case.

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 104 +++++++++++++++++---------------------
 1 file changed, 47 insertions(+), 57 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 103d2a550415..967c068d16c8 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1312,13 +1312,33 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 				  const struct ethtool_link_ksettings *kset)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(support);
-	struct ethtool_link_ksettings our_kset;
 	struct phylink_link_state config;
 	const struct phy_setting *s;
-	int ret;
 
 	ASSERT_RTNL();
 
+	if (pl->phydev) {
+		/* We can rely on phylib for this update; we also do not need
+		 * to update the pl->link_config settings:
+		 * - the configuration returned via ksettings_get() will come
+		 *   from phylib whenever a PHY is present.
+		 * - link_config.interface will be updated by the PHY calling
+		 *   back via phylink_phy_change() and a subsequent resolve.
+		 * - initial link configuration for PHY mode comes from the
+		 *   last phy state updated via phylink_phy_change().
+		 * - other configuration changes (e.g. pause modes) are
+		 *   performed directly via phylib.
+		 * - if in in-band mode with a PHY, the link configuration
+		 *   is passed on the link from the PHY, and all of
+		 *   link_config.{speed,duplex,an_enabled,pause} are not used.
+		 * - the only possible use would be link_config.advertising
+		 *   pause modes when in 1000base-X mode with a PHY, but in
+		 *   the presence of a PHY, this should not be changed as that
+		 *   should be determined from the media side advertisement.
+		 */
+		return phy_ethtool_ksettings_set(pl->phydev, kset);
+	}
+
 	linkmode_copy(support, pl->supported);
 	config = pl->link_config;
 	config.an_enabled = kset->base.autoneg == AUTONEG_ENABLE;
@@ -1365,65 +1385,35 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		return -EINVAL;
 	}
 
-	if (pl->phydev) {
-		/* If we have a PHY, we process the kset change via phylib.
-		 * phylib will call our link state function if the PHY
-		 * parameters have changed, which will trigger a resolve
-		 * and update the MAC configuration.
-		 */
-		our_kset = *kset;
-		linkmode_copy(our_kset.link_modes.advertising,
-			      config.advertising);
-		our_kset.base.speed = config.speed;
-		our_kset.base.duplex = config.duplex;
+	/* For a fixed link, this isn't able to change any parameters,
+	 * which just leaves inband mode.
+	 */
+	if (phylink_validate(pl, support, &config))
+		return -EINVAL;
 
-		ret = phy_ethtool_ksettings_set(pl->phydev, &our_kset);
-		if (ret)
-			return ret;
+	/* If autonegotiation is enabled, we must have an advertisement */
+	if (config.an_enabled && phylink_is_empty_linkmode(config.advertising))
+		return -EINVAL;
 
-		mutex_lock(&pl->state_mutex);
-		/* Save the new configuration */
-		linkmode_copy(pl->link_config.advertising,
-			      our_kset.link_modes.advertising);
-		pl->link_config.interface = config.interface;
-		pl->link_config.speed = our_kset.base.speed;
-		pl->link_config.duplex = our_kset.base.duplex;
-		pl->link_config.an_enabled = our_kset.base.autoneg !=
-					     AUTONEG_DISABLE;
-		mutex_unlock(&pl->state_mutex);
-	} else {
-		/* For a fixed link, this isn't able to change any parameters,
-		 * which just leaves inband mode.
+	mutex_lock(&pl->state_mutex);
+	linkmode_copy(pl->link_config.advertising, config.advertising);
+	pl->link_config.interface = config.interface;
+	pl->link_config.speed = config.speed;
+	pl->link_config.duplex = config.duplex;
+	pl->link_config.an_enabled = kset->base.autoneg !=
+				     AUTONEG_DISABLE;
+
+	if (pl->cur_link_an_mode == MLO_AN_INBAND &&
+	    !test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state)) {
+		/* If in 802.3z mode, this updates the advertisement.
+		 *
+		 * If we are in SGMII mode without a PHY, there is no
+		 * advertisement; the only thing we have is the pause
+		 * modes which can only come from a PHY.
 		 */
-		if (phylink_validate(pl, support, &config))
-			return -EINVAL;
-
-		/* If autonegotiation is enabled, we must have an advertisement */
-		if (config.an_enabled &&
-		    phylink_is_empty_linkmode(config.advertising))
-			return -EINVAL;
-
-		mutex_lock(&pl->state_mutex);
-		linkmode_copy(pl->link_config.advertising, config.advertising);
-		pl->link_config.interface = config.interface;
-		pl->link_config.speed = config.speed;
-		pl->link_config.duplex = config.duplex;
-		pl->link_config.an_enabled = kset->base.autoneg !=
-					     AUTONEG_DISABLE;
-
-		if (pl->cur_link_an_mode == MLO_AN_INBAND &&
-		    !test_bit(PHYLINK_DISABLE_STOPPED,
-			      &pl->phylink_disable_state)) {
-			/* If in 802.3z mode, this updates the advertisement.
-			 *
-			 * If we are in SGMII mode without a PHY, there is no
-			 * advertisement; the only thing we have is the pause
-			 * modes which can only come from a PHY.
-			 */
-			phylink_pcs_config(pl, true, &pl->link_config);
-		}
-		mutex_unlock(&pl->state_mutex);
+		phylink_pcs_config(pl, true, &pl->link_config);
 	}
+	mutex_unlock(&pl->state_mutex);
 
 	return 0;
 }
-- 
2.20.1

