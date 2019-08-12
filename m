Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048B48955D
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 04:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfHLCVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 22:21:12 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:44233 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbfHLCVM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 22:21:12 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 466KMm0Lmdz9sP7;
        Mon, 12 Aug 2019 12:21:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1565576468;
        bh=HdId0j789qpKf14+gTDT90r9ZUNm34/y6nkMbLvLDic=;
        h=Date:From:To:Cc:Subject:From;
        b=QNcfiPHDLgsuXv+vEoXbiT9BcqJPx0xzdL248GxHRlEaqR9/vubWhsPz53ZiPMGPK
         drh+igYPYu3T9f8k+QrpFpR7pRsShaUswdgWnrG4mStQcs2VbaN8m5lexnnHJcXeTL
         iIHcP8fKXLVAR0DA1NKZ8ocoYi6/FhPdLPSe37n7s1jgxieZtdQ0GMrp4Qy5l2qD0O
         ydw6iZ6agY00yUzEe8XURUa0Tk/uLvDEG1+PwmywdVAmZ5JP1/FAfD0lVVEkpYtq3P
         m/STZymVWv/eOdjazpPma0pgcm1zGVw1dAnku+GO3JH1ez2EU5vHx7xKTR/h0ei2jl
         irCsFTqHEOMBA==
Date:   Mon, 12 Aug 2019 12:21:06 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Huy Nguyen <huyn@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190812122106.628debfd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/wKh8sn3YkOTaPQ=4/ySqEeQ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/wKh8sn3YkOTaPQ=4/ySqEeQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c

between commit:

  93b3586e070b ("net/mlx5: Support inner header match criteria for non deca=
p flow action")

from the net tree and commit:

  226f2ca3075a ("net/mlx5e: Change flow flags type to unsigned long")

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

diff --cc drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index deeb65da99f3,5be3da621499..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@@ -1839,18 -2057,15 +2061,20 @@@ static int parse_cls_flower(struct mlx5
  	struct mlx5_core_dev *dev =3D priv->mdev;
  	struct mlx5_eswitch *esw =3D dev->priv.eswitch;
  	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
 -	u8 match_level, tunnel_match_level =3D MLX5_MATCH_NONE;
  	struct mlx5_eswitch_rep *rep;
+ 	bool is_eswitch_flow;
  	int err;
 =20
 -	err =3D __parse_cls_flower(priv, spec, f, filter_dev, &match_level, &tun=
nel_match_level);
 +	inner_match_level =3D MLX5_MATCH_NONE;
 +	outer_match_level =3D MLX5_MATCH_NONE;
 +
 +	err =3D __parse_cls_flower(priv, spec, f, filter_dev, &inner_match_level,
 +				 &outer_match_level);
 +	non_tunnel_match_level =3D (inner_match_level =3D=3D MLX5_MATCH_NONE) ?
 +				 outer_match_level : inner_match_level;
 =20
- 	if (!err && (flow->flags & MLX5E_TC_FLOW_ESWITCH)) {
+ 	is_eswitch_flow =3D mlx5e_is_eswitch_flow(flow);
+ 	if (!err && is_eswitch_flow) {
  		rep =3D rpriv->rep;
  		if (rep->vport !=3D MLX5_VPORT_UPLINK &&
  		    (esw->offloads.inline_mode !=3D MLX5_INLINE_MODE_NONE &&
@@@ -1864,11 -2079,11 +2088,11 @@@
  		}
  	}
 =20
- 	if (flow->flags & MLX5E_TC_FLOW_ESWITCH) {
+ 	if (is_eswitch_flow) {
 -		flow->esw_attr->match_level =3D match_level;
 -		flow->esw_attr->tunnel_match_level =3D tunnel_match_level;
 +		flow->esw_attr->inner_match_level =3D inner_match_level;
 +		flow->esw_attr->outer_match_level =3D outer_match_level;
  	} else {
 -		flow->nic_attr->match_level =3D match_level;
 +		flow->nic_attr->match_level =3D non_tunnel_match_level;
  	}
 =20
  	return err;

--Sig_/wKh8sn3YkOTaPQ=4/ySqEeQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1QzRIACgkQAVBC80lX
0Gy70wgAmOYZD+4qminOIVh1+j+LLcV84fr9pUaDAjSYS11cjsKZN0bsPzI7fX1l
KLqpS/z1gK4NhWCrECrNj1UviuC5dktksvxv9YKuhy2vJhLqpcWmiNeI6u5+ACx+
vtz4A2nBPNYvEXkuRl4JwJz6vvN23XDh+siBqcsVuyQ4lGdouFnc2CjmKNaKb9tn
NcSdA6ar3Czbf+ZeSz04j5P2IsjlEnteVuPVWuDRQhH6BEEBk4BBFUxee+iLkqRX
TgsYyICMnHnbtV2PYgHD213JjoP0AcNko+6fx8gaaom1SBQOuprppyZGLx+RaZS2
YLpc8ie93AqMR9HGH+E7izxdgTra3Q==
=7dPM
-----END PGP SIGNATURE-----

--Sig_/wKh8sn3YkOTaPQ=4/ySqEeQ--
