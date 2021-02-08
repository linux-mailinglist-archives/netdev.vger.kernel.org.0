Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6518C3134AC
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhBHOMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:12:09 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57450 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbhBHOFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:05:43 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/20] net: stmmac: Use dwmac410_disable_dma_irq for DW MAC v4.10 DMA
Date:   Mon, 8 Feb 2021 17:03:26 +0300
Message-ID: <20210208140341.9271-6-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From the very beginning of the DW GMAC v4.10 IP support the driver has used
an invalid DMA IRQ disable method to switch the DMA IRQs off. Since
commit 021bd5e36970 ("net: stmmac: Let TX and RX interrupts be
independently enabled/disabled") a valid method has been added to the
dwmac4_lib.c module, but the commit author forgot to initialize the
corresponding field of the DW MAC DMA operations descriptor with it. That
mistake hasn't caused any problem so far just because the RIE/TIE fields
match in both 4.x and 4.10 IPs. Anyway fix the inconsistency in order to
at least have a coherent driver code.

Fixes: 021bd5e36970 ("net: stmmac: Let TX and RX interrupts be independently enabled/disabled")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index bb29bfcd62c3..59da9ff36a43 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -531,7 +531,7 @@ const struct stmmac_dma_ops dwmac410_dma_ops = {
 	.dma_rx_mode = dwmac4_dma_rx_chan_op_mode,
 	.dma_tx_mode = dwmac4_dma_tx_chan_op_mode,
 	.enable_dma_irq = dwmac410_enable_dma_irq,
-	.disable_dma_irq = dwmac4_disable_dma_irq,
+	.disable_dma_irq = dwmac410_disable_dma_irq,
 	.start_tx = dwmac4_dma_start_tx,
 	.stop_tx = dwmac4_dma_stop_tx,
 	.start_rx = dwmac4_dma_start_rx,
-- 
2.29.2

