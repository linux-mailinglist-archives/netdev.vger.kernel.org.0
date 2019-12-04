Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8F28112333
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 08:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfLDHA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 02:00:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22636 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727325AbfLDHAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 02:00:54 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB46rfdZ016610
        for <netdev@vger.kernel.org>; Tue, 3 Dec 2019 23:00:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=0LlH/nLl5Dr0wbAqBTCW+ZHkKV0tDv5/l0BIkKZ/fLY=;
 b=oG+C0Y+hpC33HLnv16ir+7mA2DolqFW7yivtu0gxPmJe8mlOBcbzU10ekWG+G7K+UBP/
 bjQerMATsJaa2QA+Umt3JJKAyc2wBlbCnzickEvbBKGJQHWb50owCP/AZ71wXRtzei9B
 4rszqujRKCY9rF8Jrpwnb1OP41kgPZYa9BI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wp7rnr24x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 23:00:53 -0800
Received: from 2401:db00:2120:81ca:face:0:31:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 3 Dec 2019 23:00:52 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 97DFE2EC1853; Tue,  3 Dec 2019 23:00:51 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 15/16] selftests/bpf: add test validating data section to struct convertion layout
Date:   Tue, 3 Dec 2019 23:00:14 -0800
Message-ID: <20191204070015.3523523-16-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191204070015.3523523-1-andriin@fb.com>
References: <20191204070015.3523523-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_01:2019-12-04,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxlogscore=935
 phishscore=0 suspectscore=8 priorityscore=1501 mlxscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912040050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a simple selftests validating datasection-to-struct layour dumping. Global
variables are constructed in such a way as to cause both natural and
artificial padding (through custom alignment requirement).

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

