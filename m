Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92375A0544
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 02:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiHYAoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 20:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiHYAoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 20:44:18 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29628E443;
        Wed, 24 Aug 2022 17:44:16 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MCkk42Yr3z4x1P;
        Thu, 25 Aug 2022 10:44:11 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661388252;
        bh=1Vndnbf3NkpEVFZLd7szmH5QRxMEOYDzMqL/ri28+mU=;
        h=Date:From:To:Cc:Subject:From;
        b=gGR6P8c34BE3JjdMUhBLMYc7IuHArFZPEJ2fUKQigFW6kbSkvL3xjKOYLTrEuI7NV
         5YrxX0X4pOgfaBUA54IzAIx7g9jU2eLgxxECqOLkAoXsr37JRffSWfg4LwkmfLzQWR
         sMTqNM5n7wk8kCBLeok+gktHA0J78gKH2t8ERK/kpwGdKodq9IQD/zVdISsSn+jGPM
         OBRlIqKScfZyMtLchrGeRs5dPRTPnlrwR2UTCYwoJksyK3JT2RRBP6dyqV3HPvh6Iy
         oZI/vMb1eG3oJU4XlghPGnVp+sNLABrPg5bS59LfJtxJ4jOpFsgps//KgzHP6FfX5v
         SnYiVDJGPYUjQ==
Date:   Thu, 25 Aug 2022 10:44:10 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Lama Kayal <lkayal@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220825104410.67d4709c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/yxbc2kKvNljsdMLPlq08U/I";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/yxbc2kKvNljsdMLPlq08U/I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/en_fs.c

between commit:

  21234e3a84c7 ("net/mlx5e: Fix use after free in mlx5e_fs_init()")

from the net tree and commit:

  c7eafc5ed068 ("net/mlx5e: Convert ethtool_steering member of flow_steerin=
g struct to pointer")

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

diff --cc drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index e0ce5a233d0b,ef1dfbb78464..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@@ -1394,12 -1454,17 +1454,17 @@@ struct mlx5e_flow_steering *mlx5e_fs_in
  			goto err_free_vlan;
  	}
 =20
- 	return fs;
+ 	err =3D mlx5e_fs_ethtool_alloc(fs);
+ 	if (err)
+ 		goto err_free_tc;
 =20
+ 	return fs;
+ err_free_tc:
+ 	mlx5e_fs_tc_free(fs);
 -err_free_fs:
 -	kvfree(fs);
  err_free_vlan:
  	mlx5e_fs_vlan_free(fs);
 +err_free_fs:
 +	kvfree(fs);
  err:
  	return NULL;
  }

--Sig_/yxbc2kKvNljsdMLPlq08U/I
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMGxdoACgkQAVBC80lX
0GzU0Af/Vw/Q9clQ9Xgc6ZttXdvOTt5pZieU75s3WJD+to6UDUoCs/x43QcvA63U
4QJyKJ+/4y7TatEp8QVQkfMyLfeyPHva97MOWGYMLN+/m8OIqHNde9mSL6F9nRMe
I/FE3mct9gucyLcoN8yUz+qrJadENmw827s6Nbf7CpbFWYfJk4r6Q0OCsuilnE/d
8X67SRw0GWFkYgomGcUab7HJQYGN9dLA5ykSjchqy9jps7AuivUbbPM6HCpghLW6
kjfW3zBfx2Jze1KbgQcQe7ovf+5pHelkPcAjWpg/pDK8E84rU9tqwmapzweQP05X
QfXxPpTCPcu1PLw0KpK8ftsAE9OTMA==
=X7iz
-----END PGP SIGNATURE-----

--Sig_/yxbc2kKvNljsdMLPlq08U/I--
