Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11484284B1
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhJKBdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbhJKBcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:32:51 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25733C061570;
        Sun, 10 Oct 2021 18:30:50 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g10so60371536edj.1;
        Sun, 10 Oct 2021 18:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N+uAdgmiUmVRm99fXS9XLqpiUAxi+X0mvr7uzJcMK/8=;
        b=Atyrtm+hsW0pN4i/i0qCRaI/OwttLNeKbwE/f1F4mwCMNz2dnjx8c6sYCtVdjxEPwP
         qcUPmJas7Yo6mIUScwXPecSh2l3BbvfXF9eH3BunFBez5hzx+mowJG2gos51zifHMOhz
         fcZlB2cUWmywOz2kL+5o87CAVdDOBGPEl0uUeM+Ml6XRPOi9rkbFmP6YCUbKAT7A2Coh
         jBFY2n3oGici0WGiYLXuj4VdisLhoMVjGY18z5rlNbPD0Vrb51BAPXuS/KI0p2dbIwWx
         /enYF4rNhWArgZm/T9ZBPFiY4Iv5T9MXu48t8eBddeQyP6nhlD/kTi9z0V27TJv640ly
         UmWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N+uAdgmiUmVRm99fXS9XLqpiUAxi+X0mvr7uzJcMK/8=;
        b=gPcmoGHDVtmzeMrtqnSXaWS3CbNSyAOcdcxuSX3nnQpHkTZecYMuQjYvX+V5KlypY4
         /xwD3U4+N5dvEVtmIGbkAR3KjGD9FZdOss5NCnw3kbAJPt7NDZCYON5H/207W0rwvM3a
         tDYGCkUeCltIciE020huyNSdFfAacOqxzDde+V1fiLsoFLUO33pNMQZDPu2HrIWnNLMc
         880JEo+I/SVcXwnzFoOfhqgIlBf2BrenQK+2l2n/OwIPrmMmC9qVJr+GFgXg5BvtMx13
         FVD+YR1kA0TayMn+lI16ZHYQA2COOn1oCCXYuk83R51T41Cma+cMWfeEpulsauolK478
         j8Rw==
X-Gm-Message-State: AOAM531zsMoWZ7cHVjdS999sbNwzHGhsbyoHQHe4eaEgUDvp7QOxFTB2
        PuezpnaP3TohQkoPr4QBBcjYYv2edD0=
X-Google-Smtp-Source: ABdhPJxhBtA/LJu7Hgb5wCeczTU+8PpWtuEpYpGc1TU7RfMROFcsp7uCNDs5W2TgTOTU062rp85vAg==
X-Received: by 2002:a50:cf48:: with SMTP id d8mr37990801edk.293.1633915848583;
        Sun, 10 Oct 2021 18:30:48 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m15sm21314edd.5.2021.10.10.18.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 18:30:48 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v5 06/14] net: dsa: qca8k: rework rgmii delay logic and scan for cpu port 6
Date:   Mon, 11 Oct 2021 03:30:16 +0200
Message-Id: <20211011013024.569-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011013024.569-1-ansuelsmth@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Future proof commit. This switch have 2 CPU port and one valid
configuration is first CPU port set to sgmii and second CPU port set to
regmii-id. The current implementation detects delay only for CPU port
zero set to rgmii and doesn't count any delay set in a secondary CPU
port. Drop the current delay scan function and move it to the sgmii
parser function to generilize and implicitly add support for secondary
CPU port set to rgmii-id. Introduce new logic where delay is enabled
also with internal delay binding declared and rgmii set as PHY mode.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 162 ++++++++++++++++++++--------------------
 drivers/net/dsa/qca8k.h |  10 ++-
 2 files changed, 87 insertions(+), 85 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index de50116d483e..b1ce625e9324 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -888,68 +888,6 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 	return 0;
 }
 
