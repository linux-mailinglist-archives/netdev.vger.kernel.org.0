Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F234EE3395
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 15:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502401AbfJXNLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 09:11:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35273 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729043AbfJXNLp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 09:11:45 -0400
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BDDF54E908
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 13:11:44 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id j10so3989653lja.21
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 06:11:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fKefA3Wp/8y052CB9Q8XVTTVkDls8CtOl71Vmp2oexc=;
        b=Cjubg7WVS4yL6TSH+AUM0FUVDJ+aMOCfSqibk/Xggdw+P+kysa0vRLZL5fzpdjABUu
         9A0OkKRx3le/7QGajfxgegdNu1taS7raQXzV3pFAPuAYK9Qm455hqvsR8JEJQmHXtDId
         g3g4YtFSTP6fk/BtjpZlNp3JBmjzkfzILDNXDsvcr68hmyTaYArxUG9nvxzASRFefCW0
         /IWbRfiJ7Knt5+WKCMIQ+zVncnJXerPv912B1RUsSGFTjnPfw03NtWowj1kEzMVdmQDq
         eQ9cElWzvzwjta8sCZDvL2wwmgJ+aJj4OfmRukoiynhCt39DWqM3luXFyI/A4tL4xDMZ
         m+aA==
X-Gm-Message-State: APjAAAW6blN6KiGzUCt+RBQg1uaJIFOqj/88TmEqydIplia3bXueA1SV
        na4QK9npFhy2HZTsOoe9TcKWjO2E4FVCxM2ryYK7LwLXRLLu7XB4NFTymQAGg6+SCrs/eaPLZST
        36DTaMsdDwfhoCLBw
X-Received: by 2002:a2e:8694:: with SMTP id l20mr25808460lji.64.1571922703151;
        Thu, 24 Oct 2019 06:11:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx2fxSxDxtucP22Qo+f3kNfkSzQawEMpEIUg3SND7+5DS0dQZ7IfSXqWflpRWbbw0XiA3yvWA==
X-Received: by 2002:a2e:8694:: with SMTP id l20mr25808435lji.64.1571922702778;
        Thu, 24 Oct 2019 06:11:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id l24sm3561061lfc.53.2019.10.24.06.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:11:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D8B061804B6; Thu, 24 Oct 2019 15:11:40 +0200 (CEST)
Subject: [PATCH bpf-next v2 3/4] libbpf: Support configurable pinning of maps
 from BTF annotations
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 24 Oct 2019 15:11:40 +0200
Message-ID: <157192270077.234778.5965993521171571751.stgit@toke.dk>
In-Reply-To: <157192269744.234778.11792009511322809519.stgit@toke.dk>
References: <157192269744.234778.11792009511322809519.stgit@toke.dk>
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
the BTF map declaration. We introduce a version new
bpf_object__map_pin_opts() function to pin maps based on this setting, as
well as a getter and setter function for the pin information that callers
can use after map load.

The pinning type currently only supports a single PIN_BY_NAME mode, where
each map will be pinned by its name in a path that can be overridden, but
defaults to /sys/fs/bpf.

The pinning options supports a 'pin_all' setting, which corresponds to the
old bpf_object__map_pin() function with an explicit path. In addition, the
function now defaults to just skipping over maps that are already
pinned (since the previous commit started recording this in struct
bpf_map). This behaviour can be turned off with the 'no_skip_pinned' option.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/bpf_helpers.h |    6 ++
 tools/lib/bpf/libbpf.c      |  134 ++++++++++++++++++++++++++++++++++---------
 tools/lib/bpf/libbpf.h      |   26 ++++++++
 tools/lib/bpf/libbpf.map    |    3 +
 4 files changed, 142 insertions(+), 27 deletions(-)

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
index 848e6710b8e6..179c9911458d 100644
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
@@ -1271,6 +1272,22 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
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
+				pr_warning("map '%s': invalid pinning value %u.\n",
+					   map_name, val);
+				return -EINVAL;
+			}
+			map->pinning = val;
 		} else {
 			if (strict) {
 				pr_warning("map '%s': unknown field '%s'.\n",
@@ -1340,6 +1357,27 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict)
 	return 0;
 }
 
+static int build_pin_path(char *buf, size_t buf_len,
+			  struct bpf_map *map,
+			  const char *path,
+			  bool pin_all)
+{
+	int len;
+
+	if (map->pinning != LIBBPF_PIN_BY_NAME && !pin_all)
+		return 0;
+
+	if (!path)
+		path = "/sys/fs/bpf";
+
+	len = snprintf(buf, buf_len, "%s/%s", path, bpf_map__name(map));
+	if (len < 0)
+		return -EINVAL;
+	else if (len >= buf_len)
+		return -ENAMETOOLONG;
+	return len;
+}
+
 static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_maps)
 {
 	bool strict = !relaxed_maps;
@@ -4127,10 +4165,13 @@ bool bpf_map__is_pinned(struct bpf_map *map)
 	return map->pinned;
 }
 
-int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
+int bpf_object__pin_maps_opts(struct bpf_object *obj,
+			      struct bpf_object_pin_opts *opts)
 {
+	bool pin_all, skip_pinned;
+	const char *pin_path;
 	struct bpf_map *map;
-	int err;
+	int err, len;
 
 	if (!obj)
 		return -ENOENT;
@@ -4140,25 +4181,34 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 		return -ENOENT;
 	}
 
