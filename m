Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59C74D73DA
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 09:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbiCMIxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 04:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbiCMIxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 04:53:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA758888EE
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 00:51:48 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nTJx4-0000WX-RN
        for netdev@vger.kernel.org; Sun, 13 Mar 2022 09:51:46 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4033F49B70
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 08:51:40 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C6DDB49B52;
        Sun, 13 Mar 2022 08:51:39 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2c1d7603;
        Sun, 13 Mar 2022 08:51:38 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 09/13] can: mcp251xfd: add RX IRQ coalescing support
Date:   Sun, 13 Mar 2022 09:51:34 +0100
Message-Id: <20220313085138.507062-10-mkl@pengutronix.de>
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

This patch adds RX IRQ coalescing support to the driver.

The mcp251xfd chip doesn't support proper hardware based coalescing,
so this patch tries to implemented it in software. The RX-FIFO offers
a "FIFO not empty" interrupt, which is used if no coalescing is
active.

With activated RX IRQ coalescing the "FIFO not empty" interrupt is
disabled in the RX IRQ handler and the "FIFO half full" or "FIFO full
interrupt" (depending on RX max coalesced frames IRQ) is used instead.
To avoid RX CAN frame starvation a hrtimer is setup with RX coalesce
usecs IRQ,on timer expiration the "FIFO not empty" is enabled again.

Support for ethtool configuration is added in the next patch.

Link: https://lore.kernel.org/20220313083640.501791-9-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    |   5 +
 .../net/can/spi/mcp251xfd/mcp251xfd-ethtool.c |   3 +
 .../net/can/spi/mcp251xfd/mcp251xfd-ring.c    | 103 ++++++++++++++++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c  |  12 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |  10 ++
 5 files changed, 123 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index ebb4dc999bac..325024be7b04 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1598,6 +1598,7 @@ static int mcp251xfd_open(struct net_device *ndev)
 		goto out_transceiver_disable;
 
 	mcp251xfd_timestamp_init(priv);
+	clear_bit(MCP251XFD_FLAGS_DOWN, priv->flags);
 	can_rx_offload_enable(&priv->offload);
 
 	err = request_threaded_irq(spi->irq, NULL, mcp251xfd_irq,
@@ -1618,6 +1619,7 @@ static int mcp251xfd_open(struct net_device *ndev)
 	free_irq(spi->irq, priv);
  out_can_rx_offload_disable:
 	can_rx_offload_disable(&priv->offload);
+	set_bit(MCP251XFD_FLAGS_DOWN, priv->flags);
 	mcp251xfd_timestamp_stop(priv);
  out_transceiver_disable:
 	mcp251xfd_transceiver_disable(priv);
@@ -1637,6 +1639,8 @@ static int mcp251xfd_stop(struct net_device *ndev)
 	struct mcp251xfd_priv *priv = netdev_priv(ndev);
 
 	netif_stop_queue(ndev);
+	set_bit(MCP251XFD_FLAGS_DOWN, priv->flags);
+	hrtimer_cancel(&priv->rx_irq_timer);
 	mcp251xfd_chip_interrupts_disable(priv);
 	free_irq(ndev->irq, priv);
 	can_rx_offload_disable(&priv->offload);
@@ -2036,6 +2040,7 @@ static int mcp251xfd_probe(struct spi_device *spi)
 		CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_BERR_REPORTING |
 		CAN_CTRLMODE_FD | CAN_CTRLMODE_FD_NON_ISO |
 		CAN_CTRLMODE_CC_LEN8_DLC;
+	set_bit(MCP251XFD_FLAGS_DOWN, priv->flags);
 	priv->ndev = ndev;
 	priv->spi = spi;
 	priv->rx_int = rx_int;
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
index 8825195fa05f..8f14c9c08929 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
@@ -65,4 +65,7 @@ void mcp251xfd_ethtool_init(struct mcp251xfd_priv *priv)
 	can_ram_get_layout(&layout, &mcp251xfd_ram_config, NULL, NULL, false);
 	priv->rx_obj_num = layout.default_rx;
 	priv->tx->obj_num = layout.default_tx;
+
+	priv->rx_obj_num_coalesce_irq = 0;
+	priv->rx_coalesce_usecs_irq = 0;
 }
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
index 2ff4d4e803b0..6dbbc5b8a069 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -182,8 +182,18 @@ mcp251xfd_ring_init_rx(struct mcp251xfd_priv *priv, u16 *base, u8 *fifo_nr)
 		*base = mcp251xfd_get_rx_obj_addr(rx_ring, rx_ring->obj_num);
 		*fifo_nr += 1;
 
-		/* FIFO increment RX tail pointer */
+		/* FIFO IRQ enable */
 		addr = MCP251XFD_REG_FIFOCON(rx_ring->fifo_nr);
