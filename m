Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C3167CCAC
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 14:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjAZNvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 08:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbjAZNvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 08:51:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3EA4CE7F;
        Thu, 26 Jan 2023 05:50:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCD51617FF;
        Thu, 26 Jan 2023 13:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEECBC433A0;
        Thu, 26 Jan 2023 13:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674741040;
        bh=waQRMFuqxVZvLTarVOLu2AMjbJkqhlrOHWytHi3gGkQ=;
        h=From:To:Cc:Subject:Date:From;
        b=lgLtdinpU/cdpYmJaguihJy2shzDnw1ETYSp6SSljokJpfSf2+1vzpeeLMzYfd1qV
         re1vWWKe/h1Evf1VtbwdREJ5VNH+p469I/ieMIoYsZosH/OaHjFUdPKA937Wg5hcfG
         dy3PJXtKiQB1WwSnC6AOxmdsZ4mcCsC9uS9piHTAD+i6oAuC1QSUZwKPjeiSQuoX9J
         oGv6AbjpP1QLqP27V+Ht7Xs1ub9pLa3SV9OsEWFigaWuHl/zeOdzmsGzhDuFEDGVKW
         rLggeNHipavLW0fec6i6YmhJYOaP39SbViMImyJnNMXJxPaBDCfCWJi+5CFo+jlg+9
         sauZ3x65FrsCw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     linux-gpio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH] mmc: atmel: convert to gpio descriptos
Date:   Thu, 26 Jan 2023 14:50:04 +0100
Message-Id: <20230126135034.3320638-1-arnd@kernel.org>
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

All Atmel (now Microchip) machines boot using DT, so the
old platform_data for this driver is no longer used by any
boards.

Removing the pdata probe lets us simplify the GPIO handling
with the use of the descriptor API.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/mmc/host/atmel-mci.c | 179 +++++++++++++++--------------------
 include/linux/atmel-mci.h    |  46 ---------
 2 files changed, 77 insertions(+), 148 deletions(-)
 delete mode 100644 include/linux/atmel-mci.h

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index bb9bbf1c927b..40006a960277 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -30,7 +30,6 @@
 #include <linux/mmc/host.h>
 #include <linux/mmc/sdio.h>
 
-#include <linux/atmel-mci.h>
 #include <linux/atmel_pdc.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
@@ -40,6 +39,30 @@
 #include <asm/io.h>
 #include <asm/unaligned.h>
 
+#define ATMCI_MAX_NR_SLOTS	2
+
+/**
+ * struct mci_slot_pdata - board-specific per-slot configuration
+ * @bus_width: Number of data lines wired up the slot
+ * @wp_pin: GPIO pin wired to the write protect sensor
+ * @detect_is_active_high: The state of the detect pin when it is active
+ * @non_removable: The slot is not removable, only detect once
+ *
+ * If a given slot is not present on the board, @bus_width should be
+ * set to 0. The other fields are ignored in this case.
+ *
+ * Any pins that aren't available should be set to a negative value.
+ *
+ * Note that support for multiple slots is experimental -- some cards
+ * might get upset if we don't get the clock management exactly right.
+ * But in most cases, it should work just fine.
+ */
+struct mci_slot_pdata {
+	unsigned int		bus_width;
+	bool			detect_is_active_high;
+	bool			non_removable;
+};
+
 /*
  * Superset of MCI IP registers integrated in Atmel AT91 Processor
  * Registers and bitfields marked with [2] are only available in MCI2
@@ -388,8 +411,8 @@ struct atmel_mci_slot {
 #define ATMCI_CARD_NEED_INIT	1
 #define ATMCI_SHUTDOWN		2
 
-	int			detect_pin;
-	int			wp_pin;
+	struct gpio_desc	*detect_pin;
+	struct gpio_desc	*wp_pin;
 	bool			detect_is_active_high;
 
 	struct timer_list	detect_timer;
@@ -593,7 +616,6 @@ static void atmci_init_debugfs(struct atmel_mci_slot *slot)
 			   &host->completed_events);
 }
 
-#if defined(CONFIG_OF)
 static const struct of_device_id atmci_dt_ids[] = {
 	{ .compatible = "atmel,hsmci" },
 	{ /* sentinel */ }
