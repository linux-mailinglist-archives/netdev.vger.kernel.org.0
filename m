Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DA52B08C3
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgKLPqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:46:11 -0500
Received: from mailout11.rmx.de ([94.199.88.76]:50340 "EHLO mailout11.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728725AbgKLPqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 10:46:10 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout11.rmx.de (Postfix) with ESMTPS id 4CX5Y80WRPz40s8;
        Thu, 12 Nov 2020 16:46:04 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CX5Wb1Tqyz2xDT;
        Thu, 12 Nov 2020 16:44:43 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.59) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 12 Nov
 2020 16:39:16 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        "Rob Herring" <robh+dt@kernel.org>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Christian Eggers <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2 06/11] net: dsa: microchip: ksz9477: basic interrupt support
Date:   Thu, 12 Nov 2020 16:35:32 +0100
Message-ID: <20201112153537.22383-7-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112153537.22383-1-ceggers@arri.de>
References: <20201112153537.22383-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.59]
X-RMX-ID: 20201112-164449-4CX5Wb1Tqyz2xDT-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Interrupts are required for TX time stamping. Probably they could also
be used for PHY connection status.

This patch only adds the basic infrastructure for interrupts, no
interrupts are actually enabled nor handled.

ksz9477_reset_switch() must be called before requesting the IRQ (in
ksz9477_init() instead of ksz9477_setup()).

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 drivers/net/dsa/microchip/ksz9477_i2c.c  |   2 +
 drivers/net/dsa/microchip/ksz9477_main.c | 103 +++++++++++++++++++++--
 drivers/net/dsa/microchip/ksz9477_spi.c  |   2 +
 include/linux/dsa/ksz_common.h           |   1 +
 4 files changed, 100 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 4e053a25d077..4ed1f503044a 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -41,6 +41,8 @@ static int ksz9477_i2c_probe(struct i2c_client *i2c,
 	if (i2c->dev.platform_data)
 		dev->pdata = i2c->dev.platform_data;
 
+	dev->irq = i2c->irq;
+
 	ret = ksz9477_switch_register(dev);
 
 	/* Main DSA driver may not be started yet. */
diff --git a/drivers/net/dsa/microchip/ksz9477_main.c b/drivers/net/dsa/microchip/ksz9477_main.c
index abfd3802bb51..6b5a981fb21f 100644
--- a/drivers/net/dsa/microchip/ksz9477_main.c
+++ b/drivers/net/dsa/microchip/ksz9477_main.c
@@ -7,7 +7,9 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/interrupt.h>
 #include <linux/iopoll.h>
+#include <linux/irq.h>
 #include <linux/platform_data/microchip-ksz.h>
 #include <linux/phy.h>
 #include <linux/if_bridge.h>
@@ -1345,19 +1347,12 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 static int ksz9477_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
-	int ret = 0;
 
 	dev->vlan_cache = devm_kcalloc(dev->dev, sizeof(struct vlan_table),
 				       dev->num_vlans, GFP_KERNEL);
 	if (!dev->vlan_cache)
 		return -ENOMEM;
 
-	ret = ksz9477_reset_switch(dev);
-	if (ret) {
-		dev_err(ds->dev, "failed to reset switch\n");
-		return ret;
-	}
-
 	/* Required for port partitioning. */
 	ksz9477_cfg32(dev, REG_SW_QM_CTRL__4, UNICAST_VLAN_BOUNDARY,
 		      true);
@@ -1535,12 +1530,84 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 	},
 };
 
+static irqreturn_t ksz9477_switch_irq_thread(int irq, void *dev_id)
+{
+	struct ksz_device *dev = dev_id;
+	u32 data;
+	int port;
+	int ret;
+	irqreturn_t result = IRQ_NONE;
+
+	/* Read global port interrupt status register */
+	ret = ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data);
+	if (ret)
+		return result;
+
+	for (port = 0; port < dev->port_cnt; port++) {
+		if (data & BIT(port)) {
+			u8 data8;
+
+			/* Read port interrupt status register */
+			ret = ksz_read8(dev, PORT_CTRL_ADDR(port, REG_PORT_INT_STATUS),
+					&data8);
+			if (ret)
+				return result;
+
+			/* ToDo: Add specific handling of port interrupts */
+		}
+	}
+
+	return result;
+}
+
+static int ksz9477_enable_port_interrupts(struct ksz_device *dev)
+{
+	u32 data;
+	int ret;
+
+	ret = ksz_read32(dev, REG_SW_PORT_INT_MASK__4, &data);
+	if (ret)
+		return ret;
+
+	/* Enable port interrupts (0 means enabled) */
+	data &= ~((1 << dev->port_cnt) - 1);
+	ret = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, data);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ksz9477_disable_port_interrupts(struct ksz_device *dev)
+{
+	u32 data;
+	int ret;
+
+	ret = ksz_read32(dev, REG_SW_PORT_INT_MASK__4, &data);
+	if (ret)
+		return ret;
+
+	/* Disable port interrupts (1 means disabled) */
+	data |= ((1 << dev->port_cnt) - 1);
+	ret = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, data);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int ksz9477_switch_init(struct ksz_device *dev)
 {
-	int i;
+	int i, ret;
 
 	dev->ds->ops = &ksz9477_switch_ops;
 
+	ret = ksz9477_reset_switch(dev);
+	if (ret) {
+		dev_err(dev->dev, "failed to reset switch\n");
+		return ret;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(ksz9477_switch_chips); i++) {
 		const struct ksz_chip_data *chip = &ksz9477_switch_chips[i];
 
@@ -1584,12 +1651,32 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 
 	/* set the real number of ports */
 	dev->ds->num_ports = dev->port_cnt;
+	if (dev->irq > 0) {
+		unsigned long irqflags = irqd_get_trigger_type(irq_get_irq_data(dev->irq));
+
+		irqflags |= IRQF_ONESHOT;
+		ret = devm_request_threaded_irq(dev->dev, dev->irq, NULL,
+						ksz9477_switch_irq_thread,
+						irqflags,
+						dev_name(dev->dev),
+						dev);
+		if (ret) {
+			dev_err(dev->dev, "failed to request IRQ.\n");
+			return ret;
+		}
+
+		ret = ksz9477_enable_port_interrupts(dev);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
 
 static void ksz9477_switch_exit(struct ksz_device *dev)
 {
+	if (dev->irq > 0)
+		ksz9477_disable_port_interrupts(dev);
 	ksz9477_reset_switch(dev);
 }
 
diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index 1142768969c2..d2eea9596e53 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -48,6 +48,8 @@ static int ksz9477_spi_probe(struct spi_device *spi)
 	if (spi->dev.platform_data)
 		dev->pdata = spi->dev.platform_data;
 
+	dev->irq = spi->irq;
+
 	ret = ksz9477_switch_register(dev);
 
 	/* Main DSA driver may not be started yet. */
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index 3b22380d85c5..bf57ba4b2132 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -55,6 +55,7 @@ struct ksz_device {
 
 	struct device *dev;
 	struct regmap *regmap[3];
+	int irq;
 
 	void *priv;
 
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

