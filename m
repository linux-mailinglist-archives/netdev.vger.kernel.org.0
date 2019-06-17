Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3F548E8C
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbfFQT1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:27:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47082 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728990AbfFQT1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:27:13 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HJF6hF031865
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=a2LYmaWlRenjCozY8D15rM6+fiIfLYwDkDm7eZFqda8=;
 b=nvv007ayiljKGEIAZj5qsMbWTYk2wKhG1OvuB2ms/JdJEQUoVNaCN0xDhQWRDHEOREjq
 s4TEu0agsdS1ZvN+u5bjsA4IpD0HNzk2q0qwc139c3F1aKUcri3LL5lKluHckFEc2dBU
 /qApGflZpF19rFrnN6MruD/wJL9pf3BMgv0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t6a3hsm3x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:11 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 17 Jun 2019 12:27:11 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id C0CAE86173A; Mon, 17 Jun 2019 12:27:09 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 04/11] libbpf: refactor map initialization
Date:   Mon, 17 Jun 2019 12:26:53 -0700
Message-ID: <20190617192700.2313445-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190617192700.2313445-1-andriin@fb.com>
References: <20190617192700.2313445-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

User and global data maps initialization has gotten pretty complicated
and unnecessarily convoluted. This patch splits out the logic for global
data map and user-defined map initialization. It also removes the
restriction of pre-calculating how many maps will be initialized,
instead allowing to keep adding new maps as they are discovered, which
will be used later for BTF-defined map definitions.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 247 ++++++++++++++++++++++-------------------
 1 file changed, 133 insertions(+), 114 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7ee44d8877c5..88609dca4f7d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -234,6 +234,7 @@ struct bpf_object {
 	size_t nr_programs;
 	struct bpf_map *maps;
 	size_t nr_maps;
+	size_t maps_cap;
 	struct bpf_secdata sections;
 
 	bool loaded;
@@ -763,21 +764,51 @@ int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
 	return -ENOENT;
 }
 
