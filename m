Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B71C6CB0C5
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 23:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjC0VgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 17:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjC0VgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 17:36:14 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D00230D2;
        Mon, 27 Mar 2023 14:35:51 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pguVJ-0008MV-1c;
        Mon, 27 Mar 2023 23:35:49 +0200
Date:   Mon, 27 Mar 2023 22:35:43 +0100
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
Subject: [RFC PATCH net-next 2/2] net: dsa: mt7530: introduce MMIO driver for
 MT7988 SoC
Message-ID: <ZCIML310vc8/uoM4@makrotopia.org>
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

The MediaTek MT7988 SoC comes with a built-in switch very similar to
previous MT7530 and MT7531. However, the switch address space is mapped
into the SoCs memory space rather than being connected via MDIO.
Using MMIO simplifies register access and also removes the need for a bus
lock, and for that reason also makes interrupt handling more light-weight.

Note that this is different from previous SoCs like MT7621 and MT7623N
which also came with an integrated MT7530-like switch which yet had to be
accessed via MDIO.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/Kconfig       |   8 ++
 drivers/net/dsa/Makefile      |   1 +
 drivers/net/dsa/mt7530-mmio.c | 126 +++++++++++++++++++++
 drivers/net/dsa/mt7530.c      | 203 ++++++++++++++++++++++++++++++----
 drivers/net/dsa/mt7530.h      |  16 ++-
 5 files changed, 324 insertions(+), 30 deletions(-)
 create mode 100644 drivers/net/dsa/mt7530-mmio.c

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 5a67a74166a3d..0120586df330d 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -50,6 +50,14 @@ config NET_DSA_MT7530_MDIO
 	  switch chips. Multi-chip module MT7530 in MT7621AT, MT7621DAT,
 	  MT7621ST and MT7623AI SoCs is supported.
 
+config NET_DSA_MT7530_MMIO
+	tristate "MediaTek MT7988 built-in Ethernet switch support"
+	select NET_DSA_MT7530
+	depends on HAS_IOMEM
+	help
+	  This enables support for the MediaTek MT7988 Ethernet
+	  switch chip.
+
 config NET_DSA_MV88E6060
 	tristate "Marvell 88E6060 ethernet switch chip support"
 	select NET_DSA_TAG_TRAILER
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index 2b072d574ed02..7c763578b297f 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -8,6 +8,7 @@ endif
 obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
 obj-$(CONFIG_NET_DSA_MT7530)		+= mt7530.o
 obj-$(CONFIG_NET_DSA_MT7530_MDIO)	+= mt7530-mdio.o
+obj-$(CONFIG_NET_DSA_MT7530_MMIO)	+= mt7530-mmio.o
 obj-$(CONFIG_NET_DSA_MV88E6060) += mv88e6060.o
 obj-$(CONFIG_NET_DSA_RZN1_A5PSW) += rzn1_a5psw.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
