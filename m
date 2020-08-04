Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B3323B889
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 12:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgHDKPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 06:15:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:47576 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbgHDKPC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 06:15:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F2F1CB595;
        Tue,  4 Aug 2020 10:15:15 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E8FD06030D; Tue,  4 Aug 2020 12:14:56 +0200 (CEST)
Date:   Tue, 4 Aug 2020 12:14:56 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Adrian Pop <popadrian1996@gmail.com>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com,
        andrew@lunn.ch
Subject: Re: [PATCH] ethtool: Add QSFP-DD support
Message-ID: <20200804101456.4cfv4agv6etufi7a@lion.mk-sys.cz>
References: <20200731084725.7804-1-popadrian1996@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="t4v45t7gagw3pqcr"
Content-Disposition: inline
In-Reply-To: <20200731084725.7804-1-popadrian1996@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--t4v45t7gagw3pqcr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2020 at 11:47:25AM +0300, Adrian Pop wrote:
> The Common Management Interface Specification (CMIS) for QSFP-DD shares
> some similarities with other form factors such as QSFP or SFP, but due to
> the fact that the module memory map is different, the current ethtool
> version is not able to provide relevant information about an interface.
>=20
> This patch adds QSFP-DD support to ethtool. The changes are similar to
> the ones already existing in qsfp.c, but customized to use the memory
> addresses and logic as defined in the specifications document.
>=20
> Page 0x00 (lower and higher memory) are always implemented, so the ethtool
> expects at least 256 bytes if the identifier matches the one for QSFP-DD.
> For optical connected cables, additional pages are usually available (the
> contain module defined  thresholds or lane diagnostic information). In
> this case, ethtool expects to receive 768 bytes in the following format:
>=20
>     +----------+----------+----------+----------+----------+----------+
>     |   Page   |   Page   |   Page   |   Page   |   Page   |   Page   |
>     |   0x00   |   0x00   |   0x01   |   0x02   |   0x10   |   0x11   |
>     |  (lower) | (higher) | (higher) | (higher) | (higher) | (higher) |
>     |   128B   |   128B   |   128B   |   128B   |   128B   |   128B   |
>     +----------+----------+----------+----------+----------+----------
>=20
> Several functions from qsfp.c could be reused, so an additional parameter
> was added to each and the functions were moved to sff-common.c.
>=20
> Signed-off-by: Adrian Pop <popadrian1996@gmail.com>
> Tested-by: Ido Schimmel <idosch@mellanox.com>

AFAICS the kernel counterpart is going to reach mainline in 5.9-rc1
merge window. Please base your patch on "next" branch or wait until next
is merged into master after 5.8 release (which should be later today or
tomorrow).

> ---
>  Makefile.am  |   7 +-
>  qsfp-dd.c    | 561 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  qsfp-dd.h    | 236 ++++++++++++++++++++++
>  qsfp.c       |  60 ++----
>  qsfp.h       |   8 -
>  sff-common.c |  52 +++++
>  sff-common.h |  26 ++-
>  7 files changed, 894 insertions(+), 56 deletions(-)
>  create mode 100644 qsfp-dd.c
>  create mode 100644 qsfp-dd.h
>=20
> diff --git a/Makefile.am b/Makefile.am
> index 2abb274..9fd8024 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -17,7 +17,8 @@ ethtool_SOURCES +=3D \
>  		  smsc911x.c at76c50x-usb.c sfc.c stmmac.c	\
>  		  sff-common.c sff-common.h sfpid.c sfpdiag.c	\
>  		  ixgbevf.c tse.c vmxnet3.c qsfp.c qsfp.h fjes.c lan78xx.c \
> -		  igc.c
> +		  igc.c \
> +		  qsfp-dd.c qsfp-dd.h

There is no need to start a new line.

>  endif
> =20
>  if ENABLE_BASH_COMPLETION
> @@ -47,12 +48,12 @@ endif
> =20
>  TESTS =3D test-cmdline
>  check_PROGRAMS =3D test-cmdline
> -test_cmdline_SOURCES =3D test-cmdline.c test-common.c $(ethtool_SOURCES)=
=20
> +test_cmdline_SOURCES =3D test-cmdline.c test-common.c $(ethtool_SOURCES)
>  test_cmdline_CFLAGS =3D -DTEST_ETHTOOL
>  if !ETHTOOL_ENABLE_NETLINK
>  TESTS +=3D test-features
>  check_PROGRAMS +=3D test-features
> -test_features_SOURCES =3D test-features.c test-common.c $(ethtool_SOURCE=
S)=20
> +test_features_SOURCES =3D test-features.c test-common.c $(ethtool_SOURCE=
S)
>  test_features_CFLAGS =3D -DTEST_ETHTOOL
>  endif
> =20

Do not mix unrelated changes like whitespace cleanups with your
functional changes, it makes it harder to see what the patch is doing.
Please split the cleanups (there are some more in qsfp.c) into
a separate patch.

Michal

--t4v45t7gagw3pqcr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8pNRsACgkQ538sG/LR
dpW2GggA0m482JqxL0C2OK2aZHNLWoKzw6Kx7uWgl39Oqzusp3hX/aKZ6LG6PcN2
01f74kfTn5iYHCmwgtC0fvIQlk/06TOqQieGgXpgb9OMz9AOCuQa02zCQRAL4Bmk
Hxme9ayESK1rDYinBsXr5UXmBHolLUI1wCHmP0O1XC9QArXaZiKcgp2brtbMfRS2
NWnNg0qXtm084CsaO8RK9eoYfrD50HJAyqzoorIJWlo1h/qEPytym2IslRWljzPJ
nC+fz4x0mLsJpVDIPrqlHjbDU40gA78PMyBvUnhAL0MZK/REnPKekODrObLlBUJY
GSjRGhOdKbgegodN7G2IE2Wm4FZMQw==
=2ZqQ
-----END PGP SIGNATURE-----

--t4v45t7gagw3pqcr--
