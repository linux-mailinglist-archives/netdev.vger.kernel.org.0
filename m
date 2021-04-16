Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51222362942
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343595AbhDPUZD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 16 Apr 2021 16:25:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48452 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343495AbhDPUY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 16:24:58 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13GKJhxk029190
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 13:24:32 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37ybbnjb4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 13:24:31 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Apr 2021 13:24:30 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 953052ED4EE0; Fri, 16 Apr 2021 13:24:27 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 11/17] libbpf: add linker extern resolution support for functions and global variables
Date:   Fri, 16 Apr 2021 13:23:58 -0700
Message-ID: <20210416202404.3443623-12-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416202404.3443623-1-andrii@kernel.org>
References: <20210416202404.3443623-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 07nT1LW8shz5jKXgbl9-vIVSOmbUOczl
X-Proofpoint-ORIG-GUID: 07nT1LW8shz5jKXgbl9-vIVSOmbUOczl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-16_09:2021-04-16,2021-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 impostorscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BPF static linker logic to resolve extern variables and functions across
multiple linked together BPF object files.

For that, linker maintains a separate list of struct glob_sym structures,
which keeps track of few pieces of metadata (is it extern or resolved global,
is it a weak symbol, which ELF section it belongs to, etc) and ties together
BTF type info and ELF symbol information and keeps them in sync.

With adding support for extern variables/funcs, it's now possible for some
sections to contain both extern and non-extern definitions. This means that
some sections may start out as ephemeral (if only externs are present and thus
there is not corresponding ELF section), but will be "upgraded" to actual ELF
section as symbols are resolved or new non-extern definitions are appended.

Additional care is taken to not duplicate extern entries in sections like
.kconfig and .ksyms.

Given libbpf requires BTF type to always be present for .kconfig/.ksym
externs, linker extends this requirement to all the externs, even those that
are supposed to be resolved during static linking and which won't be visible
to libbpf. With BTF information always present, static linker will check not
just ELF symbol matches, but entire BTF type signature match as well. That
logic is stricter that BPF CO-RE checks. It probably should be re-used by
.ksym resolution logic in libbpf as well, but that's left for follow up
patches.

To make it unnecessary to rewrite ELF symbols and minimize BTF type
rewriting/removal, ELF symbols that correspond to externs initially will be
updated in place once they are resolved. Similarly for BTF type info, VAR/FUNC
and var_secinfo's (sec_vars in struct bpf_linker) are staying stable, but
types they point to might get replaced when extern is resolved. This might
leave some left-over types (even though we try to minimize this for common
cases of having extern funcs with not argument names vs concrete function with
names properly specified). That can be addresses later with a generic BTF
garbage collection. That's left for a follow up as well.

