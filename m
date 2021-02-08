Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2EC3134E4
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhBHOSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:18:52 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57508 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbhBHOJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:09:40 -0500
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
Subject: [PATCH 04/16] net: stmmac: Introduce DMA core cleanup method
Date:   Mon, 8 Feb 2021 17:08:08 +0300
Message-ID: <20210208140820.10410-5-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to the MAC core cleanup method let's introduce the DMA core
cleanup method, since we need have a way to get the DMA registers back
to their initial state while the whole interface reset is unavailable for
the particular DW MAC IP-core setup, like in case of GPIs and GPOs
support.

For now we've created the DMA cleanup method for the DW GMAC IP only,
since the chip we've got has been equipped with that IP and we lack the
documents to add and test the rest of the IPs support.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h     |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c     | 12 ++++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h          |  3 +++
 4 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
index 2a04d9d45160..bae63e1420f2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
@@ -246,6 +246,7 @@ static void dwmac1000_rx_watchdog(void __iomem *ioaddr, u32 riwt,
 
 const struct stmmac_dma_ops dwmac1000_dma_ops = {
 	.reset = dwmac_dma_reset,
+	.clean = dwmac_dma_clean,
 	.init = dwmac1000_dma_init,
 	.init_rx_chan = dwmac_dma_init_rx,
 	.init_tx_chan = dwmac_dma_init_tx,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
index fa919bf75e19..f6e759d039d7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
@@ -145,5 +145,6 @@ void dwmac_dma_stop_rx(void __iomem *ioaddr, u32 chan);
 int dwmac_dma_interrupt(void __iomem *ioaddr, struct stmmac_extra_stats *x,
 			u32 chan);
 int dwmac_dma_reset(void __iomem *ioaddr);
+void dwmac_dma_clean(void __iomem *ioaddr);
 
 #endif /* __DWMAC_DMA_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index 6ddfc689e77b..2186e95d5aa4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -26,6 +26,18 @@ int dwmac_dma_reset(void __iomem *ioaddr)
 				 10000, 200000);
 }
 
+void dwmac_dma_clean(void __iomem *ioaddr)
+{
+	/* Clean the basic DMA registers up */
+	writel(0, ioaddr + DMA_INTR_ENA);
+	writel(0x00020100, ioaddr + DMA_BUS_MODE);
+	writel(0, ioaddr + DMA_RCV_BASE_ADDR);
+	writel(0, ioaddr + DMA_TX_BASE_ADDR);
+	writel(0x00100000, ioaddr + DMA_CONTROL);
+	writel(0x00110001, ioaddr + DMA_AXI_BUS_MODE);
+	writel(0x0001FFFF, ioaddr + DMA_STATUS);
+}
+
 /* CSR1 enables the transmit DMA to check for new descriptor */
 void dwmac_enable_dma_transmission(void __iomem *ioaddr)
 {
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 3f5eed8333a5..dea5a4d17677 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -169,6 +169,7 @@ struct dma_features;
 struct stmmac_dma_ops {
 	/* DMA core initialization */
 	int (*reset)(void __iomem *ioaddr);
+	void (*clean)(void __iomem *ioaddr);
 	void (*init)(void __iomem *ioaddr, struct stmmac_dma_cfg *dma_cfg,
 		     int atds);
 	void (*init_chan)(void __iomem *ioaddr,
@@ -219,6 +220,8 @@ struct stmmac_dma_ops {
 
 #define stmmac_reset(__priv, __args...) \
 	stmmac_do_callback(__priv, dma, reset, __args)
+#define stmmac_dma_clean(__priv, __args...) \
+	stmmac_do_void_callback(__priv, dma, clean, __args)
 #define stmmac_dma_init(__priv, __args...) \
 	stmmac_do_void_callback(__priv, dma, init, __args)
 #define stmmac_init_chan(__priv, __args...) \
-- 
2.29.2

