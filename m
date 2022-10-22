Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5786608CA5
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 13:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiJVL2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 07:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiJVL2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 07:28:20 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D20C2E532C;
        Sat, 22 Oct 2022 04:03:13 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,205,1661785200"; 
   d="scan'208";a="139955124"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 22 Oct 2022 20:03:13 +0900
Received: from localhost.localdomain (unknown [10.226.92.14])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id D0525400619B;
        Sat, 22 Oct 2022 20:03:07 +0900 (JST)
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
Subject: [PATCH 5/6] can: rcar_canfd: Add multi_channel_irqs to struct rcar_canfd_hw_info
Date:   Sat, 22 Oct 2022 11:43:56 +0100
Message-Id: <20221022104357.1276740-6-biju.das.jz@bp.renesas.com>
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

RZ/G2L has separate IRQ lines for tx and error interrupt for each
channel whereas R-Car has a combined IRQ line for all the channel
specific tx and error interrupts.

Add multi_channel_irqs to struct rcar_canfd_hw_info to select the
driver to choose between combined and separate irq registration for
channel interrupts. This patch also removes enum rcanfd_chip_id and
chip_id from both struct rcar_canfd_hw_info, as it is unused.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/can/rcar/rcar_canfd.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index d226eb59010d..0b6f14df2a43 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -41,12 +41,6 @@
 
 #define RCANFD_DRV_NAME			"rcar_canfd"
 
-enum rcanfd_chip_id {
-	RENESAS_RCAR_GEN3 = 0,
-	RENESAS_RZG2L,
-	RENESAS_R8A779A0,
-};
-
 /* Global register bits */
 
 /* RSCFDnCFDGRMCFG */
@@ -524,11 +518,11 @@ enum rcar_canfd_fcanclk {
 struct rcar_canfd_global;
 
 struct rcar_canfd_hw_info {
-	enum rcanfd_chip_id chip_id;
 	u32 max_channels;
 	/* hardware features */
 	unsigned multi_global_irqs:1;	/* Has multiple global irqs  */
 	unsigned clk_postdiv:1;		/* Has CAN clk post divider  */
+	unsigned multi_channel_irqs:1;	/* Has multiple channel irqs  */
 };
 
 /* Channel priv data */
@@ -599,19 +593,17 @@ static const struct can_bittiming_const rcar_canfd_bittiming_const = {
 };
 
 static const struct rcar_canfd_hw_info rcar_gen3_hw_info = {
-	.chip_id = RENESAS_RCAR_GEN3,
 	.max_channels = 2,
 	.clk_postdiv = 1,
 };
 
 static const struct rcar_canfd_hw_info rzg2l_hw_info = {
-	.chip_id = RENESAS_RZG2L,
 	.max_channels = 2,
 	.multi_global_irqs = 1,
+	.multi_channel_irqs = 1,
 };
 
 static const struct rcar_canfd_hw_info r8a779a0_hw_info = {
-	.chip_id = RENESAS_R8A779A0,
 	.max_channels = 8,
 	.clk_postdiv = 1,
 };
@@ -1755,7 +1747,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	priv->can.clock.freq = fcan_freq;
 	dev_info(&pdev->dev, "can_clk rate is %u\n", priv->can.clock.freq);
 
-	if (info->chip_id == RENESAS_RZG2L) {
+	if (info->multi_channel_irqs) {
 		char *irq_name;
 		int err_irq;
 		int tx_irq;
-- 
2.25.1

