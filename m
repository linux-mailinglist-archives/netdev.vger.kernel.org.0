Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54413550FD
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 12:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhDFKgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 06:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbhDFKgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 06:36:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD111C06175F
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 03:36:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lTj46-0003pD-9B
        for netdev@vger.kernel.org; Tue, 06 Apr 2021 12:36:10 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A096F60864F
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 10:36:08 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B24C4608642;
        Tue,  6 Apr 2021 10:36:07 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id b8c8af25;
        Tue, 6 Apr 2021 10:36:07 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Tim Harvey <tharvey@gateworks.com>,
        Gerhard Bertelsmann <info@gerhard-bertelsmann.de>
Subject: [net] can: mcp251x: fix support for half duplex SPI host controllers
Date:   Tue,  6 Apr 2021 12:36:06 +0200
Message-Id: <20210406103606.1847506-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406103606.1847506-1-mkl@pengutronix.de>
References: <20210406103606.1847506-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some SPI host controllers do not support full-duplex SPI transfers.

The function mcp251x_spi_trans() does a full duplex transfer. It is
used in several places in the driver, where a TX half duplex transfer
is sufficient.

To fix support for half duplex SPI host controllers, this patch
introduces a new function mcp251x_spi_write() and changes all callers
that do a TX half duplex transfer to use mcp251x_spi_write().

Fixes: e0e25001d088 ("can: mcp251x: add support for half duplex controllers")
Link: https://lore.kernel.org/r/20210330100246.1074375-1-mkl@pengutronix.de
Cc: Tim Harvey <tharvey@gateworks.com>
Tested-By: Tim Harvey <tharvey@gateworks.com>
Reported-by: Gerhard Bertelsmann <info@gerhard-bertelsmann.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251x.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index f69fb4238a65..a57da43680d8 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -314,6 +314,18 @@ static int mcp251x_spi_trans(struct spi_device *spi, int len)
 	return ret;
 }
 
+static int mcp251x_spi_write(struct spi_device *spi, int len)
+{
+	struct mcp251x_priv *priv = spi_get_drvdata(spi);
+	int ret;
+
+	ret = spi_write(spi, priv->spi_tx_buf, len);
+	if (ret)
+		dev_err(&spi->dev, "spi write failed: ret = %d\n", ret);
+
+	return ret;
+}
+
 static u8 mcp251x_read_reg(struct spi_device *spi, u8 reg)
 {
 	struct mcp251x_priv *priv = spi_get_drvdata(spi);
@@ -361,7 +373,7 @@ static void mcp251x_write_reg(struct spi_device *spi, u8 reg, u8 val)
 	priv->spi_tx_buf[1] = reg;
 	priv->spi_tx_buf[2] = val;
 
-	mcp251x_spi_trans(spi, 3);
+	mcp251x_spi_write(spi, 3);
 }
 
 static void mcp251x_write_2regs(struct spi_device *spi, u8 reg, u8 v1, u8 v2)
@@ -373,7 +385,7 @@ static void mcp251x_write_2regs(struct spi_device *spi, u8 reg, u8 v1, u8 v2)
 	priv->spi_tx_buf[2] = v1;
 	priv->spi_tx_buf[3] = v2;
 
-	mcp251x_spi_trans(spi, 4);
+	mcp251x_spi_write(spi, 4);
 }
 
 static void mcp251x_write_bits(struct spi_device *spi, u8 reg,
@@ -386,7 +398,7 @@ static void mcp251x_write_bits(struct spi_device *spi, u8 reg,
 	priv->spi_tx_buf[2] = mask;
 	priv->spi_tx_buf[3] = val;
 
-	mcp251x_spi_trans(spi, 4);
+	mcp251x_spi_write(spi, 4);
 }
 
 static u8 mcp251x_read_stat(struct spi_device *spi)
@@ -618,7 +630,7 @@ static void mcp251x_hw_tx_frame(struct spi_device *spi, u8 *buf,
 					  buf[i]);
 	} else {
 		memcpy(priv->spi_tx_buf, buf, TXBDAT_OFF + len);
-		mcp251x_spi_trans(spi, TXBDAT_OFF + len);
+		mcp251x_spi_write(spi, TXBDAT_OFF + len);
 	}
 }
 
@@ -650,7 +662,7 @@ static void mcp251x_hw_tx(struct spi_device *spi, struct can_frame *frame,
 
 	/* use INSTRUCTION_RTS, to avoid "repeated frame problem" */
 	priv->spi_tx_buf[0] = INSTRUCTION_RTS(1 << tx_buf_idx);
-	mcp251x_spi_trans(priv->spi, 1);
+	mcp251x_spi_write(priv->spi, 1);
 }
 
 static void mcp251x_hw_rx_frame(struct spi_device *spi, u8 *buf,
@@ -888,7 +900,7 @@ static int mcp251x_hw_reset(struct spi_device *spi)
 	mdelay(MCP251X_OST_DELAY_MS);
 
 	priv->spi_tx_buf[0] = INSTRUCTION_RESET;
-	ret = mcp251x_spi_trans(spi, 1);
+	ret = mcp251x_spi_write(spi, 1);
 	if (ret)
 		return ret;
 

base-commit: 08c27f3322fec11950b8f1384aa0f3b11d028528
-- 
2.30.2


