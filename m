Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DC11B0DE7
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgDTOHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:07:05 -0400
Received: from bmailout2.hostsharing.net ([83.223.78.240]:43825 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728156AbgDTOHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:07:04 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id A7F1A2800B483;
        Mon, 20 Apr 2020 16:07:00 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 706861D2EAD; Mon, 20 Apr 2020 16:07:00 +0200 (CEST)
Date:   Mon, 20 Apr 2020 16:07:00 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V4 07/19] net: ks8851: Remove ks8851_rdreg32()
Message-ID: <20200420140700.6632hztejwcgjwsf@wunner.de>
References: <20200414182029.183594-1-marex@denx.de>
 <20200414182029.183594-8-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414182029.183594-8-marex@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 08:20:17PM +0200, Marek Vasut wrote:
> The ks8851_rdreg32() is used only in one place, to read two registers
> using a single read. To make it easier to support 16-bit accesses via
> parallel bus later on, replace this single read with two 16-bit reads
> from each of the registers and drop the ks8851_rdreg32() altogether.
> 
> If this has noticeable performance impact on the SPI variant of KS8851,
> then we should consider using regmap to abstract the SPI and parallel
> bus options and in case of SPI, permit regmap to merge register reads
> of neighboring registers into single, longer, read.

Bisection has shown this patch to be the biggest cause of the performance
regression introduced by this series:  Latency increases by about 9 usec.

Removal of the 8-bit register access in patch [9/19] further increases
latency by about 2 usec.

In other words, performing two 16-bit SPI transfers to read a 32-bit
register has a more significant impact than reading an 8-bit register
as 16-bits.  Nevertheless both should be performed with their native
size if the driver is used in SPI mode.

Therefore please fold the patch below into the next version of your
series.  The ks8851_mll portion is compile-tested only.

Thanks,

Lukas

-- >8 --

From: Lukas Wunner <lukas@wunner.de>
Subject: [PATCH] net: ks8851: Reinstate 8-bit and 32-bit register access

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/ethernet/micrel/ks8851.h        |  4 +++
 drivers/net/ethernet/micrel/ks8851_common.c | 34 +++++++++++++++++--
 drivers/net/ethernet/micrel/ks8851_par.c    | 31 ++++++++++++++++++
 drivers/net/ethernet/micrel/ks8851_spi.c    | 36 +++++++++++++++++++++
 4 files changed, 102 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.h b/drivers/net/ethernet/micrel/ks8851.h
index e218e8b7d364..757c49dbf0be 100644
--- a/drivers/net/ethernet/micrel/ks8851.h
+++ b/drivers/net/ethernet/micrel/ks8851.h
@@ -399,10 +399,14 @@ struct ks8851_net {
 					unsigned long *flags);
 	void			(*unlock)(struct ks8851_net *ks,
 					  unsigned long *flags);
+	unsigned int		(*rdreg8)(struct ks8851_net *ks,
+					  unsigned int reg);
 	unsigned int		(*rdreg16)(struct ks8851_net *ks,
 					   unsigned int reg);
 	void			(*wrreg16)(struct ks8851_net *ks,
 					   unsigned int reg, unsigned int val);
+	unsigned int		(*rdreg32)(struct ks8851_net *ks,
+					   unsigned int reg);
 	void			(*rdfifo)(struct ks8851_net *ks, u8 *buff,
 					  unsigned int len);
 	void			(*wrfifo)(struct ks8851_net *ks,
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 27a351ad691b..a2bc85ae241f 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -53,6 +53,19 @@ static void ks8851_unlock(struct ks8851_net *ks, unsigned long *flags)
 	ks->unlock(ks, flags);
 }
 
+/**
+ * ks8851_rdreg8 - read 8 bit register from device
+ * @ks: The chip information
+ * @reg: The register address
+ *
+ * Read a 8bit register from the chip, returning the result
+ */
+static unsigned int ks8851_rdreg8(struct ks8851_net *ks,
+				  unsigned int reg)
+{
+	return ks->rdreg8(ks, reg);
+}
+
 /**
  * ks8851_wrreg16 - write 16bit register value to chip
  * @ks: The chip state
@@ -80,6 +93,19 @@ static unsigned int ks8851_rdreg16(struct ks8851_net *ks,
 	return ks->rdreg16(ks, reg);
 }
 
+/**
+ * ks8851_rdreg32 - read 32 bit register from device
+ * @ks: The chip information
+ * @reg: The register address
+ *
+ * Read a 32bit register from the chip, returning the result
+ */
+static unsigned int ks8851_rdreg32(struct ks8851_net *ks,
+				   unsigned int reg)
+{
+	return ks->rdreg32(ks, reg);
+}
+
 /**
  * ks8851_soft_reset - issue one of the soft reset to the device
  * @ks: The device state.
@@ -257,9 +283,10 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 	unsigned rxfc;
 	unsigned rxlen;
 	unsigned rxstat;
+	u32 rxh;
 	u8 *rxpkt;
 
-	rxfc = (ks8851_rdreg16(ks, KS_RXFCTR) >> 8) & 0xff;
+	rxfc = ks8851_rdreg8(ks, KS_RXFC);
 
 	netif_dbg(ks, rx_status, ks->netdev,
 		  "%s: %d packets\n", __func__, rxfc);
@@ -275,8 +302,9 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 	 */
 
 	for (; rxfc != 0; rxfc--) {
-		rxstat = ks8851_rdreg16(ks, KS_RXFHSR);
-		rxlen = ks8851_rdreg16(ks, KS_RXFHBCR) & RXFHBCR_CNT_MASK;
+		rxh = ks8851_rdreg32(ks, KS_RXFHSR);
+		rxstat = rxh & 0xffff;
+		rxlen = (rxh >> 16) & 0xfff;
 
 		netif_dbg(ks, rx_status, ks->netdev,
 			  "rx: stat 0x%04x, len 0x%04x\n", rxstat, rxlen);
diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
index a470e40b3817..3a5d42ecdba7 100644
--- a/drivers/net/ethernet/micrel/ks8851_par.c
+++ b/drivers/net/ethernet/micrel/ks8851_par.c
@@ -162,6 +162,35 @@ static unsigned int ks8851_rdreg16_par(struct ks8851_net *ks, unsigned int reg)
 	return ioread16(ksp->hw_addr);
 }
 
