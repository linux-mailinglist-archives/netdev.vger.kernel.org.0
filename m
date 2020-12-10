Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B562D6191
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 17:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732975AbgLJQUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 11:20:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:57784 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgLJQUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 11:20:18 -0500
IronPort-SDR: ytY2EAHtzuN/eBVkuBSENW+NXCI7K+0W226YfYh+ULV9IZirRkprV82uGRlNRpBiUIN0mP5eyn
 YH1/PjB7Wl2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="174427006"
X-IronPort-AV: E=Sophos;i="5.78,408,1599548400"; 
   d="scan'208";a="174427006"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 08:20:02 -0800
IronPort-SDR: bAETIilQj4d+IkpjWrQQNvyXNV0m0m5oQ1nWkE+ymPTQC06TDdzSFyq/9eI/tJT8b9IONTCXgb
 ikFrq5cQ9SKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,408,1599548400"; 
   d="scan'208";a="484536231"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 10 Dec 2020 08:20:00 -0800
Date:   Thu, 10 Dec 2020 17:11:05 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     intel-wired-lan@lists.osuosl.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next] ice, xsk: Move Rx alloction out of while-loop
Message-ID: <20201210161105.GD45760@ranger.igk.intel.com>
References: <20201210121915.14412-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201210121915.14412-1-bjorn.topel@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 01:19:15PM +0100, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> Instead of trying to allocate for each packet, move it outside the
> while loop and try to allocate once every NAPI loop.

To rectify above, it wasn't for each packet but per ICE_RX_BUF_WRITE
cleaned frames (16).

You also have a typo in subject (alloction).

Is spinning a v2 worth it?

> 
> This change boosts the xdpsock rxdrop scenario with 15% more
> packets-per-second.
> 
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> index 797886524054..39757b4cf8f4 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> @@ -570,12 +570,6 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
>  		u16 vlan_tag = 0;
>  		u8 rx_ptype;
>  
> -		if (cleaned_count >= ICE_RX_BUF_WRITE) {
> -			failure |= ice_alloc_rx_bufs_zc(rx_ring,
> -							cleaned_count);
> -			cleaned_count = 0;
> -		}
> -
>  		rx_desc = ICE_RX_DESC(rx_ring, rx_ring->next_to_clean);
>  
>  		stat_err_bits = BIT(ICE_RX_FLEX_DESC_STATUS0_DD_S);
> @@ -642,6 +636,9 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
>  		ice_receive_skb(rx_ring, skb, vlan_tag);
>  	}
>  
> +	if (cleaned_count >= ICE_RX_BUF_WRITE)
> +		failure = !ice_alloc_rx_bufs_zc(rx_ring, cleaned_count);
> +
>  	ice_finalize_xdp_rx(rx_ring, xdp_xmit);
>  	ice_update_rx_ring_stats(rx_ring, total_rx_packets, total_rx_bytes);
>  
> 
> base-commit: a7105e3472bf6bb3099d1293ea7d70e7783aa582
> -- 
> 2.27.0
> 
