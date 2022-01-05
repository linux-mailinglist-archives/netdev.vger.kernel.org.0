Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9FC4854E3
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiAEOoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241024AbiAEOoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:44:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67824C061395
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 06:44:20 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n57WU-0004ET-Mz
        for netdev@vger.kernel.org; Wed, 05 Jan 2022 15:44:18 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4C94C6D1B1A
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 14:44:10 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id BD6D96D1AC8;
        Wed,  5 Jan 2022 14:44:05 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 79ed08d4;
        Wed, 5 Jan 2022 14:44:04 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Yasushi SHOJI <yashi@spacecubics.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 09/15] can: do not copy the payload of RTR frames
Date:   Wed,  5 Jan 2022 15:43:56 +0100
Message-Id: <20220105144402.1174191-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220105144402.1174191-1-mkl@pengutronix.de>
References: <20220105144402.1174191-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The actual payload length of the CAN Remote Transmission Request (RTR)
frames is always 0, i.e. no payload is transmitted on the wire.
However, those RTR frames still use the DLC to indicate the length of
the requested frame.

For this reason, it is incorrect to copy the payload of RTR frames
(the payload buffer would only contain garbage data). This patch
encapsulates the payload copy in a check toward the RTR flag.

Link: https://lore.kernel.org/all/20211207121531.42941-4-mailhol.vincent@wanadoo.fr
Cc: Yasushi SHOJI <yashi@spacecubics.com>
Tested-by: Yasushi SHOJI <yashi@spacecubics.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/pch_can.c      | 15 ++++++++-------
 drivers/net/can/spi/mcp251x.c  |  3 ++-
 drivers/net/can/usb/mcba_usb.c |  8 ++++----
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 6b45840db1f9..4bf9bfc4de72 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -677,16 +677,17 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
 			cf->can_id = id;
 		}
 
-		if (id2 & PCH_ID2_DIR)
-			cf->can_id |= CAN_RTR_FLAG;
-
 		cf->len = can_cc_dlc2len((ioread32(&priv->regs->
 						    ifregs[0].mcont)) & 0xF);
 
-		for (i = 0; i < cf->len; i += 2) {
-			data_reg = ioread16(&priv->regs->ifregs[0].data[i / 2]);
-			cf->data[i] = data_reg;
-			cf->data[i + 1] = data_reg >> 8;
+		if (id2 & PCH_ID2_DIR) {
+			cf->can_id |= CAN_RTR_FLAG;
+		} else {
+			for (i = 0; i < cf->len; i += 2) {
+				data_reg = ioread16(&priv->regs->ifregs[0].data[i / 2]);
+				cf->data[i] = data_reg;
+				cf->data[i + 1] = data_reg >> 8;
+			}
 		}
 
 		rcv_pkts++;
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 0cec808e8727..2fa1e85fa529 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -730,7 +730,8 @@ static void mcp251x_hw_rx(struct spi_device *spi, int buf_idx)
 	}
 	/* Data length */
 	frame->len = can_cc_dlc2len(buf[RXBDLC_OFF] & RXBDLC_LEN_MASK);
-	memcpy(frame->data, buf + RXBDAT_OFF, frame->len);
+	if (!(frame->can_id & CAN_RTR_FLAG))
+		memcpy(frame->data, buf + RXBDAT_OFF, frame->len);
 
 	priv->net->stats.rx_packets++;
 	priv->net->stats.rx_bytes += frame->len;
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index a1a154c08b7f..162d2e11cadd 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -450,12 +450,12 @@ static void mcba_usb_process_can(struct mcba_priv *priv,
 		cf->can_id = (sid & 0xffe0) >> 5;
 	}
 
-	if (msg->dlc & MCBA_DLC_RTR_MASK)
-		cf->can_id |= CAN_RTR_FLAG;
-
 	cf->len = can_cc_dlc2len(msg->dlc & MCBA_DLC_MASK);
 
-	memcpy(cf->data, msg->data, cf->len);
+	if (msg->dlc & MCBA_DLC_RTR_MASK)
+		cf->can_id |= CAN_RTR_FLAG;
+	else
+		memcpy(cf->data, msg->data, cf->len);
 
 	stats->rx_packets++;
 	stats->rx_bytes += cf->len;
-- 
2.34.1


