Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B412649851A
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243868AbiAXQo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:44:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:29791 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243857AbiAXQo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 11:44:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643042696; x=1674578696;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LlSir2LcINVCfusLwLZhh2D3eRwTsIXL/4YlxY1UD/s=;
  b=a9nGb8mR53kXq6mlI8IuQd03pIL64itIt3+Y7dNiLp2CJgJJYlt5c+gL
   d7K8LD33WaLjo6J6GkYIsVZCsDJi7Zr+RKmjy0Rpg71HC7BFvkD8Ay9TJ
   XiGI7Hj4t1vtp0vbpsVssCYoOO7llJWkWXytgJBhYIu5v1LO4UYtMr/sh
   Q8iK7Z2f2HpYdoagAQ7sB+SkfXcSutOWaluj0e321/kci5SbXj+tElx67
   jr12hmf41nkZXyGxe9eDbGHKPtWo/e1KyXcWTTl3wlktFvSezp1Gi+O5S
   65JL17gCm+Qg4118t7DxlBDyJ1QHiRDfrbm0TwV2PdHw19cdOopGaCYEP
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="233450453"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="233450453"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 08:44:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="479142935"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga006.jf.intel.com with ESMTP; 24 Jan 2022 08:44:53 -0800
Date:   Mon, 24 Jan 2022 17:44:52 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        jesse.brandeburg@intel.com
Subject: Re: [PATCH bpf-next v3 2/7] ice: xsk: handle SW XDP ring wrap and
 bump tail more often
Message-ID: <Ye7XhNFwC/5RggCL@boxer>
References: <20220121120011.49316-1-maciej.fijalkowski@intel.com>
 <20220121120011.49316-3-maciej.fijalkowski@intel.com>
 <20220121122920.23679-1-alexandr.lobakin@intel.com>
 <YerDwy7il806OqJD@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YerDwy7il806OqJD@boxer>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 03:31:31PM +0100, Maciej Fijalkowski wrote:
> On Fri, Jan 21, 2022 at 01:29:20PM +0100, Alexander Lobakin wrote:
> > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Date: Fri, 21 Jan 2022 13:00:06 +0100
> > 
> > > Currently, if ice_clean_rx_irq_zc() processed the whole ring and
> > > next_to_use != 0, then ice_alloc_rx_buf_zc() would not refill the whole
> > > ring even if the XSK buffer pool would have enough free entries (either
> > > from fill ring or the internal recycle mechanism) - it is because ring
> > > wrap is not handled.
> > > 
> > > Improve the logic in ice_alloc_rx_buf_zc() to address the problem above.
> > > Do not clamp the count of buffers that is passed to
> > > xsk_buff_alloc_batch() in case when next_to_use + buffer count >=
> > > rx_ring->count,  but rather split it and have two calls to the mentioned
> > > function - one for the part up until the wrap and one for the part after
> > > the wrap.
> > > 
> > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > ---
> > >  drivers/net/ethernet/intel/ice/ice_txrx.h |  2 +
> > >  drivers/net/ethernet/intel/ice/ice_xsk.c  | 99 ++++++++++++++++++-----
> > >  2 files changed, 81 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
> > > index b7b3bd4816f0..94a46e0e5ed0 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice_txrx.h
> > > +++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
> > > @@ -111,6 +111,8 @@ static inline int ice_skb_pad(void)
> > >  	(u16)((((R)->next_to_clean > (R)->next_to_use) ? 0 : (R)->count) + \
> > >  	      (R)->next_to_clean - (R)->next_to_use - 1)
> > >  
> > > +#define ICE_RING_QUARTER(R) ((R)->count / 4)
> > 
> > I would use `>> 2` here just to show off :D
> 
> :)
> 
> 
> (...)
> 
> > 
> > > +
> > > +/**
> > > + * ice_alloc_rx_bufs_zc - allocate a number of Rx buffers
> > > + * @rx_ring: Rx ring
> > > + * @count: The number of buffers to allocate
> > > + *
> > > + * Wrapper for internal allocation routine; figure out how many tail
> > > + * bumps should take place based on the given threshold
> > > + *
> > > + * Returns true if all calls to internal alloc routine succeeded
> > > + */
> > > +bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
> > > +{
> > > +	u16 rx_thresh = ICE_RING_QUARTER(rx_ring);
> > > +	u16 batched, leftover, i, tail_bumps;
> > > +
> > > +	batched = count & ~(rx_thresh - 1);
> > 
> > The ring size can be a non power-of-two unfortunately, it is rather
> > aligned to just 32: [0]. So it can be e.g. 96 and the mask will
> > break then.
> 
> Ugh nice catch!
> 
> > You could use roundup_pow_of_two(ICE_RING_QUARTER(rx_ring)), but
> > might can be a little slower due to fls_long() (bitsearch) inside.
> > 
> > (I would generally prohibit non-pow-2 ring sizes at all from inside
> >  the Ethtool callbacks since it makes no sense to me :p)
> 
> Although user would some of the freedom it makes a lot of sense to me.
> Jesse, what's your view?

I decided to go with an approach that forbids xsk socket attachment when
ring length (either tx or rx) is not pow(2). Sending v4 with a separate
patch for that.

> 
> > 
> > Also, it's not recommended to open-code align-down since we got
> > the ALIGN_DOWN(value, pow_of_two_alignment) macro. The macro hell
> > inside expands to the same op you do in here.
> 
> ack I'll try to use existing macros.
> 
> > 
> > > +	tail_bumps = batched / rx_thresh;
> > > +	leftover = count & (rx_thresh - 1);
> > >  
> > > -	return count == nb_buffs;
> > > +	for (i = 0; i < tail_bumps; i++)
> > > +		if (!__ice_alloc_rx_bufs_zc(rx_ring, rx_thresh))
> > > +			return false;
> > > +	return __ice_alloc_rx_bufs_zc(rx_ring, leftover);
> > >  }
> > >  
> > >  /**
> > > -- 
> > > 2.33.1
> > 
> > [0] https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/intel/ice/ice_ethtool.c#L2729
> > 
> > Thanks,
> > Al
