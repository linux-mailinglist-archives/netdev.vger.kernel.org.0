Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946737386E
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 21:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388358AbfGXT3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 15:29:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40006 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388223AbfGXT2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 15:28:19 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6OJPeUq016790
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 12:28:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=+0rbCAJW6Uv+QRcZNHra94M94Hm7XBho2fO+R9rYVNA=;
 b=DVuurin301J37t+V2ovx0GKYoXb28XWUwG9Ci/knS9hOvv18trKkYN2fpsRuLN5hFmog
 Pv4pQvqUsypw4Ml+giM1v0Ko8q+drNrd3Zofn5S0WUZPm2bcqrMkIcOZ6o7KalWsAIKN
 b3EeNoRe88RQidLV+0Alh/cZZcclk4nHTDk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2txsp9s2sx-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 12:28:18 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 24 Jul 2019 12:28:15 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id C73858615F8; Wed, 24 Jul 2019 12:28:13 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 07/10] selftests/bpf: add CO-RE relocs enum/ptr/func_proto tests
Date:   Wed, 24 Jul 2019 12:27:39 -0700
Message-ID: <20190724192742.1419254-8-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190724192742.1419254-1-andriin@fb.com>
References: <20190724192742.1419254-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-24_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=67 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=890 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907240207
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test CO-RE relocation handling of ints, enums, pointers, func protos, etc.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 36 ++++++++++
 .../bpf/progs/btf__core_reloc_primitives.c    |  3 +
 ...f__core_reloc_primitives___diff_enum_def.c |  3 +
 ..._core_reloc_primitives___diff_func_proto.c |  3 +
 ...f__core_reloc_primitives___diff_ptr_type.c |  3 +
 ...tf__core_reloc_primitives___err_non_enum.c |  3 +
 ...btf__core_reloc_primitives___err_non_int.c |  3 +
 ...btf__core_reloc_primitives___err_non_ptr.c |  3 +
 .../selftests/bpf/progs/core_reloc_types.h    | 67 +++++++++++++++++++
 .../bpf/progs/test_core_reloc_primitives.c    | 50 ++++++++++++++
 10 files changed, 174 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_enum_def.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_func_proto.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_ptr_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_enum.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_int.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_ptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index d4a5fc5304b3..05746ead48d9 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -81,6 +81,32 @@
 	.fails = true,							\
 }
 
