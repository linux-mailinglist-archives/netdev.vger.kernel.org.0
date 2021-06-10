Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA323A32DF
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhFJSSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:18:03 -0400
Received: from mail-ej1-f47.google.com ([209.85.218.47]:42558 "EHLO
        mail-ej1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbhFJSSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:18:02 -0400
Received: by mail-ej1-f47.google.com with SMTP id k25so586468eja.9
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xAPsmBT5K3SV3TKkdD/07FDgjglifRBjui+0oB7s3HI=;
        b=ukfOgQgaeKAxN6MKDpuofkUSZZ11K473AZ/4i5PlE16+uGwGwT7G6v4vXsiLVpMIwU
         wy4dJ4xPIU+vNrkAsQLoylsWBoHV9puBBmFhPzVUgIXmcj86ToNcqcrVRImteL0DdI3+
         QYMvOoFWTkMi8bMiCI7ZRRel/FBSoxCJmZMx0Zvh2IRInUIbNqCmCqLc96rdP9OINUVK
         8/n3Z3W0So/AwFKo2NvYkvCakoBEnhxvFmE75OsxBAwFF/aVeJG5zi+Ygg7moK9ztzCl
         NFCGHHEjA4R7/3Jgxe2hoNZcxvz5N2W3TK4KpyI/DbytguustguZMfC7/fYYnuA/sv0E
         dnfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xAPsmBT5K3SV3TKkdD/07FDgjglifRBjui+0oB7s3HI=;
        b=bCW33L+/btkk0GCOG/nh0QSiXBBsFnVRMczjGvH2lYlbn263DzRa5Cv+TenJEGLfeU
         arlI5NGn8z64uVQTA5MdOgTwoPNBf9WVQk5PbN7c4Q9M/jLphWASdhAPIFVA2kQEpjfu
         d/KtYURZboNhFStL9F6TA+bkAgfTQOuhk7m3APAstIjD2PgRXDWCXLtm3FG7idnOyZVl
         sGGEuq4Yv06k0mWYr0Bd53paMdLknWWw9coss5vp1Kh+fcsinx5Five7VChQ66OZDOee
         VckR+pc3esTqpOcjSVD9NhEh3lowuhEV9qT8Kt0emFY77Y0Yp02jjitnSU0b0DOUGIE+
         PH+Q==
X-Gm-Message-State: AOAM531OxHOGxFqsQ/MobbmUVfEF+Pw2vqbhwWjAdx9Nbw6YFjf27SL5
        +0yds1tNev40vR7Y6ohmRQs=
X-Google-Smtp-Source: ABdhPJxUW7x1nI6BMIokIsHQYaSm8eVWh7EOzEKA2j4iy1W+UdUFWyJnMAOMa0BPtQv9e9FU5p4YZg==
X-Received: by 2002:a17:906:3c56:: with SMTP id i22mr820373ejg.369.1623348888558;
        Thu, 10 Jun 2021 11:14:48 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id dh18sm1705660edb.92.2021.06.10.11.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:14:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 10/13] net: dsa: sja1105: migrate to xpcs for SGMII
Date:   Thu, 10 Jun 2021 21:14:07 +0300
Message-Id: <20210610181410.1886658-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610181410.1886658-1-olteanv@gmail.com>
References: <20210610181410.1886658-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is a desire to use the generic driver for the Synopsys XPCS
located in drivers/net/pcs, and to achieve that, the sja1105 driver must
expose an MDIO bus for the SGMII PCS, because the XPCS probes as an
mdio_device.

In preparation of the SJA1110 which in fact has a different access
procedure for the SJA1105, we register this PCS MDIO bus once in the
common code, but we implement function pointers for the read and write
methods. In this patch there is a single implementation for them.

There is exactly one MDIO bus for the PCS, this will contain all PCSes
at MDIO addresses equal to the port number.

We delete a bunch of hardware support code because the xpcs driver
already does what we need.

