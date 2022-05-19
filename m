Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DD152D549
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 15:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239352AbiESN5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 09:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239074AbiESN5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 09:57:09 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C18663C6;
        Thu, 19 May 2022 06:57:07 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DBB7F240023;
        Thu, 19 May 2022 13:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652968620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T5HVJtctx3gpJWBcmBUXPdRuM6h7gI5qAkK5+JtRuxU=;
        b=CO8RJtvVmUy1s2EUnqCO2BnRsTGkzHRCrVybvOn9SvVRNN3joBdEKkd0GpKyPojdevGxnU
        W0It2jG4mTiYJt1bgwAfeYOIJ/6Nh8RPjSZP0zZKeQiQ8TJDLmzvLl8xpZimqRhn/Dakc0
        DWgQXH+yzH1AnCkQcR8klCAZZ8+NdFaCR5NtzJ0nrXuB+rUZNa06IExZmM7cR3Bn2jb7UO
        7PBL0DRnyOcVl5Lqt+eaz2z7aQamt9SVdxSyDvcRtXdA4LEpe+siLIKLQKQumf9JTk2Ec1
        BxdA/9qK2M1m3HcxwQM9/1iRwrZKsCSytYaVfYyXM1LzioEJgsP+ELPjB7/KyA==
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
Subject: [PATCH net-next 3/6] net: lan966x: Add QUSGMII support for lan966x
Date:   Thu, 19 May 2022 15:56:44 +0200
Message-Id: <20220519135647.465653-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
References: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 .../ethernet/microchip/lan966x/lan966x_main.c |  2 ++
 .../ethernet/microchip/lan966x/lan966x_main.h |  6 +++++
 .../microchip/lan966x/lan966x_phylink.c       |  9 +++++++-
 .../ethernet/microchip/lan966x/lan966x_port.c | 22 ++++++++++++++-----
 .../ethernet/microchip/lan966x/lan966x_regs.h |  6 +++++
 5 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index ca1cef79b83f..b8c2ef905e46 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -728,6 +728,8 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 		  port->phylink_config.supported_interfaces);
 	__set_bit(PHY_INTERFACE_MODE_QSGMII,
 		  port->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_QUSGMII,
+		  port->phylink_config.supported_interfaces);
 	__set_bit(PHY_INTERFACE_MODE_1000BASEX,
 		  port->phylink_config.supported_interfaces);
 	__set_bit(PHY_INTERFACE_MODE_2500BASEX,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index e6642083ab9e..304c784f48f6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -452,4 +452,10 @@ static inline void lan_rmw(u32 val, u32 mask, struct lan966x *lan966x,
 			      gcnt, gwidth, raddr, rinst, rcnt, rwidth));
 }
 
+static inline bool lan966x_is_qsgmii(phy_interface_t mode)
+{
+	return (mode == PHY_INTERFACE_MODE_QSGMII) ||
+	       (mode == PHY_INTERFACE_MODE_QUSGMII);
+}
+
 #endif /* __LAN966X_MAIN_H__ */
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
index 38a7e95d69b4..96708352f53e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
@@ -28,11 +28,18 @@ static int lan966x_phylink_mac_prepare(struct phylink_config *config,
 				       phy_interface_t iface)
 {
 	struct lan966x_port *port = netdev_priv(to_net_dev(config->dev));
+	phy_interface_t serdes_mode = iface;
 	int err;
 
 	if (port->serdes) {
+		/* As far as the SerDes is concerned, QUSGMII is the same as
+		 * QSGMII.
+		 */
+		if (lan966x_is_qsgmii(iface))
+			serdes_mode = PHY_INTERFACE_MODE_QSGMII;
+
 		err = phy_set_mode_ext(port->serdes, PHY_MODE_ETHERNET,
-				       iface);
+				       serdes_mode);
 		if (err) {
 			netdev_err(to_net_dev(config->dev),
 				   "Could not set mode of SerDes\n");
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index f141644e4372..ef65a44b2d34 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -168,7 +168,7 @@ static void lan966x_port_link_up(struct lan966x_port *port)
 	/* Also the GIGA_MODE_ENA(1) needs to be set regardless of the
 	 * port speed for QSGMII ports.
 	 */
-	if (config->portmode == PHY_INTERFACE_MODE_QSGMII)
+	if (lan966x_is_qsgmii(config->portmode))
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
+		    lan966x_is_qsgmii(config->portmode))
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
+	if (!lan966x_is_qsgmii(config->portmode))
 		return;
 
 	lan_rmw(DEV_CLOCK_CFG_PCS_RX_RST_SET(0) |
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 2f59285bef29..d4839e4b8ed5 100644
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
2.36.1

