Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74AA1D038E
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 00:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbfJHWrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 18:47:52 -0400
Received: from ozlabs.org ([203.11.71.1]:55219 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbfJHWrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 18:47:52 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46nsts4Svfz9sNF;
        Wed,  9 Oct 2019 09:47:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1570574869;
        bh=58EmBSGcoGia31LuOrfaEVGmSNsD/e2sGciTU2VFkDA=;
        h=Date:From:To:Cc:Subject:From;
        b=dD1VR9/Bg/2hMvDwqcR8nwE0N63bOw0hkYDd1fVcOetc3i61KMp/hizsyeQchNJ1K
         e1Pf5sQ+9TpeIWccyM/pJdyZk0lV1M4yEJYn2HnUv/0tr9wZ5dcXAKuH71d9cKmeoC
         xNQ0UOzwnYmeAY9ZqyZUTVjlAWLXtvIKNFYVGMQVoa/9AKPspHS02SCyBmjlzTmWlW
         t7htkvDFeyiqz6gD53Ec0g3R4kqc9I6sE+Dz8HcBrfooXfJUaOUZQVQvgJm5bPLUlU
         oEL0KMdSLyalYSn+H7flx7RxW4CqhmteXGivRCAG1EbVnBminhz4cYcSUM/Ii1T+q/
         vnnxN5Bmu18yQ==
Date:   Wed, 9 Oct 2019 09:47:25 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>
Subject: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <20191009094725.71c2b1fa@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/PwLdWIvkuCoqB70WcW+lQ1Z";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/PwLdWIvkuCoqB70WcW+lQ1Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  tools/lib/bpf/Makefile

between commit:

  1bd63524593b ("libbpf: handle symbol versioning properly for libbpf.a")

from the bpf tree and commit:

  e01a75c15969 ("libbpf: Move bpf_{helpers, helper_defs, endian, tracing}.h=
 into libbpf")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc tools/lib/bpf/Makefile
index 56ce6292071b,1270955e4845..000000000000
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@@ -143,7 -133,9 +143,9 @@@ LIB_TARGET	:=3D $(addprefix $(OUTPUT),$(L
  LIB_FILE	:=3D $(addprefix $(OUTPUT),$(LIB_FILE))
  PC_FILE		:=3D $(addprefix $(OUTPUT),$(PC_FILE))
 =20
+ TAGS_PROG :=3D $(if $(shell which etags 2>/dev/null),etags,ctags)
+=20
 -GLOBAL_SYM_COUNT =3D $(shell readelf -s --wide $(BPF_IN) | \
 +GLOBAL_SYM_COUNT =3D $(shell readelf -s --wide $(BPF_IN_SHARED) | \
  			   cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | \
  			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}' | \
  			   sort -u | wc -l)
@@@ -165,7 -157,7 +167,7 @@@ all: fixde
 =20
  all_cmd: $(CMD_TARGETS) check
 =20
- $(BPF_IN_SHARED): force elfdep bpfdep
 -$(BPF_IN): force elfdep bpfdep bpf_helper_defs.h
++$(BPF_IN_SHARED): force elfdep bpfdep bpf_helper_defs.h
  	@(test -f ../../include/uapi/linux/bpf.h -a -f ../../../include/uapi/lin=
ux/bpf.h && ( \
  	(diff -B ../../include/uapi/linux/bpf.h ../../../include/uapi/linux/bpf.=
h >/dev/null) || \
  	echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' dif=
fers from latest version at 'include/uapi/linux/bpf.h'" >&2 )) || true
@@@ -181,14 -173,15 +183,18 @@@
  	@(test -f ../../include/uapi/linux/if_xdp.h -a -f ../../../include/uapi/=
linux/if_xdp.h && ( \
  	(diff -B ../../include/uapi/linux/if_xdp.h ../../../include/uapi/linux/i=
f_xdp.h >/dev/null) || \
  	echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/if_xdp.h' =
differs from latest version at 'include/uapi/linux/if_xdp.h'" >&2 )) || true
 -	$(Q)$(MAKE) $(build)=3Dlibbpf
 +	$(Q)$(MAKE) $(build)=3Dlibbpf OUTPUT=3D$(SHARED_OBJDIR) CFLAGS=3D"$(CFLA=
GS) $(SHLIB_FLAGS)"
 +
 +$(BPF_IN_STATIC): force elfdep bpfdep
 +	$(Q)$(MAKE) $(build)=3Dlibbpf OUTPUT=3D$(STATIC_OBJDIR)
 =20
+ bpf_helper_defs.h: $(srctree)/include/uapi/linux/bpf.h
+ 	$(Q)$(srctree)/scripts/bpf_helpers_doc.py --header 		\
+ 		--file $(srctree)/include/uapi/linux/bpf.h > bpf_helper_defs.h
+=20
  $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
 =20
 -$(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN)
 +$(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN_SHARED)
  	$(QUIET_LINK)$(CC) --shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION=
) \
  				    -Wl,--version-script=3D$(VERSION_SCRIPT) $^ -lelf -o $@
  	@ln -sf $(@F) $(OUTPUT)libbpf.so
@@@ -268,9 -266,9 +279,10 @@@ config-clean
  	$(Q)$(MAKE) -C $(srctree)/tools/build/feature/ clean >/dev/null
 =20
  clean:
 -	$(call QUIET_CLEAN, libbpf) $(RM) $(TARGETS) $(CXX_TEST_TARGET) \
 +	$(call QUIET_CLEAN, libbpf) $(RM) -rf $(TARGETS) $(CXX_TEST_TARGET) \
  		*.o *~ *.a *.so *.so.$(LIBBPF_MAJOR_VERSION) .*.d .*.cmd \
- 		*.pc LIBBPF-CFLAGS $(SHARED_OBJDIR) $(STATIC_OBJDIR)
 -		*.pc LIBBPF-CFLAGS bpf_helper_defs.h
++		*.pc LIBBPF-CFLAGS $(SHARED_OBJDIR) $(STATIC_OBJDIR) \
++		bpf_helper_defs.h
  	$(call QUIET_CLEAN, core-gen) $(RM) $(OUTPUT)FEATURE-DUMP.libbpf
 =20
 =20

--Sig_/PwLdWIvkuCoqB70WcW+lQ1Z
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl2dEf0ACgkQAVBC80lX
0GzSBgf+LawTSFFrSqqYVEVmDNdmrP0yfviEcCtu7DiGvsfjg2bKUV9K55FV29ai
4EqPfnbv7iuy28BWLPN7ArZdv1VtiGG0KHtVjavAOd+AtUShiHPXlY9dbmQILHCE
KlkYUiHo8UmN8lSSwGYaXJUlYfGMMW/AgrvfEs/jXpVFu2QAxfB0Dhn8B8a3uLXz
bAkl4cVpDyg2MgCSY8xUgzMaLXXymLU7vzoPxFQzzTgS44WPHFYURIQ5Bpu1Zf0u
0peARfGq+AcEQoKPLjKmDJb5z2BgNEpLYg1Ik7lV4f0SbWWes8Npm5Goj/Qeu+oP
7d6Vlf6p5yu0vhQv9jmyiEMbxLfAvQ==
=txUt
-----END PGP SIGNATURE-----

--Sig_/PwLdWIvkuCoqB70WcW+lQ1Z--
