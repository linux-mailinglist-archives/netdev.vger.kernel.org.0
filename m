Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD80EC0D9
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 10:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbfKAJxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 05:53:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728593AbfKAJxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 05:53:06 -0400
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CEC564E840
        for <netdev@vger.kernel.org>; Fri,  1 Nov 2019 09:53:04 +0000 (UTC)
Received: by mail-lj1-f199.google.com with SMTP id q185so1651732ljq.21
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 02:53:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=uce5znXsM/tCDnXO1lPrsZnlKKhGS1yvibOlKQvSIgA=;
        b=GppAdZ0Dagfzce2nloy8IZM7R8SbhF7zRPGfdmiMzydJTRCMiHt+kSIVxG294Rxtgl
         j5YYyYO2N2HiW+Yp2lwzKF2W7fY8Kzpjm2E3AGH5IcGybHdOLptPM4iqA0EPX5irXOYO
         tqVobfwibgT7OHkPlO55ZFtVE5kdXXg1Pjod6b+tNgaHO/yE3CARVQJgENe1y9K0HFSz
         psrk1WZ2jIMkN9Ikamvii1iF7OlmQ0SRTiYJpC73O/XkANxijYssAkSH0Ta/bBv1+s24
         axn/WlnFAJE7z3sJPkZ0Y+8GYmaIxMsg8tiMCFqUyDbh2hNTrVOdXLWF/aFeHwmEeaEf
         ddqQ==
X-Gm-Message-State: APjAAAVmxLvaXoN32WU6Qnxu9Qf8avBeCpMC22K/ee0OrOMXAn1F7NVp
        RDTk62hUTs0qyxl4r27Lov9/NQGSZyh1htYepGKgOVa5vEGYKLILYAEz9+GdmLW2nvzBKpaGHXu
        tOg1aqiUu8MnOPuDu
X-Received: by 2002:a2e:854b:: with SMTP id u11mr6779817ljj.85.1572601983218;
        Fri, 01 Nov 2019 02:53:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwinZJsvjz2dMTVTtPDS6PB2NkxT6LJcxpMl7fxEV42er8zc1yjs2297HKK/YC1JlC9fTmUuQ==
X-Received: by 2002:a2e:854b:: with SMTP id u11mr6779789ljj.85.1572601982867;
        Fri, 01 Nov 2019 02:53:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id y6sm2110362ljm.95.2019.11.01.02.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 02:53:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 14FC71818B5; Fri,  1 Nov 2019 10:53:01 +0100 (CET)
Subject: [PATCH bpf-next v5 4/5] libbpf: Add auto-pinning of maps when loading
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
Date:   Fri, 01 Nov 2019 10:53:01 +0100
Message-ID: <157260198101.335202.7677886408504787095.stgit@toke.dk>
In-Reply-To: <157260197645.335202.2393286837980792460.stgit@toke.dk>
References: <157260197645.335202.2393286837980792460.stgit@toke.dk>
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

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/bpf_helpers.h |    6 ++
 tools/lib/bpf/libbpf.c      |  146 +++++++++++++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf.h      |   13 ++++
 3 files changed, 156 insertions(+), 9 deletions(-)

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
index 0f1ebecad4d4..ed61f0c35dc5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1092,10 +1092,32 @@ static bool get_map_field_int(const char *map_name, const struct btf *btf,
 	return true;
 }
 
+static int build_map_pin_path(struct bpf_map *map, const char *path)
+{
+	char buf[PATH_MAX];
+	int err, len;
+
+	if (!path)
+		path = "/sys/fs/bpf";
+
+	len = snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map__name(map));
+	if (len < 0)
+		return -EINVAL;
+	else if (len >= PATH_MAX)
+		return -ENAMETOOLONG;
+
+	err = bpf_map__set_pin_path(map, buf);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 					 const struct btf_type *sec,
 					 int var_idx, int sec_idx,
-					 const Elf_Data *data, bool strict)
+					 const Elf_Data *data, bool strict,
+					 const char *pin_root_path)
 {
 	const struct btf_type *var, *def, *t;
 	const struct btf_var_secinfo *vi;
@@ -1270,6 +1292,30 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 			}
 			map->def.value_size = sz;
 			map->btf_value_type_id = t->type;
+		} else if (strcmp(name, "pinning") == 0) {
+			__u32 val;
+			int err;
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
+			if (val == LIBBPF_PIN_BY_NAME) {
+				err = build_map_pin_path(map, pin_root_path);
+				if (err) {
+					pr_warn("map '%s': couldn't build pin path.\n",
+						map_name);
+					return err;
+				}
+			}
 		} else {
 			if (strict) {
 				pr_warn("map '%s': unknown field '%s'.\n",
@@ -1289,7 +1335,8 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 	return 0;
 }
 
-static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict)
+static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
+					  const char *pin_root_path)
 {
 	const struct btf_type *sec = NULL;
 	int nr_types, i, vlen, err;
@@ -1331,7 +1378,7 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict)
 	for (i = 0; i < vlen; i++) {
 		err = bpf_object__init_user_btf_map(obj, sec, i,
 						    obj->efile.btf_maps_shndx,
-						    data, strict);
+						    data, strict, pin_root_path);
 		if (err)
 			return err;
 	}
