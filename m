Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DBA340E7B
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhCRTlW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Mar 2021 15:41:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25484 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232922AbhCRTkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:40:53 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IJYU4V025668
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:40:53 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37bs1epbqx-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:40:53 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 18 Mar 2021 12:40:52 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6220F2ED2588; Thu, 18 Mar 2021 12:40:48 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v4 bpf-next 03/12] libbpf: rename internal memory-management helpers
Date:   Thu, 18 Mar 2021 12:40:27 -0700
Message-ID: <20210318194036.3521577-4-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318194036.3521577-1-andrii@kernel.org>
References: <20210318194036.3521577-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_12:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename btf_add_mem() and btf_ensure_mem() helpers that abstract away details
of dynamically resizable memory to use libbpf_ prefix, as they are not
BTF-specific. No functional changes.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/btf.c             | 24 ++++++++++++------------
 tools/lib/bpf/btf_dump.c        |  8 ++++----
 tools/lib/bpf/libbpf.c          |  4 ++--
 tools/lib/bpf/libbpf_internal.h |  6 +++---
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index e137781f9bc6..c98d39710515 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -142,8 +142,8 @@ static inline __u64 ptr_to_u64(const void *ptr)
  * On success, memory pointer to the beginning of unused memory is returned.
  * On error, NULL is returned.
  */
