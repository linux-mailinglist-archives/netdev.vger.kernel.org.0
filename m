Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE7641171CA
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfLIQdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:33:20 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56519 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfLIQdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 11:33:07 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ieLy5-0001up-Al; Mon, 09 Dec 2019 17:33:05 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dan Murphy <dmurphy@ti.com>,
        Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 12/13] can: tcan45x: Make wake-up GPIO an optional GPIO
Date:   Mon,  9 Dec 2019 17:32:55 +0100
Message-Id: <20191209163256.12000-13-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191209163256.12000-1-mkl@pengutronix.de>
References: <20191209163256.12000-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

The device has the ability to disable the wake-up pin option. The
wake-up pin can be either force to GND or Vsup and does not have to be
tied to a GPIO. In order for the device to not use the wake-up feature
write the register to disable the WAKE_CONFIG option.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
Cc: Sean Nyekjaer <sean@geanix.com>
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index d5d4bfa9c8fd..4e1789ea2bc3 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -101,6 +101,8 @@
 #define TCAN4X5X_MODE_STANDBY BIT(6)
 #define TCAN4X5X_MODE_NORMAL BIT(7)
 
+#define TCAN4X5X_DISABLE_WAKE_MSK	(BIT(31) | BIT(30))
+
 #define TCAN4X5X_SW_RESET BIT(2)
 
 #define TCAN4X5X_MCAN_CONFIGURED BIT(5)
@@ -338,6 +340,14 @@ static int tcan4x5x_init(struct m_can_classdev *cdev)
 	return ret;
 }
 
+static int tcan4x5x_disable_wake(struct m_can_classdev *cdev)
+{
+	struct tcan4x5x_priv *tcan4x5x = cdev->device_data;
+
+	return regmap_update_bits(tcan4x5x->regmap, TCAN4X5X_CONFIG,
+				  TCAN4X5X_DISABLE_WAKE_MSK, 0x00);
+}
+
 static int tcan4x5x_parse_config(struct m_can_classdev *cdev)
 {
 	struct tcan4x5x_priv *tcan4x5x = cdev->device_data;
@@ -345,8 +355,10 @@ static int tcan4x5x_parse_config(struct m_can_classdev *cdev)
 	tcan4x5x->device_wake_gpio = devm_gpiod_get(cdev->dev, "device-wake",
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(tcan4x5x->device_wake_gpio)) {
-		dev_err(cdev->dev, "device-wake gpio not defined\n");
-		return -EINVAL;
+		if (PTR_ERR(tcan4x5x->power) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
+		tcan4x5x_disable_wake(cdev);
 	}
 
 	tcan4x5x->reset_gpio = devm_gpiod_get_optional(cdev->dev, "reset",
@@ -430,10 +442,6 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 
 	spi_set_drvdata(spi, priv);
 
-	ret = tcan4x5x_parse_config(mcan_class);
-	if (ret)
-		goto out_clk;
-
 	/* Configure the SPI bus */
 	spi->bits_per_word = 32;
 	ret = spi_setup(spi);
@@ -443,6 +451,10 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	priv->regmap = devm_regmap_init(&spi->dev, &tcan4x5x_bus,
 					&spi->dev, &tcan4x5x_regmap);
 
+	ret = tcan4x5x_parse_config(mcan_class);
+	if (ret)
+		goto out_clk;
+
 	tcan4x5x_power_enable(priv->power, 1);
 
 	ret = m_can_class_register(mcan_class);
-- 
2.24.0

