Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8CA2F533B
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbhAMTVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:21:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36680 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728560AbhAMTVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 14:21:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610565597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yRpBxJ30lYTsHSF3U2SYVlEielHK4+P3MGYhRxCt4Hg=;
        b=RdUnH3lYaPdz8GFY+Nc8/Endvf6rA1l0jh6UAsxNMy+mxKy7DmOgdHCN2iohMyjZSdWn9r
        N6tAX6T3n6hvQQf56738dMY0MCfyV/SlcXlTY5YFxRhVWstKVEzi82TuQWrlLXZKqhieCD
        tNLfyYIZ8aFXQ6QKLr3hAWxa73s8ipQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-3tPXaGoxOySiT2mBdex9gQ-1; Wed, 13 Jan 2021 14:19:55 -0500
X-MC-Unique: 3tPXaGoxOySiT2mBdex9gQ-1
Received: by mail-wm1-f70.google.com with SMTP id c2so1915708wme.0
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 11:19:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yRpBxJ30lYTsHSF3U2SYVlEielHK4+P3MGYhRxCt4Hg=;
        b=NDDcCnHQh97c9psgBwrePAPIH1IF7rQNYL4bvHyn3nqQ7IqIVoUTE+/3zhjV8Xqrat
         31Xg5+2wkxlCY2L13ZUiO7DwK1XglB9M4dOxYr6jEl/MdYMXHxX7+Hs8ewPtO+Dm15n+
         rgzQcb9Nb7oC0oacLWzYgbKM9uZyyVyaQlgOud0ri05tM8TckzVSwPYpskFy8pHIHcil
         KZ0RfwpUggdwrv70IqzhkSw2c6SlFueIVi3fl9pP9cGUimoMNbEQUj72u3/OcZ8k/7AD
         ot7ysVNNlPg7vlQxUKJRphXXPH/0i68eYNmlQFMLHHgpnahmq/xKowebObdsaGGtBa6t
         kILw==
X-Gm-Message-State: AOAM530BSp03IWIKdIkkuDdaRFDCxI82cZG2+MPDjxVjh8VNHSbHH4PA
        YP+8CHf6oIbGQHeonlTWhQ+BE6wcmCWUXOMzn2EkpgGkIbYtSZ7APQCsB08TVCcev1RA5zwiWLT
        hr4dlRFsp/7eLGHoT
X-Received: by 2002:a05:600c:2f97:: with SMTP id t23mr699121wmn.82.1610565594272;
        Wed, 13 Jan 2021 11:19:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw4gBVSzQYm3VQLJvlOnWgFrSyiYh5piugzX3bGlxjD2RFayIbDkqEqiROmSF/E/uW2jn6lhA==
X-Received: by 2002:a05:600c:2f97:: with SMTP id t23mr699113wmn.82.1610565594108;
        Wed, 13 Jan 2021 11:19:54 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id s13sm4225566wmj.28.2021.01.13.11.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 11:19:53 -0800 (PST)
Date:   Wed, 13 Jan 2021 14:19:50 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny
 skbs
Message-ID: <20210113141904-mutt-send-email-mst@kernel.org>
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113161819.1155526-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 08:18:19AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Both virtio net and napi_get_frags() allocate skbs
> with a very small skb->head
> 
> While using page fragments instead of a kmalloc backed skb->head might give
> a small performance improvement in some cases, there is a huge risk of
> under estimating memory usage.
> 
> For both GOOD_COPY_LEN and GRO_MAX_HEAD, we can fit at least 32 allocations
> per page (order-3 page in x86), or even 64 on PowerPC
> 
> We have been tracking OOM issues on GKE hosts hitting tcp_mem limits
> but consuming far more memory for TCP buffers than instructed in tcp_mem[2]
> 
> Even if we force napi_alloc_skb() to only use order-0 pages, the issue
> would still be there on arches with PAGE_SIZE >= 32768
> 
> This patch makes sure that small skb head are kmalloc backed, so that
> other objects in the slab page can be reused instead of being held as long
> as skbs are sitting in socket queues.
> 
> Note that we might in the future use the sk_buff napi cache,
> instead of going through a more expensive __alloc_skb()
> 
> Another idea would be to use separate page sizes depending
> on the allocated length (to never have more than 4 frags per page)
> 
> I would like to thank Greg Thelen for his precious help on this matter,
> analysing crash dumps is always a time consuming task.
> 
> Fixes: fd11a83dd363 ("net: Pull out core bits of __netdev_alloc_skb and add __napi_alloc_skb")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Alexander Duyck <alexanderduyck@fb.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Greg Thelen <gthelen@google.com>

Better than tweaking virtio code.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

I do hope the sk_buff napi cache idea materializes in the future.

> ---
>  net/core/skbuff.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 7626a33cce590e530f36167bd096026916131897..3a8f55a43e6964344df464a27b9b1faa0eb804f3 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -501,13 +501,17 @@ EXPORT_SYMBOL(__netdev_alloc_skb);
>  struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>  				 gfp_t gfp_mask)
>  {
> -	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
> +	struct napi_alloc_cache *nc;
>  	struct sk_buff *skb;
>  	void *data;
>  
>  	len += NET_SKB_PAD + NET_IP_ALIGN;
>  
> -	if ((len > SKB_WITH_OVERHEAD(PAGE_SIZE)) ||
> +	/* If requested length is either too small or too big,
> +	 * we use kmalloc() for skb->head allocation.
> +	 */
> +	if (len <= SKB_WITH_OVERHEAD(1024) ||
> +	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
>  	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
>  		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
>  		if (!skb)
> @@ -515,6 +519,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>  		goto skb_success;
>  	}
>  
> +	nc = this_cpu_ptr(&napi_alloc_cache);
>  	len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>  	len = SKB_DATA_ALIGN(len);
>  
> -- 
> 2.30.0.284.gd98b1dd5eaa7-goog

