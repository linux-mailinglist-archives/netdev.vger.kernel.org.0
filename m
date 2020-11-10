Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F8D2AC9B0
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 01:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgKJA3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 19:29:11 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:35438 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgKJA3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 19:29:11 -0500
Date:   Tue, 10 Nov 2020 00:28:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604968147; bh=fSQAlvUTEs4aEfI5WfBwYKzQX+hp58gV6MgZfx8QXLw=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=PEpTQdI7YPfZ8GtN/VRx4MuCGBobR7/h/0zFwBw5Y9z3c6rbXn8rfU+LlIwnTydtE
         mUjy+AixSspuBlBkAcKGkuqLZJnFP/8FyCTURJ95u3znqZc1xFaqhz42X53KZLwl+s
         ZVjdylBOficXZL+iEuGdMW2wThhJwEkbRQUi12Pu8iWsdgVgX8lEdb3j0FbmY87sRV
         Ra5J8Un5+fRWSoFKDTR1nwgkNcDqc9r109vm19t7jus77e/CTr7zRAxhUm38K++GwA
         acxPbFsDl7++Y7SKKFFRLfvm8YoErAIvS8UEuY4zbcoSiXx+Bh7nY7qd9LN9TT6E3E
         BNtV4ZSxNvj+Q==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v4 net] net: udp: fix Fast/frag0 UDP GRO
Message-ID: <bEm19mEHLokLGc5HrEiEKEUgpZfmDYPoFtoLAAEnIUE@cp3-web-033.plabs.ch>
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

From: Alexander Lobakin <alobakin@pm.me>
Date: Tue, 10 Nov 2020 00:17:18 +0000

> While testing UDP GSO fraglists forwarding through driver that uses
> Fast GRO (via napi_gro_frags()), I was observing lots of out-of-order
> iperf packets:
>
> [ ID] Interval           Transfer     Bitrate         Jitter
> [SUM]  0.0-40.0 sec  12106 datagrams received out-of-order
>
> Simple switch to napi_gro_receive() or any other method without frag0
> shortcut completely resolved them.
>
> I've found that UDP GRO uses udp_hdr(skb) in its .gro_receive()
> callback. While it's probably OK for non-frag0 paths (when all
> headers or even the entire frame are already in skb->data), this
> inline points to junk when using Fast GRO (napi_gro_frags() or
> napi_gro_receive() with only Ethernet header in skb->data and all
> the rest in shinfo->frags) and breaks GRO packet compilation and
> the packet flow itself.
> To support both modes, skb_gro_header_fast() + skb_gro_header_slow()
> are typically used. UDP even has an inline helper that makes use of
> them, udp_gro_udphdr(). Use that instead of troublemaking udp_hdr()
> to get rid of the out-of-order delivers.
>
> Present since the introduction of plain UDP GRO in 5.0-rc1.
>
> Since v3 [1]:
>  - restore the original {,__}udp{4,6}_lib_lookup_skb() and use
>    private versions of them inside GRO code (Willem).

Note: this doesn't cover a support for nested tunnels as it's out of
the subject and requires more invasive changes. It will be handled
separately in net-next series.

