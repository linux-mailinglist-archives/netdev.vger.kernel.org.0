Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8087560D11B
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 17:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiJYP5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 11:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiJYP5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 11:57:15 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 700F425589;
        Tue, 25 Oct 2022 08:57:12 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,212,1661785200"; 
   d="scan'208";a="137878971"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 26 Oct 2022 00:57:11 +0900
Received: from localhost.localdomain (unknown [10.226.92.152])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 45E9640029CE;
        Wed, 26 Oct 2022 00:57:06 +0900 (JST)
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
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rob Herring <robh@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 1/3] can: rcar_canfd: Fix IRQ storm on global fifo receive
Date:   Tue, 25 Oct 2022 16:56:55 +0100
Message-Id: <20221025155657.1426948-2-biju.das.jz@bp.renesas.com>
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

We are seeing IRQ storm on global receive IRQ line under heavy CAN
bus load conditions with both CAN channels are enabled.

Conditions:
  The global receive IRQ line is shared between can0 and can1, either
  of the channels can trigger interrupt while the other channel irq
  line is disabled(rfie).
  When global receive IRQ interrupt occurs, we mask the interrupt in
  irqhandler. Clearing and unmasking of the interrupt is happening in
  rx_poll(). There is a race condition where rx_poll unmask the
  interrupt, but the next irq handler does not mask the irq due to
  NAPIF_STATE_MISSED flag(for eg: can0 rx fifo interrupt enable is
  disabled and can1 is triggering rx interrupt, the delay in rx_poll()
  processing results in setting NAPIF_STATE_MISSED flag) leading to IRQ
  storm.

This patch fixes the issue by checking irq active and enabled before
handling the irq on a particular channel.

Fixes: dd3bd23eb438 ("can: rcar_canfd: Add Renesas R-Car CAN FD driver")
Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v1->v2:
 * Added check for irq active and enabled before handling the irq on a
   particular channel.
---
 drivers/net/can/rcar/rcar_canfd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 567620d215f8..ea828c1bd3a1 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1157,11 +1157,13 @@ static void rcar_canfd_handle_global_receive(struct rcar_canfd_global *gpriv, u3
 {
 	struct rcar_canfd_channel *priv = gpriv->ch[ch];
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
-	u32 sts;
+	u32 sts, cc;
 
 	/* Handle Rx interrupts */
 	sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(gpriv, ridx));
-	if (likely(sts & RCANFD_RFSTS_RFIF)) {
+	cc = rcar_canfd_read(priv->base, RCANFD_RFCC(gpriv, ridx));
+	if (likely(sts & RCANFD_RFSTS_RFIF &&
+		   cc & RCANFD_RFCC_RFIE)) {
 		if (napi_schedule_prep(&priv->napi)) {
 			/* Disable Rx FIFO interrupts */
 			rcar_canfd_clear_bit(priv->base,
-- 
2.25.1

