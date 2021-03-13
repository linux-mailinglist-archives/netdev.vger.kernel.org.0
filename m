Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF2433A085
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 20:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbhCMTgO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 13 Mar 2021 14:36:14 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40118 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234463AbhCMTft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 14:35:49 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12DJZmjh025704
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 11:35:49 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 378ustsc7t-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 11:35:48 -0800
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 13 Mar 2021 11:35:47 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A57A72ED20BF; Sat, 13 Mar 2021 11:35:43 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 02/11] libbpf: generalize BTF and BTF.ext type ID and strings iteration
Date:   Sat, 13 Mar 2021 11:35:28 -0800
Message-ID: <20210313193537.1548766-3-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210313193537.1548766-1-andrii@kernel.org>
References: <20210313193537.1548766-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-13_07:2021-03-12,2021-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 malwarescore=0 phishscore=0 bulkscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103130151
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract and generalize the logic to iterate BTF type ID and string offset
fields within BTF types and .BTF.ext data. Expose this internally in libbpf
for re-use by bpf_linker.

Additionally, complete strings deduplication handling for BTF.ext (e.g., CO-RE
access strings), which was previously missing. There previously was no
case of deduplicating .BTF.ext data, but bpf_linker is going to use it.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/btf.c             | 393 ++++++++++++++++++--------------
 tools/lib/bpf/libbpf_internal.h |   7 +
 2 files changed, 228 insertions(+), 172 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index e0b0a78b04fe..e137781f9bc6 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -3155,95 +3155,28 @@ static struct btf_dedup *btf_dedup_new(struct btf *btf, struct btf_ext *btf_ext,
 	return d;
 }
 
-typedef int (*str_off_fn_t)(__u32 *str_off_ptr, void *ctx);
-
 /*
  * Iterate over all possible places in .BTF and .BTF.ext that can reference
  * string and pass pointer to it to a provided callback `fn`.
  */
-static int btf_for_each_str_off(struct btf_dedup *d, str_off_fn_t fn, void *ctx)
+static int btf_for_each_str_off(struct btf_dedup *d, str_off_visit_fn fn, void *ctx)
 {
-	void *line_data_cur, *line_data_end;
-	int i, j, r, rec_size;
-	struct btf_type *t;
+	int i, r;
 
 	for (i = 0; i < d->btf->nr_types; i++) {
-		t = btf_type_by_id(d->btf, d->btf->start_id + i);
-		r = fn(&t->name_off, ctx);
+		struct btf_type *t = btf_type_by_id(d->btf, d->btf->start_id + i);
+
+		r = btf_type_visit_str_offs(t, fn, ctx);
 		if (r)
 			return r;
-
-		switch (btf_kind(t)) {
-		case BTF_KIND_STRUCT:
-		case BTF_KIND_UNION: {
-			struct btf_member *m = btf_members(t);
-			__u16 vlen = btf_vlen(t);
-
-			for (j = 0; j < vlen; j++) {
-				r = fn(&m->name_off, ctx);
-				if (r)
-					return r;
-				m++;
-			}
-			break;
-		}
-		case BTF_KIND_ENUM: {
-			struct btf_enum *m = btf_enum(t);
-			__u16 vlen = btf_vlen(t);
-
-			for (j = 0; j < vlen; j++) {
-				r = fn(&m->name_off, ctx);
-				if (r)
-					return r;
-				m++;
-			}
-			break;
-		}
-		case BTF_KIND_FUNC_PROTO: {
-			struct btf_param *m = btf_params(t);
-			__u16 vlen = btf_vlen(t);
-
-			for (j = 0; j < vlen; j++) {
-				r = fn(&m->name_off, ctx);
-				if (r)
-					return r;
-				m++;
-			}
-			break;
-		}
-		default:
-			break;
-		}
 	}
 
 	if (!d->btf_ext)
 		return 0;
 
-	line_data_cur = d->btf_ext->line_info.info;
-	line_data_end = d->btf_ext->line_info.info + d->btf_ext->line_info.len;
-	rec_size = d->btf_ext->line_info.rec_size;
-
-	while (line_data_cur < line_data_end) {
-		struct btf_ext_info_sec *sec = line_data_cur;
-		struct bpf_line_info_min *line_info;
-		__u32 num_info = sec->num_info;
-
-		r = fn(&sec->sec_name_off, ctx);
-		if (r)
-			return r;
-
-		line_data_cur += sizeof(struct btf_ext_info_sec);
-		for (i = 0; i < num_info; i++) {
-			line_info = line_data_cur;
-			r = fn(&line_info->file_name_off, ctx);
-			if (r)
-				return r;
-			r = fn(&line_info->line_off, ctx);
-			if (r)
-				return r;
-			line_data_cur += rec_size;
-		}
-	}
+	r = btf_ext_visit_str_offs(d->btf_ext, fn, ctx);
+	if (r)
+		return r;
 
 	return 0;
 }
