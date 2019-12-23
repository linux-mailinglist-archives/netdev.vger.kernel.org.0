Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4FA1291E4
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 07:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfLWGTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 01:19:12 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38222 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725822AbfLWGTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 01:19:12 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBN6CDg1024987
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 22:19:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=tKTfMoykmeJWDAmdH/ho54hwFYPssOvkeG7vrbUoa0Y=;
 b=PlAAzLXQjyrB3TcORQCF1v3wTRIIXtTQ03te+WqMDsAQrVLPS0IEHi2/gPZK4i36duZD
 ndzuAy4y7p+4umqDxHxo77bKvrIzk6lkuI34NLEO1KmgEDi8Nf7Fwy3XKOCdT6zfedTF
 J54NU67pbe4piz3JxRCxO5Ag4revNQyG+E8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2x2410b0bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 22:19:11 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 22 Dec 2019 22:19:09 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 85FA22EC17AF; Sun, 22 Dec 2019 22:19:03 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: support CO-RE relocations for LD/LDX/ST/STX instructions
Date:   Sun, 22 Dec 2019 22:18:54 -0800
Message-ID: <20191223061855.1601999-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_01:2019-12-17,2019-12-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912230052
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
LD/ST/LDX/STX instruction. It also enables relocatable access to BPF context.
Previously, if context struct (e.g., __sk_buff) was accessed with CO-RE
relocations (e.g., due to preserve_access_index attribute), it would be
rejected by BPF verifier due to modified context pointer dereference. With
Clang patch, such context accesses are both relocatable and have a fixed
offset from the point of view of BPF verifier.

  [0] https://reviews.llvm.org/D71790

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9576a90c5a1c..2dbc2204a02c 100644
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
@@ -3824,7 +3827,30 @@ static int bpf_core_reloc_insn(struct bpf_program *prog,
 		pr_debug("prog '%s': patched insn #%d (ALU/ALU64)%s imm %u -> %u\n",
 			 bpf_program__title(prog, false), insn_idx,
 			 failed ? " w/ failed reloc" : "", orig_val, new_val);
-	} else {
+		break;
+	case BPF_LD:
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

