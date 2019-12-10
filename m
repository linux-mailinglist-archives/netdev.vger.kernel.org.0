Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 962C1117CF8
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 02:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbfLJBPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 20:15:08 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10218 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727649AbfLJBPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 20:15:07 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBA1EqoJ025874
        for <netdev@vger.kernel.org>; Mon, 9 Dec 2019 17:15:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=MLR628XzU/WpmXXAAhyWQLtjEy+4QCHwy+w70DLWbp8=;
 b=THaXQiWo8Kil4zSM4YmsaYUsA2yCjWCcnxy182davSRjGF8wijRhC4js2uB9pg4qBRlH
 wB1PMqYxaWK5yiSBL1bNj+Qywfo9hMKGe+bYsLhkA8bnI5GOWjeW2AgtWQ/tM1zCPEgF
 d0ulUMhSQwHd1lKQblZv0ALYVY+4jywtdGk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wrvp0r56t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 17:15:06 -0800
Received: from intmgw004.05.ash5.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 9 Dec 2019 17:15:06 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 892A02EC16B5; Mon,  9 Dec 2019 17:15:02 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 07/15] libbpf: refactor global data map initialization
Date:   Mon, 9 Dec 2019 17:14:30 -0800
Message-ID: <20191210011438.4182911-8-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191210011438.4182911-1-andriin@fb.com>
References: <20191210011438.4182911-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_05:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 suspectscore=29 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912100009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor global data map initialization to use anonymous mmap()-ed memory
instead of malloc()-ed one. This allows to do a transparent re-mmap()-ing of
already existing memory address to point to BPF map's memory after
bpf_object__load() step (done in follow up patch). This choreographed setup
allows to have a nice and unsurprising way to pre-initialize read-only (and
r/w as well) maps by user and after BPF map creation keep working with
mmap()-ed contents of this map. All in a way that doesn't require user code to
update any pointers: the illusion of working with memory contents is preserved
before and after actual BPF map instantiation.

Selftests and runqslower example demonstrate this feature in follow up patches.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 92 +++++++++++++++++++++++++-----------------
 1 file changed, 55 insertions(+), 37 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f13752c4d271..ff00a767adfb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -221,16 +221,12 @@ struct bpf_map {
 	void *priv;
 	bpf_map_clear_priv_t clear_priv;
 	enum libbpf_map_type libbpf_type;
+	void *mmaped;
 	char *pin_path;
 	bool pinned;
 	bool reused;
 };
 
-struct bpf_secdata {
-	void *rodata;
-	void *data;
-};
-
 static LIST_HEAD(bpf_objects_list);
 
 struct bpf_object {
@@ -243,7 +239,6 @@ struct bpf_object {
 	struct bpf_map *maps;
 	size_t nr_maps;
 	size_t maps_cap;
-	struct bpf_secdata sections;
 
 	bool loaded;
 	bool has_pseudo_calls;
@@ -828,13 +823,24 @@ static struct bpf_map *bpf_object__add_map(struct bpf_object *obj)
 	return &obj->maps[obj->nr_maps++];
 }
 
+static size_t bpf_map_mmap_sz(const struct bpf_map *map)
+{
+	long page_sz = sysconf(_SC_PAGE_SIZE);
+	size_t map_sz;
+
+	map_sz = roundup(map->def.value_size, 8) * map->def.max_entries;
+	map_sz = roundup(map_sz, page_sz);
+	return map_sz;
+}
+
 static int
 bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
-			      int sec_idx, Elf_Data *data, void **data_buff)
+			      int sec_idx, Elf_Data *data)
 {
 	char map_name[BPF_OBJ_NAME_LEN];
 	struct bpf_map_def *def;
 	struct bpf_map *map;
+	int err;
 
 	map = bpf_object__add_map(obj);
 	if (IS_ERR(map))
@@ -862,16 +868,20 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
 	pr_debug("map '%s' (global data): at sec_idx %d, offset %zu, flags %x.\n",
 		 map_name, map->sec_idx, map->sec_offset, def->map_flags);
 
-	if (data_buff) {
-		*data_buff = malloc(data->d_size);
-		if (!*data_buff) {
-			zfree(&map->name);
-			pr_warn("failed to alloc map content buffer\n");
-			return -ENOMEM;
-		}
-		memcpy(*data_buff, data->d_buf, data->d_size);
+	map->mmaped = mmap(NULL, bpf_map_mmap_sz(map), PROT_READ | PROT_WRITE,
+			   MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	if (map->mmaped == MAP_FAILED) {
+		err = -errno;
+		map->mmaped = NULL;
+		pr_warn("failed to alloc map '%s' content buffer: %d\n",
+			map->name, err);
+		zfree(&map->name);
+		return err;
 	}
 
+	if (type != LIBBPF_MAP_BSS)
+		memcpy(map->mmaped, data->d_buf, data->d_size);
+
 	pr_debug("map %td is \"%s\"\n", map - obj->maps, map->name);
 	return 0;
 }
@@ -886,23 +896,21 @@ static int bpf_object__init_global_data_maps(struct bpf_object *obj)
 	if (obj->efile.data_shndx >= 0) {
 		err = bpf_object__init_internal_map(obj, LIBBPF_MAP_DATA,
 						    obj->efile.data_shndx,
-						    obj->efile.data,
-						    &obj->sections.data);
+						    obj->efile.data);
 		if (err)
 			return err;
 	}
 	if (obj->efile.rodata_shndx >= 0) {
 		err = bpf_object__init_internal_map(obj, LIBBPF_MAP_RODATA,
 						    obj->efile.rodata_shndx,
-						    obj->efile.rodata,
-						    &obj->sections.rodata);
+						    obj->efile.rodata);
 		if (err)
 			return err;
 	}
 	if (obj->efile.bss_shndx >= 0) {
 		err = bpf_object__init_internal_map(obj, LIBBPF_MAP_BSS,
 						    obj->efile.bss_shndx,
-						    obj->efile.bss, NULL);
+						    obj->efile.bss);
 		if (err)
 			return err;
 	}
