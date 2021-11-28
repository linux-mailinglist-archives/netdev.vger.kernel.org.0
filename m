Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBB7460638
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 13:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245582AbhK1MvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 07:51:15 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:51466 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345784AbhK1MtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 07:49:14 -0500
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id rJR2meSen2lVYrJRomr5SE; Sun, 28 Nov 2021 13:38:27 +0100
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sun, 28 Nov 2021 13:38:27 +0100
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Yasushi SHOJI <yashi@spacecubics.com>
Subject: [PATCH v3 3/5] can: do not copy the payload of RTR frames
Date:   Sun, 28 Nov 2021 21:37:32 +0900
Message-Id: <20211128123734.1049786-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211128123734.1049786-1-mailhol.vincent@wanadoo.fr>
References: <20211128123734.1049786-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The actual payload length of the CAN Remote Transmission Request (RTR)
frames is always 0, i.e. nothing is transmitted on the wire. However,
those RTR frames still use the DLC to indicate the length of the
requested frame.

For this reason, it is incorrect to copy the payload of RTR frames
(the payload buffer would only contain garbage data). This patch
encapsulates the payload copy in a check toward the RTR flag.

CC: Yasushi SHOJI <yashi@spacecubics.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
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
index 0579ab74f728..db3fa98569c4 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -733,7 +733,8 @@ static void mcp251x_hw_rx(struct spi_device *spi, int buf_idx)
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
2.32.0

