Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA7368902B
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjBCHI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 02:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbjBCHIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:08:55 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF0F23652;
        Thu,  2 Feb 2023 23:08:38 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pNqBX-0000uy-2P;
        Fri, 03 Feb 2023 08:08:35 +0100
Date:   Fri, 3 Feb 2023 07:06:53 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: [PATCH 9/9] net: dsa: mt7530: use external PCS driver
Message-ID: <677a5e37aab97a4f992d35c41329733c5f3082fb.1675407169.git.daniel@makrotopia.org>
References: <cover.1675407169.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1675407169.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement regmap access wrappers, for now only to be used by the
pcs-mtk driver.
Make use of external PCS driver and drop the reduntant implementation
in mt7530.c.
As a nice side effect the SGMII registers can now also more easily be
inspected for debugging via /sys/kernel/debug/regmap.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/Kconfig  |   2 +
 drivers/net/dsa/mt7530.c | 278 ++++++++++-----------------------------
 drivers/net/dsa/mt7530.h |  43 +-----
 3 files changed, 72 insertions(+), 251 deletions(-)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index f6f3b43dfb06..61b6608e45d6 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -38,6 +38,8 @@ config NET_DSA_MT7530
 	tristate "MediaTek MT7530 and MT7531 Ethernet switch support"
 	select NET_DSA_TAG_MTK
 	select MEDIATEK_GE_PHY
+	select PCS_MTK
+	select REGMAP
 	help
 	  This enables support for the MediaTek MT7530 and MT7531 Ethernet
 	  switch chips. Multi-chip module MT7530 in MT7621AT, MT7621DAT,
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 616b21c90d05..fb8ec7e479d1 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -14,6 +14,7 @@
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/of_platform.h>
+#include <linux/pcs/pcs-mtk.h>
 #include <linux/phylink.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
@@ -2555,128 +2556,11 @@ static int mt7531_rgmii_setup(struct mt7530_priv *priv, u32 port,
 	return 0;
 }
 
-static void mt7531_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
-			       phy_interface_t interface, int speed, int duplex)
-{
-	struct mt7530_priv *priv = pcs_to_mt753x_pcs(pcs)->priv;
-	int port = pcs_to_mt753x_pcs(pcs)->port;
-	unsigned int val;
-
-	/* For adjusting speed and duplex of SGMII force mode. */
-	if (interface != PHY_INTERFACE_MODE_SGMII ||
-	    phylink_autoneg_inband(mode))
-		return;
-
-	/* SGMII force mode setting */
-	val = mt7530_read(priv, MT7531_SGMII_MODE(port));
-	val &= ~MT7531_SGMII_IF_MODE_MASK;
-
-	switch (speed) {
-	case SPEED_10:
-		val |= MT7531_SGMII_FORCE_SPEED_10;
-		break;
-	case SPEED_100:
-		val |= MT7531_SGMII_FORCE_SPEED_100;
-		break;
-	case SPEED_1000:
-		val |= MT7531_SGMII_FORCE_SPEED_1000;
-		break;
-	}
-
-	/* MT7531 SGMII 1G force mode can only work in full duplex mode,
-	 * no matter MT7531_SGMII_FORCE_HALF_DUPLEX is set or not.
-	 *
-	 * The speed check is unnecessary as the MAC capabilities apply
-	 * this restriction. --rmk
-	 */
-	if ((speed == SPEED_10 || speed == SPEED_100) &&
-	    duplex != DUPLEX_FULL)
-		val |= MT7531_SGMII_FORCE_HALF_DUPLEX;
-
-	mt7530_write(priv, MT7531_SGMII_MODE(port), val);
-}
-
 static bool mt753x_is_mac_port(u32 port)
 {
 	return (port == 5 || port == 6);
 }
 
