Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C26357CC67
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiGUNot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiGUNnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:43:41 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BBF84ED3;
        Thu, 21 Jul 2022 06:43:04 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id v5so1091467wmj.0;
        Thu, 21 Jul 2022 06:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b9IGdu44vIQhiDdyqYUwInJvoHZ34VCzR5hVYbDWwvA=;
        b=jfeeCIB8GONRyCx8yYFOPaQTQzaWdJsOCpVaNuxicaB1LZbDtkzAbVi7dLQTRaGNBX
         Phz/mNmxsyQYDBZQYsekNXkyOP0hC2bDOvpYgtjJHacUiMmPNkJW8mNZ87MJ3fXUnh9h
         Jz5eftH9Y72cb/ooOyAYih5iWzD2rlO9frTNDgSYxvU5/EA57taEgyFgJugLJRi6Q1Uv
         paxB2HCmtl7o7aHz3UpBIV2Guh2I2HvmcCDV40Jj8SDoQumsMVRBLRaTRjFpAQDVyKYR
         kDQ5CgIkoqGyP8AxrEiMOJdB8DcIGVyEY8ihvtN/GQyC26L3xZZvoni2G8uJ8og5Uh2C
         ncqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b9IGdu44vIQhiDdyqYUwInJvoHZ34VCzR5hVYbDWwvA=;
        b=FD38I0e1qM1Bmq3EKfyAa7DIsIHJEliEhyozLbfYNyW6h8aQT6KZpBI1JkZi8BSqw1
         05skuEHqn4s1hgvUaAVjfHd8QjykDItG1U0BpdKaKQcnvNOX/EsRLR9AUW/teKJyNKKV
         nmSEJiGIfmaysqV1Yyc55WkIv82a34VBrzM65IlpsbepXWyQh56Cq9DmRCkDyhsPUrNn
         I5+GTt7/DahNJs8+JN19V0hlt970jkKVitVKXI3itlbDB65lHPAwfcRbQ/cHDH5pmtwY
         rNmEJhsSwOK4Rzfk/cZ4YSwI5E+FrZK9d2u1Rd9JCMHzLqbA4UO1A3qlHdtHsOPtid+Z
         imWg==
X-Gm-Message-State: AJIora8AqbxKC//90gXNVR+LN2IgsFDsODj01ezqpeZAzJYg1XwWJ+i+
        YhpbqtWEfX7lgg58TVBDO92cRDChijLelw==
X-Google-Smtp-Source: AGRyM1t2cdhDxKD6EtqwKPFRchU8XyphTdtil/MtBoQw4yuKsOwH3u+/yKIkSfVYK0iEX8Scq/0MCQ==
X-Received: by 2002:a1c:f607:0:b0:3a0:3dc9:c4db with SMTP id w7-20020a1cf607000000b003a03dc9c4dbmr8598747wmc.30.1658410983045;
        Thu, 21 Jul 2022 06:43:03 -0700 (PDT)
Received: from localhost (212.191.202.62.dynamic.cgnat.res.cust.swisscom.ch. [62.202.191.212])
        by smtp.gmail.com with ESMTPSA id i6-20020a5d5226000000b0021d6d9c0bd9sm1978871wra.82.2022.07.21.06.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:43:02 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v7 12/13] selftests/bpf: Add negative tests for new nf_conntrack kfuncs
Date:   Thu, 21 Jul 2022 15:42:44 +0200
Message-Id: <20220721134245.2450-13-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220721134245.2450-1-memxor@gmail.com>
References: <20220721134245.2450-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7143; i=memxor@gmail.com; h=from:subject; bh=5LcT2LZrEhjoAiEPR4V8pZ6D9kYF7/wjj/hDJlCMNNY=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi2VfOVrdejOOcHIycoxy5z5ZvoPl7G3z81nWF9S3e Bt3swsOJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtlXzgAKCRBM4MiGSL8RytkVEA C3H9Ci7SUYNNLyQjwn5uWKdHXDTyQ3z+iARG9vySWOsw9QROYDrHG1khDoTbwV9SfFU1edfU78+Rsp jLq1uCA2Z4nadw/V0Guktd74DJuUsJOExsHLEM0gAfocPYw4RRe+rpvkEHB8K79GerMAn9OSk0irGv 0a9ZNQE50rurxVENpa4gSQWSTqv+3raKmuxuoFdNQCEz0ohwKM1AV16/9M+G7VfYhNYvleix5NR8oa 1LHVtuIQsPVzpcqfzp8bGasKF14MBQY3ieCfcawHVFSRtafwnHdOPRklMeRKE7FqsxZGqXilzHUqlM FVf35XoSnwxvM83P6wT/RIFiVjehxc7iFNUVQsosr25qFlB5RhI1VBQ/nYHHr8ADUI/ZcS6wTJMqil FOe5XhA/EXdwoDiHgj5SJVTxU2psPsPhFRC64/Nj3r4pjOoVimJZTZbViftVOfOSqepAzTtq4PTUb5 JYd/nExRI3KSKc5daiHh+n41xEadPhuGL37gunD52Q/Ca5pGS4NOLqfknoFLm4EnHonjXCWPKHqDvW PimE/6B3vHWXfv7bEHkII+8VbITZ2dY4kFWuFrKuOm/Qeoa4ROeKtYE6zgnqESBHf8STjP2EewqxHO uR/DWfnwyig82Vl+cgssJi9X61DLncDs/KQygAaUIi0aSOJofPtkIpc4pv2w==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test cases we care about and ensure improper usage is caught and
rejected by the verifier.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  56 +++++++-
 .../selftests/bpf/progs/test_bpf_nf_fail.c    | 134 ++++++++++++++++++
 2 files changed, 189 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index cbada73a61f8..7a74a1579076 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -2,13 +2,29 @@
 #include <test_progs.h>
 #include <network_helpers.h>
 #include "test_bpf_nf.skel.h"
