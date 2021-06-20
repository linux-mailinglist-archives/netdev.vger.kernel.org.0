Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDEC3ADE43
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 14:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhFTMOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 08:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229593AbhFTMOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Jun 2021 08:14:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25C0C610CD;
        Sun, 20 Jun 2021 12:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624191151;
        bh=fCHAeuY62HCyEnFWTFBLLX9Leqdy/+cyRrnEWu4P/6w=;
        h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
        b=ohQ7jMFZFgm91sJnzQnwitbUT2ewkpfn8r+mxBoIDGEfKv6nEoR6XgQBpZ6TMCQqu
         pOo74nDVapzzRdupi3t54SpT3D4KwTnBf3aSDlKlO2T/xWXnWXK+Cdkczd2XWNRNd9
         YB108fnQfVwvWVCUUqLl2CoPLQfMa8pMEjDEh+rCYrSAfVahM37Z3ug4G5WZncfIPf
         jrui53nptMXM3Q+sJDEZ/jYg+IJqy3FLsM78UsVxNPiT+6EIM4SR748LuDh36/axrZ
         BuU38+XYlAbjTLdCsO0WxyPwE1fxsHwSRTZcnYX2XzcDRADQahULKVT60X6oxNh3OL
         rWz7VnCg6ISLw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <16920ba3-57b7-3431-4667-9aaf0d7380af@gmail.com>
References: <20210618151553.59456-1-atenart@kernel.org> <16920ba3-57b7-3431-4667-9aaf0d7380af@gmail.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net] vrf: do not push non-ND strict packets with a source LLA through packet taps again
To:     David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, atenart@kernel.org
Message-ID: <162419114873.131954.7165131880961444756@kwain>
Date:   Sun, 20 Jun 2021 14:12:28 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting David Ahern (2021-06-19 03:18:50)
> On 6/18/21 9:15 AM, Antoine Tenart wrote:
> > --- a/drivers/net/vrf.c
> > +++ b/drivers/net/vrf.c
> > @@ -1366,22 +1366,22 @@ static struct sk_buff *vrf_ip6_rcv(struct net_d=
evice *vrf_dev,
> >       int orig_iif =3D skb->skb_iif;
> >       bool need_strict =3D rt6_need_strict(&ipv6_hdr(skb)->daddr);
> >       bool is_ndisc =3D ipv6_ndisc_frame(skb);
> > -     bool is_ll_src;
> > =20
> >       /* loopback, multicast & non-ND link-local traffic; do not push t=
hrough
> >        * packet taps again. Reset pkt_type for upper layers to process =
skb.
> > -      * for packets with lladdr src, however, skip so that the dst can=
 be
> > -      * determine at input using original ifindex in the case that dad=
dr
> > -      * needs strict
> > +      * For strict packets with a source LLA, determine the dst using =
the
> > +      * original ifindex.
> >        */
> > -     is_ll_src =3D ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_L=
INKLOCAL;
> > -     if (skb->pkt_type =3D=3D PACKET_LOOPBACK ||
> > -         (need_strict && !is_ndisc && !is_ll_src)) {
> > +     if (skb->pkt_type =3D=3D PACKET_LOOPBACK || (need_strict && !is_n=
disc)) {
> >               skb->dev =3D vrf_dev;
> >               skb->skb_iif =3D vrf_dev->ifindex;
> >               IP6CB(skb)->flags |=3D IP6SKB_L3SLAVE;
> > +
> >               if (skb->pkt_type =3D=3D PACKET_LOOPBACK)
> >                       skb->pkt_type =3D PACKET_HOST;
> > +             else if (ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADD=
R_LINKLOCAL)
> > +                     vrf_ip6_input_dst(skb, vrf_dev, orig_iif);
> > +
> >               goto out;
> >       }
>=20
> you are basically moving Stephen's is_ll_src within the need_strict and
> not ND.

That's right.

> Did you run the fcnal-test script and verify no change in test results?

Yes, I saw no regression, and the tests Stephen added were still OK.

Antoine
