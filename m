Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6DFF12E872
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 17:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgABQJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 11:09:41 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50729 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728774AbgABQJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 11:09:38 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1in32X-0000mM-GX; Thu, 02 Jan 2020 17:09:37 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 2/9] can: tcan4x5x: tcan4x5x_can_probe(): turn on the power before parsing the config
Date:   Thu,  2 Jan 2020 17:09:27 +0100
Message-Id: <20200102160934.1524-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102160934.1524-1-mkl@pengutronix.de>
References: <20200102160934.1524-1-mkl@pengutronix.de>
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

The tcan4x5x_parse_config() function now performs action on the device
either reading or writing and a reset. If the devive has a switchable
power supppy (i.e. regulator is managed) it needs to be turned on.

So turn on the regulator if available. If the parsing fails, turn off
the regulator.

Fixes: 2de497356955 ("can: tcan45x: Make wake-up GPIO an optional GPIO")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index c9fb864fcfa1..a69476f5aec6 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -374,11 +374,6 @@ static int tcan4x5x_parse_config(struct m_can_classdev *cdev)
 	if (IS_ERR(tcan4x5x->device_state_gpio))
 		tcan4x5x->device_state_gpio = NULL;
 
-	tcan4x5x->power = devm_regulator_get_optional(cdev->dev,
-						      "vsup");
-	if (PTR_ERR(tcan4x5x->power) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
-
 	return 0;
 }
 
@@ -412,6 +407,12 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->power = devm_regulator_get_optional(&spi->dev, "vsup");
+	if (PTR_ERR(priv->power) == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+	else
+		priv->power = NULL;
+
 	mcan_class->device_data = priv;
 
 	m_can_class_get_clocks(mcan_class);
@@ -451,11 +452,13 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	priv->regmap = devm_regmap_init(&spi->dev, &tcan4x5x_bus,
 					&spi->dev, &tcan4x5x_regmap);
 
-	ret = tcan4x5x_parse_config(mcan_class);
+	ret = tcan4x5x_power_enable(priv->power, 1);
 	if (ret)
 		goto out_clk;
 
-	tcan4x5x_power_enable(priv->power, 1);
+	ret = tcan4x5x_parse_config(mcan_class);
+	if (ret)
+		goto out_power;
 
 	ret = tcan4x5x_init(mcan_class);
 	if (ret)
-- 
2.24.1

