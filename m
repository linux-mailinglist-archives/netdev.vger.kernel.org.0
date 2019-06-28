Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2272359ECB
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 17:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfF1PZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 11:25:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27096 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbfF1PZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 11:25:46 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SFOI92025802
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:25:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=X76oJ7beTx+bSEj2jks83TttnQqsCfjae1BFZG7LRnw=;
 b=bj+Z6eMj1Bv8byq8shCez1yVk2JyhK6PcvpjV7on0bqSLXoC2JFN6wqvm6tUpXaWDhYJ
 SAe/NBEKG7AHkXxe3KkpHy0AtB3CltnK6gidS/6HACuMr4RO7N5vYMC1x8rRgtwqUO4x
 1UW0dvW2MGJiZRENnskOl1XNuHB1xOYzNbw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2td9ka279f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:25:44 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 28 Jun 2019 08:25:43 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 05797861486; Fri, 28 Jun 2019 08:25:43 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 1/4] libbpf: capture value in BTF type info for BTF-defined map defs
Date:   Fri, 28 Jun 2019 08:25:36 -0700
Message-ID: <20190628152539.3014719-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628152539.3014719-1-andriin@fb.com>
References: <20190628152539.3014719-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=926 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280178
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change BTF-defined map definitions to capture compile-time integer
values as part of BTF type definition, to avoid split of key/value type
information and actual type/size/flags initialization for maps.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 58 ++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6e6ebef11ba3..9e099ecb2c2b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1028,40 +1028,40 @@ static const struct btf_type *skip_mods_and_typedefs(const struct btf *btf,
 	}
 }
 
-static bool get_map_field_int(const char *map_name,
-			      const struct btf *btf,
+/*
+ * Fetch integer attribute of BTF map definition. Such attributes are
+ * represented using a pointer to an array, in which dimensionality of array
+ * encodes specified integer value. E.g., int (*type)[BPF_MAP_TYPE_ARRAY];
+ * encodes `type => BPF_MAP_TYPE_ARRAY` key/value pair completely using BTF
+ * type definition, while using only sizeof(void *) space in ELF data section.
+ */
+static bool get_map_field_int(const char *map_name, const struct btf *btf,
 			      const struct btf_type *def,
-			      const struct btf_member *m,
-			      const void *data, __u32 *res) {
+			      const struct btf_member *m, __u32 *res) {
 	const struct btf_type *t = skip_mods_and_typedefs(btf, m->type);
 	const char *name = btf__name_by_offset(btf, m->name_off);
-	__u32 int_info = *(const __u32 *)(const void *)(t + 1);
+	const struct btf_array *arr_info;
+	const struct btf_type *arr_t;
 
-	if (BTF_INFO_KIND(t->info) != BTF_KIND_INT) {
-		pr_warning("map '%s': attr '%s': expected INT, got %u.\n",
+	if (BTF_INFO_KIND(t->info) != BTF_KIND_PTR) {
+		pr_warning("map '%s': attr '%s': expected PTR, got %u.\n",
 			   map_name, name, BTF_INFO_KIND(t->info));
 		return false;
 	}
-	if (t->size != 4 || BTF_INT_BITS(int_info) != 32 ||
-	    BTF_INT_OFFSET(int_info)) {
-		pr_warning("map '%s': attr '%s': expected 32-bit non-bitfield integer, "
-			   "got %u-byte (%d-bit) one with bit offset %d.\n",
-			   map_name, name, t->size, BTF_INT_BITS(int_info),
-			   BTF_INT_OFFSET(int_info));
-		return false;
-	}
-	if (BTF_INFO_KFLAG(def->info) && BTF_MEMBER_BITFIELD_SIZE(m->offset)) {
-		pr_warning("map '%s': attr '%s': bitfield is not supported.\n",
-			   map_name, name);
+
+	arr_t = btf__type_by_id(btf, t->type);
+	if (!arr_t) {
+		pr_warning("map '%s': attr '%s': type [%u] not found.\n",
+			   map_name, name, t->type);
 		return false;
 	}
-	if (m->offset % 32) {
-		pr_warning("map '%s': attr '%s': unaligned fields are not supported.\n",
-			   map_name, name);
+	if (BTF_INFO_KIND(arr_t->info) != BTF_KIND_ARRAY) {
+		pr_warning("map '%s': attr '%s': expected ARRAY, got %u.\n",
+			   map_name, name, BTF_INFO_KIND(arr_t->info));
 		return false;
 	}
-
-	*res = *(const __u32 *)(data + m->offset / 8);
+	arr_info = (const void *)(arr_t + 1);
+	*res = arr_info->nelems;
 	return true;
 }
 
@@ -1074,7 +1074,6 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 	const struct btf_var_secinfo *vi;
 	const struct btf_var *var_extra;
 	const struct btf_member *m;
-	const void *def_data;
 	const char *map_name;
 	struct bpf_map *map;
 	int vlen, i;
@@ -1131,7 +1130,6 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 	pr_debug("map '%s': at sec_idx %d, offset %zu.\n",
 		 map_name, map->sec_idx, map->sec_offset);
 
-	def_data = data->d_buf + vi->offset;
 	vlen = BTF_INFO_VLEN(def->info);
 	m = (const void *)(def + 1);
 	for (i = 0; i < vlen; i++, m++) {
@@ -1144,19 +1142,19 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 		}
 		if (strcmp(name, "type") == 0) {
 			if (!get_map_field_int(map_name, obj->btf, def, m,
-					       def_data, &map->def.type))
+					       &map->def.type))
 				return -EINVAL;
 			pr_debug("map '%s': found type = %u.\n",
 				 map_name, map->def.type);
 		} else if (strcmp(name, "max_entries") == 0) {
 			if (!get_map_field_int(map_name, obj->btf, def, m,
-					       def_data, &map->def.max_entries))
+					       &map->def.max_entries))
 				return -EINVAL;
 			pr_debug("map '%s': found max_entries = %u.\n",
 				 map_name, map->def.max_entries);
 		} else if (strcmp(name, "map_flags") == 0) {
 			if (!get_map_field_int(map_name, obj->btf, def, m,
-					       def_data, &map->def.map_flags))
+					       &map->def.map_flags))
 				return -EINVAL;
 			pr_debug("map '%s': found map_flags = %u.\n",
 				 map_name, map->def.map_flags);
@@ -1164,7 +1162,7 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 			__u32 sz;
 
 			if (!get_map_field_int(map_name, obj->btf, def, m,
-					       def_data, &sz))
+					       &sz))
 				return -EINVAL;
 			pr_debug("map '%s': found key_size = %u.\n",
 				 map_name, sz);
@@ -1207,7 +1205,7 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 			__u32 sz;
 
 			if (!get_map_field_int(map_name, obj->btf, def, m,
-					       def_data, &sz))
+					       &sz))
 				return -EINVAL;
 			pr_debug("map '%s': found value_size = %u.\n",
 				 map_name, sz);
-- 
2.17.1

