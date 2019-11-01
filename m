Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352D2ECB63
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfKAW2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:28:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20958 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727730AbfKAW23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 18:28:29 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1MPbuQ032107
        for <netdev@vger.kernel.org>; Fri, 1 Nov 2019 15:28:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=rINHHbqWnXA6GAS91SCiZQRByEQGs1nsxkKGwL7Mvhs=;
 b=aHRT13JgmPrCqsywtcfBP7NPYgqef6T0501/EKeME/5uyjD3f7RBMyWGvM+nM8gDh4GV
 eRuFeO1ylMPzHZFhukD+M+8RiXGRwJ9EO+vuO1p9bBUEVNjHePl+yw1EpFbAhfhv8jWh
 2iX56rVfhLV4EMKQijAGXPqv6g/0h9Bobfg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w01c50axa-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 15:28:28 -0700
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 1 Nov 2019 15:28:20 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3C1222EC1B43; Fri,  1 Nov 2019 15:28:20 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/5] libbpf: add support for field size relocations
Date:   Fri, 1 Nov 2019 15:28:08 -0700
Message-ID: <20191101222810.1246166-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191101222810.1246166-1-andriin@fb.com>
References: <20191101222810.1246166-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_08:2019-11-01,2019-11-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 adultscore=0 suspectscore=8 phishscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1911010207
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_core_field_size() macro, capturing a relocation against field size.
Adjust bits of internal libbpf relocation logic to allow capturing size
relocations of various field types: arrays, structs/unions, enums, etc.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_core_read.h |  7 ++++++
 tools/lib/bpf/libbpf.c        | 40 ++++++++++++++++++++++++++++-------
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index 0935cd68e7de..11461b2623b0 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -96,6 +96,13 @@ enum bpf_field_info_kind {
 #define bpf_core_field_exists(field)					    \
 	__builtin_preserve_field_info(field, BPF_FIELD_EXISTS)
 
+/*
+ * Convenience macro to get byte size of a field. Works for integers,
+ * struct/unions, pointers, arrays, and enums.
+ */
+#define bpf_core_field_size(field)					    \
+	__builtin_preserve_field_info(field, BPF_FIELD_BYTE_SIZE)
+
 /*
  * bpf_core_read() abstracts away bpf_probe_read() call and captures offset
  * relocation for source address using __builtin_preserve_access_index()
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f1a01ed93c4a..f93d17e7cccb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2569,8 +2569,10 @@ static struct ids_vec *bpf_core_find_cands(const struct btf *local_btf,
 /* Check two types for compatibility, skipping const/volatile/restrict and
  * typedefs, to ensure we are relocating compatible entities:
  *   - any two STRUCTs/UNIONs are compatible and can be mixed;
- *   - any two FWDs are compatible;
+ *   - any two FWDs are compatible, if their names match (modulo flavor suffix);
  *   - any two PTRs are always compatible;
+ *   - for ENUMs, names should be the same (ignoring flavor suffix) or at
+ *     least one of enums should be anonymous;
  *   - for ENUMs, check sizes, names are ignored;
  *   - for INT, size and signedness are ignored;
  *   - for ARRAY, dimensionality is ignored, element types are checked for
@@ -2598,11 +2600,23 @@ static int bpf_core_fields_are_compat(const struct btf *local_btf,
 		return 0;
 
 	switch (btf_kind(local_type)) {
-	case BTF_KIND_FWD:
 	case BTF_KIND_PTR:
 		return 1;
-	case BTF_KIND_ENUM:
-		return local_type->size == targ_type->size;
+	case BTF_KIND_FWD:
+	case BTF_KIND_ENUM: {
+		const char *local_name, *targ_name;
+		size_t local_len, targ_len;
+
+		local_name = btf__name_by_offset(local_btf,
+						 local_type->name_off);
+		targ_name = btf__name_by_offset(targ_btf, targ_type->name_off);
+		local_len = bpf_core_essential_name_len(local_name);
+		targ_len = bpf_core_essential_name_len(targ_name);
+		/* one of them is anonymous or both w/ same flavor-less names */
+		return local_len == 0 || targ_len == 0 ||
+		       (local_len == targ_len &&
+			strncmp(local_name, targ_name, local_len) == 0);
+	}
 	case BTF_KIND_INT:
 		/* just reject deprecated bitfield-like integers; all other
 		 * integers are by default compatible between each other
@@ -2791,16 +2805,23 @@ static int bpf_core_calc_field_relo(const struct bpf_program *prog,
 	const struct btf_member *m;
 	const struct btf_type *mt;
 	bool bitfield;
+	__s64 sz;
 
 	/* a[n] accessor needs special handling */
 	if (!acc->name) {
-		if (relo->kind != BPF_FIELD_BYTE_OFFSET) {
-			pr_warn("prog '%s': relo %d at insn #%d can't be applied to array access'\n",
+		if (relo->kind == BPF_FIELD_BYTE_OFFSET) {
+			*val = spec->bit_offset / 8;
+		} else if (relo->kind == BPF_FIELD_BYTE_SIZE) {
+			sz = btf__resolve_size(spec->btf, acc->type_id);
+			if (sz < 0)
+				return -EINVAL;
+			*val = sz;
+		} else {
+			pr_warn("prog '%s': relo %d at insn #%d can't be applied to array access\n",
 				bpf_program__title(prog, false),
 				relo->kind, relo->insn_off / 8);
 			return -EINVAL;
 		}
-		*val = spec->bit_offset / 8;
 		if (validate)
 			*validate = true;
 		return 0;
@@ -2828,7 +2849,10 @@ static int bpf_core_calc_field_relo(const struct bpf_program *prog,
 			byte_off = bit_off / 8 / byte_sz * byte_sz;
 		}
 	} else {
-		byte_sz = mt->size;
+		sz = btf__resolve_size(spec->btf, m->type);
+		if (sz < 0)
+			return -EINVAL;
+		byte_sz = sz;
 		byte_off = spec->bit_offset / 8;
 		bit_sz = byte_sz * 8;
 	}
-- 
2.17.1

