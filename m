Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A55C4A03C8
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 23:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351735AbiA1Wdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 17:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351722AbiA1Wdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 17:33:54 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3923BC061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:33:54 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id b5so6451057qtq.11
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=drECL07TLned7ySWqvu3I4souQyvtIZYsb6xvlPbqBU=;
        b=efNwnq2l+kfsdSWhCHPt8NmXSdMjJp+8LkTkteulbf6X7nseczonLERo0nJvKpVkv5
         3m8TSrqzGvjA//ohVvhc8+QmIJQurzjr6ZjW/k2fbcBUeV9/slkp9NMyfn9O+oAeJhDX
         hMaqAqug4saj63Dbphtz1u1ErEW/pknYlhKu4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=drECL07TLned7ySWqvu3I4souQyvtIZYsb6xvlPbqBU=;
        b=rjRizHGaQxCPIRLCtaMbKu7rmXKLfA/rCQVNZfBKNUr5dWuq5ZTNYLzVFZtEiA0DFK
         6fDnhZCFPjHjMkM0aGDW/42owoJIcIsrk7bWEna+BqbPKHEg/7d8yEX+rmhJ3q7yWeKT
         odkxUypmzNcSQ90mqNIaRS1DhQraMp1PxrrtbInXnAaE9wJeRYjCX9kEYISgpikwQxWp
         O7CPs2zv9lY0ho4Dh7tITyQIH16fEBDi1iM9PGIjCsrfLG84Dz6kjVTxT3S2z7uijIlC
         bO1jEJOADdAl6cTo2L1+EMMCPv5okvDD5fmb5tx/2Ga8/2nwugSEjKcEm7+e4m0eNWTJ
         e/IA==
X-Gm-Message-State: AOAM530oKXSx3W+gdANgKzPnGe+AxLRe/UkJj18nqPd+xBE7+ugw3Kr/
        JRuPRCXb7kSwrIB9C6JYr0Dqlu8RxHE8tzZBXZow2e4Vtj28s/Ji/kOqgrHqd3jxnpBT9c7PiWK
        J4jBAd0GMRhH6TGE2ZYxZhP19oBO8xGRDW5xc6/xgQJtYVtluULxSIJc+RIpeenlGVeukLQ==
X-Google-Smtp-Source: ABdhPJyYqwFtCHqNipsGLxBFC1o6mkLTYwRe7nvfr9wo4/pntEnCXKcIsOQUGfQR1Rrxzzl2DW6HZQ==
X-Received: by 2002:a05:622a:2d6:: with SMTP id a22mr7699236qtx.149.1643409230887;
        Fri, 28 Jan 2022 14:33:50 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id i18sm3723972qka.80.2022.01.28.14.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:33:50 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v5 9/9] selftest/bpf: Implement tests for bpftool gen min_core_btf
Date:   Fri, 28 Jan 2022 17:33:12 -0500
Message-Id: <20220128223312.1253169-10-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220128223312.1253169-1-mauricio@kinvolk.io>
References: <20220128223312.1253169-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements some integration tests for "BTFGen". The goal
of such tests is to verify that the generated BTF file contains the
expected types.

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   4 +-
 .../selftests/bpf/progs/btfgen_btf_source.c   |  12 +
 .../bpf/progs/btfgen_primitives_array.c       |  39 +++
 .../bpf/progs/btfgen_primitives_struct.c      |  40 +++
 .../bpf/progs/btfgen_primitives_struct2.c     |  44 ++++
 .../bpf/progs/btfgen_primitives_union.c       |  32 +++
 tools/testing/selftests/bpf/test_bpftool.c    | 228 ++++++++++++++++++
 8 files changed, 399 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btfgen_btf_source.c
 create mode 100644 tools/testing/selftests/bpf/progs/btfgen_primitives_array.c
 create mode 100644 tools/testing/selftests/bpf/progs/btfgen_primitives_struct.c
 create mode 100644 tools/testing/selftests/bpf/progs/btfgen_primitives_struct2.c
 create mode 100644 tools/testing/selftests/bpf/progs/btfgen_primitives_union.c
 create mode 100644 tools/testing/selftests/bpf/test_bpftool.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 1dad8d617da8..308cd5b9cfc4 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -41,3 +41,4 @@ test_cpp
 *.tmp
 xdpxceiver
 xdp_redirect_multi
