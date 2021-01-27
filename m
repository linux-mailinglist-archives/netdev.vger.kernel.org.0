Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC8B305775
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 10:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbhA0Jy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 04:54:56 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47531 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235633AbhA0Jw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 04:52:28 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l4h2C-0008Gw-9C
        for netdev@vger.kernel.org; Wed, 27 Jan 2021 10:22:44 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 224525CF12B
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 09:22:40 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 91A985CF0EF;
        Wed, 27 Jan 2021 09:22:33 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 57bb6611;
        Wed, 27 Jan 2021 09:22:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 10/12] can: mcp251xfd: mcp251xfd_tx_obj_from_skb(): don't copy data for RTR CAN frames in TX-path
Date:   Wed, 27 Jan 2021 10:22:25 +0100
Message-Id: <20210127092227.2775573-11-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210127092227.2775573-1-mkl@pengutronix.de>
References: <20210127092227.2775573-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In Classical CAN there are RTR frames. RTR frames have the RTR bit set, may
have a dlc != 0, but contain no data.

This patch optimizes the TX-path to not copy any data for RTR frames.

Link: https://lore.kernel.org/r/20210114153448.1506901-5-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 92816be4f3d4..e6d98e172a47 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2304,7 +2304,7 @@ mcp251xfd_tx_obj_from_skb(const struct mcp251xfd_priv *priv,
 	union mcp251xfd_tx_obj_load_buf *load_buf;
 	u8 dlc;
 	u32 id, flags;
-	int pad_len, len;
+	int len_sanitized = 0, len;
 
 	if (cfd->can_id & CAN_EFF_FLAG) {
 		u32 sid, eid;
@@ -2331,6 +2331,8 @@ mcp251xfd_tx_obj_from_skb(const struct mcp251xfd_priv *priv,
 
 	if (cfd->can_id & CAN_RTR_FLAG)
 		flags |= MCP251XFD_OBJ_FLAGS_RTR;
+	else
+		len_sanitized = canfd_sanitize_len(cfd->len);
 
 	/* CANFD */
 	if (can_is_canfd_skb(skb)) {
@@ -2356,14 +2358,18 @@ mcp251xfd_tx_obj_from_skb(const struct mcp251xfd_priv *priv,
 	memcpy(hw_tx_obj->data, cfd->data, cfd->len);
 
 	/* Clear unused data at end of CAN frame */
-	pad_len = can_fd_dlc2len(dlc) - cfd->len;
-	if (MCP251XFD_SANITIZE_CAN && pad_len)
-		memset(hw_tx_obj->data + cfd->len, 0x0, pad_len);
+	if (MCP251XFD_SANITIZE_CAN && len_sanitized) {
+		int pad_len;
+
+		pad_len = len_sanitized - cfd->len;
+		if (pad_len)
+			memset(hw_tx_obj->data + cfd->len, 0x0, pad_len);
+	}
 
 	/* Number of bytes to be written into the RAM of the controller */
 	len = sizeof(hw_tx_obj->id) + sizeof(hw_tx_obj->flags);
 	if (MCP251XFD_SANITIZE_CAN)
-		len += round_up(can_fd_dlc2len(dlc), sizeof(u32));
+		len += round_up(len_sanitized, sizeof(u32));
 	else
 		len += round_up(cfd->len, sizeof(u32));
 
-- 
2.29.2


