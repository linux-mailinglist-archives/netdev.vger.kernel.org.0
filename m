Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A4515E1F8
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392993AbgBNQVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:21:33 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55555 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392973AbgBNQVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 11:21:32 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2diF-0003Jo-GP; Fri, 14 Feb 2020 17:21:07 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id E7704101DFA;
        Fri, 14 Feb 2020 17:21:05 +0100 (CET)
Message-Id: <20200214161504.003989644@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 14 Feb 2020 14:39:28 +0100
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
Subject: [RFC patch 11/19] bpf/tests: Use migrate disable instead of preempt disable
References: <20200214133917.304937432@linutronix.de>
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

