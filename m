Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815204280B3
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhJJLSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbhJJLSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:18:12 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73880C061762;
        Sun, 10 Oct 2021 04:16:13 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id i20so39112879edj.10;
        Sun, 10 Oct 2021 04:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2v9hsRMfaKbhOo3c4bt+OaSY8rpltS1UJPgbgbrUwXc=;
        b=iYApidVythjgmxHpAbw69PU8tlv3LuEFZxV2bIPdf1ijPQMA0tsFmv/L2iqJSd4LWA
         SVgISuOe94KqhPMUhXHDYznMwaNciH5S2hwesc8uohOOB7XxBKtYFZBuM+RJeNXSRx1W
         DFwULzPwlxE9Rj+kTCY/cha5Kzma8ap8aOU3lKOJgQQ8JmgJQX5gORdwREUKMMW1bfRo
         m73fGnR+Lcrr4iqVLRrwav4bfMDpDNcexwIEAdAzOJ+uKS5U4vzL4Gp1kdj2lIiuK3dp
         yd4bUSNNeHQ67N+9E9nqCMB4lJQOp43Zk1Zy39s+WsTlybAcd7O60YPIofi9d3oH/RIq
         DrbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2v9hsRMfaKbhOo3c4bt+OaSY8rpltS1UJPgbgbrUwXc=;
        b=TbiWTW/S9q6YvKlIw6MuCxbfcyJ6JZYqFL/lHX6eEvJsc7CNxdBiFi3tb4niw4GtOh
         n4iH6Dm5sLUjLNHlfAcWxi34l1lkHJtDZ9OpQlRsrnsFoclpGXOUlfjRffJVxTp4cq1T
         grmpo4N8Gh9jQVZL4i7hqX00jTY1lgEXBxvDa3GFhxei1X2UERz1f7nRw/uN2LYHSNOd
         3UW9YFShLAT8rlMJx/Pe3hl+fK1vCbwPivQ78mq0QcxCAk8P8kNnt4iyxRQiygtCYIss
         AfDcuDQYY+EocfZozqTBLtvT9Uy02jlHxR47XW0QwoxfFK4CC9nOjYrlPnQCJlEaATll
         SIAA==
X-Gm-Message-State: AOAM530q7GtXHre+v76LfhFum7bon7bkkA7p5SuOVdehxV2aF74eQ2sx
        5g6BU3fGC9hVqF3Jv68lPEw=
X-Google-Smtp-Source: ABdhPJwGuRSZhqFbHxJ0TaOtWh1a+IRuzNifmTtrIQKCHUppT1oe23e0KDBSafRk1tf3o1zr8ONG0Q==
X-Received: by 2002:a17:907:7717:: with SMTP id kw23mr18095657ejc.396.1633864571910;
        Sun, 10 Oct 2021 04:16:11 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z5sm2414438edm.82.2021.10.10.04.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 04:16:11 -0700 (PDT)
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
Subject: [net-next PATCH v4 06/13] net: dsa: qca8k: move rgmii delay detection to phylink mac_config
Date:   Sun, 10 Oct 2021 13:15:49 +0200
Message-Id: <20211010111556.30447-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010111556.30447-1-ansuelsmth@gmail.com>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca8k.c | 121 +++++++++++++++-------------------------
 drivers/net/dsa/qca8k.h |   2 -
 2 files changed, 44 insertions(+), 79 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index df0a622acdd7..126f20b0b94c 100644
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
@@ -1019,10 +957,6 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	ret = qca8k_setup_of_rgmii_delay(priv);
-	if (ret)
-		return ret;
-
 	ret = qca8k_setup_mac_pwr_sel(priv);
 	if (ret)
 		return ret;
@@ -1190,7 +1124,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 {
 	struct qca8k_priv *priv = ds->priv;
 	struct dsa_port *dp;
-	u32 reg, val;
+	u32 reg, val, delay;
 	int ret;
 
 	switch (port) {
@@ -1241,17 +1175,50 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
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
index 5df0f0ef6526..a790b27bc310 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -259,8 +259,6 @@ struct qca8k_match_data {
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

