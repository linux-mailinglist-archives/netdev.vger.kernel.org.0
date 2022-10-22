Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105F1608CA8
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 13:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiJVL3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 07:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiJVL20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 07:28:26 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC0402F5010;
        Sat, 22 Oct 2022 04:03:19 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,205,1661785200"; 
   d="scan'208";a="137542133"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 22 Oct 2022 20:03:18 +0900
Received: from localhost.localdomain (unknown [10.226.92.14])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id A1FF3400619B;
        Sat, 22 Oct 2022 20:03:13 +0900 (JST)
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
Subject: [PATCH 6/6] can: rcar_canfd: Add has_gerfl_eef to struct rcar_canfd_hw_info
Date:   Sat, 22 Oct 2022 11:43:57 +0100
Message-Id: <20221022104357.1276740-7-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221022104357.1276740-1-biju.das.jz@bp.renesas.com>
References: <20221022104357.1276740-1-biju.das.jz@bp.renesas.com>
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
 drivers/net/can/rcar/rcar_canfd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 0b6f14df2a43..bb825cce8acb 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -523,6 +523,7 @@ struct rcar_canfd_hw_info {
 	unsigned multi_global_irqs:1;	/* Has multiple global irqs  */
 	unsigned clk_postdiv:1;		/* Has CAN clk post divider  */
 	unsigned multi_channel_irqs:1;	/* Has multiple channel irqs  */
+	unsigned has_gerfl_eef:1;	/* Has ECC Error Flag  */
 };
 
 /* Channel priv data */
@@ -595,6 +596,7 @@ static const struct can_bittiming_const rcar_canfd_bittiming_const = {
 static const struct rcar_canfd_hw_info rcar_gen3_hw_info = {
 	.max_channels = 2,
 	.clk_postdiv = 1,
+	.has_gerfl_eef = 1,
 };
 
 static const struct rcar_canfd_hw_info rzg2l_hw_info = {
@@ -606,6 +608,7 @@ static const struct rcar_canfd_hw_info rzg2l_hw_info = {
 static const struct rcar_canfd_hw_info r8a779a0_hw_info = {
 	.max_channels = 8,
 	.clk_postdiv = 1,
+	.has_gerfl_eef = 1,
 };
 
 /* Helper functions */
@@ -947,17 +950,18 @@ static void rcar_canfd_global_error(struct net_device *ndev)
 {
 	struct rcar_canfd_channel *priv = netdev_priv(ndev);
 	struct rcar_canfd_global *gpriv = priv->gpriv;
+	const struct rcar_canfd_hw_info *info = gpriv->info;
 	struct net_device_stats *stats = &ndev->stats;
 	u32 ch = priv->channel;
 	u32 gerfl, sts;
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
 
 	gerfl = rcar_canfd_read(priv->base, RCANFD_GERFL);
-	if ((gerfl & RCANFD_GERFL_EEF0) && (ch == 0)) {
+	if (info->has_gerfl_eef && (gerfl & RCANFD_GERFL_EEF0) && ch == 0) {
 		netdev_dbg(ndev, "Ch0: ECC Error flag\n");
 		stats->tx_dropped++;
 	}
-	if ((gerfl & RCANFD_GERFL_EEF1) && (ch == 1)) {
+	if (info->has_gerfl_eef && (gerfl & RCANFD_GERFL_EEF1) && ch == 1) {
 		netdev_dbg(ndev, "Ch1: ECC Error flag\n");
 		stats->tx_dropped++;
 	}
-- 
2.25.1

