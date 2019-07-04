Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBDA65FA8E
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 17:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfGDPE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 11:04:27 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:47120 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727314AbfGDPE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 11:04:27 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C2764C2975;
        Thu,  4 Jul 2019 15:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1562252666; bh=8/IDjB2DIXJSOAN7JOjH5TAznklTry/7Vqz9VmBB80k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=JGQUssCnWUgLGamKaR5b6TpPfUAMOrh4SPTzzVbBRXOa5NBANCUzdP7MvIMJ1kk11
         zd6MIG7smvbr3834tZ8hOU6aa8ivPMbeqPXD3ECZpVdSHVg43RpYBd77Pk+Efl29qS
         Pm5ETt5wpRNDAoBexZ7JgLukygw0CnwK0FGC2hN3I4i+PCygc87rJgR2AzRx3m3UpM
         jgExI+EN5xs91VlPfdZbDR7q/0Qzk4nFtgKxmrAyWFJHO+Blc30hxIAhFjAIKiDWIx
         OGZcQYVsQmHONsTJGWYJ0bdrLX3WhgWzrqN+ZkfptxCUunSVU53UBO0KesYZyE0Mou
         ZrIZ1ooj+cZYw==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 903D6A0065;
        Thu,  4 Jul 2019 15:04:23 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 52F123FC63;
        Thu,  4 Jul 2019 17:04:23 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH net-next v2 2/3] net: stmmac: Fix descriptors address being in > 32 bits address space
Date:   Thu,  4 Jul 2019 17:04:13 +0200
Message-Id: <15a55f0542be506412bbe1ac75cc633ebe44d6f0.1562252534.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1562252534.git.joabreu@synopsys.com>
References: <cover.1562252534.git.joabreu@synopsys.com>
In-Reply-To: <cover.1562252534.git.joabreu@synopsys.com>
References: <cover.1562252534.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a993db88d17d ("net: stmmac: Enable support for > 32 Bits
addressing in XGMAC"), introduced support for > 32 bits addressing in
XGMAC but the conversion of descriptors to dma_addr_t was left out.

As some devices assing coherent memory in regions > 32 bits we need to
set lower and upper value of descriptors address when initializing DMA
channels.

Luckly, this was working for me because I was assigning CMA to < 4GB
address space for performance reasons.

Fixes: a993db88d17d ("net: stmmac: Enable support for > 32 Bits addressing in XGMAC")
Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Chen-Yu Tsai <wens@csie.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c   |  8 ++++----
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c |  8 ++++----
 drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c  |  8 ++++----
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c    |  8 ++++----
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h      |  2 ++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c  | 10 ++++++----
 drivers/net/ethernet/stmicro/stmmac/hwif.h          |  4 ++--
 7 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 6d5cba4075eb..2856f3fe5266 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -289,18 +289,18 @@ static void sun8i_dwmac_dma_init(void __iomem *ioaddr,
 
 static void sun8i_dwmac_dma_init_rx(void __iomem *ioaddr,
 				    struct stmmac_dma_cfg *dma_cfg,
-				    u32 dma_rx_phy, u32 chan)
+				    dma_addr_t dma_rx_phy, u32 chan)
 {
 	/* Write RX descriptors address */
-	writel(dma_rx_phy, ioaddr + EMAC_RX_DESC_LIST);
+	writel(lower_32_bits(dma_rx_phy), ioaddr + EMAC_RX_DESC_LIST);
 }
 
 static void sun8i_dwmac_dma_init_tx(void __iomem *ioaddr,
 				    struct stmmac_dma_cfg *dma_cfg,
-				    u32 dma_tx_phy, u32 chan)
+				    dma_addr_t dma_tx_phy, u32 chan)
 {
 	/* Write TX descriptors address */
-	writel(dma_tx_phy, ioaddr + EMAC_TX_DESC_LIST);
+	writel(lower_32_bits(dma_tx_phy), ioaddr + EMAC_TX_DESC_LIST);
 }
 
 /* sun8i_dwmac_dump_regs() - Dump EMAC address space
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
index 1fdedf77678f..2bac49b49f73 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
@@ -112,18 +112,18 @@ static void dwmac1000_dma_init(void __iomem *ioaddr,
 
 static void dwmac1000_dma_init_rx(void __iomem *ioaddr,
 				  struct stmmac_dma_cfg *dma_cfg,
-				  u32 dma_rx_phy, u32 chan)
+				  dma_addr_t dma_rx_phy, u32 chan)
 {
 	/* RX descriptor base address list must be written into DMA CSR3 */
