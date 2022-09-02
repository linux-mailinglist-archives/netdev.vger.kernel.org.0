Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934305AAC75
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 12:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbiIBKcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 06:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235769AbiIBKcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 06:32:45 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D52AEDBE;
        Fri,  2 Sep 2022 03:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662114764; x=1693650764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/9/pu0lhiplmWsSlMqe1UIGGSTTU+Giege5G6bEuxm4=;
  b=H3sYP0pn4CkW3y2IaHH46FSUr8iOJV9dR61xs7pTkQrIOBJpkophWL8z
   RcIRBVt3eFJ0VkySS8xSrhDDFLBwZjhbo6zFQZT6dNVzE9ZDiKl+LdqHH
   FyfkZ5Xp51rSkaTTs1wSpraNdVlhJsqGicIakKtZdLcIKTol3dtAF09z4
   IPgysA97uTJVV1FJmGwLi5fIYO6boKnS5g3t9MLhZTD4+n06yRLMYFx0i
   Ac3SHuoJJa6FInbSoDI6GVTjzXQUadrqW/mD/k1NLJSpcRIMz/GjYUf1z
   kVWl80gu4QncuICCiv7ZjT9ligmUmKonboELlw9ouc7S7CuwvGlRIxfnh
   A==;
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="178772975"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Sep 2022 03:32:43 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Sep 2022 03:32:42 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 2 Sep 2022 03:32:37 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: [Patch net-next 3/3] net: dsa: microchip: lan937x: add interrupt support for port phy link
Date:   Fri, 2 Sep 2022 16:02:10 +0530
Message-ID: <20220902103210.10743-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220902103210.10743-1-arun.ramadoss@microchip.com>
References: <20220902103210.10743-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables the interrupts for internal phy link detection for
LAN937x. The interrupt enable bits are active low. There is global
interrupt mask for each port. And each port has the individual interrupt
mask for TAS. QCI, SGMII, PTP, PHY and ACL.
The first level of interrupt domain is registered for global port
interrupt and second level of interrupt domain for the individual port
interrupts. The phy interrupt is enabled in the lan937x_mdio_register
function. Interrupt from which port is raised will be detected based on
the interrupt host data.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c   |  10 +
 drivers/net/dsa/microchip/ksz_common.h   |  14 +
 drivers/net/dsa/microchip/ksz_spi.c      |   2 +
 drivers/net/dsa/microchip/lan937x.h      |   1 +
 drivers/net/dsa/microchip/lan937x_main.c | 364 ++++++++++++++++++++++-
 drivers/net/dsa/microchip/lan937x_reg.h  |  12 +
 6 files changed, 399 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 63b9faa89393..ec2896a23834 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -205,6 +205,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 
 static const struct ksz_dev_ops lan937x_dev_ops = {
 	.setup = lan937x_setup,
+	.teardown = lan937x_teardown,
 	.get_port_addr = ksz9477_get_port_addr,
 	.cfg_port_member = ksz9477_cfg_port_member,
 	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
@@ -1444,6 +1445,14 @@ static int ksz_setup(struct dsa_switch *ds)
 	return 0;
 }
 
