Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26916CCCF7
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 00:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjC1WRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 18:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjC1WRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 18:17:15 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7AE271C;
        Tue, 28 Mar 2023 15:17:00 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phHcg-0003at-0P;
        Wed, 29 Mar 2023 00:16:58 +0200
Date:   Tue, 28 Mar 2023 23:16:51 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: [RFC PATCH net-next v2 1/2] net: dsa: mt7530: split-off MDIO driver
Message-ID: <4acd93e451146cee593c1b91b74ee72319c63833.1680041193.git.daniel@makrotopia.org>
References: <cover.1680041193.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1680041193.git.daniel@makrotopia.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support the built-in switch of some MediaTek SoCs we need
to use MMIO instead of MDIO to access the switch.
Prepare this be splitting-off the part of the driver registering an
MDIO driver, so we can add another module acting as MMIO/platform driver.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/Kconfig       |   8 +-
 drivers/net/dsa/Makefile      |   3 +-
 drivers/net/dsa/mt7530-mdio.c | 309 ++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.c      | 286 ++++---------------------------
 drivers/net/dsa/mt7530.h      |  24 +--
 5 files changed, 356 insertions(+), 274 deletions(-)
 create mode 100644 drivers/net/dsa/mt7530-mdio.c

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 6b45fa8b69078..0d9d605b3882c 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -35,9 +35,15 @@ config NET_DSA_LANTIQ_GSWIP
 	  the xrx200 / VR9 SoC.
 
 config NET_DSA_MT7530
-	tristate "MediaTek MT7530 and MT7531 Ethernet switch support"
+	tristate "MediaTek Ethernet switch support"
 	select NET_DSA_TAG_MTK
 	select MEDIATEK_GE_PHY
+	help
+	  This enables support for the MediaTek Ethernet switch chips.
+
+config NET_DSA_MT7530_MDIO
+	tristate "MediaTek MT7530 and MT7531 Ethernet switch support"
+	select NET_DSA_MT7530
 	select PCS_MTK_LYNXI
 	help
 	  This enables support for the MediaTek MT7530 and MT7531 Ethernet
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index 16eb879e0cb4d..2b072d574ed02 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -6,7 +6,8 @@ ifdef CONFIG_NET_DSA_LOOP
 obj-$(CONFIG_FIXED_PHY)		+= dsa_loop_bdinfo.o
 endif
 obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
-obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530.o
+obj-$(CONFIG_NET_DSA_MT7530)		+= mt7530.o
+obj-$(CONFIG_NET_DSA_MT7530_MDIO)	+= mt7530-mdio.o
 obj-$(CONFIG_NET_DSA_MV88E6060) += mv88e6060.o
 obj-$(CONFIG_NET_DSA_RZN1_A5PSW) += rzn1_a5psw.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
