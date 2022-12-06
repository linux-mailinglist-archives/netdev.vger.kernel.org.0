Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A669C644BD8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiLFSfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiLFSfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:35:25 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BF524F12;
        Tue,  6 Dec 2022 10:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670351717; x=1701887717;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=qDorhu1sCM2Rge6z3lFGpoMSMQin8Kj+ABgTZFl6xb8=;
  b=J1kS8Mt/bsLYiiPam+sqWtwts3H9R7usHbvb1imeggWwU9jyy9IJKucZ
   CtUnxRtb0rWjqTmXcukPXdRxtYpO09jne5LNp7nqVLyrtHcZn1vrfZCpG
   lm4/wqvPtSfjtsAjC+vIVJ/1Mk1aUPlSXRljLnqSkesC0YWsfpCiVAroU
   AvbLuiGAYFBCNGXY0XGEGqrBIM8k9wb1tDzzIKqHFS/xugnoM4kls3ETI
   TfeSldIWnA99vHbsvrV/fo4cvE7ZbpmG8sbQlTOQtsE/KzpWkWNpT6wYv
   2Hmcb9zNFKojt8rHwlSO+oU5rRrijKs2L4DFkpQDoxoeaNv3QHl7j6luI
   g==;
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="126791975"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 11:35:16 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 11:35:07 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 11:35:06 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v3 2/2] dsa: lan9303: Move to PHYLINK
Date:   Tue, 6 Dec 2022 12:35:00 -0600
Message-ID: <20221206183500.6898-3-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221206183500.6898-1-jerry.ray@microchip.com>
References: <20221206183500.6898-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces the .adjust_link api with the .phylink_get_caps api.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
v2-> v3:
  Added back in disabling Turbo Mode on the CPU MII interface.
  Removed the unnecessary clearing of the phy supported interfaces.
---
 drivers/net/dsa/lan9303-core.c | 79 ++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index baa336bb9d15..c6236b328ed8 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -886,6 +886,13 @@ static int lan9303_check_device(struct lan9303 *chip)
 		return ret;
 	}
 
+	/* Virtual Phy: Always disable Turbo 200Mbit mode */
+	ret = lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &reg);
+	if (ret)
+		return ret;
+	reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
+	regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
+
 	return 0;
 }
 
@@ -1047,42 +1054,6 @@ static int lan9303_phy_write(struct dsa_switch *ds, int phy, int regnum,
 	return chip->ops->phy_write(chip, phy, regnum, val);
 }
 
-static void lan9303_adjust_link(struct dsa_switch *ds, int port,
-				struct phy_device *phydev)
-{
-	struct lan9303 *chip = ds->priv;
-	int ctl;
-
-	if (!phy_is_pseudo_fixed_link(phydev))
-		return;
-
-	ctl = lan9303_phy_read(ds, port, MII_BMCR);
-
-	ctl &= ~BMCR_ANENABLE;
-
-	if (phydev->speed == SPEED_100)
-		ctl |= BMCR_SPEED100;
-	else if (phydev->speed == SPEED_10)
-		ctl &= ~BMCR_SPEED100;
-	else
-		dev_err(ds->dev, "unsupported speed: %d\n", phydev->speed);
-
-	if (phydev->duplex == DUPLEX_FULL)
-		ctl |= BMCR_FULLDPLX;
-	else
-		ctl &= ~BMCR_FULLDPLX;
-
-	lan9303_phy_write(ds, port, MII_BMCR, ctl);
-
-	if (port == chip->phy_addr_base) {
-		/* Virtual Phy: Remove Turbo 200Mbit mode */
-		lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &ctl);
-
-		ctl &= ~LAN9303_VIRT_SPECIAL_TURBO;
-		regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, ctl);
-	}
-}
-
 static int lan9303_port_enable(struct dsa_switch *ds, int port,
 			       struct phy_device *phy)
 {
@@ -1279,6 +1250,40 @@ static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static void lan9303_phylink_get_caps(struct dsa_switch *ds, int port,
+				     struct phylink_config *config)
+{
+	struct lan9303 *chip = ds->priv;
+
+	dev_dbg(chip->dev, "%s(%d) entered.", __func__, port);
+
+	config->mac_capabilities = MAC_10 | MAC_100 | MAC_ASYM_PAUSE |
+				   MAC_SYM_PAUSE;
+
+	if (dsa_port_is_cpu(dsa_to_port(ds, port))) {
+		/* cpu port */
+		__set_bit(PHY_INTERFACE_MODE_RMII,
+			  config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_MII,
+			  config->supported_interfaces);
+	} else {
+		/* internal ports */
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
+		/* Compatibility for phylib's default interface type when the
+		 * phy-mode property is absent
+		 */
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  config->supported_interfaces);
+	}
+
+	/* This driver does not make use of the speed, duplex, pause or the
+	 * advertisement in its mac_config, so it is safe to mark this driver
+	 * as non-legacy.
+	 */
+	config->legacy_pre_march2020 = false;
+}
+
 /* For non-cpu ports, the max frame size is 1518.
  * The CPU port supports a max frame size of 1522.
  * There is a JUMBO flag to make the max size 2048, but this driver
@@ -1304,7 +1309,7 @@ static const struct dsa_switch_ops lan9303_switch_ops = {
 	.get_strings = lan9303_get_strings,
 	.phy_read = lan9303_phy_read,
 	.phy_write = lan9303_phy_write,
-	.adjust_link = lan9303_adjust_link,
+	.phylink_get_caps	= lan9303_phylink_get_caps,
 	.get_ethtool_stats = lan9303_get_ethtool_stats,
 	.get_sset_count = lan9303_get_sset_count,
 	.port_enable = lan9303_port_enable,
-- 
2.17.1

