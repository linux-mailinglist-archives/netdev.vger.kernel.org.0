Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDCE6CEE7F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjC2QCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbjC2QB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:01:58 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2045F7AA0;
        Wed, 29 Mar 2023 09:00:50 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phYE3-0003UF-2y;
        Wed, 29 Mar 2023 18:00:41 +0200
Date:   Wed, 29 Mar 2023 17:00:34 +0100
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
Subject: [RFC PATCH net-next v3 14/15] net: dsa: mt7530: introduce driver for
 MT7988 built-in switch
Message-ID: <371f0586e257d098993847e71d0c916a03c04191.1680105013.git.daniel@makrotopia.org>
References: <cover.1680105013.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1680105013.git.daniel@makrotopia.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add driver for the built-in Gigabit Ethernet switch which can be found
in the MediaTek MT7988 SoC.

The switch shares most of its design with MT7530 and MT7531, but has
it's registers mapped into the SoCs register space rather than being
connected externally or internally via MDIO.

Introduce a new platform driver to support that.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 MAINTAINERS                   |  2 +
 drivers/net/dsa/Kconfig       | 12 +++++
 drivers/net/dsa/Makefile      |  1 +
 drivers/net/dsa/mt7530-mmio.c | 96 +++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.c      | 86 ++++++++++++++++++++++++++++++-
 drivers/net/dsa/mt7530.h      | 12 ++---
 6 files changed, 201 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/dsa/mt7530-mmio.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 7feb52d9ae0b9..f39c2520d5323 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13174,9 +13174,11 @@ MEDIATEK SWITCH DRIVER
 M:	Sean Wang <sean.wang@mediatek.com>
 M:	Landen Chao <Landen.Chao@mediatek.com>
 M:	DENG Qingfang <dqfext@gmail.com>
+M:	Daniel Golle <daniel@makrotopia.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/dsa/mt7530-mdio.c
+F:	drivers/net/dsa/mt7530-mmio.c
 F:	drivers/net/dsa/mt7530.*
 F:	net/dsa/tag_mtk.c
 
diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index c2551b13324c2..de4d86e37973f 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -52,6 +52,18 @@ config NET_DSA_MT7530
 	  Multi-chip module MT7530 in MT7621AT, MT7621DAT, MT7621ST and
 	  MT7623AI SoCs is supported as well.
 
+config NET_DSA_MT7988
+	tristate "MediaTek MT7988 built-in Ethernet switch support"
+	select NET_DSA_MT7530_COMMON
+	depends on HAS_IOMEM
+	help
+	  This enables support for the built-in Ethernet switch found
+	  in the MediaTek MT7988 SoC.
+	  The switch is a similar design as MT7531, however, unlike
+	  other MT7530 and MT7531 the switch registers are directly
+	  mapped into the SoCs register space rather than being accessible
+	  via MDIO.
+
 config NET_DSA_MV88E6060
 	tristate "Marvell 88E6060 ethernet switch chip support"
 	select NET_DSA_TAG_TRAILER
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index 71250d7dd41af..103a33e20de4b 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -8,6 +8,7 @@ endif
 obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
 obj-$(CONFIG_NET_DSA_MT7530_COMMON) += mt7530.o
 obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530-mdio.o
+obj-$(CONFIG_NET_DSA_MT7988)	+= mt7530-mmio.o
 obj-$(CONFIG_NET_DSA_MV88E6060) += mv88e6060.o
 obj-$(CONFIG_NET_DSA_RZN1_A5PSW) += rzn1_a5psw.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
