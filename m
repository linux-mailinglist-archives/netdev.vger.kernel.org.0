Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF12E116E98
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfLIOH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:07:57 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34342 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727818AbfLIOH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 09:07:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LSdMXfR9k1ZDa4z+/mT8+eam7p7kttAzLztU60v7muY=; b=sH0+vTlEO2wQxNofdvDae2jSpy
        C0iAd0gO4ot9QbWw+MmuZ/UGVDG6rUosx6hXgse+UWDLYncL/g2Ru4Rx8PgUvjn3x7zFUqp7dqbAT
        y9nKhBNdA/tTpDYpZ5tJQfcN48lpzcKPbRm/4F2ZNg8c9FDAUMvyyj7cyDlmCu3eyp9noF+O6J8D0
        d1i5fwCrYY8gR2oA6vfOWQzhBHeTHvIqZ5WOZAqIxesbjuqf6IZgAv5Om9by1UEX5+iDZ6xaOxsgn
        m3AnP2iD5U6KwfyMlXNJ1mRj+r/mlmx7ESN5mjeMuMlwCjSMxKQ4Xs3nVVrtgdg3ioZBGrHwrHhpr
        YR/U1qnw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54420 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJhD-0003Qf-A7; Mon, 09 Dec 2019 14:07:31 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJh9-0004P8-St; Mon, 09 Dec 2019 14:07:27 +0000
