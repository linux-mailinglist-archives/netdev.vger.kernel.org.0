Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554F85B2DA8
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 06:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiIIEoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 00:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIIEov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 00:44:51 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D18A3A15C;
        Thu,  8 Sep 2022 21:44:49 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MP3Lg1lZnz4xG8;
        Fri,  9 Sep 2022 14:44:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1662698684;
        bh=sm+WWIzGsWI5u8r+ZBU+o3ckddyGFvWK/U7hSkwsZxk=;
        h=Date:From:To:Cc:Subject:From;
        b=WbNqRXoBBsHOKrFuO15zdQLi0ugJX2sr0mDpnLffaQkCCoOCDk2ltDa1xSVR2hdo5
         jFOIUs8IcZfZ0TdLHZDHJ7/uJKVUFrMsvvaT5SBygakBw92M5Pl1pJUPfu405MjnMh
         ELOKnMWYI6+PoVb2mUrsrvKGaUvEdtuGlIbrsg30c8nbq+CU0mxtkkIpkXPt45iJm1
         1mV+nVfzYs2iA8x+21n/SRVYG+oI5PYCLbrAXZYIxXjlp0rlxzjkluldkVK81Kxm4i
         +5E6XM1efGslVwepE/j2SU9d2uizDrNGRXwbx3/w5hjnDe0MVg6J2vVJyYYejSBgQ2
         odAEmNFnZ9KDw==
Date:   Fri, 9 Sep 2022 14:44:36 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Alex Williamson <alex.williamson@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: linux-next: manual merge of the vfio tree with the net-next tree
Message-ID: <20220909144436.6c08b042@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/V.6.KXDO5sCncmq/FpTf_Dp";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/V.6.KXDO5sCncmq/FpTf_Dp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the vfio tree got conflicts in:

  drivers/net/ethernet/mellanox/mlx5/core/fw.c
  drivers/net/ethernet/mellanox/mlx5/core/main.c

between commit:

  8ff0ac5be144 ("net/mlx5: Add MACsec offload Tx command support")

from the net-next tree and commit:

  939838632b91 ("net/mlx5: Query ADV_VIRTUALIZATION capabilities")

from the vfio tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ethernet/mellanox/mlx5/core/fw.c
index c63ce03e79e0,483a51870505..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@@ -273,13 -273,12 +273,19 @@@ int mlx5_query_hca_caps(struct mlx5_cor
  			return err;
  	}
 =20
 +	if (MLX5_CAP_GEN_64(dev, general_obj_types) &
 +	    MLX5_GENERAL_OBJ_TYPES_CAP_MACSEC_OFFLOAD) {
 +		err =3D mlx5_core_get_caps(dev, MLX5_CAP_MACSEC);
 +		if (err)
 +			return err;
 +	}
 +
+ 	if (MLX5_CAP_GEN(dev, adv_virtualization)) {
+ 		err =3D mlx5_core_get_caps(dev, MLX5_CAP_ADV_VIRTUALIZATION);
+ 		if (err)
+ 			return err;
+ 	}
+=20
  	return 0;
  }
 =20
diff --cc drivers/net/ethernet/mellanox/mlx5/core/main.c
index b45cef89370e,de9c315a85fc..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@@ -1507,7 -1488,7 +1507,8 @@@ static const int types[] =3D=20
  	MLX5_CAP_IPSEC,
  	MLX5_CAP_PORT_SELECTION,
  	MLX5_CAP_DEV_SHAMPO,
 +	MLX5_CAP_MACSEC,
+ 	MLX5_CAP_ADV_VIRTUALIZATION,
  };
 =20
  static void mlx5_hca_caps_free(struct mlx5_core_dev *dev)

--Sig_/V.6.KXDO5sCncmq/FpTf_Dp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMaxLQACgkQAVBC80lX
0GwXkAf/T/ctlhzVwkBDFkrltaOcAu9kCrwx0bG9/GtSqRfhfRHdkOBDCWWKtpmL
Q5K5vj5wPSM/PxSNg1cNL3fNCXSK87M+AtwxEfISPJpGrAbJKSwR/pAsRCR7I5KQ
/wZJ2QSLGNQkKShdqZo6a896XmWGt3UCPttUwTTAy/HDdthxeXz2+vRSVtmuykcs
rB6Nl/EIqFlmeHSm5VCAeMue9W63N1M2Orx1Y8a3s46n+tEeoGibudiYkuxsXcaP
9LXjAcfkN8OxTbfUpRe8tZuNZJ5frrgsRvMH43DMNnJKnpRpDWqfzAAu4TrHSR3V
klGVNDHoN7FH0Gvh9ZZbLYsLIK91vA==
=Mm/o
-----END PGP SIGNATURE-----

--Sig_/V.6.KXDO5sCncmq/FpTf_Dp--
