Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E345D1C0C49
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 04:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgEACsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 22:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728024AbgEACsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 22:48:40 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E27C035494;
        Thu, 30 Apr 2020 19:48:40 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49CxX61SXrz9sRf;
        Fri,  1 May 2020 12:48:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1588301318;
        bh=nthjKoa9TzpmwJ6Aq/Yy+5WGkiCS71gXn8l2xE1Fxqo=;
        h=Date:From:To:Cc:Subject:From;
        b=RUisjCEU5xQNuuaT6SCVDyVyXGQgRMUCqk+jz/cOd7tPyUoMV5c74NW6mtA/qIDfB
         4AMYwkqZdunoZtZEcYgimK95xM3YE2HUkmOpv+iDSXVWcR6wf14eYrL22/IYgtTFwI
         aSYC9i+j/l0zI7Jxz17Zi54ARfopbvrUlzen44by9T7V8RAok3Dy4Z0M+13PjOIFGt
         XVOQsCAUTU9nmS+POiHtQQvxxys44AyFOGwgpxt2NkPQPXNhdMuPhhgMeWbXfR6q6H
         EMok332Ycesnj7lgve1rJsErgXMbwFb6hQ3sCDsIdNx45+xR5kD3RUWHngrzvh8kCF
         FdNIgd2Nv8Y5w==
Date:   Fri, 1 May 2020 12:48:36 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200501124836.1b375eea@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/kt_sz/5HT.hr3U=+bLtYLub";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/kt_sz/5HT.hr3U=+bLtYLub
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c

between commit:

  8075411d93b6 ("net/mlx5: DR, On creation set CQ's arm_db member to right =
value")

from the net tree and commit:

  73a75b96fc9a ("net/mlx5: Remove empty QP and CQ events handlers")

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

diff --cc drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 18719acb7e54,c4ed25bb9ac8..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@@ -689,18 -693,6 +693,12 @@@ static int dr_prepare_qp_to_rts(struct=20
  	return 0;
  }
 =20
- static void dr_cq_event(struct mlx5_core_cq *mcq,
- 			enum mlx5_event event)
- {
- 	pr_info("CQ event %u on CQ #%u\n", event, mcq->cqn);
- }
-=20
 +static void dr_cq_complete(struct mlx5_core_cq *mcq,
 +			   struct mlx5_eqe *eqe)
 +{
 +	pr_err("CQ completion CQ: #%u\n", mcq->cqn);
 +}
 +
  static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
  				      struct mlx5_uars_page *uar,
  				      size_t ncqe)
@@@ -761,9 -753,6 +759,8 @@@
  	pas =3D (__be64 *)MLX5_ADDR_OF(create_cq_in, in, pas);
  	mlx5_fill_page_frag_array(&cq->wq_ctrl.buf, pas);
 =20
- 	cq->mcq.event =3D dr_cq_event;
 +	cq->mcq.comp  =3D dr_cq_complete;
 +
  	err =3D mlx5_core_create_cq(mdev, &cq->mcq, in, inlen, out, sizeof(out));
  	kvfree(in);
 =20

--Sig_/kt_sz/5HT.hr3U=+bLtYLub
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6rjgQACgkQAVBC80lX
0GzKVgf/ee82f8fRKoBhisdF/+oe9g42AVpjH+1kmnACx2xw2h5WWNb4zaWF0D0E
V1lPT8ykdbCpDaERdAKiuXT/9BGV0XY6PSWZ0Ng5XD7HnC0wz84EK4PCbEfZh6K+
DMeSCXpdgnCTFQ1Hq5wwIAAZB3AF+jCtxx4P5/1TlVpQiC+QV1bPoXmb2lxrdz+n
PLTIxZLqkHrTDB+bv74aWEpO7SfNjkUaSshBUH6YkE8829hpa51T5Yqw5vHdi4Wv
CA2kEafpe4cFapSVLY4bLwBQ6LnLol4XPtvAu0yVsF6C9fQD2bOrryWZO2NPJmi2
OB+Ia73lvHkNygJCNCbRRJyNaLh8lg==
=ayZ/
-----END PGP SIGNATURE-----

--Sig_/kt_sz/5HT.hr3U=+bLtYLub--
