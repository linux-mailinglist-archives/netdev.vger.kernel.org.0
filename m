Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C286267D11F
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbjAZQRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjAZQRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:17:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A466A35A8;
        Thu, 26 Jan 2023 08:17:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F483B81E84;
        Thu, 26 Jan 2023 16:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBB7C433EF;
        Thu, 26 Jan 2023 16:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674749824;
        bh=il9nEzHQefCpXbKAxdsRaVuBE+i1m12IQ1FVPUbBB5U=;
        h=From:To:Cc:Subject:Date:From;
        b=VYJ0hCgxkWYFhdQayaqAd+NRTEZ0J+iD/iMUMbTqTlslkBpKPMdQrdlYx60+96vQa
         Kv8De8LuYAec9m1uv3Fe27NtET72SRMBynIBv4p/hdI9IhJ44QumSRo1z82S8VX+Ji
         5Mr5gzW+nQygR7tyoyit2Vld6kpvsJ8h9EIaOAOM5aDz7CCVRydX2swsR9gwWuHVr+
         EwAZfuYOW1qsydeqzr2Jvg3n08+sQP4yLhewPzB7snyIBEt3O5vlw/1xs2Ycsh++JX
         qeWfwwHytK+h5n5Go8K8XdUVIyc9OyGyfTF2GjPWKDjkFlarjPehny8PnQeCQnqCFc
         D7bdKtLSzr9TA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Varka Bhadram <varkabhadram@gmail.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     linux-gpio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] cc2520: move to gpio descriptors
Date:   Thu, 26 Jan 2023 17:15:59 +0100
Message-Id: <20230126161658.2983292-1-arnd@kernel.org>
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

cc2520 supports both probing from static platform_data and
from devicetree, but there have never been any definitions
of the platform data in the mainline kernel, so it's safe
to assume that only the DT path is used.

After folding cc2520_platform_data into the driver itself,
the GPIO handling can be simplified by moving to the modern
gpiod interface.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS                     |   1 -
 drivers/net/ieee802154/cc2520.c | 136 +++++++++-----------------------
 include/linux/spi/cc2520.h      |  21 -----
 3 files changed, 37 insertions(+), 121 deletions(-)
 delete mode 100644 include/linux/spi/cc2520.h

diff --git a/MAINTAINERS b/MAINTAINERS
index acda33cbd689..a36ead3ce7a3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4650,7 +4650,6 @@ L:	linux-wpan@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
 F:	drivers/net/ieee802154/cc2520.c
-F:	include/linux/spi/cc2520.h
 
 CCREE ARM TRUSTZONE CRYPTOCELL REE DRIVER
 M:	Gilad Ben-Yossef <gilad@benyossef.com>
diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
index edc769daad07..a94d8dd71aad 100644
--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -7,14 +7,13 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/delay.h>
 #include <linux/spi/spi.h>
-#include <linux/spi/cc2520.h>
+#include <linux/property.h>
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
 #include <linux/skbuff.h>
-#include <linux/of_gpio.h>
 #include <linux/ieee802154.h>
 #include <linux/crc-ccitt.h>
 #include <asm/unaligned.h>
