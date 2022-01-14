Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F7448EE89
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243557AbiANQlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243546AbiANQlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:41:09 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95290C061749;
        Fri, 14 Jan 2022 08:41:08 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so22611862pjj.2;
        Fri, 14 Jan 2022 08:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H3yfHHm/dC6wV51xeH/AQZWfLUZAIsM4sDRbBI0TaOw=;
        b=nvsRPOGa2/Snyw1iAfNVPquOQ1a2s4ld4DXTWjebXBnIqMZ1GMifVPsBO0rfoziAbL
         RvfJ8e9pOcinLY3gQoIyDqNs77RSFi4irl1/OUOEuroj2Ivvnp1UJdboxz9m2bTDn0od
         IKcIEB81aKtF/yRKmzIOtac1YBvzTVhLYFEiZBMK0KiwLdLIoFQLNMPAUNinDtCZjnCc
         MuNyjKCPFjabenb/HD4pqthY8D9H/2wATTeDIGjf8d5CPZYFHpChgUWC66ckobZrdXlu
         sFEEXakmpEDeBiwQ/6j4cesKpZtTpL0BuKx+cy6xR3NLj5sO3dBV1Uthz0x7K0KMs09y
         6GAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H3yfHHm/dC6wV51xeH/AQZWfLUZAIsM4sDRbBI0TaOw=;
        b=zsqM3JUJoYTyo3hicx8guu1Sbo/NyixeaUmlGsOJCWCQ7KGY6PWR8eoEfFsGinjnQM
         D9E6Ii93YZnt05ewf3s8iY2rdOXcjF5xIPe27MsqMYWXdLNBZVp61NVDklrieP+O1Eet
         gY5Vgxv2AcN777F5KaFXbE6sNXBvFqmCp2WIDc6HykbeN4KcTvN6nvXArFbsj4dq+aXP
         xtwfQUcvZOnD+oloWdM+dMyLej9aI7o7S5kqZy9FgWSQlklkc0j0hYZLB+ykEtRTSOdk
         GkBnyavX0NgDd1WorIELPFkc6mMCVHa++bdhVkgg06PQb7AU9jG7vVMjuNOo0cvMGQI1
         Kd/w==
X-Gm-Message-State: AOAM531ak4Bsxa/OqmqukjxtkfBZffOGci++cfIcEWrQZj43NRmQ3ktE
        8KTH0uJ9pvRgEaVTDZb7WzNVi05SrpEuzg==
X-Google-Smtp-Source: ABdhPJwN3/CbLooT6WiNx04BHF/4wXKfAuA3G4rnQPafH1WDP7sR4KYhvu0jkpS9HzjjtgWMWJYE0g==
X-Received: by 2002:a17:90a:5d83:: with SMTP id t3mr20846793pji.159.1642178467868;
        Fri, 14 Jan 2022 08:41:07 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id t126sm4913772pgc.61.2022.01.14.08.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:41:07 -0800 (PST)
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
Subject: [PATCH bpf-next v8 09/10] selftests/bpf: Extend kfunc selftests
Date:   Fri, 14 Jan 2022 22:09:52 +0530
Message-Id: <20220114163953.1455836-10-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114163953.1455836-1-memxor@gmail.com>
References: <20220114163953.1455836-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10297; h=from:subject; bh=V4N8OYIp0Q0iUeJaK6wmENfeM8WFrnU4WDanDAZzvaA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh4acVh6bm+JL41xBTqXMNQUd6UAiAlasaVmwEksmi LoNq+zKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYeGnFQAKCRBM4MiGSL8RyrviD/ 4ly1fb+bCEQeMWNS7yhne8fAAKWYHTIDdYA+Icizcs2b6oc6K0b2MylGZ75rWCBoR8OuKa69jvr5Ph jxLbep2rz5DmWRwEaXtOsjbYgjwn3S0sN67inL9yKjcnyxjnE9HECU+mk2MAsB7cUv3VmFC3b/gaV5 7ZN1OdasUyVVhxlUVsOuThzAmepUivj6L5tuGqd3f1wypG6gpZNZT1V3tH1ClB6PZgRXzUpBIeC7Rr UZQCp1Pl5GSteeuPpt6dJNFkb4A33X/3g7NsTuY4NYcKd4krd0Gq9KLwKeS6WoKa/8ANEW12QxuY1+ 4pQSx/aGIbkIEyiaP7O7GPvwXUoikYOPVIJovQkPQUs3pf4aeac7E1hTiP83m6fUEVwDbQxo1AMYyJ tAnhcji9aArywV1ga+FS467iqx+lp3JEOqrKbF+1UdnVMJ5a7tMHQG3janR3IWz6LKxSFBXUzqgxjA Oq4GyJhTL8PZkDQ4kaMG+BUQp3qBLqES2g/H6VF992AWkPFdyCsHe6AbU5yRiorhCbDYDWq9iennZ8 yhaV0PeQFFFh3qWWyXf/o0U9itggQzn58QvAPlCe+RWNNWGWa+VN/cUQUSZq/io5Ts+nYnQ4IzPOhD dgoVhx+4c/PP+fjTbCtzlJW2ODHtq14+KvJToDg+AfauLsC3ik0JuK/p2COw==
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
index 7796a8c747a0..93ba56507240 100644
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

