Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665DA67CCB5
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 14:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjAZNwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 08:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjAZNwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 08:52:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FABD442E4;
        Thu, 26 Jan 2023 05:52:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67667B81D4A;
        Thu, 26 Jan 2023 13:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5994CC433D2;
        Thu, 26 Jan 2023 13:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674741143;
        bh=Z3ryCpbhMhxybS2atGPOTf/Ymkz/FXi9EazhV0g8+xM=;
        h=From:To:Cc:Subject:Date:From;
        b=qSOsnuu5WjuMXdvtDwsOZlHQACIW3/uYSBhkLOrdUX8HKDsHyEIH7JT5g4p45IaXk
         WLN1jHgX+zOkN0adTPu3HV9vNev9obFBmBjX0L1tounexZzg2YsiQxDHGY4BauQoeu
         vTW9a8zGOArEgereAA3KgQIVmxW74B4JRHlhtJR2GwS6NAlsPKOhyN8J75En1Ga9GK
         jum4IzYdR7sQpKUiNV5cgb8aGW3n6cTWe18SV5blta0EW9a9GI3m/5VUT0klu0LdRZ
         pELlV6HIaTkh73qBr+JKb+z1Edcot07xyIginVYbNlkp6T9tIhNA8409Au4tBFzwPy
         qhebWdMQq6BGQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     linux-gpio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] at86rf230: convert to gpio descriptors
Date:   Thu, 26 Jan 2023 14:51:23 +0100
Message-Id: <20230126135215.3387820-1-arnd@kernel.org>
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

There are no remaining in-tree users of the platform_data,
so this driver can be converted to using the simpler gpiod
interfaces.

Any out-of-tree users that rely on the platform data can
provide the data using the device_property and gpio_lookup
interfaces instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ieee802154/at86rf230.c | 82 +++++++++---------------------
 include/linux/spi/at86rf230.h      | 20 --------
 2 files changed, 25 insertions(+), 77 deletions(-)
 delete mode 100644 include/linux/spi/at86rf230.h

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 15f283b26721..66193756c891 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -15,14 +15,13 @@
 #include <linux/jiffies.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/delay.h>
 #include <linux/spi/spi.h>
-#include <linux/spi/at86rf230.h>
 #include <linux/regmap.h>
 #include <linux/skbuff.h>
-#include <linux/of_gpio.h>
 #include <linux/ieee802154.h>
+#include <linux/property.h>
 
 #include <net/mac802154.h>
 #include <net/cfg802154.h>
