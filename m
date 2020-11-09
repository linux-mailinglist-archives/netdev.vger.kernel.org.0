Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8242AC595
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 20:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbgKIT4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 14:56:39 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:46820 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729432AbgKIT4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 14:56:38 -0500
X-Greylist: delayed 153943 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Nov 2020 14:56:36 EST
Date:   Mon, 09 Nov 2020 19:56:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604951795; bh=TshS9dbkRzzf0kdsqu1zguOjYxDLNBwypCqj78pG4o0=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=BtGYhwaikwC5UxzObPgBEocxhQ5cmBc74WzMPJhI5ueDLvtv/ATp6No1xDkDgzG9w
         24ITPp5TUL3iuDM/vMTKpNoz7dgmi98J9FjlzEMopFefx6xQvKgRnQegl5MLTLWG12
         zuAcLFZck6VoAxvHi3+VekVd4LRiozxFUwmSUtrrpNRqLPqFREeUEH2Vz5MJZl1ijw
         l7zYSo9CZnIoftwB0cdr9+zKWHRgr1Itv6yJqTgCMvb+UJwSdMgXaFfpwfs6DJuToG
         48Blf7dp7CEYvN4CpokAL5DDCPT3RKkRQUAAGPeRn/YUiUgX/wMPX4hbGny5EHl8J5
         D896Vi4r3Xx9w==
To:     Eric Dumazet <eric.dumazet@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v2 net] net: udp: fix Fast/frag0 UDP GRO
Message-ID: <zRWfuRum1HOWs39rVjuuM0g4TsAQFBJLx5TZgkzVVbc@cp3-web-024.plabs.ch>
In-Reply-To: <0a7af3fb-d1c4-bedf-4931-5f22f0481491@gmail.com>
References: <0eaG8xtbtKY1dEKCTKUBubGiC9QawGgB3tVZtNqVdY@cp4-web-030.plabs.ch> <d9d09931-8cd3-1eb6-673c-3ae5ebc3ee57@gmail.com> <Nc6hn1Qaui1C7hTlHl8CdsNV00CdlHtyjQYv36ZYA@cp4-web-040.plabs.ch> <0a7af3fb-d1c4-bedf-4931-5f22f0481491@gmail.com>
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

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 9 Nov 2020 20:29:03 +0100

