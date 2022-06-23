Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6543558938
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbiFWTjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiFWTi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:38:56 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFB14D274;
        Thu, 23 Jun 2022 12:27:28 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q18so70597pld.13;
        Thu, 23 Jun 2022 12:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D2sxqLZYXnPRjeEx9wcH9R9PE3Wo6hu5Id1mFebWswI=;
        b=kztuVDHWUvLYUivYt8JhsUyQER4TTyIAoz28n6IlCRmZBQ4Rkna+1GYm2WobZ/h284
         CeM/uZnxs6Ci/ke6udl2LhZmoHEngc8ma7eE1KPohI9OhW220ZYTH23Vz4Na7v9jKtJb
         skLxEKdngvoJF9nxwXClvXH5P7U287+m428GL5TN2krEHWichKEuWUJPR1eRjfTF2AZM
         TaSsyMn8iKSFuXEMXh4eEIj2C+I8dvm1eHnzPvs7EzxZ0Y6z5n0xbye5AgV0BN32K7hh
         lgAVc7CXC9oZMpXaFFz6wLBn5E67nMnzWccaIJVEdHi+IHPgWSETeUBEOAKvopzJ0u7D
         xkVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D2sxqLZYXnPRjeEx9wcH9R9PE3Wo6hu5Id1mFebWswI=;
        b=oAE3U5S61qJBUVVBJneP8wLF+iUB6SGJ7hQVh26rbh3CWAubhZYfr9KBQaufuQMvQ4
         ktDJR2DUbL9xpTuu/Vyhrov+yYjKL32xzgcJP3aHsGd5DYPSUSWXuwSSJf0kN6p3aeDm
         xq+Up0k7sJxVLTrQjYOOJsV2K9d75c5Emt/mq5IGiJSPlJC3eaqPzO0p0sbNOcl5nh0S
         vAxgWoWya4Kx66a/sppKj899wLq+SuCpVkPrBJevs15YoOgFI4PrkUd5xx4TD+No+fak
         GiQVocPp8AXN3h9CyeuvemCriez3WhfHkrzKIgFMaaLBbmLROgAOLWACWaN8SJJxrwrs
         fJQQ==
X-Gm-Message-State: AJIora+/fkrkh71yf/Sh8sFQ16o0IgKCgaiPPNA9sNYT3dJTQXS+H5ca
        JVdeVv6vhuig2isIMBg4hroJHCK54p9sug==
X-Google-Smtp-Source: AGRyM1s8NBl8z0y+FZyMS91I41bGUF9l2qub6ncxoQ/DWcBoGMjqZ1YEuB8KqbLcNHQTk9bmU/5O3g==
X-Received: by 2002:a17:90a:aa10:b0:1ec:b5a7:9e23 with SMTP id k16-20020a17090aaa1000b001ecb5a79e23mr5644871pjq.191.1656012448037;
        Thu, 23 Jun 2022 12:27:28 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0c0:79de:f3f4:353c:8616])
        by smtp.gmail.com with ESMTPSA id y14-20020a62ce0e000000b0050dc762819esm8721pfg.120.2022.06.23.12.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 12:27:27 -0700 (PDT)
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
Subject: [PATCH bpf-next v5 8/8] selftests/bpf: Add negative tests for new nf_conntrack kfuncs
Date:   Fri, 24 Jun 2022 00:56:37 +0530
Message-Id: <20220623192637.3866852-9-memxor@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623192637.3866852-1-memxor@gmail.com>
References: <20220623192637.3866852-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7143; h=from:subject; bh=uxV8IMMZH4rmuVusntxt0oWQl91ETVFvr9aNiCZIaEM=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBitL5MTKbFaPiwGcW8b1ZciD4yWQMFVzM20P518T5k AxaBsKCJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYrS+TAAKCRBM4MiGSL8RynurEA CbwlkDMiIRpmweoQvM8u/+EP/CRKS/GUkaOOwgQq3FT/VMLTOCa7ksAtvE6YZCKp/dcwletroqLl+F Bw9fnvSPc0tDaDQr76qezlUUK1ChL0LNySmjk1Z/C0zNHucNHmL9qGzw6CWu4M4dS5rFAvezSywBvw 6AX6V2q/5tnGOZLTrWlgHzD4vKo16/WWcDdyNbDg85lYfFX3/s2sNCbCkugmhAtkLkDsNcqyKQZ3e0 J/JrtpgwIyWFKsLm9qXi7mEe8j29BV4DFwKCF1MdP2RCQhzinaxv+5tn9ERm/BE5v7VmbLbeV21vc4 VDX5rRZvo7f8iTj0m5VWKcMK69/tsDeEHyzx1tBQOyF5W2lBJuwXPDTbiAClTZilW0SCtqH91nS5ZI t3YECp37RzI9nIWlX+RU3+RmIk7NHG++J03c4VMCCwFZAJsVmlQIZQYakMmP4MGkwvo8bkljax2Y2t M/rlB337iGOYn4NPihl621eBSnhu4+4pqCFtp4udNXkiegKcYIzjGXk5ZPF05D7CXMRiQxTfGDQFEY fs5pTvMu4w48lx7mQDvvGk19ltZOZZ7pcTVZaRHXMdIqbgEP+2wqIUo2pOzRsBT9OuHq7PCDZWS8Cw yAoetrl6edIs1KdLhd1N3m+Qjx5icZU1RRRAeVhTyozZfWmdp6BOnNtVfL1Q==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 6d53686a7e46..69877a16f42d 100644
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
2.36.1