We need to hack up the MDIO reads for the PHY ID, since our XPCS
instantiation returns zeroes and there are some specific fixups which
need to be applied by the xpcs driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- delete sja1105_sgmii.h
- just check for priv->pcs[port] instead of checking the PHY interface
  mode each time.

 drivers/net/dsa/sja1105/Kconfig         |   1 +
 drivers/net/dsa/sja1105/sja1105.h       |   6 +
 drivers/net/dsa/sja1105/sja1105_main.c  | 171 ++++--------------------
 drivers/net/dsa/sja1105/sja1105_mdio.c  | 159 ++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_sgmii.h |  53 --------
 drivers/net/dsa/sja1105/sja1105_spi.c   |   4 +
 6 files changed, 195 insertions(+), 199 deletions(-)
 delete mode 100644 drivers/net/dsa/sja1105/sja1105_sgmii.h

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 5e83b365f17a..8383cd6d2178 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -3,6 +3,7 @@ config NET_DSA_SJA1105
 tristate "NXP SJA1105 Ethernet switch family support"
 	depends on NET_DSA && SPI
 	select NET_DSA_TAG_SJA1105
+	select PCS_XPCS
 	select PACKING
 	select CRC32
 	help
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index f762f5488a76..67d22517a5dc 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -129,6 +129,8 @@ struct sja1105_info {
 	void (*ptp_cmd_packing)(u8 *buf, struct sja1105_ptp_cmd *cmd,
 				enum packing_op op);
 	int (*clocking_setup)(struct sja1105_private *priv);
+	int (*pcs_mdio_read)(struct mii_bus *bus, int phy, int reg);
+	int (*pcs_mdio_write)(struct mii_bus *bus, int phy, int reg, u16 val);
 	const char *name;
 	bool supports_mii[SJA1105_MAX_NUM_PORTS];
 	bool supports_rmii[SJA1105_MAX_NUM_PORTS];
@@ -261,6 +263,8 @@ struct sja1105_private {
 	struct sja1105_cbs_entry *cbs;
 	struct mii_bus *mdio_base_t1;
 	struct mii_bus *mdio_base_tx;
+	struct mii_bus *mdio_pcs;
+	struct dw_xpcs *xpcs[SJA1105_MAX_NUM_PORTS];
 	struct sja1105_tagger_data tagger_data;
 	struct sja1105_ptp_data ptp_data;
 	struct sja1105_tas_data tas_data;
@@ -293,6 +297,8 @@ void sja1105_frame_memory_partitioning(struct sja1105_private *priv);
 /* From sja1105_mdio.c */
 int sja1105_mdiobus_register(struct dsa_switch *ds);
 void sja1105_mdiobus_unregister(struct dsa_switch *ds);
+int sja1105_pcs_mdio_read(struct mii_bus *bus, int phy, int reg);
+int sja1105_pcs_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val);
 
 /* From sja1105_devlink.c */
 int sja1105_devlink_setup(struct dsa_switch *ds);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 3b031864ad74..f4ed2f83a0c1 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -16,13 +16,13 @@
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
 #include <linux/of_device.h>
+#include <linux/pcs/pcs-xpcs.h>
 #include <linux/netdev_features.h>
 #include <linux/netdevice.h>
 #include <linux/if_bridge.h>
 #include <linux/if_ether.h>
 #include <linux/dsa/8021q.h>
 #include "sja1105.h"
-#include "sja1105_sgmii.h"
 #include "sja1105_tas.h"
 
 #define SJA1105_UNKNOWN_MULTICAST	0x010000000000ull
@@ -991,93 +991,6 @@ static int sja1105_parse_dt(struct sja1105_private *priv)
 	return rc;
 }
 
