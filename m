Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D7824C84B
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbgHTXNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:13:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49178 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728745AbgHTXNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:13:16 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07KN8PZp019107
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:13:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Gfhl1jPEeFSWkoO+mupIPDFY3uv0v+8TiZB4nyE5ehQ=;
 b=W2pqatSNP5ygspRhjdq4BWcmXoFDSelH6qTutLLPlP+j7kmtX3KiAZbbfyfbDyYwAtW+
 A14Z/3/sqh3jJwBV8pk8lBFYNrdtM3g/tQE7AHFjw7Bb/hbV28+9nnayTH6k0JKhXOG5
 ScQTkytiQB5MvktVVmUNAP/TCciFz69XbYE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3304jjh7gy-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:13:13 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 16:13:11 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 033DC2EC5F42; Thu, 20 Aug 2020 16:13:02 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 05/16] libbpf: normalize and improve logging across few functions
Date:   Thu, 20 Aug 2020 16:12:39 -0700
Message-ID: <20200820231250.1293069-6-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200820231250.1293069-1-andriin@fb.com>
References: <20200820231250.1293069-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_07:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make libbpf logs follow similar pattern and provide more context like sec=
tion
name or program name, where appropriate. Also, add BPF_INSN_SZ constant a=
nd
use it throughout to clean up code a little bit. This commit doesn't have=
 any
functional changes and just removes some code changes out of the way befo=
re
bigger refactoring in libbpf internals.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 117 +++++++++++++++++++++++------------------
 1 file changed, 67 insertions(+), 50 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a7318e5a312b..5a53cc9c1327 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -63,6 +63,8 @@
 #define BPF_FS_MAGIC		0xcafe4a11
 #endif
=20
+#define BPF_INSN_SZ (sizeof(struct bpf_insn))
+
 /* vsprintf() in __base_pr() uses nonliteral format string. It may break
  * compilation if user enables corresponding warning. Disable it explici=
tly.
  */
@@ -3225,7 +3227,7 @@ bpf_object__section_to_libbpf_map_type(const struct=
 bpf_object *obj, int shndx)
