Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5F460F23E
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 10:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbiJ0IWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 04:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbiJ0IWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 04:22:39 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8696161735;
        Thu, 27 Oct 2022 01:22:37 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,217,1661785200"; 
   d="scan'208";a="140573944"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 27 Oct 2022 17:22:37 +0900
Received: from localhost.localdomain (unknown [10.226.93.45])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id BD4334048F22;
        Thu, 27 Oct 2022 17:22:31 +0900 (JST)
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
Subject: [PATCH v3 5/6] can: rcar_canfd: Add multi_channel_irqs to struct rcar_canfd_hw_info
Date:   Thu, 27 Oct 2022 09:21:57 +0100
Message-Id: <20221027082158.95895-6-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221027082158.95895-1-biju.das.jz@bp.renesas.com>
References: <20221027082158.95895-1-biju.das.jz@bp.renesas.com>
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
v2->v3:
 * No change.
v1->v2:
 * Added Rb tag from Geert.
---
 drivers/net/can/rcar/rcar_canfd.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index bc5df7a39f91..f8eafb132b39 100644
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
 	u8 max_channels;
 	u8 postdiv;
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

