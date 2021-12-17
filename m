Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FD647828A
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 02:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhLQBvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 20:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbhLQBvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 20:51:04 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D557C06173E;
        Thu, 16 Dec 2021 17:51:04 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id np3so807101pjb.4;
        Thu, 16 Dec 2021 17:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=evuqDhRMh8nTtLflLHMP9tpb91vOyLauiyU+QoRV6Ko=;
        b=Mn3rTpgDY7Lv2O4MVMaGfdds8GgV9AmZNkR2DYymNGqDJgjOLXst/M0Plz5AX3HFTT
         58qywJHece4g+TVfRMZydFcQWQsh7z/owx3efIQQM0D1obPmkJKOgzXzYkgAQyrixsxh
         hAgKTXBLGZWXFGZXwrrodWd3KxIeQOaV5KrspBofckAAYGK3XgO75QGdJ3wCfmi8+Nn0
         7t/2g3yhvyVHhgYFjYwpxt4D/FP2Rp2pnUX0Kv93zIjeX7ueJrFO/gcCRNzCk1K2ZcQx
         AH6krj+arZkFNkwydp8nwafWSrN4ilUst5TVjrbZOHHi0etJoZ7zbXIbHifBx0ti8A7N
         Z5Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=evuqDhRMh8nTtLflLHMP9tpb91vOyLauiyU+QoRV6Ko=;
        b=EbAwdwM44kk9bcnbQPTzTVJQCNy2wbNJ3bUgeNF5gHPww+NL1ibESqp0dMDqRG+nLA
         SGHfYlo9P9iGcMJx3tSP1BLU/9RhLkrZ6IFiwlYVBWeSdB9crufFn3d8AfsP23y001Mp
         4WuH+y+NhfdqvBT1h/UYTm/39JwClJq3BVt7dJNYuzxj1WhKxwuLWPauyk9vPdRgzmk2
         4jMYOZOI5ePBORcPu0Hdk/Y90caDWEY/yOe07eH5LU27YimZ5LlKmtUMoHX/pI1230ai
         LaVH9zaYnEC+FKSGccBqfC7nT4Oe9loLNCUrzxbVpgvVOM2LndAkHCDAYf9uH2ngqCpD
         BIow==
X-Gm-Message-State: AOAM533TTSOp3W+pMQZEhdkasV3mwaRD+UfmF4TvzSKvtY8Oc1eINvb5
        dnogSI+ulz8QwgM+20T/HwYoExxiDZg=
X-Google-Smtp-Source: ABdhPJy5IHEJpIdkbbqcuccR+hCKUzPDj9zxb3eKhNQQvulHQk9jiDXq1hblYtGcyieh/5CAjUiFRA==
X-Received: by 2002:a17:90b:38c4:: with SMTP id nn4mr9462133pjb.26.1639705863797;
        Thu, 16 Dec 2021 17:51:03 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id pi12sm3667281pjb.12.2021.12.16.17.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 17:51:03 -0800 (PST)
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
Subject: [PATCH bpf-next v4 10/10] selftests/bpf: Extend kfunc selftests
Date:   Fri, 17 Dec 2021 07:20:31 +0530
Message-Id: <20211217015031.1278167-11-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217015031.1278167-1-memxor@gmail.com>
References: <20211217015031.1278167-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=14854; h=from:subject; bh=vxGabSO4S3DWzZQFVI/SqvtWZkNgilU9tSs/jOHkMa8=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhu+vGtkub+yj/YTvAHxhgluBeFHCQHm/UMBpI1gyl TYfK6ECJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbvrxgAKCRBM4MiGSL8RymALD/ 4iyIbCP1CSRI9IhEgUwJb4khMpMHp0pJuLm8mOrZje2wN4/TX+Fs+0uzfhDTqqz0GSASI47dL+UxEJ VN7ohxjfcBG8RU8QWDTUaHI4wf+vVmXCY1NHL4ysIDADl7PYJpfeOxLkBCqry2sHwuuGRuX4Est3g7 89rbIJTYHbAIfiR4KGevaZqwREYW5xQBl0sVqy+4e+eTnVX7yvDEV+LzCJt28lafmdHc+G+x7mJG9J bGhotufT0K1as1By/9mOKx83MBGnq/emcv/PeJBugb/vIvBqE1dY1OMLzmM4PaCVDM1KaBXTuyidKH oEclSzDPu75rKIXd/QrH9+FulciKM+sfZ46xq6gEnRmXM/K9Ml4lrFnfUYNNjOa+A7nwdvtOMqE1or yFMltfH7QrDw45ek7ylL1BDyq4epGB8nzRgK6N2w128NWOzeQHewNDWFkEVhrw7GuVNa1Eq1r1SwAz fz0WA+rUVW0tRO05PdC+TmTRkUDQ+z8dGLI+qg21RiUHuErKKotbiW6csQsht/1RgFPABAgdTaESKn v03GJ0qNUIarjqjF/yT0AISpcGb/yiLvdLFGXBzF4PaFjdnNwnIUJ/AXcBQGd2tLeU1W9KZO2nH0kM /zELNtoOru0P2MHANI/qBiHwiQVSwhHnn9FpGLFHk+iDYWGizXLNyhW2+PUw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the prog_test kfuncs to test the referenced PTR_TO_BTF_ID kfunc
support, and PTR_TO_CTX, PTR_TO_MEM argument passing support. Also
testing the various failure cases for invalid kfunc prototypes.

Also, exercise the two cases being solved by addition of
parent_ref_obj_id in bpf_reg_state:
- Invalidation of pointers formed by btf_struct_walk on
  release_reference
