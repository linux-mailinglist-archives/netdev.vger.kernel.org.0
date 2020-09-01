Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B139E258558
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 03:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgIABuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 21:50:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27614 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726293AbgIABuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 21:50:21 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0811oFQm015023
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=b5+j4AywLfgBgU48tGTgsN5TLsQcLao5q30GLQ6l0ys=;
 b=bwuKWF9IW2PAV2Gpmx2pjH32YM2lys4+TPl6bBf7uA/dv8ZArnj1Ks6NaJjEkTQk88dW
 kwN7J7TQBDZ/1iRIuCC7xFDplk08pKYbuBxAcGTkv6u4cR438/zE87viZHvmEAO/s6t3
 uckjgY1hmuKjHgjKZg+snwqua+lok0luCUQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 337jh03bdd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:17 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 18:50:15 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DD3922EC663B; Mon, 31 Aug 2020 18:50:13 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v2 bpf-next 04/14] libbpf: make RELO_CALL work for multi-prog sections and sub-program calls
Date:   Mon, 31 Aug 2020 18:49:53 -0700
Message-ID: <20200901015003.2871861-5-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200901015003.2871861-1-andriin@fb.com>
References: <20200901015003.2871861-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_01:2020-08-31,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 phishscore=0 suspectscore=25 impostorscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010014
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements general and correct logic for bpf-to-bpf sub-progra=
m
calls. Only sub-programs used (called into) from entry-point (main) BPF
program are going to be appended at the end of main BPF program. This ens=
ures
that BPF verifier won't encounter any dead code due to copying unreferenc=
ed
sub-program. This change means that each entry-point (main) BPF program m=
ight
have a different set of sub-programs appended to it and potentially in
different order. This has implications on how sub-program call relocation=
s
need to be handled, described below.

All relocations are now split into two categores: data references (maps a=
nd
global variables) and code references (sub-program calls). This distincti=
on is
important because data references need to be relocated just once per each=
 BPF
program and sub-program. These relocation are agnostic to instruction
locations, because they are not code-relative and they are relocating aga=
inst
static targets (maps, variables with fixes offsets, etc).

Sub-program RELO_CALL relocations, on the other hand, are highly-dependen=
t on
code position, because they are recorded as instruction-relative offset. =
So
BPF sub-programs (those that do calls into other sub-programs) can't be
relocated once, they need to be relocated each time such a sub-program is
appended at the end of the main entry-point BPF program. As mentioned abo=
ve,
each main BPF program might have different subset and differen order of
sub-programs, so call relocations can't be done just once. Splitting data
reference and calls relocations as described above allows to do this
efficiently and cleanly.

bpf_object__find_program_by_name() will now ignore non-entry BPF programs=
.
Previously one could have looked up '.text' fake BPF program, but the
existence of such BPF program was always an implementation detail and you
can't do much useful with it. Now, though, all non-entry sub-programs get
their own BPF program with name corresponding to a function name, so ther=
e is
no more '.text' name for BPF program. This means there is no regression,
effectively, w.r.t.  API behavior. But this is important aspect to highli=
ght,
because it's going to be critical once libbpf implements static linking o=
f BPF
programs. Non-entry static BPF programs will be allowed to have conflicti=
ng
names, but global and main-entry BPF program names should be unique. Just=
 like
with normal user-space linking process. So it's important to restrict thi=
s
aspect right now, keep static and non-entry functions as internal
implementation details, and not have to deal with regressions in behavior
later.

This patch leaves .BTF.ext adjustment as is until next patch.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 429 ++++++++++++++++++++++++++++-------------
 1 file changed, 291 insertions(+), 138 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 11ad230ec20c..172e47707f5d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -193,6 +193,7 @@ struct reloc_desc {
 	int insn_idx;
 	int map_idx;
 	int sym_off;
+	bool processed;
 };
=20
 struct bpf_sec_def;
