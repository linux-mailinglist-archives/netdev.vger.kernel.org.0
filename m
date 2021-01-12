Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E712F2D45
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 11:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbhALK5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 05:57:04 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:18630 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbhALK5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 05:57:03 -0500
Date:   Tue, 12 Jan 2021 10:56:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610448975; bh=o4WjqD8WRsgGX3zA0kQjiOkl+6TXdpW90sXH0o/3bao=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=mpXD/HtGnvzYArAWrxjXJJC6+7EgBZTl4SI5oarD8YmnknRdQ+vrY3gRp6AQdaUHY
         Eh8KFg8WnJg0Mpsv7OUGKokRP1CSj5arakiy47gN6YjJVgxPgUYNhFk76nJ5ykwUMG
         +6tjYUIvWEXzS9jmtf8MBVsc9KKYPJsy3wyznQxmH4YnuRSbmL7GjHUV5YhSORarh7
         JBfDQzq8jkWok3U67UA4H3b7aS+iZiCosw/h7oPNM0u32dSwJs5/KaFNG1pPDQJPXa
         sF46v1qJO0+OzKzC/IDGUFEhdGSesX6P0wMquQqx7/h5CVeyQaxkr4WHzdceuO86DU
         It+dsY+WdgkpA==
To:     Eric Dumazet <edumazet@google.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Edward Cree <ecree@solarflare.com>,
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
Subject: Re: [PATCH net-next 0/5] skbuff: introduce skbuff_heads bulking and reusing
Message-ID: <20210112105529.3592-1-alobakin@pm.me>
In-Reply-To: <CANn89iKceTG_Mm4RrF+WVg-EEoFBD48gwpWX=GQiNdNnj2R8+A@mail.gmail.com>
References: <20210111182655.12159-1-alobakin@pm.me> <CANn89iKceTG_Mm4RrF+WVg-EEoFBD48gwpWX=GQiNdNnj2R8+A@mail.gmail.com>
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
Date: Tue, 12 Jan 2021 09:20:39 +0100

> On Mon, Jan 11, 2021 at 7:27 PM Alexander Lobakin <alobakin@pm.me> wrote:
>>
>> Inspired by cpu_map_kthread_run() and _kfree_skb_defer() logics.
>>
>> Currently, all sorts of skb allocation always do allocate
>> skbuff_heads one by one via kmem_cache_alloc().
>> On the other hand, we have percpu napi_alloc_cache to store
>> skbuff_heads queued up for freeing and flush them by bulks.
>>
>> We can use this struct to cache and bulk not only freeing, but also
>> allocation of new skbuff_heads, as well as to reuse cached-to-free
>> heads instead of allocating the new ones.
>> As accessing napi_alloc_cache implies NAPI softirq context, do this
>> only for __napi_alloc_skb() and its derivatives (napi_alloc_skb()
>> and napi_get_frags()). The rough amount of their call sites are 69,
>> which is quite a number.
>>
>> iperf3 showed a nice bump from 910 to 935 Mbits while performing
>> UDP VLAN NAT on 1.2 GHz MIPS board. The boost is likely to be
>> way bigger on more powerful hosts and NICs with tens of Mpps.
>
> What is the latency cost of these bulk allocations, and for TCP traffic
> on which GRO is the norm ?
>
> Adding caches is increasing cache foot print when the cache is populated.
>
> I wonder if your iperf3 numbers are simply wrong because of lack of
> GRO in this UDP VLAN NAT case.

Ah, I should've mentioned that I use UDP GRO Fraglists, so these
numbers are for GRO.

My board gives full 1 Gbps (link speed) for TCP for more than a year,
so I can't really rely on TCP passthrough to measure the gains or
regressions.

> We are adding a log of additional code, thus icache pressure, that
> iperf3 tests can not really measure.

Not sure if MIPS arch can provide enough debug information to measure
icache pressure, but I'll try to catch this.

> Most linus devices simply handle one packet at a time (one packet per int=
errupt)

I disagree here, most modern NICs usually handle thousands of packets
per single interrupt due to NAPI, hardware interrupt moderation and so
on, at least in cases with high traffic load.

Al