diff --git a/drivers/net/dsa/mt7530-mdio.c b/drivers/net/dsa/mt7530-mdio.c
new file mode 100644
index 0000000000000..203dc28697204
--- /dev/null
+++ b/drivers/net/dsa/mt7530-mdio.c
@@ -0,0 +1,309 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/gpio/consumer.h>
+#include <linux/mdio.h>
+#include <linux/module.h>
+#include <linux/pcs/pcs-mtk-lynxi.h>
+#include <linux/of_irq.h>
+#include <linux/of_mdio.h>
+#include <linux/of_net.h>
+#include <linux/of_platform.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/reset.h>
+#include <net/dsa.h>
+
+#include "mt7530.h"
+
+static const struct of_device_id mt7530_of_match[] = {
+	{ .compatible = "mediatek,mt7621", .data = &mt753x_table[ID_MT7621], },
+	{ .compatible = "mediatek,mt7530", .data = &mt753x_table[ID_MT7530], },
+	{ .compatible = "mediatek,mt7531", .data = &mt753x_table[ID_MT7531], },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, mt7530_of_match);
+
+static int mt7530_regmap_read(void *context, unsigned int reg, unsigned int *val)
+{
+	struct mii_bus *bus = context;
+	u16 page, r, lo, hi;
+	int ret;
+
+	page = (reg >> 6) & 0x3ff;
+	r = (reg >> 2) & 0xf;
+
+	/* MT7530 uses 31 as the pseudo port */
+	ret = bus->write(bus, 0x1f, 0x1f, page);
+	if (ret < 0) {
+		dev_err(&bus->dev,
+			"failed to read mt7530 register\n");
+		return ret;
+	}
+
+	lo = bus->read(bus, 0x1f, r);
+	hi = bus->read(bus, 0x1f, 0x10);
+
+	*val = (hi << 16) | (lo & 0xffff);
+
+	return 0;
+};
+
+static int mt7530_regmap_write(void *context, unsigned int reg, unsigned int val)
+{
+	struct mii_bus *bus = context;
+	u16 page, r, lo, hi;
+	int ret;
+
+	page = (reg >> 6) & 0x3ff;
+	r  = (reg >> 2) & 0xf;
+	lo = val & 0xffff;
+	hi = val >> 16;
+
+	/* MT7530 uses 31 as the pseudo port */
+	ret = bus->write(bus, 0x1f, 0x1f, page);
+	if (ret < 0)
+		goto err;
+
+	ret = bus->write(bus, 0x1f, r,  lo);
+	if (ret < 0)
+		goto err;
+
+	ret = bus->write(bus, 0x1f, 0x10, hi);
+err:
+	if (ret < 0)
+		dev_err(&bus->dev,
+			"failed to write mt7530 register\n");
+	return ret;
+};
+
+static const struct regmap_bus mt7530_mdio_regmap_bus = {
+	.reg_write = mt7530_regmap_write,
+	.reg_read = mt7530_regmap_read,
+};
+
+static void
+mt7530_mdio_regmap_lock(void *mdio_lock)
+{
+	mutex_lock_nested(mdio_lock, MDIO_MUTEX_NESTED);
+}
+
+static void
+mt7530_mdio_regmap_unlock(void *mdio_lock)
+{
+	mutex_unlock(mdio_lock);
+}
+
+static int
+mt7531_create_sgmii(struct mt7530_priv *priv)
+{
+	struct regmap_config *mt7531_pcs_config[2];
+	struct phylink_pcs *pcs;
+	struct regmap *regmap;
+	int i, ret = 0;
+
+	for (i = 0; i < 2; i++) {
+		mt7531_pcs_config[i] = devm_kzalloc(priv->dev,
+						    sizeof(struct regmap_config),
+						    GFP_KERNEL);
+		if (!mt7531_pcs_config[i]) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		mt7531_pcs_config[i]->name = i ? "port6" : "port5";
+		mt7531_pcs_config[i]->reg_bits = 16;
+		mt7531_pcs_config[i]->val_bits = 32;
+		mt7531_pcs_config[i]->reg_stride = 4;
+		mt7531_pcs_config[i]->reg_base = MT7531_SGMII_REG_BASE(5 + i);
+		mt7531_pcs_config[i]->max_register = 0x17c;
+		mt7531_pcs_config[i]->lock = mt7530_mdio_regmap_lock;
+		mt7531_pcs_config[i]->unlock = mt7530_mdio_regmap_unlock;
+		mt7531_pcs_config[i]->lock_arg = &priv->bus->mdio_lock;
+
+		regmap = devm_regmap_init(priv->dev,
+					  &mt7530_mdio_regmap_bus, priv->bus,
+					  mt7531_pcs_config[i]);
+		if (IS_ERR(regmap)) {
+			ret = PTR_ERR(regmap);
+			break;
+		}
+		pcs = mtk_pcs_lynxi_create(priv->dev, regmap,
+					   MT7531_PHYA_CTRL_SIGNAL3, 0);
+		if (!pcs) {
+			ret = -ENXIO;
+			break;
+		}
+		priv->ports[5 + i].sgmii_pcs = pcs;
+	}
+
+	if (ret && i)
+		mtk_pcs_lynxi_destroy(priv->ports[5].sgmii_pcs);
+
+	return ret;
+}
+
+static int
+mt7530_probe(struct mdio_device *mdiodev)
+{
+	static struct regmap_config *sw_regmap_config;
+	struct mt7530_priv *priv;
+	struct device_node *dn;
+	int ret;
+
+	dn = mdiodev->dev.of_node;
+
+	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
+	if (!priv->ds)
+		return -ENOMEM;
+
+	priv->ds->dev = &mdiodev->dev;
+	priv->ds->num_ports = MT7530_NUM_PORTS;
+
+	/* Use medatek,mcm property to distinguish hardware type that would
+	 * casues a little bit differences on power-on sequence.
+	 */
+	priv->mcm = of_property_read_bool(dn, "mediatek,mcm");
+	if (priv->mcm) {
+		dev_info(&mdiodev->dev, "MT7530 adapts as multi-chip module\n");
+
+		priv->rstc = devm_reset_control_get(&mdiodev->dev, "mcm");
+		if (IS_ERR(priv->rstc)) {
+			dev_err(&mdiodev->dev, "Couldn't get our reset line\n");
+			return PTR_ERR(priv->rstc);
+		}
+	}
+
+	/* Get the hardware identifier from the devicetree node.
+	 * We will need it for some of the clock and regulator setup.
+	 */
+	priv->info = of_device_get_match_data(&mdiodev->dev);
+	if (!priv->info)
+		return -EINVAL;
+
+	/* Sanity check if these required device operations are filled
+	 * properly.
+	 */
+	if (!priv->info->sw_setup || !priv->info->pad_setup ||
+	    !priv->info->phy_read_c22 || !priv->info->phy_write_c22 ||
+	    !priv->info->mac_port_get_caps ||
+	    !priv->info->mac_port_config)
+		return -EINVAL;
+
+	priv->id = priv->info->id;
+
+	if (priv->id == ID_MT7530) {
+		priv->core_pwr = devm_regulator_get(&mdiodev->dev, "core");
+		if (IS_ERR(priv->core_pwr))
+			return PTR_ERR(priv->core_pwr);
+
+		priv->io_pwr = devm_regulator_get(&mdiodev->dev, "io");
+		if (IS_ERR(priv->io_pwr))
+			return PTR_ERR(priv->io_pwr);
+	}
+
+	/* Not MCM that indicates switch works as the remote standalone
+	 * integrated circuit so the GPIO pin would be used to complete
+	 * the reset, otherwise memory-mapped register accessing used
+	 * through syscon provides in the case of MCM.
+	 */
+	if (!priv->mcm) {
+		priv->reset = devm_gpiod_get_optional(&mdiodev->dev, "reset",
+						      GPIOD_OUT_LOW);
+		if (IS_ERR(priv->reset)) {
+			dev_err(&mdiodev->dev, "Couldn't get our reset line\n");
+			return PTR_ERR(priv->reset);
+		}
+	}
+
+	priv->bus = mdiodev->bus;
+	priv->dev = &mdiodev->dev;
+	priv->ds->priv = priv;
+	priv->ds->ops = &mt7530_switch_ops;
+	mutex_init(&priv->reg_mutex);
+	dev_set_drvdata(&mdiodev->dev, priv);
+
+	sw_regmap_config = devm_kzalloc(&mdiodev->dev, sizeof(*sw_regmap_config), GFP_KERNEL);
+	if (!sw_regmap_config)
+		return -ENOMEM;
+
+	sw_regmap_config->name = "switch";
+	sw_regmap_config->reg_bits = 16;
+	sw_regmap_config->val_bits = 32;
+	sw_regmap_config->reg_stride = 4;
+	sw_regmap_config->reg_base = 0x0;
+	sw_regmap_config->max_register = 0x7ffc;
+	sw_regmap_config->disable_locking = true;
+	priv->regmap = devm_regmap_init(priv->dev, &mt7530_mdio_regmap_bus,
+					priv->bus, sw_regmap_config);
+	if (IS_ERR(priv->regmap))
+		return PTR_ERR(priv->regmap);
+
+	if (priv->id == ID_MT7531) {
+		ret = mt7531_create_sgmii(priv);
+		if (ret)
+			return ret;
+	}
+
+	return dsa_register_switch(priv->ds);
+}
+
+static void
+mt7530_remove(struct mdio_device *mdiodev)
+{
+	struct mt7530_priv *priv = dev_get_drvdata(&mdiodev->dev);
+	int ret = 0, i;
+
+	if (!priv)
+		return;
+
+	ret = regulator_disable(priv->core_pwr);
+	if (ret < 0)
+		dev_err(priv->dev,
+			"Failed to disable core power: %d\n", ret);
+
+	ret = regulator_disable(priv->io_pwr);
+	if (ret < 0)
+		dev_err(priv->dev, "Failed to disable io pwr: %d\n",
+			ret);
+
+	if (priv->irq)
+		mt7530_free_irq(priv);
+
+	dsa_unregister_switch(priv->ds);
+
+	for (i = 0; i < 2; ++i)
+		mtk_pcs_lynxi_destroy(priv->ports[5 + i].sgmii_pcs);
+
+	mutex_destroy(&priv->reg_mutex);
+}
+
+static void mt7530_shutdown(struct mdio_device *mdiodev)
+{
+	struct mt7530_priv *priv = dev_get_drvdata(&mdiodev->dev);
+
+	if (!priv)
+		return;
+
+	dsa_switch_shutdown(priv->ds);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
+}
+
+static struct mdio_driver mt7530_mdio_driver = {
+	.probe  = mt7530_probe,
+	.remove = mt7530_remove,
+	.shutdown = mt7530_shutdown,
+	.mdiodrv.driver = {
+		.name = "mt7530",
+		.of_match_table = mt7530_of_match,
+	},
+};
+mdio_module_driver(mt7530_mdio_driver);
+
+MODULE_AUTHOR("Sean Wang <sean.wang@mediatek.com>");
+MODULE_DESCRIPTION("Driver for Mediatek MT7530 Switch (MDIO)");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a0d99af897ace..ca379f4d3cd32 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -14,7 +14,6 @@
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/of_platform.h>
-#include <linux/pcs/pcs-mtk-lynxi.h>
 #include <linux/phylink.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
