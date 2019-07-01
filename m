Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE64D5B3BF
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 06:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfGAE50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 00:57:26 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42799 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbfGAE5Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 00:57:25 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45cZqQ4z9Pz9s4Y;
        Mon,  1 Jul 2019 14:57:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561957042;
        bh=aJhznYD09gmkcI072a1qGBoSumfqEWCa0EM8G+nOhew=;
        h=Date:From:To:Cc:Subject:From;
        b=gzq3pRKH84xqBVNoZqlfTCXXhhPwa2HQawTOv6vIC2MTv4NKOfGiRX40XdAQzhNHG
         l81Asu4y5j1wd5D0xTx/LJTrDdKZp4TlD0g4UTm5877s3S+Te9N0kqRapvWeUy4aEX
         D00Ig05KPOgTVfOyG+0DK+qZ1TeLd0BZWpKeB0j5ytVvm0g/qNFyJNtAmGd97IPvGe
         UtZU2iqBRUXauxqsUAm7Om1QyuuPSrjZ7QOzWqAmD3bLAs+2o71goDFHTGb3VXweIm
         okLao0O936SYbgcDr0fEx7VW44KRWORL3EwRqoWt1/ee+p2q3nFC1i/w3a5b8BlQ/t
         QEVUBtBDqmngA==
Date:   Mon, 1 Jul 2019 14:57:22 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20190701145722.5809cb2c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/E/t5jHQdsPT1e_p4jbZy_PN"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/E/t5jHQdsPT1e_p4jbZy_PN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/ethernet/mellanox/mlx5/core/en_main.c:1605:5: error: conflictin=
g types for 'mlx5e_open_cq'
 int mlx5e_open_cq(struct mlx5e_channel *c, struct dim_cq_moder moder,
     ^~~~~~~~~~~~~
In file included from drivers/net/ethernet/mellanox/mlx5/core/en_main.c:43:
drivers/net/ethernet/mellanox/mlx5/core/en.h:977:5: note: previous declarat=
ion of 'mlx5e_open_cq' was here
 int mlx5e_open_cq(struct mlx5e_channel *c, struct net_dim_cq_moder moder,
     ^~~~~~~~~~~~~

Caused by commit

  8960b38932be ("linux/dim: Rename externally used net_dim members")

from the net-next tree interacting with commit

  db05815b36cb ("net/mlx5e: Add XSK zero-copy support")

I have applied the following merge fix patch.

=46rom 8e92dbee0daa6bac412daebd08073ba9ca31c7a6 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 1 Jul 2019 14:55:02 +1000
Subject: [PATCH] net/mlx5e: fix up for "linux/dim: Rename externally used
 net_dim members"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 9cebaa642727..f0d77eb66acf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -974,7 +974,7 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct ml=
x5e_params *params,
 void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq);
=20
 struct mlx5e_cq_param;
-int mlx5e_open_cq(struct mlx5e_channel *c, struct net_dim_cq_moder moder,
+int mlx5e_open_cq(struct mlx5e_channel *c, struct dim_cq_moder moder,
 		  struct mlx5e_cq_param *param, struct mlx5e_cq *cq);
 void mlx5e_close_cq(struct mlx5e_cq *cq);
=20
--=20
2.20.1



--=20
Cheers,
Stephen Rothwell

--Sig_/E/t5jHQdsPT1e_p4jbZy_PN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0ZkrIACgkQAVBC80lX
0GwdUgf/WFxURktkQ07mAnwoeff013wv95gP5CV7yZ5yD58oMh69qel/QwhSQ36S
h15vNBHltbhjqGjkarbQG3bzOA8NaglQ7AE0t4HABjfBnGkapjMjBrh8/w80pOjN
moNMt5thM5WJQ0r2vwaJa/m05QeVI1KsaOojpufVlD7yM2nzpMehrVhRJ373yu6s
zJSWn9838G9B6IRnCTGaTbZ+9EZQqIuD3selMY4bToAEJhVia3wb/Lv44j5xpBs4
e4vcy8NMAoO4TbfCVOx6xhr/HC4GJ0LZjJpcXnIYEbqJfj+auhHv1w9dKYXmwlLO
bsrfkaWQaE5ztu0PggvdInrWu75xAA==
=A7DW
-----END PGP SIGNATURE-----

--Sig_/E/t5jHQdsPT1e_p4jbZy_PN--
