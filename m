Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE051DFD6
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 11:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfD2Jws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 05:52:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40030 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbfD2Jwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 05:52:46 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so15061763wre.7
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 02:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=syviihkiROQSp44pSgGbE3xfH21/+hSpcetyJ2O8RyU=;
        b=OT6fXvCtJKnigL3xGLMAGuKEYof/ukSsIJH1/CENiogWmzqPoZ3KuV+SOsnYUVmyO7
         vOyK1FQul2ot4qg273wVHJFwkJQRPD8eOrrtiHaS/Px11j8WdAAvT43GxqYgr3L/U8Jl
         MEYYShBHBxplkR14TXRld9nLUPvEKviv5vqiqHXmtIlXIS7MTaTefr9tGP5cJiP6FybX
         oKCoK8kb9r3EYllUZMslyGH7rEdqo3YObPFmiwvyCx/6+V8koGBIK+Zq46D7F45c+lnw
         JQ3eCbXDhQk/iflGx8Z3wU0vL6h4Zlod+njxzP8oHyY4LeS9FkJa2HF0JDzkq+5179xY
         3HDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=syviihkiROQSp44pSgGbE3xfH21/+hSpcetyJ2O8RyU=;
        b=O6sJmKOUDD3KyFV33k7PxR1bmsdB9wP3g22fvhC5B5yiifSkjQ3474pd7/rTuWuucd
         /R8X6ey0jvLg+K//9BaB86zzcYJWwVI5UPwyoGd589Ij3M2O3OfWrKkkwziFFBZlmIFn
         FHDtr8602u3O9zlBraVu6xoqgumciDzUIT38qVxNv4h+RMk1ArWY53exwABuQOAHtFFn
         87e4NjxhLUP/ij5m0CC45uFmEzQUnVRclmlbqIEThCwH+JW81ecT04ieThu3/9QUNvOx
         SKuhe2nw/z3DAQmUSoOZVwvdcUErmZfQurvZs/6zro0rDEmbLIS7jwjDaDIV7k6TAKbK
         NNyA==
X-Gm-Message-State: APjAAAWNvYC85k9+SzMTJCdumHLfN3hfiZ2s/rmZeh7XNrnk5oEMNBmc
        ytDUH8KEdwzYl1nxqb9wioFzeg==
X-Google-Smtp-Source: APXvYqxn/J9gbrQ/uBlWx6kGXVNf28t67wc1M22Ey5hook9LmbaWdVKokXYps1ZIFJMQg3KnVDu1Lw==
X-Received: by 2002:adf:e309:: with SMTP id b9mr14792186wrj.165.1556531564560;
        Mon, 29 Apr 2019 02:52:44 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id x20sm11241535wrg.29.2019.04.29.02.52.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 02:52:43 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next 3/6] libbpf: add bpf_object__load_xattr() API function to pass log_level
Date:   Mon, 29 Apr 2019 10:52:24 +0100
Message-Id: <20190429095227.9745-4-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190429095227.9745-1-quentin.monnet@netronome.com>
References: <20190429095227.9745-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf was recently made aware of the log_level attribute for programs,
used to specify the level of information expected to be dumped by the
verifier.

Create an API function to pass additional attributes when loading a
bpf_object, so we can set this log_level value in programs when loading
them, and so that so that applications relying on libbpf but not calling
bpf_prog_load_xattr() can also use that feature.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/lib/bpf/libbpf.c   | 20 +++++++++++++++++---
 tools/lib/bpf/libbpf.h   |  6 ++++++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 11a65db4b93f..9bba86404e65 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2095,7 +2095,7 @@ static bool bpf_program__is_function_storage(struct bpf_program *prog,
 }
 
 static int
-bpf_object__load_progs(struct bpf_object *obj)
+bpf_object__load_progs(struct bpf_object *obj, int log_level)
 {
 	size_t i;
 	int err;
@@ -2103,6 +2103,7 @@ bpf_object__load_progs(struct bpf_object *obj)
 	for (i = 0; i < obj->nr_programs; i++) {
 		if (bpf_program__is_function_storage(&obj->programs[i], obj))
 			continue;
+		obj->programs[i].log_level = log_level;
 		err = bpf_program__load(&obj->programs[i],
 					obj->license,
 					obj->kern_version);
@@ -2254,10 +2255,14 @@ int bpf_object__unload(struct bpf_object *obj)
 	return 0;
 }
 
-int bpf_object__load(struct bpf_object *obj)
+int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 {
+	struct bpf_object *obj;
 	int err;
 
+	if (!attr)
+		return -EINVAL;
+	obj = attr->obj;
 	if (!obj)
 		return -EINVAL;
 
@@ -2270,7 +2275,7 @@ int bpf_object__load(struct bpf_object *obj)
 
 	CHECK_ERR(bpf_object__create_maps(obj), err, out);
 	CHECK_ERR(bpf_object__relocate(obj), err, out);
-	CHECK_ERR(bpf_object__load_progs(obj), err, out);
+	CHECK_ERR(bpf_object__load_progs(obj, attr->log_level), err, out);
 
 	return 0;
 out:
@@ -2279,6 +2284,15 @@ int bpf_object__load(struct bpf_object *obj)
 	return err;
 }
 
+int bpf_object__load(struct bpf_object *obj)
+{
+	struct bpf_object_load_attr attr = {
+		.obj = obj,
+	};
+
+	return bpf_object__load_xattr(&attr);
+}
+
 static int check_path(const char *path)
 {
 	char *cp, errmsg[STRERR_BUFSIZE];
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index c5ff00515ce7..e1c748db44f6 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -89,8 +89,14 @@ LIBBPF_API int bpf_object__unpin_programs(struct bpf_object *obj,
 LIBBPF_API int bpf_object__pin(struct bpf_object *object, const char *path);
 LIBBPF_API void bpf_object__close(struct bpf_object *object);
 
+struct bpf_object_load_attr {
+	struct bpf_object *obj;
+	int log_level;
+};
+
 /* Load/unload object into/from kernel */
 LIBBPF_API int bpf_object__load(struct bpf_object *obj);
+LIBBPF_API int bpf_object__load_xattr(struct bpf_object_load_attr *attr);
 LIBBPF_API int bpf_object__unload(struct bpf_object *obj);
 LIBBPF_API const char *bpf_object__name(struct bpf_object *obj);
 LIBBPF_API unsigned int bpf_object__kversion(struct bpf_object *obj);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 673001787cba..d2d52c8641d2 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -162,5 +162,6 @@ LIBBPF_0.0.3 {
 	global:
 		bpf_map__is_internal;
 		bpf_map_freeze;
+		bpf_object__load_xattr;
 		btf__finalize_data;
 } LIBBPF_0.0.2;
-- 
2.17.1

