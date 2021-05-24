Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CEC38F636
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 01:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhEXXY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 19:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhEXXYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 19:24:12 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1F3C06134A
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:40 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id lz27so44291351ejb.11
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L1jcOcxxMiCPm/pjeOtyhvP7bKvkHUyo6UJm2DwNHBc=;
        b=tjyVZgro7zVx2/n7iJi7YMpwbn8z5uqchpqpikFROsjv8L39E5S0BUwPsIRioirlS7
         j9hrRaOhPnaCXAzJWxVbZMvg6G+yUTyKvAAJTR/rl1pYMJ3YD0kzU2G476Sntds+KC68
         c4XNYeTthIIXgI5woZYDYRDIFOyKGksb/x/Sn5BL57TphBQipgsoXsGn7npzctexdKwd
         CduofTPHMC+y3ehqCCbQG8xJG1Bg1cQ6mlCrrZwhurGc6Jtyl8+z42hotBlHogLv1Hf1
         SKb3UY3v10Xry30YWFaVvtNYCpBYKJxIpnP+1SwyaLHByWK6wjYt/SydQY9KiDbJG8Mv
         HsPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L1jcOcxxMiCPm/pjeOtyhvP7bKvkHUyo6UJm2DwNHBc=;
        b=jzvXMWUMhY5FEDFW63xrlPaFaXPpoYTY63ITukiDSjG3myOJ+V2iap6DePPKWwpMJO
         eujY7OpDqjzaUni2MJ79aXJaCe3SMksQHMZjdx1I4m+04JeVyvFByBo1ySTqg9nafjLd
         hX2rx+DZNiXkmoAiOinyLwSajb7wyQdR9pAemFUulF6DYAWuLB/wSIRkf28jI20hpI7f
         61rEb6z+TZutd9RV02CgddLcmx7ifFLe/Dl38TK6DRpUa/dV5+57DxAp9WKoDao3PEt1
         o2+321n1IB7VYJu6f8nyt3pEkfjqG/1TYMieuujxwCzSIVDI53nDcZd19yF5cB+N9IvQ
         jRcw==
X-Gm-Message-State: AOAM531bg0BhdDg1CuDT8EyR7BWP/V2f0vgdllgqtOSCGghZnOMam6YA
        vYAZXthRv4jJLbMwwAC9LuM=
X-Google-Smtp-Source: ABdhPJz4RnLi5ATB/34QYnvXUKgRD0j/rTfn4NytuH1f1uFPFNSqosH/05I/Hk5rDWCzQRHgdnAtfA==
X-Received: by 2002:a17:907:248c:: with SMTP id zg12mr25294263ejb.268.1621898558784;
        Mon, 24 May 2021 16:22:38 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id di7sm9922746edb.34.2021.05.24.16.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:22:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 12/13] net: dsa: sja1105: expose the SGMII PCS as an mdio_device
Date:   Tue, 25 May 2021 02:22:13 +0300
Message-Id: <20210524232214.1378937-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524232214.1378937-1-olteanv@gmail.com>
References: <20210524232214.1378937-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SJA1110 has up to 4 PCSes for SGMII/2500base-x, and they have a
different access procedure compared to the SJA1105. Since both have a
register layout reminiscent of clause 45, the chosen abstraction to hide
this difference away was to implement an internal MDIO bus for the PCS,
and to use a high-level set of procedures called sja1105_pcs_read and
sja1105_pcs_write.

Since we touch all PCS accessors again, now it is a good time to check
for error codes from the hardware access as well. We can't propagate the
errors very far due to phylink returning void for mac_config and
mac_link_up, but at least we print them to the console.

