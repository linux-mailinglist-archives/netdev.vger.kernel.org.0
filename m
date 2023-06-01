Return-Path: <netdev+bounces-6992-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A5C6719287
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 07:46:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFF431C20EE6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:46:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66DFA6FCD;
	Thu,  1 Jun 2023 05:45:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5134D6FCC
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 05:45:59 +0000 (UTC)
Received: from forward102a.mail.yandex.net (forward102a.mail.yandex.net [178.154.239.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E88CE2;
	Wed, 31 May 2023 22:45:56 -0700 (PDT)
Received: from mail-nwsmtp-smtp-production-main-51.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-51.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:5e51:0:640:23ee:0])
	by forward102a.mail.yandex.net (Yandex) with ESMTP id 033424231D;
	Thu,  1 Jun 2023 08:45:55 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-51.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id pjGDMhnDduQ0-aOvwslIN;
	Thu, 01 Jun 2023 08:45:54 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maquefel.me; s=mail; t=1685598354;
	bh=DFRrRs5yJB6I1NZ9/5/odctWMT+EMqwMMh4rTW/kIxM=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=q0FI6OYNleFFyvjkySIRTvmRWW9IGtRpLHzuEmzI9GViPQq+8NKNZ6J96pZ8RCtfm
	 3p2fbF3ouAKcm9U16K45Kuv5AMjYp5dNUUq4/Dyjn99yYcox4xq/fBaBjlNdpSJ+sH
	 9BLp1zEsFd729J3y5Iu7J2yIU+Qc8RmesCe01kyg=
Authentication-Results: mail-nwsmtp-smtp-production-main-51.vla.yp-c.yandex.net; dkim=pass header.i=@maquefel.me
From: Nikita Shubin <nikita.shubin@maquefel.me>
To: Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Hartley Sweeten <hsweeten@visionengravers.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Nikita Shubin <nikita.shubin@maquefel.me>,
	Michael Peters <mpeters@embeddedTS.com>,
	Kris Bahnsen <kris@embeddedTS.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v1 20/43] net: cirrus: add DT support for Cirrus EP93xx
Date: Thu,  1 Jun 2023 08:45:25 +0300
Message-Id: <20230601054549.10843-2-nikita.shubin@maquefel.me>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20230424123522.18302-1-nikita.shubin@maquefel.me>
References: <20230424123522.18302-1-nikita.shubin@maquefel.me>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

- find register range from the device tree
- get "copy_addr" from the device tree
- get phy_id from the device tree

Signed-off-by: Nikita Shubin <nikita.shubin@maquefel.me>
---

Notes:
    v0 -> v1:
    
    - dropped platform data entirely
    - dropped copy_addr
    - use phy-handle instead of using non-conventional phy-id

 arch/arm/mach-ep93xx/platform.h          |  2 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c | 67 +++++++++++++-----------
 2 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/arch/arm/mach-ep93xx/platform.h b/arch/arm/mach-ep93xx/platform.h
index 5fb1b919133f..3cf2113491d8 100644
--- a/arch/arm/mach-ep93xx/platform.h
+++ b/arch/arm/mach-ep93xx/platform.h
@@ -5,8 +5,8 @@
 
 #ifndef __ASSEMBLY__
 
-#include <linux/platform_data/eth-ep93xx.h>
 #include <linux/reboot.h>
+#include <linux/platform_data/eth-ep93xx.h>
 
 struct device;
 struct i2c_board_info;
diff --git a/drivers/net/ethernet/cirrus/ep93xx_eth.c b/drivers/net/ethernet/cirrus/ep93xx_eth.c
index 8627ab19d470..41096d4830ff 100644
--- a/drivers/net/ethernet/cirrus/ep93xx_eth.c
+++ b/drivers/net/ethernet/cirrus/ep93xx_eth.c
@@ -17,12 +17,11 @@
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/slab.h>
 
-#include <linux/platform_data/eth-ep93xx.h>
-
 #define DRV_MODULE_NAME		"ep93xx-eth"
 
 #define RX_QUEUE_ENTRIES	64
