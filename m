Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770CC39AFA8
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 03:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhFDBaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 21:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFDBaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 21:30:19 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F47C06174A;
        Thu,  3 Jun 2021 18:28:29 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Fx4sQ3TgZz9sRf;
        Fri,  4 Jun 2021 11:28:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1622770107;
        bh=fbiMm/6D+EMXXuvCTl2YHi4jeP5oQF9xPK70dRUIBPA=;
        h=Date:From:To:Cc:Subject:From;
        b=KqYAVA3V0ieVbj54Tbd+NG5uFP/b0aP1wQkd1U6EHH6Igem8mSMoTmxqAaqu/2cQc
         U8tpJi5CyTZJNe/WL965V9TMy3RpIadvBZrG4qRwcfFqawucWcNM38pHuEepaIDH2t
         ZGmZlSyqI0qU7i7Qw5cFGMLi+yhd5uCazVRCaaPO3Qxna++eU5AWVk2SMMLkd48FQi
         M8AIaiR4d02E1ZtZipWIaj768g3JTSMWC9Rn24JQXfV9SvSp2VNlTKV43JiJ6tx0zC
         L9rGJ0FkKDEljmhMgAv0UdFGNK1Z2lbofNVMHfLb9obfBMc1FK4d4Ov4UseBbSVzpj
         q8DY/xlzKvh5Q==
Date:   Fri, 4 Jun 2021 11:28:25 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Sriranjani P <sriranjani.p@samsung.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210604112825.011148a3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/yix.nsB042Is1A_3FID+5_V";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/yix.nsB042Is1A_3FID+5_V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c

between commit:

  593f555fbc60 ("net: stmmac: fix kernel panic due to NULL pointer derefere=
nce of mdio_bus_data")

from the net tree and commit:

  11059740e616 ("net: pcs: xpcs: convert to phylink_pcs_ops")

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

diff --cc drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c87202cbd3d6,6d41dd6f9f7a..000000000000
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@@ -1240,9 -1222,7 +1222,9 @@@ static int stmmac_phy_setup(struct stmm
  	priv->phylink_config.dev =3D &priv->dev->dev;
  	priv->phylink_config.type =3D PHYLINK_NETDEV;
  	priv->phylink_config.pcs_poll =3D true;
- 	if (priv->plat->mdio_bus_data)
 -	priv->phylink_config.ovr_an_inband =3D mdio_bus_data->xpcs_an_inband;
++	if (mdio_bus_data)
 +		priv->phylink_config.ovr_an_inband =3D
- 			priv->plat->mdio_bus_data->xpcs_an_inband;
++			mdio_bus_data->xpcs_an_inband;
 =20
  	if (!fwnode)
  		fwnode =3D dev_fwnode(priv->device);

--Sig_/yix.nsB042Is1A_3FID+5_V
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmC5gbkACgkQAVBC80lX
0GxvRQgAjaWUMCoJpTNhSdCO7D+O7Y+e/0gVuFglBuB0/rvwirk6auAW7X53m2ss
Ix+dpdwLHB2KfCvsXAGm02UV7wLHZLqAy9VB/UKtwtNS2ssvZUl0+ijeIliZsRlf
CjRojK7eCEIr/sE9qHhZRhbmRF0s9TXiVUepK3dfnNgzBGtckuJFMbLQfSF9YyzC
SVMfuOc74xK54bA0QOYp4K8qc3iWykBQ1kNVA5sngcsZiEXaDHa6EV6RzscLdW1p
ZZLbvoqHt1OJ+PDBcgwfiB+Drf6fAXOovHo0RwwOkRo+SqOm8qf5/amnGsKVW4vA
BI00/fQLlIHZ/L2xXtR4a/i3cezpcg==
=Y+w9
-----END PGP SIGNATURE-----

--Sig_/yix.nsB042Is1A_3FID+5_V--
