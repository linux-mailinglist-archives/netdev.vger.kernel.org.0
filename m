Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC624A4B0A
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 16:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379814AbiAaPya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 10:54:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:64774 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378305AbiAaPy2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 10:54:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643644468; x=1675180468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QSQmtIpB49hVUd9x8rslZkDhT/POH0AWRUXYW6gz07Y=;
  b=kjz2mikVhKCzYWB8dXD4b39YpwVc4rjEisnYFz2Yvp6yAESFEZY6BQNK
   uTXSnknPR6t6tyh51+sTsxtoO+Rs/jbmU6lK7UCeLJRDf+Flu8QM2rE+x
   hOQngN+EMQ6WypTslExgAoyS6eKR2nCnLcD+UsAivvpL8x0aCoUnli1lc
   lsYUYfjGAJkgntvJCKET637trzNa8usZUh60iPPv9vq1QpY8kCPXAXYBH
   GSEb3rtMr8sdYNO2sZK1GC30iiLBXd2Lo6cEYxRWjNhcitjYCduv/iTED
   Alh1tZ+XFpE2Ws/0kRkTZroGx/LnG2KmjH8PRqoL1zyQK1cNCS5xCi8AB
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="247256096"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="247256096"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 07:54:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="534208873"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 31 Jan 2022 07:54:23 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20VFsMkW025367;
        Mon, 31 Jan 2022 15:54:22 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, anthony.l.nguyen@intel.com, kuba@kernel.org,
        davem@davemloft.net, magnus.karlsson@intel.com,
        jesse.brandeburg@intel.com
Subject: Re: [PATCH intel-net] ice: avoid XDP checks in ice_clean_tx_irq()
Date:   Mon, 31 Jan 2022 16:52:33 +0100
Message-Id: <20220131155233.17962-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220131134921.13176-1-maciej.fijalkowski@intel.com>
References: <20220131134921.13176-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Mon, 31 Jan 2022 14:49:21 +0100

> Commit 9610bd988df9 ("ice: optimize XDP_TX workloads") introduced
> dedicated Tx IRQ cleaning routine dedicated for XDP rings. Currently it

  ^^^^^^^^^                         ^^^^^^^^^

dedicated-dedicated :z

> is impossible to call ice_clean_tx_irq() against XDP ring, so it is safe
> to drop ice_ring_is_xdp() calls in there.
> 
> Fixes: 1c96c16858ba ("ice: update to newer kernel API")
> Fixes: cc14db11c8a4 ("ice: use prefetch methods")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index 7d8824b4c8ff..25a5a3f2d107 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -223,8 +223,7 @@ static bool ice_clean_tx_irq(struct ice_tx_ring *tx_ring, int napi_budget)
>  	struct ice_tx_buf *tx_buf;
>  
>  	/* get the bql data ready */
> -	if (!ice_ring_is_xdp(tx_ring))
> -		netdev_txq_bql_complete_prefetchw(txring_txq(tx_ring));
> +	netdev_txq_bql_complete_prefetchw(txring_txq(tx_ring));
>  
>  	tx_buf = &tx_ring->tx_buf[i];
>  	tx_desc = ICE_TX_DESC(tx_ring, i);
> @@ -313,10 +312,6 @@ static bool ice_clean_tx_irq(struct ice_tx_ring *tx_ring, int napi_budget)
>  	tx_ring->next_to_clean = i;
>  
>  	ice_update_tx_ring_stats(tx_ring, total_pkts, total_bytes);
> -
> -	if (ice_ring_is_xdp(tx_ring))
> -		return !!budget;
> -
>  	netdev_tx_completed_queue(txring_txq(tx_ring), total_pkts, total_bytes);
>  
>  #define TX_WAKE_THRESHOLD ((s16)(DESC_NEEDED * 2))

For the code:

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

> -- 
> 2.33.1

Thanks!
Al
