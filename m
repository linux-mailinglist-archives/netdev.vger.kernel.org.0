Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232C63F1AB4
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240285AbhHSNk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240231AbhHSNkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:40:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C53C061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:39:42 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGiGi-0004vp-OK
        for netdev@vger.kernel.org; Thu, 19 Aug 2021 15:39:40 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5548366A87C
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:39:34 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1FC6666A82F;
        Thu, 19 Aug 2021 13:39:25 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5ae2be16;
        Thu, 19 Aug 2021 13:39:16 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Matt Kline <matt@bitbashing.io>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 15/22] can: m_can: Batch FIFO writes during CAN transmit
Date:   Thu, 19 Aug 2021 15:39:06 +0200
Message-Id: <20210819133913.657715-16-mkl@pengutronix.de>
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

Give FIFO writes the same treatment as reads to avoid fixed costs of
individual transfers on a slow bus (e.g., tcan4x5x).

Link: https://lore.kernel.org/r/20210817050853.14875-4-matt@bitbashing.io
Signed-off-by: Matt Kline <matt@bitbashing.io>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 61 +++++++++++++++--------------------
 1 file changed, 26 insertions(+), 35 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index fbd32b48d265..2470c47b2e31 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -279,7 +279,7 @@ enum m_can_reg {
 /* Message RAM Elements */
 #define M_CAN_FIFO_ID		0x0
 #define M_CAN_FIFO_DLC		0x4
-#define M_CAN_FIFO_DATA(n)	(0x8 + ((n) << 2))
+#define M_CAN_FIFO_DATA		0x8
 
 /* Rx Buffer Element */
 /* R0 */
@@ -514,7 +514,7 @@ static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
 		if (fifo_header.dlc & RX_BUF_BRS)
 			cf->flags |= CANFD_BRS;
 
-		err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_DATA(0),
+		err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_DATA,
 				      cf->data, DIV_ROUND_UP(cf->len, 4));
 		if (err)
 			goto out_fail;
@@ -1588,8 +1588,9 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 	struct canfd_frame *cf = (struct canfd_frame *)cdev->tx_skb->data;
 	struct net_device *dev = cdev->net;
 	struct sk_buff *skb = cdev->tx_skb;
-	u32 id, dlc, cccr, fdflags;
-	int i, err;
+	struct id_and_dlc fifo_header;
+	u32 cccr, fdflags;
+	int err;
 	int putidx;
 
 	cdev->tx_skb = NULL;
@@ -1597,34 +1598,30 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 	/* Generate ID field for TX buffer Element */
 	/* Common to all supported M_CAN versions */
 	if (cf->can_id & CAN_EFF_FLAG) {
-		id = cf->can_id & CAN_EFF_MASK;
-		id |= TX_BUF_XTD;
+		fifo_header.id = cf->can_id & CAN_EFF_MASK;
+		fifo_header.id |= TX_BUF_XTD;
 	} else {
-		id = ((cf->can_id & CAN_SFF_MASK) << 18);
+		fifo_header.id = ((cf->can_id & CAN_SFF_MASK) << 18);
 	}
 
 	if (cf->can_id & CAN_RTR_FLAG)
-		id |= TX_BUF_RTR;
+		fifo_header.id |= TX_BUF_RTR;
 
 	if (cdev->version == 30) {
 		netif_stop_queue(dev);
 
-		/* message ram configuration */
-		err = m_can_fifo_write(cdev, 0, M_CAN_FIFO_ID, &id, 1);
+		fifo_header.dlc = can_fd_len2dlc(cf->len) << 16;
+
+		/* Write the frame ID, DLC, and payload to the FIFO element. */
+		err = m_can_fifo_write(cdev, 0, M_CAN_FIFO_ID, &fifo_header, 2);
 		if (err)
 			goto out_fail;
 
-		dlc = can_fd_len2dlc(cf->len) << 16;
-		err = m_can_fifo_write(cdev, 0, M_CAN_FIFO_DLC, &dlc, 1);
+		err = m_can_fifo_write(cdev, 0, M_CAN_FIFO_DATA,
+				       cf->data, DIV_ROUND_UP(cf->len, 4));
 		if (err)
 			goto out_fail;
 
-		for (i = 0; i < cf->len; i += 4) {
-			err = m_can_fifo_write(cdev, 0, M_CAN_FIFO_DATA(i / 4), cf->data + i, 1);
-			if (err)
-				goto out_fail;
-		}
-
 		can_put_echo_skb(skb, dev, 0, 0);
 
 		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD) {
@@ -1667,10 +1664,11 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		/* get put index for frame */
 		putidx = FIELD_GET(TXFQS_TFQPI_MASK,
 				   m_can_read(cdev, M_CAN_TXFQS));
-		/* Write ID Field to FIFO Element */
-		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID, &id, 1);
-		if (err)
-			goto out_fail;
+
+		/* Construct DLC Field, with CAN-FD configuration.
+		 * Use the put index of the fifo as the message marker,
+		 * used in the TX interrupt for sending the correct echo frame.
+		 */
 
 		/* get CAN FD configuration of frame */
 		fdflags = 0;
@@ -1680,24 +1678,17 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 				fdflags |= TX_BUF_BRS;
 		}
 
-		/* Construct DLC Field. Also contains CAN-FD configuration
-		 * use put index of fifo as message marker
-		 * it is used in TX interrupt for
-		 * sending the correct echo frame
-		 */
-		dlc = FIELD_PREP(TX_BUF_MM_MASK, putidx) |
+		fifo_header.dlc = FIELD_PREP(TX_BUF_MM_MASK, putidx) |
 			FIELD_PREP(TX_BUF_DLC_MASK, can_fd_len2dlc(cf->len)) |
 			fdflags | TX_BUF_EFC;
-		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DLC, &dlc, 1);
+		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID, &fifo_header, 2);
 		if (err)
 			goto out_fail;
 
-		for (i = 0; i < cf->len; i += 4) {
-			err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DATA(i / 4),
-					       cf->data + i, 1);
-			if (err)
-				goto out_fail;
-		}
+		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DATA,
+				       cf->data, DIV_ROUND_UP(cf->len, 4));
+		if (err)
+			goto out_fail;
 
 		/* Push loopback echo.
 		 * Will be looped back on TX interrupt based on message marker
-- 
2.32.0


