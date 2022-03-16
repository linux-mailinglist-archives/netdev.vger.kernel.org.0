Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4D34DAFBD
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355758AbiCPM2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239568AbiCPM2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:28:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E651E6581E;
        Wed, 16 Mar 2022 05:26:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C9886172E;
        Wed, 16 Mar 2022 12:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57385C340E9;
        Wed, 16 Mar 2022 12:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647433606;
        bh=66R3zZj85jSysiXBEgXB0opsMdpMlVAcGjh+SYQrebs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMSC7At9eC9t3Cbe6G9kHyDm3ScxGHQXXAE7fepmqoNrIiyCifCRAPZ8e862h3hix
         8o8ZfiW63SgFHQya6G66vTC7rhKo3J7KZOhWTZbFdBjw5lLpFNd8I32pnjMGv0XjD4
         h9M7O/tktc/u7V83y7+t8ImsTp7aV5DO63Ip26aMaGbg6R1QLVFPv1+44a1gvleAdi
         heyurH33DpxBW+Pfe5vl0dNSfDQoTusFsij10syUQxQDZcC+nxvG0KJhNbm33gHuW0
         1AQok1aVyOROOUzmTygxT2u2rJNLP4GzGq4v662A/g6KdRGBXKfkjV4SmAgp7fTvO9
         ekDVgbAncPPZQ==
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
Subject: [PATCHv3 bpf-next 12/13] selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts
Date:   Wed, 16 Mar 2022 13:24:18 +0100
Message-Id: <20220316122419.933957-13-jolsa@kernel.org>
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

Adding tests for bpf_program__attach_kprobe_multi_opts function,
that test attach with pattern, symbols and addrs.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/kprobe_multi_test.c        | 204 +++++++++++++++++-
 1 file changed, 193 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index ded6b8c8ec05..b9876b55fc0c 100644
--- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -3,7 +3,7 @@
 #include "kprobe_multi.skel.h"
 #include "trace_helpers.h"
 
-static void kprobe_multi_test_run(struct kprobe_multi *skel)
+static void kprobe_multi_test_run(struct kprobe_multi *skel, bool test_return)
 {
 	LIBBPF_OPTS(bpf_test_run_opts, topts);
 	int err, prog_fd;
@@ -22,14 +22,16 @@ static void kprobe_multi_test_run(struct kprobe_multi *skel)
 	ASSERT_EQ(skel->bss->kprobe_test7_result, 1, "kprobe_test7_result");
 	ASSERT_EQ(skel->bss->kprobe_test8_result, 1, "kprobe_test8_result");
 
-	ASSERT_EQ(skel->bss->kretprobe_test1_result, 1, "kretprobe_test1_result");
-	ASSERT_EQ(skel->bss->kretprobe_test2_result, 1, "kretprobe_test2_result");
-	ASSERT_EQ(skel->bss->kretprobe_test3_result, 1, "kretprobe_test3_result");
-	ASSERT_EQ(skel->bss->kretprobe_test4_result, 1, "kretprobe_test4_result");
-	ASSERT_EQ(skel->bss->kretprobe_test5_result, 1, "kretprobe_test5_result");
-	ASSERT_EQ(skel->bss->kretprobe_test6_result, 1, "kretprobe_test6_result");
-	ASSERT_EQ(skel->bss->kretprobe_test7_result, 1, "kretprobe_test7_result");
-	ASSERT_EQ(skel->bss->kretprobe_test8_result, 1, "kretprobe_test8_result");
+	if (test_return) {
+		ASSERT_EQ(skel->bss->kretprobe_test1_result, 1, "kretprobe_test1_result");
+		ASSERT_EQ(skel->bss->kretprobe_test2_result, 1, "kretprobe_test2_result");
+		ASSERT_EQ(skel->bss->kretprobe_test3_result, 1, "kretprobe_test3_result");
+		ASSERT_EQ(skel->bss->kretprobe_test4_result, 1, "kretprobe_test4_result");
+		ASSERT_EQ(skel->bss->kretprobe_test5_result, 1, "kretprobe_test5_result");
+		ASSERT_EQ(skel->bss->kretprobe_test6_result, 1, "kretprobe_test6_result");
+		ASSERT_EQ(skel->bss->kretprobe_test7_result, 1, "kretprobe_test7_result");
+		ASSERT_EQ(skel->bss->kretprobe_test8_result, 1, "kretprobe_test8_result");
+	}
 }
 
 static void test_skel_api(void)
@@ -46,7 +48,7 @@ static void test_skel_api(void)
 	if (!ASSERT_OK(err, "kprobe_multi__attach"))
 		goto cleanup;
 
-	kprobe_multi_test_run(skel);
+	kprobe_multi_test_run(skel, true);
 
 cleanup:
 	kprobe_multi__destroy(skel);
@@ -73,7 +75,7 @@ static void test_link_api(struct bpf_link_create_opts *opts)
 	if (!ASSERT_GE(link2_fd, 0, "link_fd"))
 		goto cleanup;
 
-	kprobe_multi_test_run(skel);
+	kprobe_multi_test_run(skel, true);
 
 cleanup:
 	if (link1_fd != -1)
@@ -127,6 +129,178 @@ static void test_link_api_syms(void)
 	test_link_api(&opts);
 }
 
