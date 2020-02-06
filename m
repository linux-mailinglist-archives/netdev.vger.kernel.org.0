Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC421542DB
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 12:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgBFLRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 06:17:01 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55923 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbgBFLQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 06:16:59 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so5864197wmj.5
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 03:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vp+vDl/pzU9JrU2Dc/mI09oCS/BRTHaiEEraCiGW2Fo=;
        b=tgXJN8oJ1UOo4u3WNN0Lzp7JWAnFTw4vHZ4J7gIYInhpEF4iezl1eZ8xJE/tfe315n
         ldPYqr7xIJydXW4IQ9xEsv1Dlew0M3f4jM81FLXHTbU6Iy4N2DWiZyHmusJgwXxkVbwy
         x3ZEtruf1ScCJDdQp4gp/H0LeWkwR5Nw5b4U8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vp+vDl/pzU9JrU2Dc/mI09oCS/BRTHaiEEraCiGW2Fo=;
        b=UWu6WFLA2nckySwY9nGcswdT1oHN5aBmL4Fc0+00KRNs9ofjCW3Ch7x1pisuxmiivF
         DF5y01bEqPztIvsjHQANeXJLOd5pvh7bXJs2DL7Bap38y3dZjHMoiCku+nwEVs906JSK
         vf/rulIMDubbFa/2IJCRhHWpzgZz28+eKCAO0fL0H8ze6ky22Tif/VndppWmr3GHfiVg
         NFfj25UOtiij+foabtZoZKOU4e0nZOdwbmIHaDcpxXdhJ09h8Nt0shIOhq4/rh5dVl+b
         1pyXPj8dJUZYBPyvD6KZh9s1eq61TmJQoSDKsS85zKmqYCPQhNZfdb+8isDT6JkcuACr
         Q8LQ==
X-Gm-Message-State: APjAAAWaFSCwhX8vXgb/Q9txVhwucaEy42vzmrB8QpQuKfcUlRhv4FfC
        aQwR+Rq0qrwsMbJvkGEqxywmFA==
X-Google-Smtp-Source: APXvYqxawLrnOW+JxfLsQ4WA0Dd2McGfrnr8aHrmbAEaYfH08b9S0sKaFqhjF/ALdoE2U01CMZ2YJg==
X-Received: by 2002:a1c:e388:: with SMTP id a130mr3972503wmh.176.1580987816831;
        Thu, 06 Feb 2020 03:16:56 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id s16sm3822609wrn.78.2020.02.06.03.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 03:16:56 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf 1/3] bpf, sockmap: Don't sleep while holding RCU lock on tear-down
Date:   Thu,  6 Feb 2020 12:16:50 +0100
Message-Id: <20200206111652.694507-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206111652.694507-1-jakub@cloudflare.com>
References: <20200206111652.694507-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/core/sock_map.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 8998e356f423..fd8b426dbdf3 100644
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
 
 	synchronize_rcu();
 
@@ -859,19 +859,19 @@ static void sock_hash_free(struct bpf_map *map)
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
 
 	bpf_map_area_free(htab->buckets);
 	kfree(htab);
-- 
2.24.1

