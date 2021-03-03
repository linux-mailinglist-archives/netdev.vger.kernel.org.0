Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAF332C3FE
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358133AbhCDAJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842968AbhCCKXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:23:10 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FEBC08ED8A
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 02:18:28 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id 7so23048395wrz.0
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 02:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ry5J4a9N98/oqPeG+RhxIKJ1SK0Aofvu/gThErXYALE=;
        b=d0akl/RnPj1N0pool0QoTfE3vhNviLewOTNySsS84KcNFX76QHDeLg3FMaoB5JDXBB
         nsISWZZ6EnxgbrQbGGXv91mByN3+KiB10hCMB5ZMre7PRcGGBsP+NG6Hc2YZdNcsexXj
         XOdlj6paG/RONNa3oblCs0dkk+PbxRdnnKzmA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ry5J4a9N98/oqPeG+RhxIKJ1SK0Aofvu/gThErXYALE=;
        b=JGYs6xEbpMXK4jbrofYpTtjEcwRUEua2Kl64Yov27mFRIqGgJY8suy8OmQv4mRSPlx
         CRn96YJV/5eGgk/aboTNm8wlCmK5J44cXeVjmscCZs1loePr7kDtyUA0pqeHeQFW41+j
         pG8KNC2eZSYcx0WZU1wtV2gXXovjepZyxfz3O8iF5vurNvxU/9Ujm6ZIGfDgIFk2E4N8
         caIHRkV2G85pkZ/+dVL32RY1btPAbaU9N4+puHQG2HhCg53GCsWCazEUXP9jlW8t/AaT
         FpQRGiMF4iXrfaG42oezVxSIJ4os63+WXBFnMMdVgHYApIR0DGM4FFWyqh7NJge4Klah
         XCNA==
X-Gm-Message-State: AOAM530et41lBpmiLJRK5pBOlVRJ5mREqH09KP0Zo5LasbUaGgxk1Orp
        W+gaG5DVxzrUyb/IBmeIUowHLw==
X-Google-Smtp-Source: ABdhPJzU9tsGMV1crO09r+Lhdb2i47NzPwCuLW5JqrOu0/OXDhmAFv90djlrF7MKGUNxKkC2veXBkQ==
X-Received: by 2002:adf:f7cc:: with SMTP id a12mr26558779wrq.54.1614766707263;
        Wed, 03 Mar 2021 02:18:27 -0800 (PST)
Received: from localhost.localdomain (c.a.8.8.c.1.2.8.8.7.0.2.6.c.a.1.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:1ac6:2078:821c:88ac])
        by smtp.gmail.com with ESMTPSA id r26sm1710761wmn.28.2021.03.03.02.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 02:18:26 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v4 1/5] bpf: consolidate shared test timing code
Date:   Wed,  3 Mar 2021 10:18:12 +0000
Message-Id: <20210303101816.36774-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303101816.36774-1-lmb@cloudflare.com>
References: <20210303101816.36774-1-lmb@cloudflare.com>
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
index 58bcb8c849d5..eb3c78cd4d7c 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -16,14 +16,78 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/bpf_test_run.h>
 
+struct bpf_test_timer {
+	enum { NO_PREEMPT, NO_MIGRATE } mode;
+	u32 i;
+	u64 time_start, time_spent;
+};
+
+static void bpf_test_timer_enter(struct bpf_test_timer *t)
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
+static void bpf_test_timer_leave(struct bpf_test_timer *t)
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
+static bool bpf_test_timer_continue(struct bpf_test_timer *t, u32 repeat, int *err, u32 *duration)
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
+		bpf_test_timer_leave(t);
+		cond_resched();
+		bpf_test_timer_enter(t);
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
+	struct bpf_test_timer t = { NO_MIGRATE };
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
+	bpf_test_timer_enter(&t);
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
+	} while (bpf_test_timer_continue(&t, repeat, &ret, time));
+	bpf_test_timer_leave(&t);
 
 	for_each_cgroup_storage_type(stype)
 		bpf_cgroup_storage_free(storage[stype]);
@@ -674,18 +714,17 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 				     const union bpf_attr *kattr,
 				     union bpf_attr __user *uattr)
 {
+	struct bpf_test_timer t = { NO_PREEMPT };
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
+	bpf_test_timer_enter(&t);
+	do {
 		retval = bpf_flow_dissect(prog, &ctx, eth->h_proto, ETH_HLEN,
 					  size, flags);
+	} while (bpf_test_timer_continue(&t, repeat, &ret, &duration));
+	bpf_test_timer_leave(&t);
 
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

