Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553A3697FF2
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 16:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjBOPxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 10:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjBOPxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 10:53:40 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D21E1AE;
        Wed, 15 Feb 2023 07:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676476419; x=1708012419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6kYLmkJS+SA3HwQaZJIQdOCzecN7RcboMQKxkKH6QG4=;
  b=QxVuZoPS1HDNFCh+QLTUdrGN6HwuTkLv12XamGZFqx/KGQtctPe5k2TP
   640F2p3UL7nzhv8dcfEQfyQsPnicT/id+b/C6XE/QeMgtUK9t1ybLTm4e
   knQbnJoD01EmbK+Q1cMYqRVew0lO/Pg2N/+EYE45RQAbKLr5op4F/WGCZ
   ZxR7tq4j4tk+A6YP33dfRCnL6kBkJnWjn2mXGIZfSpi5cgahiuQDaYMuj
   fnSFaja88CFA7IyXFQBuS7cvKzDC9AaXD01R3gN/ABZ3qFazBQMyP1phZ
   jb0qeLdJtGyVtv2GAtZMuSoY11VVWYFCN/Go5RdL26KzJHZtcnxf/EDW7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="393863391"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="393863391"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 07:53:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="619490483"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="619490483"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 15 Feb 2023 07:53:34 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 0B5A01C5; Wed, 15 Feb 2023 17:54:13 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Chas Williams <3chas3@gmail.com>
Subject: [PATCH v1 2/2] mmc: atmel-mci: Convert to agnostic GPIO API
Date:   Wed, 15 Feb 2023 17:54:10 +0200
Message-Id: <20230215155410.80944-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215155410.80944-1-andriy.shevchenko@linux.intel.com>
References: <20230215155410.80944-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The of_gpio.h is going to be removed. In preparation of that convert
the driver to the agnostic API.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/mmc/host/atmel-mci.c | 106 ++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 58 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index fad5e6b4c654..79876e3152e6 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -11,7 +11,7 @@
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/of_gpio.h>
 #include <linux/platform_device.h>
 #include <linux/scatterlist.h>
 #include <linux/seq_file.h>
@@ -44,8 +43,8 @@
 /**
  * struct mci_slot_pdata - board-specific per-slot configuration
  * @bus_width: Number of data lines wired up the slot
- * @detect_pin: GPIO pin wired to the card detect switch
- * @wp_pin: GPIO pin wired to the write protect sensor
+ * @wp_gpio: GPIO pin wired to the write protect sensor
+ * @detect_gpio: GPIO pin wired to the card detect switch
  * @detect_is_active_high: The state of the detect pin when it is active
  * @non_removable: The slot is not removable, only detect once
  *
@@ -60,8 +59,8 @@
  */
 struct mci_slot_pdata {
 	unsigned int		bus_width;
-	int			detect_pin;
-	int			wp_pin;
+	struct gpio_desc	*wp_gpio;
+	struct gpio_desc	*detect_gpio;
 	bool			detect_is_active_high;
 	bool			non_removable;
 };
