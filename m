Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A964213C03
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 16:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgGCOrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 10:47:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37090 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgGCOrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 10:47:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063EcUTZ047306;
        Fri, 3 Jul 2020 14:46:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=lq5sVyx1UalpiHI43tkae6jUDgNoIVMM3yi7/H6bvs8=;
 b=jTE6oOsCjzcSV44EGWqEhTyApm7H87Rd9aB2gKS/9D61v5YhqQV9iA8wd2+ZfzSRYcqX
 e2TA4ORyc1AGbbYgWSO8Fngr6gXM1VrCzEZ42nYF6EZ+mYKNrdMcY2SgAcOjJcgZQkXI
 eXn4FANQtqTmoYVRXjbCJRHtpM4eUVUdCi1aSGgE0gE7lDVNvoIndoT4y9WuFYyqmxr6
 evqfXTu4GvtEo0Jyp6F7vVkOQVN3zMhi/7PnCBbqQ9xTnPRlaLLIh2fkl4fv1PjRbRoR
 nhgohcqyuOnbfm7v7CuMkuNhTTDtfXpIcks7aiYWWkVbMWThCSWZKwlgIwfGccZDU3ee 7g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wxrnp2wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 14:46:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063EgrXb193561;
        Fri, 3 Jul 2020 14:44:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31xg1cjyw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 14:44:43 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 063EigIT023486;
        Fri, 3 Jul 2020 14:44:42 GMT
Received: from localhost.uk.oracle.com (/10.175.204.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 14:44:42 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 1/2] bpf: use dedicated bpf_trace_printk event instead of trace_printk()
Date:   Fri,  3 Jul 2020 15:44:27 +0100
Message-Id: <1593787468-29931-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593787468-29931-1-git-send-email-alan.maguire@oracle.com>
References: <1593787468-29931-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf helper bpf_trace_printk() uses trace_printk() under the hood.
This leads to an alarming warning message originating from trace
buffer allocation which occurs the first time a program using
bpf_trace_printk() is loaded.

We can instead create a trace event for bpf_trace_printk() and enable
it in-kernel when/if we encounter a program using the
bpf_trace_printk() helper.  With this approach, trace_printk()
is not used directly and no warning message appears.

This work was started by Steven (see Link) and finished by Alan; added
Steven's Signed-off-by with his permission.

Link: https://lore.kernel.org/r/20200628194334.6238b933@oasis.local.home
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 kernel/trace/Makefile    |  2 ++
 kernel/trace/bpf_trace.c | 41 +++++++++++++++++++++++++++++++++++++----
 kernel/trace/bpf_trace.h | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 4 deletions(-)
 create mode 100644 kernel/trace/bpf_trace.h

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 6575bb0..aeba5ee 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -31,6 +31,8 @@ ifdef CONFIG_GCOV_PROFILE_FTRACE
 GCOV_PROFILE := y
 endif
 
+CFLAGS_bpf_trace.o := -I$(src)
+
 CFLAGS_trace_benchmark.o := -I$(src)
 CFLAGS_trace_events_filter.o := -I$(src)
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 1d874d8..cdbafc4 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2,6 +2,10 @@
 /* Copyright (c) 2011-2015 PLUMgrid, http://plumgrid.com
  * Copyright (c) 2016 Facebook
  */
+#define CREATE_TRACE_POINTS
+
+#include "bpf_trace.h"
+
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/slab.h>
@@ -11,6 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/ctype.h>
 #include <linux/kprobes.h>
+#include <linux/spinlock.h>
 #include <linux/syscalls.h>
 #include <linux/error-injection.h>
 
@@ -374,6 +379,28 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
 	}
 }
 
+static DEFINE_SPINLOCK(trace_printk_lock);
+
+#define BPF_TRACE_PRINTK_SIZE   1024
+
+static inline int bpf_do_trace_printk(const char *fmt, ...)
+{
+	static char buf[BPF_TRACE_PRINTK_SIZE];
+	unsigned long flags;
+	va_list ap;
+	int ret;
+
+	spin_lock_irqsave(&trace_printk_lock, flags);
+	va_start(ap, fmt);
+	ret = vsnprintf(buf, BPF_TRACE_PRINTK_SIZE, fmt, ap);
+	va_end(ap);
+	if (ret > 0)
+		trace_bpf_trace_printk(buf);
+	spin_unlock_irqrestore(&trace_printk_lock, flags);
+
+	return ret;
+}
+
 /*
  * Only limited trace_printk() conversion specifiers allowed:
  * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pB %pks %pus %s
@@ -483,8 +510,7 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
  */
 #define __BPF_TP_EMIT()	__BPF_ARG3_TP()
 #define __BPF_TP(...)							\
-	__trace_printk(0 /* Fake ip */,					\
-		       fmt, ##__VA_ARGS__)
+	bpf_do_trace_printk(fmt, ##__VA_ARGS__)
 
 #define __BPF_ARG1_TP(...)						\
 	((mod[0] == 2 || (mod[0] == 1 && __BITS_PER_LONG == 64))	\
@@ -518,13 +544,20 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
 	.arg2_type	= ARG_CONST_SIZE,
 };
 
+int bpf_trace_printk_enabled;
+
 const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
 {
 	/*
 	 * this program might be calling bpf_trace_printk,
-	 * so allocate per-cpu printk buffers
+	 * so enable the associated bpf_trace/bpf_trace_printk event.
 	 */
-	trace_printk_init_buffers();
+	if (!bpf_trace_printk_enabled) {
+		if (trace_set_clr_event("bpf_trace", "bpf_trace_printk", 1))
+			pr_warn_ratelimited("could not enable bpf_trace_printk events");
+		else
+			bpf_trace_printk_enabled = 1;
+	}
 
 	return &bpf_trace_printk_proto;
 }
diff --git a/kernel/trace/bpf_trace.h b/kernel/trace/bpf_trace.h
new file mode 100644
index 0000000..9acbc11
--- /dev/null
+++ b/kernel/trace/bpf_trace.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM bpf_trace
+
+#if !defined(_TRACE_BPF_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+
+#define _TRACE_BPF_TRACE_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(bpf_trace_printk,
+
+	TP_PROTO(const char *bpf_string),
+
+	TP_ARGS(bpf_string),
+
+	TP_STRUCT__entry(
+		__string(bpf_string, bpf_string)
+	),
+
+	TP_fast_assign(
+		__assign_str(bpf_string, bpf_string);
+	),
+
+	TP_printk("%s", __get_str(bpf_string))
+);
+
+#endif /* _TRACE_BPF_TRACE_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE bpf_trace
+
+#include <trace/define_trace.h>
-- 
1.8.3.1

