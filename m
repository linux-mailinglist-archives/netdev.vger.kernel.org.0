Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0868031DAE
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 15:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbfFANYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 09:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728445AbfFANYs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 09:24:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A6862738C;
        Sat,  1 Jun 2019 13:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395486;
        bh=nuYqMwCwaG4PsWLR2mx2Ey/kaHUQDv6D9pf68XwKee0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h76C05+9JN+jchdMhc/kD5giIHKOfZF1i61nPydN2+VVg5Wt3YU9JvG/yTlXKcq07
         If05kiEjy+V6q8m6gWQyJdQQle5sSuMKSHNZHSh6YViunKYURPXbfy9brpK8Ngjxv2
         RRusKEhFhIuD203AzpU7l4183swHEUq2kjA6J3Fc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Sperbeck <jsperbeck@google.com>,
        Dennis Zhou <dennis@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 31/99] percpu: remove spurious lock dependency between percpu and sched
Date:   Sat,  1 Jun 2019 09:22:38 -0400
Message-Id: <20190601132346.26558-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132346.26558-1-sashal@kernel.org>
References: <20190601132346.26558-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Sperbeck <jsperbeck@google.com>

[ Upstream commit 198790d9a3aeaef5792d33a560020861126edc22 ]

In free_percpu() we sometimes call pcpu_schedule_balance_work() to
queue a work item (which does a wakeup) while holding pcpu_lock.
This creates an unnecessary lock dependency between pcpu_lock and
the scheduler's pi_lock.  There are other places where we call
pcpu_schedule_balance_work() without hold pcpu_lock, and this case
doesn't need to be different.

Moving the call outside the lock prevents the following lockdep splat
when running tools/testing/selftests/bpf/{test_maps,test_progs} in
sequence with lockdep enabled:

======================================================
WARNING: possible circular locking dependency detected
5.1.0-dbg-DEV #1 Not tainted
------------------------------------------------------
kworker/23:255/18872 is trying to acquire lock:
000000000bc79290 (&(&pool->lock)->rlock){-.-.}, at: __queue_work+0xb2/0x520

but task is already holding lock:
00000000e3e7a6aa (pcpu_lock){..-.}, at: free_percpu+0x36/0x260

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #4 (pcpu_lock){..-.}:
       lock_acquire+0x9e/0x180
       _raw_spin_lock_irqsave+0x3a/0x50
       pcpu_alloc+0xfa/0x780
       __alloc_percpu_gfp+0x12/0x20
       alloc_htab_elem+0x184/0x2b0
       __htab_percpu_map_update_elem+0x252/0x290
       bpf_percpu_hash_update+0x7c/0x130
       __do_sys_bpf+0x1912/0x1be0
       __x64_sys_bpf+0x1a/0x20
       do_syscall_64+0x59/0x400
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #3 (&htab->buckets[i].lock){....}:
       lock_acquire+0x9e/0x180
       _raw_spin_lock_irqsave+0x3a/0x50
       htab_map_update_elem+0x1af/0x3a0

-> #2 (&rq->lock){-.-.}:
       lock_acquire+0x9e/0x180
       _raw_spin_lock+0x2f/0x40
       task_fork_fair+0x37/0x160
       sched_fork+0x211/0x310
       copy_process.part.43+0x7b1/0x2160
       _do_fork+0xda/0x6b0
       kernel_thread+0x29/0x30
       rest_init+0x22/0x260
       arch_call_rest_init+0xe/0x10
       start_kernel+0x4fd/0x520
       x86_64_start_reservations+0x24/0x26
       x86_64_start_kernel+0x6f/0x72
       secondary_startup_64+0xa4/0xb0

-> #1 (&p->pi_lock){-.-.}:
       lock_acquire+0x9e/0x180
       _raw_spin_lock_irqsave+0x3a/0x50
       try_to_wake_up+0x41/0x600
       wake_up_process+0x15/0x20
       create_worker+0x16b/0x1e0
       workqueue_init+0x279/0x2ee
       kernel_init_freeable+0xf7/0x288
       kernel_init+0xf/0x180
       ret_from_fork+0x24/0x30

-> #0 (&(&pool->lock)->rlock){-.-.}:
       __lock_acquire+0x101f/0x12a0
       lock_acquire+0x9e/0x180
       _raw_spin_lock+0x2f/0x40
       __queue_work+0xb2/0x520
       queue_work_on+0x38/0x80
       free_percpu+0x221/0x260
       pcpu_freelist_destroy+0x11/0x20
       stack_map_free+0x2a/0x40
       bpf_map_free_deferred+0x3c/0x50
       process_one_work+0x1f7/0x580
       worker_thread+0x54/0x410
       kthread+0x10f/0x150
       ret_from_fork+0x24/0x30

other info that might help us debug this:

Chain exists of:
  &(&pool->lock)->rlock --> &htab->buckets[i].lock --> pcpu_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(pcpu_lock);
                               lock(&htab->buckets[i].lock);
                               lock(pcpu_lock);
  lock(&(&pool->lock)->rlock);

 *** DEADLOCK ***

3 locks held by kworker/23:255/18872:
 #0: 00000000b36a6e16 ((wq_completion)events){+.+.},
     at: process_one_work+0x17a/0x580
 #1: 00000000dfd966f0 ((work_completion)(&map->work)){+.+.},
     at: process_one_work+0x17a/0x580
 #2: 00000000e3e7a6aa (pcpu_lock){..-.},
     at: free_percpu+0x36/0x260

stack backtrace:
CPU: 23 PID: 18872 Comm: kworker/23:255 Not tainted 5.1.0-dbg-DEV #1
Hardware name: ...
Workqueue: events bpf_map_free_deferred
Call Trace:
 dump_stack+0x67/0x95
 print_circular_bug.isra.38+0x1c6/0x220
 check_prev_add.constprop.50+0x9f6/0xd20
 __lock_acquire+0x101f/0x12a0
 lock_acquire+0x9e/0x180
 _raw_spin_lock+0x2f/0x40
 __queue_work+0xb2/0x520
 queue_work_on+0x38/0x80
 free_percpu+0x221/0x260
 pcpu_freelist_destroy+0x11/0x20
 stack_map_free+0x2a/0x40
 bpf_map_free_deferred+0x3c/0x50
 process_one_work+0x1f7/0x580
 worker_thread+0x54/0x410
 kthread+0x10f/0x150
 ret_from_fork+0x24/0x30

Signed-off-by: John Sperbeck <jsperbeck@google.com>
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/percpu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 0c06e2f549a7b..bc58bcbe4b609 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1702,6 +1702,7 @@ void free_percpu(void __percpu *ptr)
 	struct pcpu_chunk *chunk;
 	unsigned long flags;
 	int off;
+	bool need_balance = false;
 
 	if (!ptr)
 		return;
@@ -1723,7 +1724,7 @@ void free_percpu(void __percpu *ptr)
 
 		list_for_each_entry(pos, &pcpu_slot[pcpu_nr_slots - 1], list)
 			if (pos != chunk) {
-				pcpu_schedule_balance_work();
+				need_balance = true;
 				break;
 			}
 	}
@@ -1731,6 +1732,9 @@ void free_percpu(void __percpu *ptr)
 	trace_percpu_free_percpu(chunk->base_addr, off, ptr);
 
 	spin_unlock_irqrestore(&pcpu_lock, flags);
+
+	if (need_balance)
+		pcpu_schedule_balance_work();
 }
 EXPORT_SYMBOL_GPL(free_percpu);
 
-- 
2.20.1

