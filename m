Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CA31A8946
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503861AbgDNSXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:23:46 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:56986 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503804AbgDNSVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:21:40 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 491v292NNyz1qs4B;
        Tue, 14 Apr 2020 20:21:21 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 491v291t69z1qqkS;
        Tue, 14 Apr 2020 20:21:21 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 40oXDEeNOLe1; Tue, 14 Apr 2020 20:21:19 +0200 (CEST)
X-Auth-Info: 33IjG7PELiFKYaNlvDkAqpfQn770PDelJwH6knq1e44=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 14 Apr 2020 20:21:19 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V4 16/19] net: ks8851: Implement register, FIFO, lock accessor callbacks
Date:   Tue, 14 Apr 2020 20:20:26 +0200
Message-Id: <20200414182029.183594-17-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414182029.183594-1-marex@denx.de>
References: <20200414182029.183594-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The register and FIFO accessors are bus specific, so is locking.
Implement callbacks so that each variant of the KS8851 can implement
matching accessors and locking, and use the rest of the common code.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V4: New patch
---
 drivers/net/ethernet/micrel/ks8851.c | 167 +++++++++++++++++++++++----
 1 file changed, 145 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index ea498be22e82..93191331f3a1 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -117,6 +117,24 @@ struct ks8851_net {
 	struct regulator	*vdd_reg;
 	struct regulator	*vdd_io;
 	int			gpio;
+
+	void			(*lock)(struct ks8851_net *ks,
+					unsigned long *flags);
+	void			(*unlock)(struct ks8851_net *ks,
+					  unsigned long *flags);
+	unsigned int		(*rdreg16)(struct ks8851_net *ks,
+					   unsigned int reg);
+	void			(*wrreg16)(struct ks8851_net *ks,
+					   unsigned int reg, unsigned int val);
+	void			(*rdfifo)(struct ks8851_net *ks, u8 *buff,
+					  unsigned int len);
+	void			(*wrfifo)(struct ks8851_net *ks,
+					  struct sk_buff *txp, bool irq);
+	netdev_tx_t		(*start_xmit)(struct sk_buff *skb,
+					      struct net_device *dev);
+	void			(*rx_skb)(struct ks8851_net *ks,
+					  struct sk_buff *skb);
+	void			(*flush_tx_work)(struct ks8851_net *ks);
 };
 
 /**
@@ -161,13 +179,13 @@ static int msg_enable;
 #define MK_OP(_byteen, _reg) (BYTE_EN(_byteen) | (_reg)  << (8+2) | (_reg) >> 6)
 
 /**
- * ks8851_lock - register access lock
+ * ks8851_lock_spi - register access lock for SPI
  * @ks: The chip state
  * @flags: Spinlock flags
  *
  * Claim chip register access lock
  */
-static void ks8851_lock(struct ks8851_net *ks, unsigned long *flags)
+static void ks8851_lock_spi(struct ks8851_net *ks, unsigned long *flags)
 {
 	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 
@@ -175,19 +193,43 @@ static void ks8851_lock(struct ks8851_net *ks, unsigned long *flags)
 }
 
 /**
- * ks8851_unlock - register access unlock
+ * ks8851_unlock_spi - register access unlock for SPI
  * @ks: The chip state
  * @flags: Spinlock flags
  *
  * Release chip register access lock
  */
-static void ks8851_unlock(struct ks8851_net *ks, unsigned long *flags)
+static void ks8851_unlock_spi(struct ks8851_net *ks, unsigned long *flags)
 {
 	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 
 	mutex_unlock(&kss->lock);
 }
 
+/**
+ * ks8851_lock - register access lock
+ * @ks: The chip state
+ * @flags: Spinlock flags
+ *
+ * Claim chip register access lock
+ */
+static void ks8851_lock(struct ks8851_net *ks, unsigned long *flags)
+{
+	ks->lock(ks, flags);
+}
+
+/**
+ * ks8851_unlock - register access unlock
+ * @ks: The chip state
+ * @flags: Spinlock flags
+ *
+ * Release chip register access lock
+ */
+static void ks8851_unlock(struct ks8851_net *ks, unsigned long *flags)
+{
+	ks->unlock(ks, flags);
+}
+
 /* SPI register read/write calls.
  *
  * All these calls issue SPI transactions to access the chip's registers. They
@@ -196,14 +238,15 @@ static void ks8851_unlock(struct ks8851_net *ks, unsigned long *flags)
  */
 
 /**
- * ks8851_wrreg16 - write 16bit register value to chip
+ * ks8851_wrreg16_spi - write 16bit register value to chip via SPI
  * @ks: The chip state
  * @reg: The register address
  * @val: The value to write
  *
  * Issue a write to put the value @val into the register specified in @reg.
  */