@@ -738,25 +737,6 @@ static const struct net_device_ops ep93xx_netdev_ops = {
 	.ndo_set_mac_address	= eth_mac_addr,
 };
 
-static struct net_device *ep93xx_dev_alloc(struct ep93xx_eth_data *data)
-{
-	struct net_device *dev;
-
-	dev = alloc_etherdev(sizeof(struct ep93xx_priv));
-	if (dev == NULL)
-		return NULL;
-
-	eth_hw_addr_set(dev, data->dev_addr);
-
-	dev->ethtool_ops = &ep93xx_ethtool_ops;
-	dev->netdev_ops = &ep93xx_netdev_ops;
-
-	dev->features |= NETIF_F_SG | NETIF_F_HW_CSUM;
-
-	return dev;
-}
-
-
 static int ep93xx_eth_remove(struct platform_device *pdev)
 {
 	struct net_device *dev;
@@ -788,27 +768,51 @@ static int ep93xx_eth_remove(struct platform_device *pdev)
 
 static int ep93xx_eth_probe(struct platform_device *pdev)
 {
-	struct ep93xx_eth_data *data;
 	struct net_device *dev;
 	struct ep93xx_priv *ep;
 	struct resource *mem;
+	void __iomem *base_addr;
+	struct device_node *np;
+	u32 phy_id;
 	int irq;
 	int err;
 
 	if (pdev == NULL)
 		return -ENODEV;
-	data = dev_get_platdata(&pdev->dev);
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
 	if (!mem || irq < 0)
 		return -ENXIO;
 
-	dev = ep93xx_dev_alloc(data);
+	base_addr = ioremap(mem->start, resource_size(mem));
+	if (!base_addr) {
+		dev_err(&pdev->dev, "Failed to ioremap ethernet registers\n");
+		return -EIO;
+	}
+
+	np = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
+	if (!np) {
+		dev_err(&pdev->dev, "Please provide \"phy-handle\"\n");
+		return -ENODEV;
+	}
+
+	if (of_property_read_u32(np, "reg", &phy_id)) {
+		dev_err(&pdev->dev, "Failed to locate \"phy_id\"\n");
+		return -ENOENT;
+	}
+
+	dev = alloc_etherdev(sizeof(struct ep93xx_priv));
 	if (dev == NULL) {
 		err = -ENOMEM;
 		goto err_out;
 	}
+
+	eth_hw_addr_set(dev, base_addr + 0x50);
+	dev->ethtool_ops = &ep93xx_ethtool_ops;
+	dev->netdev_ops = &ep93xx_netdev_ops;
+	dev->features |= NETIF_F_SG | NETIF_F_HW_CSUM;
+
 	ep = netdev_priv(dev);
 	ep->dev = dev;
 	SET_NETDEV_DEV(dev, &pdev->dev);
@@ -824,15 +828,10 @@ static int ep93xx_eth_probe(struct platform_device *pdev)
 		goto err_out;
 	}
 
-	ep->base_addr = ioremap(mem->start, resource_size(mem));
-	if (ep->base_addr == NULL) {
-		dev_err(&pdev->dev, "Failed to ioremap ethernet registers\n");
-		err = -EIO;
-		goto err_out;
-	}
+	ep->base_addr = base_addr;
 	ep->irq = irq;
 
-	ep->mii.phy_id = data->phy_id;
+	ep->mii.phy_id = phy_id;
 	ep->mii.phy_id_mask = 0x1f;
 	ep->mii.reg_num_mask = 0x1f;
 	ep->mii.dev = dev;
@@ -859,12 +858,18 @@ static int ep93xx_eth_probe(struct platform_device *pdev)
 	return err;
 }
 
+static const struct of_device_id ep93xx_eth_of_ids[] = {
+	{ .compatible = "cirrus,ep9301-eth" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ep93xx_eth_of_ids);
 
 static struct platform_driver ep93xx_eth_driver = {
 	.probe		= ep93xx_eth_probe,
 	.remove		= ep93xx_eth_remove,
 	.driver		= {
 		.name	= "ep93xx-eth",
+		.of_match_table = ep93xx_eth_of_ids,
 	},
 };
 
-- 
2.37.4


