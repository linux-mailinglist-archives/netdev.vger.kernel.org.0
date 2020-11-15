Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB3D2B3740
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 18:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgKORll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 12:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbgKORlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 12:41:40 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7314C0613D1
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 09:41:40 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1keM1x-0005uQ-RZ; Sun, 15 Nov 2020 18:41:37 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Zhang Qilong <zhangqilong3@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 04/15] can: ti_hecc: Fix memleak in ti_hecc_probe
Date:   Sun, 15 Nov 2020 18:41:20 +0100
Message-Id: <20201115174131.2089251-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201115174131.2089251-1-mkl@pengutronix.de>
References: <20201115174131.2089251-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

In the error handling, we should goto the probe_exit_candev
to free ndev to prevent memory leak.

Fixes: dabf54dd1c63 ("can: ti_hecc: Convert TI HECC driver to DT only driver")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201114111708.3465543-1-zhangqilong3@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/ti_hecc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 9913f5458279..2c22f40e12bd 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -881,7 +881,8 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	priv->base = devm_platform_ioremap_resource_byname(pdev, "hecc");
 	if (IS_ERR(priv->base)) {
 		dev_err(&pdev->dev, "hecc ioremap failed\n");
-		return PTR_ERR(priv->base);
+		err = PTR_ERR(priv->base);
+		goto probe_exit_candev;
 	}
 
 	/* handle hecc-ram memory */
@@ -889,20 +890,22 @@ static int ti_hecc_probe(struct platform_device *pdev)
 							       "hecc-ram");
 	if (IS_ERR(priv->hecc_ram)) {
 		dev_err(&pdev->dev, "hecc-ram ioremap failed\n");
-		return PTR_ERR(priv->hecc_ram);
+		err = PTR_ERR(priv->hecc_ram);
+		goto probe_exit_candev;
 	}
 
 	/* handle mbx memory */
 	priv->mbx = devm_platform_ioremap_resource_byname(pdev, "mbx");
 	if (IS_ERR(priv->mbx)) {
 		dev_err(&pdev->dev, "mbx ioremap failed\n");
-		return PTR_ERR(priv->mbx);
+		err = PTR_ERR(priv->mbx);
+		goto probe_exit_candev;
 	}
 
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!irq) {
 		dev_err(&pdev->dev, "No irq resource\n");
-		goto probe_exit;
+		goto probe_exit_candev;
 	}
 
 	priv->ndev = ndev;
@@ -966,7 +969,7 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	clk_put(priv->clk);
 probe_exit_candev:
 	free_candev(ndev);
-probe_exit:
+
 	return err;
 }
 
-- 
2.29.2

