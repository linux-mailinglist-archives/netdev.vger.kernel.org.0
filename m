Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8838D1A894A
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503867AbgDNSXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:23:53 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:50264 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503812AbgDNSVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:21:48 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 491v2F6FB7z1qsbF;
        Tue, 14 Apr 2020 20:21:25 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 491v2F5TxHz1qtwb;
        Tue, 14 Apr 2020 20:21:25 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 4EiY_7MvZwKp; Tue, 14 Apr 2020 20:21:22 +0200 (CEST)
X-Auth-Info: auI/zJ9PRGzhSs6v55jXhYgxQnMoTB1aw6EHChLg20w=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 14 Apr 2020 20:21:22 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V4 17/19] net: ks8851: Separate SPI operations into separate file
Date:   Tue, 14 Apr 2020 20:20:27 +0200
Message-Id: <20200414182029.183594-18-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414182029.183594-1-marex@denx.de>
References: <20200414182029.183594-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pull all the SPI bus specific code into a separate file, so that it is
not mixed with the common code. Rename ks8851.c to ks8851_common.c. The
ks8851_common.c is linked with ks8851_spi.c now, so it can call the
accessors in the ks8851_spi.c without any pointer indirection.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V2: Get rid of the pointer indirection
V3: Rename ks8851.c to ks8851_common.c and adjust Makefile to permit
    module to be built
V4: - Include linux/eeprom_93cx6.h in the ks8851.h to make the eeprom
      functions available in both ks8851_spi.c and soon ks8851_par.c
    - Move calc_txlen() into ks8851_spi.c
    - Fix incorrect use of ks->tx_work in the SPI driver
    - Replace 'unsigned' with 'unsigned int' where applicable
---
 drivers/net/ethernet/micrel/Makefile          |   1 +
 drivers/net/ethernet/micrel/ks8851.h          | 138 +++++
 .../micrel/{ks8851.c => ks8851_common.c}      | 584 +-----------------
 drivers/net/ethernet/micrel/ks8851_spi.c      | 476 ++++++++++++++
 4 files changed, 620 insertions(+), 579 deletions(-)
 rename drivers/net/ethernet/micrel/{ks8851.c => ks8851_common.c} (65%)
 create mode 100644 drivers/net/ethernet/micrel/ks8851_spi.c

diff --git a/drivers/net/ethernet/micrel/Makefile b/drivers/net/ethernet/micrel/Makefile
index 6d8ac5527aef..c7a4725c2e95 100644
--- a/drivers/net/ethernet/micrel/Makefile
+++ b/drivers/net/ethernet/micrel/Makefile
@@ -5,5 +5,6 @@
 
 obj-$(CONFIG_KS8842) += ks8842.o
 obj-$(CONFIG_KS8851) += ks8851.o
+ks8851-objs = ks8851_common.o ks8851_spi.o
 obj-$(CONFIG_KS8851_MLL) += ks8851_mll.o
 obj-$(CONFIG_KSZ884X_PCI) += ksz884x.o
diff --git a/drivers/net/ethernet/micrel/ks8851.h b/drivers/net/ethernet/micrel/ks8851.h
index f210d18a10b5..e218e8b7d364 100644
--- a/drivers/net/ethernet/micrel/ks8851.h
+++ b/drivers/net/ethernet/micrel/ks8851.h
@@ -7,6 +7,11 @@
  * KS8851 register definitions
 */
 
+#ifndef __KS8851_H__
+#define __KS8851_H__
+
+#include <linux/eeprom_93cx6.h>
+
 #define KS_CCR					0x08
 #define CCR_LE					(1 << 10)   /* KSZ8851-16MLL */
 #define CCR_EEPROM				(1 << 9)
