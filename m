Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB38369900
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243675AbhDWSPy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 14:15:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55354 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243514AbhDWSPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:15:15 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NI98Jl001433
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:38 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3839usrkyf-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:38 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:14:31 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 75DFD2ED5CB8; Fri, 23 Apr 2021 11:14:28 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH v3 bpf-next 16/18] selftests/bpf: add global variables linking selftest
Date:   Fri, 23 Apr 2021 11:13:46 -0700
Message-ID: <20210423181348.1801389-17-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423181348.1801389-1-andrii@kernel.org>
References: <20210423181348.1801389-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: BqZjZo6fWhY221r_5IwX2K5wmgb4rcg5
X-Proofpoint-ORIG-GUID: BqZjZo6fWhY221r_5IwX2K5wmgb4rcg5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 mlxscore=0 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftest validating various aspects of statically linking global
variables:
  - correct resolution of extern variables across .bss, .data, and .rodata
    sections;
  - correct handling of weak definitions;
  - correct de-duplication of repeating special externs (.kconfig, .ksyms).

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |  3 +-
 .../selftests/bpf/prog_tests/linked_vars.c    | 43 +++++++++++++++
 .../selftests/bpf/progs/linked_vars1.c        | 54 ++++++++++++++++++
 .../selftests/bpf/progs/linked_vars2.c        | 55 +++++++++++++++++++
 4 files changed, 154 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_vars.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_vars1.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_vars2.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index ab7b129a8408..411e2cf07ba5 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -309,10 +309,11 @@ endef
 
 SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
 
-LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h
+LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h linked_vars.skel.h
 
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
 linked_funcs.skel.h-deps := linked_funcs1.o linked_funcs2.o
+linked_vars.skel.h-deps := linked_vars1.o linked_vars2.o
 
 LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
 
diff --git a/tools/testing/selftests/bpf/prog_tests/linked_vars.c b/tools/testing/selftests/bpf/prog_tests/linked_vars.c
new file mode 100644
index 000000000000..267166abe4c1
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/linked_vars.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include <test_progs.h>
+#include <sys/syscall.h>
+#include "linked_vars.skel.h"
+
+void test_linked_vars(void)
+{
+	int err;
+	struct linked_vars *skel;
+
+	skel = linked_vars__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	skel->bss->input_bss1 = 1000;
+	skel->bss->input_bss2 = 2000;
+	skel->bss->input_bss_weak = 3000;
+
+	err = linked_vars__load(skel);
+	if (!ASSERT_OK(err, "skel_load"))
+		goto cleanup;
+
+	err = linked_vars__attach(skel);
+	if (!ASSERT_OK(err, "skel_attach"))
+		goto cleanup;
+
+	/* trigger */
+	syscall(SYS_getpgid);
+
+	ASSERT_EQ(skel->bss->output_bss1, 1000 + 2000 + 3000, "output_bss1");
+	ASSERT_EQ(skel->bss->output_bss2, 1000 + 2000 + 3000, "output_bss2");
+	/* 10 comes from "winner" input_data_weak in first obj file */
+	ASSERT_EQ(skel->bss->output_data1, 1 + 2 + 10, "output_bss1");
+	ASSERT_EQ(skel->bss->output_data2, 1 + 2 + 10, "output_bss2");
+	/* 100 comes from "winner" input_rodata_weak in first obj file */
+	ASSERT_EQ(skel->bss->output_rodata1, 11 + 22 + 100, "output_weak1");
+	ASSERT_EQ(skel->bss->output_rodata2, 11 + 22 + 100, "output_weak2");
+
+cleanup:
+	linked_vars__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/linked_vars1.c b/tools/testing/selftests/bpf/progs/linked_vars1.c
new file mode 100644
index 000000000000..ef9e9d0bb0ca
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/linked_vars1.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+extern int LINUX_KERNEL_VERSION __kconfig;
+/* this weak extern will be strict due to the other file's strong extern */
+extern bool CONFIG_BPF_SYSCALL __kconfig __weak;
+extern const void bpf_link_fops __ksym __weak;
+
+int input_bss1;
+int input_data1 = 1;
+const volatile int input_rodata1 = 11;
+
+int input_bss_weak __weak;
+/* these two definitions should win */
+int input_data_weak __weak = 10;
+const volatile int input_rodata_weak __weak = 100;
+
+extern int input_bss2;
+extern int input_data2;
+extern const int input_rodata2;
+
+int output_bss1;
+int output_data1;
+int output_rodata1;
+
+long output_sink1;
+
+static __noinline int get_bss_res(void)
+{
+	/* just make sure all the relocations work against .text as well */
+	return input_bss1 + input_bss2 + input_bss_weak;
+}
+
+SEC("raw_tp/sys_enter")
+int BPF_PROG(handler1)
+{
+	output_bss1 = get_bss_res();
+	output_data1 = input_data1 + input_data2 + input_data_weak;
+	output_rodata1 = input_rodata1 + input_rodata2 + input_rodata_weak;
+
+	/* make sure we actually use above special externs, otherwise compiler
+	 * will optimize them out
+	 */
+	output_sink1 = LINUX_KERNEL_VERSION
+		       + CONFIG_BPF_SYSCALL
+		       + (long)&bpf_link_fops;
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/linked_vars2.c b/tools/testing/selftests/bpf/progs/linked_vars2.c
new file mode 100644
index 000000000000..e4f5bd388a3c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/linked_vars2.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+extern int LINUX_KERNEL_VERSION __kconfig;
+/* when an extern is defined as both strong and weak, resulting symbol will be strong */
+extern bool CONFIG_BPF_SYSCALL __kconfig;
+extern const void __start_BTF __ksym;
+
+int input_bss2;
+int input_data2 = 2;
+const volatile int input_rodata2 = 22;
+
+int input_bss_weak __weak;
+/* these two weak variables should lose */
+int input_data_weak __weak = 20;
+const volatile int input_rodata_weak __weak = 200;
+
+extern int input_bss1;
+extern int input_data1;
+extern const int input_rodata1;
+
+int output_bss2;
+int output_data2;
+int output_rodata2;
+
+int output_sink2;
+
+static __noinline int get_data_res(void)
+{
+	/* just make sure all the relocations work against .text as well */
+	return input_data1 + input_data2 + input_data_weak;
+}
+
+SEC("raw_tp/sys_enter")
+int BPF_PROG(handler2)
+{
+	output_bss2 = input_bss1 + input_bss2 + input_bss_weak;
+	output_data2 = get_data_res();
+	output_rodata2 = input_rodata1 + input_rodata2 + input_rodata_weak;
+
+	/* make sure we actually use above special externs, otherwise compiler
+	 * will optimize them out
+	 */
+	output_sink2 = LINUX_KERNEL_VERSION
+		       + CONFIG_BPF_SYSCALL
+		       + (long)&__start_BTF;
+
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
-- 
2.30.2

