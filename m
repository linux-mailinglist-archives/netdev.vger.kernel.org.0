Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB9AF16A958
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgBXPDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:03:22 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50196 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbgBXPDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:03:21 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6FFu-0004v8-Iz; Mon, 24 Feb 2020 16:02:46 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 28A4B104090;
        Mon, 24 Feb 2020 16:02:43 +0100 (CET)
Message-Id: <20200224145643.785306549@linutronix.de>
User-Agent: quilt/0.65
Date:   Mon, 24 Feb 2020 15:01:44 +0100
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
Subject: [patch V3 13/22] bpf/tests: Use migrate disable instead of preempt disable
References: <20200224140131.461979697@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>

Replace the preemption disable/enable with migrate_disable/enable() to
reflect the actual requirement and to allow PREEMPT_RT to substitute it
with an actual migration disable mechanism which does not disable
preemption.

[ tglx: Switched it over to migrate disable ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 lib/test_bpf.c     |    4 ++--
 net/bpf/test_run.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6660,14 +6660,14 @@ static int __run_one(const struct bpf_pr
 	u64 start, finish;
 	int ret = 0, i;
 
-	preempt_disable();
+	migrate_disable();
 	start = ktime_get_ns();
 
 	for (i = 0; i < runs; i++)
 		ret = BPF_PROG_RUN(fp, data);
 
 	finish = ktime_get_ns();
-	preempt_enable();
+	migrate_enable();
 
 	*duration = finish - start;
 	do_div(*duration, runs);
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -37,7 +37,7 @@ static int bpf_test_run(struct bpf_prog
 		repeat = 1;
 
 	rcu_read_lock();
-	preempt_disable();
+	migrate_disable();
 	time_start = ktime_get_ns();
 	for (i = 0; i < repeat; i++) {
 		bpf_cgroup_storage_set(storage);
@@ -54,18 +54,18 @@ static int bpf_test_run(struct bpf_prog
 
 		if (need_resched()) {
 			time_spent += ktime_get_ns() - time_start;
-			preempt_enable();
+			migrate_enable();
 			rcu_read_unlock();
 
 			cond_resched();
 
 			rcu_read_lock();
-			preempt_disable();
+			migrate_disable();
 			time_start = ktime_get_ns();
 		}
 	}
 	time_spent += ktime_get_ns() - time_start;
-	preempt_enable();
+	migrate_enable();
 	rcu_read_unlock();
 
 	do_div(time_spent, repeat);