-void *btf_add_mem(void **data, size_t *cap_cnt, size_t elem_sz,
-		  size_t cur_cnt, size_t max_cnt, size_t add_cnt)
+void *libbpf_add_mem(void **data, size_t *cap_cnt, size_t elem_sz,
+		     size_t cur_cnt, size_t max_cnt, size_t add_cnt)
 {
 	size_t new_cnt;
 	void *new_data;
@@ -179,14 +179,14 @@ void *btf_add_mem(void **data, size_t *cap_cnt, size_t elem_sz,
 /* Ensure given dynamically allocated memory region has enough allocated space
  * to accommodate *need_cnt* elements of size *elem_sz* bytes each
  */
-int btf_ensure_mem(void **data, size_t *cap_cnt, size_t elem_sz, size_t need_cnt)
+int libbpf_ensure_mem(void **data, size_t *cap_cnt, size_t elem_sz, size_t need_cnt)
 {
 	void *p;
 
 	if (need_cnt <= *cap_cnt)
 		return 0;
 
-	p = btf_add_mem(data, cap_cnt, elem_sz, *cap_cnt, SIZE_MAX, need_cnt - *cap_cnt);
+	p = libbpf_add_mem(data, cap_cnt, elem_sz, *cap_cnt, SIZE_MAX, need_cnt - *cap_cnt);
 	if (!p)
 		return -ENOMEM;
 
@@ -197,8 +197,8 @@ static int btf_add_type_idx_entry(struct btf *btf, __u32 type_off)
 {
 	__u32 *p;
 
-	p = btf_add_mem((void **)&btf->type_offs, &btf->type_offs_cap, sizeof(__u32),
-			btf->nr_types, BTF_MAX_NR_TYPES, 1);
+	p = libbpf_add_mem((void **)&btf->type_offs, &btf->type_offs_cap, sizeof(__u32),
+			   btf->nr_types, BTF_MAX_NR_TYPES, 1);
 	if (!p)
 		return -ENOMEM;
 
@@ -1586,8 +1586,8 @@ static int btf_ensure_modifiable(struct btf *btf)
 
 static void *btf_add_str_mem(struct btf *btf, size_t add_sz)
 {
-	return btf_add_mem(&btf->strs_data, &btf->strs_data_cap, 1,
-			   btf->hdr->str_len, BTF_MAX_STR_OFFSET, add_sz);
+	return libbpf_add_mem(&btf->strs_data, &btf->strs_data_cap, 1,
+			      btf->hdr->str_len, BTF_MAX_STR_OFFSET, add_sz);
 }
 
 /* Find an offset in BTF string section that corresponds to a given string *s*.
@@ -1683,8 +1683,8 @@ int btf__add_str(struct btf *btf, const char *s)
 
 static void *btf_add_type_mem(struct btf *btf, size_t add_sz)
 {
-	return btf_add_mem(&btf->types_data, &btf->types_data_cap, 1,
-			   btf->hdr->type_len, UINT_MAX, add_sz);
+	return libbpf_add_mem(&btf->types_data, &btf->types_data_cap, 1,
+			      btf->hdr->type_len, UINT_MAX, add_sz);
 }
 
 static __u32 btf_type_info(int kind, int vlen, int kflag)
@@ -3208,7 +3208,7 @@ static int strs_dedup_remap_str_off(__u32 *str_off_ptr, void *ctx)
 	len = strlen(s) + 1;
 
 	new_off = d->strs_len;
-	p = btf_add_mem(&d->strs_data, &d->strs_cap, 1, new_off, BTF_MAX_STR_OFFSET, len);
+	p = libbpf_add_mem(&d->strs_data, &d->strs_cap, 1, new_off, BTF_MAX_STR_OFFSET, len);
 	if (!p)
 		return -ENOMEM;
 
@@ -3264,7 +3264,7 @@ static int btf_dedup_strings(struct btf_dedup *d)
 	}
 
 	if (!d->btf->base_btf) {
-		s = btf_add_mem(&d->strs_data, &d->strs_cap, 1, d->strs_len, BTF_MAX_STR_OFFSET, 1);
+		s = libbpf_add_mem(&d->strs_data, &d->strs_cap, 1, d->strs_len, BTF_MAX_STR_OFFSET, 1);
 		if (!s)
 			return -ENOMEM;
 		/* initial empty string */
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 5e957fcceee6..b5dbd5adc0e8 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -166,11 +166,11 @@ static int btf_dump_resize(struct btf_dump *d)
 	if (last_id <= d->last_id)
 		return 0;
 
-	if (btf_ensure_mem((void **)&d->type_states, &d->type_states_cap,
-			   sizeof(*d->type_states), last_id + 1))
+	if (libbpf_ensure_mem((void **)&d->type_states, &d->type_states_cap,
+			      sizeof(*d->type_states), last_id + 1))
 		return -ENOMEM;
-	if (btf_ensure_mem((void **)&d->cached_names, &d->cached_names_cap,
-			   sizeof(*d->cached_names), last_id + 1))
+	if (libbpf_ensure_mem((void **)&d->cached_names, &d->cached_names_cap,
+			      sizeof(*d->cached_names), last_id + 1))
 		return -ENOMEM;
 
 	if (d->last_id == 0) {
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2f351d3ad3e7..18ba37164e17 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4867,8 +4867,8 @@ static int load_module_btfs(struct bpf_object *obj)
 			goto err_out;
 		}
 
-		err = btf_ensure_mem((void **)&obj->btf_modules, &obj->btf_module_cap,
-				     sizeof(*obj->btf_modules), obj->btf_module_cnt + 1);
+		err = libbpf_ensure_mem((void **)&obj->btf_modules, &obj->btf_module_cap,
+				        sizeof(*obj->btf_modules), obj->btf_module_cnt + 1);
 		if (err)
 			goto err_out;
 
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 97b6b9cc9839..e0787900eeca 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -112,9 +112,9 @@ struct btf_type;
 
 struct btf_type *btf_type_by_id(struct btf *btf, __u32 type_id);
 
-void *btf_add_mem(void **data, size_t *cap_cnt, size_t elem_sz,
-		  size_t cur_cnt, size_t max_cnt, size_t add_cnt);
-int btf_ensure_mem(void **data, size_t *cap_cnt, size_t elem_sz, size_t need_cnt);
+void *libbpf_add_mem(void **data, size_t *cap_cnt, size_t elem_sz,
+		     size_t cur_cnt, size_t max_cnt, size_t add_cnt);
+int libbpf_ensure_mem(void **data, size_t *cap_cnt, size_t elem_sz, size_t need_cnt);
 
 static inline bool libbpf_validate_opts(const char *opts,
 					size_t opts_sz, size_t user_sz,
-- 
2.30.2

