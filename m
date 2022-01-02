Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DD9482C0A
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbiABQVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbiABQVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:21:48 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5876DC061761;
        Sun,  2 Jan 2022 08:21:48 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id m1so27597791pfk.8;
        Sun, 02 Jan 2022 08:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nIWUEdyNT9JbngAEPas6VP5r22bQ9ftcm3UcM4SovS4=;
        b=dIb+CKzegrFg17Qrg8+iHvPifVo8N5Dwy5C2vLnfHZ2fC8i7fPihfUK6sO/sgHPrmG
         NEkOl6r3bUWDVRM6YeYmrXiPN7R52Kin/xcdywgETAGEwRmLu9KDVytSl1DgYr5T03+Q
         AYOWNoD44FW1UUGwLiINfTOWN2xqd2DP3/cAubie6iggSAEWC1tii+npEJLT11hZnJEc
         /QKFrYeI8cgqzFJH7sRAaarbVWbq5ttwSRrz3EwLhsTK4TWEzmGz+EfGRFj1e23Hic3a
         18Z8iFfiv8DEKk7/rGghYOYqg9g3+Q2nbZ+ca2GY3CIn2lDGVvnxlIPkFhCa1WL7y5AM
         N2Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nIWUEdyNT9JbngAEPas6VP5r22bQ9ftcm3UcM4SovS4=;
        b=CMhhSwWgMwlt0w3uy+xQq+/pZXDQ76+TeApS9WyDCFJAA0bUIqIHWE9VB3SFHPkW2a
         +bHoiKL8RXf+jUMcPHmeQ03Mo2czQy8cGsnjBtlCE7mQQYZomPLjolGsIyT/YlqnGn1P
         ex510oKewL3Rpg8TM9H/p6y8o1UZRc+X0A5MjI3RAavyzJW9dy+/ZQPIWtAEH4ESy32I
         kMtG4OhLTSDkw80pNg/7YConIOdqgB9xGq3iGHKQwJIbQT8FEf56X40cvUBdRJtDK8m1
         h79WUuWgpGtezfDge1KvtllSl0vkR1s4Hi/u9qB1Z5Q+8tyLxLhiUCv7+lLDBpjo3x2E
         16Ug==
X-Gm-Message-State: AOAM531xdMyikyzJaSLzNUl1ycOWk666YGF9zMpJ9QQ5e0JOgphVEO9N
        5XImjwuOd8Mm1TqskbCl2fYW1iXWk2E=
X-Google-Smtp-Source: ABdhPJw1pDzOkAjwUuS+GkhjWpT8jNuOSVi8Xo6yGRpkTRZaQQGP164IrW4U8TFnuaqHJ7UGZmYqxQ==
X-Received: by 2002:a63:8248:: with SMTP id w69mr38456009pgd.158.1641140507708;
        Sun, 02 Jan 2022 08:21:47 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id t31sm26011065pfg.184.2022.01.02.08.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 08:21:47 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v6 10/11] selftests/bpf: Extend kfunc selftests
Date:   Sun,  2 Jan 2022 21:51:14 +0530
Message-Id: <20220102162115.1506833-11-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220102162115.1506833-1-memxor@gmail.com>
References: <20220102162115.1506833-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10297; h=from:subject; bh=6JCnpNki/bRIy1mpP8MnN6NvAjh+4E9vNg587086C54=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh0dCKAPgHwoGd+Pk2CFa4UFpshoZh8knd+jJCcZcH P1RatH+JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYdHQigAKCRBM4MiGSL8Ryi3LD/ 9v5MCTyp62Ueeo+WNYyQIacm8o1DDfcNjR3fSo1zuK2D/hvaw6YAGNeMxL8p6bMYoWXujo27vXLBdk jl2dKZQASmiMcqqstGlEXpWmNbj4/SFjY5A7c2BAnz09NZjfsR3hP4cxQAZr1IUna/ZhLhzODg3L4u WiV/EgVdJGQ6bPmPgwrCbwYgvih2CsyxX90MzVyE+bETnyRz44IE0abJUfFsXXhyKJce2x2F3vZ3kh GaSicbU1/eUvW5qsCA9Roo1T66MubhaaKu6ieYOgP4+POxu5PLvpjtv8dbHB9wU1CC56wSCYP79JZB x7CXLY5ynl9GP3onT/xrEGRo1Agub2XM1k/aPrRN2ng/V8aQd9MfNsooOcpK8R4AicHK0uhhTbenY8 BHk1HIcgNpLR47BRFlVBj7Wba7ePt5q4qSzrPNz0PnjSH1uYLXV3MReg6U3I8mo6DkcM8SDV2FPlfV KfUQquztw5vrb5GZTFxRkZRNiniyx0DsO4YRr1eed/t98U6aXwv1DPOz1WHufWU0q4DrF11bqZX3P/ 9c4pfNzwB6i4YQ4ZzyMgoAMjkXcBxDVihRHStmR8+jK+phRziqEkJe8HhHeOT8i9jNtLRjzKLul9zc ycJGDL5vuHpOFulcivuyd+P2oLs72uXEZU9ZU3mrKul/1EbSrLNbxAavO8aA==
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
 net/bpf/test_run.c                            | 129 +++++++++++++++++-
 .../selftests/bpf/prog_tests/kfunc_call.c     |   6 +
 .../selftests/bpf/progs/kfunc_call_test.c     |  52 ++++++-
 tools/testing/selftests/bpf/verifier/calls.c  |  75 ++++++++++
 4 files changed, 258 insertions(+), 4 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index e29f4a1c9fa4..f461770bf849 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -233,6 +233,105 @@ struct sock * noinline bpf_kfunc_call_test3(struct sock *sk)
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
@@ -241,8 +340,31 @@ BTF_SET_START(test_sk_check_kfunc_ids)
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
 BTF_SET_END(test_sk_check_kfunc_ids)
 
+BTF_SET_START(test_sk_acquire_kfunc_ids)
+BTF_ID(func, bpf_kfunc_call_test_acquire)
+BTF_SET_END(test_sk_acquire_kfunc_ids)
+
+BTF_SET_START(test_sk_release_kfunc_ids)
+BTF_ID(func, bpf_kfunc_call_test_release)
+BTF_SET_END(test_sk_release_kfunc_ids)
+
+BTF_SET_START(test_sk_ret_null_kfunc_ids)
+BTF_ID(func, bpf_kfunc_call_test_acquire)
+BTF_SET_END(test_sk_ret_null_kfunc_ids)
+
 static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
 			   u32 headroom, u32 tailroom)
 {
@@ -1063,8 +1185,11 @@ int bpf_prog_test_run_syscall(struct bpf_prog *prog,
 }
 
 static const struct btf_kfunc_id_set bpf_prog_test_kfunc_set = {
-	.owner     = THIS_MODULE,
-	.check_set = &test_sk_check_kfunc_ids,
+	.owner        = THIS_MODULE,
+	.check_set    = &test_sk_check_kfunc_ids,
+	.acquire_set  = &test_sk_acquire_kfunc_ids,
+	.release_set  = &test_sk_release_kfunc_ids,
+	.ret_null_set = &test_sk_ret_null_kfunc_ids,
 };
 
 static int __init bpf_prog_test_run_init(void)
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

