Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4633E19021A
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 00:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgCWXnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 19:43:43 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:43822 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbgCWXnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 19:43:41 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48mWDB5nkdz1qsbL;
        Tue, 24 Mar 2020 00:43:38 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48mWDB5ch0z1qyDk;
        Tue, 24 Mar 2020 00:43:38 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id jfoBuTTb1ywY; Tue, 24 Mar 2020 00:43:36 +0100 (CET)
X-Auth-Info: raxlEOcX3oIqOHA2344WnP0f9MsTcGF5ZdUl84vPtr0=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 24 Mar 2020 00:43:35 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH 12/14] net: ks8851: Separate SPI operations into separate file
Date:   Tue, 24 Mar 2020 00:43:01 +0100
Message-Id: <20200323234303.526748-13-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323234303.526748-1-marex@denx.de>
References: <20200323234303.526748-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pull all the SPI bus specific code into a separate file, so that it is
not mixed with the common code. No functional change.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/micrel/Makefile     |   2 +-
 drivers/net/ethernet/micrel/ks8851.c     | 404 +----------------------
 drivers/net/ethernet/micrel/ks8851.h     | 123 +++++++
 drivers/net/ethernet/micrel/ks8851_spi.c | 311 +++++++++++++++++
 4 files changed, 439 insertions(+), 401 deletions(-)
 create mode 100644 drivers/net/ethernet/micrel/ks8851_spi.c

diff --git a/drivers/net/ethernet/micrel/Makefile b/drivers/net/ethernet/micrel/Makefile
index 6d8ac5527aef..bb5c6c53fa02 100644
--- a/drivers/net/ethernet/micrel/Makefile
+++ b/drivers/net/ethernet/micrel/Makefile
@@ -4,6 +4,6 @@
 #
 
 obj-$(CONFIG_KS8842) += ks8842.o
-obj-$(CONFIG_KS8851) += ks8851.o
+obj-$(CONFIG_KS8851) += ks8851.o ks8851_spi.o
 obj-$(CONFIG_KS8851_MLL) += ks8851_mll.o
 obj-$(CONFIG_KSZ884X_PCI) += ksz884x.o
diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index d5bdbd9122bf..dd8d8a88c7e9 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -22,192 +22,14 @@
 #include <linux/eeprom_93cx6.h>
 #include <linux/regulator/consumer.h>
 
-#include <linux/spi/spi.h>
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
 #include <linux/of_net.h>
 
 #include "ks8851.h"
 
