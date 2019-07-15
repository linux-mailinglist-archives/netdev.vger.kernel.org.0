Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2982369B0B
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 20:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbfGOSxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 14:53:21 -0400
Received: from first.geanix.com ([116.203.34.67]:42686 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729513AbfGOSxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 14:53:21 -0400
Received: from zen.localdomain (unknown [85.184.140.241])
        by first.geanix.com (Postfix) with ESMTPSA id BE061439D7;
        Mon, 15 Jul 2019 18:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1563216774; bh=A/pOZIc6LJmtheAJTggufzDiQG1gWvquPFCDdSL0QZQ=;
        h=From:To:Cc:Subject:Date;
        b=Vu2H9HOC1XFaXeeNaqGXSO6Hgdruc89lNO1zbrksAiQHxIRRrgphzjtQs55tPup+J
         Tu7fyIXw+CtECoP/UxGjapLUwfikBs4qhCCldPqUdnevw2A4sRdIBI8adbLou1yIVD
         KaXP/aYFa1R5TcpFvuFPl78YnFEnaudVAZEEJUClZzQ6E9wHxGjjb7cvgsQ2PwFD3I
         wR8J/NAAeZR6wOcjpwla4d0eJs085B1CxptZ3mXZ0DUyygh6Blrr6FMM4FWhTdbOSR
         Nc8EFb4js1lMJP4HIW258uboYHYbkNMW+f5wbEKXwZOg/or4Cr/pmAfVgVjvaBp22M
         QD1HediEQupTA==
From:   =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Sean Nyekjaer <sean@geanix.com>
Subject: [PATCH] can: flexcan: free error skb if enqueueing failed
Date:   Mon, 15 Jul 2019 20:53:08 +0200
Message-Id: <20190715185308.104333-1-martin@geanix.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 8945dcc0271d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the call to can_rx_offload_queue_sorted() fails, the passed skb isn't
consumed, so the caller must do so.

Fixes: 30164759db1b ("can: flexcan: make use of rx-offload's irq_offload_fifo")
Signed-off-by: Martin Hundebøll <martin@geanix.com>
---
 drivers/net/can/flexcan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 1c66fb2ad76b..21f39e805d42 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -688,7 +688,8 @@ static void flexcan_irq_bus_err(struct net_device *dev, u32 reg_esr)
 	if (tx_errors)
 		dev->stats.tx_errors++;
 
-	can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
+	if (can_rx_offload_queue_sorted(&priv->offload, skb, timestamp))
+		kfree_skb(skb);
 }
 
 static void flexcan_irq_state(struct net_device *dev, u32 reg_esr)
@@ -732,7 +733,8 @@ static void flexcan_irq_state(struct net_device *dev, u32 reg_esr)
 	if (unlikely(new_state == CAN_STATE_BUS_OFF))
 		can_bus_off(dev);
 
-	can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
+	if (can_rx_offload_queue_sorted(&priv->offload, skb, timestamp))
+		kfree_skb(skb);
 }
 
 static inline struct flexcan_priv *rx_offload_to_priv(struct can_rx_offload *offload)
-- 
2.22.0

