Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD3D67D125
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbjAZQR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbjAZQRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:17:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BB82D163;
        Thu, 26 Jan 2023 08:17:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8925DB81E95;
        Thu, 26 Jan 2023 16:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC1FC4339B;
        Thu, 26 Jan 2023 16:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674749863;
        bh=qoJdV7Hy0K/c3KYKzdd66F4ZCzYzGAgyJAzosdZYTXY=;
        h=From:To:Cc:Subject:Date:From;
        b=cTckPmHczcg+AmhpY0WopBVBiM4auGprubeGb+ETYLShjMPmJ5mpuaJ5Fb9c3chV7
         4oAxWJ37kNRL0IUroFpa8oppcSeG4A1V/D4789jqdycoA0h1mZwo6sQluhxF23HL9Q
         3U0qeWhGPgwjuBxF95V8hBvtfFkf2Kjx05CAFKDYm54iaXuf5l8o1w60oYVYKcbGFD
         OfqMZY2DuXEYF8x403lWa5nu9rB5e1Ddnk62W2bGW28QMoLwc+I9Y8tDoYSOzJT7zO
         zqXtMaglx4z6G99tVWYzg5RdC1YaJcxunFnbvfxRr/VGjienZC9y9u/6FTLeKoLfbS
         WLmQofbj2Pb1Q==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     linux-gpio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ca8210: move to gpio descriptors
Date:   Thu, 26 Jan 2023 17:17:15 +0100
Message-Id: <20230126161737.2985704-1-arnd@kernel.org>
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

The driver requires DT based probing already, and can
be simplified by using the modern gpio interfaces.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ieee802154/ca8210.c | 93 +++++++++------------------------
 1 file changed, 24 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 5c0be6a3ec5e..2ee2746688ea 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -52,13 +52,11 @@
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
-#include <linux/gpio.h>
 #include <linux/ieee802154.h>
 #include <linux/io.h>
 #include <linux/kfifo.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/of_gpio.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/poll.h>
