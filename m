Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032C1608B7D
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 12:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiJVKWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 06:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiJVKVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 06:21:39 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3AB9E4C2DA;
        Sat, 22 Oct 2022 02:38:01 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,204,1661785200"; 
   d="scan'208";a="137536315"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 22 Oct 2022 17:34:13 +0900
Received: from localhost.localdomain (unknown [10.226.92.14])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id C94014006185;
        Sat, 22 Oct 2022 17:34:07 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 3/3] can: rcar_canfd: Use devm_reset_control_get_optional_exclusive
Date:   Sat, 22 Oct 2022 09:15:03 +0100
Message-Id: <20221022081503.1051257-4-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
References: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace devm_reset_control_get_exclusive->devm_reset_control_
get_optional_exclusive so that we can avoid unnecessary
SoC specific check in probe().

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/can/rcar/rcar_canfd.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 38d6a8f5691c..4b12ed85deca 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1893,17 +1893,17 @@ static int rcar_canfd_probe(struct platform_device *pdev)
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
2.25.1