@@ -255,7 +256,7 @@ struct bpf_program {
 	 * entry-point BPF programs this includes the size of main program
 	 * itself plus all the used sub-programs, appended at the end
 	 */
-	size_t insns_cnt, main_prog_cnt;
+	size_t insns_cnt;
=20
 	struct reloc_desc *reloc_desc;
 	int nr_reloc;
@@ -412,7 +413,7 @@ struct bpf_object {
 	int kconfig_map_idx;
=20
 	bool loaded;
-	bool has_pseudo_calls;
+	bool has_subcalls;
=20
 	/*
 	 * Information when doing elf related work. Only valid if fd
@@ -537,17 +538,32 @@ static char *__bpf_program__pin_name(struct bpf_pro=
gram *prog)
 	return name;
 }
=20
+static bool insn_is_subprog_call(const struct bpf_insn *insn)
+{
+	return BPF_CLASS(insn->code) =3D=3D BPF_JMP &&
+	       BPF_OP(insn->code) =3D=3D BPF_CALL &&
+	       BPF_SRC(insn->code) =3D=3D BPF_K &&
+	       insn->src_reg =3D=3D BPF_PSEUDO_CALL &&
+	       insn->dst_reg =3D=3D 0 &&
+	       insn->off =3D=3D 0;
+}
+
 static int
-bpf_program__init(struct bpf_program *prog, const char *name,
-		  size_t sec_idx, const char *sec_name, size_t sec_off,
-		  void *insn_data, size_t insn_data_sz)
+bpf_object__init_prog(struct bpf_object *obj, struct bpf_program *prog,
+		      const char *name, size_t sec_idx, const char *sec_name,
+		      size_t sec_off, void *insn_data, size_t insn_data_sz)
 {
+	int i;
+
 	if (insn_data_sz =3D=3D 0 || insn_data_sz % BPF_INSN_SZ || sec_off % BP=
F_INSN_SZ) {
 		pr_warn("sec '%s': corrupted program '%s', offset %zu, size %zu\n",
 			sec_name, name, sec_off, insn_data_sz);
 		return -EINVAL;
 	}
=20
+	memset(prog, 0, sizeof(*prog));
+	prog->obj =3D obj;
+
 	prog->sec_idx =3D sec_idx;
 	prog->sec_insn_off =3D sec_off / BPF_INSN_SZ;
 	prog->sec_insn_cnt =3D insn_data_sz / BPF_INSN_SZ;
@@ -577,6 +593,13 @@ bpf_program__init(struct bpf_program *prog, const ch=
ar *name,
 		goto errout;
 	memcpy(prog->insns, insn_data, insn_data_sz);
=20
+	for (i =3D 0; i < prog->insns_cnt; i++) {
+		if (insn_is_subprog_call(&prog->insns[i])) {
+			obj->has_subcalls =3D true;
+			break;
+		}
+	}
+
 	return 0;
 errout:
 	pr_warn("sec '%s': failed to allocate memory for prog '%s'\n", sec_name=
, name);
@@ -621,10 +644,10 @@ bpf_object__add_programs(struct bpf_object *obj, El=
f_Data *sec_data,
 			return -LIBBPF_ERRNO__FORMAT;
 		}
=20
-		pr_debug("sec '%s': found program '%s' at offset %zu, code size %zu by=
tes\n",
-			 sec_name, name, sec_off, prog_sz);
+		pr_debug("sec '%s': found program '%s' at insn offset %zu (%zu bytes),=
 code size %zu insns (%zu bytes)\n",
+			 sec_name, name, sec_off / BPF_INSN_SZ, sec_off, prog_sz / BPF_INSN_S=
Z, prog_sz);
=20
-		progs =3D reallocarray(progs, nr_progs + 1, sizeof(*progs));
+		progs =3D libbpf_reallocarray(progs, nr_progs + 1, sizeof(*progs));
 		if (!progs) {
 			/*
 			 * In this case the original obj->programs
@@ -638,11 +661,9 @@ bpf_object__add_programs(struct bpf_object *obj, Elf=
_Data *sec_data,
 		obj->programs =3D progs;
=20
 		prog =3D &progs[nr_progs];
-		memset(prog, 0, sizeof(*prog));
-		prog->obj =3D obj;
=20
-		err =3D bpf_program__init(prog, name, sec_idx, sec_name, sec_off,
-					data + sec_off, prog_sz);
+		err =3D bpf_object__init_prog(obj, prog, name, sec_idx, sec_name,
+					    sec_off, data + sec_off, prog_sz);
 		if (err)
 			return err;
=20
@@ -3255,6 +3276,12 @@ bpf_object__find_program_by_title(const struct bpf=
_object *obj,
 	return NULL;
 }
=20
+static bool prog_is_subprog(const struct bpf_object *obj,
+			    const struct bpf_program *prog)
+{
+	return prog->sec_idx =3D=3D obj->efile.text_shndx && obj->has_subcalls;
+}
+
 struct bpf_program *
 bpf_object__find_program_by_name(const struct bpf_object *obj,
 				 const char *name)
@@ -3262,6 +3289,8 @@ bpf_object__find_program_by_name(const struct bpf_o=
bject *obj,
 	struct bpf_program *prog;
=20
 	bpf_object__for_each_program(prog, obj) {
+		if (prog_is_subprog(obj, prog))
+			continue;
 		if (!strcmp(prog->name, name))
 			return prog;
 	}
@@ -3311,6 +3340,8 @@ static int bpf_program__record_reloc(struct bpf_pro=
gram *prog,
 	const char *sym_sec_name;
 	struct bpf_map *map;
=20
+	reloc_desc->processed =3D false;
+
 	/* sub-program call relocation */
 	if (insn->code =3D=3D (BPF_JMP | BPF_CALL)) {
 		if (insn->src_reg !=3D BPF_PSEUDO_CALL) {
@@ -3332,7 +3363,6 @@ static int bpf_program__record_reloc(struct bpf_pro=
gram *prog,
 		reloc_desc->type =3D RELO_CALL;
 		reloc_desc->insn_idx =3D insn_idx;
 		reloc_desc->sym_off =3D sym->st_value;
-		obj->has_pseudo_calls =3D true;
 		return 0;
 	}
=20
@@ -3464,13 +3494,18 @@ static struct bpf_program *find_prog_by_sec_insn(=
const struct bpf_object *obj,
 }
=20
 static int
-bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
-			   Elf_Data *data, struct bpf_object *obj)
+bpf_object__collect_prog_relos(struct bpf_object *obj, GElf_Shdr *shdr, =
Elf_Data *data)
 {
 	Elf_Data *symbols =3D obj->efile.symbols;
 	const char *relo_sec_name, *sec_name;
 	size_t sec_idx =3D shdr->sh_info;
+	struct bpf_program *prog;
+	struct reloc_desc *relos;
 	int err, i, nrels;
+	const char *sym_name;
+	__u32 insn_idx;
+	GElf_Sym sym;
+	GElf_Rel rel;
=20
 	relo_sec_name =3D elf_sec_str(obj, shdr->sh_name);
 	sec_name =3D elf_sec_name(obj, elf_sec_by_idx(obj, sec_idx));
@@ -3481,19 +3516,7 @@ bpf_program__collect_reloc(struct bpf_program *pro=
g, GElf_Shdr *shdr,
 		 relo_sec_name, sec_idx, sec_name);
 	nrels =3D shdr->sh_size / shdr->sh_entsize;
=20
-	prog->reloc_desc =3D malloc(sizeof(*prog->reloc_desc) * nrels);
-	if (!prog->reloc_desc) {
-		pr_warn("failed to alloc memory in relocation\n");
-		return -ENOMEM;
-	}
-	prog->nr_reloc =3D nrels;
-
 	for (i =3D 0; i < nrels; i++) {
-		const char *sym_name;
-		__u32 insn_idx;
-		GElf_Sym sym;
-		GElf_Rel rel;
-
 		if (!gelf_getrel(data, i, &rel)) {
 			pr_warn("sec '%s': failed to get relo #%d\n", relo_sec_name, i);
 			return -LIBBPF_ERRNO__FORMAT;
@@ -3510,15 +3533,42 @@ bpf_program__collect_reloc(struct bpf_program *pr=
og, GElf_Shdr *shdr,
 		}
=20
 		insn_idx =3D rel.r_offset / BPF_INSN_SZ;
-		sym_name =3D elf_sym_str(obj, sym.st_name) ?: "<?>";
+		/* relocations against static functions are recorded as
+		 * relocations against the section that contains a function;
+		 * in such case, symbol will be STT_SECTION and sym.st_name
+		 * will point to empty string (0), so fetch section name
+		 * instead
+		 */
+		if (GELF_ST_TYPE(sym.st_info) =3D=3D STT_SECTION && sym.st_name =3D=3D=
 0)
+			sym_name =3D elf_sec_name(obj, elf_sec_by_idx(obj, sym.st_shndx));
+		else
+			sym_name =3D elf_sym_str(obj, sym.st_name);
+		sym_name =3D sym_name ?: "<?";
=20
 		pr_debug("sec '%s': relo #%d: insn #%u against '%s'\n",
 			 relo_sec_name, i, insn_idx, sym_name);
=20
-		err =3D bpf_program__record_reloc(prog, &prog->reloc_desc[i],
+		prog =3D find_prog_by_sec_insn(obj, sec_idx, insn_idx);
+		if (!prog) {
+			pr_warn("sec '%s': relo #%d: program not found in section '%s' for in=
sn #%u\n",
+				relo_sec_name, i, sec_name, insn_idx);
+			return -LIBBPF_ERRNO__RELOC;
+		}
+
+		relos =3D libbpf_reallocarray(prog->reloc_desc,
+					    prog->nr_reloc + 1, sizeof(*relos));
+		if (!relos)
+			return -ENOMEM;
+		prog->reloc_desc =3D relos;
+
+		/* adjust insn_idx to local BPF program frame of reference */
+		insn_idx -=3D prog->sec_insn_off;
+		err =3D bpf_program__record_reloc(prog, &relos[prog->nr_reloc],
 						insn_idx, sym_name, &sym, &rel);
 		if (err)
 			return err;
+
+		prog->nr_reloc++;
 	}
 	return 0;
 }
@@ -5753,89 +5803,32 @@ bpf_object__relocate_core(struct bpf_object *obj,=
 const char *targ_btf_path)
 	return err;
 }
=20
+/* Relocate data references within program code:
+ *  - map references;
+ *  - global variable references;
+ *  - extern references.
+ */
 static int
-bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj=
,
-			struct reloc_desc *relo)
-{
-	struct bpf_insn *insn, *new_insn;
-	struct bpf_program *text;
-	size_t new_cnt;
-	int err;
-
-	if (prog->sec_idx !=3D obj->efile.text_shndx && prog->main_prog_cnt =3D=
=3D 0) {
-		text =3D bpf_object__find_prog_by_idx(obj, obj->efile.text_shndx);
-		if (!text) {
-			pr_warn("no .text section found yet relo into text exist\n");
-			return -LIBBPF_ERRNO__RELOC;
-		}
-		new_cnt =3D prog->insns_cnt + text->insns_cnt;
-		new_insn =3D libbpf_reallocarray(prog->insns, new_cnt, sizeof(*insn));
-		if (!new_insn) {
-			pr_warn("oom in prog realloc\n");
-			return -ENOMEM;
-		}
-		prog->insns =3D new_insn;
-
-		if (obj->btf_ext) {
-			err =3D bpf_program_reloc_btf_ext(prog, obj,
-							text->section_name,
-							prog->insns_cnt);
-			if (err)
-				return err;
-		}
-
-		memcpy(new_insn + prog->insns_cnt, text->insns,
-		       text->insns_cnt * sizeof(*insn));
-		prog->main_prog_cnt =3D prog->insns_cnt;
-		prog->insns_cnt =3D new_cnt;
-		pr_debug("added %zd insn from %s to prog %s\n",
-			 text->insns_cnt, text->section_name,
-			 prog->section_name);
-	}
-
-	insn =3D &prog->insns[relo->insn_idx];
-	insn->imm +=3D relo->sym_off / 8 + prog->main_prog_cnt - relo->insn_idx=
;
-	return 0;
-}
-
-static int
-bpf_program__relocate(struct bpf_program *prog, struct bpf_object *obj)
+bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *pr=
og)
 {
-	int i, err;
-
-	if (!prog)
-		return 0;
-
-	if (obj->btf_ext) {
-		err =3D bpf_program_reloc_btf_ext(prog, obj,
-						prog->section_name, 0);
-		if (err)
-			return err;
-	}
-
-	if (!prog->reloc_desc)
-		return 0;
+	int i;
=20
 	for (i =3D 0; i < prog->nr_reloc; i++) {
 		struct reloc_desc *relo =3D &prog->reloc_desc[i];
 		struct bpf_insn *insn =3D &prog->insns[relo->insn_idx];
 		struct extern_desc *ext;
=20
-		if (relo->insn_idx + 1 >=3D (int)prog->insns_cnt) {
-			pr_warn("relocation out of range: '%s'\n",
-				prog->section_name);
-			return -LIBBPF_ERRNO__RELOC;
-		}
-
 		switch (relo->type) {
 		case RELO_LD64:
 			insn[0].src_reg =3D BPF_PSEUDO_MAP_FD;
 			insn[0].imm =3D obj->maps[relo->map_idx].fd;
+			relo->processed =3D true;
 			break;
 		case RELO_DATA:
 			insn[0].src_reg =3D BPF_PSEUDO_MAP_VALUE;
 			insn[1].imm =3D insn[0].imm + relo->sym_off;
 			insn[0].imm =3D obj->maps[relo->map_idx].fd;
+			relo->processed =3D true;
 			break;
 		case RELO_EXTERN:
 			ext =3D &obj->externs[relo->sym_off];
@@ -5847,11 +5840,10 @@ bpf_program__relocate(struct bpf_program *prog, s=
truct bpf_object *obj)
 				insn[0].imm =3D (__u32)ext->ksym.addr;
 				insn[1].imm =3D ext->ksym.addr >> 32;
 			}
+			relo->processed =3D true;
 			break;
 		case RELO_CALL:
-			err =3D bpf_program__reloc_text(prog, obj, relo);
-			if (err)
-				return err;
+			/* will be handled as a follow up pass */
 			break;
 		default:
 			pr_warn("prog '%s': relo #%d: bad relo type %d\n",
@@ -5860,8 +5852,155 @@ bpf_program__relocate(struct bpf_program *prog, s=
truct bpf_object *obj)
 		}
 	}
=20
-	zfree(&prog->reloc_desc);
-	prog->nr_reloc =3D 0;
+	return 0;
+}
+
+static int cmp_relo_by_insn_idx(const void *key, const void *elem)
+{
+	size_t insn_idx =3D *(const size_t *)key;
+	const struct reloc_desc *relo =3D elem;
+
+	if (insn_idx =3D=3D relo->insn_idx)
+		return 0;
+	return insn_idx < relo->insn_idx ? -1 : 1;
+}
+
+static struct reloc_desc *find_prog_insn_relo(const struct bpf_program *=
prog, size_t insn_idx)
+{
+	return bsearch(&insn_idx, prog->reloc_desc, prog->nr_reloc,
+		       sizeof(*prog->reloc_desc), cmp_relo_by_insn_idx);
+}
+
+static int
+bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_=
prog,
+		       struct bpf_program *prog)
+{
+	size_t sub_insn_idx, insn_idx, new_cnt;
+	struct bpf_program *subprog;
+	struct bpf_insn *insns, *insn;
+	struct reloc_desc *relo;
+	int err;
+
+	err =3D reloc_prog_func_and_line_info(obj, main_prog, prog);
+	if (err)
+		return err;
+
+	for (insn_idx =3D 0; insn_idx < prog->sec_insn_cnt; insn_idx++) {
+		insn =3D &main_prog->insns[prog->sub_insn_off + insn_idx];
+		if (!insn_is_subprog_call(insn))
+			continue;
+
+		relo =3D find_prog_insn_relo(prog, insn_idx);
+		if (relo && relo->type !=3D RELO_CALL) {
+			pr_warn("prog '%s': unexpected relo for insn #%zu, type %d\n",
+				prog->name, insn_idx, relo->type);
+			return -LIBBPF_ERRNO__RELOC;
+		}
+		if (relo) {
+			/* sub-program instruction index is a combination of
+			 * an offset of a symbol pointed to by relocation and
+			 * call instruction's imm field; for global functions,
+			 * call always has imm =3D -1, but for static functions
+			 * relocation is against STT_SECTION and insn->imm
+			 * points to a start of a static function
+			 */
+			sub_insn_idx =3D relo->sym_off / BPF_INSN_SZ + insn->imm + 1;
+		} else {
+			/* if subprogram call is to a static function within
+			 * the same ELF section, there won't be any relocation
+			 * emitted, but it also means there is no additional
+			 * offset necessary, insns->imm is relative to
+			 * instruction's original position within the section
+			 */
+			sub_insn_idx =3D prog->sec_insn_off + insn_idx + insn->imm + 1;
+		}
+
+		/* we enforce that sub-programs should be in .text section */
+		subprog =3D find_prog_by_sec_insn(obj, obj->efile.text_shndx, sub_insn=
_idx);
+		if (!subprog) {
+			pr_warn("prog '%s': no .text section found yet sub-program call exist=
s\n",
+				prog->name);
+			return -LIBBPF_ERRNO__RELOC;
+		}
+
+		/* if subprogram hasn't been used in current main program,
+		 * relocate it and append at the end of main program code
+		 */
+		if (subprog->sub_insn_off =3D=3D 0) {
+			subprog->sub_insn_off =3D main_prog->insns_cnt;
+
+			new_cnt =3D main_prog->insns_cnt + subprog->insns_cnt;
+			insns =3D libbpf_reallocarray(main_prog->insns, new_cnt, sizeof(*insn=
s));
+			if (!insns) {
+				pr_warn("prog '%s': failed to realloc prog code\n", main_prog->name)=
;
+				return -ENOMEM;
+			}
+			main_prog->insns =3D insns;
+			main_prog->insns_cnt =3D new_cnt;
+
+			memcpy(main_prog->insns + subprog->sub_insn_off, subprog->insns,
+			       subprog->insns_cnt * sizeof(*insns));
+
+			pr_debug("prog '%s': added %zu insns from sub-prog '%s'\n",
+				 main_prog->name, subprog->insns_cnt, subprog->name);
+
+			err =3D bpf_object__reloc_code(obj, main_prog, subprog);
+			if (err)
+				return err;
+		}
+
+		/* main_prog->insns memory could have been re-allocated, so
+		 * calculate pointer again
+		 */
+		insn =3D &main_prog->insns[prog->sub_insn_off + insn_idx];
+		/* calculate correct instruction position within main prog */
+		insn->imm =3D subprog->sub_insn_off - (prog->sub_insn_off + insn_idx) =
- 1;
+
+		if (relo)
+			relo->processed =3D true;
+
+		pr_debug("prog '%s': insn #%zu relocated, imm %d points to subprog '%s=
' (now at %zu offset)\n",
+			 prog->name, insn_idx, insn->imm, subprog->name, subprog->sub_insn_of=
f);
+	}
+
+	return 0;
+}
+
+/*
+ * Relocate sub-program calls
+ */
+static int
+bpf_object__relocate_calls(struct bpf_object *obj, struct bpf_program *p=
rog)
+{
+	struct bpf_program *subprog;
+	int i, j, err;
+
+	if (obj->btf_ext) {
+		err =3D bpf_program_reloc_btf_ext(prog, obj,
+						prog->section_name, 0);
+		if (err)
+			return err;
+	}
+
+	/* mark all subprogs as not relocated (yet) within the context of
+	 * current main program
+	 */
+	for (i =3D 0; i < obj->nr_programs; i++) {
+		subprog =3D &obj->programs[i];
+		if (!prog_is_subprog(obj, subprog))
+			continue;
+
+		subprog->sub_insn_off =3D 0;
+		for (j =3D 0; j < subprog->nr_reloc; j++)
+			if (subprog->reloc_desc[j].type =3D=3D RELO_CALL)
+				subprog->reloc_desc[j].processed =3D false;
+	}
+
+	err =3D bpf_object__reloc_code(obj, prog, prog);
+	if (err)
+		return err;
+
+
 	return 0;
 }
=20
@@ -5880,37 +6019,45 @@ bpf_object__relocate(struct bpf_object *obj, cons=
t char *targ_btf_path)
 			return err;
 		}
 	}