The SGMII PCS of the SJA1110 is not functional at this point, it needs a
different initialization sequence compared to SJA1105. That will be done
by the next patch.

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h       |  12 ++
 drivers/net/dsa/sja1105/sja1105_main.c  |  93 +++++----
 drivers/net/dsa/sja1105/sja1105_mdio.c  | 241 ++++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_sgmii.h |   2 -
 drivers/net/dsa/sja1105/sja1105_spi.c   |  15 ++
 5 files changed, 310 insertions(+), 53 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 80966d7ce318..be788ddb7259 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -69,6 +69,7 @@ struct sja1105_regs {
 	u64 stats[__MAX_SJA1105_STATS_AREA][SJA1105_MAX_NUM_PORTS];
 	u64 mdio_100base_tx;
 	u64 mdio_100base_t1;
+	u64 pcs_base[SJA1105_MAX_NUM_PORTS];
 };
 
 struct sja1105_mdio_private {
@@ -129,6 +130,8 @@ struct sja1105_info {
 	void (*ptp_cmd_packing)(u8 *buf, struct sja1105_ptp_cmd *cmd,
 				enum packing_op op);
 	int (*clocking_setup)(struct sja1105_private *priv);
+	int (*pcs_mdio_read)(struct mii_bus *bus, int phy, int reg);
+	int (*pcs_mdio_write)(struct mii_bus *bus, int phy, int reg, u16 val);
 	const char *name;
 	bool supports_mii[SJA1105_MAX_NUM_PORTS];
 	bool supports_rmii[SJA1105_MAX_NUM_PORTS];
@@ -260,6 +263,8 @@ struct sja1105_private {
 	struct sja1105_cbs_entry *cbs;
 	struct mii_bus *mdio_base_t1;
 	struct mii_bus *mdio_base_tx;
+	struct mii_bus *mdio_pcs;
+	struct mdio_device *pcs[SJA1105_MAX_NUM_PORTS];
 	struct sja1105_tagger_data tagger_data;
 	struct sja1105_ptp_data ptp_data;
 	struct sja1105_tas_data tas_data;
@@ -292,6 +297,13 @@ void sja1105_frame_memory_partitioning(struct sja1105_private *priv);
 /* From sja1105_mdio.c */
 int sja1105_mdiobus_register(struct dsa_switch *ds);
 void sja1105_mdiobus_unregister(struct dsa_switch *ds);
+int sja1105_pcs_mdio_read(struct mii_bus *bus, int phy, int reg);
+int sja1105_pcs_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val);
+int sja1110_pcs_mdio_read(struct mii_bus *bus, int phy, int reg);
+int sja1110_pcs_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val);
+int sja1105_pcs_read(struct sja1105_private *priv, int port, int mmd, int reg);
+int sja1105_pcs_write(struct sja1105_private *priv, int port, int mmd, int reg,
+		      u16 val);
 
 /* From sja1105_devlink.c */
 int sja1105_devlink_setup(struct dsa_switch *ds);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 20c5dcd8de8d..d0938daacbae 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -962,74 +962,61 @@ static int sja1105_parse_dt(struct sja1105_private *priv,
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
 static void sja1105_sgmii_pcs_config(struct sja1105_private *priv, int port,
 				     bool an_enabled, bool an_master)
 {
 	u16 ac = SJA1105_AC_AUTONEG_MODE_SGMII;
+	int rc;
 
 	/* DIGITAL_CONTROL_1: Enable vendor-specific MMD1, allow the PHY to
 	 * stop the clock during LPI mode, make the MAC reconfigure
 	 * autonomously after PCS autoneg is done, flush the internal FIFOs.
 	 */
-	sja1105_sgmii_write(priv, port, MDIO_MMD_VEND2, SJA1105_DC1,
-			    SJA1105_DC1_EN_VSMMD1 |
-			    SJA1105_DC1_CLOCK_STOP_EN |
-			    SJA1105_DC1_MAC_AUTO_SW |
-			    SJA1105_DC1_INIT);
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2, SJA1105_DC1,
+			       SJA1105_DC1_EN_VSMMD1 |
+			       SJA1105_DC1_CLOCK_STOP_EN |
+			       SJA1105_DC1_MAC_AUTO_SW |
+			       SJA1105_DC1_INIT);
+	if (rc < 0)
+		goto out_write_failed;
+
 	/* DIGITAL_CONTROL_2: No polarity inversion for TX and RX lanes */
-	sja1105_sgmii_write(priv, port, MDIO_MMD_VEND2, SJA1105_DC2,
-			    SJA1105_DC2_TX_POL_INV_DISABLE);
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2, SJA1105_DC2,
+			       SJA1105_DC2_TX_POL_INV_DISABLE);
+	if (rc < 0)
+		goto out_write_failed;
+
 	/* AUTONEG_CONTROL: Use SGMII autoneg */
 	if (an_master)
 		ac |= SJA1105_AC_PHY_MODE | SJA1105_AC_SGMII_LINK;
-	sja1105_sgmii_write(priv, port, MDIO_MMD_VEND2, SJA1105_AC, ac);
+
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2, SJA1105_AC, ac);
+	if (rc < 0)
+		goto out_write_failed;
+
 	/* BASIC_CONTROL: enable in-band AN now, if requested. Otherwise,
 	 * sja1105_sgmii_pcs_force_speed must be called later for the link
 	 * to become operational.
 	 */
