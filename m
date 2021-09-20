Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC93412785
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 22:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhITUx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 16:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231846AbhITUv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 16:51:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDD9B60F43;
        Mon, 20 Sep 2021 20:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632171029;
        bh=bONEndjEedaA0u5V5KJx3a8GV3Xu2o2PMB91E2TGRqw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=My1QwbafA51eSalK/srGdhyGeBzyhXnFMJn4U0YqhFCujUo1nXh00iLKgH9y5W/cq
         4RpgWs+cUbC3d1jp83ycjKLfz+FRT3SlCGsPEgl1NxIQDL9dcgwYzplEe4Hmu/dqDr
         fhQKSCfZTr51j5VCmZtsrxfNKBfdl9sXqVgjfrKh5km1R+MjCn97rTLJZlwI4ZEMEw
         ibXJckLxs2rCvz+WtrLeK6oqliPvAoIyMSP/oYC7TLp/GhL0NS10IuixpLQAZzf+gq
         ICfwXzQxrzk7iDFIUaGKtAqVlCPN4+0B/qwh5crQvN0DUGrejDpgLAknTiGLyeP+xv
         GZwkh39MCPYtA==
Date:   Mon, 20 Sep 2021 13:50:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kangmin Park <l4stpr0gr4m@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] Introducing lockless cache built on top of
 slab allocator
Message-ID: <20210920135027.5ec63a05@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210920174713.4998-1-l4stpr0gr4m@gmail.com>
References: <20210920174713.4998-1-l4stpr0gr4m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Sep 2021 02:47:13 +0900 Kangmin Park wrote:
> It is just introducing and proof of concept.
> The patch code is based on other RFC patches. So, the code is not
> correct yet, it is just simple proof of concept.
> 
> Recently block layer implemented percpu, lockless cache on the top
> of slab allocator. It can be used for IO polling.
> 
> Link: https://lwn.net/Articles/868070/
> Link: https://www.spinics.net/lists/linux-block/msg71964.html
> 
> It gained some IOPS increase (performance increased by about 10%
> on the block layer).
> 
> And there are attempts to implement the percpu, lockless cache.
> 
> Link: https://lore.kernel.org/linux-mm/20210920154816.31832-1-42.hyeyoo@gmail.com/T/#u
> 
> If this cache is implemented successfully,
> how about use this cache to allocate skb instead of kmem_cache_alloc_bulk()
> in napi_skb_cache_get()?
> 
> I want your comment/opinion.

Please take a look at skb cache in struct napi_alloc_cache.
That should be your target here.

> Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
> ---
>  net/core/skbuff.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 7c2ab27fcbf9..f9a9deca423d 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -170,11 +170,15 @@ static struct sk_buff *napi_skb_cache_get(void)
>  	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
>  	struct sk_buff *skb;
>  
> -	if (unlikely(!nc->skb_count))
> -		nc->skb_count = kmem_cache_alloc_bulk(skbuff_head_cache,
> -						      GFP_ATOMIC,
> -						      NAPI_SKB_CACHE_BULK,
> -						      nc->skb_cache);
> +	if (unlikely(!nc->skb_count)) {
> +		/* kmem_cache_alloc_cached should be changed to return the size of
> +		 * the allocated cache
> +		 */
> +		nc->skb_cache = kmem_cache_alloc_cached(skbuff_head_cache,
> +							GFP_ATOMIC | SLB_LOCKLESS_CACHE);
> +		nc->skb_count = this_cpu_ptr(skbuff_head_cache)->size;
> +	}
> +
>  	if (unlikely(!nc->skb_count))
>  		return NULL;
>  
