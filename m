Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A749B1BB6EE
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 08:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgD1Glx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 02:41:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3742 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726272AbgD1Glw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 02:41:52 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03S6eRs9029313
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 23:41:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=wPJMP0VgmUJsmQJJu+hv7/U4wtBP9PIUI21+dOwbSBs=;
 b=dbxK6UEIQs0Hy/DWdiTtoQSoeCf5gAQYncYqV9hE/SHxpX6K9GuBgLMc58A+4jrjYsnT
 H7ntkCY3ckn40leo3DDblFHd0+7zhXsAabFcOHuW9BK1UnRjSwbPORmw9ImKfzy4hQnC
 cfs+QdWWeZNQrWwxgNkovIvq4a6az1LfR04= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30mjqn9028-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 23:41:50 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 23:41:49 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8032F2EC2FA7; Mon, 27 Apr 2020 23:41:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <toke@redhat.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/3] libbpf: refactor BTF-defined map definition parsing logic
Date:   Mon, 27 Apr 2020 23:41:37 -0700
Message-ID: <20200428064140.122796-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200428064140.122796-1-andriin@fb.com>
References: <20200428064140.122796-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_03:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=8 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004280057
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out BTF map definition logic into stand-alone routine for easier r=
euse
for map-in-map case.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 195 ++++++++++++++++++++++-------------------
 1 file changed, 103 insertions(+), 92 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8e1dc6980fac..7d10436d7b58 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1914,109 +1914,54 @@ static int build_map_pin_path(struct bpf_map *ma=
p, const char *path)
 	return 0;
 }
