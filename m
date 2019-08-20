Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0960895DBC
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 13:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbfHTLr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 07:47:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48284 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729801AbfHTLr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 07:47:56 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82B6B3CA03
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 11:47:55 +0000 (UTC)
Received: by mail-ed1-f70.google.com with SMTP id r21so3991688edc.6
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 04:47:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oHwAjgnCi7nJcwlD22qy23FLALaRuDMkiFpBzBVpITc=;
        b=rlOTPrufQAIK/kNsMaz0u5mjyvzueFasv+toEL/cTDyEVHayfHZgbjaoeWM3z3JHVY
         DqjtEt3eQIr0GSo2PDapRJqaTnpOb3TxvKqvbc61UPy3TWIIeOefN2ZTYoSck5EoFfZR
         7LdK733nFNNLsua1+5F2Xh5upoA3X09r171Bbl2y4ohMy5uWK4dzwh/xHeG1vVWsJ0Cx
         mFy+d3Y5Ykk41X+psKsZ1M0EPnONIU7xztyv+mcLc+JsGfoQmSw/wVAngGB29fzr5f+r
         tyyBA4NnL9mR/PKoUa9j8YS6B+AC7gNVDkuCQLvnARLzLYLa5iJqo9SJ9n34tq/IPfAr
         HUWw==
X-Gm-Message-State: APjAAAVKvafEfwqP7wABjLeXX8HrIka4mRJYwT5TTzJZZINoAp3ciow4
        C2ababA4RbdTEXRbX13GBzZFxQpDaFItr/rKbBFpgS8HScfaIAkyYdV8iAETxXn307n3kC8wN0v
        AAFnnpfQe0uzsHea4
X-Received: by 2002:aa7:c6cb:: with SMTP id b11mr30183584eds.78.1566301674276;
        Tue, 20 Aug 2019 04:47:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxMAgCDXj3rMdlmZSUyrC4eBzNSsmh50qC2pp550mSoSiLLQJjZVY6ykWREXk7fIbUEJ4JGAA==
X-Received: by 2002:aa7:c6cb:: with SMTP id b11mr30183561eds.78.1566301674018;
        Tue, 20 Aug 2019 04:47:54 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id o1sm2571120eji.19.2019.08.20.04.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 04:47:53 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 220B3181CE4; Tue, 20 Aug 2019 13:47:53 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [RFC bpf-next 3/5] libbpf: Add support for specifying map pinning path via callback
Date:   Tue, 20 Aug 2019 13:47:04 +0200
Message-Id: <20190820114706.18546-4-toke@redhat.com>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20190820114706.18546-1-toke@redhat.com>
References: <20190820114706.18546-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a callback parameter that can be set in struct bpf_prog_load_attr
which will allow the calling program to specify arbitrary paths for each
map included in an ELF file being loaded.

In particular, this allows iproute2 to implement its current semantics for
map pinning on top of libbpf.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c | 73 +++++++++++++++++++++++++++++-------------
 tools/lib/bpf/libbpf.h |  6 ++++
 2 files changed, 57 insertions(+), 22 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6d372a965c9d..a5c379378f26 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3995,8 +3995,33 @@ int bpf_map__unpin(struct bpf_map *map, const char *path)
 	return 0;
 }
 