-	if (an_enabled)
-		sja1105_sgmii_write(priv, port, MDIO_MMD_VEND2, MDIO_CTRL1,
-				    BMCR_ANENABLE | BMCR_ANRESTART);
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
 }
 
 static void sja1105_sgmii_pcs_force_speed(struct sja1105_private *priv,
 					  int port, int speed)
 {
 	int pcs_speed;
+	int rc;
 
 	switch (speed) {
 	case SPEED_1000:
@@ -1045,8 +1032,12 @@ static void sja1105_sgmii_pcs_force_speed(struct sja1105_private *priv,
 		dev_err(priv->ds->dev, "Invalid speed %d\n", speed);
 		return;
 	}
-	sja1105_sgmii_write(priv, port, MDIO_MMD_VEND2, MDIO_CTRL1,
-			    pcs_speed | BMCR_FULLDPLX);
+
+	rc = sja1105_pcs_write(priv, port, MDIO_MMD_VEND2, MDIO_CTRL1,
+			       pcs_speed | BMCR_FULLDPLX);
+	if (rc < 0)
+		dev_err(priv->ds->dev, "Failed to write to PCS: %pe\n",
+			ERR_PTR(rc));
 }
 
 /* Convert link speed from SJA1105 to ethtool encoding */
@@ -1250,7 +1241,7 @@ static int sja1105_mac_pcs_get_state(struct dsa_switch *ds, int port,
 	int ais;
 
 	/* Read the vendor-specific AUTONEG_INTR_STATUS register */
-	ais = sja1105_sgmii_read(priv, port, MDIO_MMD_VEND2, SJA1105_AIS);
+	ais = sja1105_pcs_read(priv, port, MDIO_MMD_VEND2, SJA1105_AIS);
 	if (ais < 0)
 		return ais;
 
@@ -1955,9 +1946,9 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		mac[i].speed = priv->info->port_speed[SJA1105_SPEED_AUTO];
 
 		if (priv->phy_mode[i] == PHY_INTERFACE_MODE_SGMII)
-			bmcr[i] = sja1105_sgmii_read(priv, i,
-						     MDIO_MMD_VEND2,
-						     MDIO_CTRL1);
+			bmcr[i] = sja1105_pcs_read(priv, i,
+						   MDIO_MMD_VEND2,
+						   MDIO_CTRL1);
 	}
 
 	/* No PTP operations can run right now */
diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index a3fe6b664807..7e83dd0f4f16 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -4,6 +4,159 @@
 #include <linux/of_mdio.h>
 #include "sja1105.h"
 
+#define SJA1110_PCS_BANK_REG		SJA1110_SPI_ADDR(0x3fc)
+
+int sja1105_pcs_read(struct sja1105_private *priv, int port, int mmd, int reg)
+{
+	u32 reg_addr = MII_ADDR_C45 | mmd << 16 | reg;
+	struct mdio_device *pcs = priv->pcs[port];
+
+	if (!pcs)
+		return -ENODEV;
+
+	return mdiobus_read(priv->mdio_pcs, port, reg_addr);
+}
+
+int sja1105_pcs_write(struct sja1105_private *priv, int port, int mmd, int reg,
+		      u16 val)
+{
+	u32 reg_addr = MII_ADDR_C45 | mmd << 16 | reg;
+	struct mdio_device *pcs = priv->pcs[port];
+
+	if (!pcs)
+		return -ENODEV;
+
+	return mdiobus_write(priv->mdio_pcs, port, reg_addr, val);
+}
+
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
+	return sja1105_xfer_u32(priv, SPI_WRITE, addr, &tmp, NULL);
+}
+
+int sja1110_pcs_mdio_read(struct mii_bus *bus, int phy, int reg)
+{
+	struct sja1105_mdio_private *mdio_priv = bus->priv;
+	struct sja1105_private *priv = mdio_priv->priv;
+	const struct sja1105_regs *regs = priv->info->regs;
+	int offset, bank;
+	u64 addr;
+	u32 tmp;
+	u16 mmd;
+	int rc;
+
+	if (!(reg & MII_ADDR_C45))
+		return -EINVAL;
+
+	/* This addressing scheme reserves register 0xff for the bank address
+	 * register, so that can never be addressed.
+	 */
+	if (WARN_ON(offset == 0xff))
+		return -ENODEV;
+
+	if (regs->pcs_base[phy] == SJA1105_RSV_ADDR)
+		return -ENODEV;
+
+	mmd = (reg >> MII_DEVADDR_C45_SHIFT) & 0x1f;
+	addr = (mmd << 16) | (reg & GENMASK(15, 0));
+
+	bank = addr >> 8;
+	offset = addr & GENMASK(7, 0);
+
+	tmp = bank;
+
+	rc = sja1105_xfer_u32(priv, SPI_WRITE,
+			      regs->pcs_base[phy] + SJA1110_PCS_BANK_REG,
+			      &tmp, NULL);
+	if (rc < 0)
+		return rc;
+
+	rc = sja1105_xfer_u32(priv, SPI_READ, regs->pcs_base[phy] + offset,
+			      &tmp, NULL);
+	if (rc < 0)
+		return rc;
+
+	return tmp & 0xffff;
+}
+
+int sja1110_pcs_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val)
+{
+	struct sja1105_mdio_private *mdio_priv = bus->priv;
+	struct sja1105_private *priv = mdio_priv->priv;
+	const struct sja1105_regs *regs = priv->info->regs;
+	int offset, bank;
+	u64 addr;
+	u32 tmp;
+	u16 mmd;
+	int rc;
+
+	if (!(reg & MII_ADDR_C45))
+		return -EINVAL;
+
+	/* This addressing scheme reserves register 0xff for the bank address
+	 * register, so that can never be addressed.
+	 */
+	if (WARN_ON(offset == 0xff))
+		return -ENODEV;
+
+	if (regs->pcs_base[phy] == SJA1105_RSV_ADDR)
+		return -ENODEV;
+
+	mmd = (reg >> MII_DEVADDR_C45_SHIFT) & 0x1f;
+	addr = (mmd << 16) | (reg & GENMASK(15, 0));
+
+	bank = addr >> 8;
+	offset = addr & GENMASK(7, 0);
+
+	tmp = bank;
+
+	rc = sja1105_xfer_u32(priv, SPI_WRITE,
+			      regs->pcs_base[phy] + SJA1110_PCS_BANK_REG,
+			      &tmp, NULL);
+	if (rc < 0)
+		return rc;
+
+	tmp = val;
+
+	return sja1105_xfer_u32(priv, SPI_WRITE, regs->pcs_base[phy] + offset,
+				&tmp, NULL);
+}
+
 enum sja1105_mdio_opcode {
 	SJA1105_C45_ADDR = 0,
 	SJA1105_C22 = 1,
@@ -239,6 +392,88 @@ static void sja1105_mdiobus_base_t1_unregister(struct sja1105_private *priv)
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
+	mdio_priv = bus->priv;
+	mdio_priv->priv = priv;
+
+	/* We don't register this MDIO bus because there is no PHY on it */
+
+	for (port = 0; port < ds->num_ports; port++) {
+		struct mdio_device *mdiodev;
+
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
+		if (!priv->info->supports_sgmii[port])
+			continue;
+
+		mdiodev = mdio_device_create(bus, port);
+		if (IS_ERR(mdiodev)) {
+			rc = PTR_ERR(mdiodev);
+			goto out_pcs_free;
+		}
+
+		priv->pcs[port] = mdiodev;
+	}
+
+	priv->mdio_pcs = bus;
+
+	return 0;
+
+out_pcs_free:
+	for (port = 0; port < ds->num_ports; port++) {
+		if (!priv->pcs[port])
+			continue;
+
+		mdio_device_free(priv->pcs[port]);
+		priv->pcs[port] = NULL;
+	}
+
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
+		if (!priv->pcs[port])
+			continue;
+
+		mdio_device_free(priv->pcs[port]);
+		priv->pcs[port] = NULL;
+	}
+
+	mdiobus_free(priv->mdio_pcs);
+	priv->mdio_pcs = NULL;
+}
+
 int sja1105_mdiobus_register(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
@@ -247,6 +482,10 @@ int sja1105_mdiobus_register(struct dsa_switch *ds)
 	struct device_node *mdio_node;
 	int rc;
 
+	rc = sja1105_mdiobus_pcs_register(priv);
+	if (rc)
+		return rc;
+
 	mdio_node = of_get_child_by_name(switch_node, "mdio");
 	if (!mdio_node)
 		return 0;
@@ -275,6 +514,7 @@ int sja1105_mdiobus_register(struct dsa_switch *ds)
 	sja1105_mdiobus_base_tx_unregister(priv);
 err_put_mdio_node:
 	of_node_put(mdio_node);
+	sja1105_mdiobus_pcs_unregister(priv);
 
 	return rc;
 }
