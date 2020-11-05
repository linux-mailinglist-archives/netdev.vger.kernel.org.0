Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285E12A7671
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 05:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbgKEEeO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Nov 2020 23:34:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2884 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730411AbgKEEeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 23:34:13 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A54VxUO022975
        for <netdev@vger.kernel.org>; Wed, 4 Nov 2020 20:34:12 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34m81m0h6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 20:34:12 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 4 Nov 2020 20:34:12 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D68DA2EC8E04; Wed,  4 Nov 2020 20:34:05 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 01/11] libbpf: factor out common operations in BTF writing APIs
Date:   Wed, 4 Nov 2020 20:33:51 -0800
Message-ID: <20201105043402.2530976-2-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201105043402.2530976-1-andrii@kernel.org>
References: <20201105043402.2530976-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_01:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 mlxlogscore=942 lowpriorityscore=0 clxscore=1034 mlxscore=0
 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0 suspectscore=8
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050032
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out commiting of appended type data. Also extract fetching the very
last type in the BTF (to append members to). These two operations are common
across many APIs and will be easier to refactor with split BTF, if they are
extracted into a single place.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/btf.c | 123 ++++++++++++++++----------------------------
 1 file changed, 43 insertions(+), 80 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 231b07203e3d..89fecfe5cb2b 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1560,6 +1560,20 @@ static void btf_type_inc_vlen(struct btf_type *t)
 	t->info = btf_type_info(btf_kind(t), btf_vlen(t) + 1, btf_kflag(t));
 }
 
+static int btf_commit_type(struct btf *btf, int data_sz)
+{
+	int err;
+
+	err = btf_add_type_idx_entry(btf, btf->hdr->type_len);
+	if (err)
+		return err;
+
+	btf->hdr->type_len += data_sz;
+	btf->hdr->str_off += data_sz;
+	btf->nr_types++;
+	return btf->nr_types;
+}
+
 /*
  * Append new BTF_KIND_INT type with:
  *   - *name* - non-empty, non-NULL type name;
@@ -1572,7 +1586,7 @@ static void btf_type_inc_vlen(struct btf_type *t)
 int btf__add_int(struct btf *btf, const char *name, size_t byte_sz, int encoding)
 {
 	struct btf_type *t;
-	int sz, err, name_off;
+	int sz, name_off;
 
 	/* non-empty name */
 	if (!name || !name[0])