diff --git a/drivers/net/dsa/mt7530-mmio.c b/drivers/net/dsa/mt7530-mmio.c
new file mode 100644
index 0000000000000..ce03605b67fc5
--- /dev/null
+++ b/drivers/net/dsa/mt7530-mmio.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/reset.h>
+#include <net/dsa.h>
+
+#include "mt7530.h"
+
+static const struct of_device_id mt7988_of_match[] = {
+	{ .compatible = "mediatek,mt7988-switch", .data = &mt753x_table[ID_MT7988], },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, mt7988_of_match);
+
+static int
+mt7988_probe(struct platform_device *pdev)
+{
+	static struct regmap_config *sw_regmap_config;
+	struct mt7530_priv *priv;
+	void __iomem *base_addr;
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->bus = NULL;
+	priv->dev = &pdev->dev;
+
+	ret = mt7530_probe_common(priv);
+	if (ret)
+		return ret;
+
+	base_addr = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(base_addr)) {
+		dev_err(&pdev->dev, "cannot request I/O memory space\n");
+		return -ENXIO;
+	}
+
+	sw_regmap_config = devm_kzalloc(&pdev->dev, sizeof(*sw_regmap_config), GFP_KERNEL);
+	if (!sw_regmap_config)
+		return -ENOMEM;
+
+	sw_regmap_config->name = "switch";
+	sw_regmap_config->reg_bits = 16;
+	sw_regmap_config->val_bits = 32;
+	sw_regmap_config->reg_stride = 4;
+	sw_regmap_config->reg_base = 0x0;
+	sw_regmap_config->max_register = 0x7ffc;
+	priv->regmap = devm_regmap_init_mmio(&pdev->dev, base_addr, sw_regmap_config);
+	if (IS_ERR(priv->regmap))
+		return PTR_ERR(priv->regmap);
+
+	return dsa_register_switch(priv->ds);
+}
+
+static int
+mt7988_remove(struct platform_device *pdev)
+{
+	struct mt7530_priv *priv = platform_get_drvdata(pdev);
+
+	if (priv)
+		mt7530_remove_common(priv);
+
+	return 0;
+}
+
+static void mt7988_shutdown(struct platform_device *pdev)
+{
+	struct mt7530_priv *priv = platform_get_drvdata(pdev);
+
+	if (!priv)
+		return;
+
+	dsa_switch_shutdown(priv->ds);
+
+	dev_set_drvdata(&pdev->dev, NULL);
+}
+
+static struct platform_driver mt7988_platform_driver = {
+	.probe  = mt7988_probe,
+	.remove = mt7988_remove,
+	.shutdown = mt7988_shutdown,
+	.driver = {
+		.name = "mt7988-switch",
+		.of_match_table = mt7988_of_match,
+	},
+};
+module_platform_driver(mt7988_platform_driver);
+
+MODULE_AUTHOR("Daniel Golle <daniel@makrotopia.org>");
+MODULE_DESCRIPTION("Driver for Mediatek MT7530 Switch (MMIO)");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a4b49e5753bdc..f8cb45de5ba84 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1985,6 +1985,47 @@ static const struct irq_domain_ops mt7530_irq_domain_ops = {
 	.xlate = irq_domain_xlate_onecell,
 };
 
+static void
+mt7988_irq_mask(struct irq_data *d)
+{
+	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
+
+	priv->irq_enable &= ~BIT(d->hwirq);
+	mt7530_mii_write(priv, MT7530_SYS_INT_EN, priv->irq_enable);
+}
+
+static void
+mt7988_irq_unmask(struct irq_data *d)
+{
+	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
+
+	priv->irq_enable |= BIT(d->hwirq);
+	mt7530_mii_write(priv, MT7530_SYS_INT_EN, priv->irq_enable);
+}
+
+static struct irq_chip mt7988_irq_chip = {
+	.name = KBUILD_MODNAME,
+	.irq_mask = mt7988_irq_mask,
+	.irq_unmask = mt7988_irq_unmask,
+};
+
+static int
+mt7988_irq_map(struct irq_domain *domain, unsigned int irq,
+	       irq_hw_number_t hwirq)
+{
+	irq_set_chip_data(irq, domain->host_data);
+	irq_set_chip_and_handler(irq, &mt7988_irq_chip, handle_simple_irq);
+	irq_set_nested_thread(irq, true);
+	irq_set_noprobe(irq);
+
+	return 0;
+}
+
+static const struct irq_domain_ops mt7988_irq_domain_ops = {
+	.map = mt7988_irq_map,
+	.xlate = irq_domain_xlate_onecell,
+};
+
 static void
 mt7530_setup_mdio_irq(struct mt7530_priv *priv)
 {
@@ -2019,8 +2060,15 @@ mt7530_setup_irq(struct mt7530_priv *priv)
 		return priv->irq ? : -EINVAL;
 	}
 
