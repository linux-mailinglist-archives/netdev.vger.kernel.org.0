Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE12349F624
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 10:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347575AbiA1JT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 04:19:56 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17827 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234750AbiA1JTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 04:19:55 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JlX1z33nWz9sc4;
        Fri, 28 Jan 2022 17:18:31 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 28 Jan
 2022 17:19:38 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>, Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <jthierry@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH bpf-next v2 1/2] selftests/bpf: use raw_tp program for atomic test
Date:   Thu, 27 Jan 2022 15:53:21 +0800
Message-ID: <20220127075322.675323-2-houtao1@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220127075322.675323-1-houtao1@huawei.com>
References: <20220127075322.675323-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now atomic tests will attach fentry program and run it through
bpf_prog_test_run(), but attaching fentry program depends on bpf
trampoline which is only available under x86-64. Considering many
archs have atomic support, using raw_tp program instead.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../selftests/bpf/prog_tests/atomics.c        | 121 ++++++------------
 tools/testing/selftests/bpf/progs/atomics.c   |  28 ++--
 2 files changed, 50 insertions(+), 99 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/atomics.c b/tools/testing/selftests/bpf/prog_tests/atomics.c
index 86b7d5d84eec..8e05a703a62b 100644
--- a/tools/testing/selftests/bpf/prog_tests/atomics.c
+++ b/tools/testing/selftests/bpf/prog_tests/atomics.c
@@ -8,18 +8,14 @@ static void test_add(struct atomics_lskel *skel)
 {
 	int err, prog_fd;
 	__u32 duration = 0, retval;
-	int link_fd;
-
-	link_fd = atomics_lskel__add__attach(skel);
-	if (!ASSERT_GT(link_fd, 0, "attach(add)"))
-		return;
 
+	/* No need to attach it, just run it directly */
 	prog_fd = skel->progs.add.prog_fd;
-	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+	err = bpf_prog_test_run(prog_fd, 0, NULL, 0,
 				NULL, NULL, &retval, &duration);
-	if (CHECK(err || retval, "test_run add",
-		  "err %d errno %d retval %d duration %d\n", err, errno, retval, duration))
-		goto cleanup;
+	if (!ASSERT_OK(err, "test_run add") ||
+	    !ASSERT_OK(retval, "test_run add ret"))
+		return;
 
 	ASSERT_EQ(skel->data->add64_value, 3, "add64_value");
 	ASSERT_EQ(skel->bss->add64_result, 1, "add64_result");
@@ -31,28 +27,20 @@ static void test_add(struct atomics_lskel *skel)
 	ASSERT_EQ(skel->bss->add_stack_result, 1, "add_stack_result");
 
 	ASSERT_EQ(skel->data->add_noreturn_value, 3, "add_noreturn_value");
-
-cleanup:
-	close(link_fd);
 }
 
 static void test_sub(struct atomics_lskel *skel)
 {
 	int err, prog_fd;
 	__u32 duration = 0, retval;
-	int link_fd;
-
-	link_fd = atomics_lskel__sub__attach(skel);
-	if (!ASSERT_GT(link_fd, 0, "attach(sub)"))
-		return;
 
+	/* No need to attach it, just run it directly */
 	prog_fd = skel->progs.sub.prog_fd;
-	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+	err = bpf_prog_test_run(prog_fd, 0, NULL, 0,
 				NULL, NULL, &retval, &duration);
-	if (CHECK(err || retval, "test_run sub",
-		  "err %d errno %d retval %d duration %d\n",
-		  err, errno, retval, duration))
-		goto cleanup;
+	if (!ASSERT_OK(err, "test_run sub") ||
+	    !ASSERT_OK(retval, "test_run sub ret"))
+		return;
 
 	ASSERT_EQ(skel->data->sub64_value, -1, "sub64_value");
 	ASSERT_EQ(skel->bss->sub64_result, 1, "sub64_result");
@@ -64,27 +52,20 @@ static void test_sub(struct atomics_lskel *skel)
 	ASSERT_EQ(skel->bss->sub_stack_result, 1, "sub_stack_result");
 
 	ASSERT_EQ(skel->data->sub_noreturn_value, -1, "sub_noreturn_value");
-
-cleanup:
-	close(link_fd);
 }
 
 static void test_and(struct atomics_lskel *skel)
 {
 	int err, prog_fd;
 	__u32 duration = 0, retval;
-	int link_fd;
-
-	link_fd = atomics_lskel__and__attach(skel);
-	if (!ASSERT_GT(link_fd, 0, "attach(and)"))
-		return;
 
+	/* No need to attach it, just run it directly */
 	prog_fd = skel->progs.and.prog_fd;
-	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+	err = bpf_prog_test_run(prog_fd, 0, NULL, 0,
 				NULL, NULL, &retval, &duration);
-	if (CHECK(err || retval, "test_run and",
-		  "err %d errno %d retval %d duration %d\n", err, errno, retval, duration))
-		goto cleanup;
+	if (!ASSERT_OK(err, "test_run and") ||
+	    !ASSERT_OK(retval, "test_run and ret"))
+		return;
 
 	ASSERT_EQ(skel->data->and64_value, 0x010ull << 32, "and64_value");
 	ASSERT_EQ(skel->bss->and64_result, 0x110ull << 32, "and64_result");
@@ -93,27 +74,20 @@ static void test_and(struct atomics_lskel *skel)
 	ASSERT_EQ(skel->bss->and32_result, 0x110, "and32_result");
 
 	ASSERT_EQ(skel->data->and_noreturn_value, 0x010ull << 32, "and_noreturn_value");
-cleanup:
-	close(link_fd);
 }
 
 static void test_or(struct atomics_lskel *skel)
 {
 	int err, prog_fd;
 	__u32 duration = 0, retval;
-	int link_fd;
-
-	link_fd = atomics_lskel__or__attach(skel);
-	if (!ASSERT_GT(link_fd, 0, "attach(or)"))
-		return;
 
+	/* No need to attach it, just run it directly */
 	prog_fd = skel->progs.or.prog_fd;
-	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+	err = bpf_prog_test_run(prog_fd, 0, NULL, 0,
 				NULL, NULL, &retval, &duration);
-	if (CHECK(err || retval, "test_run or",
-		  "err %d errno %d retval %d duration %d\n",
-		  err, errno, retval, duration))
-		goto cleanup;
+	if (!ASSERT_OK(err, "test_run or") ||
+	    !ASSERT_OK(retval, "test_run or ret"))
+		return;
 
 	ASSERT_EQ(skel->data->or64_value, 0x111ull << 32, "or64_value");
 	ASSERT_EQ(skel->bss->or64_result, 0x110ull << 32, "or64_result");
@@ -122,26 +96,20 @@ static void test_or(struct atomics_lskel *skel)
 	ASSERT_EQ(skel->bss->or32_result, 0x110, "or32_result");
 
 	ASSERT_EQ(skel->data->or_noreturn_value, 0x111ull << 32, "or_noreturn_value");
-cleanup:
-	close(link_fd);
 }
 
 static void test_xor(struct atomics_lskel *skel)
 {
 	int err, prog_fd;
 	__u32 duration = 0, retval;
-	int link_fd;
-
-	link_fd = atomics_lskel__xor__attach(skel);
-	if (!ASSERT_GT(link_fd, 0, "attach(xor)"))
-		return;
 
+	/* No need to attach it, just run it directly */
 	prog_fd = skel->progs.xor.prog_fd;
-	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+	err = bpf_prog_test_run(prog_fd, 0, NULL, 0,
 				NULL, NULL, &retval, &duration);
-	if (CHECK(err || retval, "test_run xor",
-		  "err %d errno %d retval %d duration %d\n", err, errno, retval, duration))
-		goto cleanup;
+	if (!ASSERT_OK(err, "test_run xor") ||
+	    !ASSERT_OK(retval, "test_run xor ret"))
+		return;
 
 	ASSERT_EQ(skel->data->xor64_value, 0x101ull << 32, "xor64_value");
 	ASSERT_EQ(skel->bss->xor64_result, 0x110ull << 32, "xor64_result");
@@ -150,26 +118,20 @@ static void test_xor(struct atomics_lskel *skel)
 	ASSERT_EQ(skel->bss->xor32_result, 0x110, "xor32_result");
 
 	ASSERT_EQ(skel->data->xor_noreturn_value, 0x101ull << 32, "xor_nxoreturn_value");
-cleanup:
-	close(link_fd);
 }
 
 static void test_cmpxchg(struct atomics_lskel *skel)
 {
 	int err, prog_fd;
 	__u32 duration = 0, retval;
-	int link_fd;
-
-	link_fd = atomics_lskel__cmpxchg__attach(skel);
-	if (!ASSERT_GT(link_fd, 0, "attach(cmpxchg)"))
-		return;
 
+	/* No need to attach it, just run it directly */
 	prog_fd = skel->progs.cmpxchg.prog_fd;
-	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+	err = bpf_prog_test_run(prog_fd, 0, NULL, 0,
 				NULL, NULL, &retval, &duration);
-	if (CHECK(err || retval, "test_run cmpxchg",
-		  "err %d errno %d retval %d duration %d\n", err, errno, retval, duration))
-		goto cleanup;
+	if (!ASSERT_OK(err, "test_run cmpxchg") ||
+	    !ASSERT_OK(retval, "test_run cmpxchg ret"))
+		return;
 
 	ASSERT_EQ(skel->data->cmpxchg64_value, 2, "cmpxchg64_value");
 	ASSERT_EQ(skel->bss->cmpxchg64_result_fail, 1, "cmpxchg_result_fail");
@@ -178,45 +140,34 @@ static void test_cmpxchg(struct atomics_lskel *skel)
 	ASSERT_EQ(skel->data->cmpxchg32_value, 2, "lcmpxchg32_value");
 	ASSERT_EQ(skel->bss->cmpxchg32_result_fail, 1, "cmpxchg_result_fail");
 	ASSERT_EQ(skel->bss->cmpxchg32_result_succeed, 1, "cmpxchg_result_succeed");
-
-cleanup:
-	close(link_fd);
 }
 
 static void test_xchg(struct atomics_lskel *skel)
 {
 	int err, prog_fd;
 	__u32 duration = 0, retval;
-	int link_fd;
-
-	link_fd = atomics_lskel__xchg__attach(skel);
-	if (!ASSERT_GT(link_fd, 0, "attach(xchg)"))
-		return;
 
+	/* No need to attach it, just run it directly */
 	prog_fd = skel->progs.xchg.prog_fd;
-	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+	err = bpf_prog_test_run(prog_fd, 0, NULL, 0,
 				NULL, NULL, &retval, &duration);
-	if (CHECK(err || retval, "test_run xchg",
-		  "err %d errno %d retval %d duration %d\n", err, errno, retval, duration))
-		goto cleanup;
+	if (!ASSERT_OK(err, "test_run xchg") ||
+	    !ASSERT_OK(retval, "test_run xchg ret"))
+		return;
 
 	ASSERT_EQ(skel->data->xchg64_value, 2, "xchg64_value");
 	ASSERT_EQ(skel->bss->xchg64_result, 1, "xchg64_result");
 
 	ASSERT_EQ(skel->data->xchg32_value, 2, "xchg32_value");
 	ASSERT_EQ(skel->bss->xchg32_result, 1, "xchg32_result");
-
-cleanup:
-	close(link_fd);
 }
 
 void test_atomics(void)
 {
 	struct atomics_lskel *skel;
-	__u32 duration = 0;
 
 	skel = atomics_lskel__open_and_load();
-	if (CHECK(!skel, "skel_load", "atomics skeleton failed\n"))
+	if (!ASSERT_OK_PTR(skel, "atomics skeleton load"))
 		return;
 
 	if (skel->data->skip_tests) {
diff --git a/tools/testing/selftests/bpf/progs/atomics.c b/tools/testing/selftests/bpf/progs/atomics.c
index 16e57313204a..f89c7f0cc53b 100644
--- a/tools/testing/selftests/bpf/progs/atomics.c
+++ b/tools/testing/selftests/bpf/progs/atomics.c
@@ -20,8 +20,8 @@ __u64 add_stack_value_copy = 0;
 __u64 add_stack_result = 0;
 __u64 add_noreturn_value = 1;
 
-SEC("fentry/bpf_fentry_test1")
-int BPF_PROG(add, int a)
+SEC("raw_tp/sys_enter")
+int add(const void *ctx)
 {
 	if (pid != (bpf_get_current_pid_tgid() >> 32))
 		return 0;
@@ -46,8 +46,8 @@ __s64 sub_stack_value_copy = 0;
 __s64 sub_stack_result = 0;
 __s64 sub_noreturn_value = 1;
 
-SEC("fentry/bpf_fentry_test1")
-int BPF_PROG(sub, int a)
+SEC("raw_tp/sys_enter")
+int sub(const void *ctx)
 {
 	if (pid != (bpf_get_current_pid_tgid() >> 32))
 		return 0;
@@ -70,8 +70,8 @@ __u32 and32_value = 0x110;
 __u32 and32_result = 0;
 __u64 and_noreturn_value = (0x110ull << 32);
 
-SEC("fentry/bpf_fentry_test1")
-int BPF_PROG(and, int a)
+SEC("raw_tp/sys_enter")
+int and(const void *ctx)
 {
 	if (pid != (bpf_get_current_pid_tgid() >> 32))
 		return 0;
@@ -91,8 +91,8 @@ __u32 or32_value = 0x110;
 __u32 or32_result = 0;
 __u64 or_noreturn_value = (0x110ull << 32);
 
-SEC("fentry/bpf_fentry_test1")
-int BPF_PROG(or, int a)
+SEC("raw_tp/sys_enter")
+int or(const void *ctx)
 {
 	if (pid != (bpf_get_current_pid_tgid() >> 32))
 		return 0;
@@ -111,8 +111,8 @@ __u32 xor32_value = 0x110;
 __u32 xor32_result = 0;
 __u64 xor_noreturn_value = (0x110ull << 32);
 
-SEC("fentry/bpf_fentry_test1")
-int BPF_PROG(xor, int a)
+SEC("raw_tp/sys_enter")
+int xor(const void *ctx)
 {
 	if (pid != (bpf_get_current_pid_tgid() >> 32))
 		return 0;
@@ -132,8 +132,8 @@ __u32 cmpxchg32_value = 1;
 __u32 cmpxchg32_result_fail = 0;
 __u32 cmpxchg32_result_succeed = 0;
 
-SEC("fentry/bpf_fentry_test1")
-int BPF_PROG(cmpxchg, int a)
+SEC("raw_tp/sys_enter")
+int cmpxchg(const void *ctx)
 {
 	if (pid != (bpf_get_current_pid_tgid() >> 32))
 		return 0;
@@ -153,8 +153,8 @@ __u64 xchg64_result = 0;
 __u32 xchg32_value = 1;
 __u32 xchg32_result = 0;
 
-SEC("fentry/bpf_fentry_test1")
-int BPF_PROG(xchg, int a)
+SEC("raw_tp/sys_enter")
+int xchg(const void *ctx)
 {
 	if (pid != (bpf_get_current_pid_tgid() >> 32))
 		return 0;
-- 
2.27.0

