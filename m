Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACAC160DD70
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 10:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbiJZImW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 04:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbiJZIla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 04:41:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A6A50F98
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 01:40:30 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onbxc-000725-SI
        for netdev@vger.kernel.org; Wed, 26 Oct 2022 10:40:28 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 69A5E10A15B
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 08:40:19 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 32AAB10A126;
        Wed, 26 Oct 2022 08:40:17 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2a23a055;
        Wed, 26 Oct 2022 08:40:09 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 29/29] can: rcar_canfd: Use devm_reset_control_get_optional_exclusive
Date:   Wed, 26 Oct 2022 10:40:07 +0200
Message-Id: <20221026084007.1583333-30-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026084007.1583333-1-mkl@pengutronix.de>
References: <20221026084007.1583333-1-mkl@pengutronix.de>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

Replace devm_reset_control_get_exclusive->devm_reset_control_
get_optional_exclusive so that we can avoid unnecessary
SoC specific check in probe().

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/all/20221025155657.1426948-4-biju.das.jz@bp.renesas.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 567620d215f8..9a55a54c4507 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1889,17 +1889,17 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->chip_id = chip_id;
 	gpriv->max_channels = max_channels;
 
-	if (gpriv->chip_id == RENESAS_RZG2L) {
-		gpriv->rstc1 = devm_reset_control_get_exclusive(&pdev->dev, "rstp_n");
-		if (IS_ERR(gpriv->rstc1))
-			return dev_err_probe(&pdev->dev, PTR_ERR(gpriv->rstc1),
-					     "failed to get rstp_n\n");
-
-		gpriv->rstc2 = devm_reset_control_get_exclusive(&pdev->dev, "rstc_n");
-		if (IS_ERR(gpriv->rstc2))
-			return dev_err_probe(&pdev->dev, PTR_ERR(gpriv->rstc2),
-					     "failed to get rstc_n\n");
-	}
+	gpriv->rstc1 = devm_reset_control_get_optional_exclusive(&pdev->dev,
+								 "rstp_n");
+	if (IS_ERR(gpriv->rstc1))
+		return dev_err_probe(&pdev->dev, PTR_ERR(gpriv->rstc1),
+				     "failed to get rstp_n\n");
+
+	gpriv->rstc2 = devm_reset_control_get_optional_exclusive(&pdev->dev,
+								 "rstc_n");
+	if (IS_ERR(gpriv->rstc2))
+		return dev_err_probe(&pdev->dev, PTR_ERR(gpriv->rstc2),
+				     "failed to get rstc_n\n");
 
 	/* Peripheral clock */
 	gpriv->clkp = devm_clk_get(&pdev->dev, "fck");
-- 
2.35.1


