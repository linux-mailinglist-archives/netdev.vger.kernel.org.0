Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007EE242CF1
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 18:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgHLQNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 12:13:36 -0400
Received: from mail.nic.cz ([217.31.204.67]:51836 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgHLQNg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Aug 2020 12:13:36 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 416C913F64E;
        Wed, 12 Aug 2020 18:13:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597248814; bh=HnaYHOR3u3STz7Pn2xmq5eSWra5FWGCYixQPlXtiQ7g=;
        h=Date:From:To;
        b=oP4UuBmF2gVkI/ZPV5CHyEIKDSeEtQbuUPaifmnCTqPV0hG+45yGDlT1ABarHVKCs
         YC6xvcbfsHh1MgrEG5h/lY1UI7TRAe1C2otwYxIVPIuJCs7aDi4VNionLCuVjkL09W
         HuHWNAYStnER7TnGuzURedWPLtJkjyZ3lby8YnQY=
Date:   Wed, 12 Aug 2020 18:13:33 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 3/4] net: phy: marvell10g: change
 MACTYPE according to phydev->interface
Message-ID: <20200812181333.69191baf@dellmb.labs.office.nic.cz>
In-Reply-To: <20200812154837.GQ1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
        <20200810220645.19326-4-marek.behun@nic.cz>
        <20200811152144.GN1551@shell.armlinux.org.uk>
        <20200812164431.34cf569f@dellmb.labs.office.nic.cz>
        <20200812150054.GP1551@shell.armlinux.org.uk>
        <20200812173716.140bed4d@dellmb.labs.office.nic.cz>
        <20200812154837.GQ1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Aug 2020 16:48:37 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Wed, Aug 12, 2020 at 05:37:16PM +0200, Marek Beh=FAn wrote:
> > On Wed, 12 Aug 2020 16:00:54 +0100
> > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> >  =20
> > > On Wed, Aug 12, 2020 at 04:44:31PM +0200, Marek Beh=FAn wrote: =20
> > > > There is another problem though: I think the PHY driver, when
> > > > deciding whether to set MACTYPE from the XFI with rate matching
> > > > mode to the 10GBASE-R/5GBASE-R/2500BASE-X/SGMII with AN mode,
> > > > should check which modes the underlying MAC support.   =20
> > >=20
> > > I'm aware of that problem.  I have some experimental patches
> > > which add PHY interface mode bitmaps to the MAC, PHY, and SFP
> > > module parsing functions.  I have stumbled on some problems
> > > though - it's going to be another API change (and people are
> > > already whinging about the phylink API changing "too quickly",
> > > were too quickly seems to be defined as once in three years), and
> > > in some cases, DSA, it's extremely hard to work out how to
> > > properly set such a bitmap due to DSA's layered approach.
> > >  =20
> >=20
> > If by your experimental patches you mean
> >   net: mvneta: fill in phy interface mode bitmap
> >   net: mvpp2: fill in phy interface mode bitmap
> > found here
> >   http://git.arm.linux.org.uk/cgit/linux-arm.git/log/?h=3Dclearfog
> > I am currently working on top of them.
> >  =20
> > > Having bitmaps means that we can take the union of what the MAC
> > > and PHY supports, and decide which MACTYPE setting would be most
> > > suitable. However, to do that we're into also changing phylib's
> > > interfaces as well.
> > >  =20
> > > > driver to phylink in the call to phylink_create. But there is
> > > > no way for the PHY driver to get this information from phylink
> > > > currently, and even if phylink exposed a function to return the
> > > > config member of struct phylink, the problem is that at the
> > > > time when mv3310_power_up is called, the phydev->phylink is not
> > > > yet set (this is done in phylink_bringup_phy, and
> > > > mv3310_power_up is called sometime in the phylink_attach_phy).
> > > >  =20
> > >=20
> > > We _really_ do not want phylib calling back into phylink
> > > functions. That would tie phylink functionality into phylib and
> > > cause problems when phylink is not being used.
> > >=20
> > > I would prefer phylib to be passed "the MAC can use these
> > > interface types, and would prefer to use this interface type" and
> > > have the phylib layer (along with the phylib driver) make the
> > > decision about which mode should be used.  That also means that
> > > non-phylink MACs can also use it.
> > >  =20
> >=20
> > I may try to propose something, but in the meantime do you think the
> > current version of the patch
> >   net: phy: marvell10g: change MACTYPE according to
> > phydev->interface is acceptable? =20
>=20
> Well, I have other questions about it.  Why are you doing it in
> the power_up function?  Do you find that the MACTYPE field is
> lost when clearing the power down bit?  From what I read, it should
> only change on hardware reset, and we don't hardware reset when we
> come out of power down - only software reset.
>=20

The MACTYPE is not being lost. But changing it requires Port Software
Reset, which resets the link, so it cannot be done for example in
read_status.
I think the MACTYPE should be set sometime during PHY initialisation,
and only once: either to XFI with rate matching, if the underlying MAC
does not support lower modes, or to 10gbase-r/2500base-x/sgmii mode, if
the underlying MAC supports only slower modes than 10G.

Marek
