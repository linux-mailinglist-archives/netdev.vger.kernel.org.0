Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEB36B1D9B
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 09:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjCIINM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 03:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjCIIM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 03:12:26 -0500
Received: from andre.telenet-ops.be (andre.telenet-ops.be [IPv6:2a02:1800:120:4::f00:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F72DE20F3
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 00:10:39 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:614d:21b0:703:d0f9])
        by andre.telenet-ops.be with bizsmtp
        id W8AP2900J3mNwr4018AP4q; Thu, 09 Mar 2023 09:10:24 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1paBLR-00BJmB-6k;
        Thu, 09 Mar 2023 09:10:23 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1paBLz-00FzFi-OT;
        Thu, 09 Mar 2023 09:10:23 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vincent Mailhol <vincent.mailhol@gmail.com>
Subject: [PATCH] can: rcar_canfd: Print mnemotechnic error codes
Date:   Thu,  9 Mar 2023 09:10:22 +0100
Message-Id: <8a39f99fc28967134826dff141b51a5df824b034.1678349267.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace printed numerical error codes by mnemotechnic error codes, to
improve the user experience in case of errors.

While at it, drop printing of an error message in case of out-of-memory,
as the core memory allocation code already takes care of this.

Suggested-by: Vincent Mailhol <vincent.mailhol@gmail.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
This depends on "[PATCH v2] can: rcar_canfd: Add transceiver support"
https://lore.kernel.org/r/e825b50a843ffe40e33f34e4d858c07c1b2ff259.1678280913.git.geert+renesas@glider.be
---
 drivers/net/can/rcar/rcar_canfd.c | 43 +++++++++++++++----------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 6df9a259e5e4f92c..bc75da349676d867 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1417,20 +1417,20 @@ static int rcar_canfd_open(struct net_device *ndev)
 
 	err = phy_power_on(priv->transceiver);
 	if (err) {
-		netdev_err(ndev, "failed to power on PHY, error %d\n", err);
+		netdev_err(ndev, "failed to power on PHY, %pe\n", ERR_PTR(err));
 		return err;
 	}
 
 	/* Peripheral clock is already enabled in probe */
 	err = clk_prepare_enable(gpriv->can_clk);
 	if (err) {
-		netdev_err(ndev, "failed to enable CAN clock, error %d\n", err);
+		netdev_err(ndev, "failed to enable CAN clock, %pe\n", ERR_PTR(err));
 		goto out_phy;
 	}
 
 	err = open_candev(ndev);
 	if (err) {
-		netdev_err(ndev, "open_candev() failed, error %d\n", err);
+		netdev_err(ndev, "open_candev() failed, %pe\n", ERR_PTR(err));
 		goto out_can_clock;
 	}
 
@@ -1731,10 +1731,9 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	int err = -ENODEV;
 
 	ndev = alloc_candev(sizeof(*priv), RCANFD_FIFO_DEPTH);
-	if (!ndev) {
-		dev_err(dev, "alloc_candev() failed\n");
+	if (!ndev)
 		return -ENOMEM;
-	}
+
 	priv = netdev_priv(ndev);
 
 	ndev->netdev_ops = &rcar_canfd_netdev_ops;
@@ -1777,8 +1776,8 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 				       rcar_canfd_channel_err_interrupt, 0,
 				       irq_name, priv);
 		if (err) {
-			dev_err(dev, "devm_request_irq CH Err(%d) failed, error %d\n",
-				err_irq, err);
+			dev_err(dev, "devm_request_irq CH Err(%d) failed, %pe\n",
+				err_irq, ERR_PTR(err));
 			goto fail;
 		}
 		irq_name = devm_kasprintf(dev, GFP_KERNEL, "canfd.ch%d_trx",
@@ -1791,8 +1790,8 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 				       rcar_canfd_channel_tx_interrupt, 0,
 				       irq_name, priv);
 		if (err) {
-			dev_err(dev, "devm_request_irq Tx (%d) failed, error %d\n",
-				tx_irq, err);
+			dev_err(dev, "devm_request_irq Tx (%d) failed, %pe\n",
+				tx_irq, ERR_PTR(err));
 			goto fail;
 		}
 	}
@@ -1823,7 +1822,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	gpriv->ch[priv->channel] = priv;
 	err = register_candev(ndev);
 	if (err) {
-		dev_err(dev, "register_candev() failed, error %d\n", err);
+		dev_err(dev, "register_candev() failed, %pe\n", ERR_PTR(err));
 		goto fail_candev;
 	}
 	dev_info(dev, "device registered (channel %u)\n", priv->channel);
@@ -1967,16 +1966,16 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 				       rcar_canfd_channel_interrupt, 0,
 				       "canfd.ch_int", gpriv);
 		if (err) {
-			dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
-				ch_irq, err);
+			dev_err(dev, "devm_request_irq(%d) failed, %pe\n",
+				ch_irq, ERR_PTR(err));
 			goto fail_dev;
 		}
 
 		err = devm_request_irq(dev, g_irq, rcar_canfd_global_interrupt,
 				       0, "canfd.g_int", gpriv);
 		if (err) {
-			dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
-				g_irq, err);
+			dev_err(dev, "devm_request_irq(%d) failed, %pe\n",
+				g_irq, ERR_PTR(err));
 			goto fail_dev;
 		}
 	} else {
@@ -1985,8 +1984,8 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 				       "canfd.g_recc", gpriv);
 
 		if (err) {
-			dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
-				g_recc_irq, err);
+			dev_err(dev, "devm_request_irq(%d) failed, %pe\n",
+				g_recc_irq, ERR_PTR(err));
 			goto fail_dev;
 		}
 
@@ -1994,8 +1993,8 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 				       rcar_canfd_global_err_interrupt, 0,
 				       "canfd.g_err", gpriv);
 		if (err) {
-			dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
-				g_err_irq, err);
+			dev_err(dev, "devm_request_irq(%d) failed, %pe\n",
+				g_err_irq, ERR_PTR(err));
 			goto fail_dev;
 		}
 	}
@@ -2012,14 +2011,14 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	/* Enable peripheral clock for register access */
 	err = clk_prepare_enable(gpriv->clkp);
 	if (err) {
-		dev_err(dev, "failed to enable peripheral clock, error %d\n",
-			err);
+		dev_err(dev, "failed to enable peripheral clock, %pe\n",
+			ERR_PTR(err));
 		goto fail_reset;
 	}
 
 	err = rcar_canfd_reset_controller(gpriv);
 	if (err) {
-		dev_err(dev, "reset controller failed\n");
+		dev_err(dev, "reset controller failed, %pe\n", ERR_PTR(err));
 		goto fail_clk;
 	}
 
-- 
2.34.1