diff --git a/drivers/net/dsa/mt7530-mmio.c b/drivers/net/dsa/mt7530-mmio.c
new file mode 100644
index 0000000000000..8096315f17a95
--- /dev/null
+++ b/drivers/net/dsa/mt7530-mmio.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/module.h>
+#include <linux/of_platform.h>
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
+	struct mt7530_priv *priv;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->base_addr = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(priv->base_addr)) {
+		dev_err(&pdev->dev, "cannot request I/O memory space\n");
+		return -ENXIO;
+	}
+
+	priv->ds = devm_kzalloc(&pdev->dev, sizeof(*priv->ds), GFP_KERNEL);
+	if (!priv->ds)
+		return -ENOMEM;
+
+	priv->ds->dev = &pdev->dev;
+	priv->ds->num_ports = MT7530_NUM_PORTS;
+
+	priv->rstc = devm_reset_control_get(&pdev->dev, NULL);
+	if (IS_ERR(priv->rstc)) {
+		dev_err(&pdev->dev, "Couldn't get our reset line\n");
+		return PTR_ERR(priv->rstc);
+	}
+
+	/* Get the hardware identifier from the devicetree node.
+	 * We will need it for some of the clock and regulator setup.
+	 */
+	priv->info = of_device_get_match_data(&pdev->dev);
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
+	priv->bus = NULL;
+	priv->dev = &pdev->dev;
+	priv->ds->priv = priv;
+	priv->ds->ops = &mt7530_switch_ops;
+	mutex_init(&priv->reg_mutex);
+	dev_set_drvdata(&pdev->dev, priv);
+
+	return dsa_register_switch(priv->ds);
+}
+
+static int
+mt7988_remove(struct platform_device *pdev)
+{
+	struct mt7530_priv *priv = platform_get_drvdata(pdev);
+	int ret = 0;
+
+	if (!priv)
+		return 0;
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
+	mutex_destroy(&priv->reg_mutex);
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
+MODULE_AUTHOR("Sean Wang <sean.wang@mediatek.com>");
+MODULE_DESCRIPTION("Driver for Mediatek MT7530 Switch (MMIO)");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 7828837d15e15..a5c3f69ea193d 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -118,6 +118,9 @@ core_write_mmd_indirect(struct mt7530_priv *priv, int prtad,
 	struct mii_bus *bus = priv->bus;
 	int ret;
 
+	if (!bus)
+		return 0;
+
 	/* Write the desired MMD Devad */
 	ret = bus->write(bus, 0, MII_MMD_CTRL, devad);
 	if (ret < 0)
@@ -147,11 +150,13 @@ core_write(struct mt7530_priv *priv, u32 reg, u32 val)
 {
 	struct mii_bus *bus = priv->bus;
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	if (bus)
+		mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
 	core_write_mmd_indirect(priv, reg, MDIO_MMD_VEND2, val);
 
-	mutex_unlock(&bus->mdio_lock);
+	if (bus)
+		mutex_unlock(&bus->mdio_lock);
 }
 
 static void
@@ -160,6 +165,9 @@ core_rmw(struct mt7530_priv *priv, u32 reg, u32 mask, u32 set)
 	struct mii_bus *bus = priv->bus;
 	u32 val;
 
+	if (!bus)
+		return;
+
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
 	val = core_read_mmd_indirect(priv, reg, MDIO_MMD_VEND2);
@@ -189,6 +197,11 @@ mt7530_mii_write(struct mt7530_priv *priv, u32 reg, u32 val)
 	u16 page, r, lo, hi;
 	int ret;
 
+	if (priv->base_addr) {
+		iowrite32(val, priv->base_addr + reg);
+		return 0;
+	}
+
 	page = (reg >> 6) & 0x3ff;
 	r  = (reg >> 2) & 0xf;
 	lo = val & 0xffff;
@@ -218,6 +231,9 @@ mt7530_mii_read(struct mt7530_priv *priv, u32 reg)
 	u16 page, r, lo, hi;
 	int ret;
 
+	if (priv->base_addr)
+		return ioread32(priv->base_addr + reg);
+
 	page = (reg >> 6) & 0x3ff;
 	r = (reg >> 2) & 0xf;
 
@@ -240,11 +256,13 @@ mt7530_write(struct mt7530_priv *priv, u32 reg, u32 val)
 {
 	struct mii_bus *bus = priv->bus;
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	if (bus)
+		mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
 	mt7530_mii_write(priv, reg, val);
 
-	mutex_unlock(&bus->mdio_lock);
+	if (bus)
+		mutex_unlock(&bus->mdio_lock);
 }
 
 static u32
@@ -256,14 +274,16 @@ _mt7530_unlocked_read(struct mt7530_dummy_poll *p)
 static u32
 _mt7530_read(struct mt7530_dummy_poll *p)
 {
-	struct mii_bus		*bus = p->priv->bus;
+	struct mii_bus *bus = p->priv->bus;
 	u32 val;
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	if (bus)
+		mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
 	val = mt7530_mii_read(p->priv, p->reg);
 
-	mutex_unlock(&bus->mdio_lock);
+	if (bus)
+		mutex_unlock(&bus->mdio_lock);
 
 	return val;
 }
@@ -284,14 +304,16 @@ mt7530_rmw(struct mt7530_priv *priv, u32 reg,
 	struct mii_bus *bus = priv->bus;
 	u32 val;
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	if (bus)
+		mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
 	val = mt7530_mii_read(priv, reg);
 	val &= ~mask;
 	val |= set;
 	mt7530_mii_write(priv, reg, val);
 
-	mutex_unlock(&bus->mdio_lock);
+	if (bus)
+		mutex_unlock(&bus->mdio_lock);
 }
 
 static void
@@ -642,7 +664,8 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 
 	INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	if (bus)
+		mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
 	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
 				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -675,7 +698,8 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 
 	ret = val & MT7531_MDIO_RW_DATA_MASK;
 out:
-	mutex_unlock(&bus->mdio_lock);
+	if (bus)
+		mutex_unlock(&bus->mdio_lock);
 
 	return ret;
 }
@@ -691,7 +715,8 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 
 	INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	if (bus)
+		mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
 	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
 				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -723,7 +748,8 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 	}
 
 out:
