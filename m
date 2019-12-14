Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B0511EFA6
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 02:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfLNBoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 20:44:01 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57002 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726833AbfLNBn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 20:43:59 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBE1b2p8025278
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:43:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=MJYO7O2IlWjl6Ql+2uc+AbDrOWQy3lSeh+3EvgIF7VQ=;
 b=jYSWf1H/NszNutaK7NtLf5PIC5RiLrjUffxfMxHh3dF3CjNR67MjY0xg3lOFFFsj9P2j
 pNlrrONdcSF2og/9yo5afQpx9D8icW+GOAFsP853Txh2aX7m7G5yKWtqOdLIl2cLqECF
 YFIjqauyqB5R6GBfvImPw9DSqWyeFS2LreU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvp7hg0kj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:43:58 -0800
Received: from intmgw002.05.ash5.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 13 Dec 2019 17:43:56 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DDB3E2EC1D51; Fri, 13 Dec 2019 17:43:54 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 05/17] libbpf: extract common user-facing helpers
Date:   Fri, 13 Dec 2019 17:43:29 -0800
Message-ID: <20191214014341.3442258-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191214014341.3442258-1-andriin@fb.com>
References: <20191214014341.3442258-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=8 priorityscore=1501 mlxscore=0
 malwarescore=0 phishscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912140006
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

