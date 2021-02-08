Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504AD31349E
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhBHOKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:10:47 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57234 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbhBHOE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:04:28 -0500
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
Subject: [PATCH 03/20] net: stmmac: Fix false MTL RX overflow handling for higher queues
Date:   Mon, 8 Feb 2021 17:03:24 +0300
Message-ID: <20210208140341.9271-4-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Judging by the MAC/MTL-related part of the ISR implementation if MTL IRQs
status handler returns MTL Rx overflow bit set, the
stmmac_set_rx_tail_ptr() method will be called for all subsequent queues.
That most likely isn't what we want. Fix it by just overriding the status
variable on each loop iteration. Note we can freely break the loop at the
very beginning if the stmmac_host_mtl_irq_status() method returns -EINVAL,
because that error means the MTL IRQ status handler isn't available for
the detected hardware.

Fixes: 7bac4e1ec3ca ("net: stmmac: stmmac interrupt treatment prepared for multiple queues")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>

---

Folks, I haven't seen an effect of that bug. The patch has been created
purely based on the code visual perception. If you think the handler is
supposed to work like that and I am missing something (though I have much
doubt about that), just drop this patch.
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5ee840525824..d45af1ea2565 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4149,7 +4149,6 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 	/* To handle GMAC own interrupts */
 	if ((priv->plat->has_gmac) || xmac) {
 		int status = stmmac_host_irq_status(priv, priv->hw, &priv->xstats);
-		int mtl_status;
 
 		if (unlikely(status)) {
 			/* For LPI we need to save the tx status */
@@ -4162,10 +4161,10 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 		for (queue = 0; queue < queues_count; queue++) {
 			struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 
-			mtl_status = stmmac_host_mtl_irq_status(priv, priv->hw,
-								queue);
-			if (mtl_status != -EINVAL)
-				status |= mtl_status;
+			status = stmmac_host_mtl_irq_status(priv, priv->hw,
+							    queue);
+			if (status == -EINVAL)
+				break;
 
 			if (status & CORE_IRQ_MTL_RX_OVERFLOW)
 				stmmac_set_rx_tail_ptr(priv, priv->ioaddr,
-- 
2.29.2

