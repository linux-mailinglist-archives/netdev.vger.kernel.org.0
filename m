Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE2E46A1FD
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240371AbhLFRH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:07:57 -0500
Received: from mga12.intel.com ([192.55.52.136]:21821 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347489AbhLFQ7K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 11:59:10 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="217381116"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="217381116"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 08:55:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="479182504"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 06 Dec 2021 08:55:37 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 2D79B199; Mon,  6 Dec 2021 18:55:43 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 3/4] can: hi311x: Make use of device property API
Date:   Mon,  6 Dec 2021 18:55:41 +0200
Message-Id: <20211206165542.69887-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206165542.69887-1-andriy.shevchenko@linux.intel.com>
References: <20211206165542.69887-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of device property API in this driver so that both OF based
system and ACPI based system can use this driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v2: no changes
 drivers/net/can/spi/hi311x.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index c9efdd10d0f8..78044ec24575 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -25,11 +25,11 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
@@ -828,11 +828,10 @@ MODULE_DEVICE_TABLE(spi, hi3110_id_table);
 
 static int hi3110_can_probe(struct spi_device *spi)
 {
-	const struct of_device_id *of_id = of_match_device(hi3110_of_match,
-							   &spi->dev);
 	struct device *dev = &spi->dev;
 	struct net_device *net;
 	struct hi3110_priv *priv;
+	const void *match;
 	struct clk *clk;
 	u32 freq;
 	int ret;
@@ -877,8 +876,9 @@ static int hi3110_can_probe(struct spi_device *spi)
 		CAN_CTRLMODE_LISTENONLY |
 		CAN_CTRLMODE_BERR_REPORTING;
 
-	if (of_id)
-		priv->model = (enum hi3110_model)(uintptr_t)of_id->data;
+	match = device_get_match_data(dev);
+	if (match)
+		priv->model = (enum hi3110_model)(uintptr_t)match;
 	else
 		priv->model = spi_get_device_id(spi)->driver_data;
 	priv->net = net;
-- 
2.33.0

