Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 778E1196E58
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 18:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgC2QPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 12:15:11 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:42315 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbgC2QPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 12:15:11 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48r0zw1jwKz1qrLN;
        Sun, 29 Mar 2020 18:15:06 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48r0zt61cHz1qqkH;
        Sun, 29 Mar 2020 18:15:06 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 5WGM_M-Xyfrw; Sun, 29 Mar 2020 18:15:05 +0200 (CEST)
X-Auth-Info: f8hqvO5Uf4rtg32KJrn/AR6yrhI2lL4OuFNOC7+w5d0=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 29 Mar 2020 18:15:05 +0200 (CEST)
Subject: Re: [PATCH V3 00/18] net: ks8851: Unify KS8851 SPI and MLL drivers
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200328003148.498021-1-marex@denx.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <189bf325-ee33-6d0f-0947-d1f343030bfb@denx.de>
Date:   Sun, 29 Mar 2020 18:15:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200328003148.498021-1-marex@denx.de>
Content-Type: multipart/mixed;
 boundary="------------1E67BAA512DC698E40B40E65"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------1E67BAA512DC698E40B40E65
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 3/28/20 1:31 AM, Marek Vasut wrote:
> The KS8851SNL/SNLI and KS8851-16MLL/MLLI/MLLU are very much the same pieces
> of silicon, except the former has an SPI interface, while the later has a
> parallel bus interface. Thus far, Linux has two separate drivers for each
> and they are diverging considerably.
> 
> This series unifies them into a single driver with small SPI and parallel
> bus specific parts. The approach here is to first separate out the SPI
> specific parts into a separate file, then add parallel bus accessors in
> another separate file and then finally remove the old parallel bus driver.
> The reason for replacing the old parallel bus driver is because the SPI
> bus driver is much higher quality.
> 
> NOTE: This series depends on "net: ks8851-ml: Fix IO operations, again"
> 
> NOTE: The performance regression on KS8851-16MLL is now fixes, the TX
>       throughput is back to ~75 Mbit/s , RX is still 50 Mbit/s .

I also managed to implement RX NAPI (see attached demo patch if you want
to measure something on the SPI variant), but the RX performance didn't
improve dramatically. It's been 52 Mbit/s, with the RX NAPI it is 56
Mbit/s, on the parallel variant.

[...]

--------------1E67BAA512DC698E40B40E65
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-RX-NAPI.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-RX-NAPI.patch"

From 9ef3977d7b3f73246ff0600022d23faaa32dfb75 Mon Sep 17 00:00:00 2001
From: Marek Vasut <marex@denx.de>
Date: Sun, 29 Mar 2020 18:09:34 +0200
Subject: [PATCH] RX-NAPI

Signed-off-by: Marek Vasut <marex@denx.de>
---
 drivers/net/ethernet/micrel/ks8851.h        |   3 +
 drivers/net/ethernet/micrel/ks8851_common.c | 147 +++++++++++++++-----
 2 files changed, 115 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.h b/drivers/net/ethernet/micrel/ks8851.h
index 649436032405..8f4f6d14e28a 100644
--- a/drivers/net/ethernet/micrel/ks8851.h
+++ b/drivers/net/ethernet/micrel/ks8851.h
@@ -394,6 +394,9 @@ struct ks8851_net {
 	struct regulator	*vdd_reg;
 	struct regulator	*vdd_io;
 	int			gpio;
+	struct napi_struct	napi;
+	bool			acked;
+	u16			rxfc;
 };
 
 int ks8851_probe_common(struct net_device *netdev, struct device *dev);
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index dc038c885de9..d69cb9c3e7fa 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -191,7 +191,7 @@ static void ks8851_dbg_dumpkkt(struct ks8851_net *ks, u8 *rxpkt)
  * are packets in the receive queue. Find out how many packets there are and
  * read them from the FIFO.
  */