+#define PRIMITIVES_DATA(struct_name) STRUCT_TO_CHAR_PTR(struct_name) {	\
+	.a = 1,								\
+	.b = 2,								\
+	.c = 3,								\
+	.d = (void *)4,							\
+	.f = (void *)5,							\
+}
+
+#define PRIMITIVES_CASE_COMMON(name)					\
+	.case_name = #name,						\
+	.bpf_obj_file = "test_core_reloc_primitives.o",			\
+	.btf_src_file = "btf__core_reloc_" #name ".o"
+
+#define PRIMITIVES_CASE(name) {						\
+	PRIMITIVES_CASE_COMMON(name),					\
+	.input = PRIMITIVES_DATA(core_reloc_##name),			\
+	.input_len = sizeof(struct core_reloc_##name),			\
+	.output = PRIMITIVES_DATA(core_reloc_primitives),		\
+	.output_len = sizeof(struct core_reloc_primitives),		\
+}
+
+#define PRIMITIVES_ERR_CASE(name) {					\
+	PRIMITIVES_CASE_COMMON(name),					\
+	.fails = true,							\
+}
+
 struct core_reloc_test_case {
 	const char *case_name;
 	const char *bpf_obj_file;
@@ -137,6 +163,16 @@ static struct core_reloc_test_case test_cases[] = {
 	ARRAYS_ERR_CASE(arrays___err_non_array),
 	ARRAYS_ERR_CASE(arrays___err_wrong_val_type1),
 	ARRAYS_ERR_CASE(arrays___err_wrong_val_type2),
+
+	/* enum/ptr/int handling scenarios */
+	PRIMITIVES_CASE(primitives),
+	PRIMITIVES_CASE(primitives___diff_enum_def),
+	PRIMITIVES_CASE(primitives___diff_func_proto),
+	PRIMITIVES_CASE(primitives___diff_ptr_type),
+
+	PRIMITIVES_ERR_CASE(primitives___err_non_enum),
+	PRIMITIVES_ERR_CASE(primitives___err_non_int),
+	PRIMITIVES_ERR_CASE(primitives___err_non_ptr),
 };
 
 struct data {
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives.c
new file mode 100644
index 000000000000..96b90e39242a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_primitives x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_enum_def.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_enum_def.c
new file mode 100644
index 000000000000..6e87233a3ed0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_enum_def.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_primitives___diff_enum_def x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_func_proto.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_func_proto.c
new file mode 100644
index 000000000000..d9f48e80b9d9
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_func_proto.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_primitives___diff_func_proto x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_ptr_type.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_ptr_type.c
new file mode 100644
index 000000000000..c718f75f8f3b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_ptr_type.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_primitives___diff_ptr_type x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_enum.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_enum.c
new file mode 100644
index 000000000000..b8a120830891
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_enum.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_primitives___err_non_enum x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_int.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_int.c
new file mode 100644
index 000000000000..ad8b3c9aa76f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_int.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_primitives___err_non_int x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_ptr.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_ptr.c
new file mode 100644
index 000000000000..e20bc1d42d0a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_ptr.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_primitives___err_non_ptr x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index 45de7986ea2e..7526a5f5755b 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -387,3 +387,70 @@ struct core_reloc_arrays___err_wrong_val_type2 {
 	int c[3]; /* value is not a struct */
 	struct core_reloc_arrays_substruct d[1][2];
 };
+
+/*
+ * PRIMITIVES
+ */
+enum core_reloc_primitives_enum {
+	A = 0,
+	B = 1,
+};
+
+struct core_reloc_primitives {
+	char a;
+	int b;
+	enum core_reloc_primitives_enum c;
+	void *d;
+	int (*f)(const char *);
+};
+
+struct core_reloc_primitives___diff_enum_def {
+	char a;
+	int b;
+	void *d;
+	int (*f)(const char *);
+	enum {
+		X = 100,
+		Y = 200,
+	} c; /* inline enum def with differing set of values */
+};
+
+struct core_reloc_primitives___diff_func_proto {
+	void (*f)(int); /* incompatible function prototype */
+	void *d;
+	enum core_reloc_primitives_enum c;
+	int b;
+	char a;
+};
+
+struct core_reloc_primitives___diff_ptr_type {
+	const char * const d; /* different pointee type + modifiers */
+	char a;
+	int b;
+	enum core_reloc_primitives_enum c;
+	int (*f)(const char *);
+};
+
+struct core_reloc_primitives___err_non_enum {
+	char a[1];
+	int b;
+	int c; /* int instead of enum */
+	void *d;
+	int (*f)(const char *);
+};
+
+struct core_reloc_primitives___err_non_int {
+	char a[1];
+	int *b; /* ptr instead of int */
+	enum core_reloc_primitives_enum c;
+	void *d;
+	int (*f)(const char *);
+};
+
+struct core_reloc_primitives___err_non_ptr {
+	char a[1];
+	int b;
+	enum core_reloc_primitives_enum c;
+	int d; /* int instead of ptr */
+	int (*f)(const char *);
+};
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c b/tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c
new file mode 100644
index 000000000000..9b345e2a7d6c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c
@@ -0,0 +1,50 @@
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
+enum core_reloc_primitives_enum {
+	A = 0,
+	B = 1,
+};
+
+struct core_reloc_primitives {
+	char a;
+	int b;
+	enum core_reloc_primitives_enum c;
+	void *d;
+	int (*f)(const char *);
+};
+
+#define CORE_READ(dst, src) \
+	bpf_probe_read(dst, sizeof(*src), __builtin_preserve_access_index(src))
+
+SEC("raw_tracepoint/sys_enter")
+int test_core_nesting(void *ctx)
+{
+	struct core_reloc_primitives *in = (void *)&data.in;
+	struct core_reloc_primitives *out = (void *)&data.out;
+
+	if (CORE_READ(&out->a, &in->a))
+		return 1;
+	if (CORE_READ(&out->b, &in->b))
+		return 1;
+	if (CORE_READ(&out->c, &in->c))
+		return 1;
+	if (CORE_READ(&out->d, &in->d))
+		return 1;
+	if (CORE_READ(&out->f, &in->f))
+		return 1;
+
+	return 0;
+}
+
-- 
2.17.1