-	mutex_unlock(&bus->mdio_lock);
+	if (bus)
+		mutex_unlock(&bus->mdio_lock);
 
 	return ret;
 }
@@ -738,7 +764,8 @@ mt7531_ind_c22_phy_read(struct mt7530_priv *priv, int port, int regnum)
 
 	INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	if (bus)
+		mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
 	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
 				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -761,7 +788,8 @@ mt7531_ind_c22_phy_read(struct mt7530_priv *priv, int port, int regnum)
 
 	ret = val & MT7531_MDIO_RW_DATA_MASK;
 out:
-	mutex_unlock(&bus->mdio_lock);
+	if (bus)
+		mutex_unlock(&bus->mdio_lock);
 
 	return ret;
 }
@@ -777,7 +805,8 @@ mt7531_ind_c22_phy_write(struct mt7530_priv *priv, int port, int regnum,
 
 	INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	if (bus)
+		mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
 	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, reg,
 				 !(reg & MT7531_PHY_ACS_ST), 20, 100000);
@@ -799,7 +828,8 @@ mt7531_ind_c22_phy_write(struct mt7530_priv *priv, int port, int regnum,
 	}
 
 out:
-	mutex_unlock(&bus->mdio_lock);
+	if (bus)
+		mutex_unlock(&bus->mdio_lock);
 
 	return ret;
 }
@@ -1109,7 +1139,8 @@ mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	if (!dsa_is_cpu_port(ds, port))
 		return 0;
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	if (bus)
+		mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
 	val = mt7530_mii_read(priv, MT7530_GMACCR);
 	val &= ~MAX_RX_PKT_LEN_MASK;
@@ -1130,7 +1161,8 @@ mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 
 	mt7530_mii_write(priv, MT7530_GMACCR, val);
 
-	mutex_unlock(&bus->mdio_lock);
+	if (bus)
+		mutex_unlock(&bus->mdio_lock);
 
 	return 0;
 }
@@ -1931,10 +1963,14 @@ mt7530_irq_thread_fn(int irq, void *dev_id)
 	u32 val;
 	int p;
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	if (priv->bus)
+		mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+
 	val = mt7530_mii_read(priv, MT7530_SYS_INT_STS);
 	mt7530_mii_write(priv, MT7530_SYS_INT_STS, val);