+#include "test_bpf_nf_fail.skel.h"
+
+static char log_buf[1024 * 1024];
+
+struct {
+	const char *prog_name;
+	const char *err_msg;
+} test_bpf_nf_fail_tests[] = {
+	{ "alloc_release", "kernel function bpf_ct_release args#0 expected pointer to STRUCT nf_conn but" },
+	{ "insert_insert", "kernel function bpf_ct_insert_entry args#0 expected pointer to STRUCT nf_conn___init but" },
+	{ "lookup_insert", "kernel function bpf_ct_insert_entry args#0 expected pointer to STRUCT nf_conn___init but" },
+	{ "set_timeout_after_insert", "kernel function bpf_ct_set_timeout args#0 expected pointer to STRUCT nf_conn___init but" },
+	{ "set_status_after_insert", "kernel function bpf_ct_set_status args#0 expected pointer to STRUCT nf_conn___init but" },
+	{ "change_timeout_after_alloc", "kernel function bpf_ct_change_timeout args#0 expected pointer to STRUCT nf_conn but" },
+	{ "change_status_after_alloc", "kernel function bpf_ct_change_status args#0 expected pointer to STRUCT nf_conn but" },
+};
 
 enum {
 	TEST_XDP,
 	TEST_TC_BPF,
 };
 
-void test_bpf_nf_ct(int mode)
+static void test_bpf_nf_ct(int mode)
 {
 	struct test_bpf_nf *skel;
 	int prog_fd, err;
@@ -51,10 +67,48 @@ void test_bpf_nf_ct(int mode)
 	test_bpf_nf__destroy(skel);
 }
 
