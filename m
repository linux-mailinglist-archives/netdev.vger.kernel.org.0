Return-Path: <netdev+bounces-2802-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B6F6703F4D
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 23:05:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 500191C20D7A
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 21:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D4A4200B1;
	Mon, 15 May 2023 20:58:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916681F16B
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:58:55 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB51FA5FF
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:58:40 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pyfGq-0006u9-UU
	for netdev@vger.kernel.org; Mon, 15 May 2023 22:58:17 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
	by bjornoya.blackshift.org (Postfix) with SMTP id CDB681C5D6F
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:58:08 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bjornoya.blackshift.org (Postfix) with ESMTPS id 89E4E1C5CF0;
	Mon, 15 May 2023 20:58:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
	by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 18a7f391;
	Mon, 15 May 2023 20:58:02 +0000 (UTC)
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	linux-can@vger.kernel.org,
	kernel@pengutronix.de,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 16/22] can: rcar: Convert to platform remove callback returning void
Date: Mon, 15 May 2023 22:57:53 +0200
Message-Id: <20230515205759.1003118-17-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230515205759.1003118-1-mkl@pengutronix.de>
References: <20230515205759.1003118-1-mkl@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart from
emitting a warning) and this typically results in resource leaks. To improve
here there is a quest to make the remove callback return void. In the first
step of this quest all drivers are converted to .remove_new() which already
returns void. Eventually after all drivers are converted, .remove_new() is
renamed to .remove().

Trivially convert these drivers from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230512212725.143824-14-u.kleine-koenig@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_can.c   | 5 ++---
 drivers/net/can/rcar/rcar_canfd.c | 6 ++----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index cc43c9c5e38c..f5aa5dbacaf2 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -824,7 +824,7 @@ static int rcar_can_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int rcar_can_remove(struct platform_device *pdev)
+static void rcar_can_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct rcar_can_priv *priv = netdev_priv(ndev);
@@ -832,7 +832,6 @@ static int rcar_can_remove(struct platform_device *pdev)
 	unregister_candev(ndev);
 	netif_napi_del(&priv->napi);
 	free_candev(ndev);
-	return 0;
 }
 
 static int __maybe_unused rcar_can_suspend(struct device *dev)
@@ -908,7 +907,7 @@ static struct platform_driver rcar_can_driver = {
 		.pm = &rcar_can_pm_ops,
 	},
 	.probe = rcar_can_probe,
-	.remove = rcar_can_remove,
+	.remove_new = rcar_can_remove,
 };
 
 module_platform_driver(rcar_can_driver);
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 963c42f43755..e4d748913439 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -2078,7 +2078,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int rcar_canfd_remove(struct platform_device *pdev)
+static void rcar_canfd_remove(struct platform_device *pdev)
 {
 	struct rcar_canfd_global *gpriv = platform_get_drvdata(pdev);
 	u32 ch;
@@ -2096,8 +2096,6 @@ static int rcar_canfd_remove(struct platform_device *pdev)
 	clk_disable_unprepare(gpriv->clkp);
 	reset_control_assert(gpriv->rstc1);
 	reset_control_assert(gpriv->rstc2);
-
-	return 0;
 }
 
 static int __maybe_unused rcar_canfd_suspend(struct device *dev)
@@ -2130,7 +2128,7 @@ static struct platform_driver rcar_canfd_driver = {
 		.pm = &rcar_canfd_pm_ops,
 	},
 	.probe = rcar_canfd_probe,
-	.remove = rcar_canfd_remove,
+	.remove_new = rcar_canfd_remove,
 };
 
 module_platform_driver(rcar_canfd_driver);
-- 
2.39.2