-static int mt7531_sgmii_setup_mode_force(struct mt7530_priv *priv, u32 port,
-					 phy_interface_t interface)
-{
-	u32 val;
-
-	if (!mt753x_is_mac_port(port))
-		return -EINVAL;
-
-	mt7530_set(priv, MT7531_QPHY_PWR_STATE_CTRL(port),
-		   MT7531_SGMII_PHYA_PWD);
-
-	val = mt7530_read(priv, MT7531_PHYA_CTRL_SIGNAL3(port));
-	val &= ~MT7531_RG_TPHY_SPEED_MASK;
-	/* Setup 2.5 times faster clock for 2.5Gbps data speeds with 10B/8B
-	 * encoding.
-	 */
-	val |= (interface == PHY_INTERFACE_MODE_2500BASEX) ?
-		MT7531_RG_TPHY_SPEED_3_125G : MT7531_RG_TPHY_SPEED_1_25G;
-	mt7530_write(priv, MT7531_PHYA_CTRL_SIGNAL3(port), val);
-
-	mt7530_clear(priv, MT7531_PCS_CONTROL_1(port), MT7531_SGMII_AN_ENABLE);
-
-	/* MT7531 SGMII 1G and 2.5G force mode can only work in full duplex
-	 * mode, no matter MT7531_SGMII_FORCE_HALF_DUPLEX is set or not.
-	 */
-	mt7530_rmw(priv, MT7531_SGMII_MODE(port),
-		   MT7531_SGMII_IF_MODE_MASK | MT7531_SGMII_REMOTE_FAULT_DIS,
-		   MT7531_SGMII_FORCE_SPEED_1000);
-
-	mt7530_write(priv, MT7531_QPHY_PWR_STATE_CTRL(port), 0);
-
-	return 0;
-}
-
-static int mt7531_sgmii_setup_mode_an(struct mt7530_priv *priv, int port,
-				      phy_interface_t interface)
-{
-	if (!mt753x_is_mac_port(port))
-		return -EINVAL;
-
-	mt7530_set(priv, MT7531_QPHY_PWR_STATE_CTRL(port),
-		   MT7531_SGMII_PHYA_PWD);
-
-	mt7530_rmw(priv, MT7531_PHYA_CTRL_SIGNAL3(port),
-		   MT7531_RG_TPHY_SPEED_MASK, MT7531_RG_TPHY_SPEED_1_25G);
-
-	mt7530_set(priv, MT7531_SGMII_MODE(port),
-		   MT7531_SGMII_REMOTE_FAULT_DIS |
-		   MT7531_SGMII_SPEED_DUPLEX_AN);
-
-	mt7530_rmw(priv, MT7531_PCS_SPEED_ABILITY(port),
-		   MT7531_SGMII_TX_CONFIG_MASK, 1);
-
-	mt7530_set(priv, MT7531_PCS_CONTROL_1(port), MT7531_SGMII_AN_ENABLE);
-
-	mt7530_set(priv, MT7531_PCS_CONTROL_1(port), MT7531_SGMII_AN_RESTART);
-
-	mt7530_write(priv, MT7531_QPHY_PWR_STATE_CTRL(port), 0);
-
-	return 0;
-}
-
-static void mt7531_pcs_an_restart(struct phylink_pcs *pcs)
-{
-	struct mt7530_priv *priv = pcs_to_mt753x_pcs(pcs)->priv;
-	int port = pcs_to_mt753x_pcs(pcs)->port;
-	u32 val;
-
-	/* Only restart AN when AN is enabled */
-	val = mt7530_read(priv, MT7531_PCS_CONTROL_1(port));
-	if (val & MT7531_SGMII_AN_ENABLE) {
-		val |= MT7531_SGMII_AN_RESTART;
-		mt7530_write(priv, MT7531_PCS_CONTROL_1(port), val);
-	}
-}
-
 static int
 mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		  phy_interface_t interface)
@@ -2699,11 +2583,11 @@ mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		phydev = dp->slave->phydev;
 		return mt7531_rgmii_setup(priv, port, interface, phydev);
 	case PHY_INTERFACE_MODE_SGMII:
-		return mt7531_sgmii_setup_mode_an(priv, port, interface);
 	case PHY_INTERFACE_MODE_NA:
 	case PHY_INTERFACE_MODE_1000BASEX:
 	case PHY_INTERFACE_MODE_2500BASEX:
