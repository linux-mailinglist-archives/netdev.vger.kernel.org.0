Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122A7272646
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgIUNr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgIUNqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:46:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977F5C0613D7
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:46:08 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kKM8r-0003ED-GS; Mon, 21 Sep 2020 15:46:05 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 11/38] can: dev: can_put_echo_skb(): propagate error in case of errors
Date:   Mon, 21 Sep 2020 15:45:30 +0200
Message-Id: <20200921134557.2251383-12-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921134557.2251383-1-mkl@pengutronix.de>
References: <20200921134557.2251383-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function can_put_echo_skb() can fail for several reasons. It may
fail due to OOM, but when it fails it's usually due to locking problems
in the driver.

In order to help developing and debugging of new drivers propagate error
value in case of errors.

Link: https://lore.kernel.org/r/20200915223527.1417033-12-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev.c   | 11 +++++++----
 include/linux/can/dev.h |  4 ++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index dd443e5d8cb7..77a5663693af 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -434,8 +434,8 @@ static void can_flush_echo_skb(struct net_device *dev)
  * of the device driver. The driver must protect access to
  * priv->echo_skb, if necessary.
  */
-void can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
-		      unsigned int idx)
+int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
+		     unsigned int idx)
 {
 	struct can_priv *priv = netdev_priv(dev);
 
@@ -446,13 +446,13 @@ void can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 	    (skb->protocol != htons(ETH_P_CAN) &&
 	     skb->protocol != htons(ETH_P_CANFD))) {
 		kfree_skb(skb);
-		return;
+		return 0;
 	}
 
 	if (!priv->echo_skb[idx]) {
 		skb = can_create_echo_skb(skb);
 		if (!skb)
-			return;
+			return -ENOMEM;
 
 		/* make settings for echo to reduce code in irq context */
 		skb->pkt_type = PACKET_BROADCAST;
@@ -465,7 +465,10 @@ void can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 		/* locking problem with netif_stop_queue() ?? */
 		netdev_err(dev, "%s: BUG! echo_skb %d is occupied!\n", __func__, idx);
 		kfree_skb(skb);
+		return -EBUSY;
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(can_put_echo_skb);
 
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 516892566ac9..ed0482b2f4b2 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -201,8 +201,8 @@ void can_bus_off(struct net_device *dev);
 void can_change_state(struct net_device *dev, struct can_frame *cf,
 		      enum can_state tx_state, enum can_state rx_state);
 
-void can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
-		      unsigned int idx);
+int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
+		     unsigned int idx);
 struct sk_buff *__can_get_echo_skb(struct net_device *dev, unsigned int idx,
 				   u8 *len_ptr);
 unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx);
-- 
2.28.0

