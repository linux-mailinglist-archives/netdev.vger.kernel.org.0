Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C80391945
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 15:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbhEZN5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 09:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbhEZN5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 09:57:30 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977A8C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:55:56 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id b9so2581987ejc.13
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rBQiGdmKiViP+5BrFukQsjSpt9Gn23jXAPduAryoX0o=;
        b=GJ6AuAzKIwvSg9wqCI8EYYOsoijSW2FqMUddGDHyFXldExUZDRRRYijbuJ474/7ZyG
         WUN5SLAxsmY1sDYaKkblk/uk+UtbbU4Dk+T/ffwjbYT1UOgVlAFYRzUFtoTHYaEsh2ol
         tHPTAZadtmwFh9NNAKoxcnswqFJrvFKlFlVahPqjqhpeGwXcprcKAfr6TZa1ClIML4xP
         3UDdo7eUrWVO+qkjc9iurBclFIkRUlyu5RBcEBTbuVpzv9o/vWJrIvx3lql+v4tvBKbX
         qmfifHI4OQi5jW7gwswNoFipfy/LI3DbXyz3ML7IEzqBA9P6xVnqbvqvi4zIO5pqyG34
         iFfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rBQiGdmKiViP+5BrFukQsjSpt9Gn23jXAPduAryoX0o=;
        b=IS7nd3hW7/Jm51YSbgQxh8CLpBue5rSRoOXQ8niCZsO5spWaL67d/zI83m21RFvQcp
         R1p74NWKK2gS4NgUPIDCKTs+oiObL/G0TrWsenAhaQghBnfsMw6cZK8x8t+bOs6nFwOH
         +dqUpFwzKSaqIVlrl/ovh4r3VUktq+wM4p+/00hbnnEOhWZ9LggHj06irWAFbgRucJul
         qHRchqtbc0cNNucRLwnHkAateKLDVpMt6l6Jhkf5PelAUm4iwN9kgib/lCAyj+RPapjF
         j0kWZp8FgUWKFMsa5VOLeJB07JMOP+fzz1Xbju6YGRWexHEljg0dg8lv3u2XkJGNI9Df
         diMg==
X-Gm-Message-State: AOAM530G2RFew+/1f3SrQ7eRPGfD06zLAFVP0WB5E/iB+fM+0dJI0xWB
        8Ut+bMJRuOsQk+ictE/Jtck=
X-Google-Smtp-Source: ABdhPJw0X9cTNa+X0VuNG9sw9o3PsdTA1zZ707M/KWPbaWk15nV0B+LM8Lo8s8fdV7myBCh4vK8+JA==
X-Received: by 2002:a17:906:6ad0:: with SMTP id q16mr34849090ejs.286.1622037355230;
        Wed, 26 May 2021 06:55:55 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id k11sm10508476ejc.94.2021.05.26.06.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 06:55:54 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC PATCH v2 linux-next 03/14] net: dsa: sja1105: the 0x1F0000 SGMII "base address" is actually MDIO_MMD_VEND2
Date:   Wed, 26 May 2021 16:55:24 +0300
Message-Id: <20210526135535.2515123-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looking at the SGMII PCS from SJA1110, which is accessed indirectly
through a different base address as can be seen in the next patch, it
appears odd that the address accessed through indirection still
references the base address from the SJA1105S register map (first MDIO
register is at 0x1f0000), when it could index the SGMII registers
starting from zero.

Except that the 0x1f0000 is not a base address at all, it seems. It is
0x1f << 16 | 0x0000, and 0x1f is coding for the vendor-specific MMD2.
So, it turns out, the Synopsys PCS implements all its registers inside
the vendor-specific MMDs 1 and 2 (0x1e and 0x1f). This explains why the
PCS has no overlaps (for the other MMDs) with other register regions of
the switch (because no other MMDs are implemented).

Change the code to remove the SGMII "base address" and explicitly encode
the MMD for reads/writes. This will become necessary for SJA1110 support.

