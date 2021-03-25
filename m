Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9778349866
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhCYRjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:39:45 -0400
Received: from mga03.intel.com ([134.134.136.65]:27389 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhCYRjZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 13:39:25 -0400
IronPort-SDR: AhwlR6U6H48Pg1XqH5XDQ9Tsh0lsKMPrQ8/9qVZ7BcJ1c08AE3Eg6RSKZa4g6cjkEeAddTXFqa
 jrVhNhi9BSqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="191016777"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="191016777"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 10:39:24 -0700
IronPort-SDR: Q8PKwcItM15lis4alDyCSWB+ksl06QAiVy+Z3NruU+gnWuRJmOVUzqq93j+H6qCRvlFi+mxanR
 X/kFJMKoQIIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="416112235"
Received: from climb.png.intel.com ([10.221.118.165])
  by orsmga008.jf.intel.com with ESMTP; 25 Mar 2021 10:39:20 -0700
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
Subject: [PATCH v2 net-next 1/5] net: stmmac: introduce DMA interrupt status masking per traffic direction
Date:   Fri, 26 Mar 2021 01:39:12 +0800
Message-Id: <20210325173916.13203-2-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210325173916.13203-1-weifeng.voon@intel.com>
References: <20210325173916.13203-1-weifeng.voon@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

In preparation to make stmmac support multi-vector MSI, we introduce the
interrupt status masking according to RX, TX or RXTX. Default to use RXTX
inside stmmac_dma_interrupt(), so there is no run-time logic difference
now.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  6 +++++
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 24 ++++++++++++++++++-
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  | 21 +++++++++++++++-
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  7 +++++-
 .../net/ethernet/stmicro/stmmac/dwmac_dma.h   | 22 ++++++++++++++++-
 .../net/ethernet/stmicro/stmmac/dwmac_lib.c   |  8 ++++++-
 .../net/ethernet/stmicro/stmmac/dwxgmac2.h    |  6 +++++
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |  8 ++++++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  7 +++---
 10 files changed, 101 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index d065b11b7b10..5afb36a5c94c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -309,6 +309,12 @@ enum dma_irq_status {
 	handle_tx = 0x8,
 };
 
+enum dma_irq_dir {
+	DMA_DIR_RX = 0x1,
+	DMA_DIR_TX = 0x2,
+	DMA_DIR_RXTX = 0x3,
+};
+
 /* EEE and LPI defines */
 #define	CORE_IRQ_TX_PATH_IN_LPI_MODE	(1 << 0)
 #define	CORE_IRQ_TX_PATH_EXIT_LPI_MODE	(1 << 1)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 6b75cf2603ff..e0bd08978fd6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -239,6 +239,22 @@ static const struct emac_variant emac_variant_h6 = {
 #define EMAC_RX_EARLY_INT       BIT(13)
 #define EMAC_RGMII_STA_INT      BIT(16)
 
+#define EMAC_INT_MSK_COMMON	EMAC_RGMII_STA_INT
+#define EMAC_INT_MSK_TX		(EMAC_TX_INT | \
+				 EMAC_TX_DMA_STOP_INT | \
+				 EMAC_TX_BUF_UA_INT | \
+				 EMAC_TX_TIMEOUT_INT | \
+				 EMAC_TX_UNDERFLOW_INT | \
+				 EMAC_TX_EARLY_INT |\
+				 EMAC_INT_MSK_COMMON)
+#define EMAC_INT_MSK_RX		(EMAC_RX_INT | \
+				 EMAC_RX_BUF_UA_INT | \
+				 EMAC_RX_DMA_STOP_INT | \
+				 EMAC_RX_TIMEOUT_INT | \
+				 EMAC_RX_OVERFLOW_INT | \
+				 EMAC_RX_EARLY_INT | \
+				 EMAC_INT_MSK_COMMON)
+
 #define MAC_ADDR_TYPE_DST BIT(31)
 
 /* H3 specific bits for EPHY */
