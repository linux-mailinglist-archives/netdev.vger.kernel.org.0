Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E3915E643
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393149AbgBNQq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:46:27 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55536 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392950AbgBNQVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 11:21:30 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2diG-0003Kt-Cz; Fri, 14 Feb 2020 17:21:08 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 293F2103063;
        Fri, 14 Feb 2020 17:21:06 +0100 (CET)
Message-Id: <20200214161504.111252345@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 14 Feb 2020 14:39:29 +0100
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
Subject: [RFC patch 12/19] bpf: Use migrate_disable/enabe() in trampoline code.
References: <20200214133917.304937432@linutronix.de>
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
 

