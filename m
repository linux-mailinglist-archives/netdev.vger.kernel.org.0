Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CCC1F3032
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbgFIA4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728306AbgFHXJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 252D5208A7;
        Mon,  8 Jun 2020 23:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657739;
        bh=i0C3+DlWHkBTlAqX7rAKJVnQ+MhOYrvKhl4TYPYcfbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPvvqZwnIrkTWe7/UrtA9F7LxUnBgzV7pM35+H1CK6O8Wv4ES8Gr4D8rtNq3MSuFw
         xijVeQN1PsdCckq0x5OoiZs7Mr1r6FhjE0dFRU6GtjJC/xWuOKDHZx93Km7eSNf/lT
         vadm3xXpnOI/4e1cQ75gzGxXkKa2VU/iIFW4RGhE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 128/274] libbpf: Refactor map creation logic and fix cleanup leak
Date:   Mon,  8 Jun 2020 19:03:41 -0400
Message-Id: <20200608230607.3361041-128-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 2d39d7c56f115148b05d1d8c6b8698a5730c8b53 ]

Factor out map creation and destruction logic to simplify code and especially
error handling. Also fix map FD leak in case of partially successful map
creation during bpf_object load operation.

Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BPF objects")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/bpf/20200429002739.48006-3-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 226 ++++++++++++++++++++++-------------------
 1 file changed, 121 insertions(+), 105 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8f480e29a6b0..63fc872723fc 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3482,107 +3482,111 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 	return 0;
 }
 
