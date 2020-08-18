Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5282249105
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgHRWjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:39:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28952 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726852AbgHRWjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:39:37 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IMGPOG002574
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:39:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=l1tzE8EY2u7M6D9dJDgOGMi5kiC8xQCmuSmRuFBrLkQ=;
 b=ojag54mXi5N/fGndyUmVb6AGx7H64CKk+UgtsDszA+fmRTdjNSqVkaTBLoxLjWzmvV/e
 g/s06vYWAZZNLYoATMTIar1u9MlBByyc0ICGC6xoLUZN/qLpLZpKFagj8AHwT3Kdek20
 wAxnHa1UBH0qqxYPphTeMBhPP65Q0kFmAq4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304pawdrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:39:36 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 15:39:36 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7FF982EC5EB9; Tue, 18 Aug 2020 15:39:30 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/9] libbpf: improve error logging for mismatched BTF kind cases
Date:   Tue, 18 Aug 2020 15:39:13 -0700
Message-ID: <20200818223921.2911963-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200818223921.2911963-1-andriin@fb.com>
References: <20200818223921.2911963-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 suspectscore=8 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of printing out integer value of BTF kind, print out a string
representation of a kind.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 59 +++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 18 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5f971796d196..ddc6ae184dc2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1886,6 +1886,29 @@ resolve_func_ptr(const struct btf *btf, __u32 id, =
__u32 *res_id)
 	return btf_is_func_proto(t) ? t : NULL;
 }
=20
+static const char *btf_kind_str(const struct btf_type *t)
+{
+	switch (btf_kind(t)) {
+	case BTF_KIND_UNKN: return "void";
+	case BTF_KIND_INT: return "int";
+	case BTF_KIND_PTR: return "ptr";
+	case BTF_KIND_ARRAY: return "array";
+	case BTF_KIND_STRUCT: return "struct";
+	case BTF_KIND_UNION: return "union";
+	case BTF_KIND_ENUM: return "enum";
+	case BTF_KIND_FWD: return "fwd";
+	case BTF_KIND_TYPEDEF: return "typedef";
+	case BTF_KIND_VOLATILE: return "volatile";
+	case BTF_KIND_CONST: return "const";
+	case BTF_KIND_RESTRICT: return "restrict";
+	case BTF_KIND_FUNC: return "func";
+	case BTF_KIND_FUNC_PROTO: return "func_proto";
+	case BTF_KIND_VAR: return "var";
+	case BTF_KIND_DATASEC: return "datasec";
+	default: return "unknown";
+	}
+}
+
 /*
  * Fetch integer attribute of BTF map definition. Such attributes are
  * represented using a pointer to an array, in which dimensionality of a=
rray
@@ -1902,8 +1925,8 @@ static bool get_map_field_int(const char *map_name,=
 const struct btf *btf,
 	const struct btf_type *arr_t;
=20
 	if (!btf_is_ptr(t)) {
-		pr_warn("map '%s': attr '%s': expected PTR, got %u.\n",
-			map_name, name, btf_kind(t));
+		pr_warn("map '%s': attr '%s': expected PTR, got %s.\n",
+			map_name, name, btf_kind_str(t));
 		return false;
 	}
=20
@@ -1914,8 +1937,8 @@ static bool get_map_field_int(const char *map_name,=
 const struct btf *btf,
 		return false;
 	}
 	if (!btf_is_array(arr_t)) {
-		pr_warn("map '%s': attr '%s': expected ARRAY, got %u.\n",
-			map_name, name, btf_kind(arr_t));
+		pr_warn("map '%s': attr '%s': expected ARRAY, got %s.\n",
+			map_name, name, btf_kind_str(arr_t));
 		return false;
 	}
 	arr_info =3D btf_array(arr_t);
@@ -2009,8 +2032,8 @@ static int parse_btf_map_def(struct bpf_object *obj=
,
 				return -EINVAL;
 			}
 			if (!btf_is_ptr(t)) {
-				pr_warn("map '%s': key spec is not PTR: %u.\n",
-					map->name, btf_kind(t));
+				pr_warn("map '%s': key spec is not PTR: %s.\n",
+					map->name, btf_kind_str(t));
 				return -EINVAL;
 			}
 			sz =3D btf__resolve_size(obj->btf, t->type);
@@ -2051,8 +2074,8 @@ static int parse_btf_map_def(struct bpf_object *obj=
,
 				return -EINVAL;
 			}
 			if (!btf_is_ptr(t)) {
-				pr_warn("map '%s': value spec is not PTR: %u.\n",
-					map->name, btf_kind(t));
+				pr_warn("map '%s': value spec is not PTR: %s.\n",
+					map->name, btf_kind_str(t));
 				return -EINVAL;
 			}
 			sz =3D btf__resolve_size(obj->btf, t->type);
@@ -2109,14 +2132,14 @@ static int parse_btf_map_def(struct bpf_object *o=
bj,
 			t =3D skip_mods_and_typedefs(obj->btf, btf_array(t)->type,
 						   NULL);
 			if (!btf_is_ptr(t)) {
-				pr_warn("map '%s': map-in-map inner def is of unexpected kind %u.\n"=
,
-					map->name, btf_kind(t));
+				pr_warn("map '%s': map-in-map inner def is of unexpected kind %s.\n"=
,
+					map->name, btf_kind_str(t));
 				return -EINVAL;
 			}
 			t =3D skip_mods_and_typedefs(obj->btf, t->type, NULL);
 			if (!btf_is_struct(t)) {
-				pr_warn("map '%s': map-in-map inner def is of unexpected kind %u.\n"=
,
-					map->name, btf_kind(t));
+				pr_warn("map '%s': map-in-map inner def is of unexpected kind %s.\n"=
,
+					map->name, btf_kind_str(t));
 				return -EINVAL;
 			}
=20
@@ -2207,8 +2230,8 @@ static int bpf_object__init_user_btf_map(struct bpf=
_object *obj,
 		return -EINVAL;
 	}
 	if (!btf_is_var(var)) {
-		pr_warn("map '%s': unexpected var kind %u.\n",
-			map_name, btf_kind(var));
+		pr_warn("map '%s': unexpected var kind %s.\n",
+			map_name, btf_kind_str(var));
 		return -EINVAL;
 	}
 	if (var_extra->linkage !=3D BTF_VAR_GLOBAL_ALLOCATED &&
@@ -2220,8 +2243,8 @@ static int bpf_object__init_user_btf_map(struct bpf=
_object *obj,
=20
 	def =3D skip_mods_and_typedefs(obj->btf, var->type, NULL);
 	if (!btf_is_struct(def)) {
-		pr_warn("map '%s': unexpected def kind %u.\n",
-			map_name, btf_kind(var));
+		pr_warn("map '%s': unexpected def kind %s.\n",
+			map_name, btf_kind_str(var));
 		return -EINVAL;
 	}
 	if (def->size > vi->size) {
@@ -4212,8 +4235,8 @@ static int bpf_core_spec_parse(const struct btf *bt=
f,
 				return sz;
 			spec->bit_offset +=3D access_idx * sz * 8;
 		} else {
-			pr_warn("relo for [%u] %s (at idx %d) captures type [%d] of unexpecte=
d kind %d\n",
-				type_id, spec_str, i, id, btf_kind(t));
+			pr_warn("relo for [%u] %s (at idx %d) captures type [%d] of unexpecte=
d kind %s\n",
+				type_id, spec_str, i, id, btf_kind_str(t));
 			return -EINVAL;
 		}
 	}
--=20
2.24.1