-	mutex_unlock(&priv->bus->mdio_lock);
+
+	if (priv->bus)
+		mutex_unlock(&priv->bus->mdio_lock);
 
 	for (p = 0; p < MT7530_NUM_PHYS; p++) {
 		if (BIT(p) & val) {
@@ -2007,6 +2043,47 @@ static const struct irq_domain_ops mt7530_irq_domain_ops = {
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
@@ -2041,8 +2118,15 @@ mt7530_setup_irq(struct mt7530_priv *priv)
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
@@ -2627,6 +2711,8 @@ mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	case PHY_INTERFACE_MODE_NA:
 	case PHY_INTERFACE_MODE_1000BASEX:
 	case PHY_INTERFACE_MODE_2500BASEX:
+	case PHY_INTERFACE_MODE_USXGMII:
+	case PHY_INTERFACE_MODE_10GKR:
 		/* handled in SGMII PCS driver */
 		return 0;
 	default:
@@ -2751,7 +2837,9 @@ static void mt753x_phylink_mac_link_up(struct dsa_switch *ds, int port,
 	 * variants.
 	 */
 	if (interface == PHY_INTERFACE_MODE_TRGMII ||
-	    (phy_interface_mode_is_8023z(interface))) {
+	    interface == PHY_INTERFACE_MODE_USXGMII ||
+	    interface == PHY_INTERFACE_MODE_10GKR ||
+	    phy_interface_mode_is_8023z(interface)) {
 		speed = SPEED_1000;
 		duplex = DUPLEX_FULL;
 	}
@@ -3029,6 +3117,60 @@ static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
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
+	u32 unused_pm = 0;
+	int i;
+
+	/* Reset the switch */
+	reset_control_assert(priv->rstc);
+	udelay(20);
+	reset_control_deassert(priv->rstc);
+	udelay(20);
+
+	/* Reset the switch PHYs */
+	mt7530_write(priv, MT7530_SYS_CTRL, SYS_CTRL_PHY_RST);
+
+	/* BPDU to CPU port */
+	mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
+		   BIT(MT7988_CPU_PORT));
+	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
+		   MT753X_BPDU_CPU_ONLY);
+
+	/* Enable and reset MIB counters */
+	mt7530_mib_reset(ds);
+
+	for (i = 0; i < MT7530_NUM_PORTS; i++) {
+		/* Disable forwarding by default on all ports */
+		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
+			   PCR_MATRIX_CLR);
+
+		mt7530_set(priv, MT7531_DBG_CNT(i), MT7531_DIS_CLR);
+
+		if (dsa_is_unused_port(ds, i))
+			unused_pm |= BIT(i);
+		else if (dsa_is_cpu_port(ds, i))
+			mt753x_cpu_port_enable(ds, i);
+		else
+			mt7530_port_disable(ds, i);
+
+		/* Enable consistent egress tag */
+		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
+			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
+	}
+
+	ds->configure_vlan_while_not_filtering = true;
+
+	/* Flush the FDB table */
+	return mt7530_fdb_cmd(priv, MT7530_FDB_FLUSH, NULL);
+}
+
 const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_tag_protocol	= mtk_get_tag_protocol,
 	.setup			= mt753x_setup,
@@ -3103,6 +3245,19 @@ const struct mt753x_info mt753x_table[] = {
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
index e78ae5c8955ee..6d7f72cb8a2bb 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -11,6 +11,8 @@
 #define MT7530_NUM_FDB_RECORDS		2048
 #define MT7530_ALL_MEMBERS		0xff
 
+#define MT7988_CPU_PORT			6
+
 #define MTK_HDR_LEN	4
 #define MT7530_MAX_MTU	(15 * 1024 - ETH_HLEN - ETH_FCS_LEN - MTK_HDR_LEN)
 
@@ -18,6 +20,7 @@ enum mt753x_id {
 	ID_MT7530 = 0,
 	ID_MT7621 = 1,
 	ID_MT7531 = 2,
+	ID_MT7988 = 3,
 };
 
 #define	NUM_TRGMII_CTRL			5
@@ -54,11 +57,11 @@ enum mt753x_id {
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
@@ -295,9 +298,8 @@ enum mt7530_vlan_port_acc_frm {
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
@@ -740,6 +742,7 @@ struct mt753x_info {
  * @core_pwr:		The power supplied into the core
  * @io_pwr:		The power supplied into the I/O
  * @reset:		The descriptor for GPIO line tied to its reset pin
+ * @base_addr:		MMIO address for the switch interface.
  * @mcm:		Flag for distinguishing if standalone IC or module
  *			coupling
  * @ports:		Holding the state among ports
@@ -760,6 +763,7 @@ struct mt7530_priv {
 	struct regulator	*core_pwr;
 	struct regulator	*io_pwr;
 	struct gpio_desc	*reset;
+	void __iomem		*base_addr;
 	const struct mt753x_info *info;
 	unsigned int		id;
 	bool			mcm;
-- 
2.39.2

