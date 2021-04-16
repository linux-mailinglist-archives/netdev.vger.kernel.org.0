Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A2A362937
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245653AbhDPUYt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 16 Apr 2021 16:24:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57200 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245624AbhDPUYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 16:24:48 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13GKIujk026839
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 13:24:22 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37yb5e2dh0-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 13:24:22 -0700
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Apr 2021 13:24:21 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6BC2A2ED4EE0; Fri, 16 Apr 2021 13:24:17 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 06/17] libbpf: refactor BTF map definition parsing
Date:   Fri, 16 Apr 2021 13:23:53 -0700
Message-ID: <20210416202404.3443623-7-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416202404.3443623-1-andrii@kernel.org>
References: <20210416202404.3443623-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 36N8VDJHextReTShYF9TU5-mVL4mJypN
X-Proofpoint-ORIG-GUID: 36N8VDJHextReTShYF9TU5-mVL4mJypN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-16_09:2021-04-16,2021-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 phishscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor BTF-defined maps parsing logic to allow it to be nicely reused by BPF
static linker. Further, at least for BPF static linker, it's important to know
which attributes of a BPF map were defined explicitly, so provide a bit set
for each known portion of BTF map definition. This allows BPF static linker to
do a simple check when dealing with extern map declarations.

The same capabilities allow to distinguish attributes explicitly set to zero
(e.g., __uint(max_entries, 0)) vs the case of not specifying it at all (no
max_entries attribute at all). Libbpf is currently not utilizing that, but it
could be useful for backwards compatibility reasons later.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c          | 256 ++++++++++++++++++--------------
 tools/lib/bpf/libbpf_internal.h |  32 ++++
 2 files changed, 177 insertions(+), 111 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a0e6d6bc47f3..f6f4126389ac 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2025,255 +2025,262 @@ static int build_map_pin_path(struct bpf_map *map, const char *path)
 	return bpf_map__set_pin_path(map, buf);
 }
 
-
-static int parse_btf_map_def(struct bpf_object *obj,
-			     struct bpf_map *map,
-			     const struct btf_type *def,
-			     bool strict, bool is_inner,
-			     const char *pin_root_path)
+int parse_btf_map_def(const char *map_name, struct btf *btf,
+		      const struct btf_type *def_t, bool strict,
+		      struct btf_map_def *map_def, struct btf_map_def *inner_def)
 {
 	const struct btf_type *t;
 	const struct btf_member *m;
+	bool is_inner = inner_def == NULL;
 	int vlen, i;
 
-	vlen = btf_vlen(def);
-	m = btf_members(def);
+	vlen = btf_vlen(def_t);
+	m = btf_members(def_t);
 	for (i = 0; i < vlen; i++, m++) {
-		const char *name = btf__name_by_offset(obj->btf, m->name_off);
+		const char *name = btf__name_by_offset(btf, m->name_off);
 
 		if (!name) {
-			pr_warn("map '%s': invalid field #%d.\n", map->name, i);
+			pr_warn("map '%s': invalid field #%d.\n", map_name, i);
 			return -EINVAL;
 		}
 		if (strcmp(name, "type") == 0) {
-			if (!get_map_field_int(map->name, obj->btf, m,
-					       &map->def.type))
+			if (!get_map_field_int(map_name, btf, m, &map_def->map_type))
 				return -EINVAL;
-			pr_debug("map '%s': found type = %u.\n",
-				 map->name, map->def.type);
+			map_def->parts |= MAP_DEF_MAP_TYPE;
 		} else if (strcmp(name, "max_entries") == 0) {
-			if (!get_map_field_int(map->name, obj->btf, m,
-					       &map->def.max_entries))
+			if (!get_map_field_int(map_name, btf, m, &map_def->max_entries))
 				return -EINVAL;
-			pr_debug("map '%s': found max_entries = %u.\n",
-				 map->name, map->def.max_entries);
+			map_def->parts |= MAP_DEF_MAX_ENTRIES;
 		} else if (strcmp(name, "map_flags") == 0) {
-			if (!get_map_field_int(map->name, obj->btf, m,
-					       &map->def.map_flags))
+			if (!get_map_field_int(map_name, btf, m, &map_def->map_flags))
 				return -EINVAL;
-			pr_debug("map '%s': found map_flags = %u.\n",
-				 map->name, map->def.map_flags);
+			map_def->parts |= MAP_DEF_MAP_FLAGS;
 		} else if (strcmp(name, "numa_node") == 0) {
-			if (!get_map_field_int(map->name, obj->btf, m, &map->numa_node))
+			if (!get_map_field_int(map_name, btf, m, &map_def->numa_node))
 				return -EINVAL;
-			pr_debug("map '%s': found numa_node = %u.\n", map->name, map->numa_node);
+			map_def->parts |= MAP_DEF_NUMA_NODE;
 		} else if (strcmp(name, "key_size") == 0) {
 			__u32 sz;
 
-			if (!get_map_field_int(map->name, obj->btf, m, &sz))
+			if (!get_map_field_int(map_name, btf, m, &sz))
 				return -EINVAL;
-			pr_debug("map '%s': found key_size = %u.\n",
-				 map->name, sz);
-			if (map->def.key_size && map->def.key_size != sz) {
+			if (map_def->key_size && map_def->key_size != sz) {
 				pr_warn("map '%s': conflicting key size %u != %u.\n",
-					map->name, map->def.key_size, sz);
+					map_name, map_def->key_size, sz);
 				return -EINVAL;
 			}
-			map->def.key_size = sz;
+			map_def->key_size = sz;
+			map_def->parts |= MAP_DEF_KEY_SIZE;
 		} else if (strcmp(name, "key") == 0) {
 			__s64 sz;
 
-			t = btf__type_by_id(obj->btf, m->type);
+			t = btf__type_by_id(btf, m->type);
 			if (!t) {
 				pr_warn("map '%s': key type [%d] not found.\n",
-					map->name, m->type);
+					map_name, m->type);
 				return -EINVAL;
 			}
 			if (!btf_is_ptr(t)) {
 				pr_warn("map '%s': key spec is not PTR: %s.\n",
-					map->name, btf_kind_str(t));
+					map_name, btf_kind_str(t));
 				return -EINVAL;
 			}
-			sz = btf__resolve_size(obj->btf, t->type);
+			sz = btf__resolve_size(btf, t->type);
 			if (sz < 0) {
 				pr_warn("map '%s': can't determine key size for type [%u]: %zd.\n",
-					map->name, t->type, (ssize_t)sz);
+					map_name, t->type, (ssize_t)sz);
 				return sz;
 			}
