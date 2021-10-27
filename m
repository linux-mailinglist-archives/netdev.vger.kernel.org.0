Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D040C43BE5D
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 02:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240377AbhJ0APb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 20:15:31 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:43761 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbhJ0APa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 20:15:30 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hf8KS3VyZz4xbW;
        Wed, 27 Oct 2021 11:12:59 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1635293584;
        bh=mHh1stcao4rPBa1WkjlflOW8SghL+SJ1HlGP/m/Vj1I=;
        h=Date:From:To:Cc:Subject:From;
        b=XpI3IGcE1FlwvfMfuqf0+ZBAwR9s7AkntjGZ9rcdm9mJKgy3PRFSPNTdGNYGQhB55
         1xzel0ZsPbmupKwXf8bwFro91xLxfv24nErN0er1x3UipQ1pkOb87ZI2xCjbHGcKyh
         ibLzUflSrP68FzQf9DJYuktLLuJcOeqdrSvd+VB6jrE/4a/R/qr2aeflb3xWX1Ko47
         WCf0o6TOa624O9Go+FC+DunsZvJAw1qXwAkil8wqKAD/6GzRaHvEOun6hdDGNgcAZy
         bCnFUbDHmHDYwixeqQM6lpLmH91doq+Z+DveD1GMwQjXjM5ivpy/QTEUjtMeK8/CSi
         LQg5ucrpLI4+g==
Date:   Wed, 27 Oct 2021 11:12:58 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Richard Palethorpe <rpalethorpe@suse.com>
Subject: linux-next: manual merge of the net-next tree with the bpf tree
Message-ID: <20211027111258.13136955@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/yLNrGkC4z.ubCL6pErra2mJ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/yLNrGkC4z.ubCL6pErra2mJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/net/sock.h

between commit:

  7b50ecfcc6cd ("net: Rename ->stream_memory_read to ->sock_is_readable")

from the bpf tree and commit:

  4c1e34c0dbff ("vsock: Enable y2038 safe timeval for timeout")

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

diff --cc include/net/sock.h
index 463f390d90b3,ff4e62aa62e5..000000000000
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@@ -2820,10 -2840,8 +2840,15 @@@ void sock_set_sndtimeo(struct sock *sk
 =20
  int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len);
 =20
+ int sock_get_timeout(long timeo, void *optval, bool old_timeval);
+ int sock_copy_user_timeval(struct __kernel_sock_timeval *tv,
+ 			   sockptr_t optval, int optlen, bool old_timeval);
+=20
 +static inline bool sk_is_readable(struct sock *sk)
 +{
 +	if (sk->sk_prot->sock_is_readable)
 +		return sk->sk_prot->sock_is_readable(sk);
 +	return false;
 +}
++
  #endif	/* _SOCK_H */

--Sig_/yLNrGkC4z.ubCL6pErra2mJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmF4mYoACgkQAVBC80lX
0Gwr7AgApbgV9qUiLTkz2uVip3LC5eOIRle3rYW1/RceWyiFSKDXKdad/HR3E1ed
fzkGdaU+kNIvf7JF3wNhRewPsrT616XHZ9fwmtk5/vXn4bUXa7U8udEtX0xJyLiI
Vg0UH1GJQvVJoSpPDNRbjsv4s9BqytkRNrFN0cl5uBCRwqO3JuP3kGS/9CIZg7aU
YvDWZanAC0XwXzHJRnc7Q0r1kBpF9bwt3caGFfXg6s8FzVpvHLaYQlqqGBy5+jRY
Q+hRNMiyxFBOTGa13KocDvDY8geUSUZ9i2KgGJySLwoL3vHRjk43o6B4h+fvPvxj
873nxKAoOGXr2NqF3MS3lvy1iJqSgg==
=yLjd
-----END PGP SIGNATURE-----

--Sig_/yLNrGkC4z.ubCL6pErra2mJ--
