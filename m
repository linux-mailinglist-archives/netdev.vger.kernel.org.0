Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B49F67E0EC
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 10:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbjA0J75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 04:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbjA0J7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 04:59:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2329818B08;
        Fri, 27 Jan 2023 01:59:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99E6061AC1;
        Fri, 27 Jan 2023 09:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D983C433D2;
        Fri, 27 Jan 2023 09:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674813590;
        bh=FWRIVnCapM1RxTP9UPw+n83MCTKh/lBQOrYAaBW00to=;
        h=From:To:Cc:Subject:Date:From;
        b=L55WM3J+q4aoyorMz1yK2TpCH/iVWW/r/TWxrciinhi39cyqCeHAWb/3q+DLqaeeN
         Tt/NfLsAFWtxtjutkD1Yx5arlcqBHxyrzpQdGvnzxyxmw3Y4EThx4aiLdQKjMkxe2D
         8SqyKvxX3BVNgdZxdm8L3I3VuRjlqlGPGpPvwSooGh40y79LwNLDNarFhiYAnscJLa
         7glgjTyx3LICfHTKTDOcP4sdlbDyccTOCMTedZz2dJMHD+MyQXQXgTR0b6qm+1N0UU
         WJpAoAnDEgQL6sseJonlnIHBrB7BO5Pe0x8bdi1abQQ1Ai08+UCgIRn1vhRky53usA
         +usIXbZawO8gA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v3] wiznet: convert to GPIO descriptors
Date:   Fri, 27 Jan 2023 10:57:08 +0100
Message-Id: <20230127095839.3266452-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The w5100/w5300 drivers only support probing with old platform data in
MMIO mode, or probing with DT in SPI mode. There are no users of this
platform data in tree, and from the git history it appears that the only
users of MMIO mode were on the (since removed) blackfin architecture.

Remove the platform data option, as it's unlikely to still be needed, and
change the internal operation to GPIO descriptors, making the behavior
the same for SPI and MMIO mode. The other data in the platform_data
structure is the MAC address, so make that also handled the same for both.

It would probably be possible to just remove the MMIO mode driver
completely, but it seems fine otherwise, and fixing it to use the modern
interface seems easy enough.

The CONFIG_WIZNET_BUS_SHIFT value was apparently meant to be set
at compile time to a machine specific value. This was always broken
for multiplatform configurations with conflicting requirements, and
in the mainline kernel it was set to 0 anyway. Leave it defined
locally as 0 but rename it to something without the CONFIG_ prefix.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v3: include linux/gpio/consumer.h to avoid build failure without GPIOLIB
v2: replace CONFIG_WIZNET_BUS_SHIFT with a constant

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../devicetree/bindings/net/wiznet,w5x00.txt  |  4 +-
 drivers/net/ethernet/wiznet/w5100-spi.c       | 21 ++-----
 drivers/net/ethernet/wiznet/w5100.c           | 61 ++++++++++---------
 drivers/net/ethernet/wiznet/w5100.h           |  3 +-
 drivers/net/ethernet/wiznet/w5300.c           | 54 ++++++++--------
 include/linux/platform_data/wiznet.h          | 23 -------
 6 files changed, 71 insertions(+), 95 deletions(-)
 delete mode 100644 include/linux/platform_data/wiznet.h

diff --git a/Documentation/devicetree/bindings/net/wiznet,w5x00.txt b/Documentation/devicetree/bindings/net/wiznet,w5x00.txt
index e9665798c4be..e8a802d65817 100644
--- a/Documentation/devicetree/bindings/net/wiznet,w5x00.txt
+++ b/Documentation/devicetree/bindings/net/wiznet,w5x00.txt
@@ -1,6 +1,6 @@
 * Wiznet w5x00
 
-This is a standalone 10/100 MBit Ethernet controller with SPI interface.
+This is a standalone 10/100 MBit Ethernet controller with SPI or MMIO interface.
 
 For each device connected to a SPI bus, define a child node within
 the SPI master node.
@@ -9,6 +9,7 @@ Required properties:
 - compatible: Should be one of the following strings:
 	      "wiznet,w5100"
 	      "wiznet,w5200"
