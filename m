Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC205355AD
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349229AbiEZVgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349212AbiEZVgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:36:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC35366AF8;
        Thu, 26 May 2022 14:36:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 282FB61B9C;
        Thu, 26 May 2022 21:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073BBC385B8;
        Thu, 26 May 2022 21:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653600981;
        bh=RHe/zgcc/AG0MxbXX/Obu5hneNnlfD3DUodX3MgDfH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFALLCzyM8AwrhKW5LTkKMWGZ9I7DGValV3faSC4mqpUcaZytEGT4tVD7uJmiC5SJ
         6/7GOyYftJBR+4GPzT0vhCCZjc8SWt8X+uLpv6eHrrNZXK1ok7NsM3V1nwT+EwCoHG
         b4127jNH+u40PfWQ9htun31f+Gle/joc0OrW3V1GGCH56u3zg0i4GwPv53NBQe4z/w
         zBv9efGbYINdYrRA2Ll3tXdwt6CYExrxzO++/XwPN1kFf+3bOor9ZNZ37poufC4LGz
         lpyZywCMM3LZV6vrT9PRHLcpt6qiAW01nfC2uYC3M5jJIMi9mACyA1Yx6qxtzuUMai
         3ZzeXIpnfnGtw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: [PATCH v4 bpf-next 14/14] selftests/bpf: Add negative tests for bpf_nf
Date:   Thu, 26 May 2022 23:35:02 +0200
Message-Id: <87f1b4523264afab3ad3ea56a2be7000d37cfeea.1653600578.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653600577.git.lorenzo@kernel.org>
References: <cover.1653600577.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Test cases we care about and ensure improper usage is caught and
rejected by verifier. This also ends up exercising acquire release
pair logic and MEM_RDONLY's effect on a PTR_TO_BTF_ID which usually
permits BPF_WRITE.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/bpf_nf.c | 52 ++++++++++++-
 .../selftests/bpf/progs/test_bpf_nf_fail.c    | 73 +++++++++++++++++++
 2 files changed, 124 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index b909928427f3..d7294c6451d0 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -2,13 +2,25 @@
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
+	{ "alloc_release", "not permitted to release reference" },
+	{ "write_after_insert", "pointer points to const object, only read is supported" },
+	{ "lookup_insert", "cannot pass read only pointer to arg#0" },
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
@@ -49,10 +61,48 @@ void test_bpf_nf_ct(int mode)
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
index 000000000000..2484f7baef90
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+
+struct nf_conn;
+
+struct nf_conn___local {;
+	unsigned long status;
+} __attribute__((preserve_access_index));
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
+const struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
+					struct bpf_ct_opts___local *, u32) __ksym;
+const struct nf_conn *
+bpf_ct_insert_entry(struct nf_conn *, struct bpf_ct_opts___local *, u32) __ksym;
+void bpf_ct_release(const struct nf_conn *) __ksym;
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
+int write_after_insert(struct __sk_buff *ctx)
+{
+	struct bpf_ct_opts___local opts = {};
+	struct bpf_sock_tuple tup = {};
+	struct nf_conn___local *ct;
+
+	ct = (void *)bpf_skb_ct_alloc(ctx, &tup, sizeof(tup.ipv4), &opts, sizeof(opts));
+	if (!ct)
+		return 0;
+	ct = (void *)bpf_ct_insert_entry((void *)ct, &opts, sizeof(opts));
+	if (!ct)
+		return 0;
+	ct->status = 0;
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
+	ct = (void *)bpf_skb_ct_lookup(ctx, &tup, sizeof(tup.ipv4), &opts, sizeof(opts));
+	if (!ct)
+		return 0;
+	bpf_ct_insert_entry(ct, &opts, sizeof(opts));
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.35.3

