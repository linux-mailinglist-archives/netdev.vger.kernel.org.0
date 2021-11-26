Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF04445F0A5
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 16:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378024AbhKZPaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 10:30:21 -0500
Received: from mga04.intel.com ([192.55.52.120]:57026 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350039AbhKZP2U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 10:28:20 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10180"; a="234409781"
X-IronPort-AV: E=Sophos;i="5.87,266,1631602800"; 
   d="scan'208";a="234409781"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 07:25:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,266,1631602800"; 
   d="scan'208";a="498435813"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga007.jf.intel.com with ESMTP; 26 Nov 2021 07:25:05 -0800
Date:   Fri, 26 Nov 2021 16:25:04 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        bjorn@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        bpf@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, magnus.karlsson@intel.com
Subject: Re: [Intel-wired-lan] [PATCH net-next 1/2] igc: AF_XDP zero-copy
 metadata adjust breaks SKBs on XDP_PASS
Message-ID: <YaD8UHOxHasBkqEW@boxer>
References: <163700856423.565980.10162564921347693758.stgit@firesoul>
 <163700858579.565980.15265721798644582439.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163700858579.565980.15265721798644582439.stgit@firesoul>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 09:36:25PM +0100, Jesper Dangaard Brouer wrote:
> Driver already implicitly supports XDP metadata access in AF_XDP
> zero-copy mode, as xsk_buff_pool's xp_alloc() naturally set xdp_buff
> data_meta equal data.
> 
> This works fine for XDP and AF_XDP, but if a BPF-prog adjust via
> bpf_xdp_adjust_meta() and choose to call XDP_PASS, then igc function
> igc_construct_skb_zc() will construct an invalid SKB packet. The
> function correctly include the xdp->data_meta area in the memcpy, but
> forgot to pull header to take metasize into account.
> 
> Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Great catch. Will take a look at other ZC enabled Intel drivers if they
are affected as well.

Thanks!

> ---
>  drivers/net/ethernet/intel/igc/igc_main.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 8e448288ee26..76b0a7311369 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -2448,8 +2448,10 @@ static struct sk_buff *igc_construct_skb_zc(struct igc_ring *ring,
>  
>  	skb_reserve(skb, xdp->data_meta - xdp->data_hard_start);
>  	memcpy(__skb_put(skb, totalsize), xdp->data_meta, totalsize);
> -	if (metasize)
> +	if (metasize) {
>  		skb_metadata_set(skb, metasize);
> +		__skb_pull(skb, metasize);
> +	}
>  
>  	return skb;
>  }
> 
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
