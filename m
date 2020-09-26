Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A172B2795D4
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 03:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbgIZBOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 21:14:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54934 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729426AbgIZBOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 21:14:31 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08Q1DaxJ031854
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 18:14:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=N+MfvwCL+k6RpgSks4ITWT55QbADtR9+wpw7361TpxA=;
 b=nEZ1vCzDM4QxUlJCO3tYbs5yUZP5yVA0CkuVEBhGKdGvHU50623tBBcbcTAIFvFVfT2/
 P1z0c7Yno0ZSyemW8BlhN23WEBag6UiI1Oh4D82ab2VTxYbfSf3K8daaET3y+4UL6HoA
 WaUP6beHwewUTLoPCid2R1FO3eEqZ1+YpO8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33sdm1c5ew-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 18:14:30 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 18:14:29 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 104152EC75B0; Fri, 25 Sep 2020 18:14:28 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH v2 bpf-next 2/9] libbpf: remove assumption of single contiguous memory for BTF data
Date:   Fri, 25 Sep 2020 18:13:50 -0700
Message-ID: <20200926011357.2366158-3-andriin@fb.com>
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
 suspectscore=25 bulkscore=0 adultscore=0 phishscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009260006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor internals of struct btf to remove assumptions that BTF header, t=
ype
data, and string data are layed out contiguously in a memory in a single
memory allocation. Now we have three separate pointers pointing to the st=
art
of each respective are: header, types, strings. In the next patches, thes=
e
pointers will be re-assigned to point to independently allocated memory a=
reas,
if BTF needs to be modified.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf.c |  2 +-
 tools/lib/bpf/bpf.h |  2 +-
 tools/lib/bpf/btf.c | 99 ++++++++++++++++++++++++++-------------------
 3 files changed, 60 insertions(+), 43 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 2baa1308737c..9f3224c385af 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -815,7 +815,7 @@ int bpf_raw_tracepoint_open(const char *name, int pro=
g_fd)
 	return sys_bpf(BPF_RAW_TRACEPOINT_OPEN, &attr, sizeof(attr));
 }
