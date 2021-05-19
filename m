Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1074389845
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 22:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbhESU5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 16:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229379AbhESU5Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 16:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4057B6135C;
        Wed, 19 May 2021 20:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621457764;
        bh=FV6wQlWXmkjqB9DUQy41wiMLLf4dZUasVPGY6xkjfIg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MpbJoXWqDXDKZ/N74Ip+p4VZ9ziBSg57S6u8uCpCaanYM718l7DuIhLNhQ6oSUjs0
         aOWhWfZR6Z9jfnQVlx/3wwG5+zpzaGn3BCrCAj/bIXcjRKiz7GFW34r905SZjMmsVC
         uib1xVh2LZyUhB2A+B7nD5w2Abth4JtsVeOw/imw3K+Vvab4SKyDPxJhfY7HQ8K8yK
         nGoCZT35VTKHGvuGGnGLEzTArMCG3NAxDmwigtsPSclZQG89EFZl/n/JRe235+THq7
         3MUBAS54QWGWybaKvfzARqHldXU+9xwPeZwRIIk3Ql6tIJdiqKrbXgqhCjNCsE5cIF
         F0if46ydH7DAw==
Date:   Wed, 19 May 2021 13:56:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Lijun Pan <ljp@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] mlx5: count all link events
Message-ID: <20210519135603.585a5169@kicinski-fedora-PC1C0HJN>
In-Reply-To: <61bd5f38c223582682f98d5e8f9f3820edde5b7e.camel@kernel.org>
References: <20210519171825.600110-1-kuba@kernel.org>
        <155D8D8E-C0FE-4EF9-AD7F-B496A8279F92@linux.vnet.ibm.com>
        <20210519125107.578f9c7d@kicinski-fedora-PC1C0HJN>
        <61bd5f38c223582682f98d5e8f9f3820edde5b7e.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 May 2021 13:18:36 -0700 Saeed Mahameed wrote:
> On Wed, 2021-05-19 at 12:51 -0700, Jakub Kicinski wrote:
> > On Wed, 19 May 2021 14:34:34 -0500 Lijun Pan wrote: =20
> > > Is it possible to integrate netif_carrier_event into
> > > netif_carrier_on? like,
> > >=20
> > > void netif_carrier_on(struct net_device *dev)
> > > {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (test_and_clear_bi=
t(__LINK_STATE_NOCARRIER, &dev->state))
> > > {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0if (dev->reg_state =3D=3D NETREG_UNINITIALIZED)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
return;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0atomic_inc(&dev->carrier_up_count);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0linkwatch_fire_event(dev);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0if (netif_running(dev))
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
__netdev_watchdog_up(dev);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0} else {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0if (dev->reg_state =3D=3D NETREG_UNINITIALIZED)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
return;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0atomic_inc(&dev->carrier_down_count);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0atomic_inc(&dev->carrier_up_count);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > > }
> > > EXPORT_SYMBOL(netif_carrier_on); =20
> >=20
> > Ah, I meant to address that in the commit message, thanks for bringing
> > this up. I suspect drivers may depend on the current behavior of
> > netif_carrier_on()/off() being idempotent. We have no real reason for
> > removing that assumption.
> >=20
> > I assumed netif_carrier_event() would be used specifically in places
> > driver is actually servicing a link event from the device, and
> > therefore is relatively certain that _something_ has happened. =20
>=20
> then according to the above assumption it is safe to make
> netif_carrier_event() do everything.
>=20
> netif_carrier_event(netdev, up) {
> 	if (dev->reg_state =3D=3D NETREG_UNINITIALIZED)
> 		return;
>=20
> 	if (up =3D=3D netif_carrier_ok(netdev) {
> 		atomic_inc(&netdev->carrier_up_count);
> 		atomic_inc(&netdev->carrier_down_count);
> 		linkwatch_fire_event(netdev);
> 	}
>=20
> 	if (up) {
> 		netdev_info(netdev, "Link up\n");
> 		netif_carrier_on(netdev);
> 	} else {
> 		netdev_info(netdev, "Link down\n");
> 		netif_carrier_off(netdev);
> 	}
> }

Two things to consider are:
 - some drivers print more info than just "link up/link down" so they'd
   have to drop that extra stuff (as much as I'd like the consistency)
 - again with the unnecessary events I was afraid that drivers reuse=20
   the same handler for device events and to read the state in which
   case we may do something like:

	if (from_event && up =3D=3D netif_carrier_ok(netdev)

Maybe we can revisit when there's more users?
