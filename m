Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF5043D905
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 03:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhJ1B6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 21:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhJ1B6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 21:58:46 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED894C061570;
        Wed, 27 Oct 2021 18:56:19 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HfpZ60XkPz4xbG;
        Thu, 28 Oct 2021 12:56:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1635386174;
        bh=WoyXyp9HpzLprllyxDYkut1/PKuQEke7JGGih2gRhBo=;
        h=Date:From:To:Cc:Subject:From;
        b=ftuu0rjpw4dWNk4mDazV6Paa3qoD8cGh9D+TBungimU33ybl8CBiH9CYNTd8K9VXz
         5G91POVFUv8mBJaUW+xS53lW6wrGHWkyp06myBWcr4Bjhr8fAL1Bvyw0INDrFm0pnG
         pqt2ZhUjkxquraLVUR1aKstI526gG0ovlU3HByhAvcLz/aUZZDPMKpJNh2kZ+xZvR6
         WZ0UqL0AO5OLDddDq7h9/vn9d0wsLXx8ZfZMgItUUej2H6XyPJzhzxAZVKogf/+yat
         1di7xsqfF3ksoNPD4uCRzv0fHA8xPoerty1xxaEACzLvMAWo3P0DwV+dK0IPkTzhTE
         Rb3Ssj70qJwuQ==
Date:   Thu, 28 Oct 2021 12:56:12 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20211028125612.16bf39a6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/KQpeysiaOZT_WkGoifNmla4";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/KQpeysiaOZT_WkGoifNmla4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h:11,
                 from drivers/net/ethernet/mellanox/mlx5/core/eswitch.h:48,
                 from drivers/net/ethernet/mellanox/mlx5/core/main.c:59:
drivers/net/ethernet/mellanox/mlx5/core/en.h:646:24: error: field 'mkey' ha=
s incomplete type
  646 |  struct mlx5_core_mkey mkey;
      |                        ^~~~
In file included from drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h:11,
                 from drivers/net/ethernet/mellanox/mlx5/core/eswitch.h:48,
                 from drivers/net/ethernet/mellanox/mlx5/core/eq.c:18:
drivers/net/ethernet/mellanox/mlx5/core/en.h:646:24: error: field 'mkey' ha=
s incomplete type
  646 |  struct mlx5_core_mkey mkey;
      |                        ^~~~
drivers/net/ethernet/mellanox/mlx5/core/en_rx.c: In function 'mlx5e_build_s=
hampo_hd_umr':
drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:547:45: error: request for =
member 'key' in something not a structure or union
  547 |  u32 lkey =3D rq->mdev->mlx5e_res.hw_objs.mkey.key;
      |                                             ^

Caused by commits

  e5ca8fb08ab2 ("net/mlx5e: Add control path for SHAMPO feature")
  64509b052525 ("net/mlx5e: Add data path for SHAMPO feature")

interacting with commit

  83fec3f12a59 ("RDMA/mlx5: Replace struct mlx5_core_mkey by u32 key")

from the rmda tree.

I have applied the following merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 28 Oct 2021 12:36:29 +1100
Subject: [PATCH] fixup for "RDMA/mlx5: Replace struct mlx5_core_mkey by u32=
 key"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 +++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   |  2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 5083a8a7eceb..f0ac6b0d9653 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -643,7 +643,7 @@ struct mlx5e_rq_frags_info {
 };
=20
 struct mlx5e_shampo_hd {
-	struct mlx5_core_mkey mkey;
+	u32 mkey;
 	struct mlx5e_dma_info *info;
 	struct page *last_page;
 	u16 hd_per_wq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 43b7a1e6a482..9febe4a916df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -323,8 +323,7 @@ static int mlx5e_create_umr_mtt_mkey(struct mlx5_core_d=
ev *mdev,
 }
=20
 static int mlx5e_create_umr_klm_mkey(struct mlx5_core_dev *mdev,
-				     u64 nentries,
-				     struct mlx5_core_mkey *umr_mkey)
+				     u64 nentries, u32 *umr_mkey)
 {
 	int inlen;
 	void *mkc;
@@ -518,7 +517,7 @@ static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *m=
dev,
 		goto err_hw_gro_data;
 	}
 	rq->mpwqe.shampo->key =3D
