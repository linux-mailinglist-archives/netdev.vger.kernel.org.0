Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDD51BB6B
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbfEMQ7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:59:21 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:52813 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728822AbfEMQ7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:59:20 -0400
Received: by mail-pl1-f202.google.com with SMTP id 94so8757120plc.19
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 09:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=3cOYEKKvk6z+zsgzYfoEXAvcfcEGnzEvXzE0Cid7gi0=;
        b=tsPPx9G9DnakEWknuekFc2N5HipsZv24ezd4Ev1+u2ngFhmtDGkvDyM1OuK0wFfgyO
         mC8dEpurynoMgE2/AGJwCWt6FLErTAuXZOzb9rHQWmTuwPMFe5Iy8f19J8uP07jtHQJK
         pm1algwdM/iksIT0HH3rkhLAbq+BrAx5Ei/S8KNgT93ce2q0w8JVcg42cRmXl2Jd1IOw
         2zYc9/6QYOXg++APE3nf8zzGJj4s8jgsSWaooQfpD/e79w3ZDPGjVFFbHhVGAJpXFanT
         QHPq70VRMSIeB6nsJ14DVIr9EcSLUTGiykUkRo+eHZtJX9dyPJyB5FzJQkk2lz9fxq+0
         kdQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=3cOYEKKvk6z+zsgzYfoEXAvcfcEGnzEvXzE0Cid7gi0=;
        b=MlwOQnbXMjM5/Hxvn0iyNcx6ghbKjmmlueOW0xyMYvzwVsTGrJ+tbVRQ/Nvuk/I9S/
         5w5SfAuHVOCvgbkzc3yfqpZG/m+D7U4jti5e6+cSvasJ7yEWqVxq6/sTbjQB5kVqnEj0
         kma57nzsCLl/rRJfBl0rtJF0J6DBSWlN/yfHo5n6oHEONXZko4dlP8NCD4tPuFjURWde
         VoE50AISakhglE5+cSZZloC5iBj9QyulKx8L4vQ6J89ofkR4Fxcr9Q1qYey/iNRkcR6e
         4pxVV6RBP6tjFJr+2vOC1jgX2fAFj92D38scDr7NyteYMGkhbiT8JU87etnjPuAM2AZF
         3PKw==
X-Gm-Message-State: APjAAAWANNIxFuQ3a3qEuvKDYed5zfX4nwqpwj4jD9Dx8nShJ7b8pLO6
        yAofbGZuTGeN7zzptzOwl6L0Ky/RiO8i4g==
X-Google-Smtp-Source: APXvYqznBPczJl6YOrY96mnx6E3eiJ064D+vOCus2SHa4iLhb2/DXSyg83tcd34hRfEtAJL9+tvfMVjUPRu97Q==
X-Received: by 2002:a63:7982:: with SMTP id u124mr32165268pgc.352.1557766759318;
 Mon, 13 May 2019 09:59:19 -0700 (PDT)
Date:   Mon, 13 May 2019 09:59:16 -0700
Message-Id: <20190513165916.259013-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH net] bpf: devmap: fix use-after-free Read in __dev_map_entry_free
From:   Eric Dumazet <edumazet@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        syzbot+457d3e2ffbcf31aee5c0@syzkaller.appspotmail.com,
        "=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?=" <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

synchronize_rcu() is fine when the rcu callbacks only need
to free memory (kfree_rcu() or direct kfree() call rcu call backs)

__dev_map_entry_free() is a bit more complex, so we need to make
sure that call queued __dev_map_entry_free() callbacks have completed.

sysbot report:

BUG: KASAN: use-after-free in dev_map_flush_old kernel/bpf/devmap.c:365
[inline]
BUG: KASAN: use-after-free in __dev_map_entry_free+0x2a8/0x300
kernel/bpf/devmap.c:379
Read of size 8 at addr ffff8801b8da38c8 by task ksoftirqd/1/18