@@ -300,3 +305,136 @@
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
+ * @statelock: Lock on this structure for tx list.
+ * @mii: The MII state information for the mii calls.
+ * @rxctrl: RX settings for @rxctrl_work.
+ * @rxctrl_work: Work queue for updating RX mode and multicast lists
+ * @txq: Queue of packets for transmission.
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
+	struct work_struct	rxctrl_work;
+
+	struct sk_buff_head	txq;
+
+	struct eeprom_93cx6	eeprom;
+	struct regulator	*vdd_reg;
+	struct regulator	*vdd_io;
+	int			gpio;
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
+};
+
+int ks8851_probe_common(struct net_device *netdev, struct device *dev);
+int ks8851_remove_common(struct device *dev);
+int ks8851_suspend(struct device *dev);
+int ks8851_resume(struct device *dev);
+
+static SIMPLE_DEV_PM_OPS(ks8851_pm_ops, ks8851_suspend, ks8851_resume);
+
+/**
+ * ks8851_done_tx - update and then free skbuff after transmitting
+ * @ks: The device state
+ * @txb: The buffer transmitted
+ */
+static void __maybe_unused ks8851_done_tx(struct ks8851_net *ks,
+					  struct sk_buff *txb)
+{
+	struct net_device *dev = ks->netdev;
+
+	dev->stats.tx_bytes += txb->len;
+	dev->stats.tx_packets++;
+
+	dev_kfree_skb(txb);
+}
+
+#endif
diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851_common.c
similarity index 65%
rename from drivers/net/ethernet/micrel/ks8851.c
rename to drivers/net/ethernet/micrel/ks8851_common.c
index 93191331f3a1..27a351ad691b 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -19,193 +19,16 @@
 #include <linux/cache.h>
 #include <linux/crc32.h>
 #include <linux/mii.h>
