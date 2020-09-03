Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1568C25CAF2
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbgICUgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:36:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23628 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729614AbgICUgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 16:36:39 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 083KWhv6032407
        for <netdev@vger.kernel.org>; Thu, 3 Sep 2020 13:36:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=gPVpYmzIBHmyAVxd/1CHdhoXGtfSjQ/5lwsWOow9JU8=;
 b=LOkWcITQTpRpBquqJst5zscZJVsQ72dMcjQbTrZLntv4+4QOk2juE4xg90xyVIc67yF2
 Ejxa8pzjGN9xEWCt7vybxDKlq0o2A8MbNi/v0tbbxDnZaJWUWne8qYRHyplELmrIageW
 MZDf0BhvfF+vFujeGHtKuHSVqVJnWY8Unw8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 33b4crs73k-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 13:36:37 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Sep 2020 13:35:55 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AD3B22EC6814; Thu,  3 Sep 2020 13:35:47 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH v3 bpf-next 02/14] libbpf: parse multi-function sections into multiple BPF programs
Date:   Thu, 3 Sep 2020 13:35:30 -0700
Message-ID: <20200903203542.15944-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200903203542.15944-1-andriin@fb.com>
References: <20200903203542.15944-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_13:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=9 priorityscore=1501
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=903 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Teach libbpf how to parse code sections into potentially multiple bpf_pro=
gram
instances, based on ELF FUNC symbols. Each BPF program will keep track of=
 its
