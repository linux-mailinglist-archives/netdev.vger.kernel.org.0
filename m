Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2BC15F0D6A
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbiI3OV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbiI3OVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:21:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6881A3AC3
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:21:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FDBA622AF
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D3DC4314E;
        Fri, 30 Sep 2022 14:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664547678;
        bh=CJhq/jkrahLk3fCCRnJLb9pUBOHY0gjtIHpgCnilC3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJINxpY19lVgVzwzQpm2E8HlLtvIpaFZtikJ7q9OBVnQ5JiNkWxviXLcer1NkgtJg
         IOcLBrYJ1sQpAmE2WfKAhqnaP/MRLAZNHt8i+PZZaNvlF4o1ZqFMJ0cX4K7exF97Gh
         qW5KKnDgr9Z8sdahVKNZbsOwLXy++mr9fEudFoK6Jhai2il3W2TST9D5Umq3tDbPph
         tac9Gb24I/Depz8GpHCEhHI0MgFQhOpDUbriaarrUSLxEsgea/ZAx6t/vV73dlQyOp
         BHdpjryuNtkXAbJjaWCBAfBDxqLczE6Z/z87AXfLPBVmGteCKwCzPZgKkazHUk5+1u
         iLw1Q4zrMnshg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 02/12] net: sfp: augment SFP parsing with phy_interface_t bitmap
Date:   Fri, 30 Sep 2022 16:21:00 +0200
Message-Id: <20220930142110.15372-3-kabel@kernel.org>
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

We currently parse the SFP EEPROM to a bitmap of ethtool link modes,
and then attempt to convert the link modes to a PHY interface mode.
While this works at present, there are cases where this is sub-optimal.
For example, where a module can operate with several different PHY
interface modes.

To start addressing this, arrange for the SFP EEPROM parsing to also
provide a bitmap of the possible PHY interface modes.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/at803x.c          |  3 +-
 drivers/net/phy/marvell-88x2222.c |  3 +-
 drivers/net/phy/marvell.c         |  3 +-
 drivers/net/phy/marvell10g.c      |  3 +-
 drivers/net/phy/phylink.c         |  4 +-
 drivers/net/phy/sfp-bus.c         | 75 +++++++++++++++++++++++--------
 drivers/net/phy/sfp.c             |  7 ++-
 drivers/net/phy/sfp.h             |  3 +-
 include/linux/sfp.h               |  5 ++-
 9 files changed, 78 insertions(+), 28 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 11ebd59bf2eb..9e9adde335c8 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -676,6 +676,7 @@ static int at803x_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 	struct phy_device *phydev = upstream;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(phy_support);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(sfp_support);
+	DECLARE_PHY_INTERFACE_MASK(interfaces);
 	phy_interface_t iface;
 
 	linkmode_zero(phy_support);
@@ -686,7 +687,7 @@ static int at803x_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 	phylink_set(phy_support, Asym_Pause);
 
 	linkmode_zero(sfp_support);
-	sfp_parse_support(phydev->sfp_bus, id, sfp_support);
+	sfp_parse_support(phydev->sfp_bus, id, sfp_support, interfaces);
 	/* Some modules support 10G modes as well as others we support.
 	 * Mask out non-supported modes so the correct interface is picked.
 	 */
diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
index f070776ca904..fd9ad4820192 100644
--- a/drivers/net/phy/marvell-88x2222.c
+++ b/drivers/net/phy/marvell-88x2222.c
@@ -478,6 +478,7 @@ static int mv2222_config_init(struct phy_device *phydev)
 
 static int mv2222_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 {
+	DECLARE_PHY_INTERFACE_MASK(interfaces);
 	struct phy_device *phydev = upstream;
 	phy_interface_t sfp_interface;
 	struct mv2222_data *priv;
@@ -489,7 +490,7 @@ static int mv2222_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 	priv = (struct mv2222_data *)phydev->priv;
 	dev = &phydev->mdio.dev;
 
-	sfp_parse_support(phydev->sfp_bus, id, sfp_supported);
+	sfp_parse_support(phydev->sfp_bus, id, sfp_supported, interfaces);
 	phydev->port = sfp_parse_port(phydev->sfp_bus, id, sfp_supported);
 	sfp_interface = sfp_select_interface(phydev->sfp_bus, sfp_supported);
 
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index a3e810705ce2..2810f4f9da0c 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2845,6 +2845,7 @@ static int marvell_probe(struct phy_device *phydev)
 
 static int m88e1510_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 {
+	DECLARE_PHY_INTERFACE_MASK(interfaces);
 	struct phy_device *phydev = upstream;
 	phy_interface_t interface;
 	struct device *dev;
@@ -2856,7 +2857,7 @@ static int m88e1510_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 
 	dev = &phydev->mdio.dev;
 
-	sfp_parse_support(phydev->sfp_bus, id, supported);
+	sfp_parse_support(phydev->sfp_bus, id, supported, interfaces);
 	interface = sfp_select_interface(phydev->sfp_bus, supported);
 
 	dev_info(dev, "%s SFP module inserted\n", phy_modes(interface));
diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 2b7d0720720b..05a5ed089965 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -466,9 +466,10 @@ static int mv3310_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 {
 	struct phy_device *phydev = upstream;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(support) = { 0, };
+	DECLARE_PHY_INTERFACE_MASK(interfaces);
 	phy_interface_t iface;
 
-	sfp_parse_support(phydev->sfp_bus, id, support);
+	sfp_parse_support(phydev->sfp_bus, id, support, interfaces);
 	iface = sfp_select_interface(phydev->sfp_bus, support);
 
 	if (iface != PHY_INTERFACE_MODE_10GBASER) {
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 2cf388fad1be..b76bf8df83ff 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -77,6 +77,7 @@ struct phylink {
 
 	struct sfp_bus *sfp_bus;
 	bool sfp_may_have_phy;
+	DECLARE_PHY_INTERFACE_MASK(sfp_interfaces);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(sfp_support);
 	u8 sfp_port;
 };
@@ -2898,7 +2899,8 @@ static int phylink_sfp_module_insert(void *upstream,
 	ASSERT_RTNL();
 
 	linkmode_zero(support);
-	sfp_parse_support(pl->sfp_bus, id, support);
+	phy_interface_zero(pl->sfp_interfaces);
+	sfp_parse_support(pl->sfp_bus, id, support, pl->sfp_interfaces);
 	pl->sfp_port = sfp_parse_port(pl->sfp_bus, id, support);
 
 	/* If this module may have a PHY connecting later, defer until later */
diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 0a9099c77694..29e3fa86bac3 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -139,12 +139,14 @@ EXPORT_SYMBOL_GPL(sfp_may_have_phy);
  * @bus: a pointer to the &struct sfp_bus structure for the sfp module
  * @id: a pointer to the module's &struct sfp_eeprom_id
  * @support: pointer to an array of unsigned long for the ethtool support mask
+ * @interfaces: pointer to an array of unsigned long for phy interface modes
+ *		mask
  *
  * Parse the EEPROM identification information and derive the supported
  * ethtool link modes for the module.
  */
 void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
-		       unsigned long *support)
+		       unsigned long *support, unsigned long *interfaces)
 {
 	unsigned int br_min, br_nom, br_max;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(modes) = { 0, };
@@ -171,54 +173,81 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	}
 
 	/* Set ethtool support from the compliance fields. */
-	if (id->base.e10g_base_sr)
+	if (id->base.e10g_base_sr) {
 		phylink_set(modes, 10000baseSR_Full);
-	if (id->base.e10g_base_lr)
+		__set_bit(PHY_INTERFACE_MODE_10GBASER, interfaces);
+	}
+	if (id->base.e10g_base_lr) {
 		phylink_set(modes, 10000baseLR_Full);
-	if (id->base.e10g_base_lrm)
+		__set_bit(PHY_INTERFACE_MODE_10GBASER, interfaces);
+	}
+	if (id->base.e10g_base_lrm) {
 		phylink_set(modes, 10000baseLRM_Full);
-	if (id->base.e10g_base_er)
+		__set_bit(PHY_INTERFACE_MODE_10GBASER, interfaces);
+	}
+	if (id->base.e10g_base_er) {
 		phylink_set(modes, 10000baseER_Full);
+		__set_bit(PHY_INTERFACE_MODE_10GBASER, interfaces);
+	}
 	if (id->base.e1000_base_sx ||
 	    id->base.e1000_base_lx ||
-	    id->base.e1000_base_cx)
+	    id->base.e1000_base_cx) {
 		phylink_set(modes, 1000baseX_Full);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX, interfaces);
+	}
 	if (id->base.e1000_base_t) {
 		phylink_set(modes, 1000baseT_Half);
 		phylink_set(modes, 1000baseT_Full);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX, interfaces);
+		__set_bit(PHY_INTERFACE_MODE_SGMII, interfaces);
 	}
 
 	/* 1000Base-PX or 1000Base-BX10 */
 	if ((id->base.e_base_px || id->base.e_base_bx10) &&
-	    br_min <= 1300 && br_max >= 1200)
+	    br_min <= 1300 && br_max >= 1200) {
 		phylink_set(modes, 1000baseX_Full);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX, interfaces);