-			pr_debug("map '%s': found key [%u], sz = %zd.\n",
-				 map->name, t->type, (ssize_t)sz);
-			if (map->def.key_size && map->def.key_size != sz) {
+			if (map_def->key_size && map_def->key_size != sz) {
 				pr_warn("map '%s': conflicting key size %u != %zd.\n",
-					map->name, map->def.key_size, (ssize_t)sz);
+					map_name, map_def->key_size, (ssize_t)sz);
 				return -EINVAL;
 			}
-			map->def.key_size = sz;
-			map->btf_key_type_id = t->type;
+			map_def->key_size = sz;
+			map_def->key_type_id = t->type;
+			map_def->parts |= MAP_DEF_KEY_SIZE | MAP_DEF_KEY_TYPE;
 		} else if (strcmp(name, "value_size") == 0) {
 			__u32 sz;
 
-			if (!get_map_field_int(map->name, obj->btf, m, &sz))
+			if (!get_map_field_int(map_name, btf, m, &sz))
 				return -EINVAL;
-			pr_debug("map '%s': found value_size = %u.\n",
-				 map->name, sz);
-			if (map->def.value_size && map->def.value_size != sz) {
+			if (map_def->value_size && map_def->value_size != sz) {
 				pr_warn("map '%s': conflicting value size %u != %u.\n",
-					map->name, map->def.value_size, sz);
+					map_name, map_def->value_size, sz);
 				return -EINVAL;
 			}
-			map->def.value_size = sz;
+			map_def->value_size = sz;
+			map_def->parts |= MAP_DEF_VALUE_SIZE;
 		} else if (strcmp(name, "value") == 0) {
 			__s64 sz;
 
-			t = btf__type_by_id(obj->btf, m->type);
+			t = btf__type_by_id(btf, m->type);
 			if (!t) {
 				pr_warn("map '%s': value type [%d] not found.\n",
-					map->name, m->type);
+					map_name, m->type);
 				return -EINVAL;
 			}
 			if (!btf_is_ptr(t)) {
 				pr_warn("map '%s': value spec is not PTR: %s.\n",
-					map->name, btf_kind_str(t));
+					map_name, btf_kind_str(t));
 				return -EINVAL;
 			}
