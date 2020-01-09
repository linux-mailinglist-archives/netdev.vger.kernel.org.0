Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A8613534C
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 07:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgAIGiN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 9 Jan 2020 01:38:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2214 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728198AbgAIGiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 01:38:09 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0096c7Pa002513
        for <netdev@vger.kernel.org>; Wed, 8 Jan 2020 22:38:08 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xd3ep7r9r-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 22:38:08 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 Jan 2020 22:38:06 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id DD6C5760FEC; Wed,  8 Jan 2020 22:37:59 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 7/7] selftests/bpf: Add unit tests for global functions
Date:   Wed, 8 Jan 2020 22:37:45 -0800
Message-ID: <20200109063745.3154913-8-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200109063745.3154913-1-ast@kernel.org>
References: <20200109063745.3154913-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_01:2020-01-08,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=999 phishscore=0 clxscore=1034 impostorscore=0 mlxscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_global_func[12] - check 512 stack limit.
test_global_func[34] - check 8 frame call chain limit.
test_global_func5    - check that non-ctx pointer cannot be passed into
                       a function that expects context.
test_global_func6    - check that ctx pointer is unmodified.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../bpf/prog_tests/test_global_funcs.c        | 81 +++++++++++++++++++
 .../selftests/bpf/progs/test_global_func1.c   | 45 +++++++++++
 .../selftests/bpf/progs/test_global_func2.c   |  4 +
 .../selftests/bpf/progs/test_global_func3.c   | 65 +++++++++++++++
 .../selftests/bpf/progs/test_global_func4.c   |  4 +
 .../selftests/bpf/progs/test_global_func5.c   | 31 +++++++
 .../selftests/bpf/progs/test_global_func6.c   | 31 +++++++
 7 files changed, 261 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func1.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func2.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func3.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func4.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func5.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func6.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
