Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 953D3E656F
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 21:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbfJ0UxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 16:53:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48378 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbfJ0UxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 16:53:23 -0400
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8472785538
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 20:53:22 +0000 (UTC)
Received: by mail-lj1-f198.google.com with SMTP id e3so1512323ljj.16
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 13:53:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fGG6pn28sfYvLj0Nf+1bZXXTBJzbr7H12ea/9RtWB4o=;
        b=nrH0pnMsnfTUFmEPZ99q/J3U12sgpkCJ/Y+actaB+YXZvjaq/bO4bmXrIz/mWINv4B
         F8V742Uz+HlaMiaTQUXeH2fLHlnEtbAqzrvnQhNfF6C4ltvr0sH1YE5wf8Iw6bp5QWI9
         3WVuleCj+AdGzKlbEE2h+SR5aSwsHInzd6MchfC6d0on4nqeisBHXEb1teKkswYMfTDw
         Qs7Nhrdu+1H5H1apQNLwgnRIx1UGqS/i5ylWFwAAwpdJmKv7UXG3fh0cP9fv5S+441CB
         7Ke9EOS9Rrat29Mj2ALdr87DYZu1AEseJvV6rKcn7/zzgslaRBBibpinfjdOmVI7uamw
         mc9Q==
X-Gm-Message-State: APjAAAUTheJqGnIk6+aJT9UtK9S+tkn/AKWAdGIjw5VTqwY7o/0Q2kIr
        g+bAKt7BT1aBItzI2Xj8rRtXYrSLwbd8GbvOO5LIJgLa//jI15k8xxeGIYLSf6rOyNrgeAwConr
        /SBgcAPQc5fNHPKc/
X-Received: by 2002:a19:6917:: with SMTP id e23mr9337147lfc.4.1572209601045;
        Sun, 27 Oct 2019 13:53:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyaX4X/QSUPJC5E1ZoF1w124j9yI1W4Y7NpGx0pa7LoeVTnsqKXV7AWlOc3VBUiXmEzd+yJXw==
X-Received: by 2002:a19:6917:: with SMTP id e23mr9337133lfc.4.1572209600767;
        Sun, 27 Oct 2019 13:53:20 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id f1sm3900427ljk.77.2019.10.27.13.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 13:53:20 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C36F91818B7; Sun, 27 Oct 2019 21:53:18 +0100 (CET)
Subject: [PATCH bpf-next v3 3/4] libbpf: Add auto-pinning of maps when loading
 BPF objects
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Sun, 27 Oct 2019 21:53:18 +0100
Message-ID: <157220959873.48922.4763375792594816553.stgit@toke.dk>
In-Reply-To: <157220959547.48922.6623938299823744715.stgit@toke.dk>
References: <157220959547.48922.6623938299823744715.stgit@toke.dk>
User-Agent: StGit/0.20
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds support to libbpf for setting map pinning information as part of
the BTF map declaration, to get automatic map pinning (and reuse) on load.
The pinning type currently only supports a single PIN_BY_NAME mode, where
each map will be pinned by its name in a path that can be overridden, but
defaults to /sys/fs/bpf.

Since auto-pinning only does something if any maps actually have a
'pinning' BTF attribute set, we default the new option to enabled, on the
assumption that seamless pinning is what most callers want.

When a map has a pin_path set at load time, libbpf will compare the map
pinned at that location (if any), and if the attributes match, will re-use
that map instead of creating a new one. If no existing map is found, the
newly created map will instead be pinned at the location.

Programs wanting to customise the pinning can override the pinning paths
using bpf_map__set_pin_path() before calling bpf_object__load() (including
setting it to NULL to disable pinning of a particular map).

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/bpf_helpers.h |    6 ++
 tools/lib/bpf/libbpf.c      |  142 ++++++++++++++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf.h      |   11 +++
 3 files changed, 154 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 2203595f38c3..0c7d28292898 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -38,4 +38,10 @@ struct bpf_map_def {
 	unsigned int map_flags;
 };
 
