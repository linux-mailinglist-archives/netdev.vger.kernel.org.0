Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF3E305C2
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 02:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfEaAZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 20:25:59 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37605 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfEaAZ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 20:25:59 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45FQGW4f6Yz9sDX;
        Fri, 31 May 2019 10:25:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1559262355;
        bh=zSm7pKnWmGtlSP5Cszh1yek7Et6ipYjizk37mVLQDWk=;
        h=Date:From:To:Cc:Subject:From;
        b=E7zN9t3GfHpWkYYChe1Ws8rTHORmXKWCbnho/6biYnfQg94BTb+gx2t2njCt22XNf
         5KOMUVScyix+um1zAjINp15ukJm+deUUE8hzD4codI43pumL1Q1b74fdDyWrAn+Rtz
         uVrYRSaTaPdlAAQYHAS1xs/FkGfvJVX+i0U2EXzWu0xgW0blm4NsrpB+4lrd+rb7rA
         W2mtr2QoliBmWpFnZoR5DDAa/ohsefSjMNgpGM40Ditmsrgo5DXvmslUUX5u1xlNW9
         wYSTKn0z2g2C1uhiqC4NOtBTV8NMY5jMQsXl+T33IowF2V226sxJKNcF1pwcz8Vj8h
         pWw4P9ygyn02Q==
Date:   Fri, 31 May 2019 10:25:53 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190531102553.21963774@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/9nWRv0t=KTrRSG3exrmFxVh"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/9nWRv0t=KTrRSG3exrmFxVh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/phy/phylink.c

between commit:

  c678726305b9 ("net: phylink: ensure consistent phy interface mode")

from the net tree and commit:

  27755ff88c0e ("net: phylink: Add phylink_mac_link_{up, down} wrapper func=
tions")

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

diff --cc drivers/net/phy/phylink.c
index 9044b95d2afe,68d0a89c52be..000000000000
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@@ -399,6 -414,36 +418,36 @@@ static const char *phylink_pause_to_str
  	}
  }
 =20
+ static void phylink_mac_link_up(struct phylink *pl,
+ 				struct phylink_link_state link_state)
+ {
+ 	struct net_device *ndev =3D pl->netdev;
+=20
++	pl->cur_interface =3D link_state.interface;
+ 	pl->ops->mac_link_up(pl->config, pl->link_an_mode,
 -			     pl->phy_state.interface,
 -			     pl->phydev);
++			     pl->cur_interface, pl->phydev);
+=20
+ 	if (ndev)
+ 		netif_carrier_on(ndev);
+=20
+ 	phylink_info(pl,
+ 		     "Link is Up - %s/%s - flow control %s\n",
+ 		     phy_speed_to_str(link_state.speed),
+ 		     phy_duplex_to_str(link_state.duplex),
+ 		     phylink_pause_to_str(link_state.pause));
+ }
+=20
+ static void phylink_mac_link_down(struct phylink *pl)
+ {
+ 	struct net_device *ndev =3D pl->netdev;
+=20
+ 	if (ndev)
+ 		netif_carrier_off(ndev);
+ 	pl->ops->mac_link_down(pl->config, pl->link_an_mode,
 -			       pl->phy_state.interface);
++			       pl->cur_interface);
+ 	phylink_info(pl, "Link is Down\n");
+ }
+=20
  static void phylink_resolve(struct work_struct *w)
  {
  	struct phylink *pl =3D container_of(w, struct phylink, resolve);

--Sig_/9nWRv0t=KTrRSG3exrmFxVh
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzwdJEACgkQAVBC80lX
0Gwgrwf/Yd0UmZuflVIpQOy57opRiCEoFfskS3ssDSvWIE1D29u5OwYilAsLkarE
bNkpEnCfIatYOyFrZMLnq7IwKm1qlvbdEONHvEU/kCEsWUbF1pLC+4i6Gyh/a3u4
bP03SbPPra5r2M4E+/kjadVo2sRO7vHfBAaEZkVv7245IB646TUA6wRSqY+v8bRa
qDDiMIbSSoo8ML0SCDUkVJp+Ga5M0BlFOfzHGv+N0biSsUocl/H5rT+14N6mPv5T
bJ5PTcuF2Kein0qKKkwCwPaeVfhDFhNKjI/P1XFYns0HnBHyhPYQx/qnGBnhkYPx
Ys8zcwK5YtIQQc6WOl80KU/ouncFDw==
=WZjm
-----END PGP SIGNATURE-----

--Sig_/9nWRv0t=KTrRSG3exrmFxVh--
