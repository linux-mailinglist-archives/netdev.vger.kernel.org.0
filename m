Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1694815FF16
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 16:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgBOPuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 10:50:07 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34124 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgBOPuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 10:50:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sXE92553TT0mhkkYq4jDKBTTd0yY5Si4qJ7+XHw3oA4=; b=bUbWYXICprCBPoFH9jKeQzKODF
        QWjdqICXY86CVrPKrUz9VUgNVmCowNejGoJgbkKcywPHKAGbV1oCObZeCoIH6T3480QpTdb/2OVDB
        /Ip9ZCEoeS60s6IaoRV8ZSBpXMKQgJTQMie3uN54xr1Bj/8gtfEvRzBpvUg9esuTo/kvJJzX7e9Y5
        cFFdkPuDgPoPYzZ3/Ud9RH8FkWoU1M2Znef/tHapLc80/PhNI7A7NxuFsWy9hygNQdOHH5wBjdofn
        SX4L/36kQXQvAAQaOM03ZL97HmAyThMkzjc0IL+2f6pJaqm54D8MieampAQwxqkmV5XQ7awGFcLtq
        71hz9peQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45452 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhb-0005jz-9r; Sat, 15 Feb 2020 15:49:55 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhZ-0003Y5-K7; Sat, 15 Feb 2020 15:49:53 +0000
In-Reply-To: <20200215154839.GR25745@shell.armlinux.org.uk>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 07/10] net: phylink: resolve fixed link flow control
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j2zhZ-0003Y5-K7@rmk-PC.armlinux.org.uk>
Date:   Sat, 15 Feb 2020 15:49:53 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resolve the fixed link flow control using the recently introduced
linkmode_resolve_pause() helper, which we use in
phylink_get_fixed_state() only when operating in full duplex mode.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 70 +++++++++++++++++----------------------
 include/linux/phylink.h   |  8 ++---
 2 files changed, 34 insertions(+), 44 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index e65e9c9dc759..c29648b90ce7 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -181,9 +181,11 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 		/* We treat the "pause" and "asym-pause" terminology as
 		 * defining the link partner's ability. */
 		if (fwnode_property_read_bool(fixed_node, "pause"))
-			pl->link_config.pause |= MLO_PAUSE_SYM;
+			__set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+				  pl->link_config.lp_advertising);
 		if (fwnode_property_read_bool(fixed_node, "asym-pause"))
-			pl->link_config.pause |= MLO_PAUSE_ASYM;
+			__set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+				  pl->link_config.lp_advertising);
 
 		if (ret == 0) {
 			desc = fwnode_gpiod_get_index(fixed_node, "link", 0,
@@ -215,9 +217,11 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 						DUPLEX_FULL : DUPLEX_HALF;
 			pl->link_config.speed = prop[2];
 			if (prop[3])
-				pl->link_config.pause |= MLO_PAUSE_SYM;
+				__set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+					  pl->link_config.lp_advertising);
 			if (prop[4])
-				pl->link_config.pause |= MLO_PAUSE_ASYM;
+				__set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+					  pl->link_config.lp_advertising);
 		}
 	}
 
@@ -351,6 +355,22 @@ static void phylink_apply_manual_flow(struct phylink *pl,
 		state->pause = pl->link_config.pause;
 }
 
