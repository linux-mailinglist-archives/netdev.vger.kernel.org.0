Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942A95B3C93
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 18:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbiIIQDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 12:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbiIIQCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 12:02:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B330C10D709;
        Fri,  9 Sep 2022 09:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662739344; x=1694275344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pFRmJWaZX4ddCd5aoTmUMSumtf5AcVR3xQvKQgfN4i0=;
  b=vjNsPIMDgyIVuI+KomzPFWci0MMPmIxHYt9facrLSF/as50pDzKfqwC6
   R8KT8NX0VKHRVC6J0fxCm5+RrniNXp7VhYyokeHPe432hkDtE6K0L86Hg
   i+zirIgMJEhDzmZfw4lnkFmd+eLLC41Hfi9jZ140JBsRCMQ4qgqMeyNiT
   qmkMyutR6kTK0sX/tqzSbnSGdUyFFrSXUmExyPDTH4hMbVYYUzbJYAXXI
   wSCBs/0VdS2drSGCSMuRNGENoJD8n3JNMxF7gup7I+QPm095mUU/t5IxG
   0Ict2ID351iNJuhLPzyLbSjAwl1XPIUcb34fi3l7w2cefc28rxs1DZP9R
   A==;
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="190177841"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Sep 2022 09:02:24 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Sep 2022 09:02:12 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Sep 2022 09:02:07 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>
Subject: [RFC Patch net-next 3/4] net: dsa: microchip: move interrupt handling logic from lan937x to ksz_common
Date:   Fri, 9 Sep 2022 21:31:19 +0530
Message-ID: <20220909160120.9101-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220909160120.9101-1-arun.ramadoss@microchip.com>
References: <20220909160120.9101-1-arun.ramadoss@microchip.com>
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

To support the phy link detection through interrupt method for ksz9477
based switch, the interrupt handling routines are moved from
lan937x_main.c to ksz_common.c. The only changes made are functions
names are prefixed with ksz_ instead of lan937x_.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c   | 428 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |   9 +
 drivers/net/dsa/microchip/lan937x_main.c | 426 ----------------------
 3 files changed, 437 insertions(+), 426 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index b91089a483e7..ee31b27e0c4a 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -14,6 +14,9 @@
 #include <linux/phy.h>
 #include <linux/etherdevice.h>
 #include <linux/if_bridge.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/of_mdio.h>
 #include <linux/of_device.h>
 #include <linux/of_net.h>
 #include <linux/micrel_phy.h>
@@ -1652,9 +1655,398 @@ static void ksz_update_port_member(struct ksz_device *dev, int port)
 	dev->dev_ops->cfg_port_member(dev, port, port_member | cpu_port);
 }
 