Cc: Russell King <linux@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/dsa/sja1105/sja1105.h      |  1 -
 drivers/net/dsa/sja1105/sja1105_main.c | 31 +++++++++++++-------------
 drivers/net/dsa/sja1105/sja1105_spi.c  |  1 -
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 2ec03917feb3..830ea5ca359f 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -48,7 +48,6 @@ struct sja1105_regs {
 	u64 rgu;
 	u64 vl_status;
 	u64 config;
-	u64 sgmii;
 	u64 rmii_pll1;
 	u64 ptppinst;
 	u64 ptppindur;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1a49cfce9611..292490a2ea0e 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -898,36 +898,34 @@ static int sja1105_parse_dt(struct sja1105_private *priv,
 	return rc;
 }
 
-static int sja1105_sgmii_read(struct sja1105_private *priv, int port,
+static int sja1105_sgmii_read(struct sja1105_private *priv, int port, int mmd,
 			      int pcs_reg)
 {
-	const struct sja1105_regs *regs = priv->info->regs;
+	u64 addr = (mmd << 16) | pcs_reg;
 	u32 val;
 	int rc;
 
 	if (port != SJA1105_SGMII_PORT)
 		return -ENODEV;
 
-	rc = sja1105_xfer_u32(priv, SPI_READ, regs->sgmii + pcs_reg,
-			      &val, NULL);
+	rc = sja1105_xfer_u32(priv, SPI_READ, addr, &val, NULL);
 	if (rc < 0)
 		return rc;
 
 	return val;
 }
 
-static int sja1105_sgmii_write(struct sja1105_private *priv, int port,
+static int sja1105_sgmii_write(struct sja1105_private *priv, int port, int mmd,
 			       int pcs_reg, u16 pcs_val)
 {
-	const struct sja1105_regs *regs = priv->info->regs;
+	u64 addr = (mmd << 16) | pcs_reg;
 	u32 val = pcs_val;
 	int rc;
 
 	if (port != SJA1105_SGMII_PORT)
 		return -ENODEV;
 
-	rc = sja1105_xfer_u32(priv, SPI_WRITE, regs->sgmii + pcs_reg,
-			      &val, NULL);
+	rc = sja1105_xfer_u32(priv, SPI_WRITE, addr, &val, NULL);
 	if (rc < 0)
 		return rc;
 
@@ -943,24 +941,24 @@ static void sja1105_sgmii_pcs_config(struct sja1105_private *priv, int port,
 	 * stop the clock during LPI mode, make the MAC reconfigure
 	 * autonomously after PCS autoneg is done, flush the internal FIFOs.
 	 */
-	sja1105_sgmii_write(priv, port, SJA1105_DC1,
+	sja1105_sgmii_write(priv, port, MDIO_MMD_VEND2, SJA1105_DC1,
 			    SJA1105_DC1_EN_VSMMD1 |
 			    SJA1105_DC1_CLOCK_STOP_EN |
 			    SJA1105_DC1_MAC_AUTO_SW |
 			    SJA1105_DC1_INIT);
 	/* DIGITAL_CONTROL_2: No polarity inversion for TX and RX lanes */
-	sja1105_sgmii_write(priv, port, SJA1105_DC2,
+	sja1105_sgmii_write(priv, port, MDIO_MMD_VEND2, SJA1105_DC2,
 			    SJA1105_DC2_TX_POL_INV_DISABLE);
 	/* AUTONEG_CONTROL: Use SGMII autoneg */
 	if (an_master)
 		ac |= SJA1105_AC_PHY_MODE | SJA1105_AC_SGMII_LINK;
-	sja1105_sgmii_write(priv, port, SJA1105_AC, ac);
+	sja1105_sgmii_write(priv, port, MDIO_MMD_VEND2, SJA1105_AC, ac);
 	/* BASIC_CONTROL: enable in-band AN now, if requested. Otherwise,
 	 * sja1105_sgmii_pcs_force_speed must be called later for the link
 	 * to become operational.
 	 */
 	if (an_enabled)
-		sja1105_sgmii_write(priv, port, MII_BMCR,
+		sja1105_sgmii_write(priv, port, MDIO_MMD_VEND2, MDIO_CTRL1,
 				    BMCR_ANENABLE | BMCR_ANRESTART);
 }
 
@@ -983,7 +981,8 @@ static void sja1105_sgmii_pcs_force_speed(struct sja1105_private *priv,
 		dev_err(priv->ds->dev, "Invalid speed %d\n", speed);
 		return;
 	}
-	sja1105_sgmii_write(priv, port, MII_BMCR, pcs_speed | BMCR_FULLDPLX);
+	sja1105_sgmii_write(priv, port, MDIO_MMD_VEND2, MDIO_CTRL1,
+			    pcs_speed | BMCR_FULLDPLX);
 }
 
 /* Convert link speed from SJA1105 to ethtool encoding */
@@ -1201,7 +1200,7 @@ static int sja1105_mac_pcs_get_state(struct dsa_switch *ds, int port,
 	int ais;
 
 	/* Read the vendor-specific AUTONEG_INTR_STATUS register */
-	ais = sja1105_sgmii_read(priv, port, SJA1105_AIS);
+	ais = sja1105_sgmii_read(priv, port, MDIO_MMD_VEND2, SJA1105_AIS);
 	if (ais < 0)
 		return ais;
 
@@ -1905,7 +1904,9 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		mac[i].speed = SJA1105_SPEED_AUTO;
 
 		if (sja1105_supports_sgmii(priv, i))
-			bmcr[i] = sja1105_sgmii_read(priv, i, MII_BMCR);
+			bmcr[i] = sja1105_sgmii_read(priv, i,
+						     MDIO_MMD_VEND2,
+						     MDIO_CTRL1);
 	}
 
 	/* No PTP operations can run right now */
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index d0bc6cf90bfd..615e0906b1fa 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -440,7 +440,6 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.pad_mii_tx = {0x100800, 0x100802, 0x100804, 0x100806, 0x100808},
 	.pad_mii_rx = {0x100801, 0x100803, 0x100805, 0x100807, 0x100809},
 	.pad_mii_id = {0x100810, 0x100811, 0x100812, 0x100813, 0x100814},
-	.sgmii = 0x1F0000,
 	.rmii_pll1 = 0x10000A,
 	.cgu_idiv = {0x10000B, 0x10000C, 0x10000D, 0x10000E, 0x10000F},
 	.stats[MAC] = {0x200, 0x202, 0x204, 0x206, 0x208},
-- 
2.25.1

