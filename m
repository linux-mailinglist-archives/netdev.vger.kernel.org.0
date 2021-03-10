Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C717333705
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhCJIKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbhCJIJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 03:09:39 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636E3C06174A;
        Wed, 10 Mar 2021 00:09:39 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id v2so18952730lft.9;
        Wed, 10 Mar 2021 00:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JiR6I/htM+GHb8OVEugimZJBXvb7g4WM9js2ohIQob0=;
        b=mgpFuLz8d7IucolqowI/5A2xsdIKGX9/N/lCL3HnGYzDS20EzGEuAiTjaf0dkdwajY
         Gp+GyRVk5QDEr4hTHqYll/Z2vxdeqmPfsaPCFy733sRU0zpzN+uXvI2fSZ/QmkvjoWD+
         G4bnlp5bUPtRCY4JlFYj+krKT0OiGkr4Iwefbzyf9S69M+k1DQr84Z++/inXlJPGq6Ee
         ququr/NmzESfpuHryG9KomgqbkqA91UO9N6Pwsl8OZ38j6surb6XZUlR5Oi16rRWwQCB
         8MCjW3Fin6bhvqvh3SMOc4ayjFcRDIr5XSW5Q+xRWgAhHH2RbNeydwx87LhACx1l7Cr4
         czQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JiR6I/htM+GHb8OVEugimZJBXvb7g4WM9js2ohIQob0=;
        b=TXn8zJNL47DWkPI2p5dldPha9Y2xeILFBvgcCOfEGDBo+HDwzvjHDjMcG3LO9F4yWx
         FPQPSf/rHuV9lgQ8Eo15jY4X7HXbAkVo0uzAyM58fkMVUSm1UHIAtVwbUsXkqBfj9/17
         DhmziWroMVUeYIJyIsB1y5L30nDGL1fyj7/EeBtexMaqFCT4UgLKsY6meuPHr1o4phNt
         hlKoQrMo/TKmBxFRN9mFRiS9XTsgNmuTjKtTMr12zzke8LvR65+SW7va+HaHvTT8cKnw
         wGJtoyd3VzDkgmbP31B5XSvc1gCHocq3+UTsa7AJoMy+pulEGFwBTxqDsaMHtm+1gZy5
         TM/w==
X-Gm-Message-State: AOAM530KzfD6phsHgn8bvr/ZIUvL+EUZCHrwRWlmgor/dE9ntUdTkF1y
        q7Mv3qoDnhNZqS3YN+N8fAw=
X-Google-Smtp-Source: ABdhPJxI0JPNZrQLgHgQWNusUPtpGaPOlVujNUb8Gwq8Q90v1WcxUa7eT1Q+IQr4PplFHuOzdK7dDw==
X-Received: by 2002:ac2:5974:: with SMTP id h20mr1366024lfp.554.1615363777848;
        Wed, 10 Mar 2021 00:09:37 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id x1sm2812130ljh.62.2021.03.10.00.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 00:09:37 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, andrii@kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maximmi@nvidia.com, ciara.loftus@intel.com
Subject: [PATCH bpf-next 2/2] libbpf: xsk: move barriers from libbpf_util.h to xsk.h
Date:   Wed, 10 Mar 2021 09:09:29 +0100
Message-Id: <20210310080929.641212-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210310080929.641212-1-bjorn.topel@gmail.com>
References: <20210310080929.641212-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The only user of libbpf_util.h is xsk.h. Move the barriers to xsk.h,
and remove libbpf_util.h. The barriers are used as an implementation
detail, and should not be considered part of the stable API.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/lib/bpf/Makefile      |  1 -
 tools/lib/bpf/libbpf_util.h | 82 -------------------------------------
 tools/lib/bpf/xsk.h         | 68 +++++++++++++++++++++++++++++-
 3 files changed, 67 insertions(+), 84 deletions(-)
 delete mode 100644 tools/lib/bpf/libbpf_util.h

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 8170f88e8ea6..f45bacbaa3d5 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -228,7 +228,6 @@ install_headers: $(BPF_HELPER_DEFS)
 		$(call do_install,bpf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,libbpf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,btf.h,$(prefix)/include/bpf,644); \
-		$(call do_install,libbpf_util.h,$(prefix)/include/bpf,644); \
 		$(call do_install,libbpf_common.h,$(prefix)/include/bpf,644); \
 		$(call do_install,xsk.h,$(prefix)/include/bpf,644); \
 		$(call do_install,bpf_helpers.h,$(prefix)/include/bpf,644); \
