Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314DE31C92E
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 11:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhBPK7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 05:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhBPK7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 05:59:03 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1415DC061756
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:58:18 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id a132so2328810wmc.0
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7nhGdH2jRUj/QZlW4iWuCSizyYaXZl3nI4YhKo/LbqY=;
        b=mwGWoSTICerhgD4ACWwc1oV746IpOBFVKvdPStAMRucN2NP0sqclUIuXrGuFqoxyvO
         SCWD9eZh96/+ctBR9edJC4k4dx2gag0A31WpAigNDNw7jT8P0NhraIaNwHN7uTjZq6OO
         indy9aaixC9XZue2Hesf/pxgLtFLisBibWZNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7nhGdH2jRUj/QZlW4iWuCSizyYaXZl3nI4YhKo/LbqY=;
        b=Nk9JcjsR7OJGqwMogPA90GGQW7u6z7wXGGsY1d+2KDilSkrDB06rWMJFew5H1AxPvN
         nHhpHsJIl0KKkbNYoyPzFPQucNvT7xmqakWJZjl8UVOZur6nxGcp6FPtKHlgnEhD7+8a
         mnfVjdSXs5CHcnas1j/kt91Ij8VGfQDS01O0EB6i2FhQef3g8SjkIkYM6cIyijFLmwFz
         FIXSqNA21DmbQ247U3T+vrTmnW6CYo9Emwo2F+ZcbpynmGBtyfN3B/aunlnrNThz+TkZ
         XGYm5F74eKl9GkpdYDOKKbPcPM9VhQMPWFhppXXj2LByb6fKKmczfoVoOnXEs9Jc++lU
         2Viw==
X-Gm-Message-State: AOAM533agtHZWTSGxkSoFw7LmxR3/JRNwH1/v+2abIwbg5K9ln4T6KoI
        6+I80d49jnHZUAlXdbpTbZaR5g==
X-Google-Smtp-Source: ABdhPJwP/8rfhpUy+Y14AYtpcc+vn+nJ6fF2LYDcRz95lqgP9lYxW5nNE6lXZrFTz5GVcSJ4SZvXPQ==
X-Received: by 2002:a7b:c4cb:: with SMTP id g11mr2801795wmk.99.1613473096807;
        Tue, 16 Feb 2021 02:58:16 -0800 (PST)
Received: from antares.lan (111.253.187.81.in-addr.arpa. [81.187.253.111])
        by smtp.gmail.com with ESMTPSA id l1sm2820238wmi.48.2021.02.16.02.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 02:58:16 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        jakub@cloudflare.com
Cc:     kernel-team@cloudflare.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 1/8] bpf: consolidate shared test timing code
Date:   Tue, 16 Feb 2021 10:57:06 +0000
Message-Id: <20210216105713.45052-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216105713.45052-1-lmb@cloudflare.com>
References: <20210216105713.45052-1-lmb@cloudflare.com>
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
 net/bpf/test_run.c | 137 +++++++++++++++++++++++++--------------------
 1 file changed, 76 insertions(+), 61 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 58bcb8c849d5..33bd2f67e259 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -16,14 +16,82 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/bpf_test_run.h>
 
+struct test_timer {
+	enum { NO_PREEMPT, NO_MIGRATE } mode;
+	u32 i;
+	u64 time_start, time_spent;
+};
+
+static inline void t_enter(struct test_timer *t)
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
+static inline void t_leave(struct test_timer *t)
+{
+	t->time_spent += ktime_get_ns() - t->time_start;
+	t->time_start = 0;
+
+	if (t->mode == NO_PREEMPT)
+		preempt_enable();
+	else
+		migrate_enable();
+	rcu_read_unlock();
+}
+
+static inline bool t_check(struct test_timer *t, u32 repeat, int *err, u32 *duration)
+{
+	if (!t->time_start) {
+		/* Enter protected section before first iteration. */
+		t_enter(t);
+		return true;
+	}
+
+	t->i++;
+	if (t->i >= repeat) {
+		/* Leave the protected section after the last iteration. */
+		t_leave(t);
+		do_div(t->time_spent, t->i);
+		*duration = t->time_spent > U32_MAX ? U32_MAX : (u32)t->time_spent;
+		*err = 0;
+		goto reset;
+	}
+
+	if (signal_pending(current)) {
+		/* During iteration: we've been cancelled, abort. */
+		t_leave(t);
+		*err = -EINTR;
+		goto reset;
+	}
+
+	if (need_resched()) {
+		/* During iteration: we need to reschedule between runs. */
+		t_leave(t);
+		cond_resched();
+		t_enter(t);
+	}
+
+	/* Do another round. */
+	return true;
+
+reset:
+	t->time_spent = t->i = 0;
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
@@ -38,40 +106,14 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 	if (!repeat)
 		repeat = 1;
 
-	rcu_read_lock();
-	migrate_disable();
-	time_start = ktime_get_ns();
-	for (i = 0; i < repeat; i++) {
+	while (t_check(&t, repeat, &ret, time)) {
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
 	}
-	time_spent += ktime_get_ns() - time_start;
-	migrate_enable();
-	rcu_read_unlock();
-
-	do_div(time_spent, repeat);
-	*time = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
 
 	for_each_cgroup_storage_type(stype)
 		bpf_cgroup_storage_free(storage[stype]);
@@ -674,18 +716,17 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
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
@@ -721,39 +762,13 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	ctx.data = data;
 	ctx.data_end = (__u8 *)data + size;
 
-	rcu_read_lock();
-	preempt_disable();
-	time_start = ktime_get_ns();
-	for (i = 0; i < repeat; i++) {
+	while (t_check(&t, repeat, &ret, &duration)) {
 		retval = bpf_flow_dissect(prog, &ctx, eth->h_proto, ETH_HLEN,
 					  size, flags);
-
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
 	}
-	time_spent += ktime_get_ns() - time_start;
-	preempt_enable();
-	rcu_read_unlock();
 
-	do_div(time_spent, repeat);
-	duration = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
+	if (ret < 0)
+		goto out;
 
 	ret = bpf_test_finish(kattr, uattr, &flow_keys, sizeof(flow_keys),
 			      retval, duration);
-- 
2.27.0

