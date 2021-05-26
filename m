Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83434391949
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 15:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbhEZN5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 09:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234370AbhEZN5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 09:57:31 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C247C061760
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:55:59 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id i13so1599877edb.9
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mAPLcBwuCd3g055IKmI9GM/8O52Y4WnH2h3TnK9JHnk=;
        b=n3X7pDsfWyXBNmxgt9BO+V8nnmON/Sk6NQjORCQ8LlIY1Zy0+LB2KS1Xo+eujKQDIy
         paI5sw4TWtRMXaZEb4TiyGEVDcMhPMHiaaspiCzWiNul+q8Wl6/TaAlqOcIknFEzeWwQ
         XmHOtOG4NweqM1RMYM2cVmt7JAuc1G335e1fEXkBXXFHto9GNJOHW5/VchzpL/XZrlDe
         /iTHLZt7Nr5jqMYK/N6NhFK3TArtHmI1GlB6moOgq/j5RFrucHheqkCEgB0UMKVcJZrf
         zeANLUFHfrrHuq82ry0gMFGKiliq/ZkxXP1z2ekHWm6QA70O0SY6guuej7WFocNYxO2b
         uNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mAPLcBwuCd3g055IKmI9GM/8O52Y4WnH2h3TnK9JHnk=;
        b=iRJ9FBVdMgZ7g+KiEpFogkMzOBj98bDRfDXya3tqRCPapKdA27ke97X5s1f7C6iObH
         TUdziRhe8oStNskWkmX9BjFfYQjUBrV0rKp7ckD0WEYP06AuP5Xn0xsrBAnVHDYP/yCP
         jhY/asgV6TqlQbK2yC/JfOfK3aYHqgUPegRP4nvGIlJ7tJ4KbKpowjPxpBnIPsqOCAWt
         rqFpiK1PrtB4yk9y6Bwbuq+Y+Ps2MQGeIXo9W9s226bxHyOTBJkRuDxDmgeeIv+euycg
         WOx+FIdCpoMoR0zXTSusao2emzkANxmoJzD3gk1cgkPTxqsy1fIwR2G1H6g1EuCMWsx8
         fxGw==
X-Gm-Message-State: AOAM530z0wvHVA/AaKKAmG98lV3YoaFgmzeMtIGJNjcmOB1kFKtrh4E+
        PoHf0YYzSPgfaAWdp5M6mAg=
X-Google-Smtp-Source: ABdhPJzS5bxUln5jC92P6vjMmyEDzMw+pJwvfCU306QY+yl4QEeWCQp6nnEnQarHZZQYop6q/5loag==
X-Received: by 2002:aa7:d758:: with SMTP id a24mr37660190eds.220.1622037357752;
        Wed, 26 May 2021 06:55:57 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id k11sm10508476ejc.94.2021.05.26.06.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 06:55:57 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH v2 linux-next 06/14] net: dsa: sja1105: add a translation table for port speeds
Date:   Wed, 26 May 2021 16:55:27 +0300
Message-Id: <20210526135535.2515123-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support the new speed of 2500Mbps, the SJA1110 has achieved
the great performance of changing the encoding in the MAC Configuration
Table for the port speeds of 10, 100, 1000 compared to SJA1105.

Because this is a common driver, we need a layer of indirection in order
to program the hardware with the right values irrespective of switch
generation.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/dsa/sja1105/sja1105.h          | 17 +++++----
 drivers/net/dsa/sja1105/sja1105_clocking.c | 22 +++++-------
 drivers/net/dsa/sja1105/sja1105_main.c     | 38 ++++++++++++--------
 drivers/net/dsa/sja1105/sja1105_spi.c      | 42 ++++++++++++++++++++++
 4 files changed, 84 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index a27841642693..867cda832e77 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -72,6 +72,15 @@ struct sja1105_regs {
 	u64 stats[__MAX_SJA1105_STATS_AREA][SJA1105_MAX_NUM_PORTS];
 };
 
