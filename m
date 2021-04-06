Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8AD3354B62
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 05:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243571AbhDFDtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 23:49:25 -0400
Received: from ozlabs.org ([203.11.71.1]:39571 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233639AbhDFDtY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 23:49:24 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FDtn65N4Wz9sSC;
        Tue,  6 Apr 2021 13:49:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1617680955;
        bh=2V41qytuS/O/lB46Y0+hixtZSve/HcH+r1+SdAlGDyw=;
        h=Date:From:To:Cc:Subject:From;
        b=bWEpKd1FZXu/0BmAT35fkgGDNFerfySzMTlXhSa2aR2h5EWchEBlFjdonYv0Pu0z1
         IqK2tWoENJaoZxbkwNkGJJCZQ6WQf+C/1waNyskqdADwjOOd6aGOY8tqM+dvYqJnG0
         kc3uFMdWCaepdIUdClsVQ0SMNpYgnhWfTcnWRU5OK+pTO27iKETZK+IjQ5YB8zJTcg
         7rwE8D0aKSIC4QlDvwRyd3ioGsmiuTMMWvBdn5sPu7NQ8KOJz+ngOEp3R9nK+Yz+zW
         bAPuki2Hcw5elikCVp52nKb2Yju8i6aeZGFIQwwcfFbxW3Y7tDQbj73ieqvee46P+A
         uZy+e4CDz9vQQ==
Date:   Tue, 6 Apr 2021 13:49:12 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210406134912.6a37cdcd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/8sX8bvoQhgeb..HCd.THkED";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/8sX8bvoQhgeb..HCd.THkED
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/en_main.c

between commit:

  3ff3874fa0b2 ("net/mlx5e: Guarantee room for XSK wakeup NOP on async ICOS=
Q")

from the net tree and commits:

  c276aae8c19d ("net/mlx5: Move mlx5e hw resources into a sub object")
  b3a131c2a160 ("net/mlx5e: Move params logic into its dedicated file")

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

diff --cc drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 5db63b9f3b70,773449c1424b..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@@ -1090,8 -1040,7 +1040,8 @@@ static int mlx5e_alloc_icosq(struct mlx
  	int err;
 =20
  	sq->channel   =3D c;
- 	sq->uar_map   =3D mdev->mlx5e_res.bfreg.map;
+ 	sq->uar_map   =3D mdev->mlx5e_res.hw_objs.bfreg.map;
 +	sq->reserved_room =3D param->stop_room;
 =20
  	param->wq.db_numa_node =3D cpu_to_node(c->cpu);
  	err =3D mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);

--Sig_/8sX8bvoQhgeb..HCd.THkED
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBr2jgACgkQAVBC80lX
0GyMqwf+JeRySGfwOKnE6szKkSCpgP3vQ2pxlsivZ4LzQYS1UHHWZCnIkYqtHaUh
ozDRkBUNc3JqJXQC9X0rAjT7s+bgNz7YPmAK1h200bvZodvjv9QyhF8YK+jrUSNn
dHwNd58nc6Gx1yNQuLyn4tb+1oZNyZs0me1CuVJnufb5elhQ+rcEEMDuyWam5vSF
9jl5v5n9Zi+LuNKHlWtJBVVz7RNDz1122DaKYZ7SCn41SK4C53cDnYFmFDkyedsk
P/4EpdG3moDpMaVQHGoeCsY6cIzND99nyxo4zYrFKRvXquNZ4+GD9nZE8yNQ4inz
pZxNFXKvARNECeIeyiLeCIbDA2biMA==
=Q8fT
-----END PGP SIGNATURE-----

--Sig_/8sX8bvoQhgeb..HCd.THkED--
