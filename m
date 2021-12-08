Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3DE46D3B7
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 13:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbhLHMym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 07:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbhLHMyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 07:54:40 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62EBC061A72
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 04:51:08 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1muwPb-0003Ke-6h
        for netdev@vger.kernel.org; Wed, 08 Dec 2021 13:51:07 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2B1A26BFC0A
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 12:51:02 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B9B9C6BFBD3;
        Wed,  8 Dec 2021 12:50:58 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 73266650;
        Wed, 8 Dec 2021 12:50:57 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 6/8] can: hi311x: hi3110_can_probe(): try to get crystal clock rate from property
Date:   Wed,  8 Dec 2021 13:50:53 +0100
Message-Id: <20211208125055.223141-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211208125055.223141-1-mkl@pengutronix.de>
References: <20211208125055.223141-1-mkl@pengutronix.de>
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

Link: https://lore.kernel.org/all/20211206165542.69887-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/hi311x.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 13fb979645cf..c9efdd10d0f8 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -830,17 +830,26 @@ static int hi3110_can_probe(struct spi_device *spi)
 {
 	const struct of_device_id *of_id = of_match_device(hi3110_of_match,
 							   &spi->dev);
+	struct device *dev = &spi->dev;
 	struct net_device *net;
 	struct hi3110_priv *priv;
 	struct clk *clk;
-	int freq, ret;
+	u32 freq;
+	int ret;
 
 	clk = devm_clk_get_optional(&spi->dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(&spi->dev, "no CAN clock source defined\n");
 		return PTR_ERR(clk);
 	}
-	freq = clk_get_rate(clk);
+
+	if (clk) {
+		freq = clk_get_rate(clk);
+	} else {
+		ret = device_property_read_u32(dev, "clock-frequency", &freq);
+		if (ret)
+			return dev_err_probe(dev, ret, "Failed to get clock-frequency!\n");
+	}
 
 	/* Sanity check */
 	if (freq > 40000000)
-- 
2.33.0


