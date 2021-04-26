Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DA536BA0E
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 21:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240410AbhDZTax convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 26 Apr 2021 15:30:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45744 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240198AbhDZTaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 15:30:46 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13QJOJ3J013047
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 12:30:04 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3860wrh5m8-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 12:30:04 -0700
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 26 Apr 2021 12:30:02 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 16D292ED6122; Mon, 26 Apr 2021 12:29:56 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v2 bpf-next 2/5] libbpf: support BTF_KIND_FLOAT during type compatibility checks in CO-RE
Date:   Mon, 26 Apr 2021 12:29:46 -0700
Message-ID: <20210426192949.416837-3-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426192949.416837-1-andrii@kernel.org>
References: <20210426192949.416837-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Cu93zHvRxLWz6Qiatc22NA7SRHFLqQEH
X-Proofpoint-ORIG-GUID: Cu93zHvRxLWz6Qiatc22NA7SRHFLqQEH
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-26_09:2021-04-26,2021-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104260149
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BTF_KIND_FLOAT support when doing CO-RE field type compatibility check.
Without this, relocations against float/double fields will fail.

Also adjust one error message to emit instruction index instead of less
convenient instruction byte offset.

Acked-by: Lorenz Bauer <lmb@cloudflare.com>
Fixes: 22541a9eeb0d ("libbpf: Add BTF_KIND_FLOAT support")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a1cddd17af7d..e2a3cf437814 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5115,6 +5115,7 @@ bpf_core_find_cands(struct bpf_object *obj, const struct btf *local_btf, __u32 l
  *     least one of enums should be anonymous;
  *   - for ENUMs, check sizes, names are ignored;
  *   - for INT, size and signedness are ignored;
+ *   - any two FLOATs are always compatible;
  *   - for ARRAY, dimensionality is ignored, element types are checked for
  *     compatibility recursively;
  *   - everything else shouldn't be ever a target of relocation.
@@ -5141,6 +5142,7 @@ static int bpf_core_fields_are_compat(const struct btf *local_btf,
 
 	switch (btf_kind(local_type)) {
 	case BTF_KIND_PTR:
+	case BTF_KIND_FLOAT:
 		return 1;
 	case BTF_KIND_FWD:
 	case BTF_KIND_ENUM: {
@@ -6245,8 +6247,8 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 	/* bpf_core_patch_insn() should know how to handle missing targ_spec */
 	err = bpf_core_patch_insn(prog, relo, relo_idx, &targ_res);
 	if (err) {
-		pr_warn("prog '%s': relo #%d: failed to patch insn at offset %d: %d\n",
-			prog->name, relo_idx, relo->insn_off, err);
+		pr_warn("prog '%s': relo #%d: failed to patch insn #%zu: %d\n",
+			prog->name, relo_idx, relo->insn_off / BPF_INSN_SZ, err);
 		return -EINVAL;
 	}
 
-- 
2.30.2

