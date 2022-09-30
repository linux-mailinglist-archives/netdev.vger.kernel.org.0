Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6185F0D6C
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbiI3OWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbiI3OVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:21:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D701A1A3ACF
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:21:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB8A6B828FA
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1425BC433D6;
        Fri, 30 Sep 2022 14:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664547680;
        bh=9BioZl4oFBSg3tC2JEo1drzroRWBg8EbbFd+Dm4aXB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puoZhxuNiNlvJN0bdrzS73pMkUUd3REA9UlJ88US2DR8VA/6beol8NfVKvBdao1YE
         GNMrecLXG7xu5ZBcD5L2wGwRkEQThNPN/Xrcm/PmVjnZ2LrkvgtzSQzoLjZLl+ddY9
         MbLQK2XEbHni+AV6x+D+fjBsiQidWxYMJyY2IAVVk7BpdSzfvopyhEKIAVCHUkBpf2
         aESjQNfgkIR9pFF5eVvRwcPgBtmL1+rHUJ94hRiSKYiNTrYk1G1XRqf8NzRmPSTiNc
         Tvc0HxmDHkcA9uuiwXDOfidm9X18JxQMbyzez9rBcjiqp5WajBRb3y//Cq4TjIeFQv
         eq7rFCG5KmFbA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 03/12] net: phylink: use phy_interface_t bitmaps for optical modules
Date:   Fri, 30 Sep 2022 16:21:01 +0200
Message-Id: <20220930142110.15372-4-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220930142110.15372-1-kabel@kernel.org>
References: <20220930142110.15372-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Where a MAC provides a phy_interface_t bitmap, use these bitmaps to
select the operating interface mode for optical SFP modules, rather
than using the linkmode bitmaps.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/phylink.c | 164 +++++++++++++++++++++++++++++++-------
 1 file changed, 134 insertions(+), 30 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index b76bf8df83ff..ab32ef767d69 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2803,6 +2803,70 @@ static void phylink_sfp_detach(void *upstream, struct sfp_bus *bus)
 	pl->netdev->sfp_bus = NULL;
 }
 
+static const phy_interface_t phylink_sfp_interface_preference[] = {
+	PHY_INTERFACE_MODE_25GBASER,
+	PHY_INTERFACE_MODE_USXGMII,
+	PHY_INTERFACE_MODE_10GBASER,
+	PHY_INTERFACE_MODE_5GBASER,
+	PHY_INTERFACE_MODE_2500BASEX,
+	PHY_INTERFACE_MODE_SGMII,
+	PHY_INTERFACE_MODE_1000BASEX,
+	PHY_INTERFACE_MODE_100BASEX,
+};
+
+static phy_interface_t phylink_choose_sfp_interface(struct phylink *pl,
+						    const unsigned long *intf)
+{
+	phy_interface_t interface;
+	size_t i;
+
+	interface = PHY_INTERFACE_MODE_NA;
+	for (i = 0; i < ARRAY_SIZE(phylink_sfp_interface_preference); i++)
+		if (test_bit(phylink_sfp_interface_preference[i], intf)) {
+			interface = phylink_sfp_interface_preference[i];
+			break;
+		}
+
+	return interface;
+}
+
+static void phylink_sfp_set_config(struct phylink *pl, u8 mode,
+				   unsigned long *supported,
+				   struct phylink_link_state *state)
+{
+	bool changed = false;
+
+	phylink_dbg(pl, "requesting link mode %s/%s with support %*pb\n",
+		    phylink_an_mode_str(mode), phy_modes(state->interface),
+		    __ETHTOOL_LINK_MODE_MASK_NBITS, supported);
+
+	if (!linkmode_equal(pl->supported, supported)) {
+		linkmode_copy(pl->supported, supported);
+		changed = true;
+	}
+
+	if (!linkmode_equal(pl->link_config.advertising, state->advertising)) {
+		linkmode_copy(pl->link_config.advertising, state->advertising);
+		changed = true;
+	}
+
+	if (pl->cur_link_an_mode != mode ||
+	    pl->link_config.interface != state->interface) {
+		pl->cur_link_an_mode = mode;
+		pl->link_config.interface = state->interface;
+
+		changed = true;
+
+		phylink_info(pl, "switched to %s/%s link mode\n",
+			     phylink_an_mode_str(mode),
+			     phy_modes(state->interface));
+	}
+
+	if (changed && !test_bit(PHYLINK_DISABLE_STOPPED,
+				 &pl->phylink_disable_state))
+		phylink_mac_initial_config(pl, false);
+}
+
 static int phylink_sfp_config(struct phylink *pl, u8 mode,
 			      const unsigned long *supported,
 			      const unsigned long *advertising)
@@ -2811,7 +2875,6 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(support);
 	struct phylink_link_state config;
 	phy_interface_t iface;
-	bool changed;
 	int ret;
 
 	linkmode_copy(support, supported);
@@ -2854,61 +2917,103 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 		return ret;
 	}
 
-	phylink_dbg(pl, "requesting link mode %s/%s with support %*pb\n",
-		    phylink_an_mode_str(mode), phy_modes(config.interface),
-		    __ETHTOOL_LINK_MODE_MASK_NBITS, support);
-
 	if (phy_interface_mode_is_8023z(iface) && pl->phydev)
 		return -EINVAL;
 