-static int sja1105_sgmii_read(struct sja1105_private *priv, int port, int mmd,
-			      int pcs_reg)
-{
-	u64 addr = (mmd << 16) | pcs_reg;
-	u32 val;
-	int rc;
-
-	if (port != SJA1105_SGMII_PORT)
-		return -ENODEV;
-
-	rc = sja1105_xfer_u32(priv, SPI_READ, addr, &val, NULL);
-	if (rc < 0)
-		return rc;
-
-	return val;
-}
-
-static int sja1105_sgmii_write(struct sja1105_private *priv, int port, int mmd,
-			       int pcs_reg, u16 pcs_val)
-{
-	u64 addr = (mmd << 16) | pcs_reg;
-	u32 val = pcs_val;
-	int rc;
-
-	if (port != SJA1105_SGMII_PORT)
-		return -ENODEV;
-
-	rc = sja1105_xfer_u32(priv, SPI_WRITE, addr, &val, NULL);
-	if (rc < 0)
-		return rc;
-
-	return val;
-}
-
-static void sja1105_sgmii_pcs_config(struct sja1105_private *priv, int port,
-				     bool an_enabled, bool an_master)
-{
-	u16 ac = SJA1105_AC_AUTONEG_MODE_SGMII;
-
-	/* DIGITAL_CONTROL_1: Enable vendor-specific MMD1, allow the PHY to
-	 * stop the clock during LPI mode, make the MAC reconfigure
-	 * autonomously after PCS autoneg is done, flush the internal FIFOs.
-	 */
-	sja1105_sgmii_write(priv, port, MDIO_MMD_VEND2, SJA1105_DC1,
-			    SJA1105_DC1_EN_VSMMD1 |
-			    SJA1105_DC1_CLOCK_STOP_EN |
-			    SJA1105_DC1_MAC_AUTO_SW |
-			    SJA1105_DC1_INIT);
-	/* DIGITAL_CONTROL_2: No polarity inversion for TX and RX lanes */
-	sja1105_sgmii_write(priv, port, MDIO_MMD_VEND2, SJA1105_DC2,
-			    SJA1105_DC2_TX_POL_INV_DISABLE);
-	/* AUTONEG_CONTROL: Use SGMII autoneg */
-	if (an_master)
-		ac |= SJA1105_AC_PHY_MODE | SJA1105_AC_SGMII_LINK;
-	sja1105_sgmii_write(priv, port, MDIO_MMD_VEND2, SJA1105_AC, ac);
-	/* BASIC_CONTROL: enable in-band AN now, if requested. Otherwise,
-	 * sja1105_sgmii_pcs_force_speed must be called later for the link
-	 * to become operational.
-	 */
-	if (an_enabled)
-		sja1105_sgmii_write(priv, port, MDIO_MMD_VEND2, MDIO_CTRL1,
-				    BMCR_ANENABLE | BMCR_ANRESTART);
-}
-
-static void sja1105_sgmii_pcs_force_speed(struct sja1105_private *priv,
-					  int port, int speed)
-{
-	int pcs_speed;
-
-	switch (speed) {
-	case SPEED_1000:
-		pcs_speed = BMCR_SPEED1000;
-		break;
-	case SPEED_100:
-		pcs_speed = BMCR_SPEED100;
-		break;
-	case SPEED_10:
-		pcs_speed = BMCR_SPEED10;
-		break;
-	default:
-		dev_err(priv->ds->dev, "Invalid speed %d\n", speed);
-		return;
-	}
-	sja1105_sgmii_write(priv, port, MDIO_MMD_VEND2, MDIO_CTRL1,
-			    pcs_speed | BMCR_FULLDPLX);
-}
-
 /* Convert link speed from SJA1105 to ethtool encoding */
 static int sja1105_port_speed_to_ethtool(struct sja1105_private *priv,
 					 u64 speed)
@@ -1184,10 +1097,9 @@ static void sja1105_mac_config(struct dsa_switch *ds, int port,
 			       unsigned int mode,
 			       const struct phylink_link_state *state)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct sja1105_private *priv = ds->priv;
