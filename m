Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A5E38B394
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 17:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbhETPtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 11:49:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231966AbhETPtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 11:49:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A786C60C41;
        Thu, 20 May 2021 15:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621525698;
        bh=KSrN5M4PB/NDHC7owt2InWOhnPCcNYz3n0Zhs7rq1XM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qNy0IPf4dj1R6pfH+GCCK6013GPYx2klrH2zQ1dpXsMjYUM/eBnbiiJbnAqCZPvb4
         DY+ECiehsHFUro8IRfMoL/dyZfeJiF+M6QF4FoyJRyZhZLLs31V9jilw2h3LlWQTHg
         rBRoQJfpy2/p0NNdMOzVkZCpCTfHuMAHgqHI1hbcuOhiYFGAmKoy8UWsMs9Du0sIl2
         yrZylOiqyD0aIdS1psOHkxpswgDInsRNxpLYGilGKUeUEALXMvA8kbb9TYZ1PXCTmE
         lSZVjo72TaLyBXcdfd4Ht0eMZT/pdqcKn76ydV9kz7qxahLAw7ibUibnhuIZlWTq9c
         KSYbn5+Y8/rEw==
Date:   Thu, 20 May 2021 08:48:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Lijun Pan <ljp@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] mlx5: count all link events
Message-ID: <20210520084817.6bd770e5@kicinski-fedora-PC1C0HJN>
In-Reply-To: <3ed3fb510ba62f4911f4ffe01a197df3bb8cd969.camel@kernel.org>
References: <20210519171825.600110-1-kuba@kernel.org>
        <155D8D8E-C0FE-4EF9-AD7F-B496A8279F92@linux.vnet.ibm.com>
        <20210519125107.578f9c7d@kicinski-fedora-PC1C0HJN>
        <61bd5f38c223582682f98d5e8f9f3820edde5b7e.camel@kernel.org>
        <20210519135603.585a5169@kicinski-fedora-PC1C0HJN>
        <3ed3fb510ba62f4911f4ffe01a197df3bb8cd969.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 May 2021 22:36:10 -0700 Saeed Mahameed wrote:
> On Wed, 2021-05-19 at 13:56 -0700, Jakub Kicinski wrote:
> > On Wed, 19 May 2021 13:18:36 -0700 Saeed Mahameed wrote: =20
> > > then according to the above assumption it is safe to make
> > > netif_carrier_event() do everything.
> > >=20
> > > netif_carrier_event(netdev, up) {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (dev->reg_state =
=3D=3D NETREG_UNINITIALIZED)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return;
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (up =3D=3D netif_c=
arrier_ok(netdev) {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0atomic_inc(&netdev->carrier_up_count);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0atomic_inc(&netdev->carrier_down_count);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0linkwatch_fire_event(netdev);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (up) {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0netdev_info(netdev, "Link up\n");
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0netif_carrier_on(netdev);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0} else {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0netdev_info(netdev, "Link down\n");
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0netif_carrier_off(netdev);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > > } =20
> >=20
> > Two things to consider are:
> > =C2=A0- some drivers print more info than just "link up/link down" so
> > they'd
> > =C2=A0=C2=A0 have to drop that extra stuff (as much as I'd like the
> > consistency) =20
>=20
> +1 for the consistency
>=20
> > =C2=A0- again with the unnecessary events I was afraid that drivers reu=
se=20
> > =C2=A0=C2=A0 the same handler for device events and to read the state i=
n which
> > =C2=A0=C2=A0 case we may do something like:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (from_event && up =
=3D=3D netif_carrier_ok(netdev)
> >  =20
>=20
> I don't actually understand your point here .. what kind of scenarios
> it is wrong to use this function ?=20
>=20
> But anyway, the name of the function makes it very clear this is from
> event.. also we can document this.

I don't have any proof of this but drivers may check link state
periodically from a service job or such.

> > Maybe we can revisit when there's more users? =20
> goes both ways :), we can do what fits the requirement for mlx5 now and
> revisit in the future, if we do believe this should be general behavior
> for all/most vendors of-course!

I think it'd be more of a "add this function so the future drivers can
use it". I've scanned the drivers I'm familiar with and none of them
seemed like they could make use of the "wider" version of the helper.
Does mlx4 need it?

The problem seems slightly unusual, I feel like targeted helper would
lead to a cleaner API, but can change if we really need to..
