Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECF0F02F4
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390421AbfKEQcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:32:48 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56411 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390382AbfKEQcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:32:45 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iS1l6-0002Hp-ER; Tue, 05 Nov 2019 17:32:44 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 17/33] can: rx-offload: can_rx_offload_offload_one(): use ERR_PTR() to propagate error value in case of errors
Date:   Tue,  5 Nov 2019 17:31:59 +0100
Message-Id: <20191105163215.30194-18-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191105163215.30194-1-mkl@pengutronix.de>
References: <20191105163215.30194-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this patch can_rx_offload_offload_one() returns a pointer to a
skb containing the read CAN frame or a NULL pointer.

However the meaning of the NULL pointer is ambiguous, it can either mean
the requested mailbox is empty or there was an error.

This patch fixes this situation by returning:
- pointer to skb on success
- NULL pointer if mailbox is empty
- ERR_PTR() in case of an error

All users of can_rx_offload_offload_one() have been adopted, no
functional change intended.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rx-offload.c | 86 ++++++++++++++++++++++++++++++------
 1 file changed, 73 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index e224530a0630..3f5e040f0c71 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -107,39 +107,95 @@ static int can_rx_offload_compare(struct sk_buff *a, struct sk_buff *b)
 	return cb_b->timestamp - cb_a->timestamp;
 }
 
-static struct sk_buff *can_rx_offload_offload_one(struct can_rx_offload *offload, unsigned int n)
+/**
+ * can_rx_offload_offload_one() - Read one CAN frame from HW
+ * @offload: pointer to rx_offload context
+ * @n: number of mailbox to read
+ *
+ * The task of this function is to read a CAN frame from mailbox @n
+ * from the device and return the mailbox's content as a struct
+ * sk_buff.
+ *
+ * If the struct can_rx_offload::skb_queue exceeds the maximal queue
+ * length (struct can_rx_offload::skb_queue_len_max) or no skb can be
+ * allocated, the mailbox contents is discarded by reading it into an
+ * overflow buffer. This way the mailbox is marked as free by the
+ * driver.
+ *
+ * Return: A pointer to skb containing the CAN frame on success.
+ *
+ *         NULL if the mailbox @n is empty.
+ *
+ *         ERR_PTR() in case of an error
+ */
+static struct sk_buff *
+can_rx_offload_offload_one(struct can_rx_offload *offload, unsigned int n)
 {
-	struct sk_buff *skb = NULL;
+	struct sk_buff *skb = NULL, *skb_error = NULL;
 	struct can_rx_offload_cb *cb;
 	struct can_frame *cf;
 	int ret;
 
-	/* If queue is full or skb not available, read to discard mailbox */
 	if (likely(skb_queue_len(&offload->skb_queue) <
-		   offload->skb_queue_len_max))
+		   offload->skb_queue_len_max)) {
 		skb = alloc_can_skb(offload->dev, &cf);
+		if (unlikely(!skb))
+			skb_error = ERR_PTR(-ENOMEM);	/* skb alloc failed */
+	} else {
+		skb_error = ERR_PTR(-ENOBUFS);		/* skb_queue is full */
+	}
 
-	if (!skb) {
+	/* If queue is full or skb not available, drop by reading into
+	 * overflow buffer.
+	 */
+	if (unlikely(skb_error)) {
 		struct can_frame cf_overflow;
 		u32 timestamp;
 
 		ret = offload->mailbox_read(offload, &cf_overflow,
 					    &timestamp, n);
-		if (ret) {
-			offload->dev->stats.rx_dropped++;
-			offload->dev->stats.rx_fifo_errors++;
-		}
 
-		return NULL;
+		/* Mailbox was empty. */
+		if (unlikely(!ret))
+			return NULL;
+
+		/* Mailbox has been read and we're dropping it or
+		 * there was a problem reading the mailbox.
+		 *
+		 * Increment error counters in any case.
+		 */
+		offload->dev->stats.rx_dropped++;
+		offload->dev->stats.rx_fifo_errors++;
+
+		/* There was a problem reading the mailbox, propagate
+		 * error value.
+		 */
+		if (unlikely(ret < 0))
+			return ERR_PTR(ret);
+
+		return skb_error;
 	}
 
 	cb = can_rx_offload_get_cb(skb);
 	ret = offload->mailbox_read(offload, cf, &cb->timestamp, n);
-	if (!ret) {
+
+	/* Mailbox was empty. */
+	if (unlikely(!ret)) {
 		kfree_skb(skb);
 		return NULL;
 	}
 
+	/* There was a problem reading the mailbox, propagate error value. */
+	if (unlikely(ret < 0)) {
+		kfree_skb(skb);
+
+		offload->dev->stats.rx_dropped++;
+		offload->dev->stats.rx_fifo_errors++;
+
+		return ERR_PTR(ret);
+	}
+
+	/* Mailbox was read. */
 	return skb;
 }
 
@@ -159,7 +215,7 @@ int can_rx_offload_irq_offload_timestamp(struct can_rx_offload *offload, u64 pen
 			continue;
 
 		skb = can_rx_offload_offload_one(offload, i);
-		if (!skb)
+		if (IS_ERR_OR_NULL(skb))
 			break;
 
 		__skb_queue_add_sort(&skb_queue, skb, can_rx_offload_compare);
@@ -190,7 +246,11 @@ int can_rx_offload_irq_offload_fifo(struct can_rx_offload *offload)
 	struct sk_buff *skb;
 	int received = 0;
 
-	while ((skb = can_rx_offload_offload_one(offload, 0))) {
+	while (1) {
+		skb = can_rx_offload_offload_one(offload, 0);
+		if (IS_ERR_OR_NULL(skb))
+			break;
+
 		skb_queue_tail(&offload->skb_queue, skb);
 		received++;
 	}
-- 
2.24.0.rc1

