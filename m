Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6111C863C
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgEGKAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbgEGKAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 06:00:15 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D06CB20870;
        Thu,  7 May 2020 10:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588845614;
        bh=5sZJWMajUh4vPySqA51QTeZbNJXETHrWyOeQvUNxR3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbXz3wPTNC8shMt8HNhEp6VmaFXT3FAF2/SoA1Zyei0p2qSuYCzbOfonD8QsHuw2o
         Ab6IFebSzm6lvtRNC4Mf+U69s1y1xMPZhXgJBdQSn9pwM3ODnATl+Td0dUVu6rba0K
         qFOM/QT2mZ3A6ClvIPvir4MMiYtY7A4FOnceuH8g=
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
Subject: [RFC PATCH 2/3] arm64: kprobes: Support nested kprobes
Date:   Thu,  7 May 2020 19:00:07 +0900
Message-Id: <158884560738.12656.13619534422220572094.stgit@devnote2>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <158884558272.12656.7654266361809594662.stgit@devnote2>
References: <158884558272.12656.7654266361809594662.stgit@devnote2>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make kprobes to accept 1-level nesting instead of missing it
on arm64.

Any kprobes hits in kprobes pre/post handler context can be
nested at once. If the other kprobes hits in the nested pre/post
handler context, that will be missed.

We can test this feature on the kernel with
CONFIG_KPROBE_EVENTS_ON_NOTRACE=y as below.

 # cd /sys/kernel/debug/tracing
 # echo p ring_buffer_lock_reserve > kprobe_events
 # echo p vfs_read >> kprobe_events
 # echo stacktrace > events/kprobes/p_ring_buffer_lock_reserve_0/trigger
 # echo 1 > events/kprobes/enable
 # cat trace
 ...
               sh-211   [005] d..2    71.708242: p_ring_buffer_lock_reserve_0: (ring_buffer_lock_reserve+0x0/0x4c8)
               sh-211   [005] d..2    71.709982: <stack trace>
  => kprobe_dispatcher
  => kprobe_breakpoint_handler
  => call_break_hook
  => brk_handler
  => do_debug_exception
  => el1_sync_handler
  => el1_sync
  => ring_buffer_lock_reserve
  => kprobe_trace_func
  => kprobe_dispatcher
  => kprobe_breakpoint_handler
  => call_break_hook
  => brk_handler
  => do_debug_exception
  => el1_sync_handler
  => el1_sync
  => vfs_read
  => __arm64_sys_read
  => el0_svc_common.constprop.3
  => do_el0_svc
  => el0_sync_handler
  => el0_sync

This shows brk_handler is nested.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 arch/arm64/include/asm/kprobes.h   |    5 ++
 arch/arm64/kernel/probes/kprobes.c |   75 ++++++++++++++++++++----------------
 2 files changed, 46 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/include/asm/kprobes.h b/arch/arm64/include/asm/kprobes.h
index 97e511d645a2..b2ebd3bad794 100644
--- a/arch/arm64/include/asm/kprobes.h
+++ b/arch/arm64/include/asm/kprobes.h
@@ -34,12 +34,15 @@ struct kprobe_step_ctx {
 	unsigned long match_addr;
 };
 
+#define KPROBE_NEST_MAX 2
+
 /* per-cpu kprobe control block */
 struct kprobe_ctlblk {
 	unsigned int kprobe_status;
 	unsigned long saved_irqflag;
-	struct prev_kprobe prev_kprobe;
+	struct prev_kprobe prev[KPROBE_NEST_MAX];
 	struct kprobe_step_ctx ss_ctx;
+	int nested;
 };
 
 void arch_remove_kprobe(struct kprobe *);
diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index d1c95dcf1d78..27d52726277b 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -153,14 +153,18 @@ void __kprobes arch_remove_kprobe(struct kprobe *p)
 
 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	kcb->prev_kprobe.kp = kprobe_running();
