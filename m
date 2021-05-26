Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB39E391954
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 15:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbhEZN6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 09:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbhEZN5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 09:57:38 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D0AC06175F
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:56:06 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id k14so2639469eji.2
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oqUoU6rHfW0PLI4QpYCajuab8//yEteqkwgtUVbNRUE=;
        b=bnv0wwU+9EfZOEvXk5qhDAhtuVmCWORajr8KXE7lGZgHMaU+RIoyZI6h2zhK1qJG0M
         OhyS4BbQjuM07LgwJItzfB19xkoEGBnca1+VUnn5VBylL+sHCfmMMp0Hpf5uCHPTJAPO
         S9Yqztya8PnuF6ygtNEXO0Gg+lxMXoytOA88IxgVsdw4dwu5FB1cFndaPaeGJBfj/LJq
         OP+Q9aKUGw8g35FuVQTMrh6I3hYEuA7fb0QtRIadClo4pjOCOY5a/mGbV+ChaPAXyDO6
         HKqEfeYP2FU5n7mPVlRi22mgiIWFxire+suSSTGilbdcaVPGPAxQLm5NzjgeZ8LM9Vfi
         XWWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oqUoU6rHfW0PLI4QpYCajuab8//yEteqkwgtUVbNRUE=;
        b=pIbvmvzorn4YILiD4GUuCXYCfbiJkgatRy2DuUBD02oEzWZUYF68BLtR9ZsZ5PfLv+
         Xn2Y9x+kpZHhegzagr7RnKGk5tQJtOvVVnJxsZmkw7GsXpTieQxsjivzPuWpq6KX9cnt
         K5J3RgNIDGVMJXIUzV28EaiSyRPeTyZVpTAfc2cDj1Itv5cwn4RMa4FXi7M17gFss3EQ
         AvgNYLmfhOuzI6RnifWZX+0WO4ggLA1EiYdZTqATAgNtz/cYcvP26uDGuLQ2Za8l/bGr
         m6XmwzQhNFR9brDJC+4oJkiTDyyIgRDakrOgfJAk33w65oPlB/GFG0cvSqNaMCyD0945
         qIyw==
X-Gm-Message-State: AOAM532nJUCsx6sB/+51e+VqtCvWjxGPjRi08RPN6c/v6J6phwnxnNfd
        Q5JkLyk7sSnG0DfzRjYrARU=
X-Google-Smtp-Source: ABdhPJzWexR6bnDlUdvmZNwBsWh+IdpQsZq9B291zc4BJjwCyMnGk/wa3+EsBu6SxrHjfvtK1FSQ9A==
X-Received: by 2002:a17:906:2854:: with SMTP id s20mr33613192ejc.335.1622037365315;
        Wed, 26 May 2021 06:56:05 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id k11sm10508476ejc.94.2021.05.26.06.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 06:56:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC PATCH v2 linux-next 14/14] net: dsa: sja1105: add support for the SJA1110 SGMII/2500base-x PCS
Date:   Wed, 26 May 2021 16:55:35 +0300
Message-Id: <20210526135535.2515123-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Configure the Synopsys PCS for 10/100/1000 SGMII in autoneg on/off
modes, or for fixed 2500base-x.

The portion of PCS configuration that forces the speed is common, but
the portion that initializes the PCS and enables/disables autoneg is
different, so a new .pcs_config() method was introduced in struct
sja1105_info to hide away the differences.

For the xMII Mode Parameters Table to be properly configured for SGMII
mode on SJA1110, we need to set the "special" bit, since SGMII is
officially bitwise coded as 0b0011 in SJA1105 (decimal 3, equal to
XMII_MODE_SGMII), and as 0b1011 in SJA1110 (decimal 11).

