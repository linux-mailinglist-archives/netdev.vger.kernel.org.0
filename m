Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA8557A0BA
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbiGSOJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238509AbiGSOIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:08:09 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7AB1FCC8;
        Tue, 19 Jul 2022 06:24:49 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id y8so19583967eda.3;
        Tue, 19 Jul 2022 06:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b9IGdu44vIQhiDdyqYUwInJvoHZ34VCzR5hVYbDWwvA=;
        b=jJhI3Lb5phf/F+fZWHiU4CLdhETLQnG30QWo3u4wBfappml+o40ttaS60NQ5FFWY35
         4Jh1aMqqHUVVS60OeNK8kpFyCfvLiFPxNIK2oBuStwSazSOWjg8zeLANlxB54C4sxTX6
         9pZpiLBFhQAykLBNQ2Mb9V4PoZfhLL4V2TsOuBI3nQ1fIZGzeT231cAUx+8BC1wWVC9l
         w1QY9zRfw7Tv4JwvYxrpnpLXgpDxVlef1B2LxvPgusoRPpWQf/o59VhpByfXvg7mbkUZ
         a6mX6Ynt5aGFQOCbblQmWFCQ+RJC/0ijTC807BgtjcqKWCigS0ywjlZBLnRDdILX1Lnu
         Paww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b9IGdu44vIQhiDdyqYUwInJvoHZ34VCzR5hVYbDWwvA=;
        b=2FEJU3In5LkL025KB168DrmunNqy3/A0c+kSewUJ3betkHduPkg2AfAHEBA7sI9Lnr
         QJmyCCPtxwQT/Ic3+AaZKEq0+FZG2UfeSPsWonbfbdCxn3e+9f1DCkvyZvNLxC/rLX+t
         29NKVW7RZWQWzYZBaFc3xLMfhsdvgsCOn0ke75Q0QlvRSwnmGErsuzvjYk8P9zihro4t
         JHdf7Epn1yDzGTiv/szmmURCK8AaC7+07RVpOIHetnyfBnIDpdO3gTVbOky36uqc9BvY
         5qC2ReXawhQrO/pFNpyPhsXXEtTzfi4nyzPkjW64dbj0w2brYWUvRE9pQ65vUCfQykJf
         Ekug==
X-Gm-Message-State: AJIora8sMd2H1JX7OkaUiTDHjf3FXY2Y/NWNaCHA52n1+IyXMZDKsRok
        JEHqym/baATX787OH4D4Oz7bMjUn7hw7iQ==
X-Google-Smtp-Source: AGRyM1sKLPJ3n/btEK7eAWLgUCpUR23XIsquul9wlCplJ9QrRUPxtSwDDSa+aVsFMWMM94MVQM3Iew==
X-Received: by 2002:aa7:cd0a:0:b0:43a:8ffd:d8de with SMTP id b10-20020aa7cd0a000000b0043a8ffdd8demr43337204edw.5.1658237087697;
        Tue, 19 Jul 2022 06:24:47 -0700 (PDT)
Received: from localhost (icdhcp-1-189.epfl.ch. [128.178.116.189])
        by smtp.gmail.com with ESMTPSA id l9-20020a170906078900b00722e31fcf42sm6596668ejc.184.2022.07.19.06.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:24:47 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 12/13] selftests/bpf: Add negative tests for new nf_conntrack kfuncs
Date:   Tue, 19 Jul 2022 15:24:29 +0200
Message-Id: <20220719132430.19993-13-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719132430.19993-1-memxor@gmail.com>
References: <20220719132430.19993-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7143; i=memxor@gmail.com; h=from:subject; bh=5LcT2LZrEhjoAiEPR4V8pZ6D9kYF7/wjj/hDJlCMNNY=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi1rBmVrdejOOcHIycoxy5z5ZvoPl7G3z81nWF9S3e Bt3swsOJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtawZgAKCRBM4MiGSL8Rys1AEA CH1K8MCETteOHVrnfYtkrfOX7tfaWp8iUVHt8MmqXBkUN5IK965Zt4E6cVVsqIDO7K5JPBk6Ai57FS NmjxgWSHvPCzm+fhVS0k5b0Yywfnf9Eo4zxZwJqzZXxz20MaU2hjHjN6A/ps8PAqDSphsPU80+haGx VbSBFbUBnigBhwVrAza5GTE5mu57gNATzrKWbJhDOj4sLxpUM2jdRXtdiBy3+iXhgR95hW4uAu9lCw a6Olu6bGtbOf1E2+mGwFGItOW7teBphP7c1SBkWRFW8FeD0XMfACRc5nO3KnEolPTEJJbR4xCuStQW R5XnkX8aBlgkIE4+zLSfJ6C/+SylU+HhSbY7VzPFzZ6tLMgxEjkdeSD1xZ5L56wruZAvY3iIFjroEy stXcIJATexu8AGQmM/upeZG7mVUby1jdX+4PYtmsXrjhL430xEA0PJ2PiFgTygsj+kjr7SJgb7oEdh fYiPU9XNvrize5nB4NZ50lj71vkRdGbL3BctMUsDZIAbrh74iNDvYU2DmJx3+SgWdablcWdoww/C8E s3S9kKr6ofVZlz757+byON/aXOXDhKgMF1EPnFdSnUs3aYAO8XZCIGfGSzEeNtOUsAY0t0yOVUHGZh kBtvdpX6CWyMOJRBMeec0N9z9Bj6anWCf5zrw+yuuLqSrpj8qqUx0054g1lg==
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

