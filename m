Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB0E3FD3E0
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 08:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242255AbhIAGjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 02:39:24 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:44667 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231501AbhIAGjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 02:39:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1630478305;
        bh=+P+jRAAoHJInhbNG/oriIYBjdXcWSMHExv29E1M8JbM=;
        h=Date:From:To:Cc:Subject:From;
        b=so2jUWO366M+SYsYAI/+T49i8RtNG/CQD6qHtUcqP+lLn/kfZ8omEQRL2xNzLvY5n
         pLVCd4djNA4Jh1rOLg7i2F/pj+Lkg+10QswjxWaB4kZjohbHIlSQ+TOBmwXzPLsTFD
         XWPwvbeddQ8DPK2IMXA/lxVuuxvG1fDzAhUj5fC8hkqT/D4C6sba5drbTi7L8JkDUb
         F8zkz8ZzKU6wdIQCZkzAwEoNBCwd8DjWuCACCqWCJJ+zhqEJOtpp6mtHgBZ4CI4SqI
         nB/YhWhj4AS7t5oghlknaOjZ/lVTKU3ZFgfEptO893FvMaF5TnthAChIlYFFd1WuJl
         NQwkZZJZPtiTg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GzvX06Bwxz9sXk;
        Wed,  1 Sep 2021 16:38:24 +1000 (AEST)
Date:   Wed, 1 Sep 2021 16:38:22 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Maurizio Lombardi <mlombard@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20210901163822.65beb208@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/41EVaJjowJ1ijmM/dv3QE1G";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/41EVaJjowJ1ijmM/dv3QE1G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (X86_64
allnoconfig) failed like this:

arch/x86/kernel/setup.c: In function 'setup_arch':
arch/x86/kernel/setup.c:916:6: error: implicit declaration of function 'acp=
i_mps_check' [-Werror=3Dimplicit-function-declaration]
  916 |  if (acpi_mps_check()) {
      |      ^~~~~~~~~~~~~~
arch/x86/kernel/setup.c:1110:2: error: implicit declaration of function 'ac=
pi_table_upgrade' [-Werror=3Dimplicit-function-declaration]
 1110 |  acpi_table_upgrade();
      |  ^~~~~~~~~~~~~~~~~~
arch/x86/kernel/setup.c:1112:2: error: implicit declaration of function 'ac=
pi_boot_table_init' [-Werror=3Dimplicit-function-declaration]
 1112 |  acpi_boot_table_init();
      |  ^~~~~~~~~~~~~~~~~~~~
arch/x86/kernel/setup.c:1120:2: error: implicit declaration of function 'ea=
rly_acpi_boot_init'; did you mean 'early_cpu_init'? [-Werror=3Dimplicit-fun=
ction-declaration]
 1120 |  early_acpi_boot_init();
      |  ^~~~~~~~~~~~~~~~~~~~
      |  early_cpu_init
arch/x86/kernel/setup.c:1162:2: error: implicit declaration of function 'ac=
pi_boot_init' [-Werror=3Dimplicit-function-declaration]
 1162 |  acpi_boot_init();
      |  ^~~~~~~~~~~~~~

Caused by commit

  342f43af70db ("iscsi_ibft: fix crash due to KASLR physical memory remappi=
ng")

Unfortunately that commit has now been merged into Linus' tree as well.

I have added the following fix patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 1 Sep 2021 16:31:32 +1000
Subject: [PATCH] x86: include acpi.h when using acpi functions

The removal of the include of linux/acpi.h from include/linux/iscsi_ibft.h
by commit

  342f43af70db ("iscsi_ibft: fix crash due to KASLR physical memory remappi=
ng")

exposed this build failure.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/kernel/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 63b20536c8d2..da0a4b64880f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -13,6 +13,7 @@
 #include <linux/init_ohci1394_dma.h>
 #include <linux/initrd.h>
 #include <linux/iscsi_ibft.h>
+#include <linux/acpi.h>
 #include <linux/memblock.h>
 #include <linux/panic_notifier.h>
 #include <linux/pci.h>
--=20
2.32.0

--=20
Cheers,
Stephen Rothwell

--Sig_/41EVaJjowJ1ijmM/dv3QE1G
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEvH94ACgkQAVBC80lX
0GxOQwf/T8m8+Tqc33+IK3OjriQHCNRR+al8xPZWweHJfTouB/OJyV21zPck4uxn
D4FaDhDFVIgGXAaf22euc4zH/IbEetBszV8WoXH04hexQMxiTV/oiE6ZAEPMZiyw
baiwKYD03KN5XcD+rFG2rOMRbQiAi28sXLEUQiGClrqk9s+owixf6Qup01+EDofv
19Qt6JCOAprU6SBOHpDOHT6L022dWytGtXd8je195cL56JZVephSlZDXmUBI5zrd
hkC4HtW7OT7AwKlWgAQmj7Kx8zm2b9DMd+eNUMGJ8JJ4o4xPg2nRc9YY3z3JhFnT
1j7XgmsPaawcMu9lbieWxKmX8dVqTw==
=jFds
-----END PGP SIGNATURE-----

--Sig_/41EVaJjowJ1ijmM/dv3QE1G--
