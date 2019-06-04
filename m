Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4CD34439
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 12:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfFDKQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 06:16:57 -0400
Received: from conuserg-08.nifty.com ([210.131.2.75]:41277 "EHLO
        conuserg-08.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbfFDKQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 06:16:57 -0400
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id x54AEC7L032511;
        Tue, 4 Jun 2019 19:14:27 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com x54AEC7L032511
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1559643268;
        bh=89f4NG7T3lIJUXbh+crgcBM9ot/TW/l/GBiNZdH3IcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7YyTeOIkyiLbhjHLtqXLb1VWv2GjQYy5cTgkr8C8U/cyucPCS5tXvbLRRzUzJ6TE
         ziZe0sTaCI7+AxfD4MJh54gQr0L1AJ9WvpLuV36i+x53I9JXcPBPn6xdvR2dHK9sML
         qN05UgT7qHP1pTja6UhXNVyhMW7EtydbRoefYU98Pxmufa5LHg6DmGwKMpHVw/LZeo
         NqkT9Opk4Tm0y8mmDzNavtG4fIOGm8Jcj2d55/G7CYHnGI/2KymFZgUTQCOWVome3q
         +O5FFmRsXenLxnlozqVJcD5GQPFx2xNzow+Ov8ya3wThpyW5MD5etP34fHH+iOnJbP
         iI8KUO3jj3lDg==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     linux-kbuild@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Michal Marek <michal.lkml@markovi.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Palmer Dabbelt <palmer@sifive.com>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH 15/15] kbuild: compile test UAPI headers to ensure they are self-contained
Date:   Tue,  4 Jun 2019 19:14:09 +0900
Message-Id: <20190604101409.2078-16-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604101409.2078-1-yamada.masahiro@socionext.com>
References: <20190604101409.2078-1-yamada.masahiro@socionext.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multiple people have suggested compile-testing UAPI headers to ensure
they can be really included from user-space. "make headers_check" is
obviously not enough to catch bugs, and we often leak references to
kernel-space definition to user-space.

The most recent patch I know is David Howells' work:

  https://patchwork.kernel.org/patch/10590203/

While I agree that we should do this, we must consider how it can be
integrated cleanly. That is why it has not been supported in the
mainline yet.

The idea that has been in my mind is to compile every UAPI header
so that it can be included without relying on any include order.

Please note usr/include/ is built with a completely different set of
compiler flags. The header search path is set to $(objtree)/usr/include
since UAPI headers should not include unexported headers.

We use -std=gnu89 for the kernel space since the kernel code highly
depends on GNU extensions. On the other hand, UAPI headers should be
written in somewhat strict C, so they are compiled with -std=c89. This
will catch C++ style comments, the keyword 'inline', etc. ('__inline__'
should be used instead).

There is additional compiler requirement for building under usr/include.
because many of UAPI headers include <stdlib.h>, <sys/ioctl.h>,
<sys/time.h>, etc. directly or indirectly.

