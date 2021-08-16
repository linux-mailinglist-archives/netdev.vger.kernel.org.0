Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D906A3ECE88
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 08:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhHPGUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 02:20:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:31229 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233477AbhHPGUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 02:20:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="213952983"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="213952983"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2021 23:19:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="678986860"
Received: from vijay.png.intel.com ([10.88.229.73])
  by fmsmga005.fm.intel.com with ESMTP; 15 Aug 2021 23:19:36 -0700
From:   Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com
Cc:     vee.khee.wong@intel.com, weifeng.voon@intel.com,
        vijayakannan.ayyathurai@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 3/3] net: stmmac: add ethtool per-queue irq statistic support
Date:   Mon, 16 Aug 2021 14:16:00 +0800
Message-Id: <5c956016465b688a2679bd02da1f751046be189c.1629092894.git.vijayakannan.ayyathurai@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629092894.git.vijayakannan.ayyathurai@intel.com>
References: <cover.1629092894.git.vijayakannan.ayyathurai@intel.com>
In-Reply-To: <cover.1629092894.git.vijayakannan.ayyathurai@intel.com>
References: <cover.1629092894.git.vijayakannan.ayyathurai@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding ethtool per-queue statistics support to show number of interrupts
generated at DMA tx and DMA rx. All the counters are incremented at
dwmac4_dma_interrupt function.

Signed-off-by: Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h         | 2 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c     | 2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 79333deef2e2..b6d945ea903d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -60,10 +60,12 @@
 
 struct stmmac_txq_stats {
 	unsigned long tx_pkt_n;
+	unsigned long tx_normal_irq_n;
 };
 
 struct stmmac_rxq_stats {
 	unsigned long rx_pkt_n;
+	unsigned long rx_normal_irq_n;
 };
 
 /* Extra statistic and debug information exposed by ethtool */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index f83db62938dd..9292a1fab7d3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -170,10 +170,12 @@ int dwmac4_dma_interrupt(void __iomem *ioaddr,
 		x->normal_irq_n++;
 	if (likely(intr_status & DMA_CHAN_STATUS_RI)) {
 		x->rx_normal_irq_n++;
+		x->rxq_stats[chan].rx_normal_irq_n++;
 		ret |= handle_rx;
 	}
 	if (likely(intr_status & DMA_CHAN_STATUS_TI)) {
 		x->tx_normal_irq_n++;
+		x->txq_stats[chan].tx_normal_irq_n++;
 		ret |= handle_tx;
 	}
 	if (unlikely(intr_status & DMA_CHAN_STATUS_TBU))
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 10c0895d0b43..595c3ccdcbb7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -263,11 +263,13 @@ static const struct stmmac_stats stmmac_mmc[] = {
 
 static const char stmmac_qstats_tx_string[][ETH_GSTRING_LEN] = {
 	"tx_pkt_n",
+	"tx_irq_n",
 #define STMMAC_TXQ_STATS ARRAY_SIZE(stmmac_qstats_tx_string)
 };
 
 static const char stmmac_qstats_rx_string[][ETH_GSTRING_LEN] = {
 	"rx_pkt_n",
+	"rx_irq_n",
 #define STMMAC_RXQ_STATS ARRAY_SIZE(stmmac_qstats_rx_string)
 };
 
-- 
2.17.1