+static void test_bpf_nf_ct_fail(const char *prog_name, const char *err_msg)
+{
+	LIBBPF_OPTS(bpf_object_open_opts, opts, .kernel_log_buf = log_buf,
+						.kernel_log_size = sizeof(log_buf),
+						.kernel_log_level = 1);
+	struct test_bpf_nf_fail *skel;
+	struct bpf_program *prog;
+	int ret;
+
+	skel = test_bpf_nf_fail__open_opts(&opts);
+	if (!ASSERT_OK_PTR(skel, "test_bpf_nf_fail__open"))
+		return;
+
+	prog = bpf_object__find_program_by_name(skel->obj, prog_name);
+	if (!ASSERT_OK_PTR(prog, "bpf_object__find_program_by_name"))
+		goto end;
+
+	bpf_program__set_autoload(prog, true);
+
+	ret = test_bpf_nf_fail__load(skel);
+	if (!ASSERT_ERR(ret, "test_bpf_nf_fail__load must fail"))
+		goto end;
+
+	if (!ASSERT_OK_PTR(strstr(log_buf, err_msg), "expected error message")) {
+		fprintf(stderr, "Expected: %s\n", err_msg);
+		fprintf(stderr, "Verifier: %s\n", log_buf);
+	}
+
+end:
+	test_bpf_nf_fail__destroy(skel);
+}
+
 void test_bpf_nf(void)
 {
+	int i;
 	if (test__start_subtest("xdp-ct"))
 		test_bpf_nf_ct(TEST_XDP);
 	if (test__start_subtest("tc-bpf-ct"))
 		test_bpf_nf_ct(TEST_TC_BPF);
+	for (i = 0; i < ARRAY_SIZE(test_bpf_nf_fail_tests); i++) {
+		if (test__start_subtest(test_bpf_nf_fail_tests[i].prog_name))
+			test_bpf_nf_ct_fail(test_bpf_nf_fail_tests[i].prog_name,
+					    test_bpf_nf_fail_tests[i].err_msg);
+	}
 }
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c b/tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c
new file mode 100644
index 000000000000..bf79af15c808
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+
+struct nf_conn;
+
+struct bpf_ct_opts___local {
+	s32 netns_id;
+	s32 error;
+	u8 l4proto;
+	u8 reserved[3];
+} __attribute__((preserve_access_index));
+
+struct nf_conn *bpf_skb_ct_alloc(struct __sk_buff *, struct bpf_sock_tuple *, u32,
+				 struct bpf_ct_opts___local *, u32) __ksym;
+struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
+				  struct bpf_ct_opts___local *, u32) __ksym;
+struct nf_conn *bpf_ct_insert_entry(struct nf_conn *) __ksym;
+void bpf_ct_release(struct nf_conn *) __ksym;
+void bpf_ct_set_timeout(struct nf_conn *, u32) __ksym;
+int bpf_ct_change_timeout(struct nf_conn *, u32) __ksym;
+int bpf_ct_set_status(struct nf_conn *, u32) __ksym;
+int bpf_ct_change_status(struct nf_conn *, u32) __ksym;
+
+SEC("?tc")
+int alloc_release(struct __sk_buff *ctx)
+{
+	struct bpf_ct_opts___local opts = {};
+	struct bpf_sock_tuple tup = {};
+	struct nf_conn *ct;
+
+	ct = bpf_skb_ct_alloc(ctx, &tup, sizeof(tup.ipv4), &opts, sizeof(opts));
+	if (!ct)
+		return 0;
+	bpf_ct_release(ct);
+	return 0;
+}
+
+SEC("?tc")
+int insert_insert(struct __sk_buff *ctx)
+{
+	struct bpf_ct_opts___local opts = {};
+	struct bpf_sock_tuple tup = {};
+	struct nf_conn *ct;
+
+	ct = bpf_skb_ct_alloc(ctx, &tup, sizeof(tup.ipv4), &opts, sizeof(opts));
+	if (!ct)
+		return 0;
+	ct = bpf_ct_insert_entry(ct);
+	if (!ct)
+		return 0;
+	ct = bpf_ct_insert_entry(ct);
+	return 0;
+}
+
+SEC("?tc")
+int lookup_insert(struct __sk_buff *ctx)
+{
+	struct bpf_ct_opts___local opts = {};
+	struct bpf_sock_tuple tup = {};
+	struct nf_conn *ct;
+
+	ct = bpf_skb_ct_lookup(ctx, &tup, sizeof(tup.ipv4), &opts, sizeof(opts));
+	if (!ct)
+		return 0;
+	bpf_ct_insert_entry(ct);
+	return 0;
+}
+
+SEC("?tc")
+int set_timeout_after_insert(struct __sk_buff *ctx)
+{
+	struct bpf_ct_opts___local opts = {};
+	struct bpf_sock_tuple tup = {};
+	struct nf_conn *ct;
+
+	ct = bpf_skb_ct_alloc(ctx, &tup, sizeof(tup.ipv4), &opts, sizeof(opts));
+	if (!ct)
+		return 0;
+	ct = bpf_ct_insert_entry(ct);
+	if (!ct)
+		return 0;
+	bpf_ct_set_timeout(ct, 0);
+	return 0;
+}
+
+SEC("?tc")
+int set_status_after_insert(struct __sk_buff *ctx)
+{
+	struct bpf_ct_opts___local opts = {};
+	struct bpf_sock_tuple tup = {};
+	struct nf_conn *ct;
+
+	ct = bpf_skb_ct_alloc(ctx, &tup, sizeof(tup.ipv4), &opts, sizeof(opts));
+	if (!ct)
+		return 0;
+	ct = bpf_ct_insert_entry(ct);
+	if (!ct)
+		return 0;
+	bpf_ct_set_status(ct, 0);
+	return 0;
+}
+
+SEC("?tc")
+int change_timeout_after_alloc(struct __sk_buff *ctx)
+{
+	struct bpf_ct_opts___local opts = {};
+	struct bpf_sock_tuple tup = {};
+	struct nf_conn *ct;
+
+	ct = bpf_skb_ct_alloc(ctx, &tup, sizeof(tup.ipv4), &opts, sizeof(opts));
+	if (!ct)
+		return 0;
+	bpf_ct_change_timeout(ct, 0);
+	return 0;
+}
+
+SEC("?tc")
+int change_status_after_alloc(struct __sk_buff *ctx)
+{
+	struct bpf_ct_opts___local opts = {};
+	struct bpf_sock_tuple tup = {};
+	struct nf_conn *ct;
+
+	ct = bpf_skb_ct_alloc(ctx, &tup, sizeof(tup.ipv4), &opts, sizeof(opts));
+	if (!ct)
+		return 0;
+	bpf_ct_change_status(ct, 0);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.1

