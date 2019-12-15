Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D897511F6BD
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 08:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfLOHIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 02:08:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51078 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbfLOHIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 02:08:51 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBF753qQ031158
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 23:08:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=fNUmZ/c+Z7Qf0hb5SI6/I1PxqCXo+lk6rXrRg7XQwW0=;
 b=rQ6ck5RHlvvyd+JH0XpGzj6aD9yfVGM2UAmvAJiNLWa9WX7oV8bWWgDjpKRqDlgTGrCQ
 heCnoMrD4MgPhusnXzRDcrp8xja6Rhg0LbvWamv1FLQCRSELf6eMJLuYxeYQn0QGUhmf
 w0G1n4LHOJNH88v3IQQOeBIxrJQiXt+/D58= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvxbvag6y-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 23:08:50 -0800
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 14 Dec 2019 23:08:48 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 367522EC1683; Sat, 14 Dec 2019 23:08:48 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/2] libbpf: support flexible arrays in CO-RE
Date:   Sat, 14 Dec 2019 23:08:43 -0800
Message-ID: <20191215070844.1014385-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191215070844.1014385-1-andriin@fb.com>
References: <20191215070844.1014385-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-15_01:2019-12-13,2019-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 malwarescore=0 suspectscore=8 lowpriorityscore=0 mlxlogscore=902
 mlxscore=0 spamscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912150066
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some data stuctures in kernel are defined with either zero-sized array or
flexible (dimensionless) array at the end of a struct. Actual data of such
array follows in memory immediately after the end of that struct, forming its
variable-sized "body" of elements. Support such access pattern in CO-RE
relocation handling.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 27d5f7ecba32..51e7a25c6c88 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2537,6 +2537,21 @@ static bool str_is_empty(const char *s)
 	return !s || !s[0];
 }
 
+static bool is_flex_arr(const struct btf *btf,
+			const struct bpf_core_accessor *acc,
+			const struct btf_array *arr)
+{
+	const struct btf_type *t;
+
+	/* not a flexible array, if not inside a struct or has non-zero size */
+	if (!acc->name || arr->nelems > 0)
+		return false;
+
+	/* has to be the last member of enclosing struct */
+	t = btf__type_by_id(btf, acc->type_id);
+	return acc->idx == btf_vlen(t) - 1;
+}
+
 /*
  * Turn bpf_field_reloc into a low- and high-level spec representation,
  * validating correctness along the way, as well as calculating resulting
@@ -2574,6 +2589,7 @@ static int bpf_core_spec_parse(const struct btf *btf,
 			       struct bpf_core_spec *spec)
 {
 	int access_idx, parsed_len, i;
+	struct bpf_core_accessor *acc;
 	const struct btf_type *t;
 	const char *name;
 	__u32 id;
@@ -2621,6 +2637,7 @@ static int bpf_core_spec_parse(const struct btf *btf,
 			return -EINVAL;
 
 		access_idx = spec->raw_spec[i];
+		acc = &spec->spec[spec->len];
 
 		if (btf_is_composite(t)) {
 			const struct btf_member *m;
@@ -2638,18 +2655,23 @@ static int bpf_core_spec_parse(const struct btf *btf,
 				if (str_is_empty(name))
 					return -EINVAL;
 
-				spec->spec[spec->len].type_id = id;
-				spec->spec[spec->len].idx = access_idx;
-				spec->spec[spec->len].name = name;
+				acc->type_id = id;
+				acc->idx = access_idx;
+				acc->name = name;
 				spec->len++;
 			}
 
 			id = m->type;
 		} else if (btf_is_array(t)) {
 			const struct btf_array *a = btf_array(t);
+			bool flex;
 
 			t = skip_mods_and_typedefs(btf, a->type, &id);
-			if (!t || access_idx >= a->nelems)
+			if (!t)
+				return -EINVAL;
+
+			flex = is_flex_arr(btf, acc - 1, a);
+			if (!flex && access_idx >= a->nelems)
 				return -EINVAL;
 
 			spec->spec[spec->len].type_id = id;
@@ -2954,12 +2976,14 @@ static int bpf_core_spec_match(struct bpf_core_spec *local_spec,
 			 */
 			if (i > 0) {
 				const struct btf_array *a;
+				bool flex;
 
 				if (!btf_is_array(targ_type))
 					return 0;
 
 				a = btf_array(targ_type);
-				if (local_acc->idx >= a->nelems)
+				flex = is_flex_arr(targ_btf, targ_acc - 1, a);
+				if (!flex && local_acc->idx >= a->nelems)
 					return 0;
 				if (!skip_mods_and_typedefs(targ_btf, a->type,
 							    &targ_id))
-- 
2.17.1

