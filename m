Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A7F1255C
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 02:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfECAIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 20:08:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55934 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726126AbfECAIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 20:08:55 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x43058tG004192
        for <netdev@vger.kernel.org>; Thu, 2 May 2019 17:08:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=NrH2fyOUeMJOLvQtnDP9Rj93j2gLNZGt79SBsRxuTiI=;
 b=LzkIrT5WwttjblUQGvcL/ALHB/9RdcrQAU0MGQKJyDOwfwE1p13MSTS3Zi4wn6DFIq6G
 Yf9ROLMIyDOl5UL5rOV1iR5Wz4wX3n5MZwusNJQS2I4vQEORLzO4scgYGYqxHratZzIM
 2+NPg5ZGFTOquI2H0rloZ0KuEykTUFuwAEk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2s84aqsase-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 17:08:53 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 2 May 2019 17:08:08 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 005643702ACB; Thu,  2 May 2019 17:08:06 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 1/3] bpf: implement bpf_send_signal() helper
Date:   Thu, 2 May 2019 17:08:06 -0700
Message-ID: <20190503000806.1340997-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190503000806.1340927-1-yhs@fb.com>
References: <20190503000806.1340927-1-yhs@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-02_13:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch tries to solve the following specific use case.

Currently, bpf program can already collect stack traces
when certain events happens (e.g., cache miss counter or
cpu clock counter overflows). These stack traces can be
used for performance analysis. For jitted programs, e.g.,
hhvm (jited php), it is very hard to get the true stack
trace in the bpf program due to jit complexity.

To resolve this issue, hhvm implements a signal handler,
e.g. for SIGALARM, and a set of program locations which
it can dump stack traces. When it receives a signal, it will
dump the stack in next such program location.

The following is the current way to handle this use case:
  . profiler installs a bpf program and polls on a map.
    When certain event happens, bpf program writes to a map.
  . Once receiving the information from the map, the profiler
    sends a signal to hhvm.
This method could have large delays and causing profiling
results skewed.

This patch implements bpf_send_signal() helper to send a signal to
hhvm in real time, resulting in intended stack traces.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/uapi/linux/bpf.h | 15 ++++++-
 kernel/trace/bpf_trace.c | 85 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+), 1 deletion(-)

v1 -> v2:
 fixed a compilation warning (missing return value in case)
 reported by kbuild test robot.
 added Reported-by in the above to notify the bot.

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 72336bac7573..e3e824848335 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2667,6 +2667,18 @@ union bpf_attr {
  *		0 on success.
  *
  *		**-ENOENT** if the bpf-local-storage cannot be found.
+ *
+ * int bpf_send_signal(u32 pid, u32 sig)
+ *	Description
+ *		Send signal *sig* to *pid*.
+ *	Return
+ *		0 on success or successfully queued.
+ *
+ *		**-ENOENT** if *pid* cannot be found.
+ *
+ *		**-EBUSY** if work queue under nmi is full.
+ *
+ * 		Other negative values for actual signal sending errors.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2777,7 +2789,8 @@ union bpf_attr {
 	FN(strtol),			\
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
-	FN(sk_storage_delete),
+	FN(sk_storage_delete),		\
+	FN(send_signal),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 8607aba1d882..49a804d59bfb 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -559,6 +559,76 @@ static const struct bpf_func_proto bpf_probe_read_str_proto = {
 	.arg3_type	= ARG_ANYTHING,
 };
 
+struct send_signal_irq_work {
+	struct irq_work irq_work;
+	u32 pid;
+	u32 sig;
+};
+
+static DEFINE_PER_CPU(struct send_signal_irq_work, send_signal_work);
+
+static int do_bpf_send_signal_pid(u32 pid, u32 sig)
+{
+	struct task_struct *task;
+	struct pid *pidp;
+
+	pidp = find_vpid(pid);
+	if (!pidp)
+		return -ENOENT;
+
+	task = get_pid_task(pidp, PIDTYPE_PID);
+	if (!task)
+		return -ENOENT;
+
+	kill_pid_info(sig, SEND_SIG_PRIV, pidp);
+	put_task_struct(task);
+
+	return 0;
+}
+
+static void do_bpf_send_signal(struct irq_work *entry)
+{
+	struct send_signal_irq_work *work;
+
+	work = container_of(entry, struct send_signal_irq_work, irq_work);
+	do_bpf_send_signal_pid(work->pid, work->sig);
+}
+
+BPF_CALL_2(bpf_send_signal, u32, pid, u32, sig)
+{
+	struct send_signal_irq_work *work = NULL;
+
+	/* current may be in the middle of teardown and task_pid(current)
+	 * becomes NULL. task_pid(current)) is needed to find pid namespace
+	 * in order to locate proper pid structure for the target pid.
+	 */
+	if (!task_pid(current))
+		return -ENOENT;
+
+	if (in_nmi()) {
+		work = this_cpu_ptr(&send_signal_work);
+		if (work->irq_work.flags & IRQ_WORK_BUSY)
+			return -EBUSY;
+	}
+
+	if (!work)
+		return do_bpf_send_signal_pid(pid, sig);
+
+	work->pid = pid;
+	work->sig = sig;
+	irq_work_queue(&work->irq_work);
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_send_signal_proto = {
+	.func		= bpf_send_signal,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING,
+};
+
 static const struct bpf_func_proto *
 tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -609,6 +679,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_get_current_cgroup_id:
 		return &bpf_get_current_cgroup_id_proto;
 #endif
+	case BPF_FUNC_send_signal:
+		return &bpf_send_signal_proto;
 	default:
 		return NULL;
 	}
@@ -1334,5 +1406,18 @@ int __init bpf_event_init(void)
 	return 0;
 }
 
+static int __init send_signal_irq_work_init(void)
+{
+	int cpu;
+	struct send_signal_irq_work *work;
+
+	for_each_possible_cpu(cpu) {
+		work = per_cpu_ptr(&send_signal_work, cpu);
+		init_irq_work(&work->irq_work, do_bpf_send_signal);
+	}
+	return 0;
+}
+
 fs_initcall(bpf_event_init);
+subsys_initcall(send_signal_irq_work_init);
 #endif /* CONFIG_MODULES */
-- 
2.17.1

