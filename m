Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E95362947
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343561AbhDPUZO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 16 Apr 2021 16:25:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25728 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343620AbhDPUZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 16:25:04 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13GKK37b023921
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 13:24:39 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37wv9qr9sn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 13:24:39 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Apr 2021 13:24:39 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C03312ED4EE0; Fri, 16 Apr 2021 13:24:36 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 15/17] selftests/bpf: add function linking selftest
Date:   Fri, 16 Apr 2021 13:24:02 -0700
Message-ID: <20210416202404.3443623-16-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416202404.3443623-1-andrii@kernel.org>
References: <20210416202404.3443623-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: yYeqe76VlUGoRzy7Sf7rwmkKwvp2Fcfl
X-Proofpoint-ORIG-GUID: yYeqe76VlUGoRzy7Sf7rwmkKwvp2Fcfl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-16_09:2021-04-16,2021-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 clxscore=1034 adultscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104160143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftest validating various aspects of statically linking functions:
  - no conflicts and correct resolution for name-conflicting static funcs;
  - correct resolution of extern functions;
  - correct handling of weak functions, both resolution itself and libbpf's
    handling of unused weak function that "lost" (it leaves gaps in code with
    no ELF symbols);
  - correct handling of hidden visibility to turn global function into
    "static" for the purpose of BPF verification.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |  3 +-
 .../selftests/bpf/prog_tests/linked_funcs.c   | 42 +++++++++++
 .../selftests/bpf/progs/linked_funcs1.c       | 73 +++++++++++++++++++
 .../selftests/bpf/progs/linked_funcs2.c       | 73 +++++++++++++++++++
 4 files changed, 190 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_funcs.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs1.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs2.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 666b462c1218..427ccfec1a6a 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -308,9 +308,10 @@ endef
 
 SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
 
-LINKED_SKELS := test_static_linked.skel.h
+LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h
 
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
+linked_funcs.skel.h-deps := linked_funcs1.o linked_funcs2.o
 
 LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
 
