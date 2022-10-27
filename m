Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436CA60F235
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 10:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbiJ0IWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 04:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234952AbiJ0IW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 04:22:29 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E5856744F;
        Thu, 27 Oct 2022 01:22:25 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,217,1661785200"; 
   d="scan'208";a="138124204"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 27 Oct 2022 17:22:25 +0900
Received: from localhost.localdomain (unknown [10.226.93.45])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 01B874048F22;
        Thu, 27 Oct 2022 17:22:19 +0900 (JST)
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
Subject: [PATCH v3 3/6] can: rcar_canfd: Add shared_global_irqs to struct rcar_canfd_hw_info
Date:   Thu, 27 Oct 2022 09:21:55 +0100
Message-Id: <20221027082158.95895-4-biju.das.jz@bp.renesas.com>
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

RZ/G2L has separate IRQ lines for receive FIFO and global error interrupt
whereas R-Car has shared IRQ line.

Add shared_global_irqs to struct rcar_canfd_hw_info to select the driver to
choose between shared and separate irq registration for global
interrupts.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2->v3:
 * No change
v1->v2:
 * Replaced multi_global_irqs->shared_global_irqs to make it
   positive checks.
 * Added Rb tag from Geert.
---
 drivers/net/can/rcar/rcar_canfd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 255cb0825f13..c8d44dc36515 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -526,6 +526,8 @@ struct rcar_canfd_global;
 struct rcar_canfd_hw_info {
 	enum rcanfd_chip_id chip_id;
 	u8 max_channels;
+	/* hardware features */
+	unsigned shared_global_irqs:1;	/* Has shared global irqs */
 };
 
 /* Channel priv data */
@@ -598,6 +600,7 @@ static const struct can_bittiming_const rcar_canfd_bittiming_const = {
 static const struct rcar_canfd_hw_info rcar_gen3_hw_info = {
 	.chip_id = RENESAS_RCAR_GEN3,
 	.max_channels = 2,
+	.shared_global_irqs = 1,
 };
 
 static const struct rcar_canfd_hw_info rzg2l_hw_info = {
@@ -608,6 +611,7 @@ static const struct rcar_canfd_hw_info rzg2l_hw_info = {
 static const struct rcar_canfd_hw_info r8a779a0_hw_info = {
 	.chip_id = RENESAS_R8A779A0,
 	.max_channels = 8,
+	.shared_global_irqs = 1,
 };
 
 /* Helper functions */
@@ -1868,7 +1872,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 		of_node_put(of_child);
 	}
 
-	if (info->chip_id != RENESAS_RZG2L) {
+	if (info->shared_global_irqs) {
 		ch_irq = platform_get_irq_byname_optional(pdev, "ch_int");
 		if (ch_irq < 0) {
 			/* For backward compatibility get irq by index */
@@ -1951,7 +1955,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->base = addr;
 
 	/* Request IRQ that's common for both channels */
-	if (info->chip_id != RENESAS_RZG2L) {
+	if (info->shared_global_irqs) {
 		err = devm_request_irq(&pdev->dev, ch_irq,
 				       rcar_canfd_channel_interrupt, 0,
 				       "canfd.ch_int", gpriv);
-- 
2.25.1

