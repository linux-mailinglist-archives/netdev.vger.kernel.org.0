Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5401D2795DE
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 03:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbgIZBOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 21:14:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47536 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729898AbgIZBOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 21:14:42 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08Q1DZXT031834
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 18:14:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=s3HW88pKP/0kazcphhCZqVfF0k8h1Gl6XFv5Xu4SUak=;
 b=bnkG0zYPz7NIosssyaUEZIVN70+04+9dTg8Aw7UViqZ1vl8n/nqu2dk7H0dh+WvmjZqx
 rRDiWgEco2D71Is7lWQ0UOtoMicfQnm6YpDeUN6Aizva4U+aYumOJ5AP3f/8iCtsfY1v
 JwgrrNnnqOhAGeihhlDLDRrmVKuxaMEpsIw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33sdm1c5fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 18:14:41 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 18:14:41 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3B9E22EC75B0; Fri, 25 Sep 2020 18:14:30 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH v2 bpf-next 3/9] libbpf: generalize common logic for managing dynamically-sized arrays
Date:   Fri, 25 Sep 2020 18:13:51 -0700
Message-ID: <20200926011357.2366158-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200926011357.2366158-1-andriin@fb.com>
References: <20200926011357.2366158-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_19:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 malwarescore=0
 suspectscore=8 bulkscore=0 adultscore=0 phishscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009260006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Managing dynamically-sized array is a common, but not trivial functionali=
ty,
which significant amount of logic and code to implement properly. So inst=
ead
of re-implementing it all the time, extract it into a helper function ans
reuse.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c             | 77 ++++++++++++++++++++++++---------
 tools/lib/bpf/libbpf_internal.h |  3 ++
 2 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index d180a677a3fb..f5255e2bd222 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -51,7 +51,7 @@ struct btf {
=20
 	/* type ID to `struct btf_type *` lookup index */
 	__u32 *type_offs;
-	__u32 type_offs_cap;
+	size_t type_offs_cap;
 	__u32 nr_types;
=20
 	/* BTF object FD, if loaded into kernel */
@@ -66,31 +66,60 @@ static inline __u64 ptr_to_u64(const void *ptr)
 	return (__u64) (unsigned long) ptr;
 }
=20
-static int btf_add_type_idx_entry(struct btf *btf, __u32 type_off)
+/* Ensure given dynamically allocated memory region pointed to by *data*=
 with
+ * capacity of *cap_cnt* elements each taking *elem_sz* bytes has enough
+ * memory to accomodate *add_cnt* new elements, assuming *cur_cnt* eleme=
nts
+ * are already used. At most *max_cnt* elements can be ever allocated.
+ * If necessary, memory is reallocated and all existing data is copied o=
ver,
+ * new pointer to the memory region is stored at *data, new memory regio=
n
+ * capacity (in number of elements) is stored in *cap.
+ * On success, memory pointer to the beginning of unused memory is retur=
ned.
+ * On error, NULL is returned.
+ */
+void *btf_add_mem(void **data, size_t *cap_cnt, size_t elem_sz,
+		  size_t cur_cnt, size_t max_cnt, size_t add_cnt)
 {
-	/* nr_types is 1-based, so N types means we need N+1-sized array */
-	if (btf->nr_types + 2 > btf->type_offs_cap) {
-		__u32 *new_offs;
-		__u32 expand_by, new_size;
+	size_t new_cnt;
+	void *new_data;
=20
-		if (btf->type_offs_cap =3D=3D BTF_MAX_NR_TYPES)
-			return -E2BIG;
+	if (cur_cnt + add_cnt <=3D *cap_cnt)
+		return *data + cur_cnt * elem_sz;
=20
-		expand_by =3D max(btf->type_offs_cap / 4, 16U);
-		new_size =3D min(BTF_MAX_NR_TYPES, btf->type_offs_cap + expand_by);
+	/* requested more than the set limit */
+	if (cur_cnt + add_cnt > max_cnt)
+		return NULL;
=20
-		new_offs =3D libbpf_reallocarray(btf->type_offs, new_size, sizeof(*new=
_offs));
-		if (!new_offs)
-			return -ENOMEM;
+	new_cnt =3D *cap_cnt;
+	new_cnt +=3D new_cnt / 4;		  /* expand by 25% */
+	if (new_cnt < 16)		  /* but at least 16 elements */
+		new_cnt =3D 16;
+	if (new_cnt > max_cnt)		  /* but not exceeding a set limit */
+		new_cnt =3D max_cnt;
+	if (new_cnt < cur_cnt + add_cnt)  /* also ensure we have enough memory =
*/
+		new_cnt =3D cur_cnt + add_cnt;
+
+	new_data =3D libbpf_reallocarray(*data, new_cnt, elem_sz);
+	if (!new_data)
+		return NULL;
=20
-		new_offs[0] =3D UINT_MAX; /* VOID is specially handled */
+	/* zero out newly allocated portion of memory */
+	memset(new_data + (*cap_cnt) * elem_sz, 0, (new_cnt - *cap_cnt) * elem_=
sz);
=20
-		btf->type_offs =3D new_offs;
-		btf->type_offs_cap =3D new_size;
-	}
+	*data =3D new_data;
+	*cap_cnt =3D new_cnt;
+	return new_data + cur_cnt * elem_sz;
+}
=20
-	btf->type_offs[btf->nr_types + 1] =3D type_off;
+static int btf_add_type_idx_entry(struct btf *btf, __u32 type_off)
+{
+	__u32 *p;
+
+	p =3D btf_add_mem((void **)&btf->type_offs, &btf->type_offs_cap, sizeof=
(__u32),
+			btf->nr_types + 1, BTF_MAX_NR_TYPES, 1);
+	if (!p)
+		return -ENOMEM;
=20
+	*p =3D type_off;
 	return 0;
 }
=20
@@ -203,11 +232,17 @@ static int btf_parse_type_sec(struct btf *btf)
 	struct btf_header *hdr =3D btf->hdr;
 	void *next_type =3D btf->types_data;
 	void *end_type =3D next_type + hdr->type_len;
+	int err, type_size;
=20
-	while (next_type < end_type) {
-		int type_size;
-		int err;
+	/* VOID (type_id =3D=3D 0) is specially handled by btf__get_type_by_id(=
),
+	 * so ensure we can never properly use its offset from index by
+	 * setting it to a large value
+	 */
+	err =3D btf_add_type_idx_entry(btf, UINT_MAX);
+	if (err)
+		return err;
=20
+	while (next_type < end_type) {
 		err =3D btf_add_type_idx_entry(btf, next_type - btf->types_data);
 		if (err)
 			return err;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inter=
nal.h
index 4d1c366fca2c..d43ce00e0022 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -105,6 +105,9 @@ static inline void *libbpf_reallocarray(void *ptr, si=
ze_t nmemb, size_t size)
 	return realloc(ptr, total);
 }
=20
+void *btf_add_mem(void **data, size_t *cap_cnt, size_t elem_sz,
+		  size_t cur_cnt, size_t max_cnt, size_t add_cnt);
+
 static inline bool libbpf_validate_opts(const char *opts,
 					size_t opts_sz, size_t user_sz,
 					const char *type_name)
--=20
2.24.1

