Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16F3697FEF
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 16:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjBOPxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 10:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjBOPxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 10:53:38 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EE7A8;
        Wed, 15 Feb 2023 07:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676476417; x=1708012417;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yIKGd7FoFaGRp6BU29AqU43/ancNCuEFGnNrQFiVP/E=;
  b=iGkvYF1OTYmcG0QccAzYfwujE2143wmtURkEuDCkN0xGdyob2VjCQ3Gi
   NI0NOCka/L6XbqOifkvDhuWw3ZF7rHnJIDHMVhwcDdshMEqBQ5vnImlqk
   scPJqlJkVfqnV7Of32tshiUZkUOgrqcdBD+4gk2SovnHxMOs84f3h/7QF
   keVEcF24ECORw4EaElosWzU7jCT726Bi4gnGJlrN34BLn2l0Hl3nDw4SY
   VGu4HDW8LxomQU5uoyRjtoA6L3o+XbSxQDpKDAvXG6TWnv3LyOcbAsyB3
   slDQyD9i07oC3gnYEscbVoRImA1wuWEaOvnqcGZ9bZ+h999fVqdgo9iZB
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="393863381"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="393863381"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 07:53:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="619490478"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="619490478"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 15 Feb 2023 07:53:33 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 6392D1A6; Wed, 15 Feb 2023 17:54:13 +0200 (EET)
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
Subject: [PATCH v1 1/2] mmc: atmel-mci: Get rid of external platform data
Date:   Wed, 15 Feb 2023 17:54:09 +0200
Message-Id: <20230215155410.80944-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.1
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

There is no in-kernel user that uses platform data.
Hide it. This will allow the further cleanups to
the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/mmc/host/atmel-mci.c | 75 ++++++++++++++++++++----------------
 include/linux/atmel-mci.h    | 46 ----------------------
 2 files changed, 41 insertions(+), 80 deletions(-)
 delete mode 100644 include/linux/atmel-mci.h

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index b51001c68786..fad5e6b4c654 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -30,7 +30,6 @@
 #include <linux/mmc/host.h>
 #include <linux/mmc/sdio.h>
 
-#include <linux/atmel-mci.h>
 #include <linux/atmel_pdc.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
@@ -40,6 +39,41 @@
 #include <asm/io.h>
 #include <asm/unaligned.h>
 
+#define ATMCI_MAX_NR_SLOTS	2
+
+/**
+ * struct mci_slot_pdata - board-specific per-slot configuration
+ * @bus_width: Number of data lines wired up the slot
+ * @detect_pin: GPIO pin wired to the card detect switch
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
+	int			detect_pin;
+	int			wp_pin;
+	bool			detect_is_active_high;
+	bool			non_removable;
+};
+
+/**
+ * struct mci_platform_data - board-specific MMC/SDcard configuration
+ * @slot: Per-slot configuration data.
+ */
+struct mci_platform_data {
+	struct mci_slot_pdata	slot[ATMCI_MAX_NR_SLOTS];
+};
+
 /*
  * Superset of MCI IP registers integrated in Atmel AT91 Processor
  * Registers and bitfields marked with [2] are only available in MCI2
@@ -593,7 +627,6 @@ static void atmci_init_debugfs(struct atmel_mci_slot *slot)
 			   &host->completed_events);
 }
 
-#if defined(CONFIG_OF)
 static const struct of_device_id atmci_dt_ids[] = {
 	{ .compatible = "atmel,hsmci" },
 	{ /* sentinel */ }
@@ -651,13 +684,6 @@ atmci_of_init(struct platform_device *pdev)
 
 	return pdata;
 }
-#else /* CONFIG_OF */
-static inline struct mci_platform_data*
-atmci_of_init(struct platform_device *dev)
-{
-	return ERR_PTR(-EINVAL);
-}
-#endif
 
 static inline unsigned int atmci_get_version(struct atmel_mci *host)
 {
@@ -2353,23 +2379,6 @@ static void atmci_cleanup_slot(struct atmel_mci_slot *slot,
 static int atmci_configure_dma(struct atmel_mci *host)
 {
 	host->dma.chan = dma_request_chan(&host->pdev->dev, "rxtx");
-
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
 
@@ -2457,13 +2466,11 @@ static int atmci_probe(struct platform_device *pdev)
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
+	pdata = atmci_of_init(pdev);
+	if (IS_ERR(pdata)) {
+		dev_err(&pdev->dev, "platform data not available\n");
+		return PTR_ERR(pdata);
 	}
 
 	irq = platform_get_irq(pdev, 0);
@@ -2668,7 +2675,7 @@ static struct platform_driver atmci_driver = {
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
2.39.1