@@ -312,6 +310,9 @@ struct ca8210_test {
  * @promiscuous:            whether the ca8210 is in promiscuous mode or not
  * @retries:                records how many times the current pending spi
  *                          transfer has been retried
+ * @gpio_reset:     	    gpio of ca8210 reset line
+ * @gpio_irq:       	    gpio number of ca8210 interrupt line
+ * @irq_id:        	    identifier for the ca8210 irq
  */
 struct ca8210_priv {
 	struct spi_device *spi;
@@ -332,6 +333,9 @@ struct ca8210_priv {
 	struct completion spi_transfer_complete, sync_exchange_complete;
 	bool promiscuous;
 	int retries;
+	struct gpio_desc *gpio_reset;
+	struct gpio_desc *gpio_irq;
+	int irq_id;
 };
 
 /**
@@ -351,18 +355,12 @@ struct work_priv_container {
  * @extclockenable: true if the external clock is to be enabled
  * @extclockfreq:   frequency of the external clock
  * @extclockgpio:   ca8210 output gpio of the external clock
- * @gpio_reset:     gpio number of ca8210 reset line
- * @gpio_irq:       gpio number of ca8210 interrupt line
- * @irq_id:         identifier for the ca8210 irq
  *
  */
 struct ca8210_platform_data {
 	bool extclockenable;
 	unsigned int extclockfreq;
 	unsigned int extclockgpio;
-	int gpio_reset;
-	int gpio_irq;
-	int irq_id;
 };
 
 /**
@@ -628,14 +626,13 @@ static int ca8210_spi_transfer(
  */
 static void ca8210_reset_send(struct spi_device *spi, unsigned int ms)
 {
-	struct ca8210_platform_data *pdata = spi->dev.platform_data;
 	struct ca8210_priv *priv = spi_get_drvdata(spi);
 	long status;
 
-	gpio_set_value(pdata->gpio_reset, 0);
+	gpiod_set_value(priv->gpio_reset, 0);
 	reinit_completion(&priv->ca8210_is_awake);
 	msleep(ms);
-	gpio_set_value(pdata->gpio_reset, 1);
+	gpiod_set_value(priv->gpio_reset, 1);
 	priv->promiscuous = false;
 
 	/* Wait until wakeup indication seen */
@@ -2788,74 +2785,34 @@ static void ca8210_unregister_ext_clock(struct spi_device *spi)
 	dev_info(&spi->dev, "External clock unregistered\n");
 }
 
-/**
- * ca8210_reset_init() - Initialise the reset input to the ca8210
- * @spi:  Pointer to target ca8210 spi device
- *
- * Return: 0 or linux error code
- */
-static int ca8210_reset_init(struct spi_device *spi)
-{
-	int ret;
-	struct ca8210_platform_data *pdata = spi->dev.platform_data;
-
-	pdata->gpio_reset = of_get_named_gpio(
-		spi->dev.of_node,
-		"reset-gpio",
-		0
-	);
-
-	ret = gpio_direction_output(pdata->gpio_reset, 1);
-	if (ret < 0) {
-		dev_crit(
-			&spi->dev,
-			"Reset GPIO %d did not set to output mode\n",
-			pdata->gpio_reset
-		);
-	}
-
-	return ret;
-}
-
 /**
  * ca8210_interrupt_init() - Initialise the irq output from the ca8210
  * @spi:  Pointer to target ca8210 spi device
  *
  * Return: 0 or linux error code
  */
-static int ca8210_interrupt_init(struct spi_device *spi)
+static int ca8210_interrupt_init(struct spi_device *spi, struct ca8210_priv *priv)
 {
 	int ret;
-	struct ca8210_platform_data *pdata = spi->dev.platform_data;
 
-	pdata->gpio_irq = of_get_named_gpio(
-		spi->dev.of_node,
-		"irq-gpio",
-		0
-	);
-
-	pdata->irq_id = gpio_to_irq(pdata->gpio_irq);
-	if (pdata->irq_id < 0) {
-		dev_crit(
-			&spi->dev,
-			"Could not get irq for gpio pin %d\n",
-			pdata->gpio_irq
-		);
-		gpio_free(pdata->gpio_irq);
-		return pdata->irq_id;
+	priv->gpio_irq = gpiod_get(&spi->dev, "irq", GPIOD_IN);
+	priv->irq_id = gpiod_to_irq(priv->gpio_irq);
+	if (priv->irq_id < 0) {
+		dev_crit(&spi->dev, "Could not get irq for gpio pin\n");
+		gpiod_put(priv->gpio_irq);
+		return priv->irq_id;
 	}
 
 	ret = request_irq(
-		pdata->irq_id,
+		priv->irq_id,
 		ca8210_interrupt_handler,
 		IRQF_TRIGGER_FALLING,
 		"ca8210-irq",
 		spi_get_drvdata(spi)
 	);
 	if (ret) {
-		dev_crit(&spi->dev, "request_irq %d failed\n", pdata->irq_id);
-		gpiod_unexport(gpio_to_desc(pdata->gpio_irq));
-		gpio_free(pdata->gpio_irq);
+		dev_crit(&spi->dev, "request_irq %d failed\n", priv->irq_id);
+		gpiod_put(priv->gpio_irq);
 	}
 
 	return ret;
@@ -3009,7 +2966,7 @@ static void ca8210_test_interface_clear(struct ca8210_priv *priv)
  */
 static void ca8210_remove(struct spi_device *spi_device)
 {
-	struct ca8210_priv *priv;
+	struct ca8210_priv *priv = spi_get_drvdata(spi_device);
 	struct ca8210_platform_data *pdata;
 
 	dev_info(&spi_device->dev, "Removing ca8210\n");
@@ -3020,12 +2977,10 @@ static void ca8210_remove(struct spi_device *spi_device)
 			ca8210_unregister_ext_clock(spi_device);
 			ca8210_config_extern_clk(pdata, spi_device, 0);
 		}
-		free_irq(pdata->irq_id, spi_device->dev.driver_data);
+		free_irq(priv->irq_id, spi_device->dev.driver_data);
 		kfree(pdata);
 		spi_device->dev.platform_data = NULL;
 	}
-	/* get spi_device private data */
-	priv = spi_get_drvdata(spi_device);
 	if (priv) {
 		dev_info(
 			&spi_device->dev,
@@ -3114,13 +3069,13 @@ static int ca8210_probe(struct spi_device *spi_device)
 		dev_crit(&spi_device->dev, "ca8210_dev_com_init failed\n");
 		goto error;
 	}
-	ret = ca8210_reset_init(priv->spi);
-	if (ret) {
-		dev_crit(&spi_device->dev, "ca8210_reset_init failed\n");
+	priv->gpio_reset = gpiod_get(&spi_device->dev, "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR(priv->gpio_reset)) {
+		dev_crit(&spi_device->dev, "ca8210 reset init failed\n");
 		goto error;
 	}
 
-	ret = ca8210_interrupt_init(priv->spi);
+	ret = ca8210_interrupt_init(priv->spi, priv);
 	if (ret) {
 		dev_crit(&spi_device->dev, "ca8210_interrupt_init failed\n");
 		goto error;
-- 
2.39.0