+static void
+test_attach_api(const char *pattern, struct bpf_kprobe_multi_opts *opts)
+{
+	struct bpf_link *link1 = NULL, *link2 = NULL;
+	struct kprobe_multi *skel = NULL;
+
+	skel = kprobe_multi__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fentry_raw_skel_load"))
+		goto cleanup;
+
+	skel->bss->pid = getpid();
+	link1 = bpf_program__attach_kprobe_multi_opts(skel->progs.test_kprobe,
+						      pattern, opts);
+	if (!ASSERT_OK_PTR(link1, "bpf_program__attach_kprobe_multi_opts"))
+		goto cleanup;
+
+	if (opts) {
+		opts->retprobe = true;
+		link2 = bpf_program__attach_kprobe_multi_opts(skel->progs.test_kretprobe,
+							      pattern, opts);
+		if (!ASSERT_OK_PTR(link2, "bpf_program__attach_kprobe_multi_opts"))
+			goto cleanup;
+	}
+
+	kprobe_multi_test_run(skel, !!opts);
+
+cleanup:
+	bpf_link__destroy(link2);
+	bpf_link__destroy(link1);
+	kprobe_multi__destroy(skel);
+}
+
+static void test_attach_api_pattern(void)
+{
+	LIBBPF_OPTS(bpf_kprobe_multi_opts, opts);
+
+	test_attach_api("bpf_fentry_test*", &opts);
+	test_attach_api("bpf_fentry_test?", NULL);
+}
+
+static void test_attach_api_addrs(void)
+{
+	LIBBPF_OPTS(bpf_kprobe_multi_opts, opts);
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
+	opts.addrs = (const unsigned long *) addrs;
+	opts.cnt = ARRAY_SIZE(addrs);
+	test_attach_api(NULL, &opts);
+}
+
+static void test_attach_api_syms(void)
+{
+	LIBBPF_OPTS(bpf_kprobe_multi_opts, opts);
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
+	opts.syms = syms;
+	opts.cnt = ARRAY_SIZE(syms);
+	test_attach_api(NULL, &opts);
+}
+
+static void test_attach_api_fails(void)
+{
+	LIBBPF_OPTS(bpf_kprobe_multi_opts, opts);
+	struct kprobe_multi *skel = NULL;
+	struct bpf_link *link = NULL;
+	unsigned long long addrs[2];
+	const char *syms[2] = {
+		"bpf_fentry_test1",
+		"bpf_fentry_test2",
+	};
+	__u64 cookies[2];
+
+	addrs[0] = ksym_get_addr("bpf_fentry_test1");
+	addrs[1] = ksym_get_addr("bpf_fentry_test2");
+
+	if (!ASSERT_FALSE(!addrs[0] || !addrs[1], "ksym_get_addr"))
+		goto cleanup;
+
+	skel = kprobe_multi__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fentry_raw_skel_load"))
+		goto cleanup;
+
+	skel->bss->pid = getpid();
+
+	/* fail_1 - pattern and opts NULL */
+	link = bpf_program__attach_kprobe_multi_opts(skel->progs.test_kprobe,
+						     NULL, NULL);
+	if (!ASSERT_ERR_PTR(link, "fail_1"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(libbpf_get_error(link), -EINVAL, "fail_1_error"))
+		goto cleanup;
+
+	/* fail_2 - both addrs and syms set */
+	opts.addrs = (const unsigned long *) addrs;
+	opts.syms = syms;
+	opts.cnt = ARRAY_SIZE(syms);
+	opts.cookies = NULL;
+
+	link = bpf_program__attach_kprobe_multi_opts(skel->progs.test_kprobe,
+						     NULL, &opts);
+	if (!ASSERT_ERR_PTR(link, "fail_2"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(libbpf_get_error(link), -EINVAL, "fail_2_error"))
+		goto cleanup;
+
+	/* fail_3 - pattern and addrs set */
+	opts.addrs = (const unsigned long *) addrs;
+	opts.syms = NULL;
+	opts.cnt = ARRAY_SIZE(syms);
+	opts.cookies = NULL;
+
+	link = bpf_program__attach_kprobe_multi_opts(skel->progs.test_kprobe,
+						     "ksys_*", &opts);
+	if (!ASSERT_ERR_PTR(link, "fail_3"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(libbpf_get_error(link), -EINVAL, "fail_3_error"))
+		goto cleanup;
+
+	/* fail_4 - pattern and cnt set */
+	opts.addrs = NULL;
+	opts.syms = NULL;
+	opts.cnt = ARRAY_SIZE(syms);
+	opts.cookies = NULL;
+
+	link = bpf_program__attach_kprobe_multi_opts(skel->progs.test_kprobe,
+						     "ksys_*", &opts);
+	if (!ASSERT_ERR_PTR(link, "fail_4"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(libbpf_get_error(link), -EINVAL, "fail_4_error"))
+		goto cleanup;
+
+	/* fail_5 - pattern and cookies */
+	opts.addrs = NULL;
+	opts.syms = NULL;
+	opts.cnt = 0;
+	opts.cookies = cookies;
+
+	link = bpf_program__attach_kprobe_multi_opts(skel->progs.test_kprobe,
+						     "ksys_*", &opts);
+	if (!ASSERT_ERR_PTR(link, "fail_5"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(libbpf_get_error(link), -EINVAL, "fail_5_error"))
+		goto cleanup;
+
+cleanup:
+	bpf_link__destroy(link);
+	kprobe_multi__destroy(skel);
+}
+
 void test_kprobe_multi_test(void)
 {
 	if (!ASSERT_OK(load_kallsyms(), "load_kallsyms"))
@@ -138,4 +312,12 @@ void test_kprobe_multi_test(void)
 		test_link_api_syms();
 	if (test__start_subtest("link_api_syms"))
 		test_link_api_addrs();
+	if (test__start_subtest("attach_api_pattern"))
+		test_attach_api_pattern();
+	if (test__start_subtest("attach_api_addrs"))
+		test_attach_api_addrs();
+	if (test__start_subtest("attach_api_syms"))
+		test_attach_api_syms();
+	if (test__start_subtest("attach_api_fails"))
+		test_attach_api_fails();
 }
-- 
2.35.1