-static void ks8851_wrreg16(struct ks8851_net *ks, unsigned reg, unsigned val)
+static void ks8851_wrreg16_spi(struct ks8851_net *ks, unsigned int reg,
+			       unsigned int val)
 {
 	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 	struct spi_transfer *xfer = &kss->spi_xfer1;
@@ -223,6 +266,20 @@ static void ks8851_wrreg16(struct ks8851_net *ks, unsigned reg, unsigned val)
 		netdev_err(ks->netdev, "spi_sync() failed\n");
 }
 
+/**
+ * ks8851_wrreg16 - write 16bit register value to chip
+ * @ks: The chip state
+ * @reg: The register address
+ * @val: The value to write
+ *
+ * Issue a write to put the value @val into the register specified in @reg.
+ */
+static void ks8851_wrreg16(struct ks8851_net *ks, unsigned int reg,
+			   unsigned int val)
+{
+	ks->wrreg16(ks, reg, val);
+}
+
 /**
  * ks8851_rdreg - issue read register command and return the data
  * @ks: The device state
@@ -276,13 +333,14 @@ static void ks8851_rdreg(struct ks8851_net *ks, unsigned op,
 }
 
 /**
- * ks8851_rdreg16 - read 16 bit register from device
+ * ks8851_rdreg16_spi - read 16 bit register from device via SPI
  * @ks: The chip information
  * @reg: The register address
  *
  * Read a 16bit register from the chip, returning the result
 */
-static unsigned ks8851_rdreg16(struct ks8851_net *ks, unsigned reg)
+static unsigned int ks8851_rdreg16_spi(struct ks8851_net *ks,
+				       unsigned int reg)
 {
 	__le16 rx = 0;
 
@@ -290,6 +348,19 @@ static unsigned ks8851_rdreg16(struct ks8851_net *ks, unsigned reg)
 	return le16_to_cpu(rx);
 }
 
+/**
+ * ks8851_rdreg16 - read 16 bit register from device
+ * @ks: The chip information
+ * @reg: The register address
+ *
+ * Read a 16bit register from the chip, returning the result
+ */
+static unsigned int ks8851_rdreg16(struct ks8851_net *ks,
+				   unsigned int reg)
+{
+	return ks->rdreg16(ks, reg);
+}
+
 /**
  * ks8851_soft_reset - issue one of the soft reset to the device
  * @ks: The device state.
@@ -429,7 +500,7 @@ static void ks8851_init_mac(struct ks8851_net *ks, struct device_node *np)
 }
 
 /**
- * ks8851_rdfifo - read data from the receive fifo
+ * ks8851_rdfifo_spi - read data from the receive fifo via SPI
  * @ks: The device state.
  * @buff: The buffer address
  * @len: The length of the data to read
@@ -437,7 +508,8 @@ static void ks8851_init_mac(struct ks8851_net *ks, struct device_node *np)
  * Issue an RXQ FIFO read command and read the @len amount of data from
  * the FIFO into the buffer specified by @buff.
  */
-static void ks8851_rdfifo(struct ks8851_net *ks, u8 *buff, unsigned len)
+static void ks8851_rdfifo_spi(struct ks8851_net *ks, u8 *buff,
+			      unsigned int len)
 {
 	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 	struct spi_transfer *xfer = kss->spi_xfer2;
@@ -482,14 +554,23 @@ static void ks8851_dbg_dumpkkt(struct ks8851_net *ks, u8 *rxpkt)
 }
 
 /**
- * ks8851_rx_skb - receive skbuff
+ * ks8851_rx_skb_spi - receive skbuff for SPI
  * @skb: The skbuff
  */
-static void ks8851_rx_skb(struct sk_buff *skb)
+static void ks8851_rx_skb_spi(struct ks8851_net *ks, struct sk_buff *skb)
 {
 	netif_rx_ni(skb);
 }
 
+/**
+ * ks8851_rx_skb - receive skbuff
+ * @skb: The skbuff
+ */
+static void ks8851_rx_skb(struct ks8851_net *ks, struct sk_buff *skb)
+{
+	ks->rx_skb(ks, skb);
+}
+
 /**
  * ks8851_rx_pkts - receive packets from the host
  * @ks: The device information.
@@ -552,13 +633,13 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 
 				rxpkt = skb_put(skb, rxlen) - 8;
 
-				ks8851_rdfifo(ks, rxpkt, rxalign + 8);
+				ks->rdfifo(ks, rxpkt, rxalign + 8);
 
 				if (netif_msg_pktdata(ks))
 					ks8851_dbg_dumpkkt(ks, rxpkt);
 
 				skb->protocol = eth_type_trans(skb, ks->netdev);
-				ks8851_rx_skb(skb);
+				ks8851_rx_skb(ks, skb);
 
 				ks->netdev->stats.rx_packets++;
 				ks->netdev->stats.rx_bytes += rxlen;
@@ -682,7 +763,7 @@ static inline unsigned calc_txlen(unsigned len)
 }
 
 /**
- * ks8851_wrpkt - write packet to TX FIFO
+ * ks8851_wrpkt_spi - write packet to TX FIFO via SPI
  * @ks: The device state.
  * @txp: The sk_buff to transmit.
  * @irq: IRQ on completion of the packet.
@@ -692,7 +773,8 @@ static inline unsigned calc_txlen(unsigned len)
  * needs, such as IRQ on completion. Send the header and the packet data to
  * the device.
  */
