Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 720BB15E625
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394132AbgBNQqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:46:10 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55547 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392960AbgBNQVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 11:21:31 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2diI-0003IH-BE; Fri, 14 Feb 2020 17:21:10 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 13B6B101DF3;
        Fri, 14 Feb 2020 17:21:05 +0100 (CET)
Message-Id: <20200214161503.595780887@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 14 Feb 2020 14:39:24 +0100
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
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC patch 07/19] bpf: Provide BPF_PROG_RUN_PIN_ON_CPU() macro
References: <20200214133917.304937432@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF programs require to run on one CPU to completion as they use per CPU
storage, but according to Alexei they don't need reentrancy protection as
obviously BPF programs running in thread context can always be 'preempted'
by hard and soft interrupts and instrumentation and the same program can
run concurrently on a different CPU.

The currently used mechanism to ensure CPUness is to wrap the invocation
into a preempt_disable/enable() pair. Disabling preemption is also
disabling migration for a task.

preempt_disable/enable() is used because there is no explicit way to
reliably disable only migration.

Provide a separate macro to invoke a BPF program which can be used in
migrateable task context.

It wraps BPF_PROG_RUN() in a migrate_disable/enable() pair which maps on
non RT enabled kernels to preempt_disable/enable(). On RT enabled kernels
this merely disables migration. Both methods ensure that the invoked BPF
program runs on one CPU to completion.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/filter.h |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -576,8 +576,26 @@ DECLARE_STATIC_KEY_FALSE(bpf_stats_enabl
 	}								\
 	ret; })
 
-#define BPF_PROG_RUN(prog, ctx) __BPF_PROG_RUN(prog, ctx,		\
-					       bpf_dispatcher_nopfunc)
+#define BPF_PROG_RUN(prog, ctx)						\
+	__BPF_PROG_RUN(prog, ctx, bpf_dispatcher_nopfunc)
+
+/*
+ * Use in preemptible and therefore migratable context to make sure that
+ * the execution of the BPF program runs on one CPU.
+ *
+ * This uses migrate_disable/enable() explicitely to document that the
+ * invocation of a BPF program does not require reentrancy protection
+ * against a BPF program which is invoked from a preempting task.
+ *
+ * For non RT enabled kernels migrate_disable/enable() maps to
+ * preempt_disable/enable(), i.e. it disables also preemption.
+ */
+#define BPF_PROG_RUN_PIN_ON_CPU(prog, ctx) ({				\
+	u32 ret;							\
+	migrate_disable();						\
+	ret = __BPF_PROG_RUN(prog, ctx, bpf_dispatcher_nopfunc);	\
+	migrate_enable();						\
+	ret; })
 
 #define BPF_SKB_CB_LEN QDISC_CB_PRIV_LEN
 