@@ -4498,15 +4431,18 @@ static int btf_dedup_compact_types(struct btf_dedup *d)
  * then mapping it to a deduplicated type ID, stored in btf_dedup->hypot_map,
  * which is populated during compaction phase.
  */
-static int btf_dedup_remap_type_id(struct btf_dedup *d, __u32 type_id)
+static int btf_dedup_remap_type_id(__u32 *type_id, void *ctx)
 {
+	struct btf_dedup *d = ctx;
 	__u32 resolved_type_id, new_type_id;
 
-	resolved_type_id = resolve_type_id(d, type_id);
+	resolved_type_id = resolve_type_id(d, *type_id);
 	new_type_id = d->hypot_map[resolved_type_id];
 	if (new_type_id > BTF_MAX_NR_TYPES)
 		return -EINVAL;
-	return new_type_id;
+
+	*type_id = new_type_id;
+	return 0;
 }
 
 /*
@@ -4519,109 +4455,25 @@ static int btf_dedup_remap_type_id(struct btf_dedup *d, __u32 type_id)
  * referenced from any BTF type (e.g., struct fields, func proto args, etc) to
  * their final deduped type IDs.
  */
-static int btf_dedup_remap_type(struct btf_dedup *d, __u32 type_id)
+static int btf_dedup_remap_types(struct btf_dedup *d)
 {
-	struct btf_type *t = btf_type_by_id(d->btf, type_id);
 	int i, r;
 
-	switch (btf_kind(t)) {
-	case BTF_KIND_INT:
-	case BTF_KIND_ENUM:
-	case BTF_KIND_FLOAT:
-		break;
-
-	case BTF_KIND_FWD:
-	case BTF_KIND_CONST:
-	case BTF_KIND_VOLATILE:
-	case BTF_KIND_RESTRICT:
-	case BTF_KIND_PTR:
-	case BTF_KIND_TYPEDEF:
-	case BTF_KIND_FUNC:
-	case BTF_KIND_VAR:
-		r = btf_dedup_remap_type_id(d, t->type);
-		if (r < 0)
-			return r;
-		t->type = r;
-		break;
-
-	case BTF_KIND_ARRAY: {
-		struct btf_array *arr_info = btf_array(t);
-
-		r = btf_dedup_remap_type_id(d, arr_info->type);
-		if (r < 0)
-			return r;
-		arr_info->type = r;
-		r = btf_dedup_remap_type_id(d, arr_info->index_type);
-		if (r < 0)
-			return r;
-		arr_info->index_type = r;
-		break;
-	}
-
-	case BTF_KIND_STRUCT:
-	case BTF_KIND_UNION: {
-		struct btf_member *member = btf_members(t);
-		__u16 vlen = btf_vlen(t);
-
-		for (i = 0; i < vlen; i++) {
-			r = btf_dedup_remap_type_id(d, member->type);
-			if (r < 0)
-				return r;
-			member->type = r;
-			member++;
-		}
-		break;
-	}
-
-	case BTF_KIND_FUNC_PROTO: {
-		struct btf_param *param = btf_params(t);
-		__u16 vlen = btf_vlen(t);
+	for (i = 0; i < d->btf->nr_types; i++) {
+		struct btf_type *t = btf_type_by_id(d->btf, d->btf->start_id + i);
 
-		r = btf_dedup_remap_type_id(d, t->type);
-		if (r < 0)
+		r = btf_type_visit_type_ids(t, btf_dedup_remap_type_id, d);
+		if (r)
 			return r;
-		t->type = r;
-
-		for (i = 0; i < vlen; i++) {
-			r = btf_dedup_remap_type_id(d, param->type);
-			if (r < 0)
-				return r;
-			param->type = r;
-			param++;
-		}
-		break;
-	}
-
-	case BTF_KIND_DATASEC: {
-		struct btf_var_secinfo *var = btf_var_secinfos(t);
-		__u16 vlen = btf_vlen(t);
-
-		for (i = 0; i < vlen; i++) {
-			r = btf_dedup_remap_type_id(d, var->type);
-			if (r < 0)
-				return r;
-			var->type = r;
-			var++;
-		}
-		break;
-	}
-
-	default:
-		return -EINVAL;
 	}
 
-	return 0;
-}
+	if (!d->btf_ext)
+		return 0;
 
-static int btf_dedup_remap_types(struct btf_dedup *d)
-{
-	int i, r;
+	r = btf_ext_visit_type_ids(d->btf_ext, btf_dedup_remap_type_id, d);
+	if (r)
+		return r;
 
-	for (i = 0; i < d->btf->nr_types; i++) {
-		r = btf_dedup_remap_type(d, d->btf->start_id + i);
-		if (r < 0)
-			return r;
-	}
 	return 0;
 }
 
@@ -4675,3 +4527,200 @@ struct btf *libbpf_find_kernel_btf(void)
 	pr_warn("failed to find valid kernel BTF\n");
 	return ERR_PTR(-ESRCH);
 }
