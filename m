Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAB0154C6B
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 20:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgBFToJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 14:44:09 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46590 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727630AbgBFToJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 14:44:09 -0500
Received: by mail-pf1-f195.google.com with SMTP id k29so3625248pfp.13;
        Thu, 06 Feb 2020 11:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=9ZNQ/tjcK/xnRzrUxvCJM2Oya8zreqcVafMwq6s9Tjo=;
        b=bwkDpmS4aRgCTSde+wWjqm1aXXe6cTLZ+miuC24c+oQcKQSLem8kDUgM8VtuI2CsAO
         I+bHK3oqAowt0ycbVuc3ZgqNMpGhqrbIOB8l5LY2zUemdbNvKmM3O0zCVvrM70C7bU/h
         aQbSm0DfNJgXcrrd8UI9o/bfkjqMB8xJkpbq4NRCHQn7LuuIMSR9/fvRSoLYx8RgrcoE
         Sxfy33P5SWOTdSCCP4tFKsG37WSgfYi7WCa3B9w3nZaMssDg81+yOXRrBVsNplej/TAx
         7UVyseAXBz7d/8B/B4qY1wPgz6Abzw8U+7e1sJ8sEEvgjjvlBOGISvLoIUClenTjK/fG
         KBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=9ZNQ/tjcK/xnRzrUxvCJM2Oya8zreqcVafMwq6s9Tjo=;
        b=J/FmpTnHKnp142ihOlsO4yTqvvQU0Qph6I2RiR9Cig66C9DHZ+CVb/IHPgn3MAQ5Sc
         n0PyZDBZ6LGfg8znYK9Ul8sm8X6GkTdPbzGLTGMWWR+6oyYbr+G3g+dqejvRYt1GTxTy
         bF8MIhIiWfRgUaZnk+tkZAwPIx3+qhdRcXJkrWhCIaqgM1t7aVwqYsyFwqFyG917+2Bu
         BjFWgdY01S8cfFdRmAfV9uUM7Id/BBS+0cCQm/jQje8E5ObDQDnrzXoysD16AemEBc2T
         59K7r6U0086umDyGbBBMUSzQDoXyrijDykUrh66TxQrEMAzLWaPoMasIDdIb7h/vbIDH
         927A==
X-Gm-Message-State: APjAAAUp3PWEu2bguQY5Alj+VnFmBQCGioChB9tCAuN1yiUrj85pFR62
        pUhMVRofB61kLWNjkQX1Jn8=
X-Google-Smtp-Source: APXvYqzkF1dLhhv42xT4pMGvkfoJdATlSDgLmaoPpryj5H3DDB5WpoAnpOONq2untvFzawaKl7CX3A==
X-Received: by 2002:a63:e30e:: with SMTP id f14mr5699496pgh.260.1581018248256;
        Thu, 06 Feb 2020 11:44:08 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q66sm222194pfq.27.2020.02.06.11.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 11:44:07 -0800 (PST)
