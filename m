Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CBA613221
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiJaJCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiJaJCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:02:35 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87BE865F7;
        Mon, 31 Oct 2022 02:02:33 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,227,1661785200"; 
   d="scan'208";a="138499766"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 31 Oct 2022 18:02:32 +0900
Received: from localhost.localdomain (unknown [10.226.92.171])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 5D22F41D280A;
        Mon, 31 Oct 2022 18:02:28 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        gregkh@linuxfoundation.org, Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Pavel Machek <pavel@denx.de>, Sasha Levin <sashal@kernel.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <chris.paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org,
        #@vger.kernel.org, 4.9.x@vger.kernel.org
Subject: [PATCH] can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive
Date:   Mon, 31 Oct 2022 09:02:25 +0000
Message-Id: <20221031090225.589321-1-biju.das.jz@bp.renesas.com>
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

commit 702de2c21eed04c67cefaaedc248ef16e5f6b293 upstream.

We are seeing an IRQ storm on the global receive IRQ line under heavy
CAN bus load conditions with both CAN channels enabled.

Conditions:

The global receive IRQ line is shared between can0 and can1, either of
the channels can trigger interrupt while the other channel's IRQ line
is disabled (RFIE).

When global a receive IRQ interrupt occurs, we mask the interrupt in
the IRQ handler. Clearing and unmasking of the interrupt is happening
in rx_poll(). There is a race condition where rx_poll() unmasks the
interrupt, but the next IRQ handler does not mask the IRQ due to
NAPIF_STATE_MISSED flag (e.g.: can0 RX FIFO interrupt is disabled and
can1 is triggering RX interrupt, the delay in rx_poll() processing
results in setting NAPIF_STATE_MISSED flag) leading to an IRQ storm.

This patch fixes the issue by checking IRQ active and enabled before
handling the IRQ on a particular channel.

Fixes: dd3bd23eb438 ("can: rcar_canfd: Add Renesas R-Car CAN FD driver")
Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/all/20221025155657.1426948-2-biju.das.jz@bp.renesas.com
Cc: stable@vger.kernel.org
[mkl: adjust commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[biju: removed gpriv from RCANFD_RFCC_RFIE macro]
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
Resending to 4.9 with confilcts[1] fixed
[1] https://lore.kernel.org/stable/OS0PR01MB59226F2443DFCE7C5D73778786379@OS0PR01MB5922.jpnprd01.prod.outlook.com/T/#t
---
 drivers/net/can/rcar/rcar_canfd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index a127c853a4e9..694a3354554f 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1079,7 +1079,7 @@ static irqreturn_t rcar_canfd_global_interrupt(int irq, void *dev_id)
 	struct rcar_canfd_global *gpriv = dev_id;
 	struct net_device *ndev;
 	struct rcar_canfd_channel *priv;
-	u32 sts, gerfl;
+	u32 sts, cc, gerfl;
 	u32 ch, ridx;
 
 	/* Global error interrupts still indicate a condition specific
@@ -1097,7 +1097,9 @@ static irqreturn_t rcar_canfd_global_interrupt(int irq, void *dev_id)
 
 		/* Handle Rx interrupts */
 		sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(ridx));
-		if (likely(sts & RCANFD_RFSTS_RFIF)) {
+		cc = rcar_canfd_read(priv->base, RCANFD_RFCC(ridx));
+		if (likely(sts & RCANFD_RFSTS_RFIF &&
+			   cc & RCANFD_RFCC_RFIE)) {
 			if (napi_schedule_prep(&priv->napi)) {
 				/* Disable Rx FIFO interrupts */
 				rcar_canfd_clear_bit(priv->base,
-- 
2.25.1