-		cpu_to_be32(rq->mpwqe.shampo->mkey.key);
+		cpu_to_be32(rq->mpwqe.shampo->mkey);
 	rq->mpwqe.shampo->hd_per_wqe =3D
 		mlx5e_shampo_hd_per_wqe(mdev, params, rqp);
 	wq_size =3D BIT(MLX5_GET(wq, wqc, log_wq_sz));
@@ -529,7 +528,7 @@ static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *m=
dev,
 err_hw_gro_data:
 	mlx5e_rq_shampo_hd_info_free(rq);
 err_shampo_info:
-	mlx5_core_destroy_mkey(mdev, &rq->mpwqe.shampo->mkey);
+	mlx5_core_destroy_mkey(mdev, rq->mpwqe.shampo->mkey);
 err_shampo_hd:
 	mlx5e_rq_shampo_hd_free(rq);
 out:
@@ -543,7 +542,7 @@ static void mlx5e_rq_free_shampo(struct mlx5e_rq *rq)
=20
 	kvfree(rq->hw_gro_data);
 	mlx5e_rq_shampo_hd_info_free(rq);
-	mlx5_core_destroy_mkey(rq->mdev, &rq->mpwqe.shampo->mkey);
+	mlx5_core_destroy_mkey(rq->mdev, rq->mpwqe.shampo->mkey);
 	mlx5e_rq_shampo_hd_free(rq);
 }
=20
@@ -819,7 +818,7 @@ int mlx5e_create_rq(struct mlx5e_rq *rq, struct mlx5e_r=
q_param *param)
 	if (test_bit(MLX5E_RQ_STATE_SHAMPO, &rq->state)) {
 		MLX5_SET(wq, wq, log_headers_buffer_entry_num,
 			 order_base_2(rq->mpwqe.shampo->hd_per_wq));
-		MLX5_SET(wq, wq, headers_mkey, rq->mpwqe.shampo->mkey.key);
+		MLX5_SET(wq, wq, headers_mkey, rq->mpwqe.shampo->mkey);
 	}
=20
 	mlx5_fill_page_frag_array(&rq->wq_ctrl.buf,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index fe979edd96dc..f63c8ff3ef3f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -544,7 +544,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *r=
q,
 {
 	struct mlx5e_shampo_hd *shampo =3D rq->mpwqe.shampo;
 	u16 entries, pi, i, header_offset, err, wqe_bbs, new_entries;
-	u32 lkey =3D rq->mdev->mlx5e_res.hw_objs.mkey.key;
+	u32 lkey =3D rq->mdev->mlx5e_res.hw_objs.mkey;
 	struct page *page =3D shampo->last_page;
 	u64 addr =3D shampo->last_addr;
 	struct mlx5e_dma_info *dma_info;
--=20
2.33.0

--=20
Cheers,
Stephen Rothwell

--Sig_/KQpeysiaOZT_WkGoifNmla4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmF6AzwACgkQAVBC80lX
0GybXAf8DTIiwMe9tPjlh0gOvTtDPcqf3urB/Yka7LK3Ayti6GbobPvYEunEoZgj
+gn8Js0OrcXsQdv3ZYicKFTRsPPpT8j9PvqiwrFilr3qwyg7NFx0HidslxMNrw5w
DDhmVQuJL2YMyz92KFuvnRdu3Jakp0PL55B0iaCoavZ+hPjtOetinfjofgA+kwIf
x1RT3r0xBocJMRJ3SOMHRPG0JjX3EVAypz13vB2pJCShtmEctWinUzBMDKGt811N
bZx8lLGaFIhLdNkMgxSdmPhTo0ceN45IyT+85IrZjPZVyGUx/pnf+43atiS3oiNH
ts0z/xHu5CHBE0of5yRKibxi9kjdHQ==
=HXZe
-----END PGP SIGNATURE-----

--Sig_/KQpeysiaOZT_WkGoifNmla4--