@@ -412,13 +428,19 @@ static void sun8i_dwmac_dma_stop_rx(void __iomem *ioaddr, u32 chan)
 }
 
 static int sun8i_dwmac_dma_interrupt(void __iomem *ioaddr,
-				     struct stmmac_extra_stats *x, u32 chan)
+				     struct stmmac_extra_stats *x, u32 chan,
+				     u32 dir)
 {
 	u32 v;
 	int ret = 0;
 
 	v = readl(ioaddr + EMAC_INT_STA);
 
+	if (dir == DMA_DIR_RX)
+		v &= EMAC_INT_MSK_RX;
+	else if (dir == DMA_DIR_TX)
+		v &= EMAC_INT_MSK_TX;
+
 	if (v & EMAC_TX_INT) {
 		ret |= handle_tx;
 		x->tx_normal_irq_n++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
index 8391ca63d943..5c0c53832adb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
@@ -149,6 +149,25 @@
 #define DMA_CHAN_STATUS_TPS		BIT(1)
 #define DMA_CHAN_STATUS_TI		BIT(0)
 
+#define DMA_CHAN_STATUS_MSK_COMMON	(DMA_CHAN_STATUS_NIS | \
+					 DMA_CHAN_STATUS_AIS | \
+					 DMA_CHAN_STATUS_CDE | \
+					 DMA_CHAN_STATUS_FBE)
+
+#define DMA_CHAN_STATUS_MSK_RX		(DMA_CHAN_STATUS_REB | \
+					 DMA_CHAN_STATUS_ERI | \
+					 DMA_CHAN_STATUS_RWT | \
+					 DMA_CHAN_STATUS_RPS | \
+					 DMA_CHAN_STATUS_RBU | \
+					 DMA_CHAN_STATUS_RI | \
+					 DMA_CHAN_STATUS_MSK_COMMON)
+
+#define DMA_CHAN_STATUS_MSK_TX		(DMA_CHAN_STATUS_ETI | \
+					 DMA_CHAN_STATUS_TBU | \
+					 DMA_CHAN_STATUS_TPS | \
+					 DMA_CHAN_STATUS_TI | \
+					 DMA_CHAN_STATUS_MSK_COMMON)
+
 /* Interrupt enable bits per channel */
 #define DMA_CHAN_INTR_ENA_NIE		BIT(16)
 #define DMA_CHAN_INTR_ENA_AIE		BIT(15)
@@ -206,7 +225,7 @@ void dwmac4_dma_stop_tx(void __iomem *ioaddr, u32 chan);
 void dwmac4_dma_start_rx(void __iomem *ioaddr, u32 chan);
 void dwmac4_dma_stop_rx(void __iomem *ioaddr, u32 chan);
 int dwmac4_dma_interrupt(void __iomem *ioaddr,
-			 struct stmmac_extra_stats *x, u32 chan);
+			 struct stmmac_extra_stats *x, u32 chan, u32 dir);
 void dwmac4_set_rx_ring_len(void __iomem *ioaddr, u32 len, u32 chan);
 void dwmac4_set_tx_ring_len(void __iomem *ioaddr, u32 len, u32 chan);
 void dwmac4_set_rx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index 71e50751ef2d..3fa602dabf49 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -135,12 +135,17 @@ void dwmac410_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
 }
 
 int dwmac4_dma_interrupt(void __iomem *ioaddr,
-			 struct stmmac_extra_stats *x, u32 chan)
+			 struct stmmac_extra_stats *x, u32 chan, u32 dir)
 {
 	u32 intr_status = readl(ioaddr + DMA_CHAN_STATUS(chan));
 	u32 intr_en = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
 	int ret = 0;
 
+	if (dir == DMA_DIR_RX)
+		intr_status &= DMA_CHAN_STATUS_MSK_RX;
+	else if (dir == DMA_DIR_TX)
+		intr_status &= DMA_CHAN_STATUS_MSK_TX;
+
 	/* ABNORMAL interrupts */
 	if (unlikely(intr_status & DMA_CHAN_STATUS_AIS)) {
 		if (unlikely(intr_status & DMA_CHAN_STATUS_RBU))
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
index e5dbd0bc257e..1914ad698cab 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
@@ -128,6 +128,26 @@
 #define DMA_STATUS_TI	0x00000001	/* Transmit Interrupt */
 #define DMA_CONTROL_FTF		0x00100000	/* Flush transmit FIFO */
 
+#define DMA_STATUS_MSK_COMMON		(DMA_STATUS_NIS | \
+					 DMA_STATUS_AIS | \
+					 DMA_STATUS_FBI)
+
+#define DMA_STATUS_MSK_RX		(DMA_STATUS_ERI | \
+					 DMA_STATUS_RWT | \
+					 DMA_STATUS_RPS | \
+					 DMA_STATUS_RU | \
+					 DMA_STATUS_RI | \
+					 DMA_STATUS_OVF | \
+					 DMA_STATUS_MSK_COMMON)
+
+#define DMA_STATUS_MSK_TX		(DMA_STATUS_ETI | \
+					 DMA_STATUS_UNF | \
+					 DMA_STATUS_TJT | \
+					 DMA_STATUS_TU | \
+					 DMA_STATUS_TPS | \
+					 DMA_STATUS_TI | \
+					 DMA_STATUS_MSK_COMMON)
+
 #define NUM_DWMAC100_DMA_REGS	9
 #define NUM_DWMAC1000_DMA_REGS	23
 
