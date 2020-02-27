Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7765C172C30
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 00:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgB0XZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 18:25:00 -0500
Received: from ozlabs.org ([203.11.71.1]:38043 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729391AbgB0XZA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 18:25:00 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48T808521Qz9sPk;
        Fri, 28 Feb 2020 10:24:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1582845898;
        bh=To3tzqfMsnkCEAkQZKONomjnYrthyCCicrzs9dIy7to=;
        h=Date:From:To:Cc:Subject:From;
        b=dTuaz+BzpPrKtQu42RNSwZPRg+oncKghmYa7G1kwVghJr9dUlIK4huqzAVrsfF1G1
         o+9T8GKSkjbPpigAI2/XcNl+Ma78uM1CI7pJDL9RONt4P0mr9aBdbqH5aN/cjwGmUt
         3wpfLyNV2z990izlCVcl5t8kf4p+7XdweRkCVR8gkY0QKdkPchl5k0yg/M37rdSF1e
         fwyyFoU43TdAoEtY9YHrWBWmyS4R45mlE96Cf0X+zJDrxZrd0UkByWFIAvi+zvOXvj
         CBerchfBrKzyXIV3/K/9GJJADLqER9Y0UtOrgCxhnDequEWQiu0crOqoPTE/Q0dyzP
         j4nqE3KRS28dA==
Date:   Fri, 28 Feb 2020 10:24:51 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200228102451.0a3d2057@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/JVbqX+zVa7eXIucuJAD39hv";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/JVbqX+zVa7eXIucuJAD39hv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/mptcp/protocol.c

between commit:

  dc24f8b4ecd3 ("mptcp: add dummy icsk_sync_mss()")

from the net tree and commit:

  80992017150b ("mptcp: add work queue skeleton")

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

diff --cc net/mptcp/protocol.c
index 3c19a8efdcea,044295707bbf..000000000000
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@@ -543,20 -666,26 +666,32 @@@ static void __mptcp_close_ssk(struct so
  	}
  }
 =20
 +static unsigned int mptcp_sync_mss(struct sock *sk, u32 pmtu)
 +{
 +	return 0;
 +}
 +
+ static void mptcp_worker(struct work_struct *work)
+ {
+ 	struct mptcp_sock *msk =3D container_of(work, struct mptcp_sock, work);
+ 	struct sock *sk =3D &msk->sk.icsk_inet.sk;
+=20
+ 	lock_sock(sk);
+ 	__mptcp_move_skbs(msk);
+ 	release_sock(sk);
+ 	sock_put(sk);
+ }
+=20
  static int __mptcp_init_sock(struct sock *sk)
  {
  	struct mptcp_sock *msk =3D mptcp_sk(sk);
 =20
  	INIT_LIST_HEAD(&msk->conn_list);
  	__set_bit(MPTCP_SEND_SPACE, &msk->flags);
+ 	INIT_WORK(&msk->work, mptcp_worker);
 =20
  	msk->first =3D NULL;
 +	inet_csk(sk)->icsk_sync_mss =3D mptcp_sync_mss;
 =20
  	return 0;
  }

--Sig_/JVbqX+zVa7eXIucuJAD39hv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5YT8MACgkQAVBC80lX
0GxXUgf/eb8o92fkFNcCN1qB8ycZGoXyKwCqNr7xKpnIJoj16vINIdmVcxdPippj
41ME2k0DE7xp94UioXDKX+jnquLu9/eFXtxzW3Q/4kh8rEfM8DPxpC0eqtbKASOK
+QhF3qJ7P05oXaweUnjwWfOxKN09wJmlHNihQy3SePLXaqDbisubrDD652cljv8z
/GmOVssH7LmRup+HvpABOcJnST7+y08x6KEVqmlUr+y4WFRNaX7p66XeLmKhoYKN
V2xY6/7IXgg6GUmkJgFDy9a81usJd9BdOZCFatUoIfYrVnKATxzMVJkROuBRyMpU
IxL+nPwvoEcU8P7qLXsx8ElUqlpNGg==
=qjZb
-----END PGP SIGNATURE-----

--Sig_/JVbqX+zVa7eXIucuJAD39hv--
