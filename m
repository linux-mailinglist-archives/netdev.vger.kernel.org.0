Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29799242B84
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 16:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHLOmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 10:42:04 -0400
Received: from mail.nic.cz ([217.31.204.67]:55636 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbgHLOmD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Aug 2020 10:42:03 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id C74B5140A47;
        Wed, 12 Aug 2020 16:42:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597243321; bh=1BHQvUyqiTJjXO5sXvnOxKqytUTIapYn6qKietE0OKo=;
        h=Date:From:To;
        b=rmCIypn2o0A6E7bfwteJHTWjOk4tfuzZ6Th6IJHg6xHJ6DES2f49yYbU/CEOH1eZz
         PyCVqRmFE162G8MPm8At2yKC/M/Ykhc5l6D/I/toflldtdXbqFA1h4+j7wgQI9ec5W
         hgLWSYMpPFTY8nEduuKUmWwfrVJ3BBL/6MWeBa3U=
Date:   Wed, 12 Aug 2020 16:42:01 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 2/4] net: phy: sfp: add support for
 multigig RollBall modules
Message-ID: <20200812164201.02a2a5c2@dellmb.labs.office.nic.cz>
In-Reply-To: <20200812143303.GO1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
        <20200810220645.19326-3-marek.behun@nic.cz>
        <20200811151552.GM1551@shell.armlinux.org.uk>
        <20200812153326.71b84e45@dellmb.labs.office.nic.cz>
        <20200812143303.GO1551@shell.armlinux.org.uk>
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

On Wed, 12 Aug 2020 15:33:04 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Wed, Aug 12, 2020 at 03:33:26PM +0200, Marek Beh=FAn wrote:
> > On Tue, 11 Aug 2020 16:15:53 +0100
> > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> >  =20
> > > > +	if (rollball) {
> > > > +		/* TODO: try to write this to EEPROM */
> > > > +		id.base.extended_cc =3D
> > > > SFF8024_ECC_10GBASE_T_SFI;   =20
> > >=20
> > > Should we really be "fixing" vendors EEPROMs for them?
> > >  =20
> >=20
> > Are you reffering to the TODO comment or the id.base.extended_cc
> > assignment?
> > If the comment, well, your code does it for cotsworks modules, but
> > I am actually indifferent. =20
>=20
> No, that's Chris' code, and there's quite a bit of history there:
> It appears Cotsworks programmed things like the serial number into
> the EEPROM and did not update the checksums.  After quite some time,
> it seems Cotsworks have seen sense, and have fixed their production
> line to properly program the EEPROM, but that leaves a whole bunch
> of modules with bad checksums.
>=20
> I'm more than happy that we should continue issuing the warning, but
> Chris has decided to fix them up.  I'm not particularly happy with
> that idea, but I didn't get the chance to express it before David
> picked up the patch.  So, it's now in mainline.
>=20
> Fixing the checksum for a module that is known to suffer bad checksums
> is one thing - it's a single byte write, and as the checksum is wrong,
> it's likely other systems that know about the issue will ignore it.
>=20
> However, changing the module description to be "correct" is a
> completely different level - there are many modules that do not
> report "correct" data, and, if we start fixing these up, it's likely
> that fixups that other SFP cage implementations have could stop
> working since they may not recognise the module.
>=20
> Remember, things like the extended CC codes are dependent on the SFF
> spec revisions, so if we start changing the extended CC code in byte
> 36, should we also change the SFF8472 compliance code as well (to
> be > rev 11.9)?  Since SFF8472 rev 11.9 changed the definition of this
> byte.
>=20

Thank you Russell for this explanation.
