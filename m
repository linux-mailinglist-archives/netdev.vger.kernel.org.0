Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B98BF78CEC
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 15:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387588AbfG2NfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 09:35:18 -0400
Received: from mga17.intel.com ([192.55.52.151]:12635 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728171AbfG2NfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 09:35:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 06:35:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,322,1559545200"; 
   d="scan'208";a="195388121"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2019 06:35:15 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id E922A5A8; Mon, 29 Jul 2019 16:35:14 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sedat Dilek <sedat.dilek@credativ.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH v4 04/14] NFC: nxp-nci: Convert to use GPIO descriptor
Date:   Mon, 29 Jul 2019 16:35:04 +0300
Message-Id: <20190729133514.13164-5-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
References: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we got rid of platform data, the driver may use
GPIO descriptor directly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/nfc/nxp-nci/core.c |  1 -
 drivers/nfc/nxp-nci/i2c.c  | 60 ++++++++++----------------------------
 2 files changed, 15 insertions(+), 46 deletions(-)

diff --git a/drivers/nfc/nxp-nci/core.c b/drivers/nfc/nxp-nci/core.c
index aed18ca60170..a0ce95a287c5 100644
--- a/drivers/nfc/nxp-nci/core.c
+++ b/drivers/nfc/nxp-nci/core.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/delay.h>
-#include <linux/gpio.h>
 #include <linux/module.h>
 #include <linux/nfc.h>
 
diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 47b3b7e612e6..713c267acf88 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -21,8 +21,6 @@
 #include <linux/module.h>
 #include <linux/nfc.h>
 #include <linux/gpio/consumer.h>
-#include <linux/of_gpio.h>
-#include <linux/of_irq.h>
 #include <asm/unaligned.h>
 
 #include <net/nfc/nfc.h>
@@ -37,8 +35,8 @@ struct nxp_nci_i2c_phy {
 	struct i2c_client *i2c_dev;
 	struct nci_dev *ndev;
 
-	unsigned int gpio_en;
-	unsigned int gpio_fw;
+	struct gpio_desc *gpiod_en;
+	struct gpio_desc *gpiod_fw;
 
 	int hard_fault; /*
 			 * < 0 if hardware error occurred (e.g. i2c err)
@@ -51,8 +49,8 @@ static int nxp_nci_i2c_set_mode(void *phy_id,
 {
 	struct nxp_nci_i2c_phy *phy = (struct nxp_nci_i2c_phy *) phy_id;
 
-	gpio_set_value(phy->gpio_fw, (mode == NXP_NCI_MODE_FW) ? 1 : 0);
-	gpio_set_value(phy->gpio_en, (mode != NXP_NCI_MODE_COLD) ? 1 : 0);
+	gpiod_set_value(phy->gpiod_fw, (mode == NXP_NCI_MODE_FW) ? 1 : 0);
+	gpiod_set_value(phy->gpiod_en, (mode != NXP_NCI_MODE_COLD) ? 1 : 0);
 	usleep_range(10000, 15000);
 
 	if (mode == NXP_NCI_MODE_COLD)
@@ -252,30 +250,18 @@ static irqreturn_t nxp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 static int nxp_nci_i2c_parse_devtree(struct i2c_client *client)
 {
 	struct nxp_nci_i2c_phy *phy = i2c_get_clientdata(client);
-	struct device_node *pp;
-	int r;
-
-	pp = client->dev.of_node;
-	if (!pp)
-		return -ENODEV;
 
-	r = of_get_named_gpio(pp, "enable-gpios", 0);
-	if (r == -EPROBE_DEFER)
-		r = of_get_named_gpio(pp, "enable-gpios", 0);
-	if (r < 0) {
-		nfc_err(&client->dev, "Failed to get EN gpio, error: %d\n", r);
-		return r;
+	phy->gpiod_en = devm_gpiod_get(&client->dev, "enable", GPIOD_OUT_LOW);
+	if (IS_ERR(phy->gpiod_en)) {
+		nfc_err(&client->dev, "Failed to get EN gpio\n");
+		return PTR_ERR(phy->gpiod_en);
 	}
-	phy->gpio_en = r;
 
-	r = of_get_named_gpio(pp, "firmware-gpios", 0);
-	if (r == -EPROBE_DEFER)
-		r = of_get_named_gpio(pp, "firmware-gpios", 0);
-	if (r < 0) {
-		nfc_err(&client->dev, "Failed to get FW gpio, error: %d\n", r);
-		return r;
+	phy->gpiod_fw = devm_gpiod_get(&client->dev, "firmware", GPIOD_OUT_LOW);
+	if (IS_ERR(phy->gpiod_fw)) {
+		nfc_err(&client->dev, "Failed to get FW gpio\n");
+		return PTR_ERR(phy->gpiod_fw);
 	}
-	phy->gpio_fw = r;
 
 	return 0;
 }
@@ -283,19 +269,15 @@ static int nxp_nci_i2c_parse_devtree(struct i2c_client *client)
 static int nxp_nci_i2c_acpi_config(struct nxp_nci_i2c_phy *phy)
 {
 	struct i2c_client *client = phy->i2c_dev;
-	struct gpio_desc *gpiod_en, *gpiod_fw;
 
-	gpiod_en = devm_gpiod_get_index(&client->dev, NULL, 2, GPIOD_OUT_LOW);
-	gpiod_fw = devm_gpiod_get_index(&client->dev, NULL, 1, GPIOD_OUT_LOW);
+	phy->gpiod_en = devm_gpiod_get_index(&client->dev, NULL, 2, GPIOD_OUT_LOW);
+	phy->gpiod_fw = devm_gpiod_get_index(&client->dev, NULL, 1, GPIOD_OUT_LOW);
 
-	if (IS_ERR(gpiod_en) || IS_ERR(gpiod_fw)) {
+	if (IS_ERR(phy->gpiod_en) || IS_ERR(phy->gpiod_fw)) {
 		nfc_err(&client->dev, "No GPIOs\n");
 		return -EINVAL;
 	}
 
-	phy->gpio_en = desc_to_gpio(gpiod_en);
-	phy->gpio_fw = desc_to_gpio(gpiod_fw);
-
 	return 0;
 }
 
@@ -331,24 +313,12 @@ static int nxp_nci_i2c_probe(struct i2c_client *client,
 		r = nxp_nci_i2c_acpi_config(phy);
 		if (r < 0)
 			goto probe_exit;
-		goto nci_probe;
 	} else {
 		nfc_err(&client->dev, "No platform data\n");
 		r = -EINVAL;
 		goto probe_exit;
 	}
 
-	r = devm_gpio_request_one(&phy->i2c_dev->dev, phy->gpio_en,
-				  GPIOF_OUT_INIT_LOW, "nxp_nci_en");
-	if (r < 0)
-		goto probe_exit;
-
-	r = devm_gpio_request_one(&phy->i2c_dev->dev, phy->gpio_fw,
-				  GPIOF_OUT_INIT_LOW, "nxp_nci_fw");
-	if (r < 0)
-		goto probe_exit;
-
-nci_probe:
 	r = nxp_nci_probe(phy, &client->dev, &i2c_phy_ops,
 			  NXP_NCI_I2C_MAX_PAYLOAD, &phy->ndev);
 	if (r < 0)
-- 
2.20.1

