Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD34100A04
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 18:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfKRRPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 12:15:06 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49621 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbfKRRPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 12:15:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574097304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cEFa+BhhDnfifbgxrLCUxdKWBFPhPVGDVfBVaWu3bts=;
        b=cr/WMvXy8evOJ3vriusDPiwS62zud9BeGXAp0mkrlxdyWS1bbKpmsfQeRQu57nEk8pBuOi
        xnCut4TSNNX8irRpE4/agnaQO5S0PNPcCKIoR0mMBt9abijzjJTmlV1z1nEGRUX3rBRbRv
        ebW4AwVKFeOrD7aN+WzvUtN7jufXqmI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-GN7VDbmzOVq8UR3i10_eUA-1; Mon, 18 Nov 2019 12:15:00 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38C92108BD11;
        Mon, 18 Nov 2019 17:14:59 +0000 (UTC)
Received: from ovpn-117-52.ams2.redhat.com (ovpn-117-52.ams2.redhat.com [10.36.117.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17FC163625;
        Mon, 18 Nov 2019 17:14:57 +0000 (UTC)
Message-ID: <e61877a68ae2faa6aabed5f3d60fb2236a1df647.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] ipv4: use dst hint for ipv4 list receive
From:   Paolo Abeni <pabeni@redhat.com>
To:     Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 18 Nov 2019 18:14:57 +0100
In-Reply-To: <2853344436a97a9a0aaeea60ce11e544f74d2511.camel@redhat.com>
References: <cover.1573893340.git.pabeni@redhat.com>
         <5b7407edd15edaf912214ee62ea3d56d4b4e16b1.1573893340.git.pabeni@redhat.com>
         <2393b7ba-2f58-421d-ef9b-a6ccd3804907@solarflare.com>
         <2853344436a97a9a0aaeea60ce11e544f74d2511.camel@redhat.com>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: GN7VDbmzOVq8UR3i10_eUA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-11-18 at 17:44 +0100, Paolo Abeni wrote:
> On Mon, 2019-11-18 at 16:15 +0000, Edward Cree wrote:
> > @@ -538,6 +543,7 @@ static void ip_sublist_rcv_finish(struct list_head =
*head)
> > >  static void ip_list_rcv_finish(struct net *net, struct sock *sk,
> > >  =09=09=09       struct list_head *head)
> > >  {
> > > +=09struct ip_route_input_hint _hint, *hint =3D NULL;
> > >  =09struct dst_entry *curr_dst =3D NULL;
> > >  =09struct sk_buff *skb, *next;
> > >  =09struct list_head sublist;
> > > @@ -554,11 +560,24 @@ static void ip_list_rcv_finish(struct net *net,=
 struct sock *sk,
> > >  =09=09skb =3D l3mdev_ip_rcv(skb);
> > >  =09=09if (!skb)
> > >  =09=09=09continue;
> > > -=09=09if (ip_rcv_finish_core(net, sk, skb, dev) =3D=3D NET_RX_DROP)
> > > +=09=09if (ip_rcv_finish_core(net, sk, skb, dev, hint) =3D=3D NET_RX_=
DROP)
> > >  =09=09=09continue;
> > > =20
> > >  =09=09dst =3D skb_dst(skb);
> > >  =09=09if (curr_dst !=3D dst) {
> > > +=09=09=09struct rtable *rt =3D (struct rtable *)dst;
> > > +
> > > +=09=09=09if (!net->ipv4.fib_has_custom_rules &&
> > > +=09=09=09    rt->rt_type !=3D RTN_BROADCAST) {
> > > +=09=09=09=09_hint.refdst =3D skb->_skb_refdst;
> > > +=09=09=09=09_hint.daddr =3D ip_hdr(skb)->daddr;
> > > +=09=09=09=09_hint.tos =3D ip_hdr(skb)->tos;
> > > +=09=09=09=09_hint.local =3D rt->rt_type =3D=3D RTN_LOCAL;
> > > +=09=09=09=09hint =3D &_hint;
> > > +=09=09=09} else {
> > > +=09=09=09=09hint =3D NULL;
> > > +=09=09=09}
> > Perhaps factor this block out into a function?  Just because it's getti=
ng
> >  deeply indented and giving it a name would make it more obvious what i=
t's
> >  for.  hint =3D ipv4_extract_route_hint(skb, &_hint)?
>=20
> yep, I like the idea, will do in the next iteration.
> > > +
> > >  =09=09=09/* dispatch old sublist */
> > >  =09=09=09if (!list_empty(&sublist))
> > >  =09=09=09=09ip_sublist_rcv_finish(&sublist);
> > > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > > index dcc4fa10138d..b0ddff17db80 100644
> > > --- a/net/ipv4/route.c
> > > +++ b/net/ipv4/route.c
> > > @@ -2019,6 +2019,44 @@ static int ip_mkroute_input(struct sk_buff *sk=
b,
> > >  =09return __mkroute_input(skb, res, in_dev, daddr, saddr, tos);
> > >  }
> > > =20
> > > +/* Implements all the saddr-related checks as ip_route_input_slow(),
> > > + * assuming daddr is valid and this is not a local broadcast.
> > > + * Uses the provided hint instead of performing a route lookup.
> > > + */
> > > +int ip_route_use_hint(struct sk_buff *skb, __be32 daddr, __be32 sadd=
r,
> > > +=09=09      u8 tos, struct net_device *dev,
> > > +=09=09      struct ip_route_input_hint *hint)
> > Mostly I like the idea of these patches, but it bugs me that this seems
> >  to be reimplementing a little bit, and might get out of sync.  Is it
> >  possible to factor out the checks from ip_route_input_slow() and just
> >  call them here?
> > Otherwise maybe stick something in the comment to ip_route_input_slow()
> >  reminding to propagate changes to ip_route_use_hint()?
> >=20
> > Or perhaps better still would be to come up with a single function that
> >  always takes a hint, that may be NULL, in which case it performs norma=
l
> >  routing; and use that in all paths?  (Plumbing the hint through from
> >  ip_route_input_noref() etc.)
>=20
> I experimented a bit with the latter option before restricting to
> !RTN_BROADCAST, and it make the code quite uglier. Anyhow, preserving
> the !RTN_BROADCAST restriction for hint usage, I think it could work.
> Let me try that.

Uhm... all the other options lead to significant code uglification, so
unless someone has strong optinion against it, I would go for some
additional comment to ip_route_input_slow().

Cheers,

Paolo