Cc: Russell King <linux@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/dsa/sja1105/sja1105.h       |   9 +
 drivers/net/dsa/sja1105/sja1105_main.c  | 224 ++++++++++++++++++++++--
 drivers/net/dsa/sja1105/sja1105_mdio.c  |   3 +-
 drivers/net/dsa/sja1105/sja1105_sgmii.h |  61 +++++++
 drivers/net/dsa/sja1105/sja1105_spi.c   |   8 +
 5 files changed, 293 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index be788ddb7259..617d139a627f 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -132,6 +132,9 @@ struct sja1105_info {
 	int (*clocking_setup)(struct sja1105_private *priv);
 	int (*pcs_mdio_read)(struct mii_bus *bus, int phy, int reg);
 	int (*pcs_mdio_write)(struct mii_bus *bus, int phy, int reg, u16 val);
+	void (*pcs_config)(struct sja1105_private *priv, int port,
+			   bool an_enabled, bool an_master,
+			   phy_interface_t interface);
 	const char *name;
 	bool supports_mii[SJA1105_MAX_NUM_PORTS];
 	bool supports_rmii[SJA1105_MAX_NUM_PORTS];
@@ -304,6 +307,12 @@ int sja1110_pcs_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val);
 int sja1105_pcs_read(struct sja1105_private *priv, int port, int mmd, int reg);
 int sja1105_pcs_write(struct sja1105_private *priv, int port, int mmd, int reg,
 		      u16 val);
+void sja1105_pcs_config(struct sja1105_private *priv, int port,
+			bool an_enabled, bool an_master,
+			phy_interface_t interface);
+void sja1110_pcs_config(struct sja1105_private *priv, int port,
+			bool an_enabled, bool an_master,
+			phy_interface_t interface);
 
 /* From sja1105_devlink.c */
 int sja1105_devlink_setup(struct dsa_switch *ds);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d0938daacbae..2ef23c8f725b 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -210,12 +210,14 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 				goto unsupported;
 
 			mii->xmii_mode[i] = XMII_MODE_SGMII;
+			mii->special[i] = true;
 			break;
 		case PHY_INTERFACE_MODE_2500BASEX:
 			if (!priv->info->supports_2500basex[i])
 				goto unsupported;
 
 			mii->xmii_mode[i] = XMII_MODE_SGMII;
+			mii->special[i] = true;
 			break;
 unsupported:
 		default:
@@ -234,6 +236,7 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 		 * but unconditionally put the port in the MAC role.
 		 */
 		if (ports[i].phy_mode == PHY_INTERFACE_MODE_SGMII ||
+		    ports[i].phy_mode == PHY_INTERFACE_MODE_2500BASEX ||
 		    phy_interface_mode_is_rgmii(ports[i].phy_mode))
 			mii->phy_mac[i] = XMII_MAC;
 		else
@@ -962,8 +965,9 @@ static int sja1105_parse_dt(struct sja1105_private *priv,
 	return rc;
 }
 
-static void sja1105_sgmii_pcs_config(struct sja1105_private *priv, int port,
-				     bool an_enabled, bool an_master)
+void sja1105_pcs_config(struct sja1105_private *priv, int port,
+			bool an_enabled, bool an_master,
+			phy_interface_t interface)
 {
 	u16 ac = SJA1105_AC_AUTONEG_MODE_SGMII;
 	int rc;
@@ -1012,6 +1016,188 @@ static void sja1105_sgmii_pcs_config(struct sja1105_private *priv, int port,
 		ERR_PTR(rc));
 }
 
