Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7242333D3B6
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 13:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhCPMTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 08:19:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:42290 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230173AbhCPMSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 08:18:46 -0400
IronPort-SDR: 1ukg8GX2FVGOz3aTLuWB1iyuDEYo8XoIx/L1cHqprISbgLD0u6wBTf/5nKM8jIlsTUq7j5OCtz
 3+VgKTrPdXzw==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="185886828"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="185886828"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 05:18:46 -0700
IronPort-SDR: mK6FkzXmq5OwBR5qHcwFLGjciFE4BCHfYBn0tCsX5oAJv3yr+/A6MpOu5BSzuf1YF/4ekUHDyh
 bcWYmwURdNRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="449703437"
Received: from climb.png.intel.com ([10.221.118.165])
  by orsmga001.jf.intel.com with ESMTP; 16 Mar 2021 05:18:43 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [RESEND v1 net-next 5/5] net: stmmac: use interrupt mode INTM=1 for multi-MSI
Date:   Tue, 16 Mar 2021 20:18:23 +0800
Message-Id: <20210316121823.18659-6-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210316121823.18659-1-weifeng.voon@intel.com>
References: <20210316121823.18659-1-weifeng.voon@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Wong, Vee Khee" <vee.khee.wong@intel.com>

For interrupt mode INTM=0, TX/RX transfer complete will trigger signal
not only on sbd_perch_[tx|rx]_intr_o (Transmit/Receive Per Channel) but
also on the sbd_intr_o (Common).

As for multi-MSI implementation, setting interrupt mode INTM=1 is more
efficient as each TX intr and RX intr (TI/RI) will be handled by TX/RX ISR
without the need of calling the common MAC ISR.

Updated the TX/RX NORMAL interrupts status checking process as the
NIS status bit is not asserted for any RI/TI events for INTM=1.

Signed-off-by: Wong, Vee Khee <vee.khee.wong@intel.com>
Co-developed-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  |  8 +++++++
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  3 +++
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  | 23 +++++++++----------
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  1 +
 include/linux/stmmac.h                        |  1 +
 5 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 62aa0e95beb7..3c33b9a5b291 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -161,6 +161,14 @@ static void dwmac4_dma_init(void __iomem *ioaddr,
 		value |= DMA_SYS_BUS_EAME;
 
 	writel(value, ioaddr + DMA_SYS_BUS_MODE);
+
+	value = readl(ioaddr + DMA_BUS_MODE);
+
+	if (dma_cfg->multi_msi_en) {
+		value &= ~DMA_BUS_MODE_INTM_MASK;
+		value |= (DMA_BUS_MODE_INTM_MODE1 << DMA_BUS_MODE_INTM_SHIFT);
+	}
+	writel(value, ioaddr + DMA_BUS_MODE);
 }
 
 static void _dwmac4_dump_dma_regs(void __iomem *ioaddr, u32 channel,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
index 5c0c53832adb..05481eb13ba6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
@@ -25,6 +25,9 @@
 #define DMA_TBS_CTRL			0x00001050
 
 /* DMA Bus Mode bitmap */
+#define DMA_BUS_MODE_INTM_MASK		GENMASK(17, 16)
+#define DMA_BUS_MODE_INTM_SHIFT		16
+#define DMA_BUS_MODE_INTM_MODE1		0x1
 #define DMA_BUS_MODE_SFT_RESET		BIT(0)
 
 /* DMA SYS Bus Mode bitmap */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index 3fa602dabf49..e63270267578 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -166,20 +166,19 @@ int dwmac4_dma_interrupt(void __iomem *ioaddr,
 		}
 	}
 	/* TX/RX NORMAL interrupts */
-	if (likely(intr_status & DMA_CHAN_STATUS_NIS)) {
+	if (likely(intr_status & DMA_CHAN_STATUS_NIS))
 		x->normal_irq_n++;
-		if (likely(intr_status & DMA_CHAN_STATUS_RI)) {
-			x->rx_normal_irq_n++;
-			ret |= handle_rx;
-		}
-		if (likely(intr_status & (DMA_CHAN_STATUS_TI |
-					  DMA_CHAN_STATUS_TBU))) {
-			x->tx_normal_irq_n++;
-			ret |= handle_tx;
-		}
-		if (unlikely(intr_status & DMA_CHAN_STATUS_ERI))
-			x->rx_early_irq++;
+	if (likely(intr_status & DMA_CHAN_STATUS_RI)) {
+		x->rx_normal_irq_n++;
+		ret |= handle_rx;
+	}
+	if (likely(intr_status & (DMA_CHAN_STATUS_TI |
+		DMA_CHAN_STATUS_TBU))) {
+		x->tx_normal_irq_n++;
+		ret |= handle_tx;
 	}
+	if (unlikely(intr_status & DMA_CHAN_STATUS_ERI))
+		x->rx_early_irq++;
 
 	writel(intr_status & intr_en, ioaddr + DMA_CHAN_STATUS(chan));
 	return ret;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index efc35434b9af..d23722e86721 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5401,6 +5401,7 @@ int stmmac_dvr_probe(struct device *device,
 	priv->plat = plat_dat;
 	priv->ioaddr = res->addr;
 	priv->dev->base_addr = (unsigned long)res->addr;
+	priv->plat->dma_cfg->multi_msi_en = priv->plat->multi_msi_en;
 
 	priv->dev->irq = res->irq;
 	priv->wol_irq = res->wol_irq;
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index cb260a04df80..e35224ce61cc 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -96,6 +96,7 @@ struct stmmac_dma_cfg {
 	int mixed_burst;
 	bool aal;
 	bool eame;
+	bool multi_msi_en;
 };
 
 #define AXI_BLEN	7
-- 
2.17.1

