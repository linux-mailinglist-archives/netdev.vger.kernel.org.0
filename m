Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980AD3F1AB8
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240347AbhHSNk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240203AbhHSNkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:40:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52606C061764
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:39:43 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGiGj-0004zj-K1
        for netdev@vger.kernel.org; Thu, 19 Aug 2021 15:39:41 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CE4CB66A887
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:39:34 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4FE4366A823;
        Thu, 19 Aug 2021 13:39:24 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8c4f0fba;
        Thu, 19 Aug 2021 13:39:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Matt Kline <matt@bitbashing.io>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 13/22] can: m_can: Disable IRQs on FIFO bus errors
Date:   Thu, 19 Aug 2021 15:39:04 +0200
Message-Id: <20210819133913.657715-14-mkl@pengutronix.de>
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

If FIFO reads or writes fail due to the underlying regmap (e.g., SPI)
I/O, propagate that up to the m_can driver, log an error, and disable
interrupts, similar to the mcp251xfd driver.

While reworking the FIFO functions to add this error handling,
add support for bulk reads and writes of multiple registers.

Link: https://lore.kernel.org/r/20210817050853.14875-2-matt@bitbashing.io
Signed-off-by: Matt Kline <matt@bitbashing.io>
[mkl: re-wrap long lines, remove WARN_ON, convert to netdev block comments]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c          | 177 +++++++++++++++++--------
 drivers/net/can/m_can/m_can.h          |   6 +-
 drivers/net/can/m_can/m_can_pci.c      |  11 +-
 drivers/net/can/m_can/m_can_platform.c |  15 ++-
 drivers/net/can/m_can/tcan4x5x-core.c  |  16 +--
 5 files changed, 152 insertions(+), 73 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 47ddee80c423..8922ca0f8e94 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -320,36 +320,39 @@ static inline void m_can_write(struct m_can_classdev *cdev, enum m_can_reg reg,
 	cdev->ops->write_reg(cdev, reg, val);
 }
 
-static u32 m_can_fifo_read(struct m_can_classdev *cdev,
-			   u32 fgi, unsigned int offset)
+static int
+m_can_fifo_read(struct m_can_classdev *cdev,
+		u32 fgi, unsigned int offset, void *val, size_t val_count)
 {
 	u32 addr_offset = cdev->mcfg[MRAM_RXF0].off + fgi * RXF0_ELEMENT_SIZE +
 		offset;
 
-	return cdev->ops->read_fifo(cdev, addr_offset);
+	return cdev->ops->read_fifo(cdev, addr_offset, val, val_count);
 }
 
-static void m_can_fifo_write(struct m_can_classdev *cdev,
-			     u32 fpi, unsigned int offset, u32 val)
+static int
+m_can_fifo_write(struct m_can_classdev *cdev,
+		 u32 fpi, unsigned int offset, const void *val, size_t val_count)
 {
 	u32 addr_offset = cdev->mcfg[MRAM_TXB].off + fpi * TXB_ELEMENT_SIZE +
 		offset;
 
-	cdev->ops->write_fifo(cdev, addr_offset, val);
+	return cdev->ops->write_fifo(cdev, addr_offset, val, val_count);
 }
 
-static inline void m_can_fifo_write_no_off(struct m_can_classdev *cdev,
-					   u32 fpi, u32 val)
+static inline int m_can_fifo_write_no_off(struct m_can_classdev *cdev,
+					  u32 fpi, u32 val)
 {
-	cdev->ops->write_fifo(cdev, fpi, val);
+	return cdev->ops->write_fifo(cdev, fpi, &val, 1);
 }
 
-static u32 m_can_txe_fifo_read(struct m_can_classdev *cdev, u32 fgi, u32 offset)
+static int
+m_can_txe_fifo_read(struct m_can_classdev *cdev, u32 fgi, u32 offset, u32 *val)
 {
 	u32 addr_offset = cdev->mcfg[MRAM_TXE].off + fgi * TXE_ELEMENT_SIZE +
 		offset;
 
-	return cdev->ops->read_fifo(cdev, addr_offset);
+	return cdev->ops->read_fifo(cdev, addr_offset, val, 1);
 }
 
 static inline bool m_can_tx_fifo_full(struct m_can_classdev *cdev)