-static void ks8851_rx_pkts(struct ks8851_net *ks)
+static int ks8851_rx_pkts(struct ks8851_net *ks, unsigned int maxbudget)
 {
 	struct sk_buff *skb;
 	unsigned rxfc;
@@ -199,10 +199,22 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 	unsigned rxstat;
 	u8 *rxpkt;
 
-	rxfc = (ks8851_rdreg16(ks, KS_RXFCTR) >> 8) & 0xff;
+	int total = 0;
 
-	netif_dbg(ks, rx_status, ks->netdev,
-		  "%s: %d packets\n", __func__, rxfc);
+	if (ks->rxfc) {
+		rxfc = ks->rxfc;
+	} else {
+		rxfc = ks8851_rdreg16(ks, KS_RXFCTR);
+
+//pr_err("%s: RXFC=%04x\n", __func__, rxfc);
+
+		rxfc >>= 8;
+		rxfc &= 0xff;
+
+		ks->rxfc = rxfc;
+	}
+
+//pr_err("%s: ks-RXFC=%04x\n", __func__, rxfc);
 
 	/* Currently we're issuing a read per packet, but we could possibly
 	 * improve the code by issuing a single read, getting the receive
@@ -218,8 +230,13 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 		rxstat = ks8851_rdreg16(ks, KS_RXFHSR);
 		rxlen = ks8851_rdreg16(ks, KS_RXFHBCR) & RXFHBCR_CNT_MASK;
 
-		netif_dbg(ks, rx_status, ks->netdev,
-			  "rx: stat 0x%04x, len 0x%04x\n", rxstat, rxlen);
+//pr_err("rx: stat 0x%04x, len 0x%04x\n", rxstat, rxlen);
+
+		if (!(rxstat & BIT(15))) {
+			pr_err("rx: DISCARD stat 0x%04x, len 0x%04x\n", rxstat, rxlen);
+			ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_RRXEF);
+			continue;
+		}
 
 		/* the length of the packet includes the 32bit CRC */
 
@@ -255,12 +272,81 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 
 				ks->netdev->stats.rx_packets++;
 				ks->netdev->stats.rx_bytes += rxlen;
+
+				total++;
+				ks->rxfc--;
+			} else {
+				pr_err("rx: Cannot alloc SKB\n");
 			}
 		}
 
 		/* end DMA access and dequeue packet */
 		ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_RRXEF);
+
+		if (total == maxbudget)
+			break;
+	}
+
+	return total;
+}
+
+
+
+static int ks8851_napi_poll(struct napi_struct *napi, int budget)
+{
+#if 1
+	struct ks8851_net *ks = container_of(napi, struct ks8851_net, napi);
+	int npackets = 0;
+
+//	spin_unlock_irqrestore(&ks->statelock, flags);
+
+unsigned long flags;
+
+//pr_err("START packets:%i budget:%i\n", npackets, budget);
+u16 isr = BIT(13);
+
+	while (npackets < budget) {
+		int ret = 0;
+ks8851_lock(ks, &flags);
+		if (likely(!ks->acked))
+			isr = ks8851_rdreg16(ks, KS_ISR);
+		else
+			isr = BIT(13);
+
+//pr_err("%s: ISR=%04x (ks->acked=%i) npackets=%i budget=%i\n", __func__, isr, ks->acked == true, npackets, budget);
+		if (isr & BIT(13)) {
+			if (likely(!ks->acked))
+				ks8851_wrreg16(ks, KS_ISR, IRQ_RXI);
+			else
+				ks->acked = false;
+
+			ret = ks8851_rx_pkts(ks, budget - npackets);
+		}
+//pr_err("%s: ret=%i (ks->acked=%i)\n", __func__, ret, ks->acked == true);
+//		ks8851_wrreg16(ks, KS_ISR, IRQ_RXI | IRQ_RXPSI);
+ks8851_unlock(ks, &flags);
+		if (!ret) {
+			/*
+			 * We processed all packets available. Tell NAPI to
+			 * stop polling and re-enable RX interrupts.
+			 */
+			napi_complete(napi);
+			ks->rc_ier = IRQ_LCI | IRQ_RXI | IRQ_RXPSI;
+			ks8851_wrreg16(ks, KS_IER, ks->rc_ier);
+//pr_err("END1 packets:%i budget:%i ret:%i\n\n", npackets, budget, ret);
+			ks->acked = true;
+			ks->rxfc = 0;
+			return npackets;
+		}
+		npackets += ret;
+//pr_err("packets:%i budget:%i ret:%i\n", npackets, budget, ret);
 	}
+#endif
+//pr_err("END2 packets:%i budget:%i left=%i\n\n", npackets, budget, ks->rxfc);
+	if (ks->rxfc)
+		ks->acked = true;
+	/* Return total received packets */
+	return npackets;
 }
 
 /**
@@ -286,8 +372,7 @@ static irqreturn_t ks8851_irq(int irq, void *_ks)
 
 	status = ks8851_rdreg16(ks, KS_ISR);
 
-	netif_dbg(ks, intr, ks->netdev,
-		  "%s: status 0x%04x\n", __func__, status);
+//pr_err("IRQ %s: status 0x%04x\n", __func__, status);
 
 	if (status & IRQ_LCI)
 		handled |= IRQ_LCI;
@@ -303,36 +388,26 @@ static irqreturn_t ks8851_irq(int irq, void *_ks)
 	if (status & IRQ_RXPSI)
 		handled |= IRQ_RXPSI;
 
-	if (status & IRQ_TXI) {
-		handled |= IRQ_TXI;
-
-		/* no lock here, tx queue should have been stopped */
+	bool schednapi = false;
 
