Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F37E3D5B3A
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhGZNdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234837AbhGZNcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:32:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE53C061798
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81LC-0001db-GK
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:22 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CD721658231
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:07 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 86F6665819E;
        Mon, 26 Jul 2021 14:11:52 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5d658279;
        Mon, 26 Jul 2021 14:11:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 17/46] can: mcp251xfd: mcp251xfd_probe(): try to get crystal clock rate from property
Date:   Mon, 26 Jul 2021 16:11:15 +0200
Message-Id: <20210726141144.862529-18-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

In some configurations, mainly ACPI-based, the clock frequency of the
device is supplied by very well established 'clock-frequency'
property. Hence, try to get it from the property at last if no other
providers are available.

Link: https://lore.kernel.org/r/20210531084444.1785397-1-mkl@pengutronix.de
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 6962ab2749df..1544e19b60b9 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2860,7 +2860,7 @@ static int mcp251xfd_probe(struct spi_device *spi)
 	struct gpio_desc *rx_int;
 	struct regulator *reg_vdd, *reg_xceiver;
 	struct clk *clk;
-	u32 freq;
+	u32 freq = 0;
 	int err;
 
 	if (!spi->irq)
@@ -2887,11 +2887,19 @@ static int mcp251xfd_probe(struct spi_device *spi)
 		return dev_err_probe(&spi->dev, PTR_ERR(reg_xceiver),
 				     "Failed to get Transceiver regulator!\n");
 
-	clk = devm_clk_get(&spi->dev, NULL);
+	clk = devm_clk_get_optional(&spi->dev, NULL);
 	if (IS_ERR(clk))
 		return dev_err_probe(&spi->dev, PTR_ERR(clk),
 				     "Failed to get Oscillator (clock)!\n");
-	freq = clk_get_rate(clk);
+	if (clk) {
+		freq = clk_get_rate(clk);
+	} else {
+		err = device_property_read_u32(&spi->dev, "clock-frequency",
+					       &freq);
+		if (err)
+			return dev_err_probe(&spi->dev, err,
+					     "Failed to get clock-frequency!\n");
+	}
 
 	/* Sanity check */
 	if (freq < MCP251XFD_SYSCLOCK_HZ_MIN ||
-- 
2.30.2


