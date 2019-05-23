Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F6827B21
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 12:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbfEWKyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 06:54:41 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38033 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729966AbfEWKyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 06:54:40 -0400
Received: by mail-wm1-f66.google.com with SMTP id t5so5291317wmh.3
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 03:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SRlyLD/JsDXMbt+om9NK9I/hxdP4mSQPyQCLku7EomI=;
        b=ezhbs4UpJlX01tvbX6ADZ1U9rHRv7hlS8yOYf9tGI9MbscbbRBaJOCCXkNRDq6pE97
         yNOnZCcMlKtwciWI3GJqQiUILvvUYeYQV2Tf0+NZazUH3SLwUoMeuILOPp9Cx7N8Dlko
         W9D9w63ThLJ2ohmaDD/Jaa43mBqOTAdY5p2CSeg1AsVyOFfBpsP+evkL83VanNn1iMAE
         +0JAPRu4gcpsTrRh7eOZKipAvtTHaxkQWbOoZz28NmmrVyvvWwlPpgx7rdyewCzrza3Q
         y8mT5yi2y6/E82Sj9UXJmTFXUCUjjFFT8ZB+UPm57gBGH6rmmUsHJPtbgCfWPXCJhiIn
         bBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SRlyLD/JsDXMbt+om9NK9I/hxdP4mSQPyQCLku7EomI=;
        b=jaDRyi3Cm94u9M+8KDCCXZnn/sSck7tn/PcT1aT9KScCtd+v5cJcpBCaiwC9Ja0uTx
         TjXJgtyHvhLuUGtyOT/QYidnzfQu6in2feNNh+qnCgt4Od9F95MF22sa34gU1GISF7Z5
         Y498ugaOl8QvUVduh6pPz9UgcyRUFYDBYAvp+hKHiDTFE0Rv4XC3KEzMXh68ro0UFm2+
         bSmyLBBHFJVdKDdhgLOBKBaTsqNwc8qOrxENgRR9RMqDnt+q51cV1qBGaKnxVUwM5bT3
         U5NBkggHRtGr3PM3jaKGAy7O8WmN95F6ZrRCGSxHK3ibaBuiCGsJnxJXzbVd6T5FGYA2
         Jjiw==
X-Gm-Message-State: APjAAAWxbMNLGL/mZ/qzWE0PncE07eG9JK1kxKy4DWF0066Of/KEqHSD
        HOlZL/D65DfVYz0mMMt+h3z3tg==
X-Google-Smtp-Source: APXvYqyS0/21TS4HSPxBDLCk3r6/2vJGhdbK7cwloJo/uIWRgcw74U3yt/eCvp8SB8m9/IiAog65LA==
X-Received: by 2002:a05:600c:2289:: with SMTP id 9mr12045497wmf.106.1558608878758;
        Thu, 23 May 2019 03:54:38 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id p8sm21285740wro.0.2019.05.23.03.54.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 03:54:37 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v2 2/3] libbpf: add bpf_object__load_xattr() API function to pass log_level
Date:   Thu, 23 May 2019 11:54:25 +0100
Message-Id: <20190523105426.3938-3-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523105426.3938-1-quentin.monnet@netronome.com>
References: <20190523105426.3938-1-quentin.monnet@netronome.com>
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

v2:
- We are in a new cycle, bump libbpf extraversion number.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/lib/bpf/Makefile   |  2 +-
 tools/lib/bpf/libbpf.c   | 20 +++++++++++++++++---
 tools/lib/bpf/libbpf.h   |  6 ++++++
 tools/lib/bpf/libbpf.map |  5 +++++
 4 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index a2aceadf68db..9312066a1ae3 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -3,7 +3,7 @@
 
 BPF_VERSION = 0
 BPF_PATCHLEVEL = 0
-BPF_EXTRAVERSION = 3
+BPF_EXTRAVERSION = 4
 
 MAKEFLAGS += --no-print-directory
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 197b574406b3..1c6fb7a3201e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2222,7 +2222,7 @@ static bool bpf_program__is_function_storage(struct bpf_program *prog,
 }
 
 static int
-bpf_object__load_progs(struct bpf_object *obj)
+bpf_object__load_progs(struct bpf_object *obj, int log_level)
 {
 	size_t i;
 	int err;
@@ -2230,6 +2230,7 @@ bpf_object__load_progs(struct bpf_object *obj)
 	for (i = 0; i < obj->nr_programs; i++) {
 		if (bpf_program__is_function_storage(&obj->programs[i], obj))
 			continue;
+		obj->programs[i].log_level = log_level;
 		err = bpf_program__load(&obj->programs[i],
 					obj->license,
 					obj->kern_version);
@@ -2381,10 +2382,14 @@ int bpf_object__unload(struct bpf_object *obj)
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
 
@@ -2397,7 +2402,7 @@ int bpf_object__load(struct bpf_object *obj)
 
 	CHECK_ERR(bpf_object__create_maps(obj), err, out);
 	CHECK_ERR(bpf_object__relocate(obj), err, out);
-	CHECK_ERR(bpf_object__load_progs(obj), err, out);
+	CHECK_ERR(bpf_object__load_progs(obj, attr->log_level), err, out);
 
 	return 0;
 out:
@@ -2406,6 +2411,15 @@ int bpf_object__load(struct bpf_object *obj)
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
index 673001787cba..6ce61fa0baf3 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -164,3 +164,8 @@ LIBBPF_0.0.3 {
 		bpf_map_freeze;
 		btf__finalize_data;
 } LIBBPF_0.0.2;
+
+LIBBPF_0.0.4 {
+	global:
+		bpf_object__load_xattr;
+} LIBBPF_0.0.3;
-- 
2.17.1

