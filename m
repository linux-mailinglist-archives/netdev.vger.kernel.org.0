Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF5C1A8940
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503848AbgDNSXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:23:12 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:56986 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503802AbgDNSVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:21:34 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 491v235yTzz1qs3k;
        Tue, 14 Apr 2020 20:21:15 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 491v235hFxz1qqkS;
        Tue, 14 Apr 2020 20:21:15 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id LdSzP0F6oXNW; Tue, 14 Apr 2020 20:21:14 +0200 (CEST)
X-Auth-Info: QfrcQeVjAQzhOtCy7cxf48+kxx2JjuyW8k/hpu94sgM=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 14 Apr 2020 20:21:14 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V4 12/19] net: ks8851: Split out SPI specific entries in struct ks8851_net
Date:   Tue, 14 Apr 2020 20:20:22 +0200
Message-Id: <20200414182029.183594-13-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414182029.183594-1-marex@denx.de>
References: <20200414182029.183594-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new struct ks8851_net_spi, which embeds the original
struct ks8851_net and contains the entries specific only to
the SPI variant of KS8851.

There should be no functional change.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V2: - Drop 'must be first' comment on the embedded struct ks8851_net
    - Remove moved kerneldoc entries for struct ks8851_net
V3: - Split out also tx_work and lock
V4: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 128 +++++++++++++++++----------
 1 file changed, 79 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 01b00c81a928..440ddd5cafbd 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -64,16 +64,11 @@ union ks8851_tx_hdr {
 /**
  * struct ks8851_net - KS8851 driver private data
  * @netdev: The network device we're bound to
- * @spidev: The spi device we're bound to.
- * @lock: Lock to ensure that the device is not accessed when busy.
  * @statelock: Lock on this structure for tx list.
  * @mii: The MII state information for the mii calls.
  * @rxctrl: RX settings for @rxctrl_work.
- * @tx_work: Work queue for tx packets
  * @rxctrl_work: Work queue for updating RX mode and multicast lists
  * @txq: Queue of packets for transmission.
- * @spi_msg1: pre-setup SPI transfer with one message, @spi_xfer1.
- * @spi_msg2: pre-setup SPI transfer with two messages, @spi_xfer2.
  * @txh: Space for generating packet TX header in DMA-able data
  * @rxd: Space for receiving SPI data, in DMA-able space.
  * @txd: Space for transmitting SPI data, in DMA-able space.
@@ -87,11 +82,6 @@ union ks8851_tx_hdr {
  * @vdd_io: Optional digital power supply for IO
  * @gpio: Optional reset_n gpio
  *
- * The @lock ensures that the chip is protected when certain operations are
- * in progress. When the read or write packet transfer is in progress, most
- * of the chip registers are not ccessible until the transfer is finished and
- * the DMA has been de-asserted.
- *
  * The @statelock is used to protect information in the structure which may
  * need to be accessed via several sources, such as the network driver layer
  * or one of the work queues.
@@ -102,8 +92,6 @@ union ks8851_tx_hdr {
  */
 struct ks8851_net {
 	struct net_device	*netdev;
-	struct spi_device	*spidev;
-	struct mutex		lock;
 	spinlock_t		statelock;
 
 	union ks8851_tx_hdr	txh ____cacheline_aligned;
@@ -121,22 +109,43 @@ struct ks8851_net {
 	struct mii_if_info	mii;
 	struct ks8851_rxctrl	rxctrl;
 
-	struct work_struct	tx_work;
 	struct work_struct	rxctrl_work;
 
 	struct sk_buff_head	txq;
 
-	struct spi_message	spi_msg1;
-	struct spi_message	spi_msg2;
-	struct spi_transfer	spi_xfer1;
-	struct spi_transfer	spi_xfer2[2];
-
 	struct eeprom_93cx6	eeprom;
 	struct regulator	*vdd_reg;
 	struct regulator	*vdd_io;
 	int			gpio;
 };
 
+/**
+ * struct ks8851_net_spi - KS8851 SPI driver private data
+ * @ks8851: KS8851 driver common private data
+ * @lock: Lock to ensure that the device is not accessed when busy.
+ * @tx_work: Work queue for tx packets
+ * @spidev: The spi device we're bound to.
+ * @spi_msg1: pre-setup SPI transfer with one message, @spi_xfer1.
+ * @spi_msg2: pre-setup SPI transfer with two messages, @spi_xfer2.
+ *
+ * The @lock ensures that the chip is protected when certain operations are
+ * in progress. When the read or write packet transfer is in progress, most
+ * of the chip registers are not ccessible until the transfer is finished and
+ * the DMA has been de-asserted.
+ */
+struct ks8851_net_spi {
+	struct ks8851_net	ks8851;
+	struct mutex		lock;
+	struct work_struct	tx_work;
+	struct spi_device	*spidev;
+	struct spi_message	spi_msg1;
+	struct spi_message	spi_msg2;
+	struct spi_transfer	spi_xfer1;
+	struct spi_transfer	spi_xfer2[2];
+};
+
+#define to_ks8851_spi(ks) container_of((ks), struct ks8851_net_spi, ks8851)
+
 static int msg_enable;
 
 /* SPI frame opcodes */
@@ -160,7 +169,9 @@ static int msg_enable;
  */
 static void ks8851_lock(struct ks8851_net *ks, unsigned long *flags)
 {
-	mutex_lock(&ks->lock);
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+
+	mutex_lock(&kss->lock);
 }
 
 /**
@@ -172,7 +183,9 @@ static void ks8851_lock(struct ks8851_net *ks, unsigned long *flags)
  */
 static void ks8851_unlock(struct ks8851_net *ks, unsigned long *flags)
 {
-	mutex_unlock(&ks->lock);
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+
+	mutex_unlock(&kss->lock);
 }
 
 /* SPI register read/write calls.
@@ -192,8 +205,9 @@ static void ks8851_unlock(struct ks8851_net *ks, unsigned long *flags)
  */
 static void ks8851_wrreg16(struct ks8851_net *ks, unsigned reg, unsigned val)
 {
-	struct spi_transfer *xfer = &ks->spi_xfer1;
-	struct spi_message *msg = &ks->spi_msg1;
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+	struct spi_transfer *xfer = &kss->spi_xfer1;
+	struct spi_message *msg = &kss->spi_msg1;
 	__le16 txb[2];
 	int ret;
 
@@ -204,7 +218,7 @@ static void ks8851_wrreg16(struct ks8851_net *ks, unsigned reg, unsigned val)
 	xfer->rx_buf = NULL;
 	xfer->len = 4;
 
-	ret = spi_sync(ks->spidev, msg);
+	ret = spi_sync(kss->spidev, msg);
 	if (ret < 0)
 		netdev_err(ks->netdev, "spi_sync() failed\n");
 }
@@ -222,6 +236,7 @@ static void ks8851_wrreg16(struct ks8851_net *ks, unsigned reg, unsigned val)
 static void ks8851_rdreg(struct ks8851_net *ks, unsigned op,
 			 u8 *rxb, unsigned rxl)
 {
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 	struct spi_transfer *xfer;
 	struct spi_message *msg;
 	__le16 *txb = (__le16 *)ks->txd;
@@ -230,9 +245,9 @@ static void ks8851_rdreg(struct ks8851_net *ks, unsigned op,
 
 	txb[0] = cpu_to_le16(op | KS_SPIOP_RD);
 
-	if (ks->spidev->master->flags & SPI_MASTER_HALF_DUPLEX) {
-		msg = &ks->spi_msg2;
-		xfer = ks->spi_xfer2;
+	if (kss->spidev->master->flags & SPI_MASTER_HALF_DUPLEX) {
+		msg = &kss->spi_msg2;
+		xfer = kss->spi_xfer2;
 
 		xfer->tx_buf = txb;
 		xfer->rx_buf = NULL;
@@ -243,18 +258,18 @@ static void ks8851_rdreg(struct ks8851_net *ks, unsigned op,
 		xfer->rx_buf = trx;
 		xfer->len = rxl;
 	} else {
-		msg = &ks->spi_msg1;
-		xfer = &ks->spi_xfer1;
+		msg = &kss->spi_msg1;
+		xfer = &kss->spi_xfer1;
 
 		xfer->tx_buf = txb;
 		xfer->rx_buf = trx;
 		xfer->len = rxl + 2;
 	}
 
-	ret = spi_sync(ks->spidev, msg);
+	ret = spi_sync(kss->spidev, msg);
 	if (ret < 0)
 		netdev_err(ks->netdev, "read: spi_sync() failed\n");
-	else if (ks->spidev->master->flags & SPI_MASTER_HALF_DUPLEX)
+	else if (kss->spidev->master->flags & SPI_MASTER_HALF_DUPLEX)
 		memcpy(rxb, trx, rxl);
 	else
 		memcpy(rxb, trx + 2, rxl);
@@ -424,8 +439,9 @@ static void ks8851_init_mac(struct ks8851_net *ks, struct device_node *np)
  */
 static void ks8851_rdfifo(struct ks8851_net *ks, u8 *buff, unsigned len)
 {
-	struct spi_transfer *xfer = ks->spi_xfer2;
-	struct spi_message *msg = &ks->spi_msg2;
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+	struct spi_transfer *xfer = kss->spi_xfer2;
+	struct spi_message *msg = &kss->spi_msg2;
 	u8 txb[1];
 	int ret;
 
@@ -444,7 +460,7 @@ static void ks8851_rdfifo(struct ks8851_net *ks, u8 *buff, unsigned len)
 	xfer->tx_buf = NULL;
 	xfer->len = len;
 
-	ret = spi_sync(ks->spidev, msg);
+	ret = spi_sync(kss->spidev, msg);
 	if (ret < 0)
 		netdev_err(ks->netdev, "%s: spi_sync() failed\n", __func__);
 }
@@ -678,8 +694,9 @@ static inline unsigned calc_txlen(unsigned len)
  */
 static void ks8851_wrpkt(struct ks8851_net *ks, struct sk_buff *txp, bool irq)
 {
-	struct spi_transfer *xfer = ks->spi_xfer2;
-	struct spi_message *msg = &ks->spi_msg2;
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+	struct spi_transfer *xfer = kss->spi_xfer2;
+	struct spi_message *msg = &kss->spi_msg2;
 	unsigned fid = 0;
 	int ret;
 
@@ -706,7 +723,7 @@ static void ks8851_wrpkt(struct ks8851_net *ks, struct sk_buff *txp, bool irq)
 	xfer->rx_buf = NULL;
 	xfer->len = ALIGN(txp->len, 4);
 
-	ret = spi_sync(ks->spidev, msg);
+	ret = spi_sync(kss->spidev, msg);
 	if (ret < 0)
 		netdev_err(ks->netdev, "%s: spi_sync() failed\n", __func__);
 }
@@ -735,10 +752,15 @@ static void ks8851_done_tx(struct ks8851_net *ks, struct sk_buff *txb)
  */
 static void ks8851_tx_work(struct work_struct *work)
 {
-	struct ks8851_net *ks = container_of(work, struct ks8851_net, tx_work);
+	struct ks8851_net_spi *kss;
+	struct ks8851_net *ks;
 	unsigned long flags;
 	struct sk_buff *txb;
-	bool last = skb_queue_empty(&ks->txq);
+	bool last;
+
+	kss = container_of(work, struct ks8851_net_spi, tx_work);
+	ks = &kss->ks8851;
+	last = skb_queue_empty(&ks->txq);
 
 	ks8851_lock(ks, &flags);
 
@@ -858,8 +880,11 @@ static int ks8851_net_open(struct net_device *dev)
 static int ks8851_net_stop(struct net_device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
+	struct ks8851_net_spi *kss;
 	unsigned long flags;
 
+	kss = to_ks8851_spi(ks);
+
 	netif_info(ks, ifdown, dev, "shutting down\n");
 
 	netif_stop_queue(dev);
@@ -871,7 +896,7 @@ static int ks8851_net_stop(struct net_device *dev)
 	ks8851_unlock(ks, &flags);
 
 	/* stop any outstanding work */
-	flush_work(&ks->tx_work);
+	flush_work(&kss->tx_work);
 	flush_work(&ks->rxctrl_work);
 
 	ks8851_lock(ks, &flags);
@@ -919,6 +944,9 @@ static netdev_tx_t ks8851_start_xmit(struct sk_buff *skb,
 	struct ks8851_net *ks = netdev_priv(dev);
 	unsigned needed = calc_txlen(skb->len);
 	netdev_tx_t ret = NETDEV_TX_OK;
+	struct ks8851_net_spi *kss;
+
+	kss = to_ks8851_spi(ks);
 
 	netif_dbg(ks, tx_queued, ks->netdev,
 		  "%s: skb %p, %d@%p\n", __func__, skb, skb->len, skb->data);
@@ -934,7 +962,7 @@ static netdev_tx_t ks8851_start_xmit(struct sk_buff *skb,
 	}
 
 	spin_unlock(&ks->statelock);
-	schedule_work(&ks->tx_work);
+	schedule_work(&kss->tx_work);
 
 	return ret;
 }
@@ -1406,22 +1434,24 @@ static SIMPLE_DEV_PM_OPS(ks8851_pm_ops, ks8851_suspend, ks8851_resume);
 static int ks8851_probe(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
+	struct ks8851_net_spi *kss;
 	struct net_device *netdev;
 	struct ks8851_net *ks;
 	int ret;
 	unsigned cider;
 	int gpio;
 
-	netdev = devm_alloc_etherdev(dev, sizeof(struct ks8851_net));
+	netdev = devm_alloc_etherdev(dev, sizeof(struct ks8851_net_spi));
 	if (!netdev)
 		return -ENOMEM;
 
 	spi->bits_per_word = 8;
 
 	ks = netdev_priv(netdev);
+	kss = to_ks8851_spi(ks);
 
 	ks->netdev = netdev;
-	ks->spidev = spi;
+	kss->spidev = spi;
 	ks->tx_space = 6144;
 
 	gpio = of_get_named_gpio_flags(dev->of_node, "reset-gpios", 0, NULL);
@@ -1467,20 +1497,20 @@ static int ks8851_probe(struct spi_device *spi)
 		gpio_set_value(gpio, 1);
 	}
 
-	mutex_init(&ks->lock);
+	mutex_init(&kss->lock);
 	spin_lock_init(&ks->statelock);
 
-	INIT_WORK(&ks->tx_work, ks8851_tx_work);
+	INIT_WORK(&kss->tx_work, ks8851_tx_work);
 	INIT_WORK(&ks->rxctrl_work, ks8851_rxctrl_work);
 
 	/* initialise pre-made spi transfer messages */
 
-	spi_message_init(&ks->spi_msg1);
-	spi_message_add_tail(&ks->spi_xfer1, &ks->spi_msg1);
+	spi_message_init(&kss->spi_msg1);
+	spi_message_add_tail(&kss->spi_xfer1, &kss->spi_msg1);
 
-	spi_message_init(&ks->spi_msg2);
-	spi_message_add_tail(&ks->spi_xfer2[0], &ks->spi_msg2);
-	spi_message_add_tail(&ks->spi_xfer2[1], &ks->spi_msg2);
+	spi_message_init(&kss->spi_msg2);
+	spi_message_add_tail(&kss->spi_xfer2[0], &kss->spi_msg2);
+	spi_message_add_tail(&kss->spi_xfer2[1], &kss->spi_msg2);
 
 	/* setup EEPROM state */
 
-- 
2.25.1

