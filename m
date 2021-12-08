Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CB746D7EC
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbhLHQVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbhLHQVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:21:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA908C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 08:17:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA8F2B8218C
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 16:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B39C00446;
        Wed,  8 Dec 2021 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638980245;
        bh=eViC3B78JHun2RQMy32ZFK/nNAiKnsAlDh4iFoa2Hxo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HhYd0LaCT2RMJq6p1Bx4UEuqnqsre8r5zpHFzz0IHL4wqtuzQF6Kqosg1VEh+S3RR
         k7zYGQ2SnY6rnXUo4VgfSJpdwOwlTNWbEMyWq0XHr/0WvVDTJA3OceM05L99xdfUtp
         SE2w15219twESW20TXXz51RGznTZ97FHtdRWrvej1vEjDE4uGIZZan18p8r5o8JfzD
         2JV5e2i9awCliwqE2NexBysHVjvKK+J05EuNyaBK0ubNvu+8xdvBCcPzWJ0RUQal3W
         Q9cqFS9m4eQ4871uWAzObDsUJjpyL7I7MR0UscEagJ7PglmML7dj8EpkffzuvFj/4x
         jQKmZbc6gzG6g==
Date:   Wed, 8 Dec 2021 17:17:20 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211208171720.6a297011@thinkpad>
In-Reply-To: <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
        <20211207190730.3076-2-holger.brunck@hitachienergy.com>
        <20211207202733.56a0cf15@thinkpad>
        <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208162852.4d7361af@thinkpad>
        <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 15:49:19 +0000
Holger Brunck <holger.brunck@hitachienergy.com> wrote:

> > > =20
> > > > > The mv88e6352, mv88e6240 and mv88e6176  have a serdes interface.
> > > > > This patch allows to configure the output swing to a desired value
> > > > > in the devicetree node of the port. As the chips only supports
> > > > > eight dedicated values we return EINVAL if the value in the DTS d=
oes not =20
> > match. =20
> > > > >
> > > > > CC: Andrew Lunn <andrew@lunn.ch>
> > > > > CC: Jakub Kicinski <kuba@kernel.org>
> > > > > CC: Marek Beh=C3=BAn <kabel@kernel.org>
> > > > > Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com> =20
> > > >
> > > > Holger, Andrew,
> > > >
> > > > there is another issue with this, which I only realized yesterday.
> > > > What if the different amplitude needs to be set only for certain Se=
rDes =20
> > modes? =20
> > > >
> > > > I am bringing this up because I discovered that on Turris Mox we
> > > > need to increase SerDes output amplitude when A3720 SOC is connected
> > > > directly to
> > > > 88E6141 switch, but only for 2500base-x mode. For 1000base-x, the
> > > > default amplitude is okay. (Also when the SOC is connected to
> > > > 88E6190, the amplitude does not need to be changed at all.)
> > > > =20
> > >
> > > on my board I have a fixed link connected with SGMII and there is no
> > > dedicated value given in the manual.
> > > =20
> > > > I plan to solve this in the comphy driver, not in device-tree.
> > > >
> > > > But if the solution is to be done in DTS, shouldn't there be a
> > > > possibility to define the amplitude for a specific serdes mode only?
> > > >
> > > > For example
> > > >   serdes-2500base-x-tx-amplitude-millivolt
> > > > or
> > > >   serdes-tx-amplitude-millivolt-2500base-x
> > > > or
> > > >   serdes-tx-amplitude-millivolt,2500base-x
> > > > ?
> > > >
> > > > What do you think?
> > > > =20
> > >
> > > in the data sheet for the MV6352 I am using there are no dedicated
> > > values stated for different modes at all, they can be chosen
> > > arbitrary. So in my case I think it makes sense to keep it as it is
> > > for now. Other driver may have other needs and may enhance this later=
 on. =20
> >=20
> > Hi Holger,
> >=20
> > but the mv88e6xxx driver also drives switches that allow changing serdes
> > modes. There does not need be dedicated TX amplitude register for each =
serdes
> > mode, the point is that we may want to declare different amplitudes for
> > different modes.
> >=20
> > So the question is: if we go with your binding proposal for the whole m=
v88e6xxx
> > driver, and in the future someone will want to declare different amplit=
udes for
> > different modes on another model, would he need to deprecate your bindi=
ng or
> > would it be easy to extend?
> >  =20
>=20
> ok I see. So if I follow your proposal in my case it would be something l=
ike:
> serdes-sgmii-tx-amplitude-millivolt to start with ?=20
>=20
> I can do that. Andrew what do you think?

Or maybe two properties:
  serdes-tx-amplitude-millivolt =3D <700 1000 1100>;
  serdes-tx-amplitude-modes =3D "sgmii", "2500base-x", "10gbase-r";
?

If
  serdes-tx-amplitude-modes
is omitted, then
  serdes-tx-amplitude-millivolt
should only contain one value, and this is used for all serdes modes.

This would be compatible with your change. You only need to define the
bidning for now, your code can stay the same - you don't need to add
support for multiple values or for the second property now, it can be
done later when needed. But the binding should be defined to support
those different modes.

Marek