+static void ksz_teardown(struct dsa_switch *ds)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (dev->dev_ops->teardown)
+		dev->dev_ops->teardown(ds);
+}
+
 static void port_r_cnt(struct ksz_device *dev, int port)
 {
 	struct ksz_port_mib *mib = &dev->ports[port].mib;
@@ -2193,6 +2202,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_tag_protocol	= ksz_get_tag_protocol,
 	.get_phy_flags		= ksz_get_phy_flags,
 	.setup			= ksz_setup,
+	.teardown		= ksz_teardown,
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
 	.phylink_get_caps	= ksz_phylink_get_caps,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 3fa3e4731d58..35346b39ce54 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -13,6 +13,7 @@
 #include <linux/phy.h>
 #include <linux/regmap.h>
 #include <net/dsa.h>
+#include <linux/irq.h>
 
 #define KSZ_MAX_NUM_PORTS 8
 
@@ -68,6 +69,14 @@ struct ksz_chip_data {
 	const struct regmap_access_table *rd_table;
 };
 
+struct ksz_irq {
+	u16 masked;
+	struct irq_chip chip;
+	struct irq_domain *domain;
+	int nirqs;
+	char name[16];
+};
+
 struct ksz_port {
 	bool remove_tag;		/* Remove Tag flag set, for ksz8795 only */
 	bool learning;
@@ -86,6 +95,7 @@ struct ksz_port {
 	u32 rgmii_tx_val;
 	u32 rgmii_rx_val;
 	struct ksz_device *ksz_dev;
+	struct ksz_irq pirq;
 	u8 num;
 };
 
@@ -104,6 +114,7 @@ struct ksz_device {
 	struct regmap *regmap[3];
 
 	void *priv;
+	int irq;
 
 	struct gpio_desc *reset_gpio;	/* Optional reset GPIO */
 
@@ -124,6 +135,8 @@ struct ksz_device {
 	u16 mirror_rx;
 	u16 mirror_tx;
 	u16 port_mask;
+	struct mutex lock_irq;		/* IRQ Access */
+	struct ksz_irq girq;
 };
 
 /* List of supported models */
@@ -260,6 +273,7 @@ struct alu_struct {
 
 struct ksz_dev_ops {
 	int (*setup)(struct dsa_switch *ds);
+	void (*teardown)(struct dsa_switch *ds);
 	u32 (*get_port_addr)(int port, int offset);
 	void (*cfg_port_member)(struct ksz_device *dev, int port, u8 member);
 	void (*flush_dyn_mac_table)(struct ksz_device *dev, int port);
diff --git a/drivers/net/dsa/microchip/ksz_spi.c b/drivers/net/dsa/microchip/ksz_spi.c
index 44c2d9912406..126ed1c986a9 100644
--- a/drivers/net/dsa/microchip/ksz_spi.c
+++ b/drivers/net/dsa/microchip/ksz_spi.c
@@ -88,6 +88,8 @@ static int ksz_spi_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
+	dev->irq = spi->irq;
+
 	ret = ksz_switch_register(dev);
 
 	/* Main DSA driver may not be started yet. */
diff --git a/drivers/net/dsa/microchip/lan937x.h b/drivers/net/dsa/microchip/lan937x.h
index 5d78d034a62f..1b7f077946f3 100644
--- a/drivers/net/dsa/microchip/lan937x.h
+++ b/drivers/net/dsa/microchip/lan937x.h
@@ -8,6 +8,7 @@
 
 int lan937x_reset_switch(struct ksz_device *dev);
 int lan937x_setup(struct dsa_switch *ds);
+void lan937x_teardown(struct dsa_switch *ds);
 void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port);
 void lan937x_config_cpu_port(struct dsa_switch *ds);
 int lan937x_switch_init(struct ksz_device *dev);
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 0466c4d0b10c..4867aa62dd4c 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -10,6 +10,8 @@
 #include <linux/of_mdio.h>
 #include <linux/if_bridge.h>
 #include <linux/if_vlan.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/math.h>
 #include <net/dsa.h>
 #include <net/switchdev.h>
@@ -18,6 +20,8 @@
 #include "ksz_common.h"
 #include "lan937x.h"
 
+#define LAN937x_PNIRQS 6
+
 static int lan937x_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
 	return regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
@@ -165,6 +169,45 @@ static int lan937x_sw_mdio_write(struct mii_bus *bus, int addr, int regnum,
 	return lan937x_internal_phy_write(dev, addr, regnum, val);
 }
 
+static int lan937x_irq_phy_setup(struct ksz_device *dev)
+{
+	struct dsa_switch *ds = dev->ds;
+	int phy, err_phy;
+	int irq;
+	int ret;
+
+	for (phy = 0; phy < KSZ_MAX_NUM_PORTS; phy++) {
+		if (BIT(phy) & ds->phys_mii_mask) {
+			irq = irq_find_mapping(dev->ports[phy].pirq.domain,
+					       PORT_SRC_PHY_INT);
+			if (irq < 0) {
+				ret = irq;
+				goto out;
+			}
+			ds->slave_mii_bus->irq[phy] = irq;
+		}
+	}
+	return 0;
+out:
+	err_phy = phy;
+
+	for (phy = 0; phy < err_phy; phy++)
+		if (BIT(phy) & ds->phys_mii_mask)
+			irq_dispose_mapping(ds->slave_mii_bus->irq[phy]);
+
+	return ret;
+}
+
+static void lan937x_irq_phy_free(struct ksz_device *dev)
+{
+	struct dsa_switch *ds = dev->ds;
+	int phy;
+
+	for (phy = 0; phy < KSZ_MAX_NUM_PORTS; phy++)
+		if (BIT(phy) & ds->phys_mii_mask)
+			irq_dispose_mapping(ds->slave_mii_bus->irq[phy]);
+}
+
 static int lan937x_mdio_register(struct ksz_device *dev)
 {
 	struct dsa_switch *ds = dev->ds;
@@ -194,10 +237,15 @@ static int lan937x_mdio_register(struct ksz_device *dev)
 
 	ds->slave_mii_bus = bus;
 
+	ret = lan937x_irq_phy_setup(dev);
+	if (ret)
+		return ret;
+
 	ret = devm_of_mdiobus_register(ds->dev, bus, mdio_np);
 	if (ret) {
 		dev_err(ds->dev, "unable to register MDIO bus %s\n",
 			bus->id);
+		lan937x_irq_phy_free(dev);
 	}
 
 	of_node_put(mdio_np);
@@ -387,9 +435,289 @@ void lan937x_setup_rgmii_delay(struct ksz_device *dev, int port)
 	}
 }
 
+int lan937x_switch_init(struct ksz_device *dev)
+{
+	dev->port_mask = (1 << dev->info->port_cnt) - 1;
+
+	return 0;
+}
+
+static void lan937x_girq_mask(struct irq_data *d)
+{
+	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
+	unsigned int n = d->hwirq;
+
+	dev->girq.masked |= (1 << n);
+}
+
+static void lan937x_girq_unmask(struct irq_data *d)
+{
+	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
+	unsigned int n = d->hwirq;
+
+	dev->girq.masked &= ~(1 << n);
+}
+
+static void lan937x_girq_bus_lock(struct irq_data *d)
+{
+	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
+
+	mutex_lock(&dev->lock_irq);
+}
+
+static void lan937x_girq_bus_sync_unlock(struct irq_data *d)
+{
+	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
+	int ret;
+
+	ret = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, dev->girq.masked);
+	if (ret)
+		dev_err(dev->dev, "failed to change IRQ mask\n");
+
+	mutex_unlock(&dev->lock_irq);
+}
+
+static const struct irq_chip lan937x_girq_chip = {
+	.name			= "lan937x-global",
+	.irq_mask		= lan937x_girq_mask,
+	.irq_unmask		= lan937x_girq_unmask,
+	.irq_bus_lock		= lan937x_girq_bus_lock,
+	.irq_bus_sync_unlock	= lan937x_girq_bus_sync_unlock,
+};
+
+static int lan937x_girq_domain_map(struct irq_domain *d,
+				   unsigned int irq, irq_hw_number_t hwirq)
+{
+	struct ksz_device *dev = d->host_data;
+
+	irq_set_chip_data(irq, d->host_data);
+	irq_set_chip_and_handler(irq, &dev->girq.chip, handle_level_irq);
+	irq_set_noprobe(irq);
+
+	return 0;
+}
+
+static const struct irq_domain_ops lan937x_girq_domain_ops = {
+	.map	= lan937x_girq_domain_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
+static void lan937x_girq_free(struct ksz_device *dev)
+{
+	int irq, virq;
+
+	free_irq(dev->irq, dev);
+
+	for (irq = 0; irq < dev->girq.nirqs; irq++) {
+		virq = irq_find_mapping(dev->girq.domain, irq);
+		irq_dispose_mapping(virq);
+	}
+
+	irq_domain_remove(dev->girq.domain);
+}
+
+static irqreturn_t lan937x_girq_thread_fn(int irq, void *dev_id)
+{
+	struct ksz_device *dev = dev_id;
+	unsigned int nhandled = 0;
+	unsigned int sub_irq;
+	unsigned int n;
+	u32 data;
+	int ret;
+
+	/* Read global interrupt status register */
+	ret = ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data);
+	if (ret)
+		goto out;
+
+	for (n = 0; n < dev->girq.nirqs; ++n) {
+		if (data & (1 << n)) {
+			sub_irq = irq_find_mapping(dev->girq.domain, n);
+			handle_nested_irq(sub_irq);
+			++nhandled;
+		}
+	}
+out:
+	return (nhandled > 0 ? IRQ_HANDLED : IRQ_NONE);
+}
+
+static int lan937x_girq_setup(struct ksz_device *dev)
+{
+	int ret, irq;
+
+	dev->girq.nirqs = dev->info->port_cnt;
+	dev->girq.domain = irq_domain_add_simple(NULL, dev->girq.nirqs, 0,
+						 &lan937x_girq_domain_ops, dev);
+	if (!dev->girq.domain)
+		return -ENOMEM;
+
+	for (irq = 0; irq < dev->girq.nirqs; irq++)
+		irq_create_mapping(dev->girq.domain, irq);
+
+	dev->girq.chip = lan937x_girq_chip;
+	dev->girq.masked = ~0;
+
+	ret = request_threaded_irq(dev->irq, NULL, lan937x_girq_thread_fn,
+				   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
+				   dev_name(dev->dev), dev);
+	if (ret)
+		goto out;
+
+	return 0;
+
+out:
+	lan937x_girq_free(dev);
+
+	return ret;
+}
+
+static void lan937x_pirq_mask(struct irq_data *d)
+{
+	struct ksz_port *port = irq_data_get_irq_chip_data(d);
+	unsigned int n = d->hwirq;
+
+	port->pirq.masked |= (1 << n);
+}
+
+static void lan937x_pirq_unmask(struct irq_data *d)
+{
+	struct ksz_port *port = irq_data_get_irq_chip_data(d);
+	unsigned int n = d->hwirq;
+
+	port->pirq.masked &= ~(1 << n);
+}
+
+static void lan937x_pirq_bus_lock(struct irq_data *d)
+{
+	struct ksz_port *port = irq_data_get_irq_chip_data(d);
+	struct ksz_device *dev = port->ksz_dev;
+
+	mutex_lock(&dev->lock_irq);
+}
+
+static void lan937x_pirq_bus_sync_unlock(struct irq_data *d)
+{
+	struct ksz_port *port = irq_data_get_irq_chip_data(d);
+	struct ksz_device *dev = port->ksz_dev;
+
+	ksz_pwrite8(dev, port->num, REG_PORT_INT_MASK, port->pirq.masked);
+	mutex_unlock(&dev->lock_irq);
+}
+
+static const struct irq_chip lan937x_pirq_chip = {
+	.name			= "lan937x-port",
+	.irq_mask		= lan937x_pirq_mask,
+	.irq_unmask		= lan937x_pirq_unmask,
+	.irq_bus_lock		= lan937x_pirq_bus_lock,
+	.irq_bus_sync_unlock	= lan937x_pirq_bus_sync_unlock,
+};
+
+static int lan937x_pirq_domain_map(struct irq_domain *d, unsigned int irq,
+				   irq_hw_number_t hwirq)
+{
+	struct ksz_port *port = d->host_data;
+
+	irq_set_chip_data(irq, d->host_data);
+	irq_set_chip_and_handler(irq, &port->pirq.chip, handle_level_irq);
+	irq_set_noprobe(irq);
+
+	return 0;
+}
+
+static const struct irq_domain_ops lan937x_pirq_domain_ops = {
+	.map	= lan937x_pirq_domain_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
+static void lan937x_pirq_free(struct ksz_device *dev, u8 p)
+{
+	struct ksz_port *port = &dev->ports[p];
+	int irq, virq;
+	int irq_num;
+
+	irq_num = irq_find_mapping(dev->girq.domain, p);
+	if (irq_num < 0)
+		return;
+
+	free_irq(irq_num, port);
+
+	for (irq = 0; irq < port->pirq.nirqs; irq++) {
+		virq = irq_find_mapping(port->pirq.domain, irq);
+		irq_dispose_mapping(virq);
+	}
+
+	irq_domain_remove(port->pirq.domain);
+}
+
+static irqreturn_t lan937x_pirq_thread_fn(int irq, void *dev_id)
+{
+	struct ksz_port *port = dev_id;
+	unsigned int nhandled = 0;
+	struct ksz_device *dev;
+	unsigned int sub_irq;
+	unsigned int n;
+	u8 data;
+
+	dev = port->ksz_dev;
+
+	/* Read port interrupt status register */
+	ksz_pread8(dev, port->num, REG_PORT_INT_STATUS, &data);
+
+	for (n = 0; n < port->pirq.nirqs; ++n) {
+		if (data & (1 << n)) {
+			sub_irq = irq_find_mapping(port->pirq.domain, n);
+			handle_nested_irq(sub_irq);
+			++nhandled;
+		}
+	}
+
+	return (nhandled > 0 ? IRQ_HANDLED : IRQ_NONE);
+}
+
+static int lan937x_pirq_setup(struct ksz_device *dev, u8 p)
+{
+	struct ksz_port *port = &dev->ports[p];
+	int ret, irq;
+	int irq_num;
+
+	port->pirq.nirqs = LAN937x_PNIRQS;
+	port->pirq.domain = irq_domain_add_simple(dev->dev->of_node,
+						  port->pirq.nirqs, 0,
+						  &lan937x_pirq_domain_ops,
+						  port);
+	if (!port->pirq.domain)
+		return -ENOMEM;
+
+	for (irq = 0; irq < port->pirq.nirqs; irq++)
+		irq_create_mapping(port->pirq.domain, irq);
+
+	port->pirq.chip = lan937x_pirq_chip;
+	port->pirq.masked = ~0;
+
+	irq_num = irq_find_mapping(dev->girq.domain, p);
+	if (irq_num < 0)
+		return irq_num;
+
+	snprintf(port->pirq.name, sizeof(port->pirq.name), "port_irq-%d", p);
+
+	ret = request_threaded_irq(irq_num, NULL, lan937x_pirq_thread_fn,
+				   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
+				   port->pirq.name, port);
+	if (ret)
+		goto out;
+
+	return 0;
+
+out:
+	lan937x_pirq_free(dev, p);
+
+	return ret;
+}
+
 int lan937x_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
+	struct dsa_port *dp;
 	int ret;
 
 	/* enable Indirect Access from SPI to the VPHY registers */
@@ -399,10 +727,22 @@ int lan937x_setup(struct dsa_switch *ds)
 		return ret;
 	}
 
+	if (dev->irq > 0) {
+		ret = lan937x_girq_setup(dev);
+		if (ret)
+			return ret;
+
+		dsa_switch_for_each_user_port(dp, dev->ds) {
+			ret = lan937x_pirq_setup(dev, dp->index);
+			if (ret)
+				goto out_girq;
+		}
+	}
+
 	ret = lan937x_mdio_register(dev);
 	if (ret < 0) {
 		dev_err(dev->dev, "failed to register the mdio");
-		return ret;
+		goto out_pirq;
 	}
 
 	/* The VLAN aware is a global setting. Mixed vlan
@@ -428,13 +768,29 @@ int lan937x_setup(struct dsa_switch *ds)
 		    (SW_CLK125_ENB | SW_CLK25_ENB), true);
 
 	return 0;
+
+out_pirq:
+	if (dev->irq > 0)
+		dsa_switch_for_each_user_port(dp, dev->ds)
+			lan937x_pirq_free(dev, dp->index);
+out_girq:
+	if (dev->irq > 0)
+		lan937x_girq_free(dev);
+
+	return ret;
 }
 
-int lan937x_switch_init(struct ksz_device *dev)
+void lan937x_teardown(struct dsa_switch *ds)
 {
-	dev->port_mask = (1 << dev->info->port_cnt) - 1;
+	struct ksz_device *dev = ds->priv;
+	struct dsa_port *dp;
 
-	return 0;
+	if (dev->irq > 0) {
+		dsa_switch_for_each_user_port(dp, dev->ds)
+			lan937x_pirq_free(dev, dp->index);
+
+		lan937x_girq_free(dev);
+	}
 }
 
 void lan937x_switch_exit(struct ksz_device *dev)
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index ba4adaddb3ec..a3c669d86e51 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -118,6 +118,18 @@
 /* Port Registers */
 
 /* 0 - Operation */
+#define REG_PORT_INT_STATUS		0x001B
+#define REG_PORT_INT_MASK		0x001F
+
+#define PORT_TAS_INT			BIT(5)
+#define PORT_QCI_INT			BIT(4)
+#define PORT_SGMII_INT			BIT(3)
+#define PORT_PTP_INT			BIT(2)
+#define PORT_PHY_INT			BIT(1)
+#define PORT_ACL_INT			BIT(0)
+
+#define PORT_SRC_PHY_INT		1
+
 #define REG_PORT_CTRL_0			0x0020
 
 #define PORT_MAC_LOOPBACK		BIT(7)
-- 
2.36.1

