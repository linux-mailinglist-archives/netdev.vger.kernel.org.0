Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1E9327BE4
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbhCAKWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbhCAKUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:20:23 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D53C061788
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 02:19:27 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id v15so15509646wrx.4
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 02:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qcr3NMOOmvQuNJc57S0TRJXaV4L43avgqAeNosjnIjw=;
        b=EZNCzIbVzq9zqdEZY08PBwrHPkW41dLecMCib5Hj1UtqMjNiHfnUywESe6gWP8bBl/
         2tHsH/6s8N+ljG+8hGC1Nuu8D7fi0DLYNfoIgWga3vscWRD0eP0dqhzCnGiySiD+67mf
         rS3keTuSFBSCCavQbvIsRauQf9WvNHWlE7JJw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qcr3NMOOmvQuNJc57S0TRJXaV4L43avgqAeNosjnIjw=;
        b=M5FUAxRTbi/LIX5S2Sr1YxtY9QzE6raf7uxgh3LHJqx10zQbfMEBUTjYtWfDx6R0zJ
         zZrzVCHKpzpoWt43by4zqHAq3Ojl44faeWxGcoXbLQrIbbjF10ArxDOCY/NBE62JjWLx
         /TggDt75N763Hd4ejVOObIB+Vaj0LotoW3y9VLP8DE8LYqa7bZZyT8z467DfvRm2xBqE
         I3N/E7tvEMkj13A4AdwdYS13I06+1H2aLCD8nn/QFLSgjnnqJKSbflVY1896r5gq51mX
         8od842VsecEw0EsDOzNoi9ws/oF+29HZyUD/z0LoTkkOA/fb29xB5LydWbsXuFbyuJQR
         Nbqg==
X-Gm-Message-State: AOAM530d/tfoOFnF5ZNRRVXBMIDDxEguHEisxcqzPaItT7XNbIUpicnv
        KJUXEN+7jZXUtWBMjj+fuB86Rw==
X-Google-Smtp-Source: ABdhPJxIFgmRlnfik3weXZbWq/FPdNM8XunQU9Y3aPVG8TsDeVtD1AON2U77Xk0pxoRYqC5D3oxYKg==
X-Received: by 2002:a5d:440f:: with SMTP id z15mr16535831wrq.251.1614593966231;
        Mon, 01 Mar 2021 02:19:26 -0800 (PST)
Received: from localhost.localdomain (2.b.a.d.8.4.b.a.9.e.4.2.1.8.0.5.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:5081:24e9:ab48:dab2])
        by smtp.gmail.com with ESMTPSA id a198sm14134600wmd.11.2021.03.01.02.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 02:19:25 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v3 1/5] bpf: consolidate shared test timing code
Date:   Mon,  1 Mar 2021 10:18:55 +0000
Message-Id: <20210301101859.46045-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210301101859.46045-1-lmb@cloudflare.com>
References: <20210301101859.46045-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Share the timing / signal interruption logic between different
implementations of PROG_TEST_RUN. There is a change in behaviour
as well. We check the loop exit condition before checking for
pending signals. This resolves an edge case where a signal
arrives during the last iteration. Instead of aborting with
EINTR we return the successful result to user space.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 net/bpf/test_run.c | 141 +++++++++++++++++++++++++--------------------
 1 file changed, 78 insertions(+), 63 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 58bcb8c849d5..ac8ee36d60cc 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -16,14 +16,78 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/bpf_test_run.h>
 
