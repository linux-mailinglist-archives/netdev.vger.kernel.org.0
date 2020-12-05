Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F922CF916
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 03:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgLECwc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 4 Dec 2020 21:52:32 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6850 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbgLECwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 21:52:32 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B52nAsf014684
        for <netdev@vger.kernel.org>; Fri, 4 Dec 2020 18:51:52 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 357rev36e6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 18:51:52 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 18:51:51 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CB29B2ECABA4; Fri,  4 Dec 2020 18:51:41 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next] libbpf: support module BTF for BPF_TYPE_ID_TARGET CO-RE relocation
Date:   Fri, 4 Dec 2020 18:51:40 -0800
Message-ID: <20201205025140.443115-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_13:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 suspectscore=8 clxscore=1034 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012050017
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When Clang emits ldimm64 instruction for BPF_TYPE_ID_TARGET CO-RE relocation,
put module BTF FD, containing target type, into upper 32 bits of imm64.

Because this FD is internal to libbpf, it's very cumbersome to test this in
selftests. Manual testing was performed with debug log messages sprinkled
across selftests and libbpf, confirming expected values are substituted.
Better testing will be performed as part of the work adding module BTF types
support to  bpf_snprintf_btf() helpers.

Cc: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9be88a90a4aa..539956f7920a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4795,6 +4795,7 @@ static int load_module_btfs(struct bpf_object *obj)
 
 		mod_btf = &obj->btf_modules[obj->btf_module_cnt++];
 
+		btf__set_fd(btf, fd);
 		mod_btf->btf = btf;
 		mod_btf->id = id;
 		mod_btf->fd = fd;
@@ -5445,6 +5446,10 @@ struct bpf_core_relo_res
 	__u32 orig_type_id;
 	__u32 new_sz;
 	__u32 new_type_id;
+	/* FD of the module BTF containing the target candidate, or 0 for
+	 * vmlinux BTF
+	 */
+	int btf_obj_fd;
 };
 
 /* Calculate original and target relocation values, given local and target
@@ -5469,6 +5474,7 @@ static int bpf_core_calc_relo(const struct bpf_program *prog,
 	res->fail_memsz_adjust = false;
 	res->orig_sz = res->new_sz = 0;
 	res->orig_type_id = res->new_type_id = 0;
+	res->btf_obj_fd = 0;
 
 	if (core_relo_is_field_based(relo->kind)) {
 		err = bpf_core_calc_field_relo(prog, relo, local_spec,
@@ -5519,6 +5525,9 @@ static int bpf_core_calc_relo(const struct bpf_program *prog,
 	} else if (core_relo_is_type_based(relo->kind)) {
 		err = bpf_core_calc_type_relo(relo, local_spec, &res->orig_val);
 		err = err ?: bpf_core_calc_type_relo(relo, targ_spec, &res->new_val);
+		if (!err && relo->kind == BPF_TYPE_ID_TARGET &&
+		    targ_spec->btf != prog->obj->btf_vmlinux)
+			res->btf_obj_fd = btf__fd(targ_spec->btf);
 	} else if (core_relo_is_enumval_based(relo->kind)) {
 		err = bpf_core_calc_enumval_relo(relo, local_spec, &res->orig_val);
 		err = err ?: bpf_core_calc_enumval_relo(relo, targ_spec, &res->new_val);
@@ -5725,10 +5734,14 @@ static int bpf_core_patch_insn(struct bpf_program *prog,
 		}
 
 		insn[0].imm = new_val;
-		insn[1].imm = 0; /* currently only 32-bit values are supported */
-		pr_debug("prog '%s': relo #%d: patched insn #%d (LDIMM64) imm64 %llu -> %u\n",
+		/* btf_obj_fd is zero for all relos but BPF_TYPE_ID_TARGET
+		 * with target type in the kernel module BTF
+		 */
+		insn[1].imm = res->btf_obj_fd;
+		pr_debug("prog '%s': relo #%d: patched insn #%d (LDIMM64) imm64 %llu -> %llu\n",
 			 prog->name, relo_idx, insn_idx,
-			 (unsigned long long)imm, new_val);
+			 (unsigned long long)imm,
+			 ((unsigned long long)res->btf_obj_fd << 32) | new_val);
 		break;
 	}
 	default:
-- 
2.24.1

