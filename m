Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF2E4818B9
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhL3Cho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbhL3Chg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:37:36 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B940C061401;
        Wed, 29 Dec 2021 18:37:36 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id a23so20260215pgm.4;
        Wed, 29 Dec 2021 18:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SLfcOfHich4b9hcbyTHHdLQwUV/HQApd3ia4YaupqVM=;
        b=SHhmxZ5PIheaW9zBVxNIESDNJ3cgqhjFdg16JjB1GoR0KobMllpLAtbxKrlegIaEcH
         /MTO6LIh0Gu0abFN9mxsdf/Awloxwok2R9RUgcKAY4DUW6L1pWf78ZqnqqRkxkuDp5NP
         3oKZx+L4Rmi33vEk3TYoRK9g6Kwfkef5mcDQDvfy5n6gUmOOG/nGZWdP/ir/C4/84/A2
         LlN5Dcs9APrYNW99N8zevyiJW41wNxsGcLAjHiwXCy17xeXZv0OSZQBykLQTNvpu56ED
         ADew/fR39RYS2AZbIq9cTHQbWpnyytVbMmrX3d+hmQagFnB4BhSP2KRdTsnl1Q49JXaj
         WhhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SLfcOfHich4b9hcbyTHHdLQwUV/HQApd3ia4YaupqVM=;
        b=6rFbG9qPCJNJb9RuOuD9/2jsKUe71nocjjz25HkHqqWZ6fjhsRDg/ued9bunXG0tLw
         5slW7Chb7ooCYpzmxUv7GcMdbkB6ZCUgB9zTcyO99jXycOThCSv+M2v5iB6MlRg20X4b
         Ex4wRPEmjL0K5j6ZZDKHCAt0tTKS/3uFYEdliHBBrCRKPtIWaH3/W0ygCY5gHE1KDtnm
         laVtO2g7SjaqVuHwgADMOXiMMy/1HinkTff8crUubsD3fbroFz3nMJj0VIE+EmzstUzr
         CcRlCReZOs4jXMN+18qcLaZr5Pla8Py3jK8ovKvoRPFP77OKxvX4mqZ4o4CCEMcsuoav
         nQFA==
X-Gm-Message-State: AOAM531/ymBucE+UoewNLUbTLfcR1ZEh6Jtzk9Rm8If7RWtA9sSFssly
        cZYbUzi8lPB8UnIoiuWqKRlnI3ifAMw=
X-Google-Smtp-Source: ABdhPJyNCUQ0lbS2bYHBiXaFw9jjAf0up9/xOoEJMFSCyZoHDnKoOS3C9WCIuhPVN+iW8gS6RDSY0g==
X-Received: by 2002:a63:2307:: with SMTP id j7mr26069420pgj.48.1640831855998;
        Wed, 29 Dec 2021 18:37:35 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id h11sm11105870pjs.10.2021.12.29.18.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 18:37:35 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v5 9/9] selftests/bpf: Extend kfunc selftests
Date:   Thu, 30 Dec 2021 08:07:05 +0530
Message-Id: <20211230023705.3860970-10-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211230023705.3860970-1-memxor@gmail.com>
References: <20211230023705.3860970-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9390; h=from:subject; bh=lMhmxV5w2XCL0VU3C36IT6AAKe4yEvmRDQivxdtR2jM=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhzRr+kBEjHUn8zAzDzDrFwOr30TRX6CcQKRZKZgjg LRFy/oSJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYc0a/gAKCRBM4MiGSL8RymISEA Cir+OeG+xfrlPo/w6UzwhUENXZ3HnDDYvlPzqQa9xPF6SggH9XyuW9yx+55JXN/lG6McOlnLEY5RCf eO367yWdev6sBXbeZjT5fJsuQqLAto8gdp+hnxvlmyiN/2ns6wRkAj40fr8ddg7TGTCkWZyVmayI3o 6VvvBJ9RsnPsE1iw0hlIqDVJh8/5i2zAZmhac6/dVaaJfucMlHF69uvTTTOwUHi4FPPfType2JTLbv QxBa7uSrH8i3gmIjjBkV8S0a++f0812ikZu6aYSOTgj2gr2KeTWXtQUgjBs4Dg6o1zmr/G3r2KRixg i/MyQNvGRifINPwUp5lYc3gzLDkLesebFA47u4/J1NfE6m5wzI7rySR5qBot24BrLF0HLHsJLfXs/i 95j/xtZxBhsrItwrPUZM31idzD1WqB0BTEdzDF4KJ4wUHauRQXCWDPiXmU+8xcFi2kJhgppX6L4B4r oUSUQ0l80yQndeG9pFLU68ktwx5CSdwuUxmLSPv6tjSfHic0ki1giOQehwgGShF9KhxkfPMNbD0nXf pcOFDzc6iuIZFaR6e2U7y9pIvdBm0R7VBo9+iR3dXEvKn1kNLWA5Qx3UM1/zqnXCvpjtTcyQDr1R7V CI9DOD+4ovv0SRsumXSHwWloms7JhSVL9yl4/QtNuGb5kG4BNT3uZVsXfZ8A==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the prog_test kfuncs to test the referenced PTR_TO_BTF_ID kfunc
support, and PTR_TO_CTX, PTR_TO_MEM argument passing support. Also
testing the various failure cases for invalid kfunc prototypes.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 net/bpf/test_run.c                            | 110 ++++++++++++++++++
 .../selftests/bpf/prog_tests/kfunc_call.c     |   6 +
 .../selftests/bpf/progs/kfunc_call_test.c     |  52 ++++++++-
 tools/testing/selftests/bpf/verifier/calls.c  |  75 ++++++++++++
 4 files changed, 241 insertions(+), 2 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2ccd567aa514..665aa7d25929 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -232,6 +232,105 @@ struct sock * noinline bpf_kfunc_call_test3(struct sock *sk)
 	return sk;
 }
 
