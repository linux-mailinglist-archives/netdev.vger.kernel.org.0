Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5F8481C65
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 14:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239499AbhL3NNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 08:13:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:19985 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236208AbhL3NNM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 08:13:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640869992; x=1672405992;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=q/HMgBj5AbGi6HG58yHRTDs9pxMWXuCk5+n7wUGrSMI=;
  b=FD6pF9TOi+8KOZOPuM35sDCtYy2jIyWz+QsIAc7Ebx/7GAo3lY1N364t
   9y4H5Ol/iRXSJF2Ll3TCoaiEd2/PTR8faPIPSlpnMvK6UjlnvJHRBsIgD
   dU7SmYBCJi6djxKW+K3XWycRFtDOLibu0da6VngOtwo1ie1k2xtbATRkv
   uEi6+cdFSzxjmTLtgaex53nJEECcS+FcP4qvtUP7uvTILUGQ3imUIpoGN
   GcACUGJrL5FfDGUeh5YwLOhHv6l/PC6eDEqRDwY9jA/eY9B14romM1ihi
   WsopxspQ06WJtGhCxJANpVZ8EKNshhKpl1qsYxu0yWktyyBbu0FjZAUUH
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="239210640"
X-IronPort-AV: E=Sophos;i="5.88,248,1635231600"; 
   d="scan'208";a="239210640"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2021 05:13:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,248,1635231600"; 
   d="scan'208";a="759234705"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga006.fm.intel.com with ESMTP; 30 Dec 2021 05:13:10 -0800
Date:   Thu, 30 Dec 2021 14:13:10 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com
Subject: Re: [PATCH bpf-next v2 3/4] ice: xsk: improve AF_XDP ZC Tx and use
 batching API
Message-ID: <Yc2wZvfA8qr/XB8P@boxer>
References: <20211216135958.3434-1-maciej.fijalkowski@intel.com>
 <20211216135958.3434-4-maciej.fijalkowski@intel.com>
 <20211229131131.1460702-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229131131.1460702-1-alexandr.lobakin@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 02:11:31PM +0100, Alexander Lobakin wrote:
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Date: Thu, 16 Dec 2021 14:59:57 +0100
> 
> > Follow mostly the logic from commit 9610bd988df9 ("ice: optimize XDP_TX
> > workloads") that has been done in order to address the massive tx_busy
> > statistic bump and improve the performance as well.
> > 
> > Increase the ICE_TX_THRESH to 64 as it seems to work out better for both
> > XDP and AF_XDP. Also, separating the stats structs onto separate cache
> > lines seemed to improve the performance. Batching approach is inspired
> > by i40e's implementation with adjustments to the cleaning logic.
> > 
> > One difference from 'xdpdrv' XDP_TX is when ring has less than
> > ICE_TX_THRESH free entries, the cleaning routine will not stop after
> > cleaning a single ICE_TX_THRESH amount of descs but rather will forward
> > the next_dd pointer and check the DD bit and for this bit being set the
> > cleaning will be repeated. IOW clean until there are descs that can be
> > cleaned.
> > 
> > It takes three separate xdpsock instances in txonly mode to achieve the
> > line rate and this was not previously possible.
> > 
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_txrx.c |   2 +-
> >  drivers/net/ethernet/intel/ice/ice_txrx.h |   4 +-
> >  drivers/net/ethernet/intel/ice/ice_xsk.c  | 249 ++++++++++++++--------
> >  drivers/net/ethernet/intel/ice/ice_xsk.h  |  26 ++-
> >  4 files changed, 182 insertions(+), 99 deletions(-)
> > 
> 
> -- 8< --
> 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
> > index 4c7bd8e9dfc4..f2eb99063c1f 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_xsk.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
> > @@ -6,19 +6,36 @@
> >  #include "ice_txrx.h"
> >  #include "ice.h"
> >  
> > +#define PKTS_PER_BATCH 8
> > +
> > +#ifdef __clang__
> > +#define loop_unrolled_for _Pragma("clang loop unroll_count(8)") for
> > +#elif __GNUC__ >= 4
> > +#define loop_unrolled_for _Pragma("GCC unroll 8") for
> > +#else
> > +#define loop_unrolled_for for
> > +#endif
> 
> It's used in a bunch more places across the tree, what about
> defining that in linux/compiler{,_clang,_gcc}.h?
> Is it possible to pass '8' as an argument? Like

Like where besides i40e? I might currently suck at grepping, let's blame
christmas break for that.

If there are actually other callsites besides i40e then this is a good
idea to me, maybe as a follow-up?

> 
> 	loop_unrolled_for(PKTS_PER_BATCH) ( ; ; ) { }
> 
> Could be quite handy.
> If it is not, I'd maybe try to define a couple of precoded macros
> for 8, 16 and 32, like
> 
> #define loop_unrolled_for_8 ...
> #define loop_unrolled_for_16 ...
> ...
> 
> So they could be used as generic. I don't think I've seen them with
> values other than 8-32.
> 
> > +
> >  struct ice_vsi;
> >  
> >  #ifdef CONFIG_XDP_SOCKETS
> >  int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool,
> >  		       u16 qid);
> >  int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget);
> > -bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget);
> >  int ice_xsk_wakeup(struct net_device *netdev, u32 queue_id, u32 flags);
> >  bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count);
> >  bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi);
> >  void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring);
> >  void ice_xsk_clean_xdp_ring(struct ice_tx_ring *xdp_ring);
> > +bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, u32 budget);
> >  #else
> > +static inline bool
> > +ice_xmit_zc(struct ice_tx_ring __always_unused *xdp_ring,
> > +	    u32 __always_unused budget)
> > +{
> > +	return false;
> > +}
> > +
> >  static inline int
> >  ice_xsk_pool_setup(struct ice_vsi __always_unused *vsi,
> >  		   struct xsk_buff_pool __always_unused *pool,
> > @@ -34,13 +51,6 @@ ice_clean_rx_irq_zc(struct ice_rx_ring __always_unused *rx_ring,
> >  	return 0;
> >  }
> >  
> > -static inline bool
> > -ice_clean_tx_irq_zc(struct ice_tx_ring __always_unused *xdp_ring,
> > -		    int __always_unused budget)
> > -{
> > -	return false;
> > -}
> > -
> >  static inline bool
> >  ice_alloc_rx_bufs_zc(struct ice_rx_ring __always_unused *rx_ring,
> >  		     u16 __always_unused count)
> > -- 
> > 2.33.1
> 
> Thanks,
> Al
