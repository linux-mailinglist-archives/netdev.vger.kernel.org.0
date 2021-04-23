Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA573698E6
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhDWSOq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 14:14:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29218 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243472AbhDWSOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:14:42 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NIACPe020448
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:04 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3839sh8hwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:04 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:14:03 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A96E82ED5CB8; Fri, 23 Apr 2021 11:13:58 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v3 bpf-next 04/18] libbpf: mark BPF subprogs with hidden visibility as static for BPF verifier
Date:   Fri, 23 Apr 2021 11:13:34 -0700
Message-ID: <20210423181348.1801389-5-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423181348.1801389-1-andrii@kernel.org>
References: <20210423181348.1801389-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: vN4gkUNmVvF614Vecr27wYjrEw-oDv4J
X-Proofpoint-GUID: vN4gkUNmVvF614Vecr27wYjrEw-oDv4J
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 malwarescore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define __hidden helper macro in bpf_helpers.h, which is a short-hand for
__attribute__((visibility("hidden"))). Add libbpf support to mark BPF
subprograms marked with __hidden as static in BTF information to enforce BPF
verifier's static function validation algorithm, which takes more information
(caller's context) into account during a subprogram validation.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/bpf_helpers.h     |  8 ++++++
 tools/lib/bpf/btf.c             |  5 ----
 tools/lib/bpf/libbpf.c          | 45 ++++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf_internal.h |  6 +++++
 4 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 75c7581b304c..9720dc0b4605 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -47,6 +47,14 @@
 #define __weak __attribute__((weak))
 #endif
 
+/*
+ * Use __hidden attribute to mark a non-static BPF subprogram effectively
+ * static for BPF verifier's verification algorithm purposes, allowing more
+ * extensive and permissive BPF verification process, taking into account
+ * subprogram's caller context.
+ */
+#define __hidden __attribute__((visibility("hidden")))
+
 /* When utilizing vmlinux.h with BPF CO-RE, user BPF programs can't include
  * any system-level headers (such as stddef.h, linux/version.h, etc), and
  * commonly-used macros like NULL and KERNEL_VERSION aren't available through
diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index d30e67e7e1e5..d57e13a13798 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1605,11 +1605,6 @@ static void *btf_add_type_mem(struct btf *btf, size_t add_sz)
 			      btf->hdr->type_len, UINT_MAX, add_sz);
 }
 
-static __u32 btf_type_info(int kind, int vlen, int kflag)
-{
-	return (kflag << 31) | (kind << 24) | vlen;
-}
-
 static void btf_type_inc_vlen(struct btf_type *t)
 {
 	t->info = btf_type_info(btf_kind(t), btf_vlen(t) + 1, btf_kflag(t));
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9cc2d45b0080..8bac9c7627aa 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -71,6 +71,7 @@
 static struct bpf_map *bpf_object__add_map(struct bpf_object *obj);
 static const struct btf_type *
 skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id);
+static bool prog_is_subprog(const struct bpf_object *obj, const struct bpf_program *prog);
 
 static int __base_pr(enum libbpf_print_level level, const char *format,
 		     va_list args)
@@ -274,6 +275,7 @@ struct bpf_program {
 	bpf_program_clear_priv_t clear_priv;
 
 	bool load;
+	bool mark_btf_static;
 	enum bpf_prog_type type;
 	enum bpf_attach_type expected_attach_type;
 	int prog_ifindex;
@@ -698,6 +700,15 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
 		if (err)
 			return err;
 
+		/* if function is a global/weak symbol, but has hidden
+		 * visibility (STV_HIDDEN), mark its BTF FUNC as static to
+		 * enable more permissive BPF verification mode with more
+		 * outside context available to BPF verifier
+		 */
+		if (GELF_ST_BIND(sym.st_info) != STB_LOCAL
+		    && GELF_ST_VISIBILITY(sym.st_other) == STV_HIDDEN)
+			prog->mark_btf_static = true;
+
 		nr_progs++;
 		obj->nr_programs = nr_progs;
 
@@ -2618,7 +2629,7 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 {
 	struct btf *kern_btf = obj->btf;
 	bool btf_mandatory, sanitize;
-	int err = 0;
+	int i, err = 0;
 
 	if (!obj->btf)
 		return 0;
@@ -2632,6 +2643,38 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 		return 0;
 	}
 
+	/* Even though some subprogs are global/weak, user might prefer more
+	 * permissive BPF verification process that BPF verifier performs for
+	 * static functions, taking into account more context from the caller
+	 * functions. In such case, they need to mark such subprogs with
+	 * __attribute__((visibility("hidden"))) and libbpf will adjust
+	 * corresponding FUNC BTF type to be marked as static and trigger more
+	 * involved BPF verification process.
+	 */
+	for (i = 0; i < obj->nr_programs; i++) {
+		struct bpf_program *prog = &obj->programs[i];
+		struct btf_type *t;
+		const char *name;
+		int j, n;
+
+		if (!prog->mark_btf_static || !prog_is_subprog(obj, prog))
+			continue;
+
+		n = btf__get_nr_types(obj->btf);
+		for (j = 1; j <= n; j++) {
+			t = btf_type_by_id(obj->btf, j);
+			if (!btf_is_func(t) || btf_func_linkage(t) != BTF_FUNC_GLOBAL)
+				continue;
+
+			name = btf__str_by_offset(obj->btf, t->name_off);
+			if (strcmp(name, prog->name) != 0)
+				continue;
+
+			t->info = btf_type_info(BTF_KIND_FUNC, BTF_FUNC_STATIC, 0);
+			break;
+		}
+	}
+
 	sanitize = btf_needs_sanitization(obj);
 	if (sanitize) {
 		const void *raw_data;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 6017902c687e..92b7eae10c6d 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -19,6 +19,7 @@
 #pragma GCC poison reallocarray
 
 #include "libbpf.h"
+#include "btf.h"
 
 #ifndef EM_BPF
 #define EM_BPF 247
@@ -132,6 +133,11 @@ struct btf_type;
 
 struct btf_type *btf_type_by_id(struct btf *btf, __u32 type_id);
 
+static inline __u32 btf_type_info(int kind, int vlen, int kflag)
+{
+	return (kflag << 31) | (kind << 24) | vlen;
+}
+
 void *libbpf_add_mem(void **data, size_t *cap_cnt, size_t elem_sz,
 		     size_t cur_cnt, size_t max_cnt, size_t add_cnt);
 int libbpf_ensure_mem(void **data, size_t *cap_cnt, size_t elem_sz, size_t need_cnt);
-- 
2.30.2