+enum libbpf_pin_type {
+	LIBBPF_PIN_NONE,
+	/* PIN_BY_NAME: pin maps by name (in /sys/fs/bpf by default) */
+	LIBBPF_PIN_BY_NAME,
+};
+
 #endif
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index eb1c5e6ad4a3..96d0eca6fa74 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -226,6 +226,7 @@ struct bpf_map {
 	void *priv;
 	bpf_map_clear_priv_t clear_priv;
 	enum libbpf_map_type libbpf_type;
+	enum libbpf_pin_type pinning;
 	char *pin_path;
 	bool pinned;
 };
@@ -1270,6 +1271,22 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 			}
 			map->def.value_size = sz;
 			map->btf_value_type_id = t->type;
+		} else if (strcmp(name, "pinning") == 0) {
+			__u32 val;
+
+			if (!get_map_field_int(map_name, obj->btf, def, m,
+					       &val))
+				return -EINVAL;
+			pr_debug("map '%s': found pinning = %u.\n",
+				 map_name, val);
+
+			if (val != LIBBPF_PIN_NONE &&
+			    val != LIBBPF_PIN_BY_NAME) {
+				pr_warn("map '%s': invalid pinning value %u.\n",
+					map_name, val);
+				return -EINVAL;
+			}
+			map->pinning = val;
 		} else {
 			if (strict) {
 				pr_warn("map '%s': unknown field '%s'.\n",
@@ -1339,7 +1356,36 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict)
 	return 0;
 }
 
-static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_maps)
+static int bpf_object__build_map_pin_paths(struct bpf_object *obj,
+					   const char *path)
+{
+	struct bpf_map *map;
+
+	if (!path)
+		path = "/sys/fs/bpf";
+
+	bpf_object__for_each_map(map, obj) {
+		char buf[PATH_MAX];
+		int err, len;
+
+		if (map->pinning != LIBBPF_PIN_BY_NAME)
+			continue;
+
+		len = snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map__name(map));
+		if (len < 0)
+			return -EINVAL;
+		else if (len >= PATH_MAX)
+			return -ENAMETOOLONG;
+
+		err = bpf_map__set_pin_path(map, buf);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_maps,
+				 const char *auto_pin_path)
 {
 	bool strict = !relaxed_maps;
 	int err;
@@ -1356,6 +1402,10 @@ static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_maps)
 	if (err)
 		return err;
 
+	err = bpf_object__build_map_pin_paths(obj, auto_pin_path);
+	if (err)
+		return err;
+
 	if (obj->nr_maps) {
 		qsort(obj->maps, obj->nr_maps, sizeof(obj->maps[0]),
 		      compare_bpf_map);
@@ -1537,7 +1587,8 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 	return 0;
 }
 
-static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps)
+static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
+				   const char *auto_pin_path)
 {
 	Elf *elf = obj->efile.elf;
 	GElf_Ehdr *ep = &obj->efile.ehdr;
@@ -1672,7 +1723,7 @@ static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps)
 	}
 	err = bpf_object__init_btf(obj, btf_data, btf_ext_data);
 	if (!err)
-		err = bpf_object__init_maps(obj, relaxed_maps);
+		err = bpf_object__init_maps(obj, relaxed_maps, auto_pin_path);
 	if (!err)
 		err = bpf_object__sanitize_and_load_btf(obj);
 	if (!err)
@@ -2128,6 +2179,68 @@ bpf_object__probe_caps(struct bpf_object *obj)
 	return 0;
 }
 