Date:   Thu, 06 Feb 2020 11:43:59 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5e3c6c7f8730e_22ad2af2cbd0a5b4a4@john-XPS-13-9370.notmuch>
In-Reply-To: <20200206111652.694507-1-jakub@cloudflare.com>
References: <20200206111652.694507-1-jakub@cloudflare.com>
Subject: RE: [PATCH bpf 0/3] Fix locking order and synchronization on
 sockmap/sockhash tear-down
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Couple of fixes that came from recent discussion [0] on commit
> 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down").
> 
> This series doesn't address the sleeping while holding a spinlock
> problem. We're still trying to decide how to fix that [1].
> 
> Until then sockmap users might see the following warnings:
> 
> | BUG: sleeping function called from invalid context at net/core/sock.c:2935
> | in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 62, name: kworker/0:1
> | 3 locks held by kworker/0:1/62:
> |  #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
> |  #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
> |  #2: ffff8881381f6df8 (&stab->lock){+...}, at: sock_map_free+0x26/0x180
> | CPU: 0 PID: 62 Comm: kworker/0:1 Not tainted 5.5.0-04008-g7b083332376e #454
> | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> | Workqueue: events bpf_map_free_deferred
> | Call Trace:
> |  dump_stack+0x71/0xa0
> |  ___might_sleep.cold+0xa6/0xb6
> |  lock_sock_nested+0x28/0x90
> |  sock_map_free+0x5f/0x180
> |  bpf_map_free_deferred+0x58/0x80
> |  process_one_work+0x260/0x5e0
> |  worker_thread+0x4d/0x3e0
> |  kthread+0x108/0x140
> |  ? process_one_work+0x5e0/0x5e0
> |  ? kthread_park+0x90/0x90
> |  ret_from_fork+0x3a/0x50
> |
> | ======================================================
> | WARNING: possible circular locking dependency detected
> | 5.5.0-04008-g7b083332376e #454 Tainted: G        W
> | ------------------------------------------------------
> | kworker/0:1/62 is trying to acquire lock:
> | ffff88813b280130 (sk_lock-AF_INET){+.+.}, at: sock_map_free+0x5f/0x180
> |
> | but task is already holding lock:
> | ffff8881381f6df8 (&stab->lock){+...}, at: sock_map_free+0x26/0x180
> |
> | which lock already depends on the new lock.
> |
> |
> | the existing dependency chain (in reverse order) is:
> |
> | -> #1 (&stab->lock){+...}:
> |        _raw_spin_lock_bh+0x39/0x80
> |        sock_map_update_common+0xdc/0x300
> |        sock_map_update_elem+0xc3/0x150
> |        __do_sys_bpf+0x1285/0x1620
> |        do_syscall_64+0x6d/0x690
> |        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> |
> | -> #0 (sk_lock-AF_INET){+.+.}:
> |        __lock_acquire+0xe2f/0x19f0
> |        lock_acquire+0x95/0x190
> |        lock_sock_nested+0x6b/0x90
> |        sock_map_free+0x5f/0x180
> |        bpf_map_free_deferred+0x58/0x80
> |        process_one_work+0x260/0x5e0
> |        worker_thread+0x4d/0x3e0
> |        kthread+0x108/0x140
> |        ret_from_fork+0x3a/0x50
> |
> | other info that might help us debug this:
> |
> |  Possible unsafe locking scenario:
> |
> |        CPU0                    CPU1
> |        ----                    ----
> |   lock(&stab->lock);
> |                                lock(sk_lock-AF_INET);
> |                                lock(&stab->lock);
> |   lock(sk_lock-AF_INET);
> |
> |  *** DEADLOCK ***
> |
> | 3 locks held by kworker/0:1/62:
> |  #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
> |  #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
> |  #2: ffff8881381f6df8 (&stab->lock){+...}, at: sock_map_free+0x26/0x180
> |
> | stack backtrace:
> | CPU: 0 PID: 62 Comm: kworker/0:1 Tainted: G        W         5.5.0-04008-g7b083332376e #454
> | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> | Workqueue: events bpf_map_free_deferred
> | Call Trace:
> |  dump_stack+0x71/0xa0
> |  check_noncircular+0x176/0x190
> |  __lock_acquire+0xe2f/0x19f0
> |  lock_acquire+0x95/0x190
> |  ? sock_map_free+0x5f/0x180
> |  lock_sock_nested+0x6b/0x90
> |  ? sock_map_free+0x5f/0x180
> |  sock_map_free+0x5f/0x180
> |  bpf_map_free_deferred+0x58/0x80
> |  process_one_work+0x260/0x5e0
> |  worker_thread+0x4d/0x3e0
> |  kthread+0x108/0x140
> |  ? process_one_work+0x5e0/0x5e0
> |  ? kthread_park+0x90/0x90
> |  ret_from_fork+0x3a/0x50

Hi Jakub,

Untested at the moment, but this should also be fine per your suggestion
(if I read it correctly).  The reason we have stab->lock and bucket->locks
here is to handle checking EEXIST in update/delete cases. We need to
be careful that when an update happens and we check for EEXIST that the
socket is added/removed during this check. So both map_update_common and
sock_map_delete need to guard from being run together potentially deleting
an entry we are checking, etc. But by the time we get here we just did
a synchronize_rcu() in the line above so no updates/deletes should be
in flight. So it seems safe to drop these locks because of the condition
no updates in flight.

So with patch below we keep the sync rcu but that is fine IMO these
map free's are rare. Take a look and make sure it seems sane to you
as well.

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index f36e13e577a3..1d56ec20330c 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -233,8 +233,11 @@ static void sock_map_free(struct bpf_map *map)
 	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
 	int i;
 
+	/* After the sync no updates or deletes will be in-flight so it
+	 * is safe to walk map and remove entries without risking a race
+	 * in EEXIST update case.
+	 */
 	synchronize_rcu();
-	raw_spin_lock_bh(&stab->lock);
 	for (i = 0; i < stab->map.max_entries; i++) {
 		struct sock **psk = &stab->sks[i];
 		struct sock *sk;
@@ -248,7 +251,6 @@ static void sock_map_free(struct bpf_map *map)
 			release_sock(sk);
 		}
 	}
-	raw_spin_unlock_bh(&stab->lock);
 
 	/* wait for psock readers accessing its map link */
 	synchronize_rcu();
@@ -859,10 +861,13 @@ static void sock_hash_free(struct bpf_map *map)
 	struct hlist_node *node;
 	int i;
 
+	/* After the sync no updates or deletes will be in-flight so it
+	 * is safe to walk hash and remove entries without risking a race
+	 * in EEXIST update case.
+	 */
 	synchronize_rcu();
 	for (i = 0; i < htab->buckets_num; i++) {
 		bucket = sock_hash_select_bucket(htab, i);
-		raw_spin_lock_bh(&bucket->lock);
 		hlist_for_each_entry_safe(elem, node, &bucket->head, node) {
 			hlist_del_rcu(&elem->node);
 			lock_sock(elem->sk);
@@ -871,7 +876,6 @@ static void sock_hash_free(struct bpf_map *map)
 			rcu_read_unlock();
 			release_sock(elem->sk);
 		}
-		raw_spin_unlock_bh(&bucket->lock);
 	}
 
 	/* wait for psock readers accessing its map link */
