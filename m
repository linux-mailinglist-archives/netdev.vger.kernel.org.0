Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB4B12E885
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 17:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgABQJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 11:09:56 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57665 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728791AbgABQJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 11:09:40 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1in32X-0000mM-RJ; Thu, 02 Jan 2020 17:09:37 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3/9] can: tcan4x5x: tcan4x5x_parse_config(): reset device before register access
Date:   Thu,  2 Jan 2020 17:09:28 +0100
Message-Id: <20200102160934.1524-4-mkl@pengutronix.de>
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

From: Sean Nyekjaer <sean@geanix.com>

It's a good idea to reset a ip-block/spi device before using it, this
patch will reset the device.

And a generic reset function if needed elsewhere.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index a69476f5aec6..ee22e39f131b 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -166,6 +166,28 @@ static void tcan4x5x_check_wake(struct tcan4x5x_priv *priv)
 	}
 }
 
+static int tcan4x5x_reset(struct tcan4x5x_priv *priv)
+{
+	int ret = 0;
+
+	if (priv->reset_gpio) {
+		gpiod_set_value(priv->reset_gpio, 1);
+
+		/* tpulse_width minimum 30us */
+		usleep_range(30, 100);
+		gpiod_set_value(priv->reset_gpio, 0);
+	} else {
+		ret = regmap_write(priv->regmap, TCAN4X5X_CONFIG,
+				   TCAN4X5X_SW_RESET);
+		if (ret)
+			return ret;
+	}
+
+	usleep_range(700, 1000);
+
+	return ret;
+}
+
 static int regmap_spi_gather_write(void *context, const void *reg,
 				   size_t reg_len, const void *val,
 				   size_t val_len)
@@ -351,6 +373,7 @@ static int tcan4x5x_disable_wake(struct m_can_classdev *cdev)
 static int tcan4x5x_parse_config(struct m_can_classdev *cdev)
 {
 	struct tcan4x5x_priv *tcan4x5x = cdev->device_data;
+	int ret;
 
 	tcan4x5x->device_wake_gpio = devm_gpiod_get(cdev->dev, "device-wake",
 						    GPIOD_OUT_HIGH);
@@ -366,7 +389,9 @@ static int tcan4x5x_parse_config(struct m_can_classdev *cdev)
 	if (IS_ERR(tcan4x5x->reset_gpio))
 		tcan4x5x->reset_gpio = NULL;
 
-	usleep_range(700, 1000);
+	ret = tcan4x5x_reset(tcan4x5x);
+	if (ret)
+		return ret;
 
 	tcan4x5x->device_state_gpio = devm_gpiod_get_optional(cdev->dev,
 							      "device-state",
-- 
2.24.1

