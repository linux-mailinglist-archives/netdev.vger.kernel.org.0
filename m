Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97D3295A1F
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895336AbgJVIWo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 04:22:44 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:49840 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895326AbgJVIWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:22:43 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-cT-TqApdPra38tpPbLZk1A-1; Thu, 22 Oct 2020 04:22:36 -0400
X-MC-Unique: cT-TqApdPra38tpPbLZk1A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4A1F107ACF5;
        Thu, 22 Oct 2020 08:22:34 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C529160BFA;
        Thu, 22 Oct 2020 08:22:31 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: [RFC bpf-next 12/16] bpf: Move synchronize_rcu_mult for batch processing (NOT TO BE MERGED)
Date:   Thu, 22 Oct 2020 10:21:34 +0200
Message-Id: <20201022082138.2322434-13-jolsa@kernel.org>
In-Reply-To: <20201022082138.2322434-1-jolsa@kernel.org>
References: <20201022082138.2322434-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I noticed some of the profiled workloads did not spend more cycles,
but took more time to finish than current code. I tracked it to rcu
synchronize_rcu_mult call in bpf_trampoline_update and when I called
it just once for batch mode it got faster.

The current processing when attaching the program is:

  for each program:
    bpf(BPF_RAW_TRACEPOINT_OPEN
      bpf_tracing_prog_attach
        bpf_trampoline_link_prog
          bpf_trampoline_update
            synchronize_rcu_mult
            register_ftrace_direct

With the change the synchronize_rcu_mult is called just once:

  bpf(BPF_TRAMPOLINE_BATCH_ATTACH
    for each program:
      bpf_tracing_prog_attach
        bpf_trampoline_link_prog
          bpf_trampoline_update

    synchronize_rcu_mult
    register_ftrace_direct_ips

I'm not sure this does not break stuff, because I don't follow rcu
code that much ;-) However stats are nicer now:

Before:

 Performance counter stats for './test_progs -t attach_test' (5 runs):

        37,410,887      cycles:k             ( +-  0.98% )
        70,062,158      cycles:u             ( +-  0.39% )

             26.80 +- 4.10 seconds time elapsed  ( +- 15.31% )

After:

 Performance counter stats for './test_progs -t attach_test' (5 runs):

        36,812,432      cycles:k             ( +-  2.52% )
        69,907,191      cycles:u             ( +-  0.38% )

             15.04 +- 2.94 seconds time elapsed  ( +- 19.54% )

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/syscall.c    | 3 +++
 kernel/bpf/trampoline.c | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 19fb608546c0..b315803c34d3 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -31,6 +31,7 @@
 #include <linux/poll.h>
 #include <linux/bpf-netns.h>
 #include <linux/rcupdate_trace.h>
+#include <linux/rcupdate_wait.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -2920,6 +2921,8 @@ static int bpf_trampoline_batch(const union bpf_attr *attr, int cmd)
 	if (!batch)
 		goto out_clean;
 
+	synchronize_rcu_mult(call_rcu_tasks, call_rcu_tasks_trace);
+
 	for (i = 0; i < count; i++) {
 		if (cmd == BPF_TRAMPOLINE_BATCH_ATTACH) {
 			prog = bpf_prog_get(in[i]);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index cdad87461e5d..0d5e4c5860a9 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -271,7 +271,8 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr,
 	 * programs finish executing.
 	 * Wait for these two grace periods together.
 	 */
-	synchronize_rcu_mult(call_rcu_tasks, call_rcu_tasks_trace);
+	if (!batch)
+		synchronize_rcu_mult(call_rcu_tasks, call_rcu_tasks_trace);
 
 	err = arch_prepare_bpf_trampoline(new_image, new_image + PAGE_SIZE / 2,
 					  &tr->func.model, flags, tprogs,
-- 
2.26.2

