Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03881111C2
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 04:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfEBC5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 22:57:19 -0400
Received: from ozlabs.org ([203.11.71.1]:36495 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbfEBC5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 22:57:19 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44vg0W1XhVz9s55;
        Thu,  2 May 2019 12:57:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1556765835;
        bh=njGjmv1Kh8IKRDfr0l6tcSALENdRE1UnT9QoiUBRVAI=;
        h=Date:From:To:Cc:Subject:From;
        b=gc4kd9qCBbgSsgMBu7chfvC91er2ncqKN/18IVqhLHwRMO28EjyEawJDhcz4j3Edk
         4aqV1y7ZB08ffZ0+VEYDAlL025YfmwG/yzviHYsTg6tz7FVbCLgFE4jKILFdUzkbQH
         3PtEfoYuTIhKGl/L4VhYQuDwBcfqp1LA8BMIKhspRJ1S43SQJjTRO0LnHw75YJvWl/
         nU1ixYwKE2ibaG5JirGl0ZJE9WZWnGL/lWlhsPjsfVCdG/g03EGMsEoyLO/Zw2WvKb
         WE7aJLqd6LlzSWJ2LSscL/71BtuC9hFvBYwI8C/1g0gn4QzkBTcstBts/FFmsL4oqF
         71J8FXvV4KGng==
Date:   Thu, 2 May 2019 12:57:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190502125713.062a6c03@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/xX1HVvcycWHYg5aSwOZ0mB5"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/xX1HVvcycWHYg5aSwOZ0mB5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/ipv6/route.c

between commit:

  886b7a50100a ("ipv6: A few fixes on dereferencing rt->from")

from the net tree and commits:

  85bd05deb35a ("ipv6: Pass fib6_result to ip6_rt_cache_alloc")
  5012f0a5944c ("ipv6: Pass fib6_result to rt6_insert_exception")

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

diff --cc net/ipv6/route.c
index 0520aca3354b,b18e85cd7587..000000000000
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@@ -3391,11 -3494,17 +3489,14 @@@ static void rt6_do_redirect(struct dst_
  		     NDISC_REDIRECT, &ndopts);
 =20
  	rcu_read_lock();
- 	from =3D rcu_dereference(rt->from);
- 	if (!from)
+ 	res.f6i =3D rcu_dereference(rt->from);
 -	/* This fib6_info_hold() is safe here because we hold reference to rt
 -	 * and rt already holds reference to fib6_info.
 -	 */
 -	fib6_info_hold(res.f6i);
 -	rcu_read_unlock();
++	if (!res.f6i)
 +		goto out;
 =20
- 	nrt =3D ip6_rt_cache_alloc(from, &msg->dest, NULL);
+ 	res.nh =3D &res.f6i->fib6_nh;
+ 	res.fib6_flags =3D res.f6i->fib6_flags;
+ 	res.fib6_type =3D res.f6i->fib6_type;
+ 	nrt =3D ip6_rt_cache_alloc(&res, &msg->dest, NULL);
  	if (!nrt)
  		goto out;
 =20
@@@ -3405,8 -3514,11 +3506,8 @@@
 =20
  	nrt->rt6i_gateway =3D *(struct in6_addr *)neigh->primary_key;
 =20
 -	/* No need to remove rt from the exception table if rt is
 -	 * a cached route because rt6_insert_exception() will
 -	 * takes care of it
 -	 */
 +	/* rt6_insert_exception() will take care of duplicated exceptions */
- 	if (rt6_insert_exception(nrt, from)) {
+ 	if (rt6_insert_exception(nrt, &res)) {
  		dst_release_immediate(&nrt->dst);
  		goto out;
  	}

--Sig_/xX1HVvcycWHYg5aSwOZ0mB5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzKXIkACgkQAVBC80lX
0Gztzwf/ToY88yxVwWAUTvwTmg00mGiGlGcVjCVTR+uG3HsvYpqYdBDuS30OLXzZ
3UVohdgPs40P9mB9aqWsXG857cej5wW03ATbtnNz9vHESBZgPOW5x53TkUR4Ua2D
FwKtA19kMapS1B7DV8vqa+t+dWhzI17Surit6c/P/ev1WorvCC3Qps0Hyw8x83PF
PWWzQCi7p/IwvsnbT3vSjnfy2QEW99AobT+FKHdTieq+germbds+t2jN7biszf6b
xIPQ06qxWbNfwbBzkYVnMuBlRq//wk+q0eRyKHEkZlKmJBjDfoS6HLtDNAGql8mN
AkcNUt8r21IdJTXVAasy/V/oCRWt/A==
=+YCd
-----END PGP SIGNATURE-----

--Sig_/xX1HVvcycWHYg5aSwOZ0mB5--
