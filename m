Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDC92DEC2B
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 00:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgLRX5H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Dec 2020 18:57:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48834 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLRX5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 18:57:06 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BINsC2n013124
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 15:56:26 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35gxe5jqc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 15:56:26 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 15:56:25 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0F2E52ECB8FE; Fri, 18 Dec 2020 15:56:23 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 3/3] selftests/bpf: add tests for user- and non-CO-RE BPF_CORE_READ() variants
Date:   Fri, 18 Dec 2020 15:56:14 -0800
Message-ID: <20201218235614.2284956-4-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201218235614.2284956-1-andrii@kernel.org>
References: <20201218235614.2284956-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_14:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 spamscore=0 clxscore=1034 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180163
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftests validating that newly added variations of BPF_CORE_READ(), for
use with user-space addresses and for non-CO-RE reads, work as expected.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../bpf/prog_tests/core_read_macros.c         | 64 +++++++++++++++++++
 .../bpf/progs/test_core_read_macros.c         | 51 +++++++++++++++
 2 files changed, 115 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_read_macros.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_read_macros.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_read_macros.c b/tools/testing/selftests/bpf/prog_tests/core_read_macros.c
new file mode 100644
index 000000000000..96f5cf3c6fa2
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/core_read_macros.c
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include <test_progs.h>
+
+struct callback_head {
+	struct callback_head *next;
+	void (*func)(struct callback_head *head);
+};
+
+/* ___shuffled flavor is just an illusion for BPF code, it doesn't really
+ * exist and user-space needs to provide data in the memory layout that
+ * matches callback_head. We just defined ___shuffled flavor to make it easier
+ * to work with the skeleton
+ */
+struct callback_head___shuffled {
+	struct callback_head___shuffled *next;
+	void (*func)(struct callback_head *head);
+};
+
+#include "test_core_read_macros.skel.h"
+
+void test_core_read_macros(void)
+{
+	int duration = 0, err;
+	struct test_core_read_macros* skel;
+	struct test_core_read_macros__bss *bss;
+	struct callback_head u_probe_in;
+	struct callback_head___shuffled u_core_in;
+
+	skel = test_core_read_macros__open_and_load();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		return;
+	bss = skel->bss;
+	bss->my_pid = getpid();
+
+	/* next pointers have to be set from the kernel side */
+	bss->k_probe_in.func = (void *)(long)0x1234;
+	bss->k_core_in.func = (void *)(long)0xabcd;
+
+	u_probe_in.next = &u_probe_in;
+	u_probe_in.func = (void *)(long)0x5678;
+	bss->u_probe_in = &u_probe_in;
+
+	u_core_in.next = &u_core_in;
+	u_core_in.func = (void *)(long)0xdbca;
+	bss->u_core_in = &u_core_in;
+
+	err = test_core_read_macros__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* trigger tracepoint */
+	usleep(1);
+
+	ASSERT_EQ(bss->k_probe_out, 0x1234, "k_probe_out");
+	ASSERT_EQ(bss->k_core_out, 0xabcd, "k_core_out");
+
+	ASSERT_EQ(bss->u_probe_out, 0x5678, "u_probe_out");
+	ASSERT_EQ(bss->u_core_out, 0xdbca, "u_core_out");
+
+cleanup:
+	test_core_read_macros__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_core_read_macros.c b/tools/testing/selftests/bpf/progs/test_core_read_macros.c
new file mode 100644
index 000000000000..50054af0a928
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_read_macros.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+
+char _license[] SEC("license") = "GPL";
+
+/* shuffled layout for relocatable (CO-RE) reads */
+struct callback_head___shuffled {
+	void (*func)(struct callback_head___shuffled *head);
+	struct callback_head___shuffled *next;
+};
+
+struct callback_head k_probe_in = {};
+struct callback_head___shuffled k_core_in = {};
+
+struct callback_head *u_probe_in = 0;
+struct callback_head___shuffled *u_core_in = 0;
+
+long k_probe_out = 0;
+long u_probe_out = 0;
+
+long k_core_out = 0;
+long u_core_out = 0;
+
+int my_pid = 0;
+
+SEC("raw_tracepoint/sys_enter")
+int handler(void *ctx)
+{
+	int pid = bpf_get_current_pid_tgid() >> 32;
+
+	if (my_pid != pid)
+		return 0;
+
+	/* next pointers for kernel address space have to be initialized from
+	 * BPF side, user-space mmaped addresses are stil user-space addresses
+	 */
+	k_probe_in.next = &k_probe_in;
+	__builtin_preserve_access_index(({k_core_in.next = &k_core_in;}));
+
+	k_probe_out = (long)BPF_PROBE_READ(&k_probe_in, next, next, func);
+	k_core_out = (long)BPF_CORE_READ(&k_core_in, next, next, func);
+	u_probe_out = (long)BPF_PROBE_READ_USER(u_probe_in, next, next, func);
+	u_core_out = (long)BPF_CORE_READ_USER(u_core_in, next, next, func);
+
+	return 0;
+}
+
-- 
2.24.1

