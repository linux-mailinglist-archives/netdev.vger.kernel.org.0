Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026F233FFAC
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 07:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhCRGcX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Mar 2021 02:32:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52248 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229584AbhCRGbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 02:31:46 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12I6QRcm032153
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 23:31:46 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 37bs1h29fv-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 23:31:45 -0700
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 17 Mar 2021 23:31:34 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id F0B422ED24FA; Wed, 17 Mar 2021 23:31:31 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v3 bpf-next 07/12] libbpf: add BPF static linker BTF and BTF.ext support
Date:   Wed, 17 Mar 2021 23:31:10 -0700
Message-ID: <20210318063115.49613-8-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318063115.49613-1-andrii@kernel.org>
References: <20210318063115.49613-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_02:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180050
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add .BTF and .BTF.ext static linking logic.

When multiple BPF object files are linked together, their respective .BTF and
.BTF.ext sections are merged together. BTF types are not just concatenated,
but also deduplicated. .BTF.ext data is grouped by type (func info, line info,
core_relos) and target section names, and then all the records are
concatenated together, preserving their relative order. All the BTF type ID
references and string offsets are updated as necessary, to take into account
possibly deduplicated strings and types.

BTF DATASEC types are handled specially. Their respective var_secinfos are
accumulated separately in special per-section data and then final DATASEC
types are emitted at the very end during bpf_linker__finalize() operation,
just before emitting final ELF output file.

BTF data can also provide "section annotations" for some extern variables.
Such concept is missing in ELF, but BTF will have DATASEC types for such
special extern datasections (e.g., .kconfig, .ksyms). Such sections are called
"ephemeral" internally. Internally linker will keep metadata for each such
section, collecting variables information, but those sections won't be emitted
into the final ELF file.

