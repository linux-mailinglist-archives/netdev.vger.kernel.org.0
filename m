Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4259D3EA068
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 10:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbhHLIQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 04:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235084AbhHLIQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 04:16:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76065C061765
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 01:16:09 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mE5rm-0002LU-Am; Thu, 12 Aug 2021 10:15:06 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mE5rb-0002s2-AN; Thu, 12 Aug 2021 10:14:55 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mE5rb-0006R3-8Y; Thu, 12 Aug 2021 10:14:55 +0200
Date:   Thu, 12 Aug 2021 10:14:25 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-pci@vger.kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        oss-drivers@corigine.com, Paul Mackerras <paulus@samba.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Rafa?? Mi??ecki <zajec5@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Vadym Kochan <vkochan@marvell.com>, Michael Buesch <m@bues.ch>,
        Jiri Pirko <jiri@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        netdev@vger.kernel.org, Simon Horman <simon.horman@corigine.com>,
        Oliver O'Halloran <oohall@gmail.com>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 4/8] PCI: replace pci_dev::driver usage that gets the
 driver name
Message-ID: <20210812081425.7pjy4a25e2ehkr3x@pengutronix.de>
References: <20210811080637.2596434-1-u.kleine-koenig@pengutronix.de>
 <20210811080637.2596434-5-u.kleine-koenig@pengutronix.de>
 <YRTIqGm5Dr8du7a7@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="n62mnckfisrc5gc5"
Content-Disposition: inline
In-Reply-To: <YRTIqGm5Dr8du7a7@infradead.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--n62mnckfisrc5gc5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 12, 2021 at 08:07:20AM +0100, Christoph Hellwig wrote:
> On Wed, Aug 11, 2021 at 10:06:33AM +0200, Uwe Kleine-K??nig wrote:
> >  static inline const char *eeh_driver_name(struct pci_dev *pdev)
> >  {
> > -	return (pdev && pdev->driver) ? pdev->driver->name : "<null>";
> > +	const char *drvstr =3D pdev ? dev_driver_string(&pdev->dev) : "";
> > +
> > +	if (*drvstr =3D=3D '\0')
> > +		return "<null>";
> > +
> > +	return drvstr;
>=20
> This looks rather obsfucated due to the fact that dev_driver_string
> never returns '\0', and due to the strange mix of a tenary operation
> and the if on a related condition.

dev_driver_string() might return "" (via dev_bus_name()). If that happens
*drvstr =3D=3D '\0' becomes true.

Would the following be better?:

	const char *drvstr;

	if (pdev)
		return "<null>";

	drvstr =3D dev_driver_string(&pdev->dev);

	if (!strcmp(drvstr, ""))
		return "<null>";

	return drvstr;

When I thought about this hunk I considered it ugly to have "<null>" in
it twice.

> >  }
> > =20
> >  #endif /* CONFIG_EEH */
> > diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
> > index 69c10a7b7c61..dc2ffa686964 100644
> > --- a/drivers/bcma/host_pci.c
> > +++ b/drivers/bcma/host_pci.c
> > @@ -175,9 +175,10 @@ static int bcma_host_pci_probe(struct pci_dev *dev,
> >  	if (err)
> >  		goto err_kfree_bus;
> > =20
> > -	name =3D dev_name(&dev->dev);
> > -	if (dev->driver && dev->driver->name)
> > -		name =3D dev->driver->name;
> > +	name =3D dev_driver_string(&dev->dev);
> > +	if (*name =3D=3D '\0')
> > +		name =3D dev_name(&dev->dev);
>=20
> Where does this '\0' check come from?

The original code is equivalent to

	if (dev->driver && dev->driver->name)
		name =3D dev->driver->name;
	else:
		name =3D dev_name(...);

As dev_driver_string() implements something like:

	if (dev->driver && dev->driver->name)
		return dev->driver->name;
	else
		return "";

the change looks fine to me. (One could wonder if it's sensible to fall
back to the device name if the driver has no nice name, but this isn't
new with my change.)

> > +	name =3D dev_driver_string(&dev->dev);
> > +	if (*name =3D=3D '\0')
> > +		name =3D dev_name(&dev->dev);
> > +
>=20
> More of this weirdness.

I admit it's not pretty. Would it help to use !strcmp(name, "")
instead of *name =3D=3D '\0'? Any other constructive suggestion?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--n62mnckfisrc5gc5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmEU2FkACgkQwfwUeK3K
7An+dgf/QrRVML0a6qk3HkGyLdsB8Vz7TG3WIJF9aLj4O2kfcEPwkNYsSxN/21iu
rEFabdOH9lU5Zd2HWHmas7GEMR232ZquxQiELI+9rh01/2S6Y/u/6AVGLvdzqFVZ
rXTrEHH02r9SqMl/V0Z/M7VIltjkbZwF4eSLW4+5+hHb65DACabRPBWTAjvotPU4
0WlKPyYnJf0uVw9UF7NqDkXjgdyYzRf0lM6Ie9SLp3JctB9pqnVCu4JQSqBln0Ri
AoFiE71+XFMORrsnY4gr2qdjhzoIRRGvDVVZ1BqXx0WZ7ZTzxcWXBg4xzrjF5kw0
FlVhUnMK0NFPQnBoNJXA7B6UG7ZkvA==
=3HwH
-----END PGP SIGNATURE-----

--n62mnckfisrc5gc5--