+enum {
+	SJA1105_SPEED_AUTO,
+	SJA1105_SPEED_10MBPS,
+	SJA1105_SPEED_100MBPS,
+	SJA1105_SPEED_1000MBPS,
+	SJA1105_SPEED_2500MBPS,
+	SJA1105_SPEED_MAX,
+};
+
 struct sja1105_info {
 	u64 device_id;
 	/* Needed for distinction between P and R, and between Q and S
@@ -116,6 +125,7 @@ struct sja1105_info {
 	bool supports_rgmii[SJA1105_MAX_NUM_PORTS];
 	bool supports_sgmii[SJA1105_MAX_NUM_PORTS];
 	bool supports_2500basex[SJA1105_MAX_NUM_PORTS];
+	const u64 port_speed[SJA1105_SPEED_MAX];
 };
 
 enum sja1105_key_type {
@@ -314,13 +324,6 @@ typedef enum {
 	XMII_MODE_SGMII		= 3,
 } sja1105_phy_interface_t;
 
-typedef enum {
-	SJA1105_SPEED_10MBPS	= 3,
-	SJA1105_SPEED_100MBPS	= 2,
-	SJA1105_SPEED_1000MBPS	= 1,
-	SJA1105_SPEED_AUTO	= 0,
-} sja1105_speed_t;
-
 int sja1105pqrs_setup_rgmii_delay(const void *ctx, int port);
 int sja1105_clocking_setup_port(struct sja1105_private *priv, int port);
 int sja1105_clocking_setup(struct sja1105_private *priv);
diff --git a/drivers/net/dsa/sja1105/sja1105_clocking.c b/drivers/net/dsa/sja1105/sja1105_clocking.c
index 4697ac064abc..03173397d950 100644
--- a/drivers/net/dsa/sja1105/sja1105_clocking.c
+++ b/drivers/net/dsa/sja1105/sja1105_clocking.c
@@ -328,7 +328,7 @@ sja1105_cgu_pll_control_packing(void *buf, struct sja1105_cgu_pll_ctrl *cmd,
 }
 
 static int sja1105_cgu_rgmii_tx_clk_config(struct sja1105_private *priv,
-					   int port, sja1105_speed_t speed)
+					   int port, u64 speed)
 {
 	const struct sja1105_regs *regs = priv->info->regs;
 	struct sja1105_cgu_mii_ctrl txc;
@@ -338,7 +338,7 @@ static int sja1105_cgu_rgmii_tx_clk_config(struct sja1105_private *priv,
 	if (regs->rgmii_tx_clk[port] == SJA1105_RSV_ADDR)
 		return 0;
 
-	if (speed == SJA1105_SPEED_1000MBPS) {
+	if (speed == priv->info->port_speed[SJA1105_SPEED_1000MBPS]) {
 		clksrc = CLKSRC_PLL0;
 	} else {
 		int clk_sources[] = {CLKSRC_IDIV0, CLKSRC_IDIV1, CLKSRC_IDIV2,
@@ -524,35 +524,31 @@ static int sja1105_rgmii_clocking_setup(struct sja1105_private *priv, int port,
 {
 	struct device *dev = priv->ds->dev;
 	struct sja1105_mac_config_entry *mac;
-	sja1105_speed_t speed;
+	u64 speed;
 	int rc;
 
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 	speed = mac[port].speed;
 
-	dev_dbg(dev, "Configuring port %d RGMII at speed %dMbps\n",
+	dev_dbg(dev, "Configuring port %d RGMII at speed %lldMbps\n",
 		port, speed);
 
-	switch (speed) {
-	case SJA1105_SPEED_1000MBPS:
+	if (speed == priv->info->port_speed[SJA1105_SPEED_1000MBPS]) {
 		/* 1000Mbps, IDIV disabled (125 MHz) */
 		rc = sja1105_cgu_idiv_config(priv, port, false, 1);
-		break;
-	case SJA1105_SPEED_100MBPS:
+	} else if (speed == priv->info->port_speed[SJA1105_SPEED_100MBPS]) {
 		/* 100Mbps, IDIV enabled, divide by 1 (25 MHz) */
 		rc = sja1105_cgu_idiv_config(priv, port, true, 1);
-		break;
-	case SJA1105_SPEED_10MBPS:
+	} else if (speed == priv->info->port_speed[SJA1105_SPEED_10MBPS]) {
 		/* 10Mbps, IDIV enabled, divide by 10 (2.5 MHz) */
 		rc = sja1105_cgu_idiv_config(priv, port, true, 10);
-		break;
-	case SJA1105_SPEED_AUTO:
+	} else if (speed == priv->info->port_speed[SJA1105_SPEED_AUTO]) {
 		/* Skip CGU configuration if there is no speed available
 		 * (e.g. link is not established yet)
 		 */
 		dev_dbg(dev, "Speed not available, skipping CGU config\n");
 		return 0;
-	default:
+	} else {
 		rc = -EINVAL;
 	}
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 8a07373e3cf3..d3aa14d3a5c6 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -80,7 +80,7 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 		/* Always put the MAC speed in automatic mode, where it can be
 		 * adjusted at runtime by PHYLINK.
 		 */
