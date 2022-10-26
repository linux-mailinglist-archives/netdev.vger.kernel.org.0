Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8043B60E1F1
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbiJZNTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbiJZNTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:19:01 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2BE2100BD5;
        Wed, 26 Oct 2022 06:18:15 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,214,1661785200"; 
   d="scan'208";a="140456063"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 26 Oct 2022 22:18:15 +0900
Received: from localhost.localdomain (unknown [10.226.92.188])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id E81AE4255D31;
        Wed, 26 Oct 2022 22:18:09 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 6/6] can: rcar_canfd: Add has_gerfl_eef to struct rcar_canfd_hw_info
Date:   Wed, 26 Oct 2022 14:17:32 +0100
Message-Id: <20221026131732.1843105-7-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026131732.1843105-1-biju.das.jz@bp.renesas.com>
References: <20221026131732.1843105-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car has ECC error flags in global error interrupts whereas it is
not available on RZ/G2L.

Add has_gerfl_eef to struct rcar_canfd_hw_info so that rcar_canfd_
global_error() will process ECC errors only for R-Car.

whilst, this patch fixes the below checkpatch warnings
  CHECK: Unnecessary parentheses around 'ch == 0'
  CHECK: Unnecessary parentheses around 'ch == 1'

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v1->v2:
 * Replaced info->has_gerfl to gpriv->info->has_gerfl and wrapped
   the ECC error flag check within single if statement.
---
 drivers/net/can/rcar/rcar_canfd.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 20d434eef639..0bb0ed65ea8c 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -523,6 +523,7 @@ struct rcar_canfd_hw_info {
 	/* hardware features */
 	unsigned shared_global_irqs:1;	/* Has shared global irqs */
 	unsigned multi_channel_irqs:1;	/* Has multiple channel irqs */
+	unsigned has_gerfl_eef:1;	/* Has ECC Error Flag */
 };
 
 /* Channel priv data */
@@ -596,6 +597,7 @@ static const struct rcar_canfd_hw_info rcar_gen3_hw_info = {
 	.max_channels = 2,
 	.postdiv = 2,
 	.shared_global_irqs = 1,
+	.has_gerfl_eef = 1,
 };
 
 static const struct rcar_canfd_hw_info rzg2l_hw_info = {
@@ -608,6 +610,7 @@ static const struct rcar_canfd_hw_info r8a779a0_hw_info = {
 	.max_channels = 8,
 	.postdiv = 2,
 	.shared_global_irqs = 1,
+	.has_gerfl_eef = 1,
 };
 
 /* Helper functions */
@@ -955,13 +958,15 @@ static void rcar_canfd_global_error(struct net_device *ndev)
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
 
 	gerfl = rcar_canfd_read(priv->base, RCANFD_GERFL);
-	if ((gerfl & RCANFD_GERFL_EEF0) && (ch == 0)) {
-		netdev_dbg(ndev, "Ch0: ECC Error flag\n");
-		stats->tx_dropped++;
-	}
-	if ((gerfl & RCANFD_GERFL_EEF1) && (ch == 1)) {
-		netdev_dbg(ndev, "Ch1: ECC Error flag\n");
-		stats->tx_dropped++;
+	if (gpriv->info->has_gerfl_eef) {
+		if ((gerfl & RCANFD_GERFL_EEF0) && ch == 0) {
+			netdev_dbg(ndev, "Ch0: ECC Error flag\n");
+			stats->tx_dropped++;
+		}
+		if ((gerfl & RCANFD_GERFL_EEF1) && ch == 1) {
+			netdev_dbg(ndev, "Ch1: ECC Error flag\n");
+			stats->tx_dropped++;
+		}
 	}
 	if (gerfl & RCANFD_GERFL_MES) {
 		sts = rcar_canfd_read(priv->base,
-- 
2.25.1

