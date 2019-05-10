Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 426C419907
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 09:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfEJHcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 03:32:31 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51061 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfEJHca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 03:32:30 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mgr@pengutronix.de>)
        id 1hP012-0005pg-FL; Fri, 10 May 2019 09:32:24 +0200
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mgr@pengutronix.de>)
        id 1hP012-00026i-5o; Fri, 10 May 2019 09:32:24 +0200
Date:   Fri, 10 May 2019 09:32:24 +0200
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tristram.Ha@microchip.com, kernel@pengutronix.de,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: [RFC 1/3] mdio-bitbang: add SMI0 mode support
Message-ID: <20190510073224.obymtg4thqleypne@pengutronix.de>
References: <20190508211330.19328-1-m.grzeschik@pengutronix.de>
 <20190508211330.19328-2-m.grzeschik@pengutronix.de>
 <20190509142925.GL25013@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qdpckhs7d4eiq2dv"
Content-Disposition: inline
In-Reply-To: <20190509142925.GL25013@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:22:04 up 52 days, 18:32, 90 users,  load average: 1.09, 1.11,
 1.09
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qdpckhs7d4eiq2dv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 09, 2019 at 04:29:25PM +0200, Andrew Lunn wrote:
> On Wed, May 08, 2019 at 11:13:28PM +0200, Michael Grzeschik wrote:
> > Some microchip phys support the Serial Management Interface Protocol
> > (SMI) for the configuration of the extended register set. We add
> > MII_ADDR_SMI0 as an availabe interface to the mdiobb write and read
> > functions, as this interface can be easy realized using the bitbang mdio
> > driver.
> >=20
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > ---
> >  drivers/net/phy/mdio-bitbang.c | 10 ++++++++++
> >  include/linux/phy.h            | 12 ++++++++++++
> >  2 files changed, 22 insertions(+)
> >=20
> > diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio-bitb=
ang.c
> > index 5136275c8e739..a978f8a9a172b 100644
> > --- a/drivers/net/phy/mdio-bitbang.c
> > +++ b/drivers/net/phy/mdio-bitbang.c
> > @@ -22,6 +22,10 @@
> >  #define MDIO_READ 2
> >  #define MDIO_WRITE 1
> > =20
> > +#define SMI0_RW_OPCODE	0
> > +#define SMI0_READ_PHY	(1 << 4)
> > +#define SMI0_WRITE_PHY	(0 << 4)
> > +
> >  #define MDIO_C45 (1<<15)
> >  #define MDIO_C45_ADDR (MDIO_C45 | 0)
> >  #define MDIO_C45_READ (MDIO_C45 | 3)
> > @@ -157,6 +161,9 @@ static int mdiobb_read(struct mii_bus *bus, int phy=
, int reg)
> >  	if (reg & MII_ADDR_C45) {
> >  		reg =3D mdiobb_cmd_addr(ctrl, phy, reg);
> >  		mdiobb_cmd(ctrl, MDIO_C45_READ, phy, reg);
> > +	} else if (reg & MII_ADDR_SMI0) {
> > +		mdiobb_cmd(ctrl, SMI0_RW_OPCODE,
> > +			   (reg & 0xE0) >> 5 | SMI0_READ_PHY, reg);
> >  	} else
> >  		mdiobb_cmd(ctrl, MDIO_READ, phy, reg);
> > =20
> > @@ -188,6 +195,9 @@ static int mdiobb_write(struct mii_bus *bus, int ph=
y, int reg, u16 val)
> >  	if (reg & MII_ADDR_C45) {
> >  		reg =3D mdiobb_cmd_addr(ctrl, phy, reg);
> >  		mdiobb_cmd(ctrl, MDIO_C45_WRITE, phy, reg);
> > +	} else if (reg & MII_ADDR_SMI0) {
> > +		mdiobb_cmd(ctrl, SMI0_RW_OPCODE,
> > +			   (reg & 0xE0) >> 5 | SMI0_WRITE_PHY, reg);
> >  	} else
> >  		mdiobb_cmd(ctrl, MDIO_WRITE, phy, reg);
> > =20
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 073fb151b5a99..f011722fbd5c2 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -199,6 +199,18 @@ static inline const char *phy_modes(phy_interface_=
t interface)
> >     IEEE 802.3ae clause 45 addressing mode used by 10GIGE phy chips. */
> >  #define MII_ADDR_C45 (1<<30)
> > =20
> > +/* Serial Management Interface (SMI) uses the following frame format:
> > + *
> > + *       preamble|start|Read/Write|  PHY   |  REG  |TA|   Data bits   =
   | Idle
> > + *               |frame| OP code  |address |address|  |               =
   |
> > + * read | 32x1=C2=B4s | 01  |    00    | 1xRRR  | RRRRR |Z0| 00000000D=
DDDDDDD |  Z
> > + * write| 32x1=C2=B4s | 01  |    00    | 0xRRR  | RRRRR |10| xxxxxxxxD=
DDDDDDD |  Z
> > + *
> > + * The register number is encoded with the 5 least significant bits in=
 REG
> > + * and the 3 most significant bits in PHY
> > + */
> > +#define MII_ADDR_SMI0 (1<<31)
> > +
>=20
> Michael
>=20
> This is a Micrel Proprietary protocol. So we should reflect this in
> the name. MII_ADDR_MICREL_SMI? Why the 0? Are there different
> versions? Maybe replace all SMI0 with MICREL_SMI in mdio-bitbang.c

