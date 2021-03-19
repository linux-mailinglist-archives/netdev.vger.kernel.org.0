Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C60934274A
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhCSU74 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Mar 2021 16:59:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26088 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230264AbhCSU7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 16:59:22 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JKx9dL000562
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 13:59:21 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37cx90hydv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 13:59:21 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 19 Mar 2021 13:59:20 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6C6AA2ED268B; Fri, 19 Mar 2021 13:59:17 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 3/3] selftests/bpf: allow compiling BPF objects without BTF
Date:   Fri, 19 Mar 2021 13:59:09 -0700
Message-ID: <20210319205909.1748642-4-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210319205909.1748642-1-andrii@kernel.org>
References: <20210319205909.1748642-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_12:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190144
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to skip BTF generation for some BPF object files. This is done
through using a convention of .nobtf.c file name suffix.

Also add third statically linked file to static_linked selftest. This file has
no BTF, causing resulting object file to have only some of DATASEC BTF types.
It also is using (from BPF code) global variables. This tests both libbpf's
static linking logic and bpftool's skeleton generation logic.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          | 21 +++++++----
 .../selftests/bpf/prog_tests/static_linked.c  |  6 +++-
 .../bpf/progs/test_static_linked3.nobtf.c     | 36 +++++++++++++++++++
 3 files changed, 56 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_static_linked3.nobtf.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 6448c626498f..0a481a75a416 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -270,7 +270,7 @@ IS_LITTLE_ENDIAN = $(shell $(CC) -dM -E - </dev/null | \
 MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
 
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
-BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 			\
+BPF_CFLAGS = -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 			\
 	     -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)			\
 	     -I$(abspath $(OUTPUT)/../usr/include)
 
@@ -282,30 +282,39 @@ $(OUTPUT)/test_xdp_noinline.o: BPF_CFLAGS += -fno-inline
 
 $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
 
-# Build BPF object using Clang
+# Build BPF object using Clang.
+# Source files with .nobtf.c suffix are built without BTF
 # $1 - input .c file
 # $2 - output .o file
 # $3 - CFLAGS
 define CLANG_BPF_BUILD_RULE
 	$(call msg,CLNG-BPF,$(TRUNNER_BINARY),$2)
-	$(Q)$(CLANG) $3 -O2 -target bpf -c $1 -o $2 -mcpu=v3
+	$(Q)$(CLANG) $3 -O2 -target bpf -mcpu=v3			\
+		     $(if $(filter %.nobtf.c,$1),,-g)			\
+		     -c $1 -o $2
 endef
 # Similar to CLANG_BPF_BUILD_RULE, but with disabled alu32
 define CLANG_NOALU32_BPF_BUILD_RULE
 	$(call msg,CLNG-BPF,$(TRUNNER_BINARY),$2)
-	$(Q)$(CLANG) $3 -O2 -target bpf -c $1 -o $2 -mcpu=v2
+	$(Q)$(CLANG) $3 -O2 -target bpf -mcpu=v2			\
+		     $(if $(filter %.nobtf.c,$1),,-g)			\
+		     -c $1 -o $2
 endef
 # Build BPF object using GCC
 define GCC_BPF_BUILD_RULE
 	$(call msg,GCC-BPF,$(TRUNNER_BINARY),$2)
-	$(Q)$(BPF_GCC) $3 -O2 -c $1 -o $2
+	$(Q)$(BPF_GCC) $3 -O2 						\
+		       $(if $(filter %.nobtf.c,$1),,-g)			\
+		       -c $1 -o $2
 endef
 
 SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
 
 LINKED_SKELS := test_static_linked.skel.h
 
-test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
+test_static_linked.skel.h-deps := test_static_linked1.o \
+				  test_static_linked2.o \
+				  test_static_linked3.nobtf.o
 
 # Set up extra TRUNNER_XXX "temporary" variables in the environment (relies on
 # $eval()) and pass control to DEFINE_TEST_RUNNER_RULES.
diff --git a/tools/testing/selftests/bpf/prog_tests/static_linked.c b/tools/testing/selftests/bpf/prog_tests/static_linked.c
index 46556976dccc..1e6701483d27 100644
--- a/tools/testing/selftests/bpf/prog_tests/static_linked.c
+++ b/tools/testing/selftests/bpf/prog_tests/static_linked.c
@@ -6,7 +6,7 @@
 
 void test_static_linked(void)
 {
-	int err;
+	int err, key = 0, value = 0;
 	struct test_static_linked* skel;
 
 	skel = test_static_linked__open();
@@ -35,6 +35,10 @@ void test_static_linked(void)
 	ASSERT_EQ(skel->bss->var1, 1 * 2 + 2 + 3, "var1");
 	ASSERT_EQ(skel->bss->var2, 4 * 3 + 5 + 6, "var2");
 
+	err = bpf_map_lookup_elem(bpf_map__fd(skel->maps.legacy_map), &key, &value);
+	ASSERT_OK(err, "legacy_map_lookup");
+	ASSERT_EQ(value, 1 * 3 + 3,  "legacy_map_value");
+
 cleanup:
 	test_static_linked__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_static_linked3.nobtf.c b/tools/testing/selftests/bpf/progs/test_static_linked3.nobtf.c
new file mode 100644
index 000000000000..e5fbde21381c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_static_linked3.nobtf.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+/* global variables don't need BTF to be used, but are extremely unconvenient
+ * to be consumed from user-space without BPF skeleton, that uses BTF
+ */
+
+static volatile int mul3 = 3;
+static volatile int add3 = 3;
+
+/* same "subprog" name in all files */
+static __noinline int subprog(int x)
+{
+	/* but different formula */
+	return x * mul3 + add3;
+}
+
+struct bpf_map_def SEC("maps") legacy_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(int),
+	.value_size = sizeof(int),
+	.max_entries = 1,
+};
+
+SEC("raw_tp/sys_enter")
+int handler3(const void *ctx)
+{
+	int key = 0, value = subprog(1);
+
+	bpf_map_update_elem(&legacy_map, &key, &value, BPF_ANY);
+
+	return 0;
+}
-- 
2.30.2

