Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD1827262C
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgIUNrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbgIUNqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:46:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A03C0613AB
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:46:14 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kKM8y-0003ED-K5; Mon, 21 Sep 2020 15:46:12 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 28/38] can: mcp251x: Use readx_poll_timeout() helper
Date:   Mon, 21 Sep 2020 15:45:47 +0200
Message-Id: <20200921134557.2251383-29-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921134557.2251383-1-mkl@pengutronix.de>
References: <20200921134557.2251383-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

We may use special helper macro to poll IO till condition or timeout occurs.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20200217161038.25009-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251x.c | 64 ++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 4b113f61e39d..3bf57bc9b3ff 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -32,6 +32,7 @@
 #include <linux/gpio/driver.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
@@ -376,6 +377,15 @@ static void mcp251x_write_bits(struct spi_device *spi, u8 reg,
 	mcp251x_spi_trans(spi, 4);
 }
 
+static u8 mcp251x_read_stat(struct spi_device *spi)
+{
+	return mcp251x_read_reg(spi, CANSTAT) & CANCTRL_REQOP_MASK;
+}
+
+#define mcp251x_read_stat_poll_timeout(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout(mcp251x_read_stat, addr, val, cond, \
+			   delay_us, timeout_us)
+
 #ifdef CONFIG_GPIOLIB
 enum {
 	MCP251X_GPIO_TX0RTS = 0,		/* inputs */
@@ -709,7 +719,8 @@ static void mcp251x_hw_sleep(struct spi_device *spi)
 /* May only be called when device is sleeping! */
 static int mcp251x_hw_wake(struct spi_device *spi)
 {
-	unsigned long timeout;
+	u8 value;
+	int ret;
 
 	/* Force wakeup interrupt to wake device, but don't execute IST */
 	disable_irq(spi->irq);
@@ -722,14 +733,12 @@ static int mcp251x_hw_wake(struct spi_device *spi)
 	mcp251x_write_reg(spi, CANCTRL, CANCTRL_REQOP_CONF);
 
 	/* Wait for the device to enter config mode */
-	timeout = jiffies + HZ;
-	while ((mcp251x_read_reg(spi, CANSTAT) & CANCTRL_REQOP_MASK) !=
-			CANCTRL_REQOP_CONF) {
-		schedule();
-		if (time_after(jiffies, timeout)) {
-			dev_err(&spi->dev, "MCP251x didn't enter in config mode\n");
-			return -EBUSY;
-		}
+	ret = mcp251x_read_stat_poll_timeout(spi, value, value == CANCTRL_REQOP_CONF,
+					     MCP251X_OST_DELAY_MS * 1000,
+					     USEC_PER_SEC);
+	if (ret) {
+		dev_err(&spi->dev, "MCP251x didn't enter in config mode\n");
+		return ret;
 	}
 
 	/* Disable and clear pending interrupts */
@@ -784,7 +793,8 @@ static int mcp251x_do_set_mode(struct net_device *net, enum can_mode mode)
 static int mcp251x_set_normal_mode(struct spi_device *spi)
 {
 	struct mcp251x_priv *priv = spi_get_drvdata(spi);
-	unsigned long timeout;
+	u8 value;
+	int ret;
 
 	/* Enable interrupts */
 	mcp251x_write_reg(spi, CANINTE,
@@ -802,13 +812,12 @@ static int mcp251x_set_normal_mode(struct spi_device *spi)
 		mcp251x_write_reg(spi, CANCTRL, CANCTRL_REQOP_NORMAL);
 
 		/* Wait for the device to enter normal mode */
-		timeout = jiffies + HZ;
-		while (mcp251x_read_reg(spi, CANSTAT) & CANCTRL_REQOP_MASK) {
-			schedule();
-			if (time_after(jiffies, timeout)) {
-				dev_err(&spi->dev, "MCP251x didn't enter in normal mode\n");
-				return -EBUSY;
-			}
+		ret = mcp251x_read_stat_poll_timeout(spi, value, value == 0,
+						     MCP251X_OST_DELAY_MS * 1000,
+						     USEC_PER_SEC);
+		if (ret) {
+			dev_err(&spi->dev, "MCP251x didn't enter in normal mode\n");
+			return ret;
 		}
 	}
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
@@ -852,7 +861,7 @@ static int mcp251x_setup(struct net_device *net, struct spi_device *spi)
 static int mcp251x_hw_reset(struct spi_device *spi)
 {
 	struct mcp251x_priv *priv = spi_get_drvdata(spi);
-	unsigned long timeout;
+	u8 value;
 	int ret;
 
 	/* Wait for oscillator startup timer after power up */
@@ -867,19 +876,12 @@ static int mcp251x_hw_reset(struct spi_device *spi)
 	mdelay(MCP251X_OST_DELAY_MS);
 
 	/* Wait for reset to finish */
-	timeout = jiffies + HZ;
-	while ((mcp251x_read_reg(spi, CANSTAT) & CANCTRL_REQOP_MASK) !=
-	       CANCTRL_REQOP_CONF) {
-		usleep_range(MCP251X_OST_DELAY_MS * 1000,
-			     MCP251X_OST_DELAY_MS * 1000 * 2);
-
-		if (time_after(jiffies, timeout)) {
-			dev_err(&spi->dev,
-				"MCP251x didn't enter in conf mode after reset\n");
-			return -EBUSY;
-		}
-	}
-	return 0;
+	ret = mcp251x_read_stat_poll_timeout(spi, value, value == CANCTRL_REQOP_CONF,
+					     MCP251X_OST_DELAY_MS * 1000,
+					     USEC_PER_SEC);
+	if (ret)
+		dev_err(&spi->dev, "MCP251x didn't enter in conf mode after reset\n");
+	return ret;
 }
 
 static int mcp251x_hw_probe(struct spi_device *spi)
-- 
2.28.0

