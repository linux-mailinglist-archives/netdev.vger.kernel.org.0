Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEAE24DAFC2
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355842AbiCPM2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355798AbiCPM22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:28:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CC866617;
        Wed, 16 Mar 2022 05:27:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50971B81ADD;
        Wed, 16 Mar 2022 12:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB49C340E9;
        Wed, 16 Mar 2022 12:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647433618;
        bh=tiIpHON3TQ0N7FkXLFvqTVEpozXpr6gg7cYwBCMcnwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W49kjns6ZV+4IlUsja53J9jz5T0t72tMevw2vwdhQgDzsHyrRUAmr0f4kYcUow6qK
         2hbeKSXDicCnbor6EmLm9OqzBm7fKXsXQx7Fc1VUb4rkAB+heV264dyf7J+ElB2wrw
         VVve1hzCms6SMvnfeYYY5HS6/mWo6PkK7jXUPK/t3p+7XaD5tpauRB7Yu/clFJG6oU
         MFMjx8WNum9ysyIITJj2/Rgodc+Q1BhuNk7fCXEBxKYLhN2fzEsVs8mjBjMEH2Zt/o
         rQzVYJLCJ3yfhxgj43i5owCdHApHLGYG89vQIlp05bgSFrXzAlaqgV1eN3FfvK7omk
         IZJRdk8Ora6sQ==
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
Subject: [PATCHv3 bpf-next 13/13] selftests/bpf: Add cookie test for bpf_program__attach_kprobe_multi_opts
Date:   Wed, 16 Mar 2022 13:24:19 +0100
Message-Id: <20220316122419.933957-14-jolsa@kernel.org>
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

Adding bpf_cookie test for programs attached by
bpf_program__attach_kprobe_multi_opts API.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/bpf_cookie.c     | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
index 6671d4dc0b5d..923a6139b2d8 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
@@ -170,6 +170,72 @@ static void kprobe_multi_link_api_subtest(void)
 	kprobe_multi__destroy(skel);
 }
 
+static void kprobe_multi_attach_api_subtest(void)
+{
+	struct bpf_link *link1 = NULL, *link2 = NULL;
+	LIBBPF_OPTS(bpf_kprobe_multi_opts, opts);
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+	struct kprobe_multi *skel = NULL;
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
+	__u64 cookies[8];
+
+	skel = kprobe_multi__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fentry_raw_skel_load"))
+		goto cleanup;
+
+	skel->bss->pid = getpid();
+	skel->bss->test_cookie = true;
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
+	opts.syms = syms;
+	opts.cnt = ARRAY_SIZE(syms);
+	opts.cookies = cookies;
+
+	link1 = bpf_program__attach_kprobe_multi_opts(skel->progs.test_kprobe,
+						      NULL, &opts);
+	if (!ASSERT_OK_PTR(link1, "bpf_program__attach_kprobe_multi_opts"))
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
+	opts.retprobe = true;
+
+	link2 = bpf_program__attach_kprobe_multi_opts(skel->progs.test_kretprobe,
+						      NULL, &opts);
+	if (!ASSERT_OK_PTR(link2, "bpf_program__attach_kprobe_multi_opts"))
+		goto cleanup;
+
+	kprobe_multi_test_run(skel);
+
+cleanup:
+	bpf_link__destroy(link2);
+	bpf_link__destroy(link1);
+	kprobe_multi__destroy(skel);
+}
 static void uprobe_subtest(struct test_bpf_cookie *skel)
 {
 	DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
@@ -358,6 +424,8 @@ void test_bpf_cookie(void)
 		kprobe_subtest(skel);
 	if (test__start_subtest("multi_kprobe_link_api"))
 		kprobe_multi_link_api_subtest();
+	if (test__start_subtest("multi_kprobe_attach_api"))
+		kprobe_multi_attach_api_subtest();
 	if (test__start_subtest("uprobe"))
 		uprobe_subtest(skel);
 	if (test__start_subtest("tracepoint"))
-- 
2.35.1

