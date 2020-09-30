Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB5827F31C
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729645AbgI3US0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729865AbgI3USZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:18:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E75C0613D1
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 13:18:25 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kNiYR-0002Qt-9I; Wed, 30 Sep 2020 22:18:23 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Thomas Kopp <thomas.kopp@microchip.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 02/13] can: mcp25xxfd: mcp25xxfd_probe(): add SPI clk limit related errata information
Date:   Wed, 30 Sep 2020 22:18:05 +0200
Message-Id: <20200930201816.1032054-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930201816.1032054-1-mkl@pengutronix.de>
References: <20200930201816.1032054-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Kopp <thomas.kopp@microchip.com>

This patch adds a reference to the recent released MCP2517FD and MCP2518FD
errata sheets and paste the explanation.

The driver already implements the proposed fix.

Signed-off-by: Thomas Kopp <thomas.kopp@microchip.com>
Link: https://lore.kernel.org/r/20200925065606.358-1-thomas.kopp@microchip.com
[mkl: split into two patches, adjust subject and commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp25xxfd/mcp25xxfd-core.c    | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
index 106dda8e5310..c094bb716256 100644
--- a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
@@ -2819,11 +2819,21 @@ static int mcp25xxfd_probe(struct spi_device *spi)
 		priv->devtype_data = *(struct mcp25xxfd_devtype_data *)
 			spi_get_device_id(spi)->driver_data;
 
-	/* According to the datasheet the SPI clock must be less or
-	 * equal SYSCLOCK / 2.
+	/* Errata Reference:
+	 * mcp2517fd: DS80000789B, mcp2518fd: DS80000792C 4.
+	 *
+	 * The SPI can write corrupted data to the RAM at fast SPI
+	 * speeds:
+	 *
+	 * Simultaneous activity on the CAN bus while writing data to
+	 * RAM via the SPI interface, with high SCK frequency, can
+	 * lead to corrupted data being written to RAM.
+	 *
+	 * Fix/Work Around:
+	 * Ensure that FSCK is less than or equal to 0.85 *
+	 * (FSYSCLK/2).
 	 *
-	 * It turns out, that the Controller is not stable at this
-	 * rate. Known good and bad combinations are:
+	 * Known good and bad combinations are:
 	 *
 	 * MCP	ext-clk	SoC			SPI			SPI-clk		max-clk	parent-clk	Status	config
 	 *
@@ -2836,7 +2846,6 @@ static int mcp25xxfd_probe(struct spi_device *spi)
 	 * 2517 40 MHz	atmel,sama5d27		atmel,at91rm9200-spi	16400000 Hz	 82.00%	 82000000 Hz	good	default
 	 * 2518 40 MHz	atmel,sama5d27		atmel,at91rm9200-spi	16400000 Hz	 82.00%	 82000000 Hz	good	default
 	 *
-	 * Limit SPI clock to 85% of SYSCLOCK / 2 for now.
 	 */
 	priv->spi_max_speed_hz_orig = spi->max_speed_hz;
 	spi->max_speed_hz = min(spi->max_speed_hz, freq / 2 / 1000 * 850);
-- 
2.28.0