-/**
- * struct ks8851_rxctrl - KS8851 driver rx control
- * @mchash: Multicast hash-table data.
- * @rxcr1: KS_RXCR1 register setting
- * @rxcr2: KS_RXCR2 register setting
- *
- * Representation of the settings needs to control the receive filtering
- * such as the multicast hash-filter and the receive register settings. This
- * is used to make the job of working out if the receive settings change and
- * then issuing the new settings to the worker that will send the necessary
- * commands.
- */
-struct ks8851_rxctrl {
-	u16	mchash[4];
-	u16	rxcr1;
-	u16	rxcr2;
-};
-
-/**
- * union ks8851_tx_hdr - tx header data
- * @txb: The header as bytes
- * @txw: The header as 16bit, little-endian words
- *
- * A dual representation of the tx header data to allow
- * access to individual bytes, and to allow 16bit accesses
- * with 16bit alignment.
- */
-union ks8851_tx_hdr {
-	u8	txb[6];
-	__le16	txw[3];
-};
-
-/**
- * struct ks8851_net - KS8851 driver private data
- * @netdev: The network device we're bound to
- * @spidev: The spi device we're bound to.
- * @lock: Lock to ensure that the device is not accessed when busy.
- * @statelock: Lock on this structure for tx list.
- * @mii: The MII state information for the mii calls.
- * @rxctrl: RX settings for @rxctrl_work.
- * @tx_work: Work queue for tx packets
- * @rxctrl_work: Work queue for updating RX mode and multicast lists
- * @txq: Queue of packets for transmission.
- * @spi_msg1: pre-setup SPI transfer with one message, @spi_xfer1.
- * @spi_msg2: pre-setup SPI transfer with two messages, @spi_xfer2.
- * @txh: Space for generating packet TX header in DMA-able data
- * @rxd: Space for receiving SPI data, in DMA-able space.
- * @txd: Space for transmitting SPI data, in DMA-able space.
- * @msg_enable: The message flags controlling driver output (see ethtool).
- * @fid: Incrementing frame id tag.
- * @rc_ier: Cached copy of KS_IER.
- * @rc_ccr: Cached copy of KS_CCR.
- * @rc_rxqcr: Cached copy of KS_RXQCR.
- * @eeprom: 93CX6 EEPROM state for accessing on-board EEPROM.
- * @vdd_reg:	Optional regulator supplying the chip
- * @vdd_io: Optional digital power supply for IO
- * @gpio: Optional reset_n gpio
- *
- * The @lock ensures that the chip is protected when certain operations are
- * in progress. When the read or write packet transfer is in progress, most
- * of the chip registers are not ccessible until the transfer is finished and
- * the DMA has been de-asserted.
- *
- * The @statelock is used to protect information in the structure which may
- * need to be accessed via several sources, such as the network driver layer
- * or one of the work queues.
- *
- * We align the buffers we may use for rx/tx to ensure that if the SPI driver
- * wants to DMA map them, it will not have any problems with data the driver
- * modifies.
- */
-struct ks8851_net {
-	struct net_device	*netdev;
-	struct mutex		lock;
-	spinlock_t		statelock;
-
-	union ks8851_tx_hdr	txh ____cacheline_aligned;
-	u8			rxd[8];
-	u8			txd[8];
-
-	u32			msg_enable ____cacheline_aligned;
-	u16			tx_space;
-	u8			fid;
-
-	u16			rc_ier;
-	u16			rc_rxqcr;
-	u16			rc_ccr;
-
-	struct mii_if_info	mii;
-	struct ks8851_rxctrl	rxctrl;
-
-	struct work_struct	tx_work;
-	struct work_struct	rxctrl_work;
-
-	struct sk_buff_head	txq;
-
-	struct eeprom_93cx6	eeprom;
-	struct regulator	*vdd_reg;
-	struct regulator	*vdd_io;
-	int			gpio;
-
-	unsigned int		(*rdreg16)(struct ks8851_net *ks,
-					   unsigned int reg);
-	void			(*wrreg16)(struct ks8851_net *ks,
-					   unsigned int reg, unsigned int val);
-	void			(*rdfifo)(struct ks8851_net *ks, u8 *buff,
-					  unsigned int len);
-	void			(*wrfifo)(struct ks8851_net *ks,
-					  struct sk_buff *txp, bool irq);
-};
-
-/**
- * struct ks8851_net_spi - KS8851 SPI driver private data
- * @ks8851: KS8851 driver common private data
- * @spidev: The spi device we're bound to.
- * @spi_msg1: pre-setup SPI transfer with one message, @spi_xfer1.
- * @spi_msg2: pre-setup SPI transfer with two messages, @spi_xfer2.
- */
-struct ks8851_net_spi {
-	struct ks8851_net	ks8851;	/* Must be first */
-	struct spi_device	*spidev;
-	struct spi_message	spi_msg1;
-	struct spi_message	spi_msg2;
-	struct spi_transfer	spi_xfer1;
-	struct spi_transfer	spi_xfer2[2];
-};
-
-#define to_ks8851_spi(ks) container_of((ks), struct ks8851_net_spi, ks8851)
-
 static int msg_enable;
 
