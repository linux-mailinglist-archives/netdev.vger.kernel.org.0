Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1734BC144
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 21:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239496AbiBRUjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 15:39:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238031AbiBRUja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 15:39:30 -0500
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C2853700
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 12:39:13 -0800 (PST)
Received: by mail-vk1-xa30.google.com with SMTP id j17so5120685vkd.12
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 12:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E327KRgWtLgKTf0hg5PNAZJONZVaa9eKKN6R4TJwseQ=;
        b=BoRxfeYCa2uXkpKJvBD7MnGDvGwABdgsp2/7qrzLR6/zUj7cYZFl5mrmZUQnL2e11R
         iJPdFVvV5JKLsKbt2dddGot2nUsdO1u2kptsdb+K//aM5hsz9qjByXjLK0dnxYJp0m3f
         sU4l+GEoA/8L379+Wf1EVkTAPHH+9+NZyQSZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E327KRgWtLgKTf0hg5PNAZJONZVaa9eKKN6R4TJwseQ=;
        b=0EMgQifjuIi9hGOqC5OntxQBfrw08XiO/t1tw/PBo+h3K77vGFJwPMQ0H2K9NQDMZE
         eX8LYDWMPpX03O/843qLI9ljvHhzI9qYz72LIUH53jNE5nsey+0TfukwgvbuksnqOkBt
         2W9Sr/XH02BB6nKkxL5LdvC/jcNqQhd6lAn/5nvQfnmeTU1O/T8uErg0myy2lYgVXIXT
         GL4tzXQlRf4kMZKQ22rCjCbI+sN9f7ezUHLWJ2vjbGyaTzBvbB8jfdDc+x8pLmswmrpu
         YNgbdya7dGfh/8g9G1OjJaf7PRdWGREwRSoLcvC3k2GyarHbVky2y73mlxTKG61a5hhG
         ZmeQ==
X-Gm-Message-State: AOAM531o6odxstTZ87b4sLshxW2n8CBDRK7Vju7Miu5pZHejNO5q8FDz
        2LrIhYeFIKykIVu8SHyp/SJAvDJbLUh7KlobiUTJFnG06hqlc6yIo/Wdj6BkhQPN1+dN4Ga9TrA
        jbgbkSYKGUErWzK/JnQ+47Y/DJcNC2+KbnNqAREDtv0A/ckJ1JHIdM2Ekntgb88YBU8/D7g==
X-Google-Smtp-Source: ABdhPJwvh1YEWxtGoG6zx+n1lN5LI5zKOXNIq9GM8X5aYJH96wzRvhRTs9j9Dz8pbIJpvvO/ur29Gg==
X-Received: by 2002:a05:6122:a1f:b0:32d:a4a4:6c27 with SMTP id 31-20020a0561220a1f00b0032da4a46c27mr4133797vkn.14.1645216749996;
        Fri, 18 Feb 2022 12:39:09 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id b78sm4820712vka.56.2022.02.18.12.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 12:39:09 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next] bpftool: Remove usage of reallocarray()
Date:   Fri, 18 Feb 2022 15:39:06 -0500
Message-Id: <20220218203906.317687-1-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes a compilation error on systems with glibc < 2.26 [0]:

```
In file included from main.h:14:0,
                 from gen.c:24:
linux/tools/include/tools/libc_compat.h:11:21: error: attempt to use poisoned "reallocarray"
 static inline void *reallocarray(void *ptr, size_t nmemb, size_t size)
```

This happens because gen.c pulls <bpf/libbpf_internal.h>, and then
<tools/libc_compat.h> (through main.h). When
COMPAT_NEED_REALLOCARRAY is set, libc_compat.h defines reallocarray()
which libbpf_internal.h poisons with a GCC pragma.

This follows the same approach of libbpf in commit
029258d7b228 ("libbpf: Remove any use of reallocarray() in libbpf").

Reported-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>

[0]: https://lore.kernel.org/bpf/3bf2bd49-9f2d-a2df-5536-bc0dde70a83b@isovalent.com/
---
 tools/bpf/bpftool/Makefile        |  6 +-----
 tools/bpf/bpftool/main.h          | 34 ++++++++++++++++++++++++++++++-
 tools/bpf/bpftool/prog.c          |  6 +++---
 tools/bpf/bpftool/xlated_dumper.c |  4 ++--
 4 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index a137db96bd56..ba647aede0d6 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -93,7 +93,7 @@ INSTALL ?= install
 RM ?= rm -f
 
 FEATURE_USER = .bpftool
-FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib libcap \
+FEATURE_TESTS = libbfd disassembler-four-args zlib libcap \
 	clang-bpf-co-re
 FEATURE_DISPLAY = libbfd disassembler-four-args zlib libcap \
 	clang-bpf-co-re
@@ -118,10 +118,6 @@ ifeq ($(feature-disassembler-four-args), 1)
 CFLAGS += -DDISASM_FOUR_ARGS_SIGNATURE
 endif
 
-ifeq ($(feature-reallocarray), 0)
-CFLAGS += -DCOMPAT_NEED_REALLOCARRAY
-endif
-
 LIBS = $(LIBBPF) -lelf -lz
 LIBS_BOOTSTRAP = $(LIBBPF_BOOTSTRAP) -lelf -lz
 ifeq ($(feature-libcap), 1)
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 0c3840596b5a..6a5775373640 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -8,10 +8,10 @@
 #undef GCC_VERSION
 #include <stdbool.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <linux/bpf.h>
 #include <linux/compiler.h>
 #include <linux/kernel.h>
-#include <tools/libc_compat.h>
 
 #include <bpf/hashmap.h>
 #include <bpf/libbpf.h>
@@ -21,6 +21,9 @@
 /* Make sure we do not use kernel-only integer typedefs */
 #pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
 
+/* prevent accidental re-addition of reallocarray() */
+#pragma GCC poison reallocarray
+
 static inline __u64 ptr_to_u64(const void *ptr)
 {
 	return (__u64)(unsigned long)ptr;
@@ -264,4 +267,33 @@ static inline bool hashmap__empty(struct hashmap *map)
 	return map ? hashmap__size(map) == 0 : true;
 }
 
+#ifndef __has_builtin
+#define __has_builtin(x) 0
+#endif
+
+/*
+ * Re-implement glibc's reallocarray() for bpftool internal-only use.
+ * reallocarray(), unfortunately, is not available in all versions of glibc,
+ * so requires extra feature detection and using reallocarray() stub from
+ * <tools/libc_compat.h> and COMPAT_NEED_REALLOCARRAY. All this complicates
+ * build of bpftool unnecessarily and is just a maintenance burden. Instead,
+ * it's trivial to implement bpftool-specific internal version and use it
+ * throughout bpftool.
+ * Copied from tools/lib/bpf/libbpf_internal.h
+ */
+static inline void *bpftool_reallocarray(void *ptr, size_t nmemb, size_t size)
+{
+	size_t total;
+
+#if __has_builtin(__builtin_mul_overflow)
+	if (unlikely(__builtin_mul_overflow(nmemb, size, &total)))
+		return NULL;
+#else
+	if (size == 0 || nmemb > ULONG_MAX / size)
+		return NULL;
+	total = nmemb * size;
+#endif
+	return realloc(ptr, total);
+}
+
 #endif
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 92a6f679ef7d..860ad234166c 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1558,9 +1558,9 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 			if (fd < 0)
 				goto err_free_reuse_maps;
 
-			new_map_replace = reallocarray(map_replace,
-						       old_map_fds + 1,
-						       sizeof(*map_replace));
+			new_map_replace = bpftool_reallocarray(map_replace,
+							       old_map_fds + 1,
+							       sizeof(*map_replace));
 			if (!new_map_replace) {
 				p_err("mem alloc failed");
 				goto err_free_reuse_maps;
diff --git a/tools/bpf/bpftool/xlated_dumper.c b/tools/bpf/bpftool/xlated_dumper.c
index f1f32e21d5cd..467bce9eee09 100644
--- a/tools/bpf/bpftool/xlated_dumper.c
+++ b/tools/bpf/bpftool/xlated_dumper.c
@@ -32,8 +32,8 @@ void kernel_syms_load(struct dump_data *dd)
 		return;
 
 	while (fgets(buff, sizeof(buff), fp)) {
-		tmp = reallocarray(dd->sym_mapping, dd->sym_count + 1,
-				   sizeof(*dd->sym_mapping));
+		tmp = bpftool_reallocarray(dd->sym_mapping, dd->sym_count + 1,
+					   sizeof(*dd->sym_mapping));
 		if (!tmp) {
 out:
 			free(dd->sym_mapping);
-- 
2.25.1