+	}
 
 	/* 100Base-FX, 100Base-LX, 100Base-PX, 100Base-BX10 */
-	if (id->base.e100_base_fx || id->base.e100_base_lx)
+	if (id->base.e100_base_fx || id->base.e100_base_lx) {
 		phylink_set(modes, 100baseFX_Full);
-	if ((id->base.e_base_px || id->base.e_base_bx10) && br_nom == 100)
+		__set_bit(PHY_INTERFACE_MODE_100BASEX, interfaces);
+	}
+	if ((id->base.e_base_px || id->base.e_base_bx10) && br_nom == 100) {
 		phylink_set(modes, 100baseFX_Full);
+		__set_bit(PHY_INTERFACE_MODE_100BASEX, interfaces);
+	}
 
 	/* For active or passive cables, select the link modes
 	 * based on the bit rates and the cable compliance bytes.
 	 */
 	if ((id->base.sfp_ct_passive || id->base.sfp_ct_active) && br_nom) {
 		/* This may look odd, but some manufacturers use 12000MBd */
-		if (br_min <= 12000 && br_max >= 10300)
+		if (br_min <= 12000 && br_max >= 10300) {
 			phylink_set(modes, 10000baseCR_Full);
-		if (br_min <= 3200 && br_max >= 3100)
+			__set_bit(PHY_INTERFACE_MODE_10GBASER, interfaces);
+		}
+		if (br_min <= 3200 && br_max >= 3100) {
 			phylink_set(modes, 2500baseX_Full);
-		if (br_min <= 1300 && br_max >= 1200)
+			__set_bit(PHY_INTERFACE_MODE_2500BASEX, interfaces);
+		}
+		if (br_min <= 1300 && br_max >= 1200) {
 			phylink_set(modes, 1000baseX_Full);
+			__set_bit(PHY_INTERFACE_MODE_1000BASEX, interfaces);
+		}
 	}
 	if (id->base.sfp_ct_passive) {
-		if (id->base.passive.sff8431_app_e)
+		if (id->base.passive.sff8431_app_e) {
 			phylink_set(modes, 10000baseCR_Full);
+			__set_bit(PHY_INTERFACE_MODE_10GBASER, interfaces);
+		}
 	}
 	if (id->base.sfp_ct_active) {
 		if (id->base.active.sff8431_app_e ||
 		    id->base.active.sff8431_lim) {
 			phylink_set(modes, 10000baseCR_Full);
+			__set_bit(PHY_INTERFACE_MODE_10GBASER, interfaces);
 		}
 	}
 
@@ -243,12 +272,14 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	case SFF8024_ECC_10GBASE_T_SFI:
 	case SFF8024_ECC_10GBASE_T_SR:
 		phylink_set(modes, 10000baseT_Full);
+		__set_bit(PHY_INTERFACE_MODE_10GBASER, interfaces);
 		break;
 	case SFF8024_ECC_5GBASE_T:
 		phylink_set(modes, 5000baseT_Full);
 		break;
 	case SFF8024_ECC_2_5GBASE_T:
 		phylink_set(modes, 2500baseT_Full);
