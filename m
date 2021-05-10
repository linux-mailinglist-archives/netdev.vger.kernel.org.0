Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C2D379441
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 18:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhEJQkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 12:40:42 -0400
Received: from mga18.intel.com ([134.134.136.126]:18757 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231800AbhEJQkb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 12:40:31 -0400
IronPort-SDR: sVj4DCt/I+hLjZXKlNFXYvVhyeJak/GxWz7uP3vti8EUfbu2XUyATGjNF34k66Lr1kxXHHGWp8
 7CRbyI4EQWHA==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="186680849"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="186680849"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 09:39:25 -0700
IronPort-SDR: K1tfurU8ZzFqPNRpNwCiiewNm0tWo7jmhKlVcMqmMIUF9Ph4kwLOvI2MlezBpf+ypp5/Ezkrlj
 QeJnNWZVFzWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="454537272"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 10 May 2021 09:39:23 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 0A12C142; Mon, 10 May 2021 19:39:43 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Flavio Suligoi <f.suligoi@asem.it>,
        Lee Jones <lee.jones@linaro.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 2/5] net: pch_gbe: Convert to use GPIO descriptors
Date:   Mon, 10 May 2021 19:39:28 +0300
Message-Id: <20210510163931.42417-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510163931.42417-1-andriy.shevchenko@linux.intel.com>
References: <20210510163931.42417-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This switches the PCH GBE driver to use GPIO descriptors.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Flavio Suligoi <f.suligoi@asem.it>
---
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  | 44 ++++++++++++++-----
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 3dc29b282a88..8adc8cfaca03 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -8,6 +8,9 @@
 
 #include "pch_gbe.h"
 #include "pch_gbe_phy.h"
+
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/machine.h>
 #include <linux/module.h>
 #include <linux/net_tstamp.h>
 #include <linux/ptp_classify.h>
@@ -97,8 +100,6 @@ const char pch_driver_version[] = DRV_VERSION;
 #define PTP_L4_MULTICAST_SA "01:00:5e:00:01:81"
 #define PTP_L2_MULTICAST_SA "01:1b:19:00:00:00"
 
-#define MINNOW_PHY_RESET_GPIO		13
-
 static int pch_gbe_mdio_read(struct net_device *netdev, int addr, int reg);
 static void pch_gbe_mdio_write(struct net_device *netdev, int addr, int reg,
 			       int data);
@@ -2628,26 +2629,45 @@ static int pch_gbe_probe(struct pci_dev *pdev,
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