-	kcb->prev_kprobe.status = kcb->kprobe_status;
+	int i = kcb->nested++;
+
+	kcb->prev[i].kp = kprobe_running();
+	kcb->prev[i].status = kcb->kprobe_status;
 }
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
-	kcb->kprobe_status = kcb->prev_kprobe.status;
+	int i = --kcb->nested;
+
+	__this_cpu_write(current_kprobe, kcb->prev[i].kp);
+	kcb->kprobe_status = kcb->prev[i].status;
 }
 
 static void __kprobes set_current_kprobe(struct kprobe *p)
@@ -168,6 +172,14 @@ static void __kprobes set_current_kprobe(struct kprobe *p)
 	__this_cpu_write(current_kprobe, p);
 }
 
+static nokprobe_inline void pop_current_kprobe(struct kprobe_ctlblk *kcb)
+{
+	if (kcb->nested)
+		restore_previous_kprobe(kcb);
+	else
+		reset_current_kprobe();
+}
+
 /*
  * Interrupts need to be disabled before single-step mode is set, and not
  * reenabled until after single-step mode ends.
@@ -243,6 +255,10 @@ static int __kprobes reenter_kprobe(struct kprobe *p,
 	switch (kcb->kprobe_status) {
 	case KPROBE_HIT_SSDONE:
 	case KPROBE_HIT_ACTIVE:
+		if (kcb->nested < KPROBE_NEST_MAX - 1) {
+			save_previous_kprobe(kcb);
+			return 0;
+		}
 		kprobes_inc_nmissed_count(p);
 		setup_singlestep(p, regs, kcb, 1);
 		break;
@@ -286,7 +302,7 @@ post_kprobe_handler(struct kprobe_ctlblk *kcb, struct pt_regs *regs)
 		cur->post_handler(cur, regs, 0);
 	}
 
-	reset_current_kprobe();
+	pop_current_kprobe(kcb);
 }
 
 int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr)
@@ -309,11 +325,7 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr)
 			BUG();
 
 		kernel_disable_single_step();
-
-		if (kcb->kprobe_status == KPROBE_REENTER)
-			restore_previous_kprobe(kcb);
-		else
-			reset_current_kprobe();
+		pop_current_kprobe(kcb);
 
 		break;
 	case KPROBE_HIT_ACTIVE:
@@ -357,30 +369,27 @@ static void __kprobes kprobe_handler(struct pt_regs *regs)
 	p = get_kprobe((kprobe_opcode_t *) addr);
 
 	if (p) {
-		if (cur_kprobe) {
-			if (reenter_kprobe(p, regs, kcb))
-				return;
-		} else {
-			/* Probe hit */
-			set_current_kprobe(p);
-			kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+		if (cur_kprobe && reenter_kprobe(p, regs, kcb))
+			return;
+		/* Probe hit */
+		set_current_kprobe(p);
+		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
 
-			/*
-			 * If we have no pre-handler or it returned 0, we
-			 * continue with normal processing.  If we have a
-			 * pre-handler and it returned non-zero, it will
-			 * modify the execution path and no need to single
-			 * stepping. Let's just reset current kprobe and exit.
-			 *
-			 * pre_handler can hit a breakpoint and can step thru
-			 * before return, keep PSTATE D-flag enabled until
-			 * pre_handler return back.
-			 */
-			if (!p->pre_handler || !p->pre_handler(p, regs)) {
-				setup_singlestep(p, regs, kcb, 0);
-			} else
-				reset_current_kprobe();
-		}
+		/*
+		 * If we have no pre-handler or it returned 0, we
+		 * continue with normal processing.  If we have a
+		 * pre-handler and it returned non-zero, it will
+		 * modify the execution path and no need to single
+		 * stepping. Let's just reset current kprobe and exit.
+		 *
+		 * pre_handler can hit a breakpoint and can step thru
+		 * before return, keep PSTATE D-flag enabled until
+		 * pre_handler return back.
+		 */
+		if (!p->pre_handler || !p->pre_handler(p, regs)) {
+			setup_singlestep(p, regs, kcb, 0);
+		} else
+			pop_current_kprobe(kcb);
 	}
 	/*
 	 * The breakpoint instruction was removed right

