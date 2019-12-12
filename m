Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 247EE11D28F
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 17:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbfLLQmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 11:42:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44922 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729899AbfLLQmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 11:42:11 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCGZdFe022512
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 08:42:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=U1dgC4RzpBpcz6VDWqEj9bP2kXrizujaiab0r+p3IaI=;
 b=AuIM3Nw1MugM8PMwvoFKkfPdQsE7QL0BEk1V9ZDXk65HAXnvg9GB8EE5ws8CTRboKLf8
 vkxiKrYuJlI7Hx7fGwD3shB6Sy2lENjGzoMZN3R3bh3bob+V9/VE3uWBEhuKBCyyBSx9
 iYE+wQnmh7EAho83i0gVB2Vi+p9alQXlsCs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu87qm3hc-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 08:42:10 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 12 Dec 2019 08:42:07 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 408CA2EC1AD2; Thu, 12 Dec 2019 08:42:05 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 14/15] selftests/bpf: add test validating data section to struct convertion layout
Date:   Thu, 12 Dec 2019 08:41:27 -0800
Message-ID: <20191212164129.494329-15-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212164129.494329-1-andriin@fb.com>
References: <20191212164129.494329-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_04:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 malwarescore=0
 spamscore=0 mlxscore=0 suspectscore=8 phishscore=0 lowpriorityscore=0
 mlxlogscore=974 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912120129
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a simple selftests validating datasection-to-struct layour dumping. Global
variables are constructed in such a way as to cause both natural and
artificial padding (through custom alignment requirement).

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/skeleton.c       | 47 +++++++++++++++++++
 .../selftests/bpf/progs/test_skeleton.c       | 36 ++++++++++++++
 2 files changed, 83 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skeleton.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skeleton.c

diff --git a/tools/testing/selftests/bpf/prog_tests/skeleton.c b/tools/testing/selftests/bpf/prog_tests/skeleton.c
new file mode 100644
index 000000000000..d65a0203e1df
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/skeleton.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+struct s {
+	int a;
+	long long b;
+} __attribute__((packed));
+
+#include "test_skeleton.skel.h"
+
+BPF_EMBED_OBJ(skeleton, "test_skeleton.o");
+
+void test_skeleton(void)
+{
+	int duration = 0, err;
+	struct test_skeleton* skel;
+	struct test_skeleton__bss *bss;
+
+	skel = test_skeleton__open_and_load(&skeleton_embed);
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		return;
+
+	bss = skel->bss;
+	bss->in1 = 1;
+	bss->in2 = 2;
+	bss->in3 = 3;
+	bss->in4 = 4;
+	bss->in5.a = 5;
+	bss->in5.b = 6;
+
+	err = test_skeleton__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* trigger tracepoint */
+	usleep(1);
+
+	CHECK(bss->out1 != 1, "res1", "got %d != exp %d\n", bss->out1, 1);
+	CHECK(bss->out2 != 2, "res2", "got %lld != exp %d\n", bss->out2, 2);
+	CHECK(bss->out3 != 3, "res3", "got %d != exp %d\n", (int)bss->out3, 3);
+	CHECK(bss->out4 != 4, "res4", "got %lld != exp %d\n", bss->out4, 4);
+	CHECK(bss->out5.a != 5, "res5", "got %d != exp %d\n", bss->out5.a, 5);
+	CHECK(bss->out5.b != 6, "res6", "got %lld != exp %d\n", bss->out5.b, 6);
+
+cleanup:
+	test_skeleton__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_skeleton.c b/tools/testing/selftests/bpf/progs/test_skeleton.c
new file mode 100644
index 000000000000..303a841c4d1c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_skeleton.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2017 Facebook
+
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+struct s {
+	int a;
+	long long b;
+} __attribute__((packed));
+
+int in1 = 0;
+long long in2 = 0;
+char in3 = '\0';
+long long in4 __attribute__((aligned(64))) = 0;
+struct s in5 = {};
+
+long long out2 = 0;
+struct s out5 = {};
+char out3 = 0;
+long long out4 = 0;
+int out1 = 0;
+
+
+SEC("raw_tp/sys_enter")
+int handler(const void *ctx)
+{
+	out1 = in1;
+	out2 = in2;
+	out3 = in3;
+	out4 = in4;
+	out5 = in5;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.17.1

