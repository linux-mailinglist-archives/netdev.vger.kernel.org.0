Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA60301FB3
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 01:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbhAYAQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 19:16:41 -0500
Received: from ozlabs.org ([203.11.71.1]:55989 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbhAYAPN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 19:15:13 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DP9Kj34RLz9sS8;
        Mon, 25 Jan 2021 11:12:24 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1611533546;
        bh=44tq4/OfMcgWECL37VZAQvGTgZNPvpAZkSSqPeepzqU=;
        h=Date:From:To:Cc:Subject:From;
        b=grYIoux24BKw04Evb9w4AKMmyBnYLqxLLpRrSkiydfs52Qd1f60w5JFa+DhKNZbxe
         m3bZjcAtzm3aPCz4qQoz3uf3J1ddXtoOfWsqwFODaEa0obhEn58Wk8sFhZMZ6trtHA
         XbgwsGNM8zlNVxYVi3ULc75MFjWQ4Bd2Uz+nnzH+Hs80+WBtzieH/EQcvv2REl2XGq
         ei9lgEAlLfCm3MtkvBq/wEKCzLS83NxxHSnw1xFzA8L2Tot/O8CVCk7/9vvvGXrYgf
         UHjZ5uaPXaiItLrnCwoixw4P32JlTaNUVGgenMQVnn/KjfpI5/tdxY4Kt4xAQut5/h
         nwCTJJ+X94ciA==
Date:   Mon, 25 Jan 2021 11:12:23 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Arjun Roy <arjunroy@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Subject: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Message-ID: <20210125111223.2540294c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/9JTGJ/xWlo3l.+DokjWso99";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/9JTGJ/xWlo3l.+DokjWso99
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  net/ipv4/tcp.c

between commit:

  7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")

from the net-next tree and commit:

  9cacf81f8161 ("bpf: Remove extra lock_sock for TCP_ZEROCOPY_RECEIVE")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/ipv4/tcp.c
index e1a17c6b473c,26aa923cf522..000000000000
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@@ -4160,18 -4098,13 +4160,20 @@@ static int do_tcp_getsockopt(struct soc
  		if (copy_from_user(&zc, optval, len))
  			return -EFAULT;
  		lock_sock(sk);
 -		err =3D tcp_zerocopy_receive(sk, &zc);
 +		err =3D tcp_zerocopy_receive(sk, &zc, &tss);
+ 		err =3D BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sk, level, optname,
+ 							  &zc, &len, err);
  		release_sock(sk);
 -		if (len >=3D offsetofend(struct tcp_zerocopy_receive, err))
 -			goto zerocopy_rcv_sk_err;
 +		if (len >=3D offsetofend(struct tcp_zerocopy_receive, msg_flags))
 +			goto zerocopy_rcv_cmsg;
  		switch (len) {
 +		case offsetofend(struct tcp_zerocopy_receive, msg_flags):
 +			goto zerocopy_rcv_cmsg;
 +		case offsetofend(struct tcp_zerocopy_receive, msg_controllen):
 +		case offsetofend(struct tcp_zerocopy_receive, msg_control):
 +		case offsetofend(struct tcp_zerocopy_receive, flags):
 +		case offsetofend(struct tcp_zerocopy_receive, copybuf_len):
 +		case offsetofend(struct tcp_zerocopy_receive, copybuf_address):
  		case offsetofend(struct tcp_zerocopy_receive, err):
  			goto zerocopy_rcv_sk_err;
  		case offsetofend(struct tcp_zerocopy_receive, inq):

--Sig_/9JTGJ/xWlo3l.+DokjWso99
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAODOcACgkQAVBC80lX
0Gx1IAf8DfeFGwju4aCfqdSEJEz4kyxubepTOBzSK/aqu+WE4/o+iEVO0n16n1YG
vM4lgVwCONu/O9XB9S1EKBbac7/q/ZujX/fdOOOVboYM3gSnEHTXeUkbdquiuVEc
kDWuSFLlGuQl5Ya2+t8zt62h0irGJMr7U/hsFsbFwgTr9ajZq9ditFxHPAvx269y
Ooo98XiQ49+u21tyGFMGxOlrUZvj0P0AAnRJAC14XOEUirUpTphWsmVngC+vNElh
lqtvttfJTYB0ZCfjbwPs5hKymnwvR7luPwjYOJcoJeRYs70TqoB29350q0VWXrMD
MOdLtECEpczC6ZNMhR0x3k/kXsRetA==
=UY0M
-----END PGP SIGNATURE-----

--Sig_/9JTGJ/xWlo3l.+DokjWso99--
