Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45167190218
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 00:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgCWXnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 19:43:40 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:36419 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbgCWXni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 19:43:38 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48mWD76Nkbz1qsbB;
        Tue, 24 Mar 2020 00:43:35 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48mWD76BCCz1qyDk;
        Tue, 24 Mar 2020 00:43:35 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id IblCCuhCcaps; Tue, 24 Mar 2020 00:43:34 +0100 (CET)
X-Auth-Info: rggxz76Xvd3YzOnZIf9EXwOG1u7ncPiu3Hd9y5z4reg=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 24 Mar 2020 00:43:34 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH 11/14] net: ks8851: Implement register and FIFO accessor callbacks
Date:   Tue, 24 Mar 2020 00:43:00 +0100
Message-Id: <20200323234303.526748-12-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323234303.526748-1-marex@denx.de>
References: <20200323234303.526748-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The register and FIFO accessors are bus specific. Implement callbacks so
that each variant of the KS8851 can implement matching accessors and use
the rest of the common code.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/micrel/ks8851.c | 65 +++++++++++++++++++++++-----
 1 file changed, 55 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 608c8fe4b5e8..d5bdbd9122bf 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -129,6 +129,15 @@ struct ks8851_net {
 	struct regulator	*vdd_reg;
 	struct regulator	*vdd_io;
 	int			gpio;
+
+	unsigned int		(*rdreg16)(struct ks8851_net *ks,
+					   unsigned int reg);
+	void			(*wrreg16)(struct ks8851_net *ks,
+					   unsigned int reg, unsigned int val);
+	void			(*rdfifo)(struct ks8851_net *ks, u8 *buff,
+					  unsigned int len);
+	void			(*wrfifo)(struct ks8851_net *ks,
+					  struct sk_buff *txp, bool irq);
 };
 
 /**
@@ -171,14 +180,15 @@ static int msg_enable;
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
@@ -198,6 +208,20 @@ static void ks8851_wrreg16(struct ks8851_net *ks, unsigned reg, unsigned val)
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
@@ -251,13 +275,14 @@ static void ks8851_rdreg(struct ks8851_net *ks, unsigned op,
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
 
@@ -265,6 +290,19 @@ static unsigned ks8851_rdreg16(struct ks8851_net *ks, unsigned reg)
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
@@ -402,7 +440,7 @@ static void ks8851_init_mac(struct ks8851_net *ks, struct device *ddev)
 }
 
 /**
- * ks8851_rdfifo - read data from the receive fifo
+ * ks8851_rdfifo_spi - read data from the receive fifo via SPI
  * @ks: The device state.
  * @buff: The buffer address
  * @len: The length of the data to read
@@ -410,7 +448,8 @@ static void ks8851_init_mac(struct ks8851_net *ks, struct device *ddev)
  * Issue an RXQ FIFO read command and read the @len amount of data from
  * the FIFO into the buffer specified by @buff.
  */
-static void ks8851_rdfifo(struct ks8851_net *ks, u8 *buff, unsigned len)
+static void ks8851_rdfifo_spi(struct ks8851_net *ks, u8 *buff,
+			      unsigned int len)
 {
 	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 	struct spi_transfer *xfer = kss->spi_xfer2;
@@ -516,7 +555,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 
 				rxpkt = skb_put(skb, rxlen) - 8;
 
-				ks8851_rdfifo(ks, rxpkt, rxalign + 8);
+				ks->rdfifo(ks, rxpkt, rxalign + 8);
 
 				if (netif_msg_pktdata(ks))
 					ks8851_dbg_dumpkkt(ks, rxpkt);
@@ -645,7 +684,7 @@ static inline unsigned calc_txlen(unsigned len)
 }
 
 /**
- * ks8851_wrpkt - write packet to TX FIFO
+ * ks8851_wrpkt_spi - write packet to TX FIFO via SPI
  * @ks: The device state.
  * @txp: The sk_buff to transmit.
  * @irq: IRQ on completion of the packet.
@@ -655,7 +694,8 @@ static inline unsigned calc_txlen(unsigned len)
  * needs, such as IRQ on completion. Send the header and the packet data to
  * the device.
  */
-static void ks8851_wrpkt(struct ks8851_net *ks, struct sk_buff *txp, bool irq)
+static void ks8851_wrpkt_spi(struct ks8851_net *ks, struct sk_buff *txp,
+			     bool irq)
 {
 	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 	struct spi_transfer *xfer = kss->spi_xfer2;
@@ -727,7 +767,7 @@ static void ks8851_tx_work(struct work_struct *work)
 
 		if (txb != NULL) {
 			ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_SDA);
-			ks8851_wrpkt(ks, txb, last);
+			ks->wrfifo(ks, txb, last);
 			ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr);
 			ks8851_wrreg16(ks, KS_TXQCR, TXQCR_METFE);
 
@@ -1535,6 +1575,11 @@ static int ks8851_probe(struct spi_device *spi)
 	spi->bits_per_word = 8;
 
 	ks = netdev_priv(ndev);
+	ks->rdreg16 = ks8851_rdreg16_spi;
+	ks->wrreg16 = ks8851_wrreg16_spi;
+	ks->rdfifo = ks8851_rdfifo_spi;
+	ks->wrfifo = ks8851_wrpkt_spi;
+
 	kss = to_ks8851_spi(ks);
 
 	kss->spidev = spi;
-- 
2.25.1