=20
-static int bpf_object__init_user_btf_map(struct bpf_object *obj,
-					 const struct btf_type *sec,
-					 int var_idx, int sec_idx,
-					 const Elf_Data *data, bool strict,
-					 const char *pin_root_path)
+
+static int parse_btf_map_def(struct bpf_object *obj,
+			     struct bpf_map *map,
+			     const struct btf_type *def,
+			     bool strict,
+			     const char *pin_root_path)
 {
-	const struct btf_type *var, *def, *t;
-	const struct btf_var_secinfo *vi;
-	const struct btf_var *var_extra;
+	const struct btf_type *t;
 	const struct btf_member *m;
-	const char *map_name;
-	struct bpf_map *map;
 	int vlen, i;
=20
-	vi =3D btf_var_secinfos(sec) + var_idx;
-	var =3D btf__type_by_id(obj->btf, vi->type);
-	var_extra =3D btf_var(var);
-	map_name =3D btf__name_by_offset(obj->btf, var->name_off);
-	vlen =3D btf_vlen(var);
-
-	if (map_name =3D=3D NULL || map_name[0] =3D=3D '\0') {
-		pr_warn("map #%d: empty name.\n", var_idx);
-		return -EINVAL;
-	}
-	if ((__u64)vi->offset + vi->size > data->d_size) {
-		pr_warn("map '%s' BTF data is corrupted.\n", map_name);
-		return -EINVAL;
-	}
-	if (!btf_is_var(var)) {
-		pr_warn("map '%s': unexpected var kind %u.\n",
-			map_name, btf_kind(var));
-		return -EINVAL;
-	}
-	if (var_extra->linkage !=3D BTF_VAR_GLOBAL_ALLOCATED &&
-	    var_extra->linkage !=3D BTF_VAR_STATIC) {
-		pr_warn("map '%s': unsupported var linkage %u.\n",
-			map_name, var_extra->linkage);
-		return -EOPNOTSUPP;
-	}
-
-	def =3D skip_mods_and_typedefs(obj->btf, var->type, NULL);
-	if (!btf_is_struct(def)) {
-		pr_warn("map '%s': unexpected def kind %u.\n",
-			map_name, btf_kind(var));
-		return -EINVAL;
-	}
-	if (def->size > vi->size) {
-		pr_warn("map '%s': invalid def size.\n", map_name);
-		return -EINVAL;
-	}
-
-	map =3D bpf_object__add_map(obj);
-	if (IS_ERR(map))
-		return PTR_ERR(map);
-	map->name =3D strdup(map_name);
-	if (!map->name) {
-		pr_warn("map '%s': failed to alloc map name.\n", map_name);
-		return -ENOMEM;
-	}
-	map->libbpf_type =3D LIBBPF_MAP_UNSPEC;
-	map->def.type =3D BPF_MAP_TYPE_UNSPEC;
-	map->sec_idx =3D sec_idx;
-	map->sec_offset =3D vi->offset;
-	pr_debug("map '%s': at sec_idx %d, offset %zu.\n",
-		 map_name, map->sec_idx, map->sec_offset);
-
 	vlen =3D btf_vlen(def);
 	m =3D btf_members(def);
 	for (i =3D 0; i < vlen; i++, m++) {
 		const char *name =3D btf__name_by_offset(obj->btf, m->name_off);
=20
 		if (!name) {
-			pr_warn("map '%s': invalid field #%d.\n", map_name, i);
+			pr_warn("map '%s': invalid field #%d.\n", map->name, i);
 			return -EINVAL;
 		}
 		if (strcmp(name, "type") =3D=3D 0) {
-			if (!get_map_field_int(map_name, obj->btf, m,
+			if (!get_map_field_int(map->name, obj->btf, m,
 					       &map->def.type))
 				return -EINVAL;
 			pr_debug("map '%s': found type =3D %u.\n",
-				 map_name, map->def.type);
+				 map->name, map->def.type);
 		} else if (strcmp(name, "max_entries") =3D=3D 0) {
-			if (!get_map_field_int(map_name, obj->btf, m,
+			if (!get_map_field_int(map->name, obj->btf, m,
 					       &map->def.max_entries))
 				return -EINVAL;
 			pr_debug("map '%s': found max_entries =3D %u.\n",
-				 map_name, map->def.max_entries);
+				 map->name, map->def.max_entries);
 		} else if (strcmp(name, "map_flags") =3D=3D 0) {
-			if (!get_map_field_int(map_name, obj->btf, m,
+			if (!get_map_field_int(map->name, obj->btf, m,
 					       &map->def.map_flags))
 				return -EINVAL;
 			pr_debug("map '%s': found map_flags =3D %u.\n",
-				 map_name, map->def.map_flags);
+				 map->name, map->def.map_flags);
 		} else if (strcmp(name, "key_size") =3D=3D 0) {
 			__u32 sz;
=20
-			if (!get_map_field_int(map_name, obj->btf, m, &sz))
+			if (!get_map_field_int(map->name, obj->btf, m, &sz))
 				return -EINVAL;
 			pr_debug("map '%s': found key_size =3D %u.\n",
-				 map_name, sz);
+				 map->name, sz);
 			if (map->def.key_size && map->def.key_size !=3D sz) {
 				pr_warn("map '%s': conflicting key size %u !=3D %u.\n",
-					map_name, map->def.key_size, sz);
+					map->name, map->def.key_size, sz);
 				return -EINVAL;
 			}
 			map->def.key_size =3D sz;
@@ -2026,25 +1971,25 @@ static int bpf_object__init_user_btf_map(struct b=
pf_object *obj,
 			t =3D btf__type_by_id(obj->btf, m->type);
 			if (!t) {
 				pr_warn("map '%s': key type [%d] not found.\n",
-					map_name, m->type);
+					map->name, m->type);
 				return -EINVAL;
 			}
 			if (!btf_is_ptr(t)) {
 				pr_warn("map '%s': key spec is not PTR: %u.\n",
-					map_name, btf_kind(t));
+					map->name, btf_kind(t));
 				return -EINVAL;
 			}
 			sz =3D btf__resolve_size(obj->btf, t->type);
 			if (sz < 0) {
 				pr_warn("map '%s': can't determine key size for type [%u]: %zd.\n",
-					map_name, t->type, (ssize_t)sz);
+					map->name, t->type, (ssize_t)sz);
 				return sz;
 			}
 			pr_debug("map '%s': found key [%u], sz =3D %zd.\n",
-				 map_name, t->type, (ssize_t)sz);
+				 map->name, t->type, (ssize_t)sz);
 			if (map->def.key_size && map->def.key_size !=3D sz) {
 				pr_warn("map '%s': conflicting key size %u !=3D %zd.\n",
-					map_name, map->def.key_size, (ssize_t)sz);
+					map->name, map->def.key_size, (ssize_t)sz);
 				return -EINVAL;
 			}
 			map->def.key_size =3D sz;
