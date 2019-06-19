Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5E44B06B
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 05:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730249AbfFSDXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 23:23:31 -0400
Received: from ozlabs.org ([203.11.71.1]:36817 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfFSDXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 23:23:31 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45T9Jb4zWRz9s4V;
        Wed, 19 Jun 2019 13:23:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1560914608;
        bh=XNdIJ2ZE/J4YNi6lmuA5/rpiKhu8nYiFcyeg4wJYpek=;
        h=Date:From:To:Cc:Subject:From;
        b=rM9Lv4VpP8jRohc5sxUugCj1OaqbVBnRh3qUa/5qBX1yn2KykFnz6v1iYeGTHySK+
         x009DMMi0EvQwkU0oXE3nIW6xhmX+s0WA0U62Hht8GfaR9PTHjKFnDUHSOsVShcNwB
         /0zMkScIPnVfMUnnebOmOXb3YVRmcIhFm25YhiYk3FMVF7n9MkxhsbSLFGYjQTNpI+
         25IeIagQ78m0g7BvONlBAw3tq3tF+2Cle27IMLhNBGS2ll+4XdTjS5jUfVmzI19M9Q
         BTSyX15IhMP0ikt6E3Cmo0QS4GiAUmH7kqhZKG5p+rCOFou6jG6y9IkqMTCQkRanKN
         C1lM5PbtDLRFw==
Date:   Wed, 19 Jun 2019 13:23:26 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20190619132326.1846345b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Oe8kv/g+2rA5hJ_o/risALj"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Oe8kv/g+2rA5hJ_o/risALj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from usr/include/linux/tc_act/tc_ctinfo.hdrtest.c:1:
./usr/include/linux/tc_act/tc_ctinfo.h:30:21: error: implicit declaration o=
f function 'BIT' [-Werror=3Dimplicit-function-declaration]
  CTINFO_MODE_DSCP =3D BIT(0),
                     ^~~
./usr/include/linux/tc_act/tc_ctinfo.h:30:2: error: enumerator value for 'C=
TINFO_MODE_DSCP' is not an integer constant
  CTINFO_MODE_DSCP =3D BIT(0),
  ^~~~~~~~~~~~~~~~
./usr/include/linux/tc_act/tc_ctinfo.h:32:1: error: enumerator value for 'C=
TINFO_MODE_CPMARK' is not an integer constant
 };
 ^

Caused by commit

  24ec483cec98 ("net: sched: Introduce act_ctinfo action")

Presumably exposed by commit

  b91976b7c0e3 ("kbuild: compile-test UAPI headers to ensure they are self-=
contained")

from the kbuild tree.

I have applied the following (obvious) patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 19 Jun 2019 13:15:22 +1000
Subject: [PATCH] net: sched: don't use BIT() in uapi headers

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/uapi/linux/tc_act/tc_ctinfo.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/tc_act/tc_ctinfo.h b/include/uapi/linux/tc_=
act/tc_ctinfo.h
index da803e05a89b..6166c62dd7dd 100644
--- a/include/uapi/linux/tc_act/tc_ctinfo.h
+++ b/include/uapi/linux/tc_act/tc_ctinfo.h
@@ -27,8 +27,8 @@ enum {
 #define TCA_CTINFO_MAX (__TCA_CTINFO_MAX - 1)
=20
 enum {
-	CTINFO_MODE_DSCP	=3D BIT(0),
-	CTINFO_MODE_CPMARK	=3D BIT(1)
+	CTINFO_MODE_DSCP	=3D (1UL << 0),
+	CTINFO_MODE_CPMARK	=3D (1UL << 1)
 };
=20
 #endif
--=20
2.20.1

--=20
Cheers,
Stephen Rothwell

--Sig_/Oe8kv/g+2rA5hJ_o/risALj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0Jqq4ACgkQAVBC80lX
0GyVIgf/VbrXFbohWE6yqO7OKKSo9BQo0IpNZQBM1Ivy3Ohdj6mLaAKBc+gZ2JXa
ELRGN9ZQprRInANOywYU9w0+PN08rNXxR9uIZZWkDJXKoMg4bA/vLjT1OYsh/Pwj
T2rj/4R7jal8HOvV5A3VvT5BJ9ga4ysasn7Hyq44afXJzIc35hcTFO1K3wv8R4ha
g0Ex3LqE6nZzABvw8jEX2Aj/3NRThg2vt++DjumFWJqSrr/CqdeluVwrfO8GvvxI
J5e/VPt9gqwO7pe7Ye2CKyJ2N/2r7ctyfh+sRJdu8Eaqu2mLFAlnHkNWlyasvTVZ
tSzKgLsGxjLHCQEBqzCI1CRKzlbYiQ==
=q3GV
-----END PGP SIGNATURE-----

--Sig_/Oe8kv/g+2rA5hJ_o/risALj--
