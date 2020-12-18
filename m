Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AB22DE6F9
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 16:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgLRPw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 10:52:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725949AbgLRPw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 10:52:59 -0500
Date:   Fri, 18 Dec 2020 15:52:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608306738;
        bh=hh6kmTaYw7S1ycwZ4+Gi2lG2vKviQu4KRDfzNgRJMMs=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=UyU1MPj7dIcBqLmjerLEZsmEzC9n1onWw7rJnwndCFVtu521SPmOch8eA090w9V2H
         ebUvciuQh2tgliNsbPhJ+d7famGJ5HrWsYQXOFYFawsqG7YFaYaENY1wZ3I+lQvhM3
         sBTMAP+TWsAs/Y2hGXv08Pw61G+jsbNEjrvVOliXG1QnXFRMS7pL33FrykEC15cAbc
         2EPJnk8WkKwkraXP8CJjbdl6y+P9OpU1+fs8usTsCYpva/XnIg5e4tdCor3867HRms
         tVOavWiyg+wnpW7nD1Pb2LmOxcN9bu82ySjirX3es0l64KZmVFEC9qMU+j+GVrqdxQ
         J63Ghc7zBNX5A==
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
Message-ID: <20201218155204.GC5333@sirena.org.uk>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
 <CAPcyv4iLG7V9JT34La5PYfyM9378acbLnkShx=6pOmpPK7yg3A@mail.gmail.com>
 <X8usiKhLCU3PGL9J@kroah.com>
 <20201217211937.GA3177478@piout.net>
 <X9xV+8Mujo4dhfU4@kroah.com>
 <20201218131709.GA5333@sirena.org.uk>
 <20201218140854.GW552508@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ABTtc+pdwF7KHXCz"
Content-Disposition: inline
In-Reply-To: <20201218140854.GW552508@nvidia.com>
X-Cookie: Password:
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ABTtc+pdwF7KHXCz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 18, 2020 at 10:08:54AM -0400, Jason Gunthorpe wrote:
> On Fri, Dec 18, 2020 at 01:17:09PM +0000, Mark Brown wrote:

> > As previously discussed this will need the auxilliary bus extending to
> > support at least interrupts and possibly also general resources.

> I thought the recent LWN article summed it up nicely, auxillary bus is
> for gluing to subsystems together using a driver specific software API
> to connect to the HW, MFD is for splitting a physical HW into disjoint
> regions of HW.

This conflicts with the statements from Greg about not using the
platform bus for things that aren't memory mapped or "direct firmware",
a large proportion of MFD subfunctions are neither at least in so far as
I can understand what direct firmware means.

To be honest I don't find the LWN article clarifies things particularly
here, the rationale appears to involve some misconceptions about what
MFDs look like.  It looks like it assumes that MFD functions have
physically separate register sets for example which is not a reliable
feature of MFDs, nor is the assumption that there's no shared
functionality which appears to be there.  It also appears to assume that
MFD subfunctions can clearly be described by ACPI (where it would be
unidiomatic, we just don't see this happening for the MFDs that appear
on ACPI systems and I'm not sure bindings exist within ACPI) or DT
(where even where subfunctions are individually described it's rarely
doing more than enumerating that things exist).

> Maybe there is some overlap, but if you want to add HW representations
> to the general auxillary device then I think you are using it for the
> wrong thing.

Even for the narrowest use case for auxiliary devices that I can think
of I think the assumption that nobody will ever design something which
can wire an interrupt intended to be serviced by a subfunction is a bit
optimistic.  If Greg's statements about not using platform buses for
MMIO or direct firmware devices are accurate then those cases already
exist, if nothing else a common subfunction for MFDs is an interrupt
controller.

--ABTtc+pdwF7KHXCz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/c0CMACgkQJNaLcl1U
h9AEzwf+O76Uw7BDG33tM6xhLOwoq847RdyVqkI6RrFlyIlLsFlIt49fbXRIuXTF
Pviz3SUZ268ihxH3NrtuGLDtkdVL70oKo26hEppOtp877dhmkjK/BCnnkqIiERro
4Hpxo/eoIjqT0lnx+ah2ge9q5cDhT9s1mMH8vkvdOSGa2a9z71uYEzOARmvUbXy9
LK4/z9VmLS0wmO6YPxwc4Nq6afaa0m/yGhGFxu2aKT9aKfzbBIywl6WFllPz1Y1H
G+ZxfgLJ6sZON36FToD7/FEDUuZxBUGjA5d2txOX0xpx/ZsnvapoRypEvotufObZ
ZVX/PBjkUnHdClRckKl3LHCok9Xw1w==
=lhpS
-----END PGP SIGNATURE-----

--ABTtc+pdwF7KHXCz--
