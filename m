Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D084D73CE
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 09:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbiCMIxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 04:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbiCMIwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 04:52:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7FA205D5
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 00:51:46 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nTJx2-0000TL-3k
        for netdev@vger.kernel.org; Sun, 13 Mar 2022 09:51:44 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C5B6A49B50
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 08:51:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7CB4F49B3B;
        Sun, 13 Mar 2022 08:51:39 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 18d3d587;
        Sun, 13 Mar 2022 08:51:38 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 06/13] can: mcp251xfd: ring: prepare support for runtime configurable RX/TX ring parameters
Date:   Sun, 13 Mar 2022 09:51:31 +0100
Message-Id: <20220313085138.507062-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220313085138.507062-1-mkl@pengutronix.de>
References: <20220313085138.507062-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch prepares the driver for runtime configurable RX and TX ring
parameters. The actual runtime config support will be added in the
next patch.

Link: https://lore.kernel.org/20220313083640.501791-6-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-ring.c    | 26 ++++++++-----------
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |  2 ++
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
index e540c97b4160..0e78941601bf 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -289,9 +289,9 @@ int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv)
 {
 	struct mcp251xfd_tx_ring *tx_ring;
 	struct mcp251xfd_rx_ring *rx_ring;
-	int tef_obj_size, tx_obj_size, rx_obj_size;
-	int tx_obj_num;
-	int ram_free, i;
+	u8 tef_obj_size, tx_obj_size, rx_obj_size;
+	u8 tx_obj_num;
+	u8 rem, i;
 
 	tef_obj_size = sizeof(struct mcp251xfd_hw_tef_obj);
 	if (mcp251xfd_is_fd_mode(priv)) {
@@ -310,17 +310,14 @@ int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv)
 	tx_ring->obj_num = tx_obj_num;
 	tx_ring->obj_size = tx_obj_size;
 
-	ram_free = MCP251XFD_RAM_SIZE - tx_obj_num *
-		(tef_obj_size + tx_obj_size);
+	rem = (MCP251XFD_RAM_SIZE - tx_obj_num *
+	       (tef_obj_size + tx_obj_size)) / rx_obj_size;
+	for (i = 0; i < ARRAY_SIZE(priv->rx) && rem; i++) {
+		u8 rx_obj_num;
 
-	for (i = 0;
-	     i < ARRAY_SIZE(priv->rx) && ram_free >= rx_obj_size;
-	     i++) {
-		int rx_obj_num;
-
-		rx_obj_num = ram_free / rx_obj_size;
-		rx_obj_num = min(1 << (fls(rx_obj_num) - 1),
-				 MCP251XFD_RX_OBJ_NUM_MAX);
+		rx_obj_num = min_t(u8, rounddown_pow_of_two(rem),
+				   MCP251XFD_FIFO_DEPTH);
+		rem -= rx_obj_num;
 
 		priv->rx_obj_num += rx_obj_num;
 
@@ -330,11 +327,10 @@ int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv)
 			mcp251xfd_ring_free(priv);
 			return -ENOMEM;
 		}
+
 		rx_ring->obj_num = rx_obj_num;
 		rx_ring->obj_size = rx_obj_size;
 		priv->rx[i] = rx_ring;
-
-		ram_free -= rx_ring->obj_num * rx_ring->obj_size;
 	}
 	priv->rx_ring_num = i;
 
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index 5c7a672464b1..bd7a9999b5e3 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -415,6 +415,8 @@ static_assert(MCP251XFD_TIMESTAMP_WORK_DELAY_SEC <
 #define MCP251XFD_FIFO_RX_NUM_MAX 1U
 #define MCP251XFD_FIFO_TX_NUM 1U
 
+#define MCP251XFD_FIFO_DEPTH 32U
+
 static_assert(MCP251XFD_FIFO_TEF_NUM == 1U);
 static_assert(MCP251XFD_FIFO_TEF_NUM == MCP251XFD_FIFO_TX_NUM);
 static_assert(MCP251XFD_FIFO_RX_NUM_MAX <= 4U);
-- 
2.35.1


