Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1383C300
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403898AbfFKEs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:48:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51454 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391246AbfFKEsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:48:22 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5B4hINm027242
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:48:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Hz/uYrVBA3zsJJJt5cGiSxPJ320YZfZ02wprCUKquW8=;
 b=Dd1Yh1kIn49c4j6IvSaHuOh3FLWT0FORBDqq4dxR2CQ/9CAeiXJ7hjt8M6ZhG8wunQvz
 u1Cr0elX6nqL5H6xKMek8pyVRwz/4oOX2EHJTD5q0DJuvt8++mXSqEC6hk5IaqLgs/R6
 N5ra3bRJ0LMLAPGYOxRrRXzN1WxLuwUArrE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t1wqbsemn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:48:22 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 10 Jun 2019 21:48:20 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 23D7986186A; Mon, 10 Jun 2019 21:48:18 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 4/8] libbpf: identify maps by section index in addition to offset
Date:   Mon, 10 Jun 2019 21:47:43 -0700
Message-ID: <20190611044747.44839-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611044747.44839-1-andriin@fb.com>
References: <20190611044747.44839-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110033
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support maps to be defined in multiple sections, it's important to
identify map not just by offset within its section, but section index as
well. This patch adds tracking of section index.

For global data, we record section index of corresponding
.data/.bss/.rodata ELF section for uniformity, and thus don't need
a special value of offset for those maps.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c931ee7e1fd2..5e7ea7dac958 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -207,7 +207,8 @@ static const char * const libbpf_type_to_btf_name[] = {
 struct bpf_map {
 	int fd;
 	char *name;
-	size_t offset;
+	int sec_idx;
+	size_t sec_offset;
 	int map_ifindex;
 	int inner_map_fd;
 	struct bpf_map_def def;
@@ -647,7 +648,9 @@ static int compare_bpf_map(const void *_a, const void *_b)
 	const struct bpf_map *a = _a;
 	const struct bpf_map *b = _b;
 
-	return a->offset - b->offset;
+	if (a->sec_idx != b->sec_idx)
+		return a->sec_idx - b->sec_idx;
+	return a->sec_offset - b->sec_offset;
 }
 
 static bool bpf_map_type__is_map_in_map(enum bpf_map_type type)
@@ -800,14 +803,15 @@ static struct bpf_map *bpf_object__add_map(struct bpf_object *obj)
 
 static int
 bpf_object__init_internal_map(struct bpf_object *obj, struct bpf_map *map,
-			      enum libbpf_map_type type, Elf_Data *data,
-			      void **data_buff)
+			      enum libbpf_map_type type, int sec_idx,
+			      Elf_Data *data, void **data_buff)
 {
 	struct bpf_map_def *def = &map->def;
 	char map_name[BPF_OBJ_NAME_LEN];
 
 	map->libbpf_type = type;
-	map->offset = ~(typeof(map->offset))0;
+	map->sec_idx = sec_idx;
+	map->sec_offset = 0;
 	snprintf(map_name, sizeof(map_name), "%.8s%.7s", obj->name,
 		 libbpf_type_to_btf_name[type]);
 	map->name = strdup(map_name);
@@ -815,6 +819,8 @@ bpf_object__init_internal_map(struct bpf_object *obj, struct bpf_map *map,
 		pr_warning("failed to alloc map name\n");
 		return -ENOMEM;
 	}
+	pr_debug("map '%s' (global data): at sec_idx %d, offset %zu.\n",
+		 map_name, map->sec_idx, map->sec_offset);
 
 	def->type = BPF_MAP_TYPE_ARRAY;
 	def->key_size = sizeof(int);
@@ -850,6 +856,7 @@ static int bpf_object__init_global_data_maps(struct bpf_object *obj)
 		if (IS_ERR(map))
 			return PTR_ERR(map);
 		err = bpf_object__init_internal_map(obj, map, LIBBPF_MAP_DATA,
+						    obj->efile.data_shndx,
 						    obj->efile.data,
 						    &obj->sections.data);
 		if (err)
@@ -860,6 +867,7 @@ static int bpf_object__init_global_data_maps(struct bpf_object *obj)
 		if (IS_ERR(map))
 			return PTR_ERR(map);
 		err = bpf_object__init_internal_map(obj, map, LIBBPF_MAP_RODATA,
+						    obj->efile.rodata_shndx,
 						    obj->efile.rodata,
 						    &obj->sections.rodata);
 		if (err)
@@ -870,6 +878,7 @@ static int bpf_object__init_global_data_maps(struct bpf_object *obj)
 		if (IS_ERR(map))
 			return PTR_ERR(map);
 		err = bpf_object__init_internal_map(obj, map, LIBBPF_MAP_BSS,
+						    obj->efile.bss_shndx,
 						    obj->efile.bss, NULL);
 		if (err)
 			return err;
@@ -953,7 +962,10 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
 		}
 
 		map->libbpf_type = LIBBPF_MAP_UNSPEC;
-		map->offset = sym.st_value;
+		map->sec_idx = sym.st_shndx;
+		map->sec_offset = sym.st_value;
+		pr_debug("map '%s' (legacy): at sec_idx %d, offset %zu.\n",
+			 map_name, map->sec_idx, map->sec_offset);
 		if (sym.st_value + map_def_sz > data->d_size) {
 			pr_warning("corrupted maps section in %s: last map \"%s\" too small\n",
 				   obj->path, map_name);
@@ -1453,9 +1465,13 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
 				if (maps[map_idx].libbpf_type != type)
 					continue;
 				if (type != LIBBPF_MAP_UNSPEC ||
-				    maps[map_idx].offset == sym.st_value) {
-					pr_debug("relocation: find map %zd (%s) for insn %u\n",
-						 map_idx, maps[map_idx].name, insn_idx);
+				    (maps[map_idx].sec_idx == sym.st_shndx &&
+				     maps[map_idx].sec_offset == sym.st_value)) {
+					pr_debug("relocation: found map %zd (%s, sec_idx %d, offset %zu) for insn %u\n",
+						 map_idx, maps[map_idx].name,
+						 maps[map_idx].sec_idx,
+						 maps[map_idx].sec_offset,
+						 insn_idx);
 					break;
 				}
 			}
@@ -3472,13 +3488,7 @@ bpf_object__find_map_fd_by_name(struct bpf_object *obj, const char *name)
 struct bpf_map *
 bpf_object__find_map_by_offset(struct bpf_object *obj, size_t offset)
 {
-	int i;
-
-	for (i = 0; i < obj->nr_maps; i++) {
-		if (obj->maps[i].offset == offset)
-			return &obj->maps[i];
-	}
-	return ERR_PTR(-ENOENT);
+	return ERR_PTR(-ENOTSUP);
 }
 
 long libbpf_get_error(const void *ptr)
-- 
2.17.1

