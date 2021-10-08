Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C096842612F
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242261AbhJHAZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242642AbhJHAZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:25:05 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78E1C061570;
        Thu,  7 Oct 2021 17:23:10 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id i20so13531486edj.10;
        Thu, 07 Oct 2021 17:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=A7NLR81J3K/d4wqEfrshrrHqYxKBxx0VTZbNQWYxYys=;
        b=cRnOMixkGAmSanFD6EyEIfXqU8w8IGgyIV6bonGoYy7ZnWBcKz9zRyNPajNlfXhNwg
         RUpPlh5DPPEDKXM9obJds3wsQfAArYwfOBQ1tH0wU5gWjIycTmiRgyBmZVpU/xtM/nN/
         Zyaq2qUp7m0dPZP/3fA1zuwGorDeTViA5Lko44sD5iJox2GqvfrSz+p7L1xwra8zONlV
         2AJ5hwWKRM7B/8PYrNBz/vi/mLGAHSUOcVFi5p5asGQfXnYBCKRaazOSpCM9oMQPxREt
         BQ0LaDcZozAVTf5Y6ElO4khThx9UVvPJ7wRIUNCK4v8YoEW0aAR2v6BpG7i7cm6QoLst
         4R/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A7NLR81J3K/d4wqEfrshrrHqYxKBxx0VTZbNQWYxYys=;
        b=Y6o6nl2KDwYQvjjSlFmV2fF/l5i8AAX5JbEdaW92KwIIv6BknysrrC8/IxqzRh1JMX
         L6NsgEfOqT3LcHeW6/IkQ05buY+sYJf+QvUdoY6+w1Ccw9JhXMZzF5lyegWsV9LUr/zG
         xVVdcif8fYCWKjZPyECw3rNxPlydESgsIxvAzqNnLzmkixglza0yuUsGfWTTS89FZsfX
         TyYxgak0+CRCZBnUdZy6Y686+FM98qqLuwPD5ZVnAzmKpDszV9Lqn8VA1vfoKsKB9ElE
         dnZLDguvH83ci8OLTC6AdA36vqdA1uvl7zxLeBWhQbMLSn10M2n54sf1AXNL5tbaGoEw
         w9Mg==
X-Gm-Message-State: AOAM532UPprj7MhhtxHnmUdQsr1wUnp07KOT4MP//8T0FHJXcG9N6g+D
        teoiEhb36ha83V9ycYFqTgU=
X-Google-Smtp-Source: ABdhPJzigErsVfgazb4ZZeSoCuf0ne2ideo7dxNzkn2tU0UOOcD1mQBl6bWE8npXCOj/l2FQRep6kg==
X-Received: by 2002:a50:e005:: with SMTP id e5mr10374998edl.211.1633652589226;
        Thu, 07 Oct 2021 17:23:09 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:23:08 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net-next PATCH v2 09/15] net: dsa: qca8k: move rgmii delay detection to phylink mac_config
Date:   Fri,  8 Oct 2021 02:22:19 +0200
Message-Id: <20211008002225.2426-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008002225.2426-1-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Future proof commit. This switch have 2 CPU port and one valid
configuration is first CPU port set to sgmii and second CPU port set to
regmii-id. The current implementation detects delay only for CPU port
zero set to rgmii and doesn't count any delay set in a secondary CPU
port. Drop the current delay scan function and move it to the phylink
mac_config to generilize and implicitly add support for secondary CPU
port set to rgmii-id.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 122 +++++++++++++++-------------------------
 drivers/net/dsa/qca8k.h |   2 -
 2 files changed, 45 insertions(+), 79 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 3a040a3ed58e..05ecec4ebc01 100644
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
@@ -1026,10 +964,6 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	ret = qca8k_setup_of_rgmii_delay(priv);
-	if (ret)
-		return ret;
-
 	ret = qca8k_setup_mac_pwr_sel(priv);
 	if (ret)
 		return ret;
@@ -1201,7 +1135,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			 const struct phylink_link_state *state)
 {
 	struct qca8k_priv *priv = ds->priv;
-	u32 reg, val;
+	struct dsa_port *dp;
+	u32 reg, val, delay;
 	int ret;
 
 	switch (port) {
@@ -1252,17 +1187,50 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
-		/* RGMII_ID needs internal delay. This is enabled through
-		 * PORT5_PAD_CTRL for all ports, rather than individual port
-		 * registers
+		dp = dsa_to_port(ds, port);
+		val = QCA8K_PORT_PAD_RGMII_EN;
+
+		if (state->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+		    state->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
+			if (of_property_read_u32(dp->dn, "tx-internal-delay-ps", &delay))
+				delay = 1;
+			else
+				/* Switch regs accept value in ns, convert ps to ns */
+				delay = delay / 1000;
+
+			if (delay > QCA8K_MAX_DELAY) {
+				dev_err(priv->dev, "rgmii tx delay is limited to a max value of 3ns, setting to the max value");
+				delay = 3;
+			}
+
+			val |= QCA8K_PORT_PAD_RGMII_TX_DELAY(delay) |
+			       QCA8K_PORT_PAD_RGMII_TX_DELAY_EN;
+		}
+
+		if (state->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+		    state->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
+			if (of_property_read_u32(dp->dn, "rx-internal-delay-ps", &delay))
+				delay = 2;
+			else
+				/* Switch regs accept value in ns, convert ps to ns */
+				delay = delay / 1000;
+
+			if (delay > QCA8K_MAX_DELAY) {
+				dev_err(priv->dev, "rgmii rx delay is limited to a max value of 3ns, setting to the max value");
+				delay = 3;
+			}
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
index 3fded69a6839..a36ef43e3847 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -261,8 +261,6 @@ struct qca8k_match_data {
 struct qca8k_priv {
 	u8 switch_id;
 	u8 switch_revision;
-	u8 rgmii_tx_delay;
-	u8 rgmii_rx_delay;
 	bool legacy_phy_port_mapping;
 	struct regmap *regmap;
 	struct mii_bus *bus;
-- 
2.32.0

