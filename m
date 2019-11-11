Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F42F6C5E
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 02:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfKKBj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 20:39:26 -0500
Received: from ozlabs.org ([203.11.71.1]:59865 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbfKKBj0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 20:39:26 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47BD7b0NqVz9s4Y;
        Mon, 11 Nov 2019 12:39:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1573436363;
        bh=AuDaBqMuB8YubdI3py2WhU7Li+8/PG+7HZ/4VOX2HnA=;
        h=Date:From:To:Cc:Subject:From;
        b=k7U0p6SXwZk/q8bu8b1ogCWIDgEMACuwxHCNAXQewobz5E1AwkLCWdsjKcY1LuRhn
         r2fqPu5raFH4i9nsV3Ixc+SLcF4tOsXDkoK43ieWLiRRZM2B+f5F1woaGj0Qy+Hz4X
         pj06pmo4YMKHjkT36XkW4S9ZEuOOxZWQe/9RTx6vGeV91nfKaPoowCvuZNnktFwx7K
         iRsZqk07aEP1rl85ArHNloyMqZbyymArZtzAtGzC1s22jNckBiYuV8clMo5KWdoGaJ
         coc0uCbGLKwDt+xEAHiup3X+B9qm7Gf1HmH5uZCa/lV5hQuAKactfz+Puun5UMArCt
         ngH2XkK1oic8g==
Date:   Mon, 11 Nov 2019 12:39:22 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        PowerPC <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20191111123922.540319a2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6QAr0o=pU5/YGTHjeWYMaeP";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/6QAr0o=pU5/YGTHjeWYMaeP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

In file included from ./arch/powerpc/include/generated/asm/local64.h:1,
                 from include/linux/u64_stats_sync.h:72,
                 from include/linux/cgroup-defs.h:20,
                 from include/linux/cgroup.h:28,
                 from include/linux/memcontrol.h:13,
                 from include/linux/swap.h:9,
                 from include/linux/suspend.h:5,
                 from arch/powerpc/kernel/asm-offsets.c:23:
include/linux/u64_stats_sync.h: In function 'u64_stats_read':
include/asm-generic/local64.h:30:37: warning: passing argument 1 of 'local_=
read' discards 'const' qualifier from pointer target type [-Wdiscarded-qual=
ifiers]
   30 | #define local64_read(l)  local_read(&(l)->a)
      |                                     ^~~~~~~
include/linux/u64_stats_sync.h:80:9: note: in expansion of macro 'local64_r=
ead'
   80 |  return local64_read(&p->v);
      |         ^~~~~~~~~~~~
In file included from include/asm-generic/local64.h:22,
                 from ./arch/powerpc/include/generated/asm/local64.h:1,
                 from include/linux/u64_stats_sync.h:72,
                 from include/linux/cgroup-defs.h:20,
                 from include/linux/cgroup.h:28,
                 from include/linux/memcontrol.h:13,
                 from include/linux/swap.h:9,
                 from include/linux/suspend.h:5,
                 from arch/powerpc/kernel/asm-offsets.c:23:
arch/powerpc/include/asm/local.h:20:44: note: expected 'local_t *' {aka 'st=
ruct <anonymous> *'} but argument is of type 'const local_t *' {aka 'const =
struct <anonymous> *'}
   20 | static __inline__ long local_read(local_t *l)
      |                                   ~~~~~~~~~^

Introduced by commit

  316580b69d0a ("u64_stats: provide u64_stats_t type")

Powerpc folks: is there some reason that local_read() cannot take a
const argument?

I have added this patch (which builds fine) for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 11 Nov 2019 12:32:24 +1100
Subject: [PATCH] powerpc: local_read() should take a const local_t argument

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/include/asm/local.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/local.h b/arch/powerpc/include/asm/lo=
cal.h
index fdd00939270b..bc4bd19b7fc2 100644
--- a/arch/powerpc/include/asm/local.h
+++ b/arch/powerpc/include/asm/local.h
@@ -17,7 +17,7 @@ typedef struct
=20
 #define LOCAL_INIT(i)	{ (i) }
=20
-static __inline__ long local_read(local_t *l)
+static __inline__ long local_read(const local_t *l)
 {
 	return READ_ONCE(l->v);
 }
--=20
2.23.0

--=20
Cheers,
Stephen Rothwell

--Sig_/6QAr0o=pU5/YGTHjeWYMaeP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3Iu8oACgkQAVBC80lX
0GxUrAf/eOFpcteYsF7eO+8QSB+grDoR0uBOiJ/e64gcbJxIz20N7h7isi2cqpeU
ldqfFFEW0oZlFWk4CknC/cBnW+fTu2NwZSguJTvYpXRpPcfaH1F0jJJey+EeQY0E
6z1ffv/8HemmfZeQqv99ZnBdZkO7Wy4RC33/l1ullGpc0TCHzuJDnA143Uj97VqV
aXiNHSPufe9/6a/mkh9idVoJxvyy0HpSxmB6xZi0m8S5btcyU13vt7yTVVWxBd0q
G/h4HdyqH7Z6/PRFqjkbT7G7pMvy/WGfGNUBvRLYEqsCQfBGuAj8lMUURetrqgKx
7vgQIpeRGNmNmuT7oTaEwQohj5//tw==
=WNa5
-----END PGP SIGNATURE-----

--Sig_/6QAr0o=pU5/YGTHjeWYMaeP--
