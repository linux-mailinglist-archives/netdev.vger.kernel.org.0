Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248002AEF9E
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgKKL3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:29:23 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:64821 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgKKL3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:29:19 -0500
Date:   Wed, 11 Nov 2020 11:29:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1605094155; bh=/IYsfqM+6i0/P3VojMoPzsVDxxnM6kaR+EYsZVgANIw=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=D0y4Fhb8175ehc4Xk4DsWZaEjlToIBtAho8ZXVlL8jnX7hX0NlqiEFlGjH1DaoG+D
         kbSJoijIs2VdZz+qL2iRfmsuxMvXpS5X5fBERQyrWJCSze+eF17xYhh3RYuMCljL5V
         T1yBp1GSGQeAO4fgkSjeRUoiLJbRI4i4mOVusZAaGhOzd+kbgBKL6zMUFg5YjsN6Ns
         p28e6IrXwo7oCW0iUNgi/mes6uomvpBP8B2/7jjteTef8ZFGvwtxAnG+R8jMpFMkiQ
         bUj8eLNiXrs0w+sTAf6O93vY8dNZnd4Mn0PF+MUyn1QPt3t223h0Mbmz7A4vlxw7kd
         1a/629Dn6pS1w==
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v4 net] net: udp: fix Fast/frag0 UDP GRO
Message-ID: <zlsylwLJr9o9nP9fcmUnMBxSNs5tLc6rw2181IgE@cp7-web-041.plabs.ch>
In-Reply-To: <CA+FuTScriNKLu=q+xmBGjtBB06SbErZK26M+FPiJBRN-c8gVLw@mail.gmail.com>
References: <bEm19mEHLokLGc5HrEiEKEUgpZfmDYPoFtoLAAEnIUE@cp3-web-033.plabs.ch> <CA+FuTScriNKLu=q+xmBGjtBB06SbErZK26M+FPiJBRN-c8gVLw@mail.gmail.com>
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

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 10 Nov 2020 13:49:56 -0500

> On Mon, Nov 9, 2020 at 7:29 PM Alexander Lobakin <alobakin@pm.me> wrote:
>>
>> From: Alexander Lobakin <alobakin@pm.me>
>> Date: Tue, 10 Nov 2020 00:17:18 +0000
>>
>>> While testing UDP GSO fraglists forwarding through driver that uses
>>> Fast GRO (via napi_gro_frags()), I was observing lots of out-of-order
>>> iperf packets:
>>>
>>> [ ID] Interval           Transfer     Bitrate         Jitter
>>> [SUM]  0.0-40.0 sec  12106 datagrams received out-of-order
>>>
>>> Simple switch to napi_gro_receive() or any other method without frag0
>>> shortcut completely resolved them.
>>>
>>> I've found that UDP GRO uses udp_hdr(skb) in its .gro_receive()
>>> callback. While it's probably OK for non-frag0 paths (when all
>>> headers or even the entire frame are already in skb->data), this
>>> inline points to junk when using Fast GRO (napi_gro_frags() or
>>> napi_gro_receive() with only Ethernet header in skb->data and all
>>> the rest in shinfo->frags) and breaks GRO packet compilation and
>>> the packet flow itself.
>>> To support both modes, skb_gro_header_fast() + skb_gro_header_slow()
>>> are typically used. UDP even has an inline helper that makes use of
>>> them, udp_gro_udphdr(). Use that instead of troublemaking udp_hdr()
>>> to get rid of the out-of-order delivers.
>>>
>>> Present since the introduction of plain UDP GRO in 5.0-rc1.
>>>
>>> Since v3 [1]:
>>>  - restore the original {,__}udp{4,6}_lib_lookup_skb() and use
>>>    private versions of them inside GRO code (Willem).
>>
>> Note: this doesn't cover a support for nested tunnels as it's out of
>> the subject and requires more invasive changes. It will be handled
>> separately in net-next series.
>
> Thanks for looking into that.

Thank you (and Eric) for all your comments and reviews :)

> In that case, should the p->data + off change be deferred to that,
> too? It adds some risk unrelated to the bug fix.

Change to p->data + off is absolutely safe and even can prevent from
any other potentional problems with Fast/frag0 GRO of UDP fraglists.
I find them pretty fragile currently.

