Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D3B6D147D
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjCaA4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjCaAzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:55:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36208EFAC
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5ELgqnZXVrcsJD/qHvyCDs5uJ943tNeY5adKWh8hAjA=; b=tRnldfm5if9cdraXV98qQaUeBr
        ILFaCnIwWZB8+OcE9pUqKqzg0dkMPk51ZjFLdLsqLzspWBG/YdyvEZX7G28c42dRJNihk6R0eW75D
        aJUPykLXBq2WBdb1N739dJHvGJRF941DoURL7EJK8p4ow8t231U0LiN8DgWcICsg0A3M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pi33L-008xKD-Bv; Fri, 31 Mar 2023 02:55:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFTv3 02/24] net: phylink: Add mac_set_eee() callback
Date:   Fri, 31 Mar 2023 02:54:56 +0200
Message-Id: <20230331005518.2134652-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230331005518.2134652-1-andrew@lunn.ch>
References: <20230331005518.2134652-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MAC drivers need to know the result of the auto negotiation of Energy
Efficient Ethernet. This is a simple boolean, it should be active or
not in the MAC. Add an additional callback to pass this information to
the MAC.

Currently the correct value should be passed, however no MAC drivers
have been modified to actually use it. Yet.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy-core.c | 11 +++++++++++
 drivers/net/phy/phylink.c  | 16 ++++++++++++++--
 include/linux/phy.h        |  1 +
 include/linux/phylink.h    | 22 +++++++++++++++++++---
 4 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index a64186dc53f8..666b3b9b6f4d 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -76,6 +76,17 @@ const char *phy_duplex_to_str(unsigned int duplex)
 }
 EXPORT_SYMBOL_GPL(phy_duplex_to_str);
 
+/**
+ * phy_eee_active_to_str - Return string describing eee_active
+ *
+ * @eee_active: EEE active setting to describe
+ */
+const char *phy_eee_active_to_str(bool eee_active)
+{
+	return eee_active ? "EEE Active" : "EEE Inactive";
+}
+EXPORT_SYMBOL_GPL(phy_eee_active_to_str);
+
 /**
  * phy_rate_matching_to_str - Return a string describing the rate matching
  *
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f7da96f0c75b..453f80544792 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1142,6 +1142,7 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 		state->speed = SPEED_UNKNOWN;
 		state->duplex = DUPLEX_UNKNOWN;
 		state->pause = MLO_PAUSE_NONE;
+		state->eee_active = false;
 	} else {
 		state->speed =  pl->link_config.speed;
 		state->duplex = pl->link_config.duplex;
@@ -1223,10 +1224,12 @@ static void phylink_link_up(struct phylink *pl,
 	struct net_device *ndev = pl->netdev;
 	int speed, duplex;
 	bool rx_pause;
+	bool eee_active;
 
 	speed = link_state.speed;
 	duplex = link_state.duplex;
 	rx_pause = !!(link_state.pause & MLO_PAUSE_RX);
+	eee_active = link_state.eee_active;
 
 	switch (link_state.rate_matching) {
 	case RATE_MATCH_PAUSE:
@@ -1259,6 +1262,9 @@ static void phylink_link_up(struct phylink *pl,
 				 pl->cur_interface, speed, duplex,
 				 !!(link_state.pause & MLO_PAUSE_TX), rx_pause);
 
+	if (pl->phydev && pl->mac_ops->mac_set_eee)
+		pl->mac_ops->mac_set_eee(pl->config, eee_active);
+
 	if (ndev)
 		netif_carrier_on(ndev);
 
@@ -1529,6 +1535,7 @@ struct phylink *phylink_create(struct phylink_config *config,
 	pl->link_config.pause = MLO_PAUSE_AN;
 	pl->link_config.speed = SPEED_UNKNOWN;
 	pl->link_config.duplex = DUPLEX_UNKNOWN;
+	pl->link_config.eee_active = false;
 	pl->mac_ops = mac_ops;
 	__set_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
 	timer_setup(&pl->link_poll, phylink_fixed_poll, 0);
@@ -1593,6 +1600,7 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 	mutex_lock(&pl->state_mutex);
 	pl->phy_state.speed = phydev->speed;
 	pl->phy_state.duplex = phydev->duplex;
+	pl->phy_state.eee_active = phydev->eee_active;
 	pl->phy_state.rate_matching = phydev->rate_matching;
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	if (tx_pause)
@@ -1605,12 +1613,13 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 
 	phylink_run_resolve(pl);
 
-	phylink_dbg(pl, "phy link %s %s/%s/%s/%s/%s\n", up ? "up" : "down",
+	phylink_dbg(pl, "phy link %s %s/%s/%s/%s/%s/%s\n", up ? "up" : "down",
 		    phy_modes(phydev->interface),
 		    phy_speed_to_str(phydev->speed),
 		    phy_duplex_to_str(phydev->duplex),
 		    phy_rate_matching_to_str(phydev->rate_matching),
-		    phylink_pause_to_str(pl->phy_state.pause));
+		    phylink_pause_to_str(pl->phy_state.pause),
+		    phy_eee_active_to_str(phydev->eee_active));
 }
 
 static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
@@ -1684,6 +1693,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	pl->phy_state.speed = SPEED_UNKNOWN;
 	pl->phy_state.duplex = DUPLEX_UNKNOWN;
+	pl->phy_state.eee_active = false;
 	pl->phy_state.rate_matching = RATE_MATCH_NONE;
 	linkmode_copy(pl->supported, supported);
 	linkmode_copy(pl->link_config.advertising, config.advertising);
@@ -2929,6 +2939,7 @@ static int phylink_sfp_config_phy(struct phylink *pl, u8 mode,
 	config.interface = PHY_INTERFACE_MODE_NA;
 	config.speed = SPEED_UNKNOWN;
 	config.duplex = DUPLEX_UNKNOWN;
+	config.eee_active = false;
 	config.pause = MLO_PAUSE_AN;
 
 	/* Ignore errors if we're expecting a PHY to attach later */