+
+int btf_type_visit_type_ids(struct btf_type *t, type_id_visit_fn visit, void *ctx)
+{
+	int i, n, err;
+
+	switch (btf_kind(t)) {
+	case BTF_KIND_INT:
+	case BTF_KIND_FLOAT:
+	case BTF_KIND_ENUM:
+		return 0;
+
+	case BTF_KIND_FWD:
+	case BTF_KIND_CONST:
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_RESTRICT:
+	case BTF_KIND_PTR:
+	case BTF_KIND_TYPEDEF:
+	case BTF_KIND_FUNC:
+	case BTF_KIND_VAR:
+		return visit(&t->type, ctx);
+
+	case BTF_KIND_ARRAY: {
+		struct btf_array *a = btf_array(t);
+
+		err = visit(&a->type, ctx);
+		err = err ?: visit(&a->index_type, ctx);
+		return err;
+	}
+
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION: {
+		struct btf_member *m = btf_members(t);
+
+		for (i = 0, n = btf_vlen(t); i < n; i++, m++) {
+			err = visit(&m->type, ctx);
+			if (err)
+				return err;
+		}
+		return 0;
+	}
+
+	case BTF_KIND_FUNC_PROTO: {
+		struct btf_param *m = btf_params(t);
+
+		err = visit(&t->type, ctx);
+		if (err)
+			return err;
+		for (i = 0, n = btf_vlen(t); i < n; i++, m++) {
+			err = visit(&m->type, ctx);
+			if (err)
+				return err;
+		}
+		return 0;
+	}
+
+	case BTF_KIND_DATASEC: {
+		struct btf_var_secinfo *m = btf_var_secinfos(t);
+
+		for (i = 0, n = btf_vlen(t); i < n; i++, m++) {
+			err = visit(&m->type, ctx);
+			if (err)
+				return err;
+		}
+		return 0;
+	}
+
+	default:
+		return -EINVAL;
+	}
+}
+
+int btf_type_visit_str_offs(struct btf_type *t, str_off_visit_fn visit, void *ctx)
+{
+	int i, n, err;
+
+	err = visit(&t->name_off, ctx);
+	if (err)
+		return err;
+
+	switch (btf_kind(t)) {
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION: {
+		struct btf_member *m = btf_members(t);
+
+		for (i = 0, n = btf_vlen(t); i < n; i++, m++) {
+			err = visit(&m->name_off, ctx);
+			if (err)
+				return err;
+		}
+		break;
+	}
+	case BTF_KIND_ENUM: {
+		struct btf_enum *m = btf_enum(t);
+
+		for (i = 0, n = btf_vlen(t); i < n; i++, m++) {
+			err = visit(&m->name_off, ctx);
+			if (err)
+				return err;
+		}
+		break;
+	}
+	case BTF_KIND_FUNC_PROTO: {
+		struct btf_param *m = btf_params(t);
+
+		for (i = 0, n = btf_vlen(t); i < n; i++, m++) {
+			err = visit(&m->name_off, ctx);
+			if (err)
+				return err;
+		}
+		break;
+	}
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+int btf_ext_visit_type_ids(struct btf_ext *btf_ext, type_id_visit_fn visit, void *ctx)
+{
+	const struct btf_ext_info *seg;
+	struct btf_ext_info_sec *sec;
+	int i, err;
+
+	seg = &btf_ext->func_info;
+	for_each_btf_ext_sec(seg, sec) {
+		struct bpf_func_info_min *rec;
+
+		for_each_btf_ext_rec(seg, sec, i, rec) {
+			err = visit(&rec->type_id, ctx);
+			if (err < 0)
+				return err;
+		}
+	}
+
+	seg = &btf_ext->core_relo_info;
+	for_each_btf_ext_sec(seg, sec) {
+		struct bpf_core_relo *rec;
+
+		for_each_btf_ext_rec(seg, sec, i, rec) {
+			err = visit(&rec->type_id, ctx);
+			if (err < 0)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
+int btf_ext_visit_str_offs(struct btf_ext *btf_ext, str_off_visit_fn visit, void *ctx)
+{
+	const struct btf_ext_info *seg;
+	struct btf_ext_info_sec *sec;
+	int i, err;
+
+	seg = &btf_ext->func_info;
+	for_each_btf_ext_sec(seg, sec) {
+		err = visit(&sec->sec_name_off, ctx);
+		if (err)
+			return err;
+	}
+
+	seg = &btf_ext->line_info;
+	for_each_btf_ext_sec(seg, sec) {
+		struct bpf_line_info_min *rec;
+
+		err = visit(&sec->sec_name_off, ctx);
+		if (err)
+			return err;
+
+		for_each_btf_ext_rec(seg, sec, i, rec) {
+			err = visit(&rec->file_name_off, ctx);
+			if (err)
+				return err;
+			err = visit(&rec->line_off, ctx);
+			if (err)
+				return err;
+		}
+	}
+
+	seg = &btf_ext->core_relo_info;
+	for_each_btf_ext_sec(seg, sec) {
+		struct bpf_core_relo *rec;
+
+		err = visit(&sec->sec_name_off, ctx);
+		if (err)
+			return err;
+
+		for_each_btf_ext_rec(seg, sec, i, rec) {
+			err = visit(&rec->access_str_off, ctx);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index d09860e435c8..97b6b9cc9839 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -356,4 +356,11 @@ struct bpf_core_relo {
 	enum bpf_core_relo_kind kind;
 };
 
+typedef int (*type_id_visit_fn)(__u32 *type_id, void *ctx);
+typedef int (*str_off_visit_fn)(__u32 *str_off, void *ctx);
+int btf_type_visit_type_ids(struct btf_type *t, type_id_visit_fn visit, void *ctx);
+int btf_type_visit_str_offs(struct btf_type *t, str_off_visit_fn visit, void *ctx);
+int btf_ext_visit_type_ids(struct btf_ext *btf_ext, type_id_visit_fn visit, void *ctx);
+int btf_ext_visit_str_offs(struct btf_ext *btf_ext, str_off_visit_fn visit, void *ctx);
+
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
-- 
2.24.1

