Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7CF27DCA4
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 01:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgI2X2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 19:28:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8368 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728688AbgI2X2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 19:28:52 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TNSJKT006361
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:28:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=kHSEbW5SMAWa7h4w/c+ZexrEt/aqFlnk3kNznpXE0qM=;
 b=PJ4BRwpdfua4X9lByU6Z5c4CpE/P+KJS0uGBl8mTD8G0IGefQoPHrV4qEvsFvJ2D7CVR
 cLnX/lwogrn5auweMnmhtOV5ffW7t68u81BMFj2EIRAjUKT66GJysCB5SFy5Vf4iqM1c
 j+lgtotF9veIoD8/hVXoWGYZ27vz1ky40uo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33t3fhg3qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:28:51 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 16:28:50 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7363B2EC77D1; Tue, 29 Sep 2020 16:28:47 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next 1/4] libbpf: make btf_dump work with modifiable BTF
Date:   Tue, 29 Sep 2020 16:28:40 -0700
Message-ID: <20200929232843.1249318-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200929232843.1249318-1-andriin@fb.com>
References: <20200929232843.1249318-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 suspectscore=25 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290198
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that btf_dump can accommodate new BTF types being appended to BTF
instance after struct btf_dump was created. This came up during attemp to
use btf_dump for raw type dumping in selftests, but given changes are not
excessive, it's good to not have any gotchas in API usage, so I decided t=
o
support such use case in general.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c             | 17 ++++++++
 tools/lib/bpf/btf_dump.c        | 69 ++++++++++++++++++++++-----------
 tools/lib/bpf/libbpf_internal.h |  1 +
 3 files changed, 65 insertions(+), 22 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index e1dbd766c698..df4fd9132079 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -146,6 +146,23 @@ void *btf_add_mem(void **data, size_t *cap_cnt, size=
_t elem_sz,
 	return new_data + cur_cnt * elem_sz;
 }
