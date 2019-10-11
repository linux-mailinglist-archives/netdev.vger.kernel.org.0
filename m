Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE23BD368F
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbfJKAwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:52:18 -0400
Received: from ozlabs.org ([203.11.71.1]:52353 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727523AbfJKAwR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 20:52:17 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46q8YT15r0z9sN1;
        Fri, 11 Oct 2019 11:52:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1570755134;
        bh=40TpSGGFZna6YS63gHlB1757/gR4H593oTh0pDoS0Xo=;
        h=Date:From:To:Cc:Subject:From;
        b=FDT1zK2PaVifMAtxfW4JhI++t/KJVOFnAVS9/2aV1mfC85lM5GDETrIdLIC9u/Mgq
         LWDMqIKN2i10QvK0L4OluydIxCKGt36UY1lSNk35Y55j40mFZgFhlJiuyMG4sPLgfv
         Vh/KDwwV2J3amTvput/fGCYx2aaxYhm3L9NgiIhvs3Lxa2uRb01PTK5AIqlH+BAE6y
         cny81VsGaYF6bvlrBCEg81ZUCkUXFunTGxPejOB0Dp/6gD3nlO/75dcBmqzgc8dp2t
         05+7/KoXP8FiShJsratxaeXg3Vu/z2HBwvxFpMvW3sKx/rrIlsKb3rq+6dUoaMtiX7
         TAJtUNP2QMDPA==
Date:   Fri, 11 Oct 2019 11:52:12 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Qian Cai <cai@lca.pw>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: linux-next: manual merge of the tip tree with the net tree
Message-ID: <20191011115212.42c99d3d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/e/+Kh2gAtvCXdnDhQxvAXD9";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/e/+Kh2gAtvCXdnDhQxvAXD9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in:

  net/core/sock.c

between commit:

  8265792bf887 ("net: silence KCSAN warnings around sk_add_backlog() calls")

from the net tree and commit:

  5facae4f3549 ("locking/lockdep: Remove unused @nested argument from lock_=
release()")

from the tip tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/core/sock.c
index 54c06559ad8f,50b930364cb0..000000000000
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@@ -521,8 -521,8 +521,8 @@@ int __sk_receive_skb(struct sock *sk, s
 =20
  		rc =3D sk_backlog_rcv(sk, skb);
 =20
- 		mutex_release(&sk->sk_lock.dep_map, 1, _RET_IP_);
+ 		mutex_release(&sk->sk_lock.dep_map, _RET_IP_);
 -	} else if (sk_add_backlog(sk, skb, sk->sk_rcvbuf)) {
 +	} else if (sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf))) {
  		bh_unlock_sock(sk);
  		atomic_inc(&sk->sk_drops);
  		goto discard_and_relse;

--Sig_/e/+Kh2gAtvCXdnDhQxvAXD9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl2f0jwACgkQAVBC80lX
0Gz+3Af/ULGROBkbwtIx+MPVh1Fpr1ffQg/EfkyQp6dkoztkoW3BwCG1KY1tKLR/
X1LhPlHFyqicwDUknrrezstFcQVKf+PNR5yxPvo6VarASRvwOY/bxXSgU3AlXRu5
uvNyCprXlKz06XoZXWcKfdZdFa/XBfiNf1Q00PpcMQ9KF+TXpovc3KlHl7OK/aV+
S+89ZPC/o1CSCLXfMg82iBjxZPrJRepW4UGvfjEMy7HTo4irKDaZZ7FYKrOyONqx
tQ8IIbSHznNnNf9WJGRg12Tb2YIiL8NTIgI+pAlzr8zvFjHBisPjdqJu1BaW10XG
kNBYtRx3zyDGj3LW3o1nG2tZ9wJZ7g==
=U5o7
-----END PGP SIGNATURE-----

--Sig_/e/+Kh2gAtvCXdnDhQxvAXD9--
