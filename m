Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8ED427E4D
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 03:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhJJB6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 21:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbhJJB6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 21:58:15 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD27C061570;
        Sat,  9 Oct 2021 18:56:17 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y12so38931962eda.4;
        Sat, 09 Oct 2021 18:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=76EGozKysDsid4PBsA7POrevwp5ilwSPedQ5ZoavCE4=;
        b=NfyqQlmlYKAHsmhWBrE4TUctt4Hnw0dlxcXuaUnVDKDTR645g2zYIE5EeGhGdZCULR
         bUwMcM6GE3gJr1SCE/0qo8jvmcDxiPKP11Fbndik98v+LDzUg1WkARNXMk5oFTExK5LM
         nCak8koxsOscWeYDnjAVBoQC8ZzPHHj3J1ihCivnIkulh4WVh9QRS15vB9oEvEUZZpq7
         K3aUgCrhyKwwG3C0/Jeayr+Xn6HpU5D7dxKIlNEz9lk1HX5is/D2NWEkZN4WbXV1ogdi
         le5rBNc3ztAnZhLkQTR95NPyMAQH0p7A0TD9DD7LJRbvA/GkrCVaCeALaGgn9fcupEg/
         aaxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=76EGozKysDsid4PBsA7POrevwp5ilwSPedQ5ZoavCE4=;
        b=GstViEiqOMGhABhve8KJ3+bGy9cUMny0y8ggSis0/1sy+v76Icewhe+TL/hUmP1q1v
         r0oLTvN8sNqq5SWaULNrRulkPH7d9+33mkdwLz2uxD7/rgqVeI2g0BcqSvZlvCX7Azj2
         rDZpGT6QgsVvhSc9V8K4MtyXpLDJe4seVm2iihREpWn6koOCf3LwIzkBBsMWntiwBFQ5
         mFInmOmUv7lBK/PKPvx5jh3i49FmJ7o+rQrHVvP9UVjH4ua3/nqNO5GA6M2O1acwUUy7
         mAIoeRcGK3C2hgcfZQc4dJkqJJ4xvgb9te3G28ItR96KFqBZ5EvYiFOt/lCyBGVSlp5i
         G8Aw==
X-Gm-Message-State: AOAM531DfGMPhEQk2c56N5pDeQ+Ri4qeEChdXVzCc54nt5aSzBOkekhJ
        P1vGetvor213XVRDeOxuX3I=
X-Google-Smtp-Source: ABdhPJwkwjro4Sis0idfoYxWj2fuT6dWySRIGbFkw5V3oonMlaFSAWxvn008aZrjRN8dD6o6fUSwcQ==
X-Received: by 2002:a50:d84e:: with SMTP id v14mr28332781edj.85.1633830975869;
        Sat, 09 Oct 2021 18:56:15 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id x11sm1877253edj.62.2021.10.09.18.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 18:56:15 -0700 (PDT)
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
Subject: [net-next PATCH v3 06/13] net: dsa: qca8k: move rgmii delay detection to phylink mac_config
Date:   Sun, 10 Oct 2021 03:55:56 +0200
Message-Id: <20211010015603.24483-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010015603.24483-1-ansuelsmth@gmail.com>
References: <20211010015603.24483-1-ansuelsmth@gmail.com>
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
index 91334fa23183..043980a5db7f 100644
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

