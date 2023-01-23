Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26DC6785C3
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjAWTGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjAWTGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:06:12 -0500
X-Greylist: delayed 584 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 Jan 2023 11:06:09 PST
Received: from gauss.telenet-ops.be (gauss.telenet-ops.be [195.130.132.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEB4658F
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:06:09 -0800 (PST)
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by gauss.telenet-ops.be (Postfix) with ESMTPS id 4P0zpY4TdYz4wwdd
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 19:56:21 +0100 (CET)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:6083:1fd7:ba05:ea8d])
        by baptiste.telenet-ops.be with bizsmtp
        id CJwJ2900F4604Ck01JwJ30; Mon, 23 Jan 2023 19:56:21 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pK1zG-0076Kn-NF;
        Mon, 23 Jan 2023 19:56:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pK1zO-00Ekhn-KP;
        Mon, 23 Jan 2023 19:56:18 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 11/12] can: rcar_canfd: Add helper variable dev
Date:   Mon, 23 Jan 2023 19:56:13 +0100
Message-Id: <2965edc7992ab54dc6c862910775f3466fca6b29.1674499048.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1674499048.git.geert+renesas@glider.be>
References: <cover.1674499048.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rcar_canfd_channel_probe() and rcar_canfd_probe() have many users of
"pdev->dev".  Introduce shorthands to simplify the code.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/can/rcar/rcar_canfd.c | 86 +++++++++++++++----------------
 1 file changed, 42 insertions(+), 44 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index cfcf1a93fb58c36f..ef4e1b9a9e1ee280 100644
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
2.34.1

