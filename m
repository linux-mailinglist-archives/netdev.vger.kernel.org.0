Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97332369902
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243517AbhDWSP4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 14:15:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32644 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243531AbhDWSPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:15:15 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NI9k4n019465
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:38 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3841bqgtt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:38 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:14:36 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C1BD52ED5956; Fri, 23 Apr 2021 11:14:30 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH v3 bpf-next 17/18] selftests/bpf: add map linking selftest
Date:   Fri, 23 Apr 2021 11:13:47 -0700
Message-ID: <20210423181348.1801389-18-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423181348.1801389-1-andrii@kernel.org>
References: <20210423181348.1801389-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: EjtEuXIGW6gpmhivKQ4zN3aacN0I4rar
X-Proofpoint-ORIG-GUID: EjtEuXIGW6gpmhivKQ4zN3aacN0I4rar
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftest validating various aspects of statically linking BTF-defined map
definitions. Legacy map definitions do not support extern resolution between
object files. Some of the aspects validated:
  - correct resolution of extern maps against concrete map definitions;
  - extern maps can currently only specify map type and key/value size and/or
    type information;
  - weak concrete map definitions are resolved properly.

Static map definitions are not yet supported by libbpf, so they are not
explicitly tested, though manual testing showes that BPF linker handles them
properly.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |  4 +-
 .../selftests/bpf/prog_tests/linked_maps.c    | 30 +++++++
 .../selftests/bpf/progs/linked_maps1.c        | 82 +++++++++++++++++++
 .../selftests/bpf/progs/linked_maps2.c        | 76 +++++++++++++++++
 4 files changed, 191 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_maps.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_maps1.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_maps2.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 411e2cf07ba5..283e5ad8385e 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -309,11 +309,13 @@ endef
 
 SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
 
-LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h linked_vars.skel.h
+LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
+		linked_vars.skel.h linked_maps.skel.h
 
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
 linked_funcs.skel.h-deps := linked_funcs1.o linked_funcs2.o
 linked_vars.skel.h-deps := linked_vars1.o linked_vars2.o
+linked_maps.skel.h-deps := linked_maps1.o linked_maps2.o
 
 LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
 
diff --git a/tools/testing/selftests/bpf/prog_tests/linked_maps.c b/tools/testing/selftests/bpf/prog_tests/linked_maps.c
new file mode 100644
index 000000000000..85dcaaaf2775
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/linked_maps.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include <test_progs.h>
+#include <sys/syscall.h>
+#include "linked_maps.skel.h"
+
+void test_linked_maps(void)
+{
+	int err;
+	struct linked_maps *skel;
+
+	skel = linked_maps__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	err = linked_maps__attach(skel);
+	if (!ASSERT_OK(err, "skel_attach"))
+		goto cleanup;
+
+	/* trigger */
+	syscall(SYS_getpgid);
+
+	ASSERT_EQ(skel->bss->output_first1, 2000, "output_first1");
+	ASSERT_EQ(skel->bss->output_second1, 2, "output_second1");
+	ASSERT_EQ(skel->bss->output_weak1, 2, "output_weak1");
+
+cleanup:
+	linked_maps__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/linked_maps1.c b/tools/testing/selftests/bpf/progs/linked_maps1.c
new file mode 100644
index 000000000000..52291515cc72
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/linked_maps1.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+struct my_key { long x; };
+struct my_value { long x; };
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, struct my_key);
+	__type(value, struct my_value);
+	__uint(max_entries, 16);
+} map1 SEC(".maps");
+
+ /* Matches map2 definition in linked_maps2.c. Order of the attributes doesn't
+  * matter.
+  */
+typedef struct {
+	__uint(max_entries, 8);
+	__type(key, int);
+	__type(value, int);
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+} map2_t;
+
+extern map2_t map2 SEC(".maps");
+
+/* This should be the winning map definition, but we have no way of verifying,
+ * so we just make sure that it links and works without errors
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, int);
+	__type(value, int);
+	__uint(max_entries, 16);
+} map_weak __weak SEC(".maps");
+
+int output_first1;
+int output_second1;
+int output_weak1;
+
+SEC("raw_tp/sys_enter")
+int BPF_PROG(handler_enter1)
+{
+	/* update values with key = 1 */
+	int key = 1, val = 1;
+	struct my_key key_struct = { .x = 1 };
+	struct my_value val_struct = { .x = 1000 };
+
+	bpf_map_update_elem(&map1, &key_struct, &val_struct, 0);
+	bpf_map_update_elem(&map2, &key, &val, 0);
+	bpf_map_update_elem(&map_weak, &key, &val, 0);
+
+	return 0;
+}
+
+SEC("raw_tp/sys_exit")
+int BPF_PROG(handler_exit1)
+{
+	/* lookup values with key = 2, set in another file */
+	int key = 2, *val;
+	struct my_key key_struct = { .x = 2 };
+	struct my_value *value_struct;
+
+	value_struct = bpf_map_lookup_elem(&map1, &key_struct);
+	if (value_struct)
+		output_first1 = value_struct->x;
+
+	val = bpf_map_lookup_elem(&map2, &key);
+	if (val)
+		output_second1 = *val;
+
+	val = bpf_map_lookup_elem(&map_weak, &key);
+	if (val)
+		output_weak1 = *val;
+	
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/linked_maps2.c b/tools/testing/selftests/bpf/progs/linked_maps2.c
new file mode 100644
index 000000000000..0693687474ed
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/linked_maps2.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/* modifiers and typedefs are ignored when comparing key/value types */
+typedef struct my_key { long x; } key_type;
+typedef struct my_value { long x; } value_type;
+
+extern struct {
+	__uint(max_entries, 16);
+	__type(key, key_type);
+	__type(value, value_type);
+	__uint(type, BPF_MAP_TYPE_HASH);
+} map1 SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, int);
+	__type(value, int);
+	__uint(max_entries, 8);
+} map2 SEC(".maps");
+
+/* this definition will lose, but it has to exactly match the winner */
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, int);
+	__type(value, int);
+	__uint(max_entries, 16);
+} map_weak __weak SEC(".maps");
+
+int output_first2;
+int output_second2;
+int output_weak2;
+
+SEC("raw_tp/sys_enter")
+int BPF_PROG(handler_enter2)
+{
+	/* update values with key = 2 */
+	int key = 2, val = 2;
+	key_type key_struct = { .x = 2 };
+	value_type val_struct = { .x = 2000 };
+
+	bpf_map_update_elem(&map1, &key_struct, &val_struct, 0);
+	bpf_map_update_elem(&map2, &key, &val, 0);
+	bpf_map_update_elem(&map_weak, &key, &val, 0);
+
+	return 0;
+}
+
+SEC("raw_tp/sys_exit")
+int BPF_PROG(handler_exit2)
+{
+	/* lookup values with key = 1, set in another file */
+	int key = 1, *val;
+	key_type key_struct = { .x = 1 };
+	value_type *value_struct;
+
+	value_struct = bpf_map_lookup_elem(&map1, &key_struct);
+	if (value_struct)
+		output_first2 = value_struct->x;
+
+	val = bpf_map_lookup_elem(&map2, &key);
+	if (val)
+		output_second2 = *val;
+
+	val = bpf_map_lookup_elem(&map_weak, &key);
+	if (val)
+		output_weak2 = *val;
+
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
-- 
2.30.2

