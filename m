Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F2A3486AC
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbhCYBw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:52:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29302 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239797AbhCYBwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 21:52:32 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12P1psE9031344
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:52:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=4llDdiJHTQl7CKTz4le76j0arsHsZFIWwcjFzYesytU=;
 b=H+rd/zX1B6E5yY7m2+OEn4WJWum5lwY4rTLx5/nYrmU964uLmTM0g1EyF1+wmKOgukAM
 oiFLw4mXL1HPuFS5/8wLxo7FWmRGn1/YBH+9pYreuxto/5zzWRPYfE7TCkWQLX/Yc5o9
 BpuDxJUWN/V6wqHBDGABqKDovIluL9Dd+rU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 37g173nu5n-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:52:31 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 18:52:30 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id C4F7929429D7; Wed, 24 Mar 2021 18:52:27 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH v2 bpf-next 10/14] libbpf: Record extern sym relocation first
Date:   Wed, 24 Mar 2021 18:52:27 -0700
Message-ID: <20210325015227.1548623-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325015124.1543397-1-kafai@fb.com>
References: <20210325015124.1543397-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-24_14:2021-03-24,2021-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 adultscore=0 mlxlogscore=947 clxscore=1015 phishscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250012
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch records the extern sym relocs first before recording
subprog relocs.  The later patch will have relocs for extern
kernel function call which is also using BPF_JMP | BPF_CALL.
It will be easier to handle the extern symbols first in
the later patch.

is_call_insn() helper is added.  The existing is_ldimm64() helper
is renamed to is_ldimm64_insn() for consistency.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/lib/bpf/libbpf.c | 63 +++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 29 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1a2dbde19b7e..23148566ab3a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -573,14 +573,19 @@ static bool insn_is_subprog_call(const struct bpf_i=
nsn *insn)
 	       insn->off =3D=3D 0;
 }
=20
-static bool is_ldimm64(struct bpf_insn *insn)
+static bool is_ldimm64_insn(struct bpf_insn *insn)
 {
 	return insn->code =3D=3D (BPF_LD | BPF_IMM | BPF_DW);
 }
=20
+static bool is_call_insn(const struct bpf_insn *insn)
+{
+	return insn->code =3D=3D (BPF_JMP | BPF_CALL);
+}
+
 static bool insn_is_pseudo_func(struct bpf_insn *insn)
 {
-	return is_ldimm64(insn) && insn->src_reg =3D=3D BPF_PSEUDO_FUNC;
+	return is_ldimm64_insn(insn) && insn->src_reg =3D=3D BPF_PSEUDO_FUNC;
 }
=20
 static int
@@ -3407,31 +3412,7 @@ static int bpf_program__record_reloc(struct bpf_pr=
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
+	if (!is_call_insn(insn) && !is_ldimm64_insn(insn)) {
 		pr_warn("prog '%s': invalid relo against '%s' for insns[%d].code 0x%x\=
n",
 			prog->name, sym_name, insn_idx, insn->code);
 		return -LIBBPF_ERRNO__RELOC;
@@ -3460,6 +3441,30 @@ static int bpf_program__record_reloc(struct bpf_pr=
ogram *prog,
 		return 0;
 	}
=20
+	/* sub-program call relocation */
+	if (is_call_insn(insn)) {
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
@@ -5699,7 +5704,7 @@ static int bpf_core_patch_insn(struct bpf_program *=
prog,
 		/* poison second part of ldimm64 to avoid confusing error from
 		 * verifier about "unknown opcode 00"
 		 */
-		if (is_ldimm64(insn))
+		if (is_ldimm64_insn(insn))
 			bpf_core_poison_insn(prog, relo_idx, insn_idx + 1, insn + 1);
 		bpf_core_poison_insn(prog, relo_idx, insn_idx, insn);
 		return 0;
@@ -5775,7 +5780,7 @@ static int bpf_core_patch_insn(struct bpf_program *=
prog,
 	case BPF_LD: {
 		__u64 imm;
=20
-		if (!is_ldimm64(insn) ||
+		if (!is_ldimm64_insn(insn) ||
 		    insn[0].src_reg !=3D 0 || insn[0].off !=3D 0 ||
 		    insn_idx + 1 >=3D prog->insns_cnt ||
 		    insn[1].code !=3D 0 || insn[1].dst_reg !=3D 0 ||
--=20
2.30.2

