Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7934B1299BA
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 19:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLWSDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 13:03:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44334 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726787AbfLWSDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 13:03:21 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNHxFJI006638
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 10:03:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=Wu85cQXWCEoswfqnumcZzCb1zfQYhPBo2sSFwLFNKxc=;
 b=LxR+cUe82RdYC8VUjC4HS+hq0Xi+2T8XB07Zxcs09bRYAyEC9bFvnqqp+mT85mkopI9N
 KAjm4nGhGKnYOnJ/NOIaWK0Y9u8MCbHVuKVD+ZOivMdwgQJA1nkfnAIW072QqAOhdI5R
 iC0nKFcFDNTCLh4ieZlsy4zZYazkLhy/SmE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2x249dwa03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 10:03:20 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 23 Dec 2019 10:03:18 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 20E362EC19BA; Mon, 23 Dec 2019 10:03:15 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next] libbpf: support CO-RE relocations for LDX/ST/STX instructions
Date:   Mon, 23 Dec 2019 10:03:05 -0800
Message-ID: <20191223180305.86417-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_07:2019-12-23,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912230154
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang patch [0] enables emitting relocatable generic ALU/ALU64 instructions
(i.e, shifts and arithmetic operations), as well as generic load/store
instructions. The former ones are already supported by libbpf as is. This
patch adds further support for load/store instructions. Relocatable field
offset is encoded in BPF instruction's 16-bit offset section and are adjusted
by libbpf based on target kernel BTF.

These Clang changes and corresponding libbpf changes allow for more succinct
generated BPF code by encoding relocatable field reads as a single
ST/LDX/STX instruction. It also enables relocatable access to BPF context.
Previously, if context struct (e.g., __sk_buff) was accessed with CO-RE
relocations (e.g., due to preserve_access_index attribute), it would be
rejected by BPF verifier due to modified context pointer dereference. With
Clang patch, such context accesses are both relocatable and have a fixed
offset from the point of view of BPF verifier.

  [0] https://reviews.llvm.org/D71790

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9576a90c5a1c..7513165b104f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -18,6 +18,7 @@
 #include <stdarg.h>
 #include <libgen.h>
 #include <inttypes.h>
+#include <limits.h>
 #include <string.h>
 #include <unistd.h>
 #include <endian.h>
@@ -3810,11 +3811,13 @@ static int bpf_core_reloc_insn(struct bpf_program *prog,
 	insn = &prog->insns[insn_idx];
 	class = BPF_CLASS(insn->code);
 
-	if (class == BPF_ALU || class == BPF_ALU64) {
+	switch (class) {
+	case BPF_ALU:
+	case BPF_ALU64:
 		if (BPF_SRC(insn->code) != BPF_K)
 			return -EINVAL;
 		if (!failed && validate && insn->imm != orig_val) {
-			pr_warn("prog '%s': unexpected insn #%d value: got %u, exp %u -> %u\n",
+			pr_warn("prog '%s': unexpected insn #%d (ALU/ALU64) value: got %u, exp %u -> %u\n",
 				bpf_program__title(prog, false), insn_idx,
 				insn->imm, orig_val, new_val);
 			return -EINVAL;
@@ -3824,7 +3827,29 @@ static int bpf_core_reloc_insn(struct bpf_program *prog,
 		pr_debug("prog '%s': patched insn #%d (ALU/ALU64)%s imm %u -> %u\n",
 			 bpf_program__title(prog, false), insn_idx,
 			 failed ? " w/ failed reloc" : "", orig_val, new_val);
-	} else {
+		break;
+	case BPF_LDX:
+	case BPF_ST:
+	case BPF_STX:
+		if (!failed && validate && insn->off != orig_val) {
+			pr_warn("prog '%s': unexpected insn #%d (LD/LDX/ST/STX) value: got %u, exp %u -> %u\n",
+				bpf_program__title(prog, false), insn_idx,
+				insn->off, orig_val, new_val);
+			return -EINVAL;
+		}
+		if (new_val > SHRT_MAX) {
+			pr_warn("prog '%s': insn #%d (LD/LDX/ST/STX) value too big: %u\n",
+				bpf_program__title(prog, false), insn_idx,
+				new_val);
+			return -ERANGE;
+		}
+		orig_val = insn->off;
+		insn->off = new_val;
+		pr_debug("prog '%s': patched insn #%d (LD/LDX/ST/STX)%s off %u -> %u\n",
+			 bpf_program__title(prog, false), insn_idx,
+			 failed ? " w/ failed reloc" : "", orig_val, new_val);
+		break;
+	default:
 		pr_warn("prog '%s': trying to relocate unrecognized insn #%d, code:%x, src:%x, dst:%x, off:%x, imm:%x\n",
 			bpf_program__title(prog, false),
 			insn_idx, insn->code, insn->src_reg, insn->dst_reg,
-- 
2.17.1

