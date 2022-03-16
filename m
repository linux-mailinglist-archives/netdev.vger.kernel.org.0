Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDDD4DAFB5
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237950AbiCPM2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355826AbiCPM1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:27:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A72065D3E;
        Wed, 16 Mar 2022 05:26:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB8E3B81AE7;
        Wed, 16 Mar 2022 12:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D50C36AE2;
        Wed, 16 Mar 2022 12:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647433595;
        bh=ZCd4B8vBZb5AlYNluqFEAZYkx4pah3M8EdqYo8dnBoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uAuo1d5RF3+zL/GjL47k08U0YDPhFDouwYDSjuP7yadILFReSZcLY+hKQawANuLD6
         6+jn2aR4PqVo4IN+6hugV41LaS6S6l2epxaVsn6WAbx2LVLOGuNF+3iRRdS7Dz1CSb
         o2CfVOrm59pPG4vqqBKM2VDJaZTs47pqBLTCPYb1+kTVxAjyS9wk8MqYG6pHdE581W
         4Huu+x5c1YrcaX+yIukAc9I9dH32zBLxnPqnKMRJXqffjLchrcQ3LzmM4wAIMDUmQT
         cdRz49QdIFw0AYbYkUcQ7ubjd4zG6xr9Ge04UTUk1W6sfKzw6ntWiG0tE1cHs2HFdI
         ihLSaBf/zLaiA==
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
Subject: [PATCHv3 bpf-next 11/13] selftests/bpf: Add kprobe_multi bpf_cookie test
Date:   Wed, 16 Mar 2022 13:24:17 +0100
Message-Id: <20220316122419.933957-12-jolsa@kernel.org>
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

Adding bpf_cookie test for programs attached by kprobe_multi links.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/bpf_cookie.c     | 109 ++++++++++++++++++
 .../selftests/bpf/progs/kprobe_multi.c        |  41 ++++---
 2 files changed, 131 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
index 0612e79a9281..6671d4dc0b5d 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
@@ -7,6 +7,7 @@
 #include <unistd.h>
 #include <test_progs.h>
 #include "test_bpf_cookie.skel.h"
+#include "kprobe_multi.skel.h"
 
 /* uprobe attach point */
 static void trigger_func(void)