-int bpf_object__pin_maps2(struct bpf_object *obj, const char *path,
-			  enum bpf_pin_mode mode)
+int __bpf_map__pin_path(const struct bpf_map *map,
+			const char *path,
+			map_pinning_path_fn fn, void *fn_ctx,
+			char *buf, int buf_len)
+{
+	const char *name = bpf_map__name(map);
+	int len;
+
+	if (fn) {
+		len = fn(fn_ctx, buf, buf_len, name, map->def.pinning);
+		buf[buf_len - 1] = '\0';
+		return len;
+	}
+
+	len = snprintf(buf, PATH_MAX, "%s/%s", path,
+		       name);
+	if (len < 0)
+		return -EINVAL;
+	else if (len >= PATH_MAX)
+		return -ENAMETOOLONG;
+
+	return len;
+}
+
+int __bpf_object__pin_maps(struct bpf_object *obj, enum bpf_pin_mode mode,
+			   const char *path,
+			   map_pinning_path_fn cb, void *cb_ctx)
 {
 	int explicit = (mode == BPF_PIN_MODE_EXPLICIT);
 	struct bpf_map *map;
@@ -4010,9 +4035,11 @@ int bpf_object__pin_maps2(struct bpf_object *obj, const char *path,
 		return -ENOENT;
 	}
 
-	err = make_dir(path);
-	if (err)
-		return err;
+	if (path) {
+		err = make_dir(path);
+		if (err)
+			return err;
+	}
 
 	bpf_object__for_each_map(map, obj) {
 		char buf[PATH_MAX];
@@ -4021,14 +4048,10 @@ int bpf_object__pin_maps2(struct bpf_object *obj, const char *path,
 		if ((explicit && !map->def.pinning) || map->pin_reused)
 			continue;
 
-		len = snprintf(buf, PATH_MAX, "%s/%s", path,
-			       bpf_map__name(map));
+		len = __bpf_map__pin_path(map, path, cb, cb_ctx, buf, PATH_MAX);
 		if (len < 0) {
 			err = -EINVAL;
 			goto err_unpin_maps;
-		} else if (len >= PATH_MAX) {
-			err = -ENAMETOOLONG;
-			goto err_unpin_maps;
 		}
 
 		err = bpf_map__pin(map, buf);
@@ -4059,6 +4082,13 @@ int bpf_object__pin_maps2(struct bpf_object *obj, const char *path,
 	return err;
 }
 
+int bpf_object__pin_maps2(struct bpf_object *obj, const char *path,
+			  enum bpf_pin_mode mode)
+{
+	return __bpf_object__pin_maps(obj, mode, path, NULL, NULL);
+}
+
+
 int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 {
 	return bpf_object__pin_maps2(obj, path, BPF_PIN_MODE_ALL);
@@ -4914,23 +4944,21 @@ static int bpf_map_selfcheck_pinned(int fd, const struct bpf_map_def *map,
 	}
 }
 
-
 int bpf_probe_pinned(const struct bpf_map *map,
 		     const struct bpf_prog_load_attr *attr)
 {
 	const char *name = bpf_map__name(map);
 	char buf[PATH_MAX];
-	int fd, len, ret;
+	int fd, ret;
 
-	if (!attr->auto_pin_path)
+	if (!attr->auto_pin_path && !attr->auto_pin_cb)
 		return -ENOENT;
 
-	len = snprintf(buf, PATH_MAX, "%s/%s", attr->auto_pin_path,
-		       name);
-	if (len < 0)
-		return -EINVAL;
-	else if (len >= PATH_MAX)
-		return -ENAMETOOLONG;
+	ret = __bpf_map__pin_path(map, attr->auto_pin_path,
+				  attr->auto_pin_cb, attr->auto_pin_ctx,
+				  buf, PATH_MAX);
+	if (ret < 0)
+		return ret;
 
 	fd = bpf_obj_get(buf);
 	if (fd <= 0)
@@ -5024,9 +5052,10 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 		return -EINVAL;
 	}
 
-	if (attr->auto_pin_path)
-		bpf_object__pin_maps2(obj, attr->auto_pin_path,
-				      BPF_PIN_MODE_EXPLICIT);
+	if (attr->auto_pin_path || attr->auto_pin_cb)
+		__bpf_object__pin_maps(obj, BPF_PIN_MODE_EXPLICIT,
+				       attr->auto_pin_path, attr->auto_pin_cb,
+				       attr->auto_pin_ctx);
 
 	*pobj = obj;
 	*prog_fd = bpf_program__fd(first_prog);
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 3c5c3256e22d..65fdd3389d27 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -72,6 +72,10 @@ enum bpf_pin_mode {
 	BPF_PIN_MODE_EXPLICIT,
 };
 
+struct bpf_map_def;
+typedef int (*map_pinning_path_fn)(void *ctx, char *buf, int buf_len,
+				   const char *name, unsigned int pinning);
+
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
 bpf_object__open_xattr(struct bpf_object_open_attr *attr);
@@ -361,6 +365,8 @@ struct bpf_prog_load_attr {
 	int log_level;
 	int prog_flags;
 	const char *auto_pin_path;
+	map_pinning_path_fn auto_pin_cb;
+	void *auto_pin_ctx;
 };
 
 LIBBPF_API int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
-- 
2.22.1

