Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE00AE9016
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 20:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732226AbfJ2Tj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 15:39:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731936AbfJ2Tj3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 15:39:29 -0400
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0C97085545
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 19:39:28 +0000 (UTC)
Received: by mail-lf1-f71.google.com with SMTP id v7so731380lfi.2
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 12:39:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZCfWMdw+9MblLP9dkNsTP45FIFnbRap3kdsWxOeMMFU=;
        b=Vgh9fidfLtS7Ny4LwlH+mAGbhqhIBzNTaZ8CQNJ4jtl6J/CEUGOghnvJe37Mj6p2JK
         fgT4dvHT1VXRoaxKQ/HHrDuMGXdPgE5RRug0ig9vA0faBYmJHJ7Qc6dGKjbyShaw4/TX
         QArWhmcTwptd3oWreVeU5TZ8l0mKpB+4au4e6VjDxaeG33PMyyu5aaOuKGOfTHzRF22N
         JHu2IanBM61pyM+YXwfY+X0VZdijC1VNT9k6EThdzbXQJGa3kmh+fCZ6zb3b59onmSeQ
         5EzOnvZ8H4fTOT3L/YFZeGs5X/Xwln+ZHppDWluTQZ7SXIkZmx14XUJ4yklMO/HqhdC1
         isqA==
X-Gm-Message-State: APjAAAWZheBLgfE5gOOZoIA6iuvx+oVaq6cbkrALg1vq6ooboZ/6a5EL
        SooGUsX64rL7dEi5CXB8qKeDrFtrGZLa4c4KcRyAyzlvrtJ4W2Bp0sKde1M3YETVRhxLKHyP5SV
        Cdll61cUvW0+gpHP1
X-Received: by 2002:a05:6512:146:: with SMTP id m6mr3453848lfo.98.1572377966476;
        Tue, 29 Oct 2019 12:39:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxwJ9tVlIrOn7DDSvwDwCNnrbZvJO/QsvYxP9PWJ2TjI42rBRVLXPhCc66SHNFTBvZWCy3sPA==
X-Received: by 2002:a05:6512:146:: with SMTP id m6mr3453828lfo.98.1572377966176;
        Tue, 29 Oct 2019 12:39:26 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id o2sm2016188ljj.79.2019.10.29.12.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 12:39:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9C79F1818B6; Tue, 29 Oct 2019 20:39:24 +0100 (CET)
Subject: [PATCH bpf-next v4 2/5] libbpf: Store map pin path and status in
 struct bpf_map
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Tue, 29 Oct 2019 20:39:24 +0100
Message-ID: <157237796448.169521.1399805620810530569.stgit@toke.dk>
In-Reply-To: <157237796219.169521.2129132883251452764.stgit@toke.dk>
References: <157237796219.169521.2129132883251452764.stgit@toke.dk>
User-Agent: StGit/0.20
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Support storing and setting a pin path in struct bpf_map, which can be used
for automatic pinning. Also store the pin status so we can avoid attempts
to re-pin a map that has already been pinned (or reused from a previous
pinning).

