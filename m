Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACCEA11EDD6
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 23:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfLMWcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 17:32:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56956 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726798AbfLMWca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 17:32:30 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBDMRFFk025595
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 14:32:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=MJYO7O2IlWjl6Ql+2uc+AbDrOWQy3lSeh+3EvgIF7VQ=;
 b=ZYXspg0b8JH9Hq2CdfcZfXptPhyAF03AT5TW4g5wSXWWmaMtBAjwtUBHMHy8HAMIXTbk
 k9KCLYSsclAU74lyXvu/QceHiScN3lPW5xMHPpN2+hcPHevd1enTZXxeQEN50sednxxq
 2L4MR9jXv5kSjJCFHexFlcO048NAHIlA6VI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2wvfg8s5yh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 14:32:29 -0800
Received: from intmgw005.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 14:32:28 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D96282EC1C8E; Fri, 13 Dec 2019 14:32:27 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 05/17] libbpf: extract common user-facing helpers
Date:   Fri, 13 Dec 2019 14:32:02 -0800
Message-ID: <20191213223214.2791885-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191213223214.2791885-1-andriin@fb.com>
References: <20191213223214.2791885-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_08:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=8 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LIBBPF_API and DECLARE_LIBBPF_OPTS are needed in many public libbpf API
headers. Extract them into libbpf_common.h to avoid unnecessary
interdependency between btf.h, libbpf.h, and bpf.h or code duplication.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf.h           |  6 ++----
 tools/lib/bpf/btf.h           |  6 ++----
 tools/lib/bpf/libbpf.h        | 28 ++------------------------
 tools/lib/bpf/libbpf_common.h | 38 +++++++++++++++++++++++++++++++++++
 4 files changed, 44 insertions(+), 34 deletions(-)
 create mode 100644 tools/lib/bpf/libbpf_common.h

diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 3c791fa8e68e..269807ce9ef5 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -28,14 +28,12 @@
 #include <stddef.h>
 #include <stdint.h>
 
+#include "libbpf_common.h"
+
 #ifdef __cplusplus
 extern "C" {
 #endif
 
-#ifndef LIBBPF_API
-#define LIBBPF_API __attribute__((visibility("default")))
-#endif
-
 struct bpf_create_map_attr {
 	const char *name;
 	enum bpf_map_type map_type;
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index d9ac73a02cde..5fc23b988deb 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -8,14 +8,12 @@
 #include <linux/btf.h>
 #include <linux/types.h>
 
+#include "libbpf_common.h"
+
 #ifdef __cplusplus
 extern "C" {
 #endif
 
-#ifndef LIBBPF_API
-#define LIBBPF_API __attribute__((visibility("default")))
-#endif
-
 #define BTF_ELF_SEC ".BTF"
 #define BTF_EXT_ELF_SEC ".BTF.ext"
 #define MAPS_ELF_SEC ".maps"
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index fa803dde1f46..49e6fa01024b 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -17,14 +17,12 @@
 #include <sys/types.h>  // for size_t
 #include <linux/bpf.h>
 
+#include "libbpf_common.h"
+
 #ifdef __cplusplus
 extern "C" {
 #endif
 
-#ifndef LIBBPF_API
-#define LIBBPF_API __attribute__((visibility("default")))
-#endif
-
 enum libbpf_errno {
 	__LIBBPF_ERRNO__START = 4000,
 
@@ -67,28 +65,6 @@ struct bpf_object_open_attr {
 	enum bpf_prog_type prog_type;
 };
 
-/* Helper macro to declare and initialize libbpf options struct
- *
- * This dance with uninitialized declaration, followed by memset to zero,
- * followed by assignment using compound literal syntax is done to preserve
- * ability to use a nice struct field initialization syntax and **hopefully**
- * have all the padding bytes initialized to zero. It's not guaranteed though,
- * when copying literal, that compiler won't copy garbage in literal's padding
- * bytes, but that's the best way I've found and it seems to work in practice.
- *
- * Macro declares opts struct of given type and name, zero-initializes,
- * including any extra padding, it with memset() and then assigns initial
- * values provided by users in struct initializer-syntax as varargs.
- */
-#define DECLARE_LIBBPF_OPTS(TYPE, NAME, ...)				    \
-	struct TYPE NAME = ({ 						    \
-		memset(&NAME, 0, sizeof(struct TYPE));			    \
-		(struct TYPE) {						    \
-			.sz = sizeof(struct TYPE),			    \
-			__VA_ARGS__					    \
-		};							    \
-	})
-
 struct bpf_object_open_opts {
 	/* size of this struct, for forward/backward compatiblity */
 	size_t sz;
diff --git a/tools/lib/bpf/libbpf_common.h b/tools/lib/bpf/libbpf_common.h
new file mode 100644
index 000000000000..4fb833840961
--- /dev/null
+++ b/tools/lib/bpf/libbpf_common.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+
+/*
+ * Common user-facing libbpf helpers.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+
+#ifndef __LIBBPF_LIBBPF_COMMON_H
+#define __LIBBPF_LIBBPF_COMMON_H
+
+#ifndef LIBBPF_API
+#define LIBBPF_API __attribute__((visibility("default")))
+#endif
+
+/* Helper macro to declare and initialize libbpf options struct
+ *
+ * This dance with uninitialized declaration, followed by memset to zero,
+ * followed by assignment using compound literal syntax is done to preserve
+ * ability to use a nice struct field initialization syntax and **hopefully**
+ * have all the padding bytes initialized to zero. It's not guaranteed though,
+ * when copying literal, that compiler won't copy garbage in literal's padding
+ * bytes, but that's the best way I've found and it seems to work in practice.
+ *
+ * Macro declares opts struct of given type and name, zero-initializes,
+ * including any extra padding, it with memset() and then assigns initial
+ * values provided by users in struct initializer-syntax as varargs.
+ */
+#define DECLARE_LIBBPF_OPTS(TYPE, NAME, ...)				    \
+	struct TYPE NAME = ({ 						    \
+		memset(&NAME, 0, sizeof(struct TYPE));			    \
+		(struct TYPE) {						    \
+			.sz = sizeof(struct TYPE),			    \
+			__VA_ARGS__					    \
+		};							    \
+	})
+
+#endif /* __LIBBPF_LIBBPF_COMMON_H */
-- 
2.17.1

