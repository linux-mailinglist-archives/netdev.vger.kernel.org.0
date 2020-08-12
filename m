Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197EE242D25
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 18:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgHLQ2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 12:28:19 -0400
Received: from mail.nic.cz ([217.31.204.67]:56850 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgHLQ2T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Aug 2020 12:28:19 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 54F0B140977;
        Wed, 12 Aug 2020 18:28:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597249697; bh=57Z4VgmgdoNN4P0tepB8xjq5fOdFVzL1tZA+wTmbQZw=;
        h=Date:From:To;
        b=DV2b5BsEm5QoA+afer5hoIwkLXM0vPv3Cp8kJVS9xvsfswNFd1yrf7G9Jh5r4PavW
         Mstzc4xBF05o9c8g4N6KSXDvfVQVjJzxeOBhsVvV8qO6xKQJRr678fRyzz1EBOuSW1
         03Vsl081J5BJx5wpOcRcsbT/9fijTmLFwlitHwrY=
Date:   Wed, 12 Aug 2020 18:28:17 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 3/4] net: phy: marvell10g: change
 MACTYPE according to phydev->interface
Message-ID: <20200812182817.1bb7bb4a@dellmb.labs.office.nic.cz>
In-Reply-To: <20200812162232.GT1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
        <20200810220645.19326-4-marek.behun@nic.cz>
        <20200811152144.GN1551@shell.armlinux.org.uk>
        <20200812164431.34cf569f@dellmb.labs.office.nic.cz>
        <20200812150054.GP1551@shell.armlinux.org.uk>
        <20200812173716.140bed4d@dellmb.labs.office.nic.cz>
        <20200812154837.GQ1551@shell.armlinux.org.uk>
        <20200812181333.69191baf@dellmb.labs.office.nic.cz>
        <20200812162232.GT1551@shell.armlinux.org.uk>
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

On Wed, 12 Aug 2020 17:22:32 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Wed, Aug 12, 2020 at 06:13:33PM +0200, Marek Beh=FAn wrote:
> > The MACTYPE is not being lost. But changing it requires Port
> > Software Reset, which resets the link, so it cannot be done for
> > example in read_status. =20
>=20
> Wouldn't the right place to configure it be in the config_init()
> method - which is called once we have a MAC attaching to the PHY?
> As I mentioned, if we had a way to pass the MAC interface supported
> mask into phylib, config_init() could then use that to determine what
> to do.
>=20

It is done from config_init. mv3310_power_up is called from
mv3310_config_init.

> > I think the MACTYPE should be set sometime during PHY
> > initialisation, and only once: either to XFI with rate matching, if
> > the underlying MAC does not support lower modes, or to
> > 10gbase-r/2500base-x/sgmii mode, if the underlying MAC supports
> > only slower modes than 10G. =20
>=20
> Yes - only changing the MAC type if we have good reason to do so to
> support other rates.
>=20
> There is a related problem however.  Note that if you have an 88x3310
> (non-P) in the SFP, then when rate matching is enabled, the PHY will
> _not_ generate pause frames, and the PHY expects the MAC to be
> configured to pace itself to the slower speed.  I don't believe we
> have support in MACs for that, but phylib and therefore phylink
> provides the information:
>=20
> 	interface - 10GBASE-R
> 	speed - media speed
> 	pause - media pause modes
>=20
> So, if speed !=3D SPEED_10000 and there are no pause modes, we should,
> for the sake of the entire link, pace the MAC to the media speed by
> controlling its egress rate.
>=20