-	/* ensure .text is relocated first, as it's going to be copied as-is
-	 * later for sub-program calls
+	/* relocate data references first for all programs and sub-programs,
+	 * as they don't change relative to code locations, so subsequent
+	 * subprogram processing won't need to re-calculate any of them
 	 */
 	for (i =3D 0; i < obj->nr_programs; i++) {
 		prog =3D &obj->programs[i];
-		if (prog->sec_idx !=3D obj->efile.text_shndx)
-			continue;
-
-		err =3D bpf_program__relocate(prog, obj);
+		err =3D bpf_object__relocate_data(obj, prog);
 		if (err) {
 			pr_warn("prog '%s': failed to relocate data references: %d\n",
 				prog->name, err);
 			return err;
 		}
-		break;
 	}
-	/* now relocate everything but .text, which by now is relocated
-	 * properly, so we can copy raw sub-program instructions as is safely
+	/* now relocate subprogram calls and append used subprograms to main
+	 * programs; each copy of subprogram code needs to be relocated
+	 * differently for each main program, because its code location might
+	 * have changed
 	 */
 	for (i =3D 0; i < obj->nr_programs; i++) {
 		prog =3D &obj->programs[i];
-		if (prog->sec_idx =3D=3D obj->efile.text_shndx)
+		/* sub-program's sub-calls are relocated within the context of
+		 * its main program only
+		 */
+		if (prog_is_subprog(obj, prog))
 			continue;
=20
-		err =3D bpf_program__relocate(prog, obj);
+		err =3D bpf_object__relocate_calls(obj, prog);
 		if (err) {
 			pr_warn("prog '%s': failed to relocate calls: %d\n",
 				prog->name, err);
 			return err;
 		}
 	}
