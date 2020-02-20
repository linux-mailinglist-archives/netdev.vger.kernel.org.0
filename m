Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2990616695A
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 21:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgBTU6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 15:58:09 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44160 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729181AbgBTU4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 15:56:39 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j4srf-0007Uk-7c; Thu, 20 Feb 2020 21:56:07 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id B760110408F;
        Thu, 20 Feb 2020 21:56:04 +0100 (CET)
Message-Id: <20200220204618.518678842@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 20 Feb 2020 21:45:29 +0100
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
Subject: [patch V2 12/20] bpf: Use migrate_disable/enabe() in trampoline code.
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

From: David Miller <davem@davemloft.net>

Instead of preemption disable/enable to reflect the purpose. This allows
PREEMPT_RT to substitute it with an actual migration disable
implementation. On non RT kernels this is still mapped to
preempt_disable/enable().

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/bpf/trampoline.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -367,8 +367,9 @@ void bpf_trampoline_put(struct bpf_tramp
 	mutex_unlock(&trampoline_mutex);
 }
 
-/* The logic is similar to BPF_PROG_RUN, but with explicit rcu and preempt that
- * are needed for trampoline. The macro is split into
+/* The logic is similar to BPF_PROG_RUN, but with an explicit
+ * rcu_read_lock() and migrate_disable() which are required
+ * for the trampoline. The macro is split into
  * call _bpf_prog_enter
  * call prog->bpf_func
  * call __bpf_prog_exit
@@ -378,7 +379,7 @@ u64 notrace __bpf_prog_enter(void)
 	u64 start = 0;
 
 	rcu_read_lock();
-	preempt_disable();
+	migrate_disable();
 	if (static_branch_unlikely(&bpf_stats_enabled_key))
 		start = sched_clock();
 	return start;
@@ -401,7 +402,7 @@ void notrace __bpf_prog_exit(struct bpf_
 		stats->nsecs += sched_clock() - start;
 		u64_stats_update_end(&stats->syncp);
 	}
-	preempt_enable();
+	migrate_enable();
 	rcu_read_unlock();
 }
 