@@ -601,23 +623,13 @@ static const struct of_device_id atmci_dt_ids[] = {
 
 MODULE_DEVICE_TABLE(of, atmci_dt_ids);
 
-static struct mci_platform_data*
-atmci_of_init(struct platform_device *pdev)
+static int
+atmci_of_init(struct platform_device *pdev, struct mci_slot_pdata *pdata)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *cnp;
-	struct mci_platform_data *pdata;
 	u32 slot_id;
 
-	if (!np) {
-		dev_err(&pdev->dev, "device node not found\n");
-		return ERR_PTR(-EINVAL);
-	}
-
-	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata)
-		return ERR_PTR(-ENOMEM);
-
 	for_each_child_of_node(np, cnp) {
 		if (of_property_read_u32(cnp, "reg", &slot_id)) {
 			dev_warn(&pdev->dev, "reg property is missing for %pOF\n",
@@ -633,31 +645,18 @@ atmci_of_init(struct platform_device *pdev)
 		}
 
 		if (of_property_read_u32(cnp, "bus-width",
-		                         &pdata->slot[slot_id].bus_width))
-			pdata->slot[slot_id].bus_width = 1;
-
-		pdata->slot[slot_id].detect_pin =
-			of_get_named_gpio(cnp, "cd-gpios", 0);
+		                         &pdata[slot_id].bus_width))
+			pdata[slot_id].bus_width = 1;
 
-		pdata->slot[slot_id].detect_is_active_high =
+		pdata[slot_id].detect_is_active_high =
 			of_property_read_bool(cnp, "cd-inverted");
 
-		pdata->slot[slot_id].non_removable =
+		pdata[slot_id].non_removable =
 			of_property_read_bool(cnp, "non-removable");
-
-		pdata->slot[slot_id].wp_pin =
-			of_get_named_gpio(cnp, "wp-gpios", 0);
 	}
 
-	return pdata;
-}
-#else /* CONFIG_OF */
-static inline struct mci_platform_data*
-atmci_of_init(struct platform_device *dev)
-{
-	return ERR_PTR(-EINVAL);
+	return 0;
 }
