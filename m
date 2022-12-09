Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB3D648ADF
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiLIWrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLIWrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:47:23 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B201C12A;
        Fri,  9 Dec 2022 14:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670626042; x=1702162042;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=kjBJ1T++jGq2uuDcVYJJloH539ccBnmbGCsz+c3/b0g=;
  b=oWIjY+Ck9rbXsBoT7RajY5umG2wc3mWtv5LipU4Ov5YS49hAXT13gGWr
   TJcBL3prhwfNqhtknE+fMqlytkKqTUJIwdcOzs32bGWESk6CUA4+95Xka
   xjK3am8KnQcC6TIEXRM9Lt4VyVz/bNveP/b+70QINUod/aNu3/WZzgr76
   BoxuMq4NFuxq1Dkq48JK8B4GjQm2ff8EFEQ7SK9TIJFlFOtlpIWSFlNte
   MvUtK0ucvZ99fIJyaVc8oIbZirnQKam0goo+E7t+u39TC2ioZDYL2wLL9
   NcWGF3xWoq7k8kk4Xq6JezYOCGUvmovr+tKieUxpjxG/mnmOQzMtPhRd6
   A==;
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="203381022"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 15:47:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 15:47:21 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Dec 2022 15:47:20 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v5 6/6] dsa: lan9303: Migrate to PHYLINK
Date:   Fri, 9 Dec 2022 16:47:13 -0600
Message-ID: <20221209224713.19980-7-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221209224713.19980-1-jerry.ray@microchip.com>
References: <20221209224713.19980-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces the adjust_link api with the phylink apis that provide
equivalent functionality.

The remaining functionality from the adjust_link is now covered in the
phylink_mac_link_up api.

Removes:
.adjust_link
Adds:
.phylink_get_caps
.phylink_mac_link_up

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
v4->v5:
  - Added various prep patches to better show the movement of the logic.
v3->v4:
  - Reworked the implementation to preserve the adjust_link functionality
    by including it in the phylink_mac_link_up api.
v2->v3:
  Added back in disabling Turbo Mode on the CPU MII interface.
  Removed the unnecessary clearing of the phy supported interfaces.
---
 drivers/net/dsa/lan9303-core.c | 104 ++++++++++++++++++++++-----------
 1 file changed, 71 insertions(+), 33 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 1d22e4b74308..810aef527fe1 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1058,38 +1058,6 @@ static int lan9303_phy_write(struct dsa_switch *ds, int phy, int regnum,
 	return chip->ops->phy_write(chip, phy, regnum, val);
 }
 
-static void lan9303_adjust_link(struct dsa_switch *ds, int port,
-				struct phy_device *phydev)
-{
-	struct lan9303 *chip = ds->priv;
-	int ctl;
-
-	/* On this device, we are only interested in doing something here if
-	 * this is the CPU port. All other ports are 10/100 phys using MDIO
-	 * to control there link settings.
-	 */
-	if (!dsa_is_cpu_port(ds, port))
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
-}
-
 static int lan9303_port_enable(struct dsa_switch *ds, int port,
 			       struct phy_device *phy)
 {
@@ -1286,13 +1254,83 @@ static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
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
+static void lan9303_phylink_mac_link_up(struct dsa_switch *ds, int port,
+					unsigned int mode,
+					phy_interface_t interface,
+					struct phy_device *phydev, int speed,
+					int duplex, bool tx_pause,
+					bool rx_pause)
+{
+	u32 ctl;
+
+	/* On this device, we are only interested in doing something here if
+	 * this is the CPU port. All other ports are 10/100 phys using MDIO
+	 * to control there link settings.
+	 */
+	if (!dsa_is_cpu_port(ds, port))
+		return;
+
+	ctl = lan9303_phy_read(ds, port, MII_BMCR);
+
+	ctl &= ~BMCR_ANENABLE;
+
+	if (speed == SPEED_100)
+		ctl |= BMCR_SPEED100;
+	else if (speed == SPEED_10)
+		ctl &= ~BMCR_SPEED100;
+	else
+		dev_err(ds->dev, "unsupported speed: %d\n", speed);
+
+	if (duplex == DUPLEX_FULL)
+		ctl |= BMCR_FULLDPLX;
+	else
+		ctl &= ~BMCR_FULLDPLX;
+
+	lan9303_phy_write(ds, port, MII_BMCR, ctl);
+}
+
 static const struct dsa_switch_ops lan9303_switch_ops = {
 	.get_tag_protocol	= lan9303_get_tag_protocol,
 	.setup			= lan9303_setup,
 	.get_strings		= lan9303_get_strings,
 	.phy_read		= lan9303_phy_read,
 	.phy_write		= lan9303_phy_write,
-	.adjust_link		= lan9303_adjust_link,
+	.phylink_get_caps	= lan9303_phylink_get_caps,
+	.phylink_mac_link_up	= lan9303_phylink_mac_link_up,
 	.get_ethtool_stats	= lan9303_get_ethtool_stats,
 	.get_sset_count		= lan9303_get_sset_count,
 	.port_enable		= lan9303_port_enable,
-- 
2.17.1