Also, given LLVM/Clang during compilation emits BTF DATASECS that are
incomplete, missing section size and variable offsets for static variables,
BPF static linker will initially fix up such DATASECs, using ELF symbols data.
The final DATASECs will preserve section sizes and all variable offsets. This
is handled correctly by libbpf already, so won't cause any new issues. On the
other hand, it's actually a nice property to have a complete BTF data without
runtime adjustments done during bpf_object__open() by libbpf. In that sense,
BPF static linker is also a BTF normalizer.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/linker.c | 769 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 767 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 01b56939a835..b4fff912dce2 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -32,12 +32,17 @@ struct src_sec {
 	int dst_off;
 	/* whether section is omitted from the final ELF file */
 	bool skipped;
+	/* whether section is an ephemeral section, not mapped to an ELF section */
+	bool ephemeral;
 
 	/* ELF info */
 	size_t sec_idx;
 	Elf_Scn *scn;
 	Elf64_Shdr *shdr;
 	Elf_Data *data;
+
+	/* corresponding BTF DATASEC type ID */
+	int sec_type_id;
 };
 
 struct src_obj {
@@ -49,12 +54,24 @@ struct src_obj {
 	/* SYMTAB section index */
 	size_t symtab_sec_idx;
 
-	/* List of sections. Slot zero is unused. */
+	struct btf *btf;
+	struct btf_ext *btf_ext;
+
+	/* List of sections (including ephemeral). Slot zero is unused. */
 	struct src_sec *secs;
 	int sec_cnt;
 
 	/* mapping of symbol indices from src to dst ELF */
 	int *sym_map;
+	/* mapping from the src BTF type IDs to dst ones */
+	int *btf_type_map;
+};
+
+/* single .BTF.ext data section */
+struct btf_ext_sec_data {
+	size_t rec_cnt;
+	__u32 rec_sz;
+	void *recs;
 };
 
 struct dst_sec {
@@ -75,6 +92,15 @@ struct dst_sec {
 
 	/* corresponding STT_SECTION symbol index in SYMTAB */
 	int sec_sym_idx;
+
+	/* section's DATASEC variable info, emitted on BTF finalization */
+	int sec_var_cnt;
+	struct btf_var_secinfo *sec_vars;
+
+	/* section's .BTF.ext data */
+	struct btf_ext_sec_data func_info;
+	struct btf_ext_sec_data line_info;
+	struct btf_ext_sec_data core_relo_info;
 };
 
 struct bpf_linker {
@@ -90,6 +116,9 @@ struct bpf_linker {
 	struct strset *strtab_strs; /* STRTAB unique strings */
 	size_t strtab_sec_idx; /* STRTAB section index */
 	size_t symtab_sec_idx; /* SYMTAB section index */
+
+	struct btf *btf;
+	struct btf_ext *btf_ext;
 };
 
 #define pr_warn_elf(fmt, ...)									\
@@ -101,9 +130,17 @@ static int init_output_elf(struct bpf_linker *linker, const char *file);
 
 static int linker_load_obj_file(struct bpf_linker *linker, const char *filename, struct src_obj *obj);
 static int linker_sanity_check_elf(struct src_obj *obj);
+static int linker_sanity_check_btf(struct src_obj *obj);
+static int linker_sanity_check_btf_ext(struct src_obj *obj);
+static int linker_fixup_btf(struct src_obj *obj);
 static int linker_append_sec_data(struct bpf_linker *linker, struct src_obj *obj);
 static int linker_append_elf_syms(struct bpf_linker *linker, struct src_obj *obj);
 static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *obj);
+static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj);
+static int linker_append_btf_ext(struct bpf_linker *linker, struct src_obj *obj);
+
+static int finalize_btf(struct bpf_linker *linker);
+static int finalize_btf_ext(struct bpf_linker *linker);
 
 void bpf_linker__free(struct bpf_linker *linker)
 {
@@ -122,11 +159,19 @@ void bpf_linker__free(struct bpf_linker *linker)
 
 	strset__free(linker->strtab_strs);
 
+	btf__free(linker->btf);
+	btf_ext__free(linker->btf_ext);
+
 	for (i = 1; i < linker->sec_cnt; i++) {
 		struct dst_sec *sec = &linker->secs[i];
 
 		free(sec->sec_name);
 		free(sec->raw_data);
+		free(sec->sec_vars);
+
+		free(sec->func_info.recs);
+		free(sec->line_info.recs);
+		free(sec->core_relo_info.recs);
 	}
 	free(linker->secs);
 
@@ -335,6 +380,12 @@ static int init_output_elf(struct bpf_linker *linker, const char *file)
 	sec->shdr->sh_addralign = 8;
 	sec->shdr->sh_entsize = sizeof(Elf64_Sym);
 
+	/* .BTF */
+	linker->btf = btf__new_empty();
+	err = libbpf_get_error(linker->btf);
+	if (err)
+		return err;
+
 	/* add the special all-zero symbol */
 	init_sym = add_new_sym(linker, NULL);
 	if (!init_sym)
@@ -362,8 +413,13 @@ int bpf_linker__add_file(struct bpf_linker *linker, const char *filename)
 	err = err ?: linker_append_sec_data(linker, &obj);
 	err = err ?: linker_append_elf_syms(linker, &obj);
 	err = err ?: linker_append_elf_relos(linker, &obj);
+	err = err ?: linker_append_btf(linker, &obj);
+	err = err ?: linker_append_btf_ext(linker, &obj);
 
 	/* free up src_obj resources */
+	free(obj.btf_type_map);
+	btf__free(obj.btf);
+	btf_ext__free(obj.btf_ext);
 	free(obj.secs);
 	free(obj.sym_map);
 	if (obj.elf)
@@ -555,10 +611,22 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
 			break;
 		case SHT_PROGBITS:
 			if (strcmp(sec_name, BTF_ELF_SEC) == 0) {
+				obj->btf = btf__new(data->d_buf, shdr->sh_size);
+				err = libbpf_get_error(obj->btf);
+				if (err) {
+					pr_warn("failed to parse .BTF from %s: %d\n", filename, err);
+					return err;
+				}
 				sec->skipped = true;
 				continue;
 			}
 			if (strcmp(sec_name, BTF_EXT_ELF_SEC) == 0) {
+				obj->btf_ext = btf_ext__new(data->d_buf, shdr->sh_size);
+				err = libbpf_get_error(obj->btf_ext);
+				if (err) {
+					pr_warn("failed to parse .BTF.ext from '%s': %d\n", filename, err);
+					return err;
+				}
 				sec->skipped = true;
 				continue;
 			}
@@ -580,6 +648,9 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
 	}
 
 	err = err ?: linker_sanity_check_elf(obj);
+	err = err ?: linker_sanity_check_btf(obj);
+	err = err ?: linker_sanity_check_btf_ext(obj);
+	err = err ?: linker_fixup_btf(obj);
 
 	return err;
 }
@@ -753,6 +824,69 @@ static int linker_sanity_check_elf(struct src_obj *obj)
 	return 0;
 }
 
