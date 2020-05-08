Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF0B1CB1BD
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 16:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgEHOZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 10:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgEHOZj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 10:25:39 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E65AC2495B;
        Fri,  8 May 2020 14:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588947938;
        bh=hvtN8vEfjT44J3aV4P+LxySHHWd0G/VwVAZCtMrO6ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TndzmNIboQXHAzygUMEOX6T9dOr3K5ENcl3xkPABlgjx24V2z9re94cKrwnr6+mbp
         CACT8jcSCRX8b8dzEdMKOZ9KWQpyCOb+r7kdegPtTJ9IDSlzIPN90Hinnw419Vm4UY
         eluioV817SzVA8k43DlSPJBmZ1JYu27G4lnstq+Q=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Wang Nan <wangnan0@huawei.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH v2 3/3] arm: kprobes: Support nested kprobes
Date:   Fri,  8 May 2020 23:25:31 +0900
Message-Id: <158894793116.14896.3047536946362361693.stgit@devnote2>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <158894789510.14896.13461271606820304664.stgit@devnote2>
References: <158894789510.14896.13461271606820304664.stgit@devnote2>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make kprobes to accept 1-level nesting instead of missing it
on arm.

Any kprobes hits in kprobes pre/post handler context can be
nested at once. If the other kprobes hits in the nested pre/post
handler context, that will be missed.

We can test this feature on the kernel with
CONFIG_KPROBE_EVENTS_ON_NOTRACE=y as below.

 # cd /sys/kernel/debug/tracing
 # echo p ring_buffer_lock_reserve > kprobe_events
 # echo p vfs_read >> kprobe_events
 # echo 0 > /proc/sys/debug/kprobes-optimization # to check trap handler
 # echo stacktrace > events/kprobes/p_ring_buffer_lock_reserve_0/trigger
 # echo 1 > events/kprobes/enable
 # cat trace
 ...
              sh-94    [000] d...   124.945302: p_vfs_read_0: (vfs_read+0x0/0x120)
              sh-94    [000] d...   125.041822: p_ring_buffer_lock_reserve_0: (ring_buffer_lock_reserve+0x0/0x57c)
              sh-94    [000] d...   125.042102: <stack trace>
 => kprobe_dispatcher
 => aggr_pre_handler
 => kprobe_handler
 => kprobe_trap_handler
 => do_undefinstr
 => __und_svc_finish
 => ring_buffer_lock_reserve
 => kprobe_trace_func
 => kprobe_dispatcher
 => aggr_pre_handler
 => kprobe_handler
 => kprobe_trap_handler
 => do_undefinstr
 => __und_svc_finish
 => vfs_read
 => sys_read
 => ret_fast_syscall

The trap handler is nested correctly.

Note that this also improve unrecoverable message to show
nested probes too.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
  Changes in v2:
   - Dump nested kprobes when hit a BUG().
---
 arch/arm/include/asm/kprobes.h    |    5 ++
 arch/arm/probes/kprobes/core.c    |   83 +++++++++++++++++++------------------
 arch/arm/probes/kprobes/core.h    |   30 +++++++++++++
 arch/arm/probes/kprobes/opt-arm.c |    6 ++-
 4 files changed, 80 insertions(+), 44 deletions(-)

diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
index 213607a1f45c..553f719bbfd5 100644
--- a/arch/arm/include/asm/kprobes.h
+++ b/arch/arm/include/asm/kprobes.h
@@ -32,10 +32,13 @@ struct prev_kprobe {
 	unsigned int status;
 };
 
+#define KPROBE_NEST_MAX	2
+
 /* per-cpu kprobe control block */
 struct kprobe_ctlblk {
 	unsigned int kprobe_status;
-	struct prev_kprobe prev_kprobe;
+	struct prev_kprobe prev[KPROBE_NEST_MAX];
+	int nested;
 };
 
 void arch_remove_kprobe(struct kprobe *);
diff --git a/arch/arm/probes/kprobes/core.c b/arch/arm/probes/kprobes/core.c
index 90b5bc723c83..5bb8d5f2b3b7 100644
--- a/arch/arm/probes/kprobes/core.c
+++ b/arch/arm/probes/kprobes/core.c
@@ -187,18 +187,6 @@ void __kprobes arch_remove_kprobe(struct kprobe *p)
 	}
 }
 
-static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	kcb->prev_kprobe.kp = kprobe_running();
-	kcb->prev_kprobe.status = kcb->kprobe_status;
-}
-
-static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
-	kcb->kprobe_status = kcb->prev_kprobe.status;
-}
-
 static void __kprobes set_current_kprobe(struct kprobe *p)
 {
 	__this_cpu_write(current_kprobe, p);
@@ -224,6 +212,44 @@ singlestep(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb)
 	p->ainsn.insn_singlestep(p->opcode, &p->ainsn, regs);
 }
 
