Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3892C8657
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgK3OQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgK3OQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:16:00 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0A9C061A47
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:14:45 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kjjwx-0007e4-Mc
        for netdev@vger.kernel.org; Mon, 30 Nov 2020 15:14:43 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B64D059FAFA
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:14:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id AD51759FAC7;
        Mon, 30 Nov 2020 14:14:34 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id cdd28ab5;
        Mon, 30 Nov 2020 14:14:33 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Thomas Kopp <thomas.kopp@microchip.com>
Subject: [net-next 04/14] can: mcp251xfd: struct mcp251xfd_priv::tef to array of length 1
Date:   Mon, 30 Nov 2020 15:14:22 +0100
Message-Id: <20201130141432.278219-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130141432.278219-1-mkl@pengutronix.de>
References: <20201130141432.278219-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch converts the struct mcp251xfd_tef_ring member within the struct
mcp251xfd_priv into an array of length one. This way all rings (tef, tx and rx)
can be accessed in the same way.

Link: https://lore.kernel.org/r/20201126132144.351154-4-mkl@pengutronix.de
Tested-by: Thomas Kopp <thomas.kopp@microchip.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 18 ++++++++++--------
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h      |  8 ++++----
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index c770733ecbcc..551499d9737f 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -326,6 +326,7 @@ mcp251xfd_tx_ring_init_tx_obj(const struct mcp251xfd_priv *priv,
 
 static void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 {
+	struct mcp251xfd_tef_ring *tef_ring;
 	struct mcp251xfd_tx_ring *tx_ring;
 	struct mcp251xfd_rx_ring *rx_ring, *prev_rx_ring = NULL;
 	struct mcp251xfd_tx_obj *tx_obj;
@@ -335,8 +336,9 @@ static void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 	int i, j;
 
 	/* TEF */
-	priv->tef.head = 0;
-	priv->tef.tail = 0;
+	tef_ring = priv->tef;
+	tef_ring->head = 0;
+	tef_ring->tail = 0;
 
 	/* TX */
 	tx_ring = priv->tx;
@@ -1219,7 +1221,7 @@ mcp251xfd_handle_tefif_recover(const struct mcp251xfd_priv *priv, const u32 seq)
 		    tef_sta & MCP251XFD_REG_TEFSTA_TEFFIF ?
 		    "full" : tef_sta & MCP251XFD_REG_TEFSTA_TEFNEIF ?
 		    "not empty" : "empty",
-		    seq, priv->tef.tail, priv->tef.head, tx_ring->head);
+		    seq, priv->tef->tail, priv->tef->head, tx_ring->head);
 
 	/* The Sequence Number in the TEF doesn't match our tef_tail. */
 	return -EAGAIN;
@@ -1243,7 +1245,7 @@ mcp251xfd_handle_tefif_one(struct mcp251xfd_priv *priv,
 	 */
 	seq_masked = seq &
 		field_mask(MCP251XFD_OBJ_FLAGS_SEQ_MCP2517FD_MASK);
-	tef_tail_masked = priv->tef.tail &
+	tef_tail_masked = priv->tef->tail &
 		field_mask(MCP251XFD_OBJ_FLAGS_SEQ_MCP2517FD_MASK);
 	if (seq_masked != tef_tail_masked)
 		return mcp251xfd_handle_tefif_recover(priv, seq);
@@ -1261,7 +1263,7 @@ mcp251xfd_handle_tefif_one(struct mcp251xfd_priv *priv,
 	if (err)
 		return err;
 
-	priv->tef.tail++;
+	priv->tef->tail++;
 	tx_ring->tail++;
 
 	return mcp251xfd_check_tef_tail(priv);
@@ -1281,12 +1283,12 @@ static int mcp251xfd_tef_ring_update(struct mcp251xfd_priv *priv)
 	/* chip_tx_tail, is the next TX-Object send by the HW.
 	 * The new TEF head must be >= the old head, ...
 	 */
-	new_head = round_down(priv->tef.head, tx_ring->obj_num) + chip_tx_tail;
-	if (new_head <= priv->tef.head)
+	new_head = round_down(priv->tef->head, tx_ring->obj_num) + chip_tx_tail;
+	if (new_head <= priv->tef->head)
 		new_head += tx_ring->obj_num;
 
 	/* ... but it cannot exceed the TX head. */
-	priv->tef.head = min(new_head, tx_ring->head);
+	priv->tef->head = min(new_head, tx_ring->head);
 
 	return mcp251xfd_check_tef_tail(priv);
 }
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index 97dc182e2b42..76585a40d16e 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -583,7 +583,7 @@ struct mcp251xfd_priv {
 	struct spi_device *spi;
 	u32 spi_max_speed_hz_orig;
 
-	struct mcp251xfd_tef_ring tef;
+	struct mcp251xfd_tef_ring tef[1];
 	struct mcp251xfd_tx_ring tx[1];
 	struct mcp251xfd_rx_ring *rx[1];
 
@@ -744,17 +744,17 @@ mcp251xfd_get_rx_obj_addr(const struct mcp251xfd_rx_ring *ring, u8 n)
 
 static inline u8 mcp251xfd_get_tef_head(const struct mcp251xfd_priv *priv)
 {
-	return priv->tef.head & (priv->tx->obj_num - 1);
+	return priv->tef->head & (priv->tx->obj_num - 1);
 }
 
 static inline u8 mcp251xfd_get_tef_tail(const struct mcp251xfd_priv *priv)
 {
-	return priv->tef.tail & (priv->tx->obj_num - 1);
+	return priv->tef->tail & (priv->tx->obj_num - 1);
 }
 
 static inline u8 mcp251xfd_get_tef_len(const struct mcp251xfd_priv *priv)
 {
-	return priv->tef.head - priv->tef.tail;
+	return priv->tef->head - priv->tef->tail;
 }
 
 static inline u8 mcp251xfd_get_tef_linear_len(const struct mcp251xfd_priv *priv)
-- 
2.29.2