-	writel(dma_rx_phy, ioaddr + DMA_RCV_BASE_ADDR);
+	writel(lower_32_bits(dma_rx_phy), ioaddr + DMA_RCV_BASE_ADDR);
 }
 
 static void dwmac1000_dma_init_tx(void __iomem *ioaddr,
 				  struct stmmac_dma_cfg *dma_cfg,
-				  u32 dma_tx_phy, u32 chan)
+				  dma_addr_t dma_tx_phy, u32 chan)
 {
 	/* TX descriptor base address list must be written into DMA CSR4 */
-	writel(dma_tx_phy, ioaddr + DMA_TX_BASE_ADDR);
+	writel(lower_32_bits(dma_tx_phy), ioaddr + DMA_TX_BASE_ADDR);
 }
 
 static u32 dwmac1000_configure_fc(u32 csr6, int rxfifosz)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
index c980cc7360a4..8f0d9bc7cab5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
@@ -31,18 +31,18 @@ static void dwmac100_dma_init(void __iomem *ioaddr,
 
 static void dwmac100_dma_init_rx(void __iomem *ioaddr,
 				 struct stmmac_dma_cfg *dma_cfg,
-				 u32 dma_rx_phy, u32 chan)
+				 dma_addr_t dma_rx_phy, u32 chan)
 {
 	/* RX descriptor base addr lists must be written into DMA CSR3 */
-	writel(dma_rx_phy, ioaddr + DMA_RCV_BASE_ADDR);
+	writel(lower_32_bits(dma_rx_phy), ioaddr + DMA_RCV_BASE_ADDR);
 }
 
 static void dwmac100_dma_init_tx(void __iomem *ioaddr,
 				 struct stmmac_dma_cfg *dma_cfg,
-				 u32 dma_tx_phy, u32 chan)
+				 dma_addr_t dma_tx_phy, u32 chan)
 {
 	/* TX descriptor base addr lists must be written into DMA CSR4 */
-	writel(dma_tx_phy, ioaddr + DMA_TX_BASE_ADDR);
+	writel(lower_32_bits(dma_tx_phy), ioaddr + DMA_TX_BASE_ADDR);
 }
 
 /* Store and Forward capability is not used at all.
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 0f208e13da9f..6cbcdaea55f6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -70,7 +70,7 @@ static void dwmac4_dma_axi(void __iomem *ioaddr, struct stmmac_axi *axi)
 
 static void dwmac4_dma_init_rx_chan(void __iomem *ioaddr,
 				    struct stmmac_dma_cfg *dma_cfg,
-				    u32 dma_rx_phy, u32 chan)
+				    dma_addr_t dma_rx_phy, u32 chan)
 {
 	u32 value;
 	u32 rxpbl = dma_cfg->rxpbl ?: dma_cfg->pbl;
@@ -79,12 +79,12 @@ static void dwmac4_dma_init_rx_chan(void __iomem *ioaddr,
 	value = value | (rxpbl << DMA_BUS_MODE_RPBL_SHIFT);
 	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
 
-	writel(dma_rx_phy, ioaddr + DMA_CHAN_RX_BASE_ADDR(chan));
+	writel(lower_32_bits(dma_rx_phy), ioaddr + DMA_CHAN_RX_BASE_ADDR(chan));
 }
 
 static void dwmac4_dma_init_tx_chan(void __iomem *ioaddr,
 				    struct stmmac_dma_cfg *dma_cfg,
-				    u32 dma_tx_phy, u32 chan)
+				    dma_addr_t dma_tx_phy, u32 chan)
 {
 	u32 value;
 	u32 txpbl = dma_cfg->txpbl ?: dma_cfg->pbl;
@@ -97,7 +97,7 @@ static void dwmac4_dma_init_tx_chan(void __iomem *ioaddr,
 
 	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
 
-	writel(dma_tx_phy, ioaddr + DMA_CHAN_TX_BASE_ADDR(chan));
+	writel(lower_32_bits(dma_tx_phy), ioaddr + DMA_CHAN_TX_BASE_ADDR(chan));
 }
 
 static void dwmac4_dma_init_channel(void __iomem *ioaddr,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 9a9792527530..7f86dffb264d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -199,7 +199,9 @@
 #define XGMAC_RxPBL			GENMASK(21, 16)
 #define XGMAC_RxPBL_SHIFT		16
 #define XGMAC_RXST			BIT(0)
+#define XGMAC_DMA_CH_TxDESC_HADDR(x)	(0x00003110 + (0x80 * (x)))
 #define XGMAC_DMA_CH_TxDESC_LADDR(x)	(0x00003114 + (0x80 * (x)))
+#define XGMAC_DMA_CH_RxDESC_HADDR(x)	(0x00003118 + (0x80 * (x)))
 #define XGMAC_DMA_CH_RxDESC_LADDR(x)	(0x0000311c + (0x80 * (x)))
 #define XGMAC_DMA_CH_TxDESC_TAIL_LPTR(x)	(0x00003124 + (0x80 * (x)))
 #define XGMAC_DMA_CH_RxDESC_TAIL_LPTR(x)	(0x0000312c + (0x80 * (x)))
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 229c58758cbd..a4f236e3593e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -44,7 +44,7 @@ static void dwxgmac2_dma_init_chan(void __iomem *ioaddr,
 
 static void dwxgmac2_dma_init_rx_chan(void __iomem *ioaddr,
 				      struct stmmac_dma_cfg *dma_cfg,
-				      u32 dma_rx_phy, u32 chan)
+				      dma_addr_t phy, u32 chan)
 {
 	u32 rxpbl = dma_cfg->rxpbl ?: dma_cfg->pbl;
 	u32 value;
@@ -54,12 +54,13 @@ static void dwxgmac2_dma_init_rx_chan(void __iomem *ioaddr,
 	value |= (rxpbl << XGMAC_RxPBL_SHIFT) & XGMAC_RxPBL;
 	writel(value, ioaddr + XGMAC_DMA_CH_RX_CONTROL(chan));
 
-	writel(dma_rx_phy, ioaddr + XGMAC_DMA_CH_RxDESC_LADDR(chan));
+	writel(upper_32_bits(phy), ioaddr + XGMAC_DMA_CH_RxDESC_HADDR(chan));
+	writel(lower_32_bits(phy), ioaddr + XGMAC_DMA_CH_RxDESC_LADDR(chan));
 }
 
 static void dwxgmac2_dma_init_tx_chan(void __iomem *ioaddr,
 				      struct stmmac_dma_cfg *dma_cfg,
-				      u32 dma_tx_phy, u32 chan)
+				      dma_addr_t phy, u32 chan)
 {
 	u32 txpbl = dma_cfg->txpbl ?: dma_cfg->pbl;
 	u32 value;
@@ -70,7 +71,8 @@ static void dwxgmac2_dma_init_tx_chan(void __iomem *ioaddr,
 	value |= XGMAC_OSP;
 	writel(value, ioaddr + XGMAC_DMA_CH_TX_CONTROL(chan));
 
-	writel(dma_tx_phy, ioaddr + XGMAC_DMA_CH_TxDESC_LADDR(chan));
+	writel(upper_32_bits(phy), ioaddr + XGMAC_DMA_CH_TxDESC_HADDR(chan));
+	writel(lower_32_bits(phy), ioaddr + XGMAC_DMA_CH_TxDESC_LADDR(chan));
 }
 
 static void dwxgmac2_dma_axi(void __iomem *ioaddr, struct stmmac_axi *axi)
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 2acfbc70e3c8..278c0dbec9d9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -150,10 +150,10 @@ struct stmmac_dma_ops {
 			  struct stmmac_dma_cfg *dma_cfg, u32 chan);
 	void (*init_rx_chan)(void __iomem *ioaddr,
 			     struct stmmac_dma_cfg *dma_cfg,
-			     u32 dma_rx_phy, u32 chan);
+			     dma_addr_t phy, u32 chan);
 	void (*init_tx_chan)(void __iomem *ioaddr,
 			     struct stmmac_dma_cfg *dma_cfg,
-			     u32 dma_tx_phy, u32 chan);
+			     dma_addr_t phy, u32 chan);
 	/* Configure the AXI Bus Mode Register */
 	void (*axi)(void __iomem *ioaddr, struct stmmac_axi *axi);
 	/* Dump DMA registers */
-- 
2.7.4