@@ -63,6 +64,112 @@ static void kprobe_subtest(struct test_bpf_cookie *skel)
 	bpf_link__destroy(retlink2);
 }
 
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
+static void kprobe_multi_link_api_subtest(void)
+{
+	int prog_fd, link1_fd = -1, link2_fd = -1;
+	struct kprobe_multi *skel = NULL;
+	LIBBPF_OPTS(bpf_link_create_opts, opts);
+	unsigned long long addrs[8];
+	__u64 cookies[8];
+
+	if (!ASSERT_OK(load_kallsyms(), "load_kallsyms"))
+		goto cleanup;
+
+	skel = kprobe_multi__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fentry_raw_skel_load"))
+		goto cleanup;
+
+	skel->bss->pid = getpid();
+	skel->bss->test_cookie = true;
+
+#define GET_ADDR(__sym, __addr) ({				\
+	__addr = ksym_get_addr(__sym);				\
+	if (!ASSERT_NEQ(__addr, 0, "ksym_get_addr " #__sym))	\
+		goto cleanup;					\
+})
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
+#undef GET_ADDR
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
+	opts.kprobe_multi.addrs = (const unsigned long *) &addrs;
+	opts.kprobe_multi.cnt = ARRAY_SIZE(addrs);
+	opts.kprobe_multi.cookies = (const __u64 *) &cookies;
+	prog_fd = bpf_program__fd(skel->progs.test_kprobe);
+
+	link1_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_KPROBE_MULTI, &opts);
+	if (!ASSERT_GE(link1_fd, 0, "link1_fd"))
+		goto cleanup;
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
+	opts.kprobe_multi.flags = BPF_F_KPROBE_MULTI_RETURN;
+	prog_fd = bpf_program__fd(skel->progs.test_kretprobe);
+
+	link2_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_KPROBE_MULTI, &opts);
+	if (!ASSERT_GE(link2_fd, 0, "link2_fd"))
+		goto cleanup;
+
+	kprobe_multi_test_run(skel);
+
+cleanup:
+	close(link1_fd);
+	close(link2_fd);
+	kprobe_multi__destroy(skel);
+}
+
 static void uprobe_subtest(struct test_bpf_cookie *skel)
 {
 	DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
@@ -249,6 +356,8 @@ void test_bpf_cookie(void)
 
 	if (test__start_subtest("kprobe"))
 		kprobe_subtest(skel);
+	if (test__start_subtest("multi_kprobe_link_api"))
+		kprobe_multi_link_api_subtest();
 	if (test__start_subtest("uprobe"))
 		uprobe_subtest(skel);
 	if (test__start_subtest("tracepoint"))
diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi.c b/tools/testing/selftests/bpf/progs/kprobe_multi.c
index 6616c082c8c2..af27d2c6fce8 100644
--- a/tools/testing/selftests/bpf/progs/kprobe_multi.c
+++ b/tools/testing/selftests/bpf/progs/kprobe_multi.c
@@ -16,6 +16,7 @@ extern const void bpf_fentry_test7 __ksym;
 extern const void bpf_fentry_test8 __ksym;
 
 int pid = 0;
+bool test_cookie = false;
 
 __u64 kprobe_test1_result = 0;
 __u64 kprobe_test2_result = 0;
@@ -40,31 +41,33 @@ static void kprobe_multi_check(void *ctx, bool is_return)
 	if (bpf_get_current_pid_tgid() >> 32 != pid)
 		return;
 
+	__u64 cookie = test_cookie ? bpf_get_attach_cookie(ctx) : 0;
 	__u64 addr = bpf_get_func_ip(ctx);
 
-#define SET(__var, __addr) ({			\
-	if ((const void *) addr == __addr) 	\
-		__var = 1;			\
+#define SET(__var, __addr, __cookie) ({			\
+	if (((const void *) addr == __addr) &&		\
+	     (!test_cookie || (cookie == __cookie)))	\
+		__var = 1;				\
 })
 
 	if (is_return) {
-		SET(kretprobe_test1_result, &bpf_fentry_test1);
-		SET(kretprobe_test2_result, &bpf_fentry_test2);
-		SET(kretprobe_test3_result, &bpf_fentry_test3);
-		SET(kretprobe_test4_result, &bpf_fentry_test4);
-		SET(kretprobe_test5_result, &bpf_fentry_test5);
-		SET(kretprobe_test6_result, &bpf_fentry_test6);
-		SET(kretprobe_test7_result, &bpf_fentry_test7);
-		SET(kretprobe_test8_result, &bpf_fentry_test8);
+		SET(kretprobe_test1_result, &bpf_fentry_test1, 8);
+		SET(kretprobe_test2_result, &bpf_fentry_test2, 7);
+		SET(kretprobe_test3_result, &bpf_fentry_test3, 6);
+		SET(kretprobe_test4_result, &bpf_fentry_test4, 5);
+		SET(kretprobe_test5_result, &bpf_fentry_test5, 4);
+		SET(kretprobe_test6_result, &bpf_fentry_test6, 3);
+		SET(kretprobe_test7_result, &bpf_fentry_test7, 2);
+		SET(kretprobe_test8_result, &bpf_fentry_test8, 1);
 	} else {
-		SET(kprobe_test1_result, &bpf_fentry_test1);
-		SET(kprobe_test2_result, &bpf_fentry_test2);
-		SET(kprobe_test3_result, &bpf_fentry_test3);
-		SET(kprobe_test4_result, &bpf_fentry_test4);
-		SET(kprobe_test5_result, &bpf_fentry_test5);
-		SET(kprobe_test6_result, &bpf_fentry_test6);
-		SET(kprobe_test7_result, &bpf_fentry_test7);
-		SET(kprobe_test8_result, &bpf_fentry_test8);
+		SET(kprobe_test1_result, &bpf_fentry_test1, 1);
+		SET(kprobe_test2_result, &bpf_fentry_test2, 2);
+		SET(kprobe_test3_result, &bpf_fentry_test3, 3);
+		SET(kprobe_test4_result, &bpf_fentry_test4, 4);
+		SET(kprobe_test5_result, &bpf_fentry_test5, 5);
+		SET(kprobe_test6_result, &bpf_fentry_test6, 6);
+		SET(kprobe_test7_result, &bpf_fentry_test7, 7);
+		SET(kprobe_test8_result, &bpf_fentry_test8, 8);
 	}
 
 #undef SET
-- 
2.35.1