+static bool map_is_reuse_compat(const struct bpf_map *map,
+				int map_fd)
+{
+	struct bpf_map_info map_info = {};
+	char msg[STRERR_BUFSIZE];
+	__u32 map_info_len;
+
+	map_info_len = sizeof(map_info);
+
+	if (bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len)) {
+		pr_warn("failed to get map info for map FD %d: %s\n",
+			map_fd, libbpf_strerror_r(errno, msg, sizeof(msg)));
+		return false;
+	}
+
+	return (map_info.type == map->def.type &&
+		map_info.key_size == map->def.key_size &&
+		map_info.value_size == map->def.value_size &&
+		map_info.max_entries == map->def.max_entries &&
+		map_info.map_flags == map->def.map_flags &&
+		map_info.btf_key_type_id == map->btf_key_type_id &&
+		map_info.btf_value_type_id == map->btf_value_type_id);
+}
+
+static int
+bpf_object__reuse_map(struct bpf_map *map)
+{
+	char *cp, errmsg[STRERR_BUFSIZE];
+	int err, pin_fd;
+
+	pin_fd = bpf_obj_get(map->pin_path);
+	if (pin_fd < 0) {
+		if (errno == ENOENT) {
+			pr_debug("found no pinned map to reuse at '%s'\n",
+				 map->pin_path);
+			return 0;
+		}
+
+		cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
+		pr_warn("couldn't retrieve pinned map '%s': %s\n",
+			map->pin_path, cp);
+		return -errno;
+	}
+
+	if (!map_is_reuse_compat(map, pin_fd)) {
+		pr_warn("couldn't reuse pinned map at '%s': "
+			"parameter mismatch\n", map->pin_path);
+		close(pin_fd);
+		return -EINVAL;
+	}
+
+	err = bpf_map__reuse_fd(map, pin_fd);
+	if (err) {
+		close(pin_fd);
+		return err;
+	}
+	map->pinned = true;
+	pr_debug("reused pinned map at '%s'\n", map->pin_path);
+
+	return 0;
+}
+
 static int
 bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 {
@@ -2170,6 +2283,15 @@ bpf_object__create_maps(struct bpf_object *obj)
 		char *cp, errmsg[STRERR_BUFSIZE];
 		int *pfd = &map->fd;
 
+		if (map->pin_path) {
+			err = bpf_object__reuse_map(map);
+			if (err) {
+				pr_warn("error reusing pinned map %s\n",
+					map->name);
+				return err;
+			}
+		}
+
 		if (map->fd >= 0) {
 			pr_debug("skip map create (preset) %s: fd=%d\n",
 				 map->name, map->fd);
@@ -2248,6 +2370,15 @@ bpf_object__create_maps(struct bpf_object *obj)
 			}
 		}
 
+		if (map->pin_path && !map->pinned) {
+			err = bpf_map__pin(map, NULL);
+			if (err) {
+				pr_warn("failed to auto-pin map name '%s' at '%s'\n",
+					map->name, map->pin_path);
+				return err;
+			}
+		}
+
 		pr_debug("created map %s: fd=%d\n", map->name, *pfd);
 	}
 
@@ -3619,6 +3750,7 @@ static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   struct bpf_object_open_opts *opts)
 {
+	const char *auto_pin_path;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	const char *obj_name;
@@ -3653,11 +3785,13 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 
 	obj->relaxed_core_relocs = OPTS_GET(opts, relaxed_core_relocs, false);
 	relaxed_maps = OPTS_GET(opts, relaxed_maps, false);
+	auto_pin_path = OPTS_GET(opts, auto_pin_path, NULL);
 
 	CHECK_ERR(bpf_object__elf_init(obj), err, out);
 	CHECK_ERR(bpf_object__check_endianness(obj), err, out);
 	CHECK_ERR(bpf_object__probe_caps(obj), err, out);
-	CHECK_ERR(bpf_object__elf_collect(obj, relaxed_maps), err, out);
+	CHECK_ERR(bpf_object__elf_collect(obj, relaxed_maps, auto_pin_path),
+		  err, out);
 	CHECK_ERR(bpf_object__collect_reloc(obj), err, out);
 	bpf_object__elf_finish(obj);
 
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index a514729c43f5..47e2f7dabf02 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -103,8 +103,10 @@ struct bpf_object_open_opts {
 	bool relaxed_maps;
 	/* process CO-RE relocations non-strictly, allowing them to fail */
 	bool relaxed_core_relocs;
+	/* path to auto-pin maps with 'pinning' under (default /sys/fs/bpf) */
+	const char *auto_pin_path;
 };
-#define bpf_object_open_opts__last_field relaxed_core_relocs
+#define bpf_object_open_opts__last_field auto_pin_path
 
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
@@ -124,6 +126,13 @@ int bpf_object__section_size(const struct bpf_object *obj, const char *name,
 			     __u32 *size);
 int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
 				__u32 *off);
+
+enum libbpf_pin_type {
+	LIBBPF_PIN_NONE,
+	/* PIN_BY_NAME: pin maps by name (in /sys/fs/bpf by default) */
+	LIBBPF_PIN_BY_NAME,
+};
+
 LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, const char *path);
 LIBBPF_API int bpf_object__unpin_maps(struct bpf_object *obj,
 				      const char *path);