@@ -185,54 +184,20 @@ core_clear(struct mt7530_priv *priv, u32 reg, u32 val)
 static int
 mt7530_mii_write(struct mt7530_priv *priv, u32 reg, u32 val)
 {
-	struct mii_bus *bus = priv->bus;
-	u16 page, r, lo, hi;
-	int ret;
-
-	page = (reg >> 6) & 0x3ff;
-	r  = (reg >> 2) & 0xf;
-	lo = val & 0xffff;
-	hi = val >> 16;
-
-	/* MT7530 uses 31 as the pseudo port */
-	ret = bus->write(bus, 0x1f, 0x1f, page);
-	if (ret < 0)
-		goto err;
-
-	ret = bus->write(bus, 0x1f, r,  lo);
-	if (ret < 0)
-		goto err;
-
-	ret = bus->write(bus, 0x1f, 0x10, hi);
-err:
-	if (ret < 0)
-		dev_err(&bus->dev,
-			"failed to write mt7530 register\n");
-	return ret;
+	return regmap_write(priv->regmap, reg, val);
 }
 
 static u32
 mt7530_mii_read(struct mt7530_priv *priv, u32 reg)
 {
-	struct mii_bus *bus = priv->bus;
-	u16 page, r, lo, hi;
+	u32 val;
 	int ret;
 
-	page = (reg >> 6) & 0x3ff;
-	r = (reg >> 2) & 0xf;
-
-	/* MT7530 uses 31 as the pseudo port */
-	ret = bus->write(bus, 0x1f, 0x1f, page);
-	if (ret < 0) {
-		dev_err(&bus->dev,
-			"failed to read mt7530 register\n");
+	ret = regmap_read(priv->regmap, reg, &val);
+	if (!ret)
+		return val;
+	else
 		return ret;
-	}
-
-	lo = bus->read(bus, 0x1f, r);
-	hi = bus->read(bus, 0x1f, 0x10);
-
-	return (hi << 16) | (lo & 0xffff);
 }
 
 static void
