Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1EAE149D12
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 22:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgAZVdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 16:33:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:54230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgAZVdz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 16:33:55 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09879206F0;
        Sun, 26 Jan 2020 21:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580074434;
        bh=aB4dshaGZIOZmEJpTM3f4wdbpn0Fa5nfbiqLJfYQvp8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nh9887DTP2TULWpD7rJx58h2IrDwnNlEcgd7OPaEGDwsTAXi6f7XdMPaN/LOPkLJ2
         TcT0FWyTRR6udkuJu9Tzb4gz/QCkADvTGdfYsB+0U9aOZnGMheLWB3q7LDQnDLj1P4
         CxoYSPy9J9hUcVM+zUvJ0zqPpt4KYSJGDDSPLr0o=
Date:   Sun, 26 Jan 2020 13:33:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Shannon Nelson <snelson@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200126133353.77f5cb7e@cakuba>
In-Reply-To: <20200126210850.GB3870@unreal>
References: <20200123130541.30473-1-leon@kernel.org>
        <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
        <20200126194110.GA3870@unreal>
        <20200126124957.78a31463@cakuba>
        <20200126210850.GB3870@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jan 2020 23:08:50 +0200, Leon Romanovsky wrote:
> On Sun, Jan 26, 2020 at 12:49:57PM -0800, Jakub Kicinski wrote:
> > On Sun, 26 Jan 2020 21:41:10 +0200, Leon Romanovsky wrote: =20
> > > > This will end up affecting out-of-tree drivers as well, where it is=
 useful
> > > > to know what the version number is, most especially since it is dif=
ferent
> > > > from what the kernel provided driver is.=C2=A0 How else are we to g=
et this
> > > > information out to the user?=C2=A0 If this feature gets squashed, w=
e'll end up
> > > > having to abuse some other mechanism so we can get the live informa=
tion from
> > > > the driver, and probably each vendor will find a different way to s=
neak it
> > > > out, giving us more chaos than where we started.=C2=A0 At least the=
 ethtool
> > > > version field is a known and consistent place for the version info.

> > Shannon does have a point that out of tree drivers still make use of
> > this field. Perhaps it would be a more suitable first step to print the
> > kernel version as default and add a comment saying upstream modules
> > shouldn't overwrite it (perhaps one day CI can catch new violators). =20
>=20
> Shannon proposed to remove this field and it was me who said no :)

Obviously, we can't remove fields from UAPI structs.

> My plan is to overwrite ->version, delete all users and add
> WARN_ONEC(strcpy(..->version_)...) inside net/ethtool/ to catch
> abusers.

What I was thinking just now was: initialize ->version to utsname
before drivers are called, delete all upstream users, add a coccicheck
for upstream drivers which try to report the version.

> > The NFP reports the git hash of the driver source plus the string
> > "(oot)" for out-of-tree:
> >
> > https://github.com/Netronome/nfp-drv-kmods/blob/master/src/Kbuild#L297
> > https://github.com/Netronome/nfp-drv-kmods/blob/master/src/Kbuild#L315 =
=20
>=20
> I was inspired by upstream code.
> https://elixir.bootlin.com/linux/v5.5-rc7/source/drivers/net/ethernet/net=
ronome/nfp/nfp_net_ethtool.c#L184

Right, upstream nfp reports kernel version (both in modinfo and ethtool)
GitHub/compat/backport/out-of-tree reports kernel version in which the
code was expected to appear in modinfo:

https://github.com/Netronome/nfp-drv-kmods/commit/7ec15c47caf5dbdf1f9806410=
535ad5b7373ec34#diff-492d7fa4004d885a38cfa889ed1adbe7L1284

And git hash of the driver source plus out of tree marker in ethtool.

That means it's out-of-tree driver which has to carry the extra code
and require extra feeding. As backport should IMHO.

> > > Leaving to deal with driver version to vendors is not an option too,
> > > because they prove for more than once that they are not capable to
> > > define user visible interfaces. It comes due to their natural believe
> > > that their company is alone in the world and user visible interface
> > > should be suitable for them only.
> > >
> > > It is already impossible for users to distinguish properly versions
> > > of different vendors, because they use arbitrary strings with some
> > > numbers. =20
> >
> > That is true. But reporting the kernel version without even as much as
> > in-tree/out-of-tree indication makes the field entirely meaningless. =20
>=20
> The long-standing policy in kernel that we don't really care about
> out-of-tree code.

Yeah... we all know it's not that simple :)

The in-tree driver versions are meaningless and cause annoying churn
when people arbitrarily bump them. If we can get people to stop doing
that we'll be happy, that's all there is to it.=20

Out of tree the field is useful, so we don't have to take it away just
as a matter of principle. If we can't convince people to stop bringing
the versions into the tree that'll be another story...