-	priv->irq_domain = irq_domain_add_linear(np, MT7530_NUM_PHYS,
-						 &mt7530_irq_domain_ops, priv);
+	if (priv->id == ID_MT7988)
+		priv->irq_domain = irq_domain_add_linear(np, MT7530_NUM_PHYS,
+							 &mt7988_irq_domain_ops,
+							 priv);
+	else
+		priv->irq_domain = irq_domain_add_linear(np, MT7530_NUM_PHYS,
+							 &mt7530_irq_domain_ops,
+							 priv);
+
 	if (!priv->irq_domain) {
 		dev_err(dev, "failed to create IRQ domain\n");
 		return -ENOMEM;
@@ -2965,6 +3013,27 @@ static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int mt7988_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
+{
+	return 0;
+}
+
+static int mt7988_setup(struct dsa_switch *ds)
+{
+	struct mt7530_priv *priv = ds->priv;
+
+	/* Reset the switch */
+	reset_control_assert(priv->rstc);
+	usleep_range(20, 50);
+	reset_control_deassert(priv->rstc);
+	usleep_range(20, 50);
+
+	/* Reset the switch PHYs */
+	mt7530_write(priv, MT7530_SYS_CTRL, SYS_CTRL_PHY_RST);
+
+	return mt7531_setup_common(ds);
+}
+
 const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_tag_protocol	= mtk_get_tag_protocol,
 	.setup			= mt753x_setup,
@@ -3039,6 +3108,19 @@ const struct mt753x_info mt753x_table[] = {
 		.mac_port_get_caps = mt7531_mac_port_get_caps,
 		.mac_port_config = mt7531_mac_config,
 	},
+	[ID_MT7988] = {
+		.id = ID_MT7988,
+		.pcs_ops = &mt7530_pcs_ops,
+		.sw_setup = mt7988_setup,
+		.phy_read_c22 = mt7531_ind_c22_phy_read,
+		.phy_write_c22 = mt7531_ind_c22_phy_write,
+		.phy_read_c45 = mt7531_ind_c45_phy_read,
+		.phy_write_c45 = mt7531_ind_c45_phy_write,
+		.pad_setup = mt7988_pad_setup,
+		.cpu_port_config = mt7531_cpu_port_config,
+		.mac_port_get_caps = mt7531_mac_port_get_caps,
+		.mac_port_config = mt7531_mac_config,
+	},
 };
 EXPORT_SYMBOL_GPL(mt753x_table);
 
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index ce02aa592a7a8..01db5c9724fa8 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -18,6 +18,7 @@ enum mt753x_id {
 	ID_MT7530 = 0,
 	ID_MT7621 = 1,
 	ID_MT7531 = 2,
+	ID_MT7988 = 3,
 };
 
 #define	NUM_TRGMII_CTRL			5
@@ -54,11 +55,11 @@ enum mt753x_id {
 #define  MT7531_MIRROR_PORT_SET(x)	(((x) & MIRROR_MASK) << 16)
 #define  MT7531_CPU_PMAP_MASK		GENMASK(7, 0)
 
-#define MT753X_MIRROR_REG(id)		(((id) == ID_MT7531) ? \
+#define MT753X_MIRROR_REG(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
 					 MT7531_CFC : MT7530_MFC)
-#define MT753X_MIRROR_EN(id)		(((id) == ID_MT7531) ? \
+#define MT753X_MIRROR_EN(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
 					 MT7531_MIRROR_EN : MIRROR_EN)
-#define MT753X_MIRROR_MASK(id)		(((id) == ID_MT7531) ? \
+#define MT753X_MIRROR_MASK(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
 					 MT7531_MIRROR_MASK : MIRROR_MASK)
 
 /* Registers for BPDU and PAE frame control*/
@@ -295,9 +296,8 @@ enum mt7530_vlan_port_acc_frm {
 					 MT7531_FORCE_DPX | \
 					 MT7531_FORCE_RX_FC | \
 					 MT7531_FORCE_TX_FC)
-#define  PMCR_FORCE_MODE_ID(id)		(((id) == ID_MT7531) ? \
-					 MT7531_FORCE_MODE : \
-					 PMCR_FORCE_MODE)
+#define  PMCR_FORCE_MODE_ID(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
+					 MT7531_FORCE_MODE : PMCR_FORCE_MODE)
 #define  PMCR_LINK_SETTINGS_MASK	(PMCR_TX_EN | PMCR_FORCE_SPEED_1000 | \
 					 PMCR_RX_EN | PMCR_FORCE_SPEED_100 | \
 					 PMCR_TX_FC_EN | PMCR_RX_FC_EN | \
-- 
2.39.2

