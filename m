Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E5560C8A
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 22:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbfGEUoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 16:44:20 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43735 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEUoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 16:44:19 -0400
Received: by mail-ot1-f67.google.com with SMTP id q10so10206495otk.10;
        Fri, 05 Jul 2019 13:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gQCTGZAjgL4m+xgu8lvBMUv8xr+AG/QIjMMKs/1wRMM=;
        b=tnYMT1jjORWaTZ0vMAA0DNTy+/awxvcvaOKzBhmBb34xOzfT5fVKhAIj+muJdomr1q
         cftFMcY14a6rSOHnal5avFhNbdcICNFd3kEMl+m0mMw+LTNQe9flzH2SwnnJlNxooK06
         ww+dBQdyGdR8JESSx2KVEhNdhJImqv63iRNLG1VgRGurQMzeNFlOZr8k3TzsDprzUcj0
         WCtQfajeprKkfrpgl19ub8/19oRKpIGZxTiLLdqKB/ji5iWv6xBXd/oBKItJEP79XJl5
         ljDTrmwo0oRn+nGJbtjtDezKOhfBC60h8VWBo7pbAzvsEN7MRGbhQQpf+PjuMQf3DIwd
         J3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gQCTGZAjgL4m+xgu8lvBMUv8xr+AG/QIjMMKs/1wRMM=;
        b=LnjqBkseh80mmTI/dS3MJXR7oka+sODREGcUwU4OC5U119TClpr9oEkFuH0/qANY+A
         SypHSUFsdN6RpniVjn4GYGfE29sW/i+BvdWHn9ioUfE3k1W0DNzJ8aSqwLpLDI1Wd+dT
         UBjBbj3OvvT5jnuH6ScXwfJgzigOvQxM7TJXlx9HGDpJYcTitnCDvAPA4gtMrvc/CpGO
         4UgOrcrqpQxC8ZYZO6Oo/XPKO+dRjuBz+ObWzzsT3v4dgo3AqaDg+S2XHRZXbzOehL/c
         U5IvpJfpOAEyi6dpVsCj3WEK22/HJjoZlbepEwxEwEyj62isxEGcvrFWFUHVWQSozfuR
         yMHA==
X-Gm-Message-State: APjAAAUM+UObpRyNIjQphowhWDSBMzxoUiCMPHSe7jUei5sBYbFN1v7S
        JCW/DaJJ9dwHN2OeE5Pl/hQ=
X-Google-Smtp-Source: APXvYqzzMrp2wBtKC1P30vTDPqaOfeiLXQXZHA+j7qL/WRU+BKidhOnNe8T0RWcutXvvEb/wVtZnXg==
X-Received: by 2002:a9d:7697:: with SMTP id j23mr3072631otl.128.1562359459239;
        Fri, 05 Jul 2019 13:44:19 -0700 (PDT)
Received: from localhost.members.linode.com ([2600:3c00::f03c:91ff:fe99:7fe5])
        by smtp.gmail.com with ESMTPSA id l5sm3397529otf.53.2019.07.05.13.44.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 13:44:18 -0700 (PDT)
From:   Anton Protopopov <a.s.protopopov@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Anton Protopopov <a.s.protopopov@gmail.com>
Subject: [PATCH bpf-next 1/2] bpf, libbpf: add a new API bpf_object__reuse_maps()
Date:   Fri,  5 Jul 2019 20:44:12 +0000
Message-Id: <e183c0af99056f8ea4de06acb358ace7f3a3d6ae.1562359091.git.a.s.protopopov@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1562359091.git.a.s.protopopov@gmail.com>
References: <cover.1562359091.git.a.s.protopopov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new API bpf_object__reuse_maps() which can be used to replace all maps in
an object by maps pinned to a directory provided in the path argument.  Namely,
each map M in the object will be replaced by a map pinned to path/M.name.

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
---
 tools/lib/bpf/libbpf.c   | 34 ++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  2 ++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 37 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4907997289e9..84c9e8f7bfd3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3144,6 +3144,40 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
 	return 0;
 }
 
+int bpf_object__reuse_maps(struct bpf_object *obj, const char *path)
+{
+	struct bpf_map *map;
+
+	if (!obj)
+		return -ENOENT;
+
+	if (!path)
+		return -EINVAL;
+
+	bpf_object__for_each_map(map, obj) {
+		int len, err;
+		int pinned_map_fd;
+		char buf[PATH_MAX];
+
+		len = snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map__name(map));
+		if (len < 0) {
+			return -EINVAL;
+		} else if (len >= PATH_MAX) {
+			return -ENAMETOOLONG;
+		}
+
+		pinned_map_fd = bpf_obj_get(buf);
+		if (pinned_map_fd < 0)
+			return pinned_map_fd;
+
+		err = bpf_map__reuse_fd(map, pinned_map_fd);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
 {
 	struct bpf_program *prog;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index d639f47e3110..7fe465a1be76 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -82,6 +82,8 @@ int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
 LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, const char *path);
 LIBBPF_API int bpf_object__unpin_maps(struct bpf_object *obj,
 				      const char *path);
+LIBBPF_API int bpf_object__reuse_maps(struct bpf_object *obj,
+				      const char *path);
 LIBBPF_API int bpf_object__pin_programs(struct bpf_object *obj,
 					const char *path);
 LIBBPF_API int bpf_object__unpin_programs(struct bpf_object *obj,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 2c6d835620d2..66a30be6696c 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -172,5 +172,6 @@ LIBBPF_0.0.4 {
 		btf_dump__new;
 		btf__parse_elf;
 		bpf_object__load_xattr;
+		bpf_object__reuse_maps;
 		libbpf_num_possible_cpus;
 } LIBBPF_0.0.3;
-- 
2.19.1

