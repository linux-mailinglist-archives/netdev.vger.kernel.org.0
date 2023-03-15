Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E766BAE9B
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbjCOLHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjCOLGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:06:47 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F3782367
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:06:38 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso919524wmo.0
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112; t=1678878397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ypZdWnRNDTGXAnkPh6LVaKjwNg77jYO2dJofBGuM+QE=;
        b=huSERv9rU/L1D67HT8F+JyU+EjfQBPwOlzECRS42tJwk7EuY0f4UVfiHb6pCDxx6IL
         qpW1WmSNslFEQPTbN87jNWljG/W5BbwNlYgHCy591VuNKF/ixGEOj00+E3Ax9/k4kpvw
         SfzTFxH00T4GVbhZMHYLlEpH/t7JddT/QBzZGLjP6ydJfTJxUFPBcCuygRukYq5TA6N6
         mkTzlVDQNvKq2kfRbq6ZoF8EP9/8yeW3viA8QkpSQewnnGfAnnXW/Qmh38hbl526ihyX
         v3N1zt6yadwXVTK21RxfteRtTpNpzsIF3V3Ejn8K3DCx2nlkKHqyAcWYRteQtWlGn/m6
         VJJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678878397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ypZdWnRNDTGXAnkPh6LVaKjwNg77jYO2dJofBGuM+QE=;
        b=JUDVH4RSIZPpSXdAAr9F9Vbk9rkdMoAvGvjC2CyWjmDNLBlFtPEtu7jejlO+Y2PKvd
         yuy9D0omZ9SaZi1Synm0Ce4iqzu4iIfvdAQapxOYZcJmskHt4WeiDhP3Nkn5D2ru6Llh
         F3S464FNcNyOYrA+i3cWPd2N922fvCU6XViZbgsRIZqfvXA845UvLRt7/jGeM1vuY8wu
         f0cGD8JvGu10vYWpgAKbNE7xt7pP/Fx/6BdIX09mbJhAhYzQI4GFtiKQ8vlWT5PkdsF2
         Fe7deYADbIyafMLPQKYo1lYPYmZ0/YanGmnMI6pan8Ar7tP45dzHEqHRh6KQTP4jEJ/a
         cH6A==
X-Gm-Message-State: AO0yUKV5zKbEg63LkZNSzahHbXQUlJi2LiH+y4n32NtRrZB4iAcF6+nN
        TAqosNCBVpVtQpq7wLAGIN3smA==
X-Google-Smtp-Source: AK7set+/KxeSJo6KSOJeUrUuALzWAwv+jWwglKpelEwaQjk+LGXnQXtRcgupZfjBf8Tksos101PrCg==
X-Received: by 2002:a05:600c:3c9e:b0:3e1:f8af:8772 with SMTP id bg30-20020a05600c3c9e00b003e1f8af8772mr17124880wmb.9.1678878397040;
        Wed, 15 Mar 2023 04:06:37 -0700 (PDT)
Received: from blmsp.fritz.box ([2001:4090:a247:8056:be7d:83e:a6a5:4659])
        by smtp.gmail.com with ESMTPSA id l4-20020a7bc444000000b003eafc47eb09sm1460563wmi.43.2023.03.15.04.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 04:06:36 -0700 (PDT)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v3 14/16] can: m_can: Use tx_fifo_in_flight for netif_queue control
Date:   Wed, 15 Mar 2023 12:05:44 +0100
Message-Id: <20230315110546.2518305-15-msp@baylibre.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315110546.2518305-1-msp@baylibre.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The network queue is currently always stopped in start_xmit and
continued in the interrupt handler. This is not possible anymore if we
want to keep multiple transmits in flight in parallel.

Use the previously introduced tx_fifo_in_flight counter to control the
network queue instead. This has the benefit of not needing to ask the
hardware about fifo status.

This patch stops the network queue in start_xmit if the number of
transmits in flight reaches the size of the fifo and wakes up the queue
from the interrupt handler once the transmits in flight drops below the
fifo size. This means any skbs over the limit will be rejected
immediately in start_xmit (it shouldn't be possible at all to reach that
state anyways).

The maximum number of transmits in flight is the size of the fifo.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 71 +++++++++++++----------------------
 1 file changed, 26 insertions(+), 45 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 4ad8f08f8284..3cb3d01e1a61 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -370,16 +370,6 @@ m_can_txe_fifo_read(struct m_can_classdev *cdev, u32 fgi, u32 offset, u32 *val)
 	return cdev->ops->read_fifo(cdev, addr_offset, val, 1);
 }
 
-static inline bool _m_can_tx_fifo_full(u32 txfqs)
-{
-	return !!(txfqs & TXFQS_TFQF);
-}
-
-static inline bool m_can_tx_fifo_full(struct m_can_classdev *cdev)
-{
-	return _m_can_tx_fifo_full(m_can_read(cdev, M_CAN_TXFQS));
-}
-
 static void m_can_config_endisable(struct m_can_classdev *cdev, bool enable)
 {
 	u32 cccr = m_can_read(cdev, M_CAN_CCCR);
@@ -1033,17 +1023,31 @@ static void m_can_finish_tx(struct m_can_classdev *cdev, int transmitted)
 	unsigned long irqflags;
 
 	spin_lock_irqsave(&cdev->tx_handling_spinlock, irqflags);
+	if (cdev->tx_fifo_in_flight >= cdev->tx_fifo_size && transmitted > 0)
+		netif_wake_queue(cdev->net);
 	cdev->tx_fifo_in_flight -= transmitted;
 	spin_unlock_irqrestore(&cdev->tx_handling_spinlock, irqflags);
 }
 
