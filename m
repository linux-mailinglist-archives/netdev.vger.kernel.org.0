Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08056FCE52
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfKNS5s convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Nov 2019 13:57:48 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64896 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727199AbfKNS5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:57:46 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAEIhSha013417
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:45 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w8rgdnqc9-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:45 -0800
Received: from 2401:db00:2050:5076:face:0:1f:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 14 Nov 2019 10:57:41 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 5DD6C76071B; Thu, 14 Nov 2019 10:57:41 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 10/20] selftests/bpf: Add fexit tests for BPF trampoline
Date:   Thu, 14 Nov 2019 10:57:10 -0800
Message-ID: <20191114185720.1641606-11-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114185720.1641606-1-ast@kernel.org>
References: <20191114185720.1641606-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=869 mlxscore=0 suspectscore=1 clxscore=1034 priorityscore=1501
 phishscore=0 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add fexit tests for BPF trampoline that checks kernel functions
with up to 6 arguments of different sizes and their return values.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/prog_tests/fexit_test.c     | 64 ++++++++++++
 .../testing/selftests/bpf/progs/fexit_test.c  | 98 +++++++++++++++++++
 2 files changed, 162 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fexit_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/fexit_test.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_test.c b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
new file mode 100644
index 000000000000..f99013222c74
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+#include <test_progs.h>
+
+void test_fexit_test(void)
+{
+	struct bpf_prog_load_attr attr = {
+		.file = "./fexit_test.o",
+	};
+
+	char prog_name[] = "fexit/bpf_fentry_testX";
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
+	data_map = bpf_object__find_map_by_name(obj, "fexit_te.bss");
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
diff --git a/tools/testing/selftests/bpf/progs/fexit_test.c b/tools/testing/selftests/bpf/progs/fexit_test.c
new file mode 100644
index 000000000000..8b98b1a51784
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/fexit_test.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+
+struct test1 {
+	ks32 a;
+	ks32 ret;
+};
+static volatile __u64 test1_result;
+SEC("fexit/bpf_fentry_test1")
+int test1(struct test1 *ctx)
+{
+	test1_result = ctx->a == 1 && ctx->ret == 2;
+	return 0;
+}
+
+struct test2 {
+	ks32 a;
+	ku64 b;
+	ks32 ret;
+};
+static volatile __u64 test2_result;
+SEC("fexit/bpf_fentry_test2")
+int test2(struct test2 *ctx)
+{
+	test2_result = ctx->a == 2 && ctx->b == 3 && ctx->ret == 5;
+	return 0;
+}
+
+struct test3 {
+	ks8 a;
+	ks32 b;
+	ku64 c;
+	ks32 ret;
+};
+static volatile __u64 test3_result;
+SEC("fexit/bpf_fentry_test3")
+int test3(struct test3 *ctx)
+{
+	test3_result = ctx->a == 4 && ctx->b == 5 && ctx->c == 6 &&
+		ctx->ret == 15;
+	return 0;
+}
+
+struct test4 {
+	void *a;
+	ks8 b;
+	ks32 c;
+	ku64 d;
+	ks32 ret;
+};
+static volatile __u64 test4_result;
+SEC("fexit/bpf_fentry_test4")
+int test4(struct test4 *ctx)
+{
+	test4_result = ctx->a == (void *)7 && ctx->b == 8 && ctx->c == 9 &&
+		ctx->d == 10 && ctx->ret == 34;
+	return 0;
+}
+
+struct test5 {
+	ku64 a;
+	void *b;
+	ks16 c;
+	ks32 d;
+	ku64 e;
+	ks32 ret;
+};
+static volatile __u64 test5_result;
+SEC("fexit/bpf_fentry_test5")
+int test5(struct test5 *ctx)
+{
+	test5_result = ctx->a == 11 && ctx->b == (void *)12 && ctx->c == 13 &&
+		ctx->d == 14 && ctx->e == 15 && ctx->ret == 65;
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
+	ks32 ret;
+};
+static volatile __u64 test6_result;
+SEC("fexit/bpf_fentry_test6")
+int test6(struct test6 *ctx)
+{
+	test6_result = ctx->a == 16 && ctx->b == (void *)17 && ctx->c == 18 &&
+		ctx->d == 19 && ctx->e == (void *)20 && ctx->f == 21 &&
+		ctx->ret == 111;
+	return 0;
+}
-- 
2.23.0