@@ -2052,13 +1997,13 @@ static int bpf_object__init_user_btf_map(struct b=
pf_object *obj,
 		} else if (strcmp(name, "value_size") =3D=3D 0) {
 			__u32 sz;
=20
-			if (!get_map_field_int(map_name, obj->btf, m, &sz))
+			if (!get_map_field_int(map->name, obj->btf, m, &sz))
 				return -EINVAL;
 			pr_debug("map '%s': found value_size =3D %u.\n",
-				 map_name, sz);
+				 map->name, sz);
 			if (map->def.value_size && map->def.value_size !=3D sz) {
 				pr_warn("map '%s': conflicting value size %u !=3D %u.\n",
-					map_name, map->def.value_size, sz);
+					map->name, map->def.value_size, sz);
 				return -EINVAL;
 			}
 			map->def.value_size =3D sz;
@@ -2068,25 +2013,25 @@ static int bpf_object__init_user_btf_map(struct b=
pf_object *obj,
 			t =3D btf__type_by_id(obj->btf, m->type);
 			if (!t) {
 				pr_warn("map '%s': value type [%d] not found.\n",
-					map_name, m->type);
+					map->name, m->type);
 				return -EINVAL;
 			}
 			if (!btf_is_ptr(t)) {
 				pr_warn("map '%s': value spec is not PTR: %u.\n",
-					map_name, btf_kind(t));
+					map->name, btf_kind(t));
 				return -EINVAL;
 			}
 			sz =3D btf__resolve_size(obj->btf, t->type);
 			if (sz < 0) {
 				pr_warn("map '%s': can't determine value size for type [%u]: %zd.\n"=
,
-					map_name, t->type, (ssize_t)sz);
+					map->name, t->type, (ssize_t)sz);
 				return sz;
 			}
 			pr_debug("map '%s': found value [%u], sz =3D %zd.\n",
-				 map_name, t->type, (ssize_t)sz);
+				 map->name, t->type, (ssize_t)sz);
 			if (map->def.value_size && map->def.value_size !=3D sz) {
 				pr_warn("map '%s': conflicting value size %u !=3D %zd.\n",
-					map_name, map->def.value_size, (ssize_t)sz);
+					map->name, map->def.value_size, (ssize_t)sz);
 				return -EINVAL;
 			}
 			map->def.value_size =3D sz;
@@ -2095,44 +2040,110 @@ static int bpf_object__init_user_btf_map(struct =
bpf_object *obj,
 			__u32 val;
 			int err;
=20
-			if (!get_map_field_int(map_name, obj->btf, m, &val))
+			if (!get_map_field_int(map->name, obj->btf, m, &val))
 				return -EINVAL;
 			pr_debug("map '%s': found pinning =3D %u.\n",
-				 map_name, val);
+				 map->name, val);
=20
 			if (val !=3D LIBBPF_PIN_NONE &&
 			    val !=3D LIBBPF_PIN_BY_NAME) {
 				pr_warn("map '%s': invalid pinning value %u.\n",
-					map_name, val);
+					map->name, val);
 				return -EINVAL;
 			}
 			if (val =3D=3D LIBBPF_PIN_BY_NAME) {
 				err =3D build_map_pin_path(map, pin_root_path);
 				if (err) {
 					pr_warn("map '%s': couldn't build pin path.\n",
-						map_name);
+						map->name);
 					return err;
 				}
 			}
 		} else {
 			if (strict) {
 				pr_warn("map '%s': unknown field '%s'.\n",
-					map_name, name);
+					map->name, name);
 				return -ENOTSUP;
 			}
 			pr_debug("map '%s': ignoring unknown field '%s'.\n",
-				 map_name, name);
+				 map->name, name);
 		}
 	}