@@ -282,14 +247,10 @@ mt7530_rmw(struct mt7530_priv *priv, u32 reg,
 	   u32 mask, u32 set)
 {
 	struct mii_bus *bus = priv->bus;
-	u32 val;
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	val = mt7530_mii_read(priv, reg);
-	val &= ~mask;
-	val |= set;
-	mt7530_mii_write(priv, reg, val);
+	regmap_update_bits(priv->regmap, reg, mask, set);
 
 	mutex_unlock(&bus->mdio_lock);
 }
@@ -297,7 +258,7 @@ mt7530_rmw(struct mt7530_priv *priv, u32 reg,
 static void
 mt7530_set(struct mt7530_priv *priv, u32 reg, u32 val)
 {
-	mt7530_rmw(priv, reg, 0, val);
+	mt7530_rmw(priv, reg, val, val);
 }
 
 static void
@@ -921,6 +882,24 @@ mt7530_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
 	return 0;
 }
 
+static const char *p5_intf_modes(unsigned int p5_interface)
+{
+	switch (p5_interface) {
+	case P5_DISABLED:
+		return "DISABLED";
+	case P5_INTF_SEL_PHY_P0:
+		return "PHY P0";
+	case P5_INTF_SEL_PHY_P4:
+		return "PHY P4";
+	case P5_INTF_SEL_GMAC5:
+		return "GMAC5";
+	case P5_INTF_SEL_GMAC5_SGMII:
+		return "GMAC5_SGMII";
+	default:
+		return "unknown";
+	}
+}
+
 static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
