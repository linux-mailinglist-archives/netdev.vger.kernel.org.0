Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3195E5C01
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiIVHNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbiIVHMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:12:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19391B7ED6;
        Thu, 22 Sep 2022 00:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663830741; x=1695366741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GdZjR87xvzvlWP9GhdzUWRjeO3+/IBJCBTHc7bupKO4=;
  b=qV+2lSiBSV2Fqq7hdy8/wJownp9jWRI71zetpm1AjM2dW89/NzMlTk/1
   QFYasVBASCunzrqqJ3PwytfC7XpA0b9jiGtkDhOdkgLTi9piJqGhHAmRp
   XhLDIJefq+MXi+SVOnT+PelVAWfEKp3fpjzLdjR37d6acD3t0Hvvhjv7k
   zJfHGlAa+H6kjrPY6CW0BUmAI18zdP0j8zZ03H+PGm6550avcx90YPUXK
   qJ2FqThJ2zcaZHP1vk1ZbL+pSol+wDhU9hSeLfFSTf9eRWlTIqw3NnZdX
   o242PP+5FM61h+Jkr+djmPwBZLSjwMijVH7x5oHuKc0SuBHTEIy3OtOqO
   g==;
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="178358053"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Sep 2022 00:12:19 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 22 Sep 2022 00:12:19 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 22 Sep 2022 00:12:13 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <arun.ramadoss@microchip.com>,
        <prasanna.vengateshan@microchip.com>, <hkallweit1@gmail.com>
Subject: [Patch net-next v4 5/6] net: dsa: microchip: use common irq routines for girq and pirq
Date:   Thu, 22 Sep 2022 12:40:27 +0530
Message-ID: <20220922071028.18012-6-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220922071028.18012-1-arun.ramadoss@microchip.com>
References: <20220922071028.18012-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The global port interrupt routines and individual ports interrupt
routines has similar implementation except the mask & status register
and number of nested irqs in them.  The mask & status register and
pointer to ksz_device is added to ksz_irq and uses the ksz_irq as
irq_chip_data.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 264 +++++++------------------
 drivers/net/dsa/microchip/ksz_common.h |   9 +-
 2 files changed, 81 insertions(+), 192 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 605ce3ffbeff..d612181b3226 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1768,97 +1768,97 @@ static int ksz_mdio_register(struct ksz_device *dev)
 	return ret;
 }
 
-static void ksz_girq_mask(struct irq_data *d)
+static void ksz_irq_mask(struct irq_data *d)
 {
-	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
-	unsigned int n = d->hwirq;
+	struct ksz_irq *kirq = irq_data_get_irq_chip_data(d);
 
-	dev->girq.masked |= (1 << n);
+	kirq->masked |= BIT(d->hwirq);
 }
 
-static void ksz_girq_unmask(struct irq_data *d)
+static void ksz_irq_unmask(struct irq_data *d)
 {
-	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
-	unsigned int n = d->hwirq;
+	struct ksz_irq *kirq = irq_data_get_irq_chip_data(d);
 
-	dev->girq.masked &= ~(1 << n);
+	kirq->masked &= ~BIT(d->hwirq);
 }
 
-static void ksz_girq_bus_lock(struct irq_data *d)
+static void ksz_irq_bus_lock(struct irq_data *d)
 {
-	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
+	struct ksz_irq *kirq  = irq_data_get_irq_chip_data(d);
 
-	mutex_lock(&dev->lock_irq);
+	mutex_lock(&kirq->dev->lock_irq);
 }
 
-static void ksz_girq_bus_sync_unlock(struct irq_data *d)
+static void ksz_irq_bus_sync_unlock(struct irq_data *d)
 {
-	struct ksz_device *dev = irq_data_get_irq_chip_data(d);
+	struct ksz_irq *kirq  = irq_data_get_irq_chip_data(d);
+	struct ksz_device *dev = kirq->dev;
 	int ret;
 
-	ret = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, dev->girq.masked);
+	ret = ksz_write32(dev, kirq->reg_mask, kirq->masked);
 	if (ret)
 		dev_err(dev->dev, "failed to change IRQ mask\n");
 
 	mutex_unlock(&dev->lock_irq);
 }
 