-		/* update our idea of how much tx space is available to the
-		 * system */
-		ks->tx_space = ks8851_rdreg16(ks, KS_TXMIR);
-
-		netif_dbg(ks, intr, ks->netdev,
-			  "%s: txspace %d\n", __func__, ks->tx_space);
-	}
-
-	if (status & IRQ_RXI)
+	if (status & IRQ_RXI) {
 		handled |= IRQ_RXI;
-
-	if (status & IRQ_SPIBEI) {
-		netdev_err(ks->netdev, "%s: spi bus error\n", __func__);
-		handled |= IRQ_SPIBEI;
+		if (likely(napi_schedule_prep(&ks->napi))) {
+			/* Disable Rx interrupts */
+			ks->rc_ier = IRQ_LCI;
+			ks8851_wrreg16(ks, KS_IER, ks->rc_ier);
+			schednapi = true;
+		} else {
+			pr_err("napi_schedule_prep failed");
+		}
 	}
 
 	ks8851_wrreg16(ks, KS_ISR, handled);
 
-	if (status & IRQ_RXI) {
-		/* the datasheet says to disable the rx interrupt during
-		 * packet read-out, however we're masking the interrupt
-		 * from the device so do not bother masking just the RX
-		 * from the device. */
-
-		ks8851_rx_pkts(ks);
+	/* Schedule a NAPI poll */
+	if (schednapi) {
+		ks->acked = true;
+		__napi_schedule(&ks->napi);
 	}
 
 	/* if something stopped the rx process, probably due to wanting
@@ -356,9 +431,6 @@ static irqreturn_t ks8851_irq(int irq, void *_ks)
 	if (status & IRQ_LCI)
 		mii_check_link(&ks->mii);
 
-	if (status & IRQ_TXI)
-		netif_wake_queue(ks->netdev);
-
 	return IRQ_HANDLED;
 }
 
@@ -428,6 +500,8 @@ static int ks8851_net_open(struct net_device *dev)
 
 	ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr);
 
+	napi_enable(&ks->napi);
+
 	/* clear then enable interrupts */
 	ks8851_wrreg16(ks, KS_ISR, ks->rc_ier);
 	ks8851_wrreg16(ks, KS_IER, ks->rc_ier);
@@ -462,6 +536,7 @@ static int ks8851_net_stop(struct net_device *dev)
 	/* turn off the IRQs and ack any outstanding */
 	ks8851_wrreg16(ks, KS_IER, 0x0000);
 	ks8851_wrreg16(ks, KS_ISR, 0xffff);
+	napi_disable(&ks->napi);
 	ks8851_unlock(ks, &flags);
 
 	/* stop any outstanding work */
@@ -1011,6 +1086,8 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev)
 
 	spin_lock_init(&ks->statelock);
 
+	netif_napi_add(netdev, &ks->napi, ks8851_napi_poll, 16);
+
 	INIT_WORK(&ks->rxctrl_work, ks8851_rxctrl_work);
 
 	/* setup EEPROM state */
-- 
2.25.1


--------------1E67BAA512DC698E40B40E65--
