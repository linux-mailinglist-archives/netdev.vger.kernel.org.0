Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 094DFE656B
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 21:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfJ0UxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 16:53:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbfJ0UxW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 16:53:22 -0400
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com [209.85.167.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AAD40C049E10
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 20:53:21 +0000 (UTC)
Received: by mail-lf1-f69.google.com with SMTP id x14so598169lfq.15
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 13:53:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/ld6GWTw5F33DlpGyASHQu/6RYXc/6S+nI67kwptMkc=;
        b=fdAQBwwXXJZeNyTYLrS0h7xRYhkmESk1cjkJ6+OP0RR7HLwnm+h9OCYFBPON2/0/r5
         h7KVsGn1BbeUNobZiZKiEHGcjUiDfKB+d81sF1gwQwwUGInOrK+6wDPBunpLHhP/QTic
         jKj3MstVjZOBMHC2EwrOF8dcfYenU0R6UorZIUg3jeM6AEzzBHE8J6E9xOWV0ndfqguh
         rhInLgtZbLWfOP/MIeCPZhMLCT3j1WmJbexrLMX1LZfZytEmnC7Y7bCL/cfIv1RMTnnr
         zgI2aYdpPB4tuopf+OYLqfi5uYdiPF+UAciDhxoYNgt4/hAR9FN/xRWNLNEXB49qG3pP
         mNLg==
X-Gm-Message-State: APjAAAXdxFElybzzdsQ9ZN8g6bljWgeKdIDje8/9yLEYga5hZVfdKRSx
        ITPTvu/DcG58lvmYwzVwfaYDIZiBYnnxJ34IDQx4sJhAdXmuzDwNTutD4aoDwVokJ72CfwAxDCI
        cBFjr4CTQhRRn3mLN
X-Received: by 2002:a19:148:: with SMTP id 69mr9680522lfb.76.1572209600182;
        Sun, 27 Oct 2019 13:53:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyZjt23avIRHDk5X5Gh60GfrEpL5w0tAd3O3bGu5410+YUgrmGDFc/NSuNTmyujJIEpj3wvGQ==
X-Received: by 2002:a19:148:: with SMTP id 69mr9680514lfb.76.1572209599963;
        Sun, 27 Oct 2019 13:53:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id g27sm4190187lja.33.2019.10.27.13.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 13:53:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B24C81818B6; Sun, 27 Oct 2019 21:53:17 +0100 (CET)
Subject: [PATCH bpf-next v3 2/4] libbpf: Store map pin path and status in
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
Date:   Sun, 27 Oct 2019 21:53:17 +0100
Message-ID: <157220959765.48922.14916417301812812065.stgit@toke.dk>
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

Support storing and setting a pin path in struct bpf_map, which can be used
for automatic pinning. Also store the pin status so we can avoid attempts
to re-pin a map that has already been pinned (or reused from a previous
pinning).

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c   |  115 ++++++++++++++++++++++++++++++++++++----------
 tools/lib/bpf/libbpf.h   |    3 +
 tools/lib/bpf/libbpf.map |    3 +
 3 files changed, 97 insertions(+), 24 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ce5ef3ddd263..eb1c5e6ad4a3 100644
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
@@ -4025,47 +4027,118 @@ int bpf_map__pin(struct bpf_map *map, const char *path)
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
+	if (map->pinned) {
+		pr_warn("map already pinned\n");
+		return -EEXIST;
+	}
+
+	if (path && map->pin_path && strcmp(path, map->pin_path)) {
+		pr_warn("map already has pin path '%s' different from '%s'\n",
+			map->pin_path, path);
+		return -EINVAL;
+	}
+
+	if (!map->pin_path && !path) {
+		pr_warn("missing pin path\n");
+		return -EINVAL;
 	}
 
-	pr_debug("pinned map '%s'\n", path);
+	if (!map->pin_path) {
+		map->pin_path = strdup(path);
+		if (!map->pin_path) {
+			err = -errno;
+			goto out_err;
+		}
+	}
+
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
 
-	err = unlink(path);
+	if (!map->pin_path) {
+		pr_warn("map has no pin_path set\n");
+		return -ENOENT;
+	}
+
+	if (path && strcmp(path, map->pin_path)) {
+		pr_warn("unpin path '%s' differs from map pin path '%s'\n",
+			path, map->pin_path);
+		return -EINVAL;
+	}
+
+	err = check_path(map->pin_path);
+	if (err)
+		return err;
+
+	err = unlink(map->pin_path);
 	if (err != 0)
 		return -errno;
-	pr_debug("unpinned map '%s'\n", path);
+
+	map->pinned = false;
+	pr_debug("unpinned map '%s'\n", map->pin_path);
 
 	return 0;
 }
 
+int bpf_map__set_pin_path(struct bpf_map *map, const char *path)
+{
+	char *old = map->pin_path, *new;
+
+	if (path) {
+		new = strdup(path);
+		if (!new)
+			return -errno;
+	} else {
+		new = NULL;
+	}
+
+	map->pin_path = new;
+	if (old)
+		free(old);
+
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
@@ -4106,17 +4179,10 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 
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
@@ -4266,6 +4332,7 @@ void bpf_object__close(struct bpf_object *obj)
 
 	for (i = 0; i < obj->nr_maps; i++) {
 		zfree(&obj->maps[i].name);
+		zfree(&obj->maps[i].pin_path);
 		if (obj->maps[i].clear_priv)
 			obj->maps[i].clear_priv(&obj->maps[i],
 						obj->maps[i].priv);
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index c63e2ff84abc..a514729c43f5 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -385,6 +385,9 @@ LIBBPF_API int bpf_map__resize(struct bpf_map *map, __u32 max_entries);
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

