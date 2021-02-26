Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AD0326156
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 11:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhBZKdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 05:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbhBZKcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 05:32:16 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D826C061788
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 02:31:20 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id u125so7299587wmg.4
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 02:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qcr3NMOOmvQuNJc57S0TRJXaV4L43avgqAeNosjnIjw=;
        b=i/dF/0xFnwkVT5HfwSftVCabpCGMHGcVd2/S/UWefT9iPn2q33o7SPZhKxScnv87O6
         vaelvRS6sOekIT4BZA5OfBzztY05Gpu3qSGSUFkeuVzwDfDuUD7QnQX4uLB6+21RWV6V
         hvc7YPLQoBqI1aAJra5vUIWI71biffarVJazg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qcr3NMOOmvQuNJc57S0TRJXaV4L43avgqAeNosjnIjw=;
        b=tvI1w6dUIajaxoqFyJnsMUhTtGQhC8ynS+6qRjbqyErDvVSMNGBBOU9YFL6z0A9kvO
         /11rdOvYNR+zgXGktEYV8a65tBBJyNS3xB13AimNs3FhV3aqigmqaHXm4sGcfY+JPOAC
         vQyU77NADwNU2HFnmSKCVagJ7njWVbDIjaJeyrqgUrwlz8EWHWBrLAyhIzDasqa7/pSx
         lwkqqYP9Cy4oSctCkHus7txlqi6wWNeeUTkv/ybRkLaQe/ggf4wBj3ERsrCIjfh+4eC7
         04R7iR1Nm54UehzL+To6Csl3XknUbu7Qm2wWNEMF0o+uC7fiAmnE0B72lebaM7JSGr8K
         SyHQ==
X-Gm-Message-State: AOAM532TJkHNj5GIs9moBWdoCtkI9rDzvbgpCeihcKoJ/afF7EbEUbVR
        vf2p0OUW/1AouHfkMODimFCo0w==
X-Google-Smtp-Source: ABdhPJzuAlHA4XYJsQI3XJXSFvorIiDqqgipZDwnQFBeertm0e5su23mh/bmLYQ461Kaemb3lWbXQA==
X-Received: by 2002:a7b:cd81:: with SMTP id y1mr2160595wmj.51.1614335479341;
        Fri, 26 Feb 2021 02:31:19 -0800 (PST)
Received: from localhost.localdomain (d.4.3.e.3.5.0.6.8.1.5.9.3.d.9.6.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:69d3:9518:6053:e34d])
        by smtp.gmail.com with ESMTPSA id a21sm12448744wmb.5.2021.02.26.02.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 02:31:19 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v2 1/4] bpf: consolidate shared test timing code
Date:   Fri, 26 Feb 2021 10:31:00 +0000
Message-Id: <20210226103103.131210-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210226103103.131210-1-lmb@cloudflare.com>
References: <20210226103103.131210-1-lmb@cloudflare.com>
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