-		.speed = SJA1105_SPEED_AUTO,
+		.speed = priv->info->port_speed[SJA1105_SPEED_AUTO],
 		/* No static correction for 1-step 1588 events */
 		.tp_delin = 0,
 		.tp_delout = 0,
@@ -990,12 +990,19 @@ static void sja1105_sgmii_pcs_force_speed(struct sja1105_private *priv,
 }
 
 /* Convert link speed from SJA1105 to ethtool encoding */
-static int sja1105_speed[] = {
-	[SJA1105_SPEED_AUTO]		= SPEED_UNKNOWN,
-	[SJA1105_SPEED_10MBPS]		= SPEED_10,
-	[SJA1105_SPEED_100MBPS]		= SPEED_100,
-	[SJA1105_SPEED_1000MBPS]	= SPEED_1000,
-};
+static int sja1105_port_speed_to_ethtool(struct sja1105_private *priv,
+					 u64 speed)
+{
+	if (speed == priv->info->port_speed[SJA1105_SPEED_10MBPS])
+		return SPEED_10;
+	if (speed == priv->info->port_speed[SJA1105_SPEED_100MBPS])
+		return SPEED_100;
+	if (speed == priv->info->port_speed[SJA1105_SPEED_1000MBPS])
+		return SPEED_1000;
+	if (speed == priv->info->port_speed[SJA1105_SPEED_2500MBPS])
+		return SPEED_2500;
+	return SPEED_UNKNOWN;
+}
 
 /* Set link speed in the MAC configuration for a specific port. */
 static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