@@ -2067,12 +2046,13 @@ mt7530_free_irq_common(struct mt7530_priv *priv)
 	irq_domain_remove(priv->irq_domain);
 }
 
-static void
+void
 mt7530_free_irq(struct mt7530_priv *priv)
 {
 	mt7530_free_mdio_irq(priv);
 	mt7530_free_irq_common(priv);
 }
+EXPORT_SYMBOL_GPL(mt7530_free_irq);
 
 static int
 mt7530_setup_mdio(struct mt7530_priv *priv)
@@ -2895,57 +2875,10 @@ static const struct phylink_pcs_ops mt7530_pcs_ops = {
 	.pcs_an_restart = mt7530_pcs_an_restart,
 };
 
-static int mt7530_regmap_read(void *context, unsigned int reg, unsigned int *val)
-{
-	struct mt7530_priv *priv = context;
-
-	*val = mt7530_read(priv, reg);
-	return 0;
-};
-
-static int mt7530_regmap_write(void *context, unsigned int reg, unsigned int val)
-{
-	struct mt7530_priv *priv = context;
-
-	mt7530_write(priv, reg, val);
-	return 0;
-};
-
-static int mt7530_regmap_update_bits(void *context, unsigned int reg,
-				     unsigned int mask, unsigned int val)
-{
-	struct mt7530_priv *priv = context;
-
-	mt7530_rmw(priv, reg, mask, val);
-	return 0;
-};
-
-static const struct regmap_bus mt7531_regmap_bus = {
-	.reg_write = mt7530_regmap_write,
-	.reg_read = mt7530_regmap_read,
-	.reg_update_bits = mt7530_regmap_update_bits,
-};
-
-#define MT7531_PCS_REGMAP_CONFIG(_name, _reg_base) \
-	{				\
-		.name = _name,		\
-		.reg_bits = 16,		\
-		.val_bits = 32,		\
-		.reg_stride = 4,	\
-		.reg_base = _reg_base,	\
-		.max_register = 0x17c,	\
-	}
-
-static const struct regmap_config mt7531_pcs_config[] = {
-	MT7531_PCS_REGMAP_CONFIG("port5", MT7531_SGMII_REG_BASE(5)),
-	MT7531_PCS_REGMAP_CONFIG("port6", MT7531_SGMII_REG_BASE(6)),
-};
-
 static int
 mt753x_setup(struct dsa_switch *ds)
 {
 	struct mt7530_priv *priv = ds->priv;
-	struct regmap *regmap;
 	int i, ret;
 
 	/* Initialise the PCS devices */
@@ -2967,16 +2900,6 @@ mt753x_setup(struct dsa_switch *ds)
 	if (ret && priv->irq)
 		mt7530_free_irq_common(priv);
 
-	if (priv->id == ID_MT7531)
-		for (i = 0; i < 2; i++) {
-			regmap = devm_regmap_init(ds->dev,
-						  &mt7531_regmap_bus, priv,
-						  &mt7531_pcs_config[i]);
-			priv->ports[5 + i].sgmii_pcs =
-				mtk_pcs_lynxi_create(ds->dev, regmap,
-						     MT7531_PHYA_CTRL_SIGNAL3, 0);
-		}
-
 	return ret;
 }
 