@@ -1339,7 +1386,8 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict)
 	return 0;
 }
 
-static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_maps)
+static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_maps,
+				 const char *pin_root_path)
 {
 	bool strict = !relaxed_maps;
 	int err;
@@ -1348,7 +1396,7 @@ static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_maps)
 	if (err)
 		return err;
 
-	err = bpf_object__init_user_btf_maps(obj, strict);
+	err = bpf_object__init_user_btf_maps(obj, strict, pin_root_path);
 	if (err)
 		return err;
 
@@ -1537,7 +1585,8 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 	return 0;
 }
 
-static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps)
+static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
+				   const char *pin_root_path)
 {
 	Elf *elf = obj->efile.elf;
 	GElf_Ehdr *ep = &obj->efile.ehdr;
@@ -1672,7 +1721,7 @@ static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps)
 	}
 	err = bpf_object__init_btf(obj, btf_data, btf_ext_data);
 	if (!err)
-		err = bpf_object__init_maps(obj, relaxed_maps);
+		err = bpf_object__init_maps(obj, relaxed_maps, pin_root_path);
 	if (!err)
 		err = bpf_object__sanitize_and_load_btf(obj);
 	if (!err)
@@ -2128,6 +2177,66 @@ bpf_object__probe_caps(struct bpf_object *obj)
 	return 0;
 }
 
+static bool map_is_reuse_compat(const struct bpf_map *map, int map_fd)
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
+		map_info.map_flags == map->def.map_flags);
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
+		err = -errno;
+		if (err == -ENOENT) {
+			pr_debug("found no pinned map to reuse at '%s'\n",
+				 map->pin_path);
+			return 0;
+		}
+
+		cp = libbpf_strerror_r(-err, errmsg, sizeof(errmsg));
+		pr_warn("couldn't retrieve pinned map '%s': %s\n",
+			map->pin_path, cp);
+		return err;
+	}
+
+	if (!map_is_reuse_compat(map, pin_fd)) {
+		pr_warn("couldn't reuse pinned map at '%s': parameter mismatch\n",
+			map->pin_path);
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
@@ -2170,6 +2279,15 @@ bpf_object__create_maps(struct bpf_object *obj)
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
@@ -2248,6 +2366,15 @@ bpf_object__create_maps(struct bpf_object *obj)
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
 
@@ -3619,6 +3746,7 @@ static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   struct bpf_object_open_opts *opts)
 {
+	const char *pin_root_path;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	const char *obj_name;
@@ -3653,11 +3781,13 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 
 	obj->relaxed_core_relocs = OPTS_GET(opts, relaxed_core_relocs, false);
 	relaxed_maps = OPTS_GET(opts, relaxed_maps, false);
+	pin_root_path = OPTS_GET(opts, pin_root_path, NULL);
 
 	CHECK_ERR(bpf_object__elf_init(obj), err, out);
 	CHECK_ERR(bpf_object__check_endianness(obj), err, out);
 	CHECK_ERR(bpf_object__probe_caps(obj), err, out);
-	CHECK_ERR(bpf_object__elf_collect(obj, relaxed_maps), err, out);
+	CHECK_ERR(bpf_object__elf_collect(obj, relaxed_maps, pin_root_path),
+		  err, out);
 	CHECK_ERR(bpf_object__collect_reloc(obj), err, out);
 	bpf_object__elf_finish(obj);
 
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index e28ef2ebe062..d9a685d20f7a 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -103,8 +103,13 @@ struct bpf_object_open_opts {
 	bool relaxed_maps;
 	/* process CO-RE relocations non-strictly, allowing them to fail */
 	bool relaxed_core_relocs;
+	/* maps that set the 'pinning' attribute in their definition will have
+	 * their pin_path attribute set to a file in this directory, and be
+	 * auto-pinned to that path on load; defaults to "/sys/fs/bpf".
+	 */
+	const char *pin_root_path;
 };
-#define bpf_object_open_opts__last_field relaxed_core_relocs
+#define bpf_object_open_opts__last_field pin_root_path
 
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
@@ -125,6 +130,12 @@ int bpf_object__section_size(const struct bpf_object *obj, const char *name,
 int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
 				__u32 *off);
 
+enum libbpf_pin_type {
+	LIBBPF_PIN_NONE,
+	/* PIN_BY_NAME: pin maps by name (in /sys/fs/bpf by default) */
+	LIBBPF_PIN_BY_NAME,
+};
+
 /* pin_maps and unpin_maps can both be called with a NULL path, in which case
  * they will use the pin_path attribute of each map (and ignore all maps that
  * don't have a pin_path set).