There are two variants of the SMI interface.

The KSZ8863/73/93 Products use the above Variant described as "SMI0".

The KSZ8864/95 Products use another layout:

      preamble|start|Read/Write|  PHY   |  REG  |TA|   Data bits      | Idle
              |frame| OP code  |address |address|  |                  |
read | 32x1=C2=B4s | 01  |    10    | RR11R  | RRRRR |Z0| 00000000DDDDDDDD =
|  Z
write| 32x1=C2=B4s | 01  |    01    | RR11R  | RRRRR |10| xxxxxxxxDDDDDDDD =
|  Z

So they describe their write/read operation in the OP code rather then
the PHY address.

We could change the SMI index to SMI_KSZ88X3 for the current SMI0 to
give it a more descriptive name. Beside we never know if Microchip
will add the same protocol to other numbered switches. What naming
would you prefer?

> When i look at this, i don't see how a normal MDIO bus driver is going
> to support this. Only the bit banging driver, or maybe a Micrel MDIO
> bus master hardware driver. So i think the diagram should be placed
> into mdio-bitbang.c, and it would be nice to add a diagram of standard
> SMI.

Right. I will move the description to mdio-bitbang.c.

Thanks,
Michael

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--qdpckhs7d4eiq2dv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAlzVKQEACgkQC+njFXoe
LGTX0RAAln/Pzypmri9mU7IcCOcZJxcjZR7er5hTI/RxMp+bWEz5xPeOG4S4/U4N
ZFbt1L+0FIBIVkGNTyCq/JAHsWJC0ud3EpIBcxSxUVV+tOQc46GV91eWZgMbe1oO
xAUMva9tmJq3SIGpsIhzw7ppG26o0gXJ1K4fDgqvAuV7Ek2qAa6yHrnnvT2OSJAL
XcUzBBaPYGLaljKvPICHL8NPblSmTtj1iKxdPJbL0i6BvOJuARRq6dxWAyt8AT5Q
csRQqQIfBQWBeKK2glYVJ2SVjVYY/q9TekUvGsy+s8gQSDVyBZVkEjTKNH89E+w6
O6khsP/iG9W9aQtzRRMmv14dqJIfB3/ez95Hi5ODdvd+RWFEEfn7EWVBpQwfeuTJ
LSQ6eLqejA5MZJ6iyWtzArQwWEVdwlCNKHfvPxszQfIPWaNdrENByFfTOVsWbo7h
5QdU3HgSSJpYnLXheW1NzXkFwoZZ30p7H9SzYfqOFBE2qMnR5MXZ5/It6Xulkx7c
ItL7EALtN87sq1wdVMCWhnNXmiENU7ZKs8INoml7R9VNuOVbhP06TT0xqV1RMoJJ
6tadkrUx8dCqg713Zso1cTDe2srv8XocMziw4/IcNLdfhLpPGiEqAKnUAr4jjiQ8
BxPzPBPxLbUbxMETVFaRWLNExo15Dex3+2Yx9YLh0EPy8gmv1so=
=DCxJ
-----END PGP SIGNATURE-----

--qdpckhs7d4eiq2dv--
