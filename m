Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6801675805
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfGYTfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:35:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:45002 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbfGYTfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 15:35:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 12:35:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,307,1559545200"; 
   d="scan'208";a="345561439"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 25 Jul 2019 12:35:12 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id F14711A3; Thu, 25 Jul 2019 22:35:11 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sedat Dilek <sedat.dilek@credativ.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH v3 05/14] NFC: nxp-nci: Add GPIO ACPI mapping table
Date:   Thu, 25 Jul 2019 22:35:02 +0300
Message-Id: <20190725193511.64274-5-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190725193511.64274-1-andriy.shevchenko@linux.intel.com>
References: <20190725193511.64274-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to unify GPIO resource request prepare gpiod_get_index()
to behave correctly when there is no mapping provided by firmware.

Here we add explicit mapping between _CRS GpioIo() resources and
their names used in the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/nfc/nxp-nci/i2c.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 713c267acf88..7344405feddf 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -247,6 +247,15 @@ static irqreturn_t nxp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 	return IRQ_NONE;
 }
 
+static const struct acpi_gpio_params firmware_gpios = { 1, 0, false };
+static const struct acpi_gpio_params enable_gpios = { 2, 0, false };
+
+static const struct acpi_gpio_mapping acpi_nxp_nci_gpios[] = {
+	{ "enable-gpios", &enable_gpios, 1 },
+	{ "firmware-gpios", &firmware_gpios, 1 },
+	{ }
+};
+
 static int nxp_nci_i2c_parse_devtree(struct i2c_client *client)
 {
 	struct nxp_nci_i2c_phy *phy = i2c_get_clientdata(client);
@@ -269,9 +278,14 @@ static int nxp_nci_i2c_parse_devtree(struct i2c_client *client)
 static int nxp_nci_i2c_acpi_config(struct nxp_nci_i2c_phy *phy)
 {
 	struct i2c_client *client = phy->i2c_dev;
+	int r;
 
-	phy->gpiod_en = devm_gpiod_get_index(&client->dev, NULL, 2, GPIOD_OUT_LOW);
-	phy->gpiod_fw = devm_gpiod_get_index(&client->dev, NULL, 1, GPIOD_OUT_LOW);
+	r = devm_acpi_dev_add_driver_gpios(&client->dev, acpi_nxp_nci_gpios);
+	if (r)
+		return r;
+
+	phy->gpiod_en = devm_gpiod_get(&client->dev, "enable", GPIOD_OUT_LOW);
+	phy->gpiod_fw = devm_gpiod_get(&client->dev, "firmware", GPIOD_OUT_LOW);
 
 	if (IS_ERR(phy->gpiod_en) || IS_ERR(phy->gpiod_fw)) {
 		nfc_err(&client->dev, "No GPIOs\n");
-- 
2.20.1

