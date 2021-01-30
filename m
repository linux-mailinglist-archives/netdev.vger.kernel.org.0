Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCFC309678
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 17:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhA3P6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 10:58:24 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:55217 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbhA3P4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 10:56:25 -0500
Date:   Sat, 30 Jan 2021 15:55:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612022132; bh=FggdhBVUsajUZNHPJ2/uHLJEmlhJc0ygmB55Y9M41h8=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=T/jIdyqw1mxnzW9/WPYrZoyzqI3xjjWHl5O7XcSBWxjVGIU0iJIlQrTEGFLrOB/7b
         3Ph7asMS7UnxIgQISBnvZmz0ZY+TY5HpOyxKpjaG9jarpweqryWjsxh8gOT8RBGrEB
         Nc0/CzSJ/xwliTf0TwJpZNRn+Wv8CPrAomQCO2W5mqVVSvcRPiSDS9LW2GfNhG8Yn9
         HAvjm4ZH5y88+7ELuWG8ltsMlat/d12gsolrOPH6J847+n9Dx6sieZTaeJtz7O4LUV
         zgZoZiJEuaVvIvXqFLP0a0EPNjKTnvNdtvkENgaaatD1mhZB1siM29nwwp4yT4hE+7
         uZe2SK5ZGsqqA==
To:     Dongseok Yi <dseok.yi@samsung.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        namkyu78.kim@samsung.com, Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [RESEND PATCH net v4] udp: ipv4: manipulate network header of NATed UDP GRO fraglist
Message-ID: <20210130155458.8523-1-alobakin@pm.me>
In-Reply-To: <1611962007-80092-1-git-send-email-dseok.yi@samsung.com>
References: <CGME20210129232630epcas2p1071e141ef8059c4d5c0e4b28c181a171@epcas2p1.samsung.com> <1611962007-80092-1-git-send-email-dseok.yi@samsung.com>
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

From: Dongseok Yi <dseok.yi@samsung.com>
Date: Sat, 30 Jan 2021 08:13:27 +0900

> UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> forwarding. Only the header of head_skb from ip_finish_output_gso ->
> skb_gso_segment is updated but following frag_skbs are not updated.
>=20
> A call path skb_mac_gso_segment -> inet_gso_segment ->
> udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> does not try to update UDP/IP header of the segment list but copy
> only the MAC header.
>=20
> Update port, addr and check of each skb of the segment list in
> __udp_gso_segment_list. It covers both SNAT and DNAT.
>=20
> Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---
> v1:
> Steffen Klassert said, there could be 2 options.
> https://lore.kernel.org/patchwork/patch/1362257/
> I was trying to write a quick fix, but it was not easy to forward
> segmented list. Currently, assuming DNAT only.
>=20
> v2:
> Per Steffen Klassert request, moved the procedure from
> udp4_ufo_fragment to __udp_gso_segment_list and support SNAT.
>=20
> v3:
> Per Steffen Klassert request, applied fast return by comparing seg
> and seg->next at the beginning of __udpv4_gso_segment_list_csum.
>=20
> Fixed uh->dest =3D *newport and iph->daddr =3D *newip to
> *oldport =3D *newport and *oldip =3D *newip.
>=20
> v4:
> Clear "Changes Requested" mark in
> https://patchwork.kernel.org/project/netdevbpf
>=20
> Simplified the return statement in __udp_gso_segment_list.
>=20
>  include/net/udp.h      |  2 +-
>  net/ipv4/udp_offload.c | 69 ++++++++++++++++++++++++++++++++++++++++++++=
++----
>  net/ipv6/udp_offload.c |  2 +-
>  3 files changed, 66 insertions(+), 7 deletions(-)
>=20
> diff --git a/include/net/udp.h b/include/net/udp.h
> index 877832b..01351ba 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -178,7 +178,7 @@ struct sk_buff *udp_gro_receive(struct list_head *hea=
d, struct sk_buff *skb,
>  int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup=
);
>=20
>  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> -=09=09=09=09  netdev_features_t features);
> +=09=09=09=09  netdev_features_t features, bool is_ipv6);
>=20
>  static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
>  {
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index ff39e94..cfc8726 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -187,8 +187,67 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buf=
f *skb,
>  }
>  EXPORT_SYMBOL(skb_udp_tunnel_segment);
>=20
> +static void __udpv4_gso_segment_csum(struct sk_buff *seg,
> +=09=09=09=09     __be32 *oldip, __be32 *newip,
> +=09=09=09=09     __be16 *oldport, __be16 *newport)
> +{
> +=09struct udphdr *uh;
> +=09struct iphdr *iph;
> +
> +=09if (*oldip =3D=3D *newip && *oldport =3D=3D *newport)
> +=09=09return;
> +
> +=09uh =3D udp_hdr(seg);
> +=09iph =3D ip_hdr(seg);
> +
> +=09if (uh->check) {
> +=09=09inet_proto_csum_replace4(&uh->check, seg, *oldip, *newip,
> +=09=09=09=09=09 true);
> +=09=09inet_proto_csum_replace2(&uh->check, seg, *oldport, *newport,
> +=09=09=09=09=09 false);
> +=09=09if (!uh->check)
> +=09=09=09uh->check =3D CSUM_MANGLED_0;
> +=09}
> +=09*oldport =3D *newport;
> +
> +=09csum_replace4(&iph->check, *oldip, *newip);
> +=09*oldip =3D *newip;
> +}
> +
> +static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *seg=
s)
> +{
> +=09struct sk_buff *seg;
> +=09struct udphdr *uh, *uh2;
> +=09struct iphdr *iph, *iph2;
> +
> +=09seg =3D segs;
> +=09uh =3D udp_hdr(seg);
> +=09iph =3D ip_hdr(seg);
> +
> +=09if ((udp_hdr(seg)->dest =3D=3D udp_hdr(seg->next)->dest) &&
> +=09    (udp_hdr(seg)->source =3D=3D udp_hdr(seg->next)->source) &&
> +=09    (ip_hdr(seg)->daddr =3D=3D ip_hdr(seg->next)->daddr) &&
> +=09    (ip_hdr(seg)->saddr =3D=3D ip_hdr(seg->next)->saddr))
> +=09=09return segs;
> +
> +=09while ((seg =3D seg->next)) {
> +=09=09uh2 =3D udp_hdr(seg);
> +=09=09iph2 =3D ip_hdr(seg);
> +
> +=09=09__udpv4_gso_segment_csum(seg,
> +=09=09=09=09=09 &iph2->saddr, &iph->saddr,
> +=09=09=09=09=09 &uh2->source, &uh->source);
> +=09=09__udpv4_gso_segment_csum(seg,
> +=09=09=09=09=09 &iph2->daddr, &iph->daddr,
> +=09=09=09=09=09 &uh2->dest, &uh->dest);
> +=09}
> +
> +=09return segs;
> +}
> +
>  static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
> -=09=09=09=09=09      netdev_features_t features)
> +=09=09=09=09=09      netdev_features_t features,
> +=09=09=09=09=09      bool is_ipv6)
>  {
>  =09unsigned int mss =3D skb_shinfo(skb)->gso_size;
>=20
> @@ -198,11 +257,11 @@ static struct sk_buff *__udp_gso_segment_list(struc=
t sk_buff *skb,
>=20
>  =09udp_hdr(skb)->len =3D htons(sizeof(struct udphdr) + mss);
>=20
> -=09return skb;
> +=09return is_ipv6 ? skb : __udpv4_gso_segment_list_csum(skb);

I don't think it's okay to fix checksums only for IPv4.
IPv6 checksum mangling doesn't depend on any code from net/ipv6. Just
use inet_proto_csum_replace16() for v6 addresses (see nf_nat_proto.c
for reference). You can guard the path for IPv6 with
IS_ENABLED(CONFIG_IPV6) to optimize IPv4-only systems a bit.

>  }
>=20
>  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> -=09=09=09=09  netdev_features_t features)
> +=09=09=09=09  netdev_features_t features, bool is_ipv6)
>  {
>  =09struct sock *sk =3D gso_skb->sk;
>  =09unsigned int sum_truesize =3D 0;
> @@ -214,7 +273,7 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso=
_skb,
>  =09__be16 newlen;
>=20
>  =09if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)
> -=09=09return __udp_gso_segment_list(gso_skb, features);
> +=09=09return __udp_gso_segment_list(gso_skb, features, is_ipv6);
>=20
>  =09mss =3D skb_shinfo(gso_skb)->gso_size;
>  =09if (gso_skb->len <=3D sizeof(*uh) + mss)
> @@ -328,7 +387,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_bu=
ff *skb,
>  =09=09goto out;
>=20
>  =09if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
> -=09=09return __udp_gso_segment(skb, features);
> +=09=09return __udp_gso_segment(skb, features, false);
>=20
>  =09mss =3D skb_shinfo(skb)->gso_size;
>  =09if (unlikely(skb->len <=3D mss))
> diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
> index c7bd7b1..faa823c 100644
> --- a/net/ipv6/udp_offload.c
> +++ b/net/ipv6/udp_offload.c
> @@ -42,7 +42,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff=
 *skb,
>  =09=09=09goto out;
>=20
>  =09=09if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
> -=09=09=09return __udp_gso_segment(skb, features);
> +=09=09=09return __udp_gso_segment(skb, features, true);
>=20
>  =09=09mss =3D skb_shinfo(skb)->gso_size;
>  =09=09if (unlikely(skb->len <=3D mss))
> --
> 2.7.4

Thanks,
Al