@@ -399,12 +398,12 @@ struct atmel_mci {
  *	&struct atmel_mci.
  * @clock: Clock rate configured by set_ios(). Protected by host->lock.
  * @flags: Random state bits associated with the slot.
- * @detect_pin: GPIO pin used for card detection, or negative if not
- *	available.
- * @wp_pin: GPIO pin used for card write protect sending, or negative
+ * @wp_gpio: GPIO pin used for card write protect sending, or NULL
  *	if not available.
+ * @detect_gpio: GPIO pin used for card detection, or negative if not
+ *	available.
  * @detect_is_active_high: The state of the detect pin when it is active.
- * @detect_timer: Timer used for debouncing @detect_pin interrupts.
+ * @detect_timer: Timer used for debouncing @detect_gpio interrupts.
  */
 struct atmel_mci_slot {
 	struct mmc_host		*mmc;
@@ -422,8 +421,9 @@ struct atmel_mci_slot {
 #define ATMCI_CARD_NEED_INIT	1
 #define ATMCI_SHUTDOWN		2
 
-	int			detect_pin;
-	int			wp_pin;
+	struct gpio_desc	*wp_gpio;
+
+	struct gpio_desc	*detect_gpio;
 	bool			detect_is_active_high;
 
 	struct timer_list	detect_timer;
@@ -637,7 +637,8 @@ MODULE_DEVICE_TABLE(of, atmci_dt_ids);
 static struct mci_platform_data*
 atmci_of_init(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
 	struct device_node *cnp;
 	struct mci_platform_data *pdata;
 	u32 slot_id;
@@ -669,8 +670,10 @@ atmci_of_init(struct platform_device *pdev)
 		                         &pdata->slot[slot_id].bus_width))
 			pdata->slot[slot_id].bus_width = 1;
 
-		pdata->slot[slot_id].detect_pin =
-			of_get_named_gpio(cnp, "cd-gpios", 0);
+		pdata->slot[slot_id].detect_gpio = devm_gpiod_get_optional(dev, "cd", GPIOD_IN);
+		if (!pdata->slot[slot_id].detect_gpio)
+			dev_dbg(dev, "no detect pin available\n");
+		gpiod_set_consumer_name(pdata->slot[slot_id].detect_gpio, "mmc_detect");
 
 		pdata->slot[slot_id].detect_is_active_high =
 			of_property_read_bool(cnp, "cd-inverted");
@@ -678,8 +681,10 @@ atmci_of_init(struct platform_device *pdev)
 		pdata->slot[slot_id].non_removable =
 			of_property_read_bool(cnp, "non-removable");
 
-		pdata->slot[slot_id].wp_pin =
-			of_get_named_gpio(cnp, "wp-gpios", 0);
+		pdata->slot[slot_id].wp_gpio = devm_gpiod_get_optional(dev, "wp", GPIOD_IN);
+		if (!pdata->slot[slot_id].wp_gpio)
+			dev_dbg(dev, "no WP pin available\n");
+		gpiod_set_consumer_name(pdata->slot[slot_id].wp_gpio, "mmc_wp");
 	}
 
 	return pdata;
@@ -1535,8 +1540,8 @@ static int atmci_get_ro(struct mmc_host *mmc)
 	int			read_only = -ENOSYS;
 	struct atmel_mci_slot	*slot = mmc_priv(mmc);
 
-	if (gpio_is_valid(slot->wp_pin)) {
-		read_only = gpio_get_value(slot->wp_pin);
+	if (slot->wp_gpio) {
+		read_only = gpiod_get_value(slot->wp_gpio);
 		dev_dbg(&mmc->class_dev, "card is %s\n",
 				read_only ? "read-only" : "read-write");
 	}
@@ -1544,14 +1549,18 @@ static int atmci_get_ro(struct mmc_host *mmc)
 	return read_only;
 }
 
+static bool is_card_present(struct atmel_mci_slot *slot)
+{
+	return !(gpiod_get_raw_value(slot->detect_gpio) ^ slot->detect_is_active_high);
+}
+
 static int atmci_get_cd(struct mmc_host *mmc)
 {
 	int			present = -ENOSYS;
 	struct atmel_mci_slot	*slot = mmc_priv(mmc);
 
-	if (gpio_is_valid(slot->detect_pin)) {
-		present = !(gpio_get_value(slot->detect_pin) ^
-			    slot->detect_is_active_high);
+	if (slot->detect_gpio) {
+		present = is_card_present(slot);
 		dev_dbg(&mmc->class_dev, "card is %spresent\n",
 				present ? "" : "not ");
 	}
@@ -1663,9 +1672,8 @@ static void atmci_detect_change(struct timer_list *t)
 	if (test_bit(ATMCI_SHUTDOWN, &slot->flags))
 		return;
 
-	enable_irq(gpio_to_irq(slot->detect_pin));
-	present = !(gpio_get_value(slot->detect_pin) ^
-		    slot->detect_is_active_high);
+	enable_irq(gpiod_to_irq(slot->detect_gpio));
+	present = is_card_present(slot);
 	present_old = test_bit(ATMCI_CARD_PRESENT, &slot->flags);
 
 	dev_vdbg(&slot->mmc->class_dev, "detect change: %d (was %d)\n",
@@ -2254,18 +2262,18 @@ static int atmci_init_slot(struct atmel_mci *host,
 	slot = mmc_priv(mmc);
 	slot->mmc = mmc;
 	slot->host = host;
-	slot->detect_pin = slot_data->detect_pin;
-	slot->wp_pin = slot_data->wp_pin;
+	slot->wp_gpio = slot_data->wp_gpio;
+	slot->detect_gpio = slot_data->detect_gpio;
 	slot->detect_is_active_high = slot_data->detect_is_active_high;
 	slot->sdc_reg = sdc_reg;
 	slot->sdio_irq = sdio_irq;
 
 	dev_dbg(&mmc->class_dev,
-	        "slot[%u]: bus_width=%u, detect_pin=%d, "
-		"detect_is_active_high=%s, wp_pin=%d\n",
-		id, slot_data->bus_width, slot_data->detect_pin,
+	        "slot[%u]: bus_width=%u, detect_gpio=%d, "
+		"detect_is_active_high=%s, wp_gpio=%d\n",
+		id, slot_data->bus_width, desc_to_gpio(slot_data->detect_gpio),
 		slot_data->detect_is_active_high ? "true" : "false",
-		slot_data->wp_pin);
+		desc_to_gpio(slot_data->wp_gpio));
 
 	mmc->ops = &atmci_ops;
 	mmc->f_min = DIV_ROUND_UP(host->bus_hz, 512);
@@ -2301,32 +2309,16 @@ static int atmci_init_slot(struct atmel_mci *host,
 
 	/* Assume card is present initially */
 	set_bit(ATMCI_CARD_PRESENT, &slot->flags);
-	if (gpio_is_valid(slot->detect_pin)) {
-		if (devm_gpio_request(&host->pdev->dev, slot->detect_pin,
-				      "mmc_detect")) {
-			dev_dbg(&mmc->class_dev, "no detect pin available\n");
-			slot->detect_pin = -EBUSY;
-		} else if (gpio_get_value(slot->detect_pin) ^
-				slot->detect_is_active_high) {
+	if (slot->detect_gpio) {
+		if (!is_card_present(slot))
 			clear_bit(ATMCI_CARD_PRESENT, &slot->flags);
-		}
-	}
-
-	if (!gpio_is_valid(slot->detect_pin)) {
+	} else {
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
-	}
-
 	host->slot[id] = slot;
 	mmc_regulator_get_supply(mmc);
 	ret = mmc_add_host(mmc);
@@ -2335,18 +2327,18 @@ static int atmci_init_slot(struct atmel_mci *host,
 		return ret;
 	}
 
-	if (gpio_is_valid(slot->detect_pin)) {
+	if (slot->detect_gpio) {
 		timer_setup(&slot->detect_timer, atmci_detect_change, 0);
 
-		ret = request_irq(gpio_to_irq(slot->detect_pin),
+		ret = request_irq(gpiod_to_irq(slot->detect_gpio),
 				atmci_detect_interrupt,
 				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
 				"mmc-detect", slot);
 		if (ret) {
 			dev_dbg(&mmc->class_dev,
 				"could not request IRQ %d for detect pin\n",
-				gpio_to_irq(slot->detect_pin));
-			slot->detect_pin = -EBUSY;
+				gpiod_to_irq(slot->detect_gpio));
+			slot->detect_gpio = NULL;
 		}
 	}
 
@@ -2365,10 +2357,8 @@ static void atmci_cleanup_slot(struct atmel_mci_slot *slot,
 
 	mmc_remove_host(slot->mmc);
 
-	if (gpio_is_valid(slot->detect_pin)) {
-		int pin = slot->detect_pin;
-
-		free_irq(gpio_to_irq(pin), slot);
+	if (slot->detect_gpio) {
+		free_irq(gpiod_to_irq(slot->detect_gpio), slot);
 		del_timer_sync(&slot->detect_timer);
 	}
 
-- 
2.39.1