- Not being able to pass same BTF ID's PTR_TO_BTF_ID to the release
  function, also formed by btf_struct_walk

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h                           |  21 +++
 net/bpf/test_run.c                            | 135 ++++++++++++++++++
 net/core/filter.c                             |   3 +
 .../selftests/bpf/prog_tests/kfunc_call.c     |   6 +
 .../selftests/bpf/progs/kfunc_call_test.c     |  52 ++++++-
 tools/testing/selftests/bpf/verifier/calls.c  |  75 ++++++++++
 .../selftests/bpf/verifier/ref_tracking.c     |  44 ++++++
 7 files changed, 334 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 015cb633838b..2909608b2326 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1670,6 +1670,9 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
 				const union bpf_attr *kattr,
 				union bpf_attr __user *uattr);
 bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner);
+bool bpf_prog_test_is_acquire_kfunc(u32 kfunc_id, struct module *owner);
+bool bpf_prog_test_is_release_kfunc(u32 kfunc_id, struct module *owner);
+bool bpf_prog_test_is_kfunc_ret_type_null(u32 kfunc_id, struct module *owner);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
@@ -1928,6 +1931,24 @@ static inline bool bpf_prog_test_check_kfunc_call(u32 kfunc_id,
 	return false;
 }
 
+static inline bool bpf_prog_test_is_acquire_kfunc(u32 kfunc_id,
+						  struct module *owner)
+{
+	return false;
+}
+
+static inline bool bpf_prog_test_is_release_kfunc(u32 kfunc_id,
+						  struct module *owner)
+{
+	return false;
+}
+
+static inline bool bpf_prog_test_is_kfunc_ret_type_null(u32 kfunc_id,
+							struct module *owner)
+{
+	return false;
+}
+
 static inline void bpf_map_put(struct bpf_map *map)
 {
 }
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 46dd95755967..c72e71ffdf22 100644
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
+noinline void bpf_kfunc_call_test_mem_len_pass1(void *mem, int len__mem)
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
@@ -240,8 +339,23 @@ BTF_SET_START(test_sk_kfunc_ids)
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
 BTF_SET_END(test_sk_kfunc_ids)
 
+BTF_ID_LIST(test_sk_acq_rel)
+BTF_ID(func, bpf_kfunc_call_test_acquire)
+BTF_ID(func, bpf_kfunc_call_test_release)
+
 bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
 {
 	if (btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id))
@@ -249,6 +363,27 @@ bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
 	return bpf_check_mod_kfunc_call(&prog_test_kfunc_list, kfunc_id, owner);
 }
 
+bool bpf_prog_test_is_acquire_kfunc(u32 kfunc_id, struct module *owner)
+{
+	if (kfunc_id == test_sk_acq_rel[0])
+		return true;
+	return bpf_is_mod_acquire_kfunc(&prog_test_kfunc_list, kfunc_id, owner);
+}
+
+bool bpf_prog_test_is_release_kfunc(u32 kfunc_id, struct module *owner)
+{
+	if (kfunc_id == test_sk_acq_rel[1])
+		return true;
+	return bpf_is_mod_release_kfunc(&prog_test_kfunc_list, kfunc_id, owner);
+}
+
+bool bpf_prog_test_is_kfunc_ret_type_null(u32 kfunc_id, struct module *owner)
+{
+	if (kfunc_id == test_sk_acq_rel[0])
+		return true;
+	return bpf_is_mod_kfunc_ret_type_null(&prog_test_kfunc_list, kfunc_id, owner);
+}
+
 static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
 			   u32 headroom, u32 tailroom)
 {
diff --git a/net/core/filter.c b/net/core/filter.c
index e5efacaa6175..271b89fe89f8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10002,6 +10002,9 @@ const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
 	.gen_prologue		= tc_cls_act_prologue,
 	.gen_ld_abs		= bpf_gen_ld_abs,
 	.check_kfunc_call	= bpf_prog_test_check_kfunc_call,
+	.is_acquire_kfunc	= bpf_prog_test_is_acquire_kfunc,
+	.is_release_kfunc	= bpf_prog_test_is_release_kfunc,
+	.is_kfunc_ret_type_null = bpf_prog_test_is_kfunc_ret_type_null,
 };
 
 const struct bpf_prog_ops tc_cls_act_prog_ops = {
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
index d7b74eb28333..8fc4c91eb615 100644
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
+	.errstr = "max struct nesting depth 4 exceeded\narg#0 pointer type STRUCT prog_test_fail2",
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
diff --git a/tools/testing/selftests/bpf/verifier/ref_tracking.c b/tools/testing/selftests/bpf/verifier/ref_tracking.c
index 3b6ee009c00b..acd35bdbdcf9 100644
--- a/tools/testing/selftests/bpf/verifier/ref_tracking.c
+++ b/tools/testing/selftests/bpf/verifier/ref_tracking.c
@@ -905,3 +905,47 @@
 	.result_unpriv = REJECT,
 	.errstr_unpriv = "unknown func",
 },
+{
+	"reference tracking: use ptr formed from referenced PTR_TO_BTF_ID after release",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 5),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_0, 8),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_LDX_MEM(BPF_W, BPF_REG_6, BPF_REG_6, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = REJECT,
+	.errstr = "R6 invalid mem access 'inv'",
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_acquire", 3 },
+		{ "bpf_kfunc_call_test_release", 7 },
+	},
+},
+{
+	"reference tracking: cannot release ptr formed from referenced PTR_TO_BTF_ID, same BTF ID",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 3),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 8),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = REJECT,
+	.errstr = "release kernel function bpf_kfunc_call_test_release expects refcounted",
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_acquire", 3 },
+		{ "bpf_kfunc_call_test_release", 6 },
+	},
+},
-- 
2.34.1

