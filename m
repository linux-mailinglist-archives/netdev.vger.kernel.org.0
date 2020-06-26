Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E5220A983
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 02:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgFZAFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 20:05:33 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:56115 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgFZAFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 20:05:33 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49tHG21Khhz9sQt;
        Fri, 26 Jun 2020 10:05:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1593129931;
        bh=1/NpNWSRYiuRWHY1OaZc1T1Yqf2ZVowm/dB1HXxkKjc=;
        h=Date:From:To:Cc:Subject:From;
        b=J5yt0phjrDQhLtXHDFTgmRLJ1RWOhMw2rjH8Ggtn5bNqEx+omYjBKxFKNUzq/Ksp8
         xZQV4Qu9j+lc4IrmrjVidJv3E+z/RpSLooEDoKKMKdpxJWlKhx04wJoIjXss7Ilfig
         flA0X7KUabWPehZjAWB49ClBXi65maql1Tlr8BEO5MRNQbCThrj6uaKRe4qCll5XCD
         DNbC4J2RAhVsB7yxA+dbNrQzdtmGp6KwuBLbGdVpyKpCtNagGBMVdup5JLBkctQsVC
         +NOZkM5Rht2Wr+3CAhO4yNgSWhUjx6lWma+oOCyiBIM7LI8Aj9GXZaJXTWgC832xdI
         SbjailGCKR3Nw==
Date:   Fri, 26 Jun 2020 10:05:27 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>
Subject: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <20200626100527.4dad8695@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WG=8.S1mSbgElhtsPHXXGa2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/WG=8.S1mSbgElhtsPHXXGa2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  tools/testing/selftests/bpf/progs/bpf_iter_netlink.c

between commits:

  9c82a63cf370 ("libbpf: Fix CO-RE relocs against .text section")
  647b502e3d54 ("selftests/bpf: Refactor some net macros to bpf_tracing_net=
.h")

from the bpf tree and commit:

  84544f5637ff ("selftests/bpf: Move newer bpf_iter_* type redefining to a =
new header file")

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

diff --cc tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
index 75ecf956a2df,cec82a419800..000000000000
--- a/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
@@@ -11,21 -7,7 +7,7 @@@
 =20
  char _license[] SEC("license") =3D "GPL";
 =20
- #define sk_rmem_alloc	sk_backlog.rmem_alloc
- #define sk_refcnt	__sk_common.skc_refcnt
-=20
- struct bpf_iter_meta {
- 	struct seq_file *seq;
- 	__u64 session_id;
- 	__u64 seq_num;
- } __attribute__((preserve_access_index));
-=20
- struct bpf_iter__netlink {
- 	struct bpf_iter_meta *meta;
- 	struct netlink_sock *sk;
- } __attribute__((preserve_access_index));
-=20
 -static inline struct inode *SOCK_INODE(struct socket *socket)
 +static __attribute__((noinline)) struct inode *SOCK_INODE(struct socket *=
socket)
  {
  	return &container_of(socket, struct socket_alloc, socket)->vfs_inode;
  }

--Sig_/WG=8.S1mSbgElhtsPHXXGa2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl71O8cACgkQAVBC80lX
0GzFHgf9GX71ZbtDGNbranQUQJZc/0K9s1lhhuoezD/QXpocFtHTWi9car8A5AjJ
nJaRR1B4SkzrRnca/dOsxzhMEGhK9hvkipIR9mxKARGcE5Zd8Pa6ng1pxHasiJSp
kAAbg3UcCfZ0wwbWskSROHvc7UHHXnIeL20hLy92Dl+9YqaivpElhEnb3UO7KUTi
mhAa3tss/aW4mXWe+u88S0Capv/No9OCP2kLlvADq2GVidpO74vzBE6lTcHMnVJ+
BFokVFwIL5k3f1oeu4KQayqnynj8y9kkA+4ZeJ/ELW14oLeH5KT1+RFA54jfK2Ey
C/5QO/iVPc99U2hgssUA6MzRbCYWog==
=LMGA
-----END PGP SIGNATURE-----

--Sig_/WG=8.S1mSbgElhtsPHXXGa2--
