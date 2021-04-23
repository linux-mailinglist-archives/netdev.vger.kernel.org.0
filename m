Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AB23698EC
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243442AbhDWSPE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 14:15:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13648 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243329AbhDWSOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:14:51 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NI8Bmk026692
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:14 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 383kvnmm7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:14 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:14:13 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 937882ED5CB8; Fri, 23 Apr 2021 11:14:07 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH v3 bpf-next 07/18] libbpf: factor out symtab and relos sanity checks
Date:   Fri, 23 Apr 2021 11:13:37 -0700
Message-ID: <20210423181348.1801389-8-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423181348.1801389-1-andrii@kernel.org>
References: <20210423181348.1801389-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: _TRiHJFQoBmSOQq_iwMx0oyDXCCjjM7v
X-Proofpoint-ORIG-GUID: _TRiHJFQoBmSOQq_iwMx0oyDXCCjjM7v
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104230120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out logic for sanity checking SHT_SYMTAB and SHT_REL sections into
separate sections. They are already quite extensive and are suffering from too
deep indentation. Subsequent changes will extend SYMTAB sanity checking
further, so it's better to factor each into a separate function.

No functional changes are intended.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/linker.c | 233 ++++++++++++++++++++++-------------------
 1 file changed, 127 insertions(+), 106 deletions(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 4e08bc07e635..0bb927226370 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -131,6 +131,8 @@ static int init_output_elf(struct bpf_linker *linker, const char *file);
 
 static int linker_load_obj_file(struct bpf_linker *linker, const char *filename, struct src_obj *obj);
 static int linker_sanity_check_elf(struct src_obj *obj);
+static int linker_sanity_check_elf_symtab(struct src_obj *obj, struct src_sec *sec);
+static int linker_sanity_check_elf_relos(struct src_obj *obj, struct src_sec *sec);
 static int linker_sanity_check_btf(struct src_obj *obj);
 static int linker_sanity_check_btf_ext(struct src_obj *obj);
 static int linker_fixup_btf(struct src_obj *obj);
@@ -663,8 +665,8 @@ static bool is_pow_of_2(size_t x)
 
 static int linker_sanity_check_elf(struct src_obj *obj)
 {
-	struct src_sec *sec, *link_sec;
-	int i, j, n;
+	struct src_sec *sec;
+	int i, err;
 
 	if (!obj->symtab_sec_idx) {
 		pr_warn("ELF is missing SYMTAB section in %s\n", obj->filename);
@@ -692,43 +694,11 @@ static int linker_sanity_check_elf(struct src_obj *obj)
 			return -EINVAL;
 
 		switch (sec->shdr->sh_type) {
-		case SHT_SYMTAB: {
-			Elf64_Sym *sym;
-
-			if (sec->shdr->sh_entsize != sizeof(Elf64_Sym))
-				return -EINVAL;
-			if (sec->shdr->sh_size % sec->shdr->sh_entsize != 0)
-				return -EINVAL;
-
-			if (!sec->shdr->sh_link || sec->shdr->sh_link >= obj->sec_cnt) {
-				pr_warn("ELF SYMTAB section #%zu points to missing STRTAB section #%zu in %s\n",
-					sec->sec_idx, (size_t)sec->shdr->sh_link, obj->filename);
-				return -EINVAL;
-			}
-			link_sec = &obj->secs[sec->shdr->sh_link];
-			if (link_sec->shdr->sh_type != SHT_STRTAB) {
-				pr_warn("ELF SYMTAB section #%zu points to invalid STRTAB section #%zu in %s\n",
-					sec->sec_idx, (size_t)sec->shdr->sh_link, obj->filename);
-				return -EINVAL;
-			}
-
-			n = sec->shdr->sh_size / sec->shdr->sh_entsize;
-			sym = sec->data->d_buf;
-			for (j = 0; j < n; j++, sym++) {
-				if (sym->st_shndx
-				    && sym->st_shndx < SHN_LORESERVE
-				    && sym->st_shndx >= obj->sec_cnt) {
-					pr_warn("ELF sym #%d in section #%zu points to missing section #%zu in %s\n",
-						j, sec->sec_idx, (size_t)sym->st_shndx, obj->filename);
-					return -EINVAL;
-				}
-				if (ELF64_ST_TYPE(sym->st_info) == STT_SECTION) {
-					if (sym->st_value != 0)
-						return -EINVAL;
-				}
-			}
+		case SHT_SYMTAB:
+			err = linker_sanity_check_elf_symtab(obj, sec);
+			if (err)
+				return err;
 			break;
-		}
 		case SHT_STRTAB:
 			break;
 		case SHT_PROGBITS:
@@ -739,87 +709,138 @@ static int linker_sanity_check_elf(struct src_obj *obj)
 			break;
 		case SHT_NOBITS:
 			break;
-		case SHT_REL: {
-			Elf64_Rel *relo;
-			struct src_sec *sym_sec;
+		case SHT_REL:
+			err = linker_sanity_check_elf_relos(obj, sec);
+			if (err)
+				return err;
+			break;
+		case SHT_LLVM_ADDRSIG:
+			break;
+		default:
+			pr_warn("ELF section #%zu (%s) has unrecognized type %zu in %s\n",
+				sec->sec_idx, sec->sec_name, (size_t)sec->shdr->sh_type, obj->filename);
+			return -EINVAL;
+		}
+	}
 
-			if (sec->shdr->sh_entsize != sizeof(Elf64_Rel))
-				return -EINVAL;
-			if (sec->shdr->sh_size % sec->shdr->sh_entsize != 0)
-				return -EINVAL;
+	return 0;
+}
 
-			/* SHT_REL's sh_link should point to SYMTAB */
-			if (sec->shdr->sh_link != obj->symtab_sec_idx) {
-				pr_warn("ELF relo section #%zu points to invalid SYMTAB section #%zu in %s\n",
-					sec->sec_idx, (size_t)sec->shdr->sh_link, obj->filename);
-				return -EINVAL;
-			}
+static int linker_sanity_check_elf_symtab(struct src_obj *obj, struct src_sec *sec)
+{
+	struct src_sec *link_sec;
+	Elf64_Sym *sym;
+	int i, n;
 
-			/* SHT_REL's sh_info points to relocated section */
-			if (!sec->shdr->sh_info || sec->shdr->sh_info >= obj->sec_cnt) {
-				pr_warn("ELF relo section #%zu points to missing section #%zu in %s\n",
-					sec->sec_idx, (size_t)sec->shdr->sh_info, obj->filename);
-				return -EINVAL;
-			}
-			link_sec = &obj->secs[sec->shdr->sh_info];
+	if (sec->shdr->sh_entsize != sizeof(Elf64_Sym))
+		return -EINVAL;
+	if (sec->shdr->sh_size % sec->shdr->sh_entsize != 0)
+		return -EINVAL;
+
+	if (!sec->shdr->sh_link || sec->shdr->sh_link >= obj->sec_cnt) {
+		pr_warn("ELF SYMTAB section #%zu points to missing STRTAB section #%zu in %s\n",
+			sec->sec_idx, (size_t)sec->shdr->sh_link, obj->filename);
+		return -EINVAL;
+	}
+	link_sec = &obj->secs[sec->shdr->sh_link];
+	if (link_sec->shdr->sh_type != SHT_STRTAB) {
+		pr_warn("ELF SYMTAB section #%zu points to invalid STRTAB section #%zu in %s\n",
+			sec->sec_idx, (size_t)sec->shdr->sh_link, obj->filename);
+		return -EINVAL;
+	}
 
-			/* .rel<secname> -> <secname> pattern is followed */
-			if (strncmp(sec->sec_name, ".rel", sizeof(".rel") - 1) != 0
-			    || strcmp(sec->sec_name + sizeof(".rel") - 1, link_sec->sec_name) != 0) {
-				pr_warn("ELF relo section #%zu name has invalid name in %s\n",
-					sec->sec_idx, obj->filename);
+	n = sec->shdr->sh_size / sec->shdr->sh_entsize;
+	sym = sec->data->d_buf;
+	for (i = 0; i < n; i++, sym++) {
+		if (sym->st_shndx
+		    && sym->st_shndx < SHN_LORESERVE
+		    && sym->st_shndx >= obj->sec_cnt) {
+			pr_warn("ELF sym #%d in section #%zu points to missing section #%zu in %s\n",
+				i, sec->sec_idx, (size_t)sym->st_shndx, obj->filename);
+			return -EINVAL;
+		}
+		if (ELF64_ST_TYPE(sym->st_info) == STT_SECTION) {
+			if (sym->st_value != 0)
 				return -EINVAL;
-			}
+			continue;
+		}
+	}
 
-			/* don't further validate relocations for ignored sections */
-			if (link_sec->skipped)
-				break;
+	return 0;
+}
 
-			/* relocatable section is data or instructions */
-			if (link_sec->shdr->sh_type != SHT_PROGBITS
-			    && link_sec->shdr->sh_type != SHT_NOBITS) {
-				pr_warn("ELF relo section #%zu points to invalid section #%zu in %s\n",
-					sec->sec_idx, (size_t)sec->shdr->sh_info, obj->filename);
-				return -EINVAL;
-			}
+static int linker_sanity_check_elf_relos(struct src_obj *obj, struct src_sec *sec)
+{
+	struct src_sec *link_sec, *sym_sec;
+	Elf64_Rel *relo;
+	int i, n;
 
-			/* check sanity of each relocation */
-			n = sec->shdr->sh_size / sec->shdr->sh_entsize;
-			relo = sec->data->d_buf;
-			sym_sec = &obj->secs[obj->symtab_sec_idx];
-			for (j = 0; j < n; j++, relo++) {
-				size_t sym_idx = ELF64_R_SYM(relo->r_info);
-				size_t sym_type = ELF64_R_TYPE(relo->r_info);
-
-				if (sym_type != R_BPF_64_64 && sym_type != R_BPF_64_32) {
-					pr_warn("ELF relo #%d in section #%zu has unexpected type %zu in %s\n",
-						j, sec->sec_idx, sym_type, obj->filename);
-					return -EINVAL;
-				}
+	if (sec->shdr->sh_entsize != sizeof(Elf64_Rel))
+		return -EINVAL;
+	if (sec->shdr->sh_size % sec->shdr->sh_entsize != 0)
+		return -EINVAL;
 
-				if (!sym_idx || sym_idx * sizeof(Elf64_Sym) >= sym_sec->shdr->sh_size) {
-					pr_warn("ELF relo #%d in section #%zu points to invalid symbol #%zu in %s\n",
-						j, sec->sec_idx, sym_idx, obj->filename);
-					return -EINVAL;
-				}
+	/* SHT_REL's sh_link should point to SYMTAB */
+	if (sec->shdr->sh_link != obj->symtab_sec_idx) {
+		pr_warn("ELF relo section #%zu points to invalid SYMTAB section #%zu in %s\n",
+			sec->sec_idx, (size_t)sec->shdr->sh_link, obj->filename);
+		return -EINVAL;
+	}
 
-				if (link_sec->shdr->sh_flags & SHF_EXECINSTR) {
-					if (relo->r_offset % sizeof(struct bpf_insn) != 0) {
-						pr_warn("ELF relo #%d in section #%zu points to missing symbol #%zu in %s\n",
-							j, sec->sec_idx, sym_idx, obj->filename);
-						return -EINVAL;
-					}
-				}
-			}
-			break;
+	/* SHT_REL's sh_info points to relocated section */
+	if (!sec->shdr->sh_info || sec->shdr->sh_info >= obj->sec_cnt) {
+		pr_warn("ELF relo section #%zu points to missing section #%zu in %s\n",
+			sec->sec_idx, (size_t)sec->shdr->sh_info, obj->filename);
+		return -EINVAL;
+	}
+	link_sec = &obj->secs[sec->shdr->sh_info];
+
+	/* .rel<secname> -> <secname> pattern is followed */
+	if (strncmp(sec->sec_name, ".rel", sizeof(".rel") - 1) != 0
+	    || strcmp(sec->sec_name + sizeof(".rel") - 1, link_sec->sec_name) != 0) {
+		pr_warn("ELF relo section #%zu name has invalid name in %s\n",
+			sec->sec_idx, obj->filename);
+		return -EINVAL;
+	}
+
+	/* don't further validate relocations for ignored sections */
+	if (link_sec->skipped)
+		return 0;
+
+	/* relocatable section is data or instructions */
+	if (link_sec->shdr->sh_type != SHT_PROGBITS && link_sec->shdr->sh_type != SHT_NOBITS) {
+		pr_warn("ELF relo section #%zu points to invalid section #%zu in %s\n",
+			sec->sec_idx, (size_t)sec->shdr->sh_info, obj->filename);
+		return -EINVAL;
+	}
+
+	/* check sanity of each relocation */
+	n = sec->shdr->sh_size / sec->shdr->sh_entsize;
+	relo = sec->data->d_buf;
+	sym_sec = &obj->secs[obj->symtab_sec_idx];
+	for (i = 0; i < n; i++, relo++) {
+		size_t sym_idx = ELF64_R_SYM(relo->r_info);
+		size_t sym_type = ELF64_R_TYPE(relo->r_info);
+
+		if (sym_type != R_BPF_64_64 && sym_type != R_BPF_64_32) {
+			pr_warn("ELF relo #%d in section #%zu has unexpected type %zu in %s\n",
+				i, sec->sec_idx, sym_type, obj->filename);
+			return -EINVAL;
 		}
-		case SHT_LLVM_ADDRSIG:
-			break;
-		default:
-			pr_warn("ELF section #%zu (%s) has unrecognized type %zu in %s\n",
-				sec->sec_idx, sec->sec_name, (size_t)sec->shdr->sh_type, obj->filename);
+
+		if (!sym_idx || sym_idx * sizeof(Elf64_Sym) >= sym_sec->shdr->sh_size) {
+			pr_warn("ELF relo #%d in section #%zu points to invalid symbol #%zu in %s\n",
+				i, sec->sec_idx, sym_idx, obj->filename);
 			return -EINVAL;
 		}
+
+		if (link_sec->shdr->sh_flags & SHF_EXECINSTR) {
+			if (relo->r_offset % sizeof(struct bpf_insn) != 0) {
+				pr_warn("ELF relo #%d in section #%zu points to missing symbol #%zu in %s\n",
+					i, sec->sec_idx, sym_idx, obj->filename);
+				return -EINVAL;
+			}
+		}
 	}
 
 	return 0;
-- 
2.30.2

