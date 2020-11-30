Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF222C8656
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgK3OQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgK3OP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:15:59 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6376FC0617A6
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:14:44 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kjjww-0007cq-UU
        for netdev@vger.kernel.org; Mon, 30 Nov 2020 15:14:42 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4C07159FAF2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:14:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6565E59FAC2;
        Mon, 30 Nov 2020 14:14:34 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2bffa97c;
        Mon, 30 Nov 2020 14:14:33 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Thomas Kopp <thomas.kopp@microchip.com>
Subject: [net-next 02/14] can: mcp251xfd: mcp25xxfd_ring_alloc(): add define instead open coding the maximum number of RX objects
Date:   Mon, 30 Nov 2020 15:14:20 +0100
Message-Id: <20201130141432.278219-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130141432.278219-1-mkl@pengutronix.de>
References: <20201130141432.278219-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add a define for the maximum number of RX objects instead of open
coding it.

Link: https://lore.kernel.org/r/20201126132144.351154-2-mkl@pengutronix.de
Tested-by: Thomas Kopp <thomas.kopp@microchip.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 3 ++-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h      | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index d0f2f5c73907..476a2e4a1de8 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -416,7 +416,8 @@ static int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv)
 		int rx_obj_num;
 
 		rx_obj_num = ram_free / rx_obj_size;
-		rx_obj_num = min(1 << (fls(rx_obj_num) - 1), 32);
+		rx_obj_num = min(1 << (fls(rx_obj_num) - 1),
+				 MCP251XFD_RX_OBJ_NUM_MAX);
 
 		rx_ring = kzalloc(sizeof(*rx_ring) + rx_obj_size * rx_obj_num,
 				  GFP_KERNEL);
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index fa1246e39980..c20c97d01072 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -368,6 +368,7 @@
  * FIFO setup: tef: 8*12 bytes = 96 bytes, tx: 8*16 bytes = 128 bytes
  * FIFO setup: tef: 4*12 bytes = 48 bytes, tx: 4*72 bytes = 288 bytes
  */
+#define MCP251XFD_RX_OBJ_NUM_MAX 32
 #define MCP251XFD_TX_OBJ_NUM_CAN 8
 #define MCP251XFD_TX_OBJ_NUM_CANFD 4
 
-- 
2.29.2