+static void phylink_resolve_flow(struct phylink_link_state *state)
+{
+	bool tx_pause, rx_pause;
+
+	state->pause = MLO_PAUSE_NONE;
+	if (state->duplex == DUPLEX_FULL) {
+		linkmode_resolve_pause(state->advertising,
+				       state->lp_advertising,
+				       &tx_pause, &rx_pause);
+		if (tx_pause)
+			state->pause |= MLO_PAUSE_TX;
+		if (rx_pause)
+			state->pause |= MLO_PAUSE_RX;
+	}
+}
+
 static void phylink_mac_config(struct phylink *pl,
 			       const struct phylink_link_state *state)
 {
@@ -399,44 +419,16 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 /* The fixed state is... fixed except for the link state,
  * which may be determined by a GPIO or a callback.
  */
-static void phylink_get_fixed_state(struct phylink *pl, struct phylink_link_state *state)
+static void phylink_get_fixed_state(struct phylink *pl,
+				    struct phylink_link_state *state)
 {
 	*state = pl->link_config;
 	if (pl->get_fixed_state)
 		pl->get_fixed_state(pl->netdev, state);
 	else if (pl->link_gpio)
 		state->link = !!gpiod_get_value_cansleep(pl->link_gpio);
-}
 
-/* Flow control is resolved according to our and the link partners
- * advertisements using the following drawn from the 802.3 specs:
- *  Local device  Link partner
- *  Pause AsymDir Pause AsymDir Result
- *    1     X       1     X     TX+RX
- *    0     1       1     1     TX
- *    1     1       0     1     RX
- */
-static void phylink_resolve_flow(struct phylink *pl,
-				 struct phylink_link_state *state)
-{
-	int new_pause = 0;
-	int pause = 0;
-
-	if (phylink_test(pl->link_config.advertising, Pause))
-		pause |= MLO_PAUSE_SYM;
-	if (phylink_test(pl->link_config.advertising, Asym_Pause))
-		pause |= MLO_PAUSE_ASYM;
-
-	pause &= state->pause;
-
-	if (pause & MLO_PAUSE_SYM)
-		new_pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
-	else if (pause & MLO_PAUSE_ASYM)
-		new_pause = state->pause & MLO_PAUSE_SYM ?
-			 MLO_PAUSE_TX : MLO_PAUSE_RX;
-
-	state->pause &= ~MLO_PAUSE_TXRX_MASK;
-	state->pause |= new_pause;
+	phylink_resolve_flow(state);
 }
 
 static const char *phylink_pause_to_str(int pause)
@@ -1393,8 +1385,7 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 	    !pause->autoneg && pause->rx_pause != pause->tx_pause)
 		return -EINVAL;
 
-	config->pause &= ~(MLO_PAUSE_AN | MLO_PAUSE_TXRX_MASK);
-
+	config->pause = 0;
 	if (pause->autoneg)
 		config->pause |= MLO_PAUSE_AN;
 	if (pause->rx_pause)
@@ -1505,13 +1496,14 @@ static int phylink_mii_emul_read(unsigned int reg,
 				 struct phylink_link_state *state)
 {
 	struct fixed_phy_status fs;
+	unsigned long *lpa = state->lp_advertising;
 	int val;
 
 	fs.link = state->link;
 	fs.speed = state->speed;
 	fs.duplex = state->duplex;
-	fs.pause = state->pause & MLO_PAUSE_SYM;
-	fs.asym_pause = state->pause & MLO_PAUSE_ASYM;
+	fs.pause = test_bit(ETHTOOL_LINK_MODE_Pause_BIT, lpa);
+	fs.asym_pause = test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, lpa);
 
 	val = swphy_read_reg(reg, &fs);
 	if (reg == MII_BMSR) {
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 523209e70947..0d6073c2b2b7 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -12,12 +12,10 @@ struct net_device;
 
 enum {
 	MLO_PAUSE_NONE,
-	MLO_PAUSE_ASYM = BIT(0),
-	MLO_PAUSE_SYM = BIT(1),
-	MLO_PAUSE_RX = BIT(2),
-	MLO_PAUSE_TX = BIT(3),
+	MLO_PAUSE_RX = BIT(0),
+	MLO_PAUSE_TX = BIT(1),
 	MLO_PAUSE_TXRX_MASK = MLO_PAUSE_TX | MLO_PAUSE_RX,
-	MLO_PAUSE_AN = BIT(4),
+	MLO_PAUSE_AN = BIT(2),
 
 	MLO_AN_PHY = 0,	/* Conventional PHY */
 	MLO_AN_FIXED,	/* Fixed-link mode */
-- 
2.20.1