@@ -3010,7 +2933,7 @@ static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static const struct dsa_switch_ops mt7530_switch_ops = {
+const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_tag_protocol	= mtk_get_tag_protocol,
 	.setup			= mt753x_setup,
 	.get_strings		= mt7530_get_strings,
@@ -3044,8 +2967,9 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_mac_eee		= mt753x_get_mac_eee,
 	.set_mac_eee		= mt753x_set_mac_eee,
 };
+EXPORT_SYMBOL_GPL(mt7530_switch_ops);
 
-static const struct mt753x_info mt753x_table[] = {
+const struct mt753x_info mt753x_table[] = {
 	[ID_MT7621] = {
 		.id = ID_MT7621,
 		.pcs_ops = &mt7530_pcs_ops,
@@ -3084,153 +3008,7 @@ static const struct mt753x_info mt753x_table[] = {
 		.mac_port_config = mt7531_mac_config,
 	},
 };
-
-static const struct of_device_id mt7530_of_match[] = {
-	{ .compatible = "mediatek,mt7621", .data = &mt753x_table[ID_MT7621], },
-	{ .compatible = "mediatek,mt7530", .data = &mt753x_table[ID_MT7530], },
-	{ .compatible = "mediatek,mt7531", .data = &mt753x_table[ID_MT7531], },
-	{ /* sentinel */ },
-};
-MODULE_DEVICE_TABLE(of, mt7530_of_match);
-
-static int
-mt7530_probe(struct mdio_device *mdiodev)
-{
-	struct mt7530_priv *priv;
-	struct device_node *dn;
-
-	dn = mdiodev->dev.of_node;
-
-	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
-	if (!priv->ds)
-		return -ENOMEM;
-
-	priv->ds->dev = &mdiodev->dev;
-	priv->ds->num_ports = MT7530_NUM_PORTS;
-
-	/* Use medatek,mcm property to distinguish hardware type that would
-	 * casues a little bit differences on power-on sequence.
-	 */
-	priv->mcm = of_property_read_bool(dn, "mediatek,mcm");
-	if (priv->mcm) {
-		dev_info(&mdiodev->dev, "MT7530 adapts as multi-chip module\n");
-
-		priv->rstc = devm_reset_control_get(&mdiodev->dev, "mcm");
-		if (IS_ERR(priv->rstc)) {
-			dev_err(&mdiodev->dev, "Couldn't get our reset line\n");
-			return PTR_ERR(priv->rstc);
-		}
-	}
-
-	/* Get the hardware identifier from the devicetree node.
-	 * We will need it for some of the clock and regulator setup.
-	 */
-	priv->info = of_device_get_match_data(&mdiodev->dev);
-	if (!priv->info)
-		return -EINVAL;
-
-	/* Sanity check if these required device operations are filled
-	 * properly.
-	 */
-	if (!priv->info->sw_setup || !priv->info->pad_setup ||
-	    !priv->info->phy_read_c22 || !priv->info->phy_write_c22 ||
-	    !priv->info->mac_port_get_caps ||
-	    !priv->info->mac_port_config)
-		return -EINVAL;
-
-	priv->id = priv->info->id;
-
-	if (priv->id == ID_MT7530) {
-		priv->core_pwr = devm_regulator_get(&mdiodev->dev, "core");
-		if (IS_ERR(priv->core_pwr))
-			return PTR_ERR(priv->core_pwr);
-
-		priv->io_pwr = devm_regulator_get(&mdiodev->dev, "io");
-		if (IS_ERR(priv->io_pwr))
-			return PTR_ERR(priv->io_pwr);
-	}
-
-	/* Not MCM that indicates switch works as the remote standalone
-	 * integrated circuit so the GPIO pin would be used to complete
-	 * the reset, otherwise memory-mapped register accessing used
-	 * through syscon provides in the case of MCM.
-	 */
-	if (!priv->mcm) {
-		priv->reset = devm_gpiod_get_optional(&mdiodev->dev, "reset",
-						      GPIOD_OUT_LOW);
-		if (IS_ERR(priv->reset)) {
-			dev_err(&mdiodev->dev, "Couldn't get our reset line\n");
-			return PTR_ERR(priv->reset);
-		}
-	}
-
-	priv->bus = mdiodev->bus;
-	priv->dev = &mdiodev->dev;
-	priv->ds->priv = priv;
-	priv->ds->ops = &mt7530_switch_ops;
-	mutex_init(&priv->reg_mutex);
-	dev_set_drvdata(&mdiodev->dev, priv);
-
-	return dsa_register_switch(priv->ds);
-}
-
-static void
-mt7530_remove(struct mdio_device *mdiodev)
-{
-	struct mt7530_priv *priv = dev_get_drvdata(&mdiodev->dev);
-	int ret = 0, i;
-
-	if (!priv)
-		return;
-
-	ret = regulator_disable(priv->core_pwr);
-	if (ret < 0)
-		dev_err(priv->dev,
-			"Failed to disable core power: %d\n", ret);
-
-	ret = regulator_disable(priv->io_pwr);
-	if (ret < 0)
-		dev_err(priv->dev, "Failed to disable io pwr: %d\n",
-			ret);
-
-	if (priv->irq)
-		mt7530_free_irq(priv);
-
-	dsa_unregister_switch(priv->ds);
-
-	for (i = 0; i < 2; ++i)
-		mtk_pcs_lynxi_destroy(priv->ports[5 + i].sgmii_pcs);
-
-	mutex_destroy(&priv->reg_mutex);
-}
-
-static void mt7530_shutdown(struct mdio_device *mdiodev)
-{
-	struct mt7530_priv *priv = dev_get_drvdata(&mdiodev->dev);
-
-	if (!priv)
-		return;
-
-	dsa_switch_shutdown(priv->ds);
-
-	dev_set_drvdata(&mdiodev->dev, NULL);
-}
-
-static struct mdio_driver mt7530_mdio_driver = {
-	.probe  = mt7530_probe,
-	.remove = mt7530_remove,
-	.shutdown = mt7530_shutdown,
-	.mdiodrv.driver = {
-		.name = "mt7530",
-		.of_match_table = mt7530_of_match,
-	},
-};
-
-mdio_module_driver(mt7530_mdio_driver);
+EXPORT_SYMBOL_GPL(mt753x_table);
 
 MODULE_AUTHOR("Sean Wang <sean.wang@mediatek.com>");
 MODULE_DESCRIPTION("Driver for Mediatek MT7530 Switch");
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index c5d29f3fc1d80..6ac7f503dce2f 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -682,24 +682,6 @@ enum p5_interface_select {
 	P5_INTF_SEL_GMAC5_SGMII,
 };
 
-static const char *p5_intf_modes(unsigned int p5_interface)
-{
-	switch (p5_interface) {
-	case P5_DISABLED:
-		return "DISABLED";
-	case P5_INTF_SEL_PHY_P0:
-		return "PHY P0";
-	case P5_INTF_SEL_PHY_P4:
-		return "PHY P4";
-	case P5_INTF_SEL_GMAC5:
-		return "GMAC5";
-	case P5_INTF_SEL_GMAC5_SGMII:
-		return "GMAC5_SGMII";
-	default:
-		return "unknown";
-	}
-}
-
 struct mt7530_priv;
 
 struct mt753x_pcs {
@@ -777,6 +759,7 @@ struct mt7530_priv {
 	struct reset_control	*rstc;
 	struct regulator	*core_pwr;
 	struct regulator	*io_pwr;
+	struct regmap		*regmap;
 	struct gpio_desc	*reset;
 	const struct mt753x_info *info;
 	unsigned int		id;
@@ -830,4 +813,9 @@ static inline void INIT_MT7530_DUMMY_POLL(struct mt7530_dummy_poll *p,
 	p->reg = reg;
 }
 
+void mt7530_free_irq(struct mt7530_priv *priv);
+
+extern const struct dsa_switch_ops mt7530_switch_ops;
+extern const struct mt753x_info mt753x_table[];
+
 #endif /* __MT7530_H */
-- 
2.39.2

