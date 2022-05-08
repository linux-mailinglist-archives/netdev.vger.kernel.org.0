Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6024851EEA4
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbiEHPf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234906AbiEHPfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:35:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C98E081
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WfCj3bOAeg5rObRI3yvn9w9JKN4frDz6pQqoKq5DKdw=; b=17fi2AKkMHMQBea0KWqborMCdb
        5JUUmUA+4QfNFWO6Ki1ZjthWoCIJB7RI+lap0O+B3Cnl/Ckbe0MtOuPoqsqS6tz4g+4FKo9UIdxp+
        q8gE0EpCGbKsvBXaCZ5l08Sx+964XK8NmQLGx2UWV/ZPGPMdhyn69UBoFNo+LFabYVcA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nnisJ-001n9u-Cr; Sun, 08 May 2022 17:31:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>
Subject: [PATCH net-next 09/10] net: dsa: Separate C22 and C45 MDIO bus transaction methods
Date:   Sun,  8 May 2022 17:30:48 +0200
Message-Id: <20220508153049.427227-10-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220508153049.427227-1-andrew@lunn.ch>
References: <20220508153049.427227-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By adding _c45 function pointers to the dsa_switch_op structure, the
dsa core can register an MDIO bus with C45 accessors.

The dsa-loop driver could in theory provide such accessors, since it
just passed requests to the MDIO bus it is on, but it seems unlikely
to be useful at the moment. It can however be added later.

mt7530 does support C45, but its uses a mix of registering its MDIO
bus and using the DSA core provided bus. This makes the change a bit
more complex.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mt7530.c | 92 ++++++++++++++++++++++------------------
 drivers/net/dsa/mt7530.h | 15 +++++--
 include/net/dsa.h        |  4 ++
 net/dsa/slave.c          | 35 +++++++++++++--
 4 files changed, 96 insertions(+), 50 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 2b02d823d497..8121cb6342d3 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -605,17 +605,29 @@ mt7530_mib_reset(struct dsa_switch *ds)
 	mt7530_write(priv, MT7530_MIB_CCR, CCR_MIB_ACTIVATE);
 }
 
-static int mt7530_phy_read(struct mt7530_priv *priv, int port, int regnum)
+static int mt7530_phy_read_c22(struct mt7530_priv *priv, int port, int regnum)
 {
 	return mdiobus_read_nested(priv->bus, port, regnum);
 }
 
-static int mt7530_phy_write(struct mt7530_priv *priv, int port, int regnum,
-			    u16 val)
+static int mt7530_phy_write_c22(struct mt7530_priv *priv, int port, int regnum,
+				u16 val)
 {
 	return mdiobus_write_nested(priv->bus, port, regnum, val);
 }
 
+static int mt7530_phy_read_c45(struct mt7530_priv *priv, int port,
+			       int devad, int regnum)
+{
+	return mdiobus_c45_read_nested(priv->bus, port, devad, regnum);
+}
+
+static int mt7530_phy_write_c45(struct mt7530_priv *priv, int port, int devad,
+				int regnum, u16 val)
+{
+	return mdiobus_c45_write_nested(priv->bus, port, devad, regnum, val);
+}
+
 static int
 mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 			int regnum)
@@ -667,7 +679,7 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 
 static int
 mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