+static nokprobe_inline int reenter_kprobe(struct kprobe *p,
+					  struct pt_regs *regs,
+					  struct kprobe_ctlblk *kcb)
+{
+	/* Kprobe is pending, so we're recursing. */
+	switch (kcb->kprobe_status) {
+	case KPROBE_HIT_ACTIVE:
+	case KPROBE_HIT_SSDONE:
+		if (kcb->nested < KPROBE_NEST_MAX - 1) {
+			save_previous_kprobe(kcb);
+			return 0;
+		}
+		fallthrough;
+	case KPROBE_HIT_SS:
+		/* A pre- or post-handler probe got us here. */
+		kprobes_inc_nmissed_count(p);
+		save_previous_kprobe(kcb);
+		set_current_kprobe(p);
+		kcb->kprobe_status = KPROBE_REENTER;
+		singlestep(p, regs, kcb);
+		restore_previous_kprobe(kcb);
+		break;
+	case KPROBE_REENTER:
+		/* A nested probe was hit in FIQ, it is a BUG */
+		pr_warn("Unrecoverable kprobe detected.\n");
+		pr_err("Current kprobe:\n");
+		dump_kprobe(p);
+		pr_err("Nested kprobes (nested: %d):\n", kcb->nested);
+		while (kcb->nested)
+			dump_kprobe(kcb->prev[--kcb->nested].kp);
+		fallthrough;
+	default:
+		/* impossible cases */
+		BUG();
+	}
+	return 1;
+}
+
 /*
  * Called with IRQs disabled. IRQs must remain disabled from that point
  * all the way until processing this kprobe is complete.  The current
@@ -262,30 +288,9 @@ void __kprobes kprobe_handler(struct pt_regs *regs)
 			 * In this case, we can skip recursing check too.
 			 */
 			singlestep_skip(p, regs);
-		} else if (cur) {
-			/* Kprobe is pending, so we're recursing. */
-			switch (kcb->kprobe_status) {
-			case KPROBE_HIT_ACTIVE:
-			case KPROBE_HIT_SSDONE:
-			case KPROBE_HIT_SS:
-				/* A pre- or post-handler probe got us here. */
-				kprobes_inc_nmissed_count(p);
-				save_previous_kprobe(kcb);
-				set_current_kprobe(p);
-				kcb->kprobe_status = KPROBE_REENTER;
-				singlestep(p, regs, kcb);
-				restore_previous_kprobe(kcb);
-				break;
-			case KPROBE_REENTER:
-				/* A nested probe was hit in FIQ, it is a BUG */
-				pr_warn("Unrecoverable kprobe detected.\n");
-				dump_kprobe(p);
-				/* fall through */
-			default:
-				/* impossible cases */
-				BUG();
-			}
 		} else {
+			if (cur && reenter_kprobe(p, regs, kcb))
+				return;
 			/* Probe hit and conditional execution check ok. */
 			set_current_kprobe(p);
 			kcb->kprobe_status = KPROBE_HIT_ACTIVE;
@@ -305,7 +310,7 @@ void __kprobes kprobe_handler(struct pt_regs *regs)
 					p->post_handler(p, regs, 0);
 				}
 			}
-			reset_current_kprobe();
+			pop_current_kprobe(kcb);
 		}
 	} else {
 		/*
@@ -342,11 +347,7 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr)
 		 * normal page fault.
 		 */
 		regs->ARM_pc = (long)cur->addr;
-		if (kcb->kprobe_status == KPROBE_REENTER) {
-			restore_previous_kprobe(kcb);
-		} else {
-			reset_current_kprobe();
-		}
+		pop_current_kprobe(kcb);
 		break;
 
 	case KPROBE_HIT_ACTIVE:
diff --git a/arch/arm/probes/kprobes/core.h b/arch/arm/probes/kprobes/core.h
index c3db468650ce..aaff1e0f2153 100644
--- a/arch/arm/probes/kprobes/core.h
+++ b/arch/arm/probes/kprobes/core.h
@@ -34,6 +34,36 @@ typedef enum probes_insn (kprobe_decode_insn_t)(probes_opcode_t,
 						const union decode_action *,
 						const struct decode_checker *[]);
 
+
+static nokprobe_inline void save_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	int i = kcb->nested++;
+
+	kcb->prev[i].kp = kprobe_running();
+	kcb->prev[i].status = kcb->kprobe_status;
+}
+
+static nokprobe_inline void restore_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	int i = --kcb->nested;
+
+	__this_cpu_write(current_kprobe, kcb->prev[i].kp);
+	kcb->kprobe_status = kcb->prev[i].status;
+}
+
+static nokprobe_inline void pop_current_kprobe(struct kprobe_ctlblk *kcb)
+{
+	if (kcb->nested)
+		restore_previous_kprobe(kcb);
+	else
+		reset_current_kprobe();
+}
+
+static nokprobe_inline bool kprobe_can_nest(struct kprobe_ctlblk *kcb)
+{
+	return !kprobe_running() || (kcb->nested < KPROBE_NEST_MAX - 1);
+}
+
 #ifdef CONFIG_THUMB2_KERNEL
 
 extern const union decode_action kprobes_t32_actions[];
diff --git a/arch/arm/probes/kprobes/opt-arm.c b/arch/arm/probes/kprobes/opt-arm.c
index 7a449df0b359..cb4cb13bff88 100644
--- a/arch/arm/probes/kprobes/opt-arm.c
+++ b/arch/arm/probes/kprobes/opt-arm.c
@@ -161,13 +161,15 @@ optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
 	local_irq_save(flags);
 	kcb = get_kprobe_ctlblk();
 
-	if (kprobe_running()) {
+	if (!kprobe_can_nest(kcb)) {
 		kprobes_inc_nmissed_count(&op->kp);
 	} else {
+		if (kprobe_running())
+			save_previous_kprobe(kcb);
 		__this_cpu_write(current_kprobe, &op->kp);
 		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
 		opt_pre_handler(&op->kp, regs);
-		__this_cpu_write(current_kprobe, NULL);
+		pop_current_kprobe(kcb);
 	}
 
 	/*

