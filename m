Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D34AAC2D8
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 01:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405281AbfIFXLF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 Sep 2019 19:11:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7942 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405257AbfIFXLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 19:11:05 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x86NA5N5012596
        for <netdev@vger.kernel.org>; Fri, 6 Sep 2019 16:11:04 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uuvef9a4v-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 16:11:03 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 6 Sep 2019 16:11:02 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 7CE23760B80; Fri,  6 Sep 2019 16:11:00 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <peterz@infradead.org>,
        <luto@amacapital.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-api@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 3/4] perf: implement CAP_TRACING
Date:   Fri, 6 Sep 2019 16:10:52 -0700
Message-ID: <20190906231053.1276792-4-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190906231053.1276792-1-ast@kernel.org>
References: <20190906231053.1276792-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-06_11:2019-09-04,2019-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0 clxscore=1034
 priorityscore=1501 spamscore=0 suspectscore=1 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909060226
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement permissions as stated in uapi/linux/capability.h
and update Documentation.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 Documentation/admin-guide/perf-security.rst |  4 ++--
 Documentation/admin-guide/sysctl/kernel.rst | 10 ++++------
 arch/powerpc/perf/core-book3s.c             |  4 ++--
 arch/x86/events/intel/bts.c                 |  2 +-
 arch/x86/events/intel/core.c                |  2 +-
 arch/x86/events/intel/p4.c                  |  2 +-
 kernel/events/core.c                        | 14 +++++++-------
 kernel/events/hw_breakpoint.c               |  2 +-
 kernel/trace/trace_event_perf.c             |  4 ++--
 9 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/Documentation/admin-guide/perf-security.rst b/Documentation/admin-guide/perf-security.rst
index 72effa7c23b9..c84152d1dfd4 100644
--- a/Documentation/admin-guide/perf-security.rst
+++ b/Documentation/admin-guide/perf-security.rst
@@ -66,8 +66,8 @@ into distinct units, known as capabilities [6]_ , which can be
 independently enabled and disabled on per-thread basis for processes and
 files of unprivileged users.
 
-Unprivileged processes with enabled CAP_SYS_ADMIN capability are treated
-as privileged processes with respect to perf_events performance
+Unprivileged processes with enabled CAP_SYS_ADMIN or CAP_TRACING capability
+are treated as privileged processes with respect to perf_events performance
 monitoring and bypass *scope* permissions checks in the kernel.
 
 Unprivileged processes using perf_events system call API is also subject
diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 032c7cd3cede..595bf2b1363f 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -720,20 +720,18 @@ allowed to execute.
 ====================
 
 Controls use of the performance events system by unprivileged
-users (without CAP_SYS_ADMIN).  The default value is 2.
+users (without CAP_SYS_ADMIN and without CAP_TRACING).  The default value is 2.
 
 ===  ==================================================================
  -1  Allow use of (almost) all events by all users
 
      Ignore mlock limit after perf_event_mlock_kb without CAP_IPC_LOCK
 
->=0  Disallow ftrace function tracepoint by users without CAP_SYS_ADMIN
+>=0  Disallow ftrace function tracepoint and raw tracepoint
 
-     Disallow raw tracepoint access by users without CAP_SYS_ADMIN
+>=1  Disallow CPU event access
 
->=1  Disallow CPU event access by users without CAP_SYS_ADMIN
-
->=2  Disallow kernel profiling by users without CAP_SYS_ADMIN
+>=2  Disallow kernel profiling
 ===  ==================================================================
 
 
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index ca92e01d0bd1..a204a3c6c68b 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -204,7 +204,7 @@ static inline void perf_get_data_addr(struct pt_regs *regs, u64 *addrp)
 	if (!(mmcra & MMCRA_SAMPLE_ENABLE) || sdar_valid)
 		*addrp = mfspr(SPRN_SDAR);
 
-	if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN) &&
+	if (perf_paranoid_kernel() && !capable_tracing() &&
 		is_kernel_addr(mfspr(SPRN_SDAR)))
 		*addrp = 0;
 }
@@ -472,7 +472,7 @@ static void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
 			 * exporting it to userspace (avoid exposure of regions
 			 * where we could have speculative execution)
 			 */
-			if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN) &&
+			if (perf_paranoid_kernel() && !capable_tracing() &&
 				is_kernel_addr(addr))
 				continue;
 
