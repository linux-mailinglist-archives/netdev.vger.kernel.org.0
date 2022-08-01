Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90A75865B9
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 09:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiHAHhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 03:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiHAHhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 03:37:39 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AAD3AB19;
        Mon,  1 Aug 2022 00:37:30 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 62158240010;
        Mon,  1 Aug 2022 07:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1659339446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QeuyLgP/uLqTmp79qxlI42HvqT4YfSlW6cpz6A3J+iI=;
        b=QHz9AgQNv8BAY8piu3/bSAJaT8eUTafcFVyVmbdNoRIhnie8BOQayyedCInb5SPkAlXnB3
        ZJRjc9RweBpv5eWxp9Am5TZn9og/TIzgCl3mffUV6QRu8prUFXSJMCfk/eEnSXW30pQumV
        BOuyejQZ1ZYt1zhcl/2a6QlG6qcb63vgoBz9pfwxuMhc/z1pGK+I4V4822kABpOHSKECTT
        p24Y9cLzK/DW/J62RuVO/cg9yXvYjoePLhToNxd0h/LW5E43lh3tUigHuZtG2bmvykH5e/
        Qn4Xxp8GCy3XlIKqPgqRx2YC9Gh9QPilxF5fVuqjs6/wWnmNIHXf/YGnd60mUQ==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v4 4/4] net: lan966x: Add QUSGMII support for lan966x
Date:   Mon,  1 Aug 2022 09:37:13 +0200
Message-Id: <20220801073713.32290-5-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801073713.32290-1-maxime.chevallier@bootlin.com>
References: <20220801073713.32290-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Lan996x controller supports the QUSGMII mode, which is very similar
to QSGMII in the way it's configured and the autonegociation
capababilities it provides.

This commit adds support for that mode, treating it most of the time
like QSGMII, making sure that we do configure the PCS how we should.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V1->V2 : Pass the QUSGMII mode as-is to the generic PHY driver, and use
         phy_interface_num_ports, as per Russell's review
V2->V3 : No changes
V3->V4 : No changes

 .../ethernet/microchip/lan966x/lan966x_main.c |  2 ++
 .../microchip/lan966x/lan966x_phylink.c       |  3 ++-
 .../ethernet/microchip/lan966x/lan966x_port.c | 22 ++++++++++++++-----
 .../ethernet/microchip/lan966x/lan966x_regs.h |  6 +++++
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 1d6e3b641b2e..1e604e8db20c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -778,6 +778,8 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 		  port->phylink_config.supported_interfaces);
 	__set_bit(PHY_INTERFACE_MODE_QSGMII,
 		  port->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_QUSGMII,
+		  port->phylink_config.supported_interfaces);
 	__set_bit(PHY_INTERFACE_MODE_1000BASEX,
 		  port->phylink_config.supported_interfaces);
 	__set_bit(PHY_INTERFACE_MODE_2500BASEX,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
index 38a7e95d69b4..87f3d3a57aed 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
@@ -28,11 +28,12 @@ static int lan966x_phylink_mac_prepare(struct phylink_config *config,
 				       phy_interface_t iface)
 {
 	struct lan966x_port *port = netdev_priv(to_net_dev(config->dev));
+	phy_interface_t serdes_mode = iface;
 	int err;
 
 	if (port->serdes) {
 		err = phy_set_mode_ext(port->serdes, PHY_MODE_ETHERNET,
-				       iface);
+				       serdes_mode);
 		if (err) {
 			netdev_err(to_net_dev(config->dev),
 				   "Could not set mode of SerDes\n");
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index f141644e4372..bbf42fc8c8d5 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -168,7 +168,7 @@ static void lan966x_port_link_up(struct lan966x_port *port)
 	/* Also the GIGA_MODE_ENA(1) needs to be set regardless of the
 	 * port speed for QSGMII ports.
 	 */
-	if (config->portmode == PHY_INTERFACE_MODE_QSGMII)
+	if (phy_interface_num_ports(config->portmode) == 4)
 		mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA_SET(1);
 
 	lan_wr(config->duplex | mode,
@@ -331,10 +331,14 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
 	struct lan966x *lan966x = port->lan966x;
 	bool inband_aneg = false;
 	bool outband;
+	bool full_preamble = false;
+
+	if (config->portmode == PHY_INTERFACE_MODE_QUSGMII)
+		full_preamble = true;
 
 	if (config->inband) {
 		if (config->portmode == PHY_INTERFACE_MODE_SGMII ||
-		    config->portmode == PHY_INTERFACE_MODE_QSGMII)
+		    phy_interface_num_ports(config->portmode) == 4)
 			inband_aneg = true; /* Cisco-SGMII in-band-aneg */
 		else if (config->portmode == PHY_INTERFACE_MODE_1000BASEX &&
 			 config->autoneg)
@@ -345,9 +349,15 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
 		outband = true;
 	}
 
-	/* Disable or enable inband */
-	lan_rmw(DEV_PCS1G_MODE_CFG_SGMII_MODE_ENA_SET(outband),
-		DEV_PCS1G_MODE_CFG_SGMII_MODE_ENA,
+	/* Disable or enable inband.
+	 * For QUSGMII, we rely on the preamble to transmit data such as
+	 * timestamps, therefore force full preamble transmission, and prevent
+	 * premable shortening
+	 */
+	lan_rmw(DEV_PCS1G_MODE_CFG_SGMII_MODE_ENA_SET(outband) |
+		DEV_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA_SET(full_preamble),
+		DEV_PCS1G_MODE_CFG_SGMII_MODE_ENA |
+		DEV_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA,
 		lan966x, DEV_PCS1G_MODE_CFG(port->chip_port));
 
 	/* Enable PCS */
@@ -396,7 +406,7 @@ void lan966x_port_init(struct lan966x_port *port)
 	if (lan966x->fdma)
 		lan966x_fdma_netdev_init(lan966x, port->dev);
 
-	if (config->portmode != PHY_INTERFACE_MODE_QSGMII)
+	if (phy_interface_num_ports(config->portmode) != 4)
 		return;
 
 	lan_rmw(DEV_CLOCK_CFG_PCS_RX_RST_SET(0) |
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 8265ad89f0bc..c53bae5d8dbd 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -504,6 +504,12 @@ enum lan966x_target {
 #define DEV_PCS1G_MODE_CFG_SGMII_MODE_ENA_GET(x)\
 	FIELD_GET(DEV_PCS1G_MODE_CFG_SGMII_MODE_ENA, x)
 
+#define DEV_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA        BIT(1)
+#define DEV_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA_SET(x)\
+	FIELD_PREP(DEV_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA, x)
+#define DEV_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA_GET(x)\
+	FIELD_GET(DEV_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA, x)
+
 /*      DEV:PCS1G_CFG_STATUS:PCS1G_SD_CFG */
 #define DEV_PCS1G_SD_CFG(t)       __REG(TARGET_DEV, t, 8, 72, 0, 1, 68, 8, 0, 1, 4)
 
-- 
2.37.1

