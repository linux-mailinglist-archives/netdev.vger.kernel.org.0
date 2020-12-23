Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240F32E212B
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgLWULw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:11:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728444AbgLWULw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 15:11:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27B09223E4;
        Wed, 23 Dec 2020 20:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608754271;
        bh=EEDhB1/RZds6D1bnPUvgChYVFG1ElLm+RDVB9ksbuwA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bGDZ/W1WwxjNZH+KrkdOtM2THvbNpr+oQlWMU4zBqGZutp/0kY/HnhYOAntcxE9hM
         DouODgDtoynA31hxVgSPfIiCnZx1Sea7ouFR1x1z9fUHzTLCa7nWTgCJuP6HlizX+E
         qvB3lsRdgo3KOENxI6NkZ0s89eg0TN4SJSmSpZuwPi6rFlQcTyK5YYRAfQNBpdHrTk
         coYN5ehjJ+CuG3Tv1YOdgD5/GuizgMcQL4WVL2oSa7fTsRMYR8FS76j6UiAOL3ZA8J
         YTQjH/EolXtrmp9vu9Z9DWJuBH9wuYnI2mMTWowa/bFeYAhEZZTRtcOEhIN+jNrcVu
         /RYW2WuwaN2Cg==
Date:   Wed, 23 Dec 2020 12:11:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v2 1/3] net: fix race conditions in xps by locking
 the maps and dev->tc_num
Message-ID: <20201223121110.65effe06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160875219353.1783433.8066935261216141538@kwain.local>
References: <20201221193644.1296933-1-atenart@kernel.org>
        <20201221193644.1296933-2-atenart@kernel.org>
        <CAKgT0UfTgYhED1f6vdsoT72A3=D2Grh4U-A6pp43FLZoCs30Gw@mail.gmail.com>
        <160862887909.1246462.8442420561350999328@kwain.local>
        <CAKgT0UfzNA8qk+QFTN6ihXTxZkcE=vfrjBtyHKL6_9Yyzxt=eQ@mail.gmail.com>
        <20201223102729.6463a5c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <160875219353.1783433.8066935261216141538@kwain.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Dec 2020 20:36:33 +0100 Antoine Tenart wrote:
> Quoting Jakub Kicinski (2020-12-23 19:27:29)
> > On Tue, 22 Dec 2020 08:12:28 -0800 Alexander Duyck wrote: =20
> > > On Tue, Dec 22, 2020 at 1:21 AM Antoine Tenart <atenart@kernel.org> w=
rote:
> > >  =20
> > > > If I understood correctly, as things are a bit too complex now, you
> > > > would prefer that we go for the solution proposed in v1?   =20
> > >=20
> > > Yeah, that is what I am thinking. Basically we just need to make sure
> > > the num_tc cannot be updated while we are reading the other values. =
=20
> >=20
> > Yeah, okay, as much as I dislike this approach 300 lines may be a little
> > too large for stable.
> >  =20
> > > > I can still do the code factoring for the 2 sysfs show operations, =
but
> > > > that would then target net-next and would be in a different series.=
 So I
> > > > believe we'll use the patches of v1, unmodified.   =20
> >=20
> > Are you saying just patch 3 for net-next? =20
>=20
> The idea would be to:
>=20
> - For net, to take all 4 patches from v1. If so, do I need to resend
>   them?

Yes, please.

> - For net-next, to resend patches 2 and 3 from v2 (they'll have to be
>   slightly reworked, to take into account the review from Alexander and
>   the rtnl lock). The patches can be sent once the ones for net land in
>   net-next.

If the direction is to remove xps_map_mutex, why would we need patch 2?
=F0=9F=A4=94

> > We need to do something about the fact that with sysfs taking
> > rtnl_lock xps_map_mutex is now entirely pointless. I guess its value
> > eroded over the years since Tom's initial design so we can just get
> > rid of it. =20
>=20
> We should be able to remove the mutex (I'll double check as more
> functions are involved). If so, I can send a patch to net-next.
