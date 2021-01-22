Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF77F300166
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 12:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbhAVLWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 06:22:06 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:36425 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728135AbhAVLUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 06:20:52 -0500
Date:   Fri, 22 Jan 2021 11:19:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611314395; bh=p7+8XjPhSmAbABVYbt84wqNdvpY3y5DtUEPQrJtgE7A=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=dsE44vL5poHC9QkDbiBO1M2JWyJqpO+Sou0Y3OUxPWZ4Kh4DtIUwsTHoq5cgKX+jt
         aHXOMkom6SoN1wG5FPsVAOgzdGG5DgKVszVdSugwA0/4CiG0hVqVOXncT42uSeueNi
         cIwFiAUIsXBqBzyDwxgKXA/fuuv4gUE5jgIJh66ddvvSLzErwlfXg4f2CCabHeWv3j
         13yHj2ogdozKAo8DDThnD/iVsqsGse3TX1LhcIQULOa4cpk/A2IRHb3+9IMEATuvg4
         I1zRH9KfpDV42DJL1Yn/bv0kvHQgWFQcGDrqIqV+hnyawhQEFWvOCvMHaBad5+0aB3
         esFB+ZMeXkC3Q==
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>,
        Meir Lichtinger <meirl@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next 2/2] udp: allow forwarding of plain (non-fraglisted) UDP GRO packets
Message-ID: <20210122111919.1973-1-alobakin@pm.me>
In-Reply-To: <CA+FuTSeZu6Z0eQ20Fwhr6DmraV1a90vMb1LQcwLxesD04LXGgw@mail.gmail.com>
References: <20210118193122.87271-1-alobakin@pm.me> <20210118193232.87583-1-alobakin@pm.me> <20210118193232.87583-2-alobakin@pm.me> <CA+FuTSeZu6Z0eQ20Fwhr6DmraV1a90vMb1LQcwLxesD04LXGgw@mail.gmail.com>
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
Date: Thu, 21 Jan 2021 21:47:47 -0500