Given BTF type appending phase is separate from ELF symbol
appending/resolution, special struct glob_sym->underlying_btf_id variable is
used to communicate resolution and rewrite decisions. 0 means
underlying_btf_id needs to be appended (it's not yet in final linker->btf), <0
values are used for temporary storage of source BTF type ID (not yet
rewritten), so -glob_sym->underlying_btf_id is BTF type id in obj-btf. But by
the end of linker_append_btf() phase, that underlying_btf_id will be remapped
and will always be > 0. This is the uglies part of the whole process, but
keeps the other parts much simpler due to stability of sec_var and VAR/FUNC
types, as well as ELF symbol, so please keep that in mind while reviewing.

BTF-defined maps require some extra custom logic and is addressed separate in
the next patch, so that to keep this one smaller and easier to review.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/linker.c | 844 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 785 insertions(+), 59 deletions(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index d5dc1d401f57..67d2d06e3cb6 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -22,6 +22,8 @@
 #include "libbpf_internal.h"
 #include "strset.h"
 
+#define BTF_EXTERN_SEC ".extern"
+
 struct src_sec {
 	const char *sec_name;
 	/* positional (not necessarily ELF) index in an array of sections */
@@ -74,11 +76,36 @@ struct btf_ext_sec_data {
 	void *recs;
 };
 
+struct glob_sym {
+	/* ELF symbol index */
+	int sym_idx;
+	/* associated section id for .ksyms, .kconfig, etc, but not .extern */
+	int sec_id;
+	/* extern name offset in STRTAB */
+	int name_off;
+	/* optional associated BTF type ID */
+	int btf_id;
+	/* BTF type ID to which VAR/FUNC type is pointing to; used for
+	 * rewriting types when extern VAR/FUNC is resolved to a concrete
+	 * definition
+	 */
+	int underlying_btf_id;
+	/* sec_var index in the corresponding dst_sec, if exists */
+	int var_idx;
+
+	/* extern or resolved/global symbol */
+	bool is_extern;
+	/* weak or strong symbol, never goes back from strong to weak */
+	bool is_weak;
+};
+
 struct dst_sec {
 	char *sec_name;
 	/* positional (not necessarily ELF) index in an array of sections */
 	int id;
 
+	bool ephemeral;
+
 	/* ELF info */
 	size_t sec_idx;
 	Elf_Scn *scn;
@@ -120,6 +147,10 @@ struct bpf_linker {
 
 	struct btf *btf;
 	struct btf_ext *btf_ext;
+
+	/* global (including extern) ELF symbols */
+	int glob_sym_cnt;
+	struct glob_sym *glob_syms;
 };
 
 #define pr_warn_elf(fmt, ...)									\
@@ -136,6 +167,8 @@ static int linker_sanity_check_btf_ext(struct src_obj *obj);
 static int linker_fixup_btf(struct src_obj *obj);
 static int linker_append_sec_data(struct bpf_linker *linker, struct src_obj *obj);
 static int linker_append_elf_syms(struct bpf_linker *linker, struct src_obj *obj);
+static int linker_append_elf_sym(struct bpf_linker *linker, struct src_obj *obj,
+				 Elf64_Sym *sym, const char *sym_name, int src_sym_idx);
 static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *obj);
 static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj);
 static int linker_append_btf_ext(struct bpf_linker *linker, struct src_obj *obj);
@@ -941,6 +974,7 @@ static int init_sec(struct bpf_linker *linker, struct dst_sec *dst_sec, struct s
 
 	dst_sec->sec_sz = 0;
 	dst_sec->sec_idx = 0;
+	dst_sec->ephemeral = src_sec->ephemeral;
 
 	/* ephemeral sections are just thin section shells lacking most parts */
 	if (src_sec->ephemeral)
@@ -1004,6 +1038,9 @@ static struct dst_sec *find_dst_sec_by_name(struct bpf_linker *linker, const cha
 
 static bool secs_match(struct dst_sec *dst, struct src_sec *src)
 {
+	if (dst->ephemeral || src->ephemeral)
+		return true;
+
 	if (dst->shdr->sh_type != src->shdr->sh_type) {
 		pr_warn("sec %s types mismatch\n", dst->sec_name);
 		return false;
@@ -1029,13 +1066,33 @@ static bool sec_content_is_same(struct dst_sec *dst_sec, struct src_sec *src_sec
 	return true;
 }
 
-static int extend_sec(struct dst_sec *dst, struct src_sec *src)
+static int extend_sec(struct bpf_linker *linker, struct dst_sec *dst, struct src_sec *src)
 {
 	void *tmp;
-	size_t dst_align = dst->shdr->sh_addralign;
-	size_t src_align = src->shdr->sh_addralign;
+	size_t dst_align, src_align;
 	size_t dst_align_sz, dst_final_sz;
+	int err;
+
+	/* Ephemeral source section doesn't contribute anything to ELF
+	 * section data.
+	 */
+	if (src->ephemeral)
+		return 0;
+
+	/* Some sections (like .maps) can contain both externs (and thus be
+	 * ephemeral) and non-externs (map definitions). So it's possible that
+	 * it has to be "upgraded" from ephemeral to non-ephemeral when the
+	 * first non-ephemeral entity appears. In such case, we add ELF
+	 * section, data, etc.
+	 */
+	if (dst->ephemeral) {
+		err = init_sec(linker, dst, src);
+		if (err)
+			return err;
+	}
 
+	dst_align = dst->shdr->sh_addralign;
+	src_align = src->shdr->sh_addralign;
 	if (dst_align == 0)
 		dst_align = 1;
 	if (dst_align < src_align)
@@ -1131,10 +1188,7 @@ static int linker_append_sec_data(struct bpf_linker *linker, struct src_obj *obj
 		/* record mapped section index */
 		src_sec->dst_id = dst_sec->id;
 
-		if (src_sec->ephemeral)
-			continue;
-
-		err = extend_sec(dst_sec, src_sec);
+		err = extend_sec(linker, dst_sec, src_sec);
 		if (err)
 			return err;
 	}
@@ -1145,21 +1199,16 @@ static int linker_append_sec_data(struct bpf_linker *linker, struct src_obj *obj
 static int linker_append_elf_syms(struct bpf_linker *linker, struct src_obj *obj)
 {
 	struct src_sec *symtab = &obj->secs[obj->symtab_sec_idx];
-	Elf64_Sym *sym = symtab->data->d_buf, *dst_sym;
-	int i, n = symtab->shdr->sh_size / symtab->shdr->sh_entsize;
+	Elf64_Sym *sym = symtab->data->d_buf;
+	int i, n = symtab->shdr->sh_size / symtab->shdr->sh_entsize, err;
 	int str_sec_idx = symtab->shdr->sh_link;
+	const char *sym_name;
 
 	obj->sym_map = calloc(n + 1, sizeof(*obj->sym_map));
 	if (!obj->sym_map)
 		return -ENOMEM;
 
 	for (i = 0; i < n; i++, sym++) {
-		struct src_sec *src_sec = NULL;
-		struct dst_sec *dst_sec = NULL;
-		const char *sym_name;
-		size_t dst_sym_idx;
-		int name_off;
-
 		/* We already validated all-zero symbol #0 and we already
 		 * appended it preventively to the final SYMTAB, so skip it.
 		 */
@@ -1172,41 +1221,623 @@ static int linker_append_elf_syms(struct bpf_linker *linker, struct src_obj *obj
 			return -EINVAL;
 		}
 
-		if (sym->st_shndx && sym->st_shndx < SHN_LORESERVE) {
-			src_sec = &obj->secs[sym->st_shndx];
-			if (src_sec->skipped)
+		err = linker_append_elf_sym(linker, obj, sym, sym_name, i);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static Elf64_Sym *get_sym_by_idx(struct bpf_linker *linker, size_t sym_idx)
+{
+	struct dst_sec *symtab = &linker->secs[linker->symtab_sec_idx];
+	Elf64_Sym *syms = symtab->raw_data;
+
+	return &syms[sym_idx];
+}
+
+static struct glob_sym *find_glob_sym(struct bpf_linker *linker, const char *sym_name)
+{
+	struct glob_sym *glob_sym;
+	const char *name;
+	int i;
+
+	for (i = 0; i < linker->glob_sym_cnt; i++) {
+		glob_sym = &linker->glob_syms[i];
+		name = strset__data(linker->strtab_strs) + glob_sym->name_off;
+
+		if (strcmp(name, sym_name) == 0)
+			return glob_sym;
+	}
+
+	return NULL;
+}
+
+static struct glob_sym *add_glob_sym(struct bpf_linker *linker)
+{
+	struct glob_sym *syms, *sym;
+
+	syms = libbpf_reallocarray(linker->glob_syms, linker->glob_sym_cnt + 1,
+				   sizeof(*linker->glob_syms));
+	if (!syms)
+		return NULL;
+
+	sym = &syms[linker->glob_sym_cnt];
+	memset(sym, 0, sizeof(*sym));
+	sym->var_idx = -1;
+
+	linker->glob_syms = syms;
+	linker->glob_sym_cnt++;
+
+	return sym;
+}
+
+static bool glob_sym_btf_matches(const char *sym_name, bool exact,
+				 const struct btf *btf1, __u32 id1,
+				 const struct btf *btf2, __u32 id2)
+{
+	const struct btf_type *t1, *t2;
+	bool is_static1, is_static2;
+	const char *n1, *n2;
+	int i, n;
+
+recur:
+	n1 = n2 = NULL;
+	t1 = skip_mods_and_typedefs(btf1, id1, &id1);
+	t2 = skip_mods_and_typedefs(btf2, id2, &id2);
+
+	/* check if only one side is FWD, otherwise handle with common logic */
+	if (!exact && btf_is_fwd(t1) != btf_is_fwd(t2)) {
+		n1 = btf__str_by_offset(btf1, t1->name_off);
+		n2 = btf__str_by_offset(btf2, t2->name_off);
+		if (strcmp(n1, n2) != 0) {
+			pr_warn("global '%s': incompatible forward declaration names '%s' and '%s'\n",
+				sym_name, n1, n2);
+			return false;
+		}
+		/* validate if FWD kind matches concrete kind */
+		if (btf_is_fwd(t1)) {
+			if (btf_kflag(t1) && btf_is_union(t2))
+				return true;
+			if (!btf_kflag(t1) && btf_is_struct(t2))
+				return true;
+			pr_warn("global '%s': incompatible %s forward declaration and concrete kind %s\n",
+				sym_name, btf_kflag(t1) ? "union" : "struct", btf_kind_str(t2));
+		} else {
+			if (btf_kflag(t2) && btf_is_union(t1))
+				return true;
+			if (!btf_kflag(t2) && btf_is_struct(t1))
+				return true;
+			pr_warn("global '%s': incompatible %s forward declaration and concrete kind %s\n",
+				sym_name, btf_kflag(t2) ? "union" : "struct", btf_kind_str(t1));
+		}
+		return false;
+	}
+
+	if (btf_kind(t1) != btf_kind(t2)) {
+		pr_warn("global '%s': incompatible BTF kinds %s and %s\n",
+			sym_name, btf_kind_str(t1), btf_kind_str(t2));
+		return false;
+	}
+
+	switch (btf_kind(t1)) {
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+	case BTF_KIND_ENUM:
+	case BTF_KIND_FWD:
+	case BTF_KIND_FUNC:
+	case BTF_KIND_VAR:
+		n1 = btf__str_by_offset(btf1, t1->name_off);
+		n2 = btf__str_by_offset(btf2, t2->name_off);
+		if (strcmp(n1, n2) != 0) {
+			pr_warn("global '%s': incompatible %s names '%s' and '%s'\n",
+				sym_name, btf_kind_str(t1), n1, n2);
+			return false;
+		}
+		break;
+	default:
+		break;
+	}
+
+	switch (btf_kind(t1)) {
+	case BTF_KIND_UNKN: /* void */
+	case BTF_KIND_FWD:
+		return true;
+	case BTF_KIND_INT:
+	case BTF_KIND_FLOAT:
+	case BTF_KIND_ENUM:
+		/* ignore encoding for int and enum values for enum */
+		if (t1->size != t2->size) {
+			pr_warn("global '%s': incompatible %s '%s' size %u and %u\n",
+				sym_name, btf_kind_str(t1), n1, t1->size, t2->size);
+			return false;
+		}
+		return true;
+	case BTF_KIND_PTR:
+		/* just validate overall shape of the referenced type, so no
+		 * contents comparison for struct/union, and allowd fwd vs
+		 * struct/union
+		 */
+		exact = false;
+		id1 = t1->type;
+		id2 = t2->type;
+		goto recur;
+	case BTF_KIND_ARRAY:
+		/* ignore index type and array size */
+		id1 = btf_array(t1)->type;
+		id2 = btf_array(t2)->type;
+		goto recur;
+	case BTF_KIND_FUNC:
+		/* extern and global linkages are compatible */
+		is_static1 = btf_func_linkage(t1) == BTF_FUNC_STATIC;
+		is_static2 = btf_func_linkage(t2) == BTF_FUNC_STATIC;
+		if (is_static1 != is_static2) {
+			pr_warn("global '%s': incompatible func '%s' linkage\n", sym_name, n1);
+			return false;
+		}
+
+		id1 = t1->type;
+		id2 = t2->type;
+		goto recur;
+	case BTF_KIND_VAR:
+		/* extern and global linkages are compatible */
+		is_static1 = btf_var(t1)->linkage == BTF_VAR_STATIC;
+		is_static2 = btf_var(t2)->linkage == BTF_VAR_STATIC;
+		if (is_static1 != is_static2) {
+			pr_warn("global '%s': incompatible var '%s' linkage\n", sym_name, n1);
+			return false;
+		}
+
+		id1 = t1->type;
+		id2 = t2->type;
+		goto recur;
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION: {
+		const struct btf_member *m1, *m2;
+
+		if (!exact)
+			return true;
+
+		if (btf_vlen(t1) != btf_vlen(t2)) {
+			pr_warn("global '%s': incompatible number of %s fields %u and %u\n",
+				sym_name, btf_kind_str(t1), btf_vlen(t1), btf_vlen(t2));
+			return false;
+		}
+
+		n = btf_vlen(t1);
+		m1 = btf_members(t1);
+		m2 = btf_members(t2);
+		for (i = 0; i < n; i++, m1++, m2++) {
+			n1 = btf__str_by_offset(btf1, m1->name_off);
+			n2 = btf__str_by_offset(btf2, m2->name_off);
+			if (strcmp(n1, n2) != 0) {
+				pr_warn("global '%s': incompatible field #%d names '%s' and '%s'\n",
+					sym_name, i, n1, n2);
+				return false;
+			}
+			if (m1->offset != m2->offset) {
+				pr_warn("global '%s': incompatible field #%d ('%s') offsets\n",
+					sym_name, i, n1);
+				return false;
+			}
+			if (!glob_sym_btf_matches(sym_name, exact, btf1, m1->type, btf2, m2->type))
+				return false;
+		}
+
+		return true;
+	}
+	case BTF_KIND_FUNC_PROTO: {
+		const struct btf_param *m1, *m2;
+
+		if (btf_vlen(t1) != btf_vlen(t2)) {
+			pr_warn("global '%s': incompatible number of %s params %u and %u\n",
+				sym_name, btf_kind_str(t1), btf_vlen(t1), btf_vlen(t2));
+			return false;
+		}
+
+		n = btf_vlen(t1);
+		m1 = btf_params(t1);
+		m2 = btf_params(t2);
+		for (i = 0; i < n; i++, m1++, m2++) {
+			/* ignore func arg names */
+			if (!glob_sym_btf_matches(sym_name, exact, btf1, m1->type, btf2, m2->type))
+				return false;
+		}
+
+		/* now check return type as well */
+		id1 = t1->type;
+		id2 = t2->type;
+		goto recur;
+	}
+
+	case BTF_KIND_TYPEDEF:
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_CONST:
+	case BTF_KIND_RESTRICT:
+	case BTF_KIND_DATASEC:
+	default:
+		pr_warn("global '%s': unsupported BTF kind %s\n",
+			sym_name, btf_kind_str(t1));
+		return false;
+	}
+}
+
+static bool glob_syms_match(const char *sym_name,
+			    struct bpf_linker *linker, struct glob_sym *glob_sym,
+			    struct src_obj *obj, Elf64_Sym *sym, size_t sym_idx, int btf_id)
+{
+	const struct btf_type *src_t;
+
+	/* if we are dealing with externs, BTF types describing both global
+	 * and extern VARs/FUNCs should be completely present in all files
+	 */
+	if (!glob_sym->btf_id || !btf_id) {
+		pr_warn("BTF info is missing for global symbol '%s'\n", sym_name);
+		return false;
+	}
+
+	src_t = btf__type_by_id(obj->btf, btf_id);
+	if (!btf_is_var(src_t) && !btf_is_func(src_t)) {
+		pr_warn("only extern variables and functions are supported, but got '%s' for '%s'\n",
+			btf_kind_str(src_t), sym_name);
+		return false;
+	}
+
+	if (!glob_sym_btf_matches(sym_name, true /*exact*/,
+				  linker->btf, glob_sym->btf_id, obj->btf, btf_id))
+		return false;
+
+	return true;
+}
+
+static bool btf_is_non_static(const struct btf_type *t)
+{
+	return (btf_is_var(t) && btf_var(t)->linkage != BTF_VAR_STATIC)
+	       || (btf_is_func(t) && btf_func_linkage(t) != BTF_FUNC_STATIC);
+}
+
+static int find_glob_sym_btf(struct src_obj *obj, Elf64_Sym *sym, const char *sym_name,
+			     int *out_btf_sec_id, int *out_btf_id)
+{
+	int i, j, n = btf__get_nr_types(obj->btf), m, btf_id = 0;
+	const struct btf_type *t;
+	const struct btf_var_secinfo *vi;
+	const char *name;
+
+	for (i = 1; i <= n; i++) {
+		t = btf__type_by_id(obj->btf, i);
+
+		/* some global and extern FUNCs and VARs might not be associated with any
+		 * DATASEC, so try to detect them in the same pass
+		 */
+		if (btf_is_non_static(t)) {
+			name = btf__str_by_offset(obj->btf, t->name_off);
+			if (strcmp(name, sym_name) != 0)
 				continue;
-			dst_sec = &linker->secs[src_sec->dst_id];
 
-			/* allow only one STT_SECTION symbol per section */
-			if (ELF64_ST_TYPE(sym->st_info) == STT_SECTION && dst_sec->sec_sym_idx) {
-				obj->sym_map[i] = dst_sec->sec_sym_idx;
+			/* remember and still try to find DATASEC */
+			btf_id = i;
+			continue;
+		}
+
+		if (!btf_is_datasec(t))
+			continue;
+
+		vi = btf_var_secinfos(t);
+		for (j = 0, m = btf_vlen(t); j < m; j++, vi++) {
+			t = btf__type_by_id(obj->btf, vi->type);
+			name = btf__str_by_offset(obj->btf, t->name_off);
+
+			if (strcmp(name, sym_name) != 0)
+				continue;
+			if (btf_is_var(t) && btf_var(t)->linkage == BTF_VAR_STATIC)
 				continue;
+			if (btf_is_func(t) && btf_func_linkage(t) == BTF_FUNC_STATIC)
+				continue;
+
+			if (btf_id && btf_id != vi->type) {
+				pr_warn("global/extern '%s' BTF is ambiguous: both types #%d and #%u match\n",
+					sym_name, btf_id, vi->type);
+				return -EINVAL;
 			}
+
+			*out_btf_sec_id = i;
+			*out_btf_id = vi->type;
+
+			return 0;
 		}
+	}
 
-		name_off = strset__add_str(linker->strtab_strs, sym_name);
-		if (name_off < 0)
-			return name_off;
+	/* free-floating extern or global FUNC */
+	if (btf_id) {
+		*out_btf_sec_id = 0;
+		*out_btf_id = btf_id;
+		return 0;
+	}
 
-		dst_sym = add_new_sym(linker, &dst_sym_idx);
-		if (!dst_sym)
-			return -ENOMEM;
+	pr_warn("failed to find BTF info for global/extern symbol '%s'\n", sym_name);
+	return -ENOENT;
+}
 
-		dst_sym->st_name = name_off;
-		dst_sym->st_info = sym->st_info;
-		dst_sym->st_other = sym->st_other;
-		dst_sym->st_shndx = src_sec ? dst_sec->sec_idx : sym->st_shndx;
-		dst_sym->st_value = (src_sec ? src_sec->dst_off : 0) + sym->st_value;
-		dst_sym->st_size = sym->st_size;
+static struct src_sec *find_src_sec_by_name(struct src_obj *obj, const char *sec_name)
+{
+	struct src_sec *sec;
+	int i;
 
-		obj->sym_map[i] = dst_sym_idx;
+	for (i = 1; i < obj->sec_cnt; i++) {
+		sec = &obj->secs[i];
 
-		if (ELF64_ST_TYPE(sym->st_info) == STT_SECTION && dst_sym) {
-			dst_sec->sec_sym_idx = dst_sym_idx;
-			dst_sym->st_value = 0;
+		if (strcmp(sec->sec_name, sec_name) == 0)
+			return sec;
+	}
+
+	return NULL;
+}
+
+static int complete_extern_btf_info(struct btf *dst_btf, int dst_id,
+				    struct btf *src_btf, int src_id)
+{
+	struct btf_type *dst_t = btf_type_by_id(dst_btf, dst_id);
+	struct btf_type *src_t = btf_type_by_id(src_btf, src_id);
+	struct btf_param *src_p, *dst_p;
+	const char *s;
+	int i, n, off;
+
+	/* We already made sure that source and destination types (FUNC or
+	 * VAR) match in terms of types and argument names.
+	 */
+	if (btf_is_var(dst_t)) {
+		btf_var(dst_t)->linkage = BTF_VAR_GLOBAL_ALLOCATED;
+		return 0;
+	}
+
+	dst_t->info = btf_type_info(BTF_KIND_FUNC, BTF_FUNC_GLOBAL, 0);
+
+	/* now onto FUNC_PROTO types */
+	src_t = btf_type_by_id(src_btf, src_t->type);
+	dst_t = btf_type_by_id(dst_btf, dst_t->type);
+
+	/* Fill in all the argument names, which for extern FUNCs are missing.
+	 * We'll end up with two copies of FUNCs/VARs for externs, but that
+	 * will be taken care of by BTF dedup at the very end.
+	 * It might be that BTF types for extern in one file has less/more BTF
+	 * information (e.g., FWD instead of full STRUCT/UNION information),
+	 * but that should be (in most cases, subject to BTF dedup rules)
+	 * handled and resolved by BTF dedup algorithm as well, so we won't
+	 * worry about it. Our only job is to make sure that argument names
+	 * are populated on both sides, otherwise BTF dedup will pedantically
+	 * consider them different.
+	 */
+	src_p = btf_params(src_t);
+	dst_p = btf_params(dst_t);
+	for (i = 0, n = btf_vlen(dst_t); i < n; i++, src_p++, dst_p++) {
+		if (!src_p->name_off)
+			continue;
+
+		/* src_btf has more complete info, so add name to dst_btf */
+		s = btf__str_by_offset(src_btf, src_p->name_off);
+		off = btf__add_str(dst_btf, s);
+		if (off < 0)
+			return off;
+		dst_p->name_off = off;
+	}
+	return 0;
+}
+
+static void sym_update_bind(Elf64_Sym *sym, int sym_bind)
+{
+	sym->st_info = ELF64_ST_INFO(sym_bind, ELF64_ST_TYPE(sym->st_info));
+}
+
+static void sym_update_type(Elf64_Sym *sym, int sym_type)
+{
+	sym->st_info = ELF64_ST_INFO(ELF64_ST_BIND(sym->st_info), sym_type);
+}
+
+static void sym_update_visibility(Elf64_Sym *sym, int sym_vis)
+{
+	/* libelf doesn't provide setters for ST_VISIBILITY,
+	 * but it is stored in the lower 2 bits of st_other
+	 */
+	sym->st_other &= 0x03;
+	sym->st_other |= sym_vis;
+}
+
+static int linker_append_elf_sym(struct bpf_linker *linker, struct src_obj *obj,
+				 Elf64_Sym *sym, const char *sym_name, int src_sym_idx)
+{
+	struct src_sec *src_sec = NULL;
+	struct dst_sec *dst_sec = NULL;
+	struct glob_sym *glob_sym = NULL;
+	int name_off, sym_type, sym_bind, sym_vis, err;
+	int btf_sec_id = 0, btf_id = 0;
+	size_t dst_sym_idx;
+	Elf64_Sym *dst_sym;
+	bool sym_is_extern;
+
+	sym_type = ELF64_ST_TYPE(sym->st_info);
+	sym_bind = ELF64_ST_BIND(sym->st_info);
+	sym_vis = ELF64_ST_VISIBILITY(sym->st_other);
+	sym_is_extern = sym->st_shndx == SHN_UNDEF;
+
+	if (sym_is_extern) {
+		if (!obj->btf) {
+			pr_warn("externs without BTF info are not supported\n");
+			return -ENOTSUP;
+		}
+	} else if (sym->st_shndx < SHN_LORESERVE) {
+		src_sec = &obj->secs[sym->st_shndx];
+		if (src_sec->skipped)
+			return 0;
+		dst_sec = &linker->secs[src_sec->dst_id];
+
+		/* allow only one STT_SECTION symbol per section */
+		if (sym_type == STT_SECTION && dst_sec->sec_sym_idx) {
+			obj->sym_map[src_sym_idx] = dst_sec->sec_sym_idx;
+			return 0;
+		}
+	}
+
+	if (sym_bind == STB_LOCAL)
+		goto add_sym;
+
+	/* find matching BTF info */
+	err = find_glob_sym_btf(obj, sym, sym_name, &btf_sec_id, &btf_id);
+	if (err)
+		return err;
+
+	if (sym_is_extern && btf_sec_id) {
+		const char *sec_name = NULL;
+		const struct btf_type *t;
+
+		t = btf__type_by_id(obj->btf, btf_sec_id);
+		sec_name = btf__str_by_offset(obj->btf, t->name_off);
+
+		/* Clang puts unannotated extern vars into
+		 * '.extern' BTF DATASEC. Treat them the same
+		 * as unannotated extern funcs (which are
+		 * currently not put into any DATASECs).
+		 * Those don't have associated src_sec/dst_sec.
+		 */
+		if (strcmp(sec_name, BTF_EXTERN_SEC) != 0) {
+			src_sec = find_src_sec_by_name(obj, sec_name);
+			if (!src_sec) {
+				pr_warn("failed to find matching ELF sec '%s'\n", sec_name);
+				return -ENOENT;
+			}
+			dst_sec = &linker->secs[src_sec->dst_id];
+		}
+	}
+
+	glob_sym = find_glob_sym(linker, sym_name);
+	if (glob_sym) {
+		/* Preventively resolve to existing symbol. This is
+		 * needed for further relocation symbol remapping in
+		 * the next step of linking.
+		 */
+		obj->sym_map[src_sym_idx] = glob_sym->sym_idx;
+
+		/* If both symbols are non-externs, at least one of
+		 * them has to be STB_WEAK, otherwise they are in
+		 * a conflict with each other.
+		 */
+		if (!sym_is_extern && !glob_sym->is_extern
+		    && !glob_sym->is_weak && sym_bind != STB_WEAK) {
+			pr_warn("conflicting non-weak symbol #%d (%s) definition in '%s'\n",
+				src_sym_idx, sym_name, obj->filename);
+			return -EINVAL;
 		}
 
+		if (!glob_syms_match(sym_name, linker, glob_sym, obj, sym, src_sym_idx, btf_id))
+			return -EINVAL;
+
+		dst_sym = get_sym_by_idx(linker, glob_sym->sym_idx);
+
+		/* If new symbol is strong, then force dst_sym to be strong as
+		 * well; this way a mix of weak and non-weak extern
+		 * definitions will end up being strong.
+		 */
+		if (sym_bind == STB_GLOBAL) {
+			/* We still need to preserve type (NOTYPE or
+			 * OBJECT/FUNC, depending on whether the symbol is
+			 * extern or not)
+			 */
+			sym_update_bind(dst_sym, STB_GLOBAL);
+			glob_sym->is_weak = false;
+		}
+
+		/* Non-default visibility is "contaminating", with stricter
+		 * visibility overwriting more permissive ones, even if more
+		 * permissive visibility comes from just an extern definition
+		 */
+		if (sym_vis > ELF64_ST_VISIBILITY(dst_sym->st_other))
+			sym_update_visibility(dst_sym, sym_vis);
+
+		/* If the new symbol is extern, then regardless if
+		 * existing symbol is extern or resolved global, just
+		 * keep the existing one untouched.
+		 */
+		if (sym_is_extern)
+			return 0;
+
+		/* If existing symbol is a strong resolved symbol, bail out,
+		 * because we lost resolution battle have nothing to
+		 * contribute. We already checked abover that there is no
+		 * strong-strong conflict. We also already tightened binding
+		 * and visibility, so nothing else to contribute at that point.
+		 */
+		if (!glob_sym->is_extern && sym_bind == STB_WEAK)
+			return 0;
+
+		/* At this point, new symbol is strong non-extern,
+		 * so overwrite glob_sym with new symbol information.
+		 * Preserve binding and visibility.
+		 */
+		sym_update_type(dst_sym, sym_type);
+		dst_sym->st_shndx = dst_sec->sec_idx;
+		dst_sym->st_value = src_sec->dst_off + sym->st_value;
+		dst_sym->st_size = sym->st_size;
+
+		/* see comment below about dst_sec->id vs dst_sec->sec_idx */
+		glob_sym->sec_id = dst_sec->id;
+		glob_sym->is_extern = false;
+		/* never relax strong to weak binding */
+		if (sym_bind == STB_GLOBAL)
+			glob_sym->is_weak = false;
+
+		if (complete_extern_btf_info(linker->btf, glob_sym->btf_id,
+					     obj->btf, btf_id))
+			return -EINVAL;
+
+		/* request updating VAR's/FUNC's underlying BTF type when appending BTF type */
+		glob_sym->underlying_btf_id = 0;
+
+		obj->sym_map[src_sym_idx] = glob_sym->sym_idx;
+		return 0;
+	}
+
+add_sym:
+	name_off = strset__add_str(linker->strtab_strs, sym_name);
+	if (name_off < 0)
+		return name_off;
+
+	dst_sym = add_new_sym(linker, &dst_sym_idx);
+	if (!dst_sym)
+		return -ENOMEM;
+
+	dst_sym->st_name = name_off;
+	dst_sym->st_info = sym->st_info;
+	dst_sym->st_other = sym->st_other;
+	dst_sym->st_shndx = dst_sec ? dst_sec->sec_idx : sym->st_shndx;
+	dst_sym->st_value = (src_sec ? src_sec->dst_off : 0) + sym->st_value;
+	dst_sym->st_size = sym->st_size;
+
+	obj->sym_map[src_sym_idx] = dst_sym_idx;
+
+	if (sym_type == STT_SECTION && dst_sym) {
+		dst_sec->sec_sym_idx = dst_sym_idx;
+		dst_sym->st_value = 0;
+	}
+
+	if (sym_bind != STB_LOCAL) {
+		glob_sym = add_glob_sym(linker);
+		if (!glob_sym)
+			return -ENOMEM;
+
+		glob_sym->sym_idx = dst_sym_idx;
+		/* we use dst_sec->id (and not dst_sec->sec_idx), because
+		 * ephemeral sections (.kconfig, .ksyms, etc) don't have
+		 * sec_idx (as they don't have corresponding ELF section), but
+		 * still have id. .extern doesn't have even ephemeral section
+		 * associated with it, so dst_sec->id == dst_sec->sec_idx == 0.
+		 */
+		glob_sym->sec_id = dst_sec ? dst_sec->id : 0;
+		glob_sym->name_off = name_off;
+		/* we will fill btf_id in during BTF merging step */
+		glob_sym->btf_id = 0;
+		glob_sym->is_extern = sym_is_extern;
+		glob_sym->is_weak = sym_bind == STB_WEAK;
 	}
 
 	return 0;
@@ -1256,7 +1887,7 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
 		dst_sec->shdr->sh_info = dst_linked_sec->sec_idx;
 
 		src_sec->dst_id = dst_sec->id;
-		err = extend_sec(dst_sec, src_sec);
+		err = extend_sec(linker, dst_sec, src_sec);
 		if (err)
 			return err;
 
@@ -1309,21 +1940,6 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
 	return 0;
 }
 
-static struct src_sec *find_src_sec_by_name(struct src_obj *obj, const char *sec_name)
-{
-	struct src_sec *sec;
-	int i;
-
-	for (i = 1; i < obj->sec_cnt; i++) {
-		sec = &obj->secs[i];
-
-		if (strcmp(sec->sec_name, sec_name) == 0)
-			return sec;
-	}
-
-	return NULL;
-}
-
 static Elf64_Sym *find_sym_by_name(struct src_obj *obj, size_t sec_idx,
 				   int sym_type, const char *sym_name)
 {
@@ -1378,12 +1994,32 @@ static int linker_fixup_btf(struct src_obj *obj)
 				t->size = sec->shdr->sh_size;
 		} else {
 			/* BTF can have some sections that are not represented
-			 * in ELF, e.g., .kconfig and .ksyms, which are used
-			 * for special extern variables.  Here we'll
-			 * pre-create "section shells" for them to be able to
-			 * keep track of extra per-section metadata later
-			 * (e.g., BTF variables).
+			 * in ELF, e.g., .kconfig, .ksyms, .extern, which are used
+			 * for special extern variables.
+			 *
+			 * For all but one such special (ephemeral)
+			 * sections, we pre-create "section shells" to be able
+			 * to keep track of extra per-section metadata later
+			 * (e.g., those BTF extern variables).
+			 *
+			 * .extern is even more special, though, because it
+			 * contains extern variables that need to be resolved
+			 * by static linker, not libbpf and kernel. When such
+			 * externs are resolved, we are going to remove them
+			 * from .extern BTF section and might end up not
+			 * needing it at all. Each resolved extern should have
+			 * matching non-extern VAR/FUNC in other sections.
+			 *
+			 * We do support leaving some of the externs
+			 * unresolved, though, to support cases of building
+			 * libraries, which will later be linked against final
+			 * BPF applications. So if at finalization we still
+			 * see unresolved externs, we'll create .extern
+			 * section on our own.
 			 */
+			if (strcmp(sec_name, BTF_EXTERN_SEC) == 0)
+				continue;
+
 			sec = add_src_sec(obj, sec_name);
 			if (!sec)
 				return -ENOMEM;
@@ -1442,6 +2078,7 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
 {
 	const struct btf_type *t;
 	int i, j, n, start_id, id;
+	const char *name;
 
 	if (!obj->btf)
 		return 0;
@@ -1454,12 +2091,40 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
 		return -ENOMEM;
 
 	for (i = 1; i <= n; i++) {
+		struct glob_sym *glob_sym = NULL;
+
 		t = btf__type_by_id(obj->btf, i);
 
 		/* DATASECs are handled specially below */
 		if (btf_kind(t) == BTF_KIND_DATASEC)
 			continue;
 
+		if (btf_is_non_static(t)) {
+			/* there should be glob_sym already */
+			name = btf__str_by_offset(obj->btf, t->name_off);
+			glob_sym = find_glob_sym(linker, name);
+
+			/* VARs without corresponding glob_sym are those that
+			 * belong to skipped/deduplicated sections (i.e.,
+			 * license and version), so just skip them
+			 */
+			if (!glob_sym)
+				continue;
+
+			if (glob_sym->underlying_btf_id == 0)
+				glob_sym->underlying_btf_id = -t->type;
+
+			/* globals from previous object files that match our
+			 * VAR/FUNC already have a corresponding associated
+			 * BTF type, so just make sure to use it
+			 */
+			if (glob_sym->btf_id) {
+				/* reuse existing BTF type for global var/func */
+				obj->btf_type_map[i] = glob_sym->btf_id;
+				continue;
+			}
+		}
+
 		id = btf__add_type(linker->btf, obj->btf, t);
 		if (id < 0) {
 			pr_warn("failed to append BTF type #%d from file '%s'\n", i, obj->filename);
@@ -1467,6 +2132,12 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
 		}
 
 		obj->btf_type_map[i] = id;
+
+		/* record just appended BTF type for var/func */
+		if (glob_sym) {
+			glob_sym->btf_id = id;
+			glob_sym->underlying_btf_id = -t->type;
+		}
 	}
 
 	/* remap all the types except DATASECs */
@@ -1478,6 +2149,22 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
 			return -EINVAL;
 	}
 
+	/* Rewrite VAR/FUNC underlying types (i.e., FUNC's FUNC_PROTO and VAR's
+	 * actual type), if necessary
+	 */
+	for (i = 0; i < linker->glob_sym_cnt; i++) {
+		struct glob_sym *glob_sym = &linker->glob_syms[i];
+		struct btf_type *glob_t;
+
+		if (glob_sym->underlying_btf_id >= 0)
+			continue;
+
+		glob_sym->underlying_btf_id = obj->btf_type_map[-glob_sym->underlying_btf_id];
+
+		glob_t = btf_type_by_id(linker->btf, glob_sym->btf_id);
+		glob_t->type = glob_sym->underlying_btf_id;
+	}
+
 	/* append DATASEC info */
 	for (i = 1; i < obj->sec_cnt; i++) {
 		struct src_sec *src_sec;
@@ -1505,6 +2192,42 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
 		n = btf_vlen(t);
 		for (j = 0; j < n; j++, src_var++) {
 			void *sec_vars = dst_sec->sec_vars;
+			int new_id = obj->btf_type_map[src_var->type];
+			struct glob_sym *glob_sym = NULL;
+
+			t = btf_type_by_id(linker->btf, new_id);
+			if (btf_is_non_static(t)) {
+				name = btf__str_by_offset(linker->btf, t->name_off);
+				glob_sym = find_glob_sym(linker, name);
+				if (glob_sym->sec_id != dst_sec->id) {
+					pr_warn("global '%s': section mismatch %d vs %d\n",
+						name, glob_sym->sec_id, dst_sec->id);
+					return -EINVAL;
+				}
+			}
+
+			/* If there is already a member (VAR or FUNC) mapped
+			 * to the same type, don't add a duplicate entry.
+			 * This will happen when multiple object files define
+			 * the same extern VARs/FUNCs.
+			 */
+			if (glob_sym && glob_sym->var_idx >= 0) {
+				__s64 sz;
+
+				dst_var = &dst_sec->sec_vars[glob_sym->var_idx];
+				/* Because underlying BTF type might have
+				 * changed, so might its size have changed, so
+				 * re-calculate and update it in sec_var.
+				 */
+				sz = btf__resolve_size(linker->btf, glob_sym->underlying_btf_id);
+				if (sz < 0) {
+					pr_warn("global '%s': failed to resolve size of underlying type: %d\n",
+						name, (int)sz);
+					return -EINVAL;
+				}
+				dst_var->size = sz;
+				continue;
+			}
 
 			sec_vars = libbpf_reallocarray(sec_vars,
 						       dst_sec->sec_var_cnt + 1,
@@ -1519,6 +2242,9 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
 			dst_var->type = obj->btf_type_map[src_var->type];
 			dst_var->size = src_var->size;
 			dst_var->offset = src_sec->dst_off + src_var->offset;
+
+			if (glob_sym)
+				glob_sym->var_idx = dst_sec->sec_var_cnt - 1;
 		}
 	}
 
-- 
2.30.2

