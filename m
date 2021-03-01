Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C64327D1B
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 12:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhCALX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 06:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbhCALWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 06:22:40 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51461C0617AA
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 03:21:14 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lGgbw-00033r-Tv
        for netdev@vger.kernel.org; Mon, 01 Mar 2021 12:21:12 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 94DD25EB12F
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 11:21:10 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 16E375EB0FB;
        Mon,  1 Mar 2021 11:21:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2c17ecd7;
        Mon, 1 Mar 2021 11:21:02 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Thomas Kopp <thomas.kopp@microchip.com>
Subject: [net 4/6] can: mcp251xfd: revert "can: mcp251xfd: add BQL support"
Date:   Mon,  1 Mar 2021 12:20:58 +0100
Message-Id: <20210301112100.197939-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301112100.197939-1-mkl@pengutronix.de>
References: <20210301112100.197939-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the following 4 patches

| 99842c9685ab can: dev: can_rx_offload_get_echo_skb(): extend to return can frame length
| 9420e1d495e2 can: dev: can_get_echo_skb(): extend to return can frame length
| 1dcb6e57db83 can: dev: can_put_echo_skb(): extend to handle frame_len
| f0ef72febc9a can: dev: extend struct can_skb_priv to hold CAN frame length

the CAN echo SKB support was extended to hold the CAN frame
length (which is the length of the CAN frame on the wire). It is meant
as a helper for BQL support, to avoid the re-calculation of the frame
length before sending it and on TX-completion.

However if the CAN frame is send without the request to be looped back
the SKB is discarded in can_put_echo_skb() and the subsequent
can_get_echo_skb() and can_rx_offload_get_echo_skb() return 0 for the
CAN frame length. This results in BQL stalling the TX queue after a
few packages.

Until the BQL helpers can_get_echo_skb() and
can_rx_offload_get_echo_skb() are fixed, revert the BQL support for
the mcp251xfd driver.

This reverts commit 4162e18e949ba520d5116ac0323500355479a00e.

Fixes: 4162e18e949b ("can: mcp251xfd: add BQL support")
Cc: Manivannan Sadhasivam <mani@kernel.org>
Cc: Thomas Kopp <thomas.kopp@microchip.com>
Link: https://lore.kernel.org/r/20210228083347.28580-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 21 ++++---------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 3c5b92911d46..799e9d5d3481 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -335,8 +335,6 @@ static void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 	u8 len;
 	int i, j;
 
-	netdev_reset_queue(priv->ndev);
-
 	/* TEF */
 	tef_ring = priv->tef;
 	tef_ring->head = 0;
@@ -1249,8 +1247,7 @@ mcp251xfd_handle_tefif_recover(const struct mcp251xfd_priv *priv, const u32 seq)
 
 static int
 mcp251xfd_handle_tefif_one(struct mcp251xfd_priv *priv,
-			   const struct mcp251xfd_hw_tef_obj *hw_tef_obj,
-			   unsigned int *frame_len_ptr)
+			   const struct mcp251xfd_hw_tef_obj *hw_tef_obj)
 {
 	struct net_device_stats *stats = &priv->ndev->stats;
 	u32 seq, seq_masked, tef_tail_masked;
@@ -1272,8 +1269,7 @@ mcp251xfd_handle_tefif_one(struct mcp251xfd_priv *priv,
 	stats->tx_bytes +=
 		can_rx_offload_get_echo_skb(&priv->offload,
 					    mcp251xfd_get_tef_tail(priv),
-					    hw_tef_obj->ts,
-					    frame_len_ptr);
+					    hw_tef_obj->ts, NULL);
 	stats->tx_packets++;
 	priv->tef->tail++;
 
@@ -1331,7 +1327,6 @@ mcp251xfd_tef_obj_read(const struct mcp251xfd_priv *priv,
 static int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
 {
 	struct mcp251xfd_hw_tef_obj hw_tef_obj[MCP251XFD_TX_OBJ_NUM_MAX];
-	unsigned int total_frame_len = 0;
 	u8 tef_tail, len, l;
 	int err, i;
 
@@ -1353,9 +1348,7 @@ static int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
 	}
 
 	for (i = 0; i < len; i++) {
-		unsigned int frame_len;
-
-		err = mcp251xfd_handle_tefif_one(priv, &hw_tef_obj[i], &frame_len);
+		err = mcp251xfd_handle_tefif_one(priv, &hw_tef_obj[i]);
 		/* -EAGAIN means the Sequence Number in the TEF
 		 * doesn't match our tef_tail. This can happen if we
 		 * read the TEF objects too early. Leave loop let the
@@ -1365,8 +1358,6 @@ static int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
 			goto out_netif_wake_queue;
 		if (err)
 			return err;
-
-		total_frame_len += frame_len;
 	}
 
  out_netif_wake_queue:
@@ -1397,7 +1388,6 @@ static int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
 			return err;
 
 		tx_ring->tail += len;
-		netdev_completed_queue(priv->ndev, len, total_frame_len);
 
 		err = mcp251xfd_check_tef_tail(priv);
 		if (err)
@@ -2443,7 +2433,6 @@ static netdev_tx_t mcp251xfd_start_xmit(struct sk_buff *skb,
 	struct mcp251xfd_priv *priv = netdev_priv(ndev);
 	struct mcp251xfd_tx_ring *tx_ring = priv->tx;
 	struct mcp251xfd_tx_obj *tx_obj;
-	unsigned int frame_len;
 	u8 tx_head;
 	int err;
 
@@ -2462,9 +2451,7 @@ static netdev_tx_t mcp251xfd_start_xmit(struct sk_buff *skb,
 	if (mcp251xfd_get_tx_free(tx_ring) == 0)
 		netif_stop_queue(ndev);
 
-	frame_len = can_skb_get_frame_len(skb);
-	can_put_echo_skb(skb, ndev, tx_head, frame_len);
-	netdev_sent_queue(priv->ndev, frame_len);
+	can_put_echo_skb(skb, ndev, tx_head, 0);
 
 	err = mcp251xfd_tx_obj_write(priv, tx_obj);
 	if (err)
-- 
2.30.1


