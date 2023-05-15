Return-Path: <netdev+bounces-2793-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88E6F703F31
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 23:02:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B0091C20D1F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 21:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 030BA1DDD0;
	Mon, 15 May 2023 20:58:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96231DDCC
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:58:46 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0842D100C5
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:58:32 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pyfGn-0006pU-87
	for netdev@vger.kernel.org; Mon, 15 May 2023 22:58:13 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
	by bjornoya.blackshift.org (Postfix) with SMTP id 6A4671C5D44
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:58:06 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bjornoya.blackshift.org (Postfix) with ESMTPS id 123521C5CE0;
	Mon, 15 May 2023 20:58:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
	by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 07de9716;
	Mon, 15 May 2023 20:58:02 +0000 (UTC)
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	linux-can@vger.kernel.org,
	kernel@pengutronix.de,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 13/22] can: janz-ican3: Convert to platform remove callback returning void
Date: Mon, 15 May 2023 22:57:50 +0200
Message-Id: <20230515205759.1003118-14-mkl@pengutronix.de>
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

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230512212725.143824-11-u.kleine-koenig@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/janz-ican3.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 0732a5092141..d048ea565b89 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -2023,7 +2023,7 @@ static int ican3_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int ican3_remove(struct platform_device *pdev)
+static void ican3_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct ican3_dev *mod = netdev_priv(ndev);
@@ -2042,8 +2042,6 @@ static int ican3_remove(struct platform_device *pdev)
 	iounmap(mod->dpm);
 
 	free_candev(ndev);
-
-	return 0;
 }
 
 static struct platform_driver ican3_driver = {
@@ -2051,7 +2049,7 @@ static struct platform_driver ican3_driver = {
 		.name	= DRV_NAME,
 	},
 	.probe		= ican3_probe,
-	.remove		= ican3_remove,
+	.remove_new	= ican3_remove,
 };
 
 module_platform_driver(ican3_driver);
-- 
2.39.2