> On 11/9/20 7:26 PM, Alexander Lobakin wrote:
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Date: Mon, 9 Nov 2020 18:37:36 +0100
>>=20
>>> On 11/9/20 5:56 PM, Alexander Lobakin wrote:
>>>> While testing UDP GSO fraglists forwarding through driver that uses
>>>> Fast GRO (via napi_gro_frags()), I was observing lots of out-of-order
>>>> iperf packets:
>>>>
>.
>>>>
>>>> Since v1 [1]:
>>>>  - added a NULL pointer check for "uh" as suggested by Willem.
>>>>
>>>> [1] https://lore.kernel.org/netdev/YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68=
ADZYvJI@cp4-web-034.plabs.ch
>>>>
>>>> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
>>>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>>>> ---
>>>>  net/ipv4/udp_offload.c | 7 ++++++-
>>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
>>>> index e67a66fbf27b..7f6bd221880a 100644
>>>> --- a/net/ipv4/udp_offload.c
>>>> +++ b/net/ipv4/udp_offload.c
>>>> @@ -366,13 +366,18 @@ static struct sk_buff *udp4_ufo_fragment(struct =
sk_buff *skb,
>>>>  static struct sk_buff *udp_gro_receive_segment(struct list_head *head=
,
>>>>  =09=09=09=09=09       struct sk_buff *skb)
>>>>  {
>>>> -=09struct udphdr *uh =3D udp_hdr(skb);
>>>> +=09struct udphdr *uh =3D udp_gro_udphdr(skb);
>>>>  =09struct sk_buff *pp =3D NULL;
>>>>  =09struct udphdr *uh2;
>>>>  =09struct sk_buff *p;
>>>>  =09unsigned int ulen;
>>>>  =09int ret =3D 0;
>>>>
>>>> +=09if (unlikely(!uh)) {
>>>
>>> How uh could be NULL here ?
>>>
>>> My understanding is that udp_gro_receive() is called
>>> only after udp4_gro_receive() or udp6_gro_receive()
>>> validated that udp_gro_udphdr(skb) was not NULL.
>>=20
>> Right, but only after udp{4,6}_lib_lookup_skb() in certain cases.
>> I don't know for sure if their logic can actually edit skb->data,
>> so it's better to check from my point of view.
>
> Not really. This would send a wrong signal to readers of this code.
>
> I do not think these functions can mess with GRO internals.
>
> This would be a nightmare, GRO is already way too complex.
>
> In fact these functions should use a const qualifier
> for their " struct sk_buff *skb" argument to prevent future bugs.

Agree, you're right. Lack of const qualifiers gave me a doubt that
these functions can't edit skbs. They really should use it if they
really can't.
I'll omit the check in v3.

> I will test and submit this patch :

That would be a very nice one, thanks.

> diff --git a/include/net/ip.h b/include/net/ip.h
> index 2d6b985d11ccaa75827b3a15ac3f898d7a193242..e20874059f826eb0f9e899aed=
556bfbc9c9d71e8 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -99,7 +99,7 @@ static inline void ipcm_init_sk(struct ipcm_cookie *ipc=
m,
>  #define PKTINFO_SKB_CB(skb) ((struct in_pktinfo *)((skb)->cb))
> =20
>  /* return enslaved device index if relevant */
> -static inline int inet_sdif(struct sk_buff *skb)
> +static inline int inet_sdif(const struct sk_buff *skb)
>  {
>  #if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
>         if (skb && ipv4_l3mdev_skb(IPCB(skb)->flags))
> diff --git a/include/net/udp.h b/include/net/udp.h
> index 295d52a73598277dc5071536f777d1a87e7df1d1..877832bed4713a011a514a2f6=
f522728c8c89e20 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -164,7 +164,7 @@ static inline void udp_csum_pull_header(struct sk_buf=
f *skb)
>         UDP_SKB_CB(skb)->cscov -=3D sizeof(struct udphdr);
>  }
> =20
> -typedef struct sock *(*udp_lookup_t)(struct sk_buff *skb, __be16 sport,
> +typedef struct sock *(*udp_lookup_t)(const struct sk_buff *skb, __be16 s=
port,
>                                      __be16 dport);
> =20
>  INDIRECT_CALLABLE_DECLARE(struct sk_buff *udp4_gro_receive(struct list_h=
ead *,
> @@ -313,7 +313,7 @@ struct sock *udp4_lib_lookup(struct net *net, __be32 =
saddr, __be16 sport,
>  struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr, __be16 spo=
rt,
>                                __be32 daddr, __be16 dport, int dif, int s=
dif,
>                                struct udp_table *tbl, struct sk_buff *skb=
);
> -struct sock *udp4_lib_lookup_skb(struct sk_buff *skb,
> +struct sock *udp4_lib_lookup_skb(const struct sk_buff *skb,
>                                  __be16 sport, __be16 dport);
>  struct sock *udp6_lib_lookup(struct net *net,
>                              const struct in6_addr *saddr, __be16 sport,
> @@ -324,7 +324,7 @@ struct sock *__udp6_lib_lookup(struct net *net,
>                                const struct in6_addr *daddr, __be16 dport=
,
>                                int dif, int sdif, struct udp_table *tbl,
>                                struct sk_buff *skb);
> -struct sock *udp6_lib_lookup_skb(struct sk_buff *skb,
> +struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
>                                  __be16 sport, __be16 dport);
> =20
>  /* UDP uses skb->dev_scratch to cache as much information as possible an=
d avoid
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 09f0a23d1a01741d335ce45f25fe70a4e00698c7..8b8dadfea6c9854e6bfaa0fab=
cb774db39976da3 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -541,7 +541,7 @@ static inline struct sock *__udp4_lib_lookup_skb(stru=
ct sk_buff *skb,
>                                  inet_sdif(skb), udptable, skb);
>  }
> =20
> -struct sock *udp4_lib_lookup_skb(struct sk_buff *skb,
> +struct sock *udp4_lib_lookup_skb(const struct sk_buff *skb,
>                                  __be16 sport, __be16 dport)
>  {
>         const struct iphdr *iph =3D ip_hdr(skb);
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 29d9691359b9c49ccb56a11f79e3658b1a76700d..adfe9ca6f516612b5aad6d6c6=
54c7da1dd56a50e 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -276,7 +276,7 @@ static struct sock *__udp6_lib_lookup_skb(struct sk_b=
uff *skb,
>                                  inet6_sdif(skb), udptable, skb);
>  }
> =20
> -struct sock *udp6_lib_lookup_skb(struct sk_buff *skb,
> +struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
>                                  __be16 sport, __be16 dport)
>  {
>         const struct ipv6hdr *iph =3D ipv6_hdr(skb);
>

Al