+test_bpftool
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 945f92d71db3..afc9bff6545d 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -38,7 +38,8 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_sockmap get_cgroup_id_user \
 	test_cgroup_storage \
 	test_tcpnotify_user test_sysctl \
-	test_progs-no_alu32
+	test_progs-no_alu32 \
+	test_bpftool
 
 # Also test bpf-gcc, if present
 ifneq ($(BPF_GCC),)
@@ -212,6 +213,7 @@ $(OUTPUT)/xdping: $(TESTING_HELPERS)
 $(OUTPUT)/flow_dissector_load: $(TESTING_HELPERS)
 $(OUTPUT)/test_maps: $(TESTING_HELPERS)
 $(OUTPUT)/test_verifier: $(TESTING_HELPERS)
+$(OUTPUT)/test_bpftool:
 
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
diff --git a/tools/testing/selftests/bpf/progs/btfgen_btf_source.c b/tools/testing/selftests/bpf/progs/btfgen_btf_source.c
new file mode 100644
index 000000000000..772d5d1e2788
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btfgen_btf_source.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "core_reloc_types.h"
+
+// structure made of primitive types
+void f0(struct core_reloc_primitives x) {}
+
+// union made of primite types
+void f1(union a_union x) {}
+
+// arrays
+void f2(struct core_reloc_arrays x) {}
diff --git a/tools/testing/selftests/bpf/progs/btfgen_primitives_array.c b/tools/testing/selftests/bpf/progs/btfgen_primitives_array.c
new file mode 100644
index 000000000000..aa514d1bcd96
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btfgen_primitives_array.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+
+char _license[] SEC("license") = "GPL";
+
+struct {
+	char in[256];
+	char out[256];
+} data = {};
+
+struct core_reloc_arrays_substruct {
+	int c;
+	int d;
+};
+
+struct core_reloc_arrays {
+	int a[5];
+	char b[2][3][4];
+	struct core_reloc_arrays_substruct c[3];
+	struct core_reloc_arrays_substruct d[1][2];
+	struct core_reloc_arrays_substruct f[][2];
+};
+#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*(dst)), src)
+
+SEC("raw_tracepoint/sys_enter")
+int test_btfgen_primitives(void *ctx)
+{
+	struct core_reloc_arrays *in = (void *)&data.in;
+	struct core_reloc_arrays *out = (void *)&data.out;
+
+	if (CORE_READ(&out->a[0], &in->a[0]))
+		return 1;
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/btfgen_primitives_struct.c b/tools/testing/selftests/bpf/progs/btfgen_primitives_struct.c
new file mode 100644
index 000000000000..b761d020fa4d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btfgen_primitives_struct.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+
+char _license[] SEC("license") = "GPL";
+
+struct {
+	char in[256];
+	char out[256];
+} data = {};
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
+#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*(dst)), src)
+
+SEC("raw_tracepoint/sys_enter")
+int test_btfgen_primitives(void *ctx)
+{
+	struct core_reloc_primitives *in = (void *)&data.in;
+	struct core_reloc_primitives *out = (void *)&data.out;
+
+	if (CORE_READ(&out->a, &in->a))
+		return 1;
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/btfgen_primitives_struct2.c b/tools/testing/selftests/bpf/progs/btfgen_primitives_struct2.c
new file mode 100644
index 000000000000..fe67c9a24a7f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btfgen_primitives_struct2.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* This is almost the same as btfgen_primitives_struct.c but in this one
+ * a different field is accessed
+ */
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+
+char _license[] SEC("license") = "GPL";
+
+struct {
+	char in[256];
+	char out[256];
+} data = {};
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
+#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*(dst)), src)
+
+SEC("raw_tracepoint/sys_enter")
+int test_btfgen_primitives(void *ctx)
+{
+	struct core_reloc_primitives *in = (void *)&data.in;
+	struct core_reloc_primitives *out = (void *)&data.out;
+
+	if (CORE_READ(&out->b, &in->b))
+		return 1;
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/btfgen_primitives_union.c b/tools/testing/selftests/bpf/progs/btfgen_primitives_union.c
new file mode 100644
index 000000000000..d4690c9e963c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btfgen_primitives_union.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+
+char _license[] SEC("license") = "GPL";
+
+struct {
+	char in[256];
+	char out[256];
+} data = {};
+
+union a_union {
+	int y;
+	int z;
+};
+
+#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*(dst)), src)
+
+SEC("raw_tracepoint/sys_enter")
+int test_btfgen_primitives(void *ctx)
+{
+	union a_union *in = (void *)&data.in;
+	union a_union *out = (void *)&data.out;
+
+	if (CORE_READ(&out->y, &in->y))
+		return 1;
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/test_bpftool.c b/tools/testing/selftests/bpf/test_bpftool.c
new file mode 100644
index 000000000000..ca7facc582d5
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_bpftool.c
@@ -0,0 +1,228 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <stdio.h>
+#include <string.h>
+#include <assert.h>
+#include <stdlib.h>
+#include <linux/limits.h>
+
+#include <bpf/libbpf.h>
+#include <bpf/btf.h>
+
+#include "bpf_util.h"
+
+static int run_btfgen(const char *src_btf, const char *dst_btf, const char *objspaths[])
+{
+	char command[4096];
+	int ret, i, n;
+
+	n = snprintf(command, sizeof(command),
+		     "./tools/build/bpftool/bpftool gen min_core_btf %s %s", src_btf, dst_btf);
+	assert(n >= 0 && n < sizeof(command));
+
+	for (i = 0; objspaths[i] != NULL; i++) {
+		assert(sizeof(command) - strlen(command) > strlen(objspaths[i]) + 1);
+		strcat(command, " ");
+		strcat(command, objspaths[i]);
+	}
+
+	printf("Executing bpftool: %s\n", command);
+	printf("---\n");
+	ret = system(command);
+	printf("---\n");
+	return ret;
+}
+
+struct btfgen_test {
+	const char *descr;
+	const char *src_btf;
+	const char *bpfobj[16];
+	void (*run_test)(struct btf *btf);
+};
+
+static void check_btfgen_primitive_struct(struct btf *btf)
+{
+	struct btf_member *members;
+	const struct btf_type *t;
+	int id;
+
+	assert(btf__type_cnt(btf) == 3);
+
+	id = btf__find_by_name_kind(btf, "core_reloc_primitives", BTF_KIND_STRUCT);
+	assert(id > 0);
+
+	t = btf__type_by_id(btf, id);
+	assert(btf_vlen(t) == 1);
+
+	members = btf_members(t);
+
+	id = btf__find_by_name_kind(btf, "char", BTF_KIND_INT);
+	assert(id > 0);
+
+	/* the type of the struct member must be the char */
+	assert(members[0].type == id);
+}
+
+static void check_btfgen_primitive_union(struct btf *btf)
+{
+	struct btf_member *members;
+	const struct btf_type *t;
+	int id;
+
+	/* void, a_union and int*/
+	assert(btf__type_cnt(btf) == 3);
+
+	id = btf__find_by_name_kind(btf, "a_union", BTF_KIND_UNION);
+	assert(id > 0);
+
+	t = btf__type_by_id(btf, id);
+	assert(btf_vlen(t) == 1);
+
+	members = btf_members(t);
+
+	id = btf__find_by_name_kind(btf, "int", BTF_KIND_INT);
+	assert(id > 0);
+
+	/* the type of the union member must be the integer */
+	assert(members[0].type == id);
+}
+
+static void check_btfgen_primitive_array(struct btf *btf)
+{
+	int array_id, array_type_id, array_index_type_id;
+	struct btf_array *array;
+
+	/* void, struct, array, int (array index type) and int (array type) */
+	assert(btf__type_cnt(btf) == 5);
+
+	array_id = btf__find_by_name_kind(btf, "", BTF_KIND_ARRAY);
+	assert(array_id > 0);
+
+	array = btf_array(btf__type_by_id(btf, array_id));
+
+	array_type_id = btf__find_by_name_kind(btf, "int", BTF_KIND_INT);
+	assert(array_type_id > 0);
+
+	array_index_type_id = btf__find_by_name_kind(btf, "__ARRAY_SIZE_TYPE__", BTF_KIND_INT);
+	assert(array_index_type_id > 0);
+
+	/* check that array types are the correct ones */
+	assert(array->type == array_type_id);
+	assert(array->index_type == array_index_type_id);
+}
+
+/* If there are relocations in two different BPF objects involving
+ * different members of the same struct, then the generated BTF should
+ * contain a single instance of such struct with both fields.
+ */
+static void check_btfgen_primitive_structs_different_objects(struct btf *btf)
+{
+	struct btf_member *members;
+	const struct btf_type *t;
+	int struct_id, char_id, int_id;
+
+	/* void, struct, int and char */
+	assert(btf__type_cnt(btf) == 4);
+
+	struct_id = btf__find_by_name_kind(btf, "core_reloc_primitives", BTF_KIND_STRUCT);
+	assert(struct_id > 0);
+
+	t = btf__type_by_id(btf, struct_id);
+	assert(btf_vlen(t) == 2);
+
+	members = btf_members(t);
+
+	char_id = btf__find_by_name_kind(btf, "char", BTF_KIND_INT);
+	assert(char_id > 0);
+
+	int_id = btf__find_by_name_kind(btf, "int", BTF_KIND_INT);
+	assert(int_id > 0);
+
+	for (int i = 0; i < btf_vlen(t); i++) {
+		const char *name = btf__str_by_offset(btf, members[i].name_off);
+
+		if (!strcmp("a", name))
+			assert(members[i].type == char_id);
+		else if (!strcmp("b", name))
+			assert(members[i].type == int_id);
+	}
+}
+
+static struct btfgen_test btfgen_tests[] = {
+	{
+		"primitive struct",
+		"btfgen_btf_source.o",
+		{
+			"btfgen_primitives_struct.o",
+		},
+		check_btfgen_primitive_struct,
+	},
+	{
+		"primitive union",
+		"btfgen_btf_source.o",
+		{
+			"btfgen_primitives_union.o",
+		},
+		check_btfgen_primitive_union,
+	},
+	{
+		"primitive array",
+		"btfgen_btf_source.o",
+		{
+			"btfgen_primitives_array.o",
+		},
+		check_btfgen_primitive_array,
+	},
+	{
+		"primitive structs in different objects",
+		"btfgen_btf_source.o",
+		{
+			"btfgen_primitives_struct.o",
+			"btfgen_primitives_struct2.o",
+		},
+		check_btfgen_primitive_structs_different_objects,
+	},
+};
+
+void test_gen_min_core_btf(void)
+{
+	char target_path[PATH_MAX];
+	struct btfgen_test *test;
+	struct btf *dst_btf;
+	int ret;
+
+	for (int i = 0; i < ARRAY_SIZE(btfgen_tests); i++) {
+		char dir_path[] = "/tmp/btfgen-XXXXXX";
+
+		test = &btfgen_tests[i];
+
+		printf("Running %s\n", test->descr);
+
+		mkdtemp(dir_path);
+
+		snprintf(target_path, sizeof(target_path), "%s/foo.btf", dir_path);
+
+		ret = run_btfgen(test->src_btf, target_path, test->bpfobj);
+		assert(ret == 0);
+
+		dst_btf = btf__parse(target_path, NULL);
+		assert(dst_btf != NULL);
+
+		test->run_test(dst_btf);
+
+		printf("Test %s: PASS\n", test->descr);
+	}
+
+	printf("%s: PASS\n", __func__);
+}
+
+int main(void)
+{
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
+	test_gen_min_core_btf();
+
+	printf("test_bpftool: OK\n");
+
+	return 0;
+}
-- 
2.25.1

