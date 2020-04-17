Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B631ADC26
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 13:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbgDQL2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 07:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730193AbgDQL2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 07:28:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6878BC061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 04:28:41 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jPPAg-0004FF-Fj; Fri, 17 Apr 2020 13:28:34 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jPPAc-0002xV-I1; Fri, 17 Apr 2020 13:28:30 +0200
Date:   Fri, 17 Apr 2020 13:28:30 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        kernel@pengutronix.de, David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v1] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200417112830.mhevvmnyxpve6xvk@pengutronix.de>
References: <20200415121209.12197-1-o.rempel@pengutronix.de>
 <20200415215739.GI657811@lunn.ch>
 <20200417101145.GP25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pykonr2qxhbolp4w"
Content-Disposition: inline
In-Reply-To: <20200417101145.GP25745@shell.armlinux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:26:47 up 154 days,  1:45, 169 users,  load average: 0.06, 0.02,
 0.03
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pykonr2qxhbolp4w
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2020 at 11:11:45AM +0100, Russell King - ARM Linux admin wr=
ote:
> On Wed, Apr 15, 2020 at 11:57:39PM +0200, Andrew Lunn wrote:
> > > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_devic=
e.c
> > > index c8b0c34030d32..d5edf2bc40e43 100644
> > > --- a/drivers/net/phy/phy_device.c
> > > +++ b/drivers/net/phy/phy_device.c
> > > @@ -604,6 +604,7 @@ struct phy_device *phy_device_create(struct mii_b=
us *bus, int addr, u32 phy_id,
> > >  	dev->asym_pause =3D 0;
> > >  	dev->link =3D 0;
> > >  	dev->interface =3D PHY_INTERFACE_MODE_GMII;
> > > +	dev->master_slave =3D PORT_MODE_UNKNOWN;
> >=20
> > phydev->master_slave is how we want the PHY to be configured. I don't
> > think PORT_MODE_UNKNOWN makes any sense in that contest. 802.3 gives
> > some defaults. 9.12 should be 0, meaning manual master/slave
> > configuration is disabled. The majority of linux devices are end
> > systems. So we should default to a single point device. So i would
> > initialise PORT_MODE_SLAVE, or whatever we end up calling that.
>=20
> I'm not sure that is a good idea given that we use phylib to drive
> the built-in PHYs in DSA switches, which ought to prefer master mode
> via the "is a multiport device" bit.
>=20
> Just to be clear, there are three bits that configure 1G PHYs, which
> I've framed in briefer terminology:
>=20
> - 9.12: auto/manual configuration (1=3D manual 0=3D slave)
> - 9.11: manual master/slave configuration (1=3D master, 0 =3D slave)
> - 9.10: auto master/slave preference (1=3D multiport / master)
>=20
> It is recommended that multiport devices (such as DSA switches) set
> 9.10 so they prefer to be master.
>=20
> It's likely that the reason is to reduce cross-talk interference
> between neighbouring ports both inside the PHY, magnetics and the
> board itself. I would suspect that this becomes critical when
> operating at towards the maximum cable length.
>=20
> I've checked some of my DSA switches, and 9.10 appears to default to
> one, as expected given what's in the specs.

Hm..
I've checked one of my DSA devices and 9.10 is by default 0 (proffered
slave). It get slave even if it is preferred master and it is
connected to a workstation (not multiport device) with a e1000e NIC.
The e1000e is configured by default as preferred master.

Grepping over current linux kernel I see following attempts to
configure master/slave modes:
drivers/net/ethernet/intel/e1000e/phy.c:597
  e1000_set_master_slave_mode()

all intel NICs have similar code code and do not touch preferred bit
9.10. Only force master/slave modes. So the preferred master is probably
PHY defaults, bootstrap or eeprom.

drivers/net/ethernet/broadcom/tg3.c
this driver seems to always force master mode

drivers/net/phy/broadcom.c:39
if ethernet controller is BCMA_CHIP_ID_BCM53573 and the PHY is PHY_ID_BCM54=
210E
then force master mode.

drivers/net/phy/micrel.c:637
Force master mode if devicetree property is set: micrel,force-master

drivers/net/phy/realtek.c:173
	/* RTL8211C has an issue when operating in Gigabit slave mode *=20
	return phy_set_bits(phydev, MII_CTRL1000,
		CTL1000_ENABLE_MASTER | CTL1000_AS_MASTER)

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--pykonr2qxhbolp4w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6ZktoACgkQ4omh9DUa
UbPEGw//VFNanq+Y6stjK9i/n3XiVe5KQ5YY8Ukr+2JLgV4Zfoeio7g62UAjWoNi
FYLrHrXvUfsr1ZND43G7FyEyuMtVzy+FDN/Q7htTbZFTu1VHGOHXOeKpmZaLiQNN
zlAtBTcrycqvkre+tClOz/uPmbzz3O4Ut/R1c01dTJXPf6NOlsl7ZNBPSx+b+hs2
6idToq0yUZD6Jz4QZKdfsjZwXQ1lpdBwXjwJE3/pK+lEDrw4P274shA6hQ42I/2W
fkx8W0w1008N5mXG8jkOBThrA1PmFd0J/J8iHxNmuAgSoPCwFOjoHUBsoXmCfHs1
9o3UBNabwmKTrsGXxA3+5CQS61PCWo4a4h4uqEJRCjfkK+SC1iSVf2dRxw1kE5pI
oiSHKOyVuoJsI02on3iwjOYHSkfWAtp+OrgbyKKzuTCaVllo0icK/SfEzLK3P6Ho
UR28LrTz95Jfm5w5KbG5x97iC/SCeGvH6FMhXfBKN5kWFIj/T4TkTJVuoVSt6BVP
pBO3gaJe1huQeOq5rV7KW5haDsZ+Sqi0hY/7ltyHGSJLKCM8ceFixnS8uHNehrzr
uIKCQ4lg/YI35sLNtKFu+p3xgKO4jhycN2j+VL/+V/p7h9BtrOjcyzjmGF1YH0Eu
V2Gfc2Db3zuOif+QSIcYqWjTQ0eNLwkOcrfm701eX7lXvOoZQO4=
=Hlrq
-----END PGP SIGNATURE-----

--pykonr2qxhbolp4w--