-			sz = btf__resolve_size(obj->btf, t->type);
+			sz = btf__resolve_size(btf, t->type);
 			if (sz < 0) {
 				pr_warn("map '%s': can't determine value size for type [%u]: %zd.\n",
-					map->name, t->type, (ssize_t)sz);
+					map_name, t->type, (ssize_t)sz);
 				return sz;
 			}
-			pr_debug("map '%s': found value [%u], sz = %zd.\n",
-				 map->name, t->type, (ssize_t)sz);
-			if (map->def.value_size && map->def.value_size != sz) {
+			if (map_def->value_size && map_def->value_size != sz) {
 				pr_warn("map '%s': conflicting value size %u != %zd.\n",
-					map->name, map->def.value_size, (ssize_t)sz);
+					map_name, map_def->value_size, (ssize_t)sz);
 				return -EINVAL;
 			}
-			map->def.value_size = sz;
-			map->btf_value_type_id = t->type;
+			map_def->value_size = sz;
+			map_def->value_type_id = t->type;
+			map_def->parts |= MAP_DEF_VALUE_SIZE | MAP_DEF_VALUE_TYPE;
 		}
 		else if (strcmp(name, "values") == 0) {
+			char inner_map_name[128];
 			int err;
 
 			if (is_inner) {
 				pr_warn("map '%s': multi-level inner maps not supported.\n",
-					map->name);
+					map_name);
 				return -ENOTSUP;
 			}
 			if (i != vlen - 1) {
 				pr_warn("map '%s': '%s' member should be last.\n",
-					map->name, name);
+					map_name, name);
 				return -EINVAL;
 			}
-			if (!bpf_map_type__is_map_in_map(map->def.type)) {
+			if (!bpf_map_type__is_map_in_map(map_def->map_type)) {
 				pr_warn("map '%s': should be map-in-map.\n",
-					map->name);
+					map_name);
 				return -ENOTSUP;
 			}
-			if (map->def.value_size && map->def.value_size != 4) {
+			if (map_def->value_size && map_def->value_size != 4) {
 				pr_warn("map '%s': conflicting value size %u != 4.\n",
-					map->name, map->def.value_size);
+					map_name, map_def->value_size);
 				return -EINVAL;
 			}
-			map->def.value_size = 4;
-			t = btf__type_by_id(obj->btf, m->type);
+			map_def->value_size = 4;
+			t = btf__type_by_id(btf, m->type);
 			if (!t) {
 				pr_warn("map '%s': map-in-map inner type [%d] not found.\n",
-					map->name, m->type);
+					map_name, m->type);
 				return -EINVAL;
 			}
 			if (!btf_is_array(t) || btf_array(t)->nelems) {
 				pr_warn("map '%s': map-in-map inner spec is not a zero-sized array.\n",
-					map->name);
+					map_name);
 				return -EINVAL;
 			}
-			t = skip_mods_and_typedefs(obj->btf, btf_array(t)->type,
-						   NULL);
+			t = skip_mods_and_typedefs(btf, btf_array(t)->type, NULL);
 			if (!btf_is_ptr(t)) {
 				pr_warn("map '%s': map-in-map inner def is of unexpected kind %s.\n",
-					map->name, btf_kind_str(t));
+					map_name, btf_kind_str(t));
 				return -EINVAL;
 			}
-			t = skip_mods_and_typedefs(obj->btf, t->type, NULL);
+			t = skip_mods_and_typedefs(btf, t->type, NULL);
 			if (!btf_is_struct(t)) {
 				pr_warn("map '%s': map-in-map inner def is of unexpected kind %s.\n",
-					map->name, btf_kind_str(t));
+					map_name, btf_kind_str(t));
 				return -EINVAL;
 			}
 