-static void ks8851_wrpkt(struct ks8851_net *ks, struct sk_buff *txp, bool irq)
+static void ks8851_wrpkt_spi(struct ks8851_net *ks, struct sk_buff *txp,
+			     bool irq)
 {
 	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 	struct spi_transfer *xfer = kss->spi_xfer2;
@@ -770,7 +852,7 @@ static void ks8851_tx_work(struct work_struct *work)
 
 		if (txb != NULL) {
 			ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_SDA);
-			ks8851_wrpkt(ks, txb, last);
+			ks->wrfifo(ks, txb, last);
 			ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr);
 			ks8851_wrreg16(ks, KS_TXQCR, TXQCR_METFE);
 
@@ -782,16 +864,26 @@ static void ks8851_tx_work(struct work_struct *work)
 }
 
 /**
- * ks8851_flush_tx_work - flush outstanding TX work
+ * ks8851_flush_tx_work_spi - flush outstanding TX work for SPI
  * @ks: The device state
  */
-static void ks8851_flush_tx_work(struct ks8851_net *ks)
+static void ks8851_flush_tx_work_spi(struct ks8851_net *ks)
 {
 	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 
 	flush_work(&kss->tx_work);
 }
 
+/**
+ * ks8851_flush_tx_work - flush outstanding TX work
+ * @ks: The device state
+ */
+static void ks8851_flush_tx_work(struct ks8851_net *ks)
+{
+	if (ks->flush_tx_work)
+		ks->flush_tx_work(ks);
+}
+
 /**
  * ks8851_net_open - open network device
  * @dev: The network device being opened.
@@ -925,7 +1017,7 @@ static int ks8851_net_stop(struct net_device *dev)
 }
 
 /**
- * ks8851_start_xmit - transmit packet
+ * ks8851_start_xmit_spi - transmit packet using SPI
  * @skb: The buffer to transmit
  * @dev: The device used to transmit the packet.
  *
@@ -937,8 +1029,8 @@ static int ks8851_net_stop(struct net_device *dev)
  * and secondly so we can round up more than one packet to transmit which
  * means we can try and avoid generating too many transmit done interrupts.
  */
-static netdev_tx_t ks8851_start_xmit(struct sk_buff *skb,
-				     struct net_device *dev)
+static netdev_tx_t ks8851_start_xmit_spi(struct sk_buff *skb,
+					 struct net_device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
 	unsigned needed = calc_txlen(skb->len);
@@ -966,6 +1058,27 @@ static netdev_tx_t ks8851_start_xmit(struct sk_buff *skb,
 	return ret;
 }
 
+/**
+ * ks8851_start_xmit - transmit packet
+ * @skb: The buffer to transmit
+ * @dev: The device used to transmit the packet.
+ *
+ * Called by the network layer to transmit the @skb. Queue the packet for
+ * the device and schedule the necessary work to transmit the packet when
+ * it is free.
+ *
+ * We do this to firstly avoid sleeping with the network device locked,
+ * and secondly so we can round up more than one packet to transmit which
+ * means we can try and avoid generating too many transmit done interrupts.
+ */
+static netdev_tx_t ks8851_start_xmit(struct sk_buff *skb,
+				     struct net_device *dev)
+{
+	struct ks8851_net *ks = netdev_priv(dev);
+
+	return ks->start_xmit(skb, dev);
+}
+
 /**
  * ks8851_rxctrl_work - work handler to change rx mode
  * @work: The work structure this belongs to.
@@ -1590,6 +1703,16 @@ static int ks8851_probe(struct spi_device *spi)
 
 	ks = netdev_priv(netdev);
 
+	ks->lock = ks8851_lock_spi;
+	ks->unlock = ks8851_unlock_spi;
+	ks->rdreg16 = ks8851_rdreg16_spi;
+	ks->wrreg16 = ks8851_wrreg16_spi;
+	ks->rdfifo = ks8851_rdfifo_spi;
+	ks->wrfifo = ks8851_wrpkt_spi;
+	ks->start_xmit = ks8851_start_xmit_spi;
+	ks->rx_skb = ks8851_rx_skb_spi;
+	ks->flush_tx_work = ks8851_flush_tx_work_spi;
+
 #define STD_IRQ (IRQ_LCI |	/* Link Change */	\
 		 IRQ_TXI |	/* TX done */		\
 		 IRQ_RXI |	/* RX done */		\
-- 
2.25.1

