Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97645393AE2
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 03:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234892AbhE1BI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 21:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhE1BIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 21:08:24 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3230C061574;
        Thu, 27 May 2021 18:06:50 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Frmjf74GPz9sRN;
        Fri, 28 May 2021 11:06:46 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1622164007;
        bh=Ed/rZ1jwf8yCrTKrfseKLMV1OF8kQau1a1rDVJvFiEk=;
        h=Date:From:To:Cc:Subject:From;
        b=fjouGaYsB5c82ISvtbXDmSzVqqM2RIY4gxxBDX5rxR5K+HzAZPhsd/jad2NfRY2lw
         vwRQ9SJ7CoyqEUaT9gGcpNJmoRmYdHd8+rWnATJvsUQXjhH5ZTOBg7AR0lb4IDMuB4
         JH8LaJVQuHA/UXS5LFq4wJAL43nYabCcSQDmR26vZHG/jxjLLW5Day3Jc8FbOf342k
         rFDIWMQmUQOBnDQLg+fy3aEOSULY7HrfiOYoe3R44A1OUwubWNDH6ObEagMDNl0+qu
         fFQJBVdcEpWIh0mhKovwMFzb3bHb7JlOxqyrDzotyuIo87BELJ6zWFrfHl6ABUAMWe
         auCaCcXKkhJDQ==
Date:   Fri, 28 May 2021 11:06:44 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210528110644.79e015b3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/jr_C=BEezEUZkwZHolw/O3V";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/jr_C=BEezEUZkwZHolw/O3V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/core/devlink.c

between commit:

  b28d8f0c25a9 ("devlink: Correct VIRTUAL port to not have phys_port attrib=
utes")

from the net tree and commit:

  f285f37cb1e6 ("devlink: append split port number to the port name")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/core/devlink.c
index 051432ea4f69,69681f19388e..000000000000
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@@ -8630,12 -8631,11 +8630,10 @@@ static int __devlink_port_phys_port_nam
 =20
  	switch (attrs->flavour) {
  	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
- 		if (!attrs->split)
- 			n =3D snprintf(name, len, "p%u", attrs->phys.port_number);
- 		else
- 			n =3D snprintf(name, len, "p%us%u",
- 				     attrs->phys.port_number,
- 				     attrs->phys.split_subport_number);
 -	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
+ 		n =3D snprintf(name, len, "p%u", attrs->phys.port_number);
+ 		if (n < len && attrs->split)
+ 			n +=3D snprintf(name + n, len - n, "s%u",
+ 				      attrs->phys.split_subport_number);
  		break;
  	case DEVLINK_PORT_FLAVOUR_CPU:
  	case DEVLINK_PORT_FLAVOUR_DSA:

--Sig_/jr_C=BEezEUZkwZHolw/O3V
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCwQiUACgkQAVBC80lX
0GzvpAf/SJpFUw6ZLSDurRIiAfcT7d75zM3rb13w4qw4w3c6DwyiS8leC5SBxFDG
/yS/DeT6Su0n/b9PG27pMIaetJPaF8VWrTlJYx6zcYzxYQL28CpSarxdiRVDFJv5
Ldi3MeYnPETvjt7lVKtlcFafa/RlIyYxHmD7anyZ/irS2tOfIrmMQtz5Ld4EhLFk
XIDQvbghUgcohtPZBtZvM5H/zs1JWDanObnKh2AcLC1261Lvq2FcZPNt//fO3EXs
/PET9I6QoPZKs4yv/D103FIf2XMwYxhujMZ0Ram3V8BecZLZnRBFUb19PfudD5lG
cgNwSW28wX5+c2zQJoERIMhWhZcn9g==
=SWrg
-----END PGP SIGNATURE-----

--Sig_/jr_C=BEezEUZkwZHolw/O3V--
