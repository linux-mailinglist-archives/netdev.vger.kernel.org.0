Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A93A60D120
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 17:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbiJYP5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 11:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbiJYP50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 11:57:26 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C03B917D842;
        Tue, 25 Oct 2022 08:57:24 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,212,1661785200"; 
   d="scan'208";a="140317241"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 26 Oct 2022 00:57:24 +0900
Received: from localhost.localdomain (unknown [10.226.92.152])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 82E7140029CE;
        Wed, 26 Oct 2022 00:57:18 +0900 (JST)
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
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 3/3] can: rcar_canfd: Use devm_reset_control_get_optional_exclusive
Date:   Tue, 25 Oct 2022 16:56:57 +0100
Message-Id: <20221025155657.1426948-4-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221025155657.1426948-1-biju.das.jz@bp.renesas.com>
References: <20221025155657.1426948-1-biju.das.jz@bp.renesas.com>
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
v1->v2:
 * No change.
---
 drivers/net/can/rcar/rcar_canfd.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 198da643ee6d..a0dd6044830b 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1887,17 +1887,17 @@ static int rcar_canfd_probe(struct platform_device *pdev)
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

