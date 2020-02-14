Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6B415EE32
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389143AbgBNQEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389938AbgBNQE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:04:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DA702467D;
        Fri, 14 Feb 2020 16:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696266;
        bh=a427hp4mAZ4+pNfuW2wAhJwG6Fz8yU/Bnkot/sV7VBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcknE9gE/ENF3zCkdTjivW2kxrtMBspk1ljOiC2/Ye6gLKHTvUidQJzTMvJUho7fA
         St42Hx6fYkKatwNwuFi4cnOeoAzEH4MDRz7UbPswLKoGIyfLUZqYsC4IbULDjiqvHr
         Ij7AjisonxBHrdamPKIhgwjlm87ik0B+kaOYM/xU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 118/459] bpf, sockmap: Don't sleep while holding RCU lock on tear-down
Date:   Fri, 14 Feb 2020 10:56:08 -0500
Message-Id: <20200214160149.11681-118-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit db6a5018b6e008c1d69c6628cdaa9541b8e70940 ]

rcu_read_lock is needed to protect access to psock inside sock_map_unref
when tearing down the map. However, we can't afford to sleep in lock_sock
while in RCU read-side critical section. Grab the RCU lock only after we
have locked the socket.

This fixes RCU warnings triggerable on a VM with 1 vCPU when free'ing a
sockmap/sockhash that contains at least one socket:

| =============================
| WARNING: suspicious RCU usage
| 5.5.0-04005-g8fc91b972b73 #450 Not tainted
| -----------------------------
| include/linux/rcupdate.h:272 Illegal context switch in RCU read-side critical section!
|
| other info that might help us debug this:
|
|
| rcu_scheduler_active = 2, debug_locks = 1
| 4 locks held by kworker/0:1/62:
|  #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
|  #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
|  #2: ffffffff82065d20 (rcu_read_lock){....}, at: sock_map_free+0x5/0x170
|  #3: ffff8881368c5df8 (&stab->lock){+...}, at: sock_map_free+0x64/0x170
|
| stack backtrace:
| CPU: 0 PID: 62 Comm: kworker/0:1 Not tainted 5.5.0-04005-g8fc91b972b73 #450
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
| Workqueue: events bpf_map_free_deferred
| Call Trace:
|  dump_stack+0x71/0xa0
|  ___might_sleep+0x105/0x190
|  lock_sock_nested+0x28/0x90
|  sock_map_free+0x95/0x170
|  bpf_map_free_deferred+0x58/0x80
|  process_one_work+0x260/0x5e0
|  worker_thread+0x4d/0x3e0
|  kthread+0x108/0x140
|  ? process_one_work+0x5e0/0x5e0
|  ? kthread_park+0x90/0x90
|  ret_from_fork+0x3a/0x50

| =============================
| WARNING: suspicious RCU usage
| 5.5.0-04005-g8fc91b972b73-dirty #452 Not tainted
| -----------------------------
| include/linux/rcupdate.h:272 Illegal context switch in RCU read-side critical section!
|
| other info that might help us debug this:
|
|
| rcu_scheduler_active = 2, debug_locks = 1
| 4 locks held by kworker/0:1/62:
|  #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
|  #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
|  #2: ffffffff82065d20 (rcu_read_lock){....}, at: sock_hash_free+0x5/0x1d0
|  #3: ffff888139966e00 (&htab->buckets[i].lock){+...}, at: sock_hash_free+0x92/0x1d0
|
| stack backtrace:
| CPU: 0 PID: 62 Comm: kworker/0:1 Not tainted 5.5.0-04005-g8fc91b972b73-dirty #452
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
| Workqueue: events bpf_map_free_deferred
| Call Trace:
|  dump_stack+0x71/0xa0
|  ___might_sleep+0x105/0x190
|  lock_sock_nested+0x28/0x90
|  sock_hash_free+0xec/0x1d0
|  bpf_map_free_deferred+0x58/0x80
|  process_one_work+0x260/0x5e0
|  worker_thread+0x4d/0x3e0
|  kthread+0x108/0x140
|  ? process_one_work+0x5e0/0x5e0
|  ? kthread_park+0x90/0x90
|  ret_from_fork+0x3a/0x50

Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20200206111652.694507-2-jakub@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index b16ff3b8c6503..085cef5857bbf 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -234,7 +234,6 @@ static void sock_map_free(struct bpf_map *map)
 	int i;
 
 	synchronize_rcu();
-	rcu_read_lock();
 	raw_spin_lock_bh(&stab->lock);
 	for (i = 0; i < stab->map.max_entries; i++) {
 		struct sock **psk = &stab->sks[i];
@@ -243,12 +242,13 @@ static void sock_map_free(struct bpf_map *map)
 		sk = xchg(psk, NULL);
 		if (sk) {
 			lock_sock(sk);
+			rcu_read_lock();
 			sock_map_unref(sk, psk);
+			rcu_read_unlock();
 			release_sock(sk);
 		}
 	}
 	raw_spin_unlock_bh(&stab->lock);
-	rcu_read_unlock();
 
 	/* wait for psock readers accessing its map link */
 	synchronize_rcu();
@@ -864,19 +864,19 @@ static void sock_hash_free(struct bpf_map *map)
 	int i;
 
 	synchronize_rcu();
-	rcu_read_lock();
 	for (i = 0; i < htab->buckets_num; i++) {
 		bucket = sock_hash_select_bucket(htab, i);
 		raw_spin_lock_bh(&bucket->lock);
 		hlist_for_each_entry_safe(elem, node, &bucket->head, node) {
 			hlist_del_rcu(&elem->node);
 			lock_sock(elem->sk);
+			rcu_read_lock();
 			sock_map_unref(elem->sk, elem);
+			rcu_read_unlock();
 			release_sock(elem->sk);
 		}
 		raw_spin_unlock_bh(&bucket->lock);
 	}
-	rcu_read_unlock();
 
 	/* wait for psock readers accessing its map link */
 	synchronize_rcu();
-- 
2.20.1

