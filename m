Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA6028BB7
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388310AbfEWUmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:42:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36250 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388262AbfEWUmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 16:42:50 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NKaDLA012362
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:42:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=07/nnbmqQOvD5ML2uHIoVrIQCrS5trZYIcjnoCrnuIQ=;
 b=i5iHSfMWHPlQBvwMlZhB+zdlhyUW1IduJ331MsOvb7gIkE3piT7vmrwNhnCOZOwQXQfm
 8hdhhrv211wCI7EEb5MiSDayqxFieR23RYmMw6yCmBjVT+mdPQ5EP/tZir2HaJ3HdWRm
 zW/Rd5h0b0K32PjU6sxid2L8+WVYVHMKp/U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2snspaa0gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:42:47 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 23 May 2019 13:42:45 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 0E1A9861799; Thu, 23 May 2019 13:42:44 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 09/12] selftests/bpf: add btf_dump BTF-to-C conversion tests
Date:   Thu, 23 May 2019 13:42:19 -0700
Message-ID: <20190523204222.3998365-10-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523204222.3998365-1-andriin@fb.com>
References: <20190523204222.3998365-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_17:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new test_btf_dump set of tests, validating BTF-to-C conversion
correctness. Tests rely on clang to generate BTF from provided C test
cases.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/progs/btf_dump_test_case_bitfields.c  |  92 +++++++
 .../bpf/progs/btf_dump_test_case_multidim.c   |  35 +++
 .../progs/btf_dump_test_case_namespacing.c    |  73 ++++++
 .../bpf/progs/btf_dump_test_case_ordering.c   |  63 +++++
 .../bpf/progs/btf_dump_test_case_packing.c    |  75 ++++++
 .../bpf/progs/btf_dump_test_case_padding.c    | 111 +++++++++
 .../bpf/progs/btf_dump_test_case_syntax.c     | 229 ++++++++++++++++++
 tools/testing/selftests/bpf/test_btf_dump.c   | 143 +++++++++++
 10 files changed, 824 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_multidim.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_namespacing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_ordering.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
 create mode 100644 tools/testing/selftests/bpf/test_btf_dump.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 138b6c063916..b3da2ffdc158 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -36,3 +36,4 @@ alu32
 libbpf.pc
 libbpf.so.*
 test_hashmap
+test_btf_dump
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index ddae06498a00..cd23758e8b7a 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -23,7 +23,8 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
 	test_sock test_btf test_sockmap test_lirc_mode2_user get_cgroup_id_user \
 	test_socket_cookie test_cgroup_storage test_select_reuseport test_section_names \