diff --git a/tools/lib/bpf/libbpf_util.h b/tools/lib/bpf/libbpf_util.h
deleted file mode 100644
index 954da9b34a34..000000000000
--- a/tools/lib/bpf/libbpf_util.h
+++ /dev/null
@@ -1,82 +0,0 @@
-/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
-/* Copyright (c) 2019 Facebook */
-
-#ifndef __LIBBPF_LIBBPF_UTIL_H
-#define __LIBBPF_LIBBPF_UTIL_H
-
-#include <stdbool.h>
-
-#ifdef __cplusplus
-extern "C" {
-#endif
-
-/* Load-Acquire Store-Release barriers used by the XDP socket
- * library. The following macros should *NOT* be considered part of
- * the xsk.h API, and is subject to change anytime.
- *
- * LIBRARY INTERNAL
- */
-
-#define __XSK_READ_ONCE(x) (*(volatile typeof(x) *)&x)
-#define __XSK_WRITE_ONCE(x, v) (*(volatile typeof(x) *)&x) = (v)
-
-#if defined(__i386__) || defined(__x86_64__)
-# define libbpf_smp_store_release(p, v)					\
-	do {								\
-		asm volatile("" : : : "memory");			\
-		__XSK_WRITE_ONCE(*p, v);				\
-	} while (0)
-# define libbpf_smp_load_acquire(p)					\
-	({								\
-		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
-		asm volatile("" : : : "memory");			\
-		___p1;							\
-	})
-#elif defined(__aarch64__)
-# define libbpf_smp_store_release(p, v)					\
-		asm volatile ("stlr %w1, %0" : "=Q" (*p) : "r" (v) : "memory")
-# define libbpf_smp_load_acquire(p)					\
-	({								\
-		typeof(*p) ___p1;					\
-		asm volatile ("ldar %w0, %1"				\
-			      : "=r" (___p1) : "Q" (*p) : "memory");	\
-		___p1;							\
-	})
-#elif defined(__riscv)
-# define libbpf_smp_store_release(p, v)					\
-	do {								\
-		asm volatile ("fence rw,w" : : : "memory");		\
-		__XSK_WRITE_ONCE(*p, v);				\
-	} while (0)
-# define libbpf_smp_load_acquire(p)					\
-	({								\
-		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
-		asm volatile ("fence r,rw" : : : "memory");		\
-		___p1;							\
-	})
-#endif
-
-#ifndef libbpf_smp_store_release
-#define libbpf_smp_store_release(p, v)					\
-	do {								\
-		__sync_synchronize();					\
-		__XSK_WRITE_ONCE(*p, v);				\
-	} while (0)
-#endif
-
-#ifndef libbpf_smp_load_acquire
-#define libbpf_smp_load_acquire(p)					\
-	({								\
-		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
-		__sync_synchronize();					\
-		___p1;							\
-	})
-#endif
-
-/* LIBRARY INTERNAL -- END */
-
-#ifdef __cplusplus
-} /* extern "C" */
-#endif
-
-#endif
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index a9fdea87b5cd..1d846a419d21 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -4,6 +4,7 @@
  * AF_XDP user-space access library.
  *
  * Copyright(c) 2018 - 2019 Intel Corporation.
+ * Copyright (c) 2019 Facebook
  *
  * Author(s): Magnus Karlsson <magnus.karlsson@intel.com>
  */
@@ -13,15 +14,80 @@
 
 #include <stdio.h>
 #include <stdint.h>
+#include <stdbool.h>
 #include <linux/if_xdp.h>
 
 #include "libbpf.h"
-#include "libbpf_util.h"
 
 #ifdef __cplusplus
 extern "C" {
 #endif
 
+/* Load-Acquire Store-Release barriers used by the XDP socket
+ * library. The following macros should *NOT* be considered part of
+ * the xsk.h API, and is subject to change anytime.
+ *
+ * LIBRARY INTERNAL
+ */
+
+#define __XSK_READ_ONCE(x) (*(volatile typeof(x) *)&x)
+#define __XSK_WRITE_ONCE(x, v) (*(volatile typeof(x) *)&x) = (v)
+
+#if defined(__i386__) || defined(__x86_64__)
+# define libbpf_smp_store_release(p, v)					\
+	do {								\
+		asm volatile("" : : : "memory");			\
+		__XSK_WRITE_ONCE(*p, v);				\
+	} while (0)
+# define libbpf_smp_load_acquire(p)					\
+	({								\
+		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
+		asm volatile("" : : : "memory");			\
+		___p1;							\
+	})
+#elif defined(__aarch64__)
+# define libbpf_smp_store_release(p, v)					\
+		asm volatile ("stlr %w1, %0" : "=Q" (*p) : "r" (v) : "memory")
+# define libbpf_smp_load_acquire(p)					\
+	({								\
+		typeof(*p) ___p1;					\
+		asm volatile ("ldar %w0, %1"				\
+			      : "=r" (___p1) : "Q" (*p) : "memory");	\
+		___p1;							\
+	})
+#elif defined(__riscv)
+# define libbpf_smp_store_release(p, v)					\
+	do {								\
+		asm volatile ("fence rw,w" : : : "memory");		\
+		__XSK_WRITE_ONCE(*p, v);				\
+	} while (0)
+# define libbpf_smp_load_acquire(p)					\
+	({								\
+		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
+		asm volatile ("fence r,rw" : : : "memory");		\
+		___p1;							\
+	})
+#endif
+
+#ifndef libbpf_smp_store_release
+#define libbpf_smp_store_release(p, v)					\
+	do {								\
+		__sync_synchronize();					\
+		__XSK_WRITE_ONCE(*p, v);				\
+	} while (0)
+#endif
+
+#ifndef libbpf_smp_load_acquire
+#define libbpf_smp_load_acquire(p)					\
+	({								\
+		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
+		__sync_synchronize();					\
+		___p1;							\
+	})
+#endif
+
+/* LIBRARY INTERNAL -- END */
+
 /* Do not access these members directly. Use the functions below. */
 #define DEFINE_XSK_RING(name) \
 struct name { \
-- 
2.27.0

