Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B9A33CAB0
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 02:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbhCPBPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 21:15:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49346 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231526AbhCPBOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 21:14:50 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G1BBoH016683
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:14:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=mkCKkgL+OtSu/PPJQIqEm8bTwX4NBiLVBCZNqDtJE3A=;
 b=F5BXqddPhH7s1WLeuFNoZg7oJgDpkhFs90/ksrXLcg/xoxw//RiGp8HfT875wLUZeZm3
 sahtxPEgr0+bj4xEBy8bRV0xtGhJCwSp5Xz6CTXarWVrOgZ3HiBu+JPXlsKJHf7+VCF6
 m4wsZO5oCoU4MrXvDyfhyyxmsdvOgCPWjwY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 379e118tua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:14:50 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 15 Mar 2021 18:14:49 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 1FE462942B57; Mon, 15 Mar 2021 18:14:45 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 11/15] libbpf: Record extern sym relocation first
Date:   Mon, 15 Mar 2021 18:14:45 -0700
Message-ID: <20210316011445.4179633-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316011336.4173585-1-kafai@fb.com>
References: <20210316011336.4173585-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_15:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=835 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch records the extern sym relocs first before recording
subprog relocs.  The later patch will have relocs for extern
kernel function call which is also using BPF_JMP | BPF_CALL.
It will be easier to handle the extern symbols first in
the later patch.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/lib/bpf/libbpf.c | 50 +++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8f924aece736..0a60fcb2fba2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3416,31 +3416,7 @@ static int bpf_program__record_reloc(struct bpf_pr=
ogram *prog,
=20
 	reloc_desc->processed =3D false;
=20
-	/* sub-program call relocation */
-	if (insn->code =3D=3D (BPF_JMP | BPF_CALL)) {
-		if (insn->src_reg !=3D BPF_PSEUDO_CALL) {
-			pr_warn("prog '%s': incorrect bpf_call opcode\n", prog->name);
-			return -LIBBPF_ERRNO__RELOC;
-		}
-		/* text_shndx can be 0, if no default "main" program exists */
-		if (!shdr_idx || shdr_idx !=3D obj->efile.text_shndx) {
-			sym_sec_name =3D elf_sec_name(obj, elf_sec_by_idx(obj, shdr_idx));
-			pr_warn("prog '%s': bad call relo against '%s' in section '%s'\n",
-				prog->name, sym_name, sym_sec_name);
-			return -LIBBPF_ERRNO__RELOC;
-		}
-		if (sym->st_value % BPF_INSN_SZ) {
-			pr_warn("prog '%s': bad call relo against '%s' at offset %zu\n",
-				prog->name, sym_name, (size_t)sym->st_value);
-			return -LIBBPF_ERRNO__RELOC;
-		}
-		reloc_desc->type =3D RELO_CALL;
-		reloc_desc->insn_idx =3D insn_idx;
-		reloc_desc->sym_off =3D sym->st_value;
-		return 0;
-	}
-
-	if (!is_ldimm64(insn)) {
+	if (insn->code !=3D (BPF_JMP | BPF_CALL) && !is_ldimm64(insn)) {
 		pr_warn("prog '%s': invalid relo against '%s' for insns[%d].code 0x%x\=
n",
 			prog->name, sym_name, insn_idx, insn->code);
 		return -LIBBPF_ERRNO__RELOC;
@@ -3469,6 +3445,30 @@ static int bpf_program__record_reloc(struct bpf_pr=
ogram *prog,
 		return 0;
 	}
=20
+	/* sub-program call relocation */
+	if (insn->code =3D=3D (BPF_JMP | BPF_CALL)) {
+		if (insn->src_reg !=3D BPF_PSEUDO_CALL) {
+			pr_warn("prog '%s': incorrect bpf_call opcode\n", prog->name);
+			return -LIBBPF_ERRNO__RELOC;
+		}
+		/* text_shndx can be 0, if no default "main" program exists */
+		if (!shdr_idx || shdr_idx !=3D obj->efile.text_shndx) {
+			sym_sec_name =3D elf_sec_name(obj, elf_sec_by_idx(obj, shdr_idx));
+			pr_warn("prog '%s': bad call relo against '%s' in section '%s'\n",
+				prog->name, sym_name, sym_sec_name);
+			return -LIBBPF_ERRNO__RELOC;
+		}
+		if (sym->st_value % BPF_INSN_SZ) {
+			pr_warn("prog '%s': bad call relo against '%s' at offset %zu\n",
+				prog->name, sym_name, (size_t)sym->st_value);
+			return -LIBBPF_ERRNO__RELOC;
+		}
+		reloc_desc->type =3D RELO_CALL;
+		reloc_desc->insn_idx =3D insn_idx;
+		reloc_desc->sym_off =3D sym->st_value;
+		return 0;
+	}
+
 	if (!shdr_idx || shdr_idx >=3D SHN_LORESERVE) {
 		pr_warn("prog '%s': invalid relo against '%s' in special section 0x%x;=
 forgot to initialize global var?..\n",
 			prog->name, sym_name, shdr_idx);
--=20
2.30.2

