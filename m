Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4AF616C12
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 19:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiKBSZl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Nov 2022 14:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiKBSZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 14:25:29 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B57B2E6B4
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 11:25:27 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2HnWcs005038
        for <netdev@vger.kernel.org>; Wed, 2 Nov 2022 11:25:26 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkvcw8vmj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 11:25:26 -0700
Received: from twshared1533.39.prn1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 11:25:24 -0700
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id F141E20FC7439; Wed,  2 Nov 2022 11:25:21 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH bpf 2/2] tools headers uapi: pull in stddef.h to fix BPF selftests build in CI
Date:   Wed, 2 Nov 2022 11:25:17 -0700
Message-ID: <20221102182517.2675301-2-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221102182517.2675301-1-andrii@kernel.org>
References: <20221102182517.2675301-1-andrii@kernel.org>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: AuP0KVjoA4HgFCQhpvSQtvLQ-koxavwc
X-Proofpoint-ORIG-GUID: AuP0KVjoA4HgFCQhpvSQtvLQ-koxavwc
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_14,2022-11-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With recent sync of linux/in.h tools/include headers are now relying on
__DECLARE_FLEX_ARRAY macro, which isn't itself defined inside
tools/include headers anywhere and is instead assumed to be present in
system-wide UAPI header. This breaks isolated environments that don't
have kernel UAPI headers installed system-wide, like BPF CI ([0]).

To fix this, bring in include/uapi/linux/stddef.h into tools/include. We
can't just copy/paste it, though, it has to be processed with
scripts/headers_install.sh, which has a dependency on scripts/unifdef.
So the full command to (re-)generate stddef.h for inclusion into
tools/include directory is:

  $ make scripts_unifdef && \
    cp $KBUILD_OUTPUT/scripts/unifdef scripts/ && \
    scripts/headers_install.sh include/uapi/linux/stddef.h tools/include/uapi/linux/stddef.h

This assumes KBUILD_OUTPUT envvar is set and used for out-of-tree builds.

  [0] https://github.com/kernel-patches/bpf/actions/runs/3379432493/jobs/5610982609

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Fixes: 036b8f5b8970 ("tools headers uapi: Update linux/in.h copy")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/include/uapi/linux/in.h     |  1 +
 tools/include/uapi/linux/stddef.h | 47 +++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)
 create mode 100644 tools/include/uapi/linux/stddef.h

diff --git a/tools/include/uapi/linux/in.h b/tools/include/uapi/linux/in.h
index f243ce665f74..07a4cb149305 100644
--- a/tools/include/uapi/linux/in.h
+++ b/tools/include/uapi/linux/in.h
@@ -20,6 +20,7 @@
 #define _UAPI_LINUX_IN_H
 
 #include <linux/types.h>
+#include <linux/stddef.h>
 #include <linux/libc-compat.h>
 #include <linux/socket.h>
 
diff --git a/tools/include/uapi/linux/stddef.h b/tools/include/uapi/linux/stddef.h
new file mode 100644
index 000000000000..bb6ea517efb5
--- /dev/null
+++ b/tools/include/uapi/linux/stddef.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _LINUX_STDDEF_H
+#define _LINUX_STDDEF_H
+
+
+
+#ifndef __always_inline
+#define __always_inline __inline__
+#endif
+
+/**
+ * __struct_group() - Create a mirrored named and anonyomous struct
+ *
+ * @TAG: The tag name for the named sub-struct (usually empty)
+ * @NAME: The identifier name of the mirrored sub-struct
+ * @ATTRS: Any struct attributes (usually empty)
+ * @MEMBERS: The member declarations for the mirrored structs
+ *
+ * Used to create an anonymous union of two structs with identical layout
+ * and size: one anonymous and one named. The former's members can be used
+ * normally without sub-struct naming, and the latter can be used to
+ * reason about the start, end, and size of the group of struct members.
+ * The named struct can also be explicitly tagged for layer reuse, as well
+ * as both having struct attributes appended.
+ */
+#define __struct_group(TAG, NAME, ATTRS, MEMBERS...) \
+	union { \
+		struct { MEMBERS } ATTRS; \
+		struct TAG { MEMBERS } ATTRS NAME; \
+	}
+
+/**
+ * __DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
+ *
+ * @TYPE: The type of each flexible array element
+ * @NAME: The name of the flexible array member
+ *
+ * In order to have a flexible array member in a union or alone in a
+ * struct, it needs to be wrapped in an anonymous struct with at least 1
+ * named member, but that member can be empty.
+ */
+#define __DECLARE_FLEX_ARRAY(TYPE, NAME)	\
+	struct { \
+		struct { } __empty_ ## NAME; \
+		TYPE NAME[]; \
+	}
+#endif
-- 
2.30.2

