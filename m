Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C28A10B2
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 07:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfH2FNC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Aug 2019 01:13:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10446 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbfH2FNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 01:13:01 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7T59A21012181
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 22:12:59 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2unvfyk3d7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 22:12:58 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 22:12:58 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id ACE33760F54; Wed, 28 Aug 2019 22:12:57 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <luto@amacapital.net>
CC:     <davem@davemloft.net>, <peterz@infradead.org>,
        <rostedt@goodmis.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-api@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/3] perf: implement CAP_TRACING
Date:   Wed, 28 Aug 2019 22:12:53 -0700
Message-ID: <20190829051253.1927291-3-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190829051253.1927291-1-ast@kernel.org>
References: <20190829051253.1927291-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_03:2019-08-28,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 impostorscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908290056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement permissions as stated in uapi/linux/capability.h

Similar to CAP_BPF it's highly unlikely that s/CAP_SYS_ADMIN/CAP_TRACING/
replacement will cause user breakage.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 arch/powerpc/perf/core-book3s.c |  4 ++--
 arch/x86/events/intel/bts.c     |  2 +-
 arch/x86/events/intel/core.c    |  2 +-
 arch/x86/events/intel/p4.c      |  2 +-
 kernel/events/core.c            | 14 +++++++-------
 kernel/events/hw_breakpoint.c   |  2 +-
 kernel/trace/trace_event_perf.c |  4 ++--
 7 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index ca92e01d0bd1..ddb5f4b81023 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -204,7 +204,7 @@ static inline void perf_get_data_addr(struct pt_regs *regs, u64 *addrp)
 	if (!(mmcra & MMCRA_SAMPLE_ENABLE) || sdar_valid)
 		*addrp = mfspr(SPRN_SDAR);
 
-	if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN) &&
+	if (perf_paranoid_kernel() && !capable(CAP_TRACING) &&
 		is_kernel_addr(mfspr(SPRN_SDAR)))
 		*addrp = 0;
 }
@@ -472,7 +472,7 @@ static void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
 			 * exporting it to userspace (avoid exposure of regions
 			 * where we could have speculative execution)
 			 */
-			if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN) &&
+			if (perf_paranoid_kernel() && !capable(CAP_TRACING) &&
 				is_kernel_addr(addr))
 				continue;
 
diff --git a/arch/x86/events/intel/bts.c b/arch/x86/events/intel/bts.c
index 5ee3fed881d3..848a104a0d33 100644
--- a/arch/x86/events/intel/bts.c
+++ b/arch/x86/events/intel/bts.c
@@ -550,7 +550,7 @@ static int bts_event_init(struct perf_event *event)
 	 * users to profile the kernel.
 	 */
 	if (event->attr.exclude_kernel && perf_paranoid_kernel() &&
-	    !capable(CAP_SYS_ADMIN))
+	    !capable(CAP_TRACING))
 		return -EACCES;
 
 	if (x86_add_exclusive(x86_lbr_exclusive_bts))
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 648260b5f367..08714d33e566 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3307,7 +3307,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (x86_pmu.version < 3)
 		return -EINVAL;
 
-	if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+	if (perf_paranoid_cpu() && !capable(CAP_TRACING))
 		return -EACCES;
 
 	event->hw.config |= ARCH_PERFMON_EVENTSEL_ANY;
diff --git a/arch/x86/events/intel/p4.c b/arch/x86/events/intel/p4.c
index dee579efb2b2..abf20e33b523 100644
--- a/arch/x86/events/intel/p4.c
+++ b/arch/x86/events/intel/p4.c
@@ -776,7 +776,7 @@ static int p4_validate_raw_event(struct perf_event *event)
 	 * the user needs special permissions to be able to use it
 	 */
 	if (p4_ht_active() && p4_event_bind_map[v].shared) {
-		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+		if (perf_paranoid_cpu() && !capable(CAP_TRACING))
 			return -EACCES;
 	}
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0463c1151bae..a0e5495cad53 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4134,7 +4134,7 @@ find_get_context(struct pmu *pmu, struct task_struct *task,
 
 	if (!task) {
 		/* Must be root to operate on a CPU event: */
-		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+		if (perf_paranoid_cpu() && !capable(CAP_TRACING))
 			return ERR_PTR(-EACCES);
 
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
@@ -8741,7 +8741,7 @@ static int perf_kprobe_event_init(struct perf_event *event)
 	if (event->attr.type != perf_kprobe.type)
 		return -ENOENT;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_TRACING))
 		return -EACCES;
 
 	/*
@@ -8801,7 +8801,7 @@ static int perf_uprobe_event_init(struct perf_event *event)
 	if (event->attr.type != perf_uprobe.type)
 		return -ENOENT;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_TRACING))
 		return -EACCES;
 
 	/*
@@ -10588,7 +10588,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 		}
 		/* privileged levels capture (kernel, hv): check permissions */
 		if ((mask & PERF_SAMPLE_BRANCH_PERM_PLM)
-		    && perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+		    && perf_paranoid_kernel() && !capable(CAP_TRACING))
 			return -EACCES;
 	}
 
@@ -10807,12 +10807,12 @@ SYSCALL_DEFINE5(perf_event_open,
 		return err;
 
 	if (!attr.exclude_kernel) {
-		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+		if (perf_paranoid_kernel() && !capable(CAP_TRACING))
 			return -EACCES;
 	}
 
 	if (attr.namespaces) {
-		if (!capable(CAP_SYS_ADMIN))
+		if (!capable(CAP_TRACING))
 			return -EACCES;
 	}
 
@@ -10826,7 +10826,7 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	/* Only privileged users can get physical addresses */
 	if ((attr.sample_type & PERF_SAMPLE_PHYS_ADDR) &&
-	    perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+	    perf_paranoid_kernel() && !capable(CAP_TRACING))
 		return -EACCES;
 
 	/*
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index c5cd852fe86b..6174d547699d 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -404,7 +404,7 @@ static int hw_breakpoint_parse(struct perf_event *bp,
 		 * Don't let unprivileged users set a breakpoint in the trap
 		 * path to avoid trap recursion attacks.
 		 */
-		if (!capable(CAP_SYS_ADMIN))
+		if (!capable(CAP_TRACING))
 			return -EPERM;
 	}
 
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 0892e38ed6fb..1ec3e08d4539 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -46,7 +46,7 @@ static int perf_trace_event_perm(struct trace_event_call *tp_event,
 
 	/* The ftrace function trace is allowed only for root. */
 	if (ftrace_event_is_function(tp_event)) {
-		if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
+		if (perf_paranoid_tracepoint_raw() && !capable(CAP_TRACING))
 			return -EPERM;
 
 		if (!is_sampling_event(p_event))
@@ -82,7 +82,7 @@ static int perf_trace_event_perm(struct trace_event_call *tp_event,
 	 * ...otherwise raw tracepoint data can be a severe data leak,
 	 * only allow root to have these.
 	 */
-	if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
+	if (perf_paranoid_tracepoint_raw() && !capable(CAP_TRACING))
 		return -EPERM;
 
 	return 0;
-- 
2.20.0

