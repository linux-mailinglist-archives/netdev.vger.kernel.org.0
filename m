Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521E046D7FD
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbhLHQYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:24:44 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48254 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbhLHQYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:24:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 31732CE2213
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 16:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23E5C00446;
        Wed,  8 Dec 2021 16:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638980469;
        bh=02TTfDdqs8VJlW8PzcMJ0Re8XG1aUbrstMB8WO/xV8o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mKo60F+AK9byw6b6DlFxjZUkdYW/Wku25E2cmP7jnv9JKphSdoqM8hptytJhgny44
         Fwhrg6JwlA9h2Gd6DwnFFYO0hxjc0lfrWPUnqo8BXtimV93WVdCse0WjqOlWG55yVF
         un9q8TjuytQhQKyO4fUi75XgzVy1ac6vHbqxrdhJLWfs0n5GUCkqHrGMaG8v0MBAGe
         AQqUz7vwTGWLUzmUqiC4M1b5t74EGn7P/xzL9Lxz1MyWvZm/djgpg4rko8PMVt33Cm
         aaAP/QPIYWAErldK79ew3KCVdf23WnbQn/BWI/n8UiU51BdakW+NCP5ADBuvif2RWS
         9jUy8157T9vOQ==
Date:   Wed, 8 Dec 2021 17:21:04 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211208172104.75e32a6b@thinkpad>
In-Reply-To: <20211208171720.6a297011@thinkpad>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
        <20211207190730.3076-2-holger.brunck@hitachienergy.com>
        <20211207202733.56a0cf15@thinkpad>
        <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208162852.4d7361af@thinkpad>
        <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208171720.6a297011@thinkpad>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vladimir,

On Wed, 8 Dec 2021 17:17:20 +0100
Marek Beh=C3=BAn <kabel@kernel.org> wrote:

> On Wed, 8 Dec 2021 15:49:19 +0000
> Holger Brunck <holger.brunck@hitachienergy.com> wrote:
>=20
> > > >   =20
> > > > > > The mv88e6352, mv88e6240 and mv88e6176  have a serdes interface.
> > > > > > This patch allows to configure the output swing to a desired va=
lue
> > > > > > in the devicetree node of the port. As the chips only supports
> > > > > > eight dedicated values we return EINVAL if the value in the DTS=
 does not   =20
> > > match.   =20
> > > > > >
> > > > > > CC: Andrew Lunn <andrew@lunn.ch>
> > > > > > CC: Jakub Kicinski <kuba@kernel.org>
> > > > > > CC: Marek Beh=C3=BAn <kabel@kernel.org>
> > > > > > Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com> =
  =20
> > > > >
> > > > > Holger, Andrew,
> > > > >
> > > > > there is another issue with this, which I only realized yesterday.
> > > > > What if the different amplitude needs to be set only for certain =
SerDes   =20
> > > modes?   =20
> > > > >
> > > > > I am bringing this up because I discovered that on Turris Mox we
> > > > > need to increase SerDes output amplitude when A3720 SOC is connec=
ted
> > > > > directly to
> > > > > 88E6141 switch, but only for 2500base-x mode. For 1000base-x, the
> > > > > default amplitude is okay. (Also when the SOC is connected to
> > > > > 88E6190, the amplitude does not need to be changed at all.)
> > > > >   =20
> > > >
> > > > on my board I have a fixed link connected with SGMII and there is no
> > > > dedicated value given in the manual.
> > > >   =20
> > > > > I plan to solve this in the comphy driver, not in device-tree.
> > > > >
> > > > > But if the solution is to be done in DTS, shouldn't there be a
> > > > > possibility to define the amplitude for a specific serdes mode on=
ly?
> > > > >
> > > > > For example
> > > > >   serdes-2500base-x-tx-amplitude-millivolt
> > > > > or
> > > > >   serdes-tx-amplitude-millivolt-2500base-x
> > > > > or
> > > > >   serdes-tx-amplitude-millivolt,2500base-x
> > > > > ?
> > > > >
> > > > > What do you think?
> > > > >   =20
> > > >
> > > > in the data sheet for the MV6352 I am using there are no dedicated
> > > > values stated for different modes at all, they can be chosen
> > > > arbitrary. So in my case I think it makes sense to keep it as it is
> > > > for now. Other driver may have other needs and may enhance this lat=
er on.   =20
> > >=20
> > > Hi Holger,
> > >=20
> > > but the mv88e6xxx driver also drives switches that allow changing ser=
des
> > > modes. There does not need be dedicated TX amplitude register for eac=
h serdes
> > > mode, the point is that we may want to declare different amplitudes f=
or
> > > different modes.
> > >=20
> > > So the question is: if we go with your binding proposal for the whole=
 mv88e6xxx
> > > driver, and in the future someone will want to declare different ampl=
itudes for
> > > different modes on another model, would he need to deprecate your bin=
ding or
> > > would it be easy to extend?
> > >    =20
> >=20
> > ok I see. So if I follow your proposal in my case it would be something=
 like:
> > serdes-sgmii-tx-amplitude-millivolt to start with ?=20
> >=20
> > I can do that. Andrew what do you think? =20
>=20
> Or maybe two properties:
>   serdes-tx-amplitude-millivolt =3D <700 1000 1100>;
>   serdes-tx-amplitude-modes =3D "sgmii", "2500base-x", "10gbase-r";
> ?
>=20
> If
>   serdes-tx-amplitude-modes
> is omitted, then
>   serdes-tx-amplitude-millivolt
> should only contain one value, and this is used for all serdes modes.
>=20
> This would be compatible with your change. You only need to define the
> bidning for now, your code can stay the same - you don't need to add
> support for multiple values or for the second property now, it can be
> done later when needed. But the binding should be defined to support
> those different modes.

Vladimir, can you send your thoughts about this proposal? We are trying
to propose binding for defining serdes TX amplitude.

Marek
