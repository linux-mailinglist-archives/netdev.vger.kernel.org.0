Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207DC6D0975
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbjC3PY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233004AbjC3PYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:24:09 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBE07EEF;
        Thu, 30 Mar 2023 08:23:37 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phu6y-0006iM-01;
        Thu, 30 Mar 2023 17:22:48 +0200
Date:   Thu, 30 Mar 2023 16:22:44 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?B?QXLEsW7DpyDDnG5hbA==?= <arinc.unal@arinc9.com>,
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
Subject: [PATCH net-next 11/15] net: dsa: mt7530: introduce separate MDIO
 driver
Message-ID: <9bb5932e4886715726abb00d8429f6ee3b2985c2.1680180959.git.daniel@makrotopia.org>
References: <cover.1680180959.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1680180959.git.daniel@makrotopia.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split MT7530 switch driver into a common part and a part specific
for MDIO connected switches and multi-chip modules.
Move MDIO-specific functions to newly introduced mt7530-mdio.c while
keeping the common parts in mt7530.c.
In order to maintain compatibility with existing kernel configurations
keep CONFIG_NET_DSA_MT7530 as symbol to select the MDIO-specific driver
while the newly introduced hidden symbol CONFIG_NET_DSA_MT7530_COMMON
is selected by CONFIG_NET_DSA_MT7530.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 MAINTAINERS                   |   1 +
 drivers/net/dsa/Kconfig       |  16 +-
 drivers/net/dsa/Makefile      |   3 +-
 drivers/net/dsa/mt7530-mdio.c | 271 ++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.c      | 263 +--------------------------------
 drivers/net/dsa/mt7530.h      |   6 +
 6 files changed, 300 insertions(+), 260 deletions(-)
 create mode 100644 drivers/net/dsa/mt7530-mdio.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 91201c2b81908..14924aed15ca7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13176,6 +13176,7 @@ M:	Landen Chao <Landen.Chao@mediatek.com>
 M:	DENG Qingfang <dqfext@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/dsa/mt7530-mdio.c
 F:	drivers/net/dsa/mt7530.*
 F:	net/dsa/tag_mtk.c
 
diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 6b45fa8b69078..c2551b13324c2 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -34,15 +34,23 @@ config NET_DSA_LANTIQ_GSWIP
 	  This enables support for the Lantiq / Intel GSWIP 2.1 found in
 	  the xrx200 / VR9 SoC.
 
-config NET_DSA_MT7530
-	tristate "MediaTek MT7530 and MT7531 Ethernet switch support"
+config NET_DSA_MT7530_COMMON
+	tristate
 	select NET_DSA_TAG_MTK
 	select MEDIATEK_GE_PHY
+	help
+	  This enables support for the common parts of MediaTek Ethernet
+	  switch chips.
+
+config NET_DSA_MT7530
+	tristate "MediaTek MT7530 and MT7531 Ethernet switch support"
+	select NET_DSA_MT7530_COMMON
 	select PCS_MTK_LYNXI
 	help
 	  This enables support for the MediaTek MT7530 and MT7531 Ethernet
-	  switch chips. Multi-chip module MT7530 in MT7621AT, MT7621DAT,
-	  MT7621ST and MT7623AI SoCs is supported.
+	  switch chips which are connected via MDIO.
+	  Multi-chip module MT7530 in MT7621AT, MT7621DAT, MT7621ST and
+	  MT7623AI SoCs is supported as well.
 
 config NET_DSA_MV88E6060
 	tristate "Marvell 88E6060 ethernet switch chip support"
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index 16eb879e0cb4d..71250d7dd41af 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -6,7 +6,8 @@ ifdef CONFIG_NET_DSA_LOOP
 obj-$(CONFIG_FIXED_PHY)		+= dsa_loop_bdinfo.o
 endif
 obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
-obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530.o
+obj-$(CONFIG_NET_DSA_MT7530_COMMON) += mt7530.o
+obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530-mdio.o
 obj-$(CONFIG_NET_DSA_MV88E6060) += mv88e6060.o
 obj-$(CONFIG_NET_DSA_RZN1_A5PSW) += rzn1_a5psw.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
