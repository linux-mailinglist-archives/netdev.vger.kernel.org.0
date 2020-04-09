Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA9D1A3AA4
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 21:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgDITgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 15:36:17 -0400
Received: from mail.efficios.com ([167.114.26.124]:47154 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgDITgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 15:36:00 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 7E427280DF6;
        Thu,  9 Apr 2020 15:35:59 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id oSUiqoosXzqf; Thu,  9 Apr 2020 15:35:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id CBD6628097C;
        Thu,  9 Apr 2020 15:35:58 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com CBD6628097C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1586460958;
        bh=JJbEnSZlH0Z9aiz9kDpqohqZyqDrYygmMxJ1DfOirdE=;
        h=From:To:Date:Message-Id;
        b=pk+C+CXWM6T13Lu8JpfhgTZ2/uQJ1ODQqPNghvfwd8cgfNu1GpjzwScEcsnnlJUgd
         PlYAlMxdL+dOXutnV9eOGDoyHM7vePm458oy8fO/I/axcXuQglUgqvwb+lwAGN2RX/
         AyOacGceUBfnpc5vX2bKZkXmYuBQUK+nNWrAQSgTbs3v0yvtM7JlELm4QbD5dj8Nig
         xwOXHJOC7VJ3gJ1ytPkW7L0w4xAhCbBtM3AmlmGAgBEB9NvzNhQ7oipEdPffg98Ge3
         MGvGIdwo73aRaXOF+29+xnn3ZrrqjcgL0d31+HGNYo9U0etIlKE2nmqwBZDCOfjth9
         xiZBXl6IHYjUA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4f2umtxwPemD; Thu,  9 Apr 2020 15:35:58 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id CE5B3280F54;
        Thu,  9 Apr 2020 15:35:57 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "K . Prasad" <prasad@linux.vnet.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, rostedt@goodmis.org,
        Alexei Starovoitov <ast@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC PATCH 2/9] bpf: allow up to 13 arguments for tracepoints
Date:   Thu,  9 Apr 2020 15:35:36 -0400
Message-Id: <20200409193543.18115-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200409193543.18115-1-mathieu.desnoyers@efficios.com>
References: <20200409193543.18115-1-mathieu.desnoyers@efficios.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding an argument to the writeback balance_dirty_pages event requires
to bump the bpf argument count limit from 12 to 13.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 include/linux/kernel.h       | 6 +++---
 include/linux/trace_events.h | 3 +++
 include/trace/bpf_probe.h    | 3 ++-
 kernel/trace/bpf_trace.c     | 8 +++++---
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 9b7a8d74a9d6..20203f762410 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -975,9 +975,9 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 #define swap(a, b) \
 	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
-/* This counts to 12. Any more, it will return 13th argument. */
-#define __COUNT_ARGS(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _n, X...) _n
-#define COUNT_ARGS(X...) __COUNT_ARGS(, ##X, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
+/* This counts to 13. Any more, it will return 14th argument. */
+#define __COUNT_ARGS(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _n, X...) _n
+#define COUNT_ARGS(X...) __COUNT_ARGS(, ##X, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
 
 #define __CONCAT(a, b) a ## b
 #define CONCATENATE(a, b) __CONCAT(a, b)
diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 5c6943354049..1e3f4782d32f 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -776,6 +776,9 @@ void bpf_trace_run11(struct bpf_prog *prog, u64 arg1, u64 arg2,
 void bpf_trace_run12(struct bpf_prog *prog, u64 arg1, u64 arg2,
 		     u64 arg3, u64 arg4, u64 arg5, u64 arg6, u64 arg7,
 		     u64 arg8, u64 arg9, u64 arg10, u64 arg11, u64 arg12);
+void bpf_trace_run13(struct bpf_prog *prog, u64 arg1, u64 arg2,
+		     u64 arg3, u64 arg4, u64 arg5, u64 arg6, u64 arg7,
+		     u64 arg8, u64 arg9, u64 arg10, u64 arg11, u64 arg12, u64 arg13);
 void perf_trace_run_bpf_submit(void *raw_data, int size, int rctx,
 			       struct trace_event_call *call, u64 count,
 			       struct pt_regs *regs, struct hlist_head *head,
diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
index 1ce3be63add1..1ca87b7a8230 100644
--- a/include/trace/bpf_probe.h
+++ b/include/trace/bpf_probe.h
@@ -52,7 +52,8 @@
 #define __CAST10(a,...) __CAST_TO_U64(a), __CAST9(__VA_ARGS__)
 #define __CAST11(a,...) __CAST_TO_U64(a), __CAST10(__VA_ARGS__)
 #define __CAST12(a,...) __CAST_TO_U64(a), __CAST11(__VA_ARGS__)
-/* tracepoints with more than 12 arguments will hit build error */
+#define __CAST13(a,...) __CAST_TO_U64(a), __CAST12(__VA_ARGS__)
+/* tracepoints with more than 13 arguments will hit build error */
 #define CAST_TO_U64(...) CONCATENATE(__CAST, COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__)
 
 #undef DECLARE_EVENT_CLASS
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ca1796747a77..67354218b97f 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1546,6 +1546,7 @@ void __bpf_trace_run(struct bpf_prog *prog, u64 *args)
 #define REPEAT_10(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_9(FN, DL, __VA_ARGS__)
 #define REPEAT_11(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_10(FN, DL, __VA_ARGS__)
 #define REPEAT_12(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_11(FN, DL, __VA_ARGS__)
+#define REPEAT_13(FN, DL, X, ...)	FN(X) UNPACK DL REPEAT_12(FN, DL, __VA_ARGS__)
 #define REPEAT(X, FN, DL, ...)		REPEAT_##X(FN, DL, __VA_ARGS__)
 
 #define SARG(X)		u64 arg##X
@@ -1554,14 +1555,14 @@ void __bpf_trace_run(struct bpf_prog *prog, u64 *args)
 #define __DL_COM	(,)
 #define __DL_SEM	(;)
 
-#define __SEQ_0_11	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
+#define __SEQ_0_12	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
 
 #define BPF_TRACE_DEFN_x(x)						\
 	void bpf_trace_run##x(struct bpf_prog *prog,			\
-			      REPEAT(x, SARG, __DL_COM, __SEQ_0_11))	\
+			      REPEAT(x, SARG, __DL_COM, __SEQ_0_12))	\
 	{								\
 		u64 args[x];						\
-		REPEAT(x, COPY, __DL_SEM, __SEQ_0_11);			\
+		REPEAT(x, COPY, __DL_SEM, __SEQ_0_12);			\
 		__bpf_trace_run(prog, args);				\
 	}								\
 	EXPORT_SYMBOL_GPL(bpf_trace_run##x)
@@ -1577,6 +1578,7 @@ BPF_TRACE_DEFN_x(9);
 BPF_TRACE_DEFN_x(10);
 BPF_TRACE_DEFN_x(11);
 BPF_TRACE_DEFN_x(12);
+BPF_TRACE_DEFN_x(13);
 
 static int __bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_prog *prog)
 {
-- 
2.17.1

