Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92DA24E798F
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 18:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356797AbiCYRBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 13:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiCYRBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 13:01:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5B34D264
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 10:00:09 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nXnIB-0006eD-RG; Fri, 25 Mar 2022 18:00:03 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nXnI7-002vJa-NB; Fri, 25 Mar 2022 18:00:02 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nXnI9-00BbnE-Dw; Fri, 25 Mar 2022 18:00:01 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH net-next] net: fec: Do proper error checking for enet_out clk
Date:   Fri, 25 Mar 2022 17:55:43 +0100
Message-Id: <20220325165543.33963-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1322; h=from:subject; bh=HcZQdpdharJBJZDf5TyHdiOeya4QfJRqSwv+Bv3qV8Q=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBiPfQKUaJm9HNdJ2GZHoQ1dkxoGwhYxioYRuPWpbzL IAEXw+CJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYj30CgAKCRDB/BR4rcrsCTauB/ 0QYscFM5rRh1qK1uYClRbzBR8e/MuHi0hfBzyEWBCRR4jANwqAjkBy+tp1NUzLm3WCk9t/Bc80Hv93 Eeca27CmIE7XjyR9OBzwqZGrEgS8Woof5R0pce+wSM4vNBiS+Z+yu00Q3+hc2XDnRdVPINwk1RmHUq vSha9cB7gZQQKEh8gf4RvaTgedLkc75QtILt+vOvOJEw6ImU+Hm+uk2YSBVdmQXnalD9F7gPYrO4o6 9m/esGD9u26tupPdiptBbouI4LySXo6/8C9cBZh/y1sO8IEB9/iaFY6J1jh/3A1ms1jUxof3t15q3Z FQYWF3zf4JjQCH9MDSv2o8hgXhH3fP
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

this isn't urgent and doesn't fix a problem I encountered, just noticed
this patch opportunity while looking up something different in the
driver.

Best regards
Uwe

 drivers/net/ethernet/freescale/fec_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 796133de527e..b0500ecd4ee8 100644
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
-- 
2.35.1

