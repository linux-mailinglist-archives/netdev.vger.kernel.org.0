Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C4B56D2D1
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 04:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiGKCCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 22:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiGKCCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 22:02:25 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F61918340;
        Sun, 10 Jul 2022 19:02:21 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Lh6Zz2RM1z4xbn;
        Mon, 11 Jul 2022 12:02:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1657504939;
        bh=xqBFKK6qf7Ib3HJxYp7IZT2SldM0zLDbqM3KeFXB0c8=;
        h=Date:From:To:Cc:Subject:From;
        b=hJANgGzYNQxpuf2k1CO5wvyhRVINxJUSUsRe+Q0zUzlGUAKWhjov/1pF8TntFIgYK
         QHrPAgHHYeFrPb5ghk3m0o3qv+pepVmgt4k7ImQ9Y1QD87MR3rtgqLbHwFJ13ke+Q6
         BHqI2ZEX6PikvBv1B9yiz5TSX0NYEfyANWtwbKfxUst5RAIAtOevNH6znaVB7C2HRW
         fT9O+zoydA5KuFmTBc6CrXju78F6YZsdzn4TYxHTr4ftfGvNJvMfl0gzfm6hjfUcMt
         Aml33ogJ70PNakO57Sq3HqIGDfBnHyv8li17viOkXF7b3YMycAbzZ+xRJwTupFCa8F
         D/m9cAywSXBpQ==
Date:   Mon, 11 Jul 2022 12:02:11 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220711120211.7c8b7cba@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2REdDITgtcduHSgUid.oAVa";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/2REdDITgtcduHSgUid.oAVa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/net/sock.h

between commit:

  310731e2f161 ("net: Fix data-races around sysctl_mem.")

from the net tree and commit:

  e70f3c701276 ("Revert "net: set SK_MEM_QUANTUM to 4096"")

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
index 9fa54762e077,0dd43c3df49b..000000000000
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@@ -1521,22 -1541,10 +1541,10 @@@ void __sk_mem_reclaim(struct sock *sk,=20
  #define SK_MEM_SEND	0
  #define SK_MEM_RECV	1
 =20
- /* sysctl_mem values are in pages, we convert them in SK_MEM_QUANTUM unit=
s */
+ /* sysctl_mem values are in pages */
  static inline long sk_prot_mem_limits(const struct sock *sk, int index)
  {
- 	long val =3D READ_ONCE(sk->sk_prot->sysctl_mem[index]);
-=20
- #if PAGE_SIZE > SK_MEM_QUANTUM
- 	val <<=3D PAGE_SHIFT - SK_MEM_QUANTUM_SHIFT;
- #elif PAGE_SIZE < SK_MEM_QUANTUM
- 	val >>=3D SK_MEM_QUANTUM_SHIFT - PAGE_SHIFT;
- #endif
- 	return val;
 -	return sk->sk_prot->sysctl_mem[index];
++	return READ_ONCE(sk->sk_prot->sysctl_mem[index]);
  }
 =20
  static inline int sk_mem_pages(int amt)

--Sig_/2REdDITgtcduHSgUid.oAVa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmLLhKMACgkQAVBC80lX
0GzuqQf/XT2dktWH13klD45XChcgFkdIidFCA/v3Uql4IiVzIJjmHtwKGhsuhbbw
QptsNRGPrRV5wsOszqL2yWUTZO9MQdayubx0O7m1jKBdO62wzvC/jRJ2dHm2zwrS
94IHUVsAPxi+8DLxTP5asgAImeRbkvcXML9alP42O2vqw3HQaGCoByZvGtfF92+C
WXYH1pM4Fzf8lpO5o2NWJ3HLACTl0Pn29maGuezLcSoAtQVUh0ly0eKrrHQdn09E
H+0d0j4Ue6mHuCmF6SCJ2ZKl6o9X4s90N0RdQLlCtHFkG2TpPiBmJT+jFtOvTEyQ
2Gd7VSJlolF3g3q9AnVOggEpFV3prQ==
=/tyl
-----END PGP SIGNATURE-----

--Sig_/2REdDITgtcduHSgUid.oAVa--