-	bool is_sgmii;
-
-	is_sgmii = (state->interface == PHY_INTERFACE_MODE_SGMII);
+	struct dw_xpcs *xpcs;
 
 	if (sja1105_phy_mode_mismatch(priv, port, state->interface)) {
 		dev_err(ds->dev, "Changing PHY mode to %s not supported!\n",
@@ -1195,15 +1107,10 @@ static void sja1105_mac_config(struct dsa_switch *ds, int port,
 		return;
 	}
 
-	if (phylink_autoneg_inband(mode) && !is_sgmii) {
-		dev_err(ds->dev, "In-band AN not supported!\n");
-		return;
-	}
+	xpcs = priv->xpcs[port];
 
-	if (is_sgmii)
-		sja1105_sgmii_pcs_config(priv, port,
-					 phylink_autoneg_inband(mode),
-					 false);
+	if (xpcs)
+		phylink_set_pcs(dp->pl, &xpcs->pcs);
 }
 
 static void sja1105_mac_link_down(struct dsa_switch *ds, int port,
@@ -1224,10 +1131,6 @@ static void sja1105_mac_link_up(struct dsa_switch *ds, int port,
 
 	sja1105_adjust_port_config(priv, port, speed);
 
-	if (priv->phy_mode[port] == PHY_INTERFACE_MODE_SGMII &&
-	    !phylink_autoneg_inband(mode))
-		sja1105_sgmii_pcs_force_speed(priv, port, speed);
-
 	sja1105_inhibit_tx(priv, BIT(port), false);
 }
 
@@ -1272,38 +1175,6 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
-static int sja1105_mac_pcs_get_state(struct dsa_switch *ds, int port,
-				     struct phylink_link_state *state)
-{
-	struct sja1105_private *priv = ds->priv;
-	int ais;
-
-	/* Read the vendor-specific AUTONEG_INTR_STATUS register */
-	ais = sja1105_sgmii_read(priv, port, MDIO_MMD_VEND2, SJA1105_AIS);
-	if (ais < 0)
-		return ais;
-
-	switch (SJA1105_AIS_SPEED(ais)) {
-	case 0:
-		state->speed = SPEED_10;
-		break;
-	case 1:
-		state->speed = SPEED_100;
-		break;
-	case 2:
-		state->speed = SPEED_1000;
-		break;
-	default:
-		dev_err(ds->dev, "Invalid SGMII PCS speed %lu\n",
-			SJA1105_AIS_SPEED(ais));
-	}
-	state->duplex = SJA1105_AIS_DUPLEX_MODE(ais);
-	state->an_complete = SJA1105_AIS_COMPLETE(ais);
-	state->link = SJA1105_AIS_LINK_STATUS(ais);
-
-	return 0;
-}
-
 static int
 sja1105_find_static_fdb_entry(struct sja1105_private *priv, int port,
 			      const struct sja1105_l2_lookup_entry *requested)
@@ -1979,14 +1850,14 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 	 * change it through the dynamic interface later.
 	 */
 	for (i = 0; i < ds->num_ports; i++) {
+		u32 reg_addr = mdiobus_c45_addr(MDIO_MMD_VEND2, MDIO_CTRL1);
+
 		speed_mbps[i] = sja1105_port_speed_to_ethtool(priv,
 							      mac[i].speed);
 		mac[i].speed = priv->info->port_speed[SJA1105_SPEED_AUTO];
 
-		if (priv->phy_mode[i] == PHY_INTERFACE_MODE_SGMII)
-			bmcr[i] = sja1105_sgmii_read(priv, i,
-						     MDIO_MMD_VEND2,
-						     MDIO_CTRL1);
+		if (priv->xpcs[i])
+			bmcr[i] = mdiobus_read(priv->mdio_pcs, i, reg_addr);
 	}
 
 	/* No PTP operations can run right now */
@@ -2034,20 +1905,28 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		goto out;
 
 	for (i = 0; i < ds->num_ports; i++) {
-		bool an_enabled;
+		struct dw_xpcs *xpcs = priv->xpcs[i];
+		unsigned int mode;
 
 		rc = sja1105_adjust_port_config(priv, i, speed_mbps[i]);
 		if (rc < 0)
 			goto out;
 
-		if (priv->phy_mode[i] != PHY_INTERFACE_MODE_SGMII)
+		if (!xpcs)
 			continue;
 
-		an_enabled = !!(bmcr[i] & BMCR_ANENABLE);
+		if (bmcr[i] & BMCR_ANENABLE)
+			mode = MLO_AN_INBAND;
+		else if (priv->fixed_link[i])
+			mode = MLO_AN_FIXED;
+		else
+			mode = MLO_AN_PHY;
 
-		sja1105_sgmii_pcs_config(priv, i, an_enabled, false);
+		rc = xpcs_do_config(xpcs, priv->phy_mode[i], mode);
+		if (rc < 0)
+			goto out;
 
-		if (!an_enabled) {
+		if (!phylink_autoneg_inband(mode)) {
 			int speed = SPEED_UNKNOWN;
 
 			if (bmcr[i] & BMCR_SPEED1000)
@@ -2057,7 +1936,8 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 			else
 				speed = SPEED_10;
 
-			sja1105_sgmii_pcs_force_speed(priv, i, speed);
+			xpcs_link_up(&xpcs->pcs, mode, priv->phy_mode[i],
+				     speed, DUPLEX_FULL);
 		}
 	}
 
@@ -3636,7 +3516,6 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_change_mtu	= sja1105_change_mtu,
 	.port_max_mtu		= sja1105_get_max_mtu,
 	.phylink_validate	= sja1105_phylink_validate,
-	.phylink_mac_link_state	= sja1105_mac_pcs_get_state,
 	.phylink_mac_config	= sja1105_mac_config,
 	.phylink_mac_link_up	= sja1105_mac_link_up,
 	.phylink_mac_link_down	= sja1105_mac_link_down,
diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 8dfd06318b23..fc0c94ba5d3b 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -1,9 +1,61 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright 2021, NXP Semiconductors
  */
+#include <linux/pcs/pcs-xpcs.h>
 #include <linux/of_mdio.h>
 #include "sja1105.h"
 
+int sja1105_pcs_mdio_read(struct mii_bus *bus, int phy, int reg)
+{
+	struct sja1105_mdio_private *mdio_priv = bus->priv;
+	struct sja1105_private *priv = mdio_priv->priv;
+	u64 addr;
+	u32 tmp;
+	u16 mmd;
+	int rc;
+
+	if (!(reg & MII_ADDR_C45))
+		return -EINVAL;
+
+	mmd = (reg >> MII_DEVADDR_C45_SHIFT) & 0x1f;
+	addr = (mmd << 16) | (reg & GENMASK(15, 0));
+
+	if (mmd != MDIO_MMD_VEND1 && mmd != MDIO_MMD_VEND2)
+		return 0xffff;
+
+	if (mmd == MDIO_MMD_VEND2 && (reg & GENMASK(15, 0)) == MII_PHYSID1)
+		return NXP_SJA1105_XPCS_ID >> 16;
+	if (mmd == MDIO_MMD_VEND2 && (reg & GENMASK(15, 0)) == MII_PHYSID2)
+		return NXP_SJA1105_XPCS_ID & GENMASK(15, 0);
+
+	rc = sja1105_xfer_u32(priv, SPI_READ, addr, &tmp, NULL);
+	if (rc < 0)
+		return rc;
+
+	return tmp & 0xffff;
+}
+
+int sja1105_pcs_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val)
+{
+	struct sja1105_mdio_private *mdio_priv = bus->priv;
+	struct sja1105_private *priv = mdio_priv->priv;
+	u64 addr;
+	u32 tmp;
+	u16 mmd;
+
+	if (!(reg & MII_ADDR_C45))
+		return -EINVAL;
+
+	mmd = (reg >> MII_DEVADDR_C45_SHIFT) & 0x1f;
+	addr = (mmd << 16) | (reg & GENMASK(15, 0));
+	tmp = val;
+
+	if (mmd != MDIO_MMD_VEND1 && mmd != MDIO_MMD_VEND2)
+		return -EINVAL;
+
+	return sja1105_xfer_u32(priv, SPI_WRITE, addr, &tmp, NULL);
+}
+
 enum sja1105_mdio_opcode {
 	SJA1105_C45_ADDR = 0,
 	SJA1105_C22 = 1,
@@ -239,6 +291,107 @@ static void sja1105_mdiobus_base_t1_unregister(struct sja1105_private *priv)
 	priv->mdio_base_t1 = NULL;
 }
 
+static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
+{
+	struct sja1105_mdio_private *mdio_priv;
+	struct dsa_switch *ds = priv->ds;
+	struct mii_bus *bus;
+	int rc = 0;
+	int port;
+
+	if (!priv->info->pcs_mdio_read || !priv->info->pcs_mdio_write)
+		return 0;
+
+	bus = mdiobus_alloc_size(sizeof(*mdio_priv));
+	if (!bus)
+		return -ENOMEM;
+
+	bus->name = "SJA1105 PCS MDIO bus";
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-pcs",
+		 dev_name(ds->dev));
+	bus->read = priv->info->pcs_mdio_read;
+	bus->write = priv->info->pcs_mdio_write;
+	bus->parent = ds->dev;
+	/* There is no PHY on this MDIO bus => mask out all PHY addresses
+	 * from auto probing.
+	 */
+	bus->phy_mask = ~0;
+	mdio_priv = bus->priv;
+	mdio_priv->priv = priv;
+
+	rc = mdiobus_register(bus);
+	if (rc) {
+		mdiobus_free(bus);
+		return rc;
+	}
+
+	for (port = 0; port < ds->num_ports; port++) {
+		struct mdio_device *mdiodev;
+		struct dw_xpcs *xpcs;
+
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
+		if (priv->phy_mode[port] != PHY_INTERFACE_MODE_SGMII)
+			continue;
+
+		mdiodev = mdio_device_create(bus, port);
+		if (IS_ERR(mdiodev)) {
+			rc = PTR_ERR(mdiodev);
+			goto out_pcs_free;
+		}
+
+		xpcs = xpcs_create(mdiodev, priv->phy_mode[port]);
+		if (IS_ERR(xpcs)) {
+			rc = PTR_ERR(xpcs);
+			goto out_pcs_free;
+		}
+
+		priv->xpcs[port] = xpcs;
+	}
+
+	priv->mdio_pcs = bus;
+
+	return 0;
+
+out_pcs_free:
+	for (port = 0; port < ds->num_ports; port++) {
+		if (!priv->xpcs[port])
+			continue;
+
+		mdio_device_free(priv->xpcs[port]->mdiodev);
+		xpcs_destroy(priv->xpcs[port]);
+		priv->xpcs[port] = NULL;
+	}
+
+	mdiobus_unregister(bus);
+	mdiobus_free(bus);
+
+	return rc;
+}
+
+static void sja1105_mdiobus_pcs_unregister(struct sja1105_private *priv)
+{
+	struct dsa_switch *ds = priv->ds;
+	int port;
+
+	if (!priv->mdio_pcs)
+		return;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (!priv->xpcs[port])
+			continue;
+
+		mdio_device_free(priv->xpcs[port]->mdiodev);
+		xpcs_destroy(priv->xpcs[port]);
+		priv->xpcs[port] = NULL;
+	}
+
+	mdiobus_unregister(priv->mdio_pcs);
+	mdiobus_free(priv->mdio_pcs);
+	priv->mdio_pcs = NULL;
+}
+
 int sja1105_mdiobus_register(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
@@ -247,6 +400,10 @@ int sja1105_mdiobus_register(struct dsa_switch *ds)
 	struct device_node *mdio_node;
 	int rc;
 
+	rc = sja1105_mdiobus_pcs_register(priv);
+	if (rc)
+		return rc;
+
 	mdio_node = of_get_child_by_name(switch_node, "mdios");
 	if (!mdio_node)
 		return 0;
@@ -275,6 +432,7 @@ int sja1105_mdiobus_register(struct dsa_switch *ds)
 	sja1105_mdiobus_base_tx_unregister(priv);
 err_put_mdio_node:
 	of_node_put(mdio_node);
+	sja1105_mdiobus_pcs_unregister(priv);
 
 	return rc;
 }