+struct test_timer {
+	enum { NO_PREEMPT, NO_MIGRATE } mode;
+	u32 i;
+	u64 time_start, time_spent;
+};
+
+static void t_enter(struct test_timer *t)
+	__acquires(rcu)
+{
+	rcu_read_lock();
+	if (t->mode == NO_PREEMPT)
+		preempt_disable();
+	else
+		migrate_disable();
+
+	t->time_start = ktime_get_ns();
+}
+
+static void t_leave(struct test_timer *t)
+	__releases(rcu)
+{
+	t->time_start = 0;
+
+	if (t->mode == NO_PREEMPT)
+		preempt_enable();
+	else
+		migrate_enable();
+	rcu_read_unlock();
+}
+
+static bool t_continue(struct test_timer *t, u32 repeat, int *err, u32 *duration)
+	__must_hold(rcu)
+{
+	t->i++;
+	if (t->i >= repeat) {
+		/* We're done. */
+		t->time_spent += ktime_get_ns() - t->time_start;
+		do_div(t->time_spent, t->i);
+		*duration = t->time_spent > U32_MAX ? U32_MAX : (u32)t->time_spent;
+		*err = 0;
+		goto reset;
+	}
+
+	if (signal_pending(current)) {
+		/* During iteration: we've been cancelled, abort. */
+		*err = -EINTR;
+		goto reset;
+	}
+
+	if (need_resched()) {
+		/* During iteration: we need to reschedule between runs. */
+		t->time_spent += ktime_get_ns() - t->time_start;
+		t_leave(t);
+		cond_resched();
+		t_enter(t);
+	}
+
+	/* Do another round. */
+	return true;
+
+reset:
+	t->i = 0;
+	return false;
+}
+
 static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 			u32 *retval, u32 *time, bool xdp)
 {
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = { NULL };
+	struct test_timer t = { NO_MIGRATE };
 	enum bpf_cgroup_storage_type stype;
-	u64 time_start, time_spent = 0;
-	int ret = 0;
-	u32 i;
+	int ret;
 
 	for_each_cgroup_storage_type(stype) {
 		storage[stype] = bpf_cgroup_storage_alloc(prog, stype);
@@ -38,40 +102,16 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 	if (!repeat)
 		repeat = 1;
 
-	rcu_read_lock();
-	migrate_disable();
-	time_start = ktime_get_ns();
-	for (i = 0; i < repeat; i++) {
+	t_enter(&t);
+	do {
 		bpf_cgroup_storage_set(storage);
 
 		if (xdp)
 			*retval = bpf_prog_run_xdp(prog, ctx);
 		else
 			*retval = BPF_PROG_RUN(prog, ctx);
-
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			break;
-		}
-
-		if (need_resched()) {
-			time_spent += ktime_get_ns() - time_start;
-			migrate_enable();
-			rcu_read_unlock();
-
-			cond_resched();
-
-			rcu_read_lock();
-			migrate_disable();
-			time_start = ktime_get_ns();
-		}
-	}
-	time_spent += ktime_get_ns() - time_start;
-	migrate_enable();
-	rcu_read_unlock();
-
-	do_div(time_spent, repeat);
-	*time = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
+	} while (t_continue(&t, repeat, &ret, time));
+	t_leave(&t);
 
 	for_each_cgroup_storage_type(stype)
 		bpf_cgroup_storage_free(storage[stype]);
@@ -674,18 +714,17 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 				     const union bpf_attr *kattr,
 				     union bpf_attr __user *uattr)
 {
+	struct test_timer t = { NO_PREEMPT };
 	u32 size = kattr->test.data_size_in;
 	struct bpf_flow_dissector ctx = {};
 	u32 repeat = kattr->test.repeat;
 	struct bpf_flow_keys *user_ctx;
 	struct bpf_flow_keys flow_keys;
-	u64 time_start, time_spent = 0;
 	const struct ethhdr *eth;
 	unsigned int flags = 0;
 	u32 retval, duration;
 	void *data;
 	int ret;
-	u32 i;
 
 	if (prog->type != BPF_PROG_TYPE_FLOW_DISSECTOR)
 		return -EINVAL;
@@ -721,39 +760,15 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	ctx.data = data;
 	ctx.data_end = (__u8 *)data + size;
 
-	rcu_read_lock();
-	preempt_disable();
-	time_start = ktime_get_ns();
-	for (i = 0; i < repeat; i++) {
+	t_enter(&t);
+	do {
 		retval = bpf_flow_dissect(prog, &ctx, eth->h_proto, ETH_HLEN,
 					  size, flags);
+	} while (t_continue(&t, repeat, &ret, &duration));
+	t_leave(&t);
 
-		if (signal_pending(current)) {
-			preempt_enable();
-			rcu_read_unlock();
-
-			ret = -EINTR;
-			goto out;
-		}
-
-		if (need_resched()) {
-			time_spent += ktime_get_ns() - time_start;
-			preempt_enable();
-			rcu_read_unlock();
-
-			cond_resched();
-
-			rcu_read_lock();
-			preempt_disable();
-			time_start = ktime_get_ns();
-		}
-	}
-	time_spent += ktime_get_ns() - time_start;
-	preempt_enable();
-	rcu_read_unlock();
-
-	do_div(time_spent, repeat);
-	duration = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
+	if (ret < 0)
+		goto out;
 
 	ret = bpf_test_finish(kattr, uattr, &flow_keys, sizeof(flow_keys),
 			      retval, duration);
-- 
2.27.0

