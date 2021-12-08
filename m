Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5403846D3B8
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 13:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhLHMyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 07:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbhLHMyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 07:54:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26636C0617A1
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 04:51:09 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1muwPb-0003LB-Fj
        for netdev@vger.kernel.org; Wed, 08 Dec 2021 13:51:07 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 8F2F06BFC0F
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 12:51:02 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 067CE6BFBD8;
        Wed,  8 Dec 2021 12:50:59 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 77bc2b52;
        Wed, 8 Dec 2021 12:50:57 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 8/8] can: hi311x: hi3110_can_probe(): convert to use dev_err_probe()
Date:   Wed,  8 Dec 2021 13:50:55 +0100
Message-Id: <20211208125055.223141-9-mkl@pengutronix.de>
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

When deferred the reason is saved for further debugging. Besides that,
it's fine to call dev_err_probe() in ->probe() when error code is
known. Convert the driver to use dev_err_probe().

Link: https://lore.kernel.org/all/20211206165542.69887-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/hi311x.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 78044ec24575..a17641d36468 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -837,10 +837,8 @@ static int hi3110_can_probe(struct spi_device *spi)
 	int ret;
 
 	clk = devm_clk_get_optional(&spi->dev, NULL);
-	if (IS_ERR(clk)) {
-		dev_err(&spi->dev, "no CAN clock source defined\n");
-		return PTR_ERR(clk);
-	}
+	if (IS_ERR(clk))
+		return dev_err_probe(dev, PTR_ERR(clk), "no CAN clock source defined\n");
 
 	if (clk) {
 		freq = clk_get_rate(clk);
@@ -925,9 +923,7 @@ static int hi3110_can_probe(struct spi_device *spi)
 
 	ret = hi3110_hw_probe(spi);
 	if (ret) {
-		if (ret == -ENODEV)
-			dev_err(&spi->dev, "Cannot initialize %x. Wrong wiring?\n",
-				priv->model);
+		dev_err_probe(dev, ret, "Cannot initialize %x. Wrong wiring?\n", priv->model);
 		goto error_probe;
 	}
 	hi3110_hw_sleep(spi);
@@ -950,8 +946,7 @@ static int hi3110_can_probe(struct spi_device *spi)
  out_free:
 	free_candev(net);
 
-	dev_err(&spi->dev, "Probe failed, err=%d\n", -ret);
-	return ret;
+	return dev_err_probe(dev, ret, "Probe failed\n");
 }
 
 static int hi3110_can_remove(struct spi_device *spi)
-- 
2.33.0


