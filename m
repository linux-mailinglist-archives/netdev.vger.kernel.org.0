Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5423D5B30
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhGZNc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbhGZNbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:31:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35415C0617BF
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81Kz-0001Eo-MK
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:09 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 74B246581E3
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:11:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4B406658164;
        Mon, 26 Jul 2021 14:11:47 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d3677c8e;
        Mon, 26 Jul 2021 14:11:45 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Subject: [PATCH net-next 07/46] can: rx-offload: add skb queue for use during ISR
Date:   Mon, 26 Jul 2021 16:11:05 +0200
Message-Id: <20210726141144.862529-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding a skb to the skb_queue in rx-offload requires to take a lock.

This commit avoids this by adding an unlocked skb queue that is
appended at the end of the ISR. Having one lock at the end of the ISR
should be OK as the HW is empty, not about to overflow.

Link: https://lore.kernel.org/r/20210724204745.736053-2-mkl@pengutronix.de
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Co-developed-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Signed-off-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/rx-offload.c              | 67 +++++++++----------
 drivers/net/can/flexcan.c                     |  3 +
 drivers/net/can/m_can/m_can.c                 |  3 +
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    |  6 +-
 drivers/net/can/ti_hecc.c                     |  2 +
 include/linux/can/rx-offload.h                |  2 +
 6 files changed, 48 insertions(+), 35 deletions(-)

diff --git a/drivers/net/can/dev/rx-offload.c b/drivers/net/can/dev/rx-offload.c
index ab2c1543786c..d0bdb6db3a57 100644
--- a/drivers/net/can/dev/rx-offload.c
+++ b/drivers/net/can/dev/rx-offload.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2014      Protonic Holland,
  *                         David Jander
- * Copyright (C) 2014-2017 Pengutronix,
+ * Copyright (C) 2014-2021 Pengutronix,
  *                         Marc Kleine-Budde <kernel@pengutronix.de>
  */
 
@@ -174,10 +174,8 @@ can_rx_offload_offload_one(struct can_rx_offload *offload, unsigned int n)
 int can_rx_offload_irq_offload_timestamp(struct can_rx_offload *offload,
 					 u64 pending)
 {
-	struct sk_buff_head skb_queue;
 	unsigned int i;
-
-	__skb_queue_head_init(&skb_queue);
+	int received = 0;
 
 	for (i = offload->mb_first;
 	     can_rx_offload_le(offload, i, offload->mb_last);
@@ -191,26 +189,12 @@ int can_rx_offload_irq_offload_timestamp(struct can_rx_offload *offload,
 		if (IS_ERR_OR_NULL(skb))
 			continue;
 
-		__skb_queue_add_sort(&skb_queue, skb, can_rx_offload_compare);
-	}
-
-	if (!skb_queue_empty(&skb_queue)) {
-		unsigned long flags;
-		u32 queue_len;
-
-		spin_lock_irqsave(&offload->skb_queue.lock, flags);
-		skb_queue_splice_tail(&skb_queue, &offload->skb_queue);
-		spin_unlock_irqrestore(&offload->skb_queue.lock, flags);
-
-		queue_len = skb_queue_len(&offload->skb_queue);
-		if (queue_len > offload->skb_queue_len_max / 8)
-			netdev_dbg(offload->dev, "%s: queue_len=%d\n",
-				   __func__, queue_len);
-
-		can_rx_offload_schedule(offload);
+		__skb_queue_add_sort(&offload->skb_irq_queue, skb,
+				     can_rx_offload_compare);
+		received++;
 	}
 
-	return skb_queue_len(&skb_queue);
+	return received;
 }
 EXPORT_SYMBOL_GPL(can_rx_offload_irq_offload_timestamp);
 
@@ -226,13 +210,10 @@ int can_rx_offload_irq_offload_fifo(struct can_rx_offload *offload)
 		if (!skb)
 			break;
 
-		skb_queue_tail(&offload->skb_queue, skb);
+		__skb_queue_tail(&offload->skb_irq_queue, skb);
 		received++;
 	}
 
-	if (received)
-		can_rx_offload_schedule(offload);
-
 	return received;
 }
 EXPORT_SYMBOL_GPL(can_rx_offload_irq_offload_fifo);