-		return mt7531_sgmii_setup_mode_force(priv, port, interface);
+		/* handled in SGMII PCS driver */
+		return 0;
 	default:
 		return -EINVAL;
 	}
@@ -2728,11 +2612,14 @@ mt753x_phylink_mac_select_pcs(struct dsa_switch *ds, int port,
 
 	switch (interface) {
 	case PHY_INTERFACE_MODE_TRGMII:
+		return &priv->pcs[port].pcs;
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_1000BASEX:
 	case PHY_INTERFACE_MODE_2500BASEX:
-		return &priv->pcs[port].pcs;
+		if (!mt753x_is_mac_port(port))
+			return ERR_PTR(-EINVAL);
 
+		return priv->sgmii_pcs[port - 5];
 	default:
 		return NULL;
 	}
@@ -2970,86 +2857,6 @@ static void mt7530_pcs_get_state(struct phylink_pcs *pcs,
 		state->pause |= MLO_PAUSE_TX;
 }
 
-static int
-mt7531_sgmii_pcs_get_state_an(struct mt7530_priv *priv, int port,
-			      struct phylink_link_state *state)
-{
-	u32 status, val;
-	u16 config_reg;
-
-	status = mt7530_read(priv, MT7531_PCS_CONTROL_1(port));
-	state->link = !!(status & MT7531_SGMII_LINK_STATUS);
-	state->an_complete = !!(status & MT7531_SGMII_AN_COMPLETE);
-	if (state->interface == PHY_INTERFACE_MODE_SGMII &&
-	    (status & MT7531_SGMII_AN_ENABLE)) {
-		val = mt7530_read(priv, MT7531_PCS_SPEED_ABILITY(port));
-		config_reg = val >> 16;
-
-		switch (config_reg & LPA_SGMII_SPD_MASK) {
-		case LPA_SGMII_1000:
-			state->speed = SPEED_1000;
-			break;
-		case LPA_SGMII_100:
-			state->speed = SPEED_100;
-			break;
-		case LPA_SGMII_10:
-			state->speed = SPEED_10;
-			break;
-		default:
-			dev_err(priv->dev, "invalid sgmii PHY speed\n");
-			state->link = false;
-			return -EINVAL;
-		}
-
-		if (config_reg & LPA_SGMII_FULL_DUPLEX)
-			state->duplex = DUPLEX_FULL;
-		else
-			state->duplex = DUPLEX_HALF;
-	}
-
-	return 0;
-}
-
-static void
-mt7531_sgmii_pcs_get_state_inband(struct mt7530_priv *priv, int port,
-				  struct phylink_link_state *state)
-{
-	unsigned int val;
-
-	val = mt7530_read(priv, MT7531_PCS_CONTROL_1(port));
-	state->link = !!(val & MT7531_SGMII_LINK_STATUS);
-	if (!state->link)
-		return;
-
-	state->an_complete = state->link;
-
-	if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
-		state->speed = SPEED_2500;
-	else
-		state->speed = SPEED_1000;
-
-	state->duplex = DUPLEX_FULL;
-	state->pause = MLO_PAUSE_NONE;
-}
-
-static void mt7531_pcs_get_state(struct phylink_pcs *pcs,
-				 struct phylink_link_state *state)
-{
-	struct mt7530_priv *priv = pcs_to_mt753x_pcs(pcs)->priv;
-	int port = pcs_to_mt753x_pcs(pcs)->port;
-
-	if (state->interface == PHY_INTERFACE_MODE_SGMII) {
-		mt7531_sgmii_pcs_get_state_an(priv, port, state);
-		return;
-	} else if ((state->interface == PHY_INTERFACE_MODE_1000BASEX) ||
-		   (state->interface == PHY_INTERFACE_MODE_2500BASEX)) {
-		mt7531_sgmii_pcs_get_state_inband(priv, port, state);
-		return;
-	}
-
-	state->link = false;
-}
-
 static int mt753x_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			     phy_interface_t interface,
 			     const unsigned long *advertising,
@@ -3069,18 +2876,57 @@ static const struct phylink_pcs_ops mt7530_pcs_ops = {
 	.pcs_an_restart = mt7530_pcs_an_restart,
 };
 
-static const struct phylink_pcs_ops mt7531_pcs_ops = {
-	.pcs_validate = mt753x_pcs_validate,
-	.pcs_get_state = mt7531_pcs_get_state,
-	.pcs_config = mt753x_pcs_config,
-	.pcs_an_restart = mt7531_pcs_an_restart,
-	.pcs_link_up = mt7531_pcs_link_up,
+static int mt7530_regmap_read(void *context, unsigned int reg, unsigned int *val)
+{
+	struct mt7530_priv *priv = context;
+
+	*val = mt7530_read(priv, reg);
+	return 0;
+};
+
+static int mt7530_regmap_write(void *context, unsigned int reg, unsigned int val)
+{
+	struct mt7530_priv *priv = context;
+
+	mt7530_write(priv, reg, val);
+	return 0;
+};
+
+static int mt7530_regmap_update_bits(void *context, unsigned int reg,
+				     unsigned int mask, unsigned int val)
+{
+	struct mt7530_priv *priv = context;
+
+	mt7530_rmw(priv, reg, mask, val);
+	return 0;
+};
+
+static const struct regmap_bus mt7531_regmap_bus = {
+	.reg_write = mt7530_regmap_write,
+	.reg_read = mt7530_regmap_read,
+	.reg_update_bits = mt7530_regmap_update_bits,
+};
+
+#define MT7531_PCS_REGMAP_CONFIG(_name, _reg_base) \
+	{				\
+		.name = _name,		\
+		.reg_bits = 16,		\
+		.val_bits = 32,		\
+		.reg_stride = 4,	\
+		.reg_base = _reg_base,	\
+		.max_register = 0x17c,	\
+	}
+
+static const struct regmap_config mt7531_pcs_config[] = {
+	MT7531_PCS_REGMAP_CONFIG("port5", MT7531_SGMII_REG_BASE(5)),
+	MT7531_PCS_REGMAP_CONFIG("port6", MT7531_SGMII_REG_BASE(6)),
 };
 
 static int
 mt753x_setup(struct dsa_switch *ds)
 {
 	struct mt7530_priv *priv = ds->priv;
+	struct regmap *regmap;
 	int i, ret;
 
 	/* Initialise the PCS devices */
@@ -3088,8 +2934,6 @@ mt753x_setup(struct dsa_switch *ds)
 		priv->pcs[i].pcs.ops = priv->info->pcs_ops;
 		priv->pcs[i].priv = priv;
 		priv->pcs[i].port = i;
-		if (mt753x_is_mac_port(i))
-			priv->pcs[i].pcs.poll = 1;
 	}
 
 	ret = priv->info->sw_setup(ds);
@@ -3104,6 +2948,15 @@ mt753x_setup(struct dsa_switch *ds)
 	if (ret && priv->irq)
 		mt7530_free_irq_common(priv);
 
+	if (priv->id == ID_MT7531)
+		for (i = 0; i < 2; ++i) {
+			regmap = devm_regmap_init(ds->dev,
+						  &mt7531_regmap_bus, priv,
+						  &mt7531_pcs_config[i]);
+			priv->sgmii_pcs[i] = mtk_pcs_create(ds->dev, regmap,
+							    0x128, 0);
+		}
+
 	return ret;
 }
 
@@ -3199,7 +3052,7 @@ static const struct mt753x_info mt753x_table[] = {
 	},
 	[ID_MT7531] = {
 		.id = ID_MT7531,
-		.pcs_ops = &mt7531_pcs_ops,
+		.pcs_ops = &mt7530_pcs_ops,
 		.sw_setup = mt7531_setup,
 		.phy_read_c22 = mt7531_ind_c22_phy_read,
 		.phy_write_c22 = mt7531_ind_c22_phy_write,
@@ -3309,7 +3162,7 @@ static void
 mt7530_remove(struct mdio_device *mdiodev)
 {
 	struct mt7530_priv *priv = dev_get_drvdata(&mdiodev->dev);
-	int ret = 0;
+	int ret = 0, i;
 
 	if (!priv)
 		return;
@@ -3328,6 +3181,11 @@ mt7530_remove(struct mdio_device *mdiodev)
 		mt7530_free_irq(priv);
 
 	dsa_unregister_switch(priv->ds);
+
+	for (i = 0; i < 2; ++i)
+		if (priv->sgmii_pcs[i])
+			mtk_pcs_destroy(priv->sgmii_pcs[i]);
+
 	mutex_destroy(&priv->reg_mutex);
 }
 
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 6b2fc6290ea8..dedbd707634a 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -364,47 +364,7 @@ enum mt7530_vlan_port_acc_frm {
 					 CCR_TX_OCT_CNT_BAD)
 
 /* MT7531 SGMII register group */
-#define MT7531_SGMII_REG_BASE		0x5000
-#define MT7531_SGMII_REG(p, r)		(MT7531_SGMII_REG_BASE + \
-					((p) - 5) * 0x1000 + (r))
-
-/* Register forSGMII PCS_CONTROL_1 */
-#define MT7531_PCS_CONTROL_1(p)		MT7531_SGMII_REG(p, 0x00)
-#define  MT7531_SGMII_LINK_STATUS	BIT(18)
-#define  MT7531_SGMII_AN_ENABLE		BIT(12)
-#define  MT7531_SGMII_AN_RESTART	BIT(9)
-#define  MT7531_SGMII_AN_COMPLETE	BIT(21)
-
-/* Register for SGMII PCS_SPPED_ABILITY */
-#define MT7531_PCS_SPEED_ABILITY(p)	MT7531_SGMII_REG(p, 0x08)
-#define  MT7531_SGMII_TX_CONFIG_MASK	GENMASK(15, 0)
-#define  MT7531_SGMII_TX_CONFIG		BIT(0)
-
-/* Register for SGMII_MODE */
-#define MT7531_SGMII_MODE(p)		MT7531_SGMII_REG(p, 0x20)
-#define  MT7531_SGMII_REMOTE_FAULT_DIS	BIT(8)
-#define  MT7531_SGMII_IF_MODE_MASK	GENMASK(5, 1)
-#define  MT7531_SGMII_FORCE_DUPLEX	BIT(4)
-#define  MT7531_SGMII_FORCE_SPEED_MASK	GENMASK(3, 2)
-#define  MT7531_SGMII_FORCE_SPEED_1000	BIT(3)
-#define  MT7531_SGMII_FORCE_SPEED_100	BIT(2)
-#define  MT7531_SGMII_FORCE_SPEED_10	0
-#define  MT7531_SGMII_SPEED_DUPLEX_AN	BIT(1)
-
-enum mt7531_sgmii_force_duplex {
-	MT7531_SGMII_FORCE_FULL_DUPLEX = 0,
-	MT7531_SGMII_FORCE_HALF_DUPLEX = 0x10,
-};
-
-/* Fields of QPHY_PWR_STATE_CTRL */
-#define MT7531_QPHY_PWR_STATE_CTRL(p)	MT7531_SGMII_REG(p, 0xe8)
-#define  MT7531_SGMII_PHYA_PWD		BIT(4)
-
-/* Values of SGMII SPEED */
-#define MT7531_PHYA_CTRL_SIGNAL3(p)	MT7531_SGMII_REG(p, 0x128)
-#define  MT7531_RG_TPHY_SPEED_MASK	(BIT(2) | BIT(3))
-#define  MT7531_RG_TPHY_SPEED_1_25G	0x0
-#define  MT7531_RG_TPHY_SPEED_3_125G	BIT(2)
+#define MT7531_SGMII_REG_BASE(p)	(0x5000 + ((p) - 5) * 0x1000)
 
 /* Register for system reset */
 #define MT7530_SYS_CTRL			0x7000
@@ -828,6 +788,7 @@ struct mt7530_priv {
 
 	struct mt7530_port	ports[MT7530_NUM_PORTS];
 	struct mt753x_pcs	pcs[MT7530_NUM_PORTS];
+	struct phylink_pcs	*sgmii_pcs[2];
 	/* protect among processes for registers access*/
 	struct mutex reg_mutex;
 	int irq;
-- 
2.39.1

