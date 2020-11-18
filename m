Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6CC2B85CD
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbgKRUjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:39:55 -0500
Received: from mailout07.rmx.de ([94.199.90.95]:41858 "EHLO mailout07.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726494AbgKRUjz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 15:39:55 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout07.rmx.de (Postfix) with ESMTPS id 4CbvnJ5kbPzBwnn;
        Wed, 18 Nov 2020 21:39:48 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4Cbvll6hsVz2xDw;
        Wed, 18 Nov 2020 21:38:27 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.25) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 18 Nov
 2020 21:33:52 +0100
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
Subject: [PATCH net-next v3 06/12] net: dsa: microchip: ksz9477: basic interrupt support
Date:   Wed, 18 Nov 2020 21:30:07 +0100
Message-ID: <20201118203013.5077-7-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201118203013.5077-1-ceggers@arri.de>
References: <20201118203013.5077-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.25]
X-RMX-ID: 20201118-213833-4Cbvll6hsVz2xDw-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Interrupts are required for TX time stamping. Probably they could also
be used for PHY connection status.

This patch only adds the basic infrastructure for interrupts, no
interrupts are finally enabled nor handled.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 drivers/net/dsa/microchip/ksz9477_i2c.c  |  2 +
 drivers/net/dsa/microchip/ksz9477_main.c | 68 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz9477_spi.c  |  2 +
 drivers/net/dsa/microchip/ksz_common.h   |  1 +
 4 files changed, 73 insertions(+)

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
index c0b4cf66c904..34964f6bf354 100644
--- a/drivers/net/dsa/microchip/ksz9477_main.c
+++ b/drivers/net/dsa/microchip/ksz9477_main.c
@@ -5,9 +5,12 @@
  * Copyright (C) 2017-2019 Microchip Technology Inc.
  */
 
+#include <linux/bits.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/interrupt.h>
 #include <linux/iopoll.h>
+#include <linux/irq.h>
 #include <linux/platform_data/microchip-ksz.h>
 #include <linux/phy.h>
 #include <linux/if_bridge.h>
@@ -1528,6 +1531,54 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 	},
 };
 
+static irqreturn_t ksz9477_switch_irq_thread(int irq, void *dev_id)
+{
+	struct ksz_device *dev = dev_id;
+	u32 data;
+	int port;
+	int ret;
+
+	/* Read global port interrupt status register */
+	ret = ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data);
+	if (ret)
+		return IRQ_NONE;
+
+	for (port = 0; port < dev->port_cnt; port++) {
+		u8 data8;
+
+		if (!(data & BIT(port)))
+			continue;
+
+		/* Read port interrupt status register */
+		ret = ksz_read8(dev, PORT_CTRL_ADDR(port, REG_PORT_INT_STATUS),
+				&data8);
+		if (ret)
+			return IRQ_NONE;
+
+		/* ToDo: Add specific handling of port interrupts */
+	}
+
+	return IRQ_NONE;
+}
+
+static int ksz9477_enable_port_interrupts(struct ksz_device *dev, bool enable)
+{
+	u32 data, mask = GENMASK(dev->port_cnt - 1, 0);
+	int ret;
+
+	ret = ksz_read32(dev, REG_SW_PORT_INT_MASK__4, &data);
+	if (ret)
+		return ret;
+
+	/* bits in REG_SW_PORT_INT_MASK__4 are low active */
+	if (enable)
+		data &= ~mask;
+	else
+		data |= mask;
+
+	return ksz_write32(dev, REG_SW_PORT_INT_MASK__4, data);
+}
+
 static int ksz9477_switch_init(struct ksz_device *dev)
 {
 	int i, ret;
@@ -1583,12 +1634,29 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 
 	/* set the real number of ports */
 	dev->ds->num_ports = dev->port_cnt;
+	if (dev->irq > 0) {
+		ret = devm_request_threaded_irq(dev->dev, dev->irq, NULL,
+						ksz9477_switch_irq_thread,
+						IRQF_ONESHOT | IRQF_SHARED,
+						dev_name(dev->dev),
+						dev);
+		if (ret) {
+			dev_err(dev->dev, "failed to request IRQ.\n");
+			return ret;
+		}
+
+		ret = ksz9477_enable_port_interrupts(dev, true);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
 
 static void ksz9477_switch_exit(struct ksz_device *dev)
 {
+	if (dev->irq > 0)
+		ksz9477_enable_port_interrupts(dev, false);
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
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index cf866e48ff66..5df4a7f9df02 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
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

