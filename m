Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADA1608C9F
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 13:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiJVL2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 07:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJVL2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 07:28:07 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2A9E2F3E54;
        Sat, 22 Oct 2022 04:03:01 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,205,1661785200"; 
   d="scan'208";a="137542112"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 22 Oct 2022 20:03:01 +0900
Received: from localhost.localdomain (unknown [10.226.92.14])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 33CD3400619B;
        Sat, 22 Oct 2022 20:02:55 +0900 (JST)
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
Subject: [PATCH 3/6] can: rcar_canfd: Add multi_global_irqs to struct rcar_canfd_hw_info
Date:   Sat, 22 Oct 2022 11:43:54 +0100
Message-Id: <20221022104357.1276740-4-biju.das.jz@bp.renesas.com>
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

RZ/G2L has separate IRQ lines for receive FIFO and global error interrupt
whereas R-Car has combined IRQ line.

Add multi_global_irqs to struct rcar_canfd_hw_info to select the driver to
choose between combined and separate irq registration for global
interrupts.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/can/rcar/rcar_canfd.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index ecd7c0df2ded..0d131694c241 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -526,6 +526,8 @@ struct rcar_canfd_global;
 struct rcar_canfd_hw_info {
 	enum rcanfd_chip_id chip_id;
 	u32 max_channels;
+	/* hardware features */
+	unsigned multi_global_irqs:1;	/* Has multiple global irqs  */
 };
 
 /* Channel priv data */
@@ -603,6 +605,7 @@ static const struct rcar_canfd_hw_info rcar_gen3_hw_info = {
 static const struct rcar_canfd_hw_info rzg2l_hw_info = {
 	.chip_id = RENESAS_RZG2L,
 	.max_channels = 2,
+	.multi_global_irqs = 1,
 };
 
 static const struct rcar_canfd_hw_info r8a779a0_hw_info = {
@@ -1874,7 +1877,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 		of_node_put(of_child);
 	}
 
-	if (info->chip_id != RENESAS_RZG2L) {
+	if (!info->multi_global_irqs) {
 		ch_irq = platform_get_irq_byname_optional(pdev, "ch_int");
 		if (ch_irq < 0) {
 			/* For backward compatibility get irq by index */
@@ -1957,7 +1960,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->base = addr;
 
 	/* Request IRQ that's common for both channels */
-	if (info->chip_id != RENESAS_RZG2L) {
+	if (!info->multi_global_irqs) {
 		err = devm_request_irq(&pdev->dev, ch_irq,
 				       rcar_canfd_channel_interrupt, 0,
 				       "canfd.ch_int", gpriv);
-- 
2.25.1