> Since v2 [2]:
>  - dropped redundant check introduced in v2 as it's performed right
>    before (thanks to Eric);
>  - udp_hdr() switched to data + off for skbs from list (also Eric);
>  - fixed possible malfunction of {,__}udp{4,6}_lib_lookup_skb() with
>    Fast/frag0 due to ip{,v6}_hdr() usage (Willem).
>
> Since v1 [3]:
>  - added a NULL pointer check for "uh" as suggested by Willem.
>
> [1] https://lore.kernel.org/netdev/MgZce9htmEtCtHg7pmWxXXfdhmQ6AHrnltXC41=
zOoo@cp7-web-042.plabs.ch
> [2] https://lore.kernel.org/netdev/0eaG8xtbtKY1dEKCTKUBubGiC9QawGgB3tVZtN=
qVdY@cp4-web-030.plabs.ch
> [3] https://lore.kernel.org/netdev/YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68ADZ=
YvJI@cp4-web-034.plabs.ch
>
> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  net/ipv4/udp_offload.c | 23 +++++++++++++++++++----
>  net/ipv6/udp_offload.c | 14 +++++++++++++-
>  2 files changed, 32 insertions(+), 5 deletions(-)
>
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index e67a66fbf27b..6064efe17cdb 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -366,11 +366,11 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_=
buff *skb,
>  static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
>  =09=09=09=09=09       struct sk_buff *skb)
>  {
> -=09struct udphdr *uh =3D udp_hdr(skb);
> +=09struct udphdr *uh =3D udp_gro_udphdr(skb);
>  =09struct sk_buff *pp =3D NULL;
>  =09struct udphdr *uh2;
>  =09struct sk_buff *p;
> -=09unsigned int ulen;
> +=09u32 ulen, off;
>  =09int ret =3D 0;
>
>  =09/* requires non zero csum, for symmetry with GSO */
> @@ -385,6 +385,9 @@ static struct sk_buff *udp_gro_receive_segment(struct=
 list_head *head,
>  =09=09NAPI_GRO_CB(skb)->flush =3D 1;
>  =09=09return NULL;
>  =09}
> +
> +=09off =3D skb_gro_offset(skb);
> +
>  =09/* pull encapsulating udp header */
>  =09skb_gro_pull(skb, sizeof(struct udphdr));
>
> @@ -392,7 +395,7 @@ static struct sk_buff *udp_gro_receive_segment(struct=
 list_head *head,
>  =09=09if (!NAPI_GRO_CB(p)->same_flow)
>  =09=09=09continue;
>
> -=09=09uh2 =3D udp_hdr(p);
> +=09=09uh2 =3D (void *)p->data + off;
>
>  =09=09/* Match ports only, as csum is always non zero */
>  =09=09if ((*(u32 *)&uh->source !=3D *(u32 *)&uh2->source)) {
> @@ -500,6 +503,16 @@ struct sk_buff *udp_gro_receive(struct list_head *he=
ad, struct sk_buff *skb,
>  }
>  EXPORT_SYMBOL(udp_gro_receive);
>
> +static struct sock *udp4_gro_lookup_skb(struct sk_buff *skb, __be16 spor=
t,
> +=09=09=09=09=09__be16 dport)
> +{
> +=09const struct iphdr *iph =3D skb_gro_network_header(skb);
> +
> +=09return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
> +=09=09=09=09 iph->daddr, dport, inet_iif(skb),
> +=09=09=09=09 inet_sdif(skb), &udp_table, NULL);
> +}
> +
>  INDIRECT_CALLABLE_SCOPE
>  struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff =
*skb)
>  {
> @@ -523,7 +536,9 @@ struct sk_buff *udp4_gro_receive(struct list_head *he=
ad, struct sk_buff *skb)
>  skip:
>  =09NAPI_GRO_CB(skb)->is_ipv6 =3D 0;
>  =09rcu_read_lock();
> -=09sk =3D static_branch_unlikely(&udp_encap_needed_key) ? udp4_lib_looku=
p_skb(skb, uh->source, uh->dest) : NULL;
> +=09sk =3D static_branch_unlikely(&udp_encap_needed_key) ?
> +=09     udp4_gro_lookup_skb(skb, uh->source, uh->dest) :
> +=09     NULL;
>  =09pp =3D udp_gro_receive(head, skb, uh, sk);
>  =09rcu_read_unlock();
>  =09return pp;
> diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
> index 584157a07759..b126ab2120d9 100644
> --- a/net/ipv6/udp_offload.c
> +++ b/net/ipv6/udp_offload.c
> @@ -111,6 +111,16 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_b=
uff *skb,
>  =09return segs;
>  }
>
> +static struct sock *udp6_gro_lookup_skb(struct sk_buff *skb, __be16 spor=
t,
> +=09=09=09=09=09__be16 dport)
> +{
> +=09const struct ipv6hdr *iph =3D skb_gro_network_header(skb);
> +
> +=09return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
> +=09=09=09=09 &iph->daddr, dport, inet6_iif(skb),
> +=09=09=09=09 inet6_sdif(skb), &udp_table, NULL);
> +}
> +
>  INDIRECT_CALLABLE_SCOPE
>  struct sk_buff *udp6_gro_receive(struct list_head *head, struct sk_buff =
*skb)
>  {
> @@ -135,7 +145,9 @@ struct sk_buff *udp6_gro_receive(struct list_head *he=
ad, struct sk_buff *skb)
>  skip:
>  =09NAPI_GRO_CB(skb)->is_ipv6 =3D 1;
>  =09rcu_read_lock();
> -=09sk =3D static_branch_unlikely(&udpv6_encap_needed_key) ? udp6_lib_loo=
kup_skb(skb, uh->source, uh->dest) : NULL;
> +=09sk =3D static_branch_unlikely(&udpv6_encap_needed_key) ?
> +=09     udp6_gro_lookup_skb(skb, uh->source, uh->dest) :
> +=09     NULL;
>  =09pp =3D udp_gro_receive(head, skb, uh, sk);
>  =09rcu_read_unlock();
>  =09return pp;
> --
> 2.29.2

Al