You can use kernel.org prebuilt toolchains for building the kernel
(https://mirrors.edge.kernel.org/pub/tools/crosstool/index.html)
but they do not provide <stdlib.h> etc.

If you want to compile test UAPI headers, you need to use full-featured
compilers, which are usually provided by distributions.

I added scripts/cc-system-headers.sh to check if necessary system
headers are available, which CONFIG_UAPI_HEADER_TEST depends on.

For now, a lot of headers need to be excluded because they cannot
be compiled standalone, but this is a good start point.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 Makefile                     |   2 +-
 init/Kconfig                 |  11 +++
 scripts/cc-system-headers.sh |   8 +++
 usr/.gitignore               |   1 -
 usr/Makefile                 |   2 +
 usr/include/.gitignore       |   3 +
 usr/include/Makefile         | 132 +++++++++++++++++++++++++++++++++++
 7 files changed, 157 insertions(+), 2 deletions(-)
 create mode 100755 scripts/cc-system-headers.sh
 create mode 100644 usr/include/.gitignore
 create mode 100644 usr/include/Makefile

diff --git a/Makefile b/Makefile
index 48bac02fb72d..0d54b073c415 100644
--- a/Makefile
+++ b/Makefile
@@ -1363,7 +1363,7 @@ CLEAN_DIRS  += $(MODVERDIR) include/ksym
 CLEAN_FILES += modules.builtin.modinfo
 
 # Directories & files removed with 'make mrproper'
-MRPROPER_DIRS  += include/config usr/include include/generated          \
+MRPROPER_DIRS  += include/config include/generated          \
 		  arch/$(SRCARCH)/include/generated .tmp_objdiff
 MRPROPER_FILES += .config .config.old .version \
 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
diff --git a/init/Kconfig b/init/Kconfig
index 02d8897b91fb..9a26f0e7e3fb 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -105,6 +105,17 @@ config HEADER_TEST
 	  If you are a developer or tester and want to ensure the requested
 	  headers are self-contained, say Y here. Otherwise, choose N.
 
+config UAPI_HEADER_TEST
+	bool "Compile test UAPI headers"
+	depends on HEADER_TEST && HEADERS_INSTALL
+	depends on $(success,$(srctree)/scripts/cc-system-headers.sh $(CC))
+	help
+	  Compile test headers exported to user-space to ensure they are
+	  self-contained, i.e. compilable as standalone units.
+
+	  If you are a developer or tester and want to ensure the UAPI
+	  headers are self-contained, say Y here. Otherwise, choose N.
+
 config LOCALVERSION
 	string "Local version - append to kernel release"
 	help
diff --git a/scripts/cc-system-headers.sh b/scripts/cc-system-headers.sh
new file mode 100755
index 000000000000..1b3db369828c
--- /dev/null
+++ b/scripts/cc-system-headers.sh
@@ -0,0 +1,8 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0-only
+
+cat << "END" | $@ -E -x c - -o /dev/null >/dev/null 2>&1
+#include <stdlib.h>
+#include <sys/ioctl.h>
+#include <sys/time.h>
+END
diff --git a/usr/.gitignore b/usr/.gitignore
index 8e48117a3f3d..be5eae1df7eb 100644
--- a/usr/.gitignore
+++ b/usr/.gitignore
@@ -7,4 +7,3 @@ initramfs_data.cpio.gz
 initramfs_data.cpio.bz2
 initramfs_data.cpio.lzma
 initramfs_list
-include
diff --git a/usr/Makefile b/usr/Makefile
index 4a70ae43c9cb..6a89eb019275 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -56,3 +56,5 @@ $(deps_initramfs): klibcdirs
 $(obj)/$(datafile_y): $(obj)/gen_init_cpio $(deps_initramfs) klibcdirs
 	$(Q)$(initramfs) -l $(ramfs-input) > $(obj)/$(datafile_d_y)
 	$(call if_changed,initfs)
+
+subdir-$(CONFIG_UAPI_HEADER_TEST) += include
diff --git a/usr/include/.gitignore b/usr/include/.gitignore
new file mode 100644
index 000000000000..a0991ff4402b
--- /dev/null
+++ b/usr/include/.gitignore
@@ -0,0 +1,3 @@
+*
+!.gitignore
+!Makefile
diff --git a/usr/include/Makefile b/usr/include/Makefile
new file mode 100644
index 000000000000..8cba20ba4edb
--- /dev/null
+++ b/usr/include/Makefile
@@ -0,0 +1,132 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+# Unlike the kernel space, uapi headers are written in more strict C.
+#  - Forbid C++ style comments
+#  - Use '__inline', '__asm__' instead of 'inline', 'asm'
+#
+# -std=c90 (equivalent to -ansi) catches the violation of those.
+# We cannot go as far as adding -Wpedantic since it emits too many warnings.
+#
+# REVISIT: re-consider the proper set of compiler flags for uapi compile-test.
+
+UAPI_CFLAGS := -std=c90 -Wall -Werror=implicit-function-declaration
+
+override c_flags = $(UAPI_CFLAGS) -Wp,-MD,$(depfile) -I$(objtree)/usr/include
+
+# We want to compile as many headers as possible. We collect all headers
+# by using the wildcard, then filter-out some later.
+all-uapi-headers = $(shell cd $(obj) && find * -name '*.h')
+
+# asm-generic/*.h is used by asm/*.h, and should not be included directly
+no-header-test += asm-generic/%.h
+
+# The following are excluded for now just because they fail to build.
+# The cause of errors are mostly missing include directives.
+# Check one by one, and send a patch to each subsystem.
+#
+# Do not add a new header to the list without legitimate reason.
+# Please consider to fix the header first.
+no-header-test += asm/ipcbuf.h
+no-header-test += asm/msgbuf.h
+no-header-test += asm/sembuf.h
+no-header-test += asm/shmbuf.h
+no-header-test += asm/signal.h
+no-header-test += asm/ucontext.h
+no-header-test += drm/vmwgfx_drm.h
+no-header-test += linux/am437x-vpfe.h
+no-header-test += linux/android/binderfs.h
+no-header-test += linux/android/binder.h
+no-header-test += linux/coda.h
+no-header-test += linux/coda_psdev.h
+no-header-test += linux/dvb/audio.h
+no-header-test += linux/dvb/osd.h
+no-header-test += linux/elfcore.h
+no-header-test += linux/errqueue.h
+no-header-test += linux/fsmap.h
+no-header-test += linux/hdlc/ioctl.h
+no-header-test += linux/jffs2.h
+no-header-test += linux/kexec.h
+no-header-test += linux/matroxfb.h
+no-header-test += linux/netfilter_bridge/ebtables.h
+no-header-test += linux/netfilter_ipv4/ipt_LOG.h
+no-header-test += linux/netfilter_ipv6/ip6t_LOG.h
+no-header-test += linux/nfc.h
+no-header-test += linux/nilfs2_ondisk.h
+no-header-test += linux/omap3isp.h
+no-header-test += linux/omapfb.h
+no-header-test += linux/patchkey.h
+no-header-test += linux/phonet.h
+no-header-test += linux/reiserfs_xattr.h
+no-header-test += linux/scc.h
+no-header-test += linux/sctp.h
+no-header-test += linux/signal.h
+no-header-test += linux/sysctl.h
+no-header-test += linux/usb/audio.h
+no-header-test += linux/ivtv.h
+no-header-test += linux/v4l2-mediabus.h
+no-header-test += linux/v4l2-subdev.h
+no-header-test += linux/videodev2.h
+no-header-test += linux/vm_sockets.h
+no-header-test += misc/ocxl.h
+no-header-test += scsi/scsi_bsg_fc.h
+no-header-test += scsi/scsi_netlink_fc.h
+no-header-test += scsi/scsi_netlink.h
+no-header-test += sound/asequencer.h
+no-header-test += sound/asound.h
+no-header-test += sound/asoc.h
+no-header-test += sound/compress_offload.h
+no-header-test += sound/emu10k1.h
+no-header-test += sound/sfnt_info.h
+no-header-test += sound/sof/eq.h
+no-header-test += sound/sof/fw.h
+no-header-test += sound/sof/header.h
+no-header-test += sound/sof/manifest.h
+no-header-test += sound/sof/trace.h
+no-header-test += xen/evtchn.h
+no-header-test += xen/gntdev.h
+no-header-test += xen/privcmd.h
+
+# more headers are broken in some architectures
+
+ifeq ($(SRCARCH),arc)
+no-header-test += linux/bpf_perf_event.h
+endif
+
+ifeq ($(SRCARCH),ia64)
+no-header-test += asm/setup.h
+no-header-test += asm/sigcontext.h
+no-header-test += asm/perfmon.h
+no-header-test += asm/perfmon_default_smpl.h
+no-header-test += linux/if_bonding.h
+endif
+
+ifeq ($(SRCARCH),mips)
+no-header-test += asm/stat.h
+endif
+
+ifeq ($(SRCARCH),powerpc)
+no-header-test += asm/stat.h
+no-header-test += linux/bpf_perf_event.h
+endif
+
+ifeq ($(SRCARCH),riscv)
+no-header-test += linux/bpf_perf_event.h
+endif
+
+ifeq ($(SRCARCH),s390)
+no-header-test += asm/runtime_instr.h
+no-header-test += asm/zcrypt.h
+endif
+
+ifeq ($(SRCARCH),sparc)
+no-header-test += asm/stat.h
+no-header-test += asm/uctx.h
+no-header-test += asm/fbio.h
+no-header-test += asm/openpromio.h
+endif
+
+# Use '=' instead of ':=' to avoid $(shell ...) evaluation when cleaning
+header-test-y = $(filter-out $(no-header-test), $(all-uapi-headers))
+
+# Use '=' instead of ':=' to avoid $(shell ...) evaluation when building
+clean-dirs = $(shell cd $(obj) 2>/dev/null && find * -maxdepth 0 -type d)
-- 
2.17.1

