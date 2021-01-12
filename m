Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10D62F38D8
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392395AbhALS1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:27:11 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:24719 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390350AbhALS1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 13:27:10 -0500
Date:   Tue, 12 Jan 2021 18:26:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610475986; bh=8n93bPOPZQTgDRmrlPkdqmVljXTeEe9OQ3MWPKXyrJI=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=PBzyz6k5GbGYVRRkn0uPUXUBtgqGvUCXdEZonPgRpVNdgFKHd0nbklw+1uZvoU8DS
         V8pK/x/9H6Gkh4C4IR3Ql+Yx497sVBWXnyQa6O11/hNu+uAL06u8rCrJOQFjSUil77
         NDPU8bJ5oRvWrG/g5bqTeNrifhZcVbN5MSarRKvveYKCS/wDDDdhsw6aSJ+wp4oVAo
         gH3wLBZh800jwgqrA2nEz1AYNohWr6/uljB72l8Dbzd/g9zq3R48Muqc7yF61UfJ8n
         fEfJ8qnN1u6ua2A+o0gXw5PRIyEcNu+ZOQhdbaT0xeALdi2ss4CqDXwEDFI3mz0Xpg
         +RgZ42r1OLRiQ==
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
Message-ID: <20210112182601.154198-1-alobakin@pm.me>
In-Reply-To: <CANn89i+2VC3ZH5_fyWZvJA_6QrJLzaSupusQ1rXe8CqVffCB1Q@mail.gmail.com>
References: <20210111182655.12159-1-alobakin@pm.me> <CANn89iKceTG_Mm4RrF+WVg-EEoFBD48gwpWX=GQiNdNnj2R8+A@mail.gmail.com> <20210112105529.3592-1-alobakin@pm.me> <CANn89i+2VC3ZH5_fyWZvJA_6QrJLzaSupusQ1rXe8CqVffCB1Q@mail.gmail.com>
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
Date: Tue, 12 Jan 2021 13:32:56 +0100

> On Tue, Jan 12, 2021 at 11:56 AM Alexander Lobakin <alobakin@pm.me> wrote=
:
>>
>
>>
>> Ah, I should've mentioned that I use UDP GRO Fraglists, so these
>> numbers are for GRO.
>>
>
> Right, this suggests UDP GRO fraglist is a pathological case of GRO,
> not saving memory.
>
> Real GRO (TCP in most cases) will consume one skb, and have page
> fragments for each segment.
>
> Having skbs linked together is not cache friendly.

OK, so I rebased test setup a bit to clarify the things out.

I disabled fraglists and GRO/GSO fraglists support advertisement
in driver to exclude any "pathological" cases and switched it
from napi_get_frags() + napi_gro_frags() to napi_alloc_skb() +
napi_gro_receive() to disable local skb reusing (napi_reuse_skb()).
I also enabled GSO UDP L4 ("classic" one: one skbuff_head + frags)
for forwarding, not only local traffic, and disabled NF flow offload
to increase CPU loading and drop performance below link speed so I
could see the changes.

So, the traffic flows looked like:
 - TCP GRO (one head + frags) -> NAT -> hardware TSO;
 - UDP GRO (one head + frags) -> NAT -> driver-side GSO.

Baseline 5.11-rc3:
 - 865 Mbps TCP, 866 Mbps UDP.

This patch (both separate caches and Edward's unified cache):
 - 899 Mbps TCP, 893 Mbps UDP.

So that's cleary *not* only "pathological" UDP GRO Fraglists
"problem" as TCP also got ~35 Mbps from this, as well as
non-fraglisted UDP.

Regarding latencies: I remember there were talks about latencies when
Edward introduced batched GRO (using linked lists to pass skbs from
GRO layer to core stack instead of passing one by one), so I think
it's a perennial question when it comes to batching/caching.

Thanks for the feedback, will post v2 soon.
The question about if this caching is reasonable isn't closed anyway,
but I don't see significant "cons" for now.

> So I would try first to make this case better, instead of trying to
> work around the real issue.

Al