+struct prog_test_ref_kfunc {
+	int a;
+	int b;
+	struct prog_test_ref_kfunc *next;
+};
+
+static struct prog_test_ref_kfunc prog_test_struct = {
+	.a = 42,
+	.b = 108,
+	.next = &prog_test_struct,
+};
+
+noinline struct prog_test_ref_kfunc *
+bpf_kfunc_call_test_acquire(unsigned long *scalar_ptr)
+{
+	/* randomly return NULL */
+	if (get_jiffies_64() % 2)
+		return NULL;
+	return &prog_test_struct;
+}
+
+noinline void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p)
+{
+}
+
+struct prog_test_pass1 {
+	int x0;
+	struct {
+		int x1;
+		struct {
+			int x2;
+			struct {
+				int x3;
+			};
+		};
+	};
+};
+
+struct prog_test_pass2 {
+	int len;
+	short arr1[4];
+	struct {
+		char arr2[4];
+		unsigned long arr3[8];
+	} x;
+};
+
+struct prog_test_fail1 {
+	void *p;
+	int x;
+};
+
+struct prog_test_fail2 {
+	int x8;
+	struct prog_test_pass1 x;
+};
+
+struct prog_test_fail3 {
+	int len;
+	char arr1[2];
+	char arr2[0];
+};
+
+noinline void bpf_kfunc_call_test_pass_ctx(struct __sk_buff *skb)
+{
+}
+
+noinline void bpf_kfunc_call_test_pass1(struct prog_test_pass1 *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_pass2(struct prog_test_pass2 *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_fail1(struct prog_test_fail1 *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_fail2(struct prog_test_fail2 *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_fail3(struct prog_test_fail3 *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_mem_len_pass1(void *mem, int mem__sz)
+{
+}
+
+noinline void bpf_kfunc_call_test_mem_len_fail1(void *mem, int len)
+{
+}
+
+noinline void bpf_kfunc_call_test_mem_len_fail2(u64 *mem, int len)
+{
+}
+
 __diag_pop();
 
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
@@ -240,6 +339,17 @@ BTF_KFUNC_SET_START(tc, check, test_sk_kfunc_ids)
 BTF_ID(func, bpf_kfunc_call_test1)
 BTF_ID(func, bpf_kfunc_call_test2)
 BTF_ID(func, bpf_kfunc_call_test3)
+BTF_ID(func, bpf_kfunc_call_test_acquire)
+BTF_ID(func, bpf_kfunc_call_test_release)
+BTF_ID(func, bpf_kfunc_call_test_pass_ctx)
+BTF_ID(func, bpf_kfunc_call_test_pass1)
+BTF_ID(func, bpf_kfunc_call_test_pass2)
+BTF_ID(func, bpf_kfunc_call_test_fail1)
+BTF_ID(func, bpf_kfunc_call_test_fail2)
+BTF_ID(func, bpf_kfunc_call_test_fail3)
+BTF_ID(func, bpf_kfunc_call_test_mem_len_pass1)
+BTF_ID(func, bpf_kfunc_call_test_mem_len_fail1)
+BTF_ID(func, bpf_kfunc_call_test_mem_len_fail2)
 BTF_KFUNC_SET_END(tc, check, test_sk_kfunc_ids)
 
 static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index 7d7445ccc141..b39a4f09aefd 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -27,6 +27,12 @@ static void test_main(void)
 	ASSERT_OK(err, "bpf_prog_test_run(test2)");
 	ASSERT_EQ(retval, 3, "test2-retval");
 
+	prog_fd = skel->progs.kfunc_call_test_ref_btf_id.prog_fd;
+	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				NULL, NULL, (__u32 *)&retval, NULL);
+	ASSERT_OK(err, "bpf_prog_test_run(test_ref_btf_id)");
+	ASSERT_EQ(retval, 0, "test_ref_btf_id-retval");
+
 	kfunc_call_test_lskel__destroy(skel);
 }
 
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
index 8a8cf59017aa..5aecbb9fdc68 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
@@ -1,13 +1,20 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2021 Facebook */
-#include <linux/bpf.h>
+#include <vmlinux.h>
 #include <bpf/bpf_helpers.h>
-#include "bpf_tcp_helpers.h"
 
 extern int bpf_kfunc_call_test2(struct sock *sk, __u32 a, __u32 b) __ksym;
 extern __u64 bpf_kfunc_call_test1(struct sock *sk, __u32 a, __u64 b,
 				  __u32 c, __u64 d) __ksym;
 
+extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp) __ksym;
+extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
+extern void bpf_kfunc_call_test_pass_ctx(struct __sk_buff *skb) __ksym;
+extern void bpf_kfunc_call_test_pass1(struct prog_test_pass1 *p) __ksym;
+extern void bpf_kfunc_call_test_pass2(struct prog_test_pass2 *p) __ksym;
+extern void bpf_kfunc_call_test_mem_len_pass1(void *mem, int len) __ksym;
+extern void bpf_kfunc_call_test_mem_len_fail2(__u64 *mem, int len) __ksym;
+
 SEC("tc")
 int kfunc_call_test2(struct __sk_buff *skb)
 {
@@ -44,4 +51,45 @@ int kfunc_call_test1(struct __sk_buff *skb)
 	return ret;
 }
 
+SEC("tc")
+int kfunc_call_test_ref_btf_id(struct __sk_buff *skb)
+{
+	struct prog_test_ref_kfunc *pt;
+	unsigned long s = 0;
+	int ret = 0;
+
+	pt = bpf_kfunc_call_test_acquire(&s);
+	if (pt) {
+		if (pt->a != 42 || pt->b != 108)
+			ret = -1;
+		bpf_kfunc_call_test_release(pt);
+	}
+	return ret;
+}
+
+SEC("tc")
+int kfunc_call_test_pass(struct __sk_buff *skb)
+{
+	struct prog_test_pass1 p1 = {};
+	struct prog_test_pass2 p2 = {};
+	short a = 0;
+	__u64 b = 0;
+	long c = 0;
+	char d = 0;
+	int e = 0;
+
+	bpf_kfunc_call_test_pass_ctx(skb);
+	bpf_kfunc_call_test_pass1(&p1);
+	bpf_kfunc_call_test_pass2(&p2);
+
+	bpf_kfunc_call_test_mem_len_pass1(&a, sizeof(a));
+	bpf_kfunc_call_test_mem_len_pass1(&b, sizeof(b));
+	bpf_kfunc_call_test_mem_len_pass1(&c, sizeof(c));
+	bpf_kfunc_call_test_mem_len_pass1(&d, sizeof(d));
+	bpf_kfunc_call_test_mem_len_pass1(&e, sizeof(e));
+	bpf_kfunc_call_test_mem_len_fail2(&b, -1);
+
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
index d7b74eb28333..829be2b9e08e 100644
--- a/tools/testing/selftests/bpf/verifier/calls.c
+++ b/tools/testing/selftests/bpf/verifier/calls.c
@@ -21,6 +21,81 @@
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 	.result  = ACCEPT,
 },
+{
+	"calls: invalid kfunc call: ptr_to_mem to struct with non-scalar",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = REJECT,
+	.errstr = "arg#0 pointer type STRUCT prog_test_fail1 must point to scalar",
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_fail1", 2 },
+	},
+},
+{
+	"calls: invalid kfunc call: ptr_to_mem to struct with nesting depth > 4",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = REJECT,
+	.errstr = "max struct nesting depth exceeded\narg#0 pointer type STRUCT prog_test_fail2",
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_fail2", 2 },
+	},
+},
+{
+	"calls: invalid kfunc call: ptr_to_mem to struct with FAM",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = REJECT,
+	.errstr = "arg#0 pointer type STRUCT prog_test_fail3 must point to scalar",
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_fail3", 2 },
+	},
+},
+{
+	"calls: invalid kfunc call: reg->type != PTR_TO_CTX",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = REJECT,
+	.errstr = "arg#0 expected pointer to ctx, but got PTR",
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_pass_ctx", 2 },
+	},
+},
+{
+	"calls: invalid kfunc call: void * not allowed in func proto without mem size arg",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = REJECT,
+	.errstr = "arg#0 pointer type UNKNOWN  must point to scalar",
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_mem_len_fail1", 2 },
+	},
+},
 {
 	"calls: basic sanity",
 	.insns = {
-- 
2.34.1

