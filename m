Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0AB2E217C
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgLWUf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:35:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728881AbgLWUf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 15:35:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C449224B0;
        Wed, 23 Dec 2020 20:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608755718;
        bh=UCJH7InqmImwQsTCi3QZMGca9XMMtC2oIW3MVNBPOa4=;
        h=In-Reply-To:References:To:From:Subject:Cc:Date:From;
        b=RoUtbEXRuRncI9kZRppMfYTit6lUILRuJqXU8VZGUVDB629rIEvxrwcIjd2TdgEbr
         xqoDesIFDQ48U69owy/yt45lNuDQCl3QXHprqoHQml7+vB12Z5Pihwd9JZZ/IQ8uJd
         frEqiutH2lk1l8Nj7xL13OnDjc9n916+OO6rNVMkW3dtsREOw7HLExKi5XugSjRYJ/
         63Fvagb4MLK7auIUr8rg3/UYNoR9oKll3carpRwGXSa78qyqZFWHfT3KS/IMdXErk+
         O+qc3ls1t8r0bLJ5SBVEAhJKFK9RZhschLD/JOj/WmfYGAa1gRYiusNRP/WRN/pxTb
         EY5UdTNJzJ/hg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201223121110.65effe06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201221193644.1296933-1-atenart@kernel.org> <20201221193644.1296933-2-atenart@kernel.org> <CAKgT0UfTgYhED1f6vdsoT72A3=D2Grh4U-A6pp43FLZoCs30Gw@mail.gmail.com> <160862887909.1246462.8442420561350999328@kwain.local> <CAKgT0UfzNA8qk+QFTN6ihXTxZkcE=vfrjBtyHKL6_9Yyzxt=eQ@mail.gmail.com> <20201223102729.6463a5c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <160875219353.1783433.8066935261216141538@kwain.local> <20201223121110.65effe06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net v2 1/3] net: fix race conditions in xps by locking the maps and dev->tc_num
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Message-ID: <160875571511.1783433.16922263997505181889@kwain.local>
Date:   Wed, 23 Dec 2020 21:35:15 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Jakub Kicinski (2020-12-23 21:11:10)
> On Wed, 23 Dec 2020 20:36:33 +0100 Antoine Tenart wrote:
> > Quoting Jakub Kicinski (2020-12-23 19:27:29)
> > > On Tue, 22 Dec 2020 08:12:28 -0800 Alexander Duyck wrote: =20
> > > > On Tue, Dec 22, 2020 at 1:21 AM Antoine Tenart <atenart@kernel.org>=
 wrote:
> > > >  =20
> > > > > If I understood correctly, as things are a bit too complex now, y=
ou
> > > > > would prefer that we go for the solution proposed in v1?   =20
> > > >=20
> > > > Yeah, that is what I am thinking. Basically we just need to make su=
re
> > > > the num_tc cannot be updated while we are reading the other values.=
 =20
> > >=20
> > > Yeah, okay, as much as I dislike this approach 300 lines may be a lit=
tle
> > > too large for stable.
> > >  =20
> > > > > I can still do the code factoring for the 2 sysfs show operations=
, but
> > > > > that would then target net-next and would be in a different serie=
s. So I
> > > > > believe we'll use the patches of v1, unmodified.   =20
> > >=20
> > > Are you saying just patch 3 for net-next? =20
> >=20
> > The idea would be to:
> >=20
> > - For net, to take all 4 patches from v1. If so, do I need to resend
> >   them?
>=20
> Yes, please.

Will do.

> > - For net-next, to resend patches 2 and 3 from v2 (they'll have to be
> >   slightly reworked, to take into account the review from Alexander and
> >   the rtnl lock). The patches can be sent once the ones for net land in
> >   net-next.
>=20
> If the direction is to remove xps_map_mutex, why would we need patch 2?
> =F0=9F=A4=94

Only the patches for net are needed to fix the race conditions.

In addition to use the xps_map mutex, patches 2 and 3 from v2 factorize
the code into a single function, as xps_cpus_show and xps_rxqs_show
share the same logic. That would improve maintainability, but isn't
mandatory.

Sorry, it was not very clear...

Antoine
