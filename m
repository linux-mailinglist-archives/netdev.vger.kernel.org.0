Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACD43ECE85
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 08:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbhHPGTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 02:19:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:52714 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhHPGTn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 02:19:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="212684167"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="212684167"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2021 23:19:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="678986775"
Received: from vijay.png.intel.com ([10.88.229.73])
  by fmsmga005.fm.intel.com with ESMTP; 15 Aug 2021 23:19:08 -0700
From:   Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com
Cc:     vee.khee.wong@intel.com, weifeng.voon@intel.com,
        vijayakannan.ayyathurai@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 1/3] net: stmmac: fix INTR TBU status affecting irq count statistic
Date:   Mon, 16 Aug 2021 14:15:58 +0800
Message-Id: <f82f52076841285309a997f849e2786781548538.1629092894.git.vijayakannan.ayyathurai@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629092894.git.vijayakannan.ayyathurai@intel.com>
References: <cover.1629092894.git.vijayakannan.ayyathurai@intel.com>
In-Reply-To: <cover.1629092894.git.vijayakannan.ayyathurai@intel.com>
References: <cover.1629092894.git.vijayakannan.ayyathurai@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

DMA channel status "Transmit buffer unavailable(TBU)" bit is not
considered as a successful dma tx. Hence, it should not affect
all the irq count statistic.

Fixes: 1103d3a5531c ("net: stmmac: dwmac4: Also use TBU interrupt to clean TX path")
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index e63270267578..f83db62938dd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -172,11 +172,12 @@ int dwmac4_dma_interrupt(void __iomem *ioaddr,
 		x->rx_normal_irq_n++;
 		ret |= handle_rx;
 	}
-	if (likely(intr_status & (DMA_CHAN_STATUS_TI |
-		DMA_CHAN_STATUS_TBU))) {
+	if (likely(intr_status & DMA_CHAN_STATUS_TI)) {
 		x->tx_normal_irq_n++;
 		ret |= handle_tx;
 	}
+	if (unlikely(intr_status & DMA_CHAN_STATUS_TBU))
+		ret |= handle_tx;
 	if (unlikely(intr_status & DMA_CHAN_STATUS_ERI))
 		x->rx_early_irq++;
 
-- 
2.17.1

