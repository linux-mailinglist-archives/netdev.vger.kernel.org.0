Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FE335DE76
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238296AbhDMMQS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Apr 2021 08:16:18 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:32521 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239738AbhDMMQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:16:14 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-sXv1wqZIML6AklquvXHiTw-1; Tue, 13 Apr 2021 08:15:48 -0400
X-MC-Unique: sXv1wqZIML6AklquvXHiTw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54EF81005E4C;
        Tue, 13 Apr 2021 12:15:24 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.196.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 140A210023B0;
        Tue, 13 Apr 2021 12:15:20 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCHv2 RFC bpf-next 1/7] bpf: Move bpf_prog_start/end functions to generic place
Date:   Tue, 13 Apr 2021 14:15:10 +0200
Message-Id: <20210413121516.1467989-2-jolsa@kernel.org>
In-Reply-To: <20210413121516.1467989-1-jolsa@kernel.org>
References: <20210413121516.1467989-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Moving bpf_prog_start/end functions plus related static
functions to generic place. So they can be used also when
trampolines are disabled.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/syscall.c    | 97 +++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/trampoline.c | 97 -----------------------------------------
 2 files changed, 97 insertions(+), 97 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6428634da57e..90cd58520bd4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4494,3 +4494,100 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 
 	return err;
 }
+
+#define NO_START_TIME 1
+static u64 notrace bpf_prog_start_time(void)
+{
+	u64 start = NO_START_TIME;
+
+	if (static_branch_unlikely(&bpf_stats_enabled_key)) {
+		start = sched_clock();
+		if (unlikely(!start))
+			start = NO_START_TIME;
+	}
+	return start;
+}
+
+static void notrace inc_misses_counter(struct bpf_prog *prog)
+{
+	struct bpf_prog_stats *stats;
+
+	stats = this_cpu_ptr(prog->stats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->misses++;
+	u64_stats_update_end(&stats->syncp);
+}
+
+/* The logic is similar to BPF_PROG_RUN, but with an explicit
+ * rcu_read_lock() and migrate_disable() which are required
+ * for the trampoline. The macro is split into
+ * call __bpf_prog_enter
+ * call prog->bpf_func
+ * call __bpf_prog_exit
+ *
+ * __bpf_prog_enter returns:
+ * 0 - skip execution of the bpf prog
+ * 1 - execute bpf prog
+ * [2..MAX_U64] - excute bpf prog and record execution time.
+ *     This is start time.
+ */
+u64 notrace __bpf_prog_enter(struct bpf_prog *prog)
+	__acquires(RCU)
+{
+	rcu_read_lock();
+	migrate_disable();
+	if (unlikely(__this_cpu_inc_return(*(prog->active)) != 1)) {
+		inc_misses_counter(prog);
+		return 0;
+	}
+	return bpf_prog_start_time();
+}
+
+static void notrace update_prog_stats(struct bpf_prog *prog,
+				      u64 start)
+{
+	struct bpf_prog_stats *stats;
+
+	if (static_branch_unlikely(&bpf_stats_enabled_key) &&
+	    /* static_key could be enabled in __bpf_prog_enter*
+	     * and disabled in __bpf_prog_exit*.
+	     * And vice versa.
+	     * Hence check that 'start' is valid.
+	     */
+	    start > NO_START_TIME) {
+		stats = this_cpu_ptr(prog->stats);
+		u64_stats_update_begin(&stats->syncp);
+		stats->cnt++;
+		stats->nsecs += sched_clock() - start;
+		u64_stats_update_end(&stats->syncp);
+	}
+}
+
+void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
+	__releases(RCU)
+{
+	update_prog_stats(prog, start);
+	__this_cpu_dec(*(prog->active));
+	migrate_enable();
+	rcu_read_unlock();
+}
+
+u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog)
+{
+	rcu_read_lock_trace();
+	migrate_disable();
+	might_fault();
+	if (unlikely(__this_cpu_inc_return(*(prog->active)) != 1)) {
+		inc_misses_counter(prog);
+		return 0;
+	}
+	return bpf_prog_start_time();
+}
+
+void notrace __bpf_prog_exit_sleepable(struct bpf_prog *prog, u64 start)
+{
+	update_prog_stats(prog, start);
+	__this_cpu_dec(*(prog->active));
+	migrate_enable();
+	rcu_read_unlock_trace();
+}
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 1f3a4be4b175..951cad26c5a9 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -489,103 +489,6 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 	mutex_unlock(&trampoline_mutex);
 }
 
