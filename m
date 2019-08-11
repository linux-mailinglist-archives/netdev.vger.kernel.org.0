Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4F4891F3
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 16:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfHKOEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 10:04:08 -0400
Received: from mail.nic.cz ([217.31.204.67]:50202 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbfHKOEI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 10:04:08 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id ECEBC1409E0;
        Sun, 11 Aug 2019 16:04:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565532245; bh=HhgHBuYEMpd5qaXujArYZSgPKdQoeNQIRUFrRDhrkug=;
        h=Date:From:To;
        b=TTIE86GC9cWiE1DKb1J2mi48j3DjqXyV3yhX7ZrbZrkGFeMYz+IWuHIK1zBHKlOT3
         KUKU8GvFA2Tj1FVsrXCAn14N4MJxJaL1R1eGjlUKVGEmZeUn9WWLoJLhlcxPJGYvHA
         vKNoD3ZDGjCCqOlnGwEMeq3Q/lqGXbLBd9lsCdXg=
Date:   Sun, 11 Aug 2019 16:04:04 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 1/1] net: dsa: fix fixed-link port
 registration
Message-ID: <20190811160404.06450685@nic.cz>
In-Reply-To: <91cd70df-c856-4c7e-7ebb-c01519fb13d2@gmail.com>
References: <20190811031857.2899-1-marek.behun@nic.cz>
        <20190811033910.GL30120@lunn.ch>
        <91cd70df-c856-4c7e-7ebb-c01519fb13d2@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OK guys, something is terribly wrong here.

I bisected to the commit mentioned (88d6272acaaa), looked around at the
genphy functions, tried adding the link=3D0 workaround and it did work,
so I though this was the issue.

What I realized now is that before the commit 88d6272acaaa things
worked because of two bugs, which negated each other. This commit caused
one of this bugs not to fire, and thus the second bug was not negated.

What actually happened before the commit that broke it is this:
  - after the fixed_phy is created, the parameters are corrent
  - genphy_read_status breaks the parameters:
     - first it sets the parameters to unknown (SPEED_UNKNOWN,
       DUPLEX_UNKNOWN)
     - then read the registers, which are simulated for fixed_phy
     - then it uses phy-core.c:phy_resolve_aneg_linkmode function, which
       looks for correct settings by bit-anding the ->advertising and
       ->lp_advertigins bit arrays. But in fixed_phy, ->lp_advertising
       is set to zero, so the parameters are left at SPEED_UNKNOWN, ...
       (this is the first bug)
  - then adjust_link is called, which then goes to
    mv88e6xxx_port_setup_mac, where there is a test if it should change
    something:
       if (state.link =3D=3D link && state.speed =3D=3D speed &&
           state.duplex =3D=3D duplex)
               return 0;
  - since current speed on the switch port (state.speed) is SPEED_1000,
    and new speed is SPEED_UNKNOWN, this test fails, and so the rest of
    this function is called, which makes the port work
    (the if test is the second bug)

After the commit that broke things:
  - after the fixed_phy is created, the parameters are corrent
  - genphy_read_status doesn't change them
  - mv88e6xxx_port_setup_mac does nothing, since the if condition above
    is true

So, there are two things that are broken:
 - the test in mv88e6xxx_port_setup_mac whether there is to be a change
   should be more sophisticated
 - fixed_phy should also simulate the lp_advertising register

What do you think of this?

Marek

On Sun, 11 Aug 2019 13:35:20 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 11.08.2019 05:39, Andrew Lunn wrote:
> > On Sun, Aug 11, 2019 at 05:18:57AM +0200, Marek Beh=C3=BAn wrote: =20
> >> Commit 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in
> >> genphy_read_status") broke fixed link DSA port registration in
> >> dsa_port_fixed_link_register_of: the genphy_read_status does not do wh=
at
> >> it is supposed to and the following adjust_link is given wrong
> >> parameters. =20
> >=20
> > Hi Marek
> >=20
> > Which parameters are incorrect?
> >=20
> > In fixed_phy.c, __fixed_phy_register() there is:
> >=20
> >         /* propagate the fixed link values to struct phy_device */
> >         phy->link =3D status->link;
> >         if (status->link) {
> >                 phy->speed =3D status->speed;
> >                 phy->duplex =3D status->duplex;
> >                 phy->pause =3D status->pause;
> >                 phy->asym_pause =3D status->asym_pause;
> >         }
> >=20
> > Are we not initialising something? Or is the initialisation done here
> > getting reset sometime afterwards?
> >  =20
> In addition to Andrew's question:
> We talk about this DT config: armada-385-turris-omnia.dts ?
> Which kernel version are you using?
>=20
> > Thanks
> > 	Andrew
> >  =20
> Heiner

