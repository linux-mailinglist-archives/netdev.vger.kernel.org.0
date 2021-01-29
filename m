Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED8D3082B3
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhA2AvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:51:03 -0500
Received: from ozlabs.org ([203.11.71.1]:56867 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231601AbhA2Atc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 19:49:32 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DRdxl4GwYz9sVF;
        Fri, 29 Jan 2021 11:48:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1611881324;
        bh=88acUbfYTRBOBCPuXAqi5VimIreMPtP2EqSf1zjse/w=;
        h=Date:From:To:Cc:Subject:From;
        b=GNDv/dtM1i45G+pPLwEZkZB5OmHLRRpDX0heUBdM7Ng2s4W4l+K+lE4gOAXZFKNhb
         GFh+lgt0v0RPUhDkfR1uAgKeVMwCc0mh08BHQkLUdrDb0WzdTVF87t4UyPShUE0d3d
         KA0xJk0zJsMJZG77lf6vSXKk10bUMr9hIx1fIlA90VmZcVrvVeU+7qJWh5X4QAcbTt
         ZvHmTiWLheR4s7Ve1qfC1hoO/YWDVS9dCVoWsLGXX5QZzUPkWEDrf2g8ycMaiOGkEZ
         qm+wOhQXFRhGekTL+if37aVI+84hkhT9Im4Xd3E7/hn+yQhXb0SO81AdzcY0Oz6Cdn
         GzYKeveW2gyWw==
Date:   Fri, 29 Jan 2021 11:48:42 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20210129114842.1174a9c8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Dlvl3zBc_yGdX10nioAsaxH";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Dlvl3zBc_yGdX10nioAsaxH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/switchdev/switchdev.c

between commit:

  20776b465c0c ("net: switchdev: don't set port_obj_info->handled true when=
 -EOPNOTSUPP")

from Linus' tree and commits:

  ffb68fc58e96 ("net: switchdev: remove the transaction structure from port=
 object notifiers")
  bae33f2b5afe ("net: switchdev: remove the transaction structure from port=
 attributes")

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

diff --cc net/switchdev/switchdev.c
index 2c1ffc9ba2eb,855a10feef3d..000000000000
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@@ -460,11 -388,9 +388,10 @@@ static int __switchdev_handle_port_obj_
  	extack =3D switchdev_notifier_info_to_extack(&port_obj_info->info);
 =20
  	if (check_cb(dev)) {
- 		err =3D add_cb(dev, port_obj_info->obj, port_obj_info->trans,
- 			     extack);
 -		/* This flag is only checked if the return value is success. */
 -		port_obj_info->handled =3D true;
 -		return add_cb(dev, port_obj_info->obj, extack);
++		err =3D add_cb(dev, port_obj_info->obj, extack);
 +		if (err !=3D -EOPNOTSUPP)
 +			port_obj_info->handled =3D true;
 +		return err;
  	}
 =20
  	/* Switch ports might be stacked under e.g. a LAG. Ignore the
@@@ -570,10 -493,8 +495,10 @@@ static int __switchdev_handle_port_attr
  	int err =3D -EOPNOTSUPP;
 =20
  	if (check_cb(dev)) {
- 		err =3D set_cb(dev, port_attr_info->attr, port_attr_info->trans);
 -		port_attr_info->handled =3D true;
 -		return set_cb(dev, port_attr_info->attr);
++		err =3D set_cb(dev, port_attr_info->attr);
 +		if (err !=3D -EOPNOTSUPP)
 +			port_attr_info->handled =3D true;
 +		return err;
  	}
 =20
  	/* Switch ports might be stacked under e.g. a LAG. Ignore the

--Sig_/Dlvl3zBc_yGdX10nioAsaxH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmATW2oACgkQAVBC80lX
0GwgrggAl2ACJCQVH2rteoxv0XN3FoaD6N4rTG7f8HOGNVK8pks8QeEEpIuj3s2H
PWRkI+TxrCmlmwV6xBwf2/Rc+dTA2ytkuFzCwvAGkN6kME6FUd+Qba+G8KGA+klQ
bCMAgPbakEbXFwAkIqBpAzMD1N2BMR0dJtVsnQSl4ucb8Cv8N2ESlqWscn/KQWhm
/GUr0IaqP3w/YNvn9bvEPKCLKoHrmfjmjdJoJrjVvflj2ayW6N6o1tj2JPxeM8nv
W0StOqsmbp6tIqmxT+segyI047W/0N5VLi3sI0+pfgJ1JOzBIVS7pbUeqwfOMJ+n
Wyj+J0P1+uyv3wLBCnx920pYeAhe3Q==
=k3Dn
-----END PGP SIGNATURE-----

--Sig_/Dlvl3zBc_yGdX10nioAsaxH--
