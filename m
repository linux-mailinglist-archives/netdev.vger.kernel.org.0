Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0510AF409E
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 07:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbfKHGlV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Nov 2019 01:41:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35680 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729919AbfKHGlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 01:41:20 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA86eNWq029102
        for <netdev@vger.kernel.org>; Thu, 7 Nov 2019 22:41:19 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41un9ryk-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 22:41:19 -0800
Received: from 2401:db00:2120:81ca:face:0:31:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 7 Nov 2019 22:41:18 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 23A2A760F61; Thu,  7 Nov 2019 22:41:16 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 18/18] selftests/bpf: Add a test for attaching BPF prog to another BPF prog and subprog
Date:   Thu, 7 Nov 2019 22:40:39 -0800
Message-ID: <20191108064039.2041889-19-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108064039.2041889-1-ast@kernel.org>
References: <20191108064039.2041889-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 mlxscore=0 spamscore=0 suspectscore=1 impostorscore=0 mlxlogscore=802
 lowpriorityscore=0 clxscore=1034 malwarescore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080065
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test that attaches one FEXIT program to main sched_cls networking program
and two other FEXIT programs to subprograms. All three tracing programs
access return values and skb->len of networking program and subprograms.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 76 ++++++++++++++++
 .../selftests/bpf/progs/fexit_bpf2bpf.c       | 91 +++++++++++++++++++
 2 files changed, 167 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
new file mode 100644
index 000000000000..15c7378362dd
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+#include <test_progs.h>
+
+#define PROG_CNT 3
+
+void test_fexit_bpf2bpf(void)
+{
+	const char *prog_name[PROG_CNT] = {
+		"fexit/test_pkt_access",
+		"fexit/test_pkt_access_subprog1",
+		"fexit/test_pkt_access_subprog2",
+	};
+	struct bpf_object *obj = NULL, *pkt_obj;
+	int err, pkt_fd, i;
+	struct bpf_link *link[PROG_CNT] = {};
+	struct bpf_program *prog[PROG_CNT];
+	__u32 duration, retval;
+	struct bpf_map *data_map;
+	const int zero = 0;
+	u64 result[PROG_CNT];
+
+	err = bpf_prog_load("./test_pkt_access.o", BPF_PROG_TYPE_UNSPEC,
+			    &pkt_obj, &pkt_fd);
+	if (CHECK(err, "prog_load sched cls", "err %d errno %d\n", err, errno))
+		return;
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
+			    .attach_prog_fd = pkt_fd,
+			   );
+
+	obj = bpf_object__open_file("./fexit_bpf2bpf.o", &opts);
+	if (CHECK(IS_ERR_OR_NULL(obj), "obj_open",
+		  "failed to open fexit_bpf2bpf: %ld\n",
+		  PTR_ERR(obj)))
+		goto close_prog;
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "obj_load", "err %d\n", err))
+		goto close_prog;
+
+	for (i = 0; i < PROG_CNT; i++) {
+		prog[i] = bpf_object__find_program_by_title(obj, prog_name[i]);
+		if (CHECK(!prog[i], "find_prog", "prog %s not found\n", prog_name[i]))
+			goto close_prog;
+		link[i] = bpf_program__attach_trace(prog[i]);
+		if (CHECK(IS_ERR(link[i]), "attach_trace", "failed to link\n"))
+			goto close_prog;
+	}
+	data_map = bpf_object__find_map_by_name(obj, "fexit_bp.bss");
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
+	for (i = 0; i < PROG_CNT; i++)
+		if (CHECK(result[i] != 1, "result", "fexit_bpf2bpf failed err %ld\n",
+			  result[i]))
+			goto close_prog;
+
+close_prog:
+	for (i = 0; i < PROG_CNT; i++)
+		if (!IS_ERR_OR_NULL(link[i]))
+			bpf_link__destroy(link[i]);
+	if (!IS_ERR_OR_NULL(obj))
+		bpf_object__close(obj);
+	bpf_object__close(pkt_obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
new file mode 100644
index 000000000000..69b592217e99
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+struct sk_buff {
+	unsigned int len;
+};
+
+struct args {
+	struct sk_buff *skb;
+	ks32 ret;
+};
+static volatile __u64 test_result;
+SEC("fexit/test_pkt_access")
+int test_main(struct args *ctx)
+{
+	struct sk_buff *skb = ctx->skb;
+	int len;
+
+	__builtin_preserve_access_index(({
+		len = skb->len;
+	}));
+	if (len != 74 || ctx->ret != 0)
+		return 0;
+	test_result = 1;
+	return 0;
+}
+
+struct args_subprog1 {
+	struct sk_buff *skb;
+	ks32 ret;
+};
+static volatile __u64 test_result_subprog1;
+SEC("fexit/test_pkt_access_subprog1")
+int test_subprog1(struct args_subprog1 *ctx)
+{
+	struct sk_buff *skb = ctx->skb;
+	int len;
+
+	__builtin_preserve_access_index(({
+		len = skb->len;
+	}));
+	if (len != 74 || ctx->ret != 148)
+		return 0;
+	test_result_subprog1 = 1;
+	return 0;
+}
+
+/* Though test_pkt_access_subprog2() is defined in C as:
+ * static __attribute__ ((noinline))
+ * int test_pkt_access_subprog2(int val, volatile struct __sk_buff *skb)
+ * {
+ *     return skb->len * val;
+ * }
+ * llvm optimizations remove 'int val' argument and generate BPF assembly:
+ *   r0 = *(u32 *)(r1 + 0)
+ *   w0 <<= 1
+ *   exit
+ * In such case the verifier falls back to conservative and
+ * tracing program can access arguments and return value as u64
+ * instead of accurate types.
+ */
+struct args_subprog2 {
+	ku64 args[5];
+	ku64 ret;
+};
+static volatile __u64 test_result_subprog2;
+SEC("fexit/test_pkt_access_subprog2")
+int test_subprog2(struct args_subprog2 *ctx)
+{
+	struct sk_buff *skb = (void *)ctx->args[0];
+	__u64 ret;
+	int len;
+
+	bpf_probe_read(&len, sizeof(len),
+		       __builtin_preserve_access_index(&skb->len));
+
+	ret = ctx->ret;
+	/* bpf_prog_load() loads "test_pkt_access.o" with BPF_F_TEST_RND_HI32
+	 * which randomizes upper 32 bits after BPF_ALU32 insns.
+	 * Hence after 'w0 <<= 1' upper bits of $rax are random.
+	 * That is expected and correct. Trim them.
+	 */
+	ret = (__u32) ret;
+	if (len != 74 || ret != 148)
+		return 0;
+	test_result_subprog2 = 1;
+	return 0;
+}
+char _license[] SEC("license") = "GPL";
-- 
2.23.0

