Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07E21D64F4
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 02:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgEQAez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 20:34:55 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:50861 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbgEQAew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 20:34:52 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49PjpC1SH4z1rryf;
        Sun, 17 May 2020 02:34:43 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49PjpC1DFKz1shfq;
        Sun, 17 May 2020 02:34:43 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 6IO6tQzx1zb5; Sun, 17 May 2020 02:34:42 +0200 (CEST)
X-Auth-Info: A9RR21z+A78JrceYjbjX1g3QQ6fzoJI3VshlnUgawy8=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 17 May 2020 02:34:42 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V6 15/20] net: ks8851: Permit overridding interrupt enable register
Date:   Sun, 17 May 2020 02:33:49 +0200
Message-Id: <20200517003354.233373-16-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200517003354.233373-1-marex@denx.de>
References: <20200517003354.233373-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parallel bus variant does not need to use the TX interrupt at all
as it writes the TX FIFO directly with in .ndo_start_xmit, permit the
drivers to configure the interrupt enable bits.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V3: New patch
V4: No change
V5: No change
V6: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 458c86903ac0..baf424f9893b 100644
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
 
@@ -1599,6 +1590,15 @@ static int ks8851_probe(struct spi_device *spi)
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

