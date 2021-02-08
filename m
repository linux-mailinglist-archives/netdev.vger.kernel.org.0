Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A063134E1
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhBHOSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:18:22 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57514 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhBHOJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:09:41 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
Subject: [PATCH 07/16] net: stmmac: Introduce MTL IRQs enable/disable methods
Date:   Mon, 8 Feb 2021 17:08:11 +0300
Message-ID: <20210208140820.10410-8-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aside with the DMA and MAC IRQs enable/disable methods the MTL IRQs state
regulation callbacks will be used to activate/de-activate the
network-related IRQs while the DW MAC network device is opened, up and
running/closed, down and stopped.

Note the MTL IRQs are enabled for the Rx Queues only in the framework of
the DMA operation mode configuration procedure as it has been done before
this commit (stmmac_dma_operation_mode() method). But in future it may
change that's why we need to have an additional "bool tx" argument.

Moreover there is no point in preserving the MTL IRQs interrupts control
register content for both DW MAC 4.x and DW xGMAC as it is related to the
MTL IRQs enable/disable configs only, which are tuned by the provided
methods and aren't touched by any other function. Thus we disable the rest
of the unsupported IRQs so not to confuse the MTL IRQs status handler.

Also note there is no need in enabling the MTL IRQs in the
stmmac_set_dma_operation_mode() method, because the later is called from
the DMA IRQ context and doesn't really intent the MTL IRQs setup change
anyway.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c | 23 +++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  |  7 +-----
 .../ethernet/stmicro/stmmac/dwxgmac2_core.c   | 21 +++++++++++++++++
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |  4 ----
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  8 +++++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 14 +++++++++--
 6 files changed, 65 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 8fc8d3cd238d..9ad48a0f96a6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -820,6 +820,23 @@ static void dwmac4_phystatus(void __iomem *ioaddr, struct stmmac_extra_stats *x)
 	}
 }
 
