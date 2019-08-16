Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 089E38F924
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 04:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfHPClt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 22:41:49 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:47013 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbfHPCls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 22:41:48 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 468ndh6G7Xz9sNF;
        Fri, 16 Aug 2019 12:41:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1565923305;
        bh=PGta/xD1/egYgpO5T2Qp+49QWW5+LsXeaztt0jb76q0=;
        h=Date:From:To:Cc:Subject:From;
        b=scmB09uh8U3yDhc1BtrqCfGpfyfOreBDTtjbDZ/75ihvYPZn2LVD0q2kXAiSVWy34
         No29rM5kU8OSAGulfbSliThEfRD50oxg1hKLRizdhnxIg3hFNYGy8djT7BhysgWq8E
         OqmeUqTH4jR7Gc2w1ytgJphzbR0VHiptHUXc2qo8lV1Hc4qYjGS9gFg5d7e5S45Zty
         nIzw/XZrGQ4u1U82eA0vkT7W1yovx58Ai9NqzuD1W50MVSP8eekDvEoD8pGCFfKIU5
         4q6Z4D1C5lkkf/TgcG4PULbBn8+an/xom0Ns4FuMqNRnlZuhKs/5U5IcY5FCn9NBm+
         dy0cRmeb9B2hg==
Date:   Fri, 16 Aug 2019 12:41:43 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: linux-next: manual merge of the net-next tree with the kbuild tree
Message-ID: <20190816124143.2640218a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Zd7MluIwbM_IHIc8cymxDNP";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Zd7MluIwbM_IHIc8cymxDNP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  scripts/link-vmlinux.sh

between commit:

  e167191e4a8a ("kbuild: Parameterize kallsyms generation and correct repor=
ting")

from the kbuild tree and commits:

  341dfcf8d78e ("btf: expose BTF info through sysfs")
  7fd785685e22 ("btf: rename /sys/kernel/btf/kernel into /sys/kernel/btf/vm=
linux")

from the net-next tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
This is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc scripts/link-vmlinux.sh
index 2438a9faf3f1,c31193340108..000000000000
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@@ -56,11 -56,10 +56,11 @@@ modpost_link(
  }
 =20
  # Link of vmlinux
- # ${1} - optional extra .o files
- # ${2} - output file
+ # ${1} - output file
+ # ${@:2} - optional extra .o files
  vmlinux_link()
  {
 +	info LD ${2}
  	local lds=3D"${objtree}/${KBUILD_LDS}"
  	local objects
 =20
@@@ -139,18 -149,6 +150,18 @@@ kallsyms(
  	${CC} ${aflags} -c -o ${2} ${afile}
  }
 =20
 +# Perform one step in kallsyms generation, including temporary linking of
 +# vmlinux.
 +kallsyms_step()
 +{
 +	kallsymso_prev=3D${kallsymso}
 +	kallsymso=3D.tmp_kallsyms${1}.o
 +	kallsyms_vmlinux=3D.tmp_vmlinux${1}
 +
- 	vmlinux_link "${kallsymso_prev}" ${kallsyms_vmlinux}
++	vmlinux_link ${kallsyms_vmlinux} "${kallsymso_prev}" ${btf_vmlinux_bin_o}
 +	kallsyms ${kallsyms_vmlinux} ${kallsymso}
 +}
 +
  # Create map file with all symbols from ${1}
  # See mksymap for additional details
  mksysmap()
@@@ -228,8 -227,14 +240,15 @@@ ${MAKE} -f "${srctree}/scripts/Makefile
  info MODINFO modules.builtin.modinfo
  ${OBJCOPY} -j .modinfo -O binary vmlinux.o modules.builtin.modinfo
 =20
+ btf_vmlinux_bin_o=3D""
+ if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
+ 	if gen_btf .tmp_vmlinux.btf .btf.vmlinux.bin.o ; then
+ 		btf_vmlinux_bin_o=3D.btf.vmlinux.bin.o
+ 	fi
+ fi
+=20
  kallsymso=3D""
 +kallsymso_prev=3D""
  kallsyms_vmlinux=3D""
  if [ -n "${CONFIG_KALLSYMS}" ]; then
 =20
@@@ -268,11 -285,8 +287,7 @@@
  	fi
  fi
 =20
- vmlinux_link "${kallsymso}" vmlinux
-=20
- if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
- 	gen_btf vmlinux
- fi
 -info LD vmlinux
+ vmlinux_link vmlinux "${kallsymso}" "${btf_vmlinux_bin_o}"
 =20
  if [ -n "${CONFIG_BUILDTIME_EXTABLE_SORT}" ]; then
  	info SORTEX vmlinux

--Sig_/Zd7MluIwbM_IHIc8cymxDNP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1WF+cACgkQAVBC80lX
0GxOZQf/SjZXucnzSxfw2bXj5xs/ERqO8g0sKKXV4nAYt+VAzUFL1u/WsKYDh+rg
PCZ1H1m/BdkDkrZxPP5maLh/OV9BcMHORMs0VxU3I9F4aRQ8alu18vRNm+H1G7nB
Dg5YE0g3J1AMBEAGyGnpAvJtQQic6A8aPmi1xUe5hrCrzDArlPHDAy6uOK9zA/rM
mzAosG7bDMxK0LHSg6AVqYle6hCw+P6Rdcc2DXwaWFDIRRQhCrx460vXsgpGi0er
RQMDeblnFYrVkIAs9ae6yqcK7Qys+pb/L4SaynmVMONRoS4xbpUI4Sx10KcqaT65
gSgatcHUhGTCBzYjofr4gXQI3KcFnw==
=J0ue
-----END PGP SIGNATURE-----

--Sig_/Zd7MluIwbM_IHIc8cymxDNP--
