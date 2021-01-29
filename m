Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E503130829A
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhA2AoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbhA2An6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 19:43:58 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645CAC061574;
        Thu, 28 Jan 2021 16:43:17 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DRdqP3P6Lz9sVF;
        Fri, 29 Jan 2021 11:43:12 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1611880993;
        bh=l4vnBR+mEzBF2GR6eNUHnAasrn2FIlCfc5gxL8Fgj9c=;
        h=Date:From:To:Cc:Subject:From;
        b=DDOHeZLSSgQhmq3lnp6T/Gv+2uVKPfHvUMt+Vn8O9+sXZ4MKOf88E6ACytjsjAoq8
         2+dTxhymvtwJMPVAIqwyve9JyOGMoBEyodCq/BO54lA5oxxFWmBISJuKBJRuA81lEO
         SYdmLRVWbv2fvppZHp5+s8SYaHU+gtl3W+fBPsn49OEaywiipZk5up2Wrk/yzcgHZd
         tN3cUpukEb/zu+HL9LsRo2yymetSltgo1G+0E3A6qyZccItR8SW+buYBA/KCtPB2MC
         lTUUWCDGg5UtymY9Mhu9KbxXQ1okQu0qFSq19q/mGK0jFwWiWHS/Io98OClHD6Zjqe
         cTwz0EYk9JL9A==
Date:   Fri, 29 Jan 2021 11:43:09 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20210129114309.451562f7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/LPYlfJqKMu6H8elNXBz.Rdm";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/LPYlfJqKMu6H8elNXBz.Rdm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c

between commit:

  57ac4a31c483 ("net/mlx5e: Correctly handle changing the number of queues =
when the interface is down")

from Linus' tree and commit:

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

diff --cc drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 302001d6661e,2e5a0696374a..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@@ -447,7 -447,18 +447,18 @@@ int mlx5e_ethtool_set_channels(struct m
  		goto out;
  	}
 =20
+ 	/* Don't allow changing the number of channels if HTB offload is active,
+ 	 * because the numeration of the QoS SQs will change, while per-queue
+ 	 * qdiscs are attached.
+ 	 */
+ 	if (priv->htb.maj_id) {
+ 		err =3D -EINVAL;
+ 		netdev_err(priv->netdev, "%s: HTB offload is active, cannot change the =
number of channels\n",
+ 			   __func__);
+ 		goto out;
+ 	}
+=20
 -	new_channels.params =3D priv->channels.params;
 +	new_channels.params =3D *cur_params;
  	new_channels.params.num_channels =3D count;
 =20
  	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {

--Sig_/LPYlfJqKMu6H8elNXBz.Rdm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmATWh0ACgkQAVBC80lX
0Gy6FQf+KL/nYs4V4lNxbox255v8cOEjIMUA5cnDyrPw+NefhGi8GUfPUCozSYnV
pDqSr3u2WEMCfufZ0Nre297nsW/TSErgh9MagQc+eaXtgugOpVW/SaEmmar/3dwV
KTQfHOuiScV3Ip2ju5YHlW3+5t6CAXgIjK0Qlp90xNODdK9EXLOKEcOY1qOOeov2
lCd7PM1htSLwRLD+oGNSHsYJVrcTxZaHYGu7ChMXmDM118y40ms4JBgTJgTz/+u7
xJzqtj3IIbfOhREYGQDJ13r9MuaSXfht18froaiP/xmUOAwX6mFrYTof8fuKA4o+
nlgUNUCAh0gj7VGZMqNADDSEIJALoQ==
=77xB
-----END PGP SIGNATURE-----

--Sig_/LPYlfJqKMu6H8elNXBz.Rdm--