In-Reply-To: <20191209140258.GI25745@shell.armlinux.org.uk>
References: <20191209140258.GI25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 09/14] net: phylink: split link_an_mode configured
 and current settings
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ieJh9-0004P8-St@rmk-PC.armlinux.org.uk>
Date:   Mon, 09 Dec 2019 14:07:27 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split link_an_mode between the configured setting and the current
operating setting.  This is an important distinction to make when we
need to configure PHY mode for a plugged SFP+ module that does not
use in-band signalling.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 59 ++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 056ee50aa556..035fdc187d3c 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -48,7 +48,8 @@ struct phylink {
 	unsigned long phylink_disable_state; /* bitmask of disables */
 	struct phy_device *phydev;
 	phy_interface_t link_interface;	/* PHY_INTERFACE_xxx */
-	u8 link_an_mode;		/* MLO_AN_xxx */
+	u8 cfg_link_an_mode;		/* MLO_AN_xxx */
+	u8 cur_link_an_mode;
 	u8 link_port;			/* The current non-phy ethtool port */
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
 
@@ -256,12 +257,12 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 
 	dn = fwnode_get_named_child_node(fwnode, "fixed-link");
 	if (dn || fwnode_property_present(fwnode, "fixed-link"))
-		pl->link_an_mode = MLO_AN_FIXED;
+		pl->cfg_link_an_mode = MLO_AN_FIXED;
 	fwnode_handle_put(dn);
 
 	if (fwnode_property_read_string(fwnode, "managed", &managed) == 0 &&
 	    strcmp(managed, "in-band-status") == 0) {
-		if (pl->link_an_mode == MLO_AN_FIXED) {
+		if (pl->cfg_link_an_mode == MLO_AN_FIXED) {
 			phylink_err(pl,
 				    "can't use both fixed-link and in-band-status\n");
 			return -EINVAL;
@@ -273,7 +274,7 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 		phylink_set(pl->supported, Asym_Pause);
 		phylink_set(pl->supported, Pause);
 		pl->link_config.an_enabled = true;
-		pl->link_an_mode = MLO_AN_INBAND;
+		pl->cfg_link_an_mode = MLO_AN_INBAND;
 
 		switch (pl->link_config.interface) {
 		case PHY_INTERFACE_MODE_SGMII:
@@ -333,14 +334,14 @@ static void phylink_mac_config(struct phylink *pl,
 {
 	phylink_dbg(pl,
 		    "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
-		    __func__, phylink_an_mode_str(pl->link_an_mode),
+		    __func__, phylink_an_mode_str(pl->cur_link_an_mode),
 		    phy_modes(state->interface),
 		    phy_speed_to_str(state->speed),
 		    phy_duplex_to_str(state->duplex),
 		    __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
 		    state->pause, state->link, state->an_enabled);
 
-	pl->ops->mac_config(pl->config, pl->link_an_mode, state);
+	pl->ops->mac_config(pl->config, pl->cur_link_an_mode, state);
 }
 
 static void phylink_mac_config_up(struct phylink *pl,
@@ -441,7 +442,7 @@ static void phylink_mac_link_up(struct phylink *pl,
 	struct net_device *ndev = pl->netdev;
 
 	pl->cur_interface = link_state.interface;
-	pl->ops->mac_link_up(pl->config, pl->link_an_mode,
+	pl->ops->mac_link_up(pl->config, pl->cur_link_an_mode,
 			     pl->phy_state.interface,
 			     pl->phydev);
 
@@ -461,7 +462,7 @@ static void phylink_mac_link_down(struct phylink *pl)
 
 	if (ndev)
 		netif_carrier_off(ndev);
-	pl->ops->mac_link_down(pl->config, pl->link_an_mode,
+	pl->ops->mac_link_down(pl->config, pl->cur_link_an_mode,
 			       pl->cur_interface);
 	phylink_info(pl, "Link is Down\n");
 }
@@ -480,7 +481,7 @@ static void phylink_resolve(struct work_struct *w)
 	} else if (pl->mac_link_dropped) {
 		link_state.link = false;
 	} else {
-		switch (pl->link_an_mode) {
+		switch (pl->cur_link_an_mode) {
 		case MLO_AN_PHY:
 			link_state = pl->phy_state;
 			phylink_resolve_flow(pl, &link_state);
@@ -648,7 +649,7 @@ struct phylink *phylink_create(struct phylink_config *config,
 		return ERR_PTR(ret);
 	}
 
-	if (pl->link_an_mode == MLO_AN_FIXED) {
+	if (pl->cfg_link_an_mode == MLO_AN_FIXED) {
 		ret = phylink_parse_fixedlink(pl, fwnode);
 		if (ret < 0) {
 			kfree(pl);
@@ -656,6 +657,8 @@ struct phylink *phylink_create(struct phylink_config *config,
 		}
 	}
 
+	pl->cur_link_an_mode = pl->cfg_link_an_mode;
+
 	ret = phylink_register_sfp(pl, fwnode);
 	if (ret < 0) {
 		kfree(pl);
@@ -771,8 +774,8 @@ static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
 {
 	int ret;
 
-	if (WARN_ON(pl->link_an_mode == MLO_AN_FIXED ||
-		    (pl->link_an_mode == MLO_AN_INBAND &&
+	if (WARN_ON(pl->cfg_link_an_mode == MLO_AN_FIXED ||
+		    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
 		     phy_interface_mode_is_8023z(interface))))
 		return -EINVAL;
 
@@ -839,8 +842,8 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 	int ret;
 
 	/* Fixed links and 802.3z are handled without needing a PHY */
-	if (pl->link_an_mode == MLO_AN_FIXED ||
-	    (pl->link_an_mode == MLO_AN_INBAND &&
+	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
+	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
 	     phy_interface_mode_is_8023z(pl->link_interface)))
 		return 0;
 
@@ -851,7 +854,7 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 		phy_node = of_parse_phandle(dn, "phy-device", 0);
 
 	if (!phy_node) {
-		if (pl->link_an_mode == MLO_AN_PHY)
+		if (pl->cfg_link_an_mode == MLO_AN_PHY)
 			return -ENODEV;
 		return 0;
 	}
@@ -914,7 +917,7 @@ int phylink_fixed_state_cb(struct phylink *pl,
 	/* It does not make sense to let the link be overriden unless we use
 	 * MLO_AN_FIXED
 	 */
-	if (pl->link_an_mode != MLO_AN_FIXED)
+	if (pl->cfg_link_an_mode != MLO_AN_FIXED)
 		return -EINVAL;
 
 	mutex_lock(&pl->state_mutex);
@@ -964,7 +967,7 @@ void phylink_start(struct phylink *pl)
 	ASSERT_RTNL();
 
 	phylink_info(pl, "configuring for %s/%s link mode\n",
-		     phylink_an_mode_str(pl->link_an_mode),
+		     phylink_an_mode_str(pl->cur_link_an_mode),
 		     phy_modes(pl->link_config.interface));
 
 	/* Always set the carrier off */
@@ -987,7 +990,7 @@ void phylink_start(struct phylink *pl)
 	clear_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
 	phylink_run_resolve(pl);
 
-	if (pl->link_an_mode == MLO_AN_FIXED && pl->link_gpio) {
+	if (pl->cfg_link_an_mode == MLO_AN_FIXED && pl->link_gpio) {
 		int irq = gpiod_to_irq(pl->link_gpio);
 
 		if (irq > 0) {
@@ -1002,7 +1005,7 @@ void phylink_start(struct phylink *pl)
 		if (irq <= 0)
 			mod_timer(&pl->link_poll, jiffies + HZ);
 	}
-	if (pl->link_an_mode == MLO_AN_FIXED && pl->get_fixed_state)
+	if (pl->cfg_link_an_mode == MLO_AN_FIXED && pl->get_fixed_state)
 		mod_timer(&pl->link_poll, jiffies + HZ);
 	if (pl->phydev)
 		phy_start(pl->phydev);
@@ -1129,7 +1132,7 @@ int phylink_ethtool_ksettings_get(struct phylink *pl,
 
 	linkmode_copy(kset->link_modes.supported, pl->supported);
 
-	switch (pl->link_an_mode) {
+	switch (pl->cur_link_an_mode) {
 	case MLO_AN_FIXED:
 		/* We are using fixed settings. Report these as the
 		 * current link settings - and note that these also
@@ -1201,7 +1204,7 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		/* If we have a fixed link (as specified by firmware), refuse
 		 * to change link parameters.
 		 */
-		if (pl->link_an_mode == MLO_AN_FIXED &&
+		if (pl->cur_link_an_mode == MLO_AN_FIXED &&
 		    (s->speed != pl->link_config.speed ||
 		     s->duplex != pl->link_config.duplex))
 			return -EINVAL;
@@ -1213,7 +1216,7 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		__clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, config.advertising);
 	} else {
 		/* If we have a fixed link, refuse to enable autonegotiation */
-		if (pl->link_an_mode == MLO_AN_FIXED)
+		if (pl->cur_link_an_mode == MLO_AN_FIXED)
 			return -EINVAL;
 
 		config.speed = SPEED_UNKNOWN;
@@ -1255,7 +1258,7 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 	 * configuration. For a fixed link, this isn't able to change any
 	 * parameters, which just leaves inband mode.
 	 */
-	if (pl->link_an_mode == MLO_AN_INBAND &&
+	if (pl->cur_link_an_mode == MLO_AN_INBAND &&
 	    !test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state)) {
 		phylink_mac_config(pl, &pl->link_config);
 		phylink_mac_an_restart(pl);
@@ -1345,7 +1348,7 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 				   pause->tx_pause);
 	} else if (!test_bit(PHYLINK_DISABLE_STOPPED,
 			     &pl->phylink_disable_state)) {
-		switch (pl->link_an_mode) {
+		switch (pl->cur_link_an_mode) {
 		case MLO_AN_FIXED:
 			/* Should we allow fixed links to change against the config? */
 			phylink_resolve_flow(pl, config);
@@ -1552,7 +1555,7 @@ static int phylink_mii_read(struct phylink *pl, unsigned int phy_id,
 	struct phylink_link_state state;
 	int val = 0xffff;
 
-	switch (pl->link_an_mode) {
+	switch (pl->cur_link_an_mode) {
 	case MLO_AN_FIXED:
 		if (phy_id == 0) {
 			phylink_get_fixed_state(pl, &state);
@@ -1580,7 +1583,7 @@ static int phylink_mii_read(struct phylink *pl, unsigned int phy_id,
 static int phylink_mii_write(struct phylink *pl, unsigned int phy_id,
 			     unsigned int reg, unsigned int val)
 {
-	switch (pl->link_an_mode) {
+	switch (pl->cur_link_an_mode) {
 	case MLO_AN_FIXED:
 		break;
 
@@ -1753,10 +1756,10 @@ static int phylink_sfp_module_insert(void *upstream,
 		linkmode_copy(pl->link_config.advertising, config.advertising);
 	}
 
-	if (pl->link_an_mode != MLO_AN_INBAND ||
+	if (pl->cur_link_an_mode != MLO_AN_INBAND ||
 	    pl->link_config.interface != config.interface) {
 		pl->link_config.interface = config.interface;
-		pl->link_an_mode = MLO_AN_INBAND;
+		pl->cur_link_an_mode = MLO_AN_INBAND;
 
 		changed = true;
 
-- 
2.20.1