+		val = MCP251XFD_REG_FIFOCON_RXOVIE |
+			MCP251XFD_REG_FIFOCON_TFNRFNIE;
+		len = mcp251xfd_cmd_prepare_write_reg(priv, &rx_ring->irq_enable_buf,
+						      addr, val, val);
+		rx_ring->irq_enable_xfer.tx_buf = &rx_ring->irq_enable_buf;
+		rx_ring->irq_enable_xfer.len = len;
+		spi_message_init_with_transfers(&rx_ring->irq_enable_msg,
+						&rx_ring->irq_enable_xfer, 1);
+
+		/* FIFO increment RX tail pointer */
 		val = MCP251XFD_REG_FIFOCON_UINC;
 		len = mcp251xfd_cmd_prepare_write_reg(priv, &rx_ring->uinc_buf,
 						      addr, val, val);
@@ -205,6 +215,39 @@ mcp251xfd_ring_init_rx(struct mcp251xfd_priv *priv, u16 *base, u8 *fifo_nr)
 		 * the chip select at the end of the message.
 		 */
 		xfer->cs_change = 0;
+
+		/* Use 1st RX-FIFO for IRQ coalescing. If enabled
+		 * (rx_coalesce_usecs_irq or rx_max_coalesce_frames_irq
+		 * is activated), use the last transfer to disable:
+		 *
+		 * - TFNRFNIE (Receive FIFO Not Empty Interrupt)
+		 *
+		 * and enable:
+		 *
+		 * - TFHRFHIE (Receive FIFO Half Full Interrupt)
+		 *   - or -
+		 * - TFERFFIE (Receive FIFO Full Interrupt)
+		 *
+		 * depending on rx_max_coalesce_frames_irq.
+		 *
+		 * The RXOVIE (Overflow Interrupt) is always enabled.
+		 */
+		if (rx_ring->nr == 0 && (priv->rx_coalesce_usecs_irq ||
+					 priv->rx_obj_num_coalesce_irq)) {
+			val = MCP251XFD_REG_FIFOCON_UINC |
+				MCP251XFD_REG_FIFOCON_RXOVIE;
+
+			if (priv->rx_obj_num_coalesce_irq == rx_ring->obj_num)
+				val |= MCP251XFD_REG_FIFOCON_TFERFFIE;
+			else if (priv->rx_obj_num_coalesce_irq)
+				val |= MCP251XFD_REG_FIFOCON_TFHRFHIE;
+
+			len = mcp251xfd_cmd_prepare_write_reg(priv,
+							      &rx_ring->uinc_irq_disable_buf,
+							      addr, val, val);
+			xfer->tx_buf = &rx_ring->uinc_irq_disable_buf;
+			xfer->len = len;
+		}
 	}
 }
 
@@ -246,12 +289,33 @@ int mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 		   priv->tx->obj_num * sizeof(struct mcp251xfd_hw_tef_obj));
 
 	mcp251xfd_for_each_rx_ring(priv, rx_ring, i) {
-		netdev_dbg(priv->ndev,
-			   "FIFO setup: RX-%u: FIFO %u/0x%03x: %2u*%u bytes = %4u bytes\n",
-			   rx_ring->nr, rx_ring->fifo_nr,
-			   mcp251xfd_get_rx_obj_addr(rx_ring, 0),
-			   rx_ring->obj_num, rx_ring->obj_size,
-			   rx_ring->obj_num * rx_ring->obj_size);
+		if (rx_ring->nr == 0 && priv->rx_obj_num_coalesce_irq) {
+			netdev_dbg(priv->ndev,
+				   "FIFO setup: RX-%u: FIFO %u/0x%03x: %2u*%u bytes = %4u bytes (coalesce)\n",
+				   rx_ring->nr, rx_ring->fifo_nr,
+				   mcp251xfd_get_rx_obj_addr(rx_ring, 0),
+				   priv->rx_obj_num_coalesce_irq, rx_ring->obj_size,
+				   priv->rx_obj_num_coalesce_irq * rx_ring->obj_size);
+
+			if (priv->rx_obj_num_coalesce_irq == MCP251XFD_FIFO_DEPTH)
+				continue;
+
+			netdev_dbg(priv->ndev,
+				   "                         0x%03x: %2u*%u bytes = %4u bytes\n",
+				   mcp251xfd_get_rx_obj_addr(rx_ring,
+							     priv->rx_obj_num_coalesce_irq),
+				   rx_ring->obj_num - priv->rx_obj_num_coalesce_irq,
+				   rx_ring->obj_size,
+				   (rx_ring->obj_num - priv->rx_obj_num_coalesce_irq) *
+				   rx_ring->obj_size);
+		} else {
+			netdev_dbg(priv->ndev,
+				   "FIFO setup: RX-%u: FIFO %u/0x%03x: %2u*%u bytes = %4u bytes\n",
+				   rx_ring->nr, rx_ring->fifo_nr,
+				   mcp251xfd_get_rx_obj_addr(rx_ring, 0),
+				   rx_ring->obj_num, rx_ring->obj_size,
+				   rx_ring->obj_num * rx_ring->obj_size);
+		}
 	}
 
 	netdev_dbg(priv->ndev,
@@ -286,6 +350,20 @@ void mcp251xfd_ring_free(struct mcp251xfd_priv *priv)
 	}
 }
 