+	      "wiznet,w5300"
 	      "wiznet,w5500"
 - reg: Specify the SPI chip select the chip is wired to.
 - interrupts: Specify the interrupt index within the interrupt controller (referred
@@ -25,6 +26,7 @@ Optional properties:
   According to the w5500 datasheet, the chip allows a maximum of 80 MHz, however,
   board designs may need to limit this value.
 - local-mac-address: See ethernet.txt in the same directory.
+- link-gpios: a GPIO line used for the link detection interrupt
 
 
 Example (for Raspberry Pi with pin control stuff for GPIO irq):
diff --git a/drivers/net/ethernet/wiznet/w5100-spi.c b/drivers/net/ethernet/wiznet/w5100-spi.c
index 7c52796273a4..81ac52f0fe50 100644
--- a/drivers/net/ethernet/wiznet/w5100-spi.c
+++ b/drivers/net/ethernet/wiznet/w5100-spi.c
@@ -423,23 +423,12 @@ static int w5100_spi_probe(struct spi_device *spi)
 	const struct of_device_id *of_id;
 	const struct w5100_ops *ops;
 	kernel_ulong_t driver_data;
-	const void *mac = NULL;
-	u8 tmpmac[ETH_ALEN];
 	int priv_size;
-	int ret;
 
-	ret = of_get_mac_address(spi->dev.of_node, tmpmac);
-	if (!ret)
-		mac = tmpmac;
-
-	if (spi->dev.of_node) {
-		of_id = of_match_device(w5100_of_match, &spi->dev);
-		if (!of_id)
-			return -ENODEV;
-		driver_data = (kernel_ulong_t)of_id->data;
-	} else {
-		driver_data = spi_get_device_id(spi)->driver_data;
-	}
+	of_id = of_match_device(w5100_of_match, &spi->dev);
+	if (!of_id)
+		return -ENODEV;
+	driver_data = (kernel_ulong_t)of_id->data;
 
 	switch (driver_data) {
 	case W5100:
@@ -458,7 +447,7 @@ static int w5100_spi_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	return w5100_probe(&spi->dev, ops, priv_size, mac, spi->irq, -EINVAL);
+	return w5100_probe(&spi->dev, ops, priv_size, spi->irq);
 }
 
 static void w5100_spi_remove(struct spi_device *spi)
diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index 634946e87e5f..626031d47944 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -11,7 +11,6 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
-#include <linux/platform_data/wiznet.h>
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
 #include <linux/types.h>
@@ -23,7 +22,8 @@
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
+#include <linux/of_net.h>
 
 #include "w5100.h"
 
@@ -139,6 +139,10 @@ MODULE_LICENSE("GPL");
 #define W5500_RX_MEM_START	0x30000
 #define W5500_RX_MEM_SIZE	0x04000
 
+#define WIZNET_BUS_SHIFT 0	/* possibly machine specific */
+
+#define W5100_BUS_DIRECT_SIZE  (0x8000 << WIZNET_BUS_SHIFT)
+
 /*
  * Device driver private data structure
  */
@@ -157,7 +161,7 @@ struct w5100_priv {
 
 	int irq;
 	int link_irq;
-	int link_gpio;
+	struct gpio_desc *link_gpio;
 
 	struct napi_struct napi;
 	struct net_device *ndev;
@@ -204,13 +208,13 @@ static inline void __iomem *w5100_mmio(struct net_device *ndev)
  */
 static inline int w5100_read_direct(struct net_device *ndev, u32 addr)
 {
-	return ioread8(w5100_mmio(ndev) + (addr << CONFIG_WIZNET_BUS_SHIFT));
+	return ioread8(w5100_mmio(ndev) + (addr << WIZNET_BUS_SHIFT));
 }
 
 static inline int __w5100_write_direct(struct net_device *ndev, u32 addr,
 				       u8 data)
 {
-	iowrite8(data, w5100_mmio(ndev) + (addr << CONFIG_WIZNET_BUS_SHIFT));
+	iowrite8(data, w5100_mmio(ndev) + (addr << WIZNET_BUS_SHIFT));
 
 	return 0;
 }
@@ -729,8 +733,8 @@ static u32 w5100_get_link(struct net_device *ndev)
 {
 	struct w5100_priv *priv = netdev_priv(ndev);
 
-	if (gpio_is_valid(priv->link_gpio))
-		return !!gpio_get_value(priv->link_gpio);
+	if (priv->link_gpio)
+		return !!gpiod_get_value(priv->link_gpio);
 
 	return 1;
 }
@@ -943,7 +947,7 @@ static irqreturn_t w5100_detect_link(int irq, void *ndev_instance)
 	struct w5100_priv *priv = netdev_priv(ndev);
 
 	if (netif_running(ndev)) {
-		if (gpio_get_value(priv->link_gpio) != 0) {
+		if (gpiod_get_value(priv->link_gpio) != 0) {
 			netif_info(priv, link, ndev, "link is up\n");
 			netif_carrier_on(ndev);
 		} else {
@@ -998,8 +1002,8 @@ static int w5100_open(struct net_device *ndev)
 	w5100_hw_start(priv);
 	napi_enable(&priv->napi);
 	netif_start_queue(ndev);
-	if (!gpio_is_valid(priv->link_gpio) ||
-	    gpio_get_value(priv->link_gpio) != 0)
+	if (!priv->link_gpio ||
+	    gpiod_get_value(priv->link_gpio) != 0)
 		netif_carrier_on(ndev);
 	return 0;
 }
@@ -1037,15 +1041,10 @@ static const struct net_device_ops w5100_netdev_ops = {
 
 static int w5100_mmio_probe(struct platform_device *pdev)
 {
-	struct wiznet_platform_data *data = dev_get_platdata(&pdev->dev);
-	const void *mac_addr = NULL;
 	struct resource *mem;
 	const struct w5100_ops *ops;
 	int irq;
 
-	if (data && is_valid_ether_addr(data->mac_addr))
-		mac_addr = data->mac_addr;
-
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem)
 		return -EINVAL;
@@ -1058,8 +1057,7 @@ static int w5100_mmio_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	return w5100_probe(&pdev->dev, ops, sizeof(struct w5100_mmio_priv),
-			   mac_addr, irq, data ? data->link_gpio : -EINVAL);
+	return w5100_probe(&pdev->dev, ops, sizeof(struct w5100_mmio_priv), irq);
 }
 
 static int w5100_mmio_remove(struct platform_device *pdev)
@@ -1077,13 +1075,13 @@ void *w5100_ops_priv(const struct net_device *ndev)
 EXPORT_SYMBOL_GPL(w5100_ops_priv);
 
 int w5100_probe(struct device *dev, const struct w5100_ops *ops,
-		int sizeof_ops_priv, const void *mac_addr, int irq,
-		int link_gpio)
+		int sizeof_ops_priv, int irq)
 {
 	struct w5100_priv *priv;
 	struct net_device *ndev;
 	int err;
 	size_t alloc_size;
+	u8 tmpmac[ETH_ALEN];
 
 	alloc_size = sizeof(*priv);
 	if (sizeof_ops_priv) {
@@ -1129,7 +1127,9 @@ int w5100_probe(struct device *dev, const struct w5100_ops *ops,
 	priv->ndev = ndev;
 	priv->ops = ops;
 	priv->irq = irq;
-	priv->link_gpio = link_gpio;
+	priv->link_gpio = gpiod_get_optional(dev, "link", GPIOD_IN);
+	if (IS_ERR(priv->link_gpio))
+		return PTR_ERR(priv->link_gpio);
 
 	ndev->netdev_ops = &w5100_netdev_ops;
 	ndev->ethtool_ops = &w5100_ethtool_ops;
@@ -1156,8 +1156,9 @@ int w5100_probe(struct device *dev, const struct w5100_ops *ops,
 	INIT_WORK(&priv->setrx_work, w5100_setrx_work);
 	INIT_WORK(&priv->restart_work, w5100_restart_work);
 
-	if (mac_addr)
-		eth_hw_addr_set(ndev, mac_addr);
+	err = of_get_mac_address(dev->of_node, tmpmac);
+	if (!err)
+		eth_hw_addr_set(ndev, tmpmac);
 	else
 		eth_hw_addr_random(ndev);
 
@@ -1182,7 +1183,7 @@ int w5100_probe(struct device *dev, const struct w5100_ops *ops,
 	if (err)
 		goto err_hw;
 
-	if (gpio_is_valid(priv->link_gpio)) {
+	if (priv->link_gpio) {
 		char *link_name = devm_kzalloc(dev, 16, GFP_KERNEL);
 
 		if (!link_name) {
@@ -1190,12 +1191,14 @@ int w5100_probe(struct device *dev, const struct w5100_ops *ops,
 			goto err_gpio;
 		}
 		snprintf(link_name, 16, "%s-link", netdev_name(ndev));
-		priv->link_irq = gpio_to_irq(priv->link_gpio);
+		priv->link_irq = gpiod_to_irq(priv->link_gpio);
 		if (request_any_context_irq(priv->link_irq, w5100_detect_link,
 					    IRQF_TRIGGER_RISING |
 					    IRQF_TRIGGER_FALLING,
-					    link_name, priv->ndev) < 0)
-			priv->link_gpio = -EINVAL;
+					    link_name, priv->ndev) < 0) {
+			gpiod_put(priv->link_gpio);
+			priv->link_gpio = NULL;
+		}
 	}
 
 	return 0;
@@ -1219,7 +1222,7 @@ void w5100_remove(struct device *dev)
 
 	w5100_hw_reset(priv);
 	free_irq(priv->irq, ndev);
-	if (gpio_is_valid(priv->link_gpio))
+	if (priv->link_gpio)
 		free_irq(priv->link_irq, ndev);
 
 	flush_work(&priv->setrx_work);
@@ -1256,8 +1259,8 @@ static int w5100_resume(struct device *dev)
 		w5100_hw_start(priv);
 
 		netif_device_attach(ndev);
-		if (!gpio_is_valid(priv->link_gpio) ||
-		    gpio_get_value(priv->link_gpio) != 0)
+		if (!priv->link_gpio ||
+		    gpiod_get_value(priv->link_gpio) != 0)
 			netif_carrier_on(ndev);
 	}
 	return 0;
diff --git a/drivers/net/ethernet/wiznet/w5100.h b/drivers/net/ethernet/wiznet/w5100.h
index 481af3b6d9e8..013ef2835115 100644
--- a/drivers/net/ethernet/wiznet/w5100.h
+++ b/drivers/net/ethernet/wiznet/w5100.h
@@ -29,8 +29,7 @@ struct w5100_ops {
 void *w5100_ops_priv(const struct net_device *ndev);
 
 int w5100_probe(struct device *dev, const struct w5100_ops *ops,
-		int sizeof_ops_priv, const void *mac_addr, int irq,
-		int link_gpio);
+		int sizeof_ops_priv, int irq);
 void w5100_remove(struct device *dev);
 
 extern const struct dev_pm_ops w5100_pm_ops;
diff --git a/drivers/net/ethernet/wiznet/w5300.c b/drivers/net/ethernet/wiznet/w5300.c
index b0958fe8111e..7917d4c906d0 100644
--- a/drivers/net/ethernet/wiznet/w5300.c
+++ b/drivers/net/ethernet/wiznet/w5300.c
@@ -12,7 +12,6 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
-#include <linux/platform_data/wiznet.h>
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
 #include <linux/types.h>
@@ -24,7 +23,8 @@
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
+#include <linux/of_net.h>
 
 #define DRV_NAME	"w5300"
 #define DRV_VERSION	"2012-04-04"
@@ -80,6 +80,10 @@ MODULE_LICENSE("GPL");
 #define W5300_S0_RX_FIFO	0x0230	/* S0 Receive FIFO */
 #define W5300_REGS_LEN		0x0400
 
+#define WIZNET_BUS_SHIFT 0
+
+#define W5300_BUS_DIRECT_SIZE  (0x0400 << WIZNET_BUS_SHIFT)
+
 /*
  * Device driver private data structure
  */
@@ -91,7 +95,7 @@ struct w5300_priv {
 	void (*write)(struct w5300_priv *priv, u16 addr, u16 data);
 	int irq;
 	int link_irq;
-	int link_gpio;
+	struct gpio_desc *link_gpio;
 
 	struct napi_struct napi;
 	struct net_device *ndev;
@@ -113,13 +117,13 @@ struct w5300_priv {
  */
 static inline u16 w5300_read_direct(struct w5300_priv *priv, u16 addr)
 {
-	return ioread16(priv->base + (addr << CONFIG_WIZNET_BUS_SHIFT));
+	return ioread16(priv->base + (addr << WIZNET_BUS_SHIFT));
 }
 
 static inline void w5300_write_direct(struct w5300_priv *priv,
 				      u16 addr, u16 data)
 {
-	iowrite16(data, priv->base + (addr << CONFIG_WIZNET_BUS_SHIFT));
+	iowrite16(data, priv->base + (addr << WIZNET_BUS_SHIFT));
 }
 
 /*
@@ -292,8 +296,8 @@ static u32 w5300_get_link(struct net_device *ndev)
 {
 	struct w5300_priv *priv = netdev_priv(ndev);
 
-	if (gpio_is_valid(priv->link_gpio))
-		return !!gpio_get_value(priv->link_gpio);
+	if (priv->link_gpio)
+		return !!gpiod_get_value(priv->link_gpio);
 
 	return 1;
 }
@@ -442,7 +446,7 @@ static irqreturn_t w5300_detect_link(int irq, void *ndev_instance)
 	struct w5300_priv *priv = netdev_priv(ndev);
 
 	if (netif_running(ndev)) {
-		if (gpio_get_value(priv->link_gpio) != 0) {
+		if (gpiod_get_value(priv->link_gpio) != 0) {
 			netif_info(priv, link, ndev, "link is up\n");
 			netif_carrier_on(ndev);
 		} else {
@@ -485,8 +489,8 @@ static int w5300_open(struct net_device *ndev)
 	w5300_hw_start(priv);
 	napi_enable(&priv->napi);
 	netif_start_queue(ndev);
-	if (!gpio_is_valid(priv->link_gpio) ||
-	    gpio_get_value(priv->link_gpio) != 0)
+	if (!priv->link_gpio ||
+	    gpiod_get_value(priv->link_gpio) != 0)
 		netif_carrier_on(ndev);
 	return 0;
 }
@@ -524,7 +528,6 @@ static const struct net_device_ops w5300_netdev_ops = {
 
 static int w5300_hw_probe(struct platform_device *pdev)
 {
-	struct wiznet_platform_data *data = dev_get_platdata(&pdev->dev);
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct w5300_priv *priv = netdev_priv(ndev);
 	const char *name = netdev_name(ndev);
@@ -533,11 +536,9 @@ static int w5300_hw_probe(struct platform_device *pdev)
 	int irq;
 	int ret;
 
-	if (data && is_valid_ether_addr(data->mac_addr)) {
-		eth_hw_addr_set(ndev, data->mac_addr);
-	} else {
-		eth_hw_addr_random(ndev);
-	}
+        ret = of_get_ethdev_address(pdev->dev.of_node, ndev);
+        if (ret)
+                eth_hw_addr_random(ndev);
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	priv->base = devm_ioremap_resource(&pdev->dev, mem);
@@ -569,17 +570,22 @@ static int w5300_hw_probe(struct platform_device *pdev)
 		return ret;
 	priv->irq = irq;
 
-	priv->link_gpio = data ? data->link_gpio : -EINVAL;
-	if (gpio_is_valid(priv->link_gpio)) {
+	priv->link_gpio = gpiod_get_optional(&pdev->dev, "link", GPIOD_IN);
+	if (IS_ERR(priv->link_gpio))
+		return PTR_ERR(priv->link_gpio);
+
+	if (priv->link_gpio) {
 		char *link_name = devm_kzalloc(&pdev->dev, 16, GFP_KERNEL);
 		if (!link_name)
 			return -ENOMEM;
 		snprintf(link_name, 16, "%s-link", name);
-		priv->link_irq = gpio_to_irq(priv->link_gpio);
+		priv->link_irq = gpiod_to_irq(priv->link_gpio);
 		if (request_any_context_irq(priv->link_irq, w5300_detect_link,
 				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
-				link_name, priv->ndev) < 0)
-			priv->link_gpio = -EINVAL;
+				link_name, priv->ndev) < 0) {
+			priv->link_gpio = NULL;
+			gpiod_put(priv->link_gpio);
+		}
 	}
 
 	netdev_info(ndev, "at 0x%llx irq %d\n", (u64)mem->start, irq);
@@ -634,7 +640,7 @@ static int w5300_remove(struct platform_device *pdev)
 
 	w5300_hw_reset(priv);
 	free_irq(priv->irq, ndev);
-	if (gpio_is_valid(priv->link_gpio))
+	if (priv->link_gpio)
 		free_irq(priv->link_irq, ndev);
 
 	unregister_netdev(ndev);
@@ -667,8 +673,8 @@ static int w5300_resume(struct device *dev)
 		w5300_hw_start(priv);
 
 		netif_device_attach(ndev);
-		if (!gpio_is_valid(priv->link_gpio) ||
-		    gpio_get_value(priv->link_gpio) != 0)
+		if (!priv->link_gpio ||
+		    gpiod_get_value(priv->link_gpio) != 0)
 			netif_carrier_on(ndev);
 	}
 	return 0;
diff --git a/include/linux/platform_data/wiznet.h b/include/linux/platform_data/wiznet.h
deleted file mode 100644
index 1154c4db8a13..000000000000
--- a/include/linux/platform_data/wiznet.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * Ethernet driver for the WIZnet W5x00 chip.
- */
-
-#ifndef PLATFORM_DATA_WIZNET_H
-#define PLATFORM_DATA_WIZNET_H
-
-#include <linux/if_ether.h>
-
-struct wiznet_platform_data {
-	int	link_gpio;
-	u8	mac_addr[ETH_ALEN];
-};
-
-#ifndef CONFIG_WIZNET_BUS_SHIFT
-#define CONFIG_WIZNET_BUS_SHIFT 0
-#endif
-
-#define W5100_BUS_DIRECT_SIZE	(0x8000 << CONFIG_WIZNET_BUS_SHIFT)
-#define W5300_BUS_DIRECT_SIZE	(0x0400 << CONFIG_WIZNET_BUS_SHIFT)
-
-#endif /* PLATFORM_DATA_WIZNET_H */
-- 
2.39.0