+static int check_btf_type_id(__u32 *type_id, void *ctx)
+{
+	struct btf *btf = ctx;
+
+	if (*type_id > btf__get_nr_types(btf))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int check_btf_str_off(__u32 *str_off, void *ctx)
+{
+	struct btf *btf = ctx;
+	const char *s;
+
+	s = btf__str_by_offset(btf, *str_off);
+
+	if (!s)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int linker_sanity_check_btf(struct src_obj *obj)
+{
+	struct btf_type *t;
+	int i, n, err = 0;
+
+	if (!obj->btf)
+		return 0;
+
+	n = btf__get_nr_types(obj->btf);
+	for (i = 1; i <= n; i++) {
+		t = btf_type_by_id(obj->btf, i);
+
+		err = err ?: btf_type_visit_type_ids(t, check_btf_type_id, obj->btf);
+		err = err ?: btf_type_visit_str_offs(t, check_btf_str_off, obj->btf);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int linker_sanity_check_btf_ext(struct src_obj *obj)
+{
+	int err = 0;
+
+	if (!obj->btf_ext)
+		return 0;
+
+	/* can't use .BTF.ext without .BTF */
+	if (!obj->btf)
+		return -EINVAL;
+
+	err = err ?: btf_ext_visit_type_ids(obj->btf_ext, check_btf_type_id, obj->btf);
+	err = err ?: btf_ext_visit_str_offs(obj->btf_ext, check_btf_str_off, obj->btf);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int init_sec(struct bpf_linker *linker, struct dst_sec *dst_sec, struct src_sec *src_sec)
 {
 	Elf_Scn *scn;
@@ -763,6 +897,10 @@ static int init_sec(struct bpf_linker *linker, struct dst_sec *dst_sec, struct s
 	dst_sec->sec_sz = 0;
 	dst_sec->sec_idx = 0;
 
+	/* ephemeral sections are just thin section shells lacking most parts */
+	if (src_sec->ephemeral)
+		return 0;
+
 	scn = elf_newscn(linker->elf);
 	if (!scn)
 		return -1;
@@ -891,12 +1029,15 @@ static bool is_data_sec(struct src_sec *sec)
 {
 	if (!sec || sec->skipped)
 		return false;
+	/* ephemeral sections are data sections, e.g., .kconfig, .ksyms */
+	if (sec->ephemeral)
+		return true;
 	return sec->shdr->sh_type == SHT_PROGBITS || sec->shdr->sh_type == SHT_NOBITS;
 }
 
 static bool is_relo_sec(struct src_sec *sec)
 {
-	if (!sec || sec->skipped)
+	if (!sec || sec->skipped || sec->ephemeral)
 		return false;
 	return sec->shdr->sh_type == SHT_REL;
 }
@@ -945,6 +1086,9 @@ static int linker_append_sec_data(struct bpf_linker *linker, struct src_obj *obj
 		/* record mapped section index */
 		src_sec->dst_id = dst_sec->id;
 
+		if (src_sec->ephemeral)
+			continue;
+
 		err = extend_sec(dst_sec, src_sec);
 		if (err)
 			return err;
@@ -1120,6 +1264,339 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
 	return 0;
 }
 
+static struct src_sec *find_src_sec_by_name(struct src_obj *obj, const char *sec_name)
+{
+	struct src_sec *sec;
+	int i;
+
+	for (i = 1; i < obj->sec_cnt; i++) {
+		sec = &obj->secs[i];
+
+		if (strcmp(sec->sec_name, sec_name) == 0)
+			return sec;
+	}
+
+	return NULL;
+}
+
+static Elf64_Sym *find_sym_by_name(struct src_obj *obj, size_t sec_idx,
+				   int sym_type, const char *sym_name)
+{
+	struct src_sec *symtab = &obj->secs[obj->symtab_sec_idx];
+	Elf64_Sym *sym = symtab->data->d_buf;
+	int i, n = symtab->shdr->sh_size / symtab->shdr->sh_entsize;
+	int str_sec_idx = symtab->shdr->sh_link;
+	const char *name;
+
+	for (i = 0; i < n; i++, sym++) {
+		if (sym->st_shndx != sec_idx)
+			continue;
+		if (ELF64_ST_TYPE(sym->st_info) != sym_type)
+			continue;
+
+		name = elf_strptr(obj->elf, str_sec_idx, sym->st_name);
+		if (!name)
+			return NULL;
+
+		if (strcmp(sym_name, name) != 0)
+			continue;
+
+		return sym;
+	}
+
+	return NULL;
+}
+
+static int linker_fixup_btf(struct src_obj *obj)
+{
+	const char *sec_name;
+	struct src_sec *sec;
+	int i, j, n, m;
+
+	n = btf__get_nr_types(obj->btf);
+	for (i = 1; i <= n; i++) {
+		struct btf_var_secinfo *vi;
+		struct btf_type *t;
+
+		t = btf_type_by_id(obj->btf, i);
+		if (btf_kind(t) != BTF_KIND_DATASEC)
+			continue;
+
+		sec_name = btf__str_by_offset(obj->btf, t->name_off);
+		sec = find_src_sec_by_name(obj, sec_name);
+		if (sec) {
+			/* record actual section size, unless ephemeral */
+			if (sec->shdr)
+				t->size = sec->shdr->sh_size;
+		} else {
+			/* BTF can have some sections that are not represented
+			 * in ELF, e.g., .kconfig and .ksyms, which are used
+			 * for special extern variables.  Here we'll
+			 * pre-create "section shells" for them to be able to
+			 * keep track of extra per-section metadata later
+			 * (e.g., BTF variables).
+			 */
+			sec = add_src_sec(obj, sec_name);
+			if (!sec)
+				return -ENOMEM;
+
+			sec->ephemeral = true;
+			sec->sec_idx = 0; /* will match UNDEF shndx in ELF */
+		}
+
+		/* remember ELF section and its BTF type ID match */
+		sec->sec_type_id = i;
+
+		/* fix up variable offsets */
+		vi = btf_var_secinfos(t);
+		for (j = 0, m = btf_vlen(t); j < m; j++, vi++) {
+			const struct btf_type *vt = btf__type_by_id(obj->btf, vi->type);
+			const char *var_name = btf__str_by_offset(obj->btf, vt->name_off);
+			int var_linkage = btf_var(vt)->linkage;
+			Elf64_Sym *sym;
+
+			/* no need to patch up static or extern vars */
+			if (var_linkage != BTF_VAR_GLOBAL_ALLOCATED)
+				continue;
+
+			sym = find_sym_by_name(obj, sec->sec_idx, STT_OBJECT, var_name);
+			if (!sym) {
+				pr_warn("failed to find symbol for variable '%s' in section '%s'\n", var_name, sec_name);
+				return -ENOENT;
+			}
+
+			vi->offset = sym->st_value;
+		}
+	}
+
+	return 0;
+}
+
+static int remap_type_id(__u32 *type_id, void *ctx)
+{
+	int *id_map = ctx;
+
+	*type_id = id_map[*type_id];
+
+	return 0;
+}
+
+static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
+{
+	const struct btf_type *t;
+	int i, j, n, start_id, id;
+
+	if (!obj->btf)
+		return 0;
+
+	start_id = btf__get_nr_types(linker->btf) + 1;
+	n = btf__get_nr_types(obj->btf);
+
+	obj->btf_type_map = calloc(n + 1, sizeof(int));
+	if (!obj->btf_type_map)
+		return -ENOMEM;
+
+	for (i = 1; i <= n; i++) {
+		t = btf__type_by_id(obj->btf, i);
+
+		/* DATASECs are handled specially below */
+		if (btf_kind(t) == BTF_KIND_DATASEC)
+			continue;
+
+		id = btf__add_type(linker->btf, obj->btf, t);
+		if (id < 0) {
+			pr_warn("failed to append BTF type #%d from file '%s'\n", i, obj->filename);
+			return id;
+		}
+
+		obj->btf_type_map[i] = id;
+	}
+
+	/* remap all the types except DATASECs */
+	n = btf__get_nr_types(linker->btf);
+	for (i = start_id; i <= n; i++) {
+		struct btf_type *dst_t = btf_type_by_id(linker->btf, i);
+
+		if (btf_type_visit_type_ids(dst_t, remap_type_id, obj->btf_type_map))
+			return -EINVAL;
+	}
+
+	/* append DATASEC info */
+	for (i = 1; i < obj->sec_cnt; i++) {
+		struct src_sec *src_sec;
+		struct dst_sec *dst_sec;
+		const struct btf_var_secinfo *src_var;
+		struct btf_var_secinfo *dst_var;
+
+		src_sec = &obj->secs[i];
+		if (!src_sec->sec_type_id || src_sec->skipped)
+			continue;
+		dst_sec = &linker->secs[src_sec->dst_id];
+
+		t = btf__type_by_id(obj->btf, src_sec->sec_type_id);
+		src_var = btf_var_secinfos(t);
+		n = btf_vlen(t);
+		for (j = 0; j < n; j++, src_var++) {
+			void *sec_vars = dst_sec->sec_vars;
+
+			sec_vars = libbpf_reallocarray(sec_vars,
+						       dst_sec->sec_var_cnt + 1,
+						       sizeof(*dst_sec->sec_vars));
+			if (!sec_vars)
+				return -ENOMEM;
+
+			dst_sec->sec_vars = sec_vars;
+			dst_sec->sec_var_cnt++;
+
+			dst_var = &dst_sec->sec_vars[dst_sec->sec_var_cnt - 1];
+			dst_var->type = obj->btf_type_map[src_var->type];
+			dst_var->size = src_var->size;
+			dst_var->offset = src_sec->dst_off + src_var->offset;
+		}
+	}
+
+	return 0;
+}
+
+static void *add_btf_ext_rec(struct btf_ext_sec_data *ext_data, const void *src_rec)
+{
+	void *tmp;
+
+	tmp = libbpf_reallocarray(ext_data->recs, ext_data->rec_cnt + 1, ext_data->rec_sz);
+	if (!tmp)
+		return NULL;
+	ext_data->recs = tmp;
+
+	tmp += ext_data->rec_cnt * ext_data->rec_sz;
+	memcpy(tmp, src_rec, ext_data->rec_sz);
+
+	ext_data->rec_cnt++;
+
+	return tmp;
+}
+
+static int linker_append_btf_ext(struct bpf_linker *linker, struct src_obj *obj)
+{
+	const struct btf_ext_info_sec *ext_sec;
+	const char *sec_name, *s;
+	struct src_sec *src_sec;
+	struct dst_sec *dst_sec;
+	int rec_sz, str_off, i;
+
+	if (!obj->btf_ext)
+		return 0;
+
+	rec_sz = obj->btf_ext->func_info.rec_size;
+	for_each_btf_ext_sec(&obj->btf_ext->func_info, ext_sec) {
+		struct bpf_func_info_min *src_rec, *dst_rec;
+
+		sec_name = btf__name_by_offset(obj->btf, ext_sec->sec_name_off);
+		src_sec = find_src_sec_by_name(obj, sec_name);
+		if (!src_sec) {
+			pr_warn("can't find section '%s' referenced from .BTF.ext\n", sec_name);
+			return -EINVAL;
+		}
+		dst_sec = &linker->secs[src_sec->dst_id];
+
+		if (dst_sec->func_info.rec_sz == 0)
+			dst_sec->func_info.rec_sz = rec_sz;
+		if (dst_sec->func_info.rec_sz != rec_sz) {
+			pr_warn("incompatible .BTF.ext record sizes for section '%s'\n", sec_name);
+			return -EINVAL;
+		}
+
+		for_each_btf_ext_rec(&obj->btf_ext->func_info, ext_sec, i, src_rec) {
+			dst_rec = add_btf_ext_rec(&dst_sec->func_info, src_rec);
+			if (!dst_rec)
+				return -ENOMEM;
+
+			dst_rec->insn_off += src_sec->dst_off;
+			dst_rec->type_id = obj->btf_type_map[dst_rec->type_id];
+		}
+	}
+
+	rec_sz = obj->btf_ext->line_info.rec_size;
+	for_each_btf_ext_sec(&obj->btf_ext->line_info, ext_sec) {
+		struct bpf_line_info_min *src_rec, *dst_rec;
+
+		sec_name = btf__name_by_offset(obj->btf, ext_sec->sec_name_off);
+		src_sec = find_src_sec_by_name(obj, sec_name);
+		if (!src_sec) {
+			pr_warn("can't find section '%s' referenced from .BTF.ext\n", sec_name);
+			return -EINVAL;
+		}
+		dst_sec = &linker->secs[src_sec->dst_id];
+
+		if (dst_sec->line_info.rec_sz == 0)
+			dst_sec->line_info.rec_sz = rec_sz;
+		if (dst_sec->line_info.rec_sz != rec_sz) {
+			pr_warn("incompatible .BTF.ext record sizes for section '%s'\n", sec_name);
+			return -EINVAL;
+		}
+
+		for_each_btf_ext_rec(&obj->btf_ext->line_info, ext_sec, i, src_rec) {
+			dst_rec = add_btf_ext_rec(&dst_sec->line_info, src_rec);
+			if (!dst_rec)
+				return -ENOMEM;
+
+			dst_rec->insn_off += src_sec->dst_off;
+
+			s = btf__str_by_offset(obj->btf, src_rec->file_name_off);
+			str_off = btf__add_str(linker->btf, s);
+			if (str_off < 0)
+				return -ENOMEM;
+			dst_rec->file_name_off = str_off;
+
+			s = btf__str_by_offset(obj->btf, src_rec->line_off);
+			str_off = btf__add_str(linker->btf, s);
+			if (str_off < 0)
+				return -ENOMEM;
+			dst_rec->line_off = str_off;
+
+			/* dst_rec->line_col is fine */
+		}
+	}
+
+	rec_sz = obj->btf_ext->core_relo_info.rec_size;
+	for_each_btf_ext_sec(&obj->btf_ext->core_relo_info, ext_sec) {
+		struct bpf_core_relo *src_rec, *dst_rec;
+
+		sec_name = btf__name_by_offset(obj->btf, ext_sec->sec_name_off);
+		src_sec = find_src_sec_by_name(obj, sec_name);
+		if (!src_sec) {
+			pr_warn("can't find section '%s' referenced from .BTF.ext\n", sec_name);
+			return -EINVAL;
+		}
+		dst_sec = &linker->secs[src_sec->dst_id];
+
+		if (dst_sec->core_relo_info.rec_sz == 0)
+			dst_sec->core_relo_info.rec_sz = rec_sz;
+		if (dst_sec->core_relo_info.rec_sz != rec_sz) {
+			pr_warn("incompatible .BTF.ext record sizes for section '%s'\n", sec_name);
+			return -EINVAL;
+		}
+
+		for_each_btf_ext_rec(&obj->btf_ext->core_relo_info, ext_sec, i, src_rec) {
+			dst_rec = add_btf_ext_rec(&dst_sec->core_relo_info, src_rec);
+			if (!dst_rec)
+				return -ENOMEM;
+
+			dst_rec->insn_off += src_sec->dst_off;
+			dst_rec->type_id = obj->btf_type_map[dst_rec->type_id];
+
+			s = btf__str_by_offset(obj->btf, src_rec->access_str_off);
+			str_off = btf__add_str(linker->btf, s);
+			if (str_off < 0)
+				return -ENOMEM;
+			dst_rec->access_str_off = str_off;
+
+			/* dst_rec->kind is fine */
+		}
+	}
+
+	return 0;
+}
+
 int bpf_linker__finalize(struct bpf_linker *linker)
 {
 	struct dst_sec *sec;
@@ -1130,6 +1607,10 @@ int bpf_linker__finalize(struct bpf_linker *linker)
 	if (!linker->elf)
 		return -EINVAL;
 
+	err = finalize_btf(linker);
+	if (err)
+		return err;
+
 	/* Finalize strings */
 	strs_sz = strset__data_size(linker->strtab_strs);
 	strs = strset__data(linker->strtab_strs);
@@ -1149,6 +1630,10 @@ int bpf_linker__finalize(struct bpf_linker *linker)
 		if (sec->sec_idx == linker->strtab_sec_idx)
 			continue;
 
+		/* special ephemeral sections (.ksyms, .kconfig, etc) */
+		if (!sec->scn)
+			continue;
+
 		sec->data->d_buf = sec->raw_data;
 	}
 
@@ -1174,3 +1659,283 @@ int bpf_linker__finalize(struct bpf_linker *linker)
 
 	return 0;
 }
+
+static int emit_elf_data_sec(struct bpf_linker *linker, const char *sec_name,
+			     size_t align, const void *raw_data, size_t raw_sz)
+{
+	Elf_Scn *scn;
+	Elf_Data *data;
+	Elf64_Shdr *shdr;
+	int name_off;
+
+	name_off = strset__add_str(linker->strtab_strs, sec_name);
+	if (name_off < 0)
+		return name_off;
+
+	scn = elf_newscn(linker->elf);
+	if (!scn)
+		return -ENOMEM;
+	data = elf_newdata(scn);
+	if (!data)
+		return -ENOMEM;
+	shdr = elf64_getshdr(scn);
+	if (!shdr)
+		return -EINVAL;
+
+	shdr->sh_name = name_off;
+	shdr->sh_type = SHT_PROGBITS;
+	shdr->sh_flags = 0;
+	shdr->sh_size = raw_sz;
+	shdr->sh_link = 0;
+	shdr->sh_info = 0;
+	shdr->sh_addralign = align;
+	shdr->sh_entsize = 0;
+
+	data->d_type = ELF_T_BYTE;
+	data->d_size = raw_sz;
+	data->d_buf = (void *)raw_data;
+	data->d_align = align;
+	data->d_off = 0;
+
+	return 0;
+}
+
+static int finalize_btf(struct bpf_linker *linker)
+{
+	struct btf *btf = linker->btf;
+	const void *raw_data;
+	int i, j, id, err;
+	__u32 raw_sz;
+
+	/* bail out if no BTF data was produced */
+	if (btf__get_nr_types(linker->btf) == 0)
+		return 0;
+
+	for (i = 1; i < linker->sec_cnt; i++) {
+		struct dst_sec *sec = &linker->secs[i];
+
+		if (!sec->sec_var_cnt)
+			continue;
+
+		id = btf__add_datasec(btf, sec->sec_name, sec->sec_sz);
+		if (id < 0) {
+			pr_warn("failed to add consolidated BTF type for datasec '%s': %d\n",
+				sec->sec_name, id);
+			return id;
+		}
+
+		for (j = 0; j < sec->sec_var_cnt; j++) {
+			struct btf_var_secinfo *vi = &sec->sec_vars[j];
+
+			if (btf__add_datasec_var_info(btf, vi->type, vi->offset, vi->size))
+				return -EINVAL;
+		}
+	}
+
+	err = finalize_btf_ext(linker);
+	if (err) {
+		pr_warn(".BTF.ext generation failed: %d\n", err);
+		return err;
+	}
+
+	err = btf__dedup(linker->btf, linker->btf_ext, NULL);
+	if (err) {
+		pr_warn("BTF dedup failed: %d\n", err);
+		return err;
+	}
+
+	/* Emit .BTF section */
+	raw_data = btf__get_raw_data(linker->btf, &raw_sz);
+	if (!raw_data)
+		return -ENOMEM;
+
+	err = emit_elf_data_sec(linker, BTF_ELF_SEC, 8, raw_data, raw_sz);
+	if (err) {
+		pr_warn("failed to write out .BTF ELF section: %d\n", err);
+		return err;
+	}
+
+	/* Emit .BTF.ext section */
+	if (linker->btf_ext) {
+		raw_data = btf_ext__get_raw_data(linker->btf_ext, &raw_sz);
+		if (!raw_data)
+			return -ENOMEM;
+
+		err = emit_elf_data_sec(linker, BTF_EXT_ELF_SEC, 8, raw_data, raw_sz);
+		if (err) {
+			pr_warn("failed to write out .BTF.ext ELF section: %d\n", err);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int emit_btf_ext_data(struct bpf_linker *linker, void *output,
+			     const char *sec_name, struct btf_ext_sec_data *sec_data)
+{
+	struct btf_ext_info_sec *sec_info;
+	void *cur = output;
+	int str_off;
+	size_t sz;
+
+	if (!sec_data->rec_cnt)
+		return 0;
+
+	str_off = btf__add_str(linker->btf, sec_name);
+	if (str_off < 0)
+		return -ENOMEM;
+
+	sec_info = cur;
+	sec_info->sec_name_off = str_off;
+	sec_info->num_info = sec_data->rec_cnt;
+	cur += sizeof(struct btf_ext_info_sec);
+
+	sz = sec_data->rec_cnt * sec_data->rec_sz;
+	memcpy(cur, sec_data->recs, sz);
+	cur += sz;
+
+	return cur - output;
+}
+
+static int finalize_btf_ext(struct bpf_linker *linker)
+{
+	size_t funcs_sz = 0, lines_sz = 0, core_relos_sz = 0, total_sz = 0;
+	size_t func_rec_sz = 0, line_rec_sz = 0, core_relo_rec_sz = 0;
+	struct btf_ext_header *hdr;
+	void *data, *cur;
+	int i, err, sz;
+
+	/* validate that all sections have the same .BTF.ext record sizes
+	 * and calculate total data size for each type of data (func info,
+	 * line info, core relos)
+	 */
+	for (i = 1; i < linker->sec_cnt; i++) {
+		struct dst_sec *sec = &linker->secs[i];
+
+		if (sec->func_info.rec_cnt) {
+			if (func_rec_sz == 0)
+				func_rec_sz = sec->func_info.rec_sz;
+			if (func_rec_sz != sec->func_info.rec_sz) {
+				pr_warn("mismatch in func_info record size %zu != %u\n",
+					func_rec_sz, sec->func_info.rec_sz);
+				return -EINVAL;
+			}
+
+			funcs_sz += sizeof(struct btf_ext_info_sec) + func_rec_sz * sec->func_info.rec_cnt;
+		}
+		if (sec->line_info.rec_cnt) {
+			if (line_rec_sz == 0)
+				line_rec_sz = sec->line_info.rec_sz;
+			if (line_rec_sz != sec->line_info.rec_sz) {
+				pr_warn("mismatch in line_info record size %zu != %u\n",
+					line_rec_sz, sec->line_info.rec_sz);
+				return -EINVAL;
+			}
+
+			lines_sz += sizeof(struct btf_ext_info_sec) + line_rec_sz * sec->line_info.rec_cnt;
+		}
+		if (sec->core_relo_info.rec_cnt) {
+			if (core_relo_rec_sz == 0)
+				core_relo_rec_sz = sec->core_relo_info.rec_sz;
+			if (core_relo_rec_sz != sec->core_relo_info.rec_sz) {
+				pr_warn("mismatch in core_relo_info record size %zu != %u\n",
+					core_relo_rec_sz, sec->core_relo_info.rec_sz);
+				return -EINVAL;
+			}
+
+			core_relos_sz += sizeof(struct btf_ext_info_sec) + core_relo_rec_sz * sec->core_relo_info.rec_cnt;
+		}
+	}
+
+	if (!funcs_sz && !lines_sz && !core_relos_sz)
+		return 0;
+
+	total_sz += sizeof(struct btf_ext_header);
+	if (funcs_sz) {
+		funcs_sz += sizeof(__u32); /* record size prefix */
+		total_sz += funcs_sz;
+	}
+	if (lines_sz) {
+		lines_sz += sizeof(__u32); /* record size prefix */
+		total_sz += lines_sz;
+	}
+	if (core_relos_sz) {
+		core_relos_sz += sizeof(__u32); /* record size prefix */
+		total_sz += core_relos_sz;
+	}
+
+	cur = data = calloc(1, total_sz);
+	if (!data)
+		return -ENOMEM;
+
+	hdr = cur;
+	hdr->magic = BTF_MAGIC;
+	hdr->version = BTF_VERSION;
+	hdr->flags = 0;
+	hdr->hdr_len = sizeof(struct btf_ext_header);
+	cur += sizeof(struct btf_ext_header);
+
+	/* All offsets are in bytes relative to the end of this header */
+	hdr->func_info_off = 0;
+	hdr->func_info_len = funcs_sz;
+	hdr->line_info_off = funcs_sz;
+	hdr->line_info_len = lines_sz;
+	hdr->core_relo_off = funcs_sz + lines_sz;;
+	hdr->core_relo_len = core_relos_sz;
+
+	if (funcs_sz) {
+		*(__u32 *)cur = func_rec_sz;
+		cur += sizeof(__u32);
+
+		for (i = 1; i < linker->sec_cnt; i++) {
+			struct dst_sec *sec = &linker->secs[i];
+
+			sz = emit_btf_ext_data(linker, cur, sec->sec_name, &sec->func_info);
+			if (sz < 0)
+				return sz;
+
+			cur += sz;
+		}
+	}
+
+	if (lines_sz) {
+		*(__u32 *)cur = line_rec_sz;
+		cur += sizeof(__u32);
+
+		for (i = 1; i < linker->sec_cnt; i++) {
+			struct dst_sec *sec = &linker->secs[i];
+
+			sz = emit_btf_ext_data(linker, cur, sec->sec_name, &sec->line_info);
+			if (sz < 0)
+				return sz;
+
+			cur += sz;
+		}
+	}
+
+	if (core_relos_sz) {
+		*(__u32 *)cur = core_relo_rec_sz;
+		cur += sizeof(__u32);
+
+		for (i = 1; i < linker->sec_cnt; i++) {
+			struct dst_sec *sec = &linker->secs[i];
+
+			sz = emit_btf_ext_data(linker, cur, sec->sec_name, &sec->core_relo_info);
+			if (sz < 0)
+				return sz;
+
+			cur += sz;
+		}
+	}
+
+	linker->btf_ext = btf_ext__new(data, total_sz);
+	err = libbpf_get_error(linker->btf_ext);
+	if (err) {
+		linker->btf_ext = NULL;
+		pr_warn("failed to parse final .BTF.ext data: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
-- 
2.30.2

