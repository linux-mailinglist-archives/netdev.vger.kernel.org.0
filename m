Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF9A3134FE
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbhBHOVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:21:50 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57758 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbhBHOKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:10:06 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/16] net: stmmac: Extend DMA IRQs enable/disable interface
Date:   Mon, 8 Feb 2021 17:08:10 +0300
Message-ID: <20210208140820.10410-7-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to the MAC core IRQs we need to be able to enable/disable all
the DMA-related interrupts by means of the dedicated methods so the DMA
IRQs would be enabled only when they are needed to be enabled (for
instance while the network device being opened) and disabled otherwise.
For that sake and for the sake of unification let's convert the currently
available enable_dma_irq/disable_dma_irq callbacks to fully switching the
DMA IRQs on/off and add the dedicated methods to toggle the DMA Tx/Rx IRQs
when it's required.

Note DMA channels initialization procedure won't enable the DMA IRQs
anymore. Such modification won't break the DMA-related code because the
default macro has both Tx and Rx DMA IRQs flags set anyway. So in order to
make things working as usual we just need to call the
stmmac_enable_dma_irq() method aside with the generic IRQs activating
function.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>

---

Note folks, in the framework of this commit we've naturally fixed an
invalid default DMA IRQs enable macro usage for the DW MAC v4.10 DMA
initialization. I don't really know why it hasn't been noticed so far
especially seeing the 4.x Normal/Abnormal IRQs bit fields have been
used to enable these IRQs on 4.10a hardware. I leave this commit as is for
now. But if tests prove the bug-fix actuality, then most likely we'll need
to create a dedicated patch to correctly have it backported.
---
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 33 ++++++++----
 .../ethernet/stmicro/stmmac/dwmac1000_dma.c   |  5 +-
 .../ethernet/stmicro/stmmac/dwmac100_dma.c    |  5 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 10 ++--
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  | 11 ++--
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  | 51 ++++++++++++-------
 .../net/ethernet/stmicro/stmmac/dwmac_dma.h   |  6 ++-
 .../net/ethernet/stmicro/stmmac/dwmac_lib.c   | 26 +++++++---
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    | 31 +++++++----
 drivers/net/ethernet/stmicro/stmmac/hwif.h    | 12 +++--
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 26 ++++++++--
 11 files changed, 142 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index a5e0eff4a387..35d1aeb20fa9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -285,7 +285,6 @@ static int sun8i_dwmac_dma_reset(void __iomem *ioaddr)
 static void sun8i_dwmac_dma_init(void __iomem *ioaddr,
 				 struct stmmac_dma_cfg *dma_cfg, int atds)
 {
-	writel(EMAC_RX_INT | EMAC_TX_INT, ioaddr + EMAC_INT_EN);
 	writel(0x1FFFFFF, ioaddr + EMAC_INT_STA);
 }
 
@@ -337,32 +336,42 @@ static void sun8i_dwmac_dump_mac_regs(struct mac_device_info *hw,
 	}
 }
 
-static void sun8i_dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan,
-				       bool rx, bool tx)
+static void sun8i_dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan)
+{
+	writel(EMAC_RX_INT | EMAC_TX_INT, ioaddr + EMAC_INT_EN);
+}
+
+static void sun8i_dwmac_switch_dma_rx_irq(void __iomem *ioaddr, u32 chan,
+					  bool on)
 {
 	u32 value = readl(ioaddr + EMAC_INT_EN);
 
-	if (rx)
+	if (on)
 		value |= EMAC_RX_INT;
-	if (tx)
-		value |= EMAC_TX_INT;
+	else
+		value &= ~EMAC_RX_INT;
 
 	writel(value, ioaddr + EMAC_INT_EN);
 }
 
