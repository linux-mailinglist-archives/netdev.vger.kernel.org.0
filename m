Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00D313CC2A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbgAOSeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 13:34:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15094 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729098AbgAOSeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:34:17 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00FIMcaC007479
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 10:34:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=Jx8s4CKKt4J45A0PMR6bQal52l5GqJsevyG/EvivopM=;
 b=dNjY1WiQAyB7xYKzU6JNSo5YRnIzXSXs5OHyf/R2Qulizygi85FiISLw32oc3hSm96Eb
 KwWfzAJHZyquqyR3XmWzxRe71EhoQEmd2KRd0L7t/f+uhsYHomgktfedxyJGQLYYVYPQ
 Ypcc4Doa7PWmHmPZnjsIXW/e1cRYibZWIJM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhwp4aptd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 10:34:16 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 15 Jan 2020 10:34:15 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 645B02EC20B7; Wed, 15 Jan 2020 10:34:11 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: support .text sub-calls relocations
Date:   Wed, 15 Jan 2020 10:34:09 -0800
Message-ID: <20200115183409.2274797-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-15_02:2020-01-15,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 phishscore=0 priorityscore=1501 spamscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001150141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LLVM patch https://reviews.llvm.org/D72197 makes LLVM emit function call
relocations within the same section. This includes a default .text section,
which contains any BPF sub-programs. This wasn't the case before and so libbpf
was able to get a way with slightly simpler handling of subprogram call
relocations.

This patch adds support for .text section relocations. It needs to ensure
correct order of relocations, so does two passes:
- first, relocate .text instructions, if there are any relocations in it;
- then process all the other programs and copy over patched .text instructions
for all sub-program calls.

Cc: Yonghong Song <yhs@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0c229f00a67e..c46769d558b5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4692,13 +4692,7 @@ bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj,
 	size_t new_cnt;
 	int err;
 
-	if (prog->idx == obj->efile.text_shndx) {
-		pr_warn("relo in .text insn %d into off %d (insn #%d)\n",
-			relo->insn_idx, relo->sym_off, relo->sym_off / 8);
-		return -LIBBPF_ERRNO__RELOC;
-	}
-
-	if (prog->main_prog_cnt == 0) {
+	if (prog->idx != obj->efile.text_shndx && prog->main_prog_cnt == 0) {
 		text = bpf_object__find_prog_by_idx(obj, obj->efile.text_shndx);
 		if (!text) {
 			pr_warn("no .text section found yet relo into text exist\n");
@@ -4728,6 +4722,7 @@ bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj,
 			 text->insns_cnt, text->section_name,
 			 prog->section_name);
 	}
+
 	insn = &prog->insns[relo->insn_idx];
 	insn->imm += relo->sym_off / 8 + prog->main_prog_cnt - relo->insn_idx;
 	return 0;
@@ -4807,8 +4802,27 @@ bpf_object__relocate(struct bpf_object *obj, const char *targ_btf_path)
 			return err;
 		}
 	}
+	/* ensure .text is relocated first, as it's going to be copied as-is
+	 * later for sub-program calls
+	 */
 	for (i = 0; i < obj->nr_programs; i++) {
 		prog = &obj->programs[i];
+		if (prog->idx != obj->efile.text_shndx)
+			continue;
+
+		err = bpf_program__relocate(prog, obj);
+		if (err) {
+			pr_warn("failed to relocate '%s'\n", prog->section_name);
+			return err;
+		}
+	}
+	/* now relocate everything but .text, which by now is relocated
+	 * properly, so we can copy raw sub-program instructions as is safely
+	 */
+	for (i = 0; i < obj->nr_programs; i++) {
+		prog = &obj->programs[i];
+		if (prog->idx == obj->efile.text_shndx)
+			continue;
 
 		err = bpf_program__relocate(prog, obj);
 		if (err) {
-- 
2.17.1

