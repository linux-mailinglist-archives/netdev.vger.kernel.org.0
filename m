Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43AD34D73E1
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 09:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbiCMIxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 04:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbiCMIxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 04:53:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8624888F1
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 00:51:48 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nTJx4-0000X4-Tp
        for netdev@vger.kernel.org; Sun, 13 Mar 2022 09:51:46 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4DD6C49B73
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 08:51:40 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id DC2D949B58;
        Sun, 13 Mar 2022 08:51:39 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0fb4c6af;
        Sun, 13 Mar 2022 08:51:38 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 10/13] can: mcp251xfd: add RX IRQ coalescing ethtool support
Date:   Sun, 13 Mar 2022 09:51:35 +0100
Message-Id: <20220313085138.507062-11-mkl@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support ethtool based configuration for the RX IRQ
coalescing added in the previous patch.

Link: https://lore.kernel.org/20220313083640.501791-10-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-ethtool.c | 55 +++++++++++++++++++
 .../net/can/spi/mcp251xfd/mcp251xfd-ring.c    |  1 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |  1 +
 3 files changed, 57 insertions(+)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
index 8f14c9c08929..6e49cf3411a2 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
@@ -46,14 +46,69 @@ mcp251xfd_ring_set_ringparam(struct net_device *ndev,
 		return -EBUSY;
 
 	priv->rx_obj_num = layout.cur_rx;
+	priv->rx_obj_num_coalesce_irq = layout.rx_coalesce;
+	priv->tx->obj_num = layout.cur_tx;
+
+	return 0;
+}
+
+static int mcp251xfd_ring_get_coalesce(struct net_device *ndev,
+				       struct ethtool_coalesce *ec,
+				       struct kernel_ethtool_coalesce *kec,
+				       struct netlink_ext_ack *ext_ack)
+{
+	struct mcp251xfd_priv *priv = netdev_priv(ndev);
+	u32 rx_max_frames;
+
+	/* The ethtool doc says:
+	 * To disable coalescing, set usecs = 0 and max_frames = 1.
+	 */
+	if (priv->rx_obj_num_coalesce_irq == 0)
+		rx_max_frames = 1;
+	else
+		rx_max_frames = priv->rx_obj_num_coalesce_irq;
+
+	ec->rx_max_coalesced_frames_irq = rx_max_frames;
+	ec->rx_coalesce_usecs_irq = priv->rx_coalesce_usecs_irq;
+
+	return 0;
+}
+
+static int mcp251xfd_ring_set_coalesce(struct net_device *ndev,
+				       struct ethtool_coalesce *ec,
+				       struct kernel_ethtool_coalesce *kec,
+				       struct netlink_ext_ack *ext_ack)
+{
+	struct mcp251xfd_priv *priv = netdev_priv(ndev);
+	const bool fd_mode = mcp251xfd_is_fd_mode(priv);
+	const struct ethtool_ringparam ring = {
+		.rx_pending = priv->rx_obj_num,
+		.tx_pending = priv->tx->obj_num,
+	};
+	struct can_ram_layout layout;
+
+	can_ram_get_layout(&layout, &mcp251xfd_ram_config, &ring, ec, fd_mode);
+
+	if ((layout.rx_coalesce != priv->rx_obj_num_coalesce_irq ||
+	     ec->rx_coalesce_usecs_irq != priv->rx_coalesce_usecs_irq) &&
+	    netif_running(ndev))
+		return -EBUSY;
+
+	priv->rx_obj_num = layout.cur_rx;
+	priv->rx_obj_num_coalesce_irq = layout.rx_coalesce;
+	priv->rx_coalesce_usecs_irq = ec->rx_coalesce_usecs_irq;
 	priv->tx->obj_num = layout.cur_tx;
 
 	return 0;
 }
 
 static const struct ethtool_ops mcp251xfd_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS_IRQ |
+		ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ,
 	.get_ringparam = mcp251xfd_ring_get_ringparam,
 	.set_ringparam = mcp251xfd_ring_set_ringparam,
+	.get_coalesce = mcp251xfd_ring_get_coalesce,
+	.set_coalesce = mcp251xfd_ring_set_coalesce,
 };
 
 void mcp251xfd_ethtool_init(struct mcp251xfd_priv *priv)
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
index 6dbbc5b8a069..f12a7aa8af14 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -374,6 +374,7 @@ const struct can_ram_config mcp251xfd_ram_config = {
 		.def[CAN_RAM_MODE_CANFD] = CAN_RAM_NUM_MAX,
 		.fifo_num = MCP251XFD_FIFO_RX_NUM,
 		.fifo_depth_min = MCP251XFD_RX_FIFO_DEPTH_MIN,
+		.fifo_depth_coalesce_min = MCP251XFD_RX_FIFO_DEPTH_COALESCE_MIN,
 	},
 	.tx = {
 		.size[CAN_RAM_MODE_CAN] = sizeof(struct mcp251xfd_hw_tef_obj) +
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index ef4728039998..8d912bacd2f1 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -406,6 +406,7 @@ static_assert(MCP251XFD_TIMESTAMP_WORK_DELAY_SEC <
 #define MCP251XFD_RX_OBJ_NUM_MIN 16U
 #define MCP251XFD_RX_OBJ_NUM_MAX (MCP251XFD_FIFO_RX_NUM * MCP251XFD_FIFO_DEPTH)
 #define MCP251XFD_RX_FIFO_DEPTH_MIN 4U
+#define MCP251XFD_RX_FIFO_DEPTH_COALESCE_MIN 8U
 
 #define MCP251XFD_TX_OBJ_NUM_MIN 2U
 #define MCP251XFD_TX_OBJ_NUM_MAX 8U
-- 
2.35.1


