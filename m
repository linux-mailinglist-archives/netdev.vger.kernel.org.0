Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B57CFF835
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 08:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfKQHIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 02:08:45 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40540 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726082AbfKQHIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 02:08:44 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAH78cm0021871
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 23:08:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=ix5lmy8WJQeAcLdmcIpct5xEIOetvgvIztnVLcKJLe0=;
 b=NGVFZLd8U2TXHgpVxP64HXjUxPvWMMB2wIGjDld5xPH8MqUPZHkpR2ukciy2SjgYIO2P
 8V3rWBrWe3+B5C7FEIG/NLv3v2OjypNXz1FMGUIHYR9WjpYE+RiyH9KJnChFfLEo4s31
 E3x38kdKGZVxkO+rIle31w2zzMp9RFeH9Xk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2waftjsfwu-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 23:08:41 -0800
Received: from 2401:db00:2120:81ca:face:0:31:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 16 Nov 2019 23:08:16 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E8FC82EC19AE; Sat, 16 Nov 2019 23:08:15 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/6] libbpf: refactor relocation handling
Date:   Sat, 16 Nov 2019 23:08:03 -0800
Message-ID: <20191117070807.251360-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191117070807.251360-1-andriin@fb.com>
References: <20191117070807.251360-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-17_01:2019-11-15,2019-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=958 clxscore=1015 mlxscore=0 spamscore=0 impostorscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911170067
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Relocation handling code is convoluted and unnecessarily deeply nested. Split
out per-relocation logic into separate function. Also refactor the logic to be
more a sequence of per-relocation type checks and processing steps, making it
simpler to follow control flow. This makes it easier to further extends it to
new kinds of relocations (e.g., support for extern variables).

This patch also makes relocation's section verification more robust.
Previously relocations against not yet supported externs were silently ignored
because of obj->efile.text_shndx was zero, when all BPF programs had custom
section names and there was no .text section. Also, invalid LDIMM64 relocations
against non-map sections were passed through, if they were pointing to a .text
section (or 0, which is invalid section). All these bugs are fixed within this
refactoring and checks are made more appropriate for each type of relocation.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 256 ++++++++++++++++++++++-------------------
 1 file changed, 140 insertions(+), 116 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 15e91a1d6c11..0fdca01f7e57 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -276,8 +276,8 @@ struct bpf_object {
 		struct {
 			GElf_Shdr shdr;
 			Elf_Data *data;
-		} *reloc;
-		int nr_reloc;
+		} *reloc_sects;
+		int nr_reloc_sects;
 		int maps_shndx;
 		int btf_maps_shndx;
 		int text_shndx;
@@ -575,8 +575,8 @@ static void bpf_object__elf_finish(struct bpf_object *obj)
 	obj->efile.rodata = NULL;
 	obj->efile.bss = NULL;
 
-	zfree(&obj->efile.reloc);
-	obj->efile.nr_reloc = 0;
+	zfree(&obj->efile.reloc_sects);
+	obj->efile.nr_reloc_sects = 0;
 	zclose(obj->efile.fd);
 	obj->efile.obj_buf = NULL;
 	obj->efile.obj_buf_sz = 0;
@@ -1693,8 +1693,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
 				pr_debug("skip section(%d) %s\n", idx, name);
 			}
 		} else if (sh.sh_type == SHT_REL) {
-			int nr_reloc = obj->efile.nr_reloc;
-			void *reloc = obj->efile.reloc;
+			int nr_sects = obj->efile.nr_reloc_sects;
+			void *sects = obj->efile.reloc_sects;
 			int sec = sh.sh_info; /* points to other section */
 
 			/* Only do relo for section with exec instructions */
@@ -1704,18 +1704,18 @@ static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
 				continue;
 			}
 
