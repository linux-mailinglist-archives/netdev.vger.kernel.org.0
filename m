Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA39317ED11
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 01:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbgCJAGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 20:06:18 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59487 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbgCJAGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 20:06:17 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48bwNk5B2wz9sRR;
        Tue, 10 Mar 2020 11:06:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1583798774;
        bh=7lQ8pI0XYE2KiKCl/kYDNDDZgptti74pekITiXXL/J4=;
        h=Date:From:To:Cc:Subject:From;
        b=qlovkNo+ecl805wgOZLkxTq3lDnuiYfJU7lYf6AbpXwQmTVPlBu4i32Nzze2BZIn2
         5A6NXjCJS2bK+Vm78cXyz224iXG2POPHTfG232Lfvefp9iefGY4rK+hL0aiVxI8dvF
         6cdZxLrNL+yyyR5v1TyY9QGLX5Q/9OV1HB/sq20fAelfx8jWcZQHhsah747qb11KHs
         uv5aJ4iEqxOF2WTRlbTMa0cav4fjHTc+XG/FqFFDdlBG2Dx33fEUmh76Tmgrn+vWzN
         Zf6rV+mHQt2qlC3h4ttpclRImktidvF9smUBab8JZNVirG62zGXJCm5pvFOMJpkpFG
         QgEfu5WD/pc5w==
Date:   Tue, 10 Mar 2020 11:06:12 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dmitry Yakunin <zeil@yandex-team.ru>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200310110612.611ab9ad@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7r9Ijk1oPrdyyqujRJR6XhL";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/7r9Ijk1oPrdyyqujRJR6XhL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/ipv4/inet_diag.c

between commit:

  83f73c5bb7b9 ("inet_diag: return classid for all socket types")

from the net tree and commit:

  085c20cacf2b ("bpf: inet_diag: Dump bpf_sk_storages in inet_diag_dump()")

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

diff --cc net/ipv4/inet_diag.c
index 8c8377568a78,e1cad25909df..000000000000
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@@ -298,6 -289,66 +303,48 @@@ int inet_sk_diag_fill(struct sock *sk,=20
  			goto errout;
  	}
 =20
 -	if (ext & (1 << (INET_DIAG_CLASS_ID - 1)) ||
 -	    ext & (1 << (INET_DIAG_TCLASS - 1))) {
 -		u32 classid =3D 0;
 -
 -#ifdef CONFIG_SOCK_CGROUP_DATA
 -		classid =3D sock_cgroup_classid(&sk->sk_cgrp_data);
 -#endif
 -		/* Fallback to socket priority if class id isn't set.
 -		 * Classful qdiscs use it as direct reference to class.
 -		 * For cgroup2 classid is always zero.
 -		 */
 -		if (!classid)
 -			classid =3D sk->sk_priority;
 -
 -		if (nla_put_u32(skb, INET_DIAG_CLASS_ID, classid))
 -			goto errout;
 -	}
 -
+ 	/* Keep it at the end for potential retry with a larger skb,
+ 	 * or else do best-effort fitting, which is only done for the
+ 	 * first_nlmsg.
+ 	 */
+ 	if (cb_data->bpf_stg_diag) {
+ 		bool first_nlmsg =3D ((unsigned char *)nlh =3D=3D skb->data);
+ 		unsigned int prev_min_dump_alloc;
+ 		unsigned int total_nla_size =3D 0;
+ 		unsigned int msg_len;
+ 		int err;
+=20
+ 		msg_len =3D skb_tail_pointer(skb) - (unsigned char *)nlh;
+ 		err =3D bpf_sk_storage_diag_put(cb_data->bpf_stg_diag, sk, skb,
+ 					      INET_DIAG_SK_BPF_STORAGES,
+ 					      &total_nla_size);
+=20
+ 		if (!err)
+ 			goto out;
+=20
+ 		total_nla_size +=3D msg_len;
+ 		prev_min_dump_alloc =3D cb->min_dump_alloc;
+ 		if (total_nla_size > prev_min_dump_alloc)
+ 			cb->min_dump_alloc =3D min_t(u32, total_nla_size,
+ 						   MAX_DUMP_ALLOC_SIZE);
+=20
+ 		if (!first_nlmsg)
+ 			goto errout;
+=20
+ 		if (cb->min_dump_alloc > prev_min_dump_alloc)
+ 			/* Retry with pskb_expand_head() with
+ 			 * __GFP_DIRECT_RECLAIM
+ 			 */
+ 			goto errout;
+=20
+ 		WARN_ON_ONCE(total_nla_size <=3D prev_min_dump_alloc);
+=20
+ 		/* Send what we have for this sk
+ 		 * and move on to the next sk in the following
+ 		 * dump()
+ 		 */
+ 	}
+=20
  out:
  	nlmsg_end(skb, nlh);
  	return 0;

--Sig_/7r9Ijk1oPrdyyqujRJR6XhL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5m2fQACgkQAVBC80lX
0GwjnQgAhFFX8PDORAxjYrJAEHqRPBUIQhcpfE5KhtzuJur5SaOmFlsjVTwN41CM
TVHs6u5kJAL/stdMAFPca4YXEE66+N7PDs81uYDmqZL8/ogkDeDd2blw0brWq/uE
f5RG7pD+oADLfuA9gLr+aUXrctXvDopKwaEvDOu3FG6qH8yGkfiX2GcwCjPTGOPm
hQJn/z2iv/murAVsNC9X39F/W/kTCOuSLAxL2pVmyBkCI1CaGYGpbD5iJzO/MG19
6bvfuwNOYWfWjC77I0zbQs6BCvMejSwJDe95b9pQ1BA1BhZd5lWhcBbX0z1KVoRF
hjCNg1YxZReN9kC8Bc0l/t3wh/eCyQ==
=uQDe
-----END PGP SIGNATURE-----

--Sig_/7r9Ijk1oPrdyyqujRJR6XhL--
