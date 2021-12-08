Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F71046D3B3
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 13:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbhLHMyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 07:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbhLHMyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 07:54:40 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8C9C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 04:51:08 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1muwPa-0003Io-V5
        for netdev@vger.kernel.org; Wed, 08 Dec 2021 13:51:07 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C8E396BFC03
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 12:51:01 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A47806BFBD1;
        Wed,  8 Dec 2021 12:50:58 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 317b77d9;
        Wed, 8 Dec 2021 12:50:57 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 5/8] can: hi311x: hi3110_can_probe(): use devm_clk_get_optional() to get the input clock
Date:   Wed,  8 Dec 2021 13:50:52 +0100
Message-Id: <20211208125055.223141-6-mkl@pengutronix.de>
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

It's not clear what was the intention of redundant usage of IS_ERR()
around the clock pointer since with the error check of devm_clk_get()
followed by bailout it can't be invalid,

Simplify the code which fetches the input clock by using
devm_clk_get_optional(). It will allow to switch to device properties
approach in the future.

Link: https://lore.kernel.org/all/20211206165542.69887-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/hi311x.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 89d9c986a229..13fb979645cf 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -835,7 +835,7 @@ static int hi3110_can_probe(struct spi_device *spi)
 	struct clk *clk;
 	int freq, ret;
 
-	clk = devm_clk_get(&spi->dev, NULL);
+	clk = devm_clk_get_optional(&spi->dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(&spi->dev, "no CAN clock source defined\n");
 		return PTR_ERR(clk);
@@ -851,11 +851,9 @@ static int hi3110_can_probe(struct spi_device *spi)
 	if (!net)
 		return -ENOMEM;
 
-	if (!IS_ERR(clk)) {
-		ret = clk_prepare_enable(clk);
-		if (ret)
-			goto out_free;
-	}
+	ret = clk_prepare_enable(clk);
+	if (ret)
+		goto out_free;
 
 	net->netdev_ops = &hi3110_netdev_ops;
 	net->flags |= IFF_ECHO;
@@ -938,8 +936,7 @@ static int hi3110_can_probe(struct spi_device *spi)
 	hi3110_power_enable(priv->power, 0);
 
  out_clk:
-	if (!IS_ERR(clk))
-		clk_disable_unprepare(clk);
+	clk_disable_unprepare(clk);
 
  out_free:
 	free_candev(net);
@@ -957,8 +954,7 @@ static int hi3110_can_remove(struct spi_device *spi)
 
 	hi3110_power_enable(priv->power, 0);
 
-	if (!IS_ERR(priv->clk))
-		clk_disable_unprepare(priv->clk);
+	clk_disable_unprepare(priv->clk);
 
 	free_candev(net);
 
-- 
2.33.0


