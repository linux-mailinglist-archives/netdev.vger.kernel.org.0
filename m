Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECE83C0F5
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 03:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390745AbfFKBhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 21:37:47 -0400
Received: from ozlabs.org ([203.11.71.1]:41077 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390721AbfFKBhr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 21:37:47 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45NCLG4dpPz9sNT;
        Tue, 11 Jun 2019 11:37:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1560217063;
        bh=LEOXqMuOHS2LA/cnmJMRJ7jSXtfuT+TEE6bdqoeclC0=;
        h=Date:From:To:Cc:Subject:From;
        b=Ajuzvxq1hnrwQN6rmDPfF+EKLFst46z9s4lN0MFdY8uuvOxR7dsbMHSaLXlj8tBeQ
         4iSTgyiaIW/kZPXaDE4emoT58gVODPzrCoilwGCyLLU8AG6TxU+Q4mftQhUQkmcQcU
         HG+W7BdAOia17C3IfWofSvxm2VGfkrg56g7QQn1jnFrvgbuN9J215qWVCrlfTpRG2n
         gLM1kWND67PSBSrD890KDjv3g63kxybcj2ZLHrKJuvzIb92p9MpClKmChchM4d4cjD
         j0Dan/HpA5JMfQe+LrEW0u2AP7W7rxpThNBdNB3SC2mNRP2fWTn+G88aB5D1jpxQiX
         6lBx5c0Dn69yA==
Date:   Tue, 11 Jun 2019 11:37:41 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Lawrence Brakmo <brakmo@fb.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190611113741.366093ba@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/v=mIhK8JgwY4S9K1YwYlg.2"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/v=mIhK8JgwY4S9K1YwYlg.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  kernel/bpf/verifier.c

between commit:

  983695fa6765 ("bpf: fix unconnected udp hooks")

from the net tree and commit:

  5cf1e9145630 ("bpf: cgroup inet skb programs can return 0 to 3")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This is
now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your
tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc kernel/bpf/verifier.c
index a5c369e60343,5c2cb5bd84ce..000000000000
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@@ -5353,12 -5513,13 +5505,16 @@@ static int check_return_code(struct bpf
  	struct tnum range =3D tnum_range(0, 1);
 =20
  	switch (env->prog->type) {
 +	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 +		if (env->prog->expected_attach_type =3D=3D BPF_CGROUP_UDP4_RECVMSG ||
 +		    env->prog->expected_attach_type =3D=3D BPF_CGROUP_UDP6_RECVMSG)
 +			range =3D tnum_range(1, 1);
  	case BPF_PROG_TYPE_CGROUP_SKB:
+ 		if (env->prog->expected_attach_type =3D=3D BPF_CGROUP_INET_EGRESS) {
+ 			range =3D tnum_range(0, 3);
+ 			enforce_attach_type_range =3D tnum_range(2, 3);
+ 		}
  	case BPF_PROG_TYPE_CGROUP_SOCK:
 -	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
  	case BPF_PROG_TYPE_SOCK_OPS:
  	case BPF_PROG_TYPE_CGROUP_DEVICE:
  	case BPF_PROG_TYPE_CGROUP_SYSCTL:
@@@ -5385,9 -5546,13 +5541,13 @@@
  			verbose(env, "has unknown scalar value");
  		}
  		tnum_strn(tn_buf, sizeof(tn_buf), range);
 -		verbose(env, " should have been %s\n", tn_buf);
 +		verbose(env, " should have been in %s\n", tn_buf);
  		return -EINVAL;
  	}
+=20
+ 	if (!tnum_is_unknown(enforce_attach_type_range) &&
+ 	    tnum_in(enforce_attach_type_range, reg->var_off))
+ 		env->prog->enforce_expected_attach_type =3D 1;
  	return 0;
  }
 =20

--Sig_/v=mIhK8JgwY4S9K1YwYlg.2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlz/BeUACgkQAVBC80lX
0GxZ0gf/X1ty+iSl/RyRPkDHBjW72t/r0ovp1qii6DzPG/0GFCnQehj1jLn/uhQc
WxgXqyuAK1tAtbj0tLadC+Byalyx0SLLC8Yo1atTtfKhttPyAAvKUJcZzC9EgKQu
IOqXxNTegMtzY/24iVzjZWPTw8GXxIBIsfIsBeTLR1i4w5zYgASXECr3XbLXtTc/
oFlrtUgNECWJws/qkX/ocr5VRTcxId2ChxOF9n9K4qDrylc1CtnJyF7QgfWxsmfh
7Qi9ISppY6b5vJ07Ov52HBdYpVz85tTsFYJBCICWsX6XHk3zKWjzIBgqviLvJVq/
ojwyzCafG1HeK9oolqaK4fa7vtWEWw==
=EPPT
-----END PGP SIGNATURE-----

--Sig_/v=mIhK8JgwY4S9K1YwYlg.2--
