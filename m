Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD8331608
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfEaUVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:21:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60310 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727459AbfEaUVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 16:21:48 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4VKGVXE025803
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 13:21:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=jW5wOYG2tAVHdatB6d9CMo4f6Bbw4bFSDrANqSz+0QU=;
 b=fQL+e/QD6D3WjCZDD2IVdIlHa3TSHjY35cXunrFZyrpBSwH87dm7hayYO+VlSBf/fGai
 CAWz6JTEY024hrvhBaHYQknFb0onGRPPJb4d7F42QrvUlJB2QlDc9FzbanMqmQPJ++rd
 Ghw1yCa1AKrBKsQyXKrpx2TA2KadXkvAnnk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2suar203be-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 13:21:47 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 31 May 2019 13:21:44 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 7C297861799; Fri, 31 May 2019 13:21:43 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [RFC PATCH bpf-next 1/8] libbpf: add common min/max macro to libbpf_internal.h
Date:   Fri, 31 May 2019 13:21:25 -0700
Message-ID: <20190531202132.379386-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190531202132.379386-1-andriin@fb.com>
References: <20190531202132.379386-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-31_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905310123
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multiple files in libbpf redefine their own definitions for min/max.
Let's define them in libbpf_internal.h and use those everywhere.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf.c             | 7 ++-----
 tools/lib/bpf/bpf_prog_linfo.c  | 5 +----
 tools/lib/bpf/btf.c             | 3 ---
 tools/lib/bpf/btf_dump.c        | 3 ---
 tools/lib/bpf/libbpf_internal.h | 7 +++++++
 5 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 0d4b4fe10a84..c7d7993c44bb 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -26,10 +26,11 @@
 #include <memory.h>
 #include <unistd.h>
 #include <asm/unistd.h>
+#include <errno.h>
 #include <linux/bpf.h>
 #include "bpf.h"
 #include "libbpf.h"
-#include <errno.h>
+#include "libbpf_internal.h"
 
 /*
  * When building perf, unistd.h is overridden. __NR_bpf is
@@ -53,10 +54,6 @@
 # endif
 #endif
 
-#ifndef min
-#define min(x, y) ((x) < (y) ? (x) : (y))
-#endif
-
 static inline __u64 ptr_to_u64(const void *ptr)
 {
 	return (__u64) (unsigned long) ptr;
diff --git a/tools/lib/bpf/bpf_prog_linfo.c b/tools/lib/bpf/bpf_prog_linfo.c
index 6978314ea7f6..8c67561c93b0 100644
--- a/tools/lib/bpf/bpf_prog_linfo.c
+++ b/tools/lib/bpf/bpf_prog_linfo.c
@@ -6,10 +6,7 @@
 #include <linux/err.h>
 #include <linux/bpf.h>
 #include "libbpf.h"
-
-#ifndef min
-#define min(x, y) ((x) < (y) ? (x) : (y))
-#endif
+#include "libbpf_internal.h"
 
 struct bpf_prog_linfo {
 	void *raw_linfo;
diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index b2478e98c367..467224feb43b 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -16,9 +16,6 @@
 #include "libbpf_internal.h"
 #include "hashmap.h"
 
-#define max(a, b) ((a) > (b) ? (a) : (b))
-#define min(a, b) ((a) < (b) ? (a) : (b))
-
 #define BTF_MAX_NR_TYPES 0x7fffffff
 #define BTF_MAX_STR_OFFSET 0x7fffffff
 
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 4b22db77e2cc..7065bb5b2752 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -18,9 +18,6 @@
 #include "libbpf.h"
 #include "libbpf_internal.h"
 
-#define min(x, y) ((x) < (y) ? (x) : (y))
-#define max(x, y) ((x) < (y) ? (y) : (x))
-
 static const char PREFIXES[] = "\t\t\t\t\t\t\t\t\t\t\t\t\t";
 static const size_t PREFIX_CNT = sizeof(PREFIXES) - 1;
 
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 850f7bdec5cb..554a7856dc2d 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -23,6 +23,13 @@
 #define BTF_PARAM_ENC(name, type) (name), (type)
 #define BTF_VAR_SECINFO_ENC(type, offset, size) (type), (offset), (size)
 
+#ifndef min
+# define min(x, y) ((x) < (y) ? (x) : (y))
+#endif
+#ifndef max
+# define max(x, y) ((x) < (y) ? (y) : (x))
+#endif
+
 extern void libbpf_print(enum libbpf_print_level level,
 			 const char *format, ...)
 	__attribute__((format(printf, 2, 3)));
-- 
2.17.1

