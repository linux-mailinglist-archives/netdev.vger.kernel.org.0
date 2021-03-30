Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5436034E6D0
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhC3Lr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbhC3Lqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9207AC0613B2
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:51 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpe-0006cz-6T
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:50 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 46530603F1A
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:38 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 797B8603E39;
        Tue, 30 Mar 2021 11:46:13 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2958d885;
        Tue, 30 Mar 2021 11:46:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 27/39] can: mcp251xfd: add HW timestamp to RX, TX and error CAN frames
Date:   Tue, 30 Mar 2021 13:45:47 +0200
Message-Id: <20210330114559.1114855-28-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch uses the previously added mcp251xfd_skb_set_timestamp()
function to convert the timestamp done by the CAN controller into a
proper skb hw timestamp.

Link: https://lore.kernel.org/r/20210304161209.2754463-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 23 +++++++++++++++----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 6cdc05b02403..142eb4506b55 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1265,7 +1265,8 @@ mcp251xfd_handle_tefif_one(struct mcp251xfd_priv *priv,
 			   const struct mcp251xfd_hw_tef_obj *hw_tef_obj)
 {
 	struct net_device_stats *stats = &priv->ndev->stats;
-	u32 seq, seq_masked, tef_tail_masked;
+	struct sk_buff *skb;
+	u32 seq, seq_masked, tef_tail_masked, tef_tail;
 
 	seq = FIELD_GET(MCP251XFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK,
 			hw_tef_obj->flags);
@@ -1281,9 +1282,13 @@ mcp251xfd_handle_tefif_one(struct mcp251xfd_priv *priv,
 	if (seq_masked != tef_tail_masked)
 		return mcp251xfd_handle_tefif_recover(priv, seq);
 
+	tef_tail = mcp251xfd_get_tef_tail(priv);
+	skb = priv->can.echo_skb[tef_tail];
+	if (skb)
+		mcp251xfd_skb_set_timestamp(priv, skb, hw_tef_obj->ts);
 	stats->tx_bytes +=
 		can_rx_offload_get_echo_skb(&priv->offload,
-					    mcp251xfd_get_tef_tail(priv),
+					    tef_tail,
 					    hw_tef_obj->ts, NULL);
 	stats->tx_packets++;
 	priv->tef->tail++;
@@ -1442,7 +1447,7 @@ mcp251xfd_rx_ring_update(const struct mcp251xfd_priv *priv,
 }
 
 static void
-mcp251xfd_hw_rx_obj_to_skb(const struct mcp251xfd_priv *priv,
+mcp251xfd_hw_rx_obj_to_skb(struct mcp251xfd_priv *priv,
 			   const struct mcp251xfd_hw_rx_obj_canfd *hw_rx_obj,
 			   struct sk_buff *skb)
 {
@@ -1485,6 +1490,8 @@ mcp251xfd_hw_rx_obj_to_skb(const struct mcp251xfd_priv *priv,
 
 	if (!(hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_RTR))
 		memcpy(cfd->data, hw_rx_obj->data, cfd->len);
+
+	mcp251xfd_skb_set_timestamp(priv, skb, hw_rx_obj->ts);
 }
 
 static int
@@ -1598,16 +1605,21 @@ static int mcp251xfd_handle_rxif(struct mcp251xfd_priv *priv)
 }
 
 static struct sk_buff *
-mcp251xfd_alloc_can_err_skb(const struct mcp251xfd_priv *priv,
+mcp251xfd_alloc_can_err_skb(struct mcp251xfd_priv *priv,
 			    struct can_frame **cf, u32 *timestamp)
 {
+	struct sk_buff *skb;
 	int err;
 
 	err = mcp251xfd_get_timestamp(priv, timestamp);
 	if (err)
 		return NULL;
 
-	return alloc_can_err_skb(priv->ndev, cf);
+	skb = alloc_can_err_skb(priv->ndev, cf);
+	if (skb)
+		mcp251xfd_skb_set_timestamp(priv, skb, *timestamp);
+
+	return skb;
 }
 
 static int mcp251xfd_handle_rxovif(struct mcp251xfd_priv *priv)
@@ -1759,6 +1771,7 @@ static int mcp251xfd_handle_ivmif(struct mcp251xfd_priv *priv)
 	if (!cf)
 		return 0;
 
+	mcp251xfd_skb_set_timestamp(priv, skb, timestamp);
 	err = can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
 	if (err)
 		stats->rx_fifo_errors++;
-- 
2.30.2