new file mode 100644
index 000000000000..bc588fa87d65
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <test_progs.h>
+
+const char *err_str;
+bool found;
+
+static int libbpf_debug_print(enum libbpf_print_level level,
+			      const char *format, va_list args)
+{
+	char *log_buf;
+
+	if (level != LIBBPF_WARN ||
+	    strcmp(format, "libbpf: \n%s\n")) {
+		vprintf(format, args);
+		return 0;
+	}
+
+	log_buf = va_arg(args, char *);
+	if (!log_buf)
+		goto out;
+	if (strstr(log_buf, err_str) == 0)
+		found = true;
+out:
+	printf(format, log_buf);
+	return 0;
+}
+
+extern int extra_prog_load_log_flags;
+
+static int check_load(const char *file)
+{
+	struct bpf_prog_load_attr attr;
+	struct bpf_object *obj = NULL;
+	int err, prog_fd;
+
+	memset(&attr, 0, sizeof(struct bpf_prog_load_attr));
+	attr.file = file;
+	attr.prog_type = BPF_PROG_TYPE_UNSPEC;
+	attr.log_level = extra_prog_load_log_flags;
+	attr.prog_flags = BPF_F_TEST_RND_HI32;
+	found = false;
+	err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
+	bpf_object__close(obj);
+	return err;
+}
+
+struct test_def {
+	const char *file;
+	const char *err_str;
+};
+
+void test_test_global_funcs(void)
+{
+	struct test_def tests[] = {
+		{ "test_global_func1.o", "combined stack size of 4 calls is 544" },
+		{ "test_global_func2.o" },
+		{ "test_global_func3.o" , "the call stack of 8 frames" },
+		{ "test_global_func4.o" },
+		{ "test_global_func5.o" , "expected pointer to ctx, but got PTR" },
+		{ "test_global_func6.o" , "modified ctx ptr R2" },
+	};
+	libbpf_print_fn_t old_print_fn = NULL;
+	int err, i, duration = 0;
+
+	old_print_fn = libbpf_set_print(libbpf_debug_print);
+
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		const struct test_def *test = &tests[i];
+
+		if (!test__start_subtest(test->file))
+			continue;
+
+		err_str = test->err_str;
+		err = check_load(test->file);
+		CHECK_FAIL(!!err ^ !!err_str);
+		if (err_str)
+			CHECK(found, "", "expected string '%s'", err_str);
+	}
+	libbpf_set_print(old_print_fn);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_global_func1.c b/tools/testing/selftests/bpf/progs/test_global_func1.c
new file mode 100644
index 000000000000..97d57d6e244e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_global_func1.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Facebook */
+#include <stddef.h>
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+#ifndef MAX_STACK
+#define MAX_STACK (512 - 3 * 32 + 8)
+#endif
+
+static __attribute__ ((noinline))
+int f0(int var, struct __sk_buff *skb)
+{
+	return skb->len;
+}
+
+__attribute__ ((noinline))
+int f1(struct __sk_buff *skb)
+{
+	volatile char buf[MAX_STACK] = {};
+
+	return f0(0, skb) + skb->len;
+}
+
+int f3(int, struct __sk_buff *skb, int);
+
+__attribute__ ((noinline))
+int f2(int val, struct __sk_buff *skb)
+{
+	return f1(skb) + f3(val, skb, 1);
+}
+
+__attribute__ ((noinline))
+int f3(int val, struct __sk_buff *skb, int var)
+{
+	volatile char buf[MAX_STACK] = {};
+
+	return skb->ifindex * val * var;
+}
+
+SEC("classifier/test")
+int test_cls(struct __sk_buff *skb)
+{
+	return f0(1, skb) + f1(skb) + f2(2, skb) + f3(3, skb, 4);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_global_func2.c b/tools/testing/selftests/bpf/progs/test_global_func2.c
new file mode 100644
index 000000000000..2c18d82923a2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_global_func2.c
@@ -0,0 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Facebook */
+#define MAX_STACK (512 - 3 * 32)
+#include "test_global_func1.c"
diff --git a/tools/testing/selftests/bpf/progs/test_global_func3.c b/tools/testing/selftests/bpf/progs/test_global_func3.c
new file mode 100644
index 000000000000..514ecf9f51b0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_global_func3.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Facebook */
+#include <stddef.h>
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+__attribute__ ((noinline))
+int f1(struct __sk_buff *skb)
+{
+	return skb->len;
+}
+
+__attribute__ ((noinline))
+int f2(int val, struct __sk_buff *skb)
+{
+	return f1(skb) + val;
+}
+
+__attribute__ ((noinline))
+int f3(int val, struct __sk_buff *skb, int var)
+{
+	return f2(var, skb) + val;
+}
+
+__attribute__ ((noinline))
+int f4(struct __sk_buff *skb)
+{
+	return f3(1, skb, 2);
+}
+
+__attribute__ ((noinline))
+int f5(struct __sk_buff *skb)
+{
+	return f4(skb);
+}
+
+__attribute__ ((noinline))
+int f6(struct __sk_buff *skb)
+{
+	return f5(skb);
+}
+
+__attribute__ ((noinline))
+int f7(struct __sk_buff *skb)
+{
+	return f6(skb);
+}
+
+#ifndef NO_FN8
+__attribute__ ((noinline))
+int f8(struct __sk_buff *skb)
+{
+	return f7(skb);
+}
+#endif
+
+SEC("classifier/test")
+int test_cls(struct __sk_buff *skb)
+{
+#ifndef NO_FN8
+	return f8(skb);
+#else
+	return f7(skb);
+#endif
+}
diff --git a/tools/testing/selftests/bpf/progs/test_global_func4.c b/tools/testing/selftests/bpf/progs/test_global_func4.c
new file mode 100644
index 000000000000..610f75edf276
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_global_func4.c
@@ -0,0 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Facebook */
+#define NO_FN8
+#include "test_global_func3.c"
diff --git a/tools/testing/selftests/bpf/progs/test_global_func5.c b/tools/testing/selftests/bpf/progs/test_global_func5.c
new file mode 100644
index 000000000000..86787c03cea8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_global_func5.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Facebook */
+#include <stddef.h>
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+__attribute__ ((noinline))
+int f1(struct __sk_buff *skb)
+{
+	return skb->len;
+}
+
+int f3(int, struct __sk_buff *skb);
+
+__attribute__ ((noinline))
+int f2(int val, struct __sk_buff *skb)
+{
+	return f1(skb) + f3(val, (void *)&val); /* type mismatch */
+}
+
+__attribute__ ((noinline))
+int f3(int val, struct __sk_buff *skb)
+{
+	return skb->ifindex * val;
+}
+
+SEC("classifier/test")
+int test_cls(struct __sk_buff *skb)
+{
+	return f1(skb) + f2(2, skb) + f3(3, skb);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_global_func6.c b/tools/testing/selftests/bpf/progs/test_global_func6.c
new file mode 100644
index 000000000000..e215fb3e6f02
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_global_func6.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Facebook */
+#include <stddef.h>
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+__attribute__ ((noinline))
+int f1(struct __sk_buff *skb)
+{
+	return skb->len;
+}
+
+int f3(int, struct __sk_buff *skb);
+
+__attribute__ ((noinline))
+int f2(int val, struct __sk_buff *skb)
+{
+	return f1(skb) + f3(val, skb + 1); /* type mismatch */
+}
+
+__attribute__ ((noinline))
+int f3(int val, struct __sk_buff *skb)
+{
+	return skb->ifindex * val;
+}
+
+SEC("classifier/test")
+int test_cls(struct __sk_buff *skb)
+{
+	return f1(skb) + f2(2, skb) + f3(3, skb);
+}
-- 
2.23.0

