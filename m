Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D682115FEE
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 01:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfLHAEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 19:04:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44980 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbfLHAEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 19:04:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 444D215449D81;
        Sat,  7 Dec 2019 16:04:43 -0800 (PST)
Date:   Sat, 07 Dec 2019 16:04:42 -0800 (PST)
Message-Id: <20191207.160442.1447373592334938477.davem@davemloft.net>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
CC:     ast@kernel.org, daniel@iogearbox.net, tglx@linutronix.de
Subject: [RFC v1 PATCH 5/7] bpf: Use bpf prog locking in trampoline code.
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 16:04:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Instead of preemption disable/enable.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 kernel/bpf/trampoline.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 7e89f1f49d77..52e39892fec4 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -195,8 +195,8 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 	mutex_unlock(&trampoline_mutex);
 }
 
-/* The logic is similar to BPF_PROG_RUN, but with explicit rcu and preempt that
- * are needed for trampoline. The macro is split into
+/* The logic is similar to BPF_PROG_RUN, but with explicit rcu and bpf
+ * prog lock that are needed for trampoline. The macro is split into
  * call _bpf_prog_enter
  * call prog->bpf_func
  * call __bpf_prog_exit
@@ -206,7 +206,7 @@ u64 notrace __bpf_prog_enter(void)
 	u64 start = 0;
 
 	rcu_read_lock();
-	preempt_disable();
+	bpf_prog_lock();
 	if (static_branch_unlikely(&bpf_stats_enabled_key))
 		start = sched_clock();
 	return start;
@@ -229,7 +229,7 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
 		stats->nsecs += sched_clock() - start;
 		u64_stats_update_end(&stats->syncp);
 	}
-	preempt_enable();
+	bpf_prog_unlock();
 	rcu_read_unlock();
 }
 
-- 
2.20.1

