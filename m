Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE355ED86E
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiI1JGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbiI1JGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:06:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148BF140C2
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 02:06:35 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1odT1V-00075H-Fx
        for netdev@vger.kernel.org; Wed, 28 Sep 2022 11:06:33 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CC2C0EF6A4
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:06:32 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D0E1DEF698;
        Wed, 28 Sep 2022 09:06:30 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1931824f;
        Wed, 28 Sep 2022 09:06:29 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Jacob Kroon <jacob.kroon@gmail.com>, stable@vger.kernel.org
Subject: [PATCH net] can: c_can: don't cache TX messages for C_CAN cores
Date:   Wed, 28 Sep 2022 11:06:29 +0200
Message-Id: <20220928090629.1124190-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220928090629.1124190-1-mkl@pengutronix.de>
References: <20220928090629.1124190-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Jacob noticed, the optimization introduced in 387da6bc7a82 ("can:
c_can: cache frames to operate as a true FIFO") doesn't properly work
on C_CAN, but on D_CAN IP cores. The exact reasons are still unknown.

For now disable caching if CAN frames in the TX path for C_CAN cores.

Fixes: 387da6bc7a82 ("can: c_can: cache frames to operate as a true FIFO")
Link: https://lore.kernel.org/all/20220928083354.1062321-1-mkl@pengutronix.de
Link: https://lore.kernel.org/all/15a8084b-9617-2da1-6704-d7e39d60643b@gmail.com
Reported-by: Jacob Kroon <jacob.kroon@gmail.com>
Tested-by: Jacob Kroon <jacob.kroon@gmail.com>
Cc: stable@vger.kernel.org # v5.15
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.h      | 17 +++++++++++++++--
 drivers/net/can/c_can/c_can_main.c | 11 +++++------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index f23a03300a81..029cd8194ed5 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -235,9 +235,22 @@ static inline u8 c_can_get_tx_tail(const struct c_can_tx_ring *ring)
 	return ring->tail & (ring->obj_num - 1);
 }
 
-static inline u8 c_can_get_tx_free(const struct c_can_tx_ring *ring)
+static inline u8 c_can_get_tx_free(const struct c_can_priv *priv,
+				   const struct c_can_tx_ring *ring)
 {
-	return ring->obj_num - (ring->head - ring->tail);
+	u8 head = c_can_get_tx_head(ring);
+	u8 tail = c_can_get_tx_tail(ring);
+
+	if (priv->type == BOSCH_D_CAN)
+		return ring->obj_num - (ring->head - ring->tail);
+
+	/* This is not a FIFO. C/D_CAN sends out the buffers
+	 * prioritized. The lowest buffer number wins.
+	 */
+	if (head < tail)
+		return 0;
+
+	return ring->obj_num - head;
 }
 
 #endif /* C_CAN_H */
diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index dc8132862f33..d6605dbb7737 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -429,7 +429,7 @@ static void c_can_setup_receive_object(struct net_device *dev, int iface,
 static bool c_can_tx_busy(const struct c_can_priv *priv,
 			  const struct c_can_tx_ring *tx_ring)
 {
-	if (c_can_get_tx_free(tx_ring) > 0)
+	if (c_can_get_tx_free(priv, tx_ring) > 0)
 		return false;
 
 	netif_stop_queue(priv->dev);
@@ -437,7 +437,7 @@ static bool c_can_tx_busy(const struct c_can_priv *priv,
 	/* Memory barrier before checking tx_free (head and tail) */
 	smp_mb();
 
-	if (c_can_get_tx_free(tx_ring) == 0) {
+	if (c_can_get_tx_free(priv, tx_ring) == 0) {
 		netdev_dbg(priv->dev,
 			   "Stopping tx-queue (tx_head=0x%08x, tx_tail=0x%08x, len=%d).\n",
 			   tx_ring->head, tx_ring->tail,
@@ -465,7 +465,7 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 
 	idx = c_can_get_tx_head(tx_ring);
 	tx_ring->head++;
-	if (c_can_get_tx_free(tx_ring) == 0)
+	if (c_can_get_tx_free(priv, tx_ring) == 0)
 		netif_stop_queue(dev);
 
 	if (idx < c_can_get_tx_tail(tx_ring))
@@ -748,7 +748,7 @@ static void c_can_do_tx(struct net_device *dev)
 		return;
 
 	tx_ring->tail += pkts;
-	if (c_can_get_tx_free(tx_ring)) {
+	if (c_can_get_tx_free(priv, tx_ring)) {
 		/* Make sure that anybody stopping the queue after
 		 * this sees the new tx_ring->tail.
 		 */
@@ -760,8 +760,7 @@ static void c_can_do_tx(struct net_device *dev)
 	stats->tx_packets += pkts;
 
 	tail = c_can_get_tx_tail(tx_ring);
-
-	if (tail == 0) {
+	if (priv->type == BOSCH_D_CAN && tail == 0) {
 		u8 head = c_can_get_tx_head(tx_ring);
 
 		/* Start transmission for all cached messages */

base-commit: 44d70bb561dac9363f45787aa93dfca36877ee01
-- 
2.35.1