@@ -82,7 +81,7 @@ struct at86rf230_local {
 	struct ieee802154_hw *hw;
 	struct at86rf2xx_chip_data *data;
 	struct regmap *regmap;
-	int slp_tr;
+	struct gpio_desc *slp_tr;
 	bool sleep;
 
 	struct completion state_complete;
@@ -107,8 +106,8 @@ at86rf230_async_state_change(struct at86rf230_local *lp,
 static inline void
 at86rf230_sleep(struct at86rf230_local *lp)
 {
-	if (gpio_is_valid(lp->slp_tr)) {
-		gpio_set_value(lp->slp_tr, 1);
+	if (lp->slp_tr) {
+		gpiod_set_value(lp->slp_tr, 1);
 		usleep_range(lp->data->t_off_to_sleep,
 			     lp->data->t_off_to_sleep + 10);
 		lp->sleep = true;
@@ -118,8 +117,8 @@ at86rf230_sleep(struct at86rf230_local *lp)
 static inline void
 at86rf230_awake(struct at86rf230_local *lp)
 {
-	if (gpio_is_valid(lp->slp_tr)) {
-		gpio_set_value(lp->slp_tr, 0);
+	if (lp->slp_tr) {
+		gpiod_set_value(lp->slp_tr, 0);
 		usleep_range(lp->data->t_sleep_to_off,
 			     lp->data->t_sleep_to_off + 100);
 		lp->sleep = false;
@@ -204,9 +203,9 @@ at86rf230_write_subreg(struct at86rf230_local *lp,
 static inline void
 at86rf230_slp_tr_rising_edge(struct at86rf230_local *lp)
 {
-	gpio_set_value(lp->slp_tr, 1);
+	gpiod_set_value(lp->slp_tr, 1);
 	udelay(1);
-	gpio_set_value(lp->slp_tr, 0);
+	gpiod_set_value(lp->slp_tr, 0);
 }
 
 static bool
@@ -819,7 +818,7 @@ at86rf230_write_frame_complete(void *context)
 
 	ctx->trx.len = 2;
 
-	if (gpio_is_valid(lp->slp_tr))
+	if (lp->slp_tr)
 		at86rf230_slp_tr_rising_edge(lp);
 	else
 		at86rf230_async_write_reg(lp, RG_TRX_STATE, STATE_BUSY_TX, ctx,
@@ -1415,32 +1414,6 @@ static int at86rf230_hw_init(struct at86rf230_local *lp, u8 xtal_trim)
 	return at86rf230_write_subreg(lp, SR_SLOTTED_OPERATION, 0);
 }
 
-static int
-at86rf230_get_pdata(struct spi_device *spi, int *rstn, int *slp_tr,
-		    u8 *xtal_trim)
-{
-	struct at86rf230_platform_data *pdata = spi->dev.platform_data;
-	int ret;
-
-	if (!IS_ENABLED(CONFIG_OF) || !spi->dev.of_node) {
-		if (!pdata)
-			return -ENOENT;
-
-		*rstn = pdata->rstn;
-		*slp_tr = pdata->slp_tr;
-		*xtal_trim = pdata->xtal_trim;
-		return 0;
-	}
-
-	*rstn = of_get_named_gpio(spi->dev.of_node, "reset-gpio", 0);
-	*slp_tr = of_get_named_gpio(spi->dev.of_node, "sleep-gpio", 0);
-	ret = of_property_read_u8(spi->dev.of_node, "xtal-trim", xtal_trim);
-	if (ret < 0 && ret != -EINVAL)
-		return ret;
-
-	return 0;
-}
-
 static int
 at86rf230_detect_device(struct at86rf230_local *lp)
 {
@@ -1547,7 +1520,8 @@ static int at86rf230_probe(struct spi_device *spi)
 	struct ieee802154_hw *hw;
 	struct at86rf230_local *lp;
 	unsigned int status;
-	int rc, irq_type, rstn, slp_tr;
+	int rc, irq_type;
+	struct gpio_desc *rstn, *slp_tr;
 	u8 xtal_trim = 0;
 
 	if (!spi->irq) {
@@ -1555,32 +1529,26 @@ static int at86rf230_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	rc = at86rf230_get_pdata(spi, &rstn, &slp_tr, &xtal_trim);
-	if (rc < 0) {
-		dev_err(&spi->dev, "failed to parse platform_data: %d\n", rc);
+	rc = device_property_read_u8(&spi->dev, "xtal-trim", &xtal_trim);
+	if (rc < 0 && rc != -EINVAL) {
+		dev_err(&spi->dev, "failed to parse xtal-trim: %d\n", rc);
 		return rc;
 	}
 
-	if (gpio_is_valid(rstn)) {
-		rc = devm_gpio_request_one(&spi->dev, rstn,
-					   GPIOF_OUT_INIT_HIGH, "rstn");
-		if (rc)
-			return rc;
-	}
+	rstn = devm_gpiod_get_optional(&spi->dev, "rstn", GPIOD_OUT_HIGH);
+	if (IS_ERR(rstn))
+		return PTR_ERR(rstn);
 
-	if (gpio_is_valid(slp_tr)) {
-		rc = devm_gpio_request_one(&spi->dev, slp_tr,
-					   GPIOF_OUT_INIT_LOW, "slp_tr");
-		if (rc)
-			return rc;
-	}
+	slp_tr = devm_gpiod_get_optional(&spi->dev, "slp_tr", GPIOD_OUT_LOW);
+	if (IS_ERR(slp_tr))
+		return PTR_ERR(slp_tr);
 
 	/* Reset */
-	if (gpio_is_valid(rstn)) {
+	if (rstn) {
 		udelay(1);
-		gpio_set_value_cansleep(rstn, 0);
+		gpiod_set_value_cansleep(rstn, 0);
 		udelay(1);
-		gpio_set_value_cansleep(rstn, 1);
+		gpiod_set_value_cansleep(rstn, 1);
 		usleep_range(120, 240);
 	}
 
@@ -1682,7 +1650,7 @@ MODULE_DEVICE_TABLE(spi, at86rf230_device_id);
 static struct spi_driver at86rf230_driver = {
 	.id_table = at86rf230_device_id,
 	.driver = {
-		.of_match_table = of_match_ptr(at86rf230_of_match),
+		.of_match_table = at86rf230_of_match,
 		.name	= "at86rf230",
 	},
 	.probe      = at86rf230_probe,
diff --git a/include/linux/spi/at86rf230.h b/include/linux/spi/at86rf230.h
deleted file mode 100644
index d278576ab692..000000000000
--- a/include/linux/spi/at86rf230.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * AT86RF230/RF231 driver
- *
- * Copyright (C) 2009-2012 Siemens AG
- *
- * Written by:
- * Dmitry Eremin-Solenikov <dmitry.baryshkov@siemens.com>
- */
-#ifndef AT86RF230_H
-#define AT86RF230_H
-
-struct at86rf230_platform_data {
-	int rstn;
-	int slp_tr;
-	int dig2;
-	u8 xtal_trim;
-};
-
-#endif
-- 
2.39.0

