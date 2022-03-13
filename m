Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8144D73D2
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 09:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbiCMIxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 04:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbiCMIxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 04:53:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E33B3F884
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 00:51:47 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nTJx2-0000U5-ON
        for netdev@vger.kernel.org; Sun, 13 Mar 2022 09:51:44 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D483449B54
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 08:51:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5A49649B30;
        Sun, 13 Mar 2022 08:51:39 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c456caa3;
        Sun, 13 Mar 2022 08:51:38 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 04/13] can: mcp251xfd: ram: coalescing support
Date:   Sun, 13 Mar 2022 09:51:29 +0100
Message-Id: <20220313085138.507062-5-mkl@pengutronix.de>
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

This patch adds support for coalescing to the RAM layout calculation.

Link: https://lore.kernel.org/20220313083640.501791-4-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c | 70 +++++++++++++++++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.h |  5 ++
 2 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c
index 6e7293e50d2c..9e8e82cdba46 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c
@@ -20,13 +20,26 @@ static inline u8 can_ram_clamp(const struct can_ram_config *config,
 
 static u8
 can_ram_rounddown_pow_of_two(const struct can_ram_config *config,
-			     const struct can_ram_obj_config *obj, u8 val)
+			     const struct can_ram_obj_config *obj,
+			     const u8 coalesce, u8 val)
 {
 	u8 fifo_num = obj->fifo_num;
 	u8 ret = 0, i;
 
 	val = can_ram_clamp(config, obj, val);
 
+	if (coalesce) {
+		/* Use 1st FIFO for coalescing, if requested.
+		 *
+		 * Either use complete FIFO (and FIFO Full IRQ) for
+		 * coalescing or only half of FIFO (FIFO Half Full
+		 * IRQ) and use remaining half for normal objects.
+		 */
+		ret = min_t(u8, coalesce * 2, config->fifo_depth);
+		val -= ret;
+		fifo_num--;
+	}
+
 	for (i = 0; i < fifo_num && val; i++) {
 		u8 n;
 
@@ -47,6 +60,7 @@ can_ram_rounddown_pow_of_two(const struct can_ram_config *config,
 void can_ram_get_layout(struct can_ram_layout *layout,
 			const struct can_ram_config *config,
 			const struct ethtool_ringparam *ring,
+			const struct ethtool_coalesce *ec,
 			const bool fd_mode)
 {
 	u8 num_rx, num_tx;
@@ -55,14 +69,14 @@ void can_ram_get_layout(struct can_ram_layout *layout,
 	/* default CAN */
 
 	num_tx = config->tx.def[fd_mode];
-	num_tx = can_ram_rounddown_pow_of_two(config, &config->tx, num_tx);
+	num_tx = can_ram_rounddown_pow_of_two(config, &config->tx, 0, num_tx);
 
 	ram_free = config->size;
 	ram_free -= config->tx.size[fd_mode] * num_tx;
 
 	num_rx = ram_free / config->rx.size[fd_mode];
 
-	layout->default_rx = can_ram_rounddown_pow_of_two(config, &config->rx, num_rx);
+	layout->default_rx = can_ram_rounddown_pow_of_two(config, &config->rx, 0, num_rx);
 	layout->default_tx = num_tx;
 
 	/* MAX CAN */
@@ -75,23 +89,65 @@ void can_ram_get_layout(struct can_ram_layout *layout,
 	ram_free -= config->rx.size[fd_mode] * config->rx.min;
 	num_tx = ram_free / config->tx.size[fd_mode];
 
-	layout->max_rx = can_ram_rounddown_pow_of_two(config, &config->rx, num_rx);
-	layout->max_tx = can_ram_rounddown_pow_of_two(config, &config->tx, num_tx);
+	layout->max_rx = can_ram_rounddown_pow_of_two(config, &config->rx, 0, num_rx);
+	layout->max_tx = can_ram_rounddown_pow_of_two(config, &config->tx, 0, num_tx);
 
 	/* cur CAN */
 
 	if (ring) {
-		num_rx = can_ram_rounddown_pow_of_two(config, &config->rx, ring->rx_pending);
+		u8 num_rx_coalesce = 0, num_tx_coalesce = 0;
+
+		num_rx = can_ram_rounddown_pow_of_two(config, &config->rx, 0, ring->rx_pending);
+
+		/* The ethtool doc says:
+		 * To disable coalescing, set usecs = 0 and max_frames = 1.
+		 */
+		if (ec && !(ec->rx_coalesce_usecs_irq == 0 &&
+			    ec->rx_max_coalesced_frames_irq == 1)) {
+			u8 max;
+
+			/* use only max half of available objects for coalescing */
+			max = min_t(u8, num_rx / 2, config->fifo_depth);
+			num_rx_coalesce = clamp(ec->rx_max_coalesced_frames_irq,
+						(u32)config->rx.fifo_depth_coalesce_min,
+						(u32)max);
+			num_rx_coalesce = rounddown_pow_of_two(num_rx_coalesce);
+
+			num_rx = can_ram_rounddown_pow_of_two(config, &config->rx,
+							      num_rx_coalesce, num_rx);
+		}
 
 		ram_free = config->size - config->rx.size[fd_mode] * num_rx;
 		num_tx = ram_free / config->tx.size[fd_mode];
 		num_tx = min_t(u8, ring->tx_pending, num_tx);
-		num_tx = can_ram_rounddown_pow_of_two(config, &config->tx, num_tx);
+		num_tx = can_ram_rounddown_pow_of_two(config, &config->tx, 0, num_tx);
+
+		/* The ethtool doc says:
+		 * To disable coalescing, set usecs = 0 and max_frames = 1.
+		 */
+		if (ec && !(ec->tx_coalesce_usecs_irq == 0 &&
+			    ec->tx_max_coalesced_frames_irq == 1)) {
+			u8 max;
+
+			/* use only max half of available objects for coalescing */
+			max = min_t(u8, num_tx / 2, config->fifo_depth);
+			num_tx_coalesce = clamp(ec->tx_max_coalesced_frames_irq,
+						(u32)config->tx.fifo_depth_coalesce_min,
+						(u32)max);
+			num_tx_coalesce = rounddown_pow_of_two(num_tx_coalesce);
+
+			num_tx = can_ram_rounddown_pow_of_two(config, &config->tx,
+							      num_tx_coalesce, num_tx);
+		}
 
 		layout->cur_rx = num_rx;
 		layout->cur_tx = num_tx;
+		layout->rx_coalesce = num_rx_coalesce;
+		layout->tx_coalesce = num_tx_coalesce;
 	} else {
 		layout->cur_rx = layout->default_rx;
 		layout->cur_tx = layout->default_tx;
+		layout->rx_coalesce = 0;
+		layout->tx_coalesce = 0;
 	}
 }
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.h
index c998a033c9cb..7558c1510cbf 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.h
@@ -28,6 +28,7 @@ struct can_ram_obj_config {
 
 	u8 fifo_num;
 	u8 fifo_depth_min;
+	u8 fifo_depth_coalesce_min;
 };
 
 struct can_ram_config {
@@ -47,11 +48,15 @@ struct can_ram_layout {
 
 	u8 cur_rx;
 	u8 cur_tx;
+
+	u8 rx_coalesce;
+	u8 tx_coalesce;
 };
 
 void can_ram_get_layout(struct can_ram_layout *layout,
 			const struct can_ram_config *config,
 			const struct ethtool_ringparam *ring,
+			const struct ethtool_coalesce *ec,
 			const bool fd_mode);
 
 #endif
-- 
2.35.1


