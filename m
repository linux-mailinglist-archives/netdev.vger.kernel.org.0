Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35213242B89
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 16:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgHLOoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 10:44:34 -0400
Received: from lists.nic.cz ([217.31.204.67]:56474 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbgHLOod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Aug 2020 10:44:33 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 187301409F0;
        Wed, 12 Aug 2020 16:44:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597243472; bh=j/Xy/ln7drrzlhjMVqpI25k4TjriVA6TyKFW7xKKb3s=;
        h=Date:From:To;
        b=XjykjXMzgVQuVw6/bVtt8nTuyo79SzqDsClomi4E51d75RoUeTsVv0+ZPA9ROy2tt
         JwOmEB5+h5KSwwcggOs24NuzIxRWFHH6eLhSRvuhcx8hQso9lDrt+w7I/q82MlxHOo
         nBS5RtX6ZtPVAea0w5561Ln1wuOKnsVRflULzOHE=
Date:   Wed, 12 Aug 2020 16:44:31 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 3/4] net: phy: marvell10g: change
 MACTYPE according to phydev->interface
Message-ID: <20200812164431.34cf569f@dellmb.labs.office.nic.cz>
In-Reply-To: <20200811152144.GN1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
        <20200810220645.19326-4-marek.behun@nic.cz>
        <20200811152144.GN1551@shell.armlinux.org.uk>
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

On Tue, 11 Aug 2020 16:21:44 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Tue, Aug 11, 2020 at 12:06:44AM +0200, Marek Beh=FAn wrote:
> > RollBall SFPs contain Marvell 88X3310 PHY, but they have
> > configuration pins strapped so that MACTYPE is configured in XFI
> > with Rate Matching mode.
> >=20
> > When these SFPs are inserted into a device which only supports lower
> > speeds on host interface, we need to configure the MACTYPE to a mode
> > in which the H unit changes SerDes speed according to speed on the
> > copper interface. I chose to use the
> > 10GBASE-R/5GBASE-R/2500BASE-X/SGMII with AN mode. =20
>=20
> We actually need to have more inteligence in the driver, since we
> actually assume that it is in the 10GBASE-R/5GBASE-R/2500BASE-X/SGMII
> mode without really checking.
>=20
> Note that there are differences in the way the mactype field is
> interpreted depending on exactly what chip we have.  For example,
> 3310 and 3340 are different.  That said, I've not heard of anyone
> using the 3340 yet.
>=20

Russell, I am aware that MACTYPE modes are interpreted differently for
3310 vs 3340, but this only affects modes 0-3, which the driver does
not check for even after applying my patch.

There is another problem though: I think the PHY driver, when deciding
whether to set MACTYPE from the XFI with rate matching mode to the
10GBASE-R/5GBASE-R/2500BASE-X/SGMII with AN mode, should check which
modes the underlying MAC support.

If the underlying MAC supports only XFI mode, than the MACTYPE should
be set to XFI with rate matching. But on Omnia for example the MAC
supports SGMII/1000base-s/2500base-x, so on Omnia the MACTYPE should be
changed.

Currently this information is given in your repository by the mvneta
driver to phylink in the call to phylink_create. But there is no way
for the PHY driver to get this information from phylink currently, and
even if phylink exposed a function to return the config member of
struct phylink, the problem is that at the time when mv3310_power_up is
called, the phydev->phylink is not yet set (this is done in
phylink_bringup_phy, and mv3310_power_up is called sometime in the
phylink_attach_phy).

Marek

