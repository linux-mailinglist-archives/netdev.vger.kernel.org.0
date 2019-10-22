Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB9CAE06F8
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfJVPEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:04:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732063AbfJVPEy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 11:04:54 -0400
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com [209.85.208.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 28A3FC04AC50
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 15:04:54 +0000 (UTC)
Received: by mail-lj1-f197.google.com with SMTP id u4so564874ljj.11
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 08:04:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=uoRr0ccjPD6qFV+eKlOcmNBosxytrfY1dXreuYzI0RI=;
        b=WIScP/8dewSaevpDtdTr1FCSdr2yNgQlJSa8a9DLN4tk0V0yVEobX+F9w+WV7QivnN
         MRPI6/zH7U1nx8sHbUj7zzjk+LeQO+jqAXjPhYkvrx8qyydPLF3Ne7FMwLo0qhO9qQ76
         uHw4klriiv8AR06NgPC528PuTVvA0U8hpqai69ln3C0bTij4gaJG0Ep7mjiNoSMnGn/h
         SmGSqwy8owlXNMpAJ9x8OiqCvuK7ejZWHeV0Uqv5JThDQaa9yKtHc2nRGGN2TpN5Go5c
         ngK6jllmqrJBiM8CF7ckjIYJQth7O2sO1HDzf954i+cQmJZ0qE5Ky1ViNVimPwK32+5/
         D/Sg==
X-Gm-Message-State: APjAAAW7dqpYE3d36XE1PQeThzqFkpMoH1teMpGjj3Bbon37RVHYkDuA
        QGxe+XTY/HKtfJCj1/GhWaDhmztyd7nNokgtTzm0Xg/eoOmy0zptXp9IBx9KsPY4/jk5gJddANm
        MSr2yXhJ7ckWvn1cR
X-Received: by 2002:ac2:4847:: with SMTP id 7mr18879680lfy.180.1571756692207;
        Tue, 22 Oct 2019 08:04:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwx5EVpO/lSBfTYu2gsPkd+ChFlEtrA1EYFVMIHZsNnvamFcuZPK3nyGJ/S247x7VXJ14x0Tg==
X-Received: by 2002:ac2:4847:: with SMTP id 7mr18879635lfy.180.1571756691503;
        Tue, 22 Oct 2019 08:04:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id h3sm12865485ljf.12.2019.10.22.08.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 08:04:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 074CE1804B1; Tue, 22 Oct 2019 17:04:50 +0200 (CEST)
Subject: [PATCH bpf-next 2/3] libbpf: Support configurable pinning of maps
 from BTF annotations
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Tue, 22 Oct 2019 17:04:50 +0200
Message-ID: <157175668991.112621.14204565208520782920.stgit@toke.dk>
In-Reply-To: <157175668770.112621.17344362302386223623.stgit@toke.dk>
References: <157175668770.112621.17344362302386223623.stgit@toke.dk>
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
the BTF map declaration. We introduce a new pair of functions to pin and
unpin maps based on this setting, as well as a getter and setter function
for the pin information that callers can use after map load.

The pin_type supports two modes: LOCAL pinning, which requires the caller
to set a pin path using bpf_object_pin_opts, and a global mode, where the
path can still be overridden, but defaults to /sys/fs/bpf. This is inspired
by the two modes supported by the iproute2 map definitions. In particular,
it should be possible to express the current iproute2 operating mode in
terms of the options introduced here.

The new pin functions will skip any maps that do not have a pinning type
set, unless the 'override_type' option is set, in which case all maps will
be pinning using the pin type set in that option. This also makes it
possible to express the old pin_maps and unpin_maps functions in terms of
the new option-based functions.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/bpf_helpers.h |    8 +++
 tools/lib/bpf/libbpf.c      |  123 ++++++++++++++++++++++++++++++++++++-------
 tools/lib/bpf/libbpf.h      |   33 ++++++++++++
 tools/lib/bpf/libbpf.map    |    4 +
 4 files changed, 148 insertions(+), 20 deletions(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 2203595f38c3..a23cf55d41b1 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -38,4 +38,12 @@ struct bpf_map_def {
 	unsigned int map_flags;
 };
 
+enum libbpf_pin_type {
+	LIBBPF_PIN_NONE,
+	/* PIN_LOCAL: pin maps by name in path specified by caller */
+	LIBBPF_PIN_LOCAL,
+	/* PIN_GLOBAL: pin maps by name in global path (/sys/fs/bpf by default) */
+	LIBBPF_PIN_GLOBAL,
+};
+
 #endif
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b4fdd8ee3bbd..aea3916de341 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -226,6 +226,7 @@ struct bpf_map {
 	void *priv;
 	bpf_map_clear_priv_t clear_priv;
 	enum libbpf_map_type libbpf_type;
+	enum libbpf_pin_type pinning;
 	char *pin_path;
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
+			if (val && val != LIBBPF_PIN_LOCAL &&
+			    val != LIBBPF_PIN_GLOBAL) {
+				pr_warning("map '%s': invalid pinning value %u.\n",
+					   map_name, val);
+				return -EINVAL;
+			}
+			map->pinning = val;
 		} else {
 			if (strict) {
 				pr_warning("map '%s': unknown field '%s'.\n",
@@ -4055,10 +4072,51 @@ int bpf_map__unpin(struct bpf_map *map, const char *path)
 	return 0;
 }
 
-int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
+static int get_pin_path(char *buf, size_t buf_len,
+			struct bpf_map *map, struct bpf_object_pin_opts *opts,
+			bool mkdir)
+{
+	enum libbpf_pin_type type;
+	const char *path;
+	int err, len;
+
+	type = OPTS_GET(opts, override_type, 0) ?: map->pinning;
+
+	if (type == LIBBPF_PIN_GLOBAL) {
+		path = OPTS_GET(opts, path_global, NULL);
+		if (!path)
+			path = "/sys/fs/bpf";
+	} else if (type == LIBBPF_PIN_LOCAL) {
+		path = OPTS_GET(opts, path_local, NULL);
+		if (!path) {
+			pr_warning("map '%s' set pinning to PIN_LOCAL, "
+				   "but no local path provided. Skipping.\n",
+				   bpf_map__name(map));
+			return 0;
+		}
+	} else {
+		return 0;
+	}
+
+	if (mkdir) {
+		err = make_dir(path);
+		if (err)
+			return err;
+	}
+
+	len = snprintf(buf, buf_len, "%s/%s", path, bpf_map__name(map));
+	if (len < 0)
+		return -EINVAL;
+	else if (len >= buf_len)
+		return -ENAMETOOLONG;
+	return len;
+}
+
+int bpf_object__pin_maps_opts(struct bpf_object *obj,
+			      struct bpf_object_pin_opts *opts)
 {
 	struct bpf_map *map;
-	int err;
+	int err, len;
 
 	if (!obj)
 		return -ENOENT;
@@ -4068,21 +4126,17 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 		return -ENOENT;
 	}
 
-	err = make_dir(path);
-	if (err)
-		return err;
+	if (!OPTS_VALID(opts, bpf_object_pin_opts))
+		return -EINVAL;
 
 	bpf_object__for_each_map(map, obj) {
 		char buf[PATH_MAX];
-		int len;
 
-		len = snprintf(buf, PATH_MAX, "%s/%s", path,
-			       bpf_map__name(map));
-		if (len < 0) {
-			err = -EINVAL;
-			goto err_unpin_maps;
-		} else if (len >= PATH_MAX) {
-			err = -ENAMETOOLONG;
+		len = get_pin_path(buf, PATH_MAX, map, opts, true);
+		if (len == 0) {
+			continue;
+		} else if (len < 0) {
+			err = len;
 			goto err_unpin_maps;
 		}
 
@@ -4104,7 +4158,16 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 	return err;
 }
 
-int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
+int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
+{
+	LIBBPF_OPTS(bpf_object_pin_opts, opts,
+		    .path_global = path,
+		    .override_type = LIBBPF_PIN_GLOBAL);
+	return bpf_object__pin_maps_opts(obj, &opts);
+}
+
+int bpf_object__unpin_maps_opts(struct bpf_object *obj,
+			      struct bpf_object_pin_opts *opts)
 {
 	struct bpf_map *map;
 	int err;
@@ -4112,16 +4175,18 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
 	if (!obj)
 		return -ENOENT;
 
+	if (!OPTS_VALID(opts, bpf_object_pin_opts))
+		return -EINVAL;
+
 	bpf_object__for_each_map(map, obj) {
 		char buf[PATH_MAX];
 		int len;
 
-		len = snprintf(buf, PATH_MAX, "%s/%s", path,
-			       bpf_map__name(map));
-		if (len < 0)
-			return -EINVAL;
-		else if (len >= PATH_MAX)
-			return -ENAMETOOLONG;
+		len = get_pin_path(buf, PATH_MAX, map, opts, false);
+		if (len == 0)
+			continue;
+		else if (len < 0)
+			return len;
 
 		err = bpf_map__unpin(map, buf);
 		if (err)
@@ -4131,6 +4196,14 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
 	return 0;
 }
 
+int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
+{
+	LIBBPF_OPTS(bpf_object_pin_opts, opts,
+		    .path_global = path,
+		    .override_type = LIBBPF_PIN_GLOBAL);
+	return bpf_object__unpin_maps_opts(obj, &opts);
+}
+
 int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
 {
 	struct bpf_program *prog;
@@ -4782,6 +4855,16 @@ void bpf_map__set_ifindex(struct bpf_map *map, __u32 ifindex)
 	map->map_ifindex = ifindex;
 }
 
+void bpf_map__set_pinning(struct bpf_map *map, enum libbpf_pin_type pinning)
+{
+	map->pinning = pinning;
+}
+
+enum libbpf_pin_type bpf_map__get_pinning(struct bpf_map *map)
+{
+	return map->pinning;
+}
+
 int bpf_map__set_inner_map_fd(struct bpf_map *map, int fd)
 {
 	if (!bpf_map_type__is_map_in_map(map->def.type)) {
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 53ce212764e0..2131eeafb18d 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -119,9 +119,40 @@ int bpf_object__section_size(const struct bpf_object *obj, const char *name,
 			     __u32 *size);
 int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
 				__u32 *off);
+
+enum libbpf_pin_type {
+	LIBBPF_PIN_NONE,
+	/* PIN_LOCAL: pin maps by name in path specified by caller */
+	LIBBPF_PIN_LOCAL,
+	/* PIN_GLOBAL: pin maps by name in global path (/sys/fs/bpf by default) */
+	LIBBPF_PIN_GLOBAL,
+};
+
+struct bpf_object_pin_opts {
+	/* size of this struct, for forward/backward compatiblity */
+	size_t sz;
+
+	/* Paths to pin maps setting PIN_GLOBAL and PIN_LOCAL auto-pin option.
+	 * The global path defaults to /sys/fs/bpf, while the local path has
+	 * no default (so the option must be set if that pin type is used).
+	 */
+	const char *path_global;
+	const char *path_local;
+
+	/* If set, the pin type specified in map definitions will be ignored,
+	 * and this type used for all maps instead.
+	 */
+	enum libbpf_pin_type override_type;
+};
+#define bpf_object_pin_opts__last_field override_type
+
 LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, const char *path);
 LIBBPF_API int bpf_object__unpin_maps(struct bpf_object *obj,
 				      const char *path);
+LIBBPF_API int bpf_object__pin_maps_opts(struct bpf_object *obj,
+					 struct bpf_object_pin_opts *opts);
+LIBBPF_API int bpf_object__unpin_maps_opts(struct bpf_object *obj,
+					   struct bpf_object_pin_opts *opts);
 LIBBPF_API int bpf_object__pin_programs(struct bpf_object *obj,
 					const char *path);
 LIBBPF_API int bpf_object__unpin_programs(struct bpf_object *obj,
@@ -377,6 +408,8 @@ LIBBPF_API bool bpf_map__is_internal(const struct bpf_map *map);
 LIBBPF_API void bpf_map__set_ifindex(struct bpf_map *map, __u32 ifindex);
 LIBBPF_API int bpf_map__pin(struct bpf_map *map, const char *path);
 LIBBPF_API int bpf_map__unpin(struct bpf_map *map, const char *path);
+LIBBPF_API enum libbpf_pin_type bpf_map__get_pinning(struct bpf_map *map);
+LIBBPF_API void bpf_map__set_pinning(struct bpf_map *map, enum libbpf_pin_type);
 
 LIBBPF_API int bpf_map__set_inner_map_fd(struct bpf_map *map, int fd);
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 4d241fd92dd4..d0aacb3e14fb 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -195,4 +195,8 @@ LIBBPF_0.0.6 {
 	global:
 		bpf_object__open_file;
 		bpf_object__open_mem;
+		bpf_object__pin_maps_opts;
+		bpf_object__unpin_maps_opts;
+		bpf_map__get_pinning;
+		bpf_map__set_pinning;
 } LIBBPF_0.0.5;

