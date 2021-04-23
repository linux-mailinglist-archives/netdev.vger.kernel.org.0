Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A790E369D7D
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 01:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244292AbhDWXie convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 19:38:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244218AbhDWXg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 19:36:58 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NNZAfn027186
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 16:36:21 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 383b4q9qjp-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 16:36:21 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 16:36:18 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A134C2ED5CF6; Fri, 23 Apr 2021 16:36:13 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 2/5] libbpf: support BTF_KIND_FLOAT during type compatibility checks in CO-RE
Date:   Fri, 23 Apr 2021 16:30:55 -0700
Message-ID: <20210423233058.3386115-3-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423233058.3386115-1-andrii@kernel.org>
References: <20210423233058.3386115-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: D8GMOuDphge-yfVKktxuUiV3U4Ri0qRD
X-Proofpoint-ORIG-GUID: D8GMOuDphge-yfVKktxuUiV3U4Ri0qRD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_14:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 mlxlogscore=999 phishscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230159
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BTF_KIND_FLOAT support when doing CO-RE field type compatibility check.
Without this, relocations against float/double fields will fail.

Also adjust one error message to emit instruction index instead of less
convenient instruction byte offset.

Fixes: 22541a9eeb0d ("libbpf: Add BTF_KIND_FLOAT support")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a1cddd17af7d..ff54ffef433a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5141,6 +5141,7 @@ static int bpf_core_fields_are_compat(const struct btf *local_btf,
 
 	switch (btf_kind(local_type)) {
 	case BTF_KIND_PTR:
+	case BTF_KIND_FLOAT:
 		return 1;
 	case BTF_KIND_FWD:
 	case BTF_KIND_ENUM: {
@@ -6245,8 +6246,8 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
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