-/* SPI frame opcodes */
-#define KS_SPIOP_RD	(0x00)
-#define KS_SPIOP_WR	(0x40)
-#define KS_SPIOP_RXFIFO	(0x80)
-#define KS_SPIOP_TXFIFO	(0xC0)
-
-/* shift for byte-enable data */
-#define BYTE_EN(_x)	((_x) << 2)
-
-/* turn register number and byte-enable mask into data for start of packet */
-#define MK_OP(_byteen, _reg) (BYTE_EN(_byteen) | (_reg)  << (8+2) | (_reg) >> 6)
-
-/* SPI register read/write calls.
- *
- * All these calls issue SPI transactions to access the chip's registers. They
- * all require that the necessary lock is held to prevent accesses when the
- * chip is busy transferring packet data (RX/TX FIFO accesses).
- */
-
-/**
- * ks8851_wrreg16_spi - write 16bit register value to chip via SPI
- * @ks: The chip state
- * @reg: The register address
- * @val: The value to write
- *
- * Issue a write to put the value @val into the register specified in @reg.
- */
-static void ks8851_wrreg16_spi(struct ks8851_net *ks, unsigned int reg,
-			       unsigned int val)
-{
-	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
-	struct spi_transfer *xfer = &kss->spi_xfer1;
-	struct spi_message *msg = &kss->spi_msg1;
-	__le16 txb[2];
-	int ret;
-
-	txb[0] = cpu_to_le16(MK_OP(reg & 2 ? 0xC : 0x03, reg) | KS_SPIOP_WR);
-	txb[1] = cpu_to_le16(val);
-
-	xfer->tx_buf = txb;
-	xfer->rx_buf = NULL;
-	xfer->len = 4;
-
-	ret = spi_sync(kss->spidev, msg);
-	if (ret < 0)
-		netdev_err(ks->netdev, "spi_sync() failed\n");
-}
-
 /**
  * ks8851_wrreg16 - write 16bit register value to chip
  * @ks: The chip state
@@ -222,74 +44,6 @@ static void ks8851_wrreg16(struct ks8851_net *ks, unsigned int reg,
 	ks->wrreg16(ks, reg, val);
 }
 
-/**
- * ks8851_rdreg - issue read register command and return the data
- * @ks: The device state
- * @op: The register address and byte enables in message format.
- * @rxb: The RX buffer to return the result into
- * @rxl: The length of data expected.
- *
- * This is the low level read call that issues the necessary spi message(s)
- * to read data from the register specified in @op.
- */
-static void ks8851_rdreg(struct ks8851_net *ks, unsigned op,
-			 u8 *rxb, unsigned rxl)
-{
-	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
-	struct spi_transfer *xfer;
-	struct spi_message *msg;
-	__le16 *txb = (__le16 *)ks->txd;
-	u8 *trx = ks->rxd;
-	int ret;
-
-	txb[0] = cpu_to_le16(op | KS_SPIOP_RD);
-
-	if (kss->spidev->master->flags & SPI_MASTER_HALF_DUPLEX) {
-		msg = &kss->spi_msg2;
-		xfer = kss->spi_xfer2;
-
-		xfer->tx_buf = txb;
-		xfer->rx_buf = NULL;
-		xfer->len = 2;
-
-		xfer++;
-		xfer->tx_buf = NULL;
-		xfer->rx_buf = trx;
-		xfer->len = rxl;
-	} else {
-		msg = &kss->spi_msg1;
-		xfer = &kss->spi_xfer1;
-
-		xfer->tx_buf = txb;
-		xfer->rx_buf = trx;
-		xfer->len = rxl + 2;
-	}
-
-	ret = spi_sync(kss->spidev, msg);
-	if (ret < 0)
-		netdev_err(ks->netdev, "read: spi_sync() failed\n");
-	else if (kss->spidev->master->flags & SPI_MASTER_HALF_DUPLEX)
-		memcpy(rxb, trx, rxl);
-	else
-		memcpy(rxb, trx + 2, rxl);
-}
-
-/**
- * ks8851_rdreg16_spi - read 16 bit register from device via SPI
- * @ks: The chip information
- * @reg: The register address
- *
- * Read a 16bit register from the chip, returning the result
-*/
-static unsigned int ks8851_rdreg16_spi(struct ks8851_net *ks,
-				       unsigned int reg)
-{
-	__le16 rx = 0;
-
-	ks8851_rdreg(ks, MK_OP(reg & 2 ? 0xC : 0x3, reg), (u8 *)&rx, 2);
-	return le16_to_cpu(rx);
-}
-
 /**
  * ks8851_rdreg16 - read 16 bit register from device
  * @ks: The chip information
@@ -439,44 +193,6 @@ static void ks8851_init_mac(struct ks8851_net *ks, struct device *ddev)
 	ks8851_write_mac_addr(dev);
 }
 
-/**
- * ks8851_rdfifo_spi - read data from the receive fifo via SPI
- * @ks: The device state.
- * @buff: The buffer address
- * @len: The length of the data to read
- *
- * Issue an RXQ FIFO read command and read the @len amount of data from
- * the FIFO into the buffer specified by @buff.
- */
-static void ks8851_rdfifo_spi(struct ks8851_net *ks, u8 *buff,
-			      unsigned int len)
-{
-	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
-	struct spi_transfer *xfer = kss->spi_xfer2;
-	struct spi_message *msg = &kss->spi_msg2;
-	u8 txb[1];
-	int ret;
-
-	netif_dbg(ks, rx_status, ks->netdev,
-		  "%s: %d@%p\n", __func__, len, buff);
-
-	/* set the operation we're issuing */
-	txb[0] = KS_SPIOP_RXFIFO;
-
-	xfer->tx_buf = txb;
-	xfer->rx_buf = NULL;
-	xfer->len = 1;
-
-	xfer++;
-	xfer->rx_buf = buff;
-	xfer->tx_buf = NULL;
-	xfer->len = len;
-
-	ret = spi_sync(kss->spidev, msg);
-	if (ret < 0)
-		netdev_err(ks->netdev, "%s: spi_sync() failed\n", __func__);
-}
-
 /**
  * ks8851_dbg_dumpkkt - dump initial packet contents to debug
  * @ks: The device state
@@ -683,54 +399,6 @@ static inline unsigned calc_txlen(unsigned len)
 	return ALIGN(len + 4, 4);
 }
 
-/**
- * ks8851_wrpkt_spi - write packet to TX FIFO via SPI
- * @ks: The device state.
- * @txp: The sk_buff to transmit.
- * @irq: IRQ on completion of the packet.
- *
- * Send the @txp to the chip. This means creating the relevant packet header
- * specifying the length of the packet and the other information the chip
- * needs, such as IRQ on completion. Send the header and the packet data to
- * the device.
- */
-static void ks8851_wrpkt_spi(struct ks8851_net *ks, struct sk_buff *txp,
-			     bool irq)
-{
-	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
-	struct spi_transfer *xfer = kss->spi_xfer2;
-	struct spi_message *msg = &kss->spi_msg2;
-	unsigned fid = 0;
-	int ret;
-
-	netif_dbg(ks, tx_queued, ks->netdev, "%s: skb %p, %d@%p, irq %d\n",
-		  __func__, txp, txp->len, txp->data, irq);
-
-	fid = ks->fid++;
-	fid &= TXFR_TXFID_MASK;
-
-	if (irq)
-		fid |= TXFR_TXIC;	/* irq on completion */
-
-	/* start header at txb[1] to align txw entries */
-	ks->txh.txb[1] = KS_SPIOP_TXFIFO;
-	ks->txh.txw[1] = cpu_to_le16(fid);
-	ks->txh.txw[2] = cpu_to_le16(txp->len);
-
-	xfer->tx_buf = &ks->txh.txb[1];
-	xfer->rx_buf = NULL;
-	xfer->len = 5;
-
-	xfer++;
-	xfer->tx_buf = txp->data;
-	xfer->rx_buf = NULL;
-	xfer->len = ALIGN(txp->len, 4);
-
-	ret = spi_sync(kss->spidev, msg);
-	if (ret < 0)
-		netdev_err(ks->netdev, "%s: spi_sync() failed\n", __func__);
-}
-
 /**
  * ks8851_done_tx - update and then free skbuff after transmitting
  * @ks: The device state
@@ -1382,7 +1050,7 @@ static int ks8851_read_selftest(struct ks8851_net *ks)
 
 #ifdef CONFIG_PM_SLEEP
 
-static int ks8851_suspend(struct device *dev)
+int ks8851_suspend(struct device *dev)
 {
 	struct ks8851_net *ks = dev_get_drvdata(dev);
 	struct net_device *netdev = ks->netdev;
@@ -1395,7 +1063,7 @@ static int ks8851_suspend(struct device *dev)
 	return 0;
 }
 
-static int ks8851_resume(struct device *dev)
+int ks8851_resume(struct device *dev)
 {
 	struct ks8851_net *ks = dev_get_drvdata(dev);
 	struct net_device *netdev = ks->netdev;
@@ -1409,9 +1077,7 @@ static int ks8851_resume(struct device *dev)
 }
 #endif
 
-static SIMPLE_DEV_PM_OPS(ks8851_pm_ops, ks8851_suspend, ks8851_resume);
-
-static int ks8851_probe_common(struct net_device *ndev, struct device *dev)
+int ks8851_probe_common(struct net_device *ndev, struct device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(ndev);
 	unsigned cider;
@@ -1545,7 +1211,7 @@ static int ks8851_probe_common(struct net_device *ndev, struct device *dev)
 	return ret;
 }
 
-static int ks8851_remove_common(struct device *dev)
+int ks8851_remove_common(struct device *dev)
 {
 	struct ks8851_net *priv = dev_get_drvdata(dev);
 
@@ -1561,68 +1227,6 @@ static int ks8851_remove_common(struct device *dev)
 	return 0;
 }
 
-static int ks8851_probe(struct spi_device *spi)
-{
-	struct device *dev = &spi->dev;
-	struct ks8851_net_spi *kss;
-	struct net_device *ndev;
-	struct ks8851_net *ks;
-
-	ndev = devm_alloc_etherdev(dev, sizeof(struct ks8851_net_spi));
-	if (!ndev)
-		return -ENOMEM;
-
-	spi->bits_per_word = 8;
-
-	ks = netdev_priv(ndev);
-	ks->rdreg16 = ks8851_rdreg16_spi;
-	ks->wrreg16 = ks8851_wrreg16_spi;
-	ks->rdfifo = ks8851_rdfifo_spi;
-	ks->wrfifo = ks8851_wrpkt_spi;
-
-	kss = to_ks8851_spi(ks);
-
-	kss->spidev = spi;
-
-	/* initialise pre-made spi transfer messages */
-	spi_message_init(&kss->spi_msg1);
-	spi_message_add_tail(&kss->spi_xfer1, &kss->spi_msg1);
-
-	spi_message_init(&kss->spi_msg2);
-	spi_message_add_tail(&kss->spi_xfer2[0], &kss->spi_msg2);
-	spi_message_add_tail(&kss->spi_xfer2[1], &kss->spi_msg2);
-
-	ndev->irq = spi->irq;
-
-	return ks8851_probe_common(ndev, dev);
-}
-
-static int ks8851_remove(struct spi_device *spi)
-{
-	return ks8851_remove_common(&spi->dev);
-}
-
-static const struct of_device_id ks8851_match_table[] = {
-	{ .compatible = "micrel,ks8851" },
-	{ }
-};
-MODULE_DEVICE_TABLE(of, ks8851_match_table);
-
-static struct spi_driver ks8851_driver = {
-	.driver = {
-		.name = "ks8851",
-		.of_match_table = ks8851_match_table,
-		.pm = &ks8851_pm_ops,
-	},
-	.probe = ks8851_probe,
-	.remove = ks8851_remove,
-};
-module_spi_driver(ks8851_driver);
-
-MODULE_DESCRIPTION("KS8851 Network driver");
-MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
-MODULE_LICENSE("GPL");
-
 module_param_named(message, msg_enable, int, 0);
 MODULE_PARM_DESC(message, "Message verbosity level (0=none, 31=all)");
 MODULE_ALIAS("spi:ks8851");
