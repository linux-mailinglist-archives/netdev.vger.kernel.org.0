Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497602F616D
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 14:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbhANNAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 08:00:54 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:45885 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbhANNAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 08:00:54 -0500
Date:   Thu, 14 Jan 2021 13:00:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610629209; bh=CR8dqUway7BaJmQALsLUM7lmcjpiRbLT0XH802LqrW8=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=OrCCv8SDrLlGjLaHNRrNbl/VRdd0qvBy5IiE9p97sitx4EaiVAPDzzNmEu94cBx7e
         IJVcoDkA0J+fM5z1tGzVpAvvzd2020PE5vK3wKwH0+kTrJOunGUIJGRMQV1duPS5af
         7gMLN2v17RsMzUkc7YpG7zAVWOE6FLyoMuowR2H/yv1Jcw31bNwHJYimFjWwmQVbmz
         DhufNgKiav2lZCAPtuvR6N15rSpsmRcvGIvfR95xyiq4OnCQ3fSKIEPEmcIo4GWLDt
         998HEPXoJwEgErEBfCmUdtkcHBpQ6PanBRT1j4kcHIDCzG2z+NeaDB+ByynysXTeSi
         6gO71fBXYdvfw==
To:     Dmitry Vyukov <dvyukov@google.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <edumazet@google.com>,
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
        LKML <linux-kernel@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v2 net-next 2/3] skbuff: (re)use NAPI skb cache on allocation path
Message-ID: <20210114125932.9594-1-alobakin@pm.me>
In-Reply-To: <CACT4Y+bcj_jBkUJhRMvo8kjB78WyoBtCH8+-L0tGkxuRpaO66Q@mail.gmail.com>
References: <20210113133523.39205-1-alobakin@pm.me> <20210113133635.39402-1-alobakin@pm.me> <20210113133635.39402-2-alobakin@pm.me> <CANn89i+azKGzpt4LrVVVCQdf82TLOC=dwUjA4NK3ziQHSKvtFw@mail.gmail.com> <20210114114046.7272-1-alobakin@pm.me> <CACT4Y+adbmvvbzFnzRZzmpdTipg7ye53uR6OrnU9_K030sfzzA@mail.gmail.com> <20210114124406.9049-1-alobakin@pm.me> <CACT4Y+bcj_jBkUJhRMvo8kjB78WyoBtCH8+-L0tGkxuRpaO66Q@mail.gmail.com>
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

From: Dmitry Vyukov <dvyukov@google.com>
Date: Thu, 14 Jan 2021 13:50:25 +0100

> On Thu, Jan 14, 2021 at 1:44 PM Alexander Lobakin <alobakin@pm.me> wrote:
>>
>> From: Dmitry Vyukov <dvyukov@google.com>
>> Date: Thu, 14 Jan 2021 12:47:31 +0100
>>
>>> On Thu, Jan 14, 2021 at 12:41 PM Alexander Lobakin <alobakin@pm.me> wro=
te:
>>>>
>>>> From: Eric Dumazet <edumazet@google.com>
>>>> Date: Wed, 13 Jan 2021 15:36:05 +0100
>>>>
>>>>> On Wed, Jan 13, 2021 at 2:37 PM Alexander Lobakin <alobakin@pm.me> wr=
ote:
>>>>>>
>>>>>> Instead of calling kmem_cache_alloc() every time when building a NAP=
I
>>>>>> skb, (re)use skbuff_heads from napi_alloc_cache.skb_cache. Previousl=
y
>>>>>> this cache was only used for bulk-freeing skbuff_heads consumed via
>>>>>> napi_consume_skb() or __kfree_skb_defer().
>>>>>>
>>>>>> Typical path is:
>>>>>>  - skb is queued for freeing from driver or stack, its skbuff_head
>>>>>>    goes into the cache instead of immediate freeing;
>>>>>>  - driver or stack requests NAPI skb allocation, an skbuff_head is
>>>>>>    taken from the cache instead of allocation.
>>>>>>
>>>>>> Corner cases:
>>>>>>  - if it's empty on skb allocation, bulk-allocate the first half;
>>>>>>  - if it's full on skb consuming, bulk-wipe the second half.
>>>>>>
>>>>>> Also try to balance its size after completing network softirqs
>>>>>> (__kfree_skb_flush()).
>>>>>
>>>>> I do not see the point of doing this rebalance (especially if we do n=
ot change
>>>>> its name describing its purpose more accurately).
>>>>>
>>>>> For moderate load, we will have a reduced bulk size (typically one or=
 two).
>>>>> Number of skbs in the cache is in [0, 64[ , there is really no risk o=
f
>>>>> letting skbs there for a long period of time.
>>>>> (32 * sizeof(sk_buff) =3D 8192)
>>>>> I would personally get rid of this function completely.
>>>>
>>>> When I had a cache of 128 entries, I had worse results without this
>>>> function. But seems like I forgot to retest when I switched to the
>>>> original size of 64.
>>>> I also thought about removing this function entirely, will test.
>>>>
>>>>> Also it seems you missed my KASAN support request ?
>>>>  I guess this is a matter of using kasan_unpoison_range(), we can ask =
for help.
>>>>
>>>> I saw your request, but don't see a reason for doing this.
>>>> We are not caching already freed skbuff_heads. They don't get
>>>> kmem_cache_freed before getting into local cache. KASAN poisons
>>>> them no earlier than at kmem_cache_free() (or did I miss someting?).
>>>> heads being cached just get rid of all references and at the moment
>>>> of dropping to the cache they are pretty the same as if they were
>>>> allocated.
>>>
>>> KASAN should not report false positives in this case.
>>> But I think Eric meant preventing false negatives. If we kmalloc 17
>>> bytes, KASAN will detect out-of-bounds accesses beyond these 17 bytes.
>>> But we put that data into 128-byte blocks, KASAN will miss
>>> out-of-bounds accesses beyond 17 bytes up to 128 bytes.
>>> The same holds for "logical" use-after-frees when object is free, but
>>> not freed into slab.
>>>
>>> An important custom cache should use annotations like
>>> kasan_poison_object_data/kasan_unpoison_range.
>>
>> As I understand, I should
>> kasan_poison_object_data(skbuff_head_cache, skb) and then
>> kasan_unpoison_range(skb, sizeof(*skb)) when putting it into the
>> cache?
>
> I think it's the other way around. It should be _un_poisoned when used.
> If it's fixed size, then unpoison_object_data should be a better fit:
> https://elixir.bootlin.com/linux/v5.11-rc3/source/mm/kasan/common.c#L253

Ah, I though of this too. But wouldn't there be a false-positive if
a poisoned skb hits kmem_cache_free_bulk(), not the allocation path?
We plan to use skb_cache for both reusing and bulk-freeing, and SLUB,
for example, might do writes into objects before freeing.
If it also should get unpoisoned before kmem_cache_free_bulk(), we'll
lose bulking as unpoisoning is performed per-object.

Al

