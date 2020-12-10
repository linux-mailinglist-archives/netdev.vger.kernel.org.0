Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D88F2D50A8
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 03:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgLJCMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 21:12:08 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:58859 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbgLJCMI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 21:12:08 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Cry855jH0z9sW9;
        Thu, 10 Dec 2020 13:11:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607566283;
        bh=/IR168j0DBvyZWk4UDeVSWrS9CAyzcVRu7l7dhi/4Gk=;
        h=Date:From:To:Cc:Subject:From;
        b=UO9+lKAgqZRYqKnFfB0JVvtPVBf7BTDI/rYki1NvF9huxp1mbXcrIsk3Xq9TDktGN
         L4r71anTSntJeRSsEZTJSqo5slTEuM9HWws69IiICpQJOA6hioO7D0diKBCNwJgWBz
         Xqmk46sIeT9uQpqMM2HAf34juhd6R+znwZWWeXN9I3c8fJXM1VEWYk+hzaYuFl2J4E
         gXplhIiyH06CPRS+BygFnyKi/h49V40FSjtFk/rT0vNu62BZPLzhvQy+NmmLfEylrd
         EDt4CXPCeLGyQfRQYtCLkVacCjFeOyo9qE9olOiDR+46EHsFxbP7SVIo3JZQXNahrP
         fYAnHMl1InCog==
Date:   Thu, 10 Dec 2020 13:11:13 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Francis Laniel <laniel_francis@privacyrequired.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the netfilter
 tree
Message-ID: <20201210131113.6394fe45@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/EH5MF1qJNoQbuN/x6PV0I1l";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/EH5MF1qJNoQbuN/x6PV0I1l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/netfilter/nf_tables_api.c

between commit:

  42f1c2712090 ("netfilter: nftables: comment indirect serialization of com=
mit_mutex with rtnl_mutex")

from the netfilter tree and commit:

  872f69034194 ("treewide: rename nla_strlcpy to nla_strscpy.")

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

diff --cc net/netfilter/nf_tables_api.c
index 9a080767667b,a11bc8dcaa82..000000000000
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@@ -1722,11 -1723,7 +1723,11 @@@ static struct nft_hook *nft_netdev_hook
  		goto err_hook_alloc;
  	}
 =20
- 	nla_strlcpy(ifname, attr, IFNAMSIZ);
+ 	nla_strscpy(ifname, attr, IFNAMSIZ);
 +	/* nf_tables_netdev_event() is called under rtnl_mutex, this is
 +	 * indirectly serializing all the other holders of the commit_mutex with
 +	 * the rtnl_mutex.
 +	 */
  	dev =3D __dev_get_by_name(net, ifname);
  	if (!dev) {
  		err =3D -ENOENT;

--Sig_/EH5MF1qJNoQbuN/x6PV0I1l
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/Rg8EACgkQAVBC80lX
0Gx+kggAlwsjzURJqJHjVvGAM6BEW74a+aX4CUivZE2IIRhnqmpN/Z3sos9L3FAD
wiphPmOZoJKnW4vy7IV6Ezs8+06HArUGPvrLDMGXq5uaJXVMX20vpU9pE5z0yRaT
gxmHlU4v2Ay7mf4WVuw6JCsNcILtycogQ1wTOPmLqQw25uOoowhhEfctUlhNmNje
JxRUvDH8zvycHNCowLix3V1drhSK77skiSpzKxWgdu5BmoKYkLP2eHWSJqtveU4j
usJUYqxXopEohJuBacm0dRhOhhpBrkOLNJlOgt/DdDZeqc8hx7eUXfp+rnzddJs0
4iwtJrs2RG3iPxM0fG0dH1H8xu8/Aw==
=9BrW
-----END PGP SIGNATURE-----

--Sig_/EH5MF1qJNoQbuN/x6PV0I1l--