@@ -206,7 +205,7 @@ struct cc2520_private {
 	struct mutex buffer_mutex;	/* SPI buffer mutex */
 	bool is_tx;			/* Flag for sync b/w Tx and Rx */
 	bool amplified;			/* Flag for CC2591 */
-	int fifo_pin;			/* FIFO GPIO pin number */
+	struct gpio_desc *fifo_pin;	/* FIFO GPIO pin number */
 	struct work_struct fifop_irqwork;/* Workqueue for FIFOP */
 	spinlock_t lock;		/* Lock for is_tx*/
 	struct completion tx_complete;	/* Work completion for Tx */
@@ -875,7 +874,7 @@ static void cc2520_fifop_irqwork(struct work_struct *work)
 
 	dev_dbg(&priv->spi->dev, "fifop interrupt received\n");
 
-	if (gpio_get_value(priv->fifo_pin))
+	if (gpiod_get_value(priv->fifo_pin))
 		cc2520_rx(priv);
 	else
 		dev_dbg(&priv->spi->dev, "rxfifo overflow\n");
@@ -912,49 +911,11 @@ static irqreturn_t cc2520_sfd_isr(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int cc2520_get_platform_data(struct spi_device *spi,
-				    struct cc2520_platform_data *pdata)
-{
-	struct device_node *np = spi->dev.of_node;
-	struct cc2520_private *priv = spi_get_drvdata(spi);
-
-	if (!np) {
-		struct cc2520_platform_data *spi_pdata = spi->dev.platform_data;
-
-		if (!spi_pdata)
-			return -ENOENT;
-		*pdata = *spi_pdata;
-		priv->fifo_pin = pdata->fifo;
-		return 0;
-	}
-
-	pdata->fifo = of_get_named_gpio(np, "fifo-gpio", 0);
-	priv->fifo_pin = pdata->fifo;
-
-	pdata->fifop = of_get_named_gpio(np, "fifop-gpio", 0);
-
-	pdata->sfd = of_get_named_gpio(np, "sfd-gpio", 0);
-	pdata->cca = of_get_named_gpio(np, "cca-gpio", 0);
-	pdata->vreg = of_get_named_gpio(np, "vreg-gpio", 0);
-	pdata->reset = of_get_named_gpio(np, "reset-gpio", 0);
-
-	/* CC2591 front end for CC2520 */
-	if (of_property_read_bool(np, "amplified"))
-		priv->amplified = true;
-
-	return 0;
-}
-
 static int cc2520_hw_init(struct cc2520_private *priv)
 {
 	u8 status = 0, state = 0xff;
 	int ret;
 	int timeout = 100;
-	struct cc2520_platform_data pdata;
-
-	ret = cc2520_get_platform_data(priv->spi, &pdata);
-	if (ret)
-		goto err_ret;
 
 	ret = cc2520_read_register(priv, CC2520_FSMSTAT1, &state);
 	if (ret)
@@ -1071,7 +1032,11 @@ static int cc2520_hw_init(struct cc2520_private *priv)
 static int cc2520_probe(struct spi_device *spi)
 {
 	struct cc2520_private *priv;
-	struct cc2520_platform_data pdata;
+	struct gpio_desc *fifop;
+	struct gpio_desc *cca;
+	struct gpio_desc *sfd;
+	struct gpio_desc *reset;
+	struct gpio_desc *vreg;
 	int ret;
 
 	priv = devm_kzalloc(&spi->dev, sizeof(*priv), GFP_KERNEL);
@@ -1080,11 +1045,11 @@ static int cc2520_probe(struct spi_device *spi)
 
 	spi_set_drvdata(spi, priv);
 
-	ret = cc2520_get_platform_data(spi, &pdata);
-	if (ret < 0) {
-		dev_err(&spi->dev, "no platform data\n");
-		return -EINVAL;
-	}
+	/* CC2591 front end for CC2520 */
+	/* Assumption that CC2591 is not connected */
+	priv->amplified = false;
+	if (device_property_read_bool(&spi->dev, "amplified"))
+		priv->amplified = true;
 
 	priv->spi = spi;
 
@@ -1098,80 +1063,53 @@ static int cc2520_probe(struct spi_device *spi)
 	spin_lock_init(&priv->lock);
 	init_completion(&priv->tx_complete);
 
-	/* Assumption that CC2591 is not connected */
-	priv->amplified = false;
-
 	/* Request all the gpio's */
-	if (!gpio_is_valid(pdata.fifo)) {
+	priv->fifo_pin = devm_gpiod_get(&spi->dev, "fifo", GPIOD_IN);
+	if (IS_ERR(priv->fifo_pin)) {
 		dev_err(&spi->dev, "fifo gpio is not valid\n");
-		ret = -EINVAL;
+		ret = PTR_ERR(priv->fifo_pin);
 		goto err_hw_init;
 	}
 
-	ret = devm_gpio_request_one(&spi->dev, pdata.fifo,
-				    GPIOF_IN, "fifo");
-	if (ret)
-		goto err_hw_init;
-
-	if (!gpio_is_valid(pdata.cca)) {
+	cca = devm_gpiod_get(&spi->dev, "cca", GPIOD_IN);
+	if (IS_ERR(cca)) {
 		dev_err(&spi->dev, "cca gpio is not valid\n");
-		ret = -EINVAL;
+		ret = PTR_ERR(cca);
 		goto err_hw_init;
 	}
 
-	ret = devm_gpio_request_one(&spi->dev, pdata.cca,
-				    GPIOF_IN, "cca");
-	if (ret)
-		goto err_hw_init;
-
-	if (!gpio_is_valid(pdata.fifop)) {
+	fifop = devm_gpiod_get(&spi->dev, "fifop", GPIOD_IN);
+	if (IS_ERR(fifop)) {
 		dev_err(&spi->dev, "fifop gpio is not valid\n");
-		ret = -EINVAL;
+		ret = PTR_ERR(fifop);
 		goto err_hw_init;
 	}
 
-	ret = devm_gpio_request_one(&spi->dev, pdata.fifop,
-				    GPIOF_IN, "fifop");
-	if (ret)
-		goto err_hw_init;
-
-	if (!gpio_is_valid(pdata.sfd)) {
+	sfd = devm_gpiod_get(&spi->dev, "sfd", GPIOD_IN);
+	if (IS_ERR(sfd)) {
 		dev_err(&spi->dev, "sfd gpio is not valid\n");
-		ret = -EINVAL;
+		ret = PTR_ERR(sfd);
 		goto err_hw_init;
 	}
 
-	ret = devm_gpio_request_one(&spi->dev, pdata.sfd,
-				    GPIOF_IN, "sfd");
-	if (ret)
-		goto err_hw_init;
-
-	if (!gpio_is_valid(pdata.reset)) {
+	reset = devm_gpiod_get(&spi->dev, "reset", GPIOD_OUT_LOW);
+	if (IS_ERR(reset)) {
 		dev_err(&spi->dev, "reset gpio is not valid\n");
-		ret = -EINVAL;
+		ret = PTR_ERR(reset);
 		goto err_hw_init;
 	}
 
-	ret = devm_gpio_request_one(&spi->dev, pdata.reset,
-				    GPIOF_OUT_INIT_LOW, "reset");
-	if (ret)
-		goto err_hw_init;
-
-	if (!gpio_is_valid(pdata.vreg)) {
+	vreg = devm_gpiod_get(&spi->dev, "vreg", GPIOD_OUT_LOW);
+	if (IS_ERR(vreg)) {
 		dev_err(&spi->dev, "vreg gpio is not valid\n");
-		ret = -EINVAL;
+		ret = PTR_ERR(vreg);
 		goto err_hw_init;
 	}
 
-	ret = devm_gpio_request_one(&spi->dev, pdata.vreg,
-				    GPIOF_OUT_INIT_LOW, "vreg");
-	if (ret)
-		goto err_hw_init;
-
-	gpio_set_value(pdata.vreg, HIGH);
+	gpiod_set_value(vreg, HIGH);
 	usleep_range(100, 150);
 
-	gpio_set_value(pdata.reset, HIGH);
+	gpiod_set_value(reset, HIGH);
 	usleep_range(200, 250);
 
 	ret = cc2520_hw_init(priv);
@@ -1180,7 +1118,7 @@ static int cc2520_probe(struct spi_device *spi)
 
 	/* Set up fifop interrupt */
 	ret = devm_request_irq(&spi->dev,
-			       gpio_to_irq(pdata.fifop),
+			       gpiod_to_irq(fifop),
 			       cc2520_fifop_isr,
 			       IRQF_TRIGGER_RISING,
 			       dev_name(&spi->dev),
@@ -1192,7 +1130,7 @@ static int cc2520_probe(struct spi_device *spi)
 
 	/* Set up sfd interrupt */
 	ret = devm_request_irq(&spi->dev,
-			       gpio_to_irq(pdata.sfd),
+			       gpiod_to_irq(sfd),
 			       cc2520_sfd_isr,
 			       IRQF_TRIGGER_FALLING,
 			       dev_name(&spi->dev),
@@ -1241,7 +1179,7 @@ MODULE_DEVICE_TABLE(of, cc2520_of_ids);
 static struct spi_driver cc2520_driver = {
 	.driver = {
 		.name = "cc2520",
-		.of_match_table = of_match_ptr(cc2520_of_ids),
+		.of_match_table = cc2520_of_ids,
 	},
 	.id_table = cc2520_ids,
 	.probe = cc2520_probe,
diff --git a/include/linux/spi/cc2520.h b/include/linux/spi/cc2520.h
deleted file mode 100644
index 449bacf10700..000000000000
--- a/include/linux/spi/cc2520.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/* Header file for cc2520 radio driver
- *
- * Copyright (C) 2014 Varka Bhadram <varkab@cdac.in>
- *                    Md.Jamal Mohiuddin <mjmohiuddin@cdac.in>
- *                    P Sowjanya <sowjanyap@cdac.in>
- */
-
-#ifndef __CC2520_H
-#define __CC2520_H
-
-struct cc2520_platform_data {
-	int fifo;
-	int fifop;
-	int cca;
-	int sfd;
-	int reset;
-	int vreg;
-};
-
-#endif
-- 
2.39.0