diff --git a/drivers/net/dsa/mt7530-mdio.c b/drivers/net/dsa/mt7530-mdio.c
new file mode 100644
index 0000000000000..8ba204fe88429
--- /dev/null
+++ b/drivers/net/dsa/mt7530-mdio.c
@@ -0,0 +1,271 @@
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
+#include <linux/reset.h>
+#include <linux/regulator/consumer.h>
+#include <net/dsa.h>
+
+#include "mt7530.h"
+
+static int
+mt7530_regmap_write(void *context, unsigned int reg, unsigned int val)
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
+		return ret;
+
+	ret = bus->write(bus, 0x1f, r,  lo);
+	if (ret < 0)
+		return ret;
+
+	ret = bus->write(bus, 0x1f, 0x10, hi);
+	return ret;
+}
+
+static int
+mt7530_regmap_read(void *context, unsigned int reg, unsigned int *val)
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
+	if (ret < 0)
+		return ret;
+
+	lo = bus->read(bus, 0x1f, r);
+	hi = bus->read(bus, 0x1f, 0x10);
+
+	*val = (hi << 16) | (lo & 0xffff);
+
+	return 0;
+}
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
+static const struct regmap_bus mt7530_regmap_bus = {
+	.reg_write = mt7530_regmap_write,
+	.reg_read = mt7530_regmap_read,
+};
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
+					  &mt7530_regmap_bus, priv->bus,
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
+static const struct of_device_id mt7530_of_match[] = {
+	{ .compatible = "mediatek,mt7621", .data = &mt753x_table[ID_MT7621], },
+	{ .compatible = "mediatek,mt7530", .data = &mt753x_table[ID_MT7530], },
+	{ .compatible = "mediatek,mt7531", .data = &mt753x_table[ID_MT7531], },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, mt7530_of_match);
+
+static int
+mt7530_probe(struct mdio_device *mdiodev)
+{
+	static struct regmap_config *regmap_config;
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
+	priv->bus = mdiodev->bus;
+	priv->dev = &mdiodev->dev;
+
+	ret = mt7530_probe_common(priv);
+	if (ret)
+		return ret;
+
+	/* Use medatek,mcm property to distinguish hardware type that would
+	 * cause a little bit differences on power-on sequence.
+	 * Not MCM that indicates switch works as the remote standalone
+	 * integrated circuit so the GPIO pin would be used to complete
+	 * the reset, otherwise memory-mapped register accessing used
+	 * through syscon provides in the case of MCM.
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
+	} else {
+		priv->reset = devm_gpiod_get_optional(&mdiodev->dev, "reset",
+						      GPIOD_OUT_LOW);
+		if (IS_ERR(priv->reset)) {
+			dev_err(&mdiodev->dev, "Couldn't get our reset line\n");
+			return PTR_ERR(priv->reset);
+		}
+	}
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
+	regmap_config = devm_kzalloc(&mdiodev->dev, sizeof(*regmap_config),
+				     GFP_KERNEL);
+	if (!regmap_config)
+		return -ENOMEM;
+
+	regmap_config->reg_bits = 16;
+	regmap_config->val_bits = 32;
+	regmap_config->reg_stride = 4;
+	regmap_config->max_register = MT7530_CREV;
+	regmap_config->disable_locking = true;
+	priv->regmap = devm_regmap_init(priv->dev, &mt7530_regmap_bus,
+					priv->bus, regmap_config);
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
+	mt7530_remove_common(priv);
+
+	for (i = 0; i < 2; ++i)
+		mtk_pcs_lynxi_destroy(priv->ports[5 + i].sgmii_pcs);
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
+
+mdio_module_driver(mt7530_mdio_driver);
+
+MODULE_AUTHOR("Sean Wang <sean.wang@mediatek.com>");
+MODULE_DESCRIPTION("Driver for Mediatek MT7530 Switch (MDIO)");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 26657c93d750b..ea8d8e669aacc 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -191,31 +191,6 @@ core_clear(struct mt7530_priv *priv, u32 reg, u32 val)
 	core_rmw(priv, reg, val, 0);
 }
 
-static int
-mt7530_regmap_write(void *context, unsigned int reg, unsigned int val)
-{
-	struct mii_bus *bus = context;
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
-		return ret;
-
-	ret = bus->write(bus, 0x1f, r,  lo);
-	if (ret < 0)
-		return ret;
-
-	ret = bus->write(bus, 0x1f, 0x10, hi);
-	return ret;
-}
-
 static int
 mt7530_mii_write(struct mt7530_priv *priv, u32 reg, u32 val)
 {
@@ -230,29 +205,6 @@ mt7530_mii_write(struct mt7530_priv *priv, u32 reg, u32 val)
 	return ret;
 }
 
-static int
-mt7530_regmap_read(void *context, unsigned int reg, unsigned int *val)
-{
-	struct mii_bus *bus = context;
-	u16 page, r, lo, hi;
-	int ret;
-
-	page = (reg >> 6) & 0x3ff;
-	r = (reg >> 2) & 0xf;
-
-	/* MT7530 uses 31 as the pseudo port */
-	ret = bus->write(bus, 0x1f, 0x1f, page);
-	if (ret < 0)
-		return ret;
-
-	lo = bus->read(bus, 0x1f, r);
-	hi = bus->read(bus, 0x1f, 0x10);
-
-	*val = (hi << 16) | (lo & 0xffff);
-
-	return 0;
-}
-
 static u32
 mt7530_mii_read(struct mt7530_priv *priv, u32 reg)
 {
@@ -2950,72 +2902,6 @@ static const struct phylink_pcs_ops mt7530_pcs_ops = {
 	.pcs_an_restart = mt7530_pcs_an_restart,
 };
 
-static void
-mt7530_mdio_regmap_lock(void *mdio_lock)
-{
-	mutex_lock_nested(mdio_lock, MDIO_MUTEX_NESTED);
-}
-
-static void
-mt7530_mdio_regmap_unlock(void *mdio_lock)
-{
-	mutex_unlock(mdio_lock);
-}
-
-static const struct regmap_bus mt7530_regmap_bus = {
-	.reg_write = mt7530_regmap_write,
-	.reg_read = mt7530_regmap_read,
-};
-
-static int
-mt7531_create_sgmii(struct mt7530_priv *priv)
-{
-	struct regmap_config *mt7531_pcs_config[2];
-	struct phylink_pcs *pcs;
-	struct regmap *regmap;
-	int i, ret = 0;
-
-	for (i = 0; i < 2; i++) {
-		mt7531_pcs_config[i] = devm_kzalloc(priv->dev,
-						    sizeof(struct regmap_config),
-						    GFP_KERNEL);
-		if (!mt7531_pcs_config[i]) {
-			ret = -ENOMEM;
-			break;
-		}
-
-		mt7531_pcs_config[i]->name = i ? "port6" : "port5";
-		mt7531_pcs_config[i]->reg_bits = 16;
-		mt7531_pcs_config[i]->val_bits = 32;
-		mt7531_pcs_config[i]->reg_stride = 4;
-		mt7531_pcs_config[i]->reg_base = MT7531_SGMII_REG_BASE(5 + i);
-		mt7531_pcs_config[i]->max_register = 0x17c;
-		mt7531_pcs_config[i]->lock = mt7530_mdio_regmap_lock;
-		mt7531_pcs_config[i]->unlock = mt7530_mdio_regmap_unlock;
-		mt7531_pcs_config[i]->lock_arg = &priv->bus->mdio_lock;
-
-		regmap = devm_regmap_init(priv->dev,
-					  &mt7530_regmap_bus, priv->bus,
-					  mt7531_pcs_config[i]);
-		if (IS_ERR(regmap)) {
-			ret = PTR_ERR(regmap);
-			break;
-		}
-		pcs = mtk_pcs_lynxi_create(priv->dev, regmap,
-					   MT7531_PHYA_CTRL_SIGNAL3, 0);
-		if (!pcs) {
-			ret = -ENXIO;
-			break;
-		}
-		priv->ports[5 + i].sgmii_pcs = pcs;
-	}
-
-	if (ret && i)
-		mtk_pcs_lynxi_destroy(priv->ports[5].sgmii_pcs);
-
-	return ret;
-}
-
 static int
 mt753x_setup(struct dsa_switch *ds)
 {
@@ -3074,7 +2960,7 @@ static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static const struct dsa_switch_ops mt7530_switch_ops = {
+const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_tag_protocol	= mtk_get_tag_protocol,
 	.setup			= mt753x_setup,
 	.get_strings		= mt7530_get_strings,
@@ -3108,8 +2994,9 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_mac_eee		= mt753x_get_mac_eee,
 	.set_mac_eee		= mt753x_set_mac_eee,
 };
+EXPORT_SYMBOL_GPL(mt7530_switch_ops);
 
-static const struct mt753x_info mt753x_table[] = {
+const struct mt753x_info mt753x_table[] = {
 	[ID_MT7621] = {
 		.id = ID_MT7621,
 		.pcs_ops = &mt7530_pcs_ops,
@@ -3148,16 +3035,9 @@ static const struct mt753x_info mt753x_table[] = {
 		.mac_port_config = mt7531_mac_config,
 	},
 };
+EXPORT_SYMBOL_GPL(mt753x_table);
 
-static const struct of_device_id mt7530_of_match[] = {
-	{ .compatible = "mediatek,mt7621", .data = &mt753x_table[ID_MT7621], },
-	{ .compatible = "mediatek,mt7530", .data = &mt753x_table[ID_MT7530], },
-	{ .compatible = "mediatek,mt7531", .data = &mt753x_table[ID_MT7531], },
-	{ /* sentinel */ },
-};
-MODULE_DEVICE_TABLE(of, mt7530_of_match);
-
-static int
+int
 mt7530_probe_common(struct mt7530_priv *priv)
 {
 	struct device *dev = priv->dev;
@@ -3194,88 +3074,9 @@ mt7530_probe_common(struct mt7530_priv *priv)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mt7530_probe_common);
 
-static int
-mt7530_probe(struct mdio_device *mdiodev)
-{
-	static struct regmap_config *regmap_config;
-	struct mt7530_priv *priv;
-	struct device_node *dn;
-	int ret;
-
-	dn = mdiodev->dev.of_node;
-
-	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	priv->bus = mdiodev->bus;
-	priv->dev = &mdiodev->dev;
-
-	ret = mt7530_probe_common(priv);
-	if (ret)
-		return ret;
-
-	/* Use medatek,mcm property to distinguish hardware type that would
-	 * cause a little bit differences on power-on sequence.
-	 * Not MCM that indicates switch works as the remote standalone
-	 * integrated circuit so the GPIO pin would be used to complete
-	 * the reset, otherwise memory-mapped register accessing used
-	 * through syscon provides in the case of MCM.
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
-	} else {
-		priv->reset = devm_gpiod_get_optional(&mdiodev->dev, "reset",
-						      GPIOD_OUT_LOW);
-		if (IS_ERR(priv->reset)) {
-			dev_err(&mdiodev->dev, "Couldn't get our reset line\n");
-			return PTR_ERR(priv->reset);
-		}
-	}
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
-	regmap_config = devm_kzalloc(&mdiodev->dev, sizeof(*regmap_config),
-				     GFP_KERNEL);
-	if (!regmap_config)
-		return -ENOMEM;
-
-	regmap_config->reg_bits = 16;
-	regmap_config->val_bits = 32;
-	regmap_config->reg_stride = 4;
-	regmap_config->max_register = MT7530_CREV;
-	regmap_config->disable_locking = true;
-	priv->regmap = devm_regmap_init(priv->dev, &mt7530_regmap_bus,
-					priv->bus, regmap_config);
-	if (IS_ERR(priv->regmap))
-		return PTR_ERR(priv->regmap);
-
-	if (priv->id == ID_MT7531) {
-		ret = mt7531_create_sgmii(priv);
-		if (ret)
-			return ret;
-	}
-
-	return dsa_register_switch(priv->ds);
-}
-
-static void
+void
 mt7530_remove_common(struct mt7530_priv *priv)
 {
 	if (priv->irq)
@@ -3285,55 +3086,7 @@ mt7530_remove_common(struct mt7530_priv *priv)
 
 	mutex_destroy(&priv->reg_mutex);
 }
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
-	mt7530_remove_common(priv);
-
-	for (i = 0; i < 2; ++i)
-		mtk_pcs_lynxi_destroy(priv->ports[5 + i].sgmii_pcs);
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
+EXPORT_SYMBOL_GPL(mt7530_remove_common);
 
 MODULE_AUTHOR("Sean Wang <sean.wang@mediatek.com>");
 MODULE_DESCRIPTION("Driver for Mediatek MT7530 Switch");
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 2a611173a7d08..ce02aa592a7a8 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -814,4 +814,10 @@ static inline void INIT_MT7530_DUMMY_POLL(struct mt7530_dummy_poll *p,
 	p->reg = reg;
 }
 
+int mt7530_probe_common(struct mt7530_priv *priv);
+void mt7530_remove_common(struct mt7530_priv *priv);
+
+extern const struct dsa_switch_ops mt7530_switch_ops;
+extern const struct mt753x_info mt753x_table[];
+
 #endif /* __MT7530_H */
-- 
2.39.2