@@ -2291,27 +2299,32 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 {
 	char *cp, errmsg[STRERR_BUFSIZE];
 	int err, zero = 0;
-	__u8 *data;
 
 	/* Nothing to do here since kernel already zero-initializes .bss map. */
 	if (map->libbpf_type == LIBBPF_MAP_BSS)
 		return 0;
 
-	data = map->libbpf_type == LIBBPF_MAP_DATA ?
-	       obj->sections.data : obj->sections.rodata;
+	err = bpf_map_update_elem(map->fd, &zero, map->mmaped, 0);
+	if (err) {
+		err = -errno;
+		cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
+		pr_warn("Error setting initial map(%s) contents: %s\n",
+			map->name, cp);
+		return err;
+	}
 
-	err = bpf_map_update_elem(map->fd, &zero, data, 0);
 	/* Freeze .rodata map as read-only from syscall side. */
-	if (!err && map->libbpf_type == LIBBPF_MAP_RODATA) {
+	if (map->libbpf_type == LIBBPF_MAP_RODATA) {
 		err = bpf_map_freeze(map->fd);
 		if (err) {
-			cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
+			err = -errno;
+			cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
 			pr_warn("Error freezing map(%s) as read-only: %s\n",
 				map->name, cp);
-			err = 0;
+			return err;
 		}
 	}
-	return err;
+	return 0;
 }
 
 static int
@@ -4682,17 +4695,22 @@ void bpf_object__close(struct bpf_object *obj)
 	btf_ext__free(obj->btf_ext);
 
 	for (i = 0; i < obj->nr_maps; i++) {
-		zfree(&obj->maps[i].name);
-		zfree(&obj->maps[i].pin_path);
-		if (obj->maps[i].clear_priv)
-			obj->maps[i].clear_priv(&obj->maps[i],
-						obj->maps[i].priv);
-		obj->maps[i].priv = NULL;
-		obj->maps[i].clear_priv = NULL;
+		struct bpf_map *map = &obj->maps[i];
+
+		if (map->clear_priv)
+			map->clear_priv(map, map->priv);
+		map->priv = NULL;
+		map->clear_priv = NULL;
+
+		if (map->mmaped) {
+			munmap(map->mmaped, bpf_map_mmap_sz(map));
+			map->mmaped = NULL;
+		}
+
+		zfree(&map->name);
+		zfree(&map->pin_path);
 	}
 
-	zfree(&obj->sections.rodata);
-	zfree(&obj->sections.data);
 	zfree(&obj->maps);
 	obj->nr_maps = 0;
 
-- 
2.17.1