-#define NO_START_TIME 1
-static u64 notrace bpf_prog_start_time(void)
-{
-	u64 start = NO_START_TIME;
-
-	if (static_branch_unlikely(&bpf_stats_enabled_key)) {
-		start = sched_clock();
-		if (unlikely(!start))
-			start = NO_START_TIME;
-	}
-	return start;
-}
-
-static void notrace inc_misses_counter(struct bpf_prog *prog)
-{
-	struct bpf_prog_stats *stats;
-
-	stats = this_cpu_ptr(prog->stats);
-	u64_stats_update_begin(&stats->syncp);
-	stats->misses++;
-	u64_stats_update_end(&stats->syncp);
-}
-
-/* The logic is similar to BPF_PROG_RUN, but with an explicit
- * rcu_read_lock() and migrate_disable() which are required
- * for the trampoline. The macro is split into
- * call __bpf_prog_enter
- * call prog->bpf_func
- * call __bpf_prog_exit
- *
- * __bpf_prog_enter returns:
- * 0 - skip execution of the bpf prog
- * 1 - execute bpf prog
- * [2..MAX_U64] - excute bpf prog and record execution time.
- *     This is start time.
- */
-u64 notrace __bpf_prog_enter(struct bpf_prog *prog)
-	__acquires(RCU)
-{
-	rcu_read_lock();
-	migrate_disable();
-	if (unlikely(__this_cpu_inc_return(*(prog->active)) != 1)) {
-		inc_misses_counter(prog);
-		return 0;
-	}
-	return bpf_prog_start_time();
-}
-
-static void notrace update_prog_stats(struct bpf_prog *prog,
-				      u64 start)
-{
-	struct bpf_prog_stats *stats;
-
-	if (static_branch_unlikely(&bpf_stats_enabled_key) &&
-	    /* static_key could be enabled in __bpf_prog_enter*
-	     * and disabled in __bpf_prog_exit*.
-	     * And vice versa.
-	     * Hence check that 'start' is valid.
-	     */
-	    start > NO_START_TIME) {
-		stats = this_cpu_ptr(prog->stats);
-		u64_stats_update_begin(&stats->syncp);
-		stats->cnt++;
-		stats->nsecs += sched_clock() - start;
-		u64_stats_update_end(&stats->syncp);
-	}
-}
-
-void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
-	__releases(RCU)
-{
-	update_prog_stats(prog, start);
-	__this_cpu_dec(*(prog->active));
-	migrate_enable();
-	rcu_read_unlock();
-}
-
-u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog)
-{
-	rcu_read_lock_trace();
-	migrate_disable();
-	might_fault();
-	if (unlikely(__this_cpu_inc_return(*(prog->active)) != 1)) {
-		inc_misses_counter(prog);
-		return 0;
-	}
-	return bpf_prog_start_time();
-}
-
-void notrace __bpf_prog_exit_sleepable(struct bpf_prog *prog, u64 start)
-{
-	update_prog_stats(prog, start);
-	__this_cpu_dec(*(prog->active));
-	migrate_enable();
-	rcu_read_unlock_trace();
-}
-
 void notrace __bpf_tramp_enter(struct bpf_tramp_image *tr)
 {
 	percpu_ref_get(&tr->pcref);
-- 
2.30.2

