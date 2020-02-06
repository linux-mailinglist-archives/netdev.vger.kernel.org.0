Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA461542DC
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 12:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgBFLRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 06:17:03 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33471 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbgBFLQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 06:16:58 -0500
Received: by mail-wr1-f68.google.com with SMTP id u6so6696491wrt.0
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 03:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1OgZjMiLWNnAgKB8dAEkHOVKRVeaBJzQ1MB3Kd7Onc8=;
        b=T9TWvEBNzmm/2Rcv2PuYqS7+mG7wUzuiPoW3+ZVw4PdyYijSUVMsIAuHjKKe3zypr2
         I0K1zhdlc1SHDNsGEmE/njedWUyvaAyiCilWW6N+5MGRbIoxtwttzj91SFcoRpLHJS2E
         WEs6eKk2aT5WvEUFaubuQgwR5zmQNuu3Vvx04=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1OgZjMiLWNnAgKB8dAEkHOVKRVeaBJzQ1MB3Kd7Onc8=;
        b=BJhehdNxJjOeKWGXZgWXbjyQ57soWHVMnYIcJuc+G6aZRzXazJRRWCGIdjVZBAKPXg
         Tz0I4caixfDj/DJKjTvcVLLIcPV5aBBQk5eHndXPELw9g2tRch2ToU/xE44AMuOhaPvy
         RP2l4F5nbbNEE8GvEhkkOGOeYBadoBcyDzjW7sZKlxIG1oMYyCYKW7zFOhMjSgsC5sea
         5+j/L7HfTr1flDYQTIXVL6SCv6Z/eyYXnFSLrgzT8xIU3n8Jb91mEx1x3bz/H51FVVtS
         ZkOndClBDQYSNzj1vQefydrx2NX5QQ2qqrWhYcsH0/fNv9t7t7/Ey3YA4ytLtExHCE+a
         kvGw==
X-Gm-Message-State: APjAAAVSoZh2i7TQZMMOTT+2BYMHWo2MwzaDJiBGsGeNdh6Wj4Naapsx
        UXwhsdQJLDkvuFgwU3xMkr62pg==
X-Google-Smtp-Source: APXvYqxhQVtc1FSZmOMfXzpMqI8IKwEcfk59uSM56sTM9QGrM84fwmuMRjt+RH2bMMiS9G2HGddLNg==
X-Received: by 2002:a5d:4289:: with SMTP id k9mr3417323wrq.280.1580987815038;
        Thu, 06 Feb 2020 03:16:55 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id z11sm3723877wrv.96.2020.02.06.03.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 03:16:53 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf 0/3] Fix locking order and synchronization on sockmap/sockhash tear-down
Date:   Thu,  6 Feb 2020 12:16:49 +0100
Message-Id: <20200206111652.694507-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Couple of fixes that came from recent discussion [0] on commit
7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down").

This series doesn't address the sleeping while holding a spinlock
problem. We're still trying to decide how to fix that [1].

Until then sockmap users might see the following warnings:

| BUG: sleeping function called from invalid context at net/core/sock.c:2935
| in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 62, name: kworker/0:1
| 3 locks held by kworker/0:1/62:
|  #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
|  #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
|  #2: ffff8881381f6df8 (&stab->lock){+...}, at: sock_map_free+0x26/0x180
| CPU: 0 PID: 62 Comm: kworker/0:1 Not tainted 5.5.0-04008-g7b083332376e #454
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
| Workqueue: events bpf_map_free_deferred
| Call Trace:
|  dump_stack+0x71/0xa0
|  ___might_sleep.cold+0xa6/0xb6
|  lock_sock_nested+0x28/0x90
|  sock_map_free+0x5f/0x180
|  bpf_map_free_deferred+0x58/0x80
|  process_one_work+0x260/0x5e0
|  worker_thread+0x4d/0x3e0
|  kthread+0x108/0x140
|  ? process_one_work+0x5e0/0x5e0
|  ? kthread_park+0x90/0x90
|  ret_from_fork+0x3a/0x50
|
| ======================================================
| WARNING: possible circular locking dependency detected
| 5.5.0-04008-g7b083332376e #454 Tainted: G        W
| ------------------------------------------------------
| kworker/0:1/62 is trying to acquire lock:
| ffff88813b280130 (sk_lock-AF_INET){+.+.}, at: sock_map_free+0x5f/0x180
|
| but task is already holding lock:
| ffff8881381f6df8 (&stab->lock){+...}, at: sock_map_free+0x26/0x180
|
| which lock already depends on the new lock.
|
|
| the existing dependency chain (in reverse order) is:
|
| -> #1 (&stab->lock){+...}:
|        _raw_spin_lock_bh+0x39/0x80
|        sock_map_update_common+0xdc/0x300
|        sock_map_update_elem+0xc3/0x150
|        __do_sys_bpf+0x1285/0x1620
|        do_syscall_64+0x6d/0x690
|        entry_SYSCALL_64_after_hwframe+0x49/0xbe
|
| -> #0 (sk_lock-AF_INET){+.+.}:
|        __lock_acquire+0xe2f/0x19f0
|        lock_acquire+0x95/0x190
|        lock_sock_nested+0x6b/0x90
|        sock_map_free+0x5f/0x180
|        bpf_map_free_deferred+0x58/0x80
|        process_one_work+0x260/0x5e0
|        worker_thread+0x4d/0x3e0
|        kthread+0x108/0x140
|        ret_from_fork+0x3a/0x50
|
| other info that might help us debug this:
|
|  Possible unsafe locking scenario:
|
|        CPU0                    CPU1
|        ----                    ----
|   lock(&stab->lock);
|                                lock(sk_lock-AF_INET);
|                                lock(&stab->lock);
|   lock(sk_lock-AF_INET);
|
|  *** DEADLOCK ***
|
| 3 locks held by kworker/0:1/62:
|  #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
|  #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
|  #2: ffff8881381f6df8 (&stab->lock){+...}, at: sock_map_free+0x26/0x180
|
| stack backtrace:
| CPU: 0 PID: 62 Comm: kworker/0:1 Tainted: G        W         5.5.0-04008-g7b083332376e #454
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
| Workqueue: events bpf_map_free_deferred
| Call Trace:
|  dump_stack+0x71/0xa0
|  check_noncircular+0x176/0x190
|  __lock_acquire+0xe2f/0x19f0
|  lock_acquire+0x95/0x190
|  ? sock_map_free+0x5f/0x180
|  lock_sock_nested+0x6b/0x90
|  ? sock_map_free+0x5f/0x180
|  sock_map_free+0x5f/0x180
|  bpf_map_free_deferred+0x58/0x80
|  process_one_work+0x260/0x5e0
|  worker_thread+0x4d/0x3e0
|  kthread+0x108/0x140
|  ? process_one_work+0x5e0/0x5e0
|  ? kthread_park+0x90/0x90
|  ret_from_fork+0x3a/0x50

[0] https://lore.kernel.org/bpf/8736boor55.fsf@cloudflare.com/
[1] https://lore.kernel.org/bpf/5e3ba96ca7889_6b512aafe4b145b812@john-XPS-13-9370.notmuch/


Jakub Sitnicki (3):
  bpf, sockmap: Don't sleep while holding RCU lock on tear-down
  bpf, sockhash: synchronize_rcu before free'ing map
  selftests/bpf: Test freeing sockmap/sockhash with a socket in it

 net/core/sock_map.c                           | 12 ++-
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 74 +++++++++++++++++++
 2 files changed, 82 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_basic.c

-- 
2.24.1

