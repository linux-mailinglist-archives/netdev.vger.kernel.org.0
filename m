Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D02632B422
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352897AbhCCEeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:34:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:26554 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235229AbhCCEIs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 23:08:48 -0500
IronPort-SDR: R0elyS9hq+RhQbA9nDFV0v6C9KAw56s/FyRyNYFvDfExxWBAoTYymRJ7kyL/bR2chB1sUlGDyD
 eNtvhkLbwrvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="187208253"
X-IronPort-AV: E=Sophos;i="5.81,218,1610438400"; 
   d="scan'208";a="187208253"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 20:08:03 -0800
IronPort-SDR: 6JOYJ6aBjXDsTvfNE18IvXvNacFMncaIzyC3On+Kl0FC2bUn/DjHPi2VdCy85nepbya1bbQ1Rx
 /mGjtM9oDFvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,218,1610438400"; 
   d="scan'208";a="407056226"
Received: from intel-z390-ud.iind.intel.com ([10.223.96.21])
  by orsmga008.jf.intel.com with ESMTP; 02 Mar 2021 20:07:59 -0800
From:   ramesh.babu.b@intel.com
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Ramesh Babu B <ramesh.babu.b@intel.com>
Subject: [PATCH net 1/1] net: stmmac: fix incorrect DMA channel intr enable setting of EQoS v4.10
Date:   Wed,  3 Mar 2021 20:38:40 +0530
Message-Id: <20210303150840.30024-1-ramesh.babu.b@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

We introduce dwmac410_dma_init_channel() here for both EQoS v4.10 and
above which use different DMA_CH(n)_Interrupt_Enable bit definitions for
NIE and AIE.

Fixes: 48863ce5940f ("stmmac: add DMA support for GMAC 4.xx")
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Ramesh Babu B <ramesh.babu.b@intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index bb29bfcd62c3..62aa0e95beb7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -124,6 +124,23 @@ static void dwmac4_dma_init_channel(void __iomem *ioaddr,
 	       ioaddr + DMA_CHAN_INTR_ENA(chan));
 }
 
+static void dwmac410_dma_init_channel(void __iomem *ioaddr,
+				      struct stmmac_dma_cfg *dma_cfg, u32 chan)
+{
+	u32 value;
+
+	/* common channel control register config */
+	value = readl(ioaddr + DMA_CHAN_CONTROL(chan));
+	if (dma_cfg->pblx8)
+		value = value | DMA_BUS_MODE_PBL;
+
+	writel(value, ioaddr + DMA_CHAN_CONTROL(chan));
+
+	/* Mask interrupts by writing to CSR7 */
+	writel(DMA_CHAN_INTR_DEFAULT_MASK_4_10,
+	       ioaddr + DMA_CHAN_INTR_ENA(chan));
+}
+
 static void dwmac4_dma_init(void __iomem *ioaddr,
 			    struct stmmac_dma_cfg *dma_cfg, int atds)
 {
@@ -523,7 +540,7 @@ const struct stmmac_dma_ops dwmac4_dma_ops = {
 const struct stmmac_dma_ops dwmac410_dma_ops = {
 	.reset = dwmac4_dma_reset,
 	.init = dwmac4_dma_init,
-	.init_chan = dwmac4_dma_init_channel,
+	.init_chan = dwmac410_dma_init_channel,
 	.init_rx_chan = dwmac4_dma_init_rx_chan,
 	.init_tx_chan = dwmac4_dma_init_tx_chan,
 	.axi = dwmac4_dma_axi,
-- 
2.17.1

