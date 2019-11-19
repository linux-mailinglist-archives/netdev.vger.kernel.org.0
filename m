Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0552102AC6
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 18:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfKSR2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 12:28:22 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54728 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbfKSR2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 12:28:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ljY18yPjADPQ3q4miK00UfYs37VzBFw+sHL1UzkFa90=; b=fF90V6i0n0Be8rF1Fj46iF/a6A
        WovrmZRg48gOgj7UEWhSr2kVdyUfKcqeR6yWFOq872OPfdYiqRNt/3FgvDYbbG95DT772r/ItWepi
        luRrFh2eJleIg6VapAG4FIScsNoa6nQXz4gdbIJgU3EkAUQj14EO3EIIJxJZFzgY05R5IEVhSfkA+
        PEwNimHwyyMqffWxH5JauZ+WbG8lO6rJ6vXgd06qe38GJO3D1K1Bt9pD5zzV44/9Fjo5Ee6z7Wwup
        5ZhKLgC8VrRVp6HaNYbBw/EE0osK/ysDTJ1Vbc3CwqjaqxptWEIT3oLGLCoy6gjU+Y6/4e96yuL1U
        9ABuP0UQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:36726 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iX7IV-0002mW-GH; Tue, 19 Nov 2019 17:28:15 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iX7IU-0000qH-T4; Tue, 19 Nov 2019 17:28:14 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net] net: phylink: fix link mode modification in PHY mode
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iX7IU-0000qH-T4@rmk-PC.armlinux.org.uk>
Date:   Tue, 19 Nov 2019 17:28:14 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modifying the link settings via phylink_ethtool_ksettings_set() and
phylink_ethtool_set_pauseparam() didn't always work as intended for
PHY based setups, as calling phylink_mac_config() would result in the
unresolved configuration being committed to the MAC, rather than the
configuration with the speed and duplex setting.

This would work fine if the update caused the link to renegotiate,
but if no settings have changed, phylib won't trigger a renegotiation
cycle, and the MAC will be left incorrectly configured.

Avoid calling phylink_mac_config() unless we are using an inband mode
in phylink_ethtool_ksettings_set(), and use phy_set_asym_pause() as
introduced in 4.20 to set the PHY settings in
phylink_ethtool_set_pauseparam().

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5f213dbd8511..342521ed7e7a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1255,7 +1255,13 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 	pl->link_config.duplex = our_kset.base.duplex;
 	pl->link_config.an_enabled = our_kset.base.autoneg != AUTONEG_DISABLE;
 
-	if (!test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state)) {
+	/* If we have a PHY, phylib will call our link state function if the
+	 * mode has changed, which will trigger a resolve and update the MAC
+	 * configuration. For a fixed link, this isn't able to change any
+	 * parameters, which just leaves inband mode.
+	 */
+	if (pl->link_an_mode == MLO_AN_INBAND &&
+	    !test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state)) {
 		phylink_mac_config(pl, &pl->link_config);
 		phylink_mac_an_restart(pl);
 	}
@@ -1335,15 +1341,16 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 	if (pause->tx_pause)
 		config->pause |= MLO_PAUSE_TX;
 
-	if (!test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state)) {
+	/* If we have a PHY, phylib will call our link state function if the
+	 * mode has changed, which will trigger a resolve and update the MAC
+	 * configuration.
+	 */
+	if (pl->phydev) {
+		phy_set_asym_pause(pl->phydev, pause->rx_pause,
+				   pause->tx_pause);
+	} else if (!test_bit(PHYLINK_DISABLE_STOPPED,
+			     &pl->phylink_disable_state)) {
 		switch (pl->link_an_mode) {
-		case MLO_AN_PHY:
-			/* Silently mark the carrier down, and then trigger a resolve */
-			if (pl->netdev)
-				netif_carrier_off(pl->netdev);
-			phylink_run_resolve(pl);
-			break;
-
 		case MLO_AN_FIXED:
 			/* Should we allow fixed links to change against the config? */
 			phylink_resolve_flow(pl, config);
-- 
2.20.1

