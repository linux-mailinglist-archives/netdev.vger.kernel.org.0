Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E059F433371
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbhJSK1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 06:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbhJSK1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 06:27:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20FAC06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 03:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kjOLBFA43Tt9DxqEV9OuWRcPfJMVKjcUndge09/kfAk=; b=PFeCb8h9Am0/IRlPDofGpKUFKj
        QrydvY2hxkQfqwYfmbXOXxPabsr2zZdoobrjmM777vKxoK4+rh59UMHN2RaShzghmoAk4JBFOhYbw
        sYnN5yZ+sq3eUmF9cYvmr4NH3LGDxYKIUowoyaQV6lVAtfoUKke4Xe9coZu+wt5+yGZqVYR7RjHo/
        c1BfmdTn1Lqh7FKRCZ102md0mTOAnfsW8xkY5Ut+nj2Gfb4lFR/W9TR8pOML1HnKccpedvRX5tsQr
        NKh6HOz5TOYYg1YD/51pqwjcsPMNC0ml+vT0gXpBIjX31zw/97ByXa9SCVvPZFSIyY9zdkGkPEJCL
        BjmS/6pA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:32836 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mcmIc-0005zZ-EX; Tue, 19 Oct 2021 11:24:50 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mcmIc-005LpO-13; Tue, 19 Oct 2021 11:24:50 +0100
From:   Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phylink: Support disabling autonegotiation for
 PCS
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mcmIc-005LpO-13@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 19 Oct 2021 11:24:50 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

The auto-negotiation state in the PCS as set by
phylink_mii_c22_pcs_config was previously always enabled when the
driver is configured for in-band autonegotiation, even if
autonegotiation was disabled on the interface with ethtool. Update the
code to set the BMCR_ANENABLE bit based on the interface's
autonegotiation enabled state.

Update phylink_mii_c22_pcs_get_state to not check
autonegotiation-related fields when autonegotiation is disabled.

Update phylink_mac_pcs_get_state to initialize the state based on the
interface's configured speed, duplex and pause parameters rather than
to unknown when autonegotiation is disabled, before calling the
driver's pcs_get_state functions, as they are not likely to provide
meaningful data for these fields when autonegotiation is disabled. In
this case the driver is really just filling in the link state field.

Note that in cases where there is a downstream PHY connected, such as
with SGMII and a copper PHY, the configuration set by ethtool is
handled by phy_ethtool_ksettings_set and not propagated to the PCS.
This is correct since SGMII or 1000Base-X autonegotiation with the PCS
should normally still be used even if the copper side has disabled it.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f6e848f1181c..5f0ecb43029f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -552,9 +552,15 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 	linkmode_zero(state->lp_advertising);
 	state->interface = pl->link_config.interface;
 	state->an_enabled = pl->link_config.an_enabled;
-	state->speed = SPEED_UNKNOWN;
-	state->duplex = DUPLEX_UNKNOWN;
-	state->pause = MLO_PAUSE_NONE;
+	if  (state->an_enabled) {
+		state->speed = SPEED_UNKNOWN;
+		state->duplex = DUPLEX_UNKNOWN;
+		state->pause = MLO_PAUSE_NONE;
+	} else {
+		state->speed =  pl->link_config.speed;
+		state->duplex = pl->link_config.duplex;
+		state->pause = pl->link_config.pause;
+	}
 	state->an_complete = 0;
 	state->link = 1;
 
@@ -2548,7 +2554,10 @@ void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 
 	state->link = !!(bmsr & BMSR_LSTATUS);
 	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
-	if (!state->link)
+	/* If there is no link or autonegotiation is disabled, the LP advertisement
+	 * data is not meaningful, so don't go any further.
+	 */
+	if (!state->link || !state->an_enabled)
 		return;
 
 	switch (state->interface) {
@@ -2650,7 +2659,12 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 	changed = ret > 0;
 
 	/* Ensure ISOLATE bit is disabled */
-	bmcr = mode == MLO_AN_INBAND ? BMCR_ANENABLE : 0;
+	if (mode == MLO_AN_INBAND &&
+	    linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising))
+		bmcr = BMCR_ANENABLE;
+	else
+		bmcr = 0;
+
 	ret = mdiobus_modify(pcs->bus, pcs->addr, MII_BMCR,
 			     BMCR_ANENABLE | BMCR_ISOLATE, bmcr);
 	if (ret < 0)
-- 
2.30.2

