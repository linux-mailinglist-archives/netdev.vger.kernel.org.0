Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2274C1EF4
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244653AbiBWWpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244637AbiBWWpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:45:06 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F4F5418B
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 14:43:59 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN0MX-0006tq-Ur
        for netdev@vger.kernel.org; Wed, 23 Feb 2022 23:43:58 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C3C513BC5B
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 22:43:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 78F8D3BC3B;
        Wed, 23 Feb 2022 22:43:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id b8455338;
        Wed, 23 Feb 2022 22:43:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 34/36] can: mcp251xfd: ring: update FIFO setup debug info
Date:   Wed, 23 Feb 2022 23:43:30 +0100
Message-Id: <20220223224332.2965690-35-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223224332.2965690-1-mkl@pengutronix.de>
References: <20220223224332.2965690-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recent change of the order of the TX and RX FIFOs is not reflected
in the debug info of the FIFO setup. This patch adjust the order and
additionally prints the base address of each FIFO.

Since the mcp251xfd_ring_init() may fail due to wrongly configured
FIFOs, printing of the FIFO setup is moved there. In case of an error
it would not be printed in mcp251xfd_ring_init().

Link: https://lore.kernel.org/all/20220217103826.2299157-7-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-ring.c    | 44 ++++++++++++-------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
index 8126f88d57d7..9610d262e966 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -209,8 +209,10 @@ mcp251xfd_ring_init_rx(struct mcp251xfd_priv *priv, u16 *base, u8 *fifo_nr)
 
 int mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 {
+	const struct mcp251xfd_rx_ring *rx_ring;
 	u16 base = 0, ram_used;
 	u8 fifo_nr = 1;
+	int i;
 
 	netdev_reset_queue(priv->ndev);
 
@@ -218,6 +220,32 @@ int mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 	mcp251xfd_ring_init_rx(priv, &base, &fifo_nr);
 	mcp251xfd_ring_init_tx(priv, &base, &fifo_nr);
 
+	netdev_dbg(priv->ndev,
+		   "FIFO setup: TEF:         0x%03x: %2d*%zu bytes = %4zu bytes\n",
+		   mcp251xfd_get_tef_obj_addr(0),
+		   priv->tx->obj_num, sizeof(struct mcp251xfd_hw_tef_obj),
+		   priv->tx->obj_num * sizeof(struct mcp251xfd_hw_tef_obj));
+
+	mcp251xfd_for_each_rx_ring(priv, rx_ring, i) {
+		netdev_dbg(priv->ndev,
+			   "FIFO setup: RX-%u: FIFO %u/0x%03x: %2u*%u bytes = %4u bytes\n",
+			   rx_ring->nr, rx_ring->fifo_nr,
+			   mcp251xfd_get_rx_obj_addr(rx_ring, 0),
+			   rx_ring->obj_num, rx_ring->obj_size,
+			   rx_ring->obj_num * rx_ring->obj_size);
+	}
+
+	netdev_dbg(priv->ndev,
+		   "FIFO setup: TX:   FIFO %u/0x%03x: %2u*%u bytes = %4u bytes\n",
+		   priv->tx->fifo_nr,
+		   mcp251xfd_get_tx_obj_addr(priv->tx, 0),
+		   priv->tx->obj_num, priv->tx->obj_size,
+		   priv->tx->obj_num * priv->tx->obj_size);
+
+	netdev_dbg(priv->ndev,
+		   "FIFO setup: free:                             %4u bytes\n",
+		   MCP251XFD_RAM_SIZE - (base - MCP251XFD_RAM_START));
+
 	ram_used = base - MCP251XFD_RAM_START;
 	if (ram_used > MCP251XFD_RAM_SIZE) {
 		netdev_err(priv->ndev,
@@ -288,21 +316,5 @@ int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv)
 	}
 	priv->rx_ring_num = i;
 
-	netdev_dbg(priv->ndev,
-		   "FIFO setup: TEF: %d*%d bytes = %d bytes, TX: %d*%d bytes = %d bytes\n",
-		   tx_obj_num, tef_obj_size, tef_obj_size * tx_obj_num,
-		   tx_obj_num, tx_obj_size, tx_obj_size * tx_obj_num);
-
-	mcp251xfd_for_each_rx_ring(priv, rx_ring, i) {
-		netdev_dbg(priv->ndev,
-			   "FIFO setup: RX-%d: %d*%d bytes = %d bytes\n",
-			   i, rx_ring->obj_num, rx_ring->obj_size,
-			   rx_ring->obj_size * rx_ring->obj_num);
-	}
-
-	netdev_dbg(priv->ndev,
-		   "FIFO setup: free: %d bytes\n",
-		   ram_free);
-
 	return 0;
 }
-- 
2.34.1


