Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825CD2252A2
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 17:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgGSPwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 11:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgGSPwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 11:52:54 -0400
Received: from localhost.localdomain (unknown [151.48.143.159])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 832A8207EA;
        Sun, 19 Jul 2020 15:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595173974;
        bh=LrxoiroEENFNCeizEzCr/tyUfuQ+rpnoYmHgj4YUMKI=;
        h=From:To:Cc:Subject:Date:From;
        b=fGYVqLsZEB2JT9aUTmQQmTUe2ige7vWfkAIfL9TcrzDPBHzTjS+lYLoY1D4RFl4uV
         2X0Qz0zXmB5EDySxAz1aHIEcR/XhyiWU9VYE0XNCt2KLWMnQzzItqy+k7cnEt11tyq
         VSAMXvbjgcB62l7GGY9C6UUleT0rj/A9I8sBK8H8=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        jakub@cloudflare.com, kuba@kernel.org
Subject: [PATCH bpf-next] bpf: cpumap: fix possible rcpu kthread hung
Date:   Sun, 19 Jul 2020 17:52:41 +0200
Message-Id: <e54f2aabf959f298939e5507b09c48f8c2e380be.1595170625.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following cpumap kthread hung. The issue is currently occurring
when __cpu_map_load_bpf_program fails (e.g if the bpf prog has not
BPF_XDP_CPUMAP as expected_attach_type)

$./test_progs -n 101
101/1 cpumap_with_progs:OK
101 xdp_cpumap_attach:OK
Summary: 1/1 PASSED, 0 SKIPPED, 0 FAILED
[  369.996478] INFO: task cpumap/0/map:7:205 blocked for more than 122 seconds.
[  369.998463]       Not tainted 5.8.0-rc4-01472-ge57892f50a07 #212
[  370.000102] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  370.001918] cpumap/0/map:7  D    0   205      2 0x00004000
[  370.003228] Call Trace:
[  370.003930]  __schedule+0x5c7/0xf50
[  370.004901]  ? io_schedule_timeout+0xb0/0xb0
[  370.005934]  ? static_obj+0x31/0x80
[  370.006788]  ? mark_held_locks+0x24/0x90
[  370.007752]  ? cpu_map_bpf_prog_run_xdp+0x6c0/0x6c0
[  370.008930]  schedule+0x6f/0x160
[  370.009728]  schedule_preempt_disabled+0x14/0x20
[  370.010829]  kthread+0x17b/0x240
[  370.011433]  ? kthread_create_worker_on_cpu+0xd0/0xd0
[  370.011944]  ret_from_fork+0x1f/0x30
[  370.012348]
               Showing all locks held in the system:
[  370.013025] 1 lock held by khungtaskd/33:
[  370.013432]  #0: ffffffff82b24720 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x28/0x1c3

[  370.014461] =============================================

Fixes: 9216477449f3 ("bpf: cpumap: Add the possibility to attach an eBPF program to cpumap")
Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 kernel/bpf/cpumap.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 4c95d0615ca2..f1c46529929b 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -453,24 +453,27 @@ __cpu_map_entry_alloc(struct bpf_cpumap_val *value, u32 cpu, int map_id)
 	rcpu->map_id = map_id;
 	rcpu->value.qsize  = value->qsize;
 
+	if (fd > 0 && __cpu_map_load_bpf_program(rcpu, fd))
+		goto free_ptr_ring;
+
 	/* Setup kthread */
 	rcpu->kthread = kthread_create_on_node(cpu_map_kthread_run, rcpu, numa,
 					       "cpumap/%d/map:%d", cpu, map_id);
 	if (IS_ERR(rcpu->kthread))
-		goto free_ptr_ring;
+		goto free_prog;
 
 	get_cpu_map_entry(rcpu); /* 1-refcnt for being in cmap->cpu_map[] */
 	get_cpu_map_entry(rcpu); /* 1-refcnt for kthread */
 
-	if (fd > 0 && __cpu_map_load_bpf_program(rcpu, fd))
-		goto free_ptr_ring;
-
 	/* Make sure kthread runs on a single CPU */
 	kthread_bind(rcpu->kthread, cpu);
 	wake_up_process(rcpu->kthread);
 
 	return rcpu;
 
+free_prog:
+	if (rcpu->prog)
+		bpf_prog_put(rcpu->prog);
 free_ptr_ring:
 	ptr_ring_cleanup(rcpu->queue, NULL);
 free_queue:
-- 
2.26.2

