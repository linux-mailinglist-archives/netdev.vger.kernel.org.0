Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C47608B72
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 12:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJVKVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 06:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiJVKUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 06:20:41 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BAA22E8DAC;
        Sat, 22 Oct 2022 02:37:45 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,204,1661785200"; 
   d="scan'208";a="137536294"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 22 Oct 2022 17:34:01 +0900
Received: from localhost.localdomain (unknown [10.226.92.14])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 2ED024006185;
        Sat, 22 Oct 2022 17:33:55 +0900 (JST)
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
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rob Herring <robh@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 1/3] can: rcar_canfd: Fix IRQ storm on global fifo receive
Date:   Sat, 22 Oct 2022 09:15:01 +0100
Message-Id: <20221022081503.1051257-2-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
References: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
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

This patch fixes the issue by checking irq is masked or not in
irq handler and it masks the interrupt if it is unmasked.

Fixes: dd3bd23eb438 ("can: rcar_canfd: Add Renesas R-Car CAN FD driver")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/can/rcar/rcar_canfd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 567620d215f8..1a3ae0b232c9 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1157,7 +1157,7 @@ static void rcar_canfd_handle_global_receive(struct rcar_canfd_global *gpriv, u3
 {
 	struct rcar_canfd_channel *priv = gpriv->ch[ch];
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
-	u32 sts;
+	u32 sts, rfie;
 
 	/* Handle Rx interrupts */
 	sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(gpriv, ridx));
@@ -1168,6 +1168,14 @@ static void rcar_canfd_handle_global_receive(struct rcar_canfd_global *gpriv, u3
 					     RCANFD_RFCC(gpriv, ridx),
 					     RCANFD_RFCC_RFIE);
 			__napi_schedule(&priv->napi);
+		} else {
+			rfie = rcar_canfd_read(priv->base,
+					       RCANFD_RFCC(gpriv, ridx));
+			if (rfie & RCANFD_RFCC_RFIE)
+				/* Disable Rx FIFO interrupts */
+				rcar_canfd_clear_bit(priv->base,
+						     RCANFD_RFCC(gpriv, ridx),
+						     RCANFD_RFCC_RFIE);
 		}
 	}
 }
-- 
2.25.1

