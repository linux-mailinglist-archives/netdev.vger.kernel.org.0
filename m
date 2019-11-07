Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF6A3F2752
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfKGFrO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Nov 2019 00:47:14 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27374 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbfKGFrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:47:11 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA75dfv6027387
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 21:47:10 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u2kg88-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 21:47:10 -0800
Received: from 2401:db00:2050:5102:face:0:37:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 21:47:06 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id A8A10760BC0; Wed,  6 Nov 2019 21:47:04 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 10/17] selftests/bpf: Add stress test for maximum number of progs
Date:   Wed, 6 Nov 2019 21:46:37 -0800
Message-ID: <20191107054644.1285697-11-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107054644.1285697-1-ast@kernel.org>
References: <20191107054644.1285697-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 suspectscore=1 priorityscore=1501 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 mlxlogscore=927 mlxscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add stress test for maximum number of attached BPF programs per BPF trampoline.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../selftests/bpf/prog_tests/fexit_stress.c   | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fexit_stress.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_stress.c b/tools/testing/selftests/bpf/prog_tests/fexit_stress.c
new file mode 100644
index 000000000000..91f6d93d3c83
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_stress.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+#include <test_progs.h>
+#include <linux/nbd.h>
+
+/* x86-64 fits 55 JITed and 43 interpreted progs into half page */
+#define CNT 40
+
+void test_fexit_stress(void)
+{
+	char test_skb[128] = {};
+	int fexit_fd[CNT] = {};
+	int link_fd[CNT] = {};
+	__u32 duration = 0;
+	char error[4096];
+	__u32 prog_ret;
+	int err, i;
+
+	const struct bpf_insn trace_program[] = {
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+
+	struct bpf_load_program_attr load_attr = {
+		.prog_type = BPF_PROG_TYPE_TRACING,
+		.license = "GPL",
+		.insns = trace_program,
+		.insns_cnt = sizeof(trace_program) / sizeof(struct bpf_insn),
+		.expected_attach_type = BPF_TRACE_FEXIT,
+	};
+	
+	const struct bpf_insn skb_program[] = {
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+
+	struct bpf_load_program_attr skb_load_attr = {
+		.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
+		.license = "GPL",
+		.insns = skb_program,
+		.insns_cnt = sizeof(skb_program) / sizeof(struct bpf_insn),
+	};
+
+	err = libbpf_attach_btf_id_by_name("fexit/bpf_fentry_test1",
+					   load_attr.expected_attach_type,
+					   &load_attr.attach_btf_id);
+
+	for (i = 0; i < CNT; i++) {
+		fexit_fd[i] = bpf_load_program_xattr(&load_attr, error, sizeof(error));
+		if (CHECK(fexit_fd[i] < 0, "fexit loaded",
+			  "failed: %d errno %d\n", fexit_fd[i], errno))
+			goto out;
+		link_fd[i] = bpf_raw_tracepoint_open(NULL, fexit_fd[i]);
+		if (CHECK(link_fd[i] < 0, "fexit attach failed",
+			  "prog %d failed: %d err %d\n", i, link_fd[i], errno))
+			goto out;
+	}
+
+	int filter_fd =
+		bpf_load_program_xattr(&skb_load_attr, error, sizeof(error));
+	if (CHECK(filter_fd < 0, "test_program_loaded", "failed: %d errno %d\n",
+		  filter_fd, errno))
+		goto out;
+
+	err = bpf_prog_test_run(filter_fd, 1, test_skb, sizeof(test_skb), 0,
+				0, &prog_ret, 0);
+	close(filter_fd);
+	CHECK_FAIL(err);
+out:
+	for (i = 0; i < CNT; i++) {
+		if (link_fd[i])
+			close(link_fd[i]);
+		if (fexit_fd[i])
+			close(fexit_fd[i]);
+	}
+}
-- 
2.23.0

