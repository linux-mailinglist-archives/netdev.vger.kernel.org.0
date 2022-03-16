Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9294DAFB2
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355763AbiCPM1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350986AbiCPM1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:27:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C2A66612;
        Wed, 16 Mar 2022 05:26:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 969ACB81AE4;
        Wed, 16 Mar 2022 12:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6283BC340E9;
        Wed, 16 Mar 2022 12:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647433583;
        bh=vWQ45p6IiUln+8RCOkkrGAhdyYJduZ3ffBungUr0sMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r64UMIfjBwm4SADOlvXkzugDRguLDA6OPndXYJxJ3MsievPPDI/Y3r1yMybpr7ZYw
         fW8q7tfhJrGemWqhr3eNSj4yXgYtQbbKKPqeSebnrNfpgfy9+xphsFAFLLQUxt4ao8
         yueHUv1r1lY3T6oY5c6/vtzMMfGB/MZ5L/8TdZC7ac7tyyqljqf1P7z46lezZyZdlh
         s8rU18mbh/SJGBXyd/nEcxukeKaYWFBlz8ELjp06O8knZJdTdit9jSD9/K2Rm3T+FA
         dBYErrEYKuN4qf6NbTheiEUwtExRI19EMoUu1Ny9td3juMtoA6ehdrXPnaQMGiKSF+
         4bA2hTIsRcETw==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCHv3 bpf-next 10/13] selftests/bpf: Add kprobe_multi attach test
Date:   Wed, 16 Mar 2022 13:24:16 +0100
Message-Id: <20220316122419.933957-11-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316122419.933957-1-jolsa@kernel.org>
References: <20220316122419.933957-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding kprobe_multi attach test that uses new fprobe interface to
attach kprobe program to multiple functions.

The test is attaching programs to bpf_fentry_test* functions and
uses single trampoline program bpf_prog_test_run to trigger
bpf_fentry_test* functions.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/kprobe_multi_test.c        | 141 ++++++++++++++++++
 .../selftests/bpf/progs/kprobe_multi.c        |  95 ++++++++++++
 tools/testing/selftests/bpf/trace_helpers.c   |   7 +
 3 files changed, 243 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi.c

diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
new file mode 100644
index 000000000000..ded6b8c8ec05
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "kprobe_multi.skel.h"
+#include "trace_helpers.h"
+
+static void kprobe_multi_test_run(struct kprobe_multi *skel)
+{
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+	int err, prog_fd;
+
+	prog_fd = bpf_program__fd(skel->progs.trigger);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(topts.retval, 0, "test_run");
+
+	ASSERT_EQ(skel->bss->kprobe_test1_result, 1, "kprobe_test1_result");
+	ASSERT_EQ(skel->bss->kprobe_test2_result, 1, "kprobe_test2_result");
+	ASSERT_EQ(skel->bss->kprobe_test3_result, 1, "kprobe_test3_result");
+	ASSERT_EQ(skel->bss->kprobe_test4_result, 1, "kprobe_test4_result");
+	ASSERT_EQ(skel->bss->kprobe_test5_result, 1, "kprobe_test5_result");
+	ASSERT_EQ(skel->bss->kprobe_test6_result, 1, "kprobe_test6_result");
+	ASSERT_EQ(skel->bss->kprobe_test7_result, 1, "kprobe_test7_result");
+	ASSERT_EQ(skel->bss->kprobe_test8_result, 1, "kprobe_test8_result");
+
+	ASSERT_EQ(skel->bss->kretprobe_test1_result, 1, "kretprobe_test1_result");
+	ASSERT_EQ(skel->bss->kretprobe_test2_result, 1, "kretprobe_test2_result");
+	ASSERT_EQ(skel->bss->kretprobe_test3_result, 1, "kretprobe_test3_result");
+	ASSERT_EQ(skel->bss->kretprobe_test4_result, 1, "kretprobe_test4_result");
+	ASSERT_EQ(skel->bss->kretprobe_test5_result, 1, "kretprobe_test5_result");
+	ASSERT_EQ(skel->bss->kretprobe_test6_result, 1, "kretprobe_test6_result");
+	ASSERT_EQ(skel->bss->kretprobe_test7_result, 1, "kretprobe_test7_result");
+	ASSERT_EQ(skel->bss->kretprobe_test8_result, 1, "kretprobe_test8_result");
+}
+
+static void test_skel_api(void)
+{
+	struct kprobe_multi *skel = NULL;
+	int err;
+
+	skel = kprobe_multi__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "kprobe_multi__open_and_load"))
+		goto cleanup;
+
+	skel->bss->pid = getpid();
+	err = kprobe_multi__attach(skel);
+	if (!ASSERT_OK(err, "kprobe_multi__attach"))
+		goto cleanup;
+
+	kprobe_multi_test_run(skel);
+
+cleanup:
+	kprobe_multi__destroy(skel);
+}
+
+static void test_link_api(struct bpf_link_create_opts *opts)
+{
+	int prog_fd, link1_fd = -1, link2_fd = -1;
+	struct kprobe_multi *skel = NULL;
+
+	skel = kprobe_multi__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fentry_raw_skel_load"))
+		goto cleanup;
+
+	skel->bss->pid = getpid();
+	prog_fd = bpf_program__fd(skel->progs.test_kprobe);
+	link1_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_KPROBE_MULTI, opts);
+	if (!ASSERT_GE(link1_fd, 0, "link_fd"))
+		goto cleanup;
+
+	opts->kprobe_multi.flags = BPF_F_KPROBE_MULTI_RETURN;
+	prog_fd = bpf_program__fd(skel->progs.test_kretprobe);
+	link2_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_KPROBE_MULTI, opts);
+	if (!ASSERT_GE(link2_fd, 0, "link_fd"))
+		goto cleanup;
+
+	kprobe_multi_test_run(skel);
+
+cleanup:
+	if (link1_fd != -1)
+		close(link1_fd);
+	if (link2_fd != -1)
+		close(link2_fd);
+	kprobe_multi__destroy(skel);
+}
+
+#define GET_ADDR(__sym, __addr) ({					\
+	__addr = ksym_get_addr(__sym);					\
+	if (!ASSERT_NEQ(__addr, 0, "kallsyms load failed for " #__sym))	\
+		return;							\
+})
+
+static void test_link_api_addrs(void)
+{
+	LIBBPF_OPTS(bpf_link_create_opts, opts);
+	unsigned long long addrs[8];
+
+	GET_ADDR("bpf_fentry_test1", addrs[0]);
+	GET_ADDR("bpf_fentry_test2", addrs[1]);
+	GET_ADDR("bpf_fentry_test3", addrs[2]);
+	GET_ADDR("bpf_fentry_test4", addrs[3]);
+	GET_ADDR("bpf_fentry_test5", addrs[4]);
+	GET_ADDR("bpf_fentry_test6", addrs[5]);
+	GET_ADDR("bpf_fentry_test7", addrs[6]);
+	GET_ADDR("bpf_fentry_test8", addrs[7]);
+
+	opts.kprobe_multi.addrs = (const unsigned long*) addrs;
+	opts.kprobe_multi.cnt = ARRAY_SIZE(addrs);
+	test_link_api(&opts);
+}
+
+static void test_link_api_syms(void)
+{
+	LIBBPF_OPTS(bpf_link_create_opts, opts);
+	const char *syms[8] = {
+		"bpf_fentry_test1",
+		"bpf_fentry_test2",
+		"bpf_fentry_test3",
+		"bpf_fentry_test4",
+		"bpf_fentry_test5",
+		"bpf_fentry_test6",
+		"bpf_fentry_test7",
+		"bpf_fentry_test8",
+	};
+
+	opts.kprobe_multi.syms = syms;
+	opts.kprobe_multi.cnt = ARRAY_SIZE(syms);
+	test_link_api(&opts);
+}
+
+void test_kprobe_multi_test(void)
+{
+	if (!ASSERT_OK(load_kallsyms(), "load_kallsyms"))
+		return;
+
+	if (test__start_subtest("skel_api"))
+		test_skel_api();
+	if (test__start_subtest("link_api_addrs"))
+		test_link_api_syms();
+	if (test__start_subtest("link_api_syms"))
+		test_link_api_addrs();
+}
diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi.c b/tools/testing/selftests/bpf/progs/kprobe_multi.c
new file mode 100644
index 000000000000..6616c082c8c2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kprobe_multi.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <stdbool.h>
+
+char _license[] SEC("license") = "GPL";
+
+extern const void bpf_fentry_test1 __ksym;
+extern const void bpf_fentry_test2 __ksym;
+extern const void bpf_fentry_test3 __ksym;
+extern const void bpf_fentry_test4 __ksym;
+extern const void bpf_fentry_test5 __ksym;
+extern const void bpf_fentry_test6 __ksym;
+extern const void bpf_fentry_test7 __ksym;
+extern const void bpf_fentry_test8 __ksym;
+
+int pid = 0;
+
+__u64 kprobe_test1_result = 0;
+__u64 kprobe_test2_result = 0;
+__u64 kprobe_test3_result = 0;
+__u64 kprobe_test4_result = 0;
+__u64 kprobe_test5_result = 0;
+__u64 kprobe_test6_result = 0;
+__u64 kprobe_test7_result = 0;
+__u64 kprobe_test8_result = 0;
+
+__u64 kretprobe_test1_result = 0;
+__u64 kretprobe_test2_result = 0;
+__u64 kretprobe_test3_result = 0;
+__u64 kretprobe_test4_result = 0;
+__u64 kretprobe_test5_result = 0;
+__u64 kretprobe_test6_result = 0;
+__u64 kretprobe_test7_result = 0;
+__u64 kretprobe_test8_result = 0;
+
+static void kprobe_multi_check(void *ctx, bool is_return)
+{
+	if (bpf_get_current_pid_tgid() >> 32 != pid)
+		return;
+
+	__u64 addr = bpf_get_func_ip(ctx);
+
+#define SET(__var, __addr) ({			\
+	if ((const void *) addr == __addr) 	\
+		__var = 1;			\
+})
+
+	if (is_return) {
+		SET(kretprobe_test1_result, &bpf_fentry_test1);
+		SET(kretprobe_test2_result, &bpf_fentry_test2);
+		SET(kretprobe_test3_result, &bpf_fentry_test3);
+		SET(kretprobe_test4_result, &bpf_fentry_test4);
+		SET(kretprobe_test5_result, &bpf_fentry_test5);
+		SET(kretprobe_test6_result, &bpf_fentry_test6);
+		SET(kretprobe_test7_result, &bpf_fentry_test7);
+		SET(kretprobe_test8_result, &bpf_fentry_test8);
+	} else {
+		SET(kprobe_test1_result, &bpf_fentry_test1);
+		SET(kprobe_test2_result, &bpf_fentry_test2);
+		SET(kprobe_test3_result, &bpf_fentry_test3);
+		SET(kprobe_test4_result, &bpf_fentry_test4);
+		SET(kprobe_test5_result, &bpf_fentry_test5);
+		SET(kprobe_test6_result, &bpf_fentry_test6);
+		SET(kprobe_test7_result, &bpf_fentry_test7);
+		SET(kprobe_test8_result, &bpf_fentry_test8);
+	}
+
+#undef SET
+}
+
+/*
+ * No tests in here, just to trigger 'bpf_fentry_test*'
+ * through tracing test_run
+ */
+SEC("fentry/bpf_modify_return_test")
+int BPF_PROG(trigger)
+{
+	return 0;
+}
+
+SEC("kprobe.multi/bpf_fentry_tes??")
+int test_kprobe(struct pt_regs *ctx)
+{
+	kprobe_multi_check(ctx, false);
+	return 0;
+}
+
+SEC("kretprobe.multi/bpf_fentry_test*")
+int test_kretprobe(struct pt_regs *ctx)
+{
+	kprobe_multi_check(ctx, true);
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index ca6abae9b09c..3d6217e3aff7 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -34,6 +34,13 @@ int load_kallsyms(void)
 	if (!f)
 		return -ENOENT;
 
+	/*
+	 * This is called/used from multiplace places,
+	 * load symbols just once.
+	 */
+	if (sym_cnt)
+		return 0;
+
 	while (fgets(buf, sizeof(buf), f)) {
 		if (sscanf(buf, "%p %c %s", &addr, &symbol, func) != 3)
 			break;
-- 
2.35.1