@@ -241,7 +222,6 @@ int can_rx_offload_queue_sorted(struct can_rx_offload *offload,
 				struct sk_buff *skb, u32 timestamp)
 {
 	struct can_rx_offload_cb *cb;
-	unsigned long flags;
 
 	if (skb_queue_len(&offload->skb_queue) >
 	    offload->skb_queue_len_max) {
@@ -252,11 +232,8 @@ int can_rx_offload_queue_sorted(struct can_rx_offload *offload,
 	cb = can_rx_offload_get_cb(skb);
 	cb->timestamp = timestamp;
 
-	spin_lock_irqsave(&offload->skb_queue.lock, flags);
-	__skb_queue_add_sort(&offload->skb_queue, skb, can_rx_offload_compare);
-	spin_unlock_irqrestore(&offload->skb_queue.lock, flags);
-
-	can_rx_offload_schedule(offload);
+	__skb_queue_add_sort(&offload->skb_irq_queue, skb,
+			     can_rx_offload_compare);
 
 	return 0;
 }
@@ -295,13 +272,33 @@ int can_rx_offload_queue_tail(struct can_rx_offload *offload,
 		return -ENOBUFS;
 	}
 
-	skb_queue_tail(&offload->skb_queue, skb);
-	can_rx_offload_schedule(offload);
+	__skb_queue_tail(&offload->skb_irq_queue, skb);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(can_rx_offload_queue_tail);
 
+void can_rx_offload_irq_finish(struct can_rx_offload *offload)
+{
+	unsigned long flags;
+	int queue_len;
+
+	if (skb_queue_empty_lockless(&offload->skb_irq_queue))
+		return;
+
+	spin_lock_irqsave(&offload->skb_queue.lock, flags);
+	skb_queue_splice_tail_init(&offload->skb_irq_queue, &offload->skb_queue);
+	spin_unlock_irqrestore(&offload->skb_queue.lock, flags);
+
+	queue_len = skb_queue_len(&offload->skb_queue);
+	if (queue_len > offload->skb_queue_len_max / 8)
+		netdev_dbg(offload->dev, "%s: queue_len=%d\n",
+			   __func__, queue_len);
+
+	can_rx_offload_schedule(offload);
+}
+EXPORT_SYMBOL_GPL(can_rx_offload_irq_finish);
+
 static int can_rx_offload_init_queue(struct net_device *dev,
 				     struct can_rx_offload *offload,
 				     unsigned int weight)
@@ -312,6 +309,7 @@ static int can_rx_offload_init_queue(struct net_device *dev,
 	offload->skb_queue_len_max = 2 << fls(weight);
 	offload->skb_queue_len_max *= 4;
 	skb_queue_head_init(&offload->skb_queue);
+	__skb_queue_head_init(&offload->skb_irq_queue);
 
 	netif_napi_add(dev, &offload->napi, can_rx_offload_napi_poll, weight);
 
@@ -373,5 +371,6 @@ void can_rx_offload_del(struct can_rx_offload *offload)
 {
 	netif_napi_del(&offload->napi);
 	skb_queue_purge(&offload->skb_queue);
+	__skb_queue_purge(&offload->skb_irq_queue);
 }
 EXPORT_SYMBOL_GPL(can_rx_offload_del);
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 57f3635ad8d7..d9dcf6a8412b 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1198,6 +1198,9 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 		}
 	}
 
+	if (handled)
+		can_rx_offload_irq_finish(&priv->offload);
+
 	return handled;
 }
 
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index bba2a449ac70..18461982f7a1 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1058,6 +1058,9 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 		}
 	}
 
+	if (cdev->is_peripheral)
+		can_rx_offload_irq_finish(&cdev->offload);
+
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 47c3f408a799..f3b267ec22e0 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2195,8 +2195,10 @@ static irqreturn_t mcp251xfd_irq(int irq, void *dev_id)
 			FIELD_GET(MCP251XFD_REG_INT_IE_MASK,
 				  priv->regs_status.intf);
 
-		if (!(intf_pending))
+		if (!(intf_pending)) {
+			can_rx_offload_irq_finish(&priv->offload);
 			return handled;
+		}
 
 		/* Some interrupts must be ACKed in the
 		 * MCP251XFD_REG_INT register.
@@ -2296,6 +2298,8 @@ static irqreturn_t mcp251xfd_irq(int irq, void *dev_id)
 	} while (1);
 
  out_fail:
+	can_rx_offload_irq_finish(&priv->offload);
+
 	netdev_err(priv->ndev, "IRQ handler returned %d (intf=0x%08x).\n",
 		   err, priv->regs_status.intf);
 	mcp251xfd_dump(priv);
diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 73245d8836a9..353062ead98f 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -786,6 +786,8 @@ static irqreturn_t ti_hecc_interrupt(int irq, void *dev_id)
 		int_status = hecc_read(priv, HECC_CANGIF0);
 	}
 
+	can_rx_offload_irq_finish(&priv->offload);
+
 	return IRQ_HANDLED;
 }
 
diff --git a/include/linux/can/rx-offload.h b/include/linux/can/rx-offload.h
index 40882df7105e..d71c938e17d0 100644
--- a/include/linux/can/rx-offload.h
+++ b/include/linux/can/rx-offload.h
@@ -20,6 +20,7 @@ struct can_rx_offload {
 					bool drop);
 
 	struct sk_buff_head skb_queue;
+	struct sk_buff_head skb_irq_queue;
 	u32 skb_queue_len_max;
 
 	unsigned int mb_first;
@@ -48,6 +49,7 @@ unsigned int can_rx_offload_get_echo_skb(struct can_rx_offload *offload,
 					 unsigned int *frame_len_ptr);
 int can_rx_offload_queue_tail(struct can_rx_offload *offload,
 			      struct sk_buff *skb);
+void can_rx_offload_irq_finish(struct can_rx_offload *offload);
 void can_rx_offload_del(struct can_rx_offload *offload);
 void can_rx_offload_enable(struct can_rx_offload *offload);
 
-- 
2.30.2