+static int ksz_sw_mdio_read(struct mii_bus *bus, int addr, int regnum)
+{
+	struct ksz_device *dev = bus->priv;
+	u16 val;
+	int ret;
+
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	ret = dev->dev_ops->r_phy(dev, addr, regnum, &val);
+	if (ret < 0)
+		return ret;
+
+	return val;
+}
+
+static int ksz_sw_mdio_write(struct mii_bus *bus, int addr, int regnum,
+			     u16 val)
+{
+	struct ksz_device *dev = bus->priv;
+
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	return dev->dev_ops->w_phy(dev, addr, regnum, val);
+}
+
+static int ksz_irq_phy_setup(struct ksz_device *dev)
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
+static void ksz_irq_phy_free(struct ksz_device *dev)
+{
+	struct dsa_switch *ds = dev->ds;
+	int phy;
+
+	for (phy = 0; phy < KSZ_MAX_NUM_PORTS; phy++)
+		if (BIT(phy) & ds->phys_mii_mask)
+			irq_dispose_mapping(ds->slave_mii_bus->irq[phy]);
+}
+
+static int ksz_mdio_register(struct ksz_device *dev)
+{
+	struct dsa_switch *ds = dev->ds;
+	struct device_node *mdio_np;
+	struct mii_bus *bus;
+	int ret;
+
+	mdio_np = of_get_child_by_name(dev->dev->of_node, "mdio");
+	if (!mdio_np) {
+		dev_err(ds->dev, "no MDIO bus node\n");
+		return -ENODEV;
+	}
+
+	bus = devm_mdiobus_alloc(ds->dev);
+	if (!bus) {
+		of_node_put(mdio_np);
+		return -ENOMEM;
+	}
+
+	bus->priv = dev;
+	bus->read = ksz_sw_mdio_read;
+	bus->write = ksz_sw_mdio_write;
+	bus->name = "ksz slave smi";
+	snprintf(bus->id, MII_BUS_ID_SIZE, "SMI-%d", ds->index);
+	bus->parent = ds->dev;
+	bus->phy_mask = ~ds->phys_mii_mask;
+
+	ds->slave_mii_bus = bus;
+
+	if (dev->irq > 0) {
+		ret = ksz_irq_phy_setup(dev);
+		if (ret) {
+			of_node_put(mdio_np);
+			return ret;
+		}
+	}
+
+	ret = devm_of_mdiobus_register(ds->dev, bus, mdio_np);
+	if (ret) {
+		dev_err(ds->dev, "unable to register MDIO bus %s\n",
+			bus->id);
+		if (dev->irq > 0)
+			ksz_irq_phy_free(dev);
+	}
+
+	of_node_put(mdio_np);
+
+	return ret;
+}
+
+static void ksz_girq_mask(struct irq_data *d)
+{
+	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
+	unsigned int n = d->hwirq;
+
+	dev->girq.masked |= (1 << n);
+}
+
+static void ksz_girq_unmask(struct irq_data *d)
+{
+	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
+	unsigned int n = d->hwirq;
+
+	dev->girq.masked &= ~(1 << n);
+}
+
+static void ksz_girq_bus_lock(struct irq_data *d)
+{
+	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
+
+	mutex_lock(&dev->lock_irq);
+}
+
+static void ksz_girq_bus_sync_unlock(struct irq_data *d)
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
+static const struct irq_chip ksz_girq_chip = {
+	.name			= "ksz-global",
+	.irq_mask		= ksz_girq_mask,
+	.irq_unmask		= ksz_girq_unmask,
+	.irq_bus_lock		= ksz_girq_bus_lock,
+	.irq_bus_sync_unlock	= ksz_girq_bus_sync_unlock,
+};
+
+static int ksz_girq_domain_map(struct irq_domain *d,
+			       unsigned int irq, irq_hw_number_t hwirq)
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
+static const struct irq_domain_ops ksz_girq_domain_ops = {
+	.map	= ksz_girq_domain_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
+static void ksz_girq_free(struct ksz_device *dev)
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
+static irqreturn_t ksz_girq_thread_fn(int irq, void *dev_id)
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
+static int ksz_girq_setup(struct ksz_device *dev)
+{
+	int ret, irq;
+
+	dev->girq.nirqs = dev->info->port_cnt;
+	dev->girq.domain = irq_domain_add_simple(NULL, dev->girq.nirqs, 0,
+						 &ksz_girq_domain_ops, dev);
+	if (!dev->girq.domain)
+		return -ENOMEM;
+
+	for (irq = 0; irq < dev->girq.nirqs; irq++)
+		irq_create_mapping(dev->girq.domain, irq);
+
+	dev->girq.chip = ksz_girq_chip;
+	dev->girq.masked = ~0;
+
+	ret = request_threaded_irq(dev->irq, NULL, ksz_girq_thread_fn,
+				   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
+				   dev_name(dev->dev), dev);
+	if (ret)
+		goto out;
+
+	return 0;
+
+out:
+	ksz_girq_free(dev);
+
+	return ret;
+}
+
+static void ksz_pirq_mask(struct irq_data *d)
+{
+	struct ksz_port *port = irq_data_get_irq_chip_data(d);
+	unsigned int n = d->hwirq;
+
+	port->pirq.masked |= (1 << n);
+}
+
+static void ksz_pirq_unmask(struct irq_data *d)
+{
+	struct ksz_port *port = irq_data_get_irq_chip_data(d);
+	unsigned int n = d->hwirq;
+
+	port->pirq.masked &= ~(1 << n);
+}
+
+static void ksz_pirq_bus_lock(struct irq_data *d)
+{
+	struct ksz_port *port = irq_data_get_irq_chip_data(d);
+	struct ksz_device *dev = port->ksz_dev;
+
+	mutex_lock(&dev->lock_irq);
+}
+
+static void ksz_pirq_bus_sync_unlock(struct irq_data *d)
+{
+	struct ksz_port *port = irq_data_get_irq_chip_data(d);
+	struct ksz_device *dev = port->ksz_dev;
+
+	ksz_pwrite8(dev, port->num, REG_PORT_INT_MASK, port->pirq.masked);
+	mutex_unlock(&dev->lock_irq);
+}
+
+static const struct irq_chip ksz_pirq_chip = {
+	.name			= "ksz-port",
+	.irq_mask		= ksz_pirq_mask,
+	.irq_unmask		= ksz_pirq_unmask,
+	.irq_bus_lock		= ksz_pirq_bus_lock,
+	.irq_bus_sync_unlock	= ksz_pirq_bus_sync_unlock,
+};
+
+static int ksz_pirq_domain_map(struct irq_domain *d, unsigned int irq,
+			       irq_hw_number_t hwirq)
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
+static const struct irq_domain_ops ksz_pirq_domain_ops = {
+	.map	= ksz_pirq_domain_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
+static void ksz_pirq_free(struct ksz_device *dev, u8 p)
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
+static irqreturn_t ksz_pirq_thread_fn(int irq, void *dev_id)
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
+static int ksz_pirq_setup(struct ksz_device *dev, u8 p)
+{
+	struct ksz_port *port = &dev->ports[p];
+	int ret, irq;
+	int irq_num;
+
+	port->pirq.nirqs = dev->info->port_nirqs;
+	port->pirq.domain = irq_domain_add_simple(dev->dev->of_node,
+						  port->pirq.nirqs, 0,
+						  &ksz_pirq_domain_ops,
+						  port);
+	if (!port->pirq.domain)
+		return -ENOMEM;
+
+	for (irq = 0; irq < port->pirq.nirqs; irq++)
+		irq_create_mapping(port->pirq.domain, irq);
+
+	port->pirq.chip = ksz_pirq_chip;
+	port->pirq.masked = ~0;
+
+	irq_num = irq_find_mapping(dev->girq.domain, p);
+	if (irq_num < 0)
+		return irq_num;
+
+	snprintf(port->pirq.name, sizeof(port->pirq.name), "port_irq-%d", p);
+
+	ret = request_threaded_irq(irq_num, NULL, ksz_pirq_thread_fn,
+				   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
+				   port->pirq.name, port);
+	if (ret)
+		goto out;
+
+	return 0;
+
+out:
+	ksz_pirq_free(dev, p);
+
+	return ret;
+}
+
 static int ksz_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
+	struct dsa_port *dp;
 	struct ksz_port *p;
 	const u16 *regs;
 	int ret;
@@ -1703,16 +2095,52 @@ static int ksz_setup(struct dsa_switch *ds)
 	p = &dev->ports[dev->cpu_port];
 	p->learning = true;
 
+	if (dev->irq > 0) {
+		ret = ksz_girq_setup(dev);
+		if (ret)
+			return ret;
+
+		dsa_switch_for_each_user_port(dp, dev->ds) {
+			ret = ksz_pirq_setup(dev, dp->index);
+			if (ret)
+				goto out_girq;
+		}
+	}
+
+	ret = ksz_mdio_register(dev);
+	if (ret < 0) {
+		dev_err(dev->dev, "failed to register the mdio");
+		goto out_pirq;
+	}
+
 	/* start switch */
 	regmap_update_bits(dev->regmap[0], regs[S_START_CTRL],
 			   SW_START, SW_START);
 
 	return 0;
+
+out_pirq:
+	if (dev->irq > 0)
+		dsa_switch_for_each_user_port(dp, dev->ds)
+			ksz_pirq_free(dev, dp->index);
+out_girq:
+	if (dev->irq > 0)
+		ksz_girq_free(dev);
+
+	return ret;
 }
 
 static void ksz_teardown(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
+	struct dsa_port *dp;
+
+	if (dev->irq > 0) {
+		dsa_switch_for_each_user_port(dp, dev->ds)
+			ksz_pirq_free(dev, dp->index);
+
+		ksz_girq_free(dev);
+	}
 
 	if (dev->dev_ops->teardown)
 		dev->dev_ops->teardown(ds);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index baa1e1bc1b7c..6edce587bfd2 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -573,6 +573,15 @@ static inline int is_lan937x(struct ksz_device *dev)
 #define P_MII_MAC_MODE			BIT(2)
 #define P_MII_SEL_M			0x3
 
+/* Interrupt */
+#define REG_SW_PORT_INT_STATUS__4	0x0018
+#define REG_SW_PORT_INT_MASK__4		0x001C
+
+#define REG_PORT_INT_STATUS		0x001B
+#define REG_PORT_INT_MASK		0x001F
+
+#define PORT_SRC_PHY_INT		1
+
 /* Regmap tables generation */
 #define KSZ_SPI_OP_RD		3
 #define KSZ_SPI_OP_WR		2
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 1f4472c90a1f..715c44544dd7 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -7,11 +7,8 @@
 #include <linux/iopoll.h>
 #include <linux/phy.h>
 #include <linux/of_net.h>
-#include <linux/of_mdio.h>
 #include <linux/if_bridge.h>
 #include <linux/if_vlan.h>
-#include <linux/irq.h>
-#include <linux/irqdomain.h>
 #include <linux/math.h>
 #include <net/dsa.h>
 #include <net/switchdev.h>
@@ -140,120 +137,6 @@ int lan937x_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
 	return lan937x_internal_phy_write(dev, addr, reg, val);
 }
 
-static int lan937x_sw_mdio_read(struct mii_bus *bus, int addr, int regnum)
-{
-	struct ksz_device *dev = bus->priv;
-	u16 val;
-	int ret;
-
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
-	ret = lan937x_internal_phy_read(dev, addr, regnum, &val);
-	if (ret < 0)
-		return ret;
-
-	return val;
-}
-
-static int lan937x_sw_mdio_write(struct mii_bus *bus, int addr, int regnum,
-				 u16 val)
-{
-	struct ksz_device *dev = bus->priv;
-
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
-	return lan937x_internal_phy_write(dev, addr, regnum, val);
-}
-
-static int lan937x_irq_phy_setup(struct ksz_device *dev)
-{
-	struct dsa_switch *ds = dev->ds;
-	int phy, err_phy;
-	int irq;
-	int ret;
-
-	for (phy = 0; phy < KSZ_MAX_NUM_PORTS; phy++) {
-		if (BIT(phy) & ds->phys_mii_mask) {
-			irq = irq_find_mapping(dev->ports[phy].pirq.domain,
-					       PORT_SRC_PHY_INT);
-			if (irq < 0) {
-				ret = irq;
-				goto out;
-			}
-			ds->slave_mii_bus->irq[phy] = irq;
-		}
-	}
-	return 0;
-out:
-	err_phy = phy;
-
-	for (phy = 0; phy < err_phy; phy++)
-		if (BIT(phy) & ds->phys_mii_mask)
-			irq_dispose_mapping(ds->slave_mii_bus->irq[phy]);
-
-	return ret;
-}
-
-static void lan937x_irq_phy_free(struct ksz_device *dev)
-{
-	struct dsa_switch *ds = dev->ds;
-	int phy;
-
-	for (phy = 0; phy < KSZ_MAX_NUM_PORTS; phy++)
-		if (BIT(phy) & ds->phys_mii_mask)
-			irq_dispose_mapping(ds->slave_mii_bus->irq[phy]);
-}
-
-static int lan937x_mdio_register(struct ksz_device *dev)
-{
-	struct dsa_switch *ds = dev->ds;
-	struct device_node *mdio_np;
-	struct mii_bus *bus;
-	int ret;
-
-	mdio_np = of_get_child_by_name(dev->dev->of_node, "mdio");
-	if (!mdio_np) {
-		dev_err(ds->dev, "no MDIO bus node\n");
-		return -ENODEV;
-	}
-
-	bus = devm_mdiobus_alloc(ds->dev);
-	if (!bus) {
-		of_node_put(mdio_np);
-		return -ENOMEM;
-	}
-
-	bus->priv = dev;
-	bus->read = lan937x_sw_mdio_read;
-	bus->write = lan937x_sw_mdio_write;
-	bus->name = "lan937x slave smi";
-	snprintf(bus->id, MII_BUS_ID_SIZE, "SMI-%d", ds->index);
-	bus->parent = ds->dev;
-	bus->phy_mask = ~ds->phys_mii_mask;
-
-	ds->slave_mii_bus = bus;
-
-	if (dev->irq > 0) {
-		ret = lan937x_irq_phy_setup(dev);
-		if (ret)
-			return ret;
-	}
-
-	ret = devm_of_mdiobus_register(ds->dev, bus, mdio_np);
-	if (ret) {
-		dev_err(ds->dev, "unable to register MDIO bus %s\n",
-			bus->id);
-		if (dev->irq > 0)
-			lan937x_irq_phy_free(dev);
-	}
-
-	of_node_put(mdio_np);
-
-	return ret;
-}
-
 int lan937x_reset_switch(struct ksz_device *dev)
 {
 	u32 data32;
@@ -460,282 +343,9 @@ int lan937x_switch_init(struct ksz_device *dev)
 	return 0;
 }
 
-static void lan937x_girq_mask(struct irq_data *d)
-{
-	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
-	unsigned int n = d->hwirq;
-
-	dev->girq.masked |= (1 << n);
-}
-
-static void lan937x_girq_unmask(struct irq_data *d)
-{
-	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
-	unsigned int n = d->hwirq;
-
-	dev->girq.masked &= ~(1 << n);
-}
-
-static void lan937x_girq_bus_lock(struct irq_data *d)
-{
-	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
-
-	mutex_lock(&dev->lock_irq);
-}
-
-static void lan937x_girq_bus_sync_unlock(struct irq_data *d)
-{
-	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
-	int ret;
-
-	ret = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, dev->girq.masked);
-	if (ret)
-		dev_err(dev->dev, "failed to change IRQ mask\n");
-
-	mutex_unlock(&dev->lock_irq);
-}
-
-static const struct irq_chip lan937x_girq_chip = {
-	.name			= "lan937x-global",
-	.irq_mask		= lan937x_girq_mask,
-	.irq_unmask		= lan937x_girq_unmask,
-	.irq_bus_lock		= lan937x_girq_bus_lock,
-	.irq_bus_sync_unlock	= lan937x_girq_bus_sync_unlock,
-};
-
-static int lan937x_girq_domain_map(struct irq_domain *d,
-				   unsigned int irq, irq_hw_number_t hwirq)
-{
-	struct ksz_device *dev = d->host_data;
-
-	irq_set_chip_data(irq, d->host_data);
-	irq_set_chip_and_handler(irq, &dev->girq.chip, handle_level_irq);
-	irq_set_noprobe(irq);
-
-	return 0;
-}
-
-static const struct irq_domain_ops lan937x_girq_domain_ops = {
-	.map	= lan937x_girq_domain_map,
-	.xlate	= irq_domain_xlate_twocell,
-};
-
-static void lan937x_girq_free(struct ksz_device *dev)
-{
-	int irq, virq;
-
-	free_irq(dev->irq, dev);
-
-	for (irq = 0; irq < dev->girq.nirqs; irq++) {
-		virq = irq_find_mapping(dev->girq.domain, irq);
-		irq_dispose_mapping(virq);
-	}
-
-	irq_domain_remove(dev->girq.domain);
-}
-
-static irqreturn_t lan937x_girq_thread_fn(int irq, void *dev_id)
-{
-	struct ksz_device *dev = dev_id;
-	unsigned int nhandled = 0;
-	unsigned int sub_irq;
-	unsigned int n;
-	u32 data;
-	int ret;
-
-	/* Read global interrupt status register */
-	ret = ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data);
-	if (ret)
-		goto out;
-
-	for (n = 0; n < dev->girq.nirqs; ++n) {
-		if (data & (1 << n)) {
-			sub_irq = irq_find_mapping(dev->girq.domain, n);
-			handle_nested_irq(sub_irq);
-			++nhandled;
-		}
-	}
-out:
-	return (nhandled > 0 ? IRQ_HANDLED : IRQ_NONE);
-}
-
-static int lan937x_girq_setup(struct ksz_device *dev)
-{
-	int ret, irq;
-
-	dev->girq.nirqs = dev->info->port_cnt;
-	dev->girq.domain = irq_domain_add_simple(NULL, dev->girq.nirqs, 0,
-						 &lan937x_girq_domain_ops, dev);
-	if (!dev->girq.domain)
-		return -ENOMEM;
-
-	for (irq = 0; irq < dev->girq.nirqs; irq++)
-		irq_create_mapping(dev->girq.domain, irq);
-
-	dev->girq.chip = lan937x_girq_chip;
-	dev->girq.masked = ~0;
-
-	ret = request_threaded_irq(dev->irq, NULL, lan937x_girq_thread_fn,
-				   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
-				   dev_name(dev->dev), dev);
-	if (ret)
-		goto out;
-
-	return 0;
-
-out:
-	lan937x_girq_free(dev);
-
-	return ret;
-}
-
-static void lan937x_pirq_mask(struct irq_data *d)
-{
-	struct ksz_port *port = irq_data_get_irq_chip_data(d);
-	unsigned int n = d->hwirq;
-
-	port->pirq.masked |= (1 << n);
-}
-
-static void lan937x_pirq_unmask(struct irq_data *d)
-{
-	struct ksz_port *port = irq_data_get_irq_chip_data(d);
-	unsigned int n = d->hwirq;
-
-	port->pirq.masked &= ~(1 << n);
-}
-
-static void lan937x_pirq_bus_lock(struct irq_data *d)
-{
-	struct ksz_port *port = irq_data_get_irq_chip_data(d);
-	struct ksz_device *dev = port->ksz_dev;
-
-	mutex_lock(&dev->lock_irq);
-}
-
-static void lan937x_pirq_bus_sync_unlock(struct irq_data *d)
-{
-	struct ksz_port *port = irq_data_get_irq_chip_data(d);
-	struct ksz_device *dev = port->ksz_dev;
-
-	ksz_pwrite8(dev, port->num, REG_PORT_INT_MASK, port->pirq.masked);
-	mutex_unlock(&dev->lock_irq);
-}
-
-static const struct irq_chip lan937x_pirq_chip = {
-	.name			= "lan937x-port",
-	.irq_mask		= lan937x_pirq_mask,
-	.irq_unmask		= lan937x_pirq_unmask,
-	.irq_bus_lock		= lan937x_pirq_bus_lock,
-	.irq_bus_sync_unlock	= lan937x_pirq_bus_sync_unlock,
-};
-
-static int lan937x_pirq_domain_map(struct irq_domain *d, unsigned int irq,
-				   irq_hw_number_t hwirq)
-{
-	struct ksz_port *port = d->host_data;
-
-	irq_set_chip_data(irq, d->host_data);
-	irq_set_chip_and_handler(irq, &port->pirq.chip, handle_level_irq);
-	irq_set_noprobe(irq);
-
-	return 0;
-}
-
-static const struct irq_domain_ops lan937x_pirq_domain_ops = {
-	.map	= lan937x_pirq_domain_map,
-	.xlate	= irq_domain_xlate_twocell,
-};
-
-static void lan937x_pirq_free(struct ksz_device *dev, u8 p)
-{
-	struct ksz_port *port = &dev->ports[p];
-	int irq, virq;
-	int irq_num;
-
-	irq_num = irq_find_mapping(dev->girq.domain, p);
-	if (irq_num < 0)
-		return;
-
-	free_irq(irq_num, port);
-
-	for (irq = 0; irq < port->pirq.nirqs; irq++) {
-		virq = irq_find_mapping(port->pirq.domain, irq);
-		irq_dispose_mapping(virq);
-	}
-
-	irq_domain_remove(port->pirq.domain);
-}
-
-static irqreturn_t lan937x_pirq_thread_fn(int irq, void *dev_id)
-{
-	struct ksz_port *port = dev_id;
-	unsigned int nhandled = 0;
-	struct ksz_device *dev;
-	unsigned int sub_irq;
-	unsigned int n;
-	u8 data;
-
-	dev = port->ksz_dev;
-
-	/* Read port interrupt status register */
-	ksz_pread8(dev, port->num, REG_PORT_INT_STATUS, &data);
-
-	for (n = 0; n < port->pirq.nirqs; ++n) {
-		if (data & (1 << n)) {
-			sub_irq = irq_find_mapping(port->pirq.domain, n);
-			handle_nested_irq(sub_irq);
-			++nhandled;
-		}
-	}
-
-	return (nhandled > 0 ? IRQ_HANDLED : IRQ_NONE);
-}
-
-static int lan937x_pirq_setup(struct ksz_device *dev, u8 p)
-{
-	struct ksz_port *port = &dev->ports[p];
-	int ret, irq;
-	int irq_num;
-
-	port->pirq.nirqs = dev->info->port_nirqs;
-	port->pirq.domain = irq_domain_add_simple(dev->dev->of_node,
-						  port->pirq.nirqs, 0,
-						  &lan937x_pirq_domain_ops,
-						  port);
-	if (!port->pirq.domain)
-		return -ENOMEM;
-
-	for (irq = 0; irq < port->pirq.nirqs; irq++)
-		irq_create_mapping(port->pirq.domain, irq);
-
-	port->pirq.chip = lan937x_pirq_chip;
-	port->pirq.masked = ~0;
-
-	irq_num = irq_find_mapping(dev->girq.domain, p);
-	if (irq_num < 0)
-		return irq_num;
-
-	snprintf(port->pirq.name, sizeof(port->pirq.name), "port_irq-%d", p);
-
-	ret = request_threaded_irq(irq_num, NULL, lan937x_pirq_thread_fn,
-				   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
-				   port->pirq.name, port);
-	if (ret)
-		goto out;
-
-	return 0;
-
-out:
-	lan937x_pirq_free(dev, p);
-
-	return ret;
-}
-
 int lan937x_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