diff --git a/arch/x86/events/intel/bts.c b/arch/x86/events/intel/bts.c
index 5ee3fed881d3..bd713b2dd7c2 100644
--- a/arch/x86/events/intel/bts.c
+++ b/arch/x86/events/intel/bts.c
@@ -550,7 +550,7 @@ static int bts_event_init(struct perf_event *event)
 	 * users to profile the kernel.
 	 */
 	if (event->attr.exclude_kernel && perf_paranoid_kernel() &&
-	    !capable(CAP_SYS_ADMIN))
+	    !capable_tracing())
 		return -EACCES;
 
 	if (x86_add_exclusive(x86_lbr_exclusive_bts))
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index e4c2cb65ea50..a7f8c18bd82b 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3307,7 +3307,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (x86_pmu.version < 3)
 		return -EINVAL;
 
-	if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+	if (perf_paranoid_cpu() && !capable_tracing())
 		return -EACCES;
 
 	event->hw.config |= ARCH_PERFMON_EVENTSEL_ANY;
diff --git a/arch/x86/events/intel/p4.c b/arch/x86/events/intel/p4.c
index dee579efb2b2..f379a358c9cb 100644
--- a/arch/x86/events/intel/p4.c
+++ b/arch/x86/events/intel/p4.c
@@ -776,7 +776,7 @@ static int p4_validate_raw_event(struct perf_event *event)
 	 * the user needs special permissions to be able to use it
 	 */
 	if (p4_ht_active() && p4_event_bind_map[v].shared) {
-		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+		if (perf_paranoid_cpu() && !capable_tracing())
 			return -EACCES;
 	}
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0463c1151bae..eaba102e5d91 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4134,7 +4134,7 @@ find_get_context(struct pmu *pmu, struct task_struct *task,
 
 	if (!task) {
 		/* Must be root to operate on a CPU event: */
-		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+		if (perf_paranoid_cpu() && !capable_tracing())
 			return ERR_PTR(-EACCES);
 
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
@@ -8741,7 +8741,7 @@ static int perf_kprobe_event_init(struct perf_event *event)
 	if (event->attr.type != perf_kprobe.type)
 		return -ENOENT;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_tracing())
 		return -EACCES;
 
 	/*
@@ -8801,7 +8801,7 @@ static int perf_uprobe_event_init(struct perf_event *event)
 	if (event->attr.type != perf_uprobe.type)
 		return -ENOENT;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_tracing())
 		return -EACCES;
 
 	/*
@@ -10588,7 +10588,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 		}
 		/* privileged levels capture (kernel, hv): check permissions */
 		if ((mask & PERF_SAMPLE_BRANCH_PERM_PLM)
-		    && perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+		    && perf_paranoid_kernel() && !capable_tracing())
 			return -EACCES;
 	}
 
@@ -10807,12 +10807,12 @@ SYSCALL_DEFINE5(perf_event_open,
 		return err;
 
 	if (!attr.exclude_kernel) {
-		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+		if (perf_paranoid_kernel() && !capable_tracing())
 			return -EACCES;
 	}
 
 	if (attr.namespaces) {
-		if (!capable(CAP_SYS_ADMIN))
+		if (!capable_tracing())
 			return -EACCES;
 	}
 
@@ -10826,7 +10826,7 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	/* Only privileged users can get physical addresses */
 	if ((attr.sample_type & PERF_SAMPLE_PHYS_ADDR) &&
-	    perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+	    perf_paranoid_kernel() && !capable_tracing())
 		return -EACCES;
 
 	/*
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index c5cd852fe86b..8bc4d7d8c913 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -404,7 +404,7 @@ static int hw_breakpoint_parse(struct perf_event *bp,
 		 * Don't let unprivileged users set a breakpoint in the trap
 		 * path to avoid trap recursion attacks.
 		 */
-		if (!capable(CAP_SYS_ADMIN))
+		if (!capable_tracing())
 			return -EPERM;
 	}
 
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 0892e38ed6fb..6861307f14d6 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -46,7 +46,7 @@ static int perf_trace_event_perm(struct trace_event_call *tp_event,
 
 	/* The ftrace function trace is allowed only for root. */
 	if (ftrace_event_is_function(tp_event)) {
-		if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
+		if (perf_paranoid_tracepoint_raw() && !capable_tracing())
 			return -EPERM;
 
 		if (!is_sampling_event(p_event))
@@ -82,7 +82,7 @@ static int perf_trace_event_perm(struct trace_event_call *tp_event,
 	 * ...otherwise raw tracepoint data can be a severe data leak,
 	 * only allow root to have these.
 	 */
-	if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
+	if (perf_paranoid_tracepoint_raw() && !capable_tracing())
 		return -EPERM;
 
 	return 0;
-- 
2.20.0