+		__set_bit(PHY_INTERFACE_MODE_2500BASEX, interfaces);
 		break;
 	default:
 		dev_warn(bus->sfp_dev,
@@ -261,10 +292,14 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	if (id->base.fc_speed_100 ||
 	    id->base.fc_speed_200 ||
 	    id->base.fc_speed_400) {
-		if (id->base.br_nominal >= 31)
+		if (id->base.br_nominal >= 31) {
 			phylink_set(modes, 2500baseX_Full);
-		if (id->base.br_nominal >= 12)
+			__set_bit(PHY_INTERFACE_MODE_2500BASEX, interfaces);
+		}
+		if (id->base.br_nominal >= 12) {
 			phylink_set(modes, 1000baseX_Full);
+			__set_bit(PHY_INTERFACE_MODE_1000BASEX, interfaces);
+		}
 	}
 
 	/* If we haven't discovered any modes that this module supports, try
@@ -277,14 +312,18 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	 * 2500BASE-X, so we allow some slack here.
 	 */
 	if (bitmap_empty(modes, __ETHTOOL_LINK_MODE_MASK_NBITS) && br_nom) {
-		if (br_min <= 1300 && br_max >= 1200)
+		if (br_min <= 1300 && br_max >= 1200) {
 			phylink_set(modes, 1000baseX_Full);
-		if (br_min <= 3200 && br_max >= 2500)
+			__set_bit(PHY_INTERFACE_MODE_1000BASEX, interfaces);
+		}
+		if (br_min <= 3200 && br_max >= 2500) {
 			phylink_set(modes, 2500baseX_Full);
+			__set_bit(PHY_INTERFACE_MODE_2500BASEX, interfaces);
+		}
 	}
 
 	if (bus->sfp_quirk && bus->sfp_quirk->modes)
-		bus->sfp_quirk->modes(id, modes);
+		bus->sfp_quirk->modes(id, modes, interfaces);
 
 	linkmode_or(support, support, modes);
 
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index cb1dbd0d9701..b150e4765819 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -331,13 +331,16 @@ static void sfp_fixup_halny_gsfp(struct sfp *sfp)
 }
 
 static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
-				unsigned long *modes)
+				unsigned long *modes,
+				unsigned long *interfaces)
 {
 	linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT, modes);
+	__set_bit(PHY_INTERFACE_MODE_2500BASEX, interfaces);
 }
 
 static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
-				      unsigned long *modes)
+				      unsigned long *modes,
+				      unsigned long *interfaces)
 {
 	/* Ubiquiti U-Fiber Instant module claims that support all transceiver
 	 * types including 10G Ethernet which is not truth. So clear all claimed
diff --git a/drivers/net/phy/sfp.h b/drivers/net/phy/sfp.h
index 7ad06deae76c..6cf1643214d3 100644
--- a/drivers/net/phy/sfp.h
+++ b/drivers/net/phy/sfp.h
@@ -9,7 +9,8 @@ struct sfp;
 struct sfp_quirk {
 	const char *vendor;
 	const char *part;
-	void (*modes)(const struct sfp_eeprom_id *id, unsigned long *modes);
+	void (*modes)(const struct sfp_eeprom_id *id, unsigned long *modes,
+		      unsigned long *interfaces);
 	void (*fixup)(struct sfp *sfp);
 };
 
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index 302094b855fb..d1f343853b6c 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -535,7 +535,7 @@ int sfp_parse_port(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 		   unsigned long *support);
 bool sfp_may_have_phy(struct sfp_bus *bus, const struct sfp_eeprom_id *id);
 void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
-		       unsigned long *support);
+		       unsigned long *support, unsigned long *interfaces);
 phy_interface_t sfp_select_interface(struct sfp_bus *bus,
 				     unsigned long *link_modes);
 
@@ -568,7 +568,8 @@ static inline bool sfp_may_have_phy(struct sfp_bus *bus,
 
 static inline void sfp_parse_support(struct sfp_bus *bus,
 				     const struct sfp_eeprom_id *id,
-				     unsigned long *support)
+				     unsigned long *support,
+				     unsigned long *interfaces)
 {
 }
 
-- 
2.35.1

