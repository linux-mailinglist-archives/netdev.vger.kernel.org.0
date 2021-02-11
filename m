Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C40C318803
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhBKKUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:20:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32968 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229752AbhBKKS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:18:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613038620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c3Ljm0awQ77RfIdJrua69ytgN313pKfATqymCWD0wcM=;
        b=Bb0Zq63NLqc6ZBA8ikvF17aERJOiFNdoNDhme5TXOvYVXN+u1uHfhOtJUlmcnuxWNT1uXJ
        ZrDwlHbmbaIqZ7izttsyvp/1Ob03ZEgmpFIgTQqlOHtYnu+zKdHGTIVV9WicwZczhvo0st
        wLIBd0UW9PbRnn/pINBvSsxWg2AqNMM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-_uMP2sWxOSC1MDW_mXEhmw-1; Thu, 11 Feb 2021 05:16:58 -0500
X-MC-Unique: _uMP2sWxOSC1MDW_mXEhmw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4506100CCC2;
        Thu, 11 Feb 2021 10:16:54 +0000 (UTC)
Received: from ovpn-115-49.ams2.redhat.com (ovpn-115-49.ams2.redhat.com [10.36.115.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 564E62CF79;
        Thu, 11 Feb 2021 10:16:41 +0000 (UTC)
Message-ID: <58147c2d36ea7b6e0284d400229cd79185c53463.camel@redhat.com>
Subject: Re: [PATCH v4 net-next 09/11] skbuff: allow to optionally use NAPI
 cache from __alloc_skb()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yonghong Song <yhs@fb.com>, zhudi <zhudi21@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree.xilinx@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 11 Feb 2021 11:16:40 +0100
In-Reply-To: <20210210162732.80467-10-alobakin@pm.me>
References: <20210210162732.80467-1-alobakin@pm.me>
         <20210210162732.80467-10-alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-02-10 at 16:30 +0000, Alexander Lobakin wrote:
> Reuse the old and forgotten SKB_ALLOC_NAPI to add an option to get
> an skbuff_head from the NAPI cache instead of inplace allocation
> inside __alloc_skb().
> This implies that the function is called from softirq or BH-off
> context, not for allocating a clone or from a distant node.
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  net/core/skbuff.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 9e1a8ded4acc..750fa1825b28 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -397,15 +397,20 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>  	struct sk_buff *skb;
>  	u8 *data;
>  	bool pfmemalloc;
> +	bool clone;
>  
> -	cache = (flags & SKB_ALLOC_FCLONE)
> -		? skbuff_fclone_cache : skbuff_head_cache;
> +	clone = !!(flags & SKB_ALLOC_FCLONE);
> +	cache = clone ? skbuff_fclone_cache : skbuff_head_cache;
>  
>  	if (sk_memalloc_socks() && (flags & SKB_ALLOC_RX))
>  		gfp_mask |= __GFP_MEMALLOC;
>  
>  	/* Get the HEAD */
> -	skb = kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA, node);
> +	if (!clone && (flags & SKB_ALLOC_NAPI) &&
> +	    likely(node == NUMA_NO_NODE || node == numa_mem_id()))
> +		skb = napi_skb_cache_get();
> +	else
> +		skb = kmem_cache_alloc_node(cache, gfp_mask & ~GFP_DMA, node);
>  	if (unlikely(!skb))
>  		return NULL;
>  	prefetchw(skb);

I hope the opt-in thing would have allowed leaving this code unchanged.
I see it's not trivial avoid touching this code path.
Still I think it would be nice if you would be able to let the device
driver use the cache without touching the above, which is also used
e.g. by the TCP xmit path, which in turn will not leverage the cache
(as it requires FCLONE skbs).

If I read correctly, the above chunk is needed to
allow __napi_alloc_skb() access the cache even for small skb
allocation. Good device drivers should not call alloc_skb() in the fast
path.

What about changing __napi_alloc_skb() to always use
the __napi_build_skb(), for both kmalloc and page backed skbs? That is,
always doing the 'data' allocation in __napi_alloc_skb() - either via
page_frag or via kmalloc() - and than call __napi_build_skb().

I think that should avoid adding more checks in __alloc_skb() and
should probably reduce the number of conditional used
by __napi_alloc_skb().

Thanks!

Paolo

