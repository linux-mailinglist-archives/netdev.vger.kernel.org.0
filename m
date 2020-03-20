Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C7718CD03
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 12:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgCTL3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 07:29:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43727 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgCTL3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 07:29:52 -0400
Received: by mail-wr1-f68.google.com with SMTP id b2so6956760wrj.10
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 04:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oQzvf7z8/4o10FzPFDfWhjHKqPTMap3BnsFMRZgUyHQ=;
        b=rj34k94SKki1SEljsLP4oRImjGPrVg/2ez/029sg3SMiu3QjhyJXt6h86TD4FavQLZ
         tI/bn0XALE4DjsTdNBG5g9gH/xed4QIz9VCPF395z1xGtwYdSNXnENm0Jr8KsEupdF1s
         6yES6OIMJp0TlG7AXIScQB5LEAAACvsji/HV6Z2/2/klNqkqZHgx2jva/qcicOpNq5qu
         yA8TVu6CQJ5pjdyN68FbsOFj1HecLqkw8SDjCMvDjB4JTbgPWoPXFsquURS5GgaFd/O0
         vfOfxo5lsbfhqO04I4IFZCkSLrNk8er6GnfJcuY5C4RhSijFnzo+WhxcY8bZOnlcPx5E
         f5Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oQzvf7z8/4o10FzPFDfWhjHKqPTMap3BnsFMRZgUyHQ=;
        b=hq6nqK5aD2hA+1V3lBxGRNTNa1c5FSF4zLV6zCMsVoK1zLyzgMOxru9u7iRTMa6+R3
         M6zXe7C5RGYwRhzZ8Vo/kLDGRJZrpe8R/yvJHGOukTe2/DCQvVOGAkQ1VdcQcL2RwMuB
         UtMmAthb7+TEOdWpM8NvMEfq2wwk5C2Um0ZySi9TDA/kwdab4tDOsNXUart1x57l9LPq
         F6W6SocwYntT2NHGzJYhbmQial/QrDNz63+tzHUu2L0rTtuVmCs6rHs9wsP+WYGitLd0
         7eHeNjTbMTLOLfGcRomkjGAHSiVubKmihA91q08eOrshoftR2zcKlZdtkCP4MNFvtiWt
         FI9w==
X-Gm-Message-State: ANhLgQ31YPH12PfLxEzMFnwcenem92IYXH/JCcwsEo9bRt9eMfGNYpUy
        WhqfVXn515rfuRp499ERORfJ8giHzKojVw==
X-Google-Smtp-Source: ADFU+vtTCWCZVf7wXR5khMdRzZcqPWrf0lwSt8vdDjY0v1coCQ8423L8YLIx3nka30FM0hJxscckMw==
X-Received: by 2002:adf:e58b:: with SMTP id l11mr10355109wrm.284.1584703788548;
        Fri, 20 Mar 2020 04:29:48 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id i21sm7687375wmb.23.2020.03.20.04.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 04:29:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, linux@armlinux.org.uk
Subject: [PATCH v3 net-next] net: dsa: sja1105: Add support for the SGMII port
Date:   Fri, 20 Mar 2020 13:29:37 +0200
Message-Id: <20200320112937.27203-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

SJA1105 switches R and S have one SerDes port with an 802.3z
quasi-compatible PCS, hardwired on port 4. The other ports are still
MII/RMII/RGMII. The PCS performs rate adaptation to lower link speeds;
the MAC on this port is hardwired at gigabit. Only full duplex is
supported.

The SGMII port can be configured as part of the static config tables, as
well as through a dedicated SPI address region for its pseudo-clause-22
registers. However it looks like the static configuration is not
able to change some out-of-reset values (like the value of MII_BMCR), so
at the end of the day, having code for it is utterly pointless. We are
just going to use the pseudo-C22 interface.

Because the PCS gets reset when the switch resets, we have to add even
more restoration logic to sja1105_static_config_reload, otherwise the
SGMII port breaks after operations such as enabling PTP timestamping
which require a switch reset.

From PHYLINK perspective, the switch supports *only* SGMII (it doesn't
support 1000Base-X). It also doesn't expose access to the raw config
word for in-band AN in registers MII_ADV/MII_LPA.
It is able to work in the following modes:
 - Forced speed
 - SGMII in-band AN slave (speed received from PHY)
 - SGMII in-band AN master (acting as a PHY)

The latter mode is not supported by this patch. It is even unclear to me
how that would be described. There is some code for it left in the
patch, but 'an_master' is always passed as false.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- Separated sja1105_sgmii_config into:
  * sja1105_sgmii_pcs_config for the invariant configuration (PCS
    bring-up and optional enabling of in-band AN). This is called from
    .phylink_mac_config
  * sja1105_sgmii_pcs_force_speed, which is for non-inband modes and is
    called from .phylink_mac_link_up.
