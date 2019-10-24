Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5A14E3392
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 15:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502394AbfJXNLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 09:11:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502387AbfJXNLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 09:11:43 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BCA394E83E
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 13:11:42 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id a15so12960018wrr.0
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 06:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Aluqmbw9aS35UXdNs3uSSY9migl5EXzrc2Sy+ICnbM0=;
        b=M/O0iKSdas3XCY0zj1fxm452Kk6NR0+hzqFtkPUodGQP6gRJ97fHvfXCxhG/7jbT20
         LdQqFonJw7Y7qsm/E1cyU30IEQFFPjFLI4ZI/jnWaiXwfpiEVVW9ZIOZA+QmegWH0zMz
         xLk5R9Lk4HvD9xXoD6FRC4ONXX8HdH9chceIkK5UjvI4ckx6PbYBpM/Xw9y6b3fLR82/
         peMwBetSdNOmshtqH2r3LvadyxcxhBrulnPm09n36dHPaAx4WPhJNVS++G0oZeTsW4vh
         QTXtrvlV4hNLmuce95zKdCbGjl2CI8ZEZpq4UgT1t7ydRJaVkp7xG/bx8/i+6C/OsBFb
         olBw==
X-Gm-Message-State: APjAAAVgVvYPVdHUwID22yx2hv0F756ihIJpAnVDysK7SMi5613M5cS5
        49yjlLL9EtiOQLrAcGwQU5/2QZf1ORf1wqn1RR4zht0Nf5YQ37O0tbzTGlpIpTJEzOdT3LCnzav
        yedw5ZGP8q1t2gWkg
X-Received: by 2002:adf:f010:: with SMTP id j16mr3900486wro.317.1571922701391;
        Thu, 24 Oct 2019 06:11:41 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxSsDNPkRvYY/hLpJaGJjEAsKaAlfFGQyedz+j2O429QN64u3Kd3S8VGqlv864QLEhAMSW7Tg==
X-Received: by 2002:adf:f010:: with SMTP id j16mr3900455wro.317.1571922701039;
        Thu, 24 Oct 2019 06:11:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id v81sm1431530wmg.4.2019.10.24.06.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:11:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BB42B1804B1; Thu, 24 Oct 2019 15:11:39 +0200 (CEST)
Subject: [PATCH bpf-next v2 2/4] libbpf: Store map pin path and status in
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
Date:   Thu, 24 Oct 2019 15:11:39 +0200
Message-ID: <157192269965.234778.8724720580046668597.stgit@toke.dk>
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

Support storing and setting a pin path in struct bpf_map, which can be used
for automatic pinning. Also store the pin status so we can avoid attempts
to re-pin a map that has already been pinned (or reused from a previous
pinning).

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c   |  115 ++++++++++++++++++++++++++++++++++++----------
 tools/lib/bpf/libbpf.h   |    3 +
 tools/lib/bpf/libbpf.map |    3 +
 3 files changed, 97 insertions(+), 24 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a2a7d074ac48..848e6710b8e6 100644
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
@@ -4013,47 +4015,118 @@ int bpf_map__pin(struct bpf_map *map, const char *path)
 	char *cp, errmsg[STRERR_BUFSIZE];
 	int err;
 
-	err = check_path(path);
-	if (err)
-		return err;
-
 	if (map == NULL) {
 		pr_warning("invalid map pointer\n");
 		return -EINVAL;
 	}
 
-	if (bpf_obj_pin(map->fd, path)) {
-		cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
-		pr_warning("failed to pin map: %s\n", cp);
-		return -errno;
+	if (map->pinned) {
+		pr_warning("map already pinned\n");
+		return -EEXIST;
+	}
+
+	if (path && map->pin_path && strcmp(path, map->pin_path)) {
+		pr_warning("map already has pin path '%s' different from '%s'\n",
+			   map->pin_path, path);
+		return -EINVAL;
+	}
+
+	if (!map->pin_path && !path) {
+		pr_warning("missing pin path\n");
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
+	pr_warning("failed to pin map: %s\n", cp);
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
 		pr_warning("invalid map pointer\n");
 		return -EINVAL;
 	}
 
-	err = unlink(path);
+	if (!map->pin_path) {
+		pr_warning("map has no pin_path set\n");
+		return -ENOENT;
+	}
+
+	if (path && strcmp(path, map->pin_path)) {
+		pr_warning("unpin path '%s' differs from map pin path '%s'\n",
+			   path, map->pin_path);
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
@@ -4094,17 +4167,10 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 
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
@@ -4254,6 +4320,7 @@ void bpf_object__close(struct bpf_object *obj)
 
 	for (i = 0; i < obj->nr_maps; i++) {
 		zfree(&obj->maps[i].name);
+		zfree(&obj->maps[i].pin_path);
 		if (obj->maps[i].clear_priv)
 			obj->maps[i].clear_priv(&obj->maps[i],
 						obj->maps[i].priv);
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 53ce212764e0..4e6733df5bb4 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -375,6 +375,9 @@ LIBBPF_API int bpf_map__resize(struct bpf_map *map, __u32 max_entries);
 LIBBPF_API bool bpf_map__is_offload_neutral(const struct bpf_map *map);
 LIBBPF_API bool bpf_map__is_internal(const struct bpf_map *map);
 LIBBPF_API void bpf_map__set_ifindex(struct bpf_map *map, __u32 ifindex);
+LIBBPF_API int bpf_map__set_pin_path(struct bpf_map *map, const char *path);
+LIBBPF_API const char *bpf_map__get_pin_path(struct bpf_map *map);
+LIBBPF_API bool bpf_map__is_pinned(struct bpf_map *map);
 LIBBPF_API int bpf_map__pin(struct bpf_map *map, const char *path);
 LIBBPF_API int bpf_map__unpin(struct bpf_map *map, const char *path);
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 4d241fd92dd4..ef9ae1943ec7 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -195,4 +195,7 @@ LIBBPF_0.0.6 {
 	global:
 		bpf_object__open_file;
 		bpf_object__open_mem;
+		bpf_map__get_pin_path;
+		bpf_map__set_pin_path;
+		bpf_map__is_pinned;
 } LIBBPF_0.0.5;

