Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3549D1FE3B
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 05:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfEPDjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 23:39:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44518 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726190AbfEPDjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 23:39:33 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4G3U4iK027744
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 20:39:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=CmSHyn6HPrP5p18KmBFlKUCdl/W/+J+Wgl33L/LR0kM=;
 b=iaEUTPuNAMP+f5n3BU7/xfF3qE3zyhEVmd1vjvJO8CE/o1nDPgoTaIquYO7h2OT5bTom
 9D8PtkS9tZWOEkQE3IZ0CS5v8QW26dYdEd+75Yhak1G0zCSeaXan5glWO8MnfoDY9QqF
 V1XIn69LqQbqywbMmJusrLb9sfZpj0FVwlc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sgrjehfe9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 20:39:31 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 15 May 2019 20:39:29 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 860C28627FA; Wed, 15 May 2019 20:39:28 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf] libbpf: move logging helpers into libbpf_internal.h
Date:   Wed, 15 May 2019 20:39:27 -0700
Message-ID: <20190516033927.2425057-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-16_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=886 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905160023
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf_util.h header was recently exposed as public as a dependency of
xsk.h. In addition to memory barriers, it contained logging helpers,
which are not supposed to be exposed. This patch moves those into
libbpf_internal.h, which is kept as an internal header.

Cc: Stanislav Fomichev <sdf@google.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Fixes: 7080da890984 ("libbpf: add libbpf_util.h to header install.")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c             |  2 +-
 tools/lib/bpf/libbpf.c          |  1 -
 tools/lib/bpf/libbpf_internal.h | 13 +++++++++++++
 tools/lib/bpf/libbpf_util.h     | 13 -------------
 tools/lib/bpf/xsk.c             |  2 +-
 5 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 75eaf10b9e1a..03348c4d6bd4 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -11,7 +11,7 @@
 #include "btf.h"
 #include "bpf.h"
 #include "libbpf.h"
-#include "libbpf_util.h"
+#include "libbpf_internal.h"
 
 #define max(a, b) ((a) > (b) ? (a) : (b))
 #define min(a, b) ((a) < (b) ? (a) : (b))
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3562b6ef5fdc..197b574406b3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -43,7 +43,6 @@
 #include "bpf.h"
 #include "btf.h"
 #include "str_error.h"
-#include "libbpf_util.h"
 #include "libbpf_internal.h"
 
 #ifndef EM_BPF
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 789e435b5900..f3025b4d90e1 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -21,6 +21,19 @@
 #define BTF_PARAM_ENC(name, type) (name), (type)
 #define BTF_VAR_SECINFO_ENC(type, offset, size) (type), (offset), (size)
 
+extern void libbpf_print(enum libbpf_print_level level,
+			 const char *format, ...)
+	__attribute__((format(printf, 2, 3)));
+
+#define __pr(level, fmt, ...)	\
+do {				\
+	libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);	\
+} while (0)
+
+#define pr_warning(fmt, ...)	__pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
+#define pr_info(fmt, ...)	__pr(LIBBPF_INFO, fmt, ##__VA_ARGS__)
+#define pr_debug(fmt, ...)	__pr(LIBBPF_DEBUG, fmt, ##__VA_ARGS__)
+
 int libbpf__probe_raw_btf(const char *raw_types, size_t types_len,
 			  const char *str_sec, size_t str_len);
 
diff --git a/tools/lib/bpf/libbpf_util.h b/tools/lib/bpf/libbpf_util.h
index da94c4cb2e4d..59c779c5790c 100644
--- a/tools/lib/bpf/libbpf_util.h
+++ b/tools/lib/bpf/libbpf_util.h
@@ -10,19 +10,6 @@
 extern "C" {
 #endif
 
-extern void libbpf_print(enum libbpf_print_level level,
-			 const char *format, ...)
-	__attribute__((format(printf, 2, 3)));
-
-#define __pr(level, fmt, ...)	\
-do {				\
-	libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);	\
-} while (0)
-
-#define pr_warning(fmt, ...)	__pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
-#define pr_info(fmt, ...)	__pr(LIBBPF_INFO, fmt, ##__VA_ARGS__)
-#define pr_debug(fmt, ...)	__pr(LIBBPF_DEBUG, fmt, ##__VA_ARGS__)
-
 /* Use these barrier functions instead of smp_[rw]mb() when they are
  * used in a libbpf header file. That way they can be built into the
  * application that uses libbpf.
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index a3d1a302bc9c..38667b62f1fe 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -29,7 +29,7 @@
 
 #include "bpf.h"
 #include "libbpf.h"
-#include "libbpf_util.h"
+#include "libbpf_internal.h"
 #include "xsk.h"
 
 #ifndef SOL_XDP
-- 
2.17.1