@@ -1606,14 +1620,7 @@ int btf__add_int(struct btf *btf, const char *name, size_t byte_sz, int encoding
 	/* set INT info, we don't allow setting legacy bit offset/size */
 	*(__u32 *)(t + 1) = (encoding << 24) | (byte_sz * 8);
 
-	err = btf_add_type_idx_entry(btf, btf->hdr->type_len);
-	if (err)
-		return err;
-
-	btf->hdr->type_len += sz;
-	btf->hdr->str_off += sz;
-	btf->nr_types++;
-	return btf->nr_types;
+	return btf_commit_type(btf, sz);
 }
 
 /* it's completely legal to append BTF types with type IDs pointing forward to
@@ -1631,7 +1638,7 @@ static int validate_type_id(int id)
 static int btf_add_ref_kind(struct btf *btf, int kind, const char *name, int ref_type_id)
 {
 	struct btf_type *t;
-	int sz, name_off = 0, err;
+	int sz, name_off = 0;
 
 	if (validate_type_id(ref_type_id))
 		return -EINVAL;
@@ -1654,14 +1661,7 @@ static int btf_add_ref_kind(struct btf *btf, int kind, const char *name, int ref
 	t->info = btf_type_info(kind, 0, 0);
 	t->type = ref_type_id;
 
-	err = btf_add_type_idx_entry(btf, btf->hdr->type_len);
-	if (err)
-		return err;
-
-	btf->hdr->type_len += sz;
-	btf->hdr->str_off += sz;
-	btf->nr_types++;
-	return btf->nr_types;
+	return btf_commit_type(btf, sz);
 }
 
 /*
@@ -1689,7 +1689,7 @@ int btf__add_array(struct btf *btf, int index_type_id, int elem_type_id, __u32 n
 {
 	struct btf_type *t;
 	struct btf_array *a;
-	int sz, err;
+	int sz;
 
 	if (validate_type_id(index_type_id) || validate_type_id(elem_type_id))
 		return -EINVAL;
@@ -1711,21 +1711,14 @@ int btf__add_array(struct btf *btf, int index_type_id, int elem_type_id, __u32 n
 	a->index_type = index_type_id;
 	a->nelems = nr_elems;
 
-	err = btf_add_type_idx_entry(btf, btf->hdr->type_len);
-	if (err)
-		return err;
-
-	btf->hdr->type_len += sz;
-	btf->hdr->str_off += sz;
-	btf->nr_types++;
-	return btf->nr_types;
+	return btf_commit_type(btf, sz);
 }
 
 /* generic STRUCT/UNION append function */
 static int btf_add_composite(struct btf *btf, int kind, const char *name, __u32 bytes_sz)
 {
 	struct btf_type *t;
-	int sz, err, name_off = 0;
+	int sz, name_off = 0;
 
 	if (btf_ensure_modifiable(btf))
 		return -ENOMEM;
@@ -1748,14 +1741,7 @@ static int btf_add_composite(struct btf *btf, int kind, const char *name, __u32
 	t->info = btf_type_info(kind, 0, 0);
 	t->size = bytes_sz;
 
-	err = btf_add_type_idx_entry(btf, btf->hdr->type_len);
-	if (err)
-		return err;
-
-	btf->hdr->type_len += sz;
-	btf->hdr->str_off += sz;
-	btf->nr_types++;
-	return btf->nr_types;
+	return btf_commit_type(btf, sz);
 }
 
 /*
@@ -1793,6 +1779,11 @@ int btf__add_union(struct btf *btf, const char *name, __u32 byte_sz)
 	return btf_add_composite(btf, BTF_KIND_UNION, name, byte_sz);
 }
 
+static struct btf_type *btf_last_type(struct btf *btf)
+{
+	return btf_type_by_id(btf, btf__get_nr_types(btf));
+}
+
 /*
  * Append new field for the current STRUCT/UNION type with:
  *   - *name* - name of the field, can be NULL or empty for anonymous field;
@@ -1814,7 +1805,7 @@ int btf__add_field(struct btf *btf, const char *name, int type_id,
 	/* last type should be union/struct */
 	if (btf->nr_types == 0)
 		return -EINVAL;
-	t = btf_type_by_id(btf, btf->nr_types);
+	t = btf_last_type(btf);
 	if (!btf_is_composite(t))
 		return -EINVAL;
 
@@ -1849,7 +1840,7 @@ int btf__add_field(struct btf *btf, const char *name, int type_id,
 	m->offset = bit_offset | (bit_size << 24);
 
 	/* btf_add_type_mem can invalidate t pointer */
-	t = btf_type_by_id(btf, btf->nr_types);
+	t = btf_last_type(btf);
 	/* update parent type's vlen and kflag */
 	t->info = btf_type_info(btf_kind(t), btf_vlen(t) + 1, is_bitfield || btf_kflag(t));
 
@@ -1874,7 +1865,7 @@ int btf__add_field(struct btf *btf, const char *name, int type_id,
 int btf__add_enum(struct btf *btf, const char *name, __u32 byte_sz)
 {
 	struct btf_type *t;
-	int sz, err, name_off = 0;
+	int sz, name_off = 0;
 
 	/* byte_sz must be power of 2 */
 	if (!byte_sz || (byte_sz & (byte_sz - 1)) || byte_sz > 8)
@@ -1899,14 +1890,7 @@ int btf__add_enum(struct btf *btf, const char *name, __u32 byte_sz)
 	t->info = btf_type_info(BTF_KIND_ENUM, 0, 0);
 	t->size = byte_sz;
 
-	err = btf_add_type_idx_entry(btf, btf->hdr->type_len);
-	if (err)
-		return err;
-
-	btf->hdr->type_len += sz;
-	btf->hdr->str_off += sz;
-	btf->nr_types++;
-	return btf->nr_types;
+	return btf_commit_type(btf, sz);
 }
 
 /*
@@ -1926,7 +1910,7 @@ int btf__add_enum_value(struct btf *btf, const char *name, __s64 value)
 	/* last type should be BTF_KIND_ENUM */
 	if (btf->nr_types == 0)
 		return -EINVAL;
-	t = btf_type_by_id(btf, btf->nr_types);
+	t = btf_last_type(btf);
 	if (!btf_is_enum(t))
 		return -EINVAL;
 
@@ -1953,7 +1937,7 @@ int btf__add_enum_value(struct btf *btf, const char *name, __s64 value)
 	v->val = value;
 
 	/* update parent type's vlen */
-	t = btf_type_by_id(btf, btf->nr_types);
+	t = btf_last_type(btf);
 	btf_type_inc_vlen(t);
 
 	btf->hdr->type_len += sz;
@@ -2093,7 +2077,7 @@ int btf__add_func(struct btf *btf, const char *name,
 int btf__add_func_proto(struct btf *btf, int ret_type_id)
 {
 	struct btf_type *t;
-	int sz, err;
+	int sz;
 
 	if (validate_type_id(ret_type_id))
 		return -EINVAL;
@@ -2113,14 +2097,7 @@ int btf__add_func_proto(struct btf *btf, int ret_type_id)
 	t->info = btf_type_info(BTF_KIND_FUNC_PROTO, 0, 0);
 	t->type = ret_type_id;
 
-	err = btf_add_type_idx_entry(btf, btf->hdr->type_len);
-	if (err)
-		return err;
-
-	btf->hdr->type_len += sz;
-	btf->hdr->str_off += sz;
-	btf->nr_types++;
-	return btf->nr_types;
+	return btf_commit_type(btf, sz);
 }
 
 /*
@@ -2143,7 +2120,7 @@ int btf__add_func_param(struct btf *btf, const char *name, int type_id)
 	/* last type should be BTF_KIND_FUNC_PROTO */
 	if (btf->nr_types == 0)
 		return -EINVAL;
-	t = btf_type_by_id(btf, btf->nr_types);
+	t = btf_last_type(btf);
 	if (!btf_is_func_proto(t))
 		return -EINVAL;
 
@@ -2166,7 +2143,7 @@ int btf__add_func_param(struct btf *btf, const char *name, int type_id)
 	p->type = type_id;
 
 	/* update parent type's vlen */
-	t = btf_type_by_id(btf, btf->nr_types);
+	t = btf_last_type(btf);
 	btf_type_inc_vlen(t);
 
 	btf->hdr->type_len += sz;
@@ -2188,7 +2165,7 @@ int btf__add_var(struct btf *btf, const char *name, int linkage, int type_id)
 {
 	struct btf_type *t;
 	struct btf_var *v;
-	int sz, err, name_off;
+	int sz, name_off;
 
 	/* non-empty name */
 	if (!name || !name[0])
@@ -2219,14 +2196,7 @@ int btf__add_var(struct btf *btf, const char *name, int linkage, int type_id)
 	v = btf_var(t);
 	v->linkage = linkage;
 
-	err = btf_add_type_idx_entry(btf, btf->hdr->type_len);
-	if (err)
-		return err;
-
-	btf->hdr->type_len += sz;
-	btf->hdr->str_off += sz;
-	btf->nr_types++;
-	return btf->nr_types;
+	return btf_commit_type(btf, sz);
 }
 
 /*
@@ -2244,7 +2214,7 @@ int btf__add_var(struct btf *btf, const char *name, int linkage, int type_id)
 int btf__add_datasec(struct btf *btf, const char *name, __u32 byte_sz)
 {
 	struct btf_type *t;
-	int sz, err, name_off;
+	int sz, name_off;
 
 	/* non-empty name */
 	if (!name || !name[0])
@@ -2267,14 +2237,7 @@ int btf__add_datasec(struct btf *btf, const char *name, __u32 byte_sz)
 	t->info = btf_type_info(BTF_KIND_DATASEC, 0, 0);
 	t->size = byte_sz;
 
-	err = btf_add_type_idx_entry(btf, btf->hdr->type_len);
-	if (err)
-		return err;
-
-	btf->hdr->type_len += sz;
-	btf->hdr->str_off += sz;
-	btf->nr_types++;
-	return btf->nr_types;
+	return btf_commit_type(btf, sz);
 }
 
 /*
@@ -2296,7 +2259,7 @@ int btf__add_datasec_var_info(struct btf *btf, int var_type_id, __u32 offset, __
 	/* last type should be BTF_KIND_DATASEC */
 	if (btf->nr_types == 0)
 		return -EINVAL;
-	t = btf_type_by_id(btf, btf->nr_types);
+	t = btf_last_type(btf);
 	if (!btf_is_datasec(t))
 		return -EINVAL;
 
@@ -2317,7 +2280,7 @@ int btf__add_datasec_var_info(struct btf *btf, int var_type_id, __u32 offset, __
 	v->size = byte_sz;
 
 	/* update parent type's vlen */
-	t = btf_type_by_id(btf, btf->nr_types);
+	t = btf_last_type(btf);
 	btf_type_inc_vlen(t);
 
 	btf->hdr->type_len += sz;
-- 
2.24.1

