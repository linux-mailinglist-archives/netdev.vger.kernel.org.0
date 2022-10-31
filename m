Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF07A61392E
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 15:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiJaOn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 10:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiJaOn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 10:43:26 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8B36DEA0;
        Mon, 31 Oct 2022 07:43:24 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,228,1661785200"; 
   d="scan'208";a="141010567"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 31 Oct 2022 23:43:24 +0900
Received: from localhost.localdomain (unknown [10.226.92.171])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 15E7840078A9;
        Mon, 31 Oct 2022 23:43:19 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        gregkh@linuxfoundation.org, Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Pavel Machek <pavel@denx.de>, Sasha Levin <sashal@kernel.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <chris.paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] can: rcar_canfd: fix channel specific IRQ handling for RZ/G2L
Date:   Mon, 31 Oct 2022 14:43:17 +0000
Message-Id: <20221031144317.963903-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit d887087c896881715c1a82f1d4f71fbfe5344ffd upstream.

RZ/G2L has separate channel specific IRQs for transmit and error
interrupts. But the IRQ handler processes both channels, even if there
no interrupt occurred on one of the channels.

This patch fixes the issue by passing a channel specific context
parameter instead of global one for the IRQ register and the IRQ
handler, it just handles the channel which is triggered the interrupt.

Fixes: 76e9353a80e9 ("can: rcar_canfd: Add support for RZ/G2L family")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/all/20221025155657.1426948-3-biju.das.jz@bp.renesas.com
Cc: stable@vger.kernel.org
[mkl: adjust commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[biju: fixed the conflicts manually]
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
Resending to 5.15 with conflicts[1] fixed
[1] https://lore.kernel.org/stable/1667194217249235@kroah.com/T/#u
---
 drivers/net/can/rcar/rcar_canfd.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 9991bb475ae1..4e230e145664 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1197,11 +1197,9 @@ static void rcar_canfd_handle_channel_tx(struct rcar_canfd_global *gpriv, u32 ch
 
 static irqreturn_t rcar_canfd_channel_tx_interrupt(int irq, void *dev_id)
 {
-	struct rcar_canfd_global *gpriv = dev_id;
-	u32 ch;
+	struct rcar_canfd_channel *priv = dev_id;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
-		rcar_canfd_handle_channel_tx(gpriv, ch);
+	rcar_canfd_handle_channel_tx(priv->gpriv, priv->channel);
 
 	return IRQ_HANDLED;
 }
@@ -1229,11 +1227,9 @@ static void rcar_canfd_handle_channel_err(struct rcar_canfd_global *gpriv, u32 c
 
 static irqreturn_t rcar_canfd_channel_err_interrupt(int irq, void *dev_id)
 {
-	struct rcar_canfd_global *gpriv = dev_id;
-	u32 ch;
+	struct rcar_canfd_channel *priv = dev_id;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
-		rcar_canfd_handle_channel_err(gpriv, ch);
+	rcar_canfd_handle_channel_err(priv->gpriv, priv->channel);
 
 	return IRQ_HANDLED;
 }
@@ -1651,6 +1647,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	priv->ndev = ndev;
 	priv->base = gpriv->base;
 	priv->channel = ch;
+	priv->gpriv = gpriv;
 	priv->can.clock.freq = fcan_freq;
 	dev_info(&pdev->dev, "can_clk rate is %u\n", priv->can.clock.freq);
 
@@ -1679,7 +1676,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 		}
 		err = devm_request_irq(&pdev->dev, err_irq,
 				       rcar_canfd_channel_err_interrupt, 0,
-				       irq_name, gpriv);
+				       irq_name, priv);
 		if (err) {
 			dev_err(&pdev->dev, "devm_request_irq CH Err(%d) failed, error %d\n",
 				err_irq, err);
@@ -1693,7 +1690,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 		}
 		err = devm_request_irq(&pdev->dev, tx_irq,
 				       rcar_canfd_channel_tx_interrupt, 0,
-				       irq_name, gpriv);
+				       irq_name, priv);
 		if (err) {
 			dev_err(&pdev->dev, "devm_request_irq Tx (%d) failed, error %d\n",
 				tx_irq, err);
@@ -1717,7 +1714,6 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 
 	priv->can.do_set_mode = rcar_canfd_do_set_mode;
 	priv->can.do_get_berr_counter = rcar_canfd_get_berr_counter;
-	priv->gpriv = gpriv;
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	netif_napi_add(ndev, &priv->napi, rcar_canfd_rx_poll,
-- 
2.25.1

