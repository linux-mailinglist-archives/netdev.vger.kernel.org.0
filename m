Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0773F7554
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 14:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241011AbhHYMsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241029AbhHYMsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:48:07 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D265C0617AF;
        Wed, 25 Aug 2021 05:47:21 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d17so14241642plr.12;
        Wed, 25 Aug 2021 05:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=imY1sQT0/lpEGhDIGogn209SW9JcfCkHmDP9lVMvNu8=;
        b=UT2J5QnYZ0kwFFXvFALA3zKOZ+kK+h+o0sSN3WpzA2QNhvdp0uxonk66waHT6p/J4v
         yWjncGWoqCWM845s2Jy4yRD5BcjZrfCvzEQKIWuyxDguRp2xBiRpHZ6OimVvcG/8+6O4
         NGaAYmzjY5qXLgq8ndGeWGKEhpLIbGymCKvrvA9DLrVWgYGS+FsHIszm2hds7pL7UMKT
         LjkQlOQUa/01xnw9a/eCx3PTRBxx+IkxqOeara6jVxQBFW1+tXTGDGMj54YmXSG8S5s3
         K2B5I3YEXCIktXQiUC3yoME8OBA1x9lcidFPsBQx6KaNy3paix20PuA6iPE8L1DTR0D6
         WwgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=imY1sQT0/lpEGhDIGogn209SW9JcfCkHmDP9lVMvNu8=;
        b=FoF63rZ+seNjdj3D9bgdaRY1KeJKjiE5yr4vd9s/VLDlX8ZT9cegvyH0tA2HVmN1oc
         lb7rmfop/in2c6FMGFNUXZtdYY4KG44lNMQCOSWQn0iz0PE1pViJiGa+tgjBOGf0O2mp
         COn8h9PqXTbLTY4+hiTNoIPssvjD1ILLjpn2rjml/dKmcLoIeKKE6+iWq1FH9VZP65uT
         spUZYJogCyTMe/33/Lf/58oUM2uHmsdXUodVJUqoEJHWvsGk5Fw8vc/HfPdkyFQzhOF+
         JxsV4ltXqK9WP5wDTIGui7TVtH2u/3GD5x3K/7oMM7XU2Zr6RkDO87o5EZnb3nV3i6eJ
         kiVQ==
X-Gm-Message-State: AOAM533HC3Gu6WDi7RVf7uGI+OfmShzpsF+5Joij7hcMCkRoJKtsxGeq
        Pcc5zj+/U0t4+r37S3rj3/I=
X-Google-Smtp-Source: ABdhPJwtwTdRNcs1IU5SxUkU9lBIZiTVr6WZNo6xuOw4kaot7iIjJbQLpscdGHOoB/FeB9XGW6HAng==
X-Received: by 2002:a17:90a:458c:: with SMTP id v12mr10643510pjg.50.1629895640870;
        Wed, 25 Aug 2021 05:47:20 -0700 (PDT)
Received: from localhost.localdomain ([45.124.203.15])
        by smtp.gmail.com with ESMTPSA id s16sm21511301pfk.185.2021.08.25.05.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 05:47:19 -0700 (PDT)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org,
        Florent Kermarrec <florent@enjoy-digital.fr>,
        "Gabriel L . Somlo" <gsomlo@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Shah <dave@ds0.me>,
        Stafford Horne <shorne@gmail.com>
Subject: [PATCH v3 2/2] net: Add driver for LiteX's LiteETH network interface
Date:   Wed, 25 Aug 2021 22:16:55 +0930
Message-Id: <20210825124655.3104348-3-joel@jms.id.au>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825124655.3104348-1-joel@jms.id.au>
References: <20210825124655.3104348-1-joel@jms.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LiteX is a soft system-on-chip that targets FPGAs. LiteETH is a basic
network device that is commonly used in LiteX designs.

The driver was first written in 2017 and has been maintained by the
LiteX community in various trees. Thank you to all who have contributed.

Co-developed-by: Gabriel Somlo <gsomlo@gmail.com>
Co-developed-by: David Shah <dave@ds0.me>
Co-developed-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
v2:
 - check for bad len in liteeth_rx before getting skb
 - use netdev_alloc_skb_ip_align
 - remove unused duplex/speed and mii_bus variables
 - set carrier off when stopping device
 - increment packet count in the same place as bytes
 - fix error return code when irq could not be found
 - remove request of mdio base address until it is used
 - fix of_property_read line wrapping/alignment
 - only check that reader isn't busy, and then send off next packet
 - drop third reset
 - Add an description to the kconfig text
 - stop tx queue when busy and re-start after tx complete irq fires
 - use litex accessors to support big endain socs
 - clean up unused includes
 - use standard fifo-depth properties, which are in bytes
