Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF93349821
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhCYRe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:34:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:57950 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229833AbhCYReM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 13:34:12 -0400
IronPort-SDR: 0NfWjobdLhrr+RIi4AGeyCvbM4D9d2+AYy1lzN2oMrSOnK1hSZbH0YuG8gQsciE5iGOnioDDXw
 dICIGQ75EPiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="178105029"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="178105029"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 10:34:11 -0700
IronPort-SDR: 7Zd2a+oFoobxAZ1ERNGxXAkefhE6ioBGjzghsjpGJyJ+zjmGJb3hqEMQZaPODYDhZbJqupfh8E
 TqH/RJTsKg1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="391828626"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 25 Mar 2021 10:34:09 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 48C7C368; Thu, 25 Mar 2021 19:34:23 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Flavio Suligoi <f.suligoi@asem.it>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 2/5] net: pch_gbe: Convert to use GPIO descriptors
Date:   Thu, 25 Mar 2021 19:34:09 +0200
Message-Id: <20210325173412.82911-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
References: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This switches the PCH GBE driver to use GPIO descriptors.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  | 45 +++++++++++++------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 1b32a43f7024..1038947cbac8 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -8,10 +8,12 @@
 
 #include "pch_gbe.h"
 #include "pch_gbe_phy.h"
+
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/machine.h>
 #include <linux/module.h>
 #include <linux/net_tstamp.h>
 #include <linux/ptp_classify.h>
-#include <linux/gpio.h>
 
 #define DRV_VERSION     "1.01"
 const char pch_driver_version[] = DRV_VERSION;
@@ -96,8 +98,6 @@ const char pch_driver_version[] = DRV_VERSION;
 #define PTP_L4_MULTICAST_SA "01:00:5e:00:01:81"
 #define PTP_L2_MULTICAST_SA "01:1b:19:00:00:00"
 
-#define MINNOW_PHY_RESET_GPIO		13
-
 static int pch_gbe_mdio_read(struct net_device *netdev, int addr, int reg);
 static void pch_gbe_mdio_write(struct net_device *netdev, int addr, int reg,
 			       int data);
@@ -2627,26 +2627,45 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 	return ret;
 }
 
+static void pch_gbe_gpio_remove_table(void *table)
+{
+	gpiod_remove_lookup_table(table);
+}
+
+static int pch_gbe_gpio_add_table(struct device *dev, void *table)
+{
+	gpiod_add_lookup_table(table);
+	return devm_add_action_or_reset(dev, pch_gbe_gpio_remove_table, table);
+}
+
+static struct gpiod_lookup_table pch_gbe_minnow_gpio_table = {
+	.dev_id		= "0000:02:00.1",
+	.table		= {
+		GPIO_LOOKUP("sch_gpio.33158", 13, NULL, GPIO_ACTIVE_LOW),
+		{}
+	},
+};
+
 /* The AR803X PHY on the MinnowBoard requires a physical pin to be toggled to
  * ensure it is awake for probe and init. Request the line and reset the PHY.
  */
 static int pch_gbe_minnow_platform_init(struct pci_dev *pdev)
 {
-	unsigned long flags = GPIOF_OUT_INIT_HIGH;
-	unsigned gpio = MINNOW_PHY_RESET_GPIO;
+	struct gpio_desc *gpiod;
 	int ret;
 
-	ret = devm_gpio_request_one(&pdev->dev, gpio, flags,
-				    "minnow_phy_reset");
-	if (ret) {
-		dev_err(&pdev->dev,
-			"ERR: Can't request PHY reset GPIO line '%d'\n", gpio);
+	ret = pch_gbe_gpio_add_table(&pdev->dev, &pch_gbe_minnow_gpio_table);
+	if (ret)
 		return ret;
-	}
 
-	gpio_set_value(gpio, 0);
+	gpiod = devm_gpiod_get(&pdev->dev, NULL, GPIOD_OUT_HIGH);
+	if (IS_ERR(gpiod))
+		return dev_err_probe(&pdev->dev, PTR_ERR(gpiod),
+				     "Can't request PHY reset GPIO line\n");
+
+	gpiod_set_value(gpiod, 1);
 	usleep_range(1250, 1500);
-	gpio_set_value(gpio, 1);
+	gpiod_set_value(gpiod, 0);
 	usleep_range(1250, 1500);
 
 	return ret;
-- 
2.30.2

