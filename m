Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93493362074
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 15:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235252AbhDPNEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 09:04:21 -0400
Received: from conuserg-10.nifty.com ([210.131.2.77]:62731 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbhDPNEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 09:04:06 -0400
Received: from localhost.localdomain (133-32-232-101.west.xps.vectant.ne.jp [133.32.232.101]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id 13GD0vCC002141;
        Fri, 16 Apr 2021 22:00:57 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com 13GD0vCC002141
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1618578059;
        bh=Bj3vmQYuw6AVeyGMQICNThf6rcoOcN89RQenb/sBZqc=;
        h=From:To:Cc:Subject:Date:From;
        b=cohJ7HYOsMdZ1GxI+GPzxKdV6N29fjrZk2jG+NGNstD314tHgEbG1QBPeqxMrUsyr
         7++2XZI+7lWdwgeNa4be4MW81jDO6eWRJk3EhPU7BoQ2Q9u4UoAU1Na4K+ouH8aBwq
         r3bvf4X+WQ10oGdloNZbFLbtpcbX6iHUXuvbbfcH6til8Qc1zsKomaY8HoWwPcfR4o
         bDrOpsyGuwxcIwnHtNyaiZKvlc7CU1DMChm0gv/vpRVwRclMie2D0YSh3JvTEEg6rp
         muPa6be/33bZI1soC0khkf0soRvW3ohefQLjYRjiDLNIkcMn8UCpEPn6Z507ju6Ys7
         mMSBmrcjdC8Tw==
X-Nifty-SrcIP: [133.32.232.101]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-kbuild@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH v2] tools: do not include scripts/Kbuild.include
Date:   Fri, 16 Apr 2021 22:00:51 +0900
Message-Id: <20210416130051.239782-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit d9f4ff50d2aa ("kbuild: spilt cc-option and friends to
scripts/Makefile.compiler"), some kselftests fail to build.

The tools/ directory opted out Kbuild, and went in a different
direction. They copy any kind of files to the tools/ directory
in order to do whatever they want in their world.

tools/build/Build.include mimics scripts/Kbuild.include, but some
tool Makefiles included the Kbuild one to import a feature that is
missing in tools/build/Build.include:

 - Commit ec04aa3ae87b ("tools/thermal: tmon: use "-fstack-protector"
   only if supported") included scripts/Kbuild.include from
   tools/thermal/tmon/Makefile to import the cc-option macro.

 - Commit c2390f16fc5b ("selftests: kvm: fix for compilers that do
   not support -no-pie") included scripts/Kbuild.include from
   tools/testing/selftests/kvm/Makefile to import the try-run macro.

 - Commit 9cae4ace80ef ("selftests/bpf: do not ignore clang
   failures") included scripts/Kbuild.include from
   tools/testing/selftests/bpf/Makefile to import the .DELETE_ON_ERROR
   target.

 - Commit 0695f8bca93e ("selftests/powerpc: Handle Makefile for
   unrecognized option") included scripts/Kbuild.include from
   tools/testing/selftests/powerpc/pmu/ebb/Makefile to import the
   try-run macro.

Copy what they need into tools/build/Build.include, and make them
include it instead of scripts/Kbuild.include.

Link: https://lore.kernel.org/lkml/86dadf33-70f7-a5ac-cb8c-64966d2f45a1@linux.ibm.com/
Fixes: d9f4ff50d2aa ("kbuild: spilt cc-option and friends to scripts/Makefile.compiler")
Reported-by: Janosch Frank <frankja@linux.ibm.com>
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

Changes in v2:
  - copy macros to tools/build/BUild.include

 tools/build/Build.include                     | 24 +++++++++++++++++++
 tools/testing/selftests/bpf/Makefile          |  2 +-
 tools/testing/selftests/kvm/Makefile          |  2 +-
 .../selftests/powerpc/pmu/ebb/Makefile        |  2 +-
 tools/thermal/tmon/Makefile                   |  2 +-
 5 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/tools/build/Build.include b/tools/build/Build.include
index 585486e40995..2cf3b1bde86e 100644
--- a/tools/build/Build.include
+++ b/tools/build/Build.include
@@ -100,3 +100,27 @@ cxx_flags = -Wp,-MD,$(depfile) -Wp,-MT,$@ $(CXXFLAGS) -D"BUILD_STR(s)=\#s" $(CXX
 ## HOSTCC C flags
 
 host_c_flags = -Wp,-MD,$(depfile) -Wp,-MT,$@ $(KBUILD_HOSTCFLAGS) -D"BUILD_STR(s)=\#s" $(HOSTCFLAGS_$(basetarget).o) $(HOSTCFLAGS_$(obj))
+
+# output directory for tests below
+TMPOUT = .tmp_$$$$
+
+# try-run
+# Usage: option = $(call try-run, $(CC)...-o "$$TMP",option-ok,otherwise)
+# Exit code chooses option. "$$TMP" serves as a temporary file and is
+# automatically cleaned up.
+try-run = $(shell set -e;		\
+	TMP=$(TMPOUT)/tmp;		\
+	mkdir -p $(TMPOUT);		\
+	trap "rm -rf $(TMPOUT)" EXIT;	\
+	if ($(1)) >/dev/null 2>&1;	\
+	then echo "$(2)";		\
+	else echo "$(3)";		\
+	fi)
+
+# cc-option
+# Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
+cc-option = $(call try-run, \
+	$(CC) -Werror $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
+
+# delete partially updated (i.e. corrupted) files on error
+.DELETE_ON_ERROR:
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 044bfdcf5b74..17a5cdf48d37 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-include ../../../../scripts/Kbuild.include
+include ../../../build/Build.include
 include ../../../scripts/Makefile.arch
 include ../../../scripts/Makefile.include
 
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a6d61f451f88..5ef141f265bd 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-include ../../../../scripts/Kbuild.include
+include ../../../build/Build.include
 
 all:
 
diff --git a/tools/testing/selftests/powerpc/pmu/ebb/Makefile b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
index af3df79d8163..c5ecb4634094 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-include ../../../../../../scripts/Kbuild.include
+include ../../../../../build/Build.include
 
 noarg:
 	$(MAKE) -C ../../
diff --git a/tools/thermal/tmon/Makefile b/tools/thermal/tmon/Makefile
index 59e417ec3e13..9db867df7679 100644
--- a/tools/thermal/tmon/Makefile
+++ b/tools/thermal/tmon/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # We need this for the "cc-option" macro.
-include ../../../scripts/Kbuild.include
+include ../../build/Build.include
 
 VERSION = 1.0
 
-- 
2.27.0