+static void dwmac4_enable_mtl_irq(void __iomem *ioaddr, u32 chan,
+				  bool rx, bool tx)
+{
+	u32 value = 0;
+
+	/* Enable just MTL RX overflow IRQ for now */
+	if (rx)
+		value |= MTL_RX_OVERFLOW_INT_EN;
+
+	writel(value, ioaddr + MTL_CHAN_INT_CTRL(chan));
+}
+
+static void dwmac4_disable_mtl_irq(void __iomem *ioaddr, u32 chan)
+{
+	writel(0, ioaddr + MTL_CHAN_INT_CTRL(chan));
+}
+
 static int dwmac4_irq_mtl_status(struct mac_device_info *hw, u32 chan)
 {
 	void __iomem *ioaddr = hw->pcsr;
@@ -1190,6 +1207,8 @@ const struct stmmac_ops dwmac4_ops = {
 	.enable_mac_irq = dwmac4_enable_mac_irq,
 	.disable_mac_irq = dwmac4_disable_mac_irq,
 	.host_irq_status = dwmac4_irq_status,
+	.enable_mtl_irq = dwmac4_enable_mtl_irq,
+	.disable_mtl_irq = dwmac4_disable_mtl_irq,
 	.host_mtl_irq_status = dwmac4_irq_mtl_status,
 	.flow_ctrl = dwmac4_flow_ctrl,
 	.pmt = dwmac4_pmt,
@@ -1234,6 +1253,8 @@ const struct stmmac_ops dwmac410_ops = {
 	.enable_mac_irq = dwmac4_enable_mac_irq,
 	.disable_mac_irq = dwmac4_disable_mac_irq,
 	.host_irq_status = dwmac4_irq_status,
+	.enable_mtl_irq = dwmac4_enable_mtl_irq,
+	.disable_mtl_irq = dwmac4_disable_mtl_irq,
 	.host_mtl_irq_status = dwmac4_irq_mtl_status,
 	.flow_ctrl = dwmac4_flow_ctrl,
 	.pmt = dwmac4_pmt,
@@ -1281,6 +1302,8 @@ const struct stmmac_ops dwmac510_ops = {
 	.enable_mac_irq = dwmac4_enable_mac_irq,
 	.disable_mac_irq = dwmac4_disable_mac_irq,
 	.host_irq_status = dwmac4_irq_status,
+	.enable_mtl_irq = dwmac4_enable_mtl_irq,
+	.disable_mtl_irq = dwmac4_disable_mtl_irq,
 	.host_mtl_irq_status = dwmac4_irq_mtl_status,
 	.flow_ctrl = dwmac4_flow_ctrl,
 	.pmt = dwmac4_pmt,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 924abda6c131..11bf0167e438 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -201,7 +201,7 @@ static void dwmac4_dma_rx_chan_op_mode(void __iomem *ioaddr, int mode,
 				       u32 channel, int fifosz, u8 qmode)
 {
 	unsigned int rqs = fifosz / 256 - 1;
-	u32 mtl_rx_op, mtl_rx_int;
+	u32 mtl_rx_op;
 
 	mtl_rx_op = readl(ioaddr + MTL_CHAN_RX_OP_MODE(channel));
 
@@ -262,11 +262,6 @@ static void dwmac4_dma_rx_chan_op_mode(void __iomem *ioaddr, int mode,
 	}
 
 	writel(mtl_rx_op, ioaddr + MTL_CHAN_RX_OP_MODE(channel));
-
-	/* Enable MTL RX overflow */
-	mtl_rx_int = readl(ioaddr + MTL_CHAN_INT_CTRL(channel));
-	writel(mtl_rx_int | MTL_RX_OVERFLOW_INT_EN,
-	       ioaddr + MTL_CHAN_INT_CTRL(channel));
 }
 
 static void dwmac4_dma_tx_chan_op_mode(void __iomem *ioaddr, int mode,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 12af0f831510..3a93e1b10d2e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -285,6 +285,23 @@ static int dwxgmac2_host_irq_status(struct mac_device_info *hw,
 	return ret;
 }
 
+static void dwxgmac2_enable_mtl_irq(void __iomem *ioaddr, u32 chan,
+				    bool rx, bool tx)
+{
+	u32 value = 0;
+
+	/* Enable just MTL RX overflow IRQ for now */
+	if (rx)
+		value |= XGMAC_RXOIE;
+
+	writel(value, ioaddr + XGMAC_MTL_QINTEN(chan));
+}
+
+static void dwxgmac2_disable_mtl_irq(void __iomem *ioaddr, u32 chan)
+{
+	writel(0, ioaddr + XGMAC_MTL_QINTEN(chan));
+}
+
 static int dwxgmac2_host_mtl_irq_status(struct mac_device_info *hw, u32 chan)
 {
 	void __iomem *ioaddr = hw->pcsr;
@@ -1476,6 +1493,8 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.enable_mac_irq = dwxgmac2_enable_mac_irq,
 	.disable_mac_irq = dwxgmac2_disable_mac_irq,
 	.host_irq_status = dwxgmac2_host_irq_status,
+	.enable_mtl_irq = dwxgmac2_enable_mtl_irq,
+	.disable_mtl_irq = dwxgmac2_disable_mtl_irq,
 	.host_mtl_irq_status = dwxgmac2_host_mtl_irq_status,
 	.flow_ctrl = dwxgmac2_flow_ctrl,
 	.pmt = dwxgmac2_pmt,
@@ -1539,6 +1558,8 @@ const struct stmmac_ops dwxlgmac2_ops = {
 	.enable_mac_irq = dwxgmac2_enable_mac_irq,
 	.disable_mac_irq = dwxgmac2_disable_mac_irq,
 	.host_irq_status = dwxgmac2_host_irq_status,
+	.enable_mtl_irq = dwxgmac2_enable_mtl_irq,
+	.disable_mtl_irq = dwxgmac2_disable_mtl_irq,
 	.host_mtl_irq_status = dwxgmac2_host_mtl_irq_status,
 	.flow_ctrl = dwxgmac2_flow_ctrl,
 	.pmt = dwxgmac2_pmt,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 94f101d1df6c..7812d00e7637 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -198,10 +198,6 @@ static void dwxgmac2_dma_rx_mode(void __iomem *ioaddr, int mode,
 	}
 
 	writel(value, ioaddr + XGMAC_MTL_RXQ_OPMODE(channel));
-
-	/* Enable MTL RX overflow */
-	value = readl(ioaddr + XGMAC_MTL_QINTEN(channel));
-	writel(value | XGMAC_RXOIE, ioaddr + XGMAC_MTL_QINTEN(channel));
 }
 
 static void dwxgmac2_dma_tx_mode(void __iomem *ioaddr, int mode,
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 6412c969cbb7..b933347cd991 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -332,6 +332,10 @@ struct stmmac_ops {
 	/* Handle extra events on specific interrupts hw dependent */
 	int (*host_irq_status)(struct mac_device_info *hw,
 			       struct stmmac_extra_stats *x);
+	/* Enable/Disable MTL interrupts */
+	void (*enable_mtl_irq)(void __iomem *ioaddr, u32 chan,
+			       bool rx, bool tx);
+	void (*disable_mtl_irq)(void __iomem *ioaddr, u32 chan);
 	/* Handle MTL interrupts */
 	int (*host_mtl_irq_status)(struct mac_device_info *hw, u32 chan);
 	/* Multicast filter setting */
@@ -442,6 +446,10 @@ struct stmmac_ops {
 	stmmac_do_void_callback(__priv, mac, disable_mac_irq, __args)
 #define stmmac_host_irq_status(__priv, __args...) \
 	stmmac_do_callback(__priv, mac, host_irq_status, __args)
+#define stmmac_enable_mtl_irq(__priv, __args...) \
+	stmmac_do_void_callback(__priv, mac, enable_mtl_irq, __args)
+#define stmmac_disable_mtl_irq(__priv, __args...) \
+	stmmac_do_void_callback(__priv, mac, disable_mtl_irq, __args)
 #define stmmac_host_mtl_irq_status(__priv, __args...) \
 	stmmac_do_callback(__priv, mac, host_mtl_irq_status, __args)
 #define stmmac_set_filter(__priv, __args...) \
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3e6cc91f08c5..33065195c499 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4129,6 +4129,7 @@ static int stmmac_set_features(struct net_device *netdev,
 static void stmmac_enable_irq(struct stmmac_priv *priv)
 {
 	u32 chan, maxq;
+	bool rx, tx;
 
 	/* The main IRQ signal needs to be masked while the IRQs enable/disable
 	 * procedure is in progress, because the individual IRQs handlers can
@@ -4138,9 +4139,15 @@ static void stmmac_enable_irq(struct stmmac_priv *priv)
 
 	maxq = max(priv->plat->rx_queues_to_use, priv->plat->tx_queues_to_use);
 
-	for (chan = 0; chan < maxq; ++chan)
+	for (chan = 0; chan < maxq; ++chan) {
 		stmmac_enable_dma_irq(priv, priv->ioaddr, chan);
 
+		rx = (chan < priv->plat->rx_queues_to_use);
+		tx = (chan < priv->plat->tx_queues_to_use);
+
+		stmmac_enable_mtl_irq(priv, priv->ioaddr, chan, rx, tx);
+	}
+
 	stmmac_enable_mac_irq(priv, priv->hw);
 
 	enable_irq(priv->dev->irq);
@@ -4163,8 +4170,11 @@ static void stmmac_disable_irq(struct stmmac_priv *priv)
 
 	stmmac_disable_mac_irq(priv, priv->hw);
 
-	for (chan = 0; chan < maxq; ++chan)
+	for (chan = 0; chan < maxq; ++chan) {
+		stmmac_disable_mtl_irq(priv, priv->ioaddr, chan);
+
 		stmmac_disable_dma_irq(priv, priv->ioaddr, chan);
+	}
 
 	enable_irq(priv->dev->irq);
 }
-- 
2.29.2