CPU: 1 PID: 18 Comm: ksoftirqd/1 Not tainted 4.17.0+ #39
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
  dev_map_flush_old kernel/bpf/devmap.c:365 [inline]
  __dev_map_entry_free+0x2a8/0x300 kernel/bpf/devmap.c:379
  __rcu_reclaim kernel/rcu/rcu.h:178 [inline]
  rcu_do_batch kernel/rcu/tree.c:2558 [inline]
  invoke_rcu_callbacks kernel/rcu/tree.c:2818 [inline]
  __rcu_process_callbacks kernel/rcu/tree.c:2785 [inline]
  rcu_process_callbacks+0xe9d/0x1760 kernel/rcu/tree.c:2802
  __do_softirq+0x2e0/0xaf5 kernel/softirq.c:284
  run_ksoftirqd+0x86/0x100 kernel/softirq.c:645
  smpboot_thread_fn+0x417/0x870 kernel/smpboot.c:164
  kthread+0x345/0x410 kernel/kthread.c:240
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412

Allocated by task 6675:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  kmem_cache_alloc_trace+0x152/0x780 mm/slab.c:3620
  kmalloc include/linux/slab.h:513 [inline]
  kzalloc include/linux/slab.h:706 [inline]
  dev_map_alloc+0x208/0x7f0 kernel/bpf/devmap.c:102
  find_and_alloc_map kernel/bpf/syscall.c:129 [inline]
  map_create+0x393/0x1010 kernel/bpf/syscall.c:453
  __do_sys_bpf kernel/bpf/syscall.c:2351 [inline]
  __se_sys_bpf kernel/bpf/syscall.c:2328 [inline]
  __x64_sys_bpf+0x303/0x510 kernel/bpf/syscall.c:2328
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 26:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xd9/0x260 mm/slab.c:3813
  dev_map_free+0x4fa/0x670 kernel/bpf/devmap.c:191
  bpf_map_free_deferred+0xba/0xf0 kernel/bpf/syscall.c:262
  process_one_work+0xc64/0x1b70 kernel/workqueue.c:2153
  worker_thread+0x181/0x13a0 kernel/workqueue.c:2296
  kthread+0x345/0x410 kernel/kthread.c:240
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412

The buggy address belongs to the object at ffff8801b8da37c0
  which belongs to the cache kmalloc-512 of size 512
The buggy address is located 264 bytes inside of
  512-byte region [ffff8801b8da37c0, ffff8801b8da39c0)
The buggy address belongs to the page:
page:ffffea0006e368c0 count:1 mapcount:0 mapping:ffff8801da800940
index:0xffff8801b8da3540
flags: 0x2fffc0000000100(slab)
raw: 02fffc0000000100 ffffea0007217b88 ffffea0006e30cc8 ffff8801da800940
raw: ffff8801b8da3540 ffff8801b8da3040 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801b8da3780: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
  ffff8801b8da3800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8801b8da3880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                               ^
  ffff8801b8da3900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801b8da3980: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc

Fixes: 546ac1ffb70d ("bpf: add devmap, a map for storing net device referen=
ces")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+457d3e2ffbcf31aee5c0@syzkaller.appspotmail.com
Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 kernel/bpf/devmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 191b79948424f4b21b7aa120abc03801264bf0a6..1e525d70f83354e451b738ffb8e=
42d83b5fa932f 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -164,6 +164,9 @@ static void dev_map_free(struct bpf_map *map)
 	bpf_clear_redirect_map(map);
 	synchronize_rcu();
=20
+	/* Make sure prior __dev_map_entry_free() have completed. */
+	rcu_barrier();
+
 	/* To ensure all pending flush operations have completed wait for flush
 	 * bitmap to indicate all flush_needed bits to be zero on _all_ cpus.
 	 * Because the above synchronize_rcu() ensures the map is disconnected
--=20
2.21.0.1020.gf2820cf01a-goog

