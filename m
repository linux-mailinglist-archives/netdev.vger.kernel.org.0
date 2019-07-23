Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 826E672155
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389123AbfGWVLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:11:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20150 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728921AbfGWVLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:11:39 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6NL7dxD006738
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 14:11:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=efxrTIBvNERCrYUuORgUKjmMNYv9YYW2MaqNDVoUBMg=;
 b=T7v/ANm3720IeS3VB3m9b1l2+phV6syzkWcRkECpjSqHyxchiFfZ91GqnEMeyMB3UimI
 uaCEVddXscastu7ILzlJwrTVMWflr4WXhftWptfPpSmisOV8wChnEyrJ2Y6Mpm3559Et
 D1Yf7fHEWyGStJdDmZnSRe5KA/X+hFaRB7w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2tx613h0ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 14:11:37 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 23 Jul 2019 14:11:36 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 828D686157E; Tue, 23 Jul 2019 14:11:35 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <songliubraving@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next] libbpf: provide more helpful message on uninitialized global var
Date:   Tue, 23 Jul 2019 14:11:33 -0700
Message-ID: <20190723211133.1666218-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=602 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907230214
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When BPF program defines uninitialized global variable, it's put into
a special COMMON section. Libbpf will reject such programs, but will
provide very unhelpful message with garbage-looking section index.

This patch detects special section cases and gives more explicit error
message.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 794dd5064ae8..8741c39adb1c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1760,15 +1760,22 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
 			 (long long) sym.st_value, sym.st_name, name);
 
 		shdr_idx = sym.st_shndx;
+		insn_idx = rel.r_offset / sizeof(struct bpf_insn);
+		pr_debug("relocation: insn_idx=%u, shdr_idx=%u\n",
+			 insn_idx, shdr_idx);
+
+		if (shdr_idx >= SHN_LORESERVE) {
+			pr_warning("relocation: not yet supported relo for non-static global \'%s\' variable in special section (0x%x) found in insns[%d].code 0x%x\n",
+				   name, shdr_idx, insn_idx,
+				   insns[insn_idx].code);
+			return -LIBBPF_ERRNO__RELOC;
+		}
 		if (!bpf_object__relo_in_known_section(obj, shdr_idx)) {
 			pr_warning("Program '%s' contains unrecognized relo data pointing to section %u\n",
 				   prog->section_name, shdr_idx);
 			return -LIBBPF_ERRNO__RELOC;
 		}
 
-		insn_idx = rel.r_offset / sizeof(struct bpf_insn);
-		pr_debug("relocation: insn_idx=%u\n", insn_idx);
-
 		if (insns[insn_idx].code == (BPF_JMP | BPF_CALL)) {
 			if (insns[insn_idx].src_reg != BPF_PSEUDO_CALL) {
 				pr_warning("incorrect bpf_call opcode\n");
-- 
2.17.1

