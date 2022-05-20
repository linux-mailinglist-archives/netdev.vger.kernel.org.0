Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C9152E4F2
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 08:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344776AbiETG1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 02:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiETG1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 02:27:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D4B14AF4D
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 23:27:04 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nrw6E-0003qm-7M; Fri, 20 May 2022 08:26:58 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nrw6D-003QqE-9F; Fri, 20 May 2022 08:26:55 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nrw6B-00Av1e-BT; Fri, 20 May 2022 08:26:55 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        kernel@pengutronix.de
Subject: [PATCH net-next RESEND] net: fec: Do proper error checking for enet_out clk
Date:   Fri, 20 May 2022 08:26:50 +0200
Message-Id: <20220520062650.712561-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1541; h=from:subject; bh=OPF9V1Ztruy288pNnTt/i0bKCBHX+pMLTLcWrJXLtBQ=; b=owGbwMvMwMV48I9IxdpTbzgZT6slMSS1myxfmGU+jcX9UsJdzsVqaU+bk8vPV3yYVf+8Qch+07Fb TALbOhmNWRgYuRhkxRRZ6oq0xCZIrPlvV7KEG2YQKxPIFAYuTgGYyCN/9v++W7/EpYhXiot8ca40c5 JQVeyc8eKMbsr35k1mhiL/8hmjXpUtFqmc9/lNyEwRxdy+/oCgLfvKpnAxX5csexM3dX3Fy3eb9Jum f2lLmcAc+UHoreuljo1cycmfnPaZ3XRnetJ90Vkr6xS/BVvctJPRnMkpnpZTTqxSDov98uzc5yn+u6 sncpesU19daDTzfm6WbeDDlj9z22qXP/Vd/7q1uKPuYdaRUIaZjyxdXkWmFvc/9pwSc6yB/V/09K4D hyMWiDAGfglS0T9SIv7IxFZb5Mp7zqvLxZysW64ytjMLJGl9Xc1RtLUszMbrLk+myPXcqOVL+n3q2t LXMPrezci2/vrH5HLhSpYP3qoSAA==
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An error code returned by devm_clk_get() might have other meanings than
"This clock doesn't exist". So use devm_clk_get_optional() and handle
all remaining errors as fatal.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

I sent this back in March and was asked to resend after the merge window
closed. Actually I intended to do this earlier, but it got lost in my
todo list and I found it just now. (And after all it is still after the
merge window and http://vger.kernel.org/~davem/net-next.html claims it's
still time ... :-)

Best regards
Uwe

 drivers/net/ethernet/freescale/fec_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 11227f51404c..2512b68d8545 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3866,9 +3866,11 @@ fec_probe(struct platform_device *pdev)
 	fep->itr_clk_rate = clk_get_rate(fep->clk_ahb);
 
 	/* enet_out is optional, depends on board */
-	fep->clk_enet_out = devm_clk_get(&pdev->dev, "enet_out");
-	if (IS_ERR(fep->clk_enet_out))
-		fep->clk_enet_out = NULL;
+	fep->clk_enet_out = devm_clk_get_optional(&pdev->dev, "enet_out");
+	if (IS_ERR(fep->clk_enet_out)) {
+		ret = PTR_ERR(fep->clk_enet_out);
+		goto failed_clk;
+	}
 
 	fep->ptp_clk_on = false;
 	mutex_init(&fep->ptp_clk_mutex);

base-commit: 3123109284176b1532874591f7c81f3837bbdc17
-- 
2.35.1