+static enum hrtimer_restart mcp251xfd_rx_irq_timer(struct hrtimer *t)
+{
+	struct mcp251xfd_priv *priv = container_of(t, struct mcp251xfd_priv,
+						   rx_irq_timer);
+	struct mcp251xfd_rx_ring *ring = priv->rx[0];
+
+	if (test_bit(MCP251XFD_FLAGS_DOWN, priv->flags))
+		return HRTIMER_NORESTART;
+
+	spi_async(priv->spi, &ring->irq_enable_msg);
+
+	return HRTIMER_NORESTART;
+}
+
 const struct can_ram_config mcp251xfd_ram_config = {
 	.rx = {
 		.size[CAN_RAM_MODE_CAN] = sizeof(struct mcp251xfd_hw_rx_obj_can),
@@ -346,8 +424,12 @@ int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv)
 	for (i = 0; i < ARRAY_SIZE(priv->rx) && rem; i++) {
 		u8 rx_obj_num;
 
-		rx_obj_num = min_t(u8, rounddown_pow_of_two(rem),
-				   MCP251XFD_FIFO_DEPTH);
+		if (i == 0 && priv->rx_obj_num_coalesce_irq)
+			rx_obj_num = min_t(u8, priv->rx_obj_num_coalesce_irq * 2,
+					   MCP251XFD_FIFO_DEPTH);
+		else
+			rx_obj_num = min_t(u8, rounddown_pow_of_two(rem),
+					   MCP251XFD_FIFO_DEPTH);
 		rem -= rx_obj_num;
 
 		rx_ring = kzalloc(sizeof(*rx_ring) + rx_obj_size * rx_obj_num,
@@ -363,5 +445,8 @@ int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv)
 	}
 	priv->rx_ring_num = i;
 
+	hrtimer_init(&priv->rx_irq_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	priv->rx_irq_timer.function = mcp251xfd_rx_irq_timer;
+
 	return 0;
 }
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
index e6d39876065a..d09f7fbf2ba7 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
@@ -254,7 +254,11 @@ int mcp251xfd_handle_rxif(struct mcp251xfd_priv *priv)
 	int err, n;
 
 	mcp251xfd_for_each_rx_ring(priv, ring, n) {
-		if (!(priv->regs_status.rxif & BIT(ring->fifo_nr)))
+		/* - if RX IRQ coalescing is active always handle ring 0
+		 * - only handle rings if RX IRQ is active
+		 */
+		if ((ring->nr > 0 || !priv->rx_obj_num_coalesce_irq) &&
+		    !(priv->regs_status.rxif & BIT(ring->fifo_nr)))
 			continue;
 
 		err = mcp251xfd_handle_rxif_ring(priv, ring);
@@ -262,5 +266,11 @@ int mcp251xfd_handle_rxif(struct mcp251xfd_priv *priv)
 			return err;
 	}
 
+	if (priv->rx_coalesce_usecs_irq)
+		hrtimer_start(&priv->rx_irq_timer,
+			      ns_to_ktime(priv->rx_coalesce_usecs_irq *
+					  NSEC_PER_USEC),
+			      HRTIMER_MODE_REL);
+
 	return 0;
 }
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index c61df2036fdf..ef4728039998 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -545,7 +545,12 @@ struct mcp251xfd_rx_ring {
 	u8 obj_num;
 	u8 obj_size;
 
+	union mcp251xfd_write_reg_buf irq_enable_buf;
+	struct spi_transfer irq_enable_xfer;
+	struct spi_message irq_enable_msg;
+
 	union mcp251xfd_write_reg_buf uinc_buf;
+	union mcp251xfd_write_reg_buf uinc_irq_disable_buf;
 	struct spi_transfer uinc_xfer[MCP251XFD_FIFO_DEPTH];
 	struct mcp251xfd_hw_rx_obj_canfd obj[];
 };
@@ -583,6 +588,7 @@ struct mcp251xfd_devtype_data {
 };
 
 enum mcp251xfd_flags {
+	MCP251XFD_FLAGS_DOWN,
 	MCP251XFD_FLAGS_FD_MODE,
 
 	__MCP251XFD_FLAGS_SIZE__
@@ -617,6 +623,10 @@ struct mcp251xfd_priv {
 
 	u8 rx_ring_num;
 	u8 rx_obj_num;
+	u8 rx_obj_num_coalesce_irq;
+
+	u32 rx_coalesce_usecs_irq;
+	struct hrtimer rx_irq_timer;
 
 	struct mcp251xfd_ecc ecc;
 	struct mcp251xfd_regs_status regs_status;
-- 
2.35.1


