Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25C4F275C
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfKGFrg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Nov 2019 00:47:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65356 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726982AbfKGFrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:47:35 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA75i6fx016010
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 21:47:35 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u0kgxc-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 21:47:35 -0800
Received: from 2401:db00:2120:81dc:face:0:23:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 21:47:21 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id F0404760BC0; Wed,  6 Nov 2019 21:47:18 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 17/17] selftests/bpf: Add a test for attaching BPF prog to another BPF prog and subprog
Date:   Wed, 6 Nov 2019 21:46:44 -0800
Message-ID: <20191107054644.1285697-18-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107054644.1285697-1-ast@kernel.org>
References: <20191107054644.1285697-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=1 bulkscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=843
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test that attaches one FEXIT program to main sched_cls networking program
and another FEXIT program to networking subprogram. Both tracing programs
access return values and skb->len of networking program and subprogram.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 73 +++++++++++++++++++
 .../selftests/bpf/progs/fexit_bpf2bpf.c       | 48 ++++++++++++
 2 files changed, 121 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
new file mode 100644
index 000000000000..7f5a90349721
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+#include <test_progs.h>
+
+void test_fexit_bpf2bpf(void)
+{
+	const char *prog_name[2] = {
+		"fexit/test_pkt_access",
+		"fexit/test_pkt_access_subprog",
+	};
+	struct bpf_object *obj = NULL, *pkt_obj;
+	int err, pkt_fd, i;
+	struct bpf_link *link[2] = {};
+	struct bpf_program *prog[2];
+	__u32 duration, retval;
+	struct bpf_map *data_map;
+	const int zero = 0;
+	u64 result[2];
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
+	for (i = 0; i < 2; i++) {
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
+	for (i = 0; i < 2; i++)
+		if (CHECK(result[i] != 1, "result", "fexit_bpf2bpf failed err %ld\n",
+			  result[i]))
+			goto close_prog;
+
+close_prog:
+	for (i = 0; i < 1; i++)
+		if (!IS_ERR_OR_NULL(link[i]))
+			bpf_link__destroy(link[i]);
+	if (!IS_ERR_OR_NULL(obj))
+		bpf_object__close(obj);
+	bpf_object__close(pkt_obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
new file mode 100644
index 000000000000..17b3822200aa
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
@@ -0,0 +1,48 @@
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
+struct args_subprog {
+	struct sk_buff *skb;
+	ks32 ret;
+};
+static volatile __u64 test_result_subprog;
+SEC("fexit/test_pkt_access_subprog")
+int test_subprog(struct args_subprog *ctx)
+{
+	struct sk_buff *skb = ctx->skb;
+	int len;
+
+	__builtin_preserve_access_index(({
+		len = skb->len;
+	}));
+	if (len != 74 || ctx->ret != 148)
+		return 0;
+	test_result_subprog = 1;
+	return 0;
+}
-- 
2.23.0

