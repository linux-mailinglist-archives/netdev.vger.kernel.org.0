Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8CD3D5B2F
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbhGZNcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbhGZNbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:31:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1129C061381
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81L0-0001El-Br
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:10 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6F39B6581E2
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:11:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A356165816A;
        Mon, 26 Jul 2021 14:11:47 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 74c62393;
        Mon, 26 Jul 2021 14:11:45 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH net-next 09/46] can: rx-offload: can_rx_offload_threaded_irq_finish(): add new function to be called from threaded interrupt
Date:   Mon, 26 Jul 2021 16:11:07 +0200
Message-Id: <20210726141144.862529-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After reading all CAN frames from the controller in the IRQ handler
and storing them into a skb_queue, the driver calls napi_schedule().
In the napi poll function the skb from the skb_queue are then pushed
into the networking stack.

However if napi_schedule() is called from a threaded IRQ handler this
triggers the following error:

| NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!

To avoid this, create a new rx-offload
function (can_rx_offload_threaded_irq_finish()) with a call to
local_bh_disable()/local_bh_enable() around the napi_schedule() call.

Convert all drivers that call can_rx_offload_irq_finish() from
threaded IRQ context to can_rx_offload_threaded_irq_finish().

Link: https://lore.kernel.org/r/20210724204745.736053-4-mkl@pengutronix.de
Suggested-by: Daniel Glöckner <dg@emlix.com>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/rx-offload.c              | 23 +++++++++++++++++++
 drivers/net/can/m_can/m_can.c                 |  2 +-
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    |  4 ++--
 include/linux/can/rx-offload.h                |  1 +
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/dev/rx-offload.c b/drivers/net/can/dev/rx-offload.c
index 82ade3aa5c13..37b0cc65237b 100644
--- a/drivers/net/can/dev/rx-offload.c
+++ b/drivers/net/can/dev/rx-offload.c
@@ -299,6 +299,29 @@ void can_rx_offload_irq_finish(struct can_rx_offload *offload)
 }
 EXPORT_SYMBOL_GPL(can_rx_offload_irq_finish);
 
+void can_rx_offload_threaded_irq_finish(struct can_rx_offload *offload)
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
+	local_bh_disable();
+	napi_schedule(&offload->napi);
+	local_bh_enable();
+}
+EXPORT_SYMBOL_GPL(can_rx_offload_threaded_irq_finish);
+
 static int can_rx_offload_init_queue(struct net_device *dev,
 				     struct can_rx_offload *offload,
 				     unsigned int weight)
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 18461982f7a1..317cdc98c539 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1059,7 +1059,7 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 	}
 
 	if (cdev->is_peripheral)
-		can_rx_offload_irq_finish(&cdev->offload);
+		can_rx_offload_threaded_irq_finish(&cdev->offload);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index f3b267ec22e0..6962ab2749df 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2196,7 +2196,7 @@ static irqreturn_t mcp251xfd_irq(int irq, void *dev_id)
 				  priv->regs_status.intf);
 
 		if (!(intf_pending)) {
-			can_rx_offload_irq_finish(&priv->offload);
+			can_rx_offload_threaded_irq_finish(&priv->offload);
 			return handled;
 		}
 
@@ -2298,7 +2298,7 @@ static irqreturn_t mcp251xfd_irq(int irq, void *dev_id)
 	} while (1);
 
  out_fail:
-	can_rx_offload_irq_finish(&priv->offload);
+	can_rx_offload_threaded_irq_finish(&priv->offload);
 
 	netdev_err(priv->ndev, "IRQ handler returned %d (intf=0x%08x).\n",
 		   err, priv->regs_status.intf);
diff --git a/include/linux/can/rx-offload.h b/include/linux/can/rx-offload.h
index 516f64df0ebc..c11477620403 100644
--- a/include/linux/can/rx-offload.h
+++ b/include/linux/can/rx-offload.h
@@ -50,6 +50,7 @@ unsigned int can_rx_offload_get_echo_skb(struct can_rx_offload *offload,
 int can_rx_offload_queue_tail(struct can_rx_offload *offload,
 			      struct sk_buff *skb);
 void can_rx_offload_irq_finish(struct can_rx_offload *offload);
+void can_rx_offload_threaded_irq_finish(struct can_rx_offload *offload);
 void can_rx_offload_del(struct can_rx_offload *offload);
 void can_rx_offload_enable(struct can_rx_offload *offload);
 
-- 
2.30.2