=20
-int bpf_load_btf(void *btf, __u32 btf_size, char *log_buf, __u32 log_buf=
_size,
+int bpf_load_btf(const void *btf, __u32 btf_size, char *log_buf, __u32 l=
og_buf_size,
 		 bool do_log)
 {
 	union bpf_attr attr =3D {};
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 8c1ac4b42f90..671a6e6a4ce9 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -234,7 +234,7 @@ LIBBPF_API int bpf_prog_query(int target_fd, enum bpf=
_attach_type type,
 			      __u32 query_flags, __u32 *attach_flags,
 			      __u32 *prog_ids, __u32 *prog_cnt);
 LIBBPF_API int bpf_raw_tracepoint_open(const char *name, int prog_fd);
-LIBBPF_API int bpf_load_btf(void *btf, __u32 btf_size, char *log_buf,
+LIBBPF_API int bpf_load_btf(const void *btf, __u32 btf_size, char *log_b=
uf,
 			    __u32 log_buf_size, bool do_log);
 LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf=
,
 				 __u32 *buf_len, __u32 *prog_id, __u32 *fd_type,
diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 7c9957893ef2..d180a677a3fb 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -27,18 +27,37 @@
 static struct btf_type btf_void;
=20
 struct btf {
-	union {
-		struct btf_header *hdr;
-		void *data;
-	};
+	void *raw_data;
+	__u32 raw_size;
+
+	/*
+	 * When BTF is loaded from ELF or raw memory it is stored
+	 * in contiguous memory block, pointed to by raw_data pointer, and
+	 * hdr, types_data, and strs_data point inside that memory region to
+	 * respective parts of BTF representation:
+	 *
+	 * +--------------------------------+
+	 * |  Header  |  Types  |  Strings  |
+	 * +--------------------------------+
+	 * ^          ^         ^
+	 * |          |         |
+	 * hdr        |         |
+	 * types_data-+         |
+	 * strs_data------------+
+	 */
+	struct btf_header *hdr;
+	void *types_data;
+	void *strs_data;
+
+	/* type ID to `struct btf_type *` lookup index */
 	__u32 *type_offs;
 	__u32 type_offs_cap;
-	const char *strings;
-	void *nohdr_data;
-	void *types_data;
 	__u32 nr_types;
-	__u32 data_size;
+
+	/* BTF object FD, if loaded into kernel */
 	int fd;
+
+	/* Pointer size (in bytes) for a target architecture of this BTF */
 	int ptr_sz;
 };
=20
@@ -80,7 +99,7 @@ static int btf_parse_hdr(struct btf *btf)
 	const struct btf_header *hdr =3D btf->hdr;
 	__u32 meta_left;
=20
-	if (btf->data_size < sizeof(struct btf_header)) {
+	if (btf->raw_size < sizeof(struct btf_header)) {
 		pr_debug("BTF header not found\n");
 		return -EINVAL;
 	}
@@ -100,7 +119,7 @@ static int btf_parse_hdr(struct btf *btf)
 		return -ENOTSUP;
 	}
=20
-	meta_left =3D btf->data_size - sizeof(*hdr);
+	meta_left =3D btf->raw_size - sizeof(*hdr);
 	if (!meta_left) {
 		pr_debug("BTF has no data\n");
 		return -EINVAL;
@@ -126,15 +145,13 @@ static int btf_parse_hdr(struct btf *btf)
 		return -EINVAL;
 	}
=20
-	btf->nohdr_data =3D btf->hdr + 1;
-
 	return 0;
 }
=20
 static int btf_parse_str_sec(struct btf *btf)
 {
 	const struct btf_header *hdr =3D btf->hdr;
-	const char *start =3D btf->nohdr_data + hdr->str_off;
+	const char *start =3D btf->strs_data;
 	const char *end =3D start + btf->hdr->str_len;
=20
 	if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_STR_OFFSET ||
@@ -143,8 +160,6 @@ static int btf_parse_str_sec(struct btf *btf)
 		return -EINVAL;
 	}
=20
-	btf->strings =3D start;
-
 	return 0;
 }
=20
@@ -186,11 +201,9 @@ static int btf_type_size(const struct btf_type *t)
 static int btf_parse_type_sec(struct btf *btf)
 {
 	struct btf_header *hdr =3D btf->hdr;
-	void *next_type =3D btf->nohdr_data + hdr->type_off;
+	void *next_type =3D btf->types_data;
 	void *end_type =3D next_type + hdr->type_len;
=20
-	btf->types_data =3D next_type;
-
 	while (next_type < end_type) {
 		int type_size;
 		int err;
@@ -466,7 +479,7 @@ void btf__free(struct btf *btf)
 	if (btf->fd >=3D 0)
 		close(btf->fd);
=20
-	free(btf->data);
+	free(btf->raw_data);
 	free(btf->type_offs);
 	free(btf);
 }
@@ -482,24 +495,24 @@ struct btf *btf__new(const void *data, __u32 size)
=20
 	btf->fd =3D -1;
=20
-	btf->data =3D malloc(size);
-	if (!btf->data) {
+	btf->raw_data =3D malloc(size);
+	if (!btf->raw_data) {
 		err =3D -ENOMEM;
 		goto done;
 	}
+	memcpy(btf->raw_data, data, size);
+	btf->raw_size =3D size;
=20
-	memcpy(btf->data, data, size);
-	btf->data_size =3D size;
-
+	btf->hdr =3D btf->raw_data;
 	err =3D btf_parse_hdr(btf);
 	if (err)
 		goto done;
=20
-	err =3D btf_parse_str_sec(btf);
-	if (err)
-		goto done;
+	btf->strs_data =3D btf->raw_data + btf->hdr->hdr_len + btf->hdr->str_of=
f;
+	btf->types_data =3D btf->raw_data + btf->hdr->hdr_len + btf->hdr->type_=
off;
=20
-	err =3D btf_parse_type_sec(btf);
+	err =3D btf_parse_str_sec(btf);
+	err =3D err ?: btf_parse_type_sec(btf);
=20
 done:
 	if (err) {
@@ -820,8 +833,9 @@ int btf__finalize_data(struct bpf_object *obj, struct=
 btf *btf)
=20
 int btf__load(struct btf *btf)
 {
-	__u32 log_buf_size =3D 0;
+	__u32 log_buf_size =3D 0, raw_size;
 	char *log_buf =3D NULL;
+	const void *raw_data;
 	int err =3D 0;
=20
 	if (btf->fd >=3D 0)
@@ -836,8 +850,13 @@ int btf__load(struct btf *btf)
 		*log_buf =3D 0;
 	}
=20
-	btf->fd =3D bpf_load_btf(btf->data, btf->data_size,
-			       log_buf, log_buf_size, false);
+	raw_data =3D btf__get_raw_data(btf, &raw_size);
+	if (!raw_data) {
+		err =3D -ENOMEM;
+		goto done;
+	}
+
+	btf->fd =3D bpf_load_btf(raw_data, raw_size, log_buf, log_buf_size, fal=
se);
 	if (btf->fd < 0) {
 		if (!log_buf || errno =3D=3D ENOSPC) {
 			log_buf_size =3D max((__u32)BPF_LOG_BUF_SIZE,
@@ -870,14 +889,14 @@ void btf__set_fd(struct btf *btf, int fd)
=20
 const void *btf__get_raw_data(const struct btf *btf, __u32 *size)
 {
-	*size =3D btf->data_size;
-	return btf->data;
+	*size =3D btf->raw_size;
+	return btf->raw_data;
 }
=20
 const char *btf__name_by_offset(const struct btf *btf, __u32 offset)
 {
 	if (offset < btf->hdr->str_len)
-		return &btf->strings[offset];
+		return btf->strs_data + offset;
 	else
 		return NULL;
 }
@@ -1860,8 +1879,7 @@ static int btf_str_remap_offset(__u32 *str_off_ptr,=
 void *ctx)
  */
 static int btf_dedup_strings(struct btf_dedup *d)
 {
-	const struct btf_header *hdr =3D d->btf->hdr;
-	char *start =3D (char *)d->btf->nohdr_data + hdr->str_off;
+	char *start =3D d->btf->strs_data;
 	char *end =3D start + d->btf->hdr->str_len;
 	char *p =3D start, *tmp_strs =3D NULL;
 	struct btf_str_ptrs strs =3D {
@@ -2970,12 +2988,11 @@ static int btf_dedup_compact_types(struct btf_ded=
up *d)
 	d->btf->type_offs =3D new_offs;
=20
 	/* make sure string section follows type information without gaps */
-	d->btf->hdr->str_off =3D p - d->btf->nohdr_data;
-	memmove(p, d->btf->strings, d->btf->hdr->str_len);
-	d->btf->strings =3D p;
-	p +=3D d->btf->hdr->str_len;
+	d->btf->hdr->str_off =3D p - d->btf->types_data;
+	memmove(p, d->btf->strs_data, d->btf->hdr->str_len);
+	d->btf->strs_data =3D p;
=20
-	d->btf->data_size =3D p - d->btf->data;
+	d->btf->raw_size =3D d->btf->hdr->hdr_len + d->btf->hdr->type_len + d->=
btf->hdr->str_len;
 	return 0;
 }
=20
--=20
2.24.1

