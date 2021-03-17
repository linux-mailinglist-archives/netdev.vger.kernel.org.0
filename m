Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7AD433F9BD
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 21:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhCQUFn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Mar 2021 16:05:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17382 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233422AbhCQUFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 16:05:15 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12HK4xsv027374
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 13:05:15 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37b3brxrjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 13:05:15 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 17 Mar 2021 13:05:14 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DDACE2ED245B; Wed, 17 Mar 2021 13:05:13 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v3 bpf-next 1/2] libbpf: provide NULL and KERNEL_VERSION macros in bpf_helpers.h
Date:   Wed, 17 Mar 2021 13:05:09 -0700
Message-ID: <20210317200510.1354627-2-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210317200510.1354627-1-andrii@kernel.org>
References: <20210317200510.1354627-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-17_11:2021-03-17,2021-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=811 suspectscore=0 malwarescore=0 impostorscore=0 mlxscore=0
 spamscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103170140
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given that vmlinux.h is not compatible with headers like stddef.h, NULL poses
an annoying problem: it is defined as #define, so is not captured in BTF, so
is not emitted into vmlinux.h. This leads to users either sticking to explicit
0, or defining their own NULL (as progs/skb_pkt_end.c does).

But it's easy for bpf_helpers.h to provide (conditionally) NULL definition.
Similarly, KERNEL_VERSION is another commonly missed macro that came up
multiple times. So this patch adds both of them, along with offsetof(), that
also is typically defined in stddef.h, just like NULL.

This might cause compilation warning for existing BPF applications defining
their own NULL and/or KERNEL_VERSION already:

  progs/skb_pkt_end.c:7:9: warning: 'NULL' macro redefined [-Wmacro-redefined]
  #define NULL 0
          ^
  /tmp/linux/tools/testing/selftests/bpf/tools/include/vmlinux.h:4:9: note: previous definition is here
  #define NULL ((void *)0)
	  ^

It is trivial to fix, though, so long-term benefits outweight temporary
inconveniences.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/bpf_helpers.h | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 53ff81c49dbd..cc2e51c64a54 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -40,8 +40,22 @@
 #define __weak __attribute__((weak))
 #endif
 
+/* When utilizing vmlinux.h with BPF CO-RE, user BPF programs can't include
+ * any system-level headers (such as stddef.h, linux/version.h, etc), and
+ * commonly-used macros like NULL and KERNEL_VERSION aren't available through
+ * vmlinux.h. This just adds unnecessary hurdles and forces users to re-define
+ * them on their own. So as a convenience, provide such definitions here.
+ */
+#ifndef NULL
+#define NULL ((void *)0)
+#endif
+
+#ifndef KERNEL_VERSION
+#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + ((c) > 255 ? 255 : (c))
+#endif
+
 /*
- * Helper macro to manipulate data structures
+ * Helper macros to manipulate data structures
  */
 #ifndef offsetof
 #define offsetof(TYPE, MEMBER)	((unsigned long)&((TYPE *)0)->MEMBER)
-- 
2.30.2

