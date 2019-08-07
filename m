Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A37B843CB
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 07:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbfHGFil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 01:38:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9908 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726912AbfHGFik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 01:38:40 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x775XnE2011644
        for <netdev@vger.kernel.org>; Tue, 6 Aug 2019 22:38:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=wakwQJON1s4V/mPAygG06/CLix+aq//WjFRCZyT1xWk=;
 b=OvAsGsH9rnyqtBHUY7F+HZzwLCd207lZzJV8pOhMIS/nGm7h0u6wTCZmTOYdB/wKQkXp
 6GXdRJZaf1/9bInsFIs12oDZzBA1ZIZqEt4IYAtnB2OWuCsCTd3Bczq9/Gf09D/yhZEa
 ISI09YNo0EA4yf9u8jBz9lg2AI6NilwCZUQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u7g3g9k6a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 22:38:39 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 6 Aug 2019 22:38:37 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id CBA41861698; Tue,  6 Aug 2019 22:38:36 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 12/14] selftests/bpf: add CO-RE relocs ptr-as-array tests
Date:   Tue, 6 Aug 2019 22:38:04 -0700
Message-ID: <20190807053806.1534571-13-andriin@fb.com>
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
 mlxlogscore=908 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test validating correct relocation handling for cases where pointer
to something is used as an array. E.g.:

  int *ptr = ...;
  int x = ptr[42];

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 20 +++++++++++++
 .../bpf/progs/btf__core_reloc_ptr_as_arr.c    |  3 ++
 .../btf__core_reloc_ptr_as_arr___diff_sz.c    |  3 ++
 .../selftests/bpf/progs/core_reloc_types.h    | 13 ++++++++
 .../bpf/progs/test_core_reloc_ptr_as_arr.c    | 30 +++++++++++++++++++
 5 files changed, 69 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ptr_as_arr.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ptr_as_arr___diff_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index cf38c787537a..77478b51699b 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -129,6 +129,22 @@
 	.output_len = sizeof(struct core_reloc_mods_output),		\
 }
 
+#define PTR_AS_ARR_CASE(name) {						\
+	.case_name = #name,						\
+	.bpf_obj_file = "test_core_reloc_ptr_as_arr.o",			\
+	.btf_src_file = "btf__core_reloc_" #name ".o",			\
+	.input = (const char *)&(struct core_reloc_##name []){		\
+		{ .a = 1 },						\
+		{ .a = 2 },						\
+		{ .a = 3 },						\
+	},								\
+	.input_len = 3 * sizeof(struct core_reloc_##name),		\
+	.output = STRUCT_TO_CHAR_PTR(core_reloc_ptr_as_arr) {		\
+		.a = 3,							\
+	},								\
+	.output_len = sizeof(struct core_reloc_ptr_as_arr),		\
+}
+
 struct core_reloc_test_case {
 	const char *case_name;
 	const char *bpf_obj_file;
@@ -200,6 +216,10 @@ static struct core_reloc_test_case test_cases[] = {
 	MODS_CASE(mods),
 	MODS_CASE(mods___mod_swap),
 	MODS_CASE(mods___typedefs),
+
+	/* handling "ptr is an array" semantics */
+	PTR_AS_ARR_CASE(ptr_as_arr),
+	PTR_AS_ARR_CASE(ptr_as_arr___diff_sz),
 };
 
 struct data {
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_ptr_as_arr.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ptr_as_arr.c
new file mode 100644
index 000000000000..8da52432ba17
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_ptr_as_arr.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_ptr_as_arr x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_ptr_as_arr___diff_sz.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ptr_as_arr___diff_sz.c
new file mode 100644
index 000000000000..003acfc9a3e7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_ptr_as_arr___diff_sz.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_ptr_as_arr___diff_sz x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index 3401e8342e57..c17c9279deae 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -526,3 +526,16 @@ struct core_reloc_mods___typedefs {
 	int3_t b;
 	int3_t a;
 };
+
+/*
+ * PTR_AS_ARR
+ */
+struct core_reloc_ptr_as_arr {
+	int a;
+};
+
+struct core_reloc_ptr_as_arr___diff_sz {
+	int :32; /* padding */
+	char __some_more_padding;
+	int a;
+};
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c b/tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c
new file mode 100644
index 000000000000..526b7ddc7ea1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c
@@ -0,0 +1,30 @@
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
+struct core_reloc_ptr_as_arr {
+	int a;
+};
+
+SEC("raw_tracepoint/sys_enter")
+int test_core_ptr_as_arr(void *ctx)
+{
+	struct core_reloc_ptr_as_arr *in = (void *)&data.in;
+	struct core_reloc_ptr_as_arr *out = (void *)&data.out;
+
+	if (BPF_CORE_READ(&out->a, &in[2].a))
+		return 1;
+
+	return 0;
+}
+
-- 
2.17.1