> On Mon, Jan 18, 2021 at 2:33 PM Alexander Lobakin <alobakin@pm.me> wrote:
> >
> > Commit 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.") actually
> > not only added a support for fraglisted UDP GRO, but also tweaked
> > some logics the way that non-fraglisted UDP GRO started to work for
> > forwarding too.
> > Commit 2e4ef10f5850 ("net: add GSO UDP L4 and GSO fraglists to the
> > list of software-backed types") added GSO UDP L4 to the list of
> > software GSO to allow virtual netdevs to forward them as is up to
> > the real drivers.
> >
> > Tests showed that currently forwarding and NATing of plain UDP GRO
> > packets are performed fully correctly, regardless if the target
> > netdevice has a support for hardware/driver GSO UDP L4 or not.
> > Plain UDP GRO forwarding even shows better performance than fraglisted
> > UDP GRO in some cases due to not wasting one skbuff_head per every
> > segment.
>=20
> That is surprising. The choice for fraglist based forwarding was made
> on the assumption that it is cheaper if software segmentation is needed.
>=20
> Do you have a more specific definition of the relevant cases?

"Classic" UDP GRO shows better performance when forwarding to a NIC
that supports GSO UDP L4 (i.e. no software segmentation occurs), like
the one that I test kernel on.
I don't have much info about performance without UDP GSO offload
as I usually test NAT, and fralisted UDP GRO currently fails on
this [0].

> There currently is no option to enable GRO for forwarding, without
> fraglist if to a device with h/w udp segmentation offload. This would
> add that option too.

Yes, that's exactly what I want. I want to maximize UDP
forwarding/NATing performance when NIC is capable of UDP GSO offload,
as I said above, non-fraglisted UDP GRO is better for that case.

> Though under admin control, which may make it a rarely exercised option.
> Assuming most hosts to have single or homogeneous NICs, the OS should
> be able to choose the preferred option in most cases (e.g.,: use fraglist
> unless all devices support h/w gro).

I though about some sort of auto-selection, but at the moment of
receiving we can't know which interface this skb will be forwarded
to.
Also, as Paolo Abeni said in a comment to v2, UDP GRO may cause
sensible delays, which may be inacceptable in some environments.
That's why we have to use a sockopt and netdev features to explicitly
enable UDP GRO.

Regarding all this, I introduced NETIF_F_UDP_GRO to have the
following chose:
 - both NETIF_F_UDP_GRO and NETIF_F_GRO_FRAGLIST is off - no UDP GRO;
 - NETIF_F_UDP_GRO is on, NETIF_F_GRO_FRAGLIST is off - classic GRO;
 - both NETIF_F_UDP_GRO and NETIF_F_GRO_FRAGLIST is on - fraglisted
   UDP GRO.

> > Add the last element and allow to form plain UDP GRO packets if
> > there is no socket -> we are on forwarding path, and the new
> > NETIF_F_GRO_UDP is enabled on a receiving netdevice.
> > Note that fraglisted UDP GRO now also depends on this feature, as
>=20
> That may cause a regression for applications that currently enable
> that device feature.

Thought about this one too. Not sure if it would be better to leave
it as it is for now or how it's done in this series. The problem
that we may have in future is that in some day we may get fraglisted
TCP GRO, and then NETIF_F_GRO_FRAGLIST will affect both TCP and UDP,
which is not desirable as for me. So I decided to guard this possible
case.

> > NETIF_F_GRO_FRAGLIST isn't tied to any particular L4 protocol.
> >
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  net/ipv4/udp_offload.c | 16 +++++++++++-----
> >  1 file changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> > index ff39e94781bf..781a035de5a9 100644
> > --- a/net/ipv4/udp_offload.c
> > +++ b/net/ipv4/udp_offload.c
> > @@ -454,13 +454,19 @@ struct sk_buff *udp_gro_receive(struct list_head =
*head, struct sk_buff *skb,
> >         struct sk_buff *p;
> >         struct udphdr *uh2;
> >         unsigned int off =3D skb_gro_offset(skb);
> > -       int flush =3D 1;
> > +       int flist =3D 0, flush =3D 1;
> > +       bool gro_by_feat =3D false;
>=20
> What is this variable shorthand for? By feature? Perhaps
> gro_forwarding is more descriptive.

Yes, I chose "by feature" because fraglisted GRO also starts to
work for local traffic if enabled, so "gro_forwarding" would be
inaccurate naming.

> >
> > -       NAPI_GRO_CB(skb)->is_flist =3D 0;
> > -       if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
> > -               NAPI_GRO_CB(skb)->is_flist =3D sk ? !udp_sk(sk)->gro_en=
abled: 1;

I mean this. is_flist gets enabled if socket GRO option is disabled.

> > +       if (skb->dev->features & NETIF_F_GRO_UDP) {
> > +               if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
> > +                       flist =3D !sk || !udp_sk(sk)->gro_enabled;
> >
> > -       if ((sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_fli=
st) {
>=20
> I would almost rename NETIF_F_GRO_FRAGLIST to NETIF_F_UDP_GRO_FWD.
> Then this could be a !NETIF_F_UDP_GRO_FWD_FRAGLIST toggle on top of
> that. If it wasn't for this fraglist option also enabling UDP GRO to
> local sockets if set.
>=20
> That is, if the performance difference is significant enough to
> require supporting both types of forwarding, under admin control.
>=20
> Perhaps the simplest alternative is to add the new feature without
> making fraglist dependent on it:
>=20
>   if ((sk && udp_sk(sk)->gro_enabled) ||
>       (skb->dev->features & NETIF_F_GRO_FRAGLIST) ||
>       (!sk && skb->dev->features & NETIF_F_GRO_UDP_FWD))

Yep, this will be the exact code if we end up with that
NETIF_F_GRO_FRAGLIST should not depends on new netdev feature.
But again, I wanted to protect TCP GRO if fraglisted TCP GRO will
ever land the kernel. May be it's too much for the feature that
currently doesn't exists even as a draft or plan, not sure.

So, I'd stick to this variant (NETIF_F_UDP_GRO_FWD for plain,
NETIF_F_GRO_FRAGLIST without changes for fraglisted) if preferred.

> > +               gro_by_feat =3D !sk || flist;
> > +       }
> > +
> > +       NAPI_GRO_CB(skb)->is_flist =3D flist;
> > +
> > +       if (gro_by_feat || (sk && udp_sk(sk)->gro_enabled)) {
> >                 pp =3D call_gro_receive(udp_gro_receive_segment, head, =
skb);
> >                 return pp;
> >         }
> > --
> > 2.30.0

[0] https://lore.kernel.org/netdev/1611235479-39399-1-git-send-email-dseok.=
yi@samsung.com

Thanks,
Al