- Adapted the restoration logic to call both functions if necessary.
- Added back support for in-band AN and the .phylink_pcs_get_state
  function.
- Using the phylink_autoneg_inband helper function now.

Changes in v2:
- Moved PCS forced speed to .phylink_mac_link_up
- Removed not-fully-thought-out code for in-band AN slave

 drivers/net/dsa/sja1105/sja1105.h          |   2 +
 drivers/net/dsa/sja1105/sja1105_clocking.c |   4 +
 drivers/net/dsa/sja1105/sja1105_main.c     | 189 ++++++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_sgmii.h    |  53 ++++++
 drivers/net/dsa/sja1105/sja1105_spi.c      |   1 +
 5 files changed, 244 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_sgmii.h

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index d801fc204d19..4c40f2d51a54 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -36,6 +36,7 @@ struct sja1105_regs {
 	u64 port_control;
 	u64 rgu;
 	u64 config;
+	u64 sgmii;
 	u64 rmii_pll1;
 	u64 ptp_control;
 	u64 ptpclkval;
@@ -159,6 +160,7 @@ typedef enum {
 	XMII_MODE_MII		= 0,
 	XMII_MODE_RMII		= 1,
 	XMII_MODE_RGMII		= 2,
+	XMII_MODE_SGMII		= 3,
 } sja1105_phy_interface_t;
 
 typedef enum {
diff --git a/drivers/net/dsa/sja1105/sja1105_clocking.c b/drivers/net/dsa/sja1105/sja1105_clocking.c
index 9082e52b55e9..0fdc2d55fff6 100644
--- a/drivers/net/dsa/sja1105/sja1105_clocking.c
+++ b/drivers/net/dsa/sja1105/sja1105_clocking.c
@@ -660,6 +660,10 @@ int sja1105_clocking_setup_port(struct sja1105_private *priv, int port)
 	case XMII_MODE_RGMII:
 		rc = sja1105_rgmii_clocking_setup(priv, port, role);
 		break;
+	case XMII_MODE_SGMII:
+		/* Nothing to do in the CGU for SGMII */
+		rc = 0;
+		break;
 	default:
 		dev_err(dev, "Invalid interface mode specified: %d\n",
 			phy_mode);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index edf57ea07083..afafe2ecf248 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -22,6 +22,7 @@
 #include <linux/if_ether.h>
 #include <linux/dsa/8021q.h>
 #include "sja1105.h"
+#include "sja1105_sgmii.h"
 #include "sja1105_tas.h"
 
 static void sja1105_hw_reset(struct gpio_desc *gpio, unsigned int pulse_len,
@@ -135,6 +136,21 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 	return 0;
 }
 
+static bool sja1105_supports_sgmii(struct sja1105_private *priv, int port)
+{
+	if (priv->info->part_no != SJA1105R_PART_NO &&
+	    priv->info->part_no != SJA1105S_PART_NO)
+		return false;
+
+	if (port != SJA1105_SGMII_PORT)
+		return false;
+
+	if (dsa_is_unused_port(priv->ds, port))
+		return false;
+
+	return true;
+}
+
 static int sja1105_init_mii_settings(struct sja1105_private *priv,
 				     struct sja1105_dt_port *ports)
 {
@@ -178,12 +194,24 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 		case PHY_INTERFACE_MODE_RGMII_TXID:
 			mii->xmii_mode[i] = XMII_MODE_RGMII;
 			break;
+		case PHY_INTERFACE_MODE_SGMII:
+			if (!sja1105_supports_sgmii(priv, i))
+				return -EINVAL;
+			mii->xmii_mode[i] = XMII_MODE_SGMII;
+			break;
 		default:
 			dev_err(dev, "Unsupported PHY mode %s!\n",
 				phy_modes(ports[i].phy_mode));
 		}
 
-		mii->phy_mac[i] = ports[i].role;
+		/* Even though the SerDes port is able to drive SGMII autoneg
+		 * like a PHY would, from the perspective of the XMII tables,
+		 * the SGMII port should always be put in MAC mode.
+		 */
+		if (ports[i].phy_mode == PHY_INTERFACE_MODE_SGMII)
+			mii->phy_mac[i] = XMII_MAC;
+		else
+			mii->phy_mac[i] = ports[i].role;
 	}
 	return 0;
 }
@@ -650,6 +678,85 @@ static int sja1105_parse_dt(struct sja1105_private *priv,
 	return rc;
 }
 
