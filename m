Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3FE46F203
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243063AbhLIRhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:37:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:43475 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231187AbhLIRhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 12:37:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639071227; x=1670607227;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OYyTJBH2NAkzB8yRuWaFmgipZaneXGsYztwNU9Ombj0=;
  b=RSBFNnqy5Mm8yhaymw/QkhTyMpsI+ICa5zqNq64KnX5FxLd/JaSWJS3B
   pbRW8SVArtlkGnq//N+4PYUsz5lc/jqjujoK9kFTNVKcaqcyr4G3ZhFVj
   xnJjLZW7WVs0u8+dW2zKNZcuCc4JdfRexfQlwURkSHTgy1WUdYK6n9MeY
   zzZB14RQnYzRK8WVQ7MseXDW3aoZhyMHy6g8VhPMbI2y6/MakkTt5rTj2
   6yG5kqHKTJNcb1SODQbYBOCXjP0kmBzYmeymZ0gx/l53mUeE1P7qLPjG+
   jrC+41K1UD3UywQ9P++Z5nF13Ms1E5fDY0hHwYGaakKrePqlQ7v8ZNryD
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10193"; a="262268638"
X-IronPort-AV: E=Sophos;i="5.88,193,1635231600"; 
   d="scan'208";a="262268638"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 09:33:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,193,1635231600"; 
   d="scan'208";a="658829667"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 09 Dec 2021 09:33:42 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1B9HXeqB013050;
        Thu, 9 Dec 2021 17:33:40 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        intel-wired-lan@lists.osuosl.org, brouer@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        KP Singh <kpsingh@kernel.org>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v4 net-next 1/9] i40e: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
Date:   Thu,  9 Dec 2021 18:33:07 +0100
Message-Id: <20211209173307.5003-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <da317f39-8679-96f7-ec6f-309216b02f33@redhat.com>
References: <20211208140702.642741-1-alexandr.lobakin@intel.com> <20211208140702.642741-2-alexandr.lobakin@intel.com> <da317f39-8679-96f7-ec6f-309216b02f33@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Thu, 9 Dec 2021 09:19:46 +0100

> On 08/12/2021 15.06, Alexander Lobakin wrote:
> > {__,}napi_alloc_skb() allocates and reserves additional NET_SKB_PAD
> > + NET_IP_ALIGN for any skb.
> > OTOH, i40e_construct_skb_zc() currently allocates and reserves
> > additional `xdp->data - xdp->data_hard_start`, which is
> > XDP_PACKET_HEADROOM for XSK frames.
> > There's no need for that at all as the frame is post-XDP and will
> > go only to the networking stack core.
> 
> I disagree with this assumption, that headroom is not needed by netstack.
> Why "no need for that at all" for netstack?

napi_alloc_skb() in our particular case will reserve 64 bytes, it is
sufficient for {TCP,UDP,SCTP,...}/IPv{4,6} etc.

> 
> Having headroom is important for netstack in general.  When packet will 
> grow we avoid realloc of SKB.  Use-case could also be cpumap or veth 
> redirect, or XDP-generic, that expect this headroom.

Well, those are not common cases at all.
Allocating 256 bytes more for some hypothetical usecases (and having
320 in total) is more expensive than expanding headroom in-place.
I don't know any other drivers or ifaces which reserve
XDP_PACKET_HEADROOM just for the case of using both driver-side
and generic XDP at the same time. To be more precise, I can't
remember any driver which would check whether generic XDP is enabled
for its netdev(s).

As a second option, I was trying to get exactly XDP_PACKET_HEADROOM
of headroom, but this involves either __alloc_skb() which is slower
than napi_alloc_skb(), or

	skb = napi_alloc_skb(napi, xdp->data_end -
				   xdp->data_hard_start -
				   NET_SKB_PAD);
	skb_reserve(skb, xdp->data_meta - xdp->data_hard_start -
			 NET_SKB_PAD);

Doesn't look good for me.

We could probably introduce a version of napi_alloc_skb() which
wouldn't reserve any headroom for you to have more control over it,
but that's more global material than these local fixes I'd say.

> 
> 
> > Pass the size of the actual data only to __napi_alloc_skb() and
> > don't reserve anything. This will give enough headroom for stack
> > processing.
> > 
> > Fixes: 0a714186d3c0 ("i40e: add AF_XDP zero-copy Rx support")
> > Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > ---
> >   drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 +---
> >   1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > index f08d19b8c554..9564906b7da8 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > @@ -245,13 +245,11 @@ static struct sk_buff *i40e_construct_skb_zc(struct i40e_ring *rx_ring,
> >   	struct sk_buff *skb;
> >   
> >   	/* allocate a skb to store the frags */
> > -	skb = __napi_alloc_skb(&rx_ring->q_vector->napi,
> > -			       xdp->data_end - xdp->data_hard_start,
> > +	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, datasize,
> >   			       GFP_ATOMIC | __GFP_NOWARN);
> >   	if (unlikely(!skb))
> >   		goto out;
> >   
> > -	skb_reserve(skb, xdp->data - xdp->data_hard_start);
> >   	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
> >   	if (metasize)
> >   		skb_metadata_set(skb, metasize);

Thanks,
Al
