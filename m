Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277A92F6069
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 12:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbhANLmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 06:42:09 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:19607 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbhANLmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 06:42:09 -0500
Date:   Thu, 14 Jan 2021 11:41:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610624484; bh=2OqWEb6C3glb5DS0gtuvY2Ez4Mm+WE5SlZPF/lo+ZjM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=f92/aWuY/P97cX7aw6gO/Edb67oFN7B5LJlKgx2S+TrjopuLghtL9X3qk5R7Ug1aH
         bbqfx4lYPUY9E4bb/6432NIw5sx1Z5OyYVkTKIlchy9iJ7PbGCv/NBp0xYNNLEtUtV
         78pOGLycoSrbIAF/gmySKsNPMW0EEmT7L4jm2t/WYtqI6GcWGT2oLJ6n5MrbIBqHo0
         TCWM5twiR1I0He8VydyZC+QWMlM6laAFlYCheNLD3e1DTajDWCCRIeaQXBXoZ5/hFF
         90Rz0HPjqwSa57ZQ/Awa46MpzHHUMTB2vUyEQVz+pzHXgh95x2FX4HpaMucGA05zSJ
         PvogArlN27PPQ==
To:     Eric Dumazet <edumazet@google.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v2 net-next 2/3] skbuff: (re)use NAPI skb cache on allocation path
Message-ID: <20210114114046.7272-1-alobakin@pm.me>
In-Reply-To: <CANn89i+azKGzpt4LrVVVCQdf82TLOC=dwUjA4NK3ziQHSKvtFw@mail.gmail.com>
References: <20210113133523.39205-1-alobakin@pm.me> <20210113133635.39402-1-alobakin@pm.me> <20210113133635.39402-2-alobakin@pm.me> <CANn89i+azKGzpt4LrVVVCQdf82TLOC=dwUjA4NK3ziQHSKvtFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 13 Jan 2021 15:36:05 +0100

