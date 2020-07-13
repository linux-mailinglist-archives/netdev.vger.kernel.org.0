Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC3321D55D
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbgGMLzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:55:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59358 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729613AbgGMLzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:55:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DBq27C030635;
        Mon, 13 Jul 2020 11:54:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=q9XY0O9VNOoVVMsxnoaHwNhhpztYHwFwPYqqNlIdYC4=;
 b=Teqn0wLq3Oa48MyWdCNgFk8lvHsNg1uMBBCvb9Yc7vD2yYcATgLjQLFIVJChyyyajtao
 zNS7GfaQJEISkXMEHQD+AYsKjOBRq9vprn7ihrgIyTxRmehACrFH2C6wmgZAxuzPPTtb
 pV6ZKsAyosyVghw3f5o5LR0qeqwTyEyx/knItHTeUIskDwDKHn5qPVcKdDX3WlgFLNAs
 22dykDKADsFNxEAMmAOHPKyMpX4fVniAgjjPAp5mlOhjCZUKFBsdwBMN3py/9AJEYv2/
 MujJv4/Sp6WDMFgHVi89Fzcg5n58ycwNkeKpMtC8knKAZFKW+qNyM1Os4NuT1w/ZbnPa iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3274uqxk8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 11:54:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DBhgwU104109;
        Mon, 13 Jul 2020 11:52:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 327qb0epev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 11:52:51 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06DBqoYM020293;
        Mon, 13 Jul 2020 11:52:50 GMT
Received: from localhost.uk.oracle.com (/10.175.215.251)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 04:52:50 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v3 bpf-next 1/2] bpf: use dedicated bpf_trace_printk event instead of trace_printk()
Date:   Mon, 13 Jul 2020 12:52:33 +0100
Message-Id: <1594641154-18897-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594641154-18897-1-git-send-email-alan.maguire@oracle.com>
References: <1594641154-18897-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9680 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9680 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130089
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
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/trace/Makefile    |  2 ++
 kernel/trace/bpf_trace.c | 42 +++++++++++++++++++++++++++++++++++++-----
 kernel/trace/bpf_trace.h | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 5 deletions(-)
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
index e0b7775..0a2716d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -11,6 +11,7 @@
 #include <linux/uaccess.h>
 #include <linux/ctype.h>
 #include <linux/kprobes.h>
+#include <linux/spinlock.h>
 #include <linux/syscalls.h>
 #include <linux/error-injection.h>
 
@@ -19,6 +20,9 @@
 #include "trace_probe.h"
 #include "trace.h"
 
+#define CREATE_TRACE_POINTS
+#include "bpf_trace.h"
+
 #define bpf_event_rcu_dereference(p)					\
 	rcu_dereference_protected(p, lockdep_is_held(&bpf_event_mutex))
 
@@ -374,6 +378,30 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
 	}
 }
 
+static DEFINE_RAW_SPINLOCK(trace_printk_lock);
+
+#define BPF_TRACE_PRINTK_SIZE   1024
+
+static inline __printf(1, 0) int bpf_do_trace_printk(const char *fmt, ...)
+{
+	static char buf[BPF_TRACE_PRINTK_SIZE];
+	unsigned long flags;
+	va_list ap;
+	int ret;
+
+	raw_spin_lock_irqsave(&trace_printk_lock, flags);
+	va_start(ap, fmt);
+	ret = vsnprintf(buf, sizeof(buf), fmt, ap);
+	va_end(ap);
+	/* vsnprintf() will not append null for zero-length strings */
+	if (ret == 0)
+		buf[0] = '\0';
+	trace_bpf_trace_printk(buf);
+	raw_spin_unlock_irqrestore(&trace_printk_lock, flags);
+
+	return ret;
+}
+
 /*
  * Only limited trace_printk() conversion specifiers allowed:
  * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pB %pks %pus %s
@@ -483,8 +511,7 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
  */
 #define __BPF_TP_EMIT()	__BPF_ARG3_TP()
 #define __BPF_TP(...)							\
-	__trace_printk(0 /* Fake ip */,					\
-		       fmt, ##__VA_ARGS__)
+	bpf_do_trace_printk(fmt, ##__VA_ARGS__)
 
 #define __BPF_ARG1_TP(...)						\
 	((mod[0] == 2 || (mod[0] == 1 && __BITS_PER_LONG == 64))	\
@@ -521,10 +548,15 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
 const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
 {
 	/*
-	 * this program might be calling bpf_trace_printk,
-	 * so allocate per-cpu printk buffers
+	 * This program might be calling bpf_trace_printk,
+	 * so enable the associated bpf_trace/bpf_trace_printk event.
+	 * Repeat this each time as it is possible a user has
+	 * disabled bpf_trace_printk events.  By loading a program
+	 * calling bpf_trace_printk() however the user has expressed
+	 * the intent to see such events.
 	 */
-	trace_printk_init_buffers();
+	if (trace_set_clr_event("bpf_trace", "bpf_trace_printk", 1))
+		pr_warn_ratelimited("could not enable bpf_trace_printk events");
 
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