+/**
+ * ks8851_rdreg8_par - read 8 bit register from chip
+ * @ks: The chip information
+ * @reg: The register address
+ *
+ * Read a 8bit register from the chip, returning the result
+ */
+static unsigned int ks8851_rdreg8_par(struct ks8851_net *ks, unsigned int reg)
+{
+	return le16_to_cpu(ks8851_rdreg16_par(ks, reg)) & 0xff;
+}
+
+/**
+ * ks8851_rdreg32_par - read 32 bit register from chip
+ * @ks: The chip information
+ * @reg: The register address
+ *
+ * Read a 32bit register from the chip, returning the result
+ */
+static unsigned int ks8851_rdreg32_par(struct ks8851_net *ks, unsigned int reg)
+{
+	u16 rx[2];
+
+	rx[0] = ks8851_rdreg16_par(ks, reg);
+	rx[1] = ks8851_rdreg16_par(ks, reg + 2);
+
+	return le32_to_cpup((u32 *)rx);
+}
+
 /**
  * ks8851_rdfifo_par - read data from the receive fifo
  * @ks: The device state.
@@ -284,8 +313,10 @@ static int ks8851_probe_par(struct platform_device *pdev)
 
 	ks->lock = ks8851_lock_par;
 	ks->unlock = ks8851_unlock_par;
+	ks->rdreg8 = ks8851_rdreg8_par;
 	ks->rdreg16 = ks8851_rdreg16_par;
 	ks->wrreg16 = ks8851_wrreg16_par;
+	ks->rdreg32 = ks8851_rdreg32_par;
 	ks->rdfifo = ks8851_rdfifo_par;
 	ks->wrfifo = ks8851_wrfifo_par;
 	ks->start_xmit = ks8851_start_xmit_par;
diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
index 8d497cb440ff..0b909c27075e 100644
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -184,6 +184,21 @@ static void ks8851_rdreg(struct ks8851_net *ks, unsigned int op,
 		memcpy(rxb, trx + 2, rxl);
 }
 
+/**
+ * ks8851_rdreg8_spi - read 8 bit register from device
+ * @ks: The chip information
+ * @reg: The register address
+ *
+ * Read a 8bit register from the chip, returning the result
+*/
+static unsigned int ks8851_rdreg8_spi(struct ks8851_net *ks, unsigned reg)
+{
+	u8 rxb[1];
+
+	ks8851_rdreg(ks, MK_OP(1 << (reg & 3), reg), rxb, 1);
+	return rxb[0];
+}
+
 /**
  * ks8851_rdreg16_spi - read 16 bit register from device via SPI
  * @ks: The chip information
@@ -199,6 +214,25 @@ static unsigned int ks8851_rdreg16_spi(struct ks8851_net *ks, unsigned int reg)
 	return le16_to_cpu(rx);
 }
 
+/**
+ * ks8851_rdreg32_spi - read 32 bit register from device
+ * @ks: The chip information
+ * @reg: The register address
+ *
+ * Read a 32bit register from the chip.
+ *
+ * Note, this read requires the address be aligned to 4 bytes.
+*/
+static unsigned ks8851_rdreg32_spi(struct ks8851_net *ks, unsigned reg)
+{
+	__le32 rx = 0;
+
+	WARN_ON(reg & 3);
+
+	ks8851_rdreg(ks, MK_OP(0xf, reg), (u8 *)&rx, 4);
+	return le32_to_cpu(rx);
+}
+
 /**
  * ks8851_rdfifo_spi - read data from the receive fifo via SPI
  * @ks: The device state.
@@ -414,8 +448,10 @@ static int ks8851_probe_spi(struct spi_device *spi)
 
 	ks->lock = ks8851_lock_spi;
 	ks->unlock = ks8851_unlock_spi;
+	ks->rdreg8 = ks8851_rdreg8_spi;
 	ks->rdreg16 = ks8851_rdreg16_spi;
 	ks->wrreg16 = ks8851_wrreg16_spi;
+	ks->rdreg32 = ks8851_rdreg32_spi;
 	ks->rdfifo = ks8851_rdfifo_spi;
 	ks->wrfifo = ks8851_wrfifo_spi;
 	ks->start_xmit = ks8851_start_xmit_spi;
-- 
2.26.1

