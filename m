Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1BDD5B296
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 03:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfGABB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 21:01:29 -0400
Received: from conuserg-12.nifty.com ([210.131.2.79]:62385 "EHLO
        conuserg-12.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGABB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 21:01:29 -0400
Received: from grover.flets-west.jp (softbank126125154139.bbtec.net [126.125.154.139]) (authenticated)
        by conuserg-12.nifty.com with ESMTP id x610x4ft000634;
        Mon, 1 Jul 2019 09:59:07 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-12.nifty.com x610x4ft000634
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1561942748;
        bh=MKeZdTTRfl86Y7P6MzXWSAuIsFqD3wq5RLZjRa1I1Lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ziU+h4rJWJvBru7ZdtTN3A5VNXFG3Pr048ghe0KATQ698wjk2Wpz6/MYAs4RIoTl6
         ZXHX62tCknYKHXGyyw4obJDCVa3hg97aj5/o1K9TAlaIxoZcpM/J7aJ6XgLG9U2eeK
         FBJ/VCvX3UyrMSrjBISljHjV29nWC20Kzd24DcAJ+jmSqHOYk6hmrtNRCG8cHPyYRL
         /j1kdEWCNn544fJdrVlL4pOib4nOeVcTWIakaIQ3ejmP0bf1alUm93sVrwLpzTkvgq
         UNXzuM3OCm5oqkHte62It2zBAnQBPqr4PuJbzuiC6w2k+t9EA+aEojhWXDewuQ4iTI
         84kvLpsw2RyZw==
X-Nifty-SrcIP: [126.125.154.139]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     linux-kbuild@vger.kernel.org
Cc:     Sam Ravnborg <sam@ravnborg.org>,
        Joel Fernandes <joel@joelfernandes.org>,
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
Subject: [PATCH 2/7] kbuild: compile-test exported headers to ensure they are self-contained
Date:   Mon,  1 Jul 2019 09:58:40 +0900
Message-Id: <20190701005845.12475-3-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190701005845.12475-1-yamada.masahiro@socionext.com>
References: <20190701005845.12475-1-yamada.masahiro@socionext.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multiple people have suggested compile-testing UAPI headers to ensure
they can be really included from user-space. "make headers_check" is
obviously not enough to catch bugs, and we often leak unresolved
references to user-space.

Use the new header-test-y syntax to implement it. Please note exported
headers are compile-tested with a completely different set of compiler
flags. The header search path is set to $(objtree)/usr/include since
exported headers should not include unexported ones.

We use -std=gnu89 for the kernel space since the kernel code highly
depends on GNU extensions. On the other hand, UAPI headers should be
written in more standardized C, so they are compiled with -std=c90.
This will emit errors if C++ style comments, the keyword 'inline', etc.
are used. Please use C style comments (/* ... */), '__inline__', etc.
in UAPI headers.

There is additional compiler requirement to enable this test because
many of UAPI headers include <stdlib.h>, <sys/ioctl.h>, <sys/time.h>,
etc. directly or indirectly. You cannot use kernel.org pre-built
toolchains [1] since they lack <stdlib.h>.

I reused CONFIG_CC_CAN_LINK to check the system header availability.
The intention is slightly different, but a compiler that can link
userspace programs provide system headers.

For now, a lot of headers need to be excluded because they cannot
be compiled standalone, but this is a good start point.

[1] https://mirrors.edge.kernel.org/pub/tools/crosstool/index.html

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
---

Changes in v4:
  - Sort the blacklist alphabetically
  - Add a little more comments
  - Remove scripts/cc-system-headers.sh and reuse CC_CAN_LINK

Changes in v3: None
Changes in v2:
 - Add CONFIG_CPU_{BIG,LITTLE}_ENDIAN guard to avoid build error
 - Use 'header-test-' instead of 'no-header-test'
 - Avoid weird 'find' warning when cleaning

 Makefile               |   2 +-
 init/Kconfig           |  10 ++++
 usr/.gitignore         |   1 -
 usr/Makefile           |   2 +
 usr/include/.gitignore |   3 +
 usr/include/Makefile   | 131 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 147 insertions(+), 2 deletions(-)
 create mode 100644 usr/include/.gitignore
 create mode 100644 usr/include/Makefile

diff --git a/Makefile b/Makefile
index 1f35aca4fe05..f23516980796 100644
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
index 2e9813daa2c1..74192de8ada6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -108,6 +108,16 @@ config HEADER_TEST
 	  If you are a developer or tester and want to ensure the requested
 	  headers are self-contained, say Y here. Otherwise, choose N.
 
+config UAPI_HEADER_TEST
+	bool "Compile test UAPI headers"
+	depends on HEADER_TEST && HEADERS_INSTALL && CC_CAN_LINK
+	help
+	  Compile test headers exported to user-space to ensure they are
+	  self-contained, i.e. compilable as standalone units.
+
+	  If you are a developer or tester and want to ensure the exported
+	  headers are self-contained, say Y here. Otherwise, choose N.
+
 config LOCALVERSION
 	string "Local version - append to kernel release"
 	help
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
index 000000000000..0f9f92c6016a
--- /dev/null
+++ b/usr/include/Makefile
@@ -0,0 +1,131 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+# Unlike the kernel space, exported headers are written in standard C.
+#  - Forbid C++ style comments
+#  - Use '__inline__', '__asm__' instead of 'inline', 'asm'
+#
+# -std=c90 (equivalent to -ansi) catches the violation of those.
+# We cannot go as far as adding -Wpedantic since it emits too many warnings.
+UAPI_CFLAGS := -std=c90 -Wall -Werror=implicit-function-declaration
+
+override c_flags = $(UAPI_CFLAGS) -Wp,-MD,$(depfile) -I$(objtree)/usr/include
+
+# The following are excluded for now because they fail to build.
+#
+# Do not add a new header to the blacklist without legitimate reason.
+# Please consider to fix the header first.
+#
+# Sorted alphabetically.
+header-test- += asm/ipcbuf.h
+header-test- += asm/msgbuf.h
+header-test- += asm/sembuf.h
+header-test- += asm/shmbuf.h
+header-test- += asm/signal.h
+header-test- += asm/ucontext.h
+header-test- += drm/vmwgfx_drm.h
+header-test- += linux/am437x-vpfe.h
+header-test- += linux/android/binder.h
+header-test- += linux/android/binderfs.h
+header-test-$(CONFIG_CPU_BIG_ENDIAN) += linux/byteorder/big_endian.h
+header-test-$(CONFIG_CPU_LITTLE_ENDIAN) += linux/byteorder/little_endian.h
+header-test- += linux/coda.h
+header-test- += linux/coda_psdev.h
+header-test- += linux/dvb/audio.h
+header-test- += linux/dvb/osd.h
+header-test- += linux/elfcore.h
+header-test- += linux/errqueue.h
+header-test- += linux/fsmap.h
+header-test- += linux/hdlc/ioctl.h
+header-test- += linux/ivtv.h
+header-test- += linux/jffs2.h
+header-test- += linux/kexec.h
+header-test- += linux/matroxfb.h
+header-test- += linux/netfilter_bridge/ebtables.h
+header-test- += linux/netfilter_ipv4/ipt_LOG.h
+header-test- += linux/netfilter_ipv6/ip6t_LOG.h
+header-test- += linux/nfc.h
+header-test- += linux/nilfs2_ondisk.h
+header-test- += linux/omap3isp.h
+header-test- += linux/omapfb.h
+header-test- += linux/patchkey.h
+header-test- += linux/phonet.h
+header-test- += linux/reiserfs_xattr.h
+header-test- += linux/scc.h
+header-test- += linux/sctp.h
+header-test- += linux/signal.h
+header-test- += linux/sysctl.h
+header-test- += linux/usb/audio.h
+header-test- += linux/v4l2-mediabus.h
+header-test- += linux/v4l2-subdev.h
+header-test- += linux/videodev2.h
+header-test- += linux/vm_sockets.h
+header-test- += misc/ocxl.h
+header-test- += mtd/mtd-abi.h
+header-test- += scsi/scsi_bsg_fc.h
+header-test- += scsi/scsi_netlink.h
+header-test- += scsi/scsi_netlink_fc.h
+header-test- += sound/asequencer.h
+header-test- += sound/asoc.h
+header-test- += sound/asound.h
+header-test- += sound/compress_offload.h
+header-test- += sound/emu10k1.h
+header-test- += sound/sfnt_info.h
+header-test- += sound/sof/eq.h
+header-test- += sound/sof/fw.h
+header-test- += sound/sof/header.h
+header-test- += sound/sof/manifest.h
+header-test- += sound/sof/trace.h
+header-test- += xen/evtchn.h
+header-test- += xen/gntdev.h
+header-test- += xen/privcmd.h
+
+# More headers are broken in some architectures
+
+ifeq ($(SRCARCH),arc)
+header-test- += linux/bpf_perf_event.h
+endif
+
+ifeq ($(SRCARCH),ia64)
+header-test- += asm/setup.h
+header-test- += asm/sigcontext.h
+header-test- += asm/perfmon.h
+header-test- += asm/perfmon_default_smpl.h
+header-test- += linux/if_bonding.h
+endif
+
+ifeq ($(SRCARCH),mips)
+header-test- += asm/stat.h
+endif
+
+ifeq ($(SRCARCH),powerpc)
+header-test- += asm/stat.h
+header-test- += linux/bpf_perf_event.h
+endif
+
+ifeq ($(SRCARCH),riscv)
+header-test- += linux/bpf_perf_event.h
+endif
+
+ifeq ($(SRCARCH),s390)
+header-test- += asm/runtime_instr.h
+header-test- += asm/zcrypt.h
+endif
+
+ifeq ($(SRCARCH),sparc)
+header-test- += asm/stat.h
+header-test- += asm/uctx.h
+header-test- += asm/fbio.h
+header-test- += asm/openpromio.h
+endif
+
+# asm-generic/*.h is used by asm/*.h, and should not be included directly
+header-test- += asm-generic/%
+
+# The rest are compile-tested
+header-test-y += $(filter-out $(header-test-), \
+			$(patsubst $(obj)/%,%, $(wildcard \
+			$(addprefix $(obj)/, *.h */*.h */*/*.h */*/*/*.h))))
+
+# For GNU Make <= 4.2.1, $(wildcard $(obj)/*/) matches to not only directories
+# but also regular files. Use $(filter %/, ...) just in case.
+clean-dirs += $(patsubst $(obj)/%/,%,$(filter %/, $(wildcard $(obj)/*/)))
-- 
2.17.1

