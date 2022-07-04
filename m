Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4D2565919
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 16:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbiGDO41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 10:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbiGDOz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 10:55:59 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFFACEE3F;
        Mon,  4 Jul 2022 07:55:57 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99143150C;
        Mon,  4 Jul 2022 07:55:57 -0700 (PDT)
Received: from e124483.cambridge.arm.com (e124483.cambridge.arm.com [10.1.29.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2F8D63F792;
        Mon,  4 Jul 2022 07:55:53 -0700 (PDT)
From:   Andrew Kilroy <andrew.kilroy@arm.com>
To:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org
Cc:     Andrew Kilroy <andrew.kilroy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Tom Rix <trix@redhat.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH 5/8] perf libunwind: Feature check for libunwind ptrauth callback
Date:   Mon,  4 Jul 2022 15:53:29 +0100
Message-Id: <20220704145333.22557-6-andrew.kilroy@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220704145333.22557-1-andrew.kilroy@arm.com>
References: <20220704145333.22557-1-andrew.kilroy@arm.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch prepares for a version of libunwind that is capable of
unwinding stacks with pointer authentication.

Without this change, anyone compiling perf would have to depend on a
very new version of libunwind that has the callback to supply it with
pointer authentication masks.

This patch detects if libunwind is recent enough, and if so, sets a
pre-processor flag that will be used in a subsequent commit to call
libunwind appropriately.

If libunwind is not recent enough, the pre-processor flag is not set.

Signed-off-by: Andrew Kilroy <andrew.kilroy@arm.com>
---
 tools/build/Makefile.feature                  |  2 ++
 tools/build/feature/Makefile                  |  4 +++
 tools/build/feature/test-all.c                |  5 ++++
 .../feature/test-libunwind-arm64-ptrauth.c    | 26 +++++++++++++++++++
 tools/perf/Makefile.config                    | 10 +++++++
 5 files changed, 47 insertions(+)
 create mode 100644 tools/build/feature/test-libunwind-arm64-ptrauth.c

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index 888a0421d43b..a894101342fc 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -90,6 +90,7 @@ FEATURE_TESTS_EXTRA :=                  \
          libunwind-x86_64               \
          libunwind-arm                  \
          libunwind-aarch64              \
+         libunwind-arm64-ptrauth        \
          libunwind-debug-frame          \
          libunwind-debug-frame-arm      \
          libunwind-debug-frame-aarch64  \
@@ -128,6 +129,7 @@ FEATURE_DISPLAY ?=              \
          libpython              \
          libcrypto              \
          libunwind              \
+         libunwind-arm64-ptrauth\
          libdw-dwarf-unwind     \
          zlib                   \
          lzma                   \
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 7c2a17e23c30..ac23175d5bcb 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -45,6 +45,7 @@ FILES=                                          \
          test-libunwind-aarch64.bin             \
          test-libunwind-debug-frame-arm.bin     \
          test-libunwind-debug-frame-aarch64.bin \
+         test-libunwind-arm64-ptrauth.bin \
          test-pthread-attr-setaffinity-np.bin   \
          test-pthread-barrier.bin		\
          test-stackprotector-all.bin            \
@@ -193,6 +194,9 @@ $(OUTPUT)test-libunwind-debug-frame-arm.bin:
 $(OUTPUT)test-libunwind-debug-frame-aarch64.bin:
 	$(BUILD) -lelf -lunwind-aarch64
 
+$(OUTPUT)test-libunwind-arm64-ptrauth.bin:
+	$(BUILD) # -lunwind provided by $(FEATURE_CHECK_LDFLAGS-libunwind-arm64-ptrauth)
+
 $(OUTPUT)test-libaudit.bin:
 	$(BUILD) -laudit
 
diff --git a/tools/build/feature/test-all.c b/tools/build/feature/test-all.c
index 5ffafb967b6e..86780c5c78e5 100644
--- a/tools/build/feature/test-all.c
+++ b/tools/build/feature/test-all.c
@@ -66,6 +66,10 @@
 # include "test-libunwind.c"
 #undef main
 
+#define main main_test_libunwind_arm64_ptrauth
+# include "test-libunwind-arm64-ptrauth.c"
+#undef main
+
 #define main main_test_libslang
 # include "test-libslang.c"
 #undef main
@@ -186,6 +190,7 @@ int main(int argc, char *argv[])
 	main_test_libelf_gelf_getnote();
 	main_test_libelf_getshdrstrndx();
 	main_test_libunwind();
+	main_test_libunwind_arm64_ptrauth();
 	main_test_libslang();
 	main_test_libbfd();
 	main_test_libbfd_buildid();
diff --git a/tools/build/feature/test-libunwind-arm64-ptrauth.c b/tools/build/feature/test-libunwind-arm64-ptrauth.c
new file mode 100644
index 000000000000..51650ceef90e
--- /dev/null
+++ b/tools/build/feature/test-libunwind-arm64-ptrauth.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <libunwind.h>
+
+static unw_word_t get_insn_mask(unw_addr_space_t addr_space, void *unwind_info_ptr)
+{
+	return 0;
+}
+
+// This feature test is intending to check if the version
+// of the available libunwind library is one that has the
+// ptrauth_insn_mask callback function.
+// If it doesn't this feature check should fail to compile.
+static unw_accessors_t accessors = {
+	.ptrauth_insn_mask = get_insn_mask,
+};
+
+int main(void)
+{
+	unw_addr_space_t addr_space = unw_create_addr_space(&accessors, 0);
+
+	if (addr_space)
+		return 0;
+
+	return 0;
+}
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 73e0762092fe..2578b1d1a502 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -133,6 +133,8 @@ FEATURE_CHECK_CFLAGS-libunwind = $(LIBUNWIND_CFLAGS)
 FEATURE_CHECK_LDFLAGS-libunwind = $(LIBUNWIND_LDFLAGS) $(LIBUNWIND_LIBS)
 FEATURE_CHECK_CFLAGS-libunwind-debug-frame = $(LIBUNWIND_CFLAGS)
 FEATURE_CHECK_LDFLAGS-libunwind-debug-frame = $(LIBUNWIND_LDFLAGS) $(LIBUNWIND_LIBS)
+FEATURE_CHECK_CFLAGS-libunwind-arm64-ptrauth = $(LIBUNWIND_CFLAGS)
+FEATURE_CHECK_LDFLAGS-libunwind-arm64-ptrauth = $(LIBUNWIND_LDFLAGS) $(LIBUNWIND_LIBS)
 
 FEATURE_CHECK_LDFLAGS-libunwind-arm += -lunwind -lunwind-arm
 FEATURE_CHECK_LDFLAGS-libunwind-aarch64 += -lunwind -lunwind-aarch64
@@ -677,6 +679,14 @@ ifndef NO_LIBUNWIND
     $(call detected,CONFIG_LOCAL_LIBUNWIND)
   endif
 
+  ifeq ($(have_libunwind), 1)
+    $(call feature_check,libunwind-arm64-ptrauth)
+    ifneq ($(feature-libunwind-arm64-ptrauth),1)
+      CFLAGS += -DNO_LIBUNWIND_ARM64_PTRAUTH
+      msg := $(warning libunwind cannot produce user stacks in the presence of pointer authentication.);
+    endif
+  endif
+
   ifneq ($(have_libunwind), 1)
     NO_LIBUNWIND := 1
   endif
-- 
2.17.1