-			 int regnum, u32 data)
+			 int regnum, u16 data)
 {
 	struct mii_bus *bus = priv->bus;
 	struct mt7530_dummy_poll p;
@@ -790,55 +802,43 @@ mt7531_ind_c22_phy_write(struct mt7530_priv *priv, int port, int regnum,
 }
 
 static int
-mt7531_ind_phy_read(struct mt7530_priv *priv, int port, int regnum)
+mt753x_phy_read_c22(struct mii_bus *bus, int port, int regnum)
 {
-	int devad;
-	int ret;
-
-	if (regnum & MII_ADDR_C45) {
-		devad = (regnum >> MII_DEVADDR_C45_SHIFT) & 0x1f;
-		ret = mt7531_ind_c45_phy_read(priv, port, devad,
-					      regnum & MII_REGADDR_C45_MASK);
-	} else {
-		ret = mt7531_ind_c22_phy_read(priv, port, regnum);
-	}
+	struct mt7530_priv *priv = bus->priv;
 
-	return ret;
+	return priv->info->phy_read_c22(priv, port, regnum);
 }
 
 static int
-mt7531_ind_phy_write(struct mt7530_priv *priv, int port, int regnum,
-		     u16 data)
+mt753x_phy_read_c45(struct mii_bus *bus, int port, int devad, int regnum)
 {
-	int devad;
-	int ret;
+	struct mt7530_priv *priv = bus->priv;
 
-	if (regnum & MII_ADDR_C45) {
-		devad = (regnum >> MII_DEVADDR_C45_SHIFT) & 0x1f;
-		ret = mt7531_ind_c45_phy_write(priv, port, devad,
-					       regnum & MII_REGADDR_C45_MASK,
-					       data);
-	} else {
-		ret = mt7531_ind_c22_phy_write(priv, port, regnum, data);
-	}
+	if (priv->info->phy_read_c45)
+		return priv->info->phy_read_c45(priv, port, devad, regnum);
 
-	return ret;
+	return -EOPNOTSUPP;
 }
 
 static int
-mt753x_phy_read(struct mii_bus *bus, int port, int regnum)
+mt753x_phy_write_c22(struct mii_bus *bus, int port, int regnum, u16 val)
 {
 	struct mt7530_priv *priv = bus->priv;
 
-	return priv->info->phy_read(priv, port, regnum);
+	return priv->info->phy_write_c22(priv, port, regnum, val);
 }
 
 static int
-mt753x_phy_write(struct mii_bus *bus, int port, int regnum, u16 val)
+mt753x_phy_write_c45(struct mii_bus *bus, int port, int devad, int regnum,
+		     u16 val)
 {
 	struct mt7530_priv *priv = bus->priv;
 
-	return priv->info->phy_write(priv, port, regnum, val);
+	if (priv->info->phy_write_c45)
+		return priv->info->phy_write_c45(priv, port, devad, regnum,
+						 val);
+
+	return -EOPNOTSUPP;
 }
 
 static void
@@ -2076,8 +2076,10 @@ mt7530_setup_mdio(struct mt7530_priv *priv)
 	bus->priv = priv;
 	bus->name = KBUILD_MODNAME "-mii";
 	snprintf(bus->id, MII_BUS_ID_SIZE, KBUILD_MODNAME "-%d", idx++);
-	bus->read = mt753x_phy_read;
-	bus->write = mt753x_phy_write;
+	bus->read = mt753x_phy_read_c22;
+	bus->write = mt753x_phy_write_c22;
+	bus->read_c45 = mt753x_phy_read_c45;
+	bus->write_c45 = mt753x_phy_write_c45;
 	bus->parent = dev;
 	bus->phy_mask = ~ds->phys_mii_mask;
 
@@ -3130,8 +3132,10 @@ static const struct mt753x_info mt753x_table[] = {
 		.id = ID_MT7621,
 		.pcs_ops = &mt7530_pcs_ops,
 		.sw_setup = mt7530_setup,
-		.phy_read = mt7530_phy_read,
-		.phy_write = mt7530_phy_write,
+		.phy_read_c22 = mt7530_phy_read_c22,
+		.phy_write_c22 = mt7530_phy_write_c22,
+		.phy_read_c45 = mt7530_phy_read_c45,
+		.phy_write_c45 = mt7530_phy_write_c45,
 		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
 		.mac_port_config = mt7530_mac_config,
@@ -3140,8 +3144,10 @@ static const struct mt753x_info mt753x_table[] = {
 		.id = ID_MT7530,
 		.pcs_ops = &mt7530_pcs_ops,
 		.sw_setup = mt7530_setup,
-		.phy_read = mt7530_phy_read,
-		.phy_write = mt7530_phy_write,
+		.phy_read_c22 = mt7530_phy_read_c22,
+		.phy_write_c22 = mt7530_phy_write_c22,
+		.phy_read_c45 = mt7530_phy_read_c45,
+		.phy_write_c45 = mt7530_phy_write_c45,
 		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
 		.mac_port_config = mt7530_mac_config,
@@ -3150,8 +3156,10 @@ static const struct mt753x_info mt753x_table[] = {
 		.id = ID_MT7531,
 		.pcs_ops = &mt7531_pcs_ops,
 		.sw_setup = mt7531_setup,
-		.phy_read = mt7531_ind_phy_read,
-		.phy_write = mt7531_ind_phy_write,
+		.phy_read_c22 = mt7531_ind_c22_phy_read,
+		.phy_write_c22 = mt7531_ind_c22_phy_write,
+		.phy_read_c45 = mt7531_ind_c45_phy_read,
+		.phy_write_c45 = mt7531_ind_c45_phy_write,
 		.pad_setup = mt7531_pad_setup,
 		.cpu_port_config = mt7531_cpu_port_config,
 		.mac_port_get_caps = mt7531_mac_port_get_caps,
@@ -3211,7 +3219,7 @@ mt7530_probe(struct mdio_device *mdiodev)
 	 * properly.
 	 */
 	if (!priv->info->sw_setup || !priv->info->pad_setup ||
-	    !priv->info->phy_read || !priv->info->phy_write ||
+	    !priv->info->phy_read_c22 || !priv->info->phy_write_c22 ||
 	    !priv->info->mac_port_get_caps ||
 	    !priv->info->mac_port_config)
 		return -EINVAL;
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 71e36b69b96d..1b14146a1f08 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -750,8 +750,10 @@ struct mt753x_pcs {
 /* struct mt753x_info -	This is the main data structure for holding the specific
  *			part for each supported device
  * @sw_setup:		Holding the handler to a device initialization
- * @phy_read:		Holding the way reading PHY port
- * @phy_write:		Holding the way writing PHY port
+ * @phy_read_c22:	Holding the way reading PHY port using C22
+ * @phy_write_c22:	Holding the way writing PHY port using C22
+ * @phy_read_c45:	Holding the way reading PHY port using C45
+ * @phy_write_c45:	Holding the way writing PHY port using C45
  * @pad_setup:		Holding the way setting up the bus pad for a certain
  *			MAC port
  * @phy_mode_supported:	Check if the PHY type is being supported on a certain
@@ -767,8 +769,13 @@ struct mt753x_info {
 	const struct phylink_pcs_ops *pcs_ops;
 
 	int (*sw_setup)(struct dsa_switch *ds);
-	int (*phy_read)(struct mt7530_priv *priv, int port, int regnum);
-	int (*phy_write)(struct mt7530_priv *priv, int port, int regnum, u16 val);
+	int (*phy_read_c22)(struct mt7530_priv *priv, int port, int regnum);
+	int (*phy_write_c22)(struct mt7530_priv *priv, int port, int regnum,
+			     u16 val);
+	int (*phy_read_c45)(struct mt7530_priv *priv, int port, int devad,
+			    int regnum);
+	int (*phy_write_c45)(struct mt7530_priv *priv, int port, int devad,
+			     int regnum, u16 val);
 	int (*pad_setup)(struct dsa_switch *ds, phy_interface_t interface);
 	int (*cpu_port_config)(struct dsa_switch *ds, int port);
 	void (*mac_port_get_caps)(struct dsa_switch *ds, int port,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 934958fda962..64e36eb33879 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -820,6 +820,10 @@ struct dsa_switch_ops {
 	int	(*phy_read)(struct dsa_switch *ds, int port, int regnum);
 	int	(*phy_write)(struct dsa_switch *ds, int port,
 			     int regnum, u16 val);
+	int	(*phy_read_c45)(struct dsa_switch *ds, int port, int devad,
+				int regnum);
+	int	(*phy_write_c45)(struct dsa_switch *ds, int port, int devad,
+				 int regnum, u16 val);
 
 	/*
 	 * Link state adjustment (called from libphy)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5ee0aced9410..a8976a67a8c0 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -165,7 +165,7 @@ static int dsa_slave_unsync_mc(struct net_device *dev,
 }
 
 /* slave mii_bus handling ***************************************************/
-static int dsa_slave_phy_read(struct mii_bus *bus, int addr, int reg)
+static int dsa_slave_phy_read_c22(struct mii_bus *bus, int addr, int reg)
 {
 	struct dsa_switch *ds = bus->priv;
 
@@ -175,7 +175,19 @@ static int dsa_slave_phy_read(struct mii_bus *bus, int addr, int reg)
 	return 0xffff;
 }
 
-static int dsa_slave_phy_write(struct mii_bus *bus, int addr, int reg, u16 val)
+static int dsa_slave_phy_read_c45(struct mii_bus *bus, int addr, int devad,
+				  int reg)
+{
+	struct dsa_switch *ds = bus->priv;
+
+	if (ds->phys_mii_mask & (1 << addr))
+		return ds->ops->phy_read_c45(ds, addr, devad, reg);
+
+	return 0xffff;
+}
+
+static int dsa_slave_phy_write_c22(struct mii_bus *bus, int addr, int reg,
+				   u16 val)
 {
 	struct dsa_switch *ds = bus->priv;
 
@@ -185,12 +197,27 @@ static int dsa_slave_phy_write(struct mii_bus *bus, int addr, int reg, u16 val)
 	return 0;
 }
 
+static int dsa_slave_phy_write_c45(struct mii_bus *bus, int addr, int reg,
+				   int devad, u16 val)
+{
+	struct dsa_switch *ds = bus->priv;
+
+	if (ds->phys_mii_mask & (1 << addr))
+		return ds->ops->phy_write_c45(ds, addr, devad, reg, val);
+
+	return 0;
+}
+
 void dsa_slave_mii_bus_init(struct dsa_switch *ds)
 {
 	ds->slave_mii_bus->priv = (void *)ds;
 	ds->slave_mii_bus->name = "dsa slave smi";
-	ds->slave_mii_bus->read = dsa_slave_phy_read;
-	ds->slave_mii_bus->write = dsa_slave_phy_write;
+	ds->slave_mii_bus->read = dsa_slave_phy_read_c22;
+	ds->slave_mii_bus->write = dsa_slave_phy_write_c22;
+	if (ds->ops->phy_read_c45 && ds->ops->phy_write_c45) {
+		ds->slave_mii_bus->read_c45 = dsa_slave_phy_read_c45;
+		ds->slave_mii_bus->write_c45 = dsa_slave_phy_write_c45;
+	}
 	snprintf(ds->slave_mii_bus->id, MII_BUS_ID_SIZE, "dsa-%d.%d",
 		 ds->dst->index, ds->index);
 	ds->slave_mii_bus->parent = ds->dev;
-- 
2.36.0