The behaviour of bpf_object__{un,}pin_maps() is changed so that if it is
called with a NULL path argument (which was previously illegal), it will
(un)pin only those maps that have a pin_path set.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c   |  164 +++++++++++++++++++++++++++++++++++-----------
 tools/lib/bpf/libbpf.h   |    8 ++
 tools/lib/bpf/libbpf.map |    3 +
 3 files changed, 134 insertions(+), 41 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ce5ef3ddd263..fd11f6aeb32c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -226,6 +226,8 @@ struct bpf_map {
 	void *priv;
 	bpf_map_clear_priv_t clear_priv;
 	enum libbpf_map_type libbpf_type;
+	char *pin_path;
+	bool pinned;
 };
 
 struct bpf_secdata {
@@ -4025,47 +4027,119 @@ int bpf_map__pin(struct bpf_map *map, const char *path)
 	char *cp, errmsg[STRERR_BUFSIZE];
 	int err;
 
-	err = check_path(path);
-	if (err)
-		return err;
-
 	if (map == NULL) {
 		pr_warn("invalid map pointer\n");
 		return -EINVAL;
 	}
 
-	if (bpf_obj_pin(map->fd, path)) {
-		cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
-		pr_warn("failed to pin map: %s\n", cp);
-		return -errno;
+	if (map->pin_path) {
+		if (path && strcmp(path, map->pin_path)) {
+			pr_warn("map '%s' already has pin path '%s' different from '%s'\n",
+				bpf_map__name(map), map->pin_path, path);
+			return -EINVAL;
+		} else if (map->pinned) {
+			pr_debug("map '%s' already pinned at '%s'; not re-pinning\n",
+				 bpf_map__name(map), map->pin_path);
+			return 0;
+		}
+	} else {
+		if (!path) {
+			pr_warn("missing a path to pin map '%s' at\n",
+				bpf_map__name(map));
+			return -EINVAL;
+		} else if (map->pinned) {
+			pr_warn("map '%s' already pinned\n", bpf_map__name(map));
+			return -EEXIST;
+		}
+
+		map->pin_path = strdup(path);
+		if (!map->pin_path) {
+			err = -errno;
+			goto out_err;
+		}
 	}
 
-	pr_debug("pinned map '%s'\n", path);
+	err = check_path(map->pin_path);
+	if (err)
+		return err;
+
+	if (bpf_obj_pin(map->fd, map->pin_path)) {
+		err = -errno;
+		goto out_err;
+	}
+
+	map->pinned = true;
+	pr_debug("pinned map '%s'\n", map->pin_path);
 
 	return 0;
+
+out_err:
+	cp = libbpf_strerror_r(-err, errmsg, sizeof(errmsg));
+	pr_warn("failed to pin map: %s\n", cp);
+	return err;
 }
 
 int bpf_map__unpin(struct bpf_map *map, const char *path)
 {
 	int err;
 
-	err = check_path(path);
-	if (err)
-		return err;
-
 	if (map == NULL) {
 		pr_warn("invalid map pointer\n");
 		return -EINVAL;
 	}
 
+	if (map->pin_path) {
+		if (path && strcmp(path, map->pin_path)) {
+			pr_warn("map '%s' already has pin path '%s' different from '%s'\n",
+				bpf_map__name(map), map->pin_path, path);
+			return -EINVAL;
+		}
+		path = map->pin_path;
+	} else if (!path) {
+		pr_warn("no path to unpin map '%s' from\n",
+			bpf_map__name(map));
+		return -EINVAL;
+	}
+
+	err = check_path(path);
+	if (err)
+		return err;
+
 	err = unlink(path);
 	if (err != 0)
 		return -errno;
-	pr_debug("unpinned map '%s'\n", path);
+
+	map->pinned = false;
+	pr_debug("unpinned map from '%s' from '%s'\n", bpf_map__name(map), path);
 
 	return 0;
 }
 
+int bpf_map__set_pin_path(struct bpf_map *map, const char *path)
+{
+	char *new = NULL;
+
+	if (path) {
+		new = strdup(path);
+		if (!new)
+			return -errno;
+	}
+
+	free(map->pin_path);
+	map->pin_path = new;
+	return 0;
+}
+
+const char *bpf_map__get_pin_path(struct bpf_map *map)
+{
+	return map->pin_path;
+}
+
+bool bpf_map__is_pinned(struct bpf_map *map)
+{
+	return map->pinned;
+}
+
 int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 {
 	struct bpf_map *map;
@@ -4084,20 +4158,27 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 		return err;
 
 	bpf_object__for_each_map(map, obj) {
+		char *pin_path = NULL;
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
+		if (path) {
+			int len;
+
+			len = snprintf(buf, PATH_MAX, "%s/%s", path,
+				       bpf_map__name(map));
+			if (len < 0) {
+				err = -EINVAL;
+				goto err_unpin_maps;
+			} else if (len >= PATH_MAX) {
+				err = -ENAMETOOLONG;
+				goto err_unpin_maps;
+			}
+			pin_path = buf;
+		} else if (!map->pin_path) {
+			continue;
 		}
 
-		err = bpf_map__pin(map, buf);
+		err = bpf_map__pin(map, pin_path);
 		if (err)
 			goto err_unpin_maps;
 	}
@@ -4106,17 +4187,10 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 
 err_unpin_maps:
 	while ((map = bpf_map__prev(map, obj))) {
-		char buf[PATH_MAX];
-		int len;
-
-		len = snprintf(buf, PATH_MAX, "%s/%s", path,
-			       bpf_map__name(map));
-		if (len < 0)
-			continue;
-		else if (len >= PATH_MAX)
+		if (!map->pin_path)
 			continue;
 
-		bpf_map__unpin(map, buf);
+		bpf_map__unpin(map, NULL);
 	}
 
 	return err;
@@ -4131,17 +4205,24 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
 		return -ENOENT;
 
 	bpf_object__for_each_map(map, obj) {
+		char *pin_path = NULL;
 		char buf[PATH_MAX];
-		int len;
 
-		len = snprintf(buf, PATH_MAX, "%s/%s", path,
-			       bpf_map__name(map));
-		if (len < 0)
-			return -EINVAL;
-		else if (len >= PATH_MAX)
-			return -ENAMETOOLONG;
+		if (path) {
+			int len;
+
+			len = snprintf(buf, PATH_MAX, "%s/%s", path,
+				       bpf_map__name(map));
+			if (len < 0)
+				return -EINVAL;
+			else if (len >= PATH_MAX)
+				return -ENAMETOOLONG;
+			pin_path = buf;
+		} else if (!map->pin_path) {
+			continue;
+		}
 
-		err = bpf_map__unpin(map, buf);
+		err = bpf_map__unpin(map, pin_path);
 		if (err)
 			return err;
 	}
@@ -4266,6 +4347,7 @@ void bpf_object__close(struct bpf_object *obj)
 
 	for (i = 0; i < obj->nr_maps; i++) {
 		zfree(&obj->maps[i].name);
+		zfree(&obj->maps[i].pin_path);
 		if (obj->maps[i].clear_priv)
 			obj->maps[i].clear_priv(&obj->maps[i],
 						obj->maps[i].priv);
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index c63e2ff84abc..e28ef2ebe062 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -124,6 +124,11 @@ int bpf_object__section_size(const struct bpf_object *obj, const char *name,
 			     __u32 *size);
 int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
 				__u32 *off);
+
+/* pin_maps and unpin_maps can both be called with a NULL path, in which case
+ * they will use the pin_path attribute of each map (and ignore all maps that
+ * don't have a pin_path set).
+ */
 LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, const char *path);
 LIBBPF_API int bpf_object__unpin_maps(struct bpf_object *obj,
 				      const char *path);
@@ -385,6 +390,9 @@ LIBBPF_API int bpf_map__resize(struct bpf_map *map, __u32 max_entries);
 LIBBPF_API bool bpf_map__is_offload_neutral(const struct bpf_map *map);
 LIBBPF_API bool bpf_map__is_internal(const struct bpf_map *map);
 LIBBPF_API void bpf_map__set_ifindex(struct bpf_map *map, __u32 ifindex);
+LIBBPF_API int bpf_map__set_pin_path(struct bpf_map *map, const char *path);
+LIBBPF_API const char *bpf_map__get_pin_path(struct bpf_map *map);
+LIBBPF_API bool bpf_map__is_pinned(struct bpf_map *map);
 LIBBPF_API int bpf_map__pin(struct bpf_map *map, const char *path);
 LIBBPF_API int bpf_map__unpin(struct bpf_map *map, const char *path);
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index d1473ea4d7a5..c24d4c01591d 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -197,4 +197,7 @@ LIBBPF_0.0.6 {
 		bpf_object__open_mem;
 		bpf_program__get_expected_attach_type;
 		bpf_program__get_type;
+		bpf_map__get_pin_path;
+		bpf_map__set_pin_path;
+		bpf_map__is_pinned;
 } LIBBPF_0.0.5;

