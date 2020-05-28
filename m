Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBB61E6603
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 17:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404386AbgE1P2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 11:28:17 -0400
Received: from lists.gateworks.com ([108.161.130.12]:57323 "EHLO
        lists.gateworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404080AbgE1P2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 11:28:15 -0400
Received: from 068-189-091-139.biz.spectrum.com ([68.189.91.139] helo=tharvey.pdc.gateworks.com)
        by lists.gateworks.com with esmtp (Exim 4.82)
        (envelope-from <tharvey@gateworks.com>)
        id 1jeKUi-0000Yg-Hz; Thu, 28 May 2020 15:30:56 +0000
From:   Tim Harvey <tharvey@gateworks.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Sean Nyekjaer <sean@geanix.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?q?Timo=20Schl=C3=BC=C3=9Fler?= <schluessler@krause.de>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: [PATCH] can: mcp251x: add support for half duplex controllers
Date:   Thu, 28 May 2020 08:27:57 -0700
Message-Id: <1590679677-2678-1-git-send-email-tharvey@gateworks.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some SPI host controllers do not support full-duplex SPI and are
marked as such via the SPI_CONTROLLER_HALF_DUPLEX controller flag.

For such controllers use half duplex transactions but retain full
duplex transactions for the controllers that can handle those.

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/net/can/spi/mcp251x.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 5009ff2..203ef20 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -290,8 +290,12 @@ static u8 mcp251x_read_reg(struct spi_device *spi, u8 reg)
 	priv->spi_tx_buf[0] = INSTRUCTION_READ;
 	priv->spi_tx_buf[1] = reg;
 
-	mcp251x_spi_trans(spi, 3);
-	val = priv->spi_rx_buf[2];
+	if (spi->controller->flags & SPI_CONTROLLER_HALF_DUPLEX) {
+		spi_write_then_read(spi, priv->spi_tx_buf, 2, &val, 1);
+	} else {
+		mcp251x_spi_trans(spi, 3);
+		val = priv->spi_rx_buf[2];
+	}
 
 	return val;
 }
@@ -303,10 +307,18 @@ static void mcp251x_read_2regs(struct spi_device *spi, u8 reg, u8 *v1, u8 *v2)
 	priv->spi_tx_buf[0] = INSTRUCTION_READ;
 	priv->spi_tx_buf[1] = reg;
 
-	mcp251x_spi_trans(spi, 4);
+	if (spi->controller->flags & SPI_CONTROLLER_HALF_DUPLEX) {
+		u8 val[2] = { 0 };
 
-	*v1 = priv->spi_rx_buf[2];
-	*v2 = priv->spi_rx_buf[3];
+		spi_write_then_read(spi, priv->spi_tx_buf, 2, val, 2);
+		*v1 = val[0];
+		*v2 = val[1];
+	} else {
+		mcp251x_spi_trans(spi, 4);
+
+		*v1 = priv->spi_rx_buf[2];
+		*v2 = priv->spi_rx_buf[3];
+	}
 }
 
 static void mcp251x_write_reg(struct spi_device *spi, u8 reg, u8 val)
@@ -409,8 +421,16 @@ static void mcp251x_hw_rx_frame(struct spi_device *spi, u8 *buf,
 			buf[i] = mcp251x_read_reg(spi, RXBCTRL(buf_idx) + i);
 	} else {
 		priv->spi_tx_buf[RXBCTRL_OFF] = INSTRUCTION_READ_RXB(buf_idx);
-		mcp251x_spi_trans(spi, SPI_TRANSFER_BUF_LEN);
-		memcpy(buf, priv->spi_rx_buf, SPI_TRANSFER_BUF_LEN);
+		if (spi->controller->flags & SPI_CONTROLLER_HALF_DUPLEX) {
+			spi_write_then_read(spi, priv->spi_tx_buf, 1,
+					    priv->spi_rx_buf,
+					    SPI_TRANSFER_BUF_LEN);
+			memcpy(buf + 1, priv->spi_rx_buf,
+			       SPI_TRANSFER_BUF_LEN - 1);
+		} else {
+			mcp251x_spi_trans(spi, SPI_TRANSFER_BUF_LEN);
+			memcpy(buf, priv->spi_rx_buf, SPI_TRANSFER_BUF_LEN);
+		}
 	}
 }
 
-- 
2.7.4

