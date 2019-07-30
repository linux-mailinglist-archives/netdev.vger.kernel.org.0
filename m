Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B77F57B39D
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 21:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfG3Tyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 15:54:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33118 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726731AbfG3Tym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 15:54:42 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6UJmXTA015200
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 12:54:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=IkrOdr32PYexV2eBXKEQAeH+H738dne8Lh/OXzV7LWA=;
 b=akG6r2sqcibzAFJ+hbDV7XLtC7X9VWbwStDpgR4mWSx3VBfLzY40iCwxXJz1hjGCICoQ
 0ccirXld5Y0G/htP1w0u84nxqwBCH4QYdECzCvOdXxKujrtmVl/r7orjf9O7SJ+V6wjM
 41m6SqPALdzqF98J0wQoMWOUjb00b8JOzcU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2uhtg6sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 12:54:37 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 12:54:36 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 00DF5861655; Tue, 30 Jul 2019 12:54:35 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 12/12] selftests/bpf: add CO-RE relocs misc tests
Date:   Tue, 30 Jul 2019 12:54:08 -0700
Message-ID: <20190730195408.670063-13-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190730195408.670063-1-andriin@fb.com>
References: <20190730195408.670063-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=67 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300201
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests validating few edge-cases of capturing offset relocations.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 19 ++++++
 .../bpf/progs/btf__core_reloc_misc.c          |  4 ++
 .../selftests/bpf/progs/core_reloc_types.h    | 25 ++++++++
 .../bpf/progs/test_core_reloc_misc.c          | 58 +++++++++++++++++++
 4 files changed, 106 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_misc.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_misc.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 46abb4df5b1c..a50ad439ea90 100644
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
index 000000000000..e379831d31a8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_misc.c
@@ -0,0 +1,4 @@
+#include "core_reloc_types.h"
+
+void f1(struct core_reloc_misc___a x) {}
+void f2(struct core_reloc_misc___b x) {}
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
index 000000000000..bfd295f23d5f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_misc.c
@@ -0,0 +1,58 @@
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
+	/* BUG in Clang, isn't captured right now */
+	if (BPF_CORE_READ(&out->c, &in_ext[2]))		/* accessor: 2 */
+		return 1;
+
+	return 0;
+}
+
-- 
2.17.1