+static int sja1105_sgmii_read(struct sja1105_private *priv, int pcs_reg)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	u32 val;
+	int rc;
+
+	rc = sja1105_xfer_u32(priv, SPI_READ, regs->sgmii + pcs_reg, &val,
+			      NULL);
+	if (rc < 0)
+		return rc;
+
+	return val;
+}
+
+static int sja1105_sgmii_write(struct sja1105_private *priv, int pcs_reg,
+			       u16 pcs_val)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	u32 val = pcs_val;
+	int rc;
+
+	rc = sja1105_xfer_u32(priv, SPI_WRITE, regs->sgmii + pcs_reg, &val,
+			      NULL);
+	if (rc < 0)
+		return rc;
+
+	return val;
+}
+
+static void sja1105_sgmii_pcs_config(struct sja1105_private *priv,
+				     bool an_enabled, bool an_master)
+{
+	u16 ac = SJA1105_AC_AUTONEG_MODE_SGMII;
+
+	/* DIGITAL_CONTROL_1: Enable vendor-specific MMD1, allow the PHY to
+	 * stop the clock during LPI mode, make the MAC reconfigure
+	 * autonomously after PCS autoneg is done, flush the internal FIFOs.
+	 */
+	sja1105_sgmii_write(priv, SJA1105_DC1, SJA1105_DC1_EN_VSMMD1 |
+					       SJA1105_DC1_CLOCK_STOP_EN |
+					       SJA1105_DC1_MAC_AUTO_SW |
+					       SJA1105_DC1_INIT);
+	/* DIGITAL_CONTROL_2: No polarity inversion for TX and RX lanes */
+	sja1105_sgmii_write(priv, SJA1105_DC2, SJA1105_DC2_TX_POL_INV_DISABLE);
+	/* AUTONEG_CONTROL: Use SGMII autoneg */
+	if (an_master)
+		ac |= SJA1105_AC_PHY_MODE | SJA1105_AC_SGMII_LINK;
+	sja1105_sgmii_write(priv, SJA1105_AC, ac);
+	/* BASIC_CONTROL: enable in-band AN now, if requested. Otherwise,
+	 * sja1105_sgmii_pcs_force_speed must be called later for the link
+	 * to become operational.
+	 */
+	if (an_enabled)
+		sja1105_sgmii_write(priv, MII_BMCR,
+				    BMCR_ANENABLE | BMCR_ANRESTART);
+}
+
+static void sja1105_sgmii_pcs_force_speed(struct sja1105_private *priv,
+					  int speed)
+{
+	int pcs_speed;
+
+	switch (speed) {
+	case SPEED_1000:
+		pcs_speed = BMCR_SPEED1000;
+		break;
+	case SPEED_100:
+		pcs_speed = BMCR_SPEED100;
+		break;
+	case SPEED_10:
+		pcs_speed = BMCR_SPEED10;
+		break;
+	default:
+		dev_err(priv->ds->dev, "Invalid speed %d\n", speed);
+		return;
+	}
+	sja1105_sgmii_write(priv, MII_BMCR, pcs_speed | BMCR_FULLDPLX);
+}
+
 /* Convert link speed from SJA1105 to ethtool encoding */
 static int sja1105_speed[] = {
 	[SJA1105_SPEED_AUTO]		= SPEED_UNKNOWN,
@@ -707,8 +814,13 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	 * table, since this will be used for the clocking setup, and we no
 	 * longer need to store it in the static config (already told hardware
 	 * we want auto during upload phase).
+	 * Actually for the SGMII port, the MAC is fixed at 1 Gbps and
+	 * we need to configure the PCS only (if even that).
 	 */
-	mac[port].speed = speed;
+	if (sja1105_supports_sgmii(priv, port))
+		mac[port].speed = SJA1105_SPEED_1000MBPS;
+	else
+		mac[port].speed = speed;
 
 	/* Write to the dynamic reconfiguration tables */
 	rc = sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG, port,
@@ -757,16 +869,19 @@ static bool sja1105_phy_mode_mismatch(struct sja1105_private *priv, int port,
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 		return (phy_mode != XMII_MODE_RGMII);
+	case PHY_INTERFACE_MODE_SGMII:
+		return (phy_mode != XMII_MODE_SGMII);
 	default:
 		return true;
 	}
 }
 
 static void sja1105_mac_config(struct dsa_switch *ds, int port,
-			       unsigned int link_an_mode,
+			       unsigned int mode,
 			       const struct phylink_link_state *state)
 {
 	struct sja1105_private *priv = ds->priv;
+	bool is_sgmii = sja1105_supports_sgmii(priv, port);
 
 	if (sja1105_phy_mode_mismatch(priv, port, state->interface)) {
 		dev_err(ds->dev, "Changing PHY mode to %s not supported!\n",
@@ -774,10 +889,14 @@ static void sja1105_mac_config(struct dsa_switch *ds, int port,
 		return;
 	}
 
-	if (link_an_mode == MLO_AN_INBAND) {
+	if (phylink_autoneg_inband(mode) && !is_sgmii) {
 		dev_err(ds->dev, "In-band AN not supported!\n");
 		return;
 	}
+
+	if (is_sgmii)
+		sja1105_sgmii_pcs_config(priv, phylink_autoneg_inband(mode),
+					 false);
 }
 
 static void sja1105_mac_link_down(struct dsa_switch *ds, int port,
@@ -798,6 +917,9 @@ static void sja1105_mac_link_up(struct dsa_switch *ds, int port,
 
 	sja1105_adjust_port_config(priv, port, speed);
 
+	if (sja1105_supports_sgmii(priv, port) && !phylink_autoneg_inband(mode))
+		sja1105_sgmii_pcs_force_speed(priv, speed);
+
 	sja1105_inhibit_tx(priv, BIT(port), false);
 }
 
@@ -833,7 +955,8 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 	phylink_set(mask, 10baseT_Full);
 	phylink_set(mask, 100baseT_Full);
 	phylink_set(mask, 100baseT1_Full);
-	if (mii->xmii_mode[port] == XMII_MODE_RGMII)
+	if (mii->xmii_mode[port] == XMII_MODE_RGMII ||
+	    mii->xmii_mode[port] == XMII_MODE_SGMII)
 		phylink_set(mask, 1000baseT_Full);
 
 	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
@@ -841,6 +964,38 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
+static int sja1105_mac_pcs_get_state(struct dsa_switch *ds, int port,
+				     struct phylink_link_state *state)
+{
+	struct sja1105_private *priv = ds->priv;
+	int ais;
+
+	/* Read the vendor-specific AUTONEG_INTR_STATUS register */
+	ais = sja1105_sgmii_read(priv, SJA1105_AIS);
+	if (ais < 0)
+		return ais;
+
+	switch (SJA1105_AIS_SPEED(ais)) {
+	case 0:
+		state->speed = SPEED_10;
+		break;
+	case 1:
+		state->speed = SPEED_100;
+		break;
+	case 2:
+		state->speed = SPEED_1000;
+		break;
+	default:
+		dev_err(ds->dev, "Invalid SGMII PCS speed %lu\n",
+			SJA1105_AIS_SPEED(ais));
+	}
+	state->duplex = SJA1105_AIS_DUPLEX_MODE(ais);
+	state->an_complete = SJA1105_AIS_COMPLETE(ais);
+	state->link = SJA1105_AIS_LINK_STATUS(ais);
+
+	return 0;
+}
+
 static int
 sja1105_find_static_fdb_entry(struct sja1105_private *priv, int port,
 			      const struct sja1105_l2_lookup_entry *requested)
@@ -1367,6 +1522,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 	struct dsa_switch *ds = priv->ds;
 	s64 t1, t2, t3, t4;
 	s64 t12, t34;
+	u16 bmcr = 0;
 	int rc, i;
 	s64 now;
 
@@ -1384,6 +1540,9 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		mac[i].speed = SJA1105_SPEED_AUTO;
 	}
 
+	if (sja1105_supports_sgmii(priv, SJA1105_SGMII_PORT))
+		bmcr = sja1105_sgmii_read(priv, MII_BMCR);
+
 	/* No PTP operations can run right now */
 	mutex_lock(&priv->ptp_data.lock);
 
@@ -1433,6 +1592,25 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		if (rc < 0)
 			goto out;
 	}
+
+	if (sja1105_supports_sgmii(priv, SJA1105_SGMII_PORT)) {
+		bool an_enabled = !!(bmcr & BMCR_ANENABLE);
+
+		sja1105_sgmii_pcs_config(priv, an_enabled, false);
+
+		if (!an_enabled) {
+			int speed = SPEED_UNKNOWN;
+
+			if (bmcr & BMCR_SPEED1000)
+				speed = SPEED_1000;
+			else if (bmcr & BMCR_SPEED100)
+				speed = SPEED_100;
+			else if (bmcr & BMCR_SPEED10)
+				speed = SPEED_10;
+
+			sja1105_sgmii_pcs_force_speed(priv, speed);
+		}
+	}
 out:
 	mutex_unlock(&priv->mgmt_lock);
 
@@ -1998,6 +2176,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.teardown		= sja1105_teardown,
 	.set_ageing_time	= sja1105_set_ageing_time,
 	.phylink_validate	= sja1105_phylink_validate,
+	.phylink_mac_link_state	= sja1105_mac_pcs_get_state,
 	.phylink_mac_config	= sja1105_mac_config,
 	.phylink_mac_link_up	= sja1105_mac_link_up,
 	.phylink_mac_link_down	= sja1105_mac_link_down,
diff --git a/drivers/net/dsa/sja1105/sja1105_sgmii.h b/drivers/net/dsa/sja1105/sja1105_sgmii.h
new file mode 100644
index 000000000000..24d9bc046e70
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_sgmii.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: BSD-3-Clause */
+/* Copyright 2020, NXP Semiconductors
+ */
+#ifndef _SJA1105_SGMII_H
+#define _SJA1105_SGMII_H
+
+#define SJA1105_SGMII_PORT		4
+
+/* DIGITAL_CONTROL_1 (address 1f8000h) */
+#define SJA1105_DC1			0x8000
+#define SJA1105_DC1_VS_RESET		BIT(15)
+#define SJA1105_DC1_REMOTE_LOOPBACK	BIT(14)
+#define SJA1105_DC1_EN_VSMMD1		BIT(13)
+#define SJA1105_DC1_POWER_SAVE		BIT(11)
+#define SJA1105_DC1_CLOCK_STOP_EN	BIT(10)
+#define SJA1105_DC1_MAC_AUTO_SW		BIT(9)
+#define SJA1105_DC1_INIT		BIT(8)
+#define SJA1105_DC1_TX_DISABLE		BIT(4)
+#define SJA1105_DC1_AUTONEG_TIMER_OVRR	BIT(3)
+#define SJA1105_DC1_BYP_POWERUP		BIT(1)
+#define SJA1105_DC1_PHY_MODE_CONTROL	BIT(0)
+
+/* DIGITAL_CONTROL_2 register (address 1f80E1h) */
+#define SJA1105_DC2			0x80e1
+#define SJA1105_DC2_TX_POL_INV_DISABLE	BIT(4)
+#define SJA1105_DC2_RX_POL_INV		BIT(0)
+
+/* DIGITAL_ERROR_CNT register (address 1f80E2h) */
+#define SJA1105_DEC			0x80e2
+#define SJA1105_DEC_ICG_EC_ENA		BIT(4)
+#define SJA1105_DEC_CLEAR_ON_READ	BIT(0)
+
+/* AUTONEG_CONTROL register (address 1f8001h) */
+#define SJA1105_AC			0x8001
+#define SJA1105_AC_MII_CONTROL		BIT(8)
+#define SJA1105_AC_SGMII_LINK		BIT(4)
+#define SJA1105_AC_PHY_MODE		BIT(3)
+#define SJA1105_AC_AUTONEG_MODE(x)	(((x) << 1) & GENMASK(2, 1))
+#define SJA1105_AC_AUTONEG_MODE_SGMII	SJA1105_AC_AUTONEG_MODE(2)
+
+/* AUTONEG_INTR_STATUS register (address 1f8002h) */
+#define SJA1105_AIS			0x8002
+#define SJA1105_AIS_LINK_STATUS(x)	(!!((x) & BIT(4)))
+#define SJA1105_AIS_SPEED(x)		(((x) & GENMASK(3, 2)) >> 2)
+#define SJA1105_AIS_DUPLEX_MODE(x)	(!!((x) & BIT(1)))
+#define SJA1105_AIS_COMPLETE(x)		(!!((x) & BIT(0)))
+
+/* DEBUG_CONTROL register (address 1f8005h) */
+#define SJA1105_DC			0x8005
+#define SJA1105_DC_SUPPRESS_LOS		BIT(4)
+#define SJA1105_DC_RESTART_SYNC		BIT(0)
+
+#endif
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 29b127f3bf9c..45da162ba268 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -474,6 +474,7 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	/* UM10944.pdf, Table 86, ACU Register overview */
 	.pad_mii_tx = {0x100800, 0x100802, 0x100804, 0x100806, 0x100808},
 	.pad_mii_id = {0x100810, 0x100811, 0x100812, 0x100813, 0x100814},
+	.sgmii = 0x1F0000,
 	.rmii_pll1 = 0x10000A,
 	.cgu_idiv = {0x10000B, 0x10000C, 0x10000D, 0x10000E, 0x10000F},
 	.mac = {0x200, 0x202, 0x204, 0x206, 0x208},
-- 
2.17.1

