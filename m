Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42B7C16A95B
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgBXPE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:04:57 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50203 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgBXPDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:03:23 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6FFv-0004x0-0k; Mon, 24 Feb 2020 16:02:47 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 5E1C4104096;
        Mon, 24 Feb 2020 16:02:43 +0100 (CET)
Message-Id: <20200224145643.891428873@linutronix.de>
User-Agent: quilt/0.65
Date:   Mon, 24 Feb 2020 15:01:45 +0100
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
Subject: [patch V3 14/22] bpf: Use migrate_disable/enabe() in trampoline code.
References: <20200224140131.461979697@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 