=20
 	if (map->def.type =3D=3D BPF_MAP_TYPE_UNSPEC) {
-		pr_warn("map '%s': map type isn't specified.\n", map_name);
+		pr_warn("map '%s': map type isn't specified.\n", map->name);
 		return -EINVAL;
 	}
=20
 	return 0;
 }
=20
+static int bpf_object__init_user_btf_map(struct bpf_object *obj,
+					 const struct btf_type *sec,
+					 int var_idx, int sec_idx,
+					 const Elf_Data *data, bool strict,
+					 const char *pin_root_path)
+{
+	const struct btf_type *var, *def;
+	const struct btf_var_secinfo *vi;
+	const struct btf_var *var_extra;
+	const char *map_name;
+	struct bpf_map *map;
+
+	vi =3D btf_var_secinfos(sec) + var_idx;
+	var =3D btf__type_by_id(obj->btf, vi->type);
+	var_extra =3D btf_var(var);
+	map_name =3D btf__name_by_offset(obj->btf, var->name_off);
+
+	if (map_name =3D=3D NULL || map_name[0] =3D=3D '\0') {
+		pr_warn("map #%d: empty name.\n", var_idx);
+		return -EINVAL;
+	}
+	if ((__u64)vi->offset + vi->size > data->d_size) {
+		pr_warn("map '%s' BTF data is corrupted.\n", map_name);
+		return -EINVAL;
+	}
+	if (!btf_is_var(var)) {
+		pr_warn("map '%s': unexpected var kind %u.\n",
+			map_name, btf_kind(var));
+		return -EINVAL;
+	}
+	if (var_extra->linkage !=3D BTF_VAR_GLOBAL_ALLOCATED &&
+	    var_extra->linkage !=3D BTF_VAR_STATIC) {
+		pr_warn("map '%s': unsupported var linkage %u.\n",
+			map_name, var_extra->linkage);
+		return -EOPNOTSUPP;
+	}
+
+	def =3D skip_mods_and_typedefs(obj->btf, var->type, NULL);
+	if (!btf_is_struct(def)) {
+		pr_warn("map '%s': unexpected def kind %u.\n",
+			map_name, btf_kind(var));
+		return -EINVAL;
+	}
+	if (def->size > vi->size) {
+		pr_warn("map '%s': invalid def size.\n", map_name);
+		return -EINVAL;
+	}
+
+	map =3D bpf_object__add_map(obj);
+	if (IS_ERR(map))
+		return PTR_ERR(map);
+	map->name =3D strdup(map_name);
+	if (!map->name) {
+		pr_warn("map '%s': failed to alloc map name.\n", map_name);
+		return -ENOMEM;
+	}
+	map->libbpf_type =3D LIBBPF_MAP_UNSPEC;
+	map->def.type =3D BPF_MAP_TYPE_UNSPEC;
+	map->sec_idx =3D sec_idx;
+	map->sec_offset =3D vi->offset;
+	pr_debug("map '%s': at sec_idx %d, offset %zu.\n",
+		 map_name, map->sec_idx, map->sec_offset);
+
+	return parse_btf_map_def(obj, map, def, strict, pin_root_path);
+}
+
 static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool s=
trict,
 					  const char *pin_root_path)
 {
--=20
2.24.1