-static bool bpf_object__has_maps(const struct bpf_object *obj)
+static struct bpf_map *bpf_object__add_map(struct bpf_object *obj)
 {
-	return obj->efile.maps_shndx >= 0 ||
-	       obj->efile.data_shndx >= 0 ||
-	       obj->efile.rodata_shndx >= 0 ||
-	       obj->efile.bss_shndx >= 0;
+	struct bpf_map *new_maps;
+	size_t new_cap;
+	int i;
+
+	if (obj->nr_maps < obj->maps_cap)
+		return &obj->maps[obj->nr_maps++];
+
+	new_cap = max(4ul, obj->maps_cap * 3 / 2);
+	new_maps = realloc(obj->maps, new_cap * sizeof(*obj->maps));
+	if (!new_maps) {
+		pr_warning("alloc maps for object failed\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	obj->maps_cap = new_cap;
+	obj->maps = new_maps;
+
+	/* zero out new maps */
+	memset(obj->maps + obj->nr_maps, 0,
+	       (obj->maps_cap - obj->nr_maps) * sizeof(*obj->maps));
+	/*
+	 * fill all fd with -1 so won't close incorrect fd (fd=0 is stdin)
+	 * when failure (zclose won't close negative fd)).
+	 */
+	for (i = obj->nr_maps; i < obj->maps_cap; i++) {
+		obj->maps[i].fd = -1;
+		obj->maps[i].inner_map_fd = -1;
+	}
+
+	return &obj->maps[obj->nr_maps++];
 }
 
 static int
-bpf_object__init_internal_map(struct bpf_object *obj, struct bpf_map *map,
-			      enum libbpf_map_type type, Elf_Data *data,
-			      void **data_buff)
+bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
+			      Elf_Data *data, void **data_buff)
 {
-	struct bpf_map_def *def = &map->def;
 	char map_name[BPF_OBJ_NAME_LEN];
+	struct bpf_map_def *def;
+	struct bpf_map *map;
+
+	map = bpf_object__add_map(obj);
+	if (IS_ERR(map))
+		return PTR_ERR(map);
 
 	map->libbpf_type = type;
 	map->offset = ~(typeof(map->offset))0;
@@ -789,6 +820,7 @@ bpf_object__init_internal_map(struct bpf_object *obj, struct bpf_map *map,
 		return -ENOMEM;
 	}
 
+	def = &map->def;
 	def->type = BPF_MAP_TYPE_ARRAY;
 	def->key_size = sizeof(int);
 	def->value_size = data->d_size;
@@ -808,29 +840,58 @@ bpf_object__init_internal_map(struct bpf_object *obj, struct bpf_map *map,
 	return 0;
 }
 
-static int bpf_object__init_maps(struct bpf_object *obj, int flags)
+static int bpf_object__init_global_data_maps(struct bpf_object *obj)
+{
+	int err;
+
+	if (!obj->caps.global_data)
+		return 0;
+	/*
+	 * Populate obj->maps with libbpf internal maps.
+	 */
+	if (obj->efile.data_shndx >= 0) {
+		err = bpf_object__init_internal_map(obj, LIBBPF_MAP_DATA,
+						    obj->efile.data,
+						    &obj->sections.data);
+		if (err)
+			return err;
+	}
+	if (obj->efile.rodata_shndx >= 0) {
+		err = bpf_object__init_internal_map(obj, LIBBPF_MAP_RODATA,
+						    obj->efile.rodata,
+						    &obj->sections.rodata);
+		if (err)
+			return err;
+	}
+	if (obj->efile.bss_shndx >= 0) {
+		err = bpf_object__init_internal_map(obj, LIBBPF_MAP_BSS,
+						    obj->efile.bss, NULL);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
 {
-	int i, map_idx, map_def_sz = 0, nr_syms, nr_maps = 0, nr_maps_glob = 0;
-	bool strict = !(flags & MAPS_RELAX_COMPAT);
 	Elf_Data *symbols = obj->efile.symbols;
+	int i, map_def_sz = 0, nr_maps = 0, nr_syms;
 	Elf_Data *data = NULL;
-	int ret = 0;
+	Elf_Scn *scn;
+
+	if (obj->efile.maps_shndx < 0)
+		return 0;
 
 	if (!symbols)
 		return -EINVAL;
-	nr_syms = symbols->d_size / sizeof(GElf_Sym);
-
-	if (obj->efile.maps_shndx >= 0) {
-		Elf_Scn *scn = elf_getscn(obj->efile.elf,
-					  obj->efile.maps_shndx);
 
-		if (scn)
-			data = elf_getdata(scn, NULL);
-		if (!scn || !data) {
-			pr_warning("failed to get Elf_Data from map section %d\n",
-				   obj->efile.maps_shndx);
-			return -EINVAL;
-		}
+	scn = elf_getscn(obj->efile.elf, obj->efile.maps_shndx);
+	if (scn)
+		data = elf_getdata(scn, NULL);
+	if (!scn || !data) {
+		pr_warning("failed to get Elf_Data from map section %d\n",
+			   obj->efile.maps_shndx);
+		return -EINVAL;
 	}
 
 	/*
@@ -840,16 +901,8 @@ static int bpf_object__init_maps(struct bpf_object *obj, int flags)
 	 *
 	 * TODO: Detect array of map and report error.
 	 */
-	if (obj->caps.global_data) {
-		if (obj->efile.data_shndx >= 0)
-			nr_maps_glob++;
-		if (obj->efile.rodata_shndx >= 0)
-			nr_maps_glob++;
-		if (obj->efile.bss_shndx >= 0)
-			nr_maps_glob++;
-	}
-
-	for (i = 0; data && i < nr_syms; i++) {
+	nr_syms = symbols->d_size / sizeof(GElf_Sym);
+	for (i = 0; i < nr_syms; i++) {
 		GElf_Sym sym;
 
 		if (!gelf_getsym(symbols, i, &sym))
@@ -858,79 +911,56 @@ static int bpf_object__init_maps(struct bpf_object *obj, int flags)
 			continue;
 		nr_maps++;
 	}
-
-	if (!nr_maps && !nr_maps_glob)
-		return 0;
-
 	/* Assume equally sized map definitions */
-	if (data) {
-		pr_debug("maps in %s: %d maps in %zd bytes\n", obj->path,
-			 nr_maps, data->d_size);
-
-		map_def_sz = data->d_size / nr_maps;
-		if (!data->d_size || (data->d_size % nr_maps) != 0) {
-			pr_warning("unable to determine map definition size "
-				   "section %s, %d maps in %zd bytes\n",
-				   obj->path, nr_maps, data->d_size);
-			return -EINVAL;
-		}
-	}
-
-	nr_maps += nr_maps_glob;
-	obj->maps = calloc(nr_maps, sizeof(obj->maps[0]));
-	if (!obj->maps) {
-		pr_warning("alloc maps for object failed\n");
-		return -ENOMEM;
-	}
-	obj->nr_maps = nr_maps;
-
-	for (i = 0; i < nr_maps; i++) {
-		/*
-		 * fill all fd with -1 so won't close incorrect
-		 * fd (fd=0 is stdin) when failure (zclose won't close
-		 * negative fd)).
-		 */
-		obj->maps[i].fd = -1;
-		obj->maps[i].inner_map_fd = -1;
+	pr_debug("maps in %s: %d maps in %zd bytes\n",
+		 obj->path, nr_maps, data->d_size);
+
+	map_def_sz = data->d_size / nr_maps;
+	if (!data->d_size || (data->d_size % nr_maps) != 0) {
+		pr_warning("unable to determine map definition size "
+			   "section %s, %d maps in %zd bytes\n",
+			   obj->path, nr_maps, data->d_size);
+		return -EINVAL;
 	}
 
-	/*
-	 * Fill obj->maps using data in "maps" section.
-	 */
-	for (i = 0, map_idx = 0; data && i < nr_syms; i++) {
+	/* Fill obj->maps using data in "maps" section.  */
+	for (i = 0; i < nr_syms; i++) {
 		GElf_Sym sym;
 		const char *map_name;
 		struct bpf_map_def *def;
+		struct bpf_map *map;
 
 		if (!gelf_getsym(symbols, i, &sym))
 			continue;
 		if (sym.st_shndx != obj->efile.maps_shndx)
 			continue;
 
-		map_name = elf_strptr(obj->efile.elf,
-				      obj->efile.strtabidx,
+		map = bpf_object__add_map(obj);
+		if (IS_ERR(map))
+			return PTR_ERR(map);
+
+		map_name = elf_strptr(obj->efile.elf, obj->efile.strtabidx,
 				      sym.st_name);
 		if (!map_name) {
 			pr_warning("failed to get map #%d name sym string for obj %s\n",
-				   map_idx, obj->path);
+				   i, obj->path);
 			return -LIBBPF_ERRNO__FORMAT;
 		}
 
-		obj->maps[map_idx].libbpf_type = LIBBPF_MAP_UNSPEC;
-		obj->maps[map_idx].offset = sym.st_value;
+		map->libbpf_type = LIBBPF_MAP_UNSPEC;
+		map->offset = sym.st_value;
 		if (sym.st_value + map_def_sz > data->d_size) {
 			pr_warning("corrupted maps section in %s: last map \"%s\" too small\n",
 				   obj->path, map_name);
 			return -EINVAL;
 		}
 
-		obj->maps[map_idx].name = strdup(map_name);
-		if (!obj->maps[map_idx].name) {
+		map->name = strdup(map_name);
+		if (!map->name) {
 			pr_warning("failed to alloc map name\n");
 			return -ENOMEM;
 		}
-		pr_debug("map %d is \"%s\"\n", map_idx,
-			 obj->maps[map_idx].name);
+		pr_debug("map %d is \"%s\"\n", i, map->name);
 		def = (struct bpf_map_def *)(data->d_buf + sym.st_value);
 		/*
 		 * If the definition of the map in the object file fits in
@@ -939,7 +969,7 @@ static int bpf_object__init_maps(struct bpf_object *obj, int flags)
 		 * calloc above.
 		 */
 		if (map_def_sz <= sizeof(struct bpf_map_def)) {
-			memcpy(&obj->maps[map_idx].def, def, map_def_sz);
+			memcpy(&map->def, def, map_def_sz);
 		} else {
 			/*
 			 * Here the map structure being read is bigger than what
@@ -959,37 +989,30 @@ static int bpf_object__init_maps(struct bpf_object *obj, int flags)
 						return -EINVAL;
 				}
 			}
-			memcpy(&obj->maps[map_idx].def, def,
-			       sizeof(struct bpf_map_def));
+			memcpy(&map->def, def, sizeof(struct bpf_map_def));
 		}
-		map_idx++;
 	}
+	return 0;
+}
 
-	if (!obj->caps.global_data)
-		goto finalize;
+static int bpf_object__init_maps(struct bpf_object *obj, int flags)
+{
+	bool strict = !(flags & MAPS_RELAX_COMPAT);
+	int err;
 
-	/*
-	 * Populate rest of obj->maps with libbpf internal maps.
-	 */
-	if (obj->efile.data_shndx >= 0)
-		ret = bpf_object__init_internal_map(obj, &obj->maps[map_idx++],
-						    LIBBPF_MAP_DATA,
-						    obj->efile.data,
-						    &obj->sections.data);
-	if (!ret && obj->efile.rodata_shndx >= 0)
-		ret = bpf_object__init_internal_map(obj, &obj->maps[map_idx++],
-						    LIBBPF_MAP_RODATA,
-						    obj->efile.rodata,
-						    &obj->sections.rodata);
-	if (!ret && obj->efile.bss_shndx >= 0)
-		ret = bpf_object__init_internal_map(obj, &obj->maps[map_idx++],
-						    LIBBPF_MAP_BSS,
-						    obj->efile.bss, NULL);
-finalize:
-	if (!ret)
+	err = bpf_object__init_user_maps(obj, strict);
+	if (err)
+		return err;
+
+	err = bpf_object__init_global_data_maps(obj);
+	if (err)
+		return err;
+
+	if (obj->nr_maps) {
 		qsort(obj->maps, obj->nr_maps, sizeof(obj->maps[0]),
 		      compare_bpf_map);
-	return ret;
+	}
+	return 0;
 }
 
 static bool section_have_execinstr(struct bpf_object *obj, int idx)
@@ -1262,14 +1285,10 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 		return -LIBBPF_ERRNO__FORMAT;
 	}
 	err = bpf_object__load_btf(obj, btf_data, btf_ext_data);
-	if (err)
-		return err;
-	if (bpf_object__has_maps(obj)) {
+	if (!err)
 		err = bpf_object__init_maps(obj, flags);
-		if (err)
-			return err;
-	}
-	err = bpf_object__init_prog_names(obj);
+	if (!err)
+		err = bpf_object__init_prog_names(obj);
 	return err;
 }
 
-- 
2.17.1