-	struct dsa_port *dp;
 	int ret;
 
 	/* enable Indirect Access from SPI to the VPHY registers */
@@ -745,24 +355,6 @@ int lan937x_setup(struct dsa_switch *ds)
 		return ret;
 	}
 
-	if (dev->irq > 0) {
-		ret = lan937x_girq_setup(dev);
-		if (ret)
-			return ret;
-
-		dsa_switch_for_each_user_port(dp, dev->ds) {
-			ret = lan937x_pirq_setup(dev, dp->index);
-			if (ret)
-				goto out_girq;
-		}
-	}
-
-	ret = lan937x_mdio_register(dev);
-	if (ret < 0) {
-		dev_err(dev->dev, "failed to register the mdio");
-		goto out_pirq;
-	}
-
 	/* The VLAN aware is a global setting. Mixed vlan
 	 * filterings are not supported.
 	 */
@@ -786,29 +378,11 @@ int lan937x_setup(struct dsa_switch *ds)
 		    (SW_CLK125_ENB | SW_CLK25_ENB), true);
 
 	return 0;
-
-out_pirq:
-	if (dev->irq > 0)
-		dsa_switch_for_each_user_port(dp, dev->ds)
-			lan937x_pirq_free(dev, dp->index);
-out_girq:
-	if (dev->irq > 0)
-		lan937x_girq_free(dev);
-
-	return ret;
 }
 
 void lan937x_teardown(struct dsa_switch *ds)
 {
-	struct ksz_device *dev = ds->priv;
-	struct dsa_port *dp;
 
-	if (dev->irq > 0) {
-		dsa_switch_for_each_user_port(dp, dev->ds)
-			lan937x_pirq_free(dev, dp->index);
-
-		lan937x_girq_free(dev);
-	}
 }
 
 void lan937x_switch_exit(struct ksz_device *dev)
-- 
2.36.1

