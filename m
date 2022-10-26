Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F85A60E1EE
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbiJZNT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiJZNS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:18:58 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1347C100BCE;
        Wed, 26 Oct 2022 06:18:09 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,214,1661785200"; 
   d="scan'208";a="138011740"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 26 Oct 2022 22:18:09 +0900
Received: from localhost.localdomain (unknown [10.226.92.188])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 1C8574255D2B;
        Wed, 26 Oct 2022 22:18:03 +0900 (JST)
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
Subject: [PATCH v2 5/6] can: rcar_canfd: Add multi_channel_irqs to struct rcar_canfd_hw_info
Date:   Wed, 26 Oct 2022 14:17:31 +0100
Message-Id: <20221026131732.1843105-6-biju.das.jz@bp.renesas.com>
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

RZ/G2L has separate IRQ lines for tx and error interrupt for each
channel whereas R-Car has a combined IRQ line for all the channel
specific tx and error interrupts.

Add multi_channel_irqs to struct rcar_canfd_hw_info to select the
driver to choose between combined and separate irq registration for
channel interrupts. This patch also removes enum rcanfd_chip_id and
chip_id from both struct rcar_canfd_hw_info, as it is unused.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v1->v2:
 * Added Rb tag from Geert.
---
 drivers/net/can/rcar/rcar_canfd.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index cf152a5369f7..20d434eef639 100644
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
 	unsigned int max_channels;
 	unsigned int postdiv;
 	/* hardware features */
 	unsigned shared_global_irqs:1;	/* Has shared global irqs */
+	unsigned multi_channel_irqs:1;	/* Has multiple channel irqs */
 };
 
 /* Channel priv data */
@@ -599,20 +593,18 @@ static const struct can_bittiming_const rcar_canfd_bittiming_const = {
 };
 
 static const struct rcar_canfd_hw_info rcar_gen3_hw_info = {
-	.chip_id = RENESAS_RCAR_GEN3,
 	.max_channels = 2,
 	.postdiv = 2,
 	.shared_global_irqs = 1,
 };
 
 static const struct rcar_canfd_hw_info rzg2l_hw_info = {
-	.chip_id = RENESAS_RZG2L,
-	.postdiv = 1,
 	.max_channels = 2,
+	.postdiv = 1,
+	.multi_channel_irqs = 1,
 };
 
 static const struct rcar_canfd_hw_info r8a779a0_hw_info = {
-	.chip_id = RENESAS_R8A779A0,
 	.max_channels = 8,
 	.postdiv = 2,
 	.shared_global_irqs = 1,
@@ -1751,7 +1743,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	priv->can.clock.freq = fcan_freq;
 	dev_info(&pdev->dev, "can_clk rate is %u\n", priv->can.clock.freq);
 
-	if (info->chip_id == RENESAS_RZG2L) {
+	if (info->multi_channel_irqs) {
 		char *irq_name;
 		int err_irq;
 		int tx_irq;
-- 
2.25.1

