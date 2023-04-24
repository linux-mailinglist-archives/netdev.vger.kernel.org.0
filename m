Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624FE6ECA69
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 12:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjDXKfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 06:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbjDXKeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 06:34:46 -0400
Received: from forward502c.mail.yandex.net (forward502c.mail.yandex.net [178.154.239.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42C8E68;
        Mon, 24 Apr 2023 03:34:22 -0700 (PDT)
Received: from mail-nwsmtp-smtp-production-main-39.myt.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-39.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:261e:0:640:2e3d:0])
        by forward502c.mail.yandex.net (Yandex) with ESMTP id 2A07A5ECF3;
        Mon, 24 Apr 2023 12:35:52 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-39.myt.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id JZBb1pbWwKo0-bZjfcDZh;
        Mon, 24 Apr 2023 12:35:51 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maquefel.me; s=mail; t=1682328951;
        bh=H/MzURm8LBkdmNsr58WR1SK4CDr2JEUu6baOETb8+Wg=;
        h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
        b=tYpH8otaP3x9f/8bRSAqZu82nnrxTEkZHlayhCB9QMaQcNZBH0DY//Dg5uGzu+1ns
         KYepJxdWKlIOUaF3KNmwGNqIfoWpcK2LJ+vK6ddbxRuwOghoWcuZzEEEjYOl3EjVFS
         1YyW/N6nmcrttqIhmnf0ys65Wv67QgrP9FIDzwT4=
Authentication-Results: mail-nwsmtp-smtp-production-main-39.myt.yp-c.yandex.net; dkim=pass header.i=@maquefel.me
From:   Nikita Shubin <nikita.shubin@maquefel.me>
Cc:     Arnd Bergmann <arnd@kernel.org>, Linus Walleij <linusw@kernel.org>,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/43] net: cirrus: add DT support for Cirrus EP93xx
Date:   Mon, 24 Apr 2023 15:34:35 +0300
Message-Id: <20230424123522.18302-20-nikita.shubin@maquefel.me>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230424123522.18302-1-nikita.shubin@maquefel.me>
References: <20230424123522.18302-1-nikita.shubin@maquefel.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- find register range from the device tree
- get "copy_addr" from the device tree
- get phy_id from the device tree

Signed-off-by: Nikita Shubin <nikita.shubin@maquefel.me>
---

Notes:
    rfc->v0
    Fixed warnings on "(base_addr == NULL)", pace required before the open
    parenthesis '('.
    
    Arnd Bergmann:
    - wildcards ep93xx to something meaningful, i.e. ep9301
    - drop wrappers

 drivers/net/ethernet/cirrus/ep93xx_eth.c | 49 +++++++++++++++++++++---
 1 file changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cirrus/ep93xx_eth.c b/drivers/net/ethernet/cirrus/ep93xx_eth.c
index 8627ab19d470..b156cc75daad 100644
--- a/drivers/net/ethernet/cirrus/ep93xx_eth.c
+++ b/drivers/net/ethernet/cirrus/ep93xx_eth.c
@@ -17,6 +17,8 @@
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/slab.h>
@@ -792,6 +794,8 @@ static int ep93xx_eth_probe(struct platform_device *pdev)
 	struct net_device *dev;
 	struct ep93xx_priv *ep;
 	struct resource *mem;
+	void __iomem *base_addr;
+	struct device_node *np;
 	int irq;
 	int err;
 
@@ -804,6 +808,38 @@ static int ep93xx_eth_probe(struct platform_device *pdev)
 	if (!mem || irq < 0)
 		return -ENXIO;
 
+	base_addr = ioremap(mem->start, resource_size(mem));
+	if (!base_addr) {
+		dev_err(&pdev->dev, "Failed to ioremap ethernet registers\n");
+		return -EIO;
+	}
+
+	if (!data) {
+		np = pdev->dev.of_node;
+		if (IS_ENABLED(CONFIG_OF) && np) {
+			u32 phy_id;
+
+			data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+			if (!data)
+				return -ENOMEM;
+
+			if (of_property_read_bool(np, "copy_addr")) {
+				memcpy_fromio(data->dev_addr, base_addr + 0x50, 6);
+				dev_info(&pdev->dev, "MAC=%pM\n", data->dev_addr);
+			}
+
+			if (of_property_read_u32(np, "phy_id", &phy_id)) {
+				dev_err(&pdev->dev, "Failed to parse \"phy_id\"\n");
+				return -ENOENT;
+			}
+
+			data->phy_id = phy_id;
+		}
+	}
+
+	if (!data)
+		return -ENOENT;
+
 	dev = ep93xx_dev_alloc(data);
 	if (dev == NULL) {
 		err = -ENOMEM;
@@ -824,12 +860,7 @@ static int ep93xx_eth_probe(struct platform_device *pdev)
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
 
 	ep->mii.phy_id = data->phy_id;
@@ -859,12 +890,18 @@ static int ep93xx_eth_probe(struct platform_device *pdev)
 	return err;
 }
 
+static const struct of_device_id ep93xx_eth_of_ids[] = {
+	{ .compatible = "cirrus,ep9301-eth" },
+	{},
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
2.39.2

