Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375D73163B9
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhBJKZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:25:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39095 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231157AbhBJKWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 05:22:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612952486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FrRMQyNzbOonugall6MoIHltbjoyLBJFXBqHzB+D16g=;
        b=GciFz0p40S6gtoojLUB8IdKi2gEkZUNYeuss3ZROUob29ysAuho6MCGJ2VllAwkEyPKvJj
        yFyCdrz78EdGCTxuBfLWz24jyRXaNTe9lR3iViq0VvxNFAbOXaGRMQLjO2jehb3V97djPo
        6SmPmlCMG34cbLASOLCcg2ybWzhY3yQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-0X9mPebLMQazw4csxE2_RQ-1; Wed, 10 Feb 2021 05:21:24 -0500
X-MC-Unique: 0X9mPebLMQazw4csxE2_RQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F9A6814317;
        Wed, 10 Feb 2021 10:21:20 +0000 (UTC)
Received: from ovpn-115-79.ams2.redhat.com (ovpn-115-79.ams2.redhat.com [10.36.115.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D3B36F44E;
        Wed, 10 Feb 2021 10:21:07 +0000 (UTC)
Message-ID: <b6efe8d3a4ebf8188c040c5401b50b6c11b6eaf9.camel@redhat.com>
Subject: Re: [v3 net-next 08/10] skbuff: reuse NAPI skb cache on allocation
 path (__build_skb())
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Date:   Wed, 10 Feb 2021 11:21:06 +0100
In-Reply-To: <20210209204533.327360-9-alobakin@pm.me>
References: <20210209204533.327360-1-alobakin@pm.me>
         <20210209204533.327360-9-alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I'm sorry for the late feedback, I could not step-in before.

Also adding Jesper for awareness, as he introduced the bulk free
infrastructure.

On Tue, 2021-02-09 at 20:48 +0000, Alexander Lobakin wrote:
> @@ -231,7 +256,7 @@ struct sk_buff *__build_skb(void *data, unsigned int frag_size)
>   */
>  struct sk_buff *build_skb(void *data, unsigned int frag_size)
>  {
> -	struct sk_buff *skb = __build_skb(data, frag_size);
> +	struct sk_buff *skb = __build_skb(data, frag_size, true);

I must admit I'm a bit scared of this. There are several high speed
device drivers that will move to bulk allocation, and we don't have any
performance figure for them.

In my experience with (low end) MIPS board, cache misses cost tend to
be much less visible there compared to reasonably recent server H/W,
because the CPU/memory access time difference is much lower.

When moving to higher end H/W the performance gain you measured could
be completely countered by less optimal cache usage.

I fear also latency spikes - I'm unsure if a 32 skbs allocation vs a
single skb would be visible e.g. in a round-robin test. Generally
speaking bulk allocating 32 skbs looks a bit too much. IIRC, when
Edward added listification to GRO, he did several measures with
different list size and found 8 to be the optimal value (for the tested
workload). Above such number the list become too big and the pressure
on the cache outweighted the bulking benefits.

Perhaps giving the device drivers the ability to opt-in on this infra
via a new helper - as done back then with napi_consume_skb() - would
make this change safer?

> @@ -838,31 +863,31 @@ void __consume_stateless_skb(struct sk_buff *skb)
>  	kfree_skbmem(skb);
>  }
>  
> -static inline void _kfree_skb_defer(struct sk_buff *skb)
> +static void napi_skb_cache_put(struct sk_buff *skb)
>  {
>  	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
> +	u32 i;
>  
>  	/* drop skb->head and call any destructors for packet */
>  	skb_release_all(skb);
>  
> -	/* record skb to CPU local list */
> +	kasan_poison_object_data(skbuff_head_cache, skb);
>  	nc->skb_cache[nc->skb_count++] = skb;
>  
> -#ifdef CONFIG_SLUB
> -	/* SLUB writes into objects when freeing */
> -	prefetchw(skb);
> -#endif

It looks like this chunk has been lost. Is that intentional?

Thanks!

Paolo

