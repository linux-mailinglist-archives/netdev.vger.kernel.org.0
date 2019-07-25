Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2B9757FB
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfGYTfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:35:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:17415 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbfGYTfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 15:35:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 12:35:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,307,1559545200"; 
   d="scan'208";a="254045936"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 25 Jul 2019 12:35:15 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 069AE4EB; Thu, 25 Jul 2019 22:35:12 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sedat Dilek <sedat.dilek@credativ.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH v3 06/14] NFC: nxp-nci: Get rid of code duplication in ->probe()
Date:   Thu, 25 Jul 2019 22:35:03 +0300
Message-Id: <20190725193511.64274-6-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190725193511.64274-1-andriy.shevchenko@linux.intel.com>
References: <20190725193511.64274-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since OF and ACPI case almost the same get rid of code duplication
by moving gpiod_get() calls directly to ->probe().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/nfc/nxp-nci/i2c.c | 68 +++++++++------------------------------
 1 file changed, 15 insertions(+), 53 deletions(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 7344405feddf..6a627d1b6f85 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -256,48 +256,10 @@ static const struct acpi_gpio_mapping acpi_nxp_nci_gpios[] = {
 	{ }
 };
 
-static int nxp_nci_i2c_parse_devtree(struct i2c_client *client)
-{
-	struct nxp_nci_i2c_phy *phy = i2c_get_clientdata(client);
-
-	phy->gpiod_en = devm_gpiod_get(&client->dev, "enable", GPIOD_OUT_LOW);
-	if (IS_ERR(phy->gpiod_en)) {
-		nfc_err(&client->dev, "Failed to get EN gpio\n");
-		return PTR_ERR(phy->gpiod_en);
-	}
-
-	phy->gpiod_fw = devm_gpiod_get(&client->dev, "firmware", GPIOD_OUT_LOW);
-	if (IS_ERR(phy->gpiod_fw)) {
-		nfc_err(&client->dev, "Failed to get FW gpio\n");
-		return PTR_ERR(phy->gpiod_fw);
-	}
-
-	return 0;
-}
-
-static int nxp_nci_i2c_acpi_config(struct nxp_nci_i2c_phy *phy)
-{
-	struct i2c_client *client = phy->i2c_dev;
-	int r;
-
-	r = devm_acpi_dev_add_driver_gpios(&client->dev, acpi_nxp_nci_gpios);
-	if (r)
-		return r;
-
-	phy->gpiod_en = devm_gpiod_get(&client->dev, "enable", GPIOD_OUT_LOW);
-	phy->gpiod_fw = devm_gpiod_get(&client->dev, "firmware", GPIOD_OUT_LOW);
-
-	if (IS_ERR(phy->gpiod_en) || IS_ERR(phy->gpiod_fw)) {
-		nfc_err(&client->dev, "No GPIOs\n");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int nxp_nci_i2c_probe(struct i2c_client *client,
 			    const struct i2c_device_id *id)
 {
+	struct device *dev = &client->dev;
 	struct nxp_nci_i2c_phy *phy;
 	int r;
 
@@ -317,20 +279,20 @@ static int nxp_nci_i2c_probe(struct i2c_client *client,
 	phy->i2c_dev = client;
 	i2c_set_clientdata(client, phy);
 
-	if (client->dev.of_node) {
-		r = nxp_nci_i2c_parse_devtree(client);
-		if (r < 0) {
-			nfc_err(&client->dev, "Failed to get DT data\n");
-			goto probe_exit;
-		}
-	} else if (ACPI_HANDLE(&client->dev)) {
-		r = nxp_nci_i2c_acpi_config(phy);
-		if (r < 0)
-			goto probe_exit;
-	} else {
-		nfc_err(&client->dev, "No platform data\n");
-		r = -EINVAL;
-		goto probe_exit;
+	r = devm_acpi_dev_add_driver_gpios(dev, acpi_nxp_nci_gpios);
+	if (r)
+		return r;
+
+	phy->gpiod_en = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
+	if (IS_ERR(phy->gpiod_en)) {
+		nfc_err(dev, "Failed to get EN gpio\n");
+		return PTR_ERR(phy->gpiod_en);
+	}
+
+	phy->gpiod_fw = devm_gpiod_get(dev, "firmware", GPIOD_OUT_LOW);
+	if (IS_ERR(phy->gpiod_fw)) {
+		nfc_err(dev, "Failed to get FW gpio\n");
+		return PTR_ERR(phy->gpiod_fw);
 	}
 
 	r = nxp_nci_probe(phy, &client->dev, &i2c_phy_ops,
-- 
2.20.1

