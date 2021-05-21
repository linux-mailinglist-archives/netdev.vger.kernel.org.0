Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50DB38D215
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 01:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhEUXny convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 May 2021 19:43:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3988 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230157AbhEUXnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 19:43:53 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LNeDgD029968
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 16:42:30 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38pgbpt5ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 16:42:30 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 16:42:29 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0DD7C2EDB019; Fri, 21 May 2021 16:42:28 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 1/5] libbpf: add libbpf_set_strict_mode() API to turn on libbpf 1.0 behaviors
Date:   Fri, 21 May 2021 16:42:27 -0700
Message-ID: <20210521234227.1286058-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: XNLHqveRO326eN-ChVRFLzArNxyK024a
X-Proofpoint-ORIG-GUID: XNLHqveRO326eN-ChVRFLzArNxyK024a
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-21_11:2021-05-20,2021-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=625 impostorscore=0 mlxscore=0 clxscore=1034
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210136
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add libbpf_set_strict_mode() API that allows application to simulate libbpf
1.0 breaking changes before libbpf 1.0 is released. This will help users
migrate gradually and with confidence.

For now only ALL or NONE options are available, subsequent patches will add
more flags. This patch is preliminary for selftests/bpf changes.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/Makefile        |  1 +
 tools/lib/bpf/libbpf.h        |  1 +
 tools/lib/bpf/libbpf.map      |  5 ++++
 tools/lib/bpf/libbpf_legacy.h | 47 +++++++++++++++++++++++++++++++++++
 4 files changed, 54 insertions(+)
 create mode 100644 tools/lib/bpf/libbpf_legacy.h

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index e43e1896cb4b..15420303cf06 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -229,6 +229,7 @@ install_headers: $(BPF_HELPER_DEFS)
 		$(call do_install,libbpf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,btf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,libbpf_common.h,$(prefix)/include/bpf,644); \
+		$(call do_install,libbpf_legacy.h,$(prefix)/include/bpf,644); \
 		$(call do_install,xsk.h,$(prefix)/include/bpf,644); \
 		$(call do_install,bpf_helpers.h,$(prefix)/include/bpf,644); \
 		$(call do_install,$(BPF_HELPER_DEFS),$(prefix)/include/bpf,644); \
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index d98523558f39..6e61342ba56c 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -18,6 +18,7 @@
 #include <linux/bpf.h>
 
 #include "libbpf_common.h"
+#include "libbpf_legacy.h"
 
 #ifdef __cplusplus
 extern "C" {
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 2abef6f17c06..6c8c16d4c628 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -369,3 +369,8 @@ LIBBPF_0.4.0 {
 		bpf_tc_hook_destroy;
 		bpf_tc_query;
 } LIBBPF_0.3.0;
+
+LIBBPF_0.5.0 {
+	global:
+		libbpf_set_strict_mode;
+} LIBBPF_0.4.0;
diff --git a/tools/lib/bpf/libbpf_legacy.h b/tools/lib/bpf/libbpf_legacy.h
new file mode 100644
index 000000000000..7482cfe22ab2
--- /dev/null
+++ b/tools/lib/bpf/libbpf_legacy.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+
+/*
+ * Libbpf legacy APIs (either discouraged or deprecated, as mentioned in [0])
+ *
+ *   [0] https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5an11_iaRuec6U-ZESZ54nNTY
+ *
+ * Copyright (C) 2021 Facebook
+ */
+#ifndef __LIBBPF_LEGACY_BPF_H
+#define __LIBBPF_LEGACY_BPF_H
+
+#include <linux/bpf.h>
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdint.h>
+#include "libbpf_common.h"
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+enum libbpf_strict_mode {
+	/* Turn on all supported strict features of libbpf to simulate libbpf
+	 * v1.0 behavior.
+	 * This will be the default behavior in libbpf v1.0.
+	 */
+	LIBBPF_STRICT_ALL = 0xffffffff,
+
+	/*
+	 * Disable any libbpf 1.0 behaviors. This is the default before libbpf
+	 * v1.0. It won't be supported anymore in v1.0, please update your
+	 * code so that it handles LIBBPF_STRICT_ALL mode before libbpf v1.0.
+	 */
+	LIBBPF_STRICT_NONE = 0x00,
+
+	__LIBBPF_STRICT_LAST,
+};
+
+LIBBPF_API int libbpf_set_strict_mode(enum libbpf_strict_mode mode);
+
+
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
+#endif /* __LIBBPF_LEGACY_BPF_H */
-- 
2.30.2

