Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201CC2FC085
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbhASUBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:01:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:50976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729442AbhASTt3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 14:49:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D00E23138;
        Tue, 19 Jan 2021 19:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611085727;
        bh=x2G3h6gWeJttkZWzD3p/ebQvL5B00vXITXYElAWBRd4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qzNO8wNvaKloH3Wx57QRIH5z5O9G4ae3PQD05C5mUdINm758bne2s2m7JJ60TflI1
         Yn+lE6M18hrs3tT4DrmpYJXji8mnqWFPQJI3IUB+pT+gOF5E/e0aE831rVwlgs1Anh
         4x8LNxssHMvdFnt0eQun92kuDtY2yFXjLXo7L8yuY5rhHKcI1bCrB0V1Z3lYq+OTyP
         TmyG+W6ZO4TsINNhBF5ZIhplfB3S3uFcICTnhF+kmMKTlPR9nUX75GLD8wLHwKoFX/
         p4N/Ryjhi2PdGxOccfQ03SCxNqbodG/PQXK2qswpZfc/XsCX+sjddhwRoxu7HxKxmQ
         djbE0QpoUx73g==
Date:   Tue, 19 Jan 2021 11:48:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] mdio, phy: fix -Wshadow warnings triggered by
 nested container_of()
Message-ID: <20210119114846.20b844b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YAb4/7Nb1qaGiS0f@lunn.ch>
References: <20210116161246.67075-1-alobakin@pm.me>
        <YAb4/7Nb1qaGiS0f@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 16:21:35 +0100 Andrew Lunn wrote:
> On Sat, Jan 16, 2021 at 04:13:22PM +0000, Alexander Lobakin wrote:
> > container_of() macro hides a local variable '__mptr' inside. This
> > becomes a problem when several container_of() are nested in each
> > other within single line or plain macros.
> > As C preprocessor doesn't support generating random variable names,
> > the sole solution is to avoid defining macros that consist only of
> > container_of() calls, or they will self-shadow '__mptr' each time:
> >=20
> > In file included from ./include/linux/bitmap.h:10,
> >                  from drivers/net/phy/phy_device.c:12:
> > drivers/net/phy/phy_device.c: In function =E2=80=98phy_device_release=
=E2=80=99:
> > ./include/linux/kernel.h:693:8: warning: declaration of =E2=80=98__mptr=
=E2=80=99 shadows a previous local [-Wshadow]
> >   693 |  void *__mptr =3D (void *)(ptr);     \
> >       |        ^~~~~~
> > ./include/linux/phy.h:647:26: note: in expansion of macro =E2=80=98cont=
ainer_of=E2=80=99
> >   647 | #define to_phy_device(d) container_of(to_mdio_device(d), \
> >       |                          ^~~~~~~~~~~~
> > ./include/linux/mdio.h:52:27: note: in expansion of macro =E2=80=98cont=
ainer_of=E2=80=99
> >    52 | #define to_mdio_device(d) container_of(d, struct mdio_device, d=
ev)
> >       |                           ^~~~~~~~~~~~
> > ./include/linux/phy.h:647:39: note: in expansion of macro =E2=80=98to_m=
dio_device=E2=80=99
> >   647 | #define to_phy_device(d) container_of(to_mdio_device(d), \
> >       |                                       ^~~~~~~~~~~~~~
> > drivers/net/phy/phy_device.c:217:8: note: in expansion of macro =E2=80=
=98to_phy_device=E2=80=99
> >   217 |  kfree(to_phy_device(dev));
> >       |        ^~~~~~~~~~~~~
> > ./include/linux/kernel.h:693:8: note: shadowed declaration is here
> >   693 |  void *__mptr =3D (void *)(ptr);     \
> >       |        ^~~~~~
> > ./include/linux/phy.h:647:26: note: in expansion of macro =E2=80=98cont=
ainer_of=E2=80=99
> >   647 | #define to_phy_device(d) container_of(to_mdio_device(d), \
> >       |                          ^~~~~~~~~~~~
> > drivers/net/phy/phy_device.c:217:8: note: in expansion of macro =E2=80=
=98to_phy_device=E2=80=99
> >   217 |  kfree(to_phy_device(dev));
> >       |        ^~~~~~~~~~~~~
> >=20
> > As they are declared in header files, these warnings are highly
> > repetitive and very annoying (along with the one from linux/pci.h).
> >=20
> > Convert the related macros from linux/{mdio,phy}.h to static inlines
> > to avoid self-shadowing and potentially improve bug-catching.
> > No functional changes implied.
> >=20
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me> =20
>=20
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
