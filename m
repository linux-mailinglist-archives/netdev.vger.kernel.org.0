Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2923640E4B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 20:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbiLBTSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 14:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbiLBTSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 14:18:09 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EF64387C;
        Fri,  2 Dec 2022 11:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670008686; x=1701544686;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=vToaefq740Jb/L0Na2JLNjqwlt32ey3lu/CBPuLRBfs=;
  b=iBxcCO9dkGAgfyO+lud+QWl6OvrWA6A1xTEJIvUC88Atq7UHkWaHnTrz
   X8m4KShzge7rjRLayROyCHlipakNyulCZwQVLhIIl20mSJqFt2ZeFKCen
   +EWn+JtJY0x9961jFBVDBo57GrWCrh87SItUyxDWdN8tOEf/209UtwqhR
   9saNmwv1hRle4QXEo8pMyiDozYXEukp89Np2n28hDJNUQsmZVQ67VHtKF
   YlapF+vohXtvJXq8LapF4tUy6FxKrBFFysynGWgL+eMGqN0MZ1YnEtdl1
   D2s/rdBI6f75Fo+PFgfHY/eLETCUOGkhqdYxt4xqBItLNqPROFrQ59weW
   w==;
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="189805242"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Dec 2022 12:18:04 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Dec 2022 12:17:52 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 2 Dec 2022 12:17:51 -0700
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
Subject: [PATCH net-next v2 2/2] dsa: lan9303: Move to PHYLINK
Date:   Fri, 2 Dec 2022 13:17:49 -0600
Message-ID: <20221202191749.27437-3-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221202191749.27437-1-jerry.ray@microchip.com>
References: <20221202191749.27437-1-jerry.ray@microchip.com>
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
 drivers/net/dsa/lan9303-core.c | 73 +++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index baa336bb9d15..2baf6ae7e0a0 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1047,42 +1047,6 @@ static int lan9303_phy_write(struct dsa_switch *ds, int phy, int regnum,
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
@@ -1279,6 +1243,41 @@ static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
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
+		phy_interface_empty(config->supported_interfaces);
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
@@ -1304,7 +1303,7 @@ static const struct dsa_switch_ops lan9303_switch_ops = {
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

