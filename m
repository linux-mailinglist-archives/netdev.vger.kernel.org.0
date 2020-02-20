Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75B116696E
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 21:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbgBTU6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 15:58:22 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44154 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729169AbgBTU4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 15:56:38 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j4srl-0007at-AL; Thu, 20 Feb 2020 21:56:13 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 72815104094;
        Thu, 20 Feb 2020 21:56:05 +0100 (CET)
Message-Id: <20200220204618.815084606@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 20 Feb 2020 21:45:32 +0100
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
Subject: [patch V2 15/20] bpf: Provide recursion prevention helpers
References: <20200220204517.863202864@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
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
 