-#include <linux/eeprom_93cx6.h>
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
- * @statelock: Lock on this structure for tx list.
- * @mii: The MII state information for the mii calls.
- * @rxctrl: RX settings for @rxctrl_work.
- * @rxctrl_work: Work queue for updating RX mode and multicast lists
- * @txq: Queue of packets for transmission.
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
-	struct work_struct	rxctrl_work;
-
-	struct sk_buff_head	txq;
-
-	struct eeprom_93cx6	eeprom;
-	struct regulator	*vdd_reg;
-	struct regulator	*vdd_io;
-	int			gpio;
-
-	void			(*lock)(struct ks8851_net *ks,
-					unsigned long *flags);
-	void			(*unlock)(struct ks8851_net *ks,
-					  unsigned long *flags);
-	unsigned int		(*rdreg16)(struct ks8851_net *ks,
-					   unsigned int reg);
-	void			(*wrreg16)(struct ks8851_net *ks,
-					   unsigned int reg, unsigned int val);
-	void			(*rdfifo)(struct ks8851_net *ks, u8 *buff,
-					  unsigned int len);
-	void			(*wrfifo)(struct ks8851_net *ks,
-					  struct sk_buff *txp, bool irq);
-	netdev_tx_t		(*start_xmit)(struct sk_buff *skb,
-					      struct net_device *dev);
-	void			(*rx_skb)(struct ks8851_net *ks,
-					  struct sk_buff *skb);
-	void			(*flush_tx_work)(struct ks8851_net *ks);
-};
-
-/**
- * struct ks8851_net_spi - KS8851 SPI driver private data
- * @ks8851: KS8851 driver common private data
- * @lock: Lock to ensure that the device is not accessed when busy.
- * @tx_work: Work queue for tx packets
- * @spidev: The spi device we're bound to.
- * @spi_msg1: pre-setup SPI transfer with one message, @spi_xfer1.
- * @spi_msg2: pre-setup SPI transfer with two messages, @spi_xfer2.
- *
- * The @lock ensures that the chip is protected when certain operations are
- * in progress. When the read or write packet transfer is in progress, most
- * of the chip registers are not ccessible until the transfer is finished and
- * the DMA has been de-asserted.
- */
-struct ks8851_net_spi {
-	struct ks8851_net	ks8851;
-	struct mutex		lock;
-	struct work_struct	tx_work;
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
-/**
- * ks8851_lock_spi - register access lock for SPI
- * @ks: The chip state
- * @flags: Spinlock flags
- *
- * Claim chip register access lock
- */
-static void ks8851_lock_spi(struct ks8851_net *ks, unsigned long *flags)
-{
-	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
-
-	mutex_lock(&kss->lock);
-}
-
-/**
- * ks8851_unlock_spi - register access unlock for SPI
- * @ks: The chip state
- * @flags: Spinlock flags
- *
- * Release chip register access lock
- */
-static void ks8851_unlock_spi(struct ks8851_net *ks, unsigned long *flags)
-{
-	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
-
-	mutex_unlock(&kss->lock);
-}
-
 /**
  * ks8851_lock - register access lock
  * @ks: The chip state
@@ -230,42 +53,6 @@ static void ks8851_unlock(struct ks8851_net *ks, unsigned long *flags)
 	ks->unlock(ks, flags);
 }
 
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
@@ -280,74 +67,6 @@ static void ks8851_wrreg16(struct ks8851_net *ks, unsigned int reg,
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
@@ -499,51 +218,13 @@ static void ks8851_init_mac(struct ks8851_net *ks, struct device_node *np)
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
  * @rxpkt: The data for the received packet
  *
  * Dump the initial data from the packet to dev_dbg().
-*/
+ */
 static void ks8851_dbg_dumpkkt(struct ks8851_net *ks, u8 *rxpkt)
 {
 	netdev_dbg(ks->netdev,
@@ -553,15 +234,6 @@ static void ks8851_dbg_dumpkkt(struct ks8851_net *ks, u8 *rxpkt)
 		   rxpkt[12], rxpkt[13], rxpkt[14], rxpkt[15]);
 }
 
-/**
- * ks8851_rx_skb_spi - receive skbuff for SPI
- * @skb: The skbuff
- */
-static void ks8851_rx_skb_spi(struct ks8851_net *ks, struct sk_buff *skb)
-{
-	netif_rx_ni(skb);
-}
-
 /**
  * ks8851_rx_skb - receive skbuff
  * @skb: The skbuff
@@ -750,130 +422,6 @@ static irqreturn_t ks8851_irq(int irq, void *_ks)
 	return IRQ_HANDLED;
 }
 
-/**
- * calc_txlen - calculate size of message to send packet
- * @len: Length of data
- *
- * Returns the size of the TXFIFO message needed to send
- * this packet.
- */
-static inline unsigned calc_txlen(unsigned len)
-{
-	return ALIGN(len + 4, 4);
-}
-
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
-/**
- * ks8851_done_tx - update and then free skbuff after transmitting
- * @ks: The device state
- * @txb: The buffer transmitted
- */
-static void ks8851_done_tx(struct ks8851_net *ks, struct sk_buff *txb)
-{
-	struct net_device *dev = ks->netdev;
-
-	dev->stats.tx_bytes += txb->len;
-	dev->stats.tx_packets++;
-
-	dev_kfree_skb(txb);
-}
-
-/**
- * ks8851_tx_work - process tx packet(s)
- * @work: The work strucutre what was scheduled.
- *
- * This is called when a number of packets have been scheduled for
- * transmission and need to be sent to the device.
- */
-static void ks8851_tx_work(struct work_struct *work)
-{
-	struct ks8851_net_spi *kss;
-	struct ks8851_net *ks;
-	unsigned long flags;
-	struct sk_buff *txb;
-	bool last;
-
-	kss = container_of(work, struct ks8851_net_spi, tx_work);
-	ks = &kss->ks8851;
-	last = skb_queue_empty(&ks->txq);
-
-	ks8851_lock(ks, &flags);
-
-	while (!last) {
-		txb = skb_dequeue(&ks->txq);
-		last = skb_queue_empty(&ks->txq);
-
-		if (txb != NULL) {
-			ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_SDA);
-			ks->wrfifo(ks, txb, last);
-			ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr);
-			ks8851_wrreg16(ks, KS_TXQCR, TXQCR_METFE);
-
-			ks8851_done_tx(ks, txb);
-		}
-	}
-
-	ks8851_unlock(ks, &flags);
-}
-
-/**
- * ks8851_flush_tx_work_spi - flush outstanding TX work for SPI
- * @ks: The device state
- */
-static void ks8851_flush_tx_work_spi(struct ks8851_net *ks)
-{
-	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
-
-	flush_work(&kss->tx_work);
-}
-
 /**
  * ks8851_flush_tx_work - flush outstanding TX work
  * @ks: The device state
@@ -1016,48 +564,6 @@ static int ks8851_net_stop(struct net_device *dev)
 	return 0;
 }
 
-/**
- * ks8851_start_xmit_spi - transmit packet using SPI
- * @skb: The buffer to transmit
- * @dev: The device used to transmit the packet.
- *
- * Called by the network layer to transmit the @skb. Queue the packet for
- * the device and schedule the necessary work to transmit the packet when
- * it is free.
- *
- * We do this to firstly avoid sleeping with the network device locked,
- * and secondly so we can round up more than one packet to transmit which
- * means we can try and avoid generating too many transmit done interrupts.
- */
-static netdev_tx_t ks8851_start_xmit_spi(struct sk_buff *skb,
-					 struct net_device *dev)
-{
-	struct ks8851_net *ks = netdev_priv(dev);
-	unsigned needed = calc_txlen(skb->len);
-	netdev_tx_t ret = NETDEV_TX_OK;
-	struct ks8851_net_spi *kss;
-
-	kss = to_ks8851_spi(ks);
-
-	netif_dbg(ks, tx_queued, ks->netdev,
-		  "%s: skb %p, %d@%p\n", __func__, skb, skb->len, skb->data);
-
-	spin_lock(&ks->statelock);
-
-	if (needed > ks->tx_space) {
-		netif_stop_queue(dev);
-		ret = NETDEV_TX_BUSY;
-	} else {
-		ks->tx_space -= needed;
-		skb_queue_tail(&ks->txq, skb);
-	}
-
-	spin_unlock(&ks->statelock);
-	schedule_work(&kss->tx_work);
-
-	return ret;
-}
-
 /**
  * ks8851_start_xmit - transmit packet
  * @skb: The buffer to transmit
@@ -1514,7 +1020,7 @@ static int ks8851_read_selftest(struct ks8851_net *ks)
 
 #ifdef CONFIG_PM_SLEEP
 
-static int ks8851_suspend(struct device *dev)
+int ks8851_suspend(struct device *dev)
 {
 	struct ks8851_net *ks = dev_get_drvdata(dev);
 	struct net_device *netdev = ks->netdev;
@@ -1527,7 +1033,7 @@ static int ks8851_suspend(struct device *dev)
 	return 0;
 }
 
-static int ks8851_resume(struct device *dev)
+int ks8851_resume(struct device *dev)
 {
 	struct ks8851_net *ks = dev_get_drvdata(dev);
 	struct net_device *netdev = ks->netdev;
@@ -1541,9 +1047,7 @@ static int ks8851_resume(struct device *dev)
 }
 #endif
 
-static SIMPLE_DEV_PM_OPS(ks8851_pm_ops, ks8851_suspend, ks8851_resume);
-
-static int ks8851_probe_common(struct net_device *netdev, struct device *dev)
+int ks8851_probe_common(struct net_device *netdev, struct device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(netdev);
 	unsigned cider;
@@ -1672,7 +1176,7 @@ static int ks8851_probe_common(struct net_device *netdev, struct device *dev)
 	return ret;
 }
 
-static int ks8851_remove_common(struct device *dev)
+int ks8851_remove_common(struct device *dev)
 {
 	struct ks8851_net *priv = dev_get_drvdata(dev);
 
@@ -1688,84 +1192,6 @@ static int ks8851_remove_common(struct device *dev)
 	return 0;
 }
 
-static int ks8851_probe(struct spi_device *spi)
-{
-	struct device *dev = &spi->dev;
-	struct ks8851_net_spi *kss;
-	struct net_device *netdev;
-	struct ks8851_net *ks;
-
-	netdev = devm_alloc_etherdev(dev, sizeof(struct ks8851_net_spi));
-	if (!netdev)
-		return -ENOMEM;
-
-	spi->bits_per_word = 8;
-
-	ks = netdev_priv(netdev);
-
-	ks->lock = ks8851_lock_spi;
-	ks->unlock = ks8851_unlock_spi;
-	ks->rdreg16 = ks8851_rdreg16_spi;
-	ks->wrreg16 = ks8851_wrreg16_spi;
-	ks->rdfifo = ks8851_rdfifo_spi;
-	ks->wrfifo = ks8851_wrpkt_spi;
-	ks->start_xmit = ks8851_start_xmit_spi;
-	ks->rx_skb = ks8851_rx_skb_spi;
-	ks->flush_tx_work = ks8851_flush_tx_work_spi;
-
-#define STD_IRQ (IRQ_LCI |	/* Link Change */	\
-		 IRQ_TXI |	/* TX done */		\
-		 IRQ_RXI |	/* RX done */		\
-		 IRQ_SPIBEI |	/* SPI bus error */	\
-		 IRQ_TXPSI |	/* TX process stop */	\
-		 IRQ_RXPSI)	/* RX process stop */
-	ks->rc_ier = STD_IRQ;
-
-	kss = to_ks8851_spi(ks);
-
-	kss->spidev = spi;
-	mutex_init(&kss->lock);
-	INIT_WORK(&kss->tx_work, ks8851_tx_work);
-
-	/* initialise pre-made spi transfer messages */
-	spi_message_init(&kss->spi_msg1);
-	spi_message_add_tail(&kss->spi_xfer1, &kss->spi_msg1);
-
-	spi_message_init(&kss->spi_msg2);
-	spi_message_add_tail(&kss->spi_xfer2[0], &kss->spi_msg2);
-	spi_message_add_tail(&kss->spi_xfer2[1], &kss->spi_msg2);
-
-	netdev->irq = spi->irq;
-
-	return ks8851_probe_common(netdev, dev);
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
diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
new file mode 100644
index 000000000000..8d497cb440ff
--- /dev/null
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -0,0 +1,476 @@
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
+ * @lock: Lock to ensure that the device is not accessed when busy.
+ * @tx_work: Work queue for tx packets
+ * @ks8851: KS8851 driver common private data
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
+/**
+ * ks8851_lock_spi - register access lock
+ * @ks: The chip state
+ * @flags: Spinlock flags
+ *
+ * Claim chip register access lock
+ */
+static void ks8851_lock_spi(struct ks8851_net *ks, unsigned long *flags)
+{
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+
+	mutex_lock(&kss->lock);
+}
+
+/**
+ * ks8851_unlock_spi - register access unlock
+ * @ks: The chip state
+ * @flags: Spinlock flags
+ *
+ * Release chip register access lock
+ */
+static void ks8851_unlock_spi(struct ks8851_net *ks, unsigned long *flags)
+{
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+
+	mutex_unlock(&kss->lock);
+}
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
+ * ks8851_wrfifo_spi - write packet to TX FIFO via SPI
+ * @ks: The device state.
+ * @txp: The sk_buff to transmit.
+ * @irq: IRQ on completion of the packet.
+ *
+ * Send the @txp to the chip. This means creating the relevant packet header
+ * specifying the length of the packet and the other information the chip
+ * needs, such as IRQ on completion. Send the header and the packet data to
+ * the device.
+ */
+static void ks8851_wrfifo_spi(struct ks8851_net *ks, struct sk_buff *txp,
+			      bool irq)
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
+/**
+ * ks8851_rx_skb_spi - receive skbuff
+ * @skb: The skbuff
+ */
+static void ks8851_rx_skb_spi(struct ks8851_net *ks, struct sk_buff *skb)
+{
+	netif_rx_ni(skb);
+}
+
+/**
+ * ks8851_tx_work - process tx packet(s)
+ * @work: The work strucutre what was scheduled.
+ *
+ * This is called when a number of packets have been scheduled for
+ * transmission and need to be sent to the device.
+ */
+static void ks8851_tx_work(struct work_struct *work)
+{
+	struct ks8851_net_spi *kss;
+	struct ks8851_net *ks;
+	unsigned long flags;
+	struct sk_buff *txb;
+	bool last;
+
+	kss = container_of(work, struct ks8851_net_spi, tx_work);
+	ks = &kss->ks8851;
+	last = skb_queue_empty(&ks->txq);
+
+	ks8851_lock_spi(ks, &flags);
+
+	while (!last) {
+		txb = skb_dequeue(&ks->txq);
+		last = skb_queue_empty(&ks->txq);
+
+		if (txb) {
+			ks8851_wrreg16_spi(ks, KS_RXQCR,
+					   ks->rc_rxqcr | RXQCR_SDA);
+			ks8851_wrfifo_spi(ks, txb, last);
+			ks8851_wrreg16_spi(ks, KS_RXQCR, ks->rc_rxqcr);
+			ks8851_wrreg16_spi(ks, KS_TXQCR, TXQCR_METFE);
+
+			ks8851_done_tx(ks, txb);
+		}
+	}
+
+	ks8851_unlock_spi(ks, &flags);
+}
+
+/**
+ * ks8851_flush_tx_work_spi - flush outstanding TX work
+ * @ks: The device state
+ */
+static void ks8851_flush_tx_work_spi(struct ks8851_net *ks)
+{
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+
+	flush_work(&kss->tx_work);
+}
+
+/**
+ * calc_txlen - calculate size of message to send packet
+ * @len: Length of data
+ *
+ * Returns the size of the TXFIFO message needed to send
+ * this packet.
+ */
+static unsigned int calc_txlen(unsigned int len)
+{
+	return ALIGN(len + 4, 4);
+}
+
+/**
+ * ks8851_start_xmit_spi - transmit packet using SPI
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
+static netdev_tx_t ks8851_start_xmit_spi(struct sk_buff *skb,
+					 struct net_device *dev)
+{
+	unsigned int needed = calc_txlen(skb->len);
+	struct ks8851_net *ks = netdev_priv(dev);
+	netdev_tx_t ret = NETDEV_TX_OK;
+	struct ks8851_net_spi *kss;
+
+	kss = to_ks8851_spi(ks);
+
+	netif_dbg(ks, tx_queued, ks->netdev,
+		  "%s: skb %p, %d@%p\n", __func__, skb, skb->len, skb->data);
+
+	spin_lock(&ks->statelock);
+
+	if (needed > ks->tx_space) {
+		netif_stop_queue(dev);
+		ret = NETDEV_TX_BUSY;
+	} else {
+		ks->tx_space -= needed;
+		skb_queue_tail(&ks->txq, skb);
+	}
+
+	spin_unlock(&ks->statelock);
+	schedule_work(&kss->tx_work);
+
+	return ret;
+}
+
+static int ks8851_probe_spi(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct ks8851_net_spi *kss;
+	struct net_device *netdev;
+	struct ks8851_net *ks;
+
+	netdev = devm_alloc_etherdev(dev, sizeof(struct ks8851_net_spi));
+	if (!netdev)
+		return -ENOMEM;
+
+	spi->bits_per_word = 8;
+
+	ks = netdev_priv(netdev);
+
+	ks->lock = ks8851_lock_spi;
+	ks->unlock = ks8851_unlock_spi;
+	ks->rdreg16 = ks8851_rdreg16_spi;
+	ks->wrreg16 = ks8851_wrreg16_spi;
+	ks->rdfifo = ks8851_rdfifo_spi;
+	ks->wrfifo = ks8851_wrfifo_spi;
+	ks->start_xmit = ks8851_start_xmit_spi;
+	ks->rx_skb = ks8851_rx_skb_spi;
+	ks->flush_tx_work = ks8851_flush_tx_work_spi;
+
+#define STD_IRQ (IRQ_LCI |	/* Link Change */	\
+		 IRQ_TXI |	/* TX done */		\
+		 IRQ_RXI |	/* RX done */		\
+		 IRQ_SPIBEI |	/* SPI bus error */	\
+		 IRQ_TXPSI |	/* TX process stop */	\
+		 IRQ_RXPSI)	/* RX process stop */
+	ks->rc_ier = STD_IRQ;
+
+	kss = to_ks8851_spi(ks);
+
+	kss->spidev = spi;
+	mutex_init(&kss->lock);
+	INIT_WORK(&kss->tx_work, ks8851_tx_work);
+
+	/* initialise pre-made spi transfer messages */
+	spi_message_init(&kss->spi_msg1);
+	spi_message_add_tail(&kss->spi_xfer1, &kss->spi_msg1);
+
+	spi_message_init(&kss->spi_msg2);
+	spi_message_add_tail(&kss->spi_xfer2[0], &kss->spi_msg2);
+	spi_message_add_tail(&kss->spi_xfer2[1], &kss->spi_msg2);
+
+	netdev->irq = spi->irq;
+
+	return ks8851_probe_common(netdev, dev);
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