+	/* free up relocation descriptors */
+	for (i =3D 0; i < obj->nr_programs; i++) {
+		prog =3D &obj->programs[i];
+		zfree(&prog->reloc_desc);
+		prog->nr_reloc =3D 0;
+	}
 	return 0;
 }
=20
@@ -6030,41 +6177,53 @@ static int bpf_object__collect_map_relos(struct b=
pf_object *obj,
 	return 0;
 }
=20
-static int bpf_object__collect_reloc(struct bpf_object *obj)
+static int cmp_relocs(const void *_a, const void *_b)
 {
-	int i, err;
+	const struct reloc_desc *a =3D _a;
+	const struct reloc_desc *b =3D _b;
=20
-	if (!obj_elf_valid(obj)) {
-		pr_warn("Internal error: elf object is closed\n");
-		return -LIBBPF_ERRNO__INTERNAL;
-	}
+	if (a->insn_idx !=3D b->insn_idx)
+		return a->insn_idx < b->insn_idx ? -1 : 1;
+
+	/* no two relocations should have the same insn_idx, but ... */
+	if (a->type !=3D b->type)
+		return a->type < b->type ? -1 : 1;
+
+	return 0;
+}
+
+static int bpf_object__collect_relos(struct bpf_object *obj)
+{
+	int i, err;
=20
 	for (i =3D 0; i < obj->efile.nr_reloc_sects; i++) {
 		GElf_Shdr *shdr =3D &obj->efile.reloc_sects[i].shdr;
 		Elf_Data *data =3D obj->efile.reloc_sects[i].data;
 		int idx =3D shdr->sh_info;
-		struct bpf_program *prog;
=20
 		if (shdr->sh_type !=3D SHT_REL) {
 			pr_warn("internal error at %d\n", __LINE__);
 			return -LIBBPF_ERRNO__INTERNAL;
 		}
=20
-		if (idx =3D=3D obj->efile.st_ops_shndx) {
+		if (idx =3D=3D obj->efile.st_ops_shndx)
 			err =3D bpf_object__collect_st_ops_relos(obj, shdr, data);
-		} else if (idx =3D=3D obj->efile.btf_maps_shndx) {
+		else if (idx =3D=3D obj->efile.btf_maps_shndx)
 			err =3D bpf_object__collect_map_relos(obj, shdr, data);
-		} else {
-			prog =3D bpf_object__find_prog_by_idx(obj, idx);
-			if (!prog) {
-				pr_warn("relocation failed: no prog in section(%d)\n", idx);
-				return -LIBBPF_ERRNO__RELOC;
-			}
-			err =3D bpf_program__collect_reloc(prog, shdr, data, obj);
-		}
+		else
+			err =3D bpf_object__collect_prog_relos(obj, shdr, data);
 		if (err)
 			return err;
 	}
+
+	for (i =3D 0; i < obj->nr_programs; i++) {
+		struct bpf_program *p =3D &obj->programs[i];
+	=09
+		if (!p->nr_reloc)
+			continue;
+
+		qsort(p->reloc_desc, p->nr_reloc, sizeof(*p->reloc_desc), cmp_relocs);
+	}
 	return 0;
 }
