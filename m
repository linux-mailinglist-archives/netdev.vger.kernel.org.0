Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B492D2C9C59
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 10:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389895AbgLAJR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 04:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389873AbgLAJLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 04:11:53 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D173C0613D2;
        Tue,  1 Dec 2020 01:11:13 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Clbth4xPPz9sW4;
        Tue,  1 Dec 2020 20:11:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1606813869;
        bh=V2oVLU7Ya8T1FEbPhjvbw0g0LWUsablXABJKhT4Kzbk=;
        h=Date:From:To:Cc:Subject:From;
        b=LhIgp8E0q4gIucbZRK1uQkuvu/ua0oZ67pa67HWUINZN1VKu8aOkAWbBSEJl+8wO2
         nVF8DiGxVOiy023Z014p0m3n8lZWK5louusNA3ulz8flG5sWVQEiCnpbv5X8D/THu1
         fuPFPUreNUAlphbqYb7VATVPb55iOLKMoISa4T2FTm+7UHjK3MT6xc0r+3YI+g/m7n
         Tf4RgohMlAAblqymqxoOcdagrk91xs13GJGanYbrmBN/0odVGCaBnu3CMrj/YccXCI
         r8AD2qAkJdjfn6pDEZaQDy8U565rGWWTvavOO1inhAbIXUNvoZr8CSMOBXDwH+rqNf
         XRYszY0qQuZkw==
Date:   Tue, 1 Dec 2020 20:11:06 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: linux-next: manual merge of the akpm tree with the bpf-next tree
Message-ID: <20201201201106.3ab8fbce@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Gaz1/bh1l39mvpyLfdfqLGw";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Gaz1/bh1l39mvpyLfdfqLGw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm tree got a conflict in:

  fs/eventpoll.c

between commits:

  7fd3253a7de6 ("net: Introduce preferred busy-polling")
  7c951cafc0cb ("net: Add SO_BUSY_POLL_BUDGET socket option")

from the bpf-next tree and commit:

  cc2687004c9d ("epoll: simplify and optimize busy loop logic")

from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc fs/eventpoll.c
index a80a290005c4,88f5b26806e5..000000000000
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@@ -393,15 -395,19 +395,20 @@@ static bool ep_busy_loop(struct eventpo
  {
  	unsigned int napi_id =3D READ_ONCE(ep->napi_id);
 =20
- 	if ((napi_id >=3D MIN_NAPI_ID) && net_busy_loop_on())
+ 	if ((napi_id >=3D MIN_NAPI_ID) && net_busy_loop_on()) {
 -		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end, ep);
 +		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end, ep, false,
 +			       BUSY_POLL_BUDGET);
- }
-=20
- static inline void ep_reset_busy_poll_napi_id(struct eventpoll *ep)
- {
- 	if (ep->napi_id)
+ 		if (ep_events_available(ep))
+ 			return true;
+ 		/*
+ 		 * Busy poll timed out.  Drop NAPI ID for now, we can add
+ 		 * it back in when we have moved a socket with a valid NAPI
+ 		 * ID onto the ready list.
+ 		 */
  		ep->napi_id =3D 0;
+ 		return false;
+ 	}
+ 	return false;
  }
 =20
  /*

--Sig_/Gaz1/bh1l39mvpyLfdfqLGw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/GCKoACgkQAVBC80lX
0GzrkAf/XHydBRC0Cy49lYG5Rk9J0M4sT9MUOuRmLut4KQauDrIW3wh4gD9W2Lgg
io+WtsselVsi7HSS0jXmOsq9DARsS4tF2y6Ec/t+FLRjBfTKDjBQPvrixIpzEmE1
Ym6h48+62dDHzH2swol/sPRfmEU4LeH89y9uxwrE4LNH94KycQwL0otHfOnuuOdl
14IkmIHdzW0G+DdxUlcm5eULpH+S45/0QHamcq9ni5+DPLAKvka0Gh37l+/qx+jJ
5U5x6YaL89OpO7/ama7yr1dEYpk2GC2t3nKJ1wFDsaxOy91ykGJbNFARMU6iPvr1
Au3m2DCIvqts708x6liO/igSoNtApg==
=l2DX
-----END PGP SIGNATURE-----

--Sig_/Gaz1/bh1l39mvpyLfdfqLGw--