-static void m_can_start_tx(struct m_can_classdev *cdev)
+static netdev_tx_t m_can_start_tx(struct m_can_classdev *cdev)
 {
 	unsigned long irqflags;
+	int tx_fifo_in_flight;
 
 	spin_lock_irqsave(&cdev->tx_handling_spinlock, irqflags);
-	++cdev->tx_fifo_in_flight;
+	tx_fifo_in_flight = cdev->tx_fifo_in_flight + 1;
+	if (tx_fifo_in_flight >= cdev->tx_fifo_size) {
+		netif_stop_queue(cdev->net);
+		if (tx_fifo_in_flight > cdev->tx_fifo_size) {
+			netdev_err(cdev->net, "hard_xmit called while TX FIFO full\n");
+			spin_unlock_irqrestore(&cdev->tx_handling_spinlock, irqflags);
+			return NETDEV_TX_BUSY;
+		}
+	}
+	cdev->tx_fifo_in_flight = tx_fifo_in_flight;
 	spin_unlock_irqrestore(&cdev->tx_handling_spinlock, irqflags);
+
+	return NETDEV_TX_OK;
 }
 
 static int m_can_echo_tx_event(struct net_device *dev)
@@ -1187,7 +1191,6 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 			if (cdev->is_peripheral)
 				timestamp = m_can_get_timestamp(cdev);
 			m_can_tx_update_stats(cdev, 0, timestamp);
-			netif_wake_queue(dev);
 			m_can_finish_tx(cdev, 1);
 		}
 	} else  {
@@ -1195,10 +1198,6 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 			/* New TX FIFO Element arrived */
 			if (m_can_echo_tx_event(dev) != 0)
 				goto out_fail;
-
-			if (netif_queue_stopped(dev) &&
-			    !m_can_tx_fifo_full(cdev))
-				netif_wake_queue(dev);
 		}
 	}
 
@@ -1719,7 +1718,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
 	struct net_device *dev = cdev->net;
 	struct id_and_dlc fifo_header;
 	u32 cccr, fdflags;
-	u32 txfqs;
 	int err;
 	int putidx;
 
@@ -1776,24 +1774,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
 		u8 len_padded = DIV_ROUND_UP(cf->len, 4);
 		/* Transmit routine for version >= v3.1.x */
 
-		txfqs = m_can_read(cdev, M_CAN_TXFQS);
-
-		/* Check if FIFO full */
-		if (_m_can_tx_fifo_full(txfqs)) {
-			/* This shouldn't happen */
-			netif_stop_queue(dev);
-			netdev_warn(dev,
-				    "TX queue active although FIFO is full.");
-
-			if (cdev->is_peripheral) {
-				kfree_skb(skb);
-				dev->stats.tx_dropped++;
-				return NETDEV_TX_OK;
-			} else {
-				return NETDEV_TX_BUSY;
-			}
-		}
-
 		/* get put index for frame */
 		putidx = cdev->tx_fifo_putidx;
 
@@ -1830,11 +1810,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
 		m_can_write(cdev, M_CAN_TXBAR, (1 << putidx));
 		cdev->tx_fifo_putidx = (++cdev->tx_fifo_putidx >= cdev->can.echo_skb_max ?
 					0 : cdev->tx_fifo_putidx);
-
-		/* stop network queue if fifo full */
-		if (m_can_tx_fifo_full(cdev) ||
-		    m_can_next_echo_skb_occupied(dev, putidx))
-			netif_stop_queue(dev);
 	}
 
 	return NETDEV_TX_OK;
@@ -1868,14 +1843,16 @@ static void m_can_tx_queue_skb(struct m_can_classdev *cdev, struct sk_buff *skb)
 static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
 					       struct sk_buff *skb)
 {
+	netdev_tx_t err;
+
 	if (cdev->can.state == CAN_STATE_BUS_OFF) {
 		m_can_clean(cdev->net);
 		return NETDEV_TX_OK;
 	}
 
-	netif_stop_queue(cdev->net);
-
-	m_can_start_tx(cdev);
+	err = m_can_start_tx(cdev);
+	if (err != NETDEV_TX_OK)
+		return err;
 
 	m_can_tx_queue_skb(cdev, skb);
 
@@ -1885,7 +1862,11 @@ static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
 static netdev_tx_t m_can_start_fast_xmit(struct m_can_classdev *cdev,
 					 struct sk_buff *skb)
 {
-	m_can_start_tx(cdev);
+	netdev_tx_t err;
+
+	err = m_can_start_tx(cdev);
+	if (err != NETDEV_TX_OK)
+		return err;
 
 	return m_can_tx_handler(cdev, skb);
 }
-- 
2.39.2