=20
+/* Ensure given dynamically allocated memory region has enough allocated=
 space
+ * to accommodate *need_cnt* elements of size *elem_sz* bytes each
+ */
+int btf_ensure_mem(void **data, size_t *cap_cnt, size_t elem_sz, size_t =
need_cnt)
+{
+	void *p;
+
+	if (need_cnt <=3D *cap_cnt)
+		return 0;
+
+	p =3D btf_add_mem(data, cap_cnt, elem_sz, *cap_cnt, SIZE_MAX, need_cnt =
- *cap_cnt);
+	if (!p)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static int btf_add_type_idx_entry(struct btf *btf, __u32 type_off)
 {
 	__u32 *p;
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 91310e528a3a..2f9d685bd522 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -60,11 +60,14 @@ struct btf_dump {
 	struct btf_dump_opts opts;
 	int ptr_sz;
 	bool strip_mods;
+	int last_id;
=20
 	/* per-type auxiliary state */
 	struct btf_dump_type_aux_state *type_states;
+	size_t type_states_cap;
 	/* per-type optional cached unique name, must be freed, if present */
 	const char **cached_names;
+	size_t cached_names_cap;
=20
 	/* topo-sorted list of dependent type definitions */
 	__u32 *emit_queue;
@@ -113,6 +116,7 @@ static void btf_dump_printf(const struct btf_dump *d,=
 const char *fmt, ...)
 }
=20
 static int btf_dump_mark_referenced(struct btf_dump *d);
+static int btf_dump_resize(struct btf_dump *d);
=20
 struct btf_dump *btf_dump__new(const struct btf *btf,
 			       const struct btf_ext *btf_ext,
@@ -144,25 +148,8 @@ struct btf_dump *btf_dump__new(const struct btf *btf=
,
 		d->ident_names =3D NULL;
 		goto err;
 	}
-	d->type_states =3D calloc(1 + btf__get_nr_types(d->btf),
-				sizeof(d->type_states[0]));
-	if (!d->type_states) {
-		err =3D -ENOMEM;
-		goto err;
-	}
-	d->cached_names =3D calloc(1 + btf__get_nr_types(d->btf),
-				 sizeof(d->cached_names[0]));
-	if (!d->cached_names) {
-		err =3D -ENOMEM;
-		goto err;
-	}
=20
-	/* VOID is special */
-	d->type_states[0].order_state =3D ORDERED;
-	d->type_states[0].emit_state =3D EMITTED;
-
-	/* eagerly determine referenced types for anon enums */
-	err =3D btf_dump_mark_referenced(d);
+	err =3D btf_dump_resize(d);
 	if (err)
 		goto err;
=20
@@ -172,9 +159,38 @@ struct btf_dump *btf_dump__new(const struct btf *btf=
,
 	return ERR_PTR(err);
 }
=20
+static int btf_dump_resize(struct btf_dump *d)
+{
+	int err, last_id =3D btf__get_nr_types(d->btf);
+
+	if (last_id <=3D d->last_id)
+		return 0;
+
+	if (btf_ensure_mem((void **)&d->type_states, &d->type_states_cap,
+			   sizeof(*d->type_states), last_id + 1))
+		return -ENOMEM;
+	if (btf_ensure_mem((void **)&d->cached_names, &d->cached_names_cap,
+			   sizeof(*d->cached_names), last_id + 1))
+		return -ENOMEM;
+
+	if (d->last_id =3D=3D 0) {
+		/* VOID is special */
+		d->type_states[0].order_state =3D ORDERED;
+		d->type_states[0].emit_state =3D EMITTED;
+	}
+
+	/* eagerly determine referenced types for anon enums */
+	err =3D btf_dump_mark_referenced(d);
+	if (err)
+		return err;
+
+	d->last_id =3D last_id;
+	return 0;
+}
+
 void btf_dump__free(struct btf_dump *d)
 {
-	int i, cnt;
+	int i;
=20
 	if (IS_ERR_OR_NULL(d))
 		return;
@@ -182,7 +198,7 @@ void btf_dump__free(struct btf_dump *d)
 	free(d->type_states);
 	if (d->cached_names) {
 		/* any set cached name is owned by us and should be freed */
-		for (i =3D 0, cnt =3D btf__get_nr_types(d->btf); i <=3D cnt; i++) {
+		for (i =3D 0; i <=3D d->last_id; i++) {
 			if (d->cached_names[i])
 				free((void *)d->cached_names[i]);
 		}
@@ -222,6 +238,10 @@ int btf_dump__dump_type(struct btf_dump *d, __u32 id=
)
 	if (id > btf__get_nr_types(d->btf))
 		return -EINVAL;
=20
+	err =3D btf_dump_resize(d);
+	if (err)
+		return err;
+
 	d->emit_queue_cnt =3D 0;
 	err =3D btf_dump_order_type(d, id, false);
 	if (err < 0)
@@ -251,7 +271,7 @@ static int btf_dump_mark_referenced(struct btf_dump *=
d)
 	const struct btf_type *t;
 	__u16 vlen;
=20
-	for (i =3D 1; i <=3D n; i++) {
+	for (i =3D d->last_id + 1; i <=3D n; i++) {
 		t =3D btf__type_by_id(d->btf, i);
 		vlen =3D btf_vlen(t);
=20
@@ -306,6 +326,7 @@ static int btf_dump_mark_referenced(struct btf_dump *=
d)
 	}
 	return 0;
 }
+
 static int btf_dump_add_emit_queue_id(struct btf_dump *d, __u32 id)
 {
 	__u32 *new_queue;
@@ -1049,11 +1070,15 @@ int btf_dump__emit_type_decl(struct btf_dump *d, =
__u32 id,
 			     const struct btf_dump_emit_type_decl_opts *opts)
 {
 	const char *fname;
-	int lvl;
+	int lvl, err;
=20
 	if (!OPTS_VALID(opts, btf_dump_emit_type_decl_opts))
 		return -EINVAL;
=20
+	err =3D btf_dump_resize(d);
+	if (err)
+		return -EINVAL;
+
 	fname =3D OPTS_GET(opts, field_name, "");
 	lvl =3D OPTS_GET(opts, indent_level, 0);
 	d->strip_mods =3D OPTS_GET(opts, strip_mods, false);
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inter=
nal.h
index eed5b624a784..d99bc847bf84 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -107,6 +107,7 @@ static inline void *libbpf_reallocarray(void *ptr, si=
ze_t nmemb, size_t size)
=20
 void *btf_add_mem(void **data, size_t *cap_cnt, size_t elem_sz,
 		  size_t cur_cnt, size_t max_cnt, size_t add_cnt);
+int btf_ensure_mem(void **data, size_t *cap_cnt, size_t elem_sz, size_t =
need_cnt);
=20
 static inline bool libbpf_validate_opts(const char *opts,
 					size_t opts_sz, size_t user_sz,
--=20
2.24.1