> On Wed, Jan 13, 2021 at 2:37 PM Alexander Lobakin <alobakin@pm.me> wrote:
>>
>> Instead of calling kmem_cache_alloc() every time when building a NAPI
>> skb, (re)use skbuff_heads from napi_alloc_cache.skb_cache. Previously
>> this cache was only used for bulk-freeing skbuff_heads consumed via
>> napi_consume_skb() or __kfree_skb_defer().
>>
>> Typical path is:
>>  - skb is queued for freeing from driver or stack, its skbuff_head
>>    goes into the cache instead of immediate freeing;
>>  - driver or stack requests NAPI skb allocation, an skbuff_head is
>>    taken from the cache instead of allocation.
>>
>> Corner cases:
>>  - if it's empty on skb allocation, bulk-allocate the first half;
>>  - if it's full on skb consuming, bulk-wipe the second half.
>>
>> Also try to balance its size after completing network softirqs
>> (__kfree_skb_flush()).
>
> I do not see the point of doing this rebalance (especially if we do not c=
hange
> its name describing its purpose more accurately).
>
> For moderate load, we will have a reduced bulk size (typically one or two=
).
> Number of skbs in the cache is in [0, 64[ , there is really no risk of
> letting skbs there for a long period of time.
> (32 * sizeof(sk_buff) =3D 8192)
> I would personally get rid of this function completely.

When I had a cache of 128 entries, I had worse results without this
function. But seems like I forgot to retest when I switched to the
original size of 64.
I also thought about removing this function entirely, will test.

> Also it seems you missed my KASAN support request ?
> I guess this is a matter of using kasan_unpoison_range(), we can ask for =
help.

I saw your request, but don't see a reason for doing this.
We are not caching already freed skbuff_heads. They don't get
kmem_cache_freed before getting into local cache. KASAN poisons
them no earlier than at kmem_cache_free() (or did I miss someting?).
heads being cached just get rid of all references and at the moment
of dropping to the cache they are pretty the same as if they were
allocated.

I also remind that only skbs that are caught by napi_consume_skb() or
__kfree_skb_defer() are getting into skb_cache, not every single one.

Regarding other emails:

1. NUMA awareness.

napi_alloc_cache is percpu, we're partly protected. The only thing
that might happen is that napi_consume_skb() can be called for skb
that was allocated at a distant node, and then it's requested by
napi_alloc_skb() (and there were no bulk-wipes between).
This can occur only if a NAPI polling cycle for cleaning up the
completion/send queue(s) is scheduled on a CPU that is far away
from the one(s) that clean(s) up the receive queue(s).
That is really very unlikely to be caught, but...

One of the ways to handle this is like (inside napi_skb_cache_get()):

=09skb =3D nc->skb_cache[--nc->skb_count];
=09if (unlikely(pfn_to_nid(virt_to_pfn(skb)) !=3D numa_mem_id())) {
=09=09kmem_cache_free(skbuff_head_cache, skb);
=09=09skb =3D kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
=09}

=09return skb;

This whole condition will be optimized out on !CONFIG_NUMA, as
pfn_to_nid() and numa_mem_id() are compile-time 0 in this case.
This won't break currently present bulk-freeing.

2. Where do optimizations come from.

Not only from bulk allocations, but also from the shortcut:

napi_consume_skb()/__kfree_skb_defer() -> skb_cache -> napi_alloc_skb();

napi_alloc_skb() will get a new head directly without calling for MM
functions.
I'm aware that kmem_cache has its own cache, but this also applies to
page allocators etc. which doesn't prevent from having things like
page_frag_cache or page_pool to recycle pages and fragments directly,
not through MM layer.

>> prefetchw() on CONFIG_SLUB is dropped since it makes no sense anymore.
>>
>> Suggested-by: Edward Cree <ecree.xilinx@gmail.com>
>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>> ---
>>  net/core/skbuff.c | 54 ++++++++++++++++++++++++++++++-----------------
>>  1 file changed, 35 insertions(+), 19 deletions(-)
>>
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index dc3300dc2ac4..f42a3a04b918 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -364,6 +364,7 @@ struct sk_buff *build_skb_around(struct sk_buff *skb=
,
>>  EXPORT_SYMBOL(build_skb_around);
>>
>>  #define NAPI_SKB_CACHE_SIZE    64
>> +#define NAPI_SKB_CACHE_HALF    (NAPI_SKB_CACHE_SIZE / 2)
>>
>>  struct napi_alloc_cache {
>>         struct page_frag_cache page;
>> @@ -487,7 +488,15 @@ EXPORT_SYMBOL(__netdev_alloc_skb);
>>
>>  static struct sk_buff *napi_skb_cache_get(struct napi_alloc_cache *nc)
>>  {
>> -       return kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
>> +       if (unlikely(!nc->skb_count))
>> +               nc->skb_count =3D kmem_cache_alloc_bulk(skbuff_head_cach=
e,
>> +                                                     GFP_ATOMIC,
>> +                                                     NAPI_SKB_CACHE_HAL=
F,
>> +                                                     nc->skb_cache);
>> +       if (unlikely(!nc->skb_count))
>> +               return NULL;
>> +
>> +       return nc->skb_cache[--nc->skb_count];
>>  }
>>
>>  /**
>> @@ -867,40 +876,47 @@ void __consume_stateless_skb(struct sk_buff *skb)
>>  void __kfree_skb_flush(void)
>>  {
>>         struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
>> +       size_t count;
>> +       void **ptr;
>> +
>> +       if (unlikely(nc->skb_count =3D=3D NAPI_SKB_CACHE_HALF))
>> +               return;
>> +
>> +       if (nc->skb_count > NAPI_SKB_CACHE_HALF) {
>> +               count =3D nc->skb_count - NAPI_SKB_CACHE_HALF;
>> +               ptr =3D nc->skb_cache + NAPI_SKB_CACHE_HALF;
>>
>> -       /* flush skb_cache if containing objects */
>> -       if (nc->skb_count) {
>> -               kmem_cache_free_bulk(skbuff_head_cache, nc->skb_count,
>> -                                    nc->skb_cache);
>> -               nc->skb_count =3D 0;
>> +               kmem_cache_free_bulk(skbuff_head_cache, count, ptr);
>> +               nc->skb_count =3D NAPI_SKB_CACHE_HALF;
>> +       } else {
>> +               count =3D NAPI_SKB_CACHE_HALF - nc->skb_count;
>> +               ptr =3D nc->skb_cache + nc->skb_count;
>> +
>> +               nc->skb_count +=3D kmem_cache_alloc_bulk(skbuff_head_cac=
he,
>> +                                                      GFP_ATOMIC, count=
,
>> +                                                      ptr);
>>         }
>>  }
>>

Al

