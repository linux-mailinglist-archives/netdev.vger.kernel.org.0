Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0654E2D5F33
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 16:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391636AbgLJOrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 09:47:10 -0500
Received: from mail.katalix.com ([3.9.82.81]:48560 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391610AbgLJOrJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 09:47:09 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 44D2B86B47;
        Thu, 10 Dec 2020 14:46:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1607611584; bh=flbSlFzzjBJZYzrs7L3DQldd/zchSqJ2a/QY45poB8Y=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Thu,=2010=20Dec=202020=2014:46:23=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Guillaume=20Nault=20<gnault@re
         dhat.com>|Cc:=20netdev@vger.kernel.org,=20jchapman@katalix.com|Sub
         ject:=20Re:=20[PATCH=20v3=20net-next=201/2]=20ppp:=20add=20PPPIOCB
         RIDGECHAN=20and=0D=0A=20PPPIOCUNBRIDGECHAN=20ioctls|Message-ID:=20
         <20201210144623.GA4413@katalix.com>|References:=20<20201204163656.
         1623-1-tparkin@katalix.com>=0D=0A=20<20201204163656.1623-2-tparkin
         @katalix.com>=0D=0A=20<20201207162228.GA28888@linux.home>|MIME-Ver
         sion:=201.0|Content-Disposition:=20inline|In-Reply-To:=20<20201207
         162228.GA28888@linux.home>;
        b=LlncYMbcLyV4uXjtUhDN2YokE1FD8QAtb7O5TZ53nunQugz9qlAfhKfhm6xhwmsIm
         AVq+dSr31zUU3fmTeUR+wxZVEeLkz7SaQruYlTb0lL2S2yVTuoPtbF3Z4H4DxOYE7W
         E8QeIDCXOx2+cEUFFgdwQmP09Eci8tPAPWl7cw7ZHru7RwOGOfFCYec4Aprxs6qLpO
         pZ/Bhq8jrQBzXiRv9J4usTGULsA/Dd68AoFZy5IUTELSYbPU07o+02mD835j1Lf1LO
         GlimJyQ7MmSdmYck9f5Tj08ZeysvSlgDSaDiHxaI1KHOH/pS0t0gd8w6I2s83Bg3i9
         foABTiSqycfjA==
Date:   Thu, 10 Dec 2020 14:46:23 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH v3 net-next 1/2] ppp: add PPPIOCBRIDGECHAN and
 PPPIOCUNBRIDGECHAN ioctls
Message-ID: <20201210144623.GA4413@katalix.com>
References: <20201204163656.1623-1-tparkin@katalix.com>
 <20201204163656.1623-2-tparkin@katalix.com>
 <20201207162228.GA28888@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20201207162228.GA28888@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Mon, Dec 07, 2020 at 17:22:28 +0100, Guillaume Nault wrote:
> On Fri, Dec 04, 2020 at 04:36:55PM +0000, Tom Parkin wrote:
> > +		case PPPIOCBRIDGECHAN:
> > +			if (get_user(unit, p))
> > +				break;
> > +			err =3D -ENXIO;
> > +			pn =3D ppp_pernet(current->nsproxy->net_ns);
> > +			spin_lock_bh(&pn->all_channels_lock);
> > +			pchb =3D ppp_find_channel(pn, unit);
> > +			/* Hold a reference to prevent pchb being freed while
> > +			 * we establish the bridge.
> > +			 */
> > +			if (pchb)
> > +				refcount_inc(&pchb->file.refcnt);
>=20
> The !pchb case isn't handled. With this code, if ppp_find_channel()
> returns NULL, ppp_bridge_channels() will crash when trying to lock
> pchb->upl.

Bleh :-(

Apologies for this.  I have stepped up my tests for "unhappy" code
paths, and I'll try to run syzkaller at a v4 prior to re-submitting.

> > +			spin_unlock_bh(&pn->all_channels_lock);
> > +			err =3D ppp_bridge_channels(pch, pchb);
> > +			/* Drop earlier refcount now bridge establishment is complete */
> > +			if (refcount_dec_and_test(&pchb->file.refcnt))
> > +				ppp_destroy_channel(pchb);
> > +			break;
> > +
>=20
> The rest looks good to me.

Thanks!

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl/SNLsACgkQlIwGZQq6
i9DtlggAnbAbDmISD6/5UqXP1Z+fRSkC2+6MoOm7CUr4fwfr3tKpptImcgGUOLlb
2XDL4mKtstvrXmDanUV7S8NoGn3uPXc+s+onsce7V/WZockFKLjm1DhCfEpdnqof
te3w4KT/cbU4Ss9oU+UMJzmE4RWcJWYlNQyNkJfMolSZJGtjlclw49aylgrr3F0M
toX5T2nVOXwVe1Zc9P324PdmUog8u9HLVVsg9+vmR4XQRx/VY5zUsgXV3UVLB6QC
AGleZvqqkUMebzG/gLXARY2PIFSG7Dl7Ox2cPnu3KElFsdYuwdH3krKoA6wtSxRo
EV4d9ug+xR+rVNu0vxxG83SyGzC+fA==
=AO0W
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
