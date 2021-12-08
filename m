Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A897646D3B1
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 13:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbhLHMyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 07:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhLHMyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 07:54:38 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D9FC0617A2
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 04:51:06 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1muwPZ-0003Ff-6J
        for netdev@vger.kernel.org; Wed, 08 Dec 2021 13:51:05 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D3D176BFBF5
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 12:51:00 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 682B36BFBCD;
        Wed,  8 Dec 2021 12:50:58 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4d9e6d4c;
        Wed, 8 Dec 2021 12:50:57 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Evgeny Boger <boger@wirenboard.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 3/8] can: sun4i_can: add support for R40 CAN controller
Date:   Wed,  8 Dec 2021 13:50:50 +0100
Message-Id: <20211208125055.223141-4-mkl@pengutronix.de>
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

From: Evgeny Boger <boger@wirenboard.com>

Allwinner R40 (also known as A40i, T3, V40) has a CAN controller. The
controller is the same as in earlier A10 and A20 SoCs, but needs reset
line to be deasserted before use.

This patch adds a new compatible for R40 CAN controller. Depending
on the compatible, reset line can be requested from DT.

Link: https://lore.kernel.org/all/20211122104616.537156-3-boger@wirenboard.com
Signed-off-by: Evgeny Boger <boger@wirenboard.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/sun4i_can.c | 62 +++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index 54aa7c25c4de..37862e7f6840 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -61,6 +61,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/reset.h>
 
 #define DRV_NAME "sun4i_can"
 
@@ -200,10 +201,20 @@
 #define SUN4I_CAN_MAX_IRQ	20
 #define SUN4I_MODE_MAX_RETRIES	100
 
+/**
+ * struct sun4ican_quirks - Differences between SoC variants.
+ *
+ * @has_reset: SoC needs reset deasserted.
+ */
+struct sun4ican_quirks {
+	bool has_reset;
+};
+
 struct sun4ican_priv {
 	struct can_priv can;
 	void __iomem *base;
 	struct clk *clk;
+	struct reset_control *reset;
 	spinlock_t cmdreg_lock;	/* lock for concurrent cmd register writes */
 };
 
@@ -702,6 +713,13 @@ static int sun4ican_open(struct net_device *dev)
 		goto exit_irq;
 	}
 
+	/* software reset deassert */
+	err = reset_control_deassert(priv->reset);
+	if (err) {
+		netdev_err(dev, "could not deassert CAN reset\n");
+		goto exit_soft_reset;
+	}
+
 	/* turn on clocking for CAN peripheral block */
 	err = clk_prepare_enable(priv->clk);
 	if (err) {
@@ -723,6 +741,8 @@ static int sun4ican_open(struct net_device *dev)
 exit_can_start:
 	clk_disable_unprepare(priv->clk);
 exit_clock:
+	reset_control_assert(priv->reset);
+exit_soft_reset:
 	free_irq(dev->irq, dev);
 exit_irq:
 	close_candev(dev);
@@ -736,6 +756,7 @@ static int sun4ican_close(struct net_device *dev)
 	netif_stop_queue(dev);
 	sun4i_can_stop(dev);
 	clk_disable_unprepare(priv->clk);
+	reset_control_assert(priv->reset);
 
 	free_irq(dev->irq, dev);
 	close_candev(dev);
@@ -750,9 +771,27 @@ static const struct net_device_ops sun4ican_netdev_ops = {
 	.ndo_start_xmit = sun4ican_start_xmit,
 };
 
+static const struct sun4ican_quirks sun4ican_quirks_a10 = {
+	.has_reset = false,
+};
+
+static const struct sun4ican_quirks sun4ican_quirks_r40 = {
+	.has_reset = true,
+};
+
 static const struct of_device_id sun4ican_of_match[] = {
-	{.compatible = "allwinner,sun4i-a10-can"},
-	{},
+	{
+		.compatible = "allwinner,sun4i-a10-can",
+		.data = &sun4ican_quirks_a10
+	}, {
+		.compatible = "allwinner,sun7i-a20-can",
+		.data = &sun4ican_quirks_a10
+	}, {
+		.compatible = "allwinner,sun8i-r40-can",
+		.data = &sun4ican_quirks_r40
+	}, {
+		/* sentinel */
+	},
 };
 
 MODULE_DEVICE_TABLE(of, sun4ican_of_match);
@@ -771,10 +810,28 @@ static int sun4ican_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct clk *clk;
+	struct reset_control *reset = NULL;
 	void __iomem *addr;
 	int err, irq;
 	struct net_device *dev;
 	struct sun4ican_priv *priv;
+	const struct sun4ican_quirks *quirks;
+
+	quirks = of_device_get_match_data(&pdev->dev);
+	if (!quirks) {
+		dev_err(&pdev->dev, "failed to determine the quirks to use\n");
+		err = -ENODEV;
+		goto exit;
+	}
+
+	if (quirks->has_reset) {
+		reset = devm_reset_control_get_exclusive(&pdev->dev, NULL);
+		if (IS_ERR(reset)) {
+			dev_err(&pdev->dev, "unable to request reset\n");
+			err = PTR_ERR(reset);
+			goto exit;
+		}
+	}
 
 	clk = of_clk_get(np, 0);
 	if (IS_ERR(clk)) {
@@ -818,6 +875,7 @@ static int sun4ican_probe(struct platform_device *pdev)
 				       CAN_CTRLMODE_3_SAMPLES;
 	priv->base = addr;
 	priv->clk = clk;
+	priv->reset = reset;
 	spin_lock_init(&priv->cmdreg_lock);
 
 	platform_set_drvdata(pdev, dev);
-- 
2.33.0


