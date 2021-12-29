Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AC748130F
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 14:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239566AbhL2NNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 08:13:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:10811 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236531AbhL2NNS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 08:13:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640783598; x=1672319598;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KU9e2sHqNDNyPQpSY8EwOt7bZ290fvDmMDUxWc/zkOg=;
  b=mqCZbgfeJaXl1i4CByONN2uuRL3DtXwHLfiBZBqepYyOffXavw3HWE4R
   urFykf460zgZbzMndRkKpqvpoARKwZ0O53Yzn01TrYHaFrZkSBejA4nAp
   0A6FjM79dpMscGYWZvf1E0SLBv/frlpFpdAPGNTVlJMH/Ng3FvjI7D/lc
   XvVd2wvY30X1zq9KWInk4m10gfkxuhLV51Z5cg1Zd/Cn347lYriCstwlw
   UkyVEOYG/DNO3DxPIVNi+kqNDzUexHF09YSpxNTUuMu3Lv4jBupEan8jH
   cK+moveiw//x13RhlQJsxDBGAmA5+L8u2wJcDGZ/gEGMRO1vEEbdWxty6
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10211"; a="241320521"
X-IronPort-AV: E=Sophos;i="5.88,245,1635231600"; 
   d="scan'208";a="241320521"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 05:13:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,245,1635231600"; 
   d="scan'208";a="468483654"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 29 Dec 2021 05:13:16 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1BTDDFee026533;
        Wed, 29 Dec 2021 13:13:15 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com
Subject: Re: [PATCH bpf-next v2 3/4] ice: xsk: improve AF_XDP ZC Tx and use batching API
Date:   Wed, 29 Dec 2021 14:11:31 +0100
Message-Id: <20211229131131.1460702-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211216135958.3434-4-maciej.fijalkowski@intel.com>
References: <20211216135958.3434-1-maciej.fijalkowski@intel.com> <20211216135958.3434-4-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Thu, 16 Dec 2021 14:59:57 +0100

> Follow mostly the logic from commit 9610bd988df9 ("ice: optimize XDP_TX
> workloads") that has been done in order to address the massive tx_busy
> statistic bump and improve the performance as well.
> 
> Increase the ICE_TX_THRESH to 64 as it seems to work out better for both
> XDP and AF_XDP. Also, separating the stats structs onto separate cache
> lines seemed to improve the performance. Batching approach is inspired
> by i40e's implementation with adjustments to the cleaning logic.
> 
> One difference from 'xdpdrv' XDP_TX is when ring has less than
> ICE_TX_THRESH free entries, the cleaning routine will not stop after
> cleaning a single ICE_TX_THRESH amount of descs but rather will forward
> the next_dd pointer and check the DD bit and for this bit being set the
> cleaning will be repeated. IOW clean until there are descs that can be
> cleaned.
> 
> It takes three separate xdpsock instances in txonly mode to achieve the
> line rate and this was not previously possible.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c |   2 +-
>  drivers/net/ethernet/intel/ice/ice_txrx.h |   4 +-
>  drivers/net/ethernet/intel/ice/ice_xsk.c  | 249 ++++++++++++++--------
>  drivers/net/ethernet/intel/ice/ice_xsk.h  |  26 ++-
>  4 files changed, 182 insertions(+), 99 deletions(-)
> 

-- 8< --

> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
> index 4c7bd8e9dfc4..f2eb99063c1f 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.h
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
> @@ -6,19 +6,36 @@
>  #include "ice_txrx.h"
>  #include "ice.h"
>  
> +#define PKTS_PER_BATCH 8
> +
> +#ifdef __clang__
> +#define loop_unrolled_for _Pragma("clang loop unroll_count(8)") for
> +#elif __GNUC__ >= 4
> +#define loop_unrolled_for _Pragma("GCC unroll 8") for
> +#else
> +#define loop_unrolled_for for
> +#endif

It's used in a bunch more places across the tree, what about
defining that in linux/compiler{,_clang,_gcc}.h?
Is it possible to pass '8' as an argument? Like

	loop_unrolled_for(PKTS_PER_BATCH) ( ; ; ) { }

Could be quite handy.
If it is not, I'd maybe try to define a couple of precoded macros
for 8, 16 and 32, like

#define loop_unrolled_for_8 ...
#define loop_unrolled_for_16 ...
...

So they could be used as generic. I don't think I've seen them with
values other than 8-32.

> +
>  struct ice_vsi;
>  
>  #ifdef CONFIG_XDP_SOCKETS
>  int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool,
>  		       u16 qid);
>  int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget);
> -bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget);
>  int ice_xsk_wakeup(struct net_device *netdev, u32 queue_id, u32 flags);
>  bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count);
>  bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi);
>  void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring);
>  void ice_xsk_clean_xdp_ring(struct ice_tx_ring *xdp_ring);
> +bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, u32 budget);
>  #else
> +static inline bool
> +ice_xmit_zc(struct ice_tx_ring __always_unused *xdp_ring,
> +	    u32 __always_unused budget)
> +{
> +	return false;
> +}
> +
>  static inline int
>  ice_xsk_pool_setup(struct ice_vsi __always_unused *vsi,
>  		   struct xsk_buff_pool __always_unused *pool,
> @@ -34,13 +51,6 @@ ice_clean_rx_irq_zc(struct ice_rx_ring __always_unused *rx_ring,
>  	return 0;
>  }
>  
> -static inline bool
> -ice_clean_tx_irq_zc(struct ice_tx_ring __always_unused *xdp_ring,
> -		    int __always_unused budget)
> -{
> -	return false;
> -}
> -
>  static inline bool
>  ice_alloc_rx_bufs_zc(struct ice_rx_ring __always_unused *rx_ring,
>  		     u16 __always_unused count)
> -- 
> 2.33.1

Thanks,
Al