@@ -285,4 +443,5 @@ void sja1105_mdiobus_unregister(struct dsa_switch *ds)
 
 	sja1105_mdiobus_base_t1_unregister(priv);
 	sja1105_mdiobus_base_tx_unregister(priv);
+	sja1105_mdiobus_pcs_unregister(priv);
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_sgmii.h b/drivers/net/dsa/sja1105/sja1105_sgmii.h
deleted file mode 100644
index 24d9bc046e70..000000000000
--- a/drivers/net/dsa/sja1105/sja1105_sgmii.h
+++ /dev/null
@@ -1,53 +0,0 @@
-/* SPDX-License-Identifier: BSD-3-Clause */
-/* Copyright 2020, NXP Semiconductors
- */
-#ifndef _SJA1105_SGMII_H
-#define _SJA1105_SGMII_H
-
-#define SJA1105_SGMII_PORT		4
-
-/* DIGITAL_CONTROL_1 (address 1f8000h) */
-#define SJA1105_DC1			0x8000
-#define SJA1105_DC1_VS_RESET		BIT(15)
-#define SJA1105_DC1_REMOTE_LOOPBACK	BIT(14)
-#define SJA1105_DC1_EN_VSMMD1		BIT(13)
-#define SJA1105_DC1_POWER_SAVE		BIT(11)
-#define SJA1105_DC1_CLOCK_STOP_EN	BIT(10)
-#define SJA1105_DC1_MAC_AUTO_SW		BIT(9)
-#define SJA1105_DC1_INIT		BIT(8)
-#define SJA1105_DC1_TX_DISABLE		BIT(4)
-#define SJA1105_DC1_AUTONEG_TIMER_OVRR	BIT(3)
-#define SJA1105_DC1_BYP_POWERUP		BIT(1)
-#define SJA1105_DC1_PHY_MODE_CONTROL	BIT(0)
-
-/* DIGITAL_CONTROL_2 register (address 1f80E1h) */
-#define SJA1105_DC2			0x80e1
-#define SJA1105_DC2_TX_POL_INV_DISABLE	BIT(4)
-#define SJA1105_DC2_RX_POL_INV		BIT(0)
-
-/* DIGITAL_ERROR_CNT register (address 1f80E2h) */
-#define SJA1105_DEC			0x80e2
-#define SJA1105_DEC_ICG_EC_ENA		BIT(4)
-#define SJA1105_DEC_CLEAR_ON_READ	BIT(0)
-
-/* AUTONEG_CONTROL register (address 1f8001h) */
-#define SJA1105_AC			0x8001
-#define SJA1105_AC_MII_CONTROL		BIT(8)
-#define SJA1105_AC_SGMII_LINK		BIT(4)
-#define SJA1105_AC_PHY_MODE		BIT(3)
-#define SJA1105_AC_AUTONEG_MODE(x)	(((x) << 1) & GENMASK(2, 1))
-#define SJA1105_AC_AUTONEG_MODE_SGMII	SJA1105_AC_AUTONEG_MODE(2)
-
-/* AUTONEG_INTR_STATUS register (address 1f8002h) */
-#define SJA1105_AIS			0x8002
-#define SJA1105_AIS_LINK_STATUS(x)	(!!((x) & BIT(4)))
-#define SJA1105_AIS_SPEED(x)		(((x) & GENMASK(3, 2)) >> 2)
-#define SJA1105_AIS_DUPLEX_MODE(x)	(!!((x) & BIT(1)))
-#define SJA1105_AIS_COMPLETE(x)		(!!((x) & BIT(0)))
-
-/* DEBUG_CONTROL register (address 1f8005h) */
-#define SJA1105_DC			0x8005
-#define SJA1105_DC_SUPPRESS_LOS		BIT(4)
-#define SJA1105_DC_RESTART_SYNC		BIT(0)
-
-#endif
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 54ecb5565761..8c31f82f3dd4 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -707,6 +707,8 @@ const struct sja1105_info sja1105r_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
+	.pcs_mdio_read		= sja1105_pcs_mdio_read,
+	.pcs_mdio_write		= sja1105_pcs_mdio_write,
 	.regs			= &sja1105pqrs_regs,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
@@ -741,6 +743,8 @@ const struct sja1105_info sja1105s_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
+	.pcs_mdio_read		= sja1105_pcs_mdio_read,
+	.pcs_mdio_write		= sja1105_pcs_mdio_write,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 3,
-- 
2.25.1

