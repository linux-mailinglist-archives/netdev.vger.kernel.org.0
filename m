Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFF15B9616
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiIOIU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiIOIUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:20:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCB995ACA
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 01:20:21 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oYk6d-0004Ap-BZ
        for netdev@vger.kernel.org; Thu, 15 Sep 2022 10:20:19 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id DFD3CE395D
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:20:16 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 74817E392B;
        Thu, 15 Sep 2022 08:20:15 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2575f472;
        Thu, 15 Sep 2022 08:20:14 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 03/23] can: rcar_canfd: Use dev_err_probe() to simplify code and better handle -EPROBE_DEFER
Date:   Thu, 15 Sep 2022 10:19:53 +0200
Message-Id: <20220915082013.369072-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220915082013.369072-1-mkl@pengutronix.de>
References: <20220915082013.369072-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

devm_clk_get() can return -EPROBE_DEFER, so use dev_err_probe() instead of
dev_err() in order to be less verbose in the log.

This also saves a few LoC.

While at it, turn a "goto fail_dev;" at the beginning of the function into
a direct return in order to avoid mixing goto and return, which looks
spurious.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/all/f5bf0b8f757bd3bc9b391094ece3548cc2f96456.1659858686.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 27085b796e75..567620d215f8 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1880,10 +1880,9 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 
 	/* Global controller context */
 	gpriv = devm_kzalloc(&pdev->dev, sizeof(*gpriv), GFP_KERNEL);
-	if (!gpriv) {
-		err = -ENOMEM;
-		goto fail_dev;
-	}
+	if (!gpriv)
+		return -ENOMEM;
+
 	gpriv->pdev = pdev;
 	gpriv->channels_mask = channels_mask;
 	gpriv->fdmode = fdmode;
@@ -1904,12 +1903,9 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 
 	/* Peripheral clock */
 	gpriv->clkp = devm_clk_get(&pdev->dev, "fck");
-	if (IS_ERR(gpriv->clkp)) {
-		err = PTR_ERR(gpriv->clkp);
-		dev_err(&pdev->dev, "cannot get peripheral clock, error %d\n",
-			err);
-		goto fail_dev;
-	}
+	if (IS_ERR(gpriv->clkp))
+		return dev_err_probe(&pdev->dev, PTR_ERR(gpriv->clkp),
+				     "cannot get peripheral clock\n");
 
 	/* fCAN clock: Pick External clock. If not available fallback to
 	 * CANFD clock
@@ -1917,12 +1913,10 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->can_clk = devm_clk_get(&pdev->dev, "can_clk");
 	if (IS_ERR(gpriv->can_clk) || (clk_get_rate(gpriv->can_clk) == 0)) {
 		gpriv->can_clk = devm_clk_get(&pdev->dev, "canfd");
-		if (IS_ERR(gpriv->can_clk)) {
-			err = PTR_ERR(gpriv->can_clk);
-			dev_err(&pdev->dev,
-				"cannot get canfd clock, error %d\n", err);
-			goto fail_dev;
-		}
+		if (IS_ERR(gpriv->can_clk))
+			return dev_err_probe(&pdev->dev, PTR_ERR(gpriv->can_clk),
+					     "cannot get canfd clock\n");
+
 		gpriv->fcan = RCANFD_CANFDCLK;
 
 	} else {
-- 
2.35.1


