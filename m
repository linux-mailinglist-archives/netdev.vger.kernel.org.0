Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A6534624F
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 16:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbhCWPGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 11:06:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232629AbhCWPG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 11:06:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616511985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NJl1A50/fsLhyUa1P98rAwzX/DD+4S4HjS9dlvTWw3w=;
        b=biayTjxqlGozsqF9CsXnvSZ7eR/D3/kPcvfqiUCiNx0PtQ6GpsZ3qVWFua+gu8DZFgJGjb
        EXV5TPaiokun2pI1SnM85ulJseZNeasBTOEMhtr9JrPyFj1cDWCtEb0jBSrBmLSVCHtVqh
        nw7Zio5sdn6cJPlZXAp/Ga/33shPrrw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-xoO57pTLPF29FhvsQ_wpaQ-1; Tue, 23 Mar 2021 11:06:22 -0400
X-MC-Unique: xoO57pTLPF29FhvsQ_wpaQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00F12801817;
        Tue, 23 Mar 2021 15:06:20 +0000 (UTC)
Received: from carbon (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEB6B10074FC;
        Tue, 23 Mar 2021 15:06:13 +0000 (UTC)
Date:   Tue, 23 Mar 2021 16:06:11 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 6/6] mvneta: recycle buffers
Message-ID: <20210323160611.28ddc712@carbon>
In-Reply-To: <20210322170301.26017-7-mcroce@linux.microsoft.com>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com>
        <20210322170301.26017-7-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Mar 2021 18:03:01 +0100
Matteo Croce <mcroce@linux.microsoft.com> wrote:

> From: Matteo Croce <mcroce@microsoft.com>
> 
> Use the new recycling API for page_pool.
> In a drop rate test, the packet rate increased di 10%,
> from 269 Kpps to 296 Kpps.
> 
> perf top on a stock system shows:
> 
> Overhead  Shared Object     Symbol
>   21.78%  [kernel]          [k] __pi___inval_dcache_area
>   21.66%  [mvneta]          [k] mvneta_rx_swbm
>    7.00%  [kernel]          [k] kmem_cache_alloc
>    6.05%  [kernel]          [k] eth_type_trans
>    4.44%  [kernel]          [k] kmem_cache_free.part.0
>    3.80%  [kernel]          [k] __netif_receive_skb_core
>    3.68%  [kernel]          [k] dev_gro_receive
>    3.65%  [kernel]          [k] get_page_from_freelist
>    3.43%  [kernel]          [k] page_pool_release_page
>    3.35%  [kernel]          [k] free_unref_page
> 
> And this is the same output with recycling enabled:
> 
> Overhead  Shared Object     Symbol
>   24.10%  [kernel]          [k] __pi___inval_dcache_area
>   23.02%  [mvneta]          [k] mvneta_rx_swbm
>    7.19%  [kernel]          [k] kmem_cache_alloc
>    6.50%  [kernel]          [k] eth_type_trans
>    4.93%  [kernel]          [k] __netif_receive_skb_core
>    4.77%  [kernel]          [k] kmem_cache_free.part.0
>    3.93%  [kernel]          [k] dev_gro_receive
>    3.03%  [kernel]          [k] build_skb
>    2.91%  [kernel]          [k] page_pool_put_page
>    2.85%  [kernel]          [k] __xdp_return
> 
> The test was done with mausezahn on the TX side with 64 byte raw
> ethernet frames.
> 
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index a635cf84608a..8b3250394703 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2332,7 +2332,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  	if (!skb)
>  		return ERR_PTR(-ENOMEM);
>  
> -	page_pool_release_page(rxq->page_pool, virt_to_page(xdp->data));
> +	skb_mark_for_recycle(skb, virt_to_page(xdp->data), &xdp->rxq->mem);
>  
>  	skb_reserve(skb, xdp->data - xdp->data_hard_start);
>  	skb_put(skb, xdp->data_end - xdp->data);
> @@ -2344,7 +2344,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
>  				skb_frag_page(frag), skb_frag_off(frag),
>  				skb_frag_size(frag), PAGE_SIZE);
> -		page_pool_release_page(rxq->page_pool, skb_frag_page(frag));
> +		skb_mark_for_recycle(skb, skb_frag_page(frag), &xdp->rxq->mem);
>  	}
>  
>  	return skb;

This cause skb_mark_for_recycle() to set 'skb->pp_recycle=1' multiple
times, for the same SKB.  (copy-pasted function below signature to help
reviewers).

This makes me question if we need an API for setting this per page
fragment?
Or if the API skb_mark_for_recycle() need to walk the page fragments in
the SKB and set the info stored in the page for each?


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

