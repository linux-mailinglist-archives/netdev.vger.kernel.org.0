Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352E13134A6
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhBHOLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:11:45 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57452 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbhBHOFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:05:37 -0500
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
Subject: [PATCH 06/20] net: stmmac: Use LPI IRQ status-related macro in DW MAC1000 isr
Date:   Mon, 8 Feb 2021 17:03:27 +0300
Message-ID: <20210208140341.9271-7-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some reason the DW MAC1000-specific IRQ status handler has been using
the GMAC_INT_DISABLE_PMT macro to test whether the PMT IRQ is pending in
the MAC status register while there is a dedicated macro
GMAC_INT_STATUS_PMT exists for the corresponding field to test. It didn't
cause any error because the bits position match in both DW MAC IRQ mask
and status registers, but semantically the code still doesn't look
correct. Let's fix that by using the correct macro there.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index fc8759f146c7..6b9a4f54b93c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -321,7 +321,7 @@ static int dwmac1000_irq_status(struct mac_device_info *hw,
 		x->mmc_rx_irq_n++;
 	if (unlikely(intr_status & GMAC_INT_STATUS_MMCCSUM))
 		x->mmc_rx_csum_offload_irq_n++;
-	if (unlikely(intr_status & GMAC_INT_DISABLE_PMT)) {
+	if (unlikely(intr_status & GMAC_INT_STATUS_PMT)) {
 		/* clear the PMT bits 5 and 6 by reading the PMT status reg */
 		readl(ioaddr + GMAC_PMT);
 		x->irq_receive_pmt_irq_n++;
-- 
2.29.2