diff --git a/drivers/net/ethernet/micrel/ks8851.h b/drivers/net/ethernet/micrel/ks8851.h
index 8f834aef8e32..8b2acbc06f15 100644
--- a/drivers/net/ethernet/micrel/ks8851.h
+++ b/drivers/net/ethernet/micrel/ks8851.h
@@ -7,6 +7,9 @@
  * KS8851 register definitions
 */
 
+#ifndef __KS8851_H__
+#define __KS8851_H__
+
 #define KS_CCR					0x08
 #define CCR_LE					(1 << 10)   /* KSZ8851-16MLL */
 #define CCR_EEPROM				(1 << 9)
@@ -300,3 +303,123 @@
 #define TXFR_TXIC				(1 << 15)
 #define TXFR_TXFID_MASK				(0x3f << 0)
 #define TXFR_TXFID_SHIFT			(0)
+
+/**
+ * struct ks8851_rxctrl - KS8851 driver rx control
+ * @mchash: Multicast hash-table data.
+ * @rxcr1: KS_RXCR1 register setting
+ * @rxcr2: KS_RXCR2 register setting
+ *
+ * Representation of the settings needs to control the receive filtering
+ * such as the multicast hash-filter and the receive register settings. This
+ * is used to make the job of working out if the receive settings change and
+ * then issuing the new settings to the worker that will send the necessary
+ * commands.
+ */
+struct ks8851_rxctrl {
+	u16	mchash[4];
+	u16	rxcr1;
+	u16	rxcr2;
+};
+
+/**
+ * union ks8851_tx_hdr - tx header data
+ * @txb: The header as bytes
+ * @txw: The header as 16bit, little-endian words
+ *
+ * A dual representation of the tx header data to allow
+ * access to individual bytes, and to allow 16bit accesses
+ * with 16bit alignment.
+ */
+union ks8851_tx_hdr {
+	u8	txb[6];
+	__le16	txw[3];
+};
+
+/**
+ * struct ks8851_net - KS8851 driver private data
+ * @netdev: The network device we're bound to
+ * @spidev: The spi device we're bound to.
+ * @lock: Lock to ensure that the device is not accessed when busy.
+ * @statelock: Lock on this structure for tx list.
+ * @mii: The MII state information for the mii calls.
+ * @rxctrl: RX settings for @rxctrl_work.
+ * @tx_work: Work queue for tx packets
+ * @rxctrl_work: Work queue for updating RX mode and multicast lists
+ * @txq: Queue of packets for transmission.
+ * @spi_msg1: pre-setup SPI transfer with one message, @spi_xfer1.
+ * @spi_msg2: pre-setup SPI transfer with two messages, @spi_xfer2.
+ * @txh: Space for generating packet TX header in DMA-able data
+ * @rxd: Space for receiving SPI data, in DMA-able space.
+ * @txd: Space for transmitting SPI data, in DMA-able space.
+ * @msg_enable: The message flags controlling driver output (see ethtool).
+ * @fid: Incrementing frame id tag.
+ * @rc_ier: Cached copy of KS_IER.
+ * @rc_ccr: Cached copy of KS_CCR.
+ * @rc_rxqcr: Cached copy of KS_RXQCR.
+ * @eeprom: 93CX6 EEPROM state for accessing on-board EEPROM.
+ * @vdd_reg:	Optional regulator supplying the chip
+ * @vdd_io: Optional digital power supply for IO
+ * @gpio: Optional reset_n gpio
+ *
+ * The @lock ensures that the chip is protected when certain operations are
+ * in progress. When the read or write packet transfer is in progress, most
+ * of the chip registers are not ccessible until the transfer is finished and
+ * the DMA has been de-asserted.
+ *
+ * The @statelock is used to protect information in the structure which may
+ * need to be accessed via several sources, such as the network driver layer
+ * or one of the work queues.
+ *
+ * We align the buffers we may use for rx/tx to ensure that if the SPI driver
+ * wants to DMA map them, it will not have any problems with data the driver
+ * modifies.
+ */
+struct ks8851_net {
+	struct net_device	*netdev;
+	struct mutex		lock;
+	spinlock_t		statelock;
+
+	union ks8851_tx_hdr	txh ____cacheline_aligned;
+	u8			rxd[8];
+	u8			txd[8];
+
+	u32			msg_enable ____cacheline_aligned;
+	u16			tx_space;
+	u8			fid;
+
+	u16			rc_ier;
+	u16			rc_rxqcr;
+	u16			rc_ccr;
+
+	struct mii_if_info	mii;
+	struct ks8851_rxctrl	rxctrl;
+
+	struct work_struct	tx_work;
+	struct work_struct	rxctrl_work;
+
+	struct sk_buff_head	txq;
+
+	struct eeprom_93cx6	eeprom;
+	struct regulator	*vdd_reg;
+	struct regulator	*vdd_io;
+	int			gpio;
+
+	unsigned int		(*rdreg16)(struct ks8851_net *ks,
+					   unsigned int reg);
+	void			(*wrreg16)(struct ks8851_net *ks,
+					   unsigned int reg, unsigned int val);
+	void			(*rdfifo)(struct ks8851_net *ks, u8 *buff,
+					  unsigned int len);
+	void			(*wrfifo)(struct ks8851_net *ks,
+					  struct sk_buff *txp, bool irq);
+};
+
+int ks8851_probe_common(struct net_device *ndev, struct device *dev);
+int ks8851_remove_common(struct device *dev);
+int ks8851_suspend(struct device *dev);
+int ks8851_resume(struct device *dev);
+
+static SIMPLE_DEV_PM_OPS(ks8851_pm_ops, ks8851_suspend, ks8851_resume);
+
+#endif
diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
new file mode 100644
index 000000000000..07f1b8f09fc0
--- /dev/null
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -0,0 +1,311 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* drivers/net/ethernet/micrel/ks8851.c
+ *
+ * Copyright 2009 Simtec Electronics
+ *	http://www.simtec.co.uk/
+ *	Ben Dooks <ben@simtec.co.uk>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#define DEBUG
+
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/cache.h>
+#include <linux/crc32.h>
+#include <linux/mii.h>
+#include <linux/eeprom_93cx6.h>
+#include <linux/regulator/consumer.h>
+
+#include <linux/spi/spi.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/of_net.h>
+
+#include "ks8851.h"
+
+/**
+ * struct ks8851_net_spi - KS8851 SPI driver private data
+ * @ks8851: KS8851 driver common private data
+ * @spidev: The spi device we're bound to.
+ * @spi_msg1: pre-setup SPI transfer with one message, @spi_xfer1.
+ * @spi_msg2: pre-setup SPI transfer with two messages, @spi_xfer2.
+ */
+struct ks8851_net_spi {
+	struct ks8851_net	ks8851;	/* Must be first */
+	struct spi_device	*spidev;
+	struct spi_message	spi_msg1;
+	struct spi_message	spi_msg2;
+	struct spi_transfer	spi_xfer1;
+	struct spi_transfer	spi_xfer2[2];
+};
+
+#define to_ks8851_spi(ks) container_of((ks), struct ks8851_net_spi, ks8851)
+
+/* SPI frame opcodes */
+#define KS_SPIOP_RD	0x00
+#define KS_SPIOP_WR	0x40
+#define KS_SPIOP_RXFIFO	0x80
+#define KS_SPIOP_TXFIFO	0xC0
+
+/* shift for byte-enable data */
+#define BYTE_EN(_x)	((_x) << 2)
+
+/* turn register number and byte-enable mask into data for start of packet */
+#define MK_OP(_byteen, _reg)	\
+	(BYTE_EN(_byteen) | (_reg) << (8 + 2) | (_reg) >> 6)
+
+/* SPI register read/write calls.
+ *
+ * All these calls issue SPI transactions to access the chip's registers. They
+ * all require that the necessary lock is held to prevent accesses when the
+ * chip is busy transferring packet data (RX/TX FIFO accesses).
+ */
+
+/**
+ * ks8851_wrreg16_spi - write 16bit register value to chip via SPI
+ * @ks: The chip state
+ * @reg: The register address
+ * @val: The value to write
+ *
+ * Issue a write to put the value @val into the register specified in @reg.
+ */
+static void ks8851_wrreg16_spi(struct ks8851_net *ks, unsigned int reg,
+			       unsigned int val)
+{
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+	struct spi_transfer *xfer = &kss->spi_xfer1;
+	struct spi_message *msg = &kss->spi_msg1;
+	__le16 txb[2];
+	int ret;
+
+	txb[0] = cpu_to_le16(MK_OP(reg & 2 ? 0xC : 0x03, reg) | KS_SPIOP_WR);
+	txb[1] = cpu_to_le16(val);
+
+	xfer->tx_buf = txb;
+	xfer->rx_buf = NULL;
+	xfer->len = 4;
+
+	ret = spi_sync(kss->spidev, msg);
+	if (ret < 0)
+		netdev_err(ks->netdev, "spi_sync() failed\n");
+}
+
+/**
+ * ks8851_rdreg - issue read register command and return the data
+ * @ks: The device state
+ * @op: The register address and byte enables in message format.
+ * @rxb: The RX buffer to return the result into
+ * @rxl: The length of data expected.
+ *
+ * This is the low level read call that issues the necessary spi message(s)
+ * to read data from the register specified in @op.
+ */
+static void ks8851_rdreg(struct ks8851_net *ks, unsigned int op,
+			 u8 *rxb, unsigned int rxl)
+{
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+	struct spi_transfer *xfer;
+	struct spi_message *msg;
+	__le16 *txb = (__le16 *)ks->txd;
+	u8 *trx = ks->rxd;
+	int ret;
+
+	txb[0] = cpu_to_le16(op | KS_SPIOP_RD);
+
+	if (kss->spidev->master->flags & SPI_MASTER_HALF_DUPLEX) {
+		msg = &kss->spi_msg2;
+		xfer = kss->spi_xfer2;
+
+		xfer->tx_buf = txb;
+		xfer->rx_buf = NULL;
+		xfer->len = 2;
+
+		xfer++;
+		xfer->tx_buf = NULL;
+		xfer->rx_buf = trx;
+		xfer->len = rxl;
+	} else {
+		msg = &kss->spi_msg1;
+		xfer = &kss->spi_xfer1;
+
+		xfer->tx_buf = txb;
+		xfer->rx_buf = trx;
+		xfer->len = rxl + 2;
+	}
+
+	ret = spi_sync(kss->spidev, msg);
+	if (ret < 0)
+		netdev_err(ks->netdev, "read: spi_sync() failed\n");
+	else if (kss->spidev->master->flags & SPI_MASTER_HALF_DUPLEX)
+		memcpy(rxb, trx, rxl);
+	else
+		memcpy(rxb, trx + 2, rxl);
+}
+
+/**
+ * ks8851_rdreg16_spi - read 16 bit register from device via SPI
+ * @ks: The chip information
+ * @reg: The register address
+ *
+ * Read a 16bit register from the chip, returning the result
+ */
+static unsigned int ks8851_rdreg16_spi(struct ks8851_net *ks, unsigned int reg)
+{
+	__le16 rx = 0;
+
+	ks8851_rdreg(ks, MK_OP(reg & 2 ? 0xC : 0x3, reg), (u8 *)&rx, 2);
+	return le16_to_cpu(rx);
+}
+
+/**
+ * ks8851_rdfifo_spi - read data from the receive fifo via SPI
+ * @ks: The device state.
+ * @buff: The buffer address
+ * @len: The length of the data to read
+ *
+ * Issue an RXQ FIFO read command and read the @len amount of data from
+ * the FIFO into the buffer specified by @buff.
+ */
+static void ks8851_rdfifo_spi(struct ks8851_net *ks, u8 *buff, unsigned int len)
+{
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+	struct spi_transfer *xfer = kss->spi_xfer2;
+	struct spi_message *msg = &kss->spi_msg2;
+	u8 txb[1];
+	int ret;
+
+	netif_dbg(ks, rx_status, ks->netdev,
+		  "%s: %d@%p\n", __func__, len, buff);
+
+	/* set the operation we're issuing */
+	txb[0] = KS_SPIOP_RXFIFO;
+
+	xfer->tx_buf = txb;
+	xfer->rx_buf = NULL;
+	xfer->len = 1;
+
+	xfer++;
+	xfer->rx_buf = buff;
+	xfer->tx_buf = NULL;
+	xfer->len = len;
+
+	ret = spi_sync(kss->spidev, msg);
+	if (ret < 0)
+		netdev_err(ks->netdev, "%s: spi_sync() failed\n", __func__);
+}
+
+/**
+ * ks8851_wrpkt_spi - write packet to TX FIFO via SPI
+ * @ks: The device state.
+ * @txp: The sk_buff to transmit.
+ * @irq: IRQ on completion of the packet.
+ *
+ * Send the @txp to the chip. This means creating the relevant packet header
+ * specifying the length of the packet and the other information the chip
+ * needs, such as IRQ on completion. Send the header and the packet data to
+ * the device.
+ */
+static void ks8851_wrpkt_spi(struct ks8851_net *ks, struct sk_buff *txp,
+			     bool irq)
+{
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+	struct spi_transfer *xfer = kss->spi_xfer2;
+	struct spi_message *msg = &kss->spi_msg2;
+	unsigned int fid = 0;
+	int ret;
+
+	netif_dbg(ks, tx_queued, ks->netdev, "%s: skb %p, %d@%p, irq %d\n",
+		  __func__, txp, txp->len, txp->data, irq);
+
+	fid = ks->fid++;
+	fid &= TXFR_TXFID_MASK;
+
+	if (irq)
+		fid |= TXFR_TXIC;	/* irq on completion */
+
+	/* start header at txb[1] to align txw entries */
+	ks->txh.txb[1] = KS_SPIOP_TXFIFO;
+	ks->txh.txw[1] = cpu_to_le16(fid);
+	ks->txh.txw[2] = cpu_to_le16(txp->len);
+
+	xfer->tx_buf = &ks->txh.txb[1];
+	xfer->rx_buf = NULL;
+	xfer->len = 5;
+
+	xfer++;
+	xfer->tx_buf = txp->data;
+	xfer->rx_buf = NULL;
+	xfer->len = ALIGN(txp->len, 4);
+
+	ret = spi_sync(kss->spidev, msg);
+	if (ret < 0)
+		netdev_err(ks->netdev, "%s: spi_sync() failed\n", __func__);
+}
+
+static int ks8851_probe_spi(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct ks8851_net_spi *kss;
+	struct net_device *ndev;
+	struct ks8851_net *ks;
+
+	ndev = devm_alloc_etherdev(dev, sizeof(struct ks8851_net_spi));
+	if (!ndev)
+		return -ENOMEM;
+
+	spi->bits_per_word = 8;
+
+	ks = netdev_priv(ndev);
+	ks->rdreg16 = ks8851_rdreg16_spi;
+	ks->wrreg16 = ks8851_wrreg16_spi;
+	ks->rdfifo = ks8851_rdfifo_spi;
+	ks->wrfifo = ks8851_wrpkt_spi;
+
+	kss = to_ks8851_spi(ks);
+
+	kss->spidev = spi;
+
+	/* initialise pre-made spi transfer messages */
+	spi_message_init(&kss->spi_msg1);
+	spi_message_add_tail(&kss->spi_xfer1, &kss->spi_msg1);
+
+	spi_message_init(&kss->spi_msg2);
+	spi_message_add_tail(&kss->spi_xfer2[0], &kss->spi_msg2);
+	spi_message_add_tail(&kss->spi_xfer2[1], &kss->spi_msg2);
+
+	ndev->irq = spi->irq;
+
+	return ks8851_probe_common(ndev, dev);
+}
+
+static int ks8851_remove_spi(struct spi_device *spi)
+{
+	return ks8851_remove_common(&spi->dev);
+}
+
+static const struct of_device_id ks8851_match_table[] = {
+	{ .compatible = "micrel,ks8851" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ks8851_match_table);
+
+static struct spi_driver ks8851_driver = {
+	.driver = {
+		.name = "ks8851",
+		.of_match_table = ks8851_match_table,
+		.pm = &ks8851_pm_ops,
+	},
+	.probe = ks8851_probe_spi,
+	.remove = ks8851_remove_spi,
+};
+module_spi_driver(ks8851_driver);
+
+MODULE_DESCRIPTION("KS8851 Network driver");
+MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
+MODULE_LICENSE("GPL");
-- 
2.25.1