-			reloc = reallocarray(reloc, nr_reloc + 1,
-					     sizeof(*obj->efile.reloc));
-			if (!reloc) {
-				pr_warn("realloc failed\n");
+			sects = reallocarray(sects, nr_sects + 1,
+					     sizeof(*obj->efile.reloc_sects));
+			if (!sects) {
+				pr_warn("reloc_sects realloc failed\n");
 				return -ENOMEM;
 			}
 
-			obj->efile.reloc = reloc;
-			obj->efile.nr_reloc++;
+			obj->efile.reloc_sects = sects;
+			obj->efile.nr_reloc_sects++;
 
-			obj->efile.reloc[nr_reloc].shdr = sh;
-			obj->efile.reloc[nr_reloc].data = data;
+			obj->efile.reloc_sects[nr_sects].shdr = sh;
+			obj->efile.reloc_sects[nr_sects].data = data;
 		} else if (sh.sh_type == SHT_NOBITS && strcmp(name, ".bss") == 0) {
 			obj->efile.bss = data;
 			obj->efile.bss_shndx = idx;
@@ -1780,14 +1780,6 @@ static bool bpf_object__shndx_is_maps(const struct bpf_object *obj,
 	       shndx == obj->efile.btf_maps_shndx;
 }
 
-static bool bpf_object__relo_in_known_section(const struct bpf_object *obj,
-					      int shndx)
-{
-	return shndx == obj->efile.text_shndx ||
-	       bpf_object__shndx_is_maps(obj, shndx) ||
-	       bpf_object__shndx_is_data(obj, shndx);
-}
-
 static enum libbpf_map_type
 bpf_object__section_to_libbpf_map_type(const struct bpf_object *obj, int shndx)
 {
@@ -1801,14 +1793,120 @@ bpf_object__section_to_libbpf_map_type(const struct bpf_object *obj, int shndx)
 		return LIBBPF_MAP_UNSPEC;
 }
 
+static int bpf_program__record_reloc(struct bpf_program *prog,
+				     struct reloc_desc *reloc_desc,
+				     __u32 insn_idx, const char *name,
+				     const GElf_Sym *sym, const GElf_Rel *rel)
+{
+	struct bpf_insn *insn = &prog->insns[insn_idx];
+	size_t map_idx, nr_maps = prog->obj->nr_maps;
+	struct bpf_object *obj = prog->obj;
+	__u32 shdr_idx = sym->st_shndx;
+	enum libbpf_map_type type;
+	struct bpf_map *map;
+
+	/* sub-program call relocation */
+	if (insn->code == (BPF_JMP | BPF_CALL)) {
+		if (insn->src_reg != BPF_PSEUDO_CALL) {
+			pr_warn("incorrect bpf_call opcode\n");
+			return -LIBBPF_ERRNO__RELOC;
+		}
+		/* text_shndx can be 0, if no default "main" program exists */
+		if (!shdr_idx || shdr_idx != obj->efile.text_shndx) {
+			pr_warn("bad call relo against section %u\n", shdr_idx);
+			return -LIBBPF_ERRNO__RELOC;
+		}
+		reloc_desc->type = RELO_CALL;
+		reloc_desc->insn_idx = insn_idx;
+		reloc_desc->text_off = sym->st_value;
+		obj->has_pseudo_calls = true;
+		return 0;
+	}
+
+	if (insn->code != (BPF_LD | BPF_IMM | BPF_DW)) {
+		pr_warn("bpf: relocation: invalid relo for insns[%d].code 0x%x\n",
+			insn_idx, insn->code);
+		return -LIBBPF_ERRNO__RELOC;
+	}
+	if (!shdr_idx || shdr_idx >= SHN_LORESERVE) {
+		pr_warn("relocation: not yet supported relo for non-static global \'%s\' variable in special section (0x%x) found in insns[%d].code 0x%x\n",
+			name, shdr_idx, insn_idx, insn->code);
+		return -LIBBPF_ERRNO__RELOC;
+	}
+
+	type = bpf_object__section_to_libbpf_map_type(obj, shdr_idx);
+
+	/* generic map reference relocation */
+	if (type == LIBBPF_MAP_UNSPEC) {
+		if (!bpf_object__shndx_is_maps(obj, shdr_idx)) {
+			pr_warn("bad map relo against section %u\n",
+				shdr_idx);
+			return -LIBBPF_ERRNO__RELOC;
+		}
+		for (map_idx = 0; map_idx < nr_maps; map_idx++) {
+			map = &obj->maps[map_idx];
+			if (map->libbpf_type != type ||
+			    map->sec_idx != sym->st_shndx ||
+			    map->sec_offset != sym->st_value)
+				continue;
+			pr_debug("found map %zd (%s, sec %d, off %zu) for insn %u\n",
+				 map_idx, map->name, map->sec_idx,
+				 map->sec_offset, insn_idx);
+			break;
+		}
+		if (map_idx >= nr_maps) {
+			pr_warn("map relo failed to find map for sec %u, off %llu\n",
+				shdr_idx, (__u64)sym->st_value);
+			return -LIBBPF_ERRNO__RELOC;
+		}
+		reloc_desc->type = RELO_LD64;
+		reloc_desc->insn_idx = insn_idx;
+		reloc_desc->map_idx = map_idx;
+		return 0;
+	}
+
+	/* global data map relocation */
+	if (!bpf_object__shndx_is_data(obj, shdr_idx)) {
+		pr_warn("bad data relo against section %u\n", shdr_idx);
+		return -LIBBPF_ERRNO__RELOC;
+	}
+	if (GELF_ST_BIND(sym->st_info) == STB_GLOBAL) {
+		pr_warn("relocation: not yet supported relo for non-static global \'%s\' variable found in insns[%d].code 0x%x\n",
+			name, insn_idx, insn->code);
+		return -LIBBPF_ERRNO__RELOC;
+	}
+	if (!obj->caps.global_data) {
+		pr_warn("relocation: kernel does not support global \'%s\' variable access in insns[%d]\n",
+			name, insn_idx);
+		return -LIBBPF_ERRNO__RELOC;
+	}
+	for (map_idx = 0; map_idx < nr_maps; map_idx++) {
+		map = &obj->maps[map_idx];
+		if (map->libbpf_type != type)
+			continue;
+		pr_debug("found data map %zd (%s, sec %d, off %zu) for insn %u\n",
+			 map_idx, map->name, map->sec_idx, map->sec_offset,
+			 insn_idx);
+		break;
+	}
+	if (map_idx >= nr_maps) {
+		pr_warn("data relo failed to find map for sec %u\n",
+			shdr_idx);
+		return -LIBBPF_ERRNO__RELOC;
+	}
+
+	reloc_desc->type = RELO_DATA;
+	reloc_desc->insn_idx = insn_idx;
+	reloc_desc->map_idx = map_idx;
+	return 0;
+}
+
 static int
 bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
 			   Elf_Data *data, struct bpf_object *obj)
 {
 	Elf_Data *symbols = obj->efile.symbols;
-	struct bpf_map *maps = obj->maps;
-	size_t nr_maps = obj->nr_maps;
-	int i, nrels;
+	int err, i, nrels;
 
 	pr_debug("collecting relocating info for: '%s'\n", prog->section_name);
 	nrels = shdr->sh_size / shdr->sh_entsize;
@@ -1821,12 +1919,8 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
 	prog->nr_reloc = nrels;
 
 	for (i = 0; i < nrels; i++) {
-		struct bpf_insn *insns = prog->insns;
-		enum libbpf_map_type type;
-		unsigned int insn_idx;
-		unsigned int shdr_idx;
 		const char *name;
-		size_t map_idx;
+		__u32 insn_idx;
 		GElf_Sym sym;
 		GElf_Rel rel;
 
@@ -1834,97 +1928,27 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
 			pr_warn("relocation: failed to get %d reloc\n", i);
 			return -LIBBPF_ERRNO__FORMAT;
 		}
-
 		if (!gelf_getsym(symbols, GELF_R_SYM(rel.r_info), &sym)) {
 			pr_warn("relocation: symbol %"PRIx64" not found\n",
 				GELF_R_SYM(rel.r_info));
 			return -LIBBPF_ERRNO__FORMAT;
 		}
+		if (rel.r_offset % sizeof(struct bpf_insn))
+			return -LIBBPF_ERRNO__FORMAT;
 
+		insn_idx = rel.r_offset / sizeof(struct bpf_insn);
 		name = elf_strptr(obj->efile.elf, obj->efile.strtabidx,
 				  sym.st_name) ? : "<?>";
-
-		pr_debug("relo for %lld value %lld name %d (\'%s\')\n",
-			 (long long) (rel.r_info >> 32),
-			 (long long) sym.st_value, sym.st_name, name);
-
-		shdr_idx = sym.st_shndx;
-		insn_idx = rel.r_offset / sizeof(struct bpf_insn);
-		pr_debug("relocation: insn_idx=%u, shdr_idx=%u\n",
-			 insn_idx, shdr_idx);
-
-		if (shdr_idx >= SHN_LORESERVE) {
-			pr_warn("relocation: not yet supported relo for non-static global \'%s\' variable in special section (0x%x) found in insns[%d].code 0x%x\n",
-				name, shdr_idx, insn_idx,
-				insns[insn_idx].code);
-			return -LIBBPF_ERRNO__RELOC;
-		}
-		if (!bpf_object__relo_in_known_section(obj, shdr_idx)) {
-			pr_warn("Program '%s' contains unrecognized relo data pointing to section %u\n",
-				prog->section_name, shdr_idx);
-			return -LIBBPF_ERRNO__RELOC;
-		}
-
-		if (insns[insn_idx].code == (BPF_JMP | BPF_CALL)) {
-			if (insns[insn_idx].src_reg != BPF_PSEUDO_CALL) {
-				pr_warn("incorrect bpf_call opcode\n");
-				return -LIBBPF_ERRNO__RELOC;
-			}
-			prog->reloc_desc[i].type = RELO_CALL;
-			prog->reloc_desc[i].insn_idx = insn_idx;
-			prog->reloc_desc[i].text_off = sym.st_value;
-			obj->has_pseudo_calls = true;
-			continue;
-		}
-
-		if (insns[insn_idx].code != (BPF_LD | BPF_IMM | BPF_DW)) {
-			pr_warn("bpf: relocation: invalid relo for insns[%d].code 0x%x\n",
-				insn_idx, insns[insn_idx].code);
-			return -LIBBPF_ERRNO__RELOC;
-		}
-
-		if (bpf_object__shndx_is_maps(obj, shdr_idx) ||
-		    bpf_object__shndx_is_data(obj, shdr_idx)) {
-			type = bpf_object__section_to_libbpf_map_type(obj, shdr_idx);
-			if (type != LIBBPF_MAP_UNSPEC) {
-				if (GELF_ST_BIND(sym.st_info) == STB_GLOBAL) {
-					pr_warn("bpf: relocation: not yet supported relo for non-static global \'%s\' variable found in insns[%d].code 0x%x\n",
-						name, insn_idx, insns[insn_idx].code);
-					return -LIBBPF_ERRNO__RELOC;
-				}
-				if (!obj->caps.global_data) {
-					pr_warn("bpf: relocation: kernel does not support global \'%s\' variable access in insns[%d]\n",
-						name, insn_idx);
-					return -LIBBPF_ERRNO__RELOC;
-				}
-			}
-
-			for (map_idx = 0; map_idx < nr_maps; map_idx++) {
-				if (maps[map_idx].libbpf_type != type)
-					continue;
-				if (type != LIBBPF_MAP_UNSPEC ||
-				    (maps[map_idx].sec_idx == sym.st_shndx &&
-				     maps[map_idx].sec_offset == sym.st_value)) {
-					pr_debug("relocation: found map %zd (%s, sec_idx %d, offset %zu) for insn %u\n",
-						 map_idx, maps[map_idx].name,
-						 maps[map_idx].sec_idx,
-						 maps[map_idx].sec_offset,
-						 insn_idx);
-					break;
-				}
-			}
-
-			if (map_idx >= nr_maps) {
-				pr_warn("bpf relocation: map_idx %d larger than %d\n",
-					(int)map_idx, (int)nr_maps - 1);
-				return -LIBBPF_ERRNO__RELOC;
-			}
-
-			prog->reloc_desc[i].type = type != LIBBPF_MAP_UNSPEC ?
-						   RELO_DATA : RELO_LD64;
-			prog->reloc_desc[i].insn_idx = insn_idx;
-			prog->reloc_desc[i].map_idx = map_idx;
-		}
+		pr_debug("relo for shdr %u, symb %llu, value %llu, type %d, bind %d, name %d (\'%s\'), insn %u\n",
+			 (__u32)sym.st_shndx, (__u64)GELF_R_SYM(rel.r_info),
+			 (__u64)sym.st_value, GELF_ST_TYPE(sym.st_info),
+			 GELF_ST_BIND(sym.st_info), sym.st_name, name,
+			 insn_idx);
+
+		err = bpf_program__record_reloc(prog, &prog->reloc_desc[i],
+						insn_idx, name, &sym, &rel);
+		if (err)
+			return err;
 	}
 	return 0;
 }
@@ -3667,9 +3691,9 @@ static int bpf_object__collect_reloc(struct bpf_object *obj)
 		return -LIBBPF_ERRNO__INTERNAL;
 	}
 
-	for (i = 0; i < obj->efile.nr_reloc; i++) {
-		GElf_Shdr *shdr = &obj->efile.reloc[i].shdr;
-		Elf_Data *data = obj->efile.reloc[i].data;
+	for (i = 0; i < obj->efile.nr_reloc_sects; i++) {
+		GElf_Shdr *shdr = &obj->efile.reloc_sects[i].shdr;
+		Elf_Data *data = obj->efile.reloc_sects[i].data;
 		int idx = shdr->sh_info;
 		struct bpf_program *prog;
 
-- 
2.17.1