-			map->inner_map = calloc(1, sizeof(*map->inner_map));
-			if (!map->inner_map)
-				return -ENOMEM;
-			map->inner_map->fd = -1;
-			map->inner_map->sec_idx = obj->efile.btf_maps_shndx;
-			map->inner_map->name = malloc(strlen(map->name) +
-						      sizeof(".inner") + 1);
-			if (!map->inner_map->name)
-				return -ENOMEM;
-			sprintf(map->inner_map->name, "%s.inner", map->name);
-
-			err = parse_btf_map_def(obj, map->inner_map, t, strict,
-						true /* is_inner */, NULL);
+			snprintf(inner_map_name, sizeof(inner_map_name), "%s.inner", map_name);
+			err = parse_btf_map_def(inner_map_name, btf, t, strict, inner_def, NULL);
 			if (err)
 				return err;
+
+			map_def->parts |= MAP_DEF_INNER_MAP;
 		} else if (strcmp(name, "pinning") == 0) {
 			__u32 val;
-			int err;
 
 			if (is_inner) {
-				pr_debug("map '%s': inner def can't be pinned.\n",
-					 map->name);
+				pr_warn("map '%s': inner def can't be pinned.\n", map_name);
 				return -EINVAL;
 			}
-			if (!get_map_field_int(map->name, obj->btf, m, &val))
+			if (!get_map_field_int(map_name, btf, m, &val))
 				return -EINVAL;
-			pr_debug("map '%s': found pinning = %u.\n",
-				 map->name, val);
-
-			if (val != LIBBPF_PIN_NONE &&
-			    val != LIBBPF_PIN_BY_NAME) {
+			if (val != LIBBPF_PIN_NONE && val != LIBBPF_PIN_BY_NAME) {
 				pr_warn("map '%s': invalid pinning value %u.\n",
-					map->name, val);
+					map_name, val);
 				return -EINVAL;
 			}
-			if (val == LIBBPF_PIN_BY_NAME) {
-				err = build_map_pin_path(map, pin_root_path);
-				if (err) {
-					pr_warn("map '%s': couldn't build pin path.\n",
-						map->name);
-					return err;
-				}
-			}
+			map_def->pinning = val;
+			map_def->parts |= MAP_DEF_PINNING;
 		} else {
 			if (strict) {
-				pr_warn("map '%s': unknown field '%s'.\n",
-					map->name, name);
+				pr_warn("map '%s': unknown field '%s'.\n", map_name, name);
 				return -ENOTSUP;
 			}
-			pr_debug("map '%s': ignoring unknown field '%s'.\n",
-				 map->name, name);
+			pr_debug("map '%s': ignoring unknown field '%s'.\n", map_name, name);
 		}
 	}
 
-	if (map->def.type == BPF_MAP_TYPE_UNSPEC) {
-		pr_warn("map '%s': map type isn't specified.\n", map->name);
+	if (map_def->map_type == BPF_MAP_TYPE_UNSPEC) {
+		pr_warn("map '%s': map type isn't specified.\n", map_name);
 		return -EINVAL;
 	}
 
 	return 0;
 }
 
