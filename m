Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E705718C46A
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 01:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgCTAyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 20:54:37 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54395 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgCTAyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 20:54:36 -0400
Received: by mail-wm1-f67.google.com with SMTP id f130so3646785wmf.4
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 17:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BANXbYZzchIGsMhwGZ+1jsVFtGQoFJ9awOXzNR6/PzI=;
        b=NEYkeP1JIm6v8oW1FSeufikx4FKesIgFdDxkRswQ6mNRP4C8X+aMcFeUGhkmg9M0QD
         WoZ6b9G8HKsN+L4bRY+Gta7AiUVoU03Uh0D/mpigSyWD8Ihu2GSv13pbh/A8JYGCx4pb
         I8rpTgtMuh3jvAVk3vYaekFvelhJzOAHAVQ/g64WrIHv1DXOCWuiPNaqX+yR+KCzU9ko
         I36xEi5JB1ZDx/a1JINgBqCIUaHKwqhkI07K4CJSr0d/+zDJ1SUrHw43XG6qTaDu4Z55
         VAlZzwt2HbNVePTvvyzLQdmwmxk/05S9V8zn37QxTBHuRs4d+RDw/AU3RJFgApl1asMz
         nBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BANXbYZzchIGsMhwGZ+1jsVFtGQoFJ9awOXzNR6/PzI=;
        b=NoLS1oMNr9jIdNRls/jdQnk3kvm5H5Mo+nmmhpqwF8Q7ou/rwcBQN6ThaB3MCXoAuZ
         wIrkqBcl36NIvIziM5hd5/gAwR7+1HDbRPO7sXkdck5HvC0QiEk7cOCMOsXZh6H1JS1d
         QB8XDTZLOiN4b7LeZ2OBY6TDbrwG+EM2qj3X2mA5xdPODM00DMyC9WMNi/GDxqfzO4PE
         XLt6AKBxe52FM9zlstiH380jM8boOGqSliQIsBeedLDu2e7uUrObGoP3hVvGezwssHqW
         t3DioRZIbwnLA7h8MDuKYZDAN12U3Wqic7stoi8paAaa/G9YLUj+/Uwmz0aIQt/Doeqr
         nQgg==
X-Gm-Message-State: ANhLgQ2/scEHria7XXfluMfTnkQ9siHfMMddXuM9yTWKKZC1O6V4Hs7e
        fmCV9sI/RA0dD5fo6stXELE=
X-Google-Smtp-Source: ADFU+vvhux2N2r/HW4ugIdvpr6uUg6extAVdCrE9qruvwPsJg7J/OOAgM2Hg/cInBEDBewzRgRNDzg==
X-Received: by 2002:a05:600c:21d1:: with SMTP id x17mr6611407wmj.94.1584665671841;
        Thu, 19 Mar 2020 17:54:31 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id h18sm5176613wmm.6.2020.03.19.17.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 17:54:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, linux@armlinux.org.uk
Subject: [PATCH v2 net-next] net: dsa: sja1105: Add support for the SGMII port
Date:   Fri, 20 Mar 2020 02:54:20 +0200
Message-Id: <20200320005420.1459-1-olteanv@gmail.com>
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

