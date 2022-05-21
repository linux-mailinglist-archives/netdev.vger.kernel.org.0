Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB3852FA07
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 10:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238929AbiEUIek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 04:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiEUIek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 04:34:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9AEE7313
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 01:34:38 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nsKZE-0007In-RP; Sat, 21 May 2022 10:34:32 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nsKZD-003dzU-Rq; Sat, 21 May 2022 10:34:30 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nsKZB-00B8r7-Ua; Sat, 21 May 2022 10:34:29 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        kernel@pengutronix.de, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2] net: fec: Do proper error checking for optional clks
Date:   Sat, 21 May 2022 10:34:25 +0200
Message-Id: <20220521083425.787204-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <Yof3/o46wXWXMsKo@lunn.ch>
References: <Yof3/o46wXWXMsKo@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1839; h=from:subject; bh=de8uCmAX3YcCsFx2zZZQCNIvX+BJmChdU2EXMhmt1Ro=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBiiKQNZZFg0f5HIQRVpPMJiiARQmZgG4F7Bkbk5Ee4 UbtEg0aJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYoikDQAKCRDB/BR4rcrsCR4SB/ 9DXgsTTD7dC3RKVzovceN82abyV0gA6ujjfqQHBRcVJGlGs8XHnzmcVF7Q4qI9r0k7pZLNOEqV5J5o jZIQpjD4HUrzczG5KYH54rzR2N4xf3i2QGNujsreoXQdKxKclWg3D0rV0oSmDNtA9VgPtTMj5Fb/43 Ny/qco6UJ+i39k4SUJ4IWdhxWtDvKpMdz7wuslfwlEntT/JRtHOqtFBV0Zq2raQhVyTjOBRB1PrIev zDzpOamTSf3010b9ORp5U6/e/eXfQDWSpsaebXw4presMBwZu9oA2j5y80/+Dtr/MdDtADaCEOcwi1 btHbK7KIEchxbt3P+7YI1tfsSAIXGk
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

as Andrew pointed out, there are two clocks that can benefit from better
error handling during probe. So compared to (implicit) v1 this also
cares for "enet_clk_ref".

Best regards
Uwe

 drivers/net/ethernet/freescale/fec_main.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 11227f51404c..907b379d2c83 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3866,17 +3866,21 @@ fec_probe(struct platform_device *pdev)
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
 
 	/* clk_ref is optional, depends on board */
-	fep->clk_ref = devm_clk_get(&pdev->dev, "enet_clk_ref");
-	if (IS_ERR(fep->clk_ref))
-		fep->clk_ref = NULL;
+	fep->clk_ref = devm_clk_get_optional(&pdev->dev, "enet_clk_ref");
+	if (IS_ERR(fep->clk_ref)) {
+		ret = PTR_ERR(fep->clk_ref);
+		goto failed_clk;
+	}
 	fep->clk_ref_rate = clk_get_rate(fep->clk_ref);
 
 	/* clk_2x_txclk is optional, depends on board */

base-commit: 3123109284176b1532874591f7c81f3837bbdc17
-- 
2.35.1

