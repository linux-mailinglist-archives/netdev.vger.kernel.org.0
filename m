Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A693A44E9
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 17:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhFKP1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 11:27:32 -0400
Received: from mga06.intel.com ([134.134.136.31]:48614 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231679AbhFKP1b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 11:27:31 -0400
IronPort-SDR: sWDJ07TzeUUCoa5rohlIjbOrclK6hObyjWKxfIE4kRRC0epM1JG2s/PcG2tilwjyoIpeqalLhv
 hbTw9XeLJSXQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10012"; a="266695236"
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="266695236"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 08:25:32 -0700
IronPort-SDR: ZqiQIQQUh0QmOX+Mf8/WNsTGQMXPGbeew8tTM/Y4GTULg5Q7y0eJUahjzJ+U3+MeiEINwhbV92
 YKcgMROJS5zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="553436010"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 11 Jun 2021 08:25:29 -0700
Date:   Fri, 11 Jun 2021 17:12:45 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        intel-wired-lan@lists.osuosl.org, bpf@vger.kernel.org
Subject: Re: [PATCH net] ixgbe: xsk: fix for metasize when construct skb by
 xdp_buff
Message-ID: <20210611151245.GA31289@ranger.igk.intel.com>
References: <20210609122244.52647-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609122244.52647-1-xuanzhuo@linux.alibaba.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 08:22:44PM +0800, Xuan Zhuo wrote:
> We should copy data_meta to the skb space.  Then use __skb_pull to
> correct skb->data

This looks like a bug that has been sitting over here for sometime. Have
you encountered this during your virtio-net's AF_XDP ZC work? I'm all ears
how you spotted this.

Anyway, other drivers needs such fixing too. Are you willing to do that or
should we take it on our side?

Magnus is OOO today, I'd like to get his final ack on that.

From me:
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Thanks!

> 
> Fixes: d0bcacd0a1309 ("ixgbe: add AF_XDP zero-copy Rx support")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> index f72d2978263b..ee88107fa57a 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -204,7 +204,7 @@ static struct sk_buff *ixgbe_construct_skb_zc(struct ixgbe_ring *rx_ring,
>  					      struct ixgbe_rx_buffer *bi)
>  {
>  	unsigned int metasize = bi->xdp->data - bi->xdp->data_meta;
> -	unsigned int datasize = bi->xdp->data_end - bi->xdp->data;
> +	unsigned int datasize = bi->xdp->data_end - bi->xdp->data_meta;
>  	struct sk_buff *skb;
>  
>  	/* allocate a skb to store the frags */
> @@ -214,10 +214,12 @@ static struct sk_buff *ixgbe_construct_skb_zc(struct ixgbe_ring *rx_ring,
>  	if (unlikely(!skb))
>  		return NULL;
>  
> -	skb_reserve(skb, bi->xdp->data - bi->xdp->data_hard_start);
> -	memcpy(__skb_put(skb, datasize), bi->xdp->data, datasize);
> -	if (metasize)
> +	skb_reserve(skb, bi->xdp->data_meta - bi->xdp->data_hard_start);
> +	memcpy(__skb_put(skb, datasize), bi->xdp->data_meta, datasize);
> +	if (metasize) {
> +		__skb_pull(skb, metasize);
>  		skb_metadata_set(skb, metasize);
> +	}
>  
>  	xsk_buff_free(bi->xdp);
>  	bi->xdp = NULL;
> -- 
> 2.31.0
> 
