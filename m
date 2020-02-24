Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1228416A93A
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgBXPEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:04:10 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50214 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbgBXPDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:03:24 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6FFw-0004yv-0M; Mon, 24 Feb 2020 16:02:48 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id CC5C2104098;
        Mon, 24 Feb 2020 16:02:43 +0100 (CET)
Message-Id: <20200224145644.103910133@linutronix.de>
User-Agent: quilt/0.65
Date:   Mon, 24 Feb 2020 15:01:47 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [patch V3 16/22] bpf: Provide recursion prevention helpers
References: <20200224140131.461979697@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The places which need to prevent the execution of trace type BPF programs
to prevent deadlocks on the hash bucket lock do this open coded.

Provide two inline functions, bpf_disable/enable_instrumentation() to
replace these open coded protection constructs.

Use migrate_disable/enable() instead of preempt_disable/enable() right away
so this works on RT enabled kernels. On a !RT kernel migrate_disable /
enable() are mapped to preempt_disable/enable().

These helpers use this_cpu_inc/dec() instead of __this_cpu_inc/dec() on an
RT enabled kernel because migrate disabled regions are preemptible and
preemption might hit in the middle of a RMW operation which can lead to
inconsistent state.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V2: New patch. Use this_cpu_inc/dec() as pointed out by Mathieu.
---
 include/linux/bpf.h |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -961,6 +961,36 @@ int bpf_prog_array_copy(struct bpf_prog_
 #ifdef CONFIG_BPF_SYSCALL
 DECLARE_PER_CPU(int, bpf_prog_active);
 
+/*
+ * Block execution of BPF programs attached to instrumentation (perf,
+ * kprobes, tracepoints) to prevent deadlocks on map operations as any of
+ * these events can happen inside a region which holds a map bucket lock
+ * and can deadlock on it.
+ *
+ * Use the preemption safe inc/dec variants on RT because migrate disable
+ * is preemptible on RT and preemption in the middle of the RMW operation
+ * might lead to inconsistent state. Use the raw variants for non RT
+ * kernels as migrate_disable() maps to preempt_disable() so the slightly
+ * more expensive save operation can be avoided.
+ */
+static inline void bpf_disable_instrumentation(void)
+{
+	migrate_disable();
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		this_cpu_inc(bpf_prog_active);
+	else
+		__this_cpu_inc(bpf_prog_active);
+}
+
+static inline void bpf_enable_instrumentation(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		this_cpu_dec(bpf_prog_active);
+	else
+		__this_cpu_dec(bpf_prog_active);
+	migrate_enable();
+}
+
 extern const struct file_operations bpf_map_fops;
 extern const struct file_operations bpf_prog_fops;
 

