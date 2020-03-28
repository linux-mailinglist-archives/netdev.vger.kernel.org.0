Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087C5196281
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 01:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgC1Ac3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 20:32:29 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:57862 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbgC1AcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 20:32:24 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48q06b0p5Mz1rpG2;
        Sat, 28 Mar 2020 01:32:23 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48q06b0Hx2z1qv4J;
        Sat, 28 Mar 2020 01:32:23 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id fqcA9my6iy9P; Sat, 28 Mar 2020 01:32:22 +0100 (CET)
X-Auth-Info: kS1OQOGF653deQ4PguXdzgRpN64lrIZuqc7bXQoC7xw=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 28 Mar 2020 01:32:21 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V3 15/18] net: ks8851: Permit overridding interrupt enable register
Date:   Sat, 28 Mar 2020 01:31:45 +0100
Message-Id: <20200328003148.498021-16-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200328003148.498021-1-marex@denx.de>
References: <20200328003148.498021-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parallel bus variant does not need to use the TX interrupt at all
as it writes the TX FIFO directly with in .ndo_start_xmit, permit the
drivers to configure the interrupt enable bits.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V3: New patch
---
 drivers/net/ethernet/micrel/ks8851.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 0b60acceeae9..d29b52ffbb49 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -859,17 +859,8 @@ static int ks8851_net_open(struct net_device *dev)
 	ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr);
 
 	/* clear then enable interrupts */
-
-#define STD_IRQ (IRQ_LCI |	/* Link Change */	\
-		 IRQ_TXI |	/* TX done */		\
-		 IRQ_RXI |	/* RX done */		\
-		 IRQ_SPIBEI |	/* SPI bus error */	\
-		 IRQ_TXPSI |	/* TX process stop */	\
-		 IRQ_RXPSI)	/* RX process stop */
-
-	ks->rc_ier = STD_IRQ;
-	ks8851_wrreg16(ks, KS_ISR, STD_IRQ);
-	ks8851_wrreg16(ks, KS_IER, STD_IRQ);
+	ks8851_wrreg16(ks, KS_ISR, ks->rc_ier);
+	ks8851_wrreg16(ks, KS_IER, ks->rc_ier);
 
 	netif_start_queue(ks->netdev);
 
@@ -1598,6 +1589,15 @@ static int ks8851_probe(struct spi_device *spi)
 	spi->bits_per_word = 8;
 
 	ks = netdev_priv(netdev);
+
+#define STD_IRQ (IRQ_LCI |	/* Link Change */	\
+		 IRQ_TXI |	/* TX done */		\
+		 IRQ_RXI |	/* RX done */		\
+		 IRQ_SPIBEI |	/* SPI bus error */	\
+		 IRQ_TXPSI |	/* TX process stop */	\
+		 IRQ_RXPSI)	/* RX process stop */
+	ks->rc_ier = STD_IRQ;
+
 	kss = to_ks8851_spi(ks);
 
 	kss->spidev = spi;
-- 
2.25.1

