Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E0637B65B
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 08:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhELGyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 02:54:10 -0400
Received: from conuserg-10.nifty.com ([210.131.2.77]:19436 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhELGyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 02:54:07 -0400
Received: from grover.RMN.KIBA.LAB.jp (133-32-232-101.west.xps.vectant.ne.jp [133.32.232.101]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id 14C6q4oR028643;
        Wed, 12 May 2021 15:52:05 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com 14C6q4oR028643
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1620802326;
        bh=tGCmhtBz8IEEwu83dXllP0bNtsLvnPdEOYpyEWEPOmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8vIXl+60SVnvIQU+xvxvU1m7mWDeIM9aCnTy8VllplyFJqYAhx/RqL67GCuIm+EQ
         KzPAt/GY/ZiKCuAFnYqWcL9/7QPREzldZp+/oifcxsbAd2gsGN57AOl3qiEcRYtfZU
         nWR5Q2aXsb/QaFc2RCfJBMLT9wf2V/udmxUaY1XCqMXkrzIedCaPW8nDxTspvysf19
         NpnklKEdmt2ySFJmUXFwECNO4NWs89af190dqS3Kt43cDmdnuAQsP2Q+3R9IBiiXCk
         SSdPYryUQ69+F17dzdZpbEsn1gzQ0GUUL/4UKBNxutY9Rz/5RYqAExX25M4WciBTXi
         1J6Kx13WNN18Q==
X-Nifty-SrcIP: [133.32.232.101]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-kbuild@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 2/2] kbuild: remove libelf checks from top Makefile
Date:   Wed, 12 May 2021 15:52:01 +0900
Message-Id: <20210512065201.35268-2-masahiroy@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210512065201.35268-1-masahiroy@kernel.org>
References: <20210512065201.35268-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I do not see a good reason why only the libelf development package must
be so carefully checked.

Kbuild generally does not check host tools or libraries.

For example, x86_64 defconfig fails to build with no libssl development
package installed.

scripts/extract-cert.c:21:10: fatal error: openssl/bio.h: No such file or directory
   21 | #include <openssl/bio.h>
      |          ^~~~~~~~~~~~~~~

To solve the build error, you need to install libssl-dev or openssl-devel
package, depending on your distribution.

'apt-file search', 'dnf provides', etc. is your frined to find a proper
package to install.

This commit removes all the libelf checks from the top Makefile.

If libelf is missing, objtool will fail to build in a similar pattern:

.../linux/tools/objtool/include/objtool/elf.h:10:10: fatal error: gelf.h: No such file or directory
   10 | #include <gelf.h>

You need to install libelf-dev, libelf-devel, or elfutils-libelf-devel
to proceed.

Another remarkable change is, CONFIG_STACK_VALIDATION (without
CONFIG_UNWINDER_ORC) previously continued to build with a warning,
but now it will treat missing libelf as an error.

This is just a one-time installation, so it should not matter to break
a build and make a user install the package.

BTW, the traditional way to handle such checks is autotool, but according
to [1], I do not expect the kernel build would have similar scripting
like './configure' does.

[1]: https://lore.kernel.org/lkml/CA+55aFzr2HTZVOuzpHYDwmtRJLsVzE-yqg2DHpHi_9ePsYp5ug@mail.gmail.com/

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 Makefile                  | 78 +++++++++++----------------------------
 scripts/Makefile.build    |  2 -
 scripts/Makefile.modfinal |  2 -
 3 files changed, 22 insertions(+), 60 deletions(-)

diff --git a/Makefile b/Makefile
index d60dc028f09c..bfbb7c8cbb0f 100644
--- a/Makefile
+++ b/Makefile
@@ -1081,41 +1081,6 @@ export INSTALL_DTBS_PATH ?= $(INSTALL_PATH)/dtbs/$(KERNELRELEASE)
 MODLIB	= $(INSTALL_MOD_PATH)/lib/modules/$(KERNELRELEASE)
 export MODLIB
 
-HOST_LIBELF_LIBS = $(shell pkg-config libelf --libs 2>/dev/null || echo -lelf)
-
-has_libelf = $(call try-run,\
-               echo "int main() {}" | $(HOSTCC) $(KBUILD_HOSTLDFLAGS) -xc -o /dev/null $(HOST_LIBELF_LIBS) -,1,0)
-
-ifdef CONFIG_STACK_VALIDATION
-  ifeq ($(has_libelf),1)
-    objtool_target := tools/objtool FORCE
-  else
-    SKIP_STACK_VALIDATION := 1
-    export SKIP_STACK_VALIDATION
-  endif
-endif
-
-PHONY += resolve_btfids_clean
-
-resolve_btfids_O = $(abspath $(objtree))/tools/bpf/resolve_btfids
-
-# tools/bpf/resolve_btfids directory might not exist
-# in output directory, skip its clean in that case
-resolve_btfids_clean:
-ifneq ($(wildcard $(resolve_btfids_O)),)
-	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(resolve_btfids_O) clean
-endif
-
-ifdef CONFIG_BPF
-ifdef CONFIG_DEBUG_INFO_BTF
-  ifeq ($(has_libelf),1)
-    resolve_btfids_target := tools/bpf/resolve_btfids FORCE
-  else
-    ERROR_RESOLVE_BTFIDS := 1
-  endif
-endif # CONFIG_DEBUG_INFO_BTF
-endif # CONFIG_BPF
-
 PHONY += prepare0
 
 export extmod_prefix = $(if $(KBUILD_EXTMOD),$(KBUILD_EXTMOD)/)
@@ -1227,7 +1192,7 @@ prepare0: archprepare
 	$(Q)$(MAKE) $(build)=.
 
 # All the preparing..
-prepare: prepare0 prepare-objtool prepare-resolve_btfids
+prepare: prepare0
 
 PHONY += remove-stale-files
 remove-stale-files:
@@ -1244,26 +1209,6 @@ uapi-asm-generic:
 	$(Q)$(MAKE) $(asm-generic)=arch/$(SRCARCH)/include/generated/uapi/asm \
 	generic=include/uapi/asm-generic
 
-PHONY += prepare-objtool prepare-resolve_btfids
-prepare-objtool: $(objtool_target)
-ifeq ($(SKIP_STACK_VALIDATION),1)
-ifdef CONFIG_FTRACE_MCOUNT_USE_OBJTOOL
-	@echo "error: Cannot generate __mcount_loc for CONFIG_DYNAMIC_FTRACE=y, please install libelf-dev, libelf-devel or elfutils-libelf-devel" >&2
-	@false
-endif
-ifdef CONFIG_UNWINDER_ORC
-	@echo "error: Cannot generate ORC metadata for CONFIG_UNWINDER_ORC=y, please install libelf-dev, libelf-devel or elfutils-libelf-devel" >&2
-	@false
-else
-	@echo "warning: Cannot use CONFIG_STACK_VALIDATION=y, please install libelf-dev, libelf-devel or elfutils-libelf-devel" >&2
-endif
-endif
-
-prepare-resolve_btfids: $(resolve_btfids_target)
-ifeq ($(ERROR_RESOLVE_BTFIDS),1)
-	@echo "error: Cannot resolve BTF IDs for CONFIG_DEBUG_INFO_BTF, please install libelf-dev, libelf-devel or elfutils-libelf-devel" >&2
-	@false
-endif
 # Generate some files
 # ---------------------------------------------------------------------------
 
@@ -1354,6 +1299,27 @@ scripts_unifdef: scripts_basic
 # ---------------------------------------------------------------------------
 # Tools
 
+ifdef CONFIG_STACK_VALIDATION
+prepare: tools/objtool
+endif
+
+ifdef CONFIG_BPF
+ifdef CONFIG_DEBUG_INFO_BTF
+prepare: tools/bpf/resolve_btfids
+endif
+endif
+
+PHONY += resolve_btfids_clean
+
+resolve_btfids_O = $(abspath $(objtree))/tools/bpf/resolve_btfids
+
+# tools/bpf/resolve_btfids directory might not exist
+# in output directory, skip its clean in that case
+resolve_btfids_clean:
+ifneq ($(wildcard $(resolve_btfids_O)),)
+	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(resolve_btfids_O) clean
+endif
+
 # Clear a bunch of variables before executing the submake
 ifeq ($(quiet),silent_)
 tools_silent=s
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 949f723efe53..7adc3a2c3c31 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -219,7 +219,6 @@ endif # CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT
 
 ifdef CONFIG_STACK_VALIDATION
 ifndef CONFIG_LTO_CLANG
-ifneq ($(SKIP_STACK_VALIDATION),1)
 
 __objtool_obj := $(objtree)/tools/objtool/objtool
 
@@ -233,7 +232,6 @@ objtool_obj = $(if $(patsubst y%,, \
 	$(OBJECT_FILES_NON_STANDARD_$(basetarget).o)$(OBJECT_FILES_NON_STANDARD)n), \
 	$(__objtool_obj))
 
-endif # SKIP_STACK_VALIDATION
 endif # CONFIG_LTO_CLANG
 endif # CONFIG_STACK_VALIDATION
 
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index dd87cea9fba7..bdee3babc5cf 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -39,12 +39,10 @@ prelink-ext := .lto
 # so let's now process the prelinked binary before we link the module.
 
 ifdef CONFIG_STACK_VALIDATION
-ifneq ($(SKIP_STACK_VALIDATION),1)
 cmd_ld_ko_o +=								\
 	$(objtree)/tools/objtool/objtool $(objtool_args)		\
 		$(@:.ko=$(prelink-ext).o);
 
-endif # SKIP_STACK_VALIDATION
 endif # CONFIG_STACK_VALIDATION
 
 endif # CONFIG_LTO_CLANG
-- 
2.27.0

