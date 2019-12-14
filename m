Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5BA911EFBD
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 02:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfLNBot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 20:44:49 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20934 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726736AbfLNBot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 20:44:49 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBE1aW8p023663
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:44:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=pagV6NajEM2GnnXwrXAKX6zGXAfIMK0cR4WPBnjHeQs=;
 b=kPkB+hiJKXkcMTJGXCNgvqhomF5UcSQ3dwCAWPwWkehPZw9iNb/Zp246Gpyy017q1LaH
 h14xWQaMVpxC8I+12BP0Lb5AFvWOTgI8eZM8/bALsyaGbzVAi5bViyLn0RmzWp2/DcPp
 1x3GxsdDyK90P+SS/pVdFFF8Dn7kOg8X7Qk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvkm20n38-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:44:47 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 13 Dec 2019 17:44:22 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CB5C02EC1D51; Fri, 13 Dec 2019 17:44:19 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 16/17] selftests/bpf: add test validating data section to struct convertion layout
Date:   Fri, 13 Dec 2019 17:43:40 -0800
Message-ID: <20191214014341.3442258-17-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191214014341.3442258-1-andriin@fb.com>
References: <20191214014341.3442258-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 clxscore=1015 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912140006
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
 .../selftests/bpf/prog_tests/skeleton.c       | 51 +++++++++++++++++++
 .../selftests/bpf/progs/test_skeleton.c       | 37 ++++++++++++++
 2 files changed, 88 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skeleton.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skeleton.c

diff --git a/tools/testing/selftests/bpf/prog_tests/skeleton.c b/tools/testing/selftests/bpf/prog_tests/skeleton.c
new file mode 100644
index 000000000000..79f8d13e6740
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/skeleton.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+
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
+	CHECK(bss->handler_out5.a != 5, "res5", "got %d != exp %d\n",
+	      bss->handler_out5.a, 5);
+	CHECK(bss->handler_out5.b != 6, "res6", "got %lld != exp %d\n",
+	      bss->handler_out5.b, 6);
+
+cleanup:
+	test_skeleton__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_skeleton.c b/tools/testing/selftests/bpf/progs/test_skeleton.c
new file mode 100644
index 000000000000..c0013d2e16f2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_skeleton.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
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
+char out3 = 0;
+long long out4 = 0;
+int out1 = 0;
+
+
+SEC("raw_tp/sys_enter")
+int handler(const void *ctx)
+{
+	static volatile struct s out5;
+
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

