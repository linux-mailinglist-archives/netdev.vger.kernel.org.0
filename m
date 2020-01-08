Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A895133C3C
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 08:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgAHH0D convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Jan 2020 02:26:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2746 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbgAHHZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 02:25:53 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0087PlCl027845
        for <netdev@vger.kernel.org>; Tue, 7 Jan 2020 23:25:52 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xd2ac29qt-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 23:25:52 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 7 Jan 2020 23:25:49 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id B6ECE760DB5; Tue,  7 Jan 2020 23:25:42 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/6] libbpf: Collect static vs global info about functions
Date:   Tue, 7 Jan 2020 23:25:34 -0800
Message-ID: <20200108072538.3359838-3-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200108072538.3359838-1-ast@kernel.org>
References: <20200108072538.3359838-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_01:2020-01-07,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 clxscore=1034 malwarescore=0
 suspectscore=1 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001080063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Collect static vs global information about BPF functions from ELF file and
improve BTF with this additional info if llvm is too old and doesn't emit it on
its own.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/libbpf.c | 115 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 111 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f72b3ed6c34b..2a4417d03ee2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -294,6 +294,12 @@ struct extern_desc {
 
 static LIST_HEAD(bpf_objects_list);
 
+struct func_desc {
+	int insn_idx;
+	int sec_idx;
+	enum btf_func_linkage linkage;
+};
+
 struct bpf_object {
 	char name[BPF_OBJ_NAME_LEN];
 	char license[64];
@@ -304,6 +310,8 @@ struct bpf_object {
 	struct bpf_map *maps;
 	size_t nr_maps;
 	size_t maps_cap;
+	struct func_desc *funcs;
+	int nr_funcs;
 
 	char *kconfig;
 	struct extern_desc *externs;
@@ -313,6 +321,7 @@ struct bpf_object {
 	bool loaded;
 	bool has_pseudo_calls;
 	bool relaxed_core_relocs;
+	bool llvm_emits_func_linkage;
 
 	/*
 	 * Information when doing elf related work. Only valid if fd
@@ -526,10 +535,10 @@ bpf_object__init_prog_names(struct bpf_object *obj)
 				continue;
 			if (GELF_ST_BIND(sym.st_info) != STB_GLOBAL)
 				continue;
-
 			name = elf_strptr(obj->efile.elf,
 					  obj->efile.strtabidx,
 					  sym.st_name);
+
 			if (!name) {
 				pr_warn("failed to get sym name string for prog %s\n",
 					prog->section_name);
@@ -2232,6 +2241,34 @@ static int cmp_externs(const void *_a, const void *_b)
 	return strcmp(a->name, b->name);
 }
 
+static int bpf_object__record_func_info(struct bpf_object *obj, GElf_Sym *sym)
+{
+	int bind = GELF_ST_BIND(sym->st_info);
+	bool static_func = bind == STB_LOCAL;
+	struct func_desc *f;
+
+	/*
+	 * Cannot check obj->caps.btf_func_linkage during elf open phase.
+	 * Otherwise could have skipped collection of this info.
+	 */
+
+	f = obj->funcs;
+	f = reallocarray(f, obj->nr_funcs + 1, sizeof(*f));
+	if (!f)
+		return -ENOMEM;
+	obj->funcs = f;
+	f = &f[obj->nr_funcs];
+	memset(f, 0, sizeof(*f));
+	obj->nr_funcs++;
+
+	f->insn_idx = sym->st_value / 8;
+	f->linkage = static_func ? BTF_FUNC_STATIC : BTF_FUNC_GLOBAL;
+	f->sec_idx = sym->st_shndx;
+	pr_debug("Func at insn %d sec %d linkage %d\n",
+		 f->insn_idx, f->sec_idx, f->linkage);
+	return 0;
+}
+
 static int bpf_object__collect_externs(struct bpf_object *obj)
 {
 	const struct btf_type *t;
@@ -2258,6 +2295,12 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 
 		if (!gelf_getsym(obj->efile.symbols, i, &sym))
 			return -LIBBPF_ERRNO__FORMAT;
+		if (GELF_ST_TYPE(sym.st_info) == STT_FUNC) {
+			int err = bpf_object__record_func_info(obj, &sym);
+
+			if (err)
+				return err;
+		}
 		if (!sym_is_extern(&sym))
 			continue;
 		ext_name = elf_strptr(obj->efile.elf, obj->efile.strtabidx,
@@ -3145,9 +3188,62 @@ check_btf_ext_reloc_err(struct bpf_program *prog, int err,
 	return 0;
 }
 
+static int btf_ext_improve_func_info(struct bpf_object *obj,
+				     struct bpf_program *prog,
+				     __u32 sec_idx)
+{
+	struct bpf_func_info_min *info;
+	struct btf_type *t;
+	struct func_desc *f;
+	const char *name;
+	int i, j;
+
+	if (!obj->caps.btf_func_linkage || obj->llvm_emits_func_linkage)
+		/*
+		 * If kernel doesn't understand func linkage or llvm emits
+		 * it already into BTF then don't try to improve BTF based on
+		 * ELF info.
+		 */
+		return 0;
+
+	info = prog->func_info;
+	for (i = 0; i < prog->func_info_cnt; i++) {
+		for (j = 0; j < obj->nr_funcs; j++) {
+			f = &obj->funcs[j];
+			if (f->insn_idx != info->insn_off ||
+			    f->sec_idx != sec_idx)
+				continue;
+			t = (void *)btf__type_by_id(obj->btf, info->type_id);
+			if (!t)
+				return -EINVAL;
+			name = btf__name_by_offset(obj->btf, t->name_off);
+			if (!name)
+				return -EINVAL;
+			pr_debug("Func '%s' at insn %d btf_id %d linkage in BTF %d in ELF %d\n",
+				 name, info->insn_off, info->type_id,
+				 BTF_INFO_VLEN(t->info), f->linkage);
+			if (BTF_INFO_VLEN(t->info) == f->linkage) {
+				if (BTF_INFO_VLEN(t->info)) {
+					/* llvm emits func linkage. Don't touch BTF */
+					obj->llvm_emits_func_linkage = true;
+					return 0;
+				}
+			} else {
+				/* improve BTF with static vs global */
+				t->info = BTF_INFO_ENC(BTF_KIND_FUNC, 0,
+						       f->linkage);
+			}
+			break;
+		}
+		info = ((void *)info) + prog->func_info_rec_size;
+	}
+	return 0;
+}
+
 static int
 bpf_program_reloc_btf_ext(struct bpf_program *prog, struct bpf_object *obj,
-			  const char *section_name,  __u32 insn_offset)
+			  const char *section_name,  __u32 insn_offset,
+			  __u32 sec_idx)
 {
 	int err;
 
@@ -3168,6 +3264,15 @@ bpf_program_reloc_btf_ext(struct bpf_program *prog, struct bpf_object *obj,
 						       "bpf_func_info");
 
 		prog->func_info_rec_size = btf_ext__func_info_rec_size(obj->btf_ext);
+		if (!insn_offset) {
+			/*
+			 * improve BTF_KIND_FUNC when func_info is allocated
+			 * first time. Don't touch it during relocation.
+			 */
+			err = btf_ext_improve_func_info(obj, prog, sec_idx);
+			if (err)
+				return err;
+		}
 	}
 
 	if (!insn_offset || prog->line_info) {
@@ -4308,7 +4413,8 @@ bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj,
 		if (obj->btf_ext) {
 			err = bpf_program_reloc_btf_ext(prog, obj,
 							text->section_name,
-							prog->insns_cnt);
+							prog->insns_cnt,
+							text->idx);
 			if (err)
 				return err;
 		}
@@ -4336,7 +4442,8 @@ bpf_program__relocate(struct bpf_program *prog, struct bpf_object *obj)
 
 	if (obj->btf_ext) {
 		err = bpf_program_reloc_btf_ext(prog, obj,
-						prog->section_name, 0);
+						prog->section_name, 0,
+						prog->idx);
 		if (err)
 			return err;
 	}
-- 
2.23.0

