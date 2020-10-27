Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D56329CB91
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 22:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506341AbgJ0Vxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 17:53:51 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:43582 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2506297AbgJ0Vxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 17:53:51 -0400
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Oct 2020 17:53:49 EDT
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 05EFE2E1537;
        Wed, 28 Oct 2020 00:45:33 +0300 (MSK)
Received: from myt5-70c90f7d6d7d.qloud-c.yandex.net (myt5-70c90f7d6d7d.qloud-c.yandex.net [2a02:6b8:c12:3e2c:0:640:70c9:f7d])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id tApAeRQK9B-jWwGwDLj;
        Wed, 28 Oct 2020 00:45:32 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1603835132; bh=+SHNeKa3jXsZpC25WngBRFV9Essm8OS5w6UrCmGO1mo=;
        h=To:Message-Id:References:Date:Subject:Cc:From:In-Reply-To;
        b=adssUd1rewpfNLYEiYJsdWaV4JQa3H+vYLNFIJtBv+6HjIPcPkfzky3pLKm7wkCcY
         q8mkFGXh67LHXS8hbwdMp1AT3ZNQPaBzh7qmT7dMNTX9yoxkZ7bNhxjjhg4yx8G7sh
         l4yGNhv2JhcF/NnIDta5tXtKmLMgRTf/IqLC4W4M=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b080:6426::1:4])
        by myt5-70c90f7d6d7d.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id k9vX9l5I7v-ivmGw9gL;
        Wed, 28 Oct 2020 00:45:32 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH net] ip6_tunnel: set inner ipproto before ip6_tnl_encap.
From:   Alexander Ovechkin <ovov@yandex-team.ru>
In-Reply-To: <22adf1a4-9b8d-0502-a677-a812490e0f63@novek.ru>
Date:   Wed, 28 Oct 2020 00:45:32 +0300
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <25F92C95-1D1C-4C86-BAFC-08BD47F747EF@yandex-team.ru>
References: <20201016111156.26927-1-ovov@yandex-team.ru>
 <CA+FuTSe5szAPV0qDVU1Qa7e-XH6uO4eWELfzykOvpb0CJ0NbUA@mail.gmail.com>
 <22adf1a4-9b8d-0502-a677-a812490e0f63@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

But ip6_tnl_encap assigns to proto number of outer protocol (i.e. =3D
protocol that encapsulates our original packet). Setting inner_ipproto =3D=

to this value makes no sense.=3D20

For example in case of ipv6 inside MPLS inside fou6 encapsulation we =3D
have following packet structure:
+--------------+ <---+
|    ipv6      |     |
+--------------+     +- fou6-encap
|     udp      |     |
+--------------+ <---+
|     mpls     | <---   mpls-enacp
+--------------+ <---+
|  inner-ipv6  |     |
+--------------+     +- original packet
|     ...      |     |
+--------------+ <---+
After ip6_tnl_encap proto will be equal to IPPROTO_UDP, that is =3D
obviously is not inner ipproto.

Actually if pproto =3D3D=3D3D IPPROTO_MPLS than we have two layers of =3D
encapsulation and it is meaningless to set inner ipproto, cause =3D
currently there is no support for segmentation of packets with two =3D
layers of encapsulation.


> On 17 Oct 2020, at 03:59, Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>=20
> On 16.10.2020 18:55, Willem de Bruijn wrote:
>> On Fri, Oct 16, 2020 at 7:14 AM Alexander Ovechkin =
<ovov@yandex-team.ru> wrote:
>>> ip6_tnl_encap assigns to proto transport protocol which
>>> encapsulates inner packet, but we must pass to set_inner_ipproto
>>> protocol of that inner packet.
>>>=20
>>> Calling set_inner_ipproto after ip6_tnl_encap might break gso.
>>> For example, in case of encapsulating ipv6 packet in fou6 packet, =
inner_ipproto
>>> would be set to IPPROTO_UDP instead of IPPROTO_IPV6. This would lead =
to
>>> incorrect calling sequence of gso functions:
>>> ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> =
udp6_ufo_fragment
>>> instead of:
>>> ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> =
ip6ip6_gso_segment
>>>=20
>>> Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
>> Commit 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support") moved
>> the call from ip6_tnl_encap's caller to inside ip6_tnl_encap.
>>=20
>> It makes sense that that likely broke this behavior for UDP (L4) =
tunnels.
>>=20
>> But it was moved on purpose to avoid setting the inner protocol to
>> IPPROTO_MPLS. That needs to use skb->inner_protocol to further
>> segment.
>>=20
>> I suspect we need to set this before or after conditionally to avoid
>> breaking that use case.
> I hope it could be fixed with something like this:
>=20
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index a0217e5..87368b0 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -1121,6 +1121,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct =
net_device *dev, __u8 dsfield,
>         bool use_cache =3D false;
>         u8 hop_limit;
>         int err =3D -1;
> +       __u8 pproto =3D proto;
>=20
>         if (t->parms.collect_md) {
>                 hop_limit =3D skb_tunnel_info(skb)->key.ttl;
> @@ -1280,7 +1281,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct =
net_device *dev, __u8 dsfield,
>                 ipv6_push_frag_opts(skb, &opt.ops, &proto);
>         }
>=20
> -       skb_set_inner_ipproto(skb, proto);
> +       skb_set_inner_ipproto(skb, pproto =3D=3D IPPROTO_MPLS ? proto =
: pproto);
>=20
>         skb_push(skb, sizeof(struct ipv6hdr));
>         skb_reset_network_header(skb);
>=20