-#endif
 
 static inline unsigned int atmci_get_version(struct atmel_mci *host)
 {
@@ -1509,8 +1508,8 @@ static int atmci_get_ro(struct mmc_host *mmc)
 	int			read_only = -ENOSYS;
 	struct atmel_mci_slot	*slot = mmc_priv(mmc);
 
-	if (gpio_is_valid(slot->wp_pin)) {
-		read_only = gpio_get_value(slot->wp_pin);
+	if (slot->wp_pin) {
+		read_only = gpiod_get_value(slot->wp_pin);
 		dev_dbg(&mmc->class_dev, "card is %s\n",
 				read_only ? "read-only" : "read-write");
 	}
@@ -1523,8 +1522,8 @@ static int atmci_get_cd(struct mmc_host *mmc)
 	int			present = -ENOSYS;
 	struct atmel_mci_slot	*slot = mmc_priv(mmc);
 
-	if (gpio_is_valid(slot->detect_pin)) {
-		present = !(gpio_get_value(slot->detect_pin) ^
+	if (slot->detect_pin) {
+		present = !(gpiod_get_value(slot->detect_pin) ^
 			    slot->detect_is_active_high);
 		dev_dbg(&mmc->class_dev, "card is %spresent\n",
 				present ? "" : "not ");
@@ -1637,8 +1636,8 @@ static void atmci_detect_change(struct timer_list *t)
 	if (test_bit(ATMCI_SHUTDOWN, &slot->flags))
 		return;
 
-	enable_irq(gpio_to_irq(slot->detect_pin));
-	present = !(gpio_get_value(slot->detect_pin) ^
+	enable_irq(gpiod_to_irq(slot->detect_pin));
+	present = !(gpiod_get_value(slot->detect_pin) ^
 		    slot->detect_is_active_high);
 	present_old = test_bit(ATMCI_CARD_PRESENT, &slot->flags);
 
@@ -2231,18 +2230,15 @@ static int atmci_init_slot(struct atmel_mci *host,
 	slot = mmc_priv(mmc);
 	slot->mmc = mmc;
 	slot->host = host;
-	slot->detect_pin = slot_data->detect_pin;
-	slot->wp_pin = slot_data->wp_pin;
 	slot->detect_is_active_high = slot_data->detect_is_active_high;
 	slot->sdc_reg = sdc_reg;
 	slot->sdio_irq = sdio_irq;
 
 	dev_dbg(&mmc->class_dev,
-	        "slot[%u]: bus_width=%u, detect_pin=%d, "
-		"detect_is_active_high=%s, wp_pin=%d\n",
-		id, slot_data->bus_width, slot_data->detect_pin,
-		slot_data->detect_is_active_high ? "true" : "false",
-		slot_data->wp_pin);
+	        "slot[%u]: bus_width=%u, "
+		"detect_is_active_high=%s\n",
+		id, slot_data->bus_width,
+		slot_data->detect_is_active_high ? "true" : "false");
 
 	mmc->ops = &atmci_ops;
 	mmc->f_min = DIV_ROUND_UP(host->bus_hz, 512);
@@ -2278,30 +2274,29 @@ static int atmci_init_slot(struct atmel_mci *host,
 
 	/* Assume card is present initially */
 	set_bit(ATMCI_CARD_PRESENT, &slot->flags);
-	if (gpio_is_valid(slot->detect_pin)) {
-		if (devm_gpio_request(&host->pdev->dev, slot->detect_pin,
-				      "mmc_detect")) {
-			dev_dbg(&mmc->class_dev, "no detect pin available\n");
-			slot->detect_pin = -EBUSY;
-		} else if (gpio_get_value(slot->detect_pin) ^
-				slot->detect_is_active_high) {
+
+	slot->detect_pin = devm_gpiod_get_optional(&host->pdev->dev, "cd", GPIOD_IN);
+	if (!IS_ERR(slot->detect_pin)) {
+		dev_dbg(&mmc->class_dev, "no detect pin available\n");
+		slot->detect_pin = NULL;
+	} else if (slot->detect_pin) {
+		if (gpiod_get_value(slot->detect_pin) ^
+		    slot->detect_is_active_high) {
 			clear_bit(ATMCI_CARD_PRESENT, &slot->flags);
 		}
 	}
 
-	if (!gpio_is_valid(slot->detect_pin)) {
+	if (!slot->detect_pin) {
 		if (slot_data->non_removable)
 			mmc->caps |= MMC_CAP_NONREMOVABLE;
 		else
 			mmc->caps |= MMC_CAP_NEEDS_POLL;
 	}
 
-	if (gpio_is_valid(slot->wp_pin)) {
-		if (devm_gpio_request(&host->pdev->dev, slot->wp_pin,
-				      "mmc_wp")) {
-			dev_dbg(&mmc->class_dev, "no WP pin available\n");
-			slot->wp_pin = -EBUSY;
-		}
+	slot->wp_pin = devm_gpiod_get_optional(&host->pdev->dev, "wp", GPIOD_IN);
+	if (IS_ERR(slot->wp_pin)) {
+		dev_dbg(&mmc->class_dev, "no WP pin available\n");
+		slot->wp_pin = NULL;
 	}
 
 	host->slot[id] = slot;
@@ -2312,18 +2307,18 @@ static int atmci_init_slot(struct atmel_mci *host,
 		return ret;
 	}
 
-	if (gpio_is_valid(slot->detect_pin)) {
+	if (slot->detect_pin) {
 		timer_setup(&slot->detect_timer, atmci_detect_change, 0);
 
-		ret = request_irq(gpio_to_irq(slot->detect_pin),
+		ret = request_irq(gpiod_to_irq(slot->detect_pin),
 				atmci_detect_interrupt,
 				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
 				"mmc-detect", slot);
 		if (ret) {
 			dev_dbg(&mmc->class_dev,
 				"could not request IRQ %d for detect pin\n",
-				gpio_to_irq(slot->detect_pin));
-			slot->detect_pin = -EBUSY;
+				gpiod_to_irq(slot->detect_pin));
+			slot->detect_pin = NULL;
 		}
 	}
 
@@ -2342,10 +2337,8 @@ static void atmci_cleanup_slot(struct atmel_mci_slot *slot,
 
 	mmc_remove_host(slot->mmc);
 
-	if (gpio_is_valid(slot->detect_pin)) {
-		int pin = slot->detect_pin;
-
-		free_irq(gpio_to_irq(pin), slot);
+	if (slot->detect_pin) {
+		free_irq(gpiod_to_irq(slot->detect_pin), slot);
 		del_timer_sync(&slot->detect_timer);
 	}
 
@@ -2357,22 +2350,6 @@ static int atmci_configure_dma(struct atmel_mci *host)
 {
 	host->dma.chan = dma_request_chan(&host->pdev->dev, "rxtx");
 
-	if (PTR_ERR(host->dma.chan) == -ENODEV) {
-		struct mci_platform_data *pdata = host->pdev->dev.platform_data;
-		dma_cap_mask_t mask;
-
-		if (!pdata || !pdata->dma_filter)
-			return -ENODEV;
-
-		dma_cap_zero(mask);
-		dma_cap_set(DMA_SLAVE, mask);
-
-		host->dma.chan = dma_request_channel(mask, pdata->dma_filter,
-						     pdata->dma_slave);
-		if (!host->dma.chan)
-			host->dma.chan = ERR_PTR(-ENODEV);
-	}
-
 	if (IS_ERR(host->dma.chan))
 		return PTR_ERR(host->dma.chan);
 
@@ -2450,7 +2427,7 @@ static void atmci_get_cap(struct atmel_mci *host)
 
 static int atmci_probe(struct platform_device *pdev)
 {
-	struct mci_platform_data	*pdata;
+	struct mci_slot_pdata		pdata[ATMCI_MAX_NR_SLOTS];
 	struct atmel_mci		*host;
 	struct resource			*regs;
 	unsigned int			nr_slots;
@@ -2460,23 +2437,21 @@ static int atmci_probe(struct platform_device *pdev)
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!regs)
 		return -ENXIO;
-	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		pdata = atmci_of_init(pdev);
-		if (IS_ERR(pdata)) {
-			dev_err(&pdev->dev, "platform data not available\n");
-			return PTR_ERR(pdata);
-		}
+
+	host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
+	if (!host)
+		return -ENOMEM;
+
+	ret = atmci_of_init(pdev, pdata);
+	if (ret) {
+		dev_err(&pdev->dev, "error parsing DT\n");
+		return ret;
 	}
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return irq;
 
-	host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
-	if (!host)
-		return -ENOMEM;
-
 	host->pdev = pdev;
 	spin_lock_init(&host->lock);
 	INIT_LIST_HEAD(&host->queue);
@@ -2540,16 +2515,16 @@ static int atmci_probe(struct platform_device *pdev)
 	/* We need at least one slot to succeed */
 	nr_slots = 0;
 	ret = -ENODEV;
-	if (pdata->slot[0].bus_width) {
-		ret = atmci_init_slot(host, &pdata->slot[0],
+	if (pdata[0].bus_width) {
+		ret = atmci_init_slot(host, &pdata[0],
 				0, ATMCI_SDCSEL_SLOT_A, ATMCI_SDIOIRQA);
 		if (!ret) {
 			nr_slots++;
 			host->buf_size = host->slot[0]->mmc->max_req_size;
 		}
 	}
-	if (pdata->slot[1].bus_width) {
-		ret = atmci_init_slot(host, &pdata->slot[1],
+	if (pdata[1].bus_width) {
+		ret = atmci_init_slot(host, &pdata[1],
 				1, ATMCI_SDCSEL_SLOT_B, ATMCI_SDIOIRQB);
 		if (!ret) {
 			nr_slots++;
@@ -2671,7 +2646,7 @@ static struct platform_driver atmci_driver = {
 	.driver		= {
 		.name		= "atmel_mci",
 		.probe_type	= PROBE_PREFER_ASYNCHRONOUS,
-		.of_match_table	= of_match_ptr(atmci_dt_ids),
+		.of_match_table	= atmci_dt_ids,
 		.pm		= &atmci_dev_pm_ops,
 	},
 };
diff --git a/include/linux/atmel-mci.h b/include/linux/atmel-mci.h
deleted file mode 100644
index 1491af38cc6e..000000000000
--- a/include/linux/atmel-mci.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __LINUX_ATMEL_MCI_H
-#define __LINUX_ATMEL_MCI_H
-
-#include <linux/types.h>
-#include <linux/dmaengine.h>
-
-#define ATMCI_MAX_NR_SLOTS	2
-
-/**
- * struct mci_slot_pdata - board-specific per-slot configuration
- * @bus_width: Number of data lines wired up the slot
- * @detect_pin: GPIO pin wired to the card detect switch
- * @wp_pin: GPIO pin wired to the write protect sensor
- * @detect_is_active_high: The state of the detect pin when it is active
- * @non_removable: The slot is not removable, only detect once
- *
- * If a given slot is not present on the board, @bus_width should be
- * set to 0. The other fields are ignored in this case.
- *
- * Any pins that aren't available should be set to a negative value.
- *
- * Note that support for multiple slots is experimental -- some cards
- * might get upset if we don't get the clock management exactly right.
- * But in most cases, it should work just fine.
- */
-struct mci_slot_pdata {
-	unsigned int		bus_width;
-	int			detect_pin;
-	int			wp_pin;
-	bool			detect_is_active_high;
-	bool			non_removable;
-};
-
-/**
- * struct mci_platform_data - board-specific MMC/SDcard configuration
- * @dma_slave: DMA slave interface to use in data transfers.
- * @slot: Per-slot configuration data.
- */
-struct mci_platform_data {
-	void			*dma_slave;
-	dma_filter_fn		dma_filter;
-	struct mci_slot_pdata	slot[ATMCI_MAX_NR_SLOTS];
-};
-
-#endif /* __LINUX_ATMEL_MCI_H */
-- 
2.39.0

