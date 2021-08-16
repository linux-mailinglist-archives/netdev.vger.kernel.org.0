Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFB23ED284
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbhHPKyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:54:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:17780 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236242AbhHPKyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:54:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="276867110"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="276867110"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 03:53:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="448502468"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga007.fm.intel.com with ESMTP; 16 Aug 2021 03:53:29 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 944A85808DB;
        Mon, 16 Aug 2021 03:53:26 -0700 (PDT)
Date:   Mon, 16 Aug 2021 18:53:23 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, vee.khee.wong@intel.com,
        weifeng.voon@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/3] net: stmmac: add ethtool per-queue irq
 statistic support
Message-ID: <20210816105323.GA13779@linux.intel.com>
References: <cover.1629092894.git.vijayakannan.ayyathurai@intel.com>
 <5c956016465b688a2679bd02da1f751046be189c.1629092894.git.vijayakannan.ayyathurai@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c956016465b688a2679bd02da1f751046be189c.1629092894.git.vijayakannan.ayyathurai@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 02:16:00PM +0800, Vijayakannan Ayyathurai wrote:
> Adding ethtool per-queue statistics support to show number of interrupts
> generated at DMA tx and DMA rx. All the counters are incremented at
> dwmac4_dma_interrupt function.
>

Acked-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
 
> Signed-off-by: Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/common.h         | 2 ++
>  drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c     | 2 ++
>  drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 2 ++
>  3 files changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
> index 79333deef2e2..b6d945ea903d 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/common.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/common.h
> @@ -60,10 +60,12 @@
>  
>  struct stmmac_txq_stats {
>  	unsigned long tx_pkt_n;
> +	unsigned long tx_normal_irq_n;
>  };
>  
>  struct stmmac_rxq_stats {
>  	unsigned long rx_pkt_n;
> +	unsigned long rx_normal_irq_n;
>  };
>  
>  /* Extra statistic and debug information exposed by ethtool */
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
> index f83db62938dd..9292a1fab7d3 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
> @@ -170,10 +170,12 @@ int dwmac4_dma_interrupt(void __iomem *ioaddr,
>  		x->normal_irq_n++;
>  	if (likely(intr_status & DMA_CHAN_STATUS_RI)) {
>  		x->rx_normal_irq_n++;
> +		x->rxq_stats[chan].rx_normal_irq_n++;
>  		ret |= handle_rx;
>  	}
>  	if (likely(intr_status & DMA_CHAN_STATUS_TI)) {
>  		x->tx_normal_irq_n++;
> +		x->txq_stats[chan].tx_normal_irq_n++;
>  		ret |= handle_tx;
>  	}
>  	if (unlikely(intr_status & DMA_CHAN_STATUS_TBU))
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> index 10c0895d0b43..595c3ccdcbb7 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> @@ -263,11 +263,13 @@ static const struct stmmac_stats stmmac_mmc[] = {
>  
>  static const char stmmac_qstats_tx_string[][ETH_GSTRING_LEN] = {
>  	"tx_pkt_n",
> +	"tx_irq_n",
>  #define STMMAC_TXQ_STATS ARRAY_SIZE(stmmac_qstats_tx_string)
>  };
>  
>  static const char stmmac_qstats_rx_string[][ETH_GSTRING_LEN] = {
>  	"rx_pkt_n",
> +	"rx_irq_n",
>  #define STMMAC_RXQ_STATS ARRAY_SIZE(stmmac_qstats_rx_string)
>  };
>  
