Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13AE1115FEC
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 01:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfLHAEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 19:04:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44950 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbfLHAEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 19:04:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CE44E15449D81;
        Sat,  7 Dec 2019 16:04:31 -0800 (PST)
Date:   Sat, 07 Dec 2019 16:04:31 -0800 (PST)
Message-Id: <20191207.160431.142137475190293825.davem@davemloft.net>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
CC:     ast@kernel.org, daniel@iogearbox.net, tglx@linutronix.de
Subject: [RFC v1 PATCH 4/7] bpf: More BPF_PROG_RUN() --> __BPF_PROG_RUN()
 transformations.
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 16:04:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


In these cases the explicit preempt_{disable,enable}() calls
are just outside the BPF_PROG_RUN() call site.

In some cases, for testing particularly, this is happening in to
amortize the preemption state changes.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 kernel/events/core.c     |  6 +++---
 kernel/seccomp.c         |  6 +++---
 kernel/trace/bpf_trace.c |  6 +++---
 lib/test_bpf.c           |  6 +++---
 net/bpf/test_run.c       | 10 +++++-----
 net/core/skmsg.c         |  8 +++-----
 6 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4ff86d57f9e5..b0ac32b27da4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9197,15 +9197,15 @@ static void bpf_overflow_handler(struct perf_event *event,
 	int ret = 0;
 
 	ctx.regs = perf_arch_bpf_user_pt_regs(regs);
-	preempt_disable();
+	bpf_prog_lock();
 	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1))
 		goto out;
 	rcu_read_lock();
-	ret = BPF_PROG_RUN(event->prog, &ctx);
+	ret = __BPF_PROG_RUN(event->prog, &ctx);
 	rcu_read_unlock();
 out:
 	__this_cpu_dec(bpf_prog_active);
-	preempt_enable();
+	bpf_prog_unlock();
 	if (!ret)
 		return;
 
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 12d2227e5786..80ab1ea4dead 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -268,16 +268,16 @@ static u32 seccomp_run_filters(const struct seccomp_data *sd,
 	 * All filters in the list are evaluated and the lowest BPF return
 	 * value always takes priority (ignoring the DATA).
 	 */
-	preempt_disable();
+	bpf_prog_lock();
 	for (; f; f = f->prev) {
-		u32 cur_ret = BPF_PROG_RUN(f->prog, sd);
+		u32 cur_ret = __BPF_PROG_RUN(f->prog, sd);
 
 		if (ACTION_ONLY(cur_ret) < ACTION_ONLY(ret)) {
 			ret = cur_ret;
 			*match = f;
 		}
 	}
-	preempt_enable();
+	bpf_prog_unlock();
 	return ret;
 }
 #endif /* CONFIG_SECCOMP_FILTER */
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index cc4873cfaab2..8a974f97cc9b 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -83,7 +83,7 @@ unsigned int trace_call_bpf(struct trace_event_call *call, void *ctx)
 	if (in_nmi()) /* not supported yet */
 		return 1;
 
-	preempt_disable();
+	bpf_prog_lock();
 
 	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
 		/*
@@ -111,11 +111,11 @@ unsigned int trace_call_bpf(struct trace_event_call *call, void *ctx)
 	 * out of events when it was updated in between this and the
 	 * rcu_dereference() which is accepted risk.
 	 */
-	ret = BPF_PROG_RUN_ARRAY_CHECK(call->prog_array, ctx, BPF_PROG_RUN);
+	ret = BPF_PROG_RUN_ARRAY_CHECK(call->prog_array, ctx, __BPF_PROG_RUN);
 
  out:
 	__this_cpu_dec(bpf_prog_active);
-	preempt_enable();
+	bpf_prog_unlock();
 
 	return ret;
 }
diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index cecb230833be..2ac3501d4263 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6660,14 +6660,14 @@ static int __run_one(const struct bpf_prog *fp, const void *data,
 	u64 start, finish;
 	int ret = 0, i;
 
-	preempt_disable();
+	bpf_prog_lock();
 	start = ktime_get_ns();
 
 	for (i = 0; i < runs; i++)
-		ret = BPF_PROG_RUN(fp, data);
+		ret = __BPF_PROG_RUN(fp, data);
 
 	finish = ktime_get_ns();
-	preempt_enable();
+	bpf_prog_unlock();
 
 	*duration = finish - start;
 	do_div(*duration, runs);
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 915c2d6f7fb9..2b30d5e811a6 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -37,11 +37,11 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 		repeat = 1;
 
 	rcu_read_lock();
-	preempt_disable();
+	bpf_prog_lock();
 	time_start = ktime_get_ns();
 	for (i = 0; i < repeat; i++) {
 		bpf_cgroup_storage_set(storage);
-		*retval = BPF_PROG_RUN(prog, ctx);
+		*retval = __BPF_PROG_RUN(prog, ctx);
 
 		if (signal_pending(current)) {
 			ret = -EINTR;
@@ -50,18 +50,18 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 
 		if (need_resched()) {
 			time_spent += ktime_get_ns() - time_start;
-			preempt_enable();
+			bpf_prog_unlock();
 			rcu_read_unlock();
 
 			cond_resched();
 
 			rcu_read_lock();
-			preempt_disable();
+			bpf_prog_lock();
 			time_start = ktime_get_ns();
 		}
 	}
 	time_spent += ktime_get_ns() - time_start;
-	preempt_enable();
+	bpf_prog_unlock();
 	rcu_read_unlock();
 
 	do_div(time_spent, repeat);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index ded2d5227678..07466785c47f 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -628,7 +628,7 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 	struct bpf_prog *prog;
 	int ret;
 
-	preempt_disable();
+	bpf_prog_lock();
 	rcu_read_lock();
 	prog = READ_ONCE(psock->progs.msg_parser);
 	if (unlikely(!prog)) {
@@ -638,7 +638,7 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 
 	sk_msg_compute_data_pointers(msg);
 	msg->sk = sk;
-	ret = BPF_PROG_RUN(prog, msg);
+	ret = __BPF_PROG_RUN(prog, msg);
 	ret = sk_psock_map_verd(ret, msg->sk_redir);
 	psock->apply_bytes = msg->apply_bytes;
 	if (ret == __SK_REDIRECT) {
@@ -653,7 +653,7 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 	}
 out:
 	rcu_read_unlock();
-	preempt_enable();
+	bpf_prog_unlock();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(sk_psock_msg_verdict);
@@ -665,9 +665,7 @@ static int sk_psock_bpf_run(struct sk_psock *psock, struct bpf_prog *prog,
 
 	skb->sk = psock->sk;
 	bpf_compute_data_end_sk_skb(skb);
-	preempt_disable();
 	ret = BPF_PROG_RUN(prog, skb);
-	preempt_enable();
 	/* strparser clones the skb before handing it to a upper layer,
 	 * meaning skb_orphan has been called. We NULL sk on the way out
 	 * to ensure we don't trigger a BUG_ON() in skb/sk operations
-- 
2.20.1

