Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D25456591F
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 16:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbiGDO5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 10:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234986AbiGDO4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 10:56:55 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0071011C13;
        Mon,  4 Jul 2022 07:56:35 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 027F7150C;
        Mon,  4 Jul 2022 07:56:36 -0700 (PDT)
Received: from e124483.cambridge.arm.com (e124483.cambridge.arm.com [10.1.29.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DB2973F792;
        Mon,  4 Jul 2022 07:56:31 -0700 (PDT)
From:   Andrew Kilroy <andrew.kilroy@arm.com>
To:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org
Cc:     German Gomez <german.gomez@arm.com>,
        Andrew Kilroy <andrew.kilroy@arm.com>,
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
Subject: [PATCH 8/8] perf test arm64: Test unwinding with PACs on gcc & clang compilers
Date:   Mon,  4 Jul 2022 15:53:32 +0100
Message-Id: <20220704145333.22557-9-andrew.kilroy@arm.com>
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

From: German Gomez <german.gomez@arm.com>

Adds self test to test unwindings in the presence of PACs for different
versions of gcc and clang.

Example run:

| $ ./perf test 74
|  74: Arm64 unwinding with PAC support           :
|  74.1: gcc-9                                    : Ok
|  74.2: gcc-10                                   : Ok
|  74.3: gcc-11                                   : Ok
|  74.4: gcc-12                                   : Ok
|  74.5: clang-12                                 : Skip (not installed)
|  74.6: clang-13                                 : Skip (not installed)
|  74.7: clang-14                                 : Ok

Signed-off-by: German Gomez <german.gomez@arm.com>
Signed-off-by: Andrew Kilroy <andrew.kilroy@arm.com>
---
 tools/perf/Makefile.perf           |   1 +
 tools/perf/tests/Build             |   1 +
 tools/perf/tests/arm_unwind_pac.c  | 113 +++++++++++++++++++++++++++++
 tools/perf/tests/arm_unwind_pac.sh |  57 +++++++++++++++
 tools/perf/tests/builtin-test.c    |   1 +
 tools/perf/tests/tests.h           |   1 +
 6 files changed, 174 insertions(+)
 create mode 100644 tools/perf/tests/arm_unwind_pac.c
 create mode 100755 tools/perf/tests/arm_unwind_pac.sh

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 8f738e11356d..35d067534cf1 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -1008,6 +1008,7 @@ endif
 install-tests: all install-gtk
 	$(call QUIET_INSTALL, tests) \
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'; \
+		$(INSTALL) tests/arm_unwind_pac.sh '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'; \
 		$(INSTALL) tests/attr.py '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'; \
 		$(INSTALL) tests/pe-file.exe* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'; \
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'; \
diff --git a/tools/perf/tests/Build b/tools/perf/tests/Build
index af2b37ef7c70..a03c189c5e98 100644
--- a/tools/perf/tests/Build
+++ b/tools/perf/tests/Build
@@ -66,6 +66,7 @@ perf-y += expand-cgroup.o
 perf-y += perf-time-to-tsc.o
 perf-y += dlfilter-test.o
 perf-y += sigtrap.o
+perf-y += arm_unwind_pac.o
 
 $(OUTPUT)tests/llvm-src-base.c: tests/bpf-script-example.c tests/Build
 	$(call rule_mkdir)
diff --git a/tools/perf/tests/arm_unwind_pac.c b/tools/perf/tests/arm_unwind_pac.c
new file mode 100644
index 000000000000..11b7e936a72d
--- /dev/null
+++ b/tools/perf/tests/arm_unwind_pac.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <subcmd/exec-cmd.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include "pmu.h"
+#include "tests.h"
+#include "debug.h"
+
+#if defined(HAVE_LIBUNWIND_SUPPORT) && defined(__aarch64__)
+
+#define BUF_MAX 1024
+
+static bool test_command_exists(const char *cmd)
+{
+	char buf[BUF_MAX];
+
+	scnprintf(buf, BUF_MAX, "which %s", cmd);
+	return !system(buf);
+}
+
+static int run_dir(const char *d, const char *compiler, const char *compiler_argv)
+{
+	char buf[BUF_MAX];
+
+	if (!test_command_exists(compiler))
+		return TEST_SKIP;
+
+	scnprintf(buf, BUF_MAX, "%s/arm_unwind_pac.sh %s '%s'", d, compiler, compiler_argv);
+	return system(buf) ? TEST_FAIL : TEST_OK;
+}
+
+static int run(const char *compiler, const char *compiler_argv)
+{
+	struct stat st;
+	char exec_test_path[BUF_MAX];
+	char *exec_path;
+
+	/* Check development tree tests. */
+	if (!lstat("./tests", &st))
+		return run_dir("./tests", compiler, compiler_argv);
+
+	/* Otherwise, check installed path */
+	exec_path = get_argv_exec_path();
+	if (exec_path == NULL)
+		return -1;
+
+	snprintf(exec_test_path, BUF_MAX, "%s/tests", exec_path);
+	if (!lstat(exec_test_path, &st))
+		return run_dir(exec_test_path, compiler, compiler_argv);
+
+	return TEST_SKIP;
+}
+
+#define TEST_COMPILER(_test, compiler, args)					\
+	static int test__##_test(struct test_suite *test __maybe_unused,	\
+				 int subtest __maybe_unused)			\
+	{									\
+		return run(compiler, args);					\
+	}
+
+/*
+ * gcc compilers
+ */
+TEST_COMPILER(gcc8,	"gcc-8",	"-msign-return-address=all")
+TEST_COMPILER(gcc9,	"gcc-9",	"-mbranch-protection=pac-ret+leaf")
+TEST_COMPILER(gcc10,	"gcc-10",	"-mbranch-protection=pac-ret+leaf")
+TEST_COMPILER(gcc11,	"gcc-11",	"-mbranch-protection=pac-ret+leaf")
+TEST_COMPILER(gcc12,	"gcc-12",	"-mbranch-protection=pac-ret+leaf")
+
+/*
+ * clang compilers
+ */
+TEST_COMPILER(clang12,	"clang-12",	"-msign-return-address=all")
+TEST_COMPILER(clang13,	"clang-13",	"-msign-return-address=all")
+TEST_COMPILER(clang14,	"clang-14",	"-msign-return-address=all")
+
+static struct test_case pac_tests[] = {
+#define PAC_TEST_CASE(name, test) \
+	TEST_CASE_REASON(name, test, "not installed")
+
+	PAC_TEST_CASE("gcc-8",		gcc8),
+	PAC_TEST_CASE("gcc-9",		gcc9),
+	PAC_TEST_CASE("gcc-10",		gcc10),
+	PAC_TEST_CASE("gcc-11",		gcc11),
+	PAC_TEST_CASE("gcc-12",		gcc12),
+
+	PAC_TEST_CASE("clang-12",	clang12),
+	PAC_TEST_CASE("clang-13",	clang13),
+	PAC_TEST_CASE("clang-14",	clang14),
+
+#undef PAC_TEST_CASE
+	{ .name = NULL, }
+};
+
+struct test_suite suite__arm_unwind_pac = {
+	.desc = "Arm64 unwinding with PAC support",
+	.test_cases = pac_tests,
+};
+
+#else // HAVE_LIBUNWIND_SUPPORT && __aarch64__
+
+static int test__arm_unwind_pac(struct test_suite *test __maybe_unused, int subtest __maybe_unused)
+{
+	return TEST_SKIP;
+}
+
+DEFINE_SUITE("Arm64 unwinding with PAC support", arm_unwind_pac);
+
+#endif // HAVE_LIBUNWIND_SUPPORT && __aarch64__
diff --git a/tools/perf/tests/arm_unwind_pac.sh b/tools/perf/tests/arm_unwind_pac.sh
new file mode 100755
index 000000000000..7491dc5f908b
--- /dev/null
+++ b/tools/perf/tests/arm_unwind_pac.sh
@@ -0,0 +1,57 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+COMPILER_CMD="$1"
+COMPILER_ARG="$2 -g -fno-omit-frame-pointer -fno-inline"
+
+echo "COMPILER_CMD=$COMPILER_CMD"
+echo "COMPILER_ARG=$COMPILER_ARG"
+
+TMPDIR=$(mktemp -d /tmp/__perf_test.XXXXX)
+
+clean_up() {
+	rm -rf $TMPDIR
+}
+
+trap clean_up exit term int
+
+cat << EOF > $TMPDIR/program.c
+void bar(void) {
+  for(;;);
+}
+void foo(void) {
+  bar();
+}
+int main(void) {
+  foo();
+  return 0;
+}
+EOF
+
+$COMPILER_CMD $COMPILER_ARG $TMPDIR/program.c -o $TMPDIR/program
+
+perf record --call-graph=dwarf -e cycles//u -o $TMPDIR/perf-dwarf.data -- $TMPDIR/program &
+PID=$!
+sleep 1
+kill $PID
+wait $PID
+
+perf record --call-graph=fp -e cycles//u -o $TMPDIR/perf-fp.data -- $TMPDIR/program &
+PID=$!
+sleep 1
+kill $PID
+wait $PID
+
+perf report --symbols=bar -i $TMPDIR/perf-dwarf.data --stdio > $TMPDIR/report-dwarf
+perf report --symbols=bar -i $TMPDIR/perf-fp.data --stdio > $TMPDIR/report-fp
+
+set -e
+set -x
+
+grep "main" $TMPDIR/report-dwarf
+grep "foo" $TMPDIR/report-dwarf
+grep "bar" $TMPDIR/report-dwarf
+
+grep "main" $TMPDIR/report-fp
+grep "foo" $TMPDIR/report-fp
+grep "bar" $TMPDIR/report-fp
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 81cf241cd109..e121cfd43b8d 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -108,6 +108,7 @@ static struct test_suite *generic_tests[] = {
 	&suite__perf_time_to_tsc,
 	&suite__dlfilter,
 	&suite__sigtrap,
+	&suite__arm_unwind_pac,
 	NULL,
 };
 
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 5bbb8f6a48fc..459e473a91cd 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -147,6 +147,7 @@ DECLARE_SUITE(expand_cgroup_events);
 DECLARE_SUITE(perf_time_to_tsc);
 DECLARE_SUITE(dlfilter);
 DECLARE_SUITE(sigtrap);
+DECLARE_SUITE(arm_unwind_pac);
 
 /*
  * PowerPC and S390 do not support creation of instruction breakpoints using the
-- 
2.17.1