+static void fill_map_from_def(struct bpf_map *map, const struct btf_map_def *def)
+{
+	map->def.type = def->map_type;
+	map->def.key_size = def->key_size;
+	map->def.value_size = def->value_size;
+	map->def.max_entries = def->max_entries;
+	map->def.map_flags = def->map_flags;
+
+	map->numa_node = def->numa_node;
+	map->btf_key_type_id = def->key_type_id;
+	map->btf_value_type_id = def->value_type_id;
+
+	if (def->parts & MAP_DEF_MAP_TYPE)
+		pr_debug("map '%s': found type = %u.\n", map->name, def->map_type);
+
+	if (def->parts & MAP_DEF_KEY_TYPE)
+		pr_debug("map '%s': found key [%u], sz = %u.\n",
+			 map->name, def->key_type_id, def->key_size);
+	else if (def->parts & MAP_DEF_KEY_SIZE)
+		pr_debug("map '%s': found key_size = %u.\n", map->name, def->key_size);
+
+	if (def->parts & MAP_DEF_VALUE_TYPE)
+		pr_debug("map '%s': found value [%u], sz = %u.\n",
+			 map->name, def->value_type_id, def->value_size);
+	else if (def->parts & MAP_DEF_VALUE_SIZE)
+		pr_debug("map '%s': found value_size = %u.\n", map->name, def->value_size);
+
+	if (def->parts & MAP_DEF_MAX_ENTRIES)
+		pr_debug("map '%s': found max_entries = %u.\n", map->name, def->max_entries);
+	if (def->parts & MAP_DEF_MAP_FLAGS)
+		pr_debug("map '%s': found map_flags = %u.\n", map->name, def->map_flags);
+	if (def->parts & MAP_DEF_PINNING)
+		pr_debug("map '%s': found pinning = %u.\n", map->name, def->pinning);
+	if (def->parts & MAP_DEF_NUMA_NODE)
+		pr_debug("map '%s': found numa_node = %u.\n", map->name, def->numa_node);
+
+	if (def->parts & MAP_DEF_INNER_MAP)
+		pr_debug("map '%s': found inner map definition.\n", map->name);
+}
+
 static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 					 const struct btf_type *sec,
 					 int var_idx, int sec_idx,
 					 const Elf_Data *data, bool strict,
 					 const char *pin_root_path)
 {
+	struct btf_map_def map_def = {}, inner_def = {};
 	const struct btf_type *var, *def;
 	const struct btf_var_secinfo *vi;
 	const struct btf_var *var_extra;
 	const char *map_name;
 	struct bpf_map *map;
+	int err;
 
 	vi = btf_var_secinfos(sec) + var_idx;
 	var = btf__type_by_id(obj->btf, vi->type);
@@ -2327,7 +2334,34 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 	pr_debug("map '%s': at sec_idx %d, offset %zu.\n",
 		 map_name, map->sec_idx, map->sec_offset);
 
-	return parse_btf_map_def(obj, map, def, strict, false, pin_root_path);
+	err = parse_btf_map_def(map->name, obj->btf, def, strict, &map_def, &inner_def);
+	if (err)
+		return err;
+
+	fill_map_from_def(map, &map_def);
+
+	if (map_def.pinning == LIBBPF_PIN_BY_NAME) {
+		err = build_map_pin_path(map, pin_root_path);
+		if (err) {
+			pr_warn("map '%s': couldn't build pin path.\n", map->name);
+			return err;
+		}
+	}
+
+	if (map_def.parts & MAP_DEF_INNER_MAP) {
+		map->inner_map = calloc(1, sizeof(*map->inner_map));
+		if (!map->inner_map)
+			return -ENOMEM;
+		map->inner_map->fd = -1;
+		map->inner_map->name = malloc(strlen(map_name) + sizeof(".inner") + 1);
+		if (!map->inner_map->name)
+			return -ENOMEM;
+		sprintf(map->inner_map->name, "%s.inner", map_name);
+
+		fill_map_from_def(map->inner_map, &inner_def);
+	}
+
+	return 0;
 }
 
 static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 92b7eae10c6d..17883073710c 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -138,6 +138,38 @@ static inline __u32 btf_type_info(int kind, int vlen, int kflag)
 	return (kflag << 31) | (kind << 24) | vlen;
 }
 
+enum map_def_parts {
+	MAP_DEF_MAP_TYPE	= 0x001,
+	MAP_DEF_KEY_TYPE	= 0x002,
+	MAP_DEF_KEY_SIZE	= 0x004,
+	MAP_DEF_VALUE_TYPE	= 0x008,
+	MAP_DEF_VALUE_SIZE	= 0x010,
+	MAP_DEF_MAX_ENTRIES	= 0x020,
+	MAP_DEF_MAP_FLAGS	= 0x040,
+	MAP_DEF_NUMA_NODE	= 0x080,
+	MAP_DEF_PINNING		= 0x100,
+	MAP_DEF_INNER_MAP	= 0x200,
+
+	MAP_DEF_ALL		= 0x3ff, /* combination of all above */
+};
+
+struct btf_map_def {
+	enum map_def_parts parts;
+	__u32 map_type;
+	__u32 key_type_id;
+	__u32 key_size;
+	__u32 value_type_id;
+	__u32 value_size;
+	__u32 max_entries;
+	__u32 map_flags;
+	__u32 numa_node;
+	__u32 pinning;
+};
+
+int parse_btf_map_def(const char *map_name, struct btf *btf,
+		      const struct btf_type *def_t, bool strict,
+		      struct btf_map_def *map_def, struct btf_map_def *inner_def);
+
 void *libbpf_add_mem(void **data, size_t *cap_cnt, size_t elem_sz,
 		     size_t cur_cnt, size_t max_cnt, size_t add_cnt);
 int libbpf_ensure_mem(void **data, size_t *cap_cnt, size_t elem_sz, size_t need_cnt);
-- 
2.30.2

