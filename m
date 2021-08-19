Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF443F1ABA
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240297AbhHSNka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240325AbhHSNkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:40:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC85C0613A4
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:39:43 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGiGk-00052z-4e
        for netdev@vger.kernel.org; Thu, 19 Aug 2021 15:39:42 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2D41466A890
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:39:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 30E1C66A83E;
        Thu, 19 Aug 2021 13:39:27 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id fd48fb37;
        Thu, 19 Aug 2021 13:39:16 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dario Binacchi <dariobin@libero.it>
Subject: [PATCH net-next 18/22] can: c_can: rename IF_RX -> IF_NAPI
Date:   Thu, 19 Aug 2021 15:39:09 +0200
Message-Id: <20210819133913.657715-19-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819133913.657715-1-mkl@pengutronix.de>
References: <20210819133913.657715-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The C_CAN/D_CAN cores implement 2 interfaces to manage the message
objects. To avoid concurrency and the need for locking one interface
is used in the TX path (IF_TX). While the other one, named IF_RX is
used from NAPI context only. As this interface is not only used to
manage RX, but also TX message objects, this patch renames IF_RX to
IF_NAPI.

Link: https://lore.kernel.org/r/20210809080608.171545-1-mkl@pengutronix.de
Cc: Dario Binacchi <dariobin@libero.it>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can_main.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index e65bd7a9cf1d..052ff35ed4dc 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -160,8 +160,8 @@
 
 #define IF_MCONT_TX		(IF_MCONT_TXIE | IF_MCONT_EOB)
 
-/* Use IF1 for RX and IF2 for TX */
-#define IF_RX			0
+/* Use IF1 in NAPI path and IF2 in TX path */
+#define IF_NAPI			0
 #define IF_TX			1
 
 /* minimum timeout for checking BUSY status */
@@ -529,13 +529,13 @@ static void c_can_configure_msg_objects(struct net_device *dev)
 
 	/* first invalidate all message objects */
 	for (i = priv->msg_obj_rx_first; i <= priv->msg_obj_num; i++)
-		c_can_inval_msg_object(dev, IF_RX, i);
+		c_can_inval_msg_object(dev, IF_NAPI, i);
 
 	/* setup receive message objects */
 	for (i = priv->msg_obj_rx_first; i < priv->msg_obj_rx_last; i++)
-		c_can_setup_receive_object(dev, IF_RX, i, 0, 0, IF_MCONT_RCV);
+		c_can_setup_receive_object(dev, IF_NAPI, i, 0, 0, IF_MCONT_RCV);
 
-	c_can_setup_receive_object(dev, IF_RX, priv->msg_obj_rx_last, 0, 0,
+	c_can_setup_receive_object(dev, IF_NAPI, priv->msg_obj_rx_last, 0, 0,
 				   IF_MCONT_RCV_EOB);
 }
 
@@ -710,11 +710,11 @@ static void c_can_do_tx(struct net_device *dev)
 		pend &= ~BIT(idx);
 		obj = idx + priv->msg_obj_tx_first;
 
-		/* We use IF_RX interface instead of IF_TX because we
+		/* We use IF_NAPI interface instead of IF_TX because we
 		 * are called from c_can_poll(), which runs inside
 		 * NAPI. We are not transmitting.
 		 */
-		c_can_inval_tx_object(dev, IF_RX, obj);
+		c_can_inval_tx_object(dev, IF_NAPI, obj);
 		can_get_echo_skb(dev, idx, NULL);
 		bytes += priv->dlc[idx];
 		pkts++;
@@ -766,14 +766,14 @@ static u32 c_can_adjust_pending(u32 pend, u32 rx_mask)
 static inline void c_can_rx_object_get(struct net_device *dev,
 				       struct c_can_priv *priv, u32 obj)
 {
-	c_can_object_get(dev, IF_RX, obj, priv->comm_rcv_high);
+	c_can_object_get(dev, IF_NAPI, obj, priv->comm_rcv_high);
 }
 
 static inline void c_can_rx_finalize(struct net_device *dev,
 				     struct c_can_priv *priv, u32 obj)
 {
 	if (priv->type != BOSCH_D_CAN)
-		c_can_object_get(dev, IF_RX, obj, IF_COMM_CLR_NEWDAT);
+		c_can_object_get(dev, IF_NAPI, obj, IF_COMM_CLR_NEWDAT);
 }
 
 static int c_can_read_objects(struct net_device *dev, struct c_can_priv *priv,
@@ -785,10 +785,12 @@ static int c_can_read_objects(struct net_device *dev, struct c_can_priv *priv,
 		pend &= ~BIT(obj - 1);
 
 		c_can_rx_object_get(dev, priv, obj);
-		ctrl = priv->read_reg(priv, C_CAN_IFACE(MSGCTRL_REG, IF_RX));
+		ctrl = priv->read_reg(priv, C_CAN_IFACE(MSGCTRL_REG, IF_NAPI));
 
 		if (ctrl & IF_MCONT_MSGLST) {
-			int n = c_can_handle_lost_msg_obj(dev, IF_RX, obj, ctrl);
+			int n;
+
+			n = c_can_handle_lost_msg_obj(dev, IF_NAPI, obj, ctrl);
 
 			pkts += n;
 			quota -= n;
@@ -803,7 +805,7 @@ static int c_can_read_objects(struct net_device *dev, struct c_can_priv *priv,
 			continue;
 
 		/* read the data from the message object */
-		c_can_read_msg_object(dev, IF_RX, ctrl);
+		c_can_read_msg_object(dev, IF_NAPI, ctrl);
 
 		c_can_rx_finalize(dev, priv, obj);
 
-- 
2.32.0