The latter two modes (any sort of in-band AN) are not supported by this
patch. For AN slave I did not have a board with the SGMII port connected
to a PHY, and for AN master it is unclear to me how that would even be
described.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
- Moved PCS forced speed to .phylink_mac_link_up
- Removed not-fully-thought-out code for in-band AN slave

 drivers/net/dsa/sja1105/sja1105.h          |   2 +
 drivers/net/dsa/sja1105/sja1105_clocking.c |   4 +
 drivers/net/dsa/sja1105/sja1105_main.c     | 126 ++++++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_sgmii.h    |  56 +++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c      |   1 +
 5 files changed, 186 insertions(+), 3 deletions(-)
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
index edf57ea07083..816125afceee 100644
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
@@ -650,6 +678,70 @@ static int sja1105_parse_dt(struct sja1105_private *priv,
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
+static void sja1105_sgmii_config(struct sja1105_private *priv, int port,
+				 int speed)
+{
+	int pcs_speed;
+
+	/* DIGITAL_CONTROL_1: Enable vendor-specific MMD1, allow the PHY to
+	 * stop the clock during LPI mode, make the MAC reconfigure
+	 * autonomously after PCS autoneg is done, flush the internal FIFOs.
+	 */
+	sja1105_sgmii_write(priv, 0x8000, SJA1105_DC1_EN_VSMMD1 |
+					  SJA1105_DC1_CLOCK_STOP_EN |
+					  SJA1105_DC1_MAC_AUTO_SW |
+					  SJA1105_DC1_INIT);
+	/* DIGITAL_CONTROL_2: No polarity inversion for TX and RX lanes */
+	sja1105_sgmii_write(priv, 0x80e1, SJA1105_DC2_TX_POL_INV_DISABLE);
+	/* AUTONEG_CONTROL: Use SGMII autoneg */
+	sja1105_sgmii_write(priv, 0x8001, SJA1105_AC_AUTONEG_MODE_SGMII);
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
@@ -707,8 +799,13 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
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
@@ -757,6 +854,8 @@ static bool sja1105_phy_mode_mismatch(struct sja1105_private *priv, int port,
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 		return (phy_mode != XMII_MODE_RGMII);
+	case PHY_INTERFACE_MODE_SGMII:
+		return (phy_mode != XMII_MODE_SGMII);
 	default:
 		return true;
 	}
@@ -798,6 +897,9 @@ static void sja1105_mac_link_up(struct dsa_switch *ds, int port,
 
 	sja1105_adjust_port_config(priv, port, speed);
 
+	if (sja1105_supports_sgmii(priv, port))
+		sja1105_sgmii_config(priv, port, speed);
+
 	sja1105_inhibit_tx(priv, BIT(port), false);
 }
 
@@ -833,7 +935,8 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 	phylink_set(mask, 10baseT_Full);
 	phylink_set(mask, 100baseT_Full);
 	phylink_set(mask, 100baseT1_Full);
-	if (mii->xmii_mode[port] == XMII_MODE_RGMII)
+	if (mii->xmii_mode[port] == XMII_MODE_RGMII ||
+	    mii->xmii_mode[port] == XMII_MODE_SGMII)
 		phylink_set(mask, 1000baseT_Full);
 
 	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
@@ -1367,6 +1470,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 	struct dsa_switch *ds = priv->ds;
 	s64 t1, t2, t3, t4;
 	s64 t12, t34;
+	u16 bmcr = 0;
 	int rc, i;
 	s64 now;
 
@@ -1384,6 +1488,9 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		mac[i].speed = SJA1105_SPEED_AUTO;
 	}
 
+	if (sja1105_supports_sgmii(priv, SJA1105_SGMII_PORT))
+		bmcr = sja1105_sgmii_read(priv, MII_BMCR);
+
 	/* No PTP operations can run right now */
 	mutex_lock(&priv->ptp_data.lock);
 
@@ -1433,6 +1540,19 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		if (rc < 0)
 			goto out;
 	}
+
+	if (sja1105_supports_sgmii(priv, SJA1105_SGMII_PORT)) {
+		int speed = SPEED_UNKNOWN;
+
+		if (bmcr & BMCR_SPEED1000)
+			speed = SPEED_1000;
+		else if (bmcr & BMCR_SPEED100)
+			speed = SPEED_100;
+		else if (bmcr & BMCR_SPEED10)
+			speed = SPEED_10;
+
+		sja1105_sgmii_config(priv, SJA1105_SGMII_PORT, speed);
+	}
 out:
 	mutex_unlock(&priv->mgmt_lock);
 
diff --git a/drivers/net/dsa/sja1105/sja1105_sgmii.h b/drivers/net/dsa/sja1105/sja1105_sgmii.h
new file mode 100644
index 000000000000..0517b5bcb36e
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_sgmii.h
@@ -0,0 +1,56 @@
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
+#define SJA1105_AC_AUTONEG_MODE_1000BASEX \
+	SJA1105_AC_AUTONEG_MODE(0)
+#define SJA1105_AC_AUTONEG_MODE_SGMII \
+	SJA1105_AC_AUTONEG_MODE(2)
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

