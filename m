Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D274BFFC4
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiBVRIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbiBVRIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:08:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754648C7EF;
        Tue, 22 Feb 2022 09:08:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 57054CE1791;
        Tue, 22 Feb 2022 17:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216D2C340E8;
        Tue, 22 Feb 2022 17:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645549688;
        bh=yFHBdsuRceeQRBNVPPb3szBvEEm5e1vkI4dUoZkDPHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KaKyEIbCdh650kZRkWMex9PISQa0m/xA9lY0qlaW0zI3DIYffk3XW6b11lTtQcd/H
         cr9Nam2BkUPem/AH+84Dhgx/t+Mbbj7ffC0oPSM5SqEJDSkPkisMSEKlZEefWtJ2RD
         uAsRhKTY34F/4yhPyp3DdQHlzkldGef2+/YaZqkWARdvD632guKbiLdZgHPMLe3hvp
         epfnoJrgTPEJCgIh0YGltYg0nHVfE29SrCKpceU2YBcDIPwCfxxOcPRarx7bHcP/Jp
         nmin1QgtKp/hA3VHO618P5Bb87adQCPCueyECw+v0S34/jctWNnpcHjYUVYmhH9QKw
         U6PTaan7DInGg==
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
Subject: [PATCH 09/10] selftest/bpf: Add kprobe_multi attach test
Date:   Tue, 22 Feb 2022 18:05:59 +0100
Message-Id: <20220222170600.611515-10-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220222170600.611515-1-jolsa@kernel.org>
References: <20220222170600.611515-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 .../bpf/prog_tests/kprobe_multi_test.c        | 115 ++++++++++++++++++
 .../selftests/bpf/progs/kprobe_multi.c        |  58 +++++++++
 2 files changed, 173 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi.c

diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
new file mode 100644
index 000000000000..f5567c3865d4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "kprobe_multi.skel.h"
+#include "trace_helpers.h"
+
+static void test_skel_api(void)
+{
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+	struct kprobe_multi *skel = NULL;
+	int err, prog_fd;
+
+	skel = kprobe_multi__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "kprobe_multi__open_and_load"))
+		goto cleanup;
+
+	err = kprobe_multi__attach(skel);
+	if (!ASSERT_OK(err, "kprobe_multi__attach"))
+		goto cleanup;
+
+	prog_fd = bpf_program__fd(skel->progs.test1);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(topts.retval, 0, "test_run");
+
+	ASSERT_EQ(skel->bss->test2_result, 8, "test2_result");
+	ASSERT_EQ(skel->bss->test3_result, 8, "test3_result");
+
+cleanup:
+	kprobe_multi__destroy(skel);
+}
+
+static void test_link_api(struct bpf_link_create_opts *opts)
+{
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+	int err, prog_fd, link1_fd = -1, link2_fd = -1;
+	struct kprobe_multi *skel = NULL;
+
+	skel = kprobe_multi__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fentry_raw_skel_load"))
+		goto cleanup;
+
+	prog_fd = bpf_program__fd(skel->progs.test2);
+	link1_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_KPROBE_MULTI, opts);
+	if (!ASSERT_GE(link1_fd, 0, "link_fd"))
+		goto cleanup;
+
+	opts->kprobe_multi.flags = BPF_F_KPROBE_MULTI_RETURN;
+	prog_fd = bpf_program__fd(skel->progs.test3);
+	link2_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_KPROBE_MULTI, opts);
+	if (!ASSERT_GE(link2_fd, 0, "link_fd"))
+		goto cleanup;
+
+	skel->bss->test2_result = 0;
+	skel->bss->test3_result = 0;
+
+	prog_fd = bpf_program__fd(skel->progs.test1);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(topts.retval, 0, "test_run");
+
+	ASSERT_EQ(skel->bss->test2_result, 8, "test2_result");
+	ASSERT_EQ(skel->bss->test3_result, 8, "test3_result");
+
+cleanup:
+	if (link1_fd != -1)
+		close(link1_fd);
+	if (link2_fd != -1)
+		close(link2_fd);
+	kprobe_multi__destroy(skel);
+}
+
+static void test_link_api_addrs(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	__u64 addrs[8];
+
+	kallsyms_find("bpf_fentry_test1", &addrs[0]);
+	kallsyms_find("bpf_fentry_test2", &addrs[1]);
+	kallsyms_find("bpf_fentry_test3", &addrs[2]);
+	kallsyms_find("bpf_fentry_test4", &addrs[3]);
+	kallsyms_find("bpf_fentry_test5", &addrs[4]);
+	kallsyms_find("bpf_fentry_test6", &addrs[5]);
+	kallsyms_find("bpf_fentry_test7", &addrs[6]);
+	kallsyms_find("bpf_fentry_test8", &addrs[7]);
+
+	opts.kprobe_multi.addrs = (__u64) addrs;
+	opts.kprobe_multi.cnt = 8;
+	test_link_api(&opts);
+}
+
+static void test_link_api_syms(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
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
+	opts.kprobe_multi.syms = (__u64) syms;
+	opts.kprobe_multi.cnt = 8;
+	test_link_api(&opts);
+}
+
+void test_kprobe_multi_test(void)
+{
+	test_skel_api();
+	test_link_api_syms();
+	test_link_api_addrs();
+}
diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi.c b/tools/testing/selftests/bpf/progs/kprobe_multi.c
new file mode 100644
index 000000000000..71318c65931c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kprobe_multi.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
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
+/* No tests, just to trigger bpf_fentry_test* through tracing test_run */
+SEC("fentry/bpf_modify_return_test")
+int BPF_PROG(test1)
+{
+	return 0;
+}
+
+__u64 test2_result = 0;
+
+SEC("kprobe.multi/bpf_fentry_test?")
+int test2(struct pt_regs *ctx)
+{
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test2_result += (const void *) addr == &bpf_fentry_test1 ||
+			(const void *) addr == &bpf_fentry_test2 ||
+			(const void *) addr == &bpf_fentry_test3 ||
+			(const void *) addr == &bpf_fentry_test4 ||
+			(const void *) addr == &bpf_fentry_test5 ||
+			(const void *) addr == &bpf_fentry_test6 ||
+			(const void *) addr == &bpf_fentry_test7 ||
+			(const void *) addr == &bpf_fentry_test8;
+	return 0;
+}
+
+__u64 test3_result = 0;
+
+SEC("kretprobe.multi/bpf_fentry_test*")
+int test3(struct pt_regs *ctx)
+{
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test3_result += (const void *) addr == &bpf_fentry_test1 ||
+			(const void *) addr == &bpf_fentry_test2 ||
+			(const void *) addr == &bpf_fentry_test3 ||
+			(const void *) addr == &bpf_fentry_test4 ||
+			(const void *) addr == &bpf_fentry_test5 ||
+			(const void *) addr == &bpf_fentry_test6 ||
+			(const void *) addr == &bpf_fentry_test7 ||
+			(const void *) addr == &bpf_fentry_test8;
+	return 0;
+}
-- 
2.35.1

