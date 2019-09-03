Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C00CA68C0
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 14:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbfICMnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 08:43:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:20705 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729056AbfICMnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 08:43:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 05:43:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="207072267"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 03 Sep 2019 05:43:00 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id C28D8F8; Tue,  3 Sep 2019 15:42:59 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 2/4] can: mcp251x: Make use of device property API
Date:   Tue,  3 Sep 2019 15:42:57 +0300
Message-Id: <20190903124259.60920-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190903124259.60920-1-andriy.shevchenko@linux.intel.com>
References: <20190903124259.60920-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of device property API in this driver so that both OF based
system and ACPI based system can use this driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/can/spi/mcp251x.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index e04b578f2b1f..0b7e743ca0a0 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -53,8 +53,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
+#include <linux/property.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
@@ -914,7 +913,7 @@ static int mcp251x_open(struct net_device *net)
 	priv->tx_skb = NULL;
 	priv->tx_len = 0;
 
-	if (!spi->dev.of_node)
+	if (!dev_fwnode(&spi->dev))
 		flags = IRQF_TRIGGER_FALLING;
 
 	ret = request_threaded_irq(spi->irq, NULL, mcp251x_can_ist,
@@ -1006,8 +1005,7 @@ MODULE_DEVICE_TABLE(spi, mcp251x_id_table);
 
 static int mcp251x_can_probe(struct spi_device *spi)
 {
-	const struct of_device_id *of_id = of_match_device(mcp251x_of_match,
-							   &spi->dev);
+	const void *match = device_get_match_data(&spi->dev);
 	struct mcp251x_platform_data *pdata = dev_get_platdata(&spi->dev);
 	struct net_device *net;
 	struct mcp251x_priv *priv;
@@ -1044,8 +1042,8 @@ static int mcp251x_can_probe(struct spi_device *spi)
 	priv->can.clock.freq = freq / 2;
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_3_SAMPLES |
 		CAN_CTRLMODE_LOOPBACK | CAN_CTRLMODE_LISTENONLY;
-	if (of_id)
-		priv->model = (enum mcp251x_model)of_id->data;
+	if (match)
+		priv->model = (enum mcp251x_model)match;
 	else
 		priv->model = spi_get_device_id(spi)->driver_data;
 	priv->net = net;
-- 
2.23.0.rc1

