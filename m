Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B986632B8
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 22:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237973AbjAIVUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 16:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237709AbjAIVT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 16:19:28 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BAFEA0;
        Mon,  9 Jan 2023 13:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673299152; x=1704835152;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=bF71XwdfkyXFfdauaOthhsM1+Sz7taE1BuvslIS1rog=;
  b=N859cFPKWrhNX/gvtgr60t7pb9k5ca1Ue24sqUGDTBac3ExkLZbbk+RT
   cli7BLymxjeUe5GsrJxcyyvU8j+Yfi4SuQN3I+QCntOGxe0HcNoawGve3
   E3oVnjZgMlfvuCLIrMroh98LE0zg/7m15X/JodEyjGD3UnyhcJFIrz1Jb
   28+2mFr8vaefihLgjw0c5kk197RWY17f2177SSsNM0re1veKocuNSI1VD
   6LEcOyRba749TtDarPWX0kcQbZv70fKqb6Te7DlLaFu14UUA25maSfunb
   hl55rDjAhKAy3umFrQOqwhREQsnh8PtP8VnHM4NBlZi7spkaw36nOKwyH
   A==;
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="196049306"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jan 2023 14:19:11 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 14:19:09 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 14:19:07 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v6 6/6] dsa: lan9303: Migrate to PHYLINK
Date:   Mon, 9 Jan 2023 15:18:49 -0600
Message-ID: <20230109211849.32530-7-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230109211849.32530-1-jerry.ray@microchip.com>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
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
v5->v6:
  - Moved to using port number to identify xMII port for the LAN9303.
v4->v5:
  - Added various prep patches to better show the movement of the logic.
v3->v4:
  - Reworked the implementation to preserve the adjust_link functionality
    by including it in the phylink_mac_link_up api.
v2->v3:
  Added back in disabling Turbo Mode on the CPU MII interface.
  Removed the unnecessary clearing of the phy supported interfaces.
---
 drivers/net/dsa/lan9303-core.c | 101 ++++++++++++++++++++++-----------
 1 file changed, 69 insertions(+), 32 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 7be4c491e5d9..e514fff81af6 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1058,37 +1058,6 @@ static int lan9303_phy_write(struct dsa_switch *ds, int phy, int regnum,
 	return chip->ops->phy_write(chip, phy, regnum, val);
 }
 
-static void lan9303_adjust_link(struct dsa_switch *ds, int port,
-				struct phy_device *phydev)
-{
-	int ctl;
-
-	/* On this device, we are only interested in doing something here if
-	 * this is an xMII port. All other ports are 10/100 phys using MDIO
-	 * to control there link settings.
-	 */
-	if (port != 0)
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
@@ -1285,13 +1254,81 @@ static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
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
+	if (port == 0) {
+		__set_bit(PHY_INTERFACE_MODE_RMII,
+			  config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_MII,
+			  config->supported_interfaces);
+	} else {
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
+	 * this is the xMII port. All other ports are 10/100 phys using MDIO
+	 * to control there link settings.
+	 */
+	if (port != 0)
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