-static const struct irq_chip ksz_girq_chip = {
-	.name			= "ksz-global",
-	.irq_mask		= ksz_girq_mask,
-	.irq_unmask		= ksz_girq_unmask,
-	.irq_bus_lock		= ksz_girq_bus_lock,
-	.irq_bus_sync_unlock	= ksz_girq_bus_sync_unlock,
+static const struct irq_chip ksz_irq_chip = {
+	.name			= "ksz-irq",
+	.irq_mask		= ksz_irq_mask,
+	.irq_unmask		= ksz_irq_unmask,
+	.irq_bus_lock		= ksz_irq_bus_lock,
+	.irq_bus_sync_unlock	= ksz_irq_bus_sync_unlock,
 };
 
-static int ksz_girq_domain_map(struct irq_domain *d,
-			       unsigned int irq, irq_hw_number_t hwirq)
+static int ksz_irq_domain_map(struct irq_domain *d,
+			      unsigned int irq, irq_hw_number_t hwirq)
 {
-	struct ksz_device *dev = d->host_data;
-
 	irq_set_chip_data(irq, d->host_data);
-	irq_set_chip_and_handler(irq, &dev->girq.chip, handle_level_irq);
+	irq_set_chip_and_handler(irq, &ksz_irq_chip, handle_level_irq);
 	irq_set_noprobe(irq);
 
 	return 0;
 }
 
-static const struct irq_domain_ops ksz_girq_domain_ops = {
-	.map	= ksz_girq_domain_map,
+static const struct irq_domain_ops ksz_irq_domain_ops = {
+	.map	= ksz_irq_domain_map,
 	.xlate	= irq_domain_xlate_twocell,
 };
 
-static void ksz_girq_free(struct ksz_device *dev)
+static void ksz_irq_free(struct ksz_irq *kirq)
 {
 	int irq, virq;
 
-	free_irq(dev->irq, dev);
+	free_irq(kirq->irq_num, kirq);
 
-	for (irq = 0; irq < dev->girq.nirqs; irq++) {
-		virq = irq_find_mapping(dev->girq.domain, irq);
+	for (irq = 0; irq < kirq->nirqs; irq++) {
+		virq = irq_find_mapping(kirq->domain, irq);
 		irq_dispose_mapping(virq);
 	}
 
-	irq_domain_remove(dev->girq.domain);
+	irq_domain_remove(kirq->domain);
 }
 
-static irqreturn_t ksz_girq_thread_fn(int irq, void *dev_id)
+static irqreturn_t ksz_irq_thread_fn(int irq, void *dev_id)
 {
-	struct ksz_device *dev = dev_id;
+	struct ksz_irq *kirq = dev_id;
 	unsigned int nhandled = 0;
+	struct ksz_device *dev;
 	unsigned int sub_irq;
-	unsigned int n;
-	u32 data;
+	u8 data;
 	int ret;
+	u8 n;
 
-	/* Read global interrupt status register */
-	ret = ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data);
+	dev = kirq->dev;
+
+	/* Read interrupt status register */
+	ret = ksz_read8(dev, kirq->reg_status, &data);
 	if (ret)
 		goto out;
 
-	for (n = 0; n < dev->girq.nirqs; ++n) {
-		if (data & (1 << n)) {
-			sub_irq = irq_find_mapping(dev->girq.domain, n);
+	for (n = 0; n < kirq->nirqs; ++n) {
+		if (data & BIT(n)) {
+			sub_irq = irq_find_mapping(kirq->domain, n);
 			handle_nested_irq(sub_irq);
 			++nhandled;
 		}
@@ -1867,177 +1867,63 @@ static irqreturn_t ksz_girq_thread_fn(int irq, void *dev_id)
 	return (nhandled > 0 ? IRQ_HANDLED : IRQ_NONE);
 }
 
-static int ksz_girq_setup(struct ksz_device *dev)
+static int ksz_irq_common_setup(struct ksz_device *dev, struct ksz_irq *kirq)
 {
-	int ret, irq;
+	int ret, n;
 
-	dev->girq.nirqs = dev->info->port_cnt;
-	dev->girq.domain = irq_domain_add_simple(NULL, dev->girq.nirqs, 0,
-						 &ksz_girq_domain_ops, dev);
-	if (!dev->girq.domain)
-		return -ENOMEM;
+	kirq->dev = dev;
+	kirq->masked = ~0;
 
-	for (irq = 0; irq < dev->girq.nirqs; irq++)
-		irq_create_mapping(dev->girq.domain, irq);
+	kirq->domain = irq_domain_add_simple(dev->dev->of_node, kirq->nirqs, 0,
+					     &ksz_irq_domain_ops, kirq);
+	if (!kirq->domain)
+		return -ENOMEM;
 
-	dev->girq.chip = ksz_girq_chip;
-	dev->girq.masked = ~0;
+	for (n = 0; n < kirq->nirqs; n++)
+		irq_create_mapping(kirq->domain, n);
 
-	ret = request_threaded_irq(dev->irq, NULL, ksz_girq_thread_fn,
+	ret = request_threaded_irq(kirq->irq_num, NULL, ksz_irq_thread_fn,
 				   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
-				   dev_name(dev->dev), dev);
+				   kirq->name, kirq);
 	if (ret)
 		goto out;
 
 	return 0;
 
 out:
-	ksz_girq_free(dev);
+	ksz_irq_free(kirq);
 
 	return ret;
 }
 
-static void ksz_pirq_mask(struct irq_data *d)
-{
-	struct ksz_port *port = irq_data_get_irq_chip_data(d);
-	unsigned int n = d->hwirq;
-
-	port->pirq.masked |= (1 << n);
-}
-
-static void ksz_pirq_unmask(struct irq_data *d)
-{
-	struct ksz_port *port = irq_data_get_irq_chip_data(d);
-	unsigned int n = d->hwirq;
-
-	port->pirq.masked &= ~(1 << n);
-}
-
-static void ksz_pirq_bus_lock(struct irq_data *d)
-{
-	struct ksz_port *port = irq_data_get_irq_chip_data(d);
-	struct ksz_device *dev = port->ksz_dev;
-
-	mutex_lock(&dev->lock_irq);
-}
-
-static void ksz_pirq_bus_sync_unlock(struct irq_data *d)
-{
-	struct ksz_port *port = irq_data_get_irq_chip_data(d);
-	struct ksz_device *dev = port->ksz_dev;
-
-	ksz_pwrite8(dev, port->num, REG_PORT_INT_MASK, port->pirq.masked);
-	mutex_unlock(&dev->lock_irq);
-}
-
-static const struct irq_chip ksz_pirq_chip = {
-	.name			= "ksz-port",
-	.irq_mask		= ksz_pirq_mask,
-	.irq_unmask		= ksz_pirq_unmask,
-	.irq_bus_lock		= ksz_pirq_bus_lock,
-	.irq_bus_sync_unlock	= ksz_pirq_bus_sync_unlock,
-};
-
-static int ksz_pirq_domain_map(struct irq_domain *d, unsigned int irq,
-			       irq_hw_number_t hwirq)
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
-static const struct irq_domain_ops ksz_pirq_domain_ops = {
-	.map	= ksz_pirq_domain_map,
-	.xlate	= irq_domain_xlate_twocell,
-};
-
-static void ksz_pirq_free(struct ksz_device *dev, u8 p)
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
-static irqreturn_t ksz_pirq_thread_fn(int irq, void *dev_id)
+static int ksz_girq_setup(struct ksz_device *dev)
 {
-	struct ksz_port *port = dev_id;
-	unsigned int nhandled = 0;
-	struct ksz_device *dev;
-	unsigned int sub_irq;
-	unsigned int n;
-	u8 data;
-
-	dev = port->ksz_dev;
+	struct ksz_irq *girq = &dev->girq;
 
-	/* Read port interrupt status register */
-	ksz_pread8(dev, port->num, REG_PORT_INT_STATUS, &data);
+	girq->nirqs = dev->info->port_cnt;
+	girq->reg_mask = REG_SW_PORT_INT_MASK__1;
+	girq->reg_status = REG_SW_PORT_INT_STATUS__1;
+	snprintf(girq->name, sizeof(girq->name), "global_port_irq");
 
-	for (n = 0; n < port->pirq.nirqs; ++n) {
-		if (data & (1 << n)) {
-			sub_irq = irq_find_mapping(port->pirq.domain, n);
-			handle_nested_irq(sub_irq);
-			++nhandled;
-		}
-	}
+	girq->irq_num = dev->irq;
 
-	return (nhandled > 0 ? IRQ_HANDLED : IRQ_NONE);
+	return ksz_irq_common_setup(dev, girq);
 }
 
 static int ksz_pirq_setup(struct ksz_device *dev, u8 p)
 {
-	struct ksz_port *port = &dev->ports[p];
-	int ret, irq;
-	int irq_num;
-
-	port->pirq.nirqs = dev->info->port_nirqs;
-	port->pirq.domain = irq_domain_add_simple(dev->dev->of_node,
-						  port->pirq.nirqs, 0,
-						  &ksz_pirq_domain_ops,
-						  port);
-	if (!port->pirq.domain)
-		return -ENOMEM;
-
-	for (irq = 0; irq < port->pirq.nirqs; irq++)
-		irq_create_mapping(port->pirq.domain, irq);
-
-	port->pirq.chip = ksz_pirq_chip;
-	port->pirq.masked = ~0;
+	struct ksz_irq *pirq = &dev->ports[p].pirq;
 
-	irq_num = irq_find_mapping(dev->girq.domain, p);
-	if (irq_num < 0)
-		return irq_num;
+	pirq->nirqs = dev->info->port_nirqs;
+	pirq->reg_mask = dev->dev_ops->get_port_addr(p, REG_PORT_INT_MASK);
+	pirq->reg_status = dev->dev_ops->get_port_addr(p, REG_PORT_INT_STATUS);
+	snprintf(pirq->name, sizeof(pirq->name), "port_irq-%d", p);
 
-	snprintf(port->pirq.name, sizeof(port->pirq.name), "port_irq-%d", p);
+	pirq->irq_num = irq_find_mapping(dev->girq.domain, p);
+	if (pirq->irq_num < 0)
+		return pirq->irq_num;
 
-	ret = request_threaded_irq(irq_num, NULL, ksz_pirq_thread_fn,
-				   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
-				   port->pirq.name, port);
-	if (ret)
-		goto out;
-
-	return 0;
-
-out:
-	ksz_pirq_free(dev, p);
-
-	return ret;
+	return ksz_irq_common_setup(dev, pirq);
 }
 
 static int ksz_setup(struct dsa_switch *ds)
@@ -2119,10 +2005,10 @@ static int ksz_setup(struct dsa_switch *ds)
 out_pirq:
 	if (dev->irq > 0)
 		dsa_switch_for_each_user_port(dp, dev->ds)
-			ksz_pirq_free(dev, dp->index);
+			ksz_irq_free(&dev->ports[dp->index].pirq);
 out_girq:
 	if (dev->irq > 0)
-		ksz_girq_free(dev);
+		ksz_irq_free(&dev->girq);
 
 	return ret;
 }
@@ -2134,9 +2020,9 @@ static void ksz_teardown(struct dsa_switch *ds)
 
 	if (dev->irq > 0) {
 		dsa_switch_for_each_user_port(dp, dev->ds)
-			ksz_pirq_free(dev, dp->index);
+			ksz_irq_free(&dev->ports[dp->index].pirq);
 
-		ksz_girq_free(dev);
+		ksz_irq_free(&dev->girq);
 	}
 
 	if (dev->dev_ops->teardown)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 6edce587bfd2..9cfa179575ce 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -72,10 +72,13 @@ struct ksz_chip_data {
 
 struct ksz_irq {
 	u16 masked;
-	struct irq_chip chip;
+	u16 reg_mask;
+	u16 reg_status;
 	struct irq_domain *domain;
 	int nirqs;
+	int irq_num;
 	char name[16];
+	struct ksz_device *dev;
 };
 
 struct ksz_port {
@@ -574,8 +577,8 @@ static inline int is_lan937x(struct ksz_device *dev)
 #define P_MII_SEL_M			0x3
 
 /* Interrupt */
-#define REG_SW_PORT_INT_STATUS__4	0x0018
-#define REG_SW_PORT_INT_MASK__4		0x001C
+#define REG_SW_PORT_INT_STATUS__1	0x001B
+#define REG_SW_PORT_INT_MASK__1		0x001F
 
 #define REG_PORT_INT_STATUS		0x001B
 #define REG_PORT_INT_MASK		0x001F
-- 
2.36.1

