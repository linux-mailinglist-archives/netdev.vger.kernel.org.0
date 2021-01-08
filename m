Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E71E2EFAE7
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 23:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbhAHWKj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Jan 2021 17:10:39 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26218 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726380AbhAHWKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 17:10:38 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 108M94Kp021880
        for <netdev@vger.kernel.org>; Fri, 8 Jan 2021 14:09:58 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35wpuxas9w-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 14:09:58 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 8 Jan 2021 14:09:52 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6C44F2ECD237; Fri,  8 Jan 2021 14:09:46 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Hao Luo <haoluo@google.com>
Subject: [PATCH v2 bpf-next 7/7] selftests/bpf: test kernel module ksym externs
Date:   Fri, 8 Jan 2021 14:09:30 -0800
Message-ID: <20210108220930.482456-8-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210108220930.482456-1-andrii@kernel.org>
References: <20210108220930.482456-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-08_11:2021-01-07,2021-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0 clxscore=1034
 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add per-CPU variable to bpf_testmod.ko and use those from new selftest to
validate it works end-to-end.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  3 ++
 .../selftests/bpf/prog_tests/ksyms_module.c   | 33 +++++++++++++++++++
 .../selftests/bpf/progs/test_ksyms_module.c   | 26 +++++++++++++++
 3 files changed, 62 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module.c

diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index 2df19d73ca49..0b991e115d1f 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -3,6 +3,7 @@
 #include <linux/error-injection.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/percpu-defs.h>
 #include <linux/sysfs.h>
 #include <linux/tracepoint.h>
 #include "bpf_testmod.h"
@@ -10,6 +11,8 @@
 #define CREATE_TRACE_POINTS
 #include "bpf_testmod-events.h"
 
+DEFINE_PER_CPU(int, bpf_testmod_ksym_percpu) = 123;
+
 noinline ssize_t
 bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 		      struct bin_attribute *bin_attr,
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
new file mode 100644
index 000000000000..7fa3d8b6ca30
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include <test_progs.h>
+#include <bpf/libbpf.h>
+#include <bpf/btf.h>
+#include "test_ksyms_module.skel.h"
+
+static int duration;
+
+void test_ksyms_module(void)
+{
+	struct test_ksyms_module* skel;
+	struct test_ksyms_module__bss *bss;
+	int err;
+
+	skel = test_ksyms_module__open_and_load();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		return;
+	bss = skel->bss;
+
+	err = test_ksyms_module__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	usleep(1);
+
+	ASSERT_EQ(bss->triggered, true, "triggered");
+	ASSERT_EQ(bss->out_mod_ksym_global, 123, "global_ksym_val");
+
+cleanup:
+	test_ksyms_module__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_module.c b/tools/testing/selftests/bpf/progs/test_ksyms_module.c
new file mode 100644
index 000000000000..d6a0b3086b90
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_module.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+
+extern const int bpf_testmod_ksym_percpu __ksym;
+
+int out_mod_ksym_global = 0;
+bool triggered = false;
+
+SEC("raw_tp/sys_enter")
+int handler(const void *ctx)
+{
+	int *val;
+	__u32 cpu;
+
+	val = (int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
+	out_mod_ksym_global = *val;
+	triggered = true;
+
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
-- 
2.24.1