-	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap
+	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
+	test_btf_dump
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
new file mode 100644
index 000000000000..8f44767a75fa
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * BTF-to-C dumper tests for bitfield.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+#include <stdbool.h>
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct bitfields_only_mixed_types {
+ *	int a: 3;
+ *	long int b: 2;
+ *	_Bool c: 1;
+ *	enum {
+ *		A = 0,
+ *		B = 1,
+ *	} d: 1;
+ *	short e: 5;
+ *	int: 20;
+ *	unsigned int f: 30;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct bitfields_only_mixed_types {
+	int a: 3;
+	long int b: 2;
+	bool c: 1; /* it's really a _Bool type */
+	enum {
+		A, /* A = 0, dumper is very explicit */
+		B, /* B = 1, same */
+	} d: 1;
+	short e: 5;
+	/* 20-bit padding here */
+	unsigned f: 30; /* this gets aligned on 4-byte boundary */
+};
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct bitfield_mixed_with_others {
+ *	char: 4;
+ *	int a: 4;
+ *	short b;
+ *	long int c;
+ *	long int d: 8;
+ *	int e;
+ *	int f;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+struct bitfield_mixed_with_others {
+	long: 4; /* char is enough as a backing field */
+	int a: 4;
+	/* 8-bit implicit padding */
+	short b; /* combined with previous bitfield */
+	/* 4 more bytes of implicit padding */
+	long c;
+	long d: 8;
+	/* 24 bits implicit padding */
+	int e; /* combined with previous bitfield */
+	int f;
+	/* 4 bytes of padding */
+};
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct bitfield_flushed {
+ *	int a: 4;
+ *	long: 60;
+ *	long int b: 16;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+struct bitfield_flushed {
+	int a: 4;
+	long: 0; /* flush until next natural alignment boundary */
+	long b: 16;
+};
+
+int f(struct {
+	struct bitfields_only_mixed_types _1;
+	struct bitfield_mixed_with_others _2;
+	struct bitfield_flushed _3;
+} *_)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_multidim.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_multidim.c
new file mode 100644
index 000000000000..ba97165bdb28
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_multidim.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * BTF-to-C dumper test for multi-dimensional array output.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+typedef int arr_t[2];
+
+typedef int multiarr_t[3][4][5];
+
+typedef int *ptr_arr_t[6];
+
+typedef int *ptr_multiarr_t[7][8][9][10];
+
+typedef int * (*fn_ptr_arr_t[11])();
+
+typedef int * (*fn_ptr_multiarr_t[12][13])();
+
+struct root_struct {
+	arr_t _1;
+	multiarr_t _2;
+	ptr_arr_t _3;
+	ptr_multiarr_t _4;
+	fn_ptr_arr_t _5;
+	fn_ptr_multiarr_t _6;
+};
+
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+int f(struct root_struct *s)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_namespacing.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_namespacing.c
new file mode 100644
index 000000000000..92a4ad428710
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_namespacing.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * BTF-to-C dumper test validating no name versioning happens between
+ * independent C namespaces (struct/union/enum vs typedef/enum values).
+ *
+ * Copyright (c) 2019 Facebook
+ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct S {
+	int S;
+	int U;
+};
+
+typedef struct S S;
+
+union U {
+	int S;
+	int U;
+};
+
+typedef union U U;
+
+enum E {
+	V = 0,
+};
+
+typedef enum E E;
+
+struct A {};
+
+union B {};
+
+enum C {
+	A = 1,
+	B = 2,
+	C = 3,
+};
+
+struct X {};
+
+union Y {};
+
+enum Z;
+
+typedef int X;
+
+typedef int Y;
+
+typedef int Z;
+
+/*------ END-EXPECTED-OUTPUT ------ */
+
+int f(struct {
+	struct S _1;
+	S _2;
+	union U _3;
+	U _4;
+	enum E _5;
+	E _6;
+	struct A a;
+	union B b;
+	enum C c;
+	struct X x;
+	union Y y;
+	enum Z *z;
+	X xx;
+	Y yy;
+	Z zz;
+} *_)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_ordering.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_ordering.c
new file mode 100644
index 000000000000..7c95702ee4cb
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_ordering.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * BTF-to-C dumper test for topological sorting of dependent structs.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct s1 {};
+
+struct s3;
+
+struct s4;
+
+struct s2 {
+	struct s2 *s2;
+	struct s3 *s3;
+	struct s4 *s4;
+};
+
+struct s3 {
+	struct s1 s1;
+	struct s2 s2;
+};
+
+struct s4 {
+	struct s1 s1;
+	struct s3 s3;
+};
+
+struct list_head {
+	struct list_head *next;
+	struct list_head *prev;
+};
+
+struct hlist_node {
+	struct hlist_node *next;
+	struct hlist_node **pprev;
+};
+
+struct hlist_head {
+	struct hlist_node *first;
+};
+
+struct callback_head {
+	struct callback_head *next;
+	void (*func)(struct callback_head *);
+};
+
+struct root_struct {
+	struct s4 s4;
+	struct list_head l;
+	struct hlist_node n;
+	struct hlist_head h;
+	struct callback_head cb;
+};
+
+/*------ END-EXPECTED-OUTPUT ------ */
+
+int f(struct root_struct *root)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
new file mode 100644
index 000000000000..1cef3bec1dc7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * BTF-to-C dumper tests for struct packing determination.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct packed_trailing_space {
+	int a;
+	short b;
+} __attribute__((packed));
+
+struct non_packed_trailing_space {
+	int a;
+	short b;
+};
+
+struct packed_fields {
+	short a;
+	int b;
+} __attribute__((packed));
+
+struct non_packed_fields {
+	short a;
+	int b;
+};
+
+struct nested_packed {
+	char: 4;
+	int a: 4;
+	long int b;
+	struct {
+		char c;
+		int d;
+	} __attribute__((packed)) e;
+} __attribute__((packed));
+
+union union_is_never_packed {
+	int a: 4;
+	char b;
+	char c: 1;
+};
+
+union union_does_not_need_packing {
+	struct {
+		long int a;
+		int b;
+	} __attribute__((packed));
+	int c;
+};
+
+union jump_code_union {
+	char code[5];
+	struct {
+		char jump;
+		int offset;
+	} __attribute__((packed));
+};
+
+/*------ END-EXPECTED-OUTPUT ------ */
+
+int f(struct {
+	struct packed_trailing_space _1;
+	struct non_packed_trailing_space _2;
+	struct packed_fields _3;
+	struct non_packed_fields _4;
+	struct nested_packed _5;
+	union union_is_never_packed _6;
+	union union_does_not_need_packing _7;
+	union jump_code_union _8;
+} *_)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
new file mode 100644
index 000000000000..3a62119c7498
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * BTF-to-C dumper tests for implicit and explicit padding between fields and
+ * at the end of a struct.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct padded_implicitly {
+	int a;
+	long int b;
+	char c;
+};
+
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct padded_explicitly {
+ *	int a;
+ *	int: 32;
+ *	int b;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct padded_explicitly {
+	int a;
+	int: 1; /* algo will explicitly pad with full 32 bits here */
+	int b;
+};
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct padded_a_lot {
+ *	int a;
+ *	long: 32;
+ *	long: 64;
+ *	long: 64;
+ *	int b;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct padded_a_lot {
+	int a;
+	/* 32 bit of implicit padding here, which algo will make explicit */
+	long: 64;
+	long: 64;
+	int b;
+};
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct padded_cache_line {
+ *	int a;
+ *	long: 32;
+ *	long: 64;
+ *	long: 64;
+ *	long: 64;
+ *	int b;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct padded_cache_line {
+	int a;
+	int b __attribute__((aligned(32)));
+};
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct zone_padding {
+ *	char x[0];
+ *};
+ *
+ *struct zone {
+ *	int a;
+ *	short b;
+ *	short: 16;
+ *	struct zone_padding __pad__;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct zone_padding {
+	char x[0];
+} __attribute__((__aligned__(8)));
+
+struct zone {
+	int a;
+	short b;
+	short: 16;
+	struct zone_padding __pad__;
+};
+
+int f(struct {
+	struct padded_implicitly _1;
+	struct padded_explicitly _2;
+	struct padded_a_lot _3;
+	struct padded_cache_line _4;
+	struct zone _5;
+} *_)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
new file mode 100644
index 000000000000..d4a02fe44a12
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
@@ -0,0 +1,229 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * BTF-to-C dumper test for majority of C syntax quirks.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+enum e1 {
+	A = 0,
+	B = 1,
+};
+
+enum e2 {
+	C = 100,
+	D = -100,
+	E = 0,
+};
+
+typedef enum e2 e2_t;
+
+typedef enum {
+	F = 0,
+	G = 1,
+	H = 2,
+} e3_t;
+
+typedef int int_t;
+
+typedef volatile const int * volatile const crazy_ptr_t;
+
+typedef int *****we_need_to_go_deeper_ptr_t;
+
+typedef volatile const we_need_to_go_deeper_ptr_t * restrict * volatile * const * restrict volatile * restrict const * volatile const * restrict volatile const how_about_this_ptr_t;
+
+typedef int *ptr_arr_t[10];
+
+typedef void (*fn_ptr1_t)(int);
+
+typedef void (*printf_fn_t)(const char *, ...);
+
+/* ------ END-EXPECTED-OUTPUT ------ */
+/*
+ * While previous function pointers are pretty trivial (C-syntax-level
+ * trivial), the following are deciphered here for future generations:
+ *
+ * - `fn_ptr2_t`: function, taking anonymous struct as a first arg and pointer
+ *   to a function, that takes int and returns int, as a second arg; returning
+ *   a pointer to a const pointer to a char. Equivalent to:
+ *	typedef struct { int a; } s_t;
+ *	typedef int (*fn_t)(int);
+ *	typedef char * const * (*fn_ptr2_t)(s_t, fn_t);
+ *
+ * - `fn_complext_t`: pointer to a function returning struct and accepting
+ *   union and struct. All structs and enum are anonymous and defined inline.
+ *
+ * - `signal_t: pointer to a function accepting a pointer to a function as an
+ *   argument and returning pointer to a function as a result. Sane equivalent:
+ *	typedef void (*signal_handler_t)(int);
+ *	typedef signal_handler_t (*signal_ptr_t)(int, signal_handler_t);
+ *
+ * - fn_ptr_arr1_t: array of pointers to a function accepting pointer to
+ *   a pointer to an int and returning pointer to a char. Easy.
+ *
+ * - fn_ptr_arr2_t: array of const pointers to a function taking no arguments
+ *   and returning a const pointer to a function, that takes pointer to a
+ *   `int -> char *` function and returns pointer to a char. Equivalent:
+ *   typedef char * (*fn_input_t)(int);
+ *   typedef char * (*fn_output_outer_t)(fn_input_t);
+ *   typedef const fn_output_outer_t (* fn_output_inner_t)();
+ *   typedef const fn_output_inner_t fn_ptr_arr2_t[5];
+ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+typedef char * const * (*fn_ptr2_t)(struct {
+	int a;
+}, int (*)(int));
+
+typedef struct {
+	int a;
+	void (*b)(int, struct {
+		int c;
+	}, union {
+		char d;
+		int e[5];
+	});
+} (*fn_complex_t)(union {
+	void *f;
+	char g[16];
+}, struct {
+	int h;
+});
+
+typedef void (* (*signal_t)(int, void (*)(int)))(int);
+
+typedef char * (*fn_ptr_arr1_t[10])(int **);
+
+typedef char * (* const (* const fn_ptr_arr2_t[5])())(char * (*)(int));
+
+struct struct_w_typedefs {
+	int_t a;
+	crazy_ptr_t b;
+	we_need_to_go_deeper_ptr_t c;
+	how_about_this_ptr_t d;
+	ptr_arr_t e;
+	fn_ptr1_t f;
+	printf_fn_t g;
+	fn_ptr2_t h;
+	fn_complex_t i;
+	signal_t j;
+	fn_ptr_arr1_t k;
+	fn_ptr_arr2_t l;
+};
+
+typedef struct {
+	int x;
+	int y;
+	int z;
+} anon_struct_t;
+
+struct struct_fwd;
+
+typedef struct struct_fwd struct_fwd_t;
+
+typedef struct struct_fwd *struct_fwd_ptr_t;
+
+union union_fwd;
+
+typedef union union_fwd union_fwd_t;
+
+typedef union union_fwd *union_fwd_ptr_t;
+
+struct struct_empty {};
+
+struct struct_simple {
+	int a;
+	char b;
+	const int_t *p;
+	struct struct_empty s;
+	enum e2 e;
+	enum {
+		ANON_VAL1 = 1,
+		ANON_VAL2 = 2,
+	} f;
+	int arr1[13];
+	enum e2 arr2[5];
+};
+
+union union_empty {};
+
+union union_simple {
+	void *ptr;
+	int num;
+	int_t num2;
+	union union_empty u;
+};
+
+struct struct_in_struct {
+	struct struct_simple simple;
+	union union_simple also_simple;
+	struct {
+		int a;
+	} not_so_hard_as_well;
+	union {
+		int b;
+		int c;
+	} anon_union_is_good;
+	struct {
+		int d;
+		int e;
+	};
+	union {
+		int f;
+		int g;
+	};
+};
+
+struct struct_with_embedded_stuff {
+	int a;
+	struct {
+		int b;
+		struct {
+			struct struct_with_embedded_stuff *c;
+			const char *d;
+		} e;
+		union {
+			volatile long int f;
+			void * restrict g;
+		};
+	};
+	union {
+		const int_t *h;
+		void (*i)(char, int, void *);
+	} j;
+	enum {
+		K = 100,
+		L = 200,
+	} m;
+	char n[16];
+	struct {
+		char o;
+		int p;
+		void (*q)(int);
+	} r[5];
+	struct struct_in_struct s[10];
+	int t[11];
+};
+
+struct root_struct {
+	enum e1 _1;
+	enum e2 _2;
+	e2_t _2_1;
+	e3_t _2_2;
+	struct struct_w_typedefs _3;
+	anon_struct_t _7;
+	struct struct_fwd *_8;
+	struct_fwd_t *_9;
+	struct_fwd_ptr_t _10;
+	union union_fwd *_11;
+	union_fwd_t *_12;
+	union_fwd_ptr_t _13;
+	struct struct_with_embedded_stuff _14;
+};
+
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+int f(struct root_struct *s)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/test_btf_dump.c b/tools/testing/selftests/bpf/test_btf_dump.c
new file mode 100644
index 000000000000..8f850823d35f
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_btf_dump.c
@@ -0,0 +1,143 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <linux/err.h>
+#include <btf.h>
+
+#define CHECK(condition, format...) ({					\
+	int __ret = !!(condition);					\
+	if (__ret) {							\
+		fprintf(stderr, "%s:%d:FAIL ", __func__, __LINE__);	\
+		fprintf(stderr, format);				\
+	}								\
+	__ret;								\
+})
+
+void btf_dump_printf(void *ctx, const char *fmt, va_list args)
+{
+	vfprintf(ctx, fmt, args);
+}
+
+struct btf_dump_test_case {
+	const char *name;
+	struct btf_dump_opts opts;
+} btf_dump_test_cases[] = {
+	{.name = "btf_dump_test_case_syntax", .opts = {}},
+	{.name = "btf_dump_test_case_ordering", .opts = {}},
+	{.name = "btf_dump_test_case_padding", .opts = {}},
+	{.name = "btf_dump_test_case_packing", .opts = {}},
+	{.name = "btf_dump_test_case_bitfields", .opts = {}},
+	{.name = "btf_dump_test_case_multidim", .opts = {}},
+	{.name = "btf_dump_test_case_namespacing", .opts = {}},
+};
+
+static int btf_dump_all_types(const struct btf *btf,
+			      const struct btf_dump_opts *opts)
+{
+	size_t type_cnt = btf__get_nr_types(btf);
+	struct btf_dump *d;
+	int err = 0, id;
+
+	d = btf_dump__new(btf, NULL, opts, btf_dump_printf);
+	if (IS_ERR(d))
+		return PTR_ERR(d);
+
+	for (id = 1; id <= type_cnt; id++) {
+		err = btf_dump__dump_type(d, id);
+		if (err)
+			goto done;
+	}
+
+done:
+	btf_dump__free(d);
+	return err;
+}
+
+int test_btf_dump_case(int n, struct btf_dump_test_case *test_case)
+{
+	char test_file[256], out_file[256], diff_cmd[1024];
+	struct btf *btf = NULL;
+	int err = 0, fd = -1;
+	FILE *f = NULL;
+
+	fprintf(stderr, "Test case #%d (%s): ", n, test_case->name);
+
+	snprintf(test_file, sizeof(test_file), "%s.o", test_case->name);
+
+	btf = btf__parse_elf(test_file, NULL);
+	if (CHECK(IS_ERR(btf),
+	    "failed to load test BTF: %ld\n", PTR_ERR(btf))) {
+		err = -PTR_ERR(btf);
+		btf = NULL;
+		goto done;
+	}
+
+	snprintf(out_file, sizeof(out_file),
+		 "/tmp/%s.output.XXXXXX", test_case->name);
+	fd = mkstemp(out_file);
+	if (CHECK(fd < 0, "failed to create temp output file: %d\n", fd)) {
+		err = fd;
+		goto done;
+	}
+	f = fdopen(fd, "w");
+	if (CHECK(f == NULL, "failed to open temp output file: %s(%d)\n",
+		  strerror(errno), errno)) {
+		close(fd);
+		goto done;
+	}
+
+	test_case->opts.ctx = f;
+	err = btf_dump_all_types(btf, &test_case->opts);
+	fclose(f);
+	close(fd);
+	if (CHECK(err, "failure during C dumping: %d\n", err)) {
+		goto done;
+	}
+
+	snprintf(test_file, sizeof(test_file), "progs/%s.c", test_case->name);
+	/*
+	 * Diff test output and expected test output, contained between
+	 * START-EXPECTED-OUTPUT and END-EXPECTED-OUTPUT lines in test case.
+	 * For expected output lines, everything before '*' is stripped out.
+	 * Also lines containing comment start and comment end markers are
+	 * ignored. 
+	 */
+	snprintf(diff_cmd, sizeof(diff_cmd),
+		 "awk '/START-EXPECTED-OUTPUT/{out=1;next} "
+		 "/END-EXPECTED-OUTPUT/{out=0} "
+		 "/\\/\\*|\\*\\//{next} " /* ignore comment start/end lines */
+		 "out {sub(/^[ \\t]*\\*/, \"\"); print}' '%s' | diff -u - '%s'",
+		 test_file, out_file);
+	err = system(diff_cmd);
+	if (CHECK(err,
+		  "differing test output, output=%s, err=%d, diff cmd:\n%s\n",
+		  out_file, err, diff_cmd))
+		goto done;
+
+	remove(out_file);
+	fprintf(stderr, "OK\n");
+
+done:
+	btf__free(btf);
+	return err;
+}
+
+int main() {
+	int test_case_cnt, i, err, failed = 0;
+
+	test_case_cnt = sizeof(btf_dump_test_cases) /
+			sizeof(btf_dump_test_cases[0]);
+
+	for (i = 0; i < test_case_cnt; i++) {
+		err = test_btf_dump_case(i, &btf_dump_test_cases[i]);
+		if (err)
+			failed++;
+	}
+
+	fprintf(stderr, "%d tests succeeded, %d tests failed.\n",
+		test_case_cnt - failed, failed);
+
+	return failed;
+}
-- 
2.17.1

