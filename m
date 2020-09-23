Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC0B2753C1
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgIWIyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbgIWIyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:54:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CB5C0613D4
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 01:54:31 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kL0Xk-0000uS-GH; Wed, 23 Sep 2020 10:54:28 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, michael@walle.cc, qiangqing.zhang@nxp.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 14/20] can: flexcan: use struct canfd_frame for CAN classic frame
Date:   Wed, 23 Sep 2020 10:54:12 +0200
Message-Id: <20200923085418.2685858-15-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923085418.2685858-1-mkl@pengutronix.de>
References: <20200923085418.2685858-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

This patch prepares for CAN FD mode, using struct canfd_frame can both
for classic format frame and fd format frame.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: https://lore.kernel.org/r/20190712075926.7357-3-qiangqing.zhang@nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index a9908deae411..20c845c265e1 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -646,10 +646,10 @@ static int flexcan_get_berr_counter(const struct net_device *dev,
 static netdev_tx_t flexcan_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	const struct flexcan_priv *priv = netdev_priv(dev);
-	struct can_frame *cf = (struct can_frame *)skb->data;
+	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 	u32 can_id;
 	u32 data;
-	u32 ctrl = FLEXCAN_MB_CODE_TX_DATA | (cf->can_dlc << 16);
+	u32 ctrl = FLEXCAN_MB_CODE_TX_DATA | (cfd->len << 16);
 	int i;
 
 	if (can_dropped_invalid_skb(dev, skb))
@@ -657,18 +657,18 @@ static netdev_tx_t flexcan_start_xmit(struct sk_buff *skb, struct net_device *de
 
 	netif_stop_queue(dev);
 
-	if (cf->can_id & CAN_EFF_FLAG) {
-		can_id = cf->can_id & CAN_EFF_MASK;
+	if (cfd->can_id & CAN_EFF_FLAG) {
+		can_id = cfd->can_id & CAN_EFF_MASK;
 		ctrl |= FLEXCAN_MB_CNT_IDE | FLEXCAN_MB_CNT_SRR;
 	} else {
-		can_id = (cf->can_id & CAN_SFF_MASK) << 18;
+		can_id = (cfd->can_id & CAN_SFF_MASK) << 18;
 	}
 
-	if (cf->can_id & CAN_RTR_FLAG)
+	if (cfd->can_id & CAN_RTR_FLAG)
 		ctrl |= FLEXCAN_MB_CNT_RTR;
 
-	for (i = 0; i < cf->can_dlc; i += sizeof(u32)) {
-		data = be32_to_cpup((__be32 *)&cf->data[i]);
+	for (i = 0; i < cfd->len; i += sizeof(u32)) {
+		data = be32_to_cpup((__be32 *)&cfd->data[i]);
 		priv->write(data, &priv->tx_mb->data[i / sizeof(u32)]);
 	}
 
@@ -840,7 +840,7 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 	struct flexcan_regs __iomem *regs = priv->regs;
 	struct flexcan_mb __iomem *mb;
 	struct sk_buff *skb;
-	struct can_frame *cf;
+	struct canfd_frame *cfd;
 	u32 reg_ctrl, reg_id, reg_iflag1;
 	int i;
 
@@ -877,8 +877,8 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 		reg_ctrl = priv->read(&mb->can_ctrl);
 	}
 
-	skb = alloc_can_skb(offload->dev, &cf);
-	if (!skb) {
+	skb = alloc_can_skb(offload->dev, (struct can_frame **)&cfd);
+	if (unlikely(!skb)) {
 		skb = ERR_PTR(-ENOMEM);
 		goto mark_as_read;
 	}
@@ -888,17 +888,17 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 
 	reg_id = priv->read(&mb->can_id);
 	if (reg_ctrl & FLEXCAN_MB_CNT_IDE)
-		cf->can_id = ((reg_id >> 0) & CAN_EFF_MASK) | CAN_EFF_FLAG;
+		cfd->can_id = ((reg_id >> 0) & CAN_EFF_MASK) | CAN_EFF_FLAG;
 	else
-		cf->can_id = (reg_id >> 18) & CAN_SFF_MASK;
+		cfd->can_id = (reg_id >> 18) & CAN_SFF_MASK;
 
 	if (reg_ctrl & FLEXCAN_MB_CNT_RTR)
-		cf->can_id |= CAN_RTR_FLAG;
-	cf->can_dlc = get_can_dlc((reg_ctrl >> 16) & 0xf);
+		cfd->can_id |= CAN_RTR_FLAG;
+	cfd->len = get_can_dlc((reg_ctrl >> 16) & 0xf);
 
-	for (i = 0; i < cf->can_dlc; i += sizeof(u32)) {
+	for (i = 0; i < cfd->len; i += sizeof(u32)) {
 		__be32 data = cpu_to_be32(priv->read(&mb->data[i / sizeof(u32)]));
-		*(__be32 *)(cf->data + i) = data;
+		*(__be32 *)(cfd->data + i) = data;
 	}
 
  mark_as_read:
-- 
2.28.0

