Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8D8316C97
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhBJR1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:27:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232193AbhBJR1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 12:27:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612977954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/cSe7sL5Ep1uG0oJAcv3xu7xrZMjqjN2Tp23S5V2S98=;
        b=NtepvGNPxlp3RmtKukk4QPETwDN8TERWWbWhOmTsxOJ2/iuMpB/5PSnLMNaqC+qZ4H4utL
        dxpBqoj60GlQwp/Nn2FN6fV5zUWueRXFsFTeOYeR7ckA2Es5SijlgVwoOBHsoniN+JD9Xj
        AZAzw6He+7Fo8o2HNTJmKStcGwFukQo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-F5KEm5BxMWCru53xB6q2fA-1; Wed, 10 Feb 2021 12:25:49 -0500
X-MC-Unique: F5KEm5BxMWCru53xB6q2fA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DAB4C7402;
        Wed, 10 Feb 2021 17:25:46 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 600A962688;
        Wed, 10 Feb 2021 17:25:27 +0000 (UTC)
Date:   Wed, 10 Feb 2021 18:25:26 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
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
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yonghong Song <yhs@fb.com>, zhudi <zhudi21@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Edward Cree <ecree.xilinx@gmail.com>, brouer@redhat.com,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [v3 net-next 08/10] skbuff: reuse NAPI skb cache on allocation
 path (__build_skb())
Message-ID: <20210210182526.3fd3c0ba@carbon>
In-Reply-To: <20210210122414.8064-1-alobakin@pm.me>
References: <20210209204533.327360-1-alobakin@pm.me>
        <20210209204533.327360-9-alobakin@pm.me>
        <b6efe8d3a4ebf8188c040c5401b50b6c11b6eaf9.camel@redhat.com>
        <20210210122414.8064-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Feb 2021 12:25:04 +0000
Alexander Lobakin <alobakin@pm.me> wrote:

> From: Paolo Abeni <pabeni@redhat.com>
> Date: Wed, 10 Feb 2021 11:21:06 +0100
> 
> > I'm sorry for the late feedback, I could not step-in before.
> > 
> > Also adding Jesper for awareness, as he introduced the bulk free
> > infrastructure.

Thanks (and Alexander Duyck also did part of the work while at Red Hat).

In my initial versions of my patchsets I actually also had reuse of the
SKBs that were defer freed during NAPI context.  But I dropped that
part because it was getting nitpicked and the merge window was getting
close, so I ended up dropping that part.



> > On Tue, 2021-02-09 at 20:48 +0000, Alexander Lobakin wrote:  
> > > @@ -231,7 +256,7 @@ struct sk_buff *__build_skb(void *data, unsigned int frag_size)
> > >   */
> > >  struct sk_buff *build_skb(void *data, unsigned int frag_size)
> > >  {
> > > -	struct sk_buff *skb = __build_skb(data, frag_size);
> > > +	struct sk_buff *skb = __build_skb(data, frag_size, true);  
> > 
> > I must admit I'm a bit scared of this. There are several high speed
> > device drivers that will move to bulk allocation, and we don't have any
> > performance figure for them.
> > 
> > In my experience with (low end) MIPS board, cache misses cost tend to
> > be much less visible there compared to reasonably recent server H/W,
> > because the CPU/memory access time difference is much lower.
> > 
> > When moving to higher end H/W the performance gain you measured could
> > be completely countered by less optimal cache usage.
> > 
> > I fear also latency spikes - I'm unsure if a 32 skbs allocation vs a
> > single skb would be visible e.g. in a round-robin test. Generally
> > speaking bulk allocating 32 skbs looks a bit too much. IIRC, when
> > Edward added listification to GRO, he did several measures with
> > different list size and found 8 to be the optimal value (for the tested
> > workload). Above such number the list become too big and the pressure
> > on the cache outweighted the bulking benefits.  
> 
> I can change to logics the way so it would allocate the first 8.
> I think I've already seen this batch value somewhere in XDP code,
> so this might be a balanced one.

(Speaking about SLUB code): Bulk ALLOC side disables interrupts, and
can call slow path (___slab_alloc), which is bad for latency sensitive
workloads.   This I don't recommend large bulk ALLOCATIONS.

> Regarding bulk-freeing: can the batch size make sense when freeing
> or it's okay to wipe 32 (currently 64 in baseline) in a row?

(Speaking about SLUB code):  You can bulk FREE large amount of object
without hurting latency sensitive workloads, because it doesn't disable
interrupts (I'm quite proud that this was possible).


> > Perhaps giving the device drivers the ability to opt-in on this infra
> > via a new helper - as done back then with napi_consume_skb() - would
> > make this change safer?  
> 
> That's actually a very nice idea. There's only a little in the code
> to change to introduce an ability to take heads from the cache
> optionally. This way developers could switch to it when needed.

Well, I actually disagree that this should be hidden behind a switch
for drivers to enable, as this will take forever to get proper enabled.



> Thanks for the suggestions! I'll definitely absorb them into the code
> and give it a test.
> 
> > > @@ -838,31 +863,31 @@ void __consume_stateless_skb(struct sk_buff *skb)
> > >  	kfree_skbmem(skb);
> > >  }
> > >
> > > -static inline void _kfree_skb_defer(struct sk_buff *skb)
> > > +static void napi_skb_cache_put(struct sk_buff *skb)
> > >  {
> > >  	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
> > > +	u32 i;
> > >
> > >  	/* drop skb->head and call any destructors for packet */
> > >  	skb_release_all(skb);
> > >
> > > -	/* record skb to CPU local list */
> > > +	kasan_poison_object_data(skbuff_head_cache, skb);
> > >  	nc->skb_cache[nc->skb_count++] = skb;
> > >
> > > -#ifdef CONFIG_SLUB
> > > -	/* SLUB writes into objects when freeing */
> > > -	prefetchw(skb);
> > > -#endif  
> > 
> > It looks like this chunk has been lost. Is that intentional?  
> 
> Yep. This prefetchw() assumed that skbuff_heads will be wiped
> immediately or at the end of network softirq. Reusing this cache
> means that heads can be reused later or may be kept in a cache for
> some time, so prefetching makes no sense anymore.

I agree with this statement, the prefetchw() is no-longer needed.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

