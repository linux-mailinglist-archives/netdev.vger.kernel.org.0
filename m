Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6077968BDC3
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjBFNSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjBFNRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:17:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A227E23D86
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:24 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1N4-0007Z4-N1
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:22 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 51A3F1713AF
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:26 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 106D41712B8;
        Mon,  6 Feb 2023 13:16:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9edf823c;
        Mon, 6 Feb 2023 13:16:22 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 14/47] can: rcar_canfd: Add helper variable dev
Date:   Mon,  6 Feb 2023 14:15:47 +0100
Message-Id: <20230206131620.2758724-15-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

rcar_canfd_channel_probe() and rcar_canfd_probe() have many users of
"pdev->dev".  Introduce shorthands to simplify the code.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/all/2965edc7992ab54dc6c862910775f3466fca6b29.1674499048.git.geert+renesas@glider.be
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 86 +++++++++++++++----------------
 1 file changed, 42 insertions(+), 44 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index cfcf1a93fb58..ef4e1b9a9e1e 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1715,13 +1715,14 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 {
 	const struct rcar_canfd_hw_info *info = gpriv->info;
 	struct platform_device *pdev = gpriv->pdev;
+	struct device *dev = &pdev->dev;
 	struct rcar_canfd_channel *priv;
 	struct net_device *ndev;
 	int err = -ENODEV;
 
 	ndev = alloc_candev(sizeof(*priv), RCANFD_FIFO_DEPTH);
 	if (!ndev) {
-		dev_err(&pdev->dev, "alloc_candev() failed\n");
+		dev_err(dev, "alloc_candev() failed\n");
 		return -ENOMEM;
 	}
 	priv = netdev_priv(ndev);
@@ -1734,7 +1735,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	priv->channel = ch;
 	priv->gpriv = gpriv;
 	priv->can.clock.freq = fcan_freq;
-	dev_info(&pdev->dev, "can_clk rate is %u\n", priv->can.clock.freq);
+	dev_info(dev, "can_clk rate is %u\n", priv->can.clock.freq);
 
 	if (info->multi_channel_irqs) {
 		char *irq_name;
@@ -1753,31 +1754,31 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 			goto fail;
 		}
 
-		irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
-					  "canfd.ch%d_err", ch);
+		irq_name = devm_kasprintf(dev, GFP_KERNEL, "canfd.ch%d_err",
+					  ch);
 		if (!irq_name) {
 			err = -ENOMEM;
 			goto fail;
 		}