diff --git a/tools/testing/selftests/bpf/prog_tests/linked_funcs.c b/tools/testing/selftests/bpf/prog_tests/linked_funcs.c
new file mode 100644
index 000000000000..03bf8ef131ce
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/linked_funcs.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include <test_progs.h>
+#include <sys/syscall.h>
+#include "linked_funcs.skel.h"
+
+void test_linked_funcs(void)
+{
+	int err;
+	struct linked_funcs *skel;
+
+	skel = linked_funcs__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	skel->rodata->my_tid = syscall(SYS_gettid);
+	skel->rodata->syscall_id = SYS_getpgid;
+
+	err = linked_funcs__load(skel);
+	if (!ASSERT_OK(err, "skel_load"))
+		goto cleanup;
+
+	err = linked_funcs__attach(skel);
+	if (!ASSERT_OK(err, "skel_attach"))
+		goto cleanup;
+
+	/* trigger */
+	syscall(SYS_getpgid);
+
+	ASSERT_EQ(skel->bss->output_val1, 2000 + 2000, "output_val1");
+	ASSERT_EQ(skel->bss->output_ctx1, SYS_getpgid, "output_ctx1");
+	ASSERT_EQ(skel->bss->output_weak1, 42, "output_weak1");
+
+	ASSERT_EQ(skel->bss->output_val2, 2 * 1000 + 2 * (2 * 1000), "output_val2");
+	ASSERT_EQ(skel->bss->output_ctx2, SYS_getpgid, "output_ctx2");
+	/* output_weak2 should never be updated */
+	ASSERT_EQ(skel->bss->output_weak2, 0, "output_weak2");
+
+cleanup:
+	linked_funcs__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/linked_funcs1.c b/tools/testing/selftests/bpf/progs/linked_funcs1.c
new file mode 100644
index 000000000000..cc621d4e4d82
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/linked_funcs1.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/* weak and shared between two files */
+const volatile int my_tid __weak = 0;
+const volatile long syscall_id __weak = 0;
+
+int output_val1 = 0;
+int output_ctx1 = 0;
+int output_weak1 = 0;
+
+/* same "subprog" name in all files, but it's ok because they all are static */
+static __noinline int subprog(int x)
+{
+	/* but different formula */
+	return x * 1;
+}
+
+/* Global functions can't be void */
+int set_output_val1(int x)
+{
+	output_val1 = x + subprog(x);
+	return x;
+}
+
+/* This function can't be verified as global, as it assumes raw_tp/sys_enter
+ * context and accesses syscall id (second argument). So we mark it as
+ * __hidden, so that libbpf will mark it as static in the final object file,
+ * right before verifying it in the kernel.
+ *
+ * But we don't mark it as __hidden here, rather at extern site. __hidden is
+ * "contaminating" visibility, so it will get propagated from either extern or
+ * actual definition (including from the losing __weak definition).
+ */
+void set_output_ctx1(__u64 *ctx)
+{
+	output_ctx1 = ctx[1]; /* long id, same as in BPF_PROG below */
+}
+
+/* this weak instance should win because it's the first one */
+__weak int set_output_weak(int x)
+{
+	output_weak1 = x;
+	return x;
+}
+
+extern int set_output_val2(int x);
+
+/* here we'll force set_output_ctx2() to be __hidden in the final obj file */
+__hidden extern void set_output_ctx2(__u64 *ctx);
+
+SEC("raw_tp/sys_enter")
+int BPF_PROG(handler1, struct pt_regs *regs, long id)
+{
+	if (my_tid != (u32)bpf_get_current_pid_tgid() || id != syscall_id)
+		return 0;
+
+	set_output_val2(1000);
+	set_output_ctx2(ctx); /* ctx definition is hidden in BPF_PROG macro */
+
+	/* keep input value the same across both files to avoid dependency on
+	 * handler call order; differentiate by output_weak1 vs output_weak2.
+	 */
+	set_output_weak(42);
+
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/linked_funcs2.c b/tools/testing/selftests/bpf/progs/linked_funcs2.c
new file mode 100644
index 000000000000..a5a935a4f748
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/linked_funcs2.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/* weak and shared between both files */
+const volatile int my_tid __weak = 0;
+const volatile long syscall_id __weak = 0;
+
+int output_val2 = 0;
+int output_ctx2 = 0;
+int output_weak2 = 0; /* should stay zero */
+
+/* same "subprog" name in all files, but it's ok because they all are static */
+static __noinline int subprog(int x)
+{
+	/* but different formula */
+	return x * 2;
+}
+
+/* Global functions can't be void */
+int set_output_val2(int x)
+{
+	output_val2 = 2 * x + 2 * subprog(x);
+	return 2 * x;
+}
+
+/* This function can't be verified as global, as it assumes raw_tp/sys_enter
+ * context and accesses syscall id (second argument). So we mark it as
+ * __hidden, so that libbpf will mark it as static in the final object file,
+ * right before verifying it in the kernel.
+ *
+ * But we don't mark it as __hidden here, rather at extern site. __hidden is
+ * "contaminating" visibility, so it will get propagated from either extern or
+ * actual definition (including from the losing __weak definition).
+ */
+void set_output_ctx2(__u64 *ctx)
+{
+	output_ctx2 = ctx[1]; /* long id, same as in BPF_PROG below */
+}
+
+/* this weak instance should lose, because it will be processed second */
+__weak int set_output_weak(int x)
+{
+	output_weak2 = x;
+	return 2 * x;
+}
+
+extern int set_output_val1(int x);
+
+/* here we'll force set_output_ctx1() to be __hidden in the final obj file */
+__hidden extern void set_output_ctx1(__u64 *ctx);
+
+SEC("raw_tp/sys_enter")
+int BPF_PROG(handler2, struct pt_regs *regs, long id)
+{
+	if (my_tid != (u32)bpf_get_current_pid_tgid() || id != syscall_id)
+		return 0;
+
+	set_output_val1(2000);
+	set_output_ctx1(ctx); /* ctx definition is hidden in BPF_PROG macro */
+
+	/* keep input value the same across both files to avoid dependency on
+	 * handler call order; differentiate by output_weak1 vs output_weak2.
+	 */
+	set_output_weak(42);
+
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
-- 
2.30.2

