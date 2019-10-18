Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E077DBC4E
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407457AbfJRFAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:00:46 -0400
Received: from ozlabs.org ([203.11.71.1]:59595 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727627AbfJRFAq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 01:00:46 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46vVR047dMz9sP3;
        Fri, 18 Oct 2019 13:31:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1571365907;
        bh=STqXBQt1of/WFIT0GVfq42YrvZ3JDvNR2LFQ87IDERM=;
        h=Date:From:To:Cc:Subject:From;
        b=MS6cWvzglWlyRB1w1pnINex7OcQ3VsrD6+OCHaOiorDM2hqOFT+bs6SohJ5s1g4HP
         vW6Szz6i+lJL6exfdTptnjlKSFlCZDhRWs5mfxoRZY65p2NWSBbasLKAu6Dmgitx60
         oVtxsMEcCCZjlGZjq/+3wJ8gvP58kESCloqqyNATJlCdu76ilIkdgck8K2et+Evcld
         tEib04l9lohK/Vm4W3NKebRKq+zC2UgdjWZG0UeFJlCONTCPGpiBayAp0iCJyXbxtw
         VF361NIm2M4bTZFuxmC58w7cphh5VhbYm9ji9ITsLigVsrESCFuvlMeTzJ41WqaeMS
         vCpvnt4KZ+rUA==
Date:   Fri, 18 Oct 2019 13:31:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: linux-next: manual merge of the tip tree with the net-next tree
Message-ID: <20191018133139.30c88807@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Z+ofq0xCGo0+RR6uVsB2NLd";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Z+ofq0xCGo0+RR6uVsB2NLd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in:

  samples/bpf/Makefile

between commit:

  1d97c6c2511f ("samples/bpf: Base target programs rules on Makefile.target=
")

from the net-next tree and commit:

  fce9501aec6b ("samples/bpf: fix build by setting HAVE_ATTR_TEST to zero")

from the tip tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc samples/bpf/Makefile
index 4df11ddb9c75,42b571cde177..000000000000
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@@ -168,38 -171,21 +168,39 @@@ always +=3D ibumad_kern.
  always +=3D hbm_out_kern.o
  always +=3D hbm_edt_kern.o
 =20
 -KBUILD_HOSTCFLAGS +=3D -I$(objtree)/usr/include
 -KBUILD_HOSTCFLAGS +=3D -I$(srctree)/tools/lib/bpf/
 -KBUILD_HOSTCFLAGS +=3D -I$(srctree)/tools/testing/selftests/bpf/
 -KBUILD_HOSTCFLAGS +=3D -I$(srctree)/tools/lib/ -I$(srctree)/tools/include
 -KBUILD_HOSTCFLAGS +=3D -I$(srctree)/tools/perf
 -KBUILD_HOSTCFLAGS +=3D -DHAVE_ATTR_TEST=3D0
 +ifeq ($(ARCH), arm)
 +# Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
 +# headers when arm instruction set identification is requested.
 +ARM_ARCH_SELECTOR :=3D $(filter -D__LINUX_ARM_ARCH__%, $(KBUILD_CFLAGS))
 +BPF_EXTRA_CFLAGS :=3D $(ARM_ARCH_SELECTOR)
 +TPROGS_CFLAGS +=3D $(ARM_ARCH_SELECTOR)
 +endif
 +
 +TPROGS_CFLAGS +=3D -Wall -O2
 +TPROGS_CFLAGS +=3D -Wmissing-prototypes
 +TPROGS_CFLAGS +=3D -Wstrict-prototypes
 +
 +TPROGS_CFLAGS +=3D -I$(objtree)/usr/include
 +TPROGS_CFLAGS +=3D -I$(srctree)/tools/lib/bpf/
 +TPROGS_CFLAGS +=3D -I$(srctree)/tools/testing/selftests/bpf/
 +TPROGS_CFLAGS +=3D -I$(srctree)/tools/lib/
 +TPROGS_CFLAGS +=3D -I$(srctree)/tools/include
 +TPROGS_CFLAGS +=3D -I$(srctree)/tools/perf
++TPROGS_CFLAGS +=3D -DHAVE_ATTR_TEST=3D0
 =20
 -HOSTCFLAGS_bpf_load.o +=3D -I$(objtree)/usr/include -Wno-unused-variable
 +ifdef SYSROOT
 +TPROGS_CFLAGS +=3D --sysroot=3D$(SYSROOT)
 +TPROGS_LDFLAGS :=3D -L$(SYSROOT)/usr/lib
 +endif
 +
 +TPROGCFLAGS_bpf_load.o +=3D -Wno-unused-variable
 =20
 -KBUILD_HOSTLDLIBS		+=3D $(LIBBPF) -lelf
 -HOSTLDLIBS_tracex4		+=3D -lrt
 -HOSTLDLIBS_trace_output	+=3D -lrt
 -HOSTLDLIBS_map_perf_test	+=3D -lrt
 -HOSTLDLIBS_test_overhead	+=3D -lrt
 -HOSTLDLIBS_xdpsock		+=3D -pthread
 +TPROGS_LDLIBS			+=3D $(LIBBPF) -lelf
 +TPROGLDLIBS_tracex4		+=3D -lrt
 +TPROGLDLIBS_trace_output	+=3D -lrt
 +TPROGLDLIBS_map_perf_test	+=3D -lrt
 +TPROGLDLIBS_test_overhead	+=3D -lrt
 +TPROGLDLIBS_xdpsock		+=3D -pthread
 =20
  # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine =
on cmdline:
  #  make samples/bpf/ LLC=3D~/git/llvm/build/bin/llc CLANG=3D~/git/llvm/bu=
ild/bin/clang

--Sig_/Z+ofq0xCGo0+RR6uVsB2NLd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl2pJAsACgkQAVBC80lX
0GyqEwf/UuMAsHsveGo2AA1IPKiMbsDeaMyqQOSlVmR60dCwQFt/0FIiGRYvDOj1
Bj8APje30mHsjkB8soqEQ6wZAdDmzzrSIlI55bubZp2ogCBhoP4r+eDfYZJyLiCL
O3tzu/owv5qrURc6e1qHQch6LhT5So77T3UPpL8xEPoGMPOpMVHeaHwq4H+B9ldA
JpiMbPI+gRpaDghkt8ZwnPeetv6hChoeZVUKATArwuk5jJM4n+fIpnWratvgI+eZ
AVPrdPGXNfFqttwLvq/dgjSxwplSn+onU6XtmO7reAPN6NHjPC1F6KNQYOg6nEQQ
KJer+ciicgEiQ5jNLlr1fRuq0f8f4Q==
=1V2Z
-----END PGP SIGNATURE-----

--Sig_/Z+ofq0xCGo0+RR6uVsB2NLd--