@@ -139,7 +159,7 @@ void dwmac_dma_stop_tx(void __iomem *ioaddr, u32 chan);
 void dwmac_dma_start_rx(void __iomem *ioaddr, u32 chan);
 void dwmac_dma_stop_rx(void __iomem *ioaddr, u32 chan);
 int dwmac_dma_interrupt(void __iomem *ioaddr, struct stmmac_extra_stats *x,
-			u32 chan);
+			u32 chan, u32 dir);
 int dwmac_dma_reset(void __iomem *ioaddr);
 
 #endif /* __DWMAC_DMA_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index 57a53a600aa5..d1c31200bb91 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -155,7 +155,7 @@ static void show_rx_process_state(unsigned int status)
 #endif
 
 int dwmac_dma_interrupt(void __iomem *ioaddr,
-			struct stmmac_extra_stats *x, u32 chan)
+			struct stmmac_extra_stats *x, u32 chan, u32 dir)
 {
 	int ret = 0;
 	/* read the status register (CSR5) */
@@ -167,6 +167,12 @@ int dwmac_dma_interrupt(void __iomem *ioaddr,
 	show_tx_process_state(intr_status);
 	show_rx_process_state(intr_status);
 #endif
+
+	if (dir == DMA_DIR_RX)
+		intr_status &= DMA_STATUS_MSK_RX;
+	else if (dir == DMA_DIR_TX)
+		intr_status &= DMA_STATUS_MSK_TX;
+
 	/* ABNORMAL interrupts */
 	if (unlikely(intr_status & DMA_STATUS_AIS)) {
 		if (unlikely(intr_status & DMA_STATUS_UNF)) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 6c3b8a950f58..1913385df685 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -412,6 +412,12 @@
 #define XGMAC_TI			BIT(0)
 #define XGMAC_REGSIZE			((0x0000317c + (0x80 * 15)) / 4)
 
+#define XGMAC_DMA_STATUS_MSK_COMMON	(XGMAC_NIS | XGMAC_AIS | XGMAC_FBE)
+#define XGMAC_DMA_STATUS_MSK_RX		(XGMAC_RBU | XGMAC_RI | \
+					 XGMAC_DMA_STATUS_MSK_COMMON)
+#define XGMAC_DMA_STATUS_MSK_TX		(XGMAC_TBU | XGMAC_TPS | XGMAC_TI | \
+					 XGMAC_DMA_STATUS_MSK_COMMON)
+
 /* Descriptors */
 #define XGMAC_TDES0_LTV			BIT(31)
 #define XGMAC_TDES0_LT			GENMASK(7, 0)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index f2cab5b76732..906e985441a9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -323,12 +323,18 @@ static void dwxgmac2_dma_stop_rx(void __iomem *ioaddr, u32 chan)
 }
 
 static int dwxgmac2_dma_interrupt(void __iomem *ioaddr,
-				  struct stmmac_extra_stats *x, u32 chan)
+				  struct stmmac_extra_stats *x, u32 chan,
+				  u32 dir)
 {
 	u32 intr_status = readl(ioaddr + XGMAC_DMA_CH_STATUS(chan));
 	u32 intr_en = readl(ioaddr + XGMAC_DMA_CH_INT_EN(chan));
 	int ret = 0;
 
+	if (dir == DMA_DIR_RX)
+		intr_status &= XGMAC_DMA_STATUS_MSK_RX;
+	else if (dir == DMA_DIR_TX)
+		intr_status &= XGMAC_DMA_STATUS_MSK_TX;
+
 	/* ABNORMAL interrupts */
 	if (unlikely(intr_status & XGMAC_AIS)) {
 		if (unlikely(intr_status & XGMAC_RBU)) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 45edac5f60db..c9cf89e21a41 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -201,7 +201,7 @@ struct stmmac_dma_ops {
 	void (*start_rx)(void __iomem *ioaddr, u32 chan);
 	void (*stop_rx)(void __iomem *ioaddr, u32 chan);
 	int (*dma_interrupt) (void __iomem *ioaddr,
-			      struct stmmac_extra_stats *x, u32 chan);
+			      struct stmmac_extra_stats *x, u32 chan, u32 dir);
 	/* If supported then get the optional core features */
 	void (*get_hw_feature)(void __iomem *ioaddr,
 			       struct dma_features *dma_cap);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 170296820af0..7c352d017eb2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2337,10 +2337,10 @@ static bool stmmac_safety_feat_interrupt(struct stmmac_priv *priv)
 	return false;
 }
 
-static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan)
+static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan, u32 dir)
 {
 	int status = stmmac_dma_interrupt_status(priv, priv->ioaddr,
-						 &priv->xstats, chan);
+						 &priv->xstats, chan, dir);
 	struct stmmac_channel *ch = &priv->channel[chan];
 	unsigned long flags;
 
@@ -2386,7 +2386,8 @@ static void stmmac_dma_interrupt(struct stmmac_priv *priv)
 		channels_to_check = ARRAY_SIZE(status);
 
 	for (chan = 0; chan < channels_to_check; chan++)
-		status[chan] = stmmac_napi_check(priv, chan);
+		status[chan] = stmmac_napi_check(priv, chan,
+						 DMA_DIR_RXTX);
 
 	for (chan = 0; chan < tx_channel_count; chan++) {
 		if (unlikely(status[chan] & tx_hard_error_bump_tc)) {
-- 
2.17.1

