Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71956CB0C3
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 23:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbjC0Vfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 17:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjC0Vfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 17:35:36 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0F226B3;
        Mon, 27 Mar 2023 14:35:34 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pguV2-0008LK-2E;
        Mon, 27 Mar 2023 23:35:32 +0200
Date:   Mon, 27 Mar 2023 22:35:27 +0100
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
Subject: [RFC PATCH net-next 1/2] net: dsa: mt7530: split-off MDIO driver
Message-ID: <ZCIMH4M2RxGHbVUP@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
 drivers/net/dsa/mt7530-mdio.c | 165 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.c      | 174 +++++-----------------------------
 drivers/net/dsa/mt7530.h      |  23 +----
 5 files changed, 203 insertions(+), 170 deletions(-)
 create mode 100644 drivers/net/dsa/mt7530-mdio.c

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 6b45fa8b69078..5a67a74166a3d 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -35,10 +35,16 @@ config NET_DSA_LANTIQ_GSWIP
 	  the xrx200 / VR9 SoC.
 
 config NET_DSA_MT7530
-	tristate "MediaTek MT7530 and MT7531 Ethernet switch support"
+	tristate "MediaTek Ethernet switch support"
 	select NET_DSA_TAG_MTK
 	select MEDIATEK_GE_PHY
 	select PCS_MTK_LYNXI
+	help
+	  This enables support for the MediaTek Ethernet switch chips.
+
+config NET_DSA_MT7530_MDIO
+	tristate "MediaTek MT7530 and MT7531 Ethernet switch support"
+	select NET_DSA_MT7530
 	help
 	  This enables support for the MediaTek MT7530 and MT7531 Ethernet
 	  switch chips. Multi-chip module MT7530 in MT7621AT, MT7621DAT,
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
index 0000000000000..33f8e4b0965ce
--- /dev/null
+++ b/drivers/net/dsa/mt7530-mdio.c
@@ -0,0 +1,165 @@
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
+static int
+mt7530_probe(struct mdio_device *mdiodev)
+{
+	struct mt7530_priv *priv;
+	struct device_node *dn;
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
index a0d99af897ace..7828837d15e15 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -921,6 +921,24 @@ mt7530_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
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
@@ -2067,12 +2085,13 @@ mt7530_free_irq_common(struct mt7530_priv *priv)
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
@@ -3010,7 +3029,7 @@ static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static const struct dsa_switch_ops mt7530_switch_ops = {
+const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_tag_protocol	= mtk_get_tag_protocol,
 	.setup			= mt753x_setup,
 	.get_strings		= mt7530_get_strings,
@@ -3044,8 +3063,9 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_mac_eee		= mt753x_get_mac_eee,
 	.set_mac_eee		= mt753x_set_mac_eee,
 };
+EXPORT_SYMBOL_GPL(mt7530_switch_ops);
 
-static const struct mt753x_info mt753x_table[] = {
+const struct mt753x_info mt753x_table[] = {
 	[ID_MT7621] = {
 		.id = ID_MT7621,
 		.pcs_ops = &mt7530_pcs_ops,
@@ -3084,153 +3104,7 @@ static const struct mt753x_info mt753x_table[] = {
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
index c5d29f3fc1d80..e78ae5c8955ee 100644
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
@@ -830,4 +812,9 @@ static inline void INIT_MT7530_DUMMY_POLL(struct mt7530_dummy_poll *p,
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

