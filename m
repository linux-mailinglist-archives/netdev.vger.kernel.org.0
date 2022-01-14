Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7170B48EB48
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 15:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbiANOJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 09:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbiANOJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 09:09:32 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8140CC061574;
        Fri, 14 Jan 2022 06:09:31 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id 193so10227457qkh.13;
        Fri, 14 Jan 2022 06:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qUKuxAJ4vvXBnCZ5Cp++Kv0NqUtoyv7zDYvbU0ZGaLw=;
        b=CuZyZMwPGGCdS62DEAznvCbAO9JS4ASe7AZTTgYdbWQTURfoT5y4Pt1i6qIUUVE8Ri
         wUsyOW0+C4nAyUamlYsgscifwF2bV5Nde0VJYebMmnb+ESSRpqvg50jduR7VYdOQMKhN
         egMHzWUHiLmmhV1Q/28dBzDqPtEtIKUC+DagloYuk1SVUum0cjwDY7BPyvllvZxvg9ps
         D4+7ocIdHd5iM90LaSkjla6TWHNkzVIdZl0RLzx92+EndzT6BQSPD/3pEimau9zzH4V2
         mbE5Yx9nOX+PJeNUrirDS+wRl520NsSGStdmjmiWAhk7h7Ig2QYrU8hIPt2p4OaYRrpa
         NuIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qUKuxAJ4vvXBnCZ5Cp++Kv0NqUtoyv7zDYvbU0ZGaLw=;
        b=s0Rr550Tgry03e50Z/EtJQSSZFmRgGu9gW9r279NgiOePCGf6dBoTteLsNIzmPeQCj
         DC88xf2Q5fiNHoRFM60gYxPuYAvy2eViSydMjY1BHcbh84PTZDdIQhc9I5z71q9oSqO5
         0xDkTMuD1IpHt2GIhAvD9V0soCOojpkJz+8g9rgAMNL7qMnH0u7f1kKiRInM6Pjc9hpT
         xGuKfjNM39boY3L6WpuT1Z18ucwWrzo3qsiSnIuBvE3wp+PI5m4MT2RIm+HYaIqIKq7W
         w+iPoiVjrohnSbHB3fJnHphz/tgQUwZN39qw/1nvQ3H1jblgMQrWzB7UD7QVZUBFsRhd
         qA8Q==
X-Gm-Message-State: AOAM530lE/c8R2vCczlOz9LfuomPcXs+L7vGq2OXjKY77V2HSngy5XvW
        fd6N3rfyAvhz1gfh5HCoM2ufdNAEP87YPw==
X-Google-Smtp-Source: ABdhPJxaJajErJ6AFGJIvPpCwzWjcRjv52zqBPD/JpVZ/VxUrzPaG6AORHQu+4q5rD7S9WYKYhWF0Q==
X-Received: by 2002:a05:620a:bc7:: with SMTP id s7mr6595178qki.334.1642169370390;
        Fri, 14 Jan 2022 06:09:30 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id u8sm3887175qkp.45.2022.01.14.06.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 06:09:29 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH net] mm: slub: fix a deadlock warning in kmem_cache_destroy