-	changed = !linkmode_equal(pl->supported, support) ||
-		  !linkmode_equal(pl->link_config.advertising,
-				  config.advertising);
-	if (changed) {
-		linkmode_copy(pl->supported, support);
-		linkmode_copy(pl->link_config.advertising, config.advertising);
+	pl->link_port = pl->sfp_port;
+
+	phylink_sfp_set_config(pl, mode, support, &config);
+
+	return 0;
+}
+
+static int phylink_sfp_config_optical(struct phylink *pl)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(support);
+	DECLARE_PHY_INTERFACE_MASK(interfaces);
+	struct phylink_link_state config;
+	phy_interface_t interface;
+	int ret;
+
+	phylink_dbg(pl, "optical SFP: interfaces=[mac=%*pbl, sfp=%*pbl]\n",
+		    (int)PHY_INTERFACE_MODE_MAX,
+		    pl->config->supported_interfaces,
+		    (int)PHY_INTERFACE_MODE_MAX,
+		    pl->sfp_interfaces);
+
+	/* Find the union of the supported interfaces by the PCS/MAC and
+	 * the SFP module.
+	 */
+	phy_interface_and(interfaces, pl->config->supported_interfaces,
+			  pl->sfp_interfaces);
+	if (phy_interface_empty(interfaces)) {
+		phylink_err(pl, "unsupported SFP module: no common interface modes\n");
+		return -EINVAL;
 	}
 
-	if (pl->cur_link_an_mode != mode ||
-	    pl->link_config.interface != config.interface) {
-		pl->link_config.interface = config.interface;
-		pl->cur_link_an_mode = mode;
+	memset(&config, 0, sizeof(config));
+	linkmode_copy(support, pl->sfp_support);
+	linkmode_copy(config.advertising, pl->sfp_support);
+	config.speed = SPEED_UNKNOWN;
+	config.duplex = DUPLEX_UNKNOWN;
+	config.pause = MLO_PAUSE_AN;
+	config.an_enabled = true;
 
-		changed = true;
+	/* For all the interfaces that are supported, reduce the sfp_support
+	 * mask to only those link modes that can be supported.
+	 */
+	ret = phylink_validate_mask(pl, pl->sfp_support, &config, interfaces);
+	if (ret) {
+		phylink_err(pl, "unsupported SFP module: validation with support %*pb failed\n",
+			    __ETHTOOL_LINK_MODE_MASK_NBITS, support);
+		return ret;
+	}
 
-		phylink_info(pl, "switched to %s/%s link mode\n",
-			     phylink_an_mode_str(mode),
-			     phy_modes(config.interface));
+	interface = phylink_choose_sfp_interface(pl, interfaces);
+	if (interface == PHY_INTERFACE_MODE_NA) {
+		phylink_err(pl, "failed to select SFP interface\n");
+		return -EINVAL;
+	}
+
+	phylink_dbg(pl, "optical SFP: chosen %s interface\n",
+		    phy_modes(interface));
+
+	config.interface = interface;
+
+	/* Ignore errors if we're expecting a PHY to attach later */
+	ret = phylink_validate(pl, support, &config);
+	if (ret) {
+		phylink_err(pl, "validation with support %*pb failed: %pe\n",
+			    __ETHTOOL_LINK_MODE_MASK_NBITS, support,
+			    ERR_PTR(ret));
+		return ret;
 	}
 
 	pl->link_port = pl->sfp_port;
 
-	if (changed && !test_bit(PHYLINK_DISABLE_STOPPED,
-				 &pl->phylink_disable_state))
-		phylink_mac_initial_config(pl, false);
+	phylink_sfp_set_config(pl, MLO_AN_INBAND, pl->sfp_support, &config);
 
-	return ret;
+	return 0;
 }
 
 static int phylink_sfp_module_insert(void *upstream,
 				     const struct sfp_eeprom_id *id)
 {
 	struct phylink *pl = upstream;
-	unsigned long *support = pl->sfp_support;
 
 	ASSERT_RTNL();
 
-	linkmode_zero(support);
+	linkmode_zero(pl->sfp_support);
 	phy_interface_zero(pl->sfp_interfaces);
-	sfp_parse_support(pl->sfp_bus, id, support, pl->sfp_interfaces);
-	pl->sfp_port = sfp_parse_port(pl->sfp_bus, id, support);
+	sfp_parse_support(pl->sfp_bus, id, pl->sfp_support, pl->sfp_interfaces);
+	pl->sfp_port = sfp_parse_port(pl->sfp_bus, id, pl->sfp_support);
 
 	/* If this module may have a PHY connecting later, defer until later */
 	pl->sfp_may_have_phy = sfp_may_have_phy(pl->sfp_bus, id);
 	if (pl->sfp_may_have_phy)
 		return 0;
 
-	return phylink_sfp_config(pl, MLO_AN_INBAND, support, support);
+	return phylink_sfp_config_optical(pl);
 }
 
 static int phylink_sfp_module_start(void *upstream)
@@ -2927,8 +3032,7 @@ static int phylink_sfp_module_start(void *upstream)
 	if (!pl->sfp_may_have_phy)
 		return 0;
 
-	return phylink_sfp_config(pl, MLO_AN_INBAND,
-				  pl->sfp_support, pl->sfp_support);
+	return phylink_sfp_config_optical(pl);
 }
 
 static void phylink_sfp_module_stop(void *upstream)
-- 
2.35.1