@@ -1003,7 +1010,7 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 {
 	struct sja1105_mac_config_entry *mac;
 	struct device *dev = priv->ds->dev;
-	sja1105_speed_t speed;
+	u64 speed;
 	int rc;
 
 	/* On P/Q/R/S, one can read from the device via the MAC reconfiguration
@@ -1023,16 +1030,16 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 		 * ok for power consumption in case AN will never complete -
 		 * otherwise PHYLINK should come back with a new update.
 		 */
-		speed = SJA1105_SPEED_AUTO;
+		speed = priv->info->port_speed[SJA1105_SPEED_AUTO];
 		break;
 	case SPEED_10:
-		speed = SJA1105_SPEED_10MBPS;
+		speed = priv->info->port_speed[SJA1105_SPEED_10MBPS];
 		break;
 	case SPEED_100:
-		speed = SJA1105_SPEED_100MBPS;
+		speed = priv->info->port_speed[SJA1105_SPEED_100MBPS];
 		break;
 	case SPEED_1000:
-		speed = SJA1105_SPEED_1000MBPS;
+		speed = priv->info->port_speed[SJA1105_SPEED_1000MBPS];
 		break;
 	default:
 		dev_err(dev, "Invalid speed %iMbps\n", speed_mbps);
@@ -1047,7 +1054,7 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	 * we need to configure the PCS only (if even that).
 	 */
 	if (priv->phy_mode[port] == PHY_INTERFACE_MODE_SGMII)
-		mac[port].speed = SJA1105_SPEED_1000MBPS;
+		mac[port].speed = priv->info->port_speed[SJA1105_SPEED_1000MBPS];
 	else
 		mac[port].speed = speed;
 
@@ -1883,8 +1890,9 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 	 * change it through the dynamic interface later.
 	 */
 	for (i = 0; i < ds->num_ports; i++) {
-		speed_mbps[i] = sja1105_speed[mac[i].speed];
-		mac[i].speed = SJA1105_SPEED_AUTO;
+		speed_mbps[i] = sja1105_port_speed_to_ethtool(priv,
+							      mac[i].speed);
+		mac[i].speed = priv->info->port_speed[SJA1105_SPEED_AUTO];
 
 		if (priv->phy_mode[i] == PHY_INTERFACE_MODE_SGMII)
 			bmcr[i] = sja1105_sgmii_read(priv, i,
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 565b594efa7d..786c16a77e46 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -482,6 +482,13 @@ const struct sja1105_info sja1105e_info = {
 	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105et_regs,
+	.port_speed		= {
+		[SJA1105_SPEED_AUTO] = 0,
+		[SJA1105_SPEED_10MBPS] = 3,
+		[SJA1105_SPEED_100MBPS] = 2,
+		[SJA1105_SPEED_1000MBPS] = 1,
+		[SJA1105_SPEED_2500MBPS] = 0, /* Not supported */
+	},
 	.supports_mii		= {true, true, true, true, true},
 	.supports_rmii		= {true, true, true, true, true},
 	.supports_rgmii		= {true, true, true, true, true},
@@ -505,6 +512,13 @@ const struct sja1105_info sja1105t_info = {
 	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105et_regs,
+	.port_speed		= {
+		[SJA1105_SPEED_AUTO] = 0,
+		[SJA1105_SPEED_10MBPS] = 3,
+		[SJA1105_SPEED_100MBPS] = 2,
+		[SJA1105_SPEED_1000MBPS] = 1,
+		[SJA1105_SPEED_2500MBPS] = 0, /* Not supported */
+	},
 	.supports_mii		= {true, true, true, true, true},
 	.supports_rmii		= {true, true, true, true, true},
 	.supports_rgmii		= {true, true, true, true, true},
@@ -529,6 +543,13 @@ const struct sja1105_info sja1105p_info = {
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
+	.port_speed		= {
+		[SJA1105_SPEED_AUTO] = 0,
+		[SJA1105_SPEED_10MBPS] = 3,
+		[SJA1105_SPEED_100MBPS] = 2,
+		[SJA1105_SPEED_1000MBPS] = 1,
+		[SJA1105_SPEED_2500MBPS] = 0, /* Not supported */
+	},
 	.supports_mii		= {true, true, true, true, true},
 	.supports_rmii		= {true, true, true, true, true},
 	.supports_rgmii		= {true, true, true, true, true},
@@ -553,6 +574,13 @@ const struct sja1105_info sja1105q_info = {
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
+	.port_speed		= {
+		[SJA1105_SPEED_AUTO] = 0,
+		[SJA1105_SPEED_10MBPS] = 3,
+		[SJA1105_SPEED_100MBPS] = 2,
+		[SJA1105_SPEED_1000MBPS] = 1,
+		[SJA1105_SPEED_2500MBPS] = 0, /* Not supported */
+	},
 	.supports_mii		= {true, true, true, true, true},
 	.supports_rmii		= {true, true, true, true, true},
 	.supports_rgmii		= {true, true, true, true, true},
@@ -577,6 +605,13 @@ const struct sja1105_info sja1105r_info = {
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
+	.port_speed		= {
+		[SJA1105_SPEED_AUTO] = 0,
+		[SJA1105_SPEED_10MBPS] = 3,
+		[SJA1105_SPEED_100MBPS] = 2,
+		[SJA1105_SPEED_1000MBPS] = 1,
+		[SJA1105_SPEED_2500MBPS] = 0, /* Not supported */
+	},
 	.supports_mii		= {true, true, true, true, true},
 	.supports_rmii		= {true, true, true, true, true},
 	.supports_rgmii		= {true, true, true, true, true},
@@ -602,6 +637,13 @@ const struct sja1105_info sja1105s_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
+	.port_speed		= {
+		[SJA1105_SPEED_AUTO] = 0,
+		[SJA1105_SPEED_10MBPS] = 3,
+		[SJA1105_SPEED_100MBPS] = 2,
+		[SJA1105_SPEED_1000MBPS] = 1,
+		[SJA1105_SPEED_2500MBPS] = 0, /* Not supported */
+	},
 	.supports_mii		= {true, true, true, true, true},
 	.supports_rmii		= {true, true, true, true, true},
 	.supports_rgmii		= {true, true, true, true, true},
-- 
2.25.1

