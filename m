Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33992517DA
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 13:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgHYLhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 07:37:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:22609 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729910AbgHYLgB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 07:36:01 -0400
IronPort-SDR: a661DSWyEhKHz6f3Gr6hLZMfClRO02pxFZpHwyW4YepjlZjY25rTXBxZ3QAfuP+5dC2WK9MHZM
 lkf4YVnep2Eg==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="135636904"
X-IronPort-AV: E=Sophos;i="5.76,352,1592895600"; 
   d="scan'208";a="135636904"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 04:36:00 -0700
IronPort-SDR: JcfeAB+IY6BHvoLpUvmza9UT4NsM7eb3BOD25a9XPyxXKQuPbW+Ai8PkjSp0tidLhmWxCIgUGd
 FfnecQjUfEPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,352,1592895600"; 
   d="scan'208";a="294966479"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga003.jf.intel.com with ESMTP; 25 Aug 2020 04:35:58 -0700
Date:   Tue, 25 Aug 2020 13:29:53 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, piotr.raczynski@intel.com,
        maciej.machnikowski@intel.com, lirongqing@baidu.com
Subject: Re: [PATCH net 1/3] i40e: avoid premature Rx buffer reuse
Message-ID: <20200825112953.GB38865@ranger.igk.intel.com>
References: <20200825091629.12949-1-bjorn.topel@gmail.com>
 <20200825091629.12949-2-bjorn.topel@gmail.com>
 <20200825111336.GA38865@ranger.igk.intel.com>
 <256ab09e-1cea-c8ab-9589-b0c5809bdea7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <256ab09e-1cea-c8ab-9589-b0c5809bdea7@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 01:25:16PM +0200, Björn Töpel wrote:
> On 2020-08-25 13:13, Maciej Fijalkowski wrote:
> > On Tue, Aug 25, 2020 at 11:16:27AM +0200, Björn Töpel wrote:
> [...]
> > >   	struct i40e_rx_buffer *rx_buffer;
> > >   	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
> > > +	*rx_buffer_pgcnt = i40e_rx_buffer_page_count(rx_buffer);
> > 
> > What i previously meant was:
> > 
> > #if (PAGE_SIZE < 8192)
> > 	*rx_buffer_pgcnt = page_count(rx_buffer->page);
> > #endif
> > 
> > and see below
> > 
> 
> Right...
> 
> > >   	prefetchw(rx_buffer->page);
> > >   	/* we are reusing so sync this buffer for CPU use */
> > > @@ -2112,9 +2124,10 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
> > >    * either recycle the buffer or unmap it and free the associated resources.
> > >    */
> > >   static void i40e_put_rx_buffer(struct i40e_ring *rx_ring,
> > > -			       struct i40e_rx_buffer *rx_buffer)
> > > +			       struct i40e_rx_buffer *rx_buffer,
> > > +			       int rx_buffer_pgcnt)
> > >   {
> > > -	if (i40e_can_reuse_rx_page(rx_buffer)) {
> > > +	if (i40e_can_reuse_rx_page(rx_buffer, rx_buffer_pgcnt)) {
> > >   		/* hand second half of page back to the ring */
> > >   		i40e_reuse_rx_page(rx_ring, rx_buffer);
> > >   	} else {
> > > @@ -2319,6 +2332,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
> > >   	unsigned int xdp_xmit = 0;
> > >   	bool failure = false;
> > >   	struct xdp_buff xdp;
> > > +	int rx_buffer_pgcnt;
> > 
> > you could move scope this variable only for the
> > 
> > while (likely(total_rx_packets < (unsigned int)budget))
> > 
> > loop and init this to 0. then you could drop the helper function you've
> > added. and BTW the page_count is not being used for big pages but i agree
> > that it's better to have it set to 0.
> > 
> 
> ...but isn't it a bit nasty with an output parameter that relies on the that
> the input was set to zero. I guess it's a matter of taste, but I find that
> more error prone.
> 
> Let me know if you have strong feelings about this, and I'll respin (but I
> rather not!).

Up to you. No strong feelings, i just think that i40e_rx_buffer_page_count
is not needed. But if you want to keep it, then i was usually asking
people to provide the doxygen descriptions for newly introduced
functions... :P

but scoping it still makes sense to me, static analysis tools would agree
with me I guess.

> 
> 
> Björn
> 
> 
> > >   #if (PAGE_SIZE < 8192)
> > >   	xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, 0);
> > > @@ -2370,7 +2384,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
> > >   			break;
> > >   		i40e_trace(clean_rx_irq, rx_ring, rx_desc, skb);
> > > -		rx_buffer = i40e_get_rx_buffer(rx_ring, size);
> > > +		rx_buffer = i40e_get_rx_buffer(rx_ring, size, &rx_buffer_pgcnt);
> > >   		/* retrieve a buffer from the ring */
> > >   		if (!skb) {
> > > @@ -2413,7 +2427,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
> > >   			break;
> > >   		}
> > > -		i40e_put_rx_buffer(rx_ring, rx_buffer);
> > > +		i40e_put_rx_buffer(rx_ring, rx_buffer, rx_buffer_pgcnt);
> > >   		cleaned_count++;
> > >   		if (i40e_is_non_eop(rx_ring, rx_desc, skb))
> > > -- 
> > > 2.25.1
> > > 
