Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2463698E7
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243552AbhDWSOu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 14:14:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4960 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243491AbhDWSOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:14:43 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13NID3QP024364
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:06 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3839vur80w-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:06 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:14:04 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id ED9FF2ED5CB8; Fri, 23 Apr 2021 11:14:01 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH v3 bpf-next 05/18] libbpf: allow gaps in BPF program sections to support overriden weak functions
Date:   Fri, 23 Apr 2021 11:13:35 -0700
Message-ID: <20210423181348.1801389-6-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423181348.1801389-1-andrii@kernel.org>
References: <20210423181348.1801389-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: TKCNve3Qm3JLgts6__uME_7Bi_oaniwG
X-Proofpoint-GUID: TKCNve3Qm3JLgts6__uME_7Bi_oaniwG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 suspectscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently libbpf is very strict about parsing BPF program instruction
sections. No gaps are allowed between sequential BPF programs within a given
ELF section. Libbpf enforced that by keeping track of the next section offset
that should start a new BPF (sub)program and cross-checks that by searching
for a corresponding STT_FUNC ELF symbol.

But this is too restrictive once we allow to have weak BPF programs and link
together two or more BPF object files. In such case, some weak BPF programs
might be "overridden" by either non-weak BPF program with the same name and
signature, or even by another weak BPF program that just happened to be linked
first. That, in turn, leaves BPF instructions of the "lost" BPF (sub)program
intact, but there is no corresponding ELF symbol, because no one is going to
be referencing it.

Libbpf already correctly handles such cases in the sense that it won't append
such dead code to actual BPF programs loaded into kernel. So the only change
that needs to be done is to relax the logic of parsing BPF instruction
sections. Instead of assuming next BPF (sub)program section offset, iterate
available STT_FUNC ELF symbols to discover all available BPF subprograms and
programs.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c | 58 ++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 36 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8bac9c7627aa..198d6e149beb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -502,8 +502,6 @@ static Elf_Scn *elf_sec_by_name(const struct bpf_object *obj, const char *name);
 static int elf_sec_hdr(const struct bpf_object *obj, Elf_Scn *scn, GElf_Shdr *hdr);
 static const char *elf_sec_name(const struct bpf_object *obj, Elf_Scn *scn);
 static Elf_Data *elf_sec_data(const struct bpf_object *obj, Elf_Scn *scn);
-static int elf_sym_by_sec_off(const struct bpf_object *obj, size_t sec_idx,
-			      size_t off, __u32 sym_type, GElf_Sym *sym);
 
 void bpf_program__unload(struct bpf_program *prog)
 {
@@ -644,25 +642,29 @@ static int
 bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
 			 const char *sec_name, int sec_idx)
 {
+	Elf_Data *symbols = obj->efile.symbols;
 	struct bpf_program *prog, *progs;
 	void *data = sec_data->d_buf;
-	size_t sec_sz = sec_data->d_size, sec_off, prog_sz;
-	int nr_progs, err;
+	size_t sec_sz = sec_data->d_size, sec_off, prog_sz, nr_syms;
+	int nr_progs, err, i;
 	const char *name;
 	GElf_Sym sym;
 
 	progs = obj->programs;
 	nr_progs = obj->nr_programs;
+	nr_syms = symbols->d_size / sizeof(GElf_Sym);
 	sec_off = 0;
 
-	while (sec_off < sec_sz) {
-		if (elf_sym_by_sec_off(obj, sec_idx, sec_off, STT_FUNC, &sym)) {
-			pr_warn("sec '%s': failed to find program symbol at offset %zu\n",
-				sec_name, sec_off);
-			return -LIBBPF_ERRNO__FORMAT;
-		}
+	for (i = 0; i < nr_syms; i++) {
+		if (!gelf_getsym(symbols, i, &sym))
+			continue;
+		if (sym.st_shndx != sec_idx)
+			continue;
+		if (GELF_ST_TYPE(sym.st_info) != STT_FUNC)
+			continue;
 
 		prog_sz = sym.st_size;
+		sec_off = sym.st_value;
 
 		name = elf_sym_str(obj, sym.st_name);
 		if (!name) {
@@ -711,8 +713,6 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
 
 		nr_progs++;
 		obj->nr_programs = nr_progs;
-
-		sec_off += prog_sz;
 	}
 
 	return 0;
@@ -2825,26 +2825,6 @@ static Elf_Data *elf_sec_data(const struct bpf_object *obj, Elf_Scn *scn)
 	return data;
 }
 
-static int elf_sym_by_sec_off(const struct bpf_object *obj, size_t sec_idx,
-			      size_t off, __u32 sym_type, GElf_Sym *sym)
-{
-	Elf_Data *symbols = obj->efile.symbols;
-	size_t n = symbols->d_size / sizeof(GElf_Sym);
-	int i;
-
-	for (i = 0; i < n; i++) {
-		if (!gelf_getsym(symbols, i, sym))
-			continue;
-		if (sym->st_shndx != sec_idx || sym->st_value != off)
-			continue;
-		if (GELF_ST_TYPE(sym->st_info) != sym_type)
-			continue;
-		return 0;
-	}
-
-	return -ENOENT;
-}
-
 static bool is_sec_name_dwarf(const char *name)
 {
 	/* approximation, but the actual list is too long */
@@ -3723,11 +3703,16 @@ bpf_object__collect_prog_relos(struct bpf_object *obj, GElf_Shdr *shdr, Elf_Data
 	int err, i, nrels;
 	const char *sym_name;
 	__u32 insn_idx;
+	Elf_Scn *scn;
+	Elf_Data *scn_data;
 	GElf_Sym sym;
 	GElf_Rel rel;
 
+	scn = elf_sec_by_idx(obj, sec_idx);
+	scn_data = elf_sec_data(obj, scn);
+
 	relo_sec_name = elf_sec_str(obj, shdr->sh_name);
-	sec_name = elf_sec_name(obj, elf_sec_by_idx(obj, sec_idx));
+	sec_name = elf_sec_name(obj, scn);
 	if (!relo_sec_name || !sec_name)
 		return -EINVAL;
 
@@ -3745,7 +3730,8 @@ bpf_object__collect_prog_relos(struct bpf_object *obj, GElf_Shdr *shdr, Elf_Data
 				relo_sec_name, (size_t)GELF_R_SYM(rel.r_info), i);
 			return -LIBBPF_ERRNO__FORMAT;
 		}
-		if (rel.r_offset % BPF_INSN_SZ) {
+
+		if (rel.r_offset % BPF_INSN_SZ || rel.r_offset >= scn_data->d_size) {
 			pr_warn("sec '%s': invalid offset 0x%zx for relo #%d\n",
 				relo_sec_name, (size_t)GELF_R_SYM(rel.r_info), i);
 			return -LIBBPF_ERRNO__FORMAT;
@@ -3769,9 +3755,9 @@ bpf_object__collect_prog_relos(struct bpf_object *obj, GElf_Shdr *shdr, Elf_Data
 
 		prog = find_prog_by_sec_insn(obj, sec_idx, insn_idx);
 		if (!prog) {
-			pr_warn("sec '%s': relo #%d: program not found in section '%s' for insn #%u\n",
+			pr_debug("sec '%s': relo #%d: couldn't find program in section '%s' for insn #%u, probably overridden weak function, skipping...\n",
 				relo_sec_name, i, sec_name, insn_idx);
-			return -LIBBPF_ERRNO__RELOC;
+			continue;
 		}
 
 		relos = libbpf_reallocarray(prog->reloc_desc,
-- 
2.30.2

