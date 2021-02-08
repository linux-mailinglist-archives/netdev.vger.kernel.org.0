Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2B53134EC
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbhBHOUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:20:06 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57512 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhBHOJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:09:42 -0500
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
Subject: [PATCH 09/16] net: stmmac: Disable MMC IRQs in the generic IRQs disable method
Date:   Mon, 8 Feb 2021 17:08:13 +0300
Message-ID: <20210208140820.10410-10-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MMC IRQs aren't handled by the main ISR, so for the sake of the code
coherency let's move the MMC IRQs disabling procedure to the generic IRQs
de-activating method. By doing so we've finally finished filling the
generic IRQs enable/disable functions up with the individual
MAC/MTL/DMA/etc interrupt control methods.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ddcd82d02c27..fcd59a647b02 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2274,8 +2274,6 @@ static void stmmac_mmc_setup(struct stmmac_priv *priv)
 	unsigned int mode = MMC_CNTRL_RESET_ON_READ | MMC_CNTRL_COUNTER_RESET |
 			    MMC_CNTRL_PRESET | MMC_CNTRL_FULL_HALF_PRESET;
 
-	stmmac_mmc_intr_all_mask(priv, priv->mmcaddr);
-
 	if (priv->dma_cap.rmon) {
 		stmmac_mmc_ctrl(priv, priv->mmcaddr, mode);
 		memset(&priv->mmc, 0, sizeof(struct stmmac_counters));
@@ -4182,6 +4180,8 @@ static void stmmac_disable_irq(struct stmmac_priv *priv)
 	if (priv->dma_cap.asp)
 		stmmac_disable_safety_feat_irq(priv, priv->ioaddr);
 
+	stmmac_mmc_intr_all_mask(priv, priv->mmcaddr);
+
 	enable_irq(priv->dev->irq);
 }
 
-- 
2.29.2

