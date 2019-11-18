Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A15E4100E7F
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfKRV6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:58:39 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53777 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726272AbfKRV6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 16:58:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574114317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DoTzpnG9k6dkRnqOjKpA34QnkGkoVn6pxeyuf+m37RY=;
        b=DAAYgoexI6dNVuCoWB0OCicnELujwCs0AIM1YMbQIS0jOffhhCBe9JS4uBd66FurDSt8tu
        bN27YhhZhVvM6KvU/rHeeVTJ77XqQi/7g5d+T8rpLiKtILPPdPywoGGOjroo9KVzTdvCgG
        l7o1d32/9riKGDDlrCkFU5nPuBidLak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-F6av5ThxM_aGY4buAAM1kw-1; Mon, 18 Nov 2019 16:58:34 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E49D21005500;
        Mon, 18 Nov 2019 21:58:32 +0000 (UTC)
Received: from ovpn-116-48.ams2.redhat.com (ovpn-116-48.ams2.redhat.com [10.36.116.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5A5B60560;
        Mon, 18 Nov 2019 21:58:31 +0000 (UTC)
Message-ID: <cb69bcc246e06a1a53287db571df1b98f82807d2.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/2] ipv6: introduce and uses route look
 hints for list input
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>
Date:   Mon, 18 Nov 2019 22:58:30 +0100
In-Reply-To: <CA+FuTSf_GL2gfGnDnZiVzHpjbV6+bw25Pi-FMNdUGH4np9=N3Q@mail.gmail.com>
References: <cover.1574071944.git.pabeni@redhat.com>
         <643f2b258e275e915fa96ef0c635f9c5ff804c9d.1574071944.git.pabeni@redhat.com>
         <CA+FuTSf_GL2gfGnDnZiVzHpjbV6+bw25Pi-FMNdUGH4np9=N3Q@mail.gmail.com>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: F6av5ThxM_aGY4buAAM1kw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-11-18 at 15:29 -0500, Willem de Bruijn wrote:
> On Mon, Nov 18, 2019 at 6:03 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > When doing RX batch packet processing, we currently always repeat
> > the route lookup for each ingress packet. If policy routing is
> > configured, and IPV6_SUBTREES is disabled at build time, we
> > know that packets with the same destination address will use
> > the same dst.
> >=20
> > This change tries to avoid per packet route lookup caching
> > the destination address of the latest successful lookup, and
> > reusing it for the next packet when the above conditions are
> > in place. Ingress traffic for most servers should fit.
> >=20
> > The measured performance delta under UDP flood vs a recvmmsg
> > receiver is as follow:
> >=20
> > vanilla         patched         delta
> > Kpps            Kpps            %
> > 1431            1664            +14
>=20
> Since IPv4 speed-up is almost half and code considerably more complex,
> maybe only do IPv6?

uhmm... I would avoid that kind of assimmetry, and I would not look
down on a 8% speedup, if possible.

> > In the worst-case scenario - each packet has a different
> > destination address - the performance delta is within noise
> > range.
> >=20
> > v1 -> v2:
> >  - fix build issue with !CONFIG_IPV6_MULTIPLE_TABLES
> >  - fix potential race when fib6_has_custom_rules is set
> >    while processing a packet batch
> >=20
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  net/ipv6/ip6_input.c | 40 ++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 36 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> > index ef7f707d9ae3..f559ad6b09ef 100644
> > --- a/net/ipv6/ip6_input.c
> > +++ b/net/ipv6/ip6_input.c
> > @@ -44,10 +44,16 @@
> >  #include <net/inet_ecn.h>
> >  #include <net/dst_metadata.h>
> >=20
> > +struct ip6_route_input_hint {
> > +       unsigned long   refdst;
> > +       struct in6_addr daddr;
> > +};
> > +
> >  INDIRECT_CALLABLE_DECLARE(void udp_v6_early_demux(struct sk_buff *));
> >  INDIRECT_CALLABLE_DECLARE(void tcp_v6_early_demux(struct sk_buff *));
> >  static void ip6_rcv_finish_core(struct net *net, struct sock *sk,
> > -                               struct sk_buff *skb)
> > +                               struct sk_buff *skb,
> > +                               struct ip6_route_input_hint *hint)
> >  {
> >         void (*edemux)(struct sk_buff *skb);
> >=20
> > @@ -59,7 +65,13 @@ static void ip6_rcv_finish_core(struct net *net, str=
uct sock *sk,
> >                         INDIRECT_CALL_2(edemux, tcp_v6_early_demux,
> >                                         udp_v6_early_demux, skb);
> >         }
> > -       if (!skb_valid_dst(skb))
> > +
> > +       if (skb_valid_dst(skb))
> > +               return;
> > +
> > +       if (hint && ipv6_addr_equal(&hint->daddr, &ipv6_hdr(skb)->daddr=
))
> > +               __skb_dst_copy(skb, hint->refdst);
> > +       else
> >                 ip6_route_input(skb);
>=20
> Is it possible to do the address comparison in ip6_list_rcv_finish
> itself and pass a pointer to refdst if safe? To avoid new struct
> definition, memcpy and to have all logic in one place. Need to
> keep a pointer to the prev skb, then, instead.

I haven't tought about that. Sounds promising. I'll try, thanks.

> >  static void ip6_list_rcv_finish(struct net *net, struct sock *sk,
> >                                 struct list_head *head)
> >  {
> > +       struct ip6_route_input_hint _hint, *hint =3D NULL;
> >         struct dst_entry *curr_dst =3D NULL;
> >         struct sk_buff *skb, *next;
> >         struct list_head sublist;
> > @@ -104,9 +127,18 @@ static void ip6_list_rcv_finish(struct net *net, s=
truct sock *sk,
> >                 skb =3D l3mdev_ip6_rcv(skb);
> >                 if (!skb)
> >                         continue;
> > -               ip6_rcv_finish_core(net, sk, skb);
> > +               ip6_rcv_finish_core(net, sk, skb, hint);
> >                 dst =3D skb_dst(skb);
> >                 if (curr_dst !=3D dst) {
> > +                       if (ip6_can_cache_route_hint(net)) {
> > +                               _hint.refdst =3D skb->_skb_refdst;
> > +                               memcpy(&_hint.daddr, &ipv6_hdr(skb)->da=
ddr,
> > +                                      sizeof(_hint.daddr));
> > +                               hint =3D &_hint;
> > +                       } else {
> > +                               hint =3D NULL;
> > +                       }
>=20
> not needed. ip6_can_cache_route_hit is the same for all iterations of
> the loop (indeed, compile time static), so if false, hint is never
> set.

I think this is needed, instead: if CONFIG_MULTIPLE_TABLES=3Dy,
fib6_has_custom_rules can change at runtime - from 'false' to 'true'.
If we don't reset 'hint', we could end-up with use-after-free.

Cheers,

Paolo



