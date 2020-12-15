Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E892DAFFD
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 16:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgLOPYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 10:24:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:59801 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728109AbgLOPYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 10:24:02 -0500
IronPort-SDR: NQDnRwgL2P6GN2ObFnyGJzvxVMfMTtLOaSXnFkX/ltc9YLj8UGYz94mVkoVuyIeyAhk9LIPdxV
 WdTzrM8H9MXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="175036170"
X-IronPort-AV: E=Sophos;i="5.78,421,1599548400"; 
   d="scan'208";a="175036170"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 07:23:20 -0800
IronPort-SDR: Ao7SwFY8A+xjYZRBASPHQbX6HfgL/hyMtw8mAZp0A0zwiZlt2SK9pU7rdP0dD0t/Zfzv2rDCLg
 e8bH+fcSUrHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,421,1599548400"; 
   d="scan'208";a="337299264"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 15 Dec 2020 07:23:17 -0800
Date:   Tue, 15 Dec 2020 16:13:44 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, brouer@redhat.com, alexander.duyck@gmail.com,
        saeed@kernel.org
Subject: Re: [PATCH v3 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
Message-ID: <20201215151344.GA24650@ranger.igk.intel.com>
References: <cover.1607794551.git.lorenzo@kernel.org>
 <71d5ae9f810c2c80f1cb09e304330be0b5ce5345.1607794552.git.lorenzo@kernel.org>
 <20201215123643.GA23785@ranger.igk.intel.com>
 <20201215134710.GB5477@lore-desk>
 <6886cd02-8dec-1905-b878-d45ee9a0c9b4@iogearbox.net>
 <20201215150620.GC5477@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215150620.GC5477@lore-desk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 04:06:20PM +0100, Lorenzo Bianconi wrote:
> > On 12/15/20 2:47 PM, Lorenzo Bianconi wrote:
> > [...]
> > > > > diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> > > > > index 329397c60d84..61d3f5f8b7f3 100644
> > > > > --- a/drivers/net/xen-netfront.c
> > > > > +++ b/drivers/net/xen-netfront.c
> > > > > @@ -866,10 +866,8 @@ static u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
> > > > >   	xdp_init_buff(xdp, XEN_PAGE_SIZE - XDP_PACKET_HEADROOM,
> > > > >   		      &queue->xdp_rxq);
> > > > > -	xdp->data_hard_start = page_address(pdata);
> > > > > -	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
> > > > > +	xdp_prepare_buff(xdp, page_address(pdata), XDP_PACKET_HEADROOM, len);
> > > > >   	xdp_set_data_meta_invalid(xdp);
> > > > > -	xdp->data_end = xdp->data + len;
> > > > >   	act = bpf_prog_run_xdp(prog, xdp);
> > > > >   	switch (act) {
> > > > > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > > > > index 3fb3a9aa1b71..66d8a4b317a3 100644
> > > > > --- a/include/net/xdp.h
> > > > > +++ b/include/net/xdp.h
> > > > > @@ -83,6 +83,18 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
> > > > >   	xdp->rxq = rxq;
> > > > >   }
> > > > > +static inline void
> > 
> > nit: maybe __always_inline
> 
> ack, I will add in v4
> 
> > 
> > > > > +xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
> > > > > +		 int headroom, int data_len)
> > > > > +{
> > > > > +	unsigned char *data = hard_start + headroom;
> > > > > +
> > > > > +	xdp->data_hard_start = hard_start;
> > > > > +	xdp->data = data;
> > > > > +	xdp->data_end = data + data_len;
> > > > > +	xdp->data_meta = data;
> > > > > +}
> > > > > +
> > > > >   /* Reserve memory area at end-of data area.
> > > > >    *
> > 
> > For the drivers with xdp_set_data_meta_invalid(), we're basically setting xdp->data_meta
> > twice unless compiler is smart enough to optimize the first one away (did you double check?).
> > Given this is supposed to be a cleanup, why not integrate this logic as well so the
> > xdp_set_data_meta_invalid() doesn't get extra treatment?

That's what I was trying to say previously.

> 
> we discussed it before, but I am fine to add it in v4. Something like:
> 
> static __always_inline void
> xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
> 		 int headroom, int data_len, bool meta_valid)
> {
> 	unsigned char *data = hard_start + headroom;
> 	
> 	xdp->data_hard_start = hard_start;
> 	xdp->data = data;
> 	xdp->data_end = data + data_len;
> 	xdp->data_meta = meta_valid ? data : data + 1;

This will introduce branch, so for intel drivers we're getting the
overhead of one add and a branch. I'm still opting for a separate helper.

static __always_inline void
xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
		 int headroom, int data_len)
{
	unsigned char *data = hard_start + headroom;

	xdp->data_hard_start = hard_start;
	xdp->data = data;
	xdp->data_end = data + data_len;
	xdp_set_data_meta_invalid(xdp);
}

static __always_inline void
xdp_prepare_buff_meta(struct xdp_buff *xdp, unsigned char *hard_start,
		      int headroom, int data_len)
{
	unsigned char *data = hard_start + headroom;

	xdp->data_hard_start = hard_start;
	xdp->data = data;
	xdp->data_end = data + data_len;
	xdp->data_meta = data;
}

> }
> 
> Regards,
> Lorenzo
> 
> > 
> > Thanks,
> > Daniel
> > 