>>> Since v2 [2]:
>>>  - dropped redundant check introduced in v2 as it's performed right
>>>    before (thanks to Eric);
>>>  - udp_hdr() switched to data + off for skbs from list (also Eric);
>>>  - fixed possible malfunction of {,__}udp{4,6}_lib_lookup_skb() with
>>>    Fast/frag0 due to ip{,v6}_hdr() usage (Willem).
>>>
>>> Since v1 [3]:
>>>  - added a NULL pointer check for "uh" as suggested by Willem.
>>>
>>> [1] https://lore.kernel.org/netdev/MgZce9htmEtCtHg7pmWxXXfdhmQ6AHrnltXC=
41zOoo@cp7-web-042.plabs.ch
>>> [2] https://lore.kernel.org/netdev/0eaG8xtbtKY1dEKCTKUBubGiC9QawGgB3tVZ=
tNqVdY@cp4-web-030.plabs.ch
>>> [3] https://lore.kernel.org/netdev/YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68A=
DZYvJI@cp4-web-034.plabs.ch
>>>
>>> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
>>> Cc: Eric Dumazet <edumazet@google.com>
>>> Cc: Willem de Bruijn <willemb@google.com>
>>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>>> ---
>>>  net/ipv4/udp_offload.c | 23 +++++++++++++++++++----
>>>  net/ipv6/udp_offload.c | 14 +++++++++++++-
>>>  2 files changed, 32 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
>>> index e67a66fbf27b..6064efe17cdb 100644
>>> --- a/net/ipv4/udp_offload.c
>>> +++ b/net/ipv4/udp_offload.c
>>> @@ -366,11 +366,11 @@ static struct sk_buff *udp4_ufo_fragment(struct s=
k_buff *skb,
>>>  static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
>>>                                              struct sk_buff *skb)
>>>  {
>>> -     struct udphdr *uh =3D udp_hdr(skb);
>>> +     struct udphdr *uh =3D udp_gro_udphdr(skb);
>>>       struct sk_buff *pp =3D NULL;
>>>       struct udphdr *uh2;
>>>       struct sk_buff *p;
>>> -     unsigned int ulen;
>>> +     u32 ulen, off;
>
> a specific reason for changing type here?

Yep. unsigned int =3D=3D u32, I had to add another variable, and the
easiest way to do this without breaking reverse christmas tree or
adding new lines was this.
Pure cosmetics, I can change this if somebody doesn't like that one.

>>>       int ret =3D 0;
>>>
>>>       /* requires non zero csum, for symmetry with GSO */
>>> @@ -385,6 +385,9 @@ static struct sk_buff *udp_gro_receive_segment(stru=
ct list_head *head,
>>>               NAPI_GRO_CB(skb)->flush =3D 1;
>>>               return NULL;
>>>       }
>>> +
>>> +     off =3D skb_gro_offset(skb);
>>> +
>>>       /* pull encapsulating udp header */
>>>       skb_gro_pull(skb, sizeof(struct udphdr));
>>>
>>> @@ -392,7 +395,7 @@ static struct sk_buff *udp_gro_receive_segment(stru=
ct list_head *head,
>>>               if (!NAPI_GRO_CB(p)->same_flow)
>>>                       continue;
>>>
>>> -             uh2 =3D udp_hdr(p);
>>> +             uh2 =3D (void *)p->data + off;
>>>
>>>               /* Match ports only, as csum is always non zero */
>>>               if ((*(u32 *)&uh->source !=3D *(u32 *)&uh2->source)) {
>>> @@ -500,6 +503,16 @@ struct sk_buff *udp_gro_receive(struct list_head *=
head, struct sk_buff *skb,
>>>  }
>>>  EXPORT_SYMBOL(udp_gro_receive);
>>>
>>> +static struct sock *udp4_gro_lookup_skb(struct sk_buff *skb, __be16 sp=
ort,
>>> +                                     __be16 dport)
>>> +{
>>> +     const struct iphdr *iph =3D skb_gro_network_header(skb);
>>> +
>>> +     return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
>>> +                              iph->daddr, dport, inet_iif(skb),
>>> +                              inet_sdif(skb), &udp_table, NULL);
>>> +}
>>> +
>>>  INDIRECT_CALLABLE_SCOPE
>>>  struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buf=
f *skb)
>>>  {
>>> @@ -523,7 +536,9 @@ struct sk_buff *udp4_gro_receive(struct list_head *=
head, struct sk_buff *skb)
>>>  skip:
>>>       NAPI_GRO_CB(skb)->is_ipv6 =3D 0;
>>>       rcu_read_lock();
>>> -     sk =3D static_branch_unlikely(&udp_encap_needed_key) ? udp4_lib_l=
ookup_skb(skb, uh->source, uh->dest) : NULL;
>>> +     sk =3D static_branch_unlikely(&udp_encap_needed_key) ?
>>> +          udp4_gro_lookup_skb(skb, uh->source, uh->dest) :
>>> +          NULL;
>
> Does this indentation pass checkpatch?

Sure, I always check my changes with checkpatch --strict.

> Else, the line limit is no longer strict,a and this only shortens the
> line, so a single line is fine.

These single lines is about 120 chars, don't find them eye-pleasant.
But, as with "u32" above, they're pure cosmetics and can be changed.

Thanks,
Al

