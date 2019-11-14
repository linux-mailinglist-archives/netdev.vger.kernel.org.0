Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F514FCE45
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfKNS5n convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Nov 2019 13:57:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14404 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727059AbfKNS5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:57:41 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAEIeD8I016535
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:40 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w8u0tcu50-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:40 -0800
Received: from 2401:db00:2120:80e1:face:0:29:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 14 Nov 2019 10:57:39 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 53A6E76071B; Thu, 14 Nov 2019 10:57:39 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 09/20] selftests/bpf: Add test for BPF trampoline
Date:   Thu, 14 Nov 2019 10:57:09 -0800
Message-ID: <20191114185720.1641606-10-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114185720.1641606-1-ast@kernel.org>
References: <20191114185720.1641606-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=1 malwarescore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 mlxlogscore=913
 impostorscore=0 mlxscore=0 clxscore=1034 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911140157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add sanity test for BPF trampoline that checks kernel functions
with up to 6 arguments of different sizes.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
---
 tools/lib/bpf/bpf_helpers.h                   | 13 +++
 .../selftests/bpf/prog_tests/fentry_test.c    | 64 +++++++++++++
 .../testing/selftests/bpf/progs/fentry_test.c | 90 +++++++++++++++++++
 3 files changed, 167 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/fentry_test.c

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 0c7d28292898..c63ab1add126 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -44,4 +44,17 @@ enum libbpf_pin_type {
 	LIBBPF_PIN_BY_NAME,
 };
 
+/* The following types should be used by BPF_PROG_TYPE_TRACING program to
+ * access kernel function arguments. BPF trampoline and raw tracepoints
+ * typecast arguments to 'unsigned long long'.
+ */
+typedef int __attribute__((aligned(8))) ks32;
+typedef char __attribute__((aligned(8))) ks8;
+typedef short __attribute__((aligned(8))) ks16;
+typedef long long __attribute__((aligned(8))) ks64;
+typedef unsigned int __attribute__((aligned(8))) ku32;
+typedef unsigned char __attribute__((aligned(8))) ku8;
+typedef unsigned short __attribute__((aligned(8))) ku16;
+typedef unsigned long long __attribute__((aligned(8))) ku64;
+
 #endif
diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
new file mode 100644
index 000000000000..9fb103193878
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+#include <test_progs.h>
+
+void test_fentry_test(void)
+{
+	struct bpf_prog_load_attr attr = {
+		.file = "./fentry_test.o",
+	};
+
+	char prog_name[] = "fentry/bpf_fentry_testX";
+	struct bpf_object *obj = NULL, *pkt_obj;
+	int err, pkt_fd, kfree_skb_fd, i;
+	struct bpf_link *link[6] = {};
+	struct bpf_program *prog[6];
+	__u32 duration, retval;
+	struct bpf_map *data_map;
+	const int zero = 0;
+	u64 result[6];
+
+	err = bpf_prog_load("./test_pkt_access.o", BPF_PROG_TYPE_SCHED_CLS,
+			    &pkt_obj, &pkt_fd);
+	if (CHECK(err, "prog_load sched cls", "err %d errno %d\n", err, errno))
+		return;
+	err = bpf_prog_load_xattr(&attr, &obj, &kfree_skb_fd);
+	if (CHECK(err, "prog_load fail", "err %d errno %d\n", err, errno))
+		goto close_prog;
+
+	for (i = 0; i < 6; i++) {
+		prog_name[sizeof(prog_name) - 2] = '1' + i;
+		prog[i] = bpf_object__find_program_by_title(obj, prog_name);
+		if (CHECK(!prog[i], "find_prog", "prog %s not found\n", prog_name))
+			goto close_prog;
+		link[i] = bpf_program__attach_trace(prog[i]);
+		if (CHECK(IS_ERR(link[i]), "attach_trace", "failed to link\n"))
+			goto close_prog;
+	}
+	data_map = bpf_object__find_map_by_name(obj, "fentry_t.bss");
+	if (CHECK(!data_map, "find_data_map", "data map not found\n"))
+		goto close_prog;
+
+	err = bpf_prog_test_run(pkt_fd, 1, &pkt_v6, sizeof(pkt_v6),
+				NULL, NULL, &retval, &duration);
+	CHECK(err || retval, "ipv6",
+	      "err %d errno %d retval %d duration %d\n",
+	      err, errno, retval, duration);
+
+	err = bpf_map_lookup_elem(bpf_map__fd(data_map), &zero, &result);
+	if (CHECK(err, "get_result",
+		  "failed to get output data: %d\n", err))
+		goto close_prog;
+
+	for (i = 0; i < 6; i++)
+		if (CHECK(result[i] != 1, "result", "bpf_fentry_test%d failed err %ld\n",
+			  i + 1, result[i]))
+			goto close_prog;
+
+close_prog:
+	for (i = 0; i < 6; i++)
+		if (!IS_ERR_OR_NULL(link[i]))
+			bpf_link__destroy(link[i]);
+	bpf_object__close(obj);
+	bpf_object__close(pkt_obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/fentry_test.c b/tools/testing/selftests/bpf/progs/fentry_test.c
new file mode 100644
index 000000000000..545788bf8d50
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/fentry_test.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+
+struct test1 {
+	ks32 a;
+};
+static volatile __u64 test1_result;
+SEC("fentry/bpf_fentry_test1")
+int test1(struct test1 *ctx)
+{
+	test1_result = ctx->a == 1;
+	return 0;
+}
+
+struct test2 {
+	ks32 a;
+	ku64 b;
+};
+static volatile __u64 test2_result;
+SEC("fentry/bpf_fentry_test2")
+int test2(struct test2 *ctx)
+{
+	test2_result = ctx->a == 2 && ctx->b == 3;
+	return 0;
+}
+
+struct test3 {
+	ks8 a;
+	ks32 b;
+	ku64 c;
+};
+static volatile __u64 test3_result;
+SEC("fentry/bpf_fentry_test3")
+int test3(struct test3 *ctx)
+{
+	test3_result = ctx->a == 4 && ctx->b == 5 && ctx->c == 6;
+	return 0;
+}
+
+struct test4 {
+	void *a;
+	ks8 b;
+	ks32 c;
+	ku64 d;
+};
+static volatile __u64 test4_result;
+SEC("fentry/bpf_fentry_test4")
+int test4(struct test4 *ctx)
+{
+	test4_result = ctx->a == (void *)7 && ctx->b == 8 && ctx->c == 9 &&
+		ctx->d == 10;
+	return 0;
+}
+
+struct test5 {
+	ku64 a;
+	void *b;
+	ks16 c;
+	ks32 d;
+	ku64 e;
+};
+static volatile __u64 test5_result;
+SEC("fentry/bpf_fentry_test5")
+int test5(struct test5 *ctx)
+{
+	test5_result = ctx->a == 11 && ctx->b == (void *)12 && ctx->c == 13 &&
+		ctx->d == 14 && ctx->e == 15;
+	return 0;
+}
+
+struct test6 {
+	ku64 a;
+	void *b;
+	ks16 c;
+	ks32 d;
+	void *e;
+	ks64 f;
+};
+static volatile __u64 test6_result;
+SEC("fentry/bpf_fentry_test6")
+int test6(struct test6 *ctx)
+{
+	test6_result = ctx->a == 16 && ctx->b == (void *)17 && ctx->c == 18 &&
+		ctx->d == 19 && ctx->e == (void *)20 && ctx->f == 21;
+	return 0;
+}
-- 
2.23.0

