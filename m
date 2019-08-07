Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E890843D0
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 07:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfHGFis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 01:38:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27088 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727016AbfHGFio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 01:38:44 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x775XooN011647
        for <netdev@vger.kernel.org>; Tue, 6 Aug 2019 22:38:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=+nxTUC2ma/7lgSvMCVjEB9RhMXYzhvIPt5HvrZYsKUc=;
 b=RjIQ+0Ec+1fJJvvP7784l0qQ1LFKt0hPhGUrhotd6/ZMqVxU0y5uGo9BWCi3O+Akotqb
 pIOB1BQ4J42QSQEZxNdbo/WeGbaoTWpDk24ysdABe8UuXNz30/wmg0xz+/wXyW3knoKN
 Ku5CRLzLD8CxpCfZJSD0LCXRuuOzkKaz3v4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u7g3g9k6d-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 22:38:43 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 6 Aug 2019 22:38:42 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 090EF861698; Tue,  6 Aug 2019 22:38:40 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 14/14] selftests/bpf: add CO-RE relocs misc tests
Date:   Tue, 6 Aug 2019 22:38:06 -0700
Message-ID: <20190807053806.1534571-15-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190807053806.1534571-1-andriin@fb.com>
References: <20190807053806.1534571-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=67 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests validating few edge-cases of capturing offset relocations.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 19 +++++++
 .../bpf/progs/btf__core_reloc_misc.c          |  5 ++
 .../selftests/bpf/progs/core_reloc_types.h    | 25 ++++++++
 .../bpf/progs/test_core_reloc_misc.c          | 57 +++++++++++++++++++
 4 files changed, 106 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_misc.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_misc.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 11daf0dbf2a3..bcc21db3c974 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -260,6 +260,25 @@ static struct core_reloc_test_case test_cases[] = {
 	INTS_ERR_CASE(ints___err_wrong_sz_16),
 	INTS_ERR_CASE(ints___err_wrong_sz_32),
 	INTS_ERR_CASE(ints___err_wrong_sz_64),
+	
+	/* validate edge cases of capturing relocations */
+	{
+		.case_name = "misc",
+		.bpf_obj_file = "test_core_reloc_misc.o",
+		.btf_src_file = "btf__core_reloc_misc.o",
+		.input = (const char *)&(struct core_reloc_misc_extensible[]){
+			{ .a = 1 },
+			{ .a = 2 }, /* not read */
+			{ .a = 3 },
+		},
+		.input_len = 4 * sizeof(int),
+		.output = STRUCT_TO_CHAR_PTR(core_reloc_misc_output) {
+			.a = 1,
+			.b = 1,
+			.c = 0, /* BUG in clang, should be 3 */
+		},
+		.output_len = sizeof(struct core_reloc_misc_output),
+	},
 };
 
 struct data {
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_misc.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_misc.c
new file mode 100644
index 000000000000..ed9ad8b5b4f8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_misc.c
@@ -0,0 +1,5 @@
+#include "core_reloc_types.h"
+
+void f1(struct core_reloc_misc___a x) {}
+void f2(struct core_reloc_misc___b x) {}
+void f3(struct core_reloc_misc_extensible x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index 5f3ebd4f6dc3..10a252b6da55 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -640,3 +640,28 @@ struct core_reloc_ints___err_wrong_sz_64 {
 	uint32_t	u64_field; /* not 64-bit anymore */
 	int32_t		s64_field; /* not 64-bit anymore */
 };
+
+/*
+ * MISC
+ */
+struct core_reloc_misc_output {
+	int a, b, c;
+};
+
+struct core_reloc_misc___a {
+	int a1;
+	int a2;
+};
+
+struct core_reloc_misc___b {
+	int b1;
+	int b2;
+};
+
+/* this one extends core_reloc_misc_extensible struct from BPF prog */
+struct core_reloc_misc_extensible {
+	int a;
+	int b;
+	int c;
+	int d;
+};
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_misc.c b/tools/testing/selftests/bpf/progs/test_core_reloc_misc.c
new file mode 100644
index 000000000000..c59984bd3e23
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_misc.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include "bpf_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+
+static volatile struct data {
+	char in[256];
+	char out[256];
+} data;
+
+struct core_reloc_misc_output {
+	int a, b, c;
+};
+
+struct core_reloc_misc___a {
+	int a1;
+	int a2;
+};
+
+struct core_reloc_misc___b {
+	int b1;
+	int b2;
+};
+
+/* fixed two first members, can be extended with new fields */
+struct core_reloc_misc_extensible {
+	int a;
+	int b;
+};
+
+SEC("raw_tracepoint/sys_enter")
+int test_core_misc(void *ctx)
+{
+	struct core_reloc_misc___a *in_a = (void *)&data.in;
+	struct core_reloc_misc___b *in_b = (void *)&data.in;
+	struct core_reloc_misc_extensible *in_ext = (void *)&data.in;
+	struct core_reloc_misc_output *out = (void *)&data.out;
+
+	/* record two different relocations with the same accessor string */
+	if (BPF_CORE_READ(&out->a, &in_a->a1) ||	/* accessor: 0:0 */
+	    BPF_CORE_READ(&out->b, &in_b->b1))		/* accessor: 0:0 */
+		return 1;
+
+	/* Validate relocations capture array-only accesses for structs with
+	 * fixed header, but with potentially extendable tail. This will read
+	 * first 4 bytes of 2nd element of in_ext array of potentially
+	 * variably sized struct core_reloc_misc_extensible. */ 
+	if (BPF_CORE_READ(&out->c, &in_ext[2]))		/* accessor: 2 */
+		return 1;
+
+	return 0;
+}
+
-- 
2.17.1

