Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A492737504F
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 09:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbhEFHlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 03:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbhEFHlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 03:41:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6933BC061763
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 00:40:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1leYcR-0003Do-Vk
        for netdev@vger.kernel.org; Thu, 06 May 2021 09:40:24 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 51E6061DD91
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 07:40:22 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4FB8161DD71;
        Thu,  6 May 2021 07:40:18 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9e89d672;
        Thu, 6 May 2021 07:40:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 3/4] can: mcp251x: fix resume from sleep before interface was brought up
Date:   Thu,  6 May 2021 09:40:14 +0200
Message-Id: <20210506074015.1300591-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210506074015.1300591-1-mkl@pengutronix.de>
References: <20210506074015.1300591-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

Since 8ce8c0abcba3 the driver queues work via priv->restart_work when
resuming after suspend, even when the interface was not previously
enabled. This causes a null dereference error as the workqueue is only
allocated and initialized in mcp251x_open().

To fix this we move the workqueue init to mcp251x_can_probe() as there
is no reason to do it later and repeat it whenever mcp251x_open() is
called.

Fixes: 8ce8c0abcba3 ("can: mcp251x: only reset hardware as required")
Link: https://lore.kernel.org/r/17d5d714-b468-482f-f37a-482e3d6df84e@kontron.de
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
[mkl: fix error handling in mcp251x_stop()]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251x.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 492f1bcb0516..173c6614086f 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -956,8 +956,6 @@ static int mcp251x_stop(struct net_device *net)
 
 	priv->force_quit = 1;
 	free_irq(spi->irq, priv);
-	destroy_workqueue(priv->wq);
-	priv->wq = NULL;
 
 	mutex_lock(&priv->mcp_lock);
 
@@ -1224,24 +1222,15 @@ static int mcp251x_open(struct net_device *net)
 		goto out_close;
 	}
 
-	priv->wq = alloc_workqueue("mcp251x_wq", WQ_FREEZABLE | WQ_MEM_RECLAIM,
-				   0);
-	if (!priv->wq) {
-		ret = -ENOMEM;
-		goto out_clean;
-	}
-	INIT_WORK(&priv->tx_work, mcp251x_tx_work_handler);
-	INIT_WORK(&priv->restart_work, mcp251x_restart_work_handler);
-
 	ret = mcp251x_hw_wake(spi);
 	if (ret)
-		goto out_free_wq;
+		goto out_free_irq;
 	ret = mcp251x_setup(net, spi);
 	if (ret)
-		goto out_free_wq;
+		goto out_free_irq;
 	ret = mcp251x_set_normal_mode(spi);
 	if (ret)
-		goto out_free_wq;
+		goto out_free_irq;
 
 	can_led_event(net, CAN_LED_EVENT_OPEN);
 
@@ -1250,9 +1239,7 @@ static int mcp251x_open(struct net_device *net)
 
 	return 0;
 
-out_free_wq:
-	destroy_workqueue(priv->wq);
-out_clean:
+out_free_irq:
 	free_irq(spi->irq, priv);
 	mcp251x_hw_sleep(spi);
 out_close:
@@ -1373,6 +1360,15 @@ static int mcp251x_can_probe(struct spi_device *spi)
 	if (ret)
 		goto out_clk;
 
+	priv->wq = alloc_workqueue("mcp251x_wq", WQ_FREEZABLE | WQ_MEM_RECLAIM,
+				   0);
+	if (!priv->wq) {
+		ret = -ENOMEM;
+		goto out_clk;
+	}
+	INIT_WORK(&priv->tx_work, mcp251x_tx_work_handler);
+	INIT_WORK(&priv->restart_work, mcp251x_restart_work_handler);
+
 	priv->spi = spi;
 	mutex_init(&priv->mcp_lock);
 
@@ -1417,6 +1413,8 @@ static int mcp251x_can_probe(struct spi_device *spi)
 	return 0;
 
 error_probe:
+	destroy_workqueue(priv->wq);
+	priv->wq = NULL;
 	mcp251x_power_enable(priv->power, 0);
 
 out_clk:
@@ -1438,6 +1436,9 @@ static int mcp251x_can_remove(struct spi_device *spi)
 
 	mcp251x_power_enable(priv->power, 0);
 
+	destroy_workqueue(priv->wq);
+	priv->wq = NULL;
+
 	clk_disable_unprepare(priv->clk);
 
 	free_candev(net);
-- 
2.30.2


