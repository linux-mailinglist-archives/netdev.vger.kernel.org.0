Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB793977F
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731257AbfFGVPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:15:52 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55703 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731224AbfFGVPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 17:15:50 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <mkl@pengutronix.de>)
        id 1hZMDF-00006I-DG; Fri, 07 Jun 2019 23:15:49 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5/9] can: mcp251x: add support for mcp25625
Date:   Fri,  7 Jun 2019 23:15:37 +0200
Message-Id: <20190607211541.16095-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607211541.16095-1-mkl@pengutronix.de>
References: <20190607211541.16095-1-mkl@pengutronix.de>
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

Fully compatible with mcp2515, the mcp25625 have integrated transceiver.

This patch adds support for the mcp25625 to the existing mcp251x driver.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/Kconfig   |  5 +++--
 drivers/net/can/spi/mcp251x.c | 25 ++++++++++++++++---------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/spi/Kconfig b/drivers/net/can/spi/Kconfig
index 2e7e535e9237..1c50788055cb 100644
--- a/drivers/net/can/spi/Kconfig
+++ b/drivers/net/can/spi/Kconfig
@@ -9,9 +9,10 @@ config CAN_HI311X
 	  Driver for the Holt HI311x SPI CAN controllers.
 
 config CAN_MCP251X
-	tristate "Microchip MCP251x SPI CAN controllers"
+	tristate "Microchip MCP251x and MCP25625 SPI CAN controllers"
 	depends on HAS_DMA
 	---help---
-	  Driver for the Microchip MCP251x SPI CAN controllers.
+	  Driver for the Microchip MCP251x and MCP25625 SPI CAN
+	  controllers.
 
 endmenu
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index e90817608645..da64e71a62ee 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1,5 +1,5 @@
 /*
- * CAN bus driver for Microchip 251x CAN Controller with SPI Interface
+ * CAN bus driver for Microchip 251x/25625 CAN Controller with SPI Interface
  *
  * MCP2510 support and bug fixes by Christian Pellegrin
  * <chripell@evolware.org>
@@ -41,7 +41,7 @@
  * static struct spi_board_info spi_board_info[] = {
  *         {
  *                 .modalias = "mcp2510",
- *			// or "mcp2515" depending on your controller
+ *			// "mcp2515" or "mcp25625" depending on your controller
  *                 .platform_data = &mcp251x_info,
  *                 .irq = IRQ_EINT13,
  *                 .max_speed_hz = 2*1000*1000,
@@ -238,6 +238,7 @@ static const struct can_bittiming_const mcp251x_bittiming_const = {
 enum mcp251x_model {
 	CAN_MCP251X_MCP2510	= 0x2510,
 	CAN_MCP251X_MCP2515	= 0x2515,
+	CAN_MCP251X_MCP25625	= 0x25625,
 };
 
 struct mcp251x_priv {
@@ -280,7 +281,6 @@ static inline int mcp251x_is_##_model(struct spi_device *spi) \
 }
 
 MCP251X_IS(2510);
-MCP251X_IS(2515);
 
 static void mcp251x_clean(struct net_device *net)
 {
@@ -639,7 +639,7 @@ static int mcp251x_hw_reset(struct spi_device *spi)
 
 	/* Wait for oscillator startup timer after reset */
 	mdelay(MCP251X_OST_DELAY_MS);
-	
+
 	reg = mcp251x_read_reg(spi, CANSTAT);
 	if ((reg & CANCTRL_REQOP_MASK) != CANCTRL_REQOP_CONF)
 		return -ENODEV;
@@ -820,9 +820,8 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 		/* receive buffer 0 */
 		if (intf & CANINTF_RX0IF) {
 			mcp251x_hw_rx(spi, 0);
-			/*
-			 * Free one buffer ASAP
-			 * (The MCP2515 does this automatically.)
+			/* Free one buffer ASAP
+			 * (The MCP2515/25625 does this automatically.)
 			 */
 			if (mcp251x_is_2510(spi))
 				mcp251x_write_bits(spi, CANINTF, CANINTF_RX0IF, 0x00);
@@ -831,7 +830,7 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 		/* receive buffer 1 */
 		if (intf & CANINTF_RX1IF) {
 			mcp251x_hw_rx(spi, 1);
-			/* the MCP2515 does this automatically */
+			/* The MCP2515/25625 does this automatically. */
 			if (mcp251x_is_2510(spi))
 				clear_intf |= CANINTF_RX1IF;
 		}
@@ -1006,6 +1005,10 @@ static const struct of_device_id mcp251x_of_match[] = {
 		.compatible	= "microchip,mcp2515",
 		.data		= (void *)CAN_MCP251X_MCP2515,
 	},
+	{
+		.compatible	= "microchip,mcp25625",
+		.data		= (void *)CAN_MCP251X_MCP25625,
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(of, mcp251x_of_match);
@@ -1019,6 +1022,10 @@ static const struct spi_device_id mcp251x_id_table[] = {
 		.name		= "mcp2515",
 		.driver_data	= (kernel_ulong_t)CAN_MCP251X_MCP2515,
 	},
+	{
+		.name		= "mcp25625",
+		.driver_data	= (kernel_ulong_t)CAN_MCP251X_MCP25625,
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(spi, mcp251x_id_table);
@@ -1259,5 +1266,5 @@ module_spi_driver(mcp251x_can_driver);
 
 MODULE_AUTHOR("Chris Elston <celston@katalix.com>, "
 	      "Christian Pellegrin <chripell@evolware.org>");
-MODULE_DESCRIPTION("Microchip 251x CAN driver");
+MODULE_DESCRIPTION("Microchip 251x/25625 CAN driver");
 MODULE_LICENSE("GPL v2");
-- 
2.20.1