+static void bpf_map__destroy(struct bpf_map *map);
+
+static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
+{
+	struct bpf_create_map_attr create_attr;
+	struct bpf_map_def *def = &map->def;
+
+	memset(&create_attr, 0, sizeof(create_attr));
+
+	if (obj->caps.name)
+		create_attr.name = map->name;
+	create_attr.map_ifindex = map->map_ifindex;
+	create_attr.map_type = def->type;
+	create_attr.map_flags = def->map_flags;
+	create_attr.key_size = def->key_size;
+	create_attr.value_size = def->value_size;
+
+	if (def->type == BPF_MAP_TYPE_PERF_EVENT_ARRAY && !def->max_entries) {
+		int nr_cpus;
+
+		nr_cpus = libbpf_num_possible_cpus();
+		if (nr_cpus < 0) {
+			pr_warn("map '%s': failed to determine number of system CPUs: %d\n",
+				map->name, nr_cpus);
+			return nr_cpus;
+		}
+		pr_debug("map '%s': setting size to %d\n", map->name, nr_cpus);
+		create_attr.max_entries = nr_cpus;
+	} else {
+		create_attr.max_entries = def->max_entries;
+	}
+
+	if (bpf_map__is_struct_ops(map))
+		create_attr.btf_vmlinux_value_type_id =
+			map->btf_vmlinux_value_type_id;
+
+	create_attr.btf_fd = 0;
+	create_attr.btf_key_type_id = 0;
+	create_attr.btf_value_type_id = 0;
+	if (obj->btf && !bpf_map_find_btf_info(obj, map)) {
+		create_attr.btf_fd = btf__fd(obj->btf);
+		create_attr.btf_key_type_id = map->btf_key_type_id;
+		create_attr.btf_value_type_id = map->btf_value_type_id;
+	}
+
+	map->fd = bpf_create_map_xattr(&create_attr);
+	if (map->fd < 0 && (create_attr.btf_key_type_id ||
+			    create_attr.btf_value_type_id)) {
+		char *cp, errmsg[STRERR_BUFSIZE];
+		int err = -errno;
+
+		cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
+		pr_warn("Error in bpf_create_map_xattr(%s):%s(%d). Retrying without BTF.\n",
+			map->name, cp, err);
+		create_attr.btf_fd = 0;
+		create_attr.btf_key_type_id = 0;
+		create_attr.btf_value_type_id = 0;
+		map->btf_key_type_id = 0;
+		map->btf_value_type_id = 0;
+		map->fd = bpf_create_map_xattr(&create_attr);
+	}
+
+	if (map->fd < 0)
+		return -errno;
+
+	return 0;
+}
+
 static int
 bpf_object__create_maps(struct bpf_object *obj)
 {
-	struct bpf_create_map_attr create_attr = {};
-	int nr_cpus = 0;
-	unsigned int i;
+	struct bpf_map *map;
+	char *cp, errmsg[STRERR_BUFSIZE];
+	unsigned int i, j;
 	int err;
 
 	for (i = 0; i < obj->nr_maps; i++) {
-		struct bpf_map *map = &obj->maps[i];
-		struct bpf_map_def *def = &map->def;
-		char *cp, errmsg[STRERR_BUFSIZE];
-		int *pfd = &map->fd;
+		map = &obj->maps[i];
 
 		if (map->pin_path) {
 			err = bpf_object__reuse_map(map);
 			if (err) {
-				pr_warn("error reusing pinned map %s\n",
+				pr_warn("map '%s': error reusing pinned map\n",
 					map->name);
-				return err;
+				goto err_out;
 			}
 		}
 
 		if (map->fd >= 0) {
-			pr_debug("skip map create (preset) %s: fd=%d\n",
+			pr_debug("map '%s': skipping creation (preset fd=%d)\n",
 				 map->name, map->fd);
 			continue;
 		}
 
-		if (obj->caps.name)
-			create_attr.name = map->name;
-		create_attr.map_ifindex = map->map_ifindex;
-		create_attr.map_type = def->type;
-		create_attr.map_flags = def->map_flags;
-		create_attr.key_size = def->key_size;
-		create_attr.value_size = def->value_size;
-		if (def->type == BPF_MAP_TYPE_PERF_EVENT_ARRAY &&
-		    !def->max_entries) {
-			if (!nr_cpus)
-				nr_cpus = libbpf_num_possible_cpus();
-			if (nr_cpus < 0) {
-				pr_warn("failed to determine number of system CPUs: %d\n",
-					nr_cpus);
-				err = nr_cpus;
-				goto err_out;
-			}
-			pr_debug("map '%s': setting size to %d\n",
-				 map->name, nr_cpus);
-			create_attr.max_entries = nr_cpus;
-		} else {
-			create_attr.max_entries = def->max_entries;
-		}
-		create_attr.btf_fd = 0;
-		create_attr.btf_key_type_id = 0;
-		create_attr.btf_value_type_id = 0;
-		if (bpf_map_type__is_map_in_map(def->type) &&
-		    map->inner_map_fd >= 0)
-			create_attr.inner_map_fd = map->inner_map_fd;
-		if (bpf_map__is_struct_ops(map))
-			create_attr.btf_vmlinux_value_type_id =
-				map->btf_vmlinux_value_type_id;
-
-		if (obj->btf && !bpf_map_find_btf_info(obj, map)) {
-			create_attr.btf_fd = btf__fd(obj->btf);
-			create_attr.btf_key_type_id = map->btf_key_type_id;
-			create_attr.btf_value_type_id = map->btf_value_type_id;
-		}
-
-		*pfd = bpf_create_map_xattr(&create_attr);
-		if (*pfd < 0 && (create_attr.btf_key_type_id ||
-				 create_attr.btf_value_type_id)) {
-			err = -errno;
-			cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
-			pr_warn("Error in bpf_create_map_xattr(%s):%s(%d). Retrying without BTF.\n",
-				map->name, cp, err);
-			create_attr.btf_fd = 0;
-			create_attr.btf_key_type_id = 0;
-			create_attr.btf_value_type_id = 0;
-			map->btf_key_type_id = 0;
-			map->btf_value_type_id = 0;
-			*pfd = bpf_create_map_xattr(&create_attr);
-		}
-
-		if (*pfd < 0) {
-			size_t j;
+		err = bpf_object__create_map(obj, map);
+		if (err)
+			goto err_out;
 
-			err = -errno;
-err_out:
-			cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
-			pr_warn("failed to create map (name: '%s'): %s(%d)\n",
-				map->name, cp, err);
-			pr_perm_msg(err);
-			for (j = 0; j < i; j++)
-				zclose(obj->maps[j].fd);
-			return err;
-		}
+		pr_debug("map '%s': created successfully, fd=%d\n", map->name,
+			 map->fd);
 
 		if (bpf_map__is_internal(map)) {
 			err = bpf_object__populate_internal_map(obj, map);
 			if (err < 0) {
-				zclose(*pfd);
+				zclose(map->fd);
 				goto err_out;
 			}
 		}
@@ -3590,16 +3594,23 @@ bpf_object__create_maps(struct bpf_object *obj)
 		if (map->pin_path && !map->pinned) {
 			err = bpf_map__pin(map, NULL);
 			if (err) {
-				pr_warn("failed to auto-pin map name '%s' at '%s'\n",
-					map->name, map->pin_path);
-				return err;
+				pr_warn("map '%s': failed to auto-pin at '%s': %d\n",
+					map->name, map->pin_path, err);
+				zclose(map->fd);
+				goto err_out;
 			}
 		}
-
-		pr_debug("created map %s: fd=%d\n", map->name, *pfd);
 	}
 
 	return 0;
+
+err_out:
+	cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
+	pr_warn("map '%s': failed to create: %s(%d)\n", map->name, cp, err);
+	pr_perm_msg(err);
+	for (j = 0; j < i; j++)
+		zclose(obj->maps[j].fd);
+	return err;
 }
 
 static int
@@ -5955,6 +5966,32 @@ int bpf_object__pin(struct bpf_object *obj, const char *path)
 	return 0;
 }
 
+static void bpf_map__destroy(struct bpf_map *map)
+{
+	if (map->clear_priv)
+		map->clear_priv(map, map->priv);
+	map->priv = NULL;
+	map->clear_priv = NULL;
+
+	if (map->mmaped) {
+		munmap(map->mmaped, bpf_map_mmap_sz(map));
+		map->mmaped = NULL;
+	}
+
+	if (map->st_ops) {
+		zfree(&map->st_ops->data);
+		zfree(&map->st_ops->progs);
+		zfree(&map->st_ops->kern_func_off);
+		zfree(&map->st_ops);
+	}
+
+	zfree(&map->name);
+	zfree(&map->pin_path);
+
+	if (map->fd >= 0)
+		zclose(map->fd);
+}
+
 void bpf_object__close(struct bpf_object *obj)
 {
 	size_t i;
@@ -5970,29 +6007,8 @@ void bpf_object__close(struct bpf_object *obj)
 	btf__free(obj->btf);
 	btf_ext__free(obj->btf_ext);
 
-	for (i = 0; i < obj->nr_maps; i++) {
-		struct bpf_map *map = &obj->maps[i];
-
-		if (map->clear_priv)
-			map->clear_priv(map, map->priv);
-		map->priv = NULL;
-		map->clear_priv = NULL;
-
-		if (map->mmaped) {
-			munmap(map->mmaped, bpf_map_mmap_sz(map));
-			map->mmaped = NULL;
-		}
-
-		if (map->st_ops) {
-			zfree(&map->st_ops->data);
-			zfree(&map->st_ops->progs);
-			zfree(&map->st_ops->kern_func_off);
-			zfree(&map->st_ops);
-		}
-
-		zfree(&map->name);
-		zfree(&map->pin_path);
-	}
+	for (i = 0; i < obj->nr_maps; i++)
+		bpf_map__destroy(&obj->maps[i]);
 
 	zfree(&obj->kconfig);
 	zfree(&obj->externs);
-- 
2.25.1

