Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA322576C8
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbfF0AmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727136AbfF0AmC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:42:02 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDDD921852;
        Thu, 27 Jun 2019 00:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561596121;
        bh=lA741g5M5XrN6vuMYnEO882Mv1kOcTBUERg4GVxIIHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3TF0A8Gy+Q7uxLC6s3gawmcXt/RCy3PxlKeMMUgHh3jPxd1FZaIdHEl0eGKxiKbw
         get5Sb/QoyaJe1PCC0XjKEz8JbYzI/sogoudjIf0m0HonASCAcjKiJDR4fbxgtYwbi
         QCQQHr/66+fGBakp+qaV5zeKLtZtg7YEguAae/nU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/21] can: mcp251x: add support for mcp25625
Date:   Wed, 26 Jun 2019 20:41:11 -0400
Message-Id: <20190627004122.21671-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627004122.21671-1-sashal@kernel.org>
References: <20190627004122.21671-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

[ Upstream commit 35b7fa4d07c43ad79b88e6462119e7140eae955c ]

Fully compatible with mcp2515, the mcp25625 have integrated transceiver.

This patch adds support for the mcp25625 to the existing mcp251x driver.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/Kconfig   |  5 +++--
 drivers/net/can/spi/mcp251x.c | 25 ++++++++++++++++---------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/spi/Kconfig b/drivers/net/can/spi/Kconfig
index 148cae5871a6..249d2db7d600 100644
--- a/drivers/net/can/spi/Kconfig
+++ b/drivers/net/can/spi/Kconfig
@@ -2,9 +2,10 @@ menu "CAN SPI interfaces"
 	depends on SPI
 
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
index f3f05fea8e1f..d8c448beab24 100644
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
@@ -640,7 +640,7 @@ static int mcp251x_hw_reset(struct spi_device *spi)
 
 	/* Wait for oscillator startup timer after reset */
 	mdelay(MCP251X_OST_DELAY_MS);
-	
+
 	reg = mcp251x_read_reg(spi, CANSTAT);
 	if ((reg & CANCTRL_REQOP_MASK) != CANCTRL_REQOP_CONF)
 		return -ENODEV;
@@ -821,9 +821,8 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
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
@@ -832,7 +831,7 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 		/* receive buffer 1 */
 		if (intf & CANINTF_RX1IF) {
 			mcp251x_hw_rx(spi, 1);
-			/* the MCP2515 does this automatically */
+			/* The MCP2515/25625 does this automatically. */
 			if (mcp251x_is_2510(spi))
 				clear_intf |= CANINTF_RX1IF;
 		}
@@ -1007,6 +1006,10 @@ static const struct of_device_id mcp251x_of_match[] = {
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
@@ -1020,6 +1023,10 @@ static const struct spi_device_id mcp251x_id_table[] = {
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
@@ -1260,5 +1267,5 @@ module_spi_driver(mcp251x_can_driver);
 
 MODULE_AUTHOR("Chris Elston <celston@katalix.com>, "
 	      "Christian Pellegrin <chripell@evolware.org>");
-MODULE_DESCRIPTION("Microchip 251x CAN driver");
+MODULE_DESCRIPTION("Microchip 251x/25625 CAN driver");
 MODULE_LICENSE("GPL v2");
-- 
2.20.1

