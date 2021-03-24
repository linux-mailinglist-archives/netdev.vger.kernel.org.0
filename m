Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC694346E91
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbhCXBTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:19:01 -0400
Received: from ozlabs.org ([203.11.71.1]:34777 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234188AbhCXBSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 21:18:42 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F4r3L0lTtz9sWV;
        Wed, 24 Mar 2021 12:18:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616548718;
        bh=2zn+dHvSOjP1psSX7dRMUQa86aPXcoq0uxVdQ9/MVlg=;
        h=Date:From:To:Cc:Subject:From;
        b=t/h4X8KDD92V2hfI+Yo+q0546927IMkrwbRB/laTFmzUsvVU/pF0pMCApxc6baOf1
         PXGqEI0u9++zj6b0CdbTlkgukhhkHDwoITOCBoP+6dsztjsPav8Ym+USo0xL14glHt
         yPMlhWRhBpyx46AlQwdUbo5tIBNbW4p5w2SLyHv57wOsdC3/Ic811/kSTJmKpuQ+g1
         hnyOJUZBHLXixYMzE7p/990Cek31eDPCccVOHDoPcXYcCUjvWSHPQIcA0mh4t5Lo+N
         nUwFmEp6zXXbnPsOM4ERoZIy5N8+fnTezuTU2eaCADSjKH/xiDvnlaNquKgS/Slr89
         VTcybX7a5FnZQ==
Date:   Wed, 24 Mar 2021 12:18:35 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Alaa Hleihel <alaa@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210324121835.716d0088@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/MHZNfrd03A7qAv6Ch0Gbxt1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/MHZNfrd03A7qAv6Ch0Gbxt1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c

between commit:

  7d6c86e3ccb5 ("net/mlx5e: Allow to match on MPLS parameters only for MPLS=
 over UDP")

from the net tree and commit:

  a3222a2da0a2 ("net/mlx5e: Allow to match on ICMP parameters")

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
index df2a0af854bb,730f33ada90a..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@@ -2295,17 -2314,49 +2314,60 @@@ static int __parse_cls_flower(struct ml
  		if (match.mask->flags)
  			*match_level =3D MLX5_MATCH_L4;
  	}
 +
 +	/* Currenlty supported only for MPLS over UDP */
 +	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_MPLS) &&
 +	    !netif_is_bareudp(filter_dev)) {
 +		NL_SET_ERR_MSG_MOD(extack,
 +				   "Matching on MPLS is supported only for MPLS over UDP");
 +		netdev_err(priv->netdev,
 +			   "Matching on MPLS is supported only for MPLS over UDP\n");
 +		return -EOPNOTSUPP;
 +	}
 +
+ 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ICMP)) {
+ 		struct flow_match_icmp match;
+=20
+ 		flow_rule_match_icmp(rule, &match);
+ 		switch (ip_proto) {
+ 		case IPPROTO_ICMP:
+ 			if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
+ 			      MLX5_FLEX_PROTO_ICMP))
+ 				return -EOPNOTSUPP;
+ 			MLX5_SET(fte_match_set_misc3, misc_c_3, icmp_type,
+ 				 match.mask->type);
+ 			MLX5_SET(fte_match_set_misc3, misc_v_3, icmp_type,
+ 				 match.key->type);
+ 			MLX5_SET(fte_match_set_misc3, misc_c_3, icmp_code,
+ 				 match.mask->code);
+ 			MLX5_SET(fte_match_set_misc3, misc_v_3, icmp_code,
+ 				 match.key->code);
+ 			break;
+ 		case IPPROTO_ICMPV6:
+ 			if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
+ 			      MLX5_FLEX_PROTO_ICMPV6))
+ 				return -EOPNOTSUPP;
+ 			MLX5_SET(fte_match_set_misc3, misc_c_3, icmpv6_type,
+ 				 match.mask->type);
+ 			MLX5_SET(fte_match_set_misc3, misc_v_3, icmpv6_type,
+ 				 match.key->type);
+ 			MLX5_SET(fte_match_set_misc3, misc_c_3, icmpv6_code,
+ 				 match.mask->code);
+ 			MLX5_SET(fte_match_set_misc3, misc_v_3, icmpv6_code,
+ 				 match.key->code);
+ 			break;
+ 		default:
+ 			NL_SET_ERR_MSG_MOD(extack,
+ 					   "Code and type matching only with ICMP and ICMPv6");
+ 			netdev_err(priv->netdev,
+ 				   "Code and type matching only with ICMP and ICMPv6\n");
+ 			return -EINVAL;
+ 		}
+ 		if (match.mask->code || match.mask->type) {
+ 			*match_level =3D MLX5_MATCH_L4;
+ 			spec->match_criteria_enable |=3D MLX5_MATCH_MISC_PARAMETERS_3;
+ 		}
+ 	}
  	return 0;
  }
 =20

--Sig_/MHZNfrd03A7qAv6Ch0Gbxt1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBak2sACgkQAVBC80lX
0GzXogf/cJRPK8eDlyY8jegnB1mvptdAqpH510tr9VZeWe9JgfHs9XuM58rPY4dp
cD/8oZmYQOwfPcez2xdlW6d6BiYbxCZ2xZWUxkRxIzmYRirKHcTKdnd+etsndBCZ
1mhX1FGYaJj5uFOHGS9qPwT2jUQI4HCvwL3Sx1v3KT6tk5dJEA7vc6ctfths4u4z
KHswhWzmTuE8oo9Ik7/gBXudrK6vHIVc9S+lcKV5dEdZNN+GdY4yErQFQ7mFRwBH
3dxhtfaJlx+nV85vK1BgsnlAl6EVYjRR1A+6hIAvpDOCv0qjOc9zCedsgNF/I1Mo
LVKnb3puBA1kiYBr1ztlmWzxJlQtLw==
=4R5A
-----END PGP SIGNATURE-----

--Sig_/MHZNfrd03A7qAv6Ch0Gbxt1--
