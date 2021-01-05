Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48032EAC1F
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 14:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbhAENoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 08:44:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbhAENoF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 08:44:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A267229C4;
        Tue,  5 Jan 2021 13:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609854204;
        bh=wIlnL1VAyIouVMBSrzUu5JMg84xwPJWp1BYOBKzgZ/Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tvWKEFipHEDorOQU8OnU/LqjLJCoa7lP+Aafx3JLPVskDJ6tt1NXyYlWBraWFGGE1
         V5ubiRc0+jpUzSNkExV72LsTkIHQ6jgbyqrzjK1RJCAdBXhRDXyzDDDBu0Py+Rplk8
         F42hBCxBHvQCr3QQ0GnK+AVF+qqgPWfHhdZDiW+iGYmlQSknYpK3eFfIDFxGMyTnHY
         GCuDY+xIS7eufA7abSYllLvAWIL9/nnhtHcGBNl4EAowOLTn+/7sLamfdjkFldiVRe
         ezBjwTWAL9uzIDeYfPRtA9m4mACI05DbSqb8kAacFag/mj2ESMZsLxuW7t61XSuGbI
         WsDiprh/w/5og==
Date:   Tue, 5 Jan 2021 13:42:56 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>, lee.jones@linaro.org
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20210105134256.GA4487@sirena.org.uk>
References: <20201218155204.GC5333@sirena.org.uk>
 <20201218162817.GX552508@nvidia.com>
 <20201218180310.GD5333@sirena.org.uk>
 <20201218184150.GY552508@nvidia.com>
 <20201218203211.GE5333@sirena.org.uk>
 <20201218205856.GZ552508@nvidia.com>
 <20201221185140.GD4521@sirena.org.uk>
 <20210104180831.GD552508@nvidia.com>
 <20210104211930.GI5645@sirena.org.uk>
 <20210105001341.GL552508@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20210105001341.GL552508@nvidia.com>
X-Cookie: I'm ANN LANDERS!!  I can SHOPLIFT!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 04, 2021 at 08:13:41PM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 04, 2021 at 09:19:30PM +0000, Mark Brown wrote:

> > Like I keep saying the same thing applies to all non-enumerable buses -
> > exactly the same considerations exist for all the other buses like I2C
> > (including the ACPI naming issue you mention below), and for that matter
> > with enumerable buses which can have firmware info.

> And most busses do already have their own bus type. ACPI, I2C, PCI,
> etc. It is just a few that have been squished into platform, notably
> OF.

You're missing the point there.  I2C is enumerated by firmware in
exactly the same way as the platform bus is, it's not discoverable from
the hardware (and similarly for a bunch of other buses).  If we were to
say that we need separate device types for platform devices enumerated
using firmware then by analogy we should do the same for devices on
these other buses that happen to be enumerated by firmware.

I'm not convinced this is actually the design that's being pushed by
Greg here, to the extent anything is being actively pushed.

> But now it begs the question, why not push harder to make 'struct
> device' the generic universal access point and add some resource_get()
> API along these lines so even a platform_device * isn't needed?

We still need a struct device of some kind so the discussions about
exactly which bus type one is supposed to use in which circumstances
remain given that you're not supposed to have raw struct devices.

> Then the path seems much clearer, add a multi-bus-type device_driver
> that has a probe(struct device *) and uses the 'universal api_get()'
> style interface to find the generic 'resources'.

That's exactly how things like mixed I2C/SPI devices work at present,
given that they can usually use regmap to hide register I/O.

> int gpiod_count(struct device *dev, const char *con_id)
> {
> 	int count =3D -ENOENT;

> 	if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node)
> 		count =3D of_gpio_get_count(dev, con_id);
> 	else if (IS_ENABLED(CONFIG_ACPI) && dev && ACPI_HANDLE(dev))
> 		count =3D acpi_gpio_count(dev, con_id);
>=20
> 	if (count < 0)
> 		count =3D platform_gpio_count(dev, con_id);

> With an actual bus specific virtual function:

>     return dev->bus->gpio_count(dev);

That won't work, you might have a mix of enumeration types for a given
bus type in a single system so you'd need to do this per device.  It's
also not clear to me that it is useful to spread things out like this,
it makes it more hassle to add new APIs since you have to change core
code.

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/0bOAACgkQJNaLcl1U
h9ASGQf+PqdAMqCv0v40Pazm4IUU5EhqpiFSYI0ApyvEeiC+ax6gxyaqepjUv9Iy
QVScfPevt2Q95DSeFBBbTl0tNmGp6xVJedt1bb3f7O8tT6Og47jvopRj9Ng6Eua3
WBAXS1FsNefwO1XYB7lZbIPoGtZ3e93zDC3Lhfk8OMSzobu6Oc62xkHOV70E+TAK
WWk2LX/abBhoGcP71eh6HmH/iSoSrjZFIamO3KNmZ46oq7aDLbIM658cy0/vku0j
Ed6tn2HjxxT+UaQ4Fh6Egs8MldDGQWwBdvjo6+i8+zTKy+TDbq+ftf0YOjfHPNn/
BLq3yUaioOz3/qxoY/b+oWE2kwZ2Tg==
=DXq7
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