@@ -2997,6 +3008,7 @@ static int phylink_sfp_config_optical(struct phylink *pl)
 	linkmode_copy(config.advertising, pl->sfp_support);
 	config.speed = SPEED_UNKNOWN;
 	config.duplex = DUPLEX_UNKNOWN;
+	config.eee_active = false;
 	config.pause = MLO_PAUSE_AN;
 
 	/* For all the interfaces that are supported, reduce the sfp_support
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5cc2dcb17eb0..2508f1d99777 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1080,6 +1080,7 @@ struct phy_fixup {
 
 const char *phy_speed_to_str(int speed);
 const char *phy_duplex_to_str(unsigned int duplex);
+const char *phy_eee_active_to_str(bool eee_active);
 const char *phy_rate_matching_to_str(int rate_matching);
 
 int phy_interface_num_ports(phy_interface_t interface);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 9ff56b050584..7b5df55e2467 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -88,6 +88,7 @@ static inline bool phylink_autoneg_inband(unsigned int mode)
  * @speed: link speed, one of the SPEED_* constants.
  * @duplex: link duplex mode, one of DUPLEX_* constants.
  * @pause: link pause state, described by MLO_PAUSE_* constants.
+ * @eee_active: true if EEE should be active
  * @rate_matching: rate matching being performed, one of the RATE_MATCH_*
  *   constants. If rate matching is taking place, then the speed/duplex of
  *   the medium link mode (@speed and @duplex) and the speed/duplex of the phy
@@ -105,6 +106,7 @@ struct phylink_link_state {
 	int rate_matching;
 	unsigned int link:1;
 	unsigned int an_complete:1;
+	unsigned int eee_active:1;
 };
 
 enum phylink_op_type {
@@ -152,6 +154,7 @@ struct phylink_config {
  * @mac_an_restart: restart 802.3z BaseX autonegotiation.
  * @mac_link_down: take the link down.
  * @mac_link_up: allow the link to come up.
+ * @mac_set_eee: enable/disable EEE in the MAC
  *
  * The individual methods are described more fully below.
  */
@@ -176,6 +179,7 @@ struct phylink_mac_ops {
 			    struct phy_device *phy, unsigned int mode,
 			    phy_interface_t interface, int speed, int duplex,
 			    bool tx_pause, bool rx_pause);
+	void (*mac_set_eee)(struct phylink_config *config, bool eee_active);
 };
 
 #if 0 /* For kernel-doc purposes only. */
@@ -408,6 +412,7 @@ void mac_link_down(struct phylink_config *config, unsigned int mode,
  * @duplex: link duplex
  * @tx_pause: link transmit pause enablement status
  * @rx_pause: link receive pause enablement status
+ * @eee_active: EEE should be enabled
  *
  * Configure the MAC for an established link.
  *
@@ -421,14 +426,25 @@ void mac_link_down(struct phylink_config *config, unsigned int mode,
  * that the user wishes to override the pause settings, and this should
  * be allowed when considering the implementation of this method.
  *
- * If in-band negotiation mode is disabled, allow the link to come up. If
- * @phy is non-%NULL, configure Energy Efficient Ethernet by calling
- * phy_init_eee() and perform appropriate MAC configuration for EEE.
+ * If in-band negotiation mode is disabled, allow the link to come up.
  * Interface type selection must be done in mac_config().
  */
 void mac_link_up(struct phylink_config *config, struct phy_device *phy,
 		 unsigned int mode, phy_interface_t interface,
 		 int speed, int duplex, bool tx_pause, bool rx_pause);
+/**
+ * mac_set_eee() - enable/disable EEE in the MAC
+ * @config: a pointer to a &struct phylink_config.
+ *
+ * Enable or disable the MAC performing EEE.
+ *
+ * @eee_active indicates if the MAC should enable EEE. This callback
+ * can be called without the link going down, e.g after calls to
+ * ethtool_set_eee() which don't require a new auto-negotiation.
+ *
+ * This callback is optional.
+ */
+void mac_set_eee(struct phylink_config *config, bool eee_active);
 #endif
 
 struct phylink_pcs_ops;
-- 
2.40.0

