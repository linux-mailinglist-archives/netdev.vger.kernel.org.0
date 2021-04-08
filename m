Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3497B357AA8
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 05:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhDHDLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 23:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhDHDLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 23:11:32 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3636C061760;
        Wed,  7 Apr 2021 20:11:21 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FG5rR0XTcz9sVt;
        Thu,  8 Apr 2021 13:11:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1617851479;
        bh=XRZd5e7aM4sYuw8uXFm5nELypDN8Dj4CBomZlTo5WBQ=;
        h=Date:From:To:Cc:Subject:From;
        b=umdV4Dt0iJQwP9m+JF3U7IByKWWUiAQlqSlq3OhvMeRnXMnTbqWLP0T7tBBsQwADS
         BcP3tDn7p8kKCNnOBaRRwMxYp40CzlakMURDXC+7rKfD5vU0GEA9isKIJkMMwOi6rZ
         /AK7kFlmBMT3aMAdr6swzaKB8htFRpP+IEfpVaHdWeaPh7Zd/PHJHvdu/9tmDSs8me
         Ma8dmtg9pgVjPoI14EqaeknYpVEAv5ZWAzJt3ocnfuIHzTKrKG61eTQ3LBTB8QLSDC
         KwdONqukPHmGY3tTWROm+/FRVWXj+1EuL6MVR/WTFbkDWP2hSMWzIbTwXXw9lAq+EH
         UG5GcSNPCQJRQ==
Date:   Thu, 8 Apr 2021 13:11:17 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the bpf tree
Message-ID: <20210408131117.7f2f3a29@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/YAP01BDqZX8g.n8__N40P_p";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/YAP01BDqZX8g.n8__N40P_p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/core/skmsg.c

between commit:

  144748eb0c44 ("bpf, sockmap: Fix incorrect fwd_alloc accounting")

from the bpf tree and commit:

  e3526bb92a20 ("skmsg: Move sk_redir from TCP_SKB_CB to skb")

from the net-next tree.

I fixed it up (I think - see below) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/core/skmsg.c
index 5def3a2e85be,92a83c02562a..000000000000
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@@ -806,12 -900,17 +900,13 @@@ int sk_psock_tls_strp_read(struct sk_ps
  	int ret =3D __SK_PASS;
 =20
  	rcu_read_lock();
- 	prog =3D READ_ONCE(psock->progs.skb_verdict);
+ 	prog =3D READ_ONCE(psock->progs.stream_verdict);
  	if (likely(prog)) {
 -		/* We skip full set_owner_r here because if we do a SK_PASS
 -		 * or SK_DROP we can skip skb memory accounting and use the
 -		 * TLS context.
 -		 */
  		skb->sk =3D psock->sk;
- 		tcp_skb_bpf_redirect_clear(skb);
- 		ret =3D sk_psock_bpf_run(psock, prog, skb);
- 		ret =3D sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+ 		skb_dst_drop(skb);
+ 		skb_bpf_redirect_clear(skb);
+ 		ret =3D bpf_prog_run_pin_on_cpu(prog, skb);
+ 		ret =3D sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
  		skb->sk =3D NULL;
  	}
  	sk_psock_tls_verdict_apply(skb, psock->sk, ret);
@@@ -876,13 -995,13 +991,14 @@@ static void sk_psock_strp_read(struct s
  		kfree_skb(skb);
  		goto out;
  	}
- 	prog =3D READ_ONCE(psock->progs.skb_verdict);
 -	skb_set_owner_r(skb, sk);
+ 	prog =3D READ_ONCE(psock->progs.stream_verdict);
  	if (likely(prog)) {
 +		skb->sk =3D sk;
- 		tcp_skb_bpf_redirect_clear(skb);
- 		ret =3D sk_psock_bpf_run(psock, prog, skb);
- 		ret =3D sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+ 		skb_dst_drop(skb);
+ 		skb_bpf_redirect_clear(skb);
+ 		ret =3D bpf_prog_run_pin_on_cpu(prog, skb);
+ 		ret =3D sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 +		skb->sk =3D NULL;
  	}
  	sk_psock_verdict_apply(psock, skb, ret);
  out:
@@@ -953,13 -1115,15 +1112,16 @@@ static int sk_psock_verdict_recv(read_d
  		kfree_skb(skb);
  		goto out;
  	}
- 	prog =3D READ_ONCE(psock->progs.skb_verdict);
 -	skb_set_owner_r(skb, sk);
+ 	prog =3D READ_ONCE(psock->progs.stream_verdict);
+ 	if (!prog)
+ 		prog =3D READ_ONCE(psock->progs.skb_verdict);
  	if (likely(prog)) {
 +		skb->sk =3D sk;
- 		tcp_skb_bpf_redirect_clear(skb);
- 		ret =3D sk_psock_bpf_run(psock, prog, skb);
- 		ret =3D sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+ 		skb_dst_drop(skb);
+ 		skb_bpf_redirect_clear(skb);
+ 		ret =3D bpf_prog_run_pin_on_cpu(prog, skb);
+ 		ret =3D sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 +		skb->sk =3D NULL;
  	}
  	sk_psock_verdict_apply(psock, skb, ret);
  out:

--Sig_/YAP01BDqZX8g.n8__N40P_p
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBudFUACgkQAVBC80lX
0GzNiwf8Du4CRrC2d/nEEZUR8gEaBrd8EWeWQOsV5kAzE84/sh8t4sTxEqUQsLfv
iakS0u4IFrEQidjptTyoU08Zv7rWXTqqsMjGMI6W2ju7W/4eapwKWogmaRkKh4Q6
jTNQE1liobzyZiXGSPs5LHhNUxaFsdX2+RTymmdcEUUkOvU5hnPnaG/+FvFF9/0f
oiuCT6SMLUcMSKC6V4Zjat+TgbuAhRkS0HCx8GPtB3JoUjdvm0X7VoGrWLc0UYTQ
dNnKbE2yLykX1xqU/CQ8KQvX0k3F32EHaHNhOBgzDsBhobrqxjkRDKV1CNRRT0cv
U1BhWbnfD8Bwn36MgFTu/3OItkqOOg==
=szah
-----END PGP SIGNATURE-----

--Sig_/YAP01BDqZX8g.n8__N40P_p--
