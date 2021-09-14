Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A0F40BA22
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 23:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbhINVWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 17:22:39 -0400
Received: from mx4.wp.pl ([212.77.101.11]:17268 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234648AbhINVWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 17:22:36 -0400
Received: (wp-smtpd smtp.wp.pl 11120 invoked from network); 14 Sep 2021 23:21:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1631654476; bh=q8mLgiPtxya/Sg5rNVuOO44cl/hVhzExZ2McrLq7SX8=;
          h=From:To:Subject;
          b=wH0KQc+yPpNRAlK5WCoks1wOdIJrlMKiuXL0jWEqQtzc9Kc+0rasKyNNwRfD05CLs
           S5S+AK8+H2yKM82XfqhRJfHtefYInuxq/6sqgWNAu7/eCROs5vVC2LGcBZRUHMnOI4
           tHyZOe2whr6PgunVURYs7GPbtCcBIghs+SyTJtWo=
Received: from 46.204.52.243.nat.umts.dynamic.t-mobile.pl (HELO LAPTOP-OLEK.Free) (olek2@wp.pl@[46.204.52.243])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <john@phrozen.org>; 14 Sep 2021 23:21:16 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     john@phrozen.org, tsbogend@alpha.franken.de, olek2@wp.pl,
        maz@kernel.org, ralf@linux-mips.org, ralph.hempel@lantiq.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        hauke@hauke-m.de, dev@kresin.me, arnd@arndb.de, jgg@ziepe.ca,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/8] MIPS: lantiq: dma: make the burst length configurable by the drivers
Date:   Tue, 14 Sep 2021 23:21:01 +0200
Message-Id: <20210914212105.76186-4-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210914212105.76186-1-olek2@wp.pl>
References: <20210914212105.76186-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 174ec4fde9de90ceed564e8e2d47f074
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [sUNh]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the burst length configurable by the drivers.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 .../include/asm/mach-lantiq/xway/xway_dma.h   |  2 +-
 arch/mips/lantiq/xway/dma.c                   | 38 ++++++++++++++++---
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/mips/include/asm/mach-lantiq/xway/xway_dma.h b/arch/mips/include/asm/mach-lantiq/xway/xway_dma.h
index 8218a1356bd8..31ca9151b539 100644
--- a/arch/mips/include/asm/mach-lantiq/xway/xway_dma.h
+++ b/arch/mips/include/asm/mach-lantiq/xway/xway_dma.h
@@ -45,6 +45,6 @@ extern void ltq_dma_close(struct ltq_dma_channel *ch);
 extern void ltq_dma_alloc_tx(struct ltq_dma_channel *ch);
 extern void ltq_dma_alloc_rx(struct ltq_dma_channel *ch);
 extern void ltq_dma_free(struct ltq_dma_channel *ch);
-extern void ltq_dma_init_port(int p);
+extern void ltq_dma_init_port(int p, int tx_burst, int rx_burst);
 
 #endif
diff --git a/arch/mips/lantiq/xway/dma.c b/arch/mips/lantiq/xway/dma.c
index 53fcc672a294..f8eedeb15f18 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -182,7 +182,7 @@ ltq_dma_free(struct ltq_dma_channel *ch)
 EXPORT_SYMBOL_GPL(ltq_dma_free);
 
 void
-ltq_dma_init_port(int p)
+ltq_dma_init_port(int p, int tx_burst, int rx_burst)
 {
 	ltq_dma_w32(p, LTQ_DMA_PS);
 	switch (p) {
@@ -191,16 +191,44 @@ ltq_dma_init_port(int p)
 		 * Tell the DMA engine to swap the endianness of data frames and
 		 * drop packets if the channel arbitration fails.
 		 */
-		ltq_dma_w32_mask(0, DMA_ETOP_ENDIANNESS | DMA_PDEN,
+		ltq_dma_w32_mask(0, (DMA_ETOP_ENDIANNESS | DMA_PDEN),
 			LTQ_DMA_PCTRL);
 		break;
 
-	case DMA_PORT_DEU:
-		ltq_dma_w32((DMA_PCTRL_2W_BURST << DMA_TX_BURST_SHIFT) |
-			(DMA_PCTRL_2W_BURST << DMA_RX_BURST_SHIFT),
+	default:
+		break;
+	}
+
+	switch (rx_burst) {
+	case 8:
+		ltq_dma_w32_mask(0x0c, (DMA_PCTRL_8W_BURST << DMA_RX_BURST_SHIFT),
 			LTQ_DMA_PCTRL);
 		break;
+	case 4:
+		ltq_dma_w32_mask(0x0c, (DMA_PCTRL_4W_BURST << DMA_RX_BURST_SHIFT),
+			LTQ_DMA_PCTRL);
+		break;
+	case 2:
+		ltq_dma_w32_mask(0x0c, (DMA_PCTRL_2W_BURST << DMA_RX_BURST_SHIFT),
+			LTQ_DMA_PCTRL);
+		break;
+	default:
+		break;
+	}
 
+	switch (tx_burst) {
+	case 8:
+		ltq_dma_w32_mask(0x30, (DMA_PCTRL_8W_BURST << DMA_TX_BURST_SHIFT),
+			LTQ_DMA_PCTRL);
+		break;
+	case 4:
+		ltq_dma_w32_mask(0x30, (DMA_PCTRL_4W_BURST << DMA_TX_BURST_SHIFT),
+			LTQ_DMA_PCTRL);
+		break;
+	case 2:
+		ltq_dma_w32_mask(0x30, (DMA_PCTRL_2W_BURST << DMA_TX_BURST_SHIFT),
+			LTQ_DMA_PCTRL);
+		break;
 	default:
 		break;
 	}
-- 
2.30.2