=20
@@ -6314,12 +6473,6 @@ int bpf_program__load(struct bpf_program *prog, ch=
ar *license, __u32 kern_ver)
 	return err;
 }
=20
-static bool bpf_program__is_function_storage(const struct bpf_program *p=
rog,
-					     const struct bpf_object *obj)
-{
-	return prog->sec_idx =3D=3D obj->efile.text_shndx && obj->has_pseudo_ca=
lls;
-}
-
 static int
 bpf_object__load_progs(struct bpf_object *obj, int log_level)
 {
@@ -6336,7 +6489,7 @@ bpf_object__load_progs(struct bpf_object *obj, int =
log_level)
=20
 	for (i =3D 0; i < obj->nr_programs; i++) {
 		prog =3D &obj->programs[i];
-		if (bpf_program__is_function_storage(prog, obj))
+		if (prog_is_subprog(obj, prog))
 			continue;
 		if (!prog->load) {
 			pr_debug("prog '%s': skipped loading\n", prog->name);
@@ -6400,7 +6553,7 @@ __bpf_object__open(const char *path, const void *ob=
j_buf, size_t obj_buf_sz,
 	err =3D err ? : bpf_object__collect_externs(obj);
 	err =3D err ? : bpf_object__finalize_btf(obj);
 	err =3D err ? : bpf_object__init_maps(obj, opts);
-	err =3D err ? : bpf_object__collect_reloc(obj);
+	err =3D err ? : bpf_object__collect_relos(obj);
 	if (err)
 		goto out;
 	bpf_object__elf_finish(obj);
@@ -7404,7 +7557,7 @@ bpf_program__next(struct bpf_program *prev, const s=
truct bpf_object *obj)
=20
 	do {
 		prog =3D __bpf_program__iter(prog, obj, true);
-	} while (prog && bpf_program__is_function_storage(prog, obj));
+	} while (prog && prog_is_subprog(obj, prog));
=20
 	return prog;
 }
@@ -7416,7 +7569,7 @@ bpf_program__prev(struct bpf_program *next, const s=
truct bpf_object *obj)
=20
 	do {
 		prog =3D __bpf_program__iter(prog, obj, false);
-	} while (prog && bpf_program__is_function_storage(prog, obj));
+	} while (prog && prog_is_subprog(obj, prog));
=20
 	return prog;
 }
--=20
2.24.1