@@ -285,4 +525,5 @@ void sja1105_mdiobus_unregister(struct dsa_switch *ds)
 
 	sja1105_mdiobus_base_t1_unregister(priv);
 	sja1105_mdiobus_base_tx_unregister(priv);
+	sja1105_mdiobus_pcs_unregister(priv);
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_sgmii.h b/drivers/net/dsa/sja1105/sja1105_sgmii.h
index 24d9bc046e70..dc067b876758 100644
--- a/drivers/net/dsa/sja1105/sja1105_sgmii.h
+++ b/drivers/net/dsa/sja1105/sja1105_sgmii.h
@@ -4,8 +4,6 @@
 #ifndef _SJA1105_SGMII_H
 #define _SJA1105_SGMII_H
 
-#define SJA1105_SGMII_PORT		4
-
 /* DIGITAL_CONTROL_1 (address 1f8000h) */
 #define SJA1105_DC1			0x8000
 #define SJA1105_DC1_VS_RESET		BIT(15)
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 54ecb5565761..e6c2cb68fcc4 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -561,6 +561,9 @@ static struct sja1105_regs sja1110_regs = {
 	.ptpsyncts = SJA1110_SPI_ADDR(0x84),
 	.mdio_100base_tx = 0x1c2400,
 	.mdio_100base_t1 = 0x1c1000,
+	.pcs_base = {SJA1105_RSV_ADDR, 0x1c1400, 0x1c1800, 0x1c1c00, 0x1c2000,
+		     SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		     SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR},
 };
 
 const struct sja1105_info sja1105e_info = {
@@ -707,6 +710,8 @@ const struct sja1105_info sja1105r_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
+	.pcs_mdio_read		= sja1105_pcs_mdio_read,
+	.pcs_mdio_write		= sja1105_pcs_mdio_write,
 	.regs			= &sja1105pqrs_regs,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
@@ -741,6 +746,8 @@ const struct sja1105_info sja1105s_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1105_clocking_setup,
+	.pcs_mdio_read		= sja1105_pcs_mdio_read,
+	.pcs_mdio_write		= sja1105_pcs_mdio_write,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 3,
@@ -774,6 +781,8 @@ const struct sja1105_info sja1110a_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1110_clocking_setup,
+	.pcs_mdio_read		= sja1110_pcs_mdio_read,
+	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
@@ -819,6 +828,8 @@ const struct sja1105_info sja1110b_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1110_clocking_setup,
+	.pcs_mdio_read		= sja1110_pcs_mdio_read,
+	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
@@ -864,6 +875,8 @@ const struct sja1105_info sja1110c_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1110_clocking_setup,
+	.pcs_mdio_read		= sja1110_pcs_mdio_read,
+	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
@@ -909,6 +922,8 @@ const struct sja1105_info sja1110d_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1110_clocking_setup,
+	.pcs_mdio_read		= sja1110_pcs_mdio_read,
+	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
-- 
2.25.1