-		err = devm_request_irq(&pdev->dev, err_irq,
+		err = devm_request_irq(dev, err_irq,
 				       rcar_canfd_channel_err_interrupt, 0,
 				       irq_name, priv);
 		if (err) {
-			dev_err(&pdev->dev, "devm_request_irq CH Err(%d) failed, error %d\n",
+			dev_err(dev, "devm_request_irq CH Err(%d) failed, error %d\n",
 				err_irq, err);
 			goto fail;
 		}
-		irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
-					  "canfd.ch%d_trx", ch);
+		irq_name = devm_kasprintf(dev, GFP_KERNEL, "canfd.ch%d_trx",
+					  ch);
 		if (!irq_name) {
 			err = -ENOMEM;
 			goto fail;
 		}
-		err = devm_request_irq(&pdev->dev, tx_irq,
+		err = devm_request_irq(dev, tx_irq,
 				       rcar_canfd_channel_tx_interrupt, 0,
 				       irq_name, priv);
 		if (err) {
-			dev_err(&pdev->dev, "devm_request_irq Tx (%d) failed, error %d\n",
+			dev_err(dev, "devm_request_irq Tx (%d) failed, error %d\n",
 				tx_irq, err);
 			goto fail;
 		}
@@ -1801,7 +1802,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 
 	priv->can.do_set_mode = rcar_canfd_do_set_mode;
 	priv->can.do_get_berr_counter = rcar_canfd_get_berr_counter;
-	SET_NETDEV_DEV(ndev, &pdev->dev);
+	SET_NETDEV_DEV(ndev, dev);
 
 	netif_napi_add_weight(ndev, &priv->napi, rcar_canfd_rx_poll,
 			      RCANFD_NAPI_WEIGHT);
@@ -1809,11 +1810,10 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	gpriv->ch[priv->channel] = priv;
 	err = register_candev(ndev);
 	if (err) {
-		dev_err(&pdev->dev,
-			"register_candev() failed, error %d\n", err);
+		dev_err(dev, "register_candev() failed, error %d\n", err);
 		goto fail_candev;
 	}
-	dev_info(&pdev->dev, "device registered (channel %u)\n", priv->channel);
+	dev_info(dev, "device registered (channel %u)\n", priv->channel);
 	return 0;
 
 fail_candev:
@@ -1837,6 +1837,7 @@ static void rcar_canfd_channel_remove(struct rcar_canfd_global *gpriv, u32 ch)
 static int rcar_canfd_probe(struct platform_device *pdev)
 {
 	const struct rcar_canfd_hw_info *info;
+	struct device *dev = &pdev->dev;
 	void __iomem *addr;
 	u32 sts, ch, fcan_freq;
 	struct rcar_canfd_global *gpriv;
@@ -1848,14 +1849,14 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	char name[9] = "channelX";
 	int i;
 
-	info = of_device_get_match_data(&pdev->dev);
+	info = of_device_get_match_data(dev);
 
-	if (of_property_read_bool(pdev->dev.of_node, "renesas,no-can-fd"))
+	if (of_property_read_bool(dev->of_node, "renesas,no-can-fd"))
 		fdmode = false;			/* Classical CAN only mode */
 
 	for (i = 0; i < info->max_channels; ++i) {
 		name[7] = '0' + i;
-		of_child = of_get_child_by_name(pdev->dev.of_node, name);
+		of_child = of_get_child_by_name(dev->of_node, name);
 		if (of_child && of_device_is_available(of_child))
 			channels_mask |= BIT(i);
 		of_node_put(of_child);
@@ -1888,7 +1889,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	}
 
 	/* Global controller context */
-	gpriv = devm_kzalloc(&pdev->dev, sizeof(*gpriv), GFP_KERNEL);
+	gpriv = devm_kzalloc(dev, sizeof(*gpriv), GFP_KERNEL);
 	if (!gpriv)
 		return -ENOMEM;
 
@@ -1897,32 +1898,30 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->fdmode = fdmode;
 	gpriv->info = info;
 
-	gpriv->rstc1 = devm_reset_control_get_optional_exclusive(&pdev->dev,
-								 "rstp_n");
+	gpriv->rstc1 = devm_reset_control_get_optional_exclusive(dev, "rstp_n");
 	if (IS_ERR(gpriv->rstc1))
-		return dev_err_probe(&pdev->dev, PTR_ERR(gpriv->rstc1),
+		return dev_err_probe(dev, PTR_ERR(gpriv->rstc1),
 				     "failed to get rstp_n\n");
 
-	gpriv->rstc2 = devm_reset_control_get_optional_exclusive(&pdev->dev,
-								 "rstc_n");
+	gpriv->rstc2 = devm_reset_control_get_optional_exclusive(dev, "rstc_n");
 	if (IS_ERR(gpriv->rstc2))
-		return dev_err_probe(&pdev->dev, PTR_ERR(gpriv->rstc2),
+		return dev_err_probe(dev, PTR_ERR(gpriv->rstc2),
 				     "failed to get rstc_n\n");
 
 	/* Peripheral clock */
-	gpriv->clkp = devm_clk_get(&pdev->dev, "fck");
+	gpriv->clkp = devm_clk_get(dev, "fck");
 	if (IS_ERR(gpriv->clkp))
-		return dev_err_probe(&pdev->dev, PTR_ERR(gpriv->clkp),
+		return dev_err_probe(dev, PTR_ERR(gpriv->clkp),
 				     "cannot get peripheral clock\n");
 
 	/* fCAN clock: Pick External clock. If not available fallback to
 	 * CANFD clock
 	 */
-	gpriv->can_clk = devm_clk_get(&pdev->dev, "can_clk");
+	gpriv->can_clk = devm_clk_get(dev, "can_clk");
 	if (IS_ERR(gpriv->can_clk) || (clk_get_rate(gpriv->can_clk) == 0)) {
-		gpriv->can_clk = devm_clk_get(&pdev->dev, "canfd");
+		gpriv->can_clk = devm_clk_get(dev, "canfd");
 		if (IS_ERR(gpriv->can_clk))
-			return dev_err_probe(&pdev->dev, PTR_ERR(gpriv->can_clk),
+			return dev_err_probe(dev, PTR_ERR(gpriv->can_clk),
 					     "cannot get canfd clock\n");
 
 		gpriv->fcan = RCANFD_CANFDCLK;
@@ -1945,39 +1944,38 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 
 	/* Request IRQ that's common for both channels */
 	if (info->shared_global_irqs) {
-		err = devm_request_irq(&pdev->dev, ch_irq,
+		err = devm_request_irq(dev, ch_irq,
 				       rcar_canfd_channel_interrupt, 0,
 				       "canfd.ch_int", gpriv);
 		if (err) {
-			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
+			dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
 				ch_irq, err);
 			goto fail_dev;
 		}
 
-		err = devm_request_irq(&pdev->dev, g_irq,
-				       rcar_canfd_global_interrupt, 0,
-				       "canfd.g_int", gpriv);
+		err = devm_request_irq(dev, g_irq, rcar_canfd_global_interrupt,
+				       0, "canfd.g_int", gpriv);
 		if (err) {
-			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
+			dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
 				g_irq, err);
 			goto fail_dev;
 		}
 	} else {
-		err = devm_request_irq(&pdev->dev, g_recc_irq,
+		err = devm_request_irq(dev, g_recc_irq,
 				       rcar_canfd_global_receive_fifo_interrupt, 0,
 				       "canfd.g_recc", gpriv);
 
 		if (err) {
-			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
+			dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
 				g_recc_irq, err);
 			goto fail_dev;
 		}
 
-		err = devm_request_irq(&pdev->dev, g_err_irq,
+		err = devm_request_irq(dev, g_err_irq,
 				       rcar_canfd_global_err_interrupt, 0,
 				       "canfd.g_err", gpriv);
 		if (err) {
-			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
+			dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
 				g_err_irq, err);
 			goto fail_dev;
 		}
@@ -1995,14 +1993,14 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	/* Enable peripheral clock for register access */
 	err = clk_prepare_enable(gpriv->clkp);
 	if (err) {
-		dev_err(&pdev->dev,
-			"failed to enable peripheral clock, error %d\n", err);
+		dev_err(dev, "failed to enable peripheral clock, error %d\n",
+			err);
 		goto fail_reset;
 	}
 
 	err = rcar_canfd_reset_controller(gpriv);
 	if (err) {
-		dev_err(&pdev->dev, "reset controller failed\n");
+		dev_err(dev, "reset controller failed\n");
 		goto fail_clk;
 	}
 
@@ -2032,7 +2030,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	err = readl_poll_timeout((gpriv->base + RCANFD_GSTS), sts,
 				 !(sts & RCANFD_GSTS_GNOPM), 2, 500000);
 	if (err) {
-		dev_err(&pdev->dev, "global operational mode failed\n");
+		dev_err(dev, "global operational mode failed\n");
 		goto fail_mode;
 	}
 
@@ -2043,7 +2041,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, gpriv);
-	dev_info(&pdev->dev, "global operational state (clk %d, fdmode %d)\n",
+	dev_info(dev, "global operational state (clk %d, fdmode %d)\n",
 		 gpriv->fcan, gpriv->fdmode);
 	return 0;
 
-- 
2.39.1


