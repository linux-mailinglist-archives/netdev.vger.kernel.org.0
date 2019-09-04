Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64D3EA7B0F
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 08:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfIDGA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 02:00:27 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:51589 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfIDGA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 02:00:27 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46NY865qKBz9sDB;
        Wed,  4 Sep 2019 16:00:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1567576823;
        bh=t+9dnYK3oBolgwlJFR6x9mvuGOLTEaj/jY1jCsV0Omc=;
        h=Date:From:To:Cc:Subject:From;
        b=i4mPsmhnilHZQhKCHvaWM8onzDYZGbkgTOA7cYhTvR/wl6HajTlTtowWsYs+ERb9Y
         WC9sSw9+GsVeLfr/5sWVYps5kMw6X6SKlcwk8O9ANYntyHTs7fzb+0UMaWrutiqO3c
         L11+ioaYkOLvm5574/OOHn34J8PleGA9x8V4qlZeCemsRtOhZYqTu096wHhq4sskBo
         g0KLTwvV6NnK4xzsj7ujxK8k/G36FL+M95cLF61wRJr3QSQ8NvPOs2O0zgXWUu1UVC
         m0E57PDA+PyTUqSWXzfdG+h0N1WbhqK/ypfkyl+m+VIBSdHirhRVs5nWxi+16TP/li
         QxLIqApXDbl1w==
Date:   Wed, 4 Sep 2019 16:00:21 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20190904160021.72d104f1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/QTWFWPom_661+i5lo5rk3WG";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/QTWFWPom_661+i5lo5rk3WG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

scripts/link-vmlinux.sh: 74: Bad substitution

Caused by commit

  341dfcf8d78e ("btf: expose BTF info through sysfs")

interacting with commit

  1267f9d3047d ("kbuild: add $(BASH) to run scripts with bash-extension")

from the kbuild tree.

The change in the net-next tree turned link-vmlinux.sh into a bash script
(I think).

I have applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 4 Sep 2019 15:43:41 +1000
Subject: [PATCH] link-vmlinux.sh is now a bash script

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 Makefile                | 4 ++--
 scripts/link-vmlinux.sh | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index ac97fb282d99..523d12c5cebe 100644
--- a/Makefile
+++ b/Makefile
@@ -1087,7 +1087,7 @@ ARCH_POSTLINK :=3D $(wildcard $(srctree)/arch/$(SRCAR=
CH)/Makefile.postlink)
=20
 # Final link of vmlinux with optional arch pass after final link
 cmd_link-vmlinux =3D                                                 \
-	$(CONFIG_SHELL) $< $(LD) $(KBUILD_LDFLAGS) $(LDFLAGS_vmlinux) ;    \
+	$(BASH) $< $(LD) $(KBUILD_LDFLAGS) $(LDFLAGS_vmlinux) ;    \
 	$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)
=20
 vmlinux: scripts/link-vmlinux.sh autoksyms_recursive $(vmlinux-deps) FORCE
@@ -1403,7 +1403,7 @@ clean: rm-files :=3D $(CLEAN_FILES)
 PHONY +=3D archclean vmlinuxclean
=20
 vmlinuxclean:
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
+	$(Q)$(BASH) $(srctree)/scripts/link-vmlinux.sh clean
 	$(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
=20
 clean: archclean vmlinuxclean
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index f7edb75f9806..ea1f8673869d 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 #
 # link vmlinux
--=20
2.23.0.rc1

--=20
Cheers,
Stephen Rothwell

--Sig_/QTWFWPom_661+i5lo5rk3WG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1vUvUACgkQAVBC80lX
0GzjyQgAnQfiteckT1XZtpBJIHgCriDzDQqrEz05XEKBmPDc5xi3w76wOh/VzzHB
mNvEKEeOfAfGrPFKyfcJuF+MgdZPqgAv/JXm+kWrR11cQjcFJrERgYeTM6woyt9J
qkwSAZ6v8jcH/iFgSbiAawXdCE3zJxR7lMNMn8QZ3IWZgswNQK2yvEleFAZEVnF5
KZUymnHzjI+MRWVR0y1TtoOLj+OzX8fTgdvthbiYfPhSXNKnLQYcbGbY7Kc+1o76
JkjOb53KVzlI33Vl/Tl7PC0R8T0AGZFWNSmt8eu38OgrlQGsPumKNnA1CarQSvGX
6GGiG0Gzdjm0eH4XDxGRguDc+UrlvQ==
=Qlyc
-----END PGP SIGNATURE-----

--Sig_/QTWFWPom_661+i5lo5rk3WG--