Date:   Fri, 14 Jan 2022 09:09:28 -0500
Message-Id: <388098b2c03fbf0a732834fc01b2d875c335bc49.1642169368.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cpus_read_lock() is introduced into kmem_cache_destroy() by
commit 5a836bf6b09f ("mm: slub: move flush_cpu_slab() invocations
__free_slab() invocations out of IRQ context"), and it could cause
a deadlock.

As Antoine pointed out, when one thread calls kmem_cache_destroy(), it is
blocking until kn->active becomes 0 in kernfs_drain() after holding
cpu_hotplug_lock. While in another thread, when calling kernfs_fop_write(),
it may try to hold cpu_hotplug_lock after incrementing kn->active by
calling kernfs_get_active():

        CPU0                        CPU1
        ----                        ----
  cpus_read_lock()
                                   kn->active++
                                   cpus_read_lock() [a]
  wait until kn->active == 0

Although cpu_hotplug_lock is a RWSEM, [a] will not block in there. But as
lockdep annotations are added for cpu_hotplug_lock, a deadlock warning
would be detected:

  ======================================================
  WARNING: possible circular locking dependency detected
  ------------------------------------------------------
  dmsetup/1832 is trying to acquire lock:
  ffff986f5a0f9f20 (kn->count#144){++++}-{0:0}, at: kernfs_remove+0x1d/0x30

  but task is already holding lock:
  ffffffffa43817c0 (slab_mutex){+.+.}-{3:3}, at: kmem_cache_destroy+0x2a/0x120

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #2 (slab_mutex){+.+.}-{3:3}:
         lock_acquire+0xe8/0x470
         mutex_lock_nested+0x47/0x80
         kmem_cache_destroy+0x2a/0x120
         bioset_exit+0xb5/0x100
         cleanup_mapped_device+0x26/0xf0 [dm_mod]
         free_dev+0x43/0xb0 [dm_mod]
         __dm_destroy+0x153/0x1b0 [dm_mod]
         dev_remove+0xe4/0x1a0 [dm_mod]
         ctl_ioctl+0x1af/0x3f0 [dm_mod]
         dm_ctl_ioctl+0xa/0x10 [dm_mod]
         do_vfs_ioctl+0xa5/0x760
         ksys_ioctl+0x60/0x90
         __x64_sys_ioctl+0x16/0x20
         do_syscall_64+0x8c/0x240
         entry_SYSCALL_64_after_hwframe+0x6a/0xdf

  -> #1 (cpu_hotplug_lock){++++}-{0:0}:
         lock_acquire+0xe8/0x470
         cpus_read_lock+0x39/0x100
         cpu_partial_store+0x44/0x80
         slab_attr_store+0x20/0x30
         kernfs_fop_write+0x101/0x1b0
         vfs_write+0xd4/0x1e0
         ksys_write+0x52/0xc0
         do_syscall_64+0x8c/0x240
         entry_SYSCALL_64_after_hwframe+0x6a/0xdf

  -> #0 (kn->count#144){++++}-{0:0}:
         check_prevs_add+0x185/0xb80
         __lock_acquire+0xd8f/0xe90
         lock_acquire+0xe8/0x470
         __kernfs_remove+0x25e/0x320
         kernfs_remove+0x1d/0x30
         kobject_del+0x28/0x60
         kmem_cache_destroy+0xf1/0x120
         bioset_exit+0xb5/0x100
         cleanup_mapped_device+0x26/0xf0 [dm_mod]
         free_dev+0x43/0xb0 [dm_mod]
         __dm_destroy+0x153/0x1b0 [dm_mod]
         dev_remove+0xe4/0x1a0 [dm_mod]
         ctl_ioctl+0x1af/0x3f0 [dm_mod]
         dm_ctl_ioctl+0xa/0x10 [dm_mod]
         do_vfs_ioctl+0xa5/0x760
         ksys_ioctl+0x60/0x90
         __x64_sys_ioctl+0x16/0x20
         do_syscall_64+0x8c/0x240
         entry_SYSCALL_64_after_hwframe+0x6a/0xdf

  other info that might help us debug this:

  Chain exists of:
    kn->count#144 --> cpu_hotplug_lock --> slab_mutex

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(slab_mutex);
                                 lock(cpu_hotplug_lock);
                                 lock(slab_mutex);
    lock(kn->count#144);

   *** DEADLOCK ***

  3 locks held by dmsetup/1832:
   #0: ffffffffa43fe5c0 (bio_slab_lock){+.+.}-{3:3}, at: bioset_exit+0x62/0x100
   #1: ffffffffa3e87c20 (cpu_hotplug_lock){++++}-{0:0}, at: kmem_cache_destroy+0x1c/0x120
   #2: ffffffffa43817c0 (slab_mutex){+.+.}-{3:3}, at: kmem_cache_destroy+0x2a/0x120

  stack backtrace:
  Call Trace:
   dump_stack+0x5c/0x80
   check_noncircular+0xff/0x120
   check_prevs_add+0x185/0xb80
   __lock_acquire+0xd8f/0xe90
   lock_acquire+0xe8/0x470
   __kernfs_remove+0x25e/0x320
   kernfs_remove+0x1d/0x30
   kobject_del+0x28/0x60
   kmem_cache_destroy+0xf1/0x120
   bioset_exit+0xb5/0x100
   cleanup_mapped_device+0x26/0xf0 [dm_mod]
   free_dev+0x43/0xb0 [dm_mod]
   __dm_destroy+0x153/0x1b0 [dm_mod]
   dev_remove+0xe4/0x1a0 [dm_mod]
   ctl_ioctl+0x1af/0x3f0 [dm_mod]
   dm_ctl_ioctl+0xa/0x10 [dm_mod]
   do_vfs_ioctl+0xa5/0x760
   ksys_ioctl+0x60/0x90
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x8c/0x240
   entry_SYSCALL_64_after_hwframe+0x6a/0xdf

Since cpus_read_lock() is supposed to protect the cpu related data, it
makes sense to fix this issue by moving cpus_read_lock() from
kmem_cache_destroy() to __kmem_cache_shutdown(). While at it,
add the missing cpus_read_lock() in slab_mem_going_offline_callback().

Fixes: 5a836bf6b09f ("mm: slub: move flush_cpu_slab() invocations __free_slab() invocations out of IRQ context")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 mm/slab_common.c | 2 --
 mm/slub.c        | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index e5d080a93009..06ec3fa585e6 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -494,7 +494,6 @@ void kmem_cache_destroy(struct kmem_cache *s)
 	if (unlikely(!s))
 		return;
 
-	cpus_read_lock();
 	mutex_lock(&slab_mutex);
 
 	s->refcount--;
@@ -509,7 +508,6 @@ void kmem_cache_destroy(struct kmem_cache *s)
 	}
 out_unlock:
 	mutex_unlock(&slab_mutex);
-	cpus_read_unlock();
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
diff --git a/mm/slub.c b/mm/slub.c
index abe7db581d68..754f020235ee 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4311,7 +4311,7 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 	int node;
 	struct kmem_cache_node *n;
 
-	flush_all_cpus_locked(s);
+	flush_all(s);
 	/* Attempt to free all objects */
 	for_each_kmem_cache_node(s, node, n) {
 		free_partial(s, n);
@@ -4646,7 +4646,7 @@ static int slab_mem_going_offline_callback(void *arg)
 
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list) {
-		flush_all_cpus_locked(s);
+		flush_all(s);
 		__kmem_cache_do_shrink(s);
 	}
 	mutex_unlock(&slab_mutex);
-- 
2.27.0

