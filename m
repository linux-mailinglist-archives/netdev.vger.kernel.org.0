Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A3631B3BA
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 01:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhBOAxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 19:53:16 -0500
Received: from ozlabs.org ([203.11.71.1]:43539 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhBOAxP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Feb 2021 19:53:15 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Df5DH6kzjz9sCD;
        Mon, 15 Feb 2021 11:52:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613350352;
        bh=oa6Uc+7uJnYD30C2uWpQl2bbjVcL9J8DziaWhvXWAbg=;
        h=Date:From:To:Cc:Subject:From;
        b=e0n4Hg3DM0kwa/YKMUfeFAiiogSXYMUUSmTGTusYiI2ywrwQARB9+g3eet5DEYppS
         hmDBLchbhn/KeDhF0u1kKN2Btq8GiyaDsTzJ5YHFQrBaRv7PiQfSTf9ShOswwECw2M
         JK/9sfNkg7BZjers8rj44/01iZjwrqSsNdJgSZobB7DvmjKwWPnl+4/YJhVMVzFmb5
         QupCL32x9RFaMSpv6RiIQXceNjT7ea2qbtBGiiTcPlmlFl1wJ7kh5vCiCX5b4Ai38q
         bR+IGnvsenpHruU4w0DLMDIROJNUuPmZIiH4Qjfr3O4NbIu5VZj2swXGSaHAOOJFD5
         HgRvuRRVsF4xQ==
Date:   Mon, 15 Feb 2021 11:52:31 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Aya Levin <ayal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210215115231.2311310a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/49jkGUhnk31rBtkq3GBA.g1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/49jkGUhnk31rBtkq3GBA.g1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  drivers/net/ethernet/mellanox/mlx5/core/en_main.c
  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c

between commit:

  e4484d9df500 ("net/mlx5e: Enable striding RQ for Connect-X IPsec capable =
devices")

from the net tree and commits:

  224169d2a32b ("net/mlx5e: IPsec, Remove unnecessary config flag usage")
  70038b73e40e ("net/mlx5e: Add listener to trap event")
  214baf22870c ("net/mlx5e: Support HTB offload")

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
index a2e0b548bf57,d3534b657b98..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@@ -65,7 -65,8 +65,9 @@@
  #include "en/devlink.h"
  #include "lib/mlx5.h"
  #include "en/ptp.h"
 +#include "fpga/ipsec.h"
+ #include "qos.h"
+ #include "en/trap.h"
 =20
  bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
  {
@@@ -2069,10 -2106,8 +2107,8 @@@ static void mlx5e_build_rq_frags_info(s
  	u32 buf_size =3D 0;
  	int i;
 =20
- #ifdef CONFIG_MLX5_EN_IPSEC
 -	if (MLX5_IPSEC_DEV(mdev))
 +	if (mlx5_fpga_is_ipsec_device(mdev))
  		byte_count +=3D MLX5E_METADATA_ETHER_LEN;
- #endif
 =20
  	if (mlx5e_rx_is_linear_skb(params, xsk)) {
  		int frag_stride;
diff --cc drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 4864deed9dc9,4de5a97ceac6..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@@ -1794,12 -1786,10 +1786,10 @@@ int mlx5e_rq_set_handlers(struct mlx5e_
  		rq->dealloc_wqe =3D mlx5e_dealloc_rx_mpwqe;
 =20
  		rq->handle_rx_cqe =3D priv->profile->rx_handlers->handle_rx_cqe_mpwqe;
- #ifdef CONFIG_MLX5_EN_IPSEC
 -		if (MLX5_IPSEC_DEV(mdev)) {
 -			netdev_err(netdev, "MPWQE RQ with IPSec offload not supported\n");
 +		if (mlx5_fpga_is_ipsec_device(mdev)) {
 +			netdev_err(netdev, "MPWQE RQ with Innova IPSec offload not supported\n=
");
  			return -EINVAL;
  		}
- #endif
  		if (!rq->handle_rx_cqe) {
  			netdev_err(netdev, "RX handler of MPWQE RQ is not set\n");
  			return -EINVAL;

--Sig_/49jkGUhnk31rBtkq3GBA.g1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmApxc8ACgkQAVBC80lX
0GwOywf+JQQYI5Qt5YRTa39uK02+aj7eiK5MLNY5+7FXywoX5LTAGLDvxNqZp5Sq
Wy5SjcdXgTGk8MsmxGas7z5nb3qkAsUZxbYxh+2BCaJ9TdhdAgLLUuN9HLIebRMy
qCsD/dslZRLowZ3PsTSYEsvGklOZaqvDAIboVlXBowxdQeyiZFJab2lZhfUQETly
R0gqASJElBFy4qCstmutZs6gloTL6YdMdto49bkglGILww7EHThMi1DNu9SBv+9j
njRvHWl5N5tlqAG2zIoywNPKrugg2fKsTyw5FKGgMOQIywUDXeWrRmm6mFH+KIjU
76fCe3/tBkC/vpqcYJqfoRzRomlm/g==
=prWx
-----END PGP SIGNATURE-----

--Sig_/49jkGUhnk31rBtkq3GBA.g1--