@@ -455,7 +458,7 @@ static void m_can_receive_skb(struct m_can_classdev *cdev,
 	}
 }
 
-static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
+static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
 {
 	struct net_device_stats *stats = &dev->stats;
 	struct m_can_classdev *cdev = netdev_priv(dev);
@@ -463,18 +466,21 @@ static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
 	struct sk_buff *skb;
 	u32 id, fgi, dlc;
 	u32 timestamp = 0;
-	int i;
+	int i, err;
 
 	/* calculate the fifo get index for where to read data */
 	fgi = FIELD_GET(RXFS_FGI_MASK, rxfs);
-	dlc = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_DLC);
+	err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_DLC, &dlc, 1);
+	if (err)
+		goto out_fail;
+
 	if (dlc & RX_BUF_FDF)
 		skb = alloc_canfd_skb(dev, &cf);
 	else
 		skb = alloc_can_skb(dev, (struct can_frame **)&cf);
 	if (!skb) {
 		stats->rx_dropped++;
-		return;
+		return 0;
 	}
 
 	if (dlc & RX_BUF_FDF)
@@ -482,7 +488,10 @@ static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
 	else
 		cf->len = can_cc_dlc2len((dlc >> 16) & 0x0F);
 
-	id = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_ID);
+	err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_ID, &id, 1);
+	if (err)
+		goto out_fail;
+
 	if (id & RX_BUF_XTD)
 		cf->can_id = (id & CAN_EFF_MASK) | CAN_EFF_FLAG;
 	else
@@ -499,10 +508,11 @@ static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
 		if (dlc & RX_BUF_BRS)
 			cf->flags |= CANFD_BRS;
 
-		for (i = 0; i < cf->len; i += 4)
-			*(u32 *)(cf->data + i) =
-				m_can_fifo_read(cdev, fgi,
-						M_CAN_FIFO_DATA(i / 4));
+		for (i = 0; i < cf->len; i += 4) {
+			err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_DATA(i / 4), cf->data + i, 1);
+			if (err)
+				goto out_fail;
+		}
 	}
 
 	/* acknowledge rx fifo 0 */
@@ -514,6 +524,12 @@ static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
 	timestamp = FIELD_GET(RX_BUF_RXTS_MASK, dlc);
 
 	m_can_receive_skb(cdev, skb, timestamp);
+
+	return 0;
+
+out_fail:
+	netdev_err(dev, "FIFO read returned %d\n", err);
+	return err;
 }
 
 static int m_can_do_rx_poll(struct net_device *dev, int quota)
@@ -521,6 +537,7 @@ static int m_can_do_rx_poll(struct net_device *dev, int quota)
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	u32 pkts = 0;
 	u32 rxfs;
+	int err;
 
 	rxfs = m_can_read(cdev, M_CAN_RXF0S);
 	if (!(rxfs & RXFS_FFL_MASK)) {
@@ -529,7 +546,9 @@ static int m_can_do_rx_poll(struct net_device *dev, int quota)
 	}
 
 	while ((rxfs & RXFS_FFL_MASK) && (quota > 0)) {
-		m_can_read_fifo(dev, rxfs);
+		err = m_can_read_fifo(dev, rxfs);
+		if (err)
+			return err;
 
 		quota--;
 		pkts++;
@@ -875,6 +894,7 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 static int m_can_rx_handler(struct net_device *dev, int quota)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
+	int rx_work_or_err;
 	int work_done = 0;
 	u32 irqstatus, psr;
 
@@ -911,8 +931,13 @@ static int m_can_rx_handler(struct net_device *dev, int quota)
 	if (irqstatus & IR_ERR_BUS_30X)
 		work_done += m_can_handle_bus_errors(dev, irqstatus, psr);
 
-	if (irqstatus & IR_RF0N)
-		work_done += m_can_do_rx_poll(dev, (quota - work_done));
+	if (irqstatus & IR_RF0N) {
+		rx_work_or_err = m_can_do_rx_poll(dev, (quota - work_done));
+		if (rx_work_or_err < 0)
+			return rx_work_or_err;
+
+		work_done += rx_work_or_err;
+	}
 end:
 	return work_done;
 }
