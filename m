Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FDF43D843
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 02:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhJ1A7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 20:59:07 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:37093 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhJ1A7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 20:59:06 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HfnFL6323z4xbw;
        Thu, 28 Oct 2021 11:56:38 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1635382599;
        bh=xOnrFlMiK8dTxtCuVyh/PCtDqBDM6/2zBoSBHWhXIYQ=;
        h=Date:From:To:Cc:Subject:From;
        b=LcuPGUro4ILDohQcXZWIaH574ZjxDiVHIc3zknqzB/g7N/ZTik3M5g4fGWr0Uc24A
         5X5aJdisFPCGdlsMOzBb0uekdRfraE7wTxLSAT9ROZvnHzGaXMCMAplI+keCbYt30x
         epEu9mRC7PBzMuLSvAX79WjlpXlNVpOFh4mvM5D43t8PHxRioJXHDUT2kORCG6bWep
         m1lrddVSaWqTasGacdQOaaYgHgRsFD2Lh9CCuY2YjcLML6hD0rG0GEt3yDRuhdKo52
         Ej/+nHQTnzikzCJS/Ud7zuN9/1R7jH1oqCOD/WTWG82EDcpvHDL5Yphiatr3BqlFJk
         8XdUB21NbrR+Q==
Date:   Thu, 28 Oct 2021 11:56:37 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with the rdma tree
Message-ID: <20211028115637.1ed0ba86@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/JaM83v_m1nfKyhnSirWrJz9";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/JaM83v_m1nfKyhnSirWrJz9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/en_main.c

between commit:

  83fec3f12a59 ("RDMA/mlx5: Replace struct mlx5_core_mkey by u32 key")

from the rdma tree and commit:

  e5ca8fb08ab2 ("net/mlx5e: Add control path for SHAMPO feature")

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
index 5fce9401ac74,6f398f636f01..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@@ -233,9 -272,10 +272,9 @@@ static int mlx5e_rq_alloc_mpwqe_info(st
  	return 0;
  }
 =20
- static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
- 				 u64 npages, u8 page_shift, u32 *umr_mkey,
- 				 dma_addr_t filler_addr)
+ static int mlx5e_create_umr_mtt_mkey(struct mlx5_core_dev *mdev,
 -				     u64 npages, u8 page_shift,
 -				     struct mlx5_core_mkey *umr_mkey,
++				     u64 npages, u8 page_shift, u32 *umr_mkey,
+ 				     dma_addr_t filler_addr)
  {
  	struct mlx5_mtt *mtt;
  	int inlen;
@@@ -606,8 -761,9 +760,9 @@@ static void mlx5e_free_rq(struct mlx5e_
  	switch (rq->wq_type) {
  	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
  		kvfree(rq->mpwqe.info);
 -		mlx5_core_destroy_mkey(rq->mdev, &rq->umr_mkey);
 +		mlx5_core_destroy_mkey(rq->mdev, rq->umr_mkey);
  		mlx5e_free_mpwqe_rq_drop_page(rq);
+ 		mlx5e_rq_free_shampo(rq);
  		break;
  	default: /* MLX5_WQ_TYPE_CYCLIC */
  		kvfree(rq->wqe.frags);

--Sig_/JaM83v_m1nfKyhnSirWrJz9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmF59UUACgkQAVBC80lX
0Gw5Cgf+IMFMIl+tyxD8fNaTtbkJWqrxjUrkT9KBZANXgmMM10FE1+jJCI1Xn+bH
RYuKysKcH2pZAPYZu47HMnQDxD/VxP5MEVKmuDuNsrZiPsLEdYTCURTZZEpcsX1k
CwyZ+Ax6S3PfPu/vjBdmufY8WLo5Nw1/8nk4nPJlqmjjFm+WO8sRd2pNo8KzWcyC
/j+k+7qVGdwe5BEdf6vNrmfc5XW2w3cdf+bfLwwUvPRqOPPypShErgR3+twSGyks
qxUqnbtIzXQGs3PerHnF0hmuCxsfwfAQdW8KlniB2VBRVykxYFSbLs6dzmt9gq/9
Yt9foh3JfPgpHGEwbmFY5RViFbwdww==
=dIx2
-----END PGP SIGNATURE-----

--Sig_/JaM83v_m1nfKyhnSirWrJz9--
