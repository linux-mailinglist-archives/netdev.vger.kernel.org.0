Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4693B11C1
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 04:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhFWCcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 22:32:41 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:38453 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230004AbhFWCcl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 22:32:41 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G8nL63z5sz9sVp;
        Wed, 23 Jun 2021 12:30:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1624415422;
        bh=/vX2d4nBp95AiQYzim25ID4hG5hiACFClTaFYQiZ+Vc=;
        h=Date:From:To:Cc:Subject:From;
        b=rGHWPtmI28UIyGe9BV3BcE/eRVDbJC1BHes5TZ0yP6i2ynqsL/hZwhofTpODUjSCC
         0r5BJeF6/6ri8xpdSbod+i/kZtjKbVXbgnK8gQxZ0hIms/GCBglSgyzc5LIiRVGf5K
         NdhKyAg8mZmuBXSaMmMJMI8EjlPUikHskjDXcgxfIwXWDbcR5mRDe2PUqsBK53XFla
         QdfzAucsHrWDKD7trhXzu9YP44sBAKzz6lJnD76NxyYrL/QRUdJp68TKQiG2MU1dmE
         2IPVM5jF+gVu0ijuVneyeUka9ugtQdQ8rucA4zyvnpopxOZRD7o43Oc2Ag6PlEXQvF
         UOtddDH5lNqBQ==
Date:   Wed, 23 Jun 2021 12:30:20 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Xin Long <lucien.xin@gmail.com>
Subject: linux-next: manual merge of the net-next tree with the kspp-gustavo
 tree
Message-ID: <20210623123020.2840adc2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/xOJAl=5v5wdPqk0k5x2C2PP";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/xOJAl=5v5wdPqk0k5x2C2PP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/sctp/input.c

between commit:

  0572b37b27f4 ("sctp: Fix fall-through warnings for Clang")

from the kspp-gustavo tree and commit:

  d83060759a65 ("sctp: extract sctp_v4_err_handle function from sctp_v4_err=
")

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

diff --cc net/sctp/input.c
index 5ceaf75105ba,fe6429cc012f..000000000000
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@@ -554,6 -556,49 +556,50 @@@ void sctp_err_finish(struct sock *sk, s
  	sctp_transport_put(t);
  }
 =20
+ static void sctp_v4_err_handle(struct sctp_transport *t, struct sk_buff *=
skb,
+ 			       __u8 type, __u8 code, __u32 info)
+ {
+ 	struct sctp_association *asoc =3D t->asoc;
+ 	struct sock *sk =3D asoc->base.sk;
+ 	int err =3D 0;
+=20
+ 	switch (type) {
+ 	case ICMP_PARAMETERPROB:
+ 		err =3D EPROTO;
+ 		break;
+ 	case ICMP_DEST_UNREACH:
+ 		if (code > NR_ICMP_UNREACH)
+ 			return;
+ 		if (code =3D=3D ICMP_FRAG_NEEDED) {
+ 			sctp_icmp_frag_needed(sk, asoc, t, SCTP_TRUNC4(info));
+ 			return;
+ 		}
+ 		if (code =3D=3D ICMP_PROT_UNREACH) {
+ 			sctp_icmp_proto_unreachable(sk, asoc, t);
+ 			return;
+ 		}
+ 		err =3D icmp_err_convert[code].errno;
+ 		break;
+ 	case ICMP_TIME_EXCEEDED:
+ 		if (code =3D=3D ICMP_EXC_FRAGTIME)
+ 			return;
+=20
+ 		err =3D EHOSTUNREACH;
+ 		break;
+ 	case ICMP_REDIRECT:
+ 		sctp_icmp_redirect(sk, t, skb);
++		return;
+ 	default:
+ 		return;
+ 	}
+ 	if (!sock_owned_by_user(sk) && inet_sk(sk)->recverr) {
+ 		sk->sk_err =3D err;
+ 		sk->sk_error_report(sk);
+ 	} else {  /* Only an error on timeout */
+ 		sk->sk_err_soft =3D err;
+ 	}
+ }
+=20
  /*
   * This routine is called by the ICMP module when it gets some
   * sort of error condition.  If err < 0 then the socket should

--Sig_/xOJAl=5v5wdPqk0k5x2C2PP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDSnLwACgkQAVBC80lX
0Gy60Qf/Xhjo/wBPlb+GvSEEdaQUVE6UaU6pULd6wyqvfIMrH4NwQi1I3TODf05R
DtcSBK+CQhLKTQh0jv/waJyte7tbJVCLb/Zn0l/anYRkBqiGmwXKKPCKojvfzdGU
unqXWZKUdVQWQzp0lts8FE2FXDtxoPVGIPElN6+9/PbodIkgM05xDptzRNSl+4nV
cVx3Ih6zYQIrYtsonFFgiJjBFTg+5CVp6przsuEhzK3SBAR/d4vLL8MHozdYbLco
VmR3YPUwJBX2IL1A1xu8+xKa0yz9kooK5RU+tsoeoT5BD+753+hHMwr3CUHLNRDO
eU8Kb1vdqvRcY5DVScbDaTgPf1nZsA==
=FB9o
-----END PGP SIGNATURE-----

--Sig_/xOJAl=5v5wdPqk0k5x2C2PP--