=20
 static int bpf_program__record_reloc(struct bpf_program *prog,
 				     struct reloc_desc *reloc_desc,
-				     __u32 insn_idx, const char *name,
+				     __u32 insn_idx, const char *sym_name,
 				     const GElf_Sym *sym, const GElf_Rel *rel)
 {
 	struct bpf_insn *insn =3D &prog->insns[insn_idx];
@@ -3233,22 +3235,25 @@ static int bpf_program__record_reloc(struct bpf_p=
rogram *prog,
 	struct bpf_object *obj =3D prog->obj;
 	__u32 shdr_idx =3D sym->st_shndx;
 	enum libbpf_map_type type;
+	const char *sym_sec_name;
 	struct bpf_map *map;
=20
 	/* sub-program call relocation */
 	if (insn->code =3D=3D (BPF_JMP | BPF_CALL)) {
 		if (insn->src_reg !=3D BPF_PSEUDO_CALL) {
-			pr_warn("incorrect bpf_call opcode\n");
+			pr_warn("prog '%s': incorrect bpf_call opcode\n", prog->name);
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		/* text_shndx can be 0, if no default "main" program exists */
 		if (!shdr_idx || shdr_idx !=3D obj->efile.text_shndx) {
-			pr_warn("bad call relo against section %u\n", shdr_idx);
+			sym_sec_name =3D elf_sec_name(obj, elf_sec_by_idx(obj, shdr_idx));
+			pr_warn("prog '%s': bad call relo against '%s' in section '%s'\n",
+				prog->name, sym_name, sym_sec_name);
 			return -LIBBPF_ERRNO__RELOC;
 		}
-		if (sym->st_value % 8) {
-			pr_warn("bad call relo offset: %zu\n",
-				(size_t)sym->st_value);
+		if (sym->st_value % BPF_INSN_SZ) {
+			pr_warn("prog '%s': bad call relo against '%s' at offset %zu\n",
+				prog->name, sym_name, (size_t)sym->st_value);
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		reloc_desc->type =3D RELO_CALL;
@@ -3259,8 +3264,8 @@ static int bpf_program__record_reloc(struct bpf_pro=
gram *prog,
 	}
=20
 	if (insn->code !=3D (BPF_LD | BPF_IMM | BPF_DW)) {
-		pr_warn("invalid relo for insns[%d].code 0x%x\n",
-			insn_idx, insn->code);
+		pr_warn("prog '%s': invalid relo against '%s' for insns[%d].code 0x%x\=
n",
+			prog->name, sym_name, insn_idx, insn->code);
 		return -LIBBPF_ERRNO__RELOC;
 	}
=20
@@ -3275,12 +3280,12 @@ static int bpf_program__record_reloc(struct bpf_p=
rogram *prog,
 				break;
 		}
 		if (i >=3D n) {
-			pr_warn("extern relo failed to find extern for sym %d\n",
-				sym_idx);
+			pr_warn("prog '%s': extern relo failed to find extern for '%s' (%d)\n=
",
+				prog->name, sym_name, sym_idx);
 			return -LIBBPF_ERRNO__RELOC;
 		}
-		pr_debug("found extern #%d '%s' (sym %d) for insn %u\n",
-			 i, ext->name, ext->sym_idx, insn_idx);
+		pr_debug("prog '%s': found extern #%d '%s' (sym %d) for insn #%u\n",
+			 prog->name, i, ext->name, ext->sym_idx, insn_idx);
 		reloc_desc->type =3D RELO_EXTERN;
 		reloc_desc->insn_idx =3D insn_idx;
 		reloc_desc->sym_off =3D i; /* sym_off stores extern index */
@@ -3288,18 +3293,19 @@ static int bpf_program__record_reloc(struct bpf_p=
rogram *prog,
 	}
=20
 	if (!shdr_idx || shdr_idx >=3D SHN_LORESERVE) {
-		pr_warn("invalid relo for \'%s\' in special section 0x%x; forgot to in=
itialize global var?..\n",
-			name, shdr_idx);
+		pr_warn("prog '%s': invalid relo against '%s' in special section 0x%x;=
 forgot to initialize global var?..\n",
+			prog->name, sym_name, shdr_idx);
 		return -LIBBPF_ERRNO__RELOC;
 	}
=20
 	type =3D bpf_object__section_to_libbpf_map_type(obj, shdr_idx);
+	sym_sec_name =3D elf_sec_name(obj, elf_sec_by_idx(obj, shdr_idx));
=20
 	/* generic map reference relocation */
 	if (type =3D=3D LIBBPF_MAP_UNSPEC) {
 		if (!bpf_object__shndx_is_maps(obj, shdr_idx)) {
-			pr_warn("bad map relo against section %u\n",
-				shdr_idx);
+			pr_warn("prog '%s': bad map relo against '%s' in section '%s'\n",
+				prog->name, sym_name, sym_sec_name);
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		for (map_idx =3D 0; map_idx < nr_maps; map_idx++) {
@@ -3308,14 +3314,14 @@ static int bpf_program__record_reloc(struct bpf_p=
rogram *prog,
 			    map->sec_idx !=3D sym->st_shndx ||
 			    map->sec_offset !=3D sym->st_value)
 				continue;
-			pr_debug("found map %zd (%s, sec %d, off %zu) for insn %u\n",
-				 map_idx, map->name, map->sec_idx,
+			pr_debug("prog '%s': found map %zd (%s, sec %d, off %zu) for insn #%u=
\n",
+				 prog->name, map_idx, map->name, map->sec_idx,
 				 map->sec_offset, insn_idx);
 			break;
 		}
 		if (map_idx >=3D nr_maps) {
-			pr_warn("map relo failed to find map for sec %u, off %zu\n",
-				shdr_idx, (size_t)sym->st_value);
+			pr_warn("prog '%s': map relo failed to find map for section '%s', off=
 %zu\n",
+				prog->name, sym_sec_name, (size_t)sym->st_value);
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		reloc_desc->type =3D RELO_LD64;
@@ -3327,21 +3333,22 @@ static int bpf_program__record_reloc(struct bpf_p=
rogram *prog,
=20
 	/* global data map relocation */
 	if (!bpf_object__shndx_is_data(obj, shdr_idx)) {
-		pr_warn("bad data relo against section %u\n", shdr_idx);
+		pr_warn("prog '%s': bad data relo against section '%s'\n",
+			prog->name, sym_sec_name);
 		return -LIBBPF_ERRNO__RELOC;
 	}
 	for (map_idx =3D 0; map_idx < nr_maps; map_idx++) {
 		map =3D &obj->maps[map_idx];
 		if (map->libbpf_type !=3D type)
 			continue;
-		pr_debug("found data map %zd (%s, sec %d, off %zu) for insn %u\n",
-			 map_idx, map->name, map->sec_idx, map->sec_offset,
-			 insn_idx);
+		pr_debug("prog '%s': found data map %zd (%s, sec %d, off %zu) for insn=
 %u\n",
+			 prog->name, map_idx, map->name, map->sec_idx,
+			 map->sec_offset, insn_idx);
 		break;
 	}
 	if (map_idx >=3D nr_maps) {
-		pr_warn("data relo failed to find map for sec %u\n",
-			shdr_idx);
+		pr_warn("prog '%s': data relo failed to find map for section '%s'\n",
+			prog->name, sym_sec_name);
 		return -LIBBPF_ERRNO__RELOC;
 	}
=20
@@ -3357,9 +3364,17 @@ bpf_program__collect_reloc(struct bpf_program *pro=
g, GElf_Shdr *shdr,
 			   Elf_Data *data, struct bpf_object *obj)
 {
 	Elf_Data *symbols =3D obj->efile.symbols;
+	const char *relo_sec_name, *sec_name;
+	size_t sec_idx =3D shdr->sh_info;
 	int err, i, nrels;
=20
-	pr_debug("collecting relocating info for: '%s'\n", prog->section_name);
+	relo_sec_name =3D elf_sec_str(obj, shdr->sh_name);
+	sec_name =3D elf_sec_name(obj, elf_sec_by_idx(obj, sec_idx));
+	if (!relo_sec_name || !sec_name)
+		return -EINVAL;
+
+	pr_debug("sec '%s': collecting relocation for section(%zu) '%s'\n",
+		 relo_sec_name, sec_idx, sec_name);
 	nrels =3D shdr->sh_size / shdr->sh_entsize;
=20
 	prog->reloc_desc =3D malloc(sizeof(*prog->reloc_desc) * nrels);
@@ -3370,34 +3385,34 @@ bpf_program__collect_reloc(struct bpf_program *pr=
og, GElf_Shdr *shdr,
 	prog->nr_reloc =3D nrels;
=20
 	for (i =3D 0; i < nrels; i++) {
-		const char *name;
+		const char *sym_name;
 		__u32 insn_idx;
 		GElf_Sym sym;
 		GElf_Rel rel;
=20
 		if (!gelf_getrel(data, i, &rel)) {
-			pr_warn("relocation: failed to get %d reloc\n", i);
+			pr_warn("sec '%s': failed to get relo #%d\n", relo_sec_name, i);
 			return -LIBBPF_ERRNO__FORMAT;
 		}
 		if (!gelf_getsym(symbols, GELF_R_SYM(rel.r_info), &sym)) {
-			pr_warn("relocation: symbol %zx not found\n",
-				(size_t)GELF_R_SYM(rel.r_info));
+			pr_warn("sec '%s': symbol 0x%zx not found for relo #%d\n",
+				relo_sec_name, (size_t)GELF_R_SYM(rel.r_info), i);
 			return -LIBBPF_ERRNO__FORMAT;
 		}
-		if (rel.r_offset % sizeof(struct bpf_insn))
+		if (rel.r_offset % BPF_INSN_SZ) {
+			pr_warn("sec '%s': invalid offset 0x%zx for relo #%d\n",
+				relo_sec_name, (size_t)GELF_R_SYM(rel.r_info), i);
 			return -LIBBPF_ERRNO__FORMAT;
+		}
=20
-		insn_idx =3D rel.r_offset / sizeof(struct bpf_insn);
-		name =3D elf_sym_str(obj, sym.st_name) ?: "<?>";
+		insn_idx =3D rel.r_offset / BPF_INSN_SZ;
+		sym_name =3D elf_sym_str(obj, sym.st_name) ?: "<?>";
=20
-		pr_debug("relo for shdr %u, symb %zu, value %zu, type %d, bind %d, nam=
e %d (\'%s\'), insn %u\n",
-			 (__u32)sym.st_shndx, (size_t)GELF_R_SYM(rel.r_info),
-			 (size_t)sym.st_value, GELF_ST_TYPE(sym.st_info),
-			 GELF_ST_BIND(sym.st_info), sym.st_name, name,
-			 insn_idx);
+		pr_debug("sec '%s': relo #%d: insn #%u against '%s'\n",
+			 relo_sec_name, i, insn_idx, sym_name);
=20
 		err =3D bpf_program__record_reloc(prog, &prog->reloc_desc[i],
-						insn_idx, name, &sym, &rel);
+						insn_idx, sym_name, &sym, &rel);
 		if (err)
 			return err;
 	}
@@ -5155,9 +5170,9 @@ static int bpf_core_patch_insn(struct bpf_program *=
prog,
 	int insn_idx;
 	__u8 class;
=20
-	if (relo->insn_off % sizeof(struct bpf_insn))
+	if (relo->insn_off % BPF_INSN_SZ)
 		return -EINVAL;
-	insn_idx =3D relo->insn_off / sizeof(struct bpf_insn);
+	insn_idx =3D relo->insn_off / BPF_INSN_SZ;
 	insn =3D &prog->insns[insn_idx];
 	class =3D BPF_CLASS(insn->code);
=20
@@ -5588,7 +5603,7 @@ bpf_object__relocate_core(struct bpf_object *obj, c=
onst char *targ_btf_path)
 			goto out;
 		}
=20
-		pr_debug("prog '%s': performing %d CO-RE offset relocs\n",
+		pr_debug("sec '%s': found %d CO-RE relocations\n",
 			 sec_name, sec->num_info);
=20
 		for_each_btf_ext_rec(seg, sec, i, rec) {
@@ -5596,7 +5611,7 @@ bpf_object__relocate_core(struct bpf_object *obj, c=
onst char *targ_btf_path)
 						  targ_btf, cand_cache);
 			if (err) {
 				pr_warn("prog '%s': relo #%d: failed to relocate: %d\n",
-					sec_name, i, err);
+					prog->name, i, err);
 				goto out;
 			}
 		}
@@ -5716,7 +5731,8 @@ bpf_program__relocate(struct bpf_program *prog, str=
uct bpf_object *obj)
 				return err;
 			break;
 		default:
-			pr_warn("relo #%d: bad relo type %d\n", i, relo->type);
+			pr_warn("prog '%s': relo #%d: bad relo type %d\n",
+				prog->name, i, relo->type);
 			return -EINVAL;
 		}
 	}
@@ -5751,7 +5767,8 @@ bpf_object__relocate(struct bpf_object *obj, const =
char *targ_btf_path)
=20
 		err =3D bpf_program__relocate(prog, obj);
 		if (err) {
-			pr_warn("failed to relocate '%s'\n", prog->section_name);
+			pr_warn("prog '%s': failed to relocate data references: %d\n",
+				prog->name, err);
 			return err;
 		}
 		break;
@@ -5766,7 +5783,8 @@ bpf_object__relocate(struct bpf_object *obj, const =
char *targ_btf_path)
=20
 		err =3D bpf_program__relocate(prog, obj);
 		if (err) {
-			pr_warn("failed to relocate '%s'\n", prog->section_name);
+			pr_warn("prog '%s': failed to relocate calls: %d\n",
+				prog->name, err);
 			return err;
 		}
 	}
@@ -6198,8 +6216,7 @@ bpf_object__load_progs(struct bpf_object *obj, int =
log_level)
 		if (bpf_program__is_function_storage(prog, obj))
 			continue;
 		if (!prog->load) {
-			pr_debug("prog '%s'('%s'): skipped loading\n",
-				 prog->name, prog->section_name);
+			pr_debug("prog '%s': skipped loading\n", prog->name);
 			continue;
 		}
 		prog->log_level |=3D log_level;
@@ -7343,7 +7360,7 @@ int bpf_program__fd(const struct bpf_program *prog)
=20
 size_t bpf_program__size(const struct bpf_program *prog)
 {
-	return prog->insns_cnt * sizeof(struct bpf_insn);
+	return prog->insns_cnt * BPF_INSN_SZ;
 }
=20
 int bpf_program__set_prep(struct bpf_program *prog, int nr_instances,
--=20
2.24.1