@@ -920,12 +945,17 @@ static int m_can_rx_handler(struct net_device *dev, int quota)
 static int m_can_rx_peripheral(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
+	int work_done;
 
-	m_can_rx_handler(dev, M_CAN_NAPI_WEIGHT);
+	work_done = m_can_rx_handler(dev, M_CAN_NAPI_WEIGHT);
 
-	m_can_enable_all_interrupts(cdev);
+	/* Don't re-enable interrupts if the driver had a fatal error
+	 * (e.g., FIFO read failure).
+	 */
+	if (work_done >= 0)
+		m_can_enable_all_interrupts(cdev);
 
-	return 0;
+	return work_done;
 }
 
 static int m_can_poll(struct napi_struct *napi, int quota)
@@ -935,7 +965,11 @@ static int m_can_poll(struct napi_struct *napi, int quota)
 	int work_done;
 
 	work_done = m_can_rx_handler(dev, quota);
-	if (work_done < quota) {
+
+	/* Don't re-enable interrupts if the driver had a fatal error
+	 * (e.g., FIFO read failure).
+	 */
+	if (work_done >= 0 && work_done < quota) {
 		napi_complete_done(napi, work_done);
 		m_can_enable_all_interrupts(cdev);
 	}
@@ -966,7 +1000,7 @@ static void m_can_tx_update_stats(struct m_can_classdev *cdev,
 	stats->tx_packets++;
 }
 
-static void m_can_echo_tx_event(struct net_device *dev)
+static int m_can_echo_tx_event(struct net_device *dev)
 {
 	u32 txe_count = 0;
 	u32 m_can_txefs;
@@ -985,12 +1019,18 @@ static void m_can_echo_tx_event(struct net_device *dev)
 	/* Get and process all sent elements */
 	for (i = 0; i < txe_count; i++) {
 		u32 txe, timestamp = 0;
+		int err;
 
 		/* retrieve get index */
 		fgi = FIELD_GET(TXEFS_EFGI_MASK, m_can_read(cdev, M_CAN_TXEFS));
 
 		/* get message marker, timestamp */
-		txe = m_can_txe_fifo_read(cdev, fgi, 4);
+		err = m_can_txe_fifo_read(cdev, fgi, 4, &txe);
+		if (err) {
+			netdev_err(dev, "TXE FIFO read returned %d\n", err);
+			return err;
+		}
+
 		msg_mark = FIELD_GET(TX_EVENT_MM_MASK, txe);
 		timestamp = FIELD_GET(TX_EVENT_TXTS_MASK, txe);
 
@@ -1001,6 +1041,8 @@ static void m_can_echo_tx_event(struct net_device *dev)
 		/* update stats */
 		m_can_tx_update_stats(cdev, msg_mark, timestamp);
 	}
+
+	return 0;
 }
 
 static irqreturn_t m_can_isr(int irq, void *dev_id)
@@ -1032,8 +1074,8 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 		m_can_disable_all_interrupts(cdev);
 		if (!cdev->is_peripheral)
 			napi_schedule(&cdev->napi);
-		else
-			m_can_rx_peripheral(dev);
+		else if (m_can_rx_peripheral(dev) < 0)
+			goto out_fail;
 	}
 
 	if (cdev->version == 30) {
@@ -1051,7 +1093,9 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 	} else  {
 		if (ir & IR_TEFN) {
 			/* New TX FIFO Element arrived */
-			m_can_echo_tx_event(dev);
+			if (m_can_echo_tx_event(dev) != 0)
+				goto out_fail;
+
 			can_led_event(dev, CAN_LED_EVENT_TX);
 			if (netif_queue_stopped(dev) &&
 			    !m_can_tx_fifo_full(cdev))
@@ -1063,6 +1107,10 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 		can_rx_offload_threaded_irq_finish(&cdev->offload);
 
 	return IRQ_HANDLED;
+
+out_fail:
+	m_can_disable_all_interrupts(cdev);
+	return IRQ_HANDLED;
 }
 
 static const struct can_bittiming_const m_can_bittiming_const_30X = {
@@ -1535,8 +1583,8 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 	struct canfd_frame *cf = (struct canfd_frame *)cdev->tx_skb->data;
 	struct net_device *dev = cdev->net;
 	struct sk_buff *skb = cdev->tx_skb;
-	u32 id, cccr, fdflags;
-	int i;
+	u32 id, dlc, cccr, fdflags;
+	int i, err;
 	int putidx;
 
 	cdev->tx_skb = NULL;
@@ -1557,14 +1605,20 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		netif_stop_queue(dev);
 
 		/* message ram configuration */
-		m_can_fifo_write(cdev, 0, M_CAN_FIFO_ID, id);
-		m_can_fifo_write(cdev, 0, M_CAN_FIFO_DLC,
-				 can_fd_len2dlc(cf->len) << 16);
+		err = m_can_fifo_write(cdev, 0, M_CAN_FIFO_ID, &id, 1);
+		if (err)
+			goto out_fail;
+
+		dlc = can_fd_len2dlc(cf->len) << 16;
+		err = m_can_fifo_write(cdev, 0, M_CAN_FIFO_DLC, &dlc, 1);
+		if (err)
+			goto out_fail;
 
-		for (i = 0; i < cf->len; i += 4)
-			m_can_fifo_write(cdev, 0,
-					 M_CAN_FIFO_DATA(i / 4),
-					 *(u32 *)(cf->data + i));
+		for (i = 0; i < cf->len; i += 4) {
+			err = m_can_fifo_write(cdev, 0, M_CAN_FIFO_DATA(i / 4), cf->data + i, 1);
+			if (err)
+				goto out_fail;
+		}
 
 		can_put_echo_skb(skb, dev, 0, 0);
 
@@ -1609,7 +1663,9 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		putidx = FIELD_GET(TXFQS_TFQPI_MASK,
 				   m_can_read(cdev, M_CAN_TXFQS));
 		/* Write ID Field to FIFO Element */
-		m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID, id);
+		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID, &id, 1);
+		if (err)
+			goto out_fail;
 
 		/* get CAN FD configuration of frame */
 		fdflags = 0;
