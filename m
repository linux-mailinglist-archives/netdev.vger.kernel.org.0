Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D9F58BA1F
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 09:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbiHGHwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 03:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiHGHwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 03:52:18 -0400
Received: from smtp.smtpout.orange.fr (smtp06.smtpout.orange.fr [80.12.242.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5725BF59C
        for <netdev@vger.kernel.org>; Sun,  7 Aug 2022 00:52:17 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id Kb52oyREZ5V1hKb53o3EZs; Sun, 07 Aug 2022 09:52:15 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 07 Aug 2022 09:52:15 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] can: rcar_canfd: Use dev_err_probe() to simplify code and better handle -EPROBE_DEFER
Date:   Sun,  7 Aug 2022 09:52:11 +0200
Message-Id: <f5bf0b8f757bd3bc9b391094ece3548cc2f96456.1659858686.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devm_clk_get() can return -EPROBE_DEFER, so use dev_err_probe() instead of
dev_err() in order to be less verbose in the log.

This also saves a few LoC.

While at it, turn a "goto fail_dev;" at the beginning of the function into
a direct return in order to avoid mixing goto and return, which looks
spurious.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
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
2.34.1