v3:
 - make fifo helper static
 - fix error messages about invalid slot sizes
 - use slot size from device tree instead of inferring it
 - update to match the latest version of the bindings, which describes
   the number of slots
---
 drivers/net/ethernet/Kconfig               |   1 +
 drivers/net/ethernet/Makefile              |   1 +
 drivers/net/ethernet/litex/Kconfig         |  27 ++
 drivers/net/ethernet/litex/Makefile        |   5 +
 drivers/net/ethernet/litex/litex_liteeth.c | 317 +++++++++++++++++++++
 5 files changed, 351 insertions(+)
 create mode 100644 drivers/net/ethernet/litex/Kconfig
 create mode 100644 drivers/net/ethernet/litex/Makefile
 create mode 100644 drivers/net/ethernet/litex/litex_liteeth.c

diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 1cdff1dca790..d796684ec9ca 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -118,6 +118,7 @@ config LANTIQ_XRX200
 	  Support for the PMAC of the Gigabit switch (GSWIP) inside the
 	  Lantiq / Intel VRX200 VDSL SoC
 
+source "drivers/net/ethernet/litex/Kconfig"
 source "drivers/net/ethernet/marvell/Kconfig"
 source "drivers/net/ethernet/mediatek/Kconfig"
 source "drivers/net/ethernet/mellanox/Kconfig"
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index cb3f9084a21b..aaa5078cd7d1 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_JME) += jme.o
 obj-$(CONFIG_KORINA) += korina.o
 obj-$(CONFIG_LANTIQ_ETOP) += lantiq_etop.o
 obj-$(CONFIG_LANTIQ_XRX200) += lantiq_xrx200.o
+obj-$(CONFIG_NET_VENDOR_LITEX) += litex/
 obj-$(CONFIG_NET_VENDOR_MARVELL) += marvell/
 obj-$(CONFIG_NET_VENDOR_MEDIATEK) += mediatek/
 obj-$(CONFIG_NET_VENDOR_MELLANOX) += mellanox/
diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
new file mode 100644
index 000000000000..265dba414b41
--- /dev/null
+++ b/drivers/net/ethernet/litex/Kconfig
@@ -0,0 +1,27 @@
+#
+# LiteX device configuration
+#
+
+config NET_VENDOR_LITEX
+	bool "LiteX devices"
+	default y
+	help
+	  If you have a network (Ethernet) card belonging to this class, say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about LiteX devices. If you say Y, you will be asked
+	  for your specific card in the following questions.
+
+if NET_VENDOR_LITEX
+
+config LITEX_LITEETH
+	tristate "LiteX Ethernet support"
+	help
+	  If you wish to compile a kernel for hardware with a LiteX LiteEth
+	  device then you should answer Y to this.
+
+	  LiteX is a soft system-on-chip that targets FPGAs. LiteETH is a basic
+	  network device that is commonly used in LiteX designs.
+
+endif # NET_VENDOR_LITEX
diff --git a/drivers/net/ethernet/litex/Makefile b/drivers/net/ethernet/litex/Makefile
new file mode 100644
index 000000000000..9343b73b8e49
--- /dev/null
+++ b/drivers/net/ethernet/litex/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the LiteX network device drivers.
+#
+
+obj-$(CONFIG_LITEX_LITEETH) += litex_liteeth.o
diff --git a/drivers/net/ethernet/litex/litex_liteeth.c b/drivers/net/ethernet/litex/litex_liteeth.c
new file mode 100644
index 000000000000..10e6f2dedfad
--- /dev/null
+++ b/drivers/net/ethernet/litex/litex_liteeth.c
@@ -0,0 +1,317 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * LiteX Liteeth Ethernet
+ *
+ * Copyright 2017 Joel Stanley <joel@jms.id.au>
+ *
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/interrupt.h>
+#include <linux/litex.h>
+#include <linux/module.h>
+#include <linux/of_net.h>
+#include <linux/platform_device.h>
+
+#define LITEETH_WRITER_SLOT       0x00
+#define LITEETH_WRITER_LENGTH     0x04
+#define LITEETH_WRITER_ERRORS     0x08
+#define LITEETH_WRITER_EV_STATUS  0x0C
+#define LITEETH_WRITER_EV_PENDING 0x10
+#define LITEETH_WRITER_EV_ENABLE  0x14
+#define LITEETH_READER_START      0x18
+#define LITEETH_READER_READY      0x1C
+#define LITEETH_READER_LEVEL      0x20
+#define LITEETH_READER_SLOT       0x24
+#define LITEETH_READER_LENGTH     0x28
+#define LITEETH_READER_EV_STATUS  0x2C
+#define LITEETH_READER_EV_PENDING 0x30
+#define LITEETH_READER_EV_ENABLE  0x34
+#define LITEETH_PREAMBLE_CRC      0x38
+#define LITEETH_PREAMBLE_ERRORS   0x3C
+#define LITEETH_CRC_ERRORS        0x40
+
+#define LITEETH_PHY_CRG_RESET     0x00
+#define LITEETH_MDIO_W            0x04
+#define LITEETH_MDIO_R            0x0C
+
+#define DRV_NAME	"liteeth"
+
+struct liteeth {
+	void __iomem *base;
+	struct net_device *netdev;
+	struct device *dev;
+	u32 slot_size;
+
+	/* Tx */
+	u32 tx_slot;
+	u32 num_tx_slots;
+	void __iomem *tx_base;
+
+	/* Rx */
+	u32 rx_slot;
+	u32 num_rx_slots;
+	void __iomem *rx_base;
+};
+
+static int liteeth_rx(struct net_device *netdev)
+{
+	struct liteeth *priv = netdev_priv(netdev);
+	struct sk_buff *skb;
+	unsigned char *data;
+	u8 rx_slot;
+	int len;
+
+	rx_slot = litex_read8(priv->base + LITEETH_WRITER_SLOT);
+	len = litex_read32(priv->base + LITEETH_WRITER_LENGTH);
+
+	if (len == 0 || len > 2048)
+		goto rx_drop;
+
+	skb = netdev_alloc_skb_ip_align(netdev, len);
+	if (!skb) {
+		netdev_err(netdev, "couldn't get memory\n");
+		goto rx_drop;
+	}
+
+	data = skb_put(skb, len);
+	memcpy_fromio(data, priv->rx_base + rx_slot * priv->slot_size, len);
+	skb->protocol = eth_type_trans(skb, netdev);
+
+	netdev->stats.rx_packets++;
+	netdev->stats.rx_bytes += len;
+
+	return netif_rx(skb);
+
+rx_drop:
+	netdev->stats.rx_dropped++;
+	netdev->stats.rx_errors++;
+
+	return NET_RX_DROP;
+}
+
+static irqreturn_t liteeth_interrupt(int irq, void *dev_id)
+{
+	struct net_device *netdev = dev_id;
+	struct liteeth *priv = netdev_priv(netdev);
+	u8 reg;
+
+	reg = litex_read8(priv->base + LITEETH_READER_EV_PENDING);
+	if (reg) {
+		if (netif_queue_stopped(netdev))
+			netif_wake_queue(netdev);
+		litex_write8(priv->base + LITEETH_READER_EV_PENDING, reg);
+	}
+
+	reg = litex_read8(priv->base + LITEETH_WRITER_EV_PENDING);
+	if (reg) {
+		liteeth_rx(netdev);
+		litex_write8(priv->base + LITEETH_WRITER_EV_PENDING, reg);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int liteeth_open(struct net_device *netdev)
+{
+	struct liteeth *priv = netdev_priv(netdev);
+	int err;
+
+	/* Clear pending events */
+	litex_write8(priv->base + LITEETH_WRITER_EV_PENDING, 1);
+	litex_write8(priv->base + LITEETH_READER_EV_PENDING, 1);
+
+	err = request_irq(netdev->irq, liteeth_interrupt, 0, netdev->name, netdev);
+	if (err) {
+		netdev_err(netdev, "failed to request irq %d\n", netdev->irq);
+		return err;
+	}
+
+	/* Enable IRQs */
+	litex_write8(priv->base + LITEETH_WRITER_EV_ENABLE, 1);
+	litex_write8(priv->base + LITEETH_READER_EV_ENABLE, 1);
+
+	netif_carrier_on(netdev);
+	netif_start_queue(netdev);
+
+	return 0;
+}
+
+static int liteeth_stop(struct net_device *netdev)
+{
+	struct liteeth *priv = netdev_priv(netdev);
+
+	netif_stop_queue(netdev);
+	netif_carrier_off(netdev);
+
+	litex_write8(priv->base + LITEETH_WRITER_EV_ENABLE, 0);
+	litex_write8(priv->base + LITEETH_READER_EV_ENABLE, 0);
+
+	free_irq(netdev->irq, netdev);
+
+	return 0;
+}
+
+static int liteeth_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct liteeth *priv = netdev_priv(netdev);
+	void __iomem *txbuffer;
+
+	if (!litex_read8(priv->base + LITEETH_READER_READY)) {
+		if (net_ratelimit())
+			netdev_err(netdev, "LITEETH_READER_READY not ready\n");
+
+		netif_stop_queue(netdev);
+
+		return NETDEV_TX_BUSY;
+	}
+
+	/* Reject oversize packets */
+	if (unlikely(skb->len > priv->slot_size)) {
+		if (net_ratelimit())
+			netdev_err(netdev, "tx packet too big\n");
+
+		dev_kfree_skb_any(skb);
+		netdev->stats.tx_dropped++;
+		netdev->stats.tx_errors++;
+
+		return NETDEV_TX_OK;
+	}
+
+	txbuffer = priv->tx_base + priv->tx_slot * priv->slot_size;
+	memcpy_toio(txbuffer, skb->data, skb->len);
+	litex_write8(priv->base + LITEETH_READER_SLOT, priv->tx_slot);
+	litex_write16(priv->base + LITEETH_READER_LENGTH, skb->len);
+	litex_write8(priv->base + LITEETH_READER_START, 1);
+
+	netdev->stats.tx_bytes += skb->len;
+	netdev->stats.tx_packets++;
+
+	priv->tx_slot = (priv->tx_slot + 1) % priv->num_tx_slots;
+	dev_kfree_skb_any(skb);
+
+	return NETDEV_TX_OK;
+}
+
+static const struct net_device_ops liteeth_netdev_ops = {
+	.ndo_open		= liteeth_open,
+	.ndo_stop		= liteeth_stop,
+	.ndo_start_xmit         = liteeth_start_xmit,
+};
+
+static void liteeth_setup_slots(struct liteeth *priv)
+{
+	struct device_node *np = priv->dev->of_node;
+	int err;
+
+	err = of_property_read_u32(np, "litex,rx-slots", &priv->num_rx_slots);
+	if (err) {
+		dev_dbg(priv->dev, "unable to get litex,rx-slots, using 2\n");
+		priv->num_rx_slots = 2;
+	}
+
+	err = of_property_read_u32(np, "litex,tx-slots", &priv->num_tx_slots);
+	if (err) {
+		dev_dbg(priv->dev, "unable to get litex,tx-slots, using 2\n");
+		priv->num_tx_slots = 2;
+	}
+
+	err = of_property_read_u32(np, "litex,slot-size", &priv->slot_size);
+	if (err) {
+		dev_dbg(priv->dev, "unable to get litex,slot-size, using 0x800\n");
+		priv->slot_size = 0x800;
+	}
+}
+
+static int liteeth_probe(struct platform_device *pdev)
+{
+	struct net_device *netdev;
+	void __iomem *buf_base;
+	struct resource *res;
+	struct liteeth *priv;
+	int irq, err;
+
+	netdev = devm_alloc_etherdev(&pdev->dev, sizeof(*priv));
+	if (!netdev)
+		return -ENOMEM;
+
+	SET_NETDEV_DEV(netdev, &pdev->dev);
+	platform_set_drvdata(pdev, netdev);
+
+	priv = netdev_priv(netdev);
+	priv->netdev = netdev;
+	priv->dev = &pdev->dev;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "Failed to get IRQ %d\n", irq);
+		return irq;
+	}
+	netdev->irq = irq;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mac");
+	priv->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "buffer");
+	buf_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(buf_base))
+		return PTR_ERR(buf_base);
+
+	liteeth_setup_slots(priv);
+
+	/* Rx slots */
+	priv->rx_base = buf_base;
+	priv->rx_slot = 0;
+
+	/* Tx slots come after Rx slots */
+	priv->tx_base = buf_base + priv->num_rx_slots * priv->slot_size;
+	priv->tx_slot = 0;
+
+	err = of_get_mac_address(pdev->dev.of_node, netdev->dev_addr);
+	if (err)
+		eth_hw_addr_random(netdev);
+
+	netdev->netdev_ops = &liteeth_netdev_ops;
+
+	err = register_netdev(netdev);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to register netdev %d\n", err);
+		return err;
+	}
+
+	netdev_info(netdev, "irq %d slots: tx %d rx %d size %d\n",
+		    netdev->irq, priv->num_tx_slots, priv->num_rx_slots, priv->slot_size);
+
+	return 0;
+}
+
+static int liteeth_remove(struct platform_device *pdev)
+{
+	struct net_device *netdev = platform_get_drvdata(pdev);
+
+	unregister_netdev(netdev);
+	free_netdev(netdev);
+
+	return 0;
+}
+
+static const struct of_device_id liteeth_of_match[] = {
+	{ .compatible = "litex,liteeth" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, liteeth_of_match);
+
+static struct platform_driver liteeth_driver = {
+	.probe = liteeth_probe,
+	.remove = liteeth_remove,
+	.driver = {
+		.name = DRV_NAME,
+		.of_match_table = liteeth_of_match,
+	},
+};
+module_platform_driver(liteeth_driver);
+
+MODULE_AUTHOR("Joel Stanley <joel@jms.id.au>");
+MODULE_LICENSE("GPL");
-- 
2.33.0