position within containing ELF section for translating section instructio=
n
offsets into program instruction offsets: regardless of BPF program's loc=
ation
in ELF section, it's first instruction is always at local instruction off=
set
0, so when libbpf is working with relocations (which use section-based
instruction offsets) this is critical to make proper translations.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 249 +++++++++++++++++++++++------------------
 1 file changed, 142 insertions(+), 107 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ac56d4db6d3e..57f87eee5be5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -217,20 +217,45 @@ struct bpf_sec_def {
  * linux/filter.h.
  */
 struct bpf_program {
-	/* Index in elf obj file, for relocation use. */
-	int idx;
-	char *name;
-	int prog_ifindex;
-	char *section_name;
 	const struct bpf_sec_def *sec_def;
+	char *section_name;
+	size_t sec_idx;
+	/* this program's instruction offset (in number of instructions)
+	 * within its containing ELF section
+	 */
+	size_t sec_insn_off;
+	/* number of original instructions in ELF section belonging to this
+	 * program, not taking into account subprogram instructions possible
+	 * appended later during relocation
+	 */
+	size_t sec_insn_cnt;
+	/* Offset (in number of instructions) of the start of instruction
+	 * belonging to this BPF program  within its containing main BPF
+	 * program. For the entry-point (main) BPF program, this is always
+	 * zero. For a sub-program, this gets reset before each of main BPF
+	 * programs are processed and relocated and is used to determined
+	 * whether sub-program was already appended to the main program, and
+	 * if yes, at which instruction offset.
+	 */
+	size_t sub_insn_off;
+
+	char *name;
 	/* section_name with / replaced by _; makes recursive pinning
 	 * in bpf_object__pin_programs easier
 	 */
 	char *pin_name;
+
+	/* instructions that belong to BPF program; insns[0] is located at
+	 * sec_insn_off instruction within its ELF section in ELF file, so
+	 * when mapping ELF file instruction index to the local instruction,
+	 * one needs to subtract sec_insn_off; and vice versa.
+	 */
 	struct bpf_insn *insns;
+	/* actual number of instruction in this BPF program's image; for
+	 * entry-point BPF programs this includes the size of main program
+	 * itself plus all the used sub-programs, appended at the end
+	 */
 	size_t insns_cnt, main_prog_cnt;
-	enum bpf_prog_type type;
-	bool load;
=20
 	struct reloc_desc *reloc_desc;
 	int nr_reloc;
@@ -246,7 +271,10 @@ struct bpf_program {
 	void *priv;
 	bpf_program_clear_priv_t clear_priv;
=20
+	bool load;
+	enum bpf_prog_type type;
 	enum bpf_attach_type expected_attach_type;
+	int prog_ifindex;
 	__u32 attach_btf_id;
 	__u32 attach_prog_fd;
 	void *func_info;
@@ -446,6 +474,8 @@ static Elf_Scn *elf_sec_by_name(const struct bpf_obje=
ct *obj, const char *name);
 static int elf_sec_hdr(const struct bpf_object *obj, Elf_Scn *scn, GElf_=
Shdr *hdr);
 static const char *elf_sec_name(const struct bpf_object *obj, Elf_Scn *s=
cn);
 static Elf_Data *elf_sec_data(const struct bpf_object *obj, Elf_Scn *scn=
);
+static int elf_sym_by_sec_off(const struct bpf_object *obj, size_t sec_i=
dx,
+			      size_t off, __u32 sym_type, GElf_Sym *sym);
=20
 void bpf_program__unload(struct bpf_program *prog)
 {
@@ -493,7 +523,7 @@ static void bpf_program__exit(struct bpf_program *pro=
g)
=20
 	prog->nr_reloc =3D 0;
 	prog->insns_cnt =3D 0;
-	prog->idx =3D -1;
+	prog->sec_idx =3D -1;
 }
=20
 static char *__bpf_program__pin_name(struct bpf_program *prog)
@@ -508,130 +538,118 @@ static char *__bpf_program__pin_name(struct bpf_p=
rogram *prog)
 }
=20
 static int
-bpf_program__init(void *data, size_t size, const char *section_name, int=
 idx,
-		  struct bpf_program *prog)
+bpf_program__init(struct bpf_program *prog, const char *name,
+		  size_t sec_idx, const char *sec_name, size_t sec_off,
+		  void *insn_data, size_t insn_data_sz)
 {
-	const size_t bpf_insn_sz =3D sizeof(struct bpf_insn);
-
-	if (size =3D=3D 0 || size % bpf_insn_sz) {
-		pr_warn("corrupted section '%s', size: %zu\n",
-			section_name, size);
+	if (insn_data_sz =3D=3D 0 || insn_data_sz % BPF_INSN_SZ || sec_off % BP=
F_INSN_SZ) {
+		pr_warn("sec '%s': corrupted program '%s', offset %zu, size %zu\n",
+			sec_name, name, sec_off, insn_data_sz);
 		return -EINVAL;
 	}
=20
-	memset(prog, 0, sizeof(*prog));
+	prog->sec_idx =3D sec_idx;
+	prog->sec_insn_off =3D sec_off / BPF_INSN_SZ;
+	prog->sec_insn_cnt =3D insn_data_sz / BPF_INSN_SZ;
+	/* insns_cnt can later be increased by appending used subprograms */
+	prog->insns_cnt =3D prog->sec_insn_cnt;
=20
-	prog->section_name =3D strdup(section_name);
-	if (!prog->section_name) {
-		pr_warn("failed to alloc name for prog under section(%d) %s\n",
-			idx, section_name);
+	prog->type =3D BPF_PROG_TYPE_UNSPEC;
+	prog->load =3D true;
+
+	prog->instances.fds =3D NULL;
+	prog->instances.nr =3D -1;
+
+	prog->section_name =3D strdup(sec_name);
+	if (!prog->section_name)
+		goto errout;
+
+	prog->name =3D strdup(name);
+	if (!prog->name)
 		goto errout;
-	}
=20
 	prog->pin_name =3D __bpf_program__pin_name(prog);
-	if (!prog->pin_name) {
-		pr_warn("failed to alloc pin name for prog under section(%d) %s\n",
-			idx, section_name);
+	if (!prog->pin_name)
 		goto errout;
-	}
=20
-	prog->insns =3D malloc(size);
-	if (!prog->insns) {
-		pr_warn("failed to alloc insns for prog under section %s\n",
-			section_name);
+	prog->insns =3D malloc(insn_data_sz);
+	if (!prog->insns)
 		goto errout;
-	}
-	prog->insns_cnt =3D size / bpf_insn_sz;
-	memcpy(prog->insns, data, size);
-	prog->idx =3D idx;
-	prog->instances.fds =3D NULL;
-	prog->instances.nr =3D -1;
-	prog->type =3D BPF_PROG_TYPE_UNSPEC;
-	prog->load =3D true;
+	memcpy(prog->insns, insn_data, insn_data_sz);
=20
 	return 0;
 errout:
+	pr_warn("sec '%s': failed to allocate memory for prog '%s'\n", sec_name=
, name);
 	bpf_program__exit(prog);
 	return -ENOMEM;
 }
=20
 static int
-bpf_object__add_program(struct bpf_object *obj, void *data, size_t size,
-			const char *section_name, int idx)
+bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
+			 const char *sec_name, int sec_idx)
 {
-	struct bpf_program prog, *progs;
+	struct bpf_program *prog, *progs;
+	void *data =3D sec_data->d_buf;
+	size_t sec_sz =3D sec_data->d_size, sec_off, prog_sz;
 	int nr_progs, err;
-
-	err =3D bpf_program__init(data, size, section_name, idx, &prog);
-	if (err)
-		return err;
+	const char *name;
+	GElf_Sym sym;
=20
 	progs =3D obj->programs;
 	nr_progs =3D obj->nr_programs;
+	sec_off =3D 0;
=20
-	progs =3D libbpf_reallocarray(progs, nr_progs + 1, sizeof(progs[0]));
-	if (!progs) {
-		/*
-		 * In this case the original obj->programs
-		 * is still valid, so don't need special treat for
-		 * bpf_close_object().
-		 */
-		pr_warn("failed to alloc a new program under section '%s'\n",
-			section_name);
-		bpf_program__exit(&prog);
-		return -ENOMEM;
-	}
-
-	pr_debug("elf: found program '%s'\n", prog.section_name);
-	obj->programs =3D progs;
-	obj->nr_programs =3D nr_progs + 1;
-	prog.obj =3D obj;
-	progs[nr_progs] =3D prog;
-	return 0;
-}
-
-static int
-bpf_object__init_prog_names(struct bpf_object *obj)
-{
-	Elf_Data *symbols =3D obj->efile.symbols;
-	struct bpf_program *prog;
-	size_t pi, si;
+	while (sec_off < sec_sz) {
+		if (elf_sym_by_sec_off(obj, sec_idx, sec_off, STT_FUNC, &sym)) {
+			pr_warn("sec '%s': failed to find program symbol at offset %zu\n",
+				sec_name, sec_off);
+			return -LIBBPF_ERRNO__FORMAT;
+		}
=20
-	for (pi =3D 0; pi < obj->nr_programs; pi++) {
-		const char *name =3D NULL;
+		prog_sz =3D sym.st_size;
=20
-		prog =3D &obj->programs[pi];
+		name =3D elf_sym_str(obj, sym.st_name);
+		if (!name) {
+			pr_warn("sec '%s': failed to get symbol name for offset %zu\n",
+				sec_name, sec_off);
+			return -LIBBPF_ERRNO__FORMAT;
+		}
=20
-		for (si =3D 0; si < symbols->d_size / sizeof(GElf_Sym) && !name; si++)=
 {
-			GElf_Sym sym;
+		if (sec_off + prog_sz > sec_sz) {
+			pr_warn("sec '%s': program at offset %zu crosses section boundary\n",
+				sec_name, sec_off);
+			return -LIBBPF_ERRNO__FORMAT;
+		}
=20
-			if (!gelf_getsym(symbols, si, &sym))
-				continue;
-			if (sym.st_shndx !=3D prog->idx)
-				continue;
-			if (GELF_ST_BIND(sym.st_info) !=3D STB_GLOBAL)
-				continue;
+		pr_debug("sec '%s': found program '%s' at offset %zu, code size %zu by=
tes\n",
+			 sec_name, name, sec_off, prog_sz);
=20
-			name =3D elf_sym_str(obj, sym.st_name);
-			if (!name) {
-				pr_warn("prog '%s': failed to get symbol name\n",
-					prog->section_name);
-				return -LIBBPF_ERRNO__LIBELF;
-			}
+		progs =3D reallocarray(progs, nr_progs + 1, sizeof(*progs));
+		if (!progs) {
+			/*
+			 * In this case the original obj->programs
+			 * is still valid, so don't need special treat for
+			 * bpf_close_object().
+			 */
+			pr_warn("sec '%s': failed to alloc memory for new program '%s'\n",
+				sec_name, name);
+			return -ENOMEM;
 		}
+		obj->programs =3D progs;
=20
-		if (!name && prog->idx =3D=3D obj->efile.text_shndx)
-			name =3D ".text";
+		prog =3D &progs[nr_progs];
+		memset(prog, 0, sizeof(*prog));
+		prog->obj =3D obj;
=20
-		if (!name) {
-			pr_warn("prog '%s': failed to find program symbol\n",
-				prog->section_name);
-			return -EINVAL;
-		}
+		err =3D bpf_program__init(prog, name, sec_idx, sec_name, sec_off,
+					data + sec_off, prog_sz);
+		if (err)
+			return err;
=20
-		prog->name =3D strdup(name);
-		if (!prog->name)
-			return -ENOMEM;
+		nr_progs++;
+		obj->nr_programs =3D nr_progs;
+
+		sec_off +=3D prog_sz;
 	}
=20
 	return 0;
@@ -2675,6 +2693,26 @@ static Elf_Data *elf_sec_data(const struct bpf_obj=
ect *obj, Elf_Scn *scn)
 	return data;
 }
=20
+static int elf_sym_by_sec_off(const struct bpf_object *obj, size_t sec_i=
dx,
+			      size_t off, __u32 sym_type, GElf_Sym *sym)
+{
+	Elf_Data *symbols =3D obj->efile.symbols;
+	size_t n =3D symbols->d_size / sizeof(GElf_Sym);
+	int i;
+
+	for (i =3D 0; i < n; i++) {
+		if (!gelf_getsym(symbols, i, sym))
+			continue;
+		if (sym->st_shndx !=3D sec_idx || sym->st_value !=3D off)
+			continue;
+		if (GELF_ST_TYPE(sym->st_info) !=3D sym_type)
+			continue;
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
 static bool is_sec_name_dwarf(const char *name)
 {
 	/* approximation, but the actual list is too long */
@@ -2795,9 +2833,7 @@ static int bpf_object__elf_collect(struct bpf_objec=
t *obj)
 			if (sh.sh_flags & SHF_EXECINSTR) {
 				if (strcmp(name, ".text") =3D=3D 0)
 					obj->efile.text_shndx =3D idx;
-				err =3D bpf_object__add_program(obj, data->d_buf,
-							      data->d_size,
-							      name, idx);
+				err =3D bpf_object__add_programs(obj, data, name, idx);
 				if (err)
 					return err;
 			} else if (strcmp(name, DATA_SEC) =3D=3D 0) {
@@ -3183,7 +3219,7 @@ bpf_object__find_prog_by_idx(struct bpf_object *obj=
, int idx)
=20
 	for (i =3D 0; i < obj->nr_programs; i++) {
 		prog =3D &obj->programs[i];
-		if (prog->idx =3D=3D idx)
+		if (prog->sec_idx =3D=3D idx)
 			return prog;
 	}
 	return NULL;
@@ -5660,7 +5696,7 @@ bpf_program__reloc_text(struct bpf_program *prog, s=
truct bpf_object *obj,
 	size_t new_cnt;
 	int err;
=20
-	if (prog->idx !=3D obj->efile.text_shndx && prog->main_prog_cnt =3D=3D =
0) {
+	if (prog->sec_idx !=3D obj->efile.text_shndx && prog->main_prog_cnt =3D=
=3D 0) {
 		text =3D bpf_object__find_prog_by_idx(obj, obj->efile.text_shndx);
 		if (!text) {
 			pr_warn("no .text section found yet relo into text exist\n");
@@ -5783,7 +5819,7 @@ bpf_object__relocate(struct bpf_object *obj, const =
char *targ_btf_path)
 	 */
 	for (i =3D 0; i < obj->nr_programs; i++) {
 		prog =3D &obj->programs[i];
-		if (prog->idx !=3D obj->efile.text_shndx)
+		if (prog->sec_idx !=3D obj->efile.text_shndx)
 			continue;
=20
 		err =3D bpf_program__relocate(prog, obj);
@@ -5799,7 +5835,7 @@ bpf_object__relocate(struct bpf_object *obj, const =
char *targ_btf_path)
 	 */
 	for (i =3D 0; i < obj->nr_programs; i++) {
 		prog =3D &obj->programs[i];
-		if (prog->idx =3D=3D obj->efile.text_shndx)
+		if (prog->sec_idx =3D=3D obj->efile.text_shndx)
 			continue;
=20
 		err =3D bpf_program__relocate(prog, obj);
@@ -6215,7 +6251,7 @@ int bpf_program__load(struct bpf_program *prog, cha=
r *license, __u32 kern_ver)
 static bool bpf_program__is_function_storage(const struct bpf_program *p=
rog,
 					     const struct bpf_object *obj)
 {
-	return prog->idx =3D=3D obj->efile.text_shndx && obj->has_pseudo_calls;
+	return prog->sec_idx =3D=3D obj->efile.text_shndx && obj->has_pseudo_ca=
lls;
 }
=20
 static int
@@ -6298,7 +6334,6 @@ __bpf_object__open(const char *path, const void *ob=
j_buf, size_t obj_buf_sz,
 	err =3D err ? : bpf_object__collect_externs(obj);
 	err =3D err ? : bpf_object__finalize_btf(obj);
 	err =3D err ? : bpf_object__init_maps(obj, opts);
-	err =3D err ? : bpf_object__init_prog_names(obj);
 	err =3D err ? : bpf_object__collect_reloc(obj);
 	if (err)
 		goto out;
--=20
2.24.1