-static void sun8i_dwmac_disable_dma_irq(void __iomem *ioaddr, u32 chan,
-					bool rx, bool tx)
+static void sun8i_dwmac_switch_dma_tx_irq(void __iomem *ioaddr, u32 chan,
+					  bool on)
 {
 	u32 value = readl(ioaddr + EMAC_INT_EN);
 
-	if (rx)
-		value &= ~EMAC_RX_INT;
-	if (tx)
+	if (on)
+		value |= EMAC_TX_INT;
+	else
 		value &= ~EMAC_TX_INT;
 
 	writel(value, ioaddr + EMAC_INT_EN);
 }
 
+static void sun8i_dwmac_disable_dma_irq(void __iomem *ioaddr, u32 chan)
+{
+	writel(0, ioaddr + EMAC_INT_EN);
+}
+
 static void sun8i_dwmac_dma_start_tx(void __iomem *ioaddr, u32 chan)
 {
 	u32 v;
@@ -533,6 +542,8 @@ static const struct stmmac_dma_ops sun8i_dwmac_dma_ops = {
 	.dma_tx_mode = sun8i_dwmac_dma_operation_mode_tx,
 	.enable_dma_transmission = sun8i_dwmac_enable_dma_transmission,
 	.enable_dma_irq = sun8i_dwmac_enable_dma_irq,
+	.switch_dma_rx_irq = sun8i_dwmac_switch_dma_rx_irq,
+	.switch_dma_tx_irq = sun8i_dwmac_switch_dma_tx_irq,
 	.disable_dma_irq = sun8i_dwmac_disable_dma_irq,
 	.start_tx = sun8i_dwmac_dma_start_tx,
 	.stop_tx = sun8i_dwmac_dma_stop_tx,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
index bae63e1420f2..c1b79f712323 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
@@ -105,9 +105,6 @@ static void dwmac1000_dma_init(void __iomem *ioaddr,
 		value |= DMA_BUS_MODE_AAL;
 
 	writel(value, ioaddr + DMA_BUS_MODE);
-
-	/* Mask interrupts by writing to CSR7 */
-	writel(DMA_INTR_DEFAULT_MASK, ioaddr + DMA_INTR_ENA);
 }
 
 static u32 dwmac1000_configure_fc(u32 csr6, int rxfifosz)
@@ -256,6 +253,8 @@ const struct stmmac_dma_ops dwmac1000_dma_ops = {
 	.dma_tx_mode = dwmac1000_dma_operation_mode_tx,
 	.enable_dma_transmission = dwmac_enable_dma_transmission,
 	.enable_dma_irq = dwmac_enable_dma_irq,
+	.switch_dma_rx_irq = dwmac_switch_dma_rx_irq,
+	.switch_dma_tx_irq = dwmac_switch_dma_tx_irq,
 	.disable_dma_irq = dwmac_disable_dma_irq,
 	.start_tx = dwmac_dma_start_tx,
 	.stop_tx = dwmac_dma_stop_tx,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
index ad51a7949a42..e880c07dd34c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
@@ -24,9 +24,6 @@ static void dwmac100_dma_init(void __iomem *ioaddr,
 	/* Enable Application Access by writing to DMA CSR0 */
 	writel(DMA_BUS_MODE_DEFAULT | (dma_cfg->pbl << DMA_BUS_MODE_PBL_SHIFT),
 	       ioaddr + DMA_BUS_MODE);
-
-	/* Mask interrupts by writing to CSR7 */
-	writel(DMA_INTR_DEFAULT_MASK, ioaddr + DMA_INTR_ENA);
 }
 
 /* Store and Forward capability is not used at all.
@@ -102,6 +99,8 @@ const struct stmmac_dma_ops dwmac100_dma_ops = {
 	.dma_diagnostic_fr = dwmac100_dma_diagnostic_fr,
 	.enable_dma_transmission = dwmac_enable_dma_transmission,
 	.enable_dma_irq = dwmac_enable_dma_irq,
+	.switch_dma_rx_irq = dwmac_switch_dma_rx_irq,
+	.switch_dma_tx_irq = dwmac_switch_dma_tx_irq,
 	.disable_dma_irq = dwmac_disable_dma_irq,
 	.start_tx = dwmac_dma_start_tx,
 	.stop_tx = dwmac_dma_stop_tx,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 59da9ff36a43..924abda6c131 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -118,10 +118,6 @@ static void dwmac4_dma_init_channel(void __iomem *ioaddr,
 	if (dma_cfg->pblx8)
 		value = value | DMA_BUS_MODE_PBL;
 	writel(value, ioaddr + DMA_CHAN_CONTROL(chan));
-
-	/* Mask interrupts by writing to CSR7 */
-	writel(DMA_CHAN_INTR_DEFAULT_MASK,
-	       ioaddr + DMA_CHAN_INTR_ENA(chan));
 }
 
 static void dwmac4_dma_init(void __iomem *ioaddr,
@@ -502,6 +498,8 @@ const struct stmmac_dma_ops dwmac4_dma_ops = {
 	.dma_rx_mode = dwmac4_dma_rx_chan_op_mode,
 	.dma_tx_mode = dwmac4_dma_tx_chan_op_mode,
 	.enable_dma_irq = dwmac4_enable_dma_irq,
+	.switch_dma_rx_irq = dwmac4_switch_dma_rx_irq,
+	.switch_dma_tx_irq = dwmac4_switch_dma_tx_irq,
 	.disable_dma_irq = dwmac4_disable_dma_irq,
 	.start_tx = dwmac4_dma_start_tx,
 	.stop_tx = dwmac4_dma_stop_tx,
@@ -531,7 +529,9 @@ const struct stmmac_dma_ops dwmac410_dma_ops = {
 	.dma_rx_mode = dwmac4_dma_rx_chan_op_mode,
 	.dma_tx_mode = dwmac4_dma_tx_chan_op_mode,
 	.enable_dma_irq = dwmac410_enable_dma_irq,
-	.disable_dma_irq = dwmac410_disable_dma_irq,
+	.switch_dma_rx_irq = dwmac410_switch_dma_rx_irq,
+	.switch_dma_tx_irq = dwmac410_switch_dma_tx_irq,
+	.disable_dma_irq = dwmac4_disable_dma_irq,
 	.start_tx = dwmac4_dma_start_tx,
 	.stop_tx = dwmac4_dma_stop_tx,
 	.start_rx = dwmac4_dma_start_rx,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
index 8391ca63d943..d8c9f9107879 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
@@ -197,10 +197,13 @@
 #define DMA_CHAN0_DBG_STAT_RPS_SHIFT	8
 
 int dwmac4_dma_reset(void __iomem *ioaddr);
-void dwmac4_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
-void dwmac410_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
-void dwmac4_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
-void dwmac410_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
+void dwmac4_enable_dma_irq(void __iomem *ioaddr, u32 chan);
+void dwmac410_enable_dma_irq(void __iomem *ioaddr, u32 chan);
+void dwmac4_switch_dma_rx_irq(void __iomem *ioaddr, u32 chan, bool on);
+void dwmac410_switch_dma_rx_irq(void __iomem *ioaddr, u32 chan, bool on);
+void dwmac4_switch_dma_tx_irq(void __iomem *ioaddr, u32 chan, bool on);
+void dwmac410_switch_dma_tx_irq(void __iomem *ioaddr, u32 chan, bool on);
+void dwmac4_disable_dma_irq(void __iomem *ioaddr, u32 chan);
 void dwmac4_dma_start_tx(void __iomem *ioaddr, u32 chan);
 void dwmac4_dma_stop_tx(void __iomem *ioaddr, u32 chan);
 void dwmac4_dma_start_rx(void __iomem *ioaddr, u32 chan);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index 0b4ee2dbb691..ee46eabf11af 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -90,54 +90,69 @@ void dwmac4_set_rx_ring_len(void __iomem *ioaddr, u32 len, u32 chan)
 	writel(len, ioaddr + DMA_CHAN_RX_RING_LEN(chan));
 }
 
-void dwmac4_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+void dwmac4_enable_dma_irq(void __iomem *ioaddr, u32 chan)
+{
+	writel(DMA_CHAN_INTR_DEFAULT_MASK, ioaddr + DMA_CHAN_INTR_ENA(chan));
+}
+
+void dwmac410_enable_dma_irq(void __iomem *ioaddr, u32 chan)
+{
+	writel(DMA_CHAN_INTR_DEFAULT_MASK_4_10, ioaddr + DMA_CHAN_INTR_ENA(chan));
+}
+
+void dwmac4_switch_dma_rx_irq(void __iomem *ioaddr, u32 chan, bool on)
 {
 	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
 
-	if (rx)
+	if (on)
 		value |= DMA_CHAN_INTR_DEFAULT_RX;
-	if (tx)
-		value |= DMA_CHAN_INTR_DEFAULT_TX;
+	else
+		value &= ~DMA_CHAN_INTR_DEFAULT_RX;
 
 	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
 }
 
-void dwmac410_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+void dwmac4_switch_dma_tx_irq(void __iomem *ioaddr, u32 chan, bool on)
 {
 	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
 
-	if (rx)
-		value |= DMA_CHAN_INTR_DEFAULT_RX_4_10;
-	if (tx)
-		value |= DMA_CHAN_INTR_DEFAULT_TX_4_10;
+	if (on)
+		value |= DMA_CHAN_INTR_DEFAULT_TX;
+	else
+		value &= ~DMA_CHAN_INTR_DEFAULT_TX;
 
 	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
 }
 
-void dwmac4_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+void dwmac410_switch_dma_rx_irq(void __iomem *ioaddr, u32 chan, bool on)
 {
 	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
 
-	if (rx)
-		value &= ~DMA_CHAN_INTR_DEFAULT_RX;
-	if (tx)
-		value &= ~DMA_CHAN_INTR_DEFAULT_TX;
+	if (on)
+		value |= DMA_CHAN_INTR_DEFAULT_RX_4_10;
+	else
+		value &= ~DMA_CHAN_INTR_DEFAULT_RX_4_10;
 
 	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
 }
 
-void dwmac410_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+void dwmac410_switch_dma_tx_irq(void __iomem *ioaddr, u32 chan, bool on)
 {
 	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
 
-	if (rx)
-		value &= ~DMA_CHAN_INTR_DEFAULT_RX_4_10;
-	if (tx)
+	if (on)
+		value |= DMA_CHAN_INTR_DEFAULT_TX_4_10;
+	else
 		value &= ~DMA_CHAN_INTR_DEFAULT_TX_4_10;
 
 	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
 }
 
+void dwmac4_disable_dma_irq(void __iomem *ioaddr, u32 chan)
+{
+	writel(0, ioaddr + DMA_CHAN_INTR_ENA(chan));
+}
+
 int dwmac4_dma_interrupt(void __iomem *ioaddr,
 			 struct stmmac_extra_stats *x, u32 chan)
 {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
index f6e759d039d7..a692ed714426 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
@@ -132,8 +132,10 @@
 #define NUM_DWMAC1000_DMA_REGS	23
 
 void dwmac_enable_dma_transmission(void __iomem *ioaddr);
-void dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
-void dwmac_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
+void dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan);
+void dwmac_switch_dma_rx_irq(void __iomem *ioaddr, u32 chan, bool on);
+void dwmac_switch_dma_tx_irq(void __iomem *ioaddr, u32 chan, bool on);
+void dwmac_disable_dma_irq(void __iomem *ioaddr, u32 chan);
 void dwmac_dma_init_tx(void __iomem *ioaddr, struct stmmac_dma_cfg *dma_cfg,
 		       dma_addr_t dma_tx_phy, u32 chan);
 void dwmac_dma_start_tx(void __iomem *ioaddr, u32 chan);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index 2186e95d5aa4..0ba986be83f5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -44,30 +44,40 @@ void dwmac_enable_dma_transmission(void __iomem *ioaddr)
 	writel(1, ioaddr + DMA_XMT_POLL_DEMAND);
 }
 
-void dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+void dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan)
+{
+	writel(DMA_INTR_DEFAULT_MASK, ioaddr + DMA_INTR_ENA);
+}
+
+void dwmac_switch_dma_rx_irq(void __iomem *ioaddr, u32 chan, bool on)
 {
 	u32 value = readl(ioaddr + DMA_INTR_ENA);
 
-	if (rx)
+	if (on)
 		value |= DMA_INTR_DEFAULT_RX;
-	if (tx)
-		value |= DMA_INTR_DEFAULT_TX;
+	else
+		value &= ~DMA_INTR_DEFAULT_RX;
 
 	writel(value, ioaddr + DMA_INTR_ENA);
 }
 
-void dwmac_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+void dwmac_switch_dma_tx_irq(void __iomem *ioaddr, u32 chan, bool on)
 {
 	u32 value = readl(ioaddr + DMA_INTR_ENA);
 
-	if (rx)
-		value &= ~DMA_INTR_DEFAULT_RX;
-	if (tx)
+	if (on)
+		value |= DMA_INTR_DEFAULT_TX;
+	else
 		value &= ~DMA_INTR_DEFAULT_TX;
 
 	writel(value, ioaddr + DMA_INTR_ENA);
 }
 
+void dwmac_disable_dma_irq(void __iomem *ioaddr, u32 chan)
+{
+	writel(0, ioaddr + DMA_INTR_ENA);
+}
+
 void dwmac_dma_init_tx(void __iomem *ioaddr, struct stmmac_dma_cfg *dma_cfg,
 		       dma_addr_t dma_tx_phy, u32 chan)
 {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 77308c5c5d29..94f101d1df6c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -42,7 +42,6 @@ static void dwxgmac2_dma_init_chan(void __iomem *ioaddr,
 		value |= XGMAC_PBLx8;
 
 	writel(value, ioaddr + XGMAC_DMA_CH_CONTROL(chan));
-	writel(XGMAC_DMA_INT_DEFAULT_EN, ioaddr + XGMAC_DMA_CH_INT_EN(chan));
 }
 
 static void dwxgmac2_dma_init_rx_chan(void __iomem *ioaddr,
@@ -248,32 +247,40 @@ static void dwxgmac2_dma_tx_mode(void __iomem *ioaddr, int mode,
 	writel(value, ioaddr +  XGMAC_MTL_TXQ_OPMODE(channel));
 }
 
-static void dwxgmac2_enable_dma_irq(void __iomem *ioaddr, u32 chan,
-				    bool rx, bool tx)
+static void dwxgmac2_enable_dma_irq(void __iomem *ioaddr, u32 chan)
+{
+	writel(XGMAC_DMA_INT_DEFAULT_EN, ioaddr + XGMAC_DMA_CH_INT_EN(chan));
+}
+
+static void dwxgmac2_switch_dma_rx_irq(void __iomem *ioaddr, u32 chan, bool on)
 {
 	u32 value = readl(ioaddr + XGMAC_DMA_CH_INT_EN(chan));
 
-	if (rx)
+	if (on)
 		value |= XGMAC_DMA_INT_DEFAULT_RX;
-	if (tx)
-		value |= XGMAC_DMA_INT_DEFAULT_TX;
+	else
+		value &= ~XGMAC_DMA_INT_DEFAULT_RX;
 
 	writel(value, ioaddr + XGMAC_DMA_CH_INT_EN(chan));
 }
 
-static void dwxgmac2_disable_dma_irq(void __iomem *ioaddr, u32 chan,
-				     bool rx, bool tx)
+static void dwxgmac2_switch_dma_tx_irq(void __iomem *ioaddr, u32 chan, bool on)
 {
 	u32 value = readl(ioaddr + XGMAC_DMA_CH_INT_EN(chan));
 
-	if (rx)
-		value &= ~XGMAC_DMA_INT_DEFAULT_RX;
-	if (tx)
+	if (on)
+		value |= XGMAC_DMA_INT_DEFAULT_TX;
+	else
 		value &= ~XGMAC_DMA_INT_DEFAULT_TX;
 
 	writel(value, ioaddr + XGMAC_DMA_CH_INT_EN(chan));
 }
 
+static void dwxgmac2_disable_dma_irq(void __iomem *ioaddr, u32 chan)
+{
+	writel(0, ioaddr + XGMAC_DMA_CH_INT_EN(chan));
+}
+
 static void dwxgmac2_dma_start_tx(void __iomem *ioaddr, u32 chan)
 {
 	u32 value;
@@ -557,6 +564,8 @@ const struct stmmac_dma_ops dwxgmac210_dma_ops = {
 	.dma_rx_mode = dwxgmac2_dma_rx_mode,
 	.dma_tx_mode = dwxgmac2_dma_tx_mode,
 	.enable_dma_irq = dwxgmac2_enable_dma_irq,
+	.switch_dma_rx_irq = dwxgmac2_switch_dma_rx_irq,
+	.switch_dma_tx_irq = dwxgmac2_switch_dma_tx_irq,
 	.disable_dma_irq = dwxgmac2_disable_dma_irq,
 	.start_tx = dwxgmac2_dma_start_tx,
 	.stop_tx = dwxgmac2_dma_stop_tx,
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 68496b7a640b..6412c969cbb7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -192,10 +192,10 @@ struct stmmac_dma_ops {
 	void (*dma_diagnostic_fr) (void *data, struct stmmac_extra_stats *x,
 				   void __iomem *ioaddr);
 	void (*enable_dma_transmission) (void __iomem *ioaddr);
-	void (*enable_dma_irq)(void __iomem *ioaddr, u32 chan,
-			       bool rx, bool tx);
-	void (*disable_dma_irq)(void __iomem *ioaddr, u32 chan,
-				bool rx, bool tx);
+	void (*enable_dma_irq)(void __iomem *ioaddr, u32 chan);
+	void (*switch_dma_rx_irq)(void __iomem *ioaddr, u32 chan, bool on);
+	void (*switch_dma_tx_irq)(void __iomem *ioaddr, u32 chan, bool on);
+	void (*disable_dma_irq)(void __iomem *ioaddr, u32 chan);
 	void (*start_tx)(void __iomem *ioaddr, u32 chan);
 	void (*stop_tx)(void __iomem *ioaddr, u32 chan);
 	void (*start_rx)(void __iomem *ioaddr, u32 chan);
@@ -244,6 +244,10 @@ struct stmmac_dma_ops {
 	stmmac_do_void_callback(__priv, dma, enable_dma_transmission, __args)
 #define stmmac_enable_dma_irq(__priv, __args...) \
 	stmmac_do_void_callback(__priv, dma, enable_dma_irq, __args)
+#define stmmac_switch_dma_rx_irq(__priv, __args...) \
+	stmmac_do_void_callback(__priv, dma, switch_dma_rx_irq, __args)
+#define stmmac_switch_dma_tx_irq(__priv, __args...) \
+	stmmac_do_void_callback(__priv, dma, switch_dma_tx_irq, __args)
 #define stmmac_disable_dma_irq(__priv, __args...) \
 	stmmac_do_void_callback(__priv, dma, disable_dma_irq, __args)
 #define stmmac_start_tx(__priv, __args...) \
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d124cbaceafd..3e6cc91f08c5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2199,7 +2199,7 @@ static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan)
 	if ((status & handle_rx) && (chan < priv->plat->rx_queues_to_use)) {
 		if (napi_schedule_prep(&ch->rx_napi)) {
 			spin_lock_irqsave(&ch->lock, flags);
-			stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 0);
+			stmmac_switch_dma_rx_irq(priv, priv->ioaddr, chan, 0);
 			spin_unlock_irqrestore(&ch->lock, flags);
 			__napi_schedule(&ch->rx_napi);
 		}
@@ -2208,7 +2208,7 @@ static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan)
 	if ((status & handle_tx) && (chan < priv->plat->tx_queues_to_use)) {
 		if (napi_schedule_prep(&ch->tx_napi)) {
 			spin_lock_irqsave(&ch->lock, flags);
-			stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 0, 1);
+			stmmac_switch_dma_tx_irq(priv, priv->ioaddr, chan, 0);
 			spin_unlock_irqrestore(&ch->lock, flags);
 			__napi_schedule(&ch->tx_napi);
 		}
@@ -2413,7 +2413,7 @@ static enum hrtimer_restart stmmac_tx_timer(struct hrtimer *t)
 		unsigned long flags;
 
 		spin_lock_irqsave(&ch->lock, flags);
-		stmmac_disable_dma_irq(priv, priv->ioaddr, ch->index, 0, 1);
+		stmmac_switch_dma_tx_irq(priv, priv->ioaddr, ch->index, 0);
 		spin_unlock_irqrestore(&ch->lock, flags);
 		__napi_schedule(&ch->tx_napi);
 	}
@@ -3963,7 +3963,7 @@ static int stmmac_napi_poll_rx(struct napi_struct *napi, int budget)
 		unsigned long flags;
 
 		spin_lock_irqsave(&ch->lock, flags);
-		stmmac_enable_dma_irq(priv, priv->ioaddr, chan, 1, 0);
+		stmmac_switch_dma_rx_irq(priv, priv->ioaddr, chan, 1);
 		spin_unlock_irqrestore(&ch->lock, flags);
 	}
 
@@ -3987,7 +3987,7 @@ static int stmmac_napi_poll_tx(struct napi_struct *napi, int budget)
 		unsigned long flags;
 
 		spin_lock_irqsave(&ch->lock, flags);
-		stmmac_enable_dma_irq(priv, priv->ioaddr, chan, 0, 1);
+		stmmac_switch_dma_tx_irq(priv, priv->ioaddr, chan, 1);
 		spin_unlock_irqrestore(&ch->lock, flags);
 	}
 
@@ -4128,12 +4128,19 @@ static int stmmac_set_features(struct net_device *netdev,
  */
 static void stmmac_enable_irq(struct stmmac_priv *priv)
 {
+	u32 chan, maxq;
+
 	/* The main IRQ signal needs to be masked while the IRQs enable/disable
 	 * procedure is in progress, because the individual IRQs handlers can
 	 * also read/write the IRQs control registers.
 	 */
 	disable_irq(priv->dev->irq);
 
+	maxq = max(priv->plat->rx_queues_to_use, priv->plat->tx_queues_to_use);
+
+	for (chan = 0; chan < maxq; ++chan)
+		stmmac_enable_dma_irq(priv, priv->ioaddr, chan);
+
 	stmmac_enable_mac_irq(priv, priv->hw);
 
 	enable_irq(priv->dev->irq);
@@ -4146,10 +4153,19 @@ static void stmmac_enable_irq(struct stmmac_priv *priv)
  */
 static void stmmac_disable_irq(struct stmmac_priv *priv)
 {
+	u32 chan, maxq;
+
 	disable_irq(priv->dev->irq);
 
 	stmmac_disable_mac_irq(priv, priv->hw);
 
+	maxq = max(priv->plat->rx_queues_to_use, priv->plat->tx_queues_to_use);
+
+	stmmac_disable_mac_irq(priv, priv->hw);
+
+	for (chan = 0; chan < maxq; ++chan)
+		stmmac_disable_dma_irq(priv, priv->ioaddr, chan);
+
 	enable_irq(priv->dev->irq);
 }
 
-- 
2.29.2

