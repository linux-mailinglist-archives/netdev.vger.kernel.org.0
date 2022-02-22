Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4895E4BFFC8
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiBVRI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbiBVRIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:08:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1518990249;
        Tue, 22 Feb 2022 09:08:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A516161291;
        Tue, 22 Feb 2022 17:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7A1C340E8;
        Tue, 22 Feb 2022 17:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645549702;
        bh=bYw58Oim7YKxfKRi3NAAACDa3WAM5CvIxglbEBfCSe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TEZysduse1anvebQk5Ub3ENn7A3VKtOSHtoCkDPP9CQgWhC9OR6fTLFYecgxGhGMz
         O1FPUEUbT857+cmOvxR5CcCkvYwfMslcN64WzEm26X1c3dGfgkzfbHg2D8K93qixEZ
         d2b3NsE4Be+5/ImeQdLFnJ90AibwXpUA8VeoyxZNZqx/3KcSzlAVx/KBJhvXXA0A03
         w9exsqVpolSvH8V3oswd0CBmWv/v010cyzXTxV19qV8V35A+ZgiMvKAmL/6IA5GHKI
         8Fi0YUuOT6k32gyjvaeiV/nzFZhE5loK7XZ1+VGEd+6WixwJmE9jbbHPEuESgXGoS5
         iIXeOhvZv7J+Q==
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
Subject: [PATCH 10/10] selftest/bpf: Add kprobe_multi test for bpf_cookie values
Date:   Tue, 22 Feb 2022 18:06:00 +0100
Message-Id: <20220222170600.611515-11-jolsa@kernel.org>
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

Adding bpf_cookie test for programs attached by kprobe_multi links.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/bpf_cookie.c     | 72 +++++++++++++++++++
 .../bpf/progs/kprobe_multi_bpf_cookie.c       | 62 ++++++++++++++++
 2 files changed, 134 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
index cd10df6cd0fc..edfb9f8736c6 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
@@ -7,6 +7,7 @@
 #include <unistd.h>
 #include <test_progs.h>
 #include "test_bpf_cookie.skel.h"
+#include "kprobe_multi_bpf_cookie.skel.h"
 
 /* uprobe attach point */
 static void trigger_func(void)
@@ -63,6 +64,75 @@ static void kprobe_subtest(struct test_bpf_cookie *skel)
 	bpf_link__destroy(retlink2);
 }
 
+static void kprobe_multi_subtest(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	int err, prog_fd, link1_fd = -1, link2_fd = -1;
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+	struct kprobe_multi_bpf_cookie *skel = NULL;
+	__u64 addrs[8], cookies[8];
+
+	skel = kprobe_multi_bpf_cookie__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fentry_raw_skel_load"))
+		goto cleanup;
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
+	cookies[0] = 1;
+	cookies[1] = 2;
+	cookies[2] = 3;
+	cookies[3] = 4;
+	cookies[4] = 5;
+	cookies[5] = 6;
+	cookies[6] = 7;
+	cookies[7] = 8;
+
+	opts.kprobe_multi.addrs = ptr_to_u64(&addrs);
+	opts.kprobe_multi.cnt = 8;
+	opts.kprobe_multi.cookies = ptr_to_u64(&cookies);
+	prog_fd = bpf_program__fd(skel->progs.test2);
+
+	link1_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_KPROBE_MULTI, &opts);
+	if (!ASSERT_GE(link1_fd, 0, "link1_fd"))
+		return;
+
+	cookies[0] = 8;
+	cookies[1] = 7;
+	cookies[2] = 6;
+	cookies[3] = 5;
+	cookies[4] = 4;
+	cookies[5] = 3;
+	cookies[6] = 2;
+	cookies[7] = 1;
+
+	opts.flags = BPF_F_KPROBE_MULTI_RETURN;
+	prog_fd = bpf_program__fd(skel->progs.test3);
+
+	link2_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_KPROBE_MULTI, &opts);
+	if (!ASSERT_GE(link2_fd, 0, "link2_fd"))
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
+	close(link1_fd);
+	close(link2_fd);
+	kprobe_multi_bpf_cookie__destroy(skel);
+}
+
 static void uprobe_subtest(struct test_bpf_cookie *skel)
 {
 	DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
@@ -249,6 +319,8 @@ void test_bpf_cookie(void)
 
 	if (test__start_subtest("kprobe"))
 		kprobe_subtest(skel);
+	if (test__start_subtest("multi_kprobe"))
+		kprobe_multi_subtest();
 	if (test__start_subtest("uprobe"))
 		uprobe_subtest(skel);
 	if (test__start_subtest("tracepoint"))
diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c b/tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c
new file mode 100644
index 000000000000..d6f8454ba093
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c
@@ -0,0 +1,62 @@
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
+SEC("kprobe.multi/bpf_fentry_tes??")
+int test2(struct pt_regs *ctx)
+{
+	__u64 cookie = bpf_get_attach_cookie(ctx);
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test2_result += (const void *) addr == &bpf_fentry_test1 && cookie == 1;
+	test2_result += (const void *) addr == &bpf_fentry_test2 && cookie == 2;
+	test2_result += (const void *) addr == &bpf_fentry_test3 && cookie == 3;
+	test2_result += (const void *) addr == &bpf_fentry_test4 && cookie == 4;
+	test2_result += (const void *) addr == &bpf_fentry_test5 && cookie == 5;
+	test2_result += (const void *) addr == &bpf_fentry_test6 && cookie == 6;
+	test2_result += (const void *) addr == &bpf_fentry_test7 && cookie == 7;
+	test2_result += (const void *) addr == &bpf_fentry_test8 && cookie == 8;
+
+	return 0;
+}
+
+__u64 test3_result = 0;
+
+SEC("kretprobe.multi/bpf_fentry_test*")
+int test3(struct pt_regs *ctx)
+{
+	__u64 cookie = bpf_get_attach_cookie(ctx);
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test3_result += (const void *) addr == &bpf_fentry_test1 && cookie == 8;
+	test3_result += (const void *) addr == &bpf_fentry_test2 && cookie == 7;
+	test3_result += (const void *) addr == &bpf_fentry_test3 && cookie == 6;
+	test3_result += (const void *) addr == &bpf_fentry_test4 && cookie == 5;
+	test3_result += (const void *) addr == &bpf_fentry_test5 && cookie == 4;
+	test3_result += (const void *) addr == &bpf_fentry_test6 && cookie == 3;
+	test3_result += (const void *) addr == &bpf_fentry_test7 && cookie == 2;
+	test3_result += (const void *) addr == &bpf_fentry_test8 && cookie == 1;
+
+	return 0;
+}
-- 
2.35.1