-static int
-qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
-{
-	struct device_node *port_dn;
-	phy_interface_t mode;
-	struct dsa_port *dp;
-	u32 val;
-
-	/* CPU port is already checked */
-	dp = dsa_to_port(priv->ds, 0);
-
-	port_dn = dp->dn;
-
-	/* Check if port 0 is set to the correct type */
-	of_get_phy_mode(port_dn, &mode);
-	if (mode != PHY_INTERFACE_MODE_RGMII_ID &&
-	    mode != PHY_INTERFACE_MODE_RGMII_RXID &&
-	    mode != PHY_INTERFACE_MODE_RGMII_TXID) {
-		return 0;
-	}
-
-	switch (mode) {
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-		if (of_property_read_u32(port_dn, "rx-internal-delay-ps", &val))
-			val = 2;
-		else
-			/* Switch regs accept value in ns, convert ps to ns */
-			val = val / 1000;
-
-		if (val > QCA8K_MAX_DELAY) {
-			dev_err(priv->dev, "rgmii rx delay is limited to a max value of 3ns, setting to the max value");
-			val = 3;
-		}
-
-		priv->rgmii_rx_delay = val;
-		/* Stop here if we need to check only for rx delay */
-		if (mode != PHY_INTERFACE_MODE_RGMII_ID)
-			break;
-
-		fallthrough;
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-		if (of_property_read_u32(port_dn, "tx-internal-delay-ps", &val))
-			val = 1;
-		else
-			/* Switch regs accept value in ns, convert ps to ns */
-			val = val / 1000;
-
-		if (val > QCA8K_MAX_DELAY) {
-			dev_err(priv->dev, "rgmii tx delay is limited to a max value of 3ns, setting to the max value");
-			val = 3;
-		}
-
-		priv->rgmii_tx_delay = val;
-		break;
-	default:
-		return 0;
-	}
-
-	return 0;
-}
-
 static int
 qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
 {
@@ -996,10 +934,11 @@ static int qca8k_find_cpu_port(struct dsa_switch *ds)
 static int
 qca8k_parse_port_config(struct qca8k_priv *priv)
 {
+	int port, cpu_port_index = 0;
 	struct device_node *port_dn;
 	phy_interface_t mode;
 	struct dsa_port *dp;
-	int port;
+	u32 delay;
 
 	/* We have 2 CPU port. Check them */
 	for (port = 0; port < QCA8K_NUM_PORTS; port++) {
@@ -1009,14 +948,56 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 
 		dp = dsa_to_port(priv->ds, port);
 		port_dn = dp->dn;
+		cpu_port_index++;
 
 		of_get_phy_mode(port_dn, &mode);
-		if (mode == PHY_INTERFACE_MODE_SGMII) {
+		switch (mode) {
+		case PHY_INTERFACE_MODE_RGMII:
+		case PHY_INTERFACE_MODE_RGMII_ID:
+		case PHY_INTERFACE_MODE_RGMII_TXID:
+		case PHY_INTERFACE_MODE_RGMII_RXID:
+			delay = 0;
+
+			if (!of_property_read_u32(port_dn, "tx-internal-delay-ps", &delay))
+				/* Switch regs accept value in ns, convert ps to ns */
+				delay = delay / 1000;
+			else if (mode == PHY_INTERFACE_MODE_RGMII_ID ||
+				 mode == PHY_INTERFACE_MODE_RGMII_TXID)
+				delay = 1;
+
+			if (delay > QCA8K_MAX_DELAY) {
+				dev_err(priv->dev, "rgmii tx delay is limited to a max value of 3ns, setting to the max value");
+				delay = 3;
+			}
+
+			priv->rgmii_tx_delay[cpu_port_index] = delay;
+
+			delay = 0;
+
+			if (!of_property_read_u32(port_dn, "rx-internal-delay-ps", &delay))
+				/* Switch regs accept value in ns, convert ps to ns */
+				delay = delay / 1000;
+			else if (mode == PHY_INTERFACE_MODE_RGMII_ID ||
+				 mode == PHY_INTERFACE_MODE_RGMII_RXID)
+				delay = 2;
+
+			if (delay > QCA8K_MAX_DELAY) {
+				dev_err(priv->dev, "rgmii rx delay is limited to a max value of 3ns, setting to the max value");
+				delay = 3;
+			}
+
+			priv->rgmii_rx_delay[cpu_port_index] = delay;
+
+			break;
+		case PHY_INTERFACE_MODE_SGMII:
 			if (of_property_read_bool(port_dn, "qca,sgmii-txclk-falling-edge"))
 				priv->sgmii_tx_clk_falling_edge = true;
 
 			if (of_property_read_bool(port_dn, "qca,sgmii-rxclk-falling-edge"))
 				priv->sgmii_rx_clk_falling_edge = true;
+
+			break;
+		default:
 		}
 	}
 
@@ -1054,10 +1035,6 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	ret = qca8k_setup_of_rgmii_delay(priv);
-	if (ret)
-		return ret;
-
 	ret = qca8k_setup_mac_pwr_sel(priv);
 	if (ret)
 		return ret;
@@ -1224,8 +1201,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			 const struct phylink_link_state *state)
 {
 	struct qca8k_priv *priv = ds->priv;
-	u32 reg, val;
-	int ret;
+	int cpu_port_index, ret;
+	u32 reg, val, delay;
 
 	switch (port) {
 	case 0: /* 1st CPU port */
@@ -1237,6 +1214,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			return;
 
 		reg = QCA8K_REG_PORT0_PAD_CTRL;
+		cpu_port_index = QCA8K_CPU_PORT0;
 		break;
 	case 1:
 	case 2:
@@ -1255,6 +1233,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			return;
 
 		reg = QCA8K_REG_PORT6_PAD_CTRL;
+		cpu_port_index = QCA8K_CPU_PORT6;
 		break;
 	default:
 		dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
@@ -1269,23 +1248,40 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
-		/* RGMII mode means no delay so don't enable the delay */
-		qca8k_write(priv, reg, QCA8K_PORT_PAD_RGMII_EN);
-		break;
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
-		/* RGMII_ID needs internal delay. This is enabled through
-		 * PORT5_PAD_CTRL for all ports, rather than individual port
-		 * registers
+		val = QCA8K_PORT_PAD_RGMII_EN;
+
+		/* Delay can be declared in 3 different way.
+		 * Mode to rgmii and internal-delay standard binding defined
+		 * rgmii-id or rgmii-tx/rx phy mode set.
+		 * The parse logic set a delay different than 0 only when one
+		 * of the 3 different way is used. In all other case delay is
+		 * not enabled. With ID or TX/RXID delay is enabled and set
+		 * to the default and recommended value.
+		 */
+		if (priv->rgmii_tx_delay[cpu_port_index]) {
+			delay = priv->rgmii_tx_delay[cpu_port_index];
+
+			val |= QCA8K_PORT_PAD_RGMII_TX_DELAY(delay) |
+			       QCA8K_PORT_PAD_RGMII_TX_DELAY_EN;
+		}
+
+		if (priv->rgmii_rx_delay[cpu_port_index]) {
+			delay = priv->rgmii_rx_delay[cpu_port_index];
+
+			val |= QCA8K_PORT_PAD_RGMII_RX_DELAY(delay) |
+			       QCA8K_PORT_PAD_RGMII_RX_DELAY_EN;
+		}
+
+		/* Set RGMII delay based on the selected values */
+		qca8k_write(priv, reg, val);
+
+		/* QCA8337 requires to set rgmii rx delay for all ports.
+		 * This is enabled through PORT5_PAD_CTRL for all ports,
+		 * rather than individual port registers.
 		 */
-		qca8k_write(priv, reg,
-			    QCA8K_PORT_PAD_RGMII_EN |
-			    QCA8K_PORT_PAD_RGMII_TX_DELAY(priv->rgmii_tx_delay) |
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY(priv->rgmii_rx_delay) |
-			    QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
-		/* QCA8337 requires to set rgmii rx delay */
 		if (priv->switch_id == QCA8K_ID_QCA8337)
 			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
 				    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 781521e6a965..5eb0c890dfe4 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -13,6 +13,7 @@
 #include <linux/gpio.h>
 
 #define QCA8K_NUM_PORTS					7
+#define QCA8K_NUM_CPU_PORTS				2
 #define QCA8K_MAX_MTU					9000
 
 #define PHY_ID_QCA8327					0x004dd034
@@ -255,13 +256,18 @@ struct qca8k_match_data {
 	u8 id;
 };
 
+enum {
+	QCA8K_CPU_PORT0,
+	QCA8K_CPU_PORT6,
+};
+
 struct qca8k_priv {
 	u8 switch_id;
 	u8 switch_revision;
-	u8 rgmii_tx_delay;
-	u8 rgmii_rx_delay;
 	bool sgmii_rx_clk_falling_edge;
 	bool sgmii_tx_clk_falling_edge;
+	u8 rgmii_rx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
+	u8 rgmii_tx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
 	bool legacy_phy_port_mapping;
 	struct regmap *regmap;
 	struct mii_bus *bus;
-- 
2.32.0

