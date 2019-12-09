Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 816BC11643F
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 01:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfLIABV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 8 Dec 2019 19:01:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46012 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbfLIABU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 19:01:20 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB8NwIvu018008
        for <netdev@vger.kernel.org>; Sun, 8 Dec 2019 16:01:19 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wrbrh5yeh-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 08 Dec 2019 16:01:19 -0800
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 8 Dec 2019 16:01:17 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 88C7B760CCB; Sun,  8 Dec 2019 16:01:16 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <rostedt@goodmis.org>, <x86@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 1/3] ftrace: Fix function_graph tracer interaction with BPF trampoline
Date:   Sun, 8 Dec 2019 16:01:12 -0800
Message-ID: <20191209000114.1876138-2-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191209000114.1876138-1-ast@kernel.org>
References: <20191209000114.1876138-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-08_07:2019-12-05,2019-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=1 spamscore=0
 malwarescore=0 phishscore=0 impostorscore=0 clxscore=1015 mlxlogscore=546
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912080207
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depending on type of BPF programs served by BPF trampoline it can call original
function. In such case the trampoline will skip one stack frame while
returning. That will confuse function_graph tracer and will cause crashes with
bad RIP. Teach graph tracer to skip functions that have BPF trampoline attached.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 arch/x86/kernel/ftrace.c | 14 --------------
 include/linux/ftrace.h   |  5 +++++
 kernel/trace/fgraph.c    |  9 +++++++++
 kernel/trace/ftrace.c    | 19 +++++++------------
 4 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 060a361d9d11..024c3053dbba 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -1042,20 +1042,6 @@ void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
-	/*
-	 * If the return location is actually pointing directly to
-	 * the start of a direct trampoline (if we trace the trampoline
-	 * it will still be offset by MCOUNT_INSN_SIZE), then the
-	 * return address is actually off by one word, and we
-	 * need to adjust for that.
-	 */
-	if (ftrace_direct_func_count) {
-		if (ftrace_find_direct_func(self_addr + MCOUNT_INSN_SIZE)) {
-			self_addr = *parent;
-			parent++;
-		}
-	}
-
 	/*
 	 * Protect against fault, even if it shouldn't
 	 * happen. This tool is too much intrusive to
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 7247d35c3d16..db95244a62d4 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -264,6 +264,7 @@ int ftrace_modify_direct_caller(struct ftrace_func_entry *entry,
 				struct dyn_ftrace *rec,
 				unsigned long old_addr,
 				unsigned long new_addr);
+unsigned long ftrace_find_rec_direct(unsigned long ip);
 #else
 # define ftrace_direct_func_count 0
 static inline int register_ftrace_direct(unsigned long ip, unsigned long addr)
@@ -290,6 +291,10 @@ static inline int ftrace_modify_direct_caller(struct ftrace_func_entry *entry,
 {
 	return -ENODEV;
 }
+static inline unsigned long ftrace_find_rec_direct(unsigned long ip)
+{
+	return 0;
+}
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
 
 #ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
index 67e0c462b059..a2659735db73 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -101,6 +101,15 @@ int function_graph_enter(unsigned long ret, unsigned long func,
 {
 	struct ftrace_graph_ent trace;
 
+	/*
+	 * Skip graph tracing if the return location is served by direct trampoline,
+	 * since call sequence and return addresses is unpredicatable anymore.
+	 * Ex: BPF trampoline may call original function and may skip frame
+	 * depending on type of BPF programs attached.
+	 */
+	if (ftrace_direct_func_count &&
+	    ftrace_find_rec_direct(ret - MCOUNT_INSN_SIZE))
+		return -EBUSY;
 	trace.func = func;
 	trace.depth = ++current->curr_ret_depth;
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 74439ab5c2b6..ac99a3500076 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2364,7 +2364,7 @@ int ftrace_direct_func_count;
  * Search the direct_functions hash to see if the given instruction pointer
  * has a direct caller attached to it.
  */
-static unsigned long find_rec_direct(unsigned long ip)
+unsigned long ftrace_find_rec_direct(unsigned long ip)
 {
 	struct ftrace_func_entry *entry;
 
@@ -2380,7 +2380,7 @@ static void call_direct_funcs(unsigned long ip, unsigned long pip,
 {
 	unsigned long addr;
 
-	addr = find_rec_direct(ip);
+	addr = ftrace_find_rec_direct(ip);
 	if (!addr)
 		return;
 
@@ -2393,11 +2393,6 @@ struct ftrace_ops direct_ops = {
 			  | FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_REGS
 			  | FTRACE_OPS_FL_PERMANENT,
 };
-#else
-static inline unsigned long find_rec_direct(unsigned long ip)
-{
-	return 0;
-}
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
 
 /**
@@ -2417,7 +2412,7 @@ unsigned long ftrace_get_addr_new(struct dyn_ftrace *rec)
 
 	if ((rec->flags & FTRACE_FL_DIRECT) &&
 	    (ftrace_rec_count(rec) == 1)) {
-		addr = find_rec_direct(rec->ip);
+		addr = ftrace_find_rec_direct(rec->ip);
 		if (addr)
 			return addr;
 		WARN_ON_ONCE(1);
@@ -2458,7 +2453,7 @@ unsigned long ftrace_get_addr_curr(struct dyn_ftrace *rec)
 
 	/* Direct calls take precedence over trampolines */
 	if (rec->flags & FTRACE_FL_DIRECT_EN) {
-		addr = find_rec_direct(rec->ip);
+		addr = ftrace_find_rec_direct(rec->ip);
 		if (addr)
 			return addr;
 		WARN_ON_ONCE(1);
@@ -3604,7 +3599,7 @@ static int t_show(struct seq_file *m, void *v)
 		if (rec->flags & FTRACE_FL_DIRECT) {
 			unsigned long direct;
 
-			direct = find_rec_direct(rec->ip);
+			direct = ftrace_find_rec_direct(rec->ip);
 			if (direct)
 				seq_printf(m, "\n\tdirect-->%pS", (void *)direct);
 		}
@@ -5008,7 +5003,7 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
 	mutex_lock(&direct_mutex);
 
 	/* See if there's a direct function at @ip already */
-	if (find_rec_direct(ip))
+	if (ftrace_find_rec_direct(ip))
 		goto out_unlock;
 
 	ret = -ENODEV;
@@ -5027,7 +5022,7 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
 	if (ip != rec->ip) {
 		ip = rec->ip;
 		/* Need to check this ip for a direct. */
-		if (find_rec_direct(ip))
+		if (ftrace_find_rec_direct(ip))
 			goto out_unlock;
 	}
 
-- 
2.23.0

