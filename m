Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D592D3ED240
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhHPKsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:48:25 -0400
Received: from mga04.intel.com ([192.55.52.120]:4868 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230250AbhHPKsZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:48:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="213987707"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="213987707"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 03:47:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="504848340"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP; 16 Aug 2021 03:47:53 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id DF374580866;
        Mon, 16 Aug 2021 03:47:49 -0700 (PDT)
Date:   Mon, 16 Aug 2021 18:47:46 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, vee.khee.wong@intel.com,
        weifeng.voon@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/3] net: stmmac: fix INTR TBU status
 affecting irq count statistic
Message-ID: <20210816104746.GA9014@linux.intel.com>
References: <cover.1629092894.git.vijayakannan.ayyathurai@intel.com>
 <f82f52076841285309a997f849e2786781548538.1629092894.git.vijayakannan.ayyathurai@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f82f52076841285309a997f849e2786781548538.1629092894.git.vijayakannan.ayyathurai@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 02:15:58PM +0800, Vijayakannan Ayyathurai wrote:
> From: Voon Weifeng <weifeng.voon@intel.com>
> 
> DMA channel status "Transmit buffer unavailable(TBU)" bit is not
> considered as a successful dma tx. Hence, it should not affect
> all the irq count statistic.
>

Acked-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
 
> Fixes: 1103d3a5531c ("net: stmmac: dwmac4: Also use TBU interrupt to clean TX path")
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
> index e63270267578..f83db62938dd 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
> @@ -172,11 +172,12 @@ int dwmac4_dma_interrupt(void __iomem *ioaddr,
>  		x->rx_normal_irq_n++;
>  		ret |= handle_rx;
>  	}
> -	if (likely(intr_status & (DMA_CHAN_STATUS_TI |
> -		DMA_CHAN_STATUS_TBU))) {
> +	if (likely(intr_status & DMA_CHAN_STATUS_TI)) {
>  		x->tx_normal_irq_n++;
>  		ret |= handle_tx;
>  	}
> +	if (unlikely(intr_status & DMA_CHAN_STATUS_TBU))
> +		ret |= handle_tx;
>  	if (unlikely(intr_status & DMA_CHAN_STATUS_ERI))
>  		x->rx_early_irq++;
>  
