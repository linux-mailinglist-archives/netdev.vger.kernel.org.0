Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F71A461A81
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345640AbhK2PBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 10:01:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:61839 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345390AbhK2O7v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 09:59:51 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10182"; a="259897689"
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="259897689"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 06:53:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="558829786"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 29 Nov 2021 06:53:07 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ATEr5m0005092;
        Mon, 29 Nov 2021 14:53:05 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>, brouer@redhat.com,
        bpf@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        intel-wired-lan@lists.osuosl.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] igc: enable XDP metadata in driver
Date:   Mon, 29 Nov 2021 15:53:03 +0100
Message-Id: <20211129145303.10507-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <6de05aea-9cf4-c938-eff2-9e3b138512a4@redhat.com>
References: <163700856423.565980.10162564921347693758.stgit@firesoul> <163700859087.565980.3578855072170209153.stgit@firesoul> <20211126161649.151100-1-alexandr.lobakin@intel.com> <6de05aea-9cf4-c938-eff2-9e3b138512a4@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Mon, 29 Nov 2021 15:39:04 +0100

> On 26/11/2021 17.16, Alexander Lobakin wrote:
> > From: Jesper Dangaard Brouer <brouer@redhat.com>
> > Date: Mon, 15 Nov 2021 21:36:30 +0100
> > 
> >> Enabling the XDP bpf_prog access to data_meta area is a very small
> >> change. Hint passing 'true' to xdp_prepare_buff().
> >>
> >> The SKB layers can also access data_meta area, which required more
> >> driver changes to support. Reviewers, notice the igc driver have two
> >> different functions that can create SKBs, depending on driver config.
> >>
> >> Hint for testers, ethtool priv-flags legacy-rx enables
> >> the function igc_construct_skb()
> >>
> >>   ethtool --set-priv-flags DEV legacy-rx on
> >>
> >> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >> ---
> >>   drivers/net/ethernet/intel/igc/igc_main.c |   29 +++++++++++++++++++----------
> >>   1 file changed, 19 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> >> index 76b0a7311369..b516f1b301b4 100644
> >> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> >> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> >> @@ -1718,24 +1718,26 @@ static void igc_add_rx_frag(struct igc_ring *rx_ring,
> >>   
> >>   static struct sk_buff *igc_build_skb(struct igc_ring *rx_ring,
> >>   				     struct igc_rx_buffer *rx_buffer,
> >> -				     union igc_adv_rx_desc *rx_desc,
> >> -				     unsigned int size)
> >> +				     struct xdp_buff *xdp)
> >>   {
> >> -	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
> >> +	unsigned int size = xdp->data_end - xdp->data;
> >>   	unsigned int truesize = igc_get_rx_frame_truesize(rx_ring, size);
> >> +	unsigned int metasize = xdp->data - xdp->data_meta;
> >>   	struct sk_buff *skb;
> >>   
> >>   	/* prefetch first cache line of first page */
> >> -	net_prefetch(va);
> >> +	net_prefetch(xdp->data);
> > 
> > I'd prefer prefetching xdp->data_meta here. GRO layer accesses it.
> > Maximum meta size for now is 32, so at least 96 bytes of the frame
> > will stil be prefetched.
> 
> Prefetch works for "full" cachelines. Intel CPUs often prefect two 
> cache-lines, when doing this, thus I guess we still get xdp->data.

Sure. I mean, net_prefetch() prefetches 128 bytes in a row.
xdp->data is usually aligned to XDP_PACKET_HEADROOM (or two bytes
to the right). If our CL is 64 and the meta is present, then... ah
right, 64 to the left and 64 starting from data to the right.

> I don't mind prefetching xdp->data_meta, but (1) I tried to keep the 
> change minimal as current behavior was data area I kept that. (2) 
> xdp->data starts on a cacheline and we know NIC hardware have touched 
> that, it is not a full-cache-miss due to DDIO/DCA it is known to be in 
> L3 cache (gain is around 2-3 ns in my machine for data prefetch).
> Given this is only a 2.5 Gbit/s driver/HW I doubt this make any difference.

Code constistency at least. On 10+ Gbps we prefetch meta, and I plan
to continue doing this in my series.

> Tony is it worth resending a V2 of this patch?

Tony, you can take it as it is if you want, I'll correct it later in
mine. Up to you.

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

> >>   
> >>   	/* build an skb around the page buffer */
> >> -	skb = build_skb(va - IGC_SKB_PAD, truesize);
> >> +	skb = build_skb(xdp->data_hard_start, truesize);
> >>   	if (unlikely(!skb))
> >>   		return NULL;
> >>   
> >>   	/* update pointers within the skb to store the data */
> >> -	skb_reserve(skb, IGC_SKB_PAD);
> >> +	skb_reserve(skb, xdp->data - xdp->data_hard_start);
> >>   	__skb_put(skb, size);
> >> +	if (metasize)
> >> +		skb_metadata_set(skb, metasize);
> >>   
> >>   	igc_rx_buffer_flip(rx_buffer, truesize);
> >>   	return skb;
> >> @@ -1746,6 +1748,7 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
> >>   					 struct xdp_buff *xdp,
> >>   					 ktime_t timestamp)
> >>   {
> >> +	unsigned int metasize = xdp->data - xdp->data_meta;
> >>   	unsigned int size = xdp->data_end - xdp->data;
> >>   	unsigned int truesize = igc_get_rx_frame_truesize(rx_ring, size);
> >>   	void *va = xdp->data;
> >> @@ -1756,7 +1759,7 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
> >>   	net_prefetch(va);
> > 
> > ...here as well.
> >

Thanks,
Al
