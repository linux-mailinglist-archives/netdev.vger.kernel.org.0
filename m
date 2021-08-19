Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625BA3F1AB2
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240213AbhHSNk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240199AbhHSNkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:40:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E40C06175F
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:39:42 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGiGi-0004w9-O4
        for netdev@vger.kernel.org; Thu, 19 Aug 2021 15:39:40 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 571FF66A87E
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:39:34 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id ECFF266A82C;
        Thu, 19 Aug 2021 13:39:24 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 7e1e2a6c;
        Thu, 19 Aug 2021 13:39:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Matt Kline <matt@bitbashing.io>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 14/22] can: m_can: Batch FIFO reads during CAN receive
Date:   Thu, 19 Aug 2021 15:39:05 +0200
Message-Id: <20210819133913.657715-15-mkl@pengutronix.de>
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

From: Matt Kline <matt@bitbashing.io>

On peripherals communicating over a relatively slow SPI line
(e.g. tcan4x5x), individual transfers have high fixed costs.
This causes the driver to spend most of its time waiting between
transfers and severely limits throughput.

Reduce these overheads by reading more than one word at a time.
Writing could get a similar treatment in follow-on commits.

Link: https://lore.kernel.org/r/20210817050853.14875-3-matt@bitbashing.io
Signed-off-by: Matt Kline <matt@bitbashing.io>
[mkl: remove __packed from struct id_and_dlc]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 51 +++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 8922ca0f8e94..fbd32b48d265 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -309,6 +309,15 @@ enum m_can_reg {
 #define TX_EVENT_MM_MASK	GENMASK(31, 24)
 #define TX_EVENT_TXTS_MASK	GENMASK(15, 0)
 
+/* The ID and DLC registers are adjacent in M_CAN FIFO memory,
+ * and we can save a (potentially slow) bus round trip by combining
+ * reads and writes to them.
+ */
+struct id_and_dlc {
+	u32 id;
+	u32 dlc;
+};
+
 static inline u32 m_can_read(struct m_can_classdev *cdev, enum m_can_reg reg)
 {
 	return cdev->ops->read_reg(cdev, reg);
@@ -464,17 +473,18 @@ static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	struct canfd_frame *cf;
 	struct sk_buff *skb;
-	u32 id, fgi, dlc;
+	struct id_and_dlc fifo_header;
+	u32 fgi;
 	u32 timestamp = 0;
-	int i, err;
+	int err;
 
 	/* calculate the fifo get index for where to read data */
 	fgi = FIELD_GET(RXFS_FGI_MASK, rxfs);
-	err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_DLC, &dlc, 1);
+	err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_ID, &fifo_header, 2);
 	if (err)
 		goto out_fail;
 
-	if (dlc & RX_BUF_FDF)
+	if (fifo_header.dlc & RX_BUF_FDF)
 		skb = alloc_canfd_skb(dev, &cf);
 	else
 		skb = alloc_can_skb(dev, (struct can_frame **)&cf);
@@ -483,36 +493,31 @@ static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
 		return 0;
 	}
 
-	if (dlc & RX_BUF_FDF)
-		cf->len = can_fd_dlc2len((dlc >> 16) & 0x0F);
+	if (fifo_header.dlc & RX_BUF_FDF)
+		cf->len = can_fd_dlc2len((fifo_header.dlc >> 16) & 0x0F);
 	else
-		cf->len = can_cc_dlc2len((dlc >> 16) & 0x0F);
-
-	err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_ID, &id, 1);
-	if (err)
-		goto out_fail;
+		cf->len = can_cc_dlc2len((fifo_header.dlc >> 16) & 0x0F);
 
-	if (id & RX_BUF_XTD)
-		cf->can_id = (id & CAN_EFF_MASK) | CAN_EFF_FLAG;
+	if (fifo_header.id & RX_BUF_XTD)
+		cf->can_id = (fifo_header.id & CAN_EFF_MASK) | CAN_EFF_FLAG;
 	else
-		cf->can_id = (id >> 18) & CAN_SFF_MASK;
+		cf->can_id = (fifo_header.id >> 18) & CAN_SFF_MASK;
 
-	if (id & RX_BUF_ESI) {
+	if (fifo_header.id & RX_BUF_ESI) {
 		cf->flags |= CANFD_ESI;
 		netdev_dbg(dev, "ESI Error\n");
 	}
 
-	if (!(dlc & RX_BUF_FDF) && (id & RX_BUF_RTR)) {
+	if (!(fifo_header.dlc & RX_BUF_FDF) && (fifo_header.id & RX_BUF_RTR)) {
 		cf->can_id |= CAN_RTR_FLAG;
 	} else {
-		if (dlc & RX_BUF_BRS)
+		if (fifo_header.dlc & RX_BUF_BRS)
 			cf->flags |= CANFD_BRS;
 
-		for (i = 0; i < cf->len; i += 4) {
-			err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_DATA(i / 4), cf->data + i, 1);
-			if (err)
-				goto out_fail;
-		}
+		err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_DATA(0),
+				      cf->data, DIV_ROUND_UP(cf->len, 4));
+		if (err)
+			goto out_fail;
 	}
 
 	/* acknowledge rx fifo 0 */
@@ -521,7 +526,7 @@ static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
 	stats->rx_packets++;
 	stats->rx_bytes += cf->len;
 
-	timestamp = FIELD_GET(RX_BUF_RXTS_MASK, dlc);
+	timestamp = FIELD_GET(RX_BUF_RXTS_MASK, fifo_header.dlc);
 
 	m_can_receive_skb(cdev, skb, timestamp);
 
-- 
2.32.0


