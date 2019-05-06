Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 056F414874
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 12:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfEFKnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 06:43:11 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35663 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbfEFKnK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 06:43:10 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44yK893Hckz9s9T;
        Mon,  6 May 2019 20:43:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1557139386;
        bh=2V9EGX6DxXuIksap/rhYTlaPn/s1mzX2hSQK2ZWioUA=;
        h=Date:From:To:Cc:Subject:From;
        b=dWh1g/Ga03d3380jlEqP4ePTagqhjLLg+FYgBC0vSJ3h8YEuPl1lwCwFa0pWQKI8t
         rzotfHF4szTlu2TOFdkpnE0iZQaw8Ci5WTR8T5hMAEtC/VxA416TbMduRS+T6fWjgR
         uph1zgK22fGmt7YwsPePq2VjQulI7NIGnnsZ8SRIkTqYYkyQJYUpqBdAuDwN2OP1Wr
         21wJFgb0oSD/2xp9Y3/KLsDd8bpRsYce/9jwSQq89ZbkwLP359H6IQUTs4IvpaLVO8
         xMm/PTKXdRRLWRwMq/EM5bBHv7QPBJb3hZxrawCuSHHgE6Ah4eVLPuMjPdYfywXYqU
         7b7ATCwAh2PuQ==
Date:   Mon, 6 May 2019 20:43:03 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: linux-next: manual merge of the akpm-current tree with the net-next
 tree
Message-ID: <20190506204303.0d0082d7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Z1y9ZGU8tFe9HrqI0FaWe.h"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Z1y9ZGU8tFe9HrqI0FaWe.h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm-current tree got a conflict in:

  lib/Makefile

between commit:

  554aae35007e ("lib: Add support for generic packing operations")

from the net-next tree and commit:

  1a1e7f563bd5 ("lib: Move mathematic helpers to separate folder")

from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc lib/Makefile
index 83d7df2661ff,4eeb814eee2e..000000000000
--- a/lib/Makefile
+++ b/lib/Makefile
@@@ -17,20 -17,9 +17,20 @@@ KCOV_INSTRUMENT_list_debug.o :=3D=20
  KCOV_INSTRUMENT_debugobjects.o :=3D n
  KCOV_INSTRUMENT_dynamic_debug.o :=3D n
 =20
 +# Early boot use of cmdline, don't instrument it
 +ifdef CONFIG_AMD_MEM_ENCRYPT
 +KASAN_SANITIZE_string.o :=3D n
 +
 +ifdef CONFIG_FUNCTION_TRACER
 +CFLAGS_REMOVE_string.o =3D -pg
 +endif
 +
 +CFLAGS_string.o :=3D $(call cc-option, -fno-stack-protector)
 +endif
 +
  lib-y :=3D ctype.o string.o vsprintf.o cmdline.o \
  	 rbtree.o radix-tree.o timerqueue.o xarray.o \
- 	 idr.o int_sqrt.o extable.o \
+ 	 idr.o extable.o \
  	 sha1.o chacha.o irq_regs.o argv_split.o \
  	 flex_proportions.o ratelimit.o show_mem.o \
  	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
@@@ -120,8 -110,6 +122,7 @@@ obj-$(CONFIG_DEBUG_LIST) +=3D list_debug.
  obj-$(CONFIG_DEBUG_OBJECTS) +=3D debugobjects.o
 =20
  obj-$(CONFIG_BITREVERSE) +=3D bitrev.o
 +obj-$(CONFIG_PACKING)	+=3D packing.o
- obj-$(CONFIG_RATIONAL)	+=3D rational.o
  obj-$(CONFIG_CRC_CCITT)	+=3D crc-ccitt.o
  obj-$(CONFIG_CRC16)	+=3D crc16.o
  obj-$(CONFIG_CRC_T10DIF)+=3D crc-t10dif.o

--Sig_/Z1y9ZGU8tFe9HrqI0FaWe.h
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzQD7cACgkQAVBC80lX
0GxyFQf+Oxeg/myCZnkE2ztvU4e7GB6Gm8qPNwB50TGAVjL4g1CRrdmE6stC1xLr
Vit2Qrx2qSojaECslnAv4DOf4kPsExXNrHkWCSzzwjfMPtCDFDTLcJulS7FB1xc9
At47Hzd5dNdi50RRYaZ/FhXw6lMIJ/Ubq6YIFZOQ9Ir9xHiIXg0C1kY1Zou7C1ql
8axPlPtYxcUeuFIfCiVQojGHdz0NfeZ6q7eQTY0lyY5lkJ9siHXi3KuU975nmj3S
yRWM+Q4Pb0RH8d4zSqOBwtMYShoMRJr0besO6yx6p22s6PTLx6fit2HqhysjrkIX
qYfeMoMBvxrZU6hREoeh8kwE8HpZ2A==
=Lwq0
-----END PGP SIGNATURE-----

--Sig_/Z1y9ZGU8tFe9HrqI0FaWe.h--