@@ -1624,15 +1680,19 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		 * it is used in TX interrupt for
 		 * sending the correct echo frame
 		 */
-		m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DLC,
-				 FIELD_PREP(TX_BUF_MM_MASK, putidx) |
-				 FIELD_PREP(TX_BUF_DLC_MASK,
-					    can_fd_len2dlc(cf->len)) |
-				 fdflags | TX_BUF_EFC);
+		dlc = FIELD_PREP(TX_BUF_MM_MASK, putidx) |
+			FIELD_PREP(TX_BUF_DLC_MASK, can_fd_len2dlc(cf->len)) |
+			fdflags | TX_BUF_EFC;
+		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DLC, &dlc, 1);
+		if (err)
+			goto out_fail;
 
-		for (i = 0; i < cf->len; i += 4)
-			m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DATA(i / 4),
-					 *(u32 *)(cf->data + i));
+		for (i = 0; i < cf->len; i += 4) {
+			err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DATA(i / 4),
+					       cf->data + i, 1);
+			if (err)
+				goto out_fail;
+		}
 
 		/* Push loopback echo.
 		 * Will be looped back on TX interrupt based on message marker
@@ -1649,6 +1709,11 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 	}
 
 	return NETDEV_TX_OK;
+
+out_fail:
+	netdev_err(dev, "FIFO write returned %d\n", err);
+	m_can_disable_all_interrupts(cdev);
+	return NETDEV_TX_BUSY;
 }
 
 static void m_can_tx_work_queue(struct work_struct *ws)
@@ -1820,9 +1885,10 @@ static void m_can_of_parse_mram(struct m_can_classdev *cdev,
 		cdev->mcfg[MRAM_TXB].off, cdev->mcfg[MRAM_TXB].num);
 }
 
-void m_can_init_ram(struct m_can_classdev *cdev)
+int m_can_init_ram(struct m_can_classdev *cdev)
 {
 	int end, i, start;
+	int err = 0;
 
 	/* initialize the entire Message RAM in use to avoid possible
 	 * ECC/parity checksum errors when reading an uninitialized buffer
@@ -1831,8 +1897,13 @@ void m_can_init_ram(struct m_can_classdev *cdev)
 	end = cdev->mcfg[MRAM_TXB].off +
 		cdev->mcfg[MRAM_TXB].num * TXB_ELEMENT_SIZE;
 
-	for (i = start; i < end; i += 4)
-		m_can_fifo_write_no_off(cdev, i, 0x0);
+	for (i = start; i < end; i += 4) {
+		err = m_can_fifo_write_no_off(cdev, i, 0x0);
+		if (err)
+			break;
+	}
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(m_can_init_ram);
 
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 56e994376a7b..d18b515e6ccc 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -65,9 +65,9 @@ struct m_can_ops {
 	int (*clear_interrupts)(struct m_can_classdev *cdev);
 	u32 (*read_reg)(struct m_can_classdev *cdev, int reg);
 	int (*write_reg)(struct m_can_classdev *cdev, int reg, int val);
-	u32 (*read_fifo)(struct m_can_classdev *cdev, int addr_offset);
+	int (*read_fifo)(struct m_can_classdev *cdev, int addr_offset, void *val, size_t val_count);
 	int (*write_fifo)(struct m_can_classdev *cdev, int addr_offset,
-			  int val);
+			  const void *val, size_t val_count);
 	int (*init)(struct m_can_classdev *cdev);
 };
 
@@ -101,7 +101,7 @@ void m_can_class_free_dev(struct net_device *net);
 int m_can_class_register(struct m_can_classdev *cdev);
 void m_can_class_unregister(struct m_can_classdev *cdev);
 int m_can_class_get_clocks(struct m_can_classdev *cdev);
-void m_can_init_ram(struct m_can_classdev *priv);
+int m_can_init_ram(struct m_can_classdev *priv);
 
 int m_can_class_suspend(struct device *dev);
 int m_can_class_resume(struct device *dev);
diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index 128808605c3f..89cc3d41e952 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -39,11 +39,13 @@ static u32 iomap_read_reg(struct m_can_classdev *cdev, int reg)
 	return readl(priv->base + reg);
 }
 
-static u32 iomap_read_fifo(struct m_can_classdev *cdev, int offset)
+static int iomap_read_fifo(struct m_can_classdev *cdev, int offset, void *val, size_t val_count)
 {
 	struct m_can_pci_priv *priv = cdev_to_priv(cdev);
 
-	return readl(priv->base + offset);
+	ioread32_rep(priv->base + offset, val, val_count);
+
+	return 0;
 }
 
 static int iomap_write_reg(struct m_can_classdev *cdev, int reg, int val)
@@ -55,11 +57,12 @@ static int iomap_write_reg(struct m_can_classdev *cdev, int reg, int val)
 	return 0;
 }
 
-static int iomap_write_fifo(struct m_can_classdev *cdev, int offset, int val)
+static int iomap_write_fifo(struct m_can_classdev *cdev, int offset,
+			    const void *val, size_t val_count)
 {
 	struct m_can_pci_priv *priv = cdev_to_priv(cdev);
 
-	writel(val, priv->base + offset);
+	iowrite32_rep(priv->base + offset, val, val_count);
 
 	return 0;
 }
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index a28c84aa8fa8..308d4f2fff00 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -29,11 +29,13 @@ static u32 iomap_read_reg(struct m_can_classdev *cdev, int reg)
 	return readl(priv->base + reg);
 }
 
-static u32 iomap_read_fifo(struct m_can_classdev *cdev, int offset)
+static int iomap_read_fifo(struct m_can_classdev *cdev, int offset, void *val, size_t val_count)
 {
 	struct m_can_plat_priv *priv = cdev_to_priv(cdev);
 
-	return readl(priv->mram_base + offset);
+	ioread32_rep(priv->mram_base + offset, val, val_count);
+
+	return 0;
 }
 
 static int iomap_write_reg(struct m_can_classdev *cdev, int reg, int val)
@@ -45,11 +47,12 @@ static int iomap_write_reg(struct m_can_classdev *cdev, int reg, int val)
 	return 0;
 }
 
-static int iomap_write_fifo(struct m_can_classdev *cdev, int offset, int val)
+static int iomap_write_fifo(struct m_can_classdev *cdev, int offset,
+			    const void *val, size_t val_count)
 {
 	struct m_can_plat_priv *priv = cdev_to_priv(cdev);
 
-	writel(val, priv->mram_base + offset);
+	iowrite32_rep(priv->base + offset, val, val_count);
 
 	return 0;
 }
@@ -127,7 +130,9 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, mcan_class);
 
-	m_can_init_ram(mcan_class);
+	ret = m_can_init_ram(mcan_class);
+	if (ret)
+		goto probe_fail;
 
 	pm_runtime_enable(mcan_class->dev);
 	ret = m_can_class_register(mcan_class);
diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
index a4cbfedb6621..04687b15b250 100644
--- a/drivers/net/can/m_can/tcan4x5x-core.c
+++ b/drivers/net/can/m_can/tcan4x5x-core.c
@@ -153,14 +153,12 @@ static u32 tcan4x5x_read_reg(struct m_can_classdev *cdev, int reg)
 	return val;
 }
 
-static u32 tcan4x5x_read_fifo(struct m_can_classdev *cdev, int addr_offset)
+static int tcan4x5x_read_fifo(struct m_can_classdev *cdev, int addr_offset,
+			      void *val, size_t val_count)
 {
 	struct tcan4x5x_priv *priv = cdev_to_priv(cdev);
-	u32 val;
-
-	regmap_read(priv->regmap, TCAN4X5X_MRAM_START + addr_offset, &val);
 
-	return val;
+	return regmap_bulk_read(priv->regmap, TCAN4X5X_MRAM_START + addr_offset, val, val_count);
 }
 
 static int tcan4x5x_write_reg(struct m_can_classdev *cdev, int reg, int val)
@@ -171,11 +169,11 @@ static int tcan4x5x_write_reg(struct m_can_classdev *cdev, int reg, int val)
 }
 
 static int tcan4x5x_write_fifo(struct m_can_classdev *cdev,
-			       int addr_offset, int val)
+			       int addr_offset, const void *val, size_t val_count)
 {
 	struct tcan4x5x_priv *priv = cdev_to_priv(cdev);
 
-	return regmap_write(priv->regmap, TCAN4X5X_MRAM_START + addr_offset, val);
+	return regmap_bulk_write(priv->regmap, TCAN4X5X_MRAM_START + addr_offset, val, val_count);
 }
 
 static int tcan4x5x_power_enable(struct regulator *reg, int enable)
@@ -237,7 +235,9 @@ static int tcan4x5x_init(struct m_can_classdev *cdev)
 		return ret;
 
 	/* Zero out the MCAN buffers */
-	m_can_init_ram(cdev);
+	ret = m_can_init_ram(cdev);
+	if (ret)
+		return ret;
 
 	ret = regmap_update_bits(tcan4x5x->regmap, TCAN4X5X_CONFIG,
 				 TCAN4X5X_MODE_SEL_MASK, TCAN4X5X_MODE_NORMAL);
-- 
2.32.0