+void sja1110_pcs_config(struct sja1105_private *priv, int port,
+			bool an_enabled, bool an_master,
+			phy_interface_t interface)
+{
+	const int timeout_us = 1000;
+	u16 val;
+	int rc;
+
+	/* Soft-reset the PCS */
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2, MDIO_CTRL1,
+			       MDIO_CTRL1_RESET);
+	if (rc < 0)
+		goto out_write_failed;
+
+	rc = read_poll_timeout(sja1105_pcs_read, val,
+			       !(val & MDIO_CTRL1_RESET),
+			       0, timeout_us, false,
+			       priv, port, MDIO_MMD_VEND2, MDIO_CTRL1);
+	if (rc || val < 0) {
+		dev_err(priv->ds->dev, "port %d PCS reset failed: %pe\n",
+			port, ERR_PTR(rc));
+		return;
+	}
+
+	val = SJA1105_DC1_EN_VSMMD1;
+	if (interface == PHY_INTERFACE_MODE_2500BASEX)
+		val |= SJA1105_DC1_ENA_2500_MODE;
+	if (an_master)
+		val |= SJA1105_DC1_MAC_AUTO_SW;
+
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2, SJA1105_DC1, val);
+	if (rc < 0)
+		goto out_write_failed;
+
+	/* Program TX PLL feedback divider and reference divider settings for
+	 * correct oscillation frequency.
+	 */
+	if (interface == PHY_INTERFACE_MODE_2500BASEX)
+		val = SJA1105_TXPLL_FBDIV(0x7d);
+	else
+		val = SJA1105_TXPLL_FBDIV(0x19);
+
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2, SJA1105_TXPLL_CTRL0,
+			       val);
+	if (rc < 0)
+		goto out_write_failed;
+
+	if (interface == PHY_INTERFACE_MODE_2500BASEX)
+		val = SJA1105_TXPLL_REFDIV(0x2);
+	else
+		val = SJA1105_TXPLL_REFDIV(0x1);
+
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2, SJA1105_TXPLL_CTRL1,
+			       val);
+	if (rc < 0)
+		goto out_write_failed;
+
+	/* Program transmitter amplitude and disable amplitude trimming */
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2,
+			       SJA1105_LANE_DRIVER1_0,
+			       SJA1105_TXDRV(0x5));
+	if (rc < 0)
+		goto out_write_failed;
+
+	val = SJA1105_TXDRVTRIM_LSB(0xffffffull);
+
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2,
+			       SJA1105_LANE_DRIVER2_0, val);
+	if (rc < 0)
+		goto out_write_failed;
+
+	val = SJA1105_TXDRVTRIM_MSB(0xffffffull) | SJA1105_LANE_DRIVER2_1_RSV;
+
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2,
+			       SJA1105_LANE_DRIVER2_1, val);
+	if (rc < 0)
+		goto out_write_failed;
+
+	/* Enable input and output resistor terminations for low BER. */
+	val = SJA1105_ACCOUPLE_RXVCM_EN | SJA1105_CDR_GAIN |
+	      SJA1105_RXRTRIM(4) | SJA1105_RXTEN | SJA1105_TXPLL_BWSEL |
+	      SJA1105_TXRTRIM(3) | SJA1105_TXTEN;
+
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2, SJA1105_LANE_TRIM,
+			       val);
+	if (rc < 0)
+		goto out_write_failed;
+
+	/* Select PCS as transmitter data source. */
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2,
+			       SJA1105_LANE_DATAPATH_1, 0);
+	if (rc < 0)
+		goto out_write_failed;
+
+	/* Program RX PLL feedback divider and reference divider for correct
+	 * oscillation frequency.
+	 */
+	if (interface == PHY_INTERFACE_MODE_2500BASEX)
+		val = SJA1105_RXPLL_FBDIV(0x7d);
+	else
+		val = SJA1105_RXPLL_FBDIV(0x19);
+
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2, SJA1105_RXPLL_CTRL0,
+			       val);
+	if (rc < 0)
+		goto out_write_failed;
+
+	if (interface == PHY_INTERFACE_MODE_2500BASEX)
+		val = SJA1105_RXPLL_REFDIV(0x2);
+	else
+		val = SJA1105_RXPLL_REFDIV(0x1);
+
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2, SJA1105_RXPLL_CTRL1,
+			       val);
+	if (rc < 0)
+		goto out_write_failed;
+
+	/* Program threshold for receiver signal detector.
+	 * Enable control of RXPLL by receiver signal detector to disable RXPLL
+	 * when an input signal is not present.
+	 */
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2,
+			       SJA1105_RX_DATA_DETECT, 0x0005);
+	if (rc < 0)
+		goto out_write_failed;
+
+	/* Enable TX and RX PLLs and circuits.
+	 * Release reset of PMA to enable data flow to/from PCS.
+	 */
+	val = sja1105_pcs_read(priv, port, MDIO_MMD_VEND2,
+			       SJA1105_POWERDOWN_ENABLE);
+	if (val < 0) {
+		dev_err(priv->ds->dev, "failed to read PCS: %pe\n",
+			ERR_PTR(val));
+		return;
+	}
+
+	val &= ~(SJA1105_TXPLL_PD | SJA1105_TXPD | SJA1105_RXCH_PD |
+		 SJA1105_RXBIAS_PD | SJA1105_RESET_SER_EN |
+		 SJA1105_RESET_SER | SJA1105_RESET_DES);
+	val |= SJA1105_RXPKDETEN | SJA1105_RCVEN;
+
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2,
+			       SJA1105_POWERDOWN_ENABLE, val);
+	if (rc < 0)
+		goto out_write_failed;
+
+	/* Program continuous-time linear equalizer (CTLE) settings. */
+	if (interface == PHY_INTERFACE_MODE_2500BASEX)
+		val = 0x732a;
+	else
+		val = 0x212a;
+
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2, SJA1105_RX_CDR_CTLE,
+			       val);
+	if (rc < 0)
+		goto out_write_failed;
+
+	/* AUTONEG_CONTROL: Use SGMII autoneg in MAC mode */
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2, SJA1105_AC,
+			       SJA1105_AC_AUTONEG_MODE_SGMII);
+	if (rc < 0)
+		goto out_write_failed;
+
+	/* BASIC_CONTROL: enable in-band AN now, if requested. Otherwise,
+	 * sja1105_sgmii_pcs_force_speed must be called later for the link
+	 * to become operational.
+	 */
+	if (an_enabled) {
+		rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2, MDIO_CTRL1,
+				       BMCR_ANENABLE | BMCR_ANRESTART);
+		if (rc < 0)
+			goto out_write_failed;
+	}
+
+	return;
+
+out_write_failed:
+	dev_err(priv->ds->dev, "Failed to write to PCS: %pe\n",
+		ERR_PTR(rc));
+}
+
 static void sja1105_sgmii_pcs_force_speed(struct sja1105_private *priv,
 					  int port, int speed)
 {
@@ -1019,6 +1205,7 @@ static void sja1105_sgmii_pcs_force_speed(struct sja1105_private *priv,
 	int rc;
 
 	switch (speed) {
+	case SPEED_2500:
 	case SPEED_1000:
 		pcs_speed = BMCR_SPEED1000;
 		break;
@@ -1092,6 +1279,9 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	case SPEED_1000:
 		speed = priv->info->port_speed[SJA1105_SPEED_1000MBPS];
 		break;
+	case SPEED_2500:
+		speed = priv->info->port_speed[SJA1105_SPEED_2500MBPS];
+		break;
 	default:
 		dev_err(dev, "Invalid speed %iMbps\n", speed_mbps);
 		return -EINVAL;
@@ -1106,6 +1296,8 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	 */
 	if (priv->phy_mode[port] == PHY_INTERFACE_MODE_SGMII)
 		mac[port].speed = priv->info->port_speed[SJA1105_SPEED_1000MBPS];
+	else if (priv->phy_mode[port] == PHY_INTERFACE_MODE_2500BASEX)
+		mac[port].speed = priv->info->port_speed[SJA1105_SPEED_2500MBPS];
 	else
 		mac[port].speed = speed;
 
@@ -1162,10 +1354,10 @@ static void sja1105_mac_config(struct dsa_switch *ds, int port,
 		return;
 	}
 
-	if (is_sgmii)
-		sja1105_sgmii_pcs_config(priv, port,
-					 phylink_autoneg_inband(mode),
-					 false);
+	if (state->interface == PHY_INTERFACE_MODE_SGMII ||
+	    state->interface == PHY_INTERFACE_MODE_2500BASEX)
+		priv->info->pcs_config(priv, port, phylink_autoneg_inband(mode),
+				       false, state->interface);
 }
 
 static void sja1105_mac_link_down(struct dsa_switch *ds, int port,
@@ -1186,7 +1378,8 @@ static void sja1105_mac_link_up(struct dsa_switch *ds, int port,
 
 	sja1105_adjust_port_config(priv, port, speed);
 
-	if (priv->phy_mode[port] == PHY_INTERFACE_MODE_SGMII &&
+	if ((priv->phy_mode[port] == PHY_INTERFACE_MODE_SGMII ||
+	     priv->phy_mode[port] == PHY_INTERFACE_MODE_2500BASEX) &&
 	    !phylink_autoneg_inband(mode))
 		sja1105_sgmii_pcs_force_speed(priv, port, speed);
 
@@ -1228,6 +1421,10 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 	if (mii->xmii_mode[port] == XMII_MODE_RGMII ||
 	    mii->xmii_mode[port] == XMII_MODE_SGMII)
 		phylink_set(mask, 1000baseT_Full);
+	if (priv->info->supports_2500basex[port]) {
+		phylink_set(mask, 2500baseT_Full);
+		phylink_set(mask, 2500baseX_Full);
+	}
 
 	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	bitmap_and(state->advertising, state->advertising, mask,
@@ -1945,7 +2142,8 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 							      mac[i].speed);
 		mac[i].speed = priv->info->port_speed[SJA1105_SPEED_AUTO];
 
-		if (priv->phy_mode[i] == PHY_INTERFACE_MODE_SGMII)
+		if (priv->phy_mode[i] == PHY_INTERFACE_MODE_SGMII ||
+		    priv->phy_mode[i] == PHY_INTERFACE_MODE_2500BASEX)
 			bmcr[i] = sja1105_pcs_read(priv, i,
 						   MDIO_MMD_VEND2,
 						   MDIO_CTRL1);
@@ -2002,17 +2200,21 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		if (rc < 0)
 			goto out;
 
-		if (priv->phy_mode[i] != PHY_INTERFACE_MODE_SGMII)
+		if (priv->phy_mode[i] != PHY_INTERFACE_MODE_SGMII &&
+		    priv->phy_mode[i] != PHY_INTERFACE_MODE_2500BASEX)
 			continue;
 
 		an_enabled = !!(bmcr[i] & BMCR_ANENABLE);
 
-		sja1105_sgmii_pcs_config(priv, i, an_enabled, false);
+		priv->info->pcs_config(priv, i, an_enabled, false,
+				       priv->phy_mode[i]);
 
 		if (!an_enabled) {
 			int speed = SPEED_UNKNOWN;
 
-			if (bmcr[i] & BMCR_SPEED1000)
+			if (priv->phy_mode[i] == PHY_INTERFACE_MODE_2500BASEX)
+				speed = SPEED_2500;
+			else if (bmcr[i] & BMCR_SPEED1000)
 				speed = SPEED_1000;
 			else if (bmcr[i] & BMCR_SPEED100)
 				speed = SPEED_100;
diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index bc6c3c1ac7a6..26c2bf8ed1f0 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -432,7 +432,8 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
 		if (dsa_is_unused_port(ds, port))
 			continue;
 
-		if (!priv->info->supports_sgmii[port])
+		if (!priv->info->supports_sgmii[port] &&
+		    !priv->info->supports_2500basex[port])
 			continue;
 
 		mdiodev = mdio_device_create(bus, port);
diff --git a/drivers/net/dsa/sja1105/sja1105_sgmii.h b/drivers/net/dsa/sja1105/sja1105_sgmii.h
index dc067b876758..b2d117f68417 100644
--- a/drivers/net/dsa/sja1105/sja1105_sgmii.h
+++ b/drivers/net/dsa/sja1105/sja1105_sgmii.h
@@ -15,6 +15,7 @@
 #define SJA1105_DC1_INIT		BIT(8)
 #define SJA1105_DC1_TX_DISABLE		BIT(4)
 #define SJA1105_DC1_AUTONEG_TIMER_OVRR	BIT(3)
+#define SJA1105_DC1_ENA_2500_MODE	BIT(2)
 #define SJA1105_DC1_BYP_POWERUP		BIT(1)
 #define SJA1105_DC1_PHY_MODE_CONTROL	BIT(0)
 
@@ -48,4 +49,64 @@
 #define SJA1105_DC_SUPPRESS_LOS		BIT(4)
 #define SJA1105_DC_RESTART_SYNC		BIT(0)
 
+/* LANE_DRIVER1_0 register (address 0x1f8038) */
+#define SJA1105_LANE_DRIVER1_0		0x8038
+#define SJA1105_TXDRV(x)		(((x) << 12) & GENMASK(14, 12))
+
+/* LANE_DRIVER2_0 register (address 0x1f803a) */
+#define SJA1105_LANE_DRIVER2_0		0x803a
+#define SJA1105_TXDRVTRIM_LSB(x)	((x) & GENMASK_ULL(15, 0))
+
+/* LANE_DRIVER2_1 register (address 0x1f803b) */
+#define SJA1105_LANE_DRIVER2_1		0x803b
+#define SJA1105_LANE_DRIVER2_1_RSV	BIT(9)
+#define SJA1105_TXDRVTRIM_MSB(x)	(((x) & GENMASK_ULL(23, 16)) >> 16)
+
+/* LANE_TRIM register (address 0x1f8040) */
+#define SJA1105_LANE_TRIM		0x8040
+#define SJA1105_TXTEN			BIT(11)
+#define SJA1105_TXRTRIM(x)		(((x) << 8) & GENMASK(10, 8))
+#define SJA1105_TXPLL_BWSEL		BIT(7)
+#define SJA1105_RXTEN			BIT(6)
+#define SJA1105_RXRTRIM(x)		(((x) << 3) & GENMASK(5, 3))
+#define SJA1105_CDR_GAIN		BIT(2)
+#define SJA1105_ACCOUPLE_RXVCM_EN	BIT(0)
+
+/* LANE_DATAPATH_1 register (address 0x1f8037) */
+#define SJA1105_LANE_DATAPATH_1		0x8037
+
+/* POWERDOWN_ENABLE register (address 0x1f8041) */
+#define SJA1105_POWERDOWN_ENABLE	0x8041
+#define SJA1105_TXPLL_PD		BIT(12)
+#define SJA1105_TXPD			BIT(11)
+#define SJA1105_RXPKDETEN		BIT(10)
+#define SJA1105_RXCH_PD			BIT(9)
+#define SJA1105_RXBIAS_PD		BIT(8)
+#define SJA1105_RESET_SER_EN		BIT(7)
+#define SJA1105_RESET_SER		BIT(6)
+#define SJA1105_RESET_DES		BIT(5)
+#define SJA1105_RCVEN			BIT(4)
+
+/* RXPLL_CTRL0 register (address 0x1f8065) */
+#define SJA1105_RXPLL_CTRL0		0x8065
+#define SJA1105_RXPLL_FBDIV(x)		(((x) << 2) & GENMASK(9, 2))
+
+/* RXPLL_CTRL1 register (address 0x1f8066) */
+#define SJA1105_RXPLL_CTRL1		0x8066
+#define SJA1105_RXPLL_REFDIV(x)		((x) & GENMASK(4, 0))
+
+/* TXPLL_CTRL0 register (address 0x1f806d) */
+#define SJA1105_TXPLL_CTRL0		0x806d
+#define SJA1105_TXPLL_FBDIV(x)		((x) & GENMASK(11, 0))
+
+/* TXPLL_CTRL1 register (address 0x1f806e) */
+#define SJA1105_TXPLL_CTRL1		0x806e
+#define SJA1105_TXPLL_REFDIV(x)		((x) & GENMASK(5, 0))
+
+/* RX_DATA_DETECT register (address 0x1f8045) */
+#define SJA1105_RX_DATA_DETECT		0x8045
+
+/* RX_CDR_CTLE register (address 0x1f8042) */
+#define SJA1105_RX_CDR_CTLE		0x8042
+
 #endif
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index e6c2cb68fcc4..c776a08e5e77 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -712,6 +712,7 @@ const struct sja1105_info sja1105r_info = {
 	.clocking_setup		= sja1105_clocking_setup,
 	.pcs_mdio_read		= sja1105_pcs_mdio_read,
 	.pcs_mdio_write		= sja1105_pcs_mdio_write,
+	.pcs_config		= sja1105_pcs_config,
 	.regs			= &sja1105pqrs_regs,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
@@ -748,6 +749,7 @@ const struct sja1105_info sja1105s_info = {
 	.clocking_setup		= sja1105_clocking_setup,
 	.pcs_mdio_read		= sja1105_pcs_mdio_read,
 	.pcs_mdio_write		= sja1105_pcs_mdio_write,
+	.pcs_config		= sja1105_pcs_config,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 3,
@@ -783,6 +785,7 @@ const struct sja1105_info sja1110a_info = {
 	.clocking_setup		= sja1110_clocking_setup,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
+	.pcs_config		= sja1110_pcs_config,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
@@ -830,6 +833,7 @@ const struct sja1105_info sja1110b_info = {
 	.clocking_setup		= sja1110_clocking_setup,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
+	.pcs_config		= sja1110_pcs_config,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
@@ -877,6 +881,7 @@ const struct sja1105_info sja1110c_info = {
 	.clocking_setup		= sja1110_clocking_setup,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
+	.pcs_config		= sja1110_pcs_config,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
@@ -924,6 +929,7 @@ const struct sja1105_info sja1110d_info = {
 	.clocking_setup		= sja1110_clocking_setup,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
+	.pcs_config		= sja1110_pcs_config,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
@@ -939,6 +945,8 @@ const struct sja1105_info sja1110d_info = {
 				   false, false, false, false, false, false},
 	.supports_sgmii		= {false, true, true, true, true,
 				   false, false, false, false, false, false},
+	.supports_2500basex	= {false, false, false, true, true,
+				   false, false, false, false, false, false},
 	.internal_phy		= {SJA1105_NO_PHY, SJA1105_NO_PHY,
 				   SJA1105_NO_PHY, SJA1105_NO_PHY,
 				   SJA1105_NO_PHY, SJA1105_PHY_BASE_T1,
-- 
2.25.1