-	err = make_dir(path);
-	if (err)
-		return err;
+	if (!OPTS_VALID(opts, bpf_object_pin_opts))
+		return -EINVAL;
+
+	pin_path = OPTS_GET(opts, pin_path, NULL);
+	pin_all = OPTS_GET(opts, pin_all, false);
+	skip_pinned = !OPTS_GET(opts, no_skip_pinned, false);
 
 	bpf_object__for_each_map(map, obj) {
+		char *path = NULL;
 		char buf[PATH_MAX];
-		int len;
 
-		len = snprintf(buf, PATH_MAX, "%s/%s", path,
-			       bpf_map__name(map));
-		if (len < 0) {
-			err = -EINVAL;
-			goto err_unpin_maps;
-		} else if (len >= PATH_MAX) {
-			err = -ENAMETOOLONG;
-			goto err_unpin_maps;
+		if (map->pinned && skip_pinned)
+			continue;
+
+		if (!map->pin_path) {
+
+			len = build_pin_path(buf, sizeof(buf), map,
+					     pin_path, pin_all);
+			if (len == 0) {
+				continue;
+			} else if (len < 0) {
+				err = len;
+				goto err_unpin_maps;
+			}
+			path = buf;
 		}
 
-		err = bpf_map__pin(map, buf);
+		err = bpf_map__pin(map, path);
 		if (err)
 			goto err_unpin_maps;
 	}
@@ -4166,16 +4216,30 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 	return 0;
 
 err_unpin_maps:
-	while ((map = bpf_map__prev(map, obj))) {
-		if (!map->pin_path)
-			continue;
+	if (!skip_pinned) {
+		/* Only undo pinning if we are not configured to skip
+		 * already-pinned maps; otherwise we could undo something we
+		 * didn't do in the first place.
+		 */
+		while ((map = bpf_map__prev(map, obj))) {
+			if (!map->pinned)
+				continue;
 
-		bpf_map__unpin(map, NULL);
+			bpf_map__unpin(map, NULL);
+		}
 	}
 
 	return err;
 }
 
+int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
+{
+	LIBBPF_OPTS(bpf_object_pin_opts, opts,
+		    .pin_path = path,
+		    .pin_all = (path != NULL));
+	return bpf_object__pin_maps_opts(obj, &opts);
+}
+
 int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
 {
 	struct bpf_map *map;
@@ -4185,18 +4249,24 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
 		return -ENOENT;
 
 	bpf_object__for_each_map(map, obj) {
+		char *pin_path = NULL;
 		char buf[PATH_MAX];
 		int len;
 
-		len = snprintf(buf, PATH_MAX, "%s/%s", path,
-			       bpf_map__name(map));
-		if (len < 0)
-			return -EINVAL;
-		else if (len >= PATH_MAX)
-			return -ENAMETOOLONG;
+		if (path) {
+			len = build_pin_path(buf, sizeof(buf), map, path, true);
+			if (len == 0)
+				continue;
+			else if (len < 0)
+				return len;
 
-		err = bpf_map__unpin(map, buf);
-		if (err)
+			pin_path = buf;
+		} else if (!map->pin_path) {
+			continue;
+		}
+
+		err = bpf_map__unpin(map, pin_path);
+		if (err && err != -ENOENT)
 			return err;
 	}
 
@@ -4854,6 +4924,16 @@ void bpf_map__set_ifindex(struct bpf_map *map, __u32 ifindex)
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
index 4e6733df5bb4..26a4ed3856e7 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -119,9 +119,33 @@ int bpf_object__section_size(const struct bpf_object *obj, const char *name,
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
+struct bpf_object_pin_opts {
+	/* size of this struct, for forward/backward compatiblity */
+	size_t sz;
+
+	/* Paths to pin maps. Defaults to /sys/fs/bpf */
+	const char *pin_path;
+
+	/* If set, pin all maps regardless of map definition 'pinning' value */
+	bool pin_all;
+
+	/* If set, don't skip already pinned maps */
+	bool no_skip_pinned;
+};
+#define bpf_object_pin_opts__last_field no_skip_pinned
+
 LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, const char *path);
 LIBBPF_API int bpf_object__unpin_maps(struct bpf_object *obj,
 				      const char *path);
+LIBBPF_API int bpf_object__pin_maps_opts(struct bpf_object *obj,
+					 struct bpf_object_pin_opts *opts);
 LIBBPF_API int bpf_object__pin_programs(struct bpf_object *obj,
 					const char *path);
 LIBBPF_API int bpf_object__unpin_programs(struct bpf_object *obj,
@@ -380,6 +404,8 @@ LIBBPF_API const char *bpf_map__get_pin_path(struct bpf_map *map);
 LIBBPF_API bool bpf_map__is_pinned(struct bpf_map *map);
 LIBBPF_API int bpf_map__pin(struct bpf_map *map, const char *path);
 LIBBPF_API int bpf_map__unpin(struct bpf_map *map, const char *path);
+LIBBPF_API enum libbpf_pin_type bpf_map__get_pinning(struct bpf_map *map);
+LIBBPF_API void bpf_map__set_pinning(struct bpf_map *map, enum libbpf_pin_type);
 
 LIBBPF_API int bpf_map__set_inner_map_fd(struct bpf_map *map, int fd);
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index ef9ae1943ec7..94e0dbe1658b 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -198,4 +198,7 @@ LIBBPF_0.0.6 {
 		bpf_map__get_pin_path;
 		bpf_map__set_pin_path;
 		bpf_map__is_pinned;
+		bpf_map__get_pinning;
+		bpf_map__set_pinning;
+		bpf_object__pin_maps_opts;
 } LIBBPF_0.0.5;

