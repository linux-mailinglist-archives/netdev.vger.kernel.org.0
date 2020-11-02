Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258C42A29A8
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgKBLlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgKBLlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:41:06 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABCDC0617A6;
        Mon,  2 Nov 2020 03:41:06 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id z24so10571423pgk.3;
        Mon, 02 Nov 2020 03:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pjlyXXm52wfYFVFE3okvomUK69BQYy61gTCsuwArXNk=;
        b=nzeoMjWzR2CpmtCRUXYHBfP6+bqrJbms0H6w84vybROwwOCDIr61j7BZMHe9Tu+WkY
         NWGP0BfIpIpusDD1sUkNEZy2XMKIehiJ+WZd7zig4Q+i9JES2ryHc14BMlNpmMVdtwQC
         Qyo4TR3YimWLgM5zRJx3gC/2ESRIprUQv0KdJnU413SC/Ksfzy4hoFxR8+JDE50SGHBu
         FWebrr/fr4aeZnN7mRwWnb1yBx6/Y91fn2DAItwtEIsTkNlbx1f5gc6Vl+MBZ52mjfHJ
         rQJcCXqW2sbO4DXmJcsVf1wzotlyeJuZzktvdx8IeFbab1q8GkQrVX9jBPCVfZiHWZ2S
         aADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pjlyXXm52wfYFVFE3okvomUK69BQYy61gTCsuwArXNk=;
        b=PaGY/JGtEwQ7ZFP8sIeteb2w8C3A2BwRi7bUiidprKIMNuxHYddrQ2o98TnPMIT+LW
         LHInLKgOmwXTf/KcdkEil+sBVKnlEZDuVSFV/prk7S5UIkx4gU1ISW2m5ddoCGMMeaLh
         NbFmNx3fDsHlOSYx0cGPUZwecfzpeworBlyrNRgplKxpsDzCiRQ41xwRELOUa2xDl74a
         qknowa34a7UUiGDdMeBuMTzWXvOkLrbtYQD2YznzMbRJenSyIO6AAu2MdF8olU1cHQNf
         RiSEAZ5suGmJZQvgck/apAtf/DMpzgT+Zmn81RsPR9r7Z67e8Trxi9GL6swUC6uSmpfJ
         yulg==
X-Gm-Message-State: AOAM531oLmSJaOI+EXuAUQHqQQMpGcyxX46UW9Gl1AaNIAPCy/1E4Ofj
        NED9aath6Cj8dwFVPR03aac=
X-Google-Smtp-Source: ABdhPJxqA1SRdeu+x+EnFaLDWrmrtiAr8sQ1CoI1S+X1T98q/yuyg/0Eh94IOGUmkexFRtvyJPTf6A==
X-Received: by 2002:a65:460a:: with SMTP id v10mr12715035pgq.81.1604317265546;
        Mon, 02 Nov 2020 03:41:05 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id i123sm13710036pfc.13.2020.11.02.03.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:41:04 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-net] bpf: fix error path in htab_map_alloc()
Date:   Mon,  2 Nov 2020 03:41:00 -0800
Message-Id: <20201102114100.3103180-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot was able to trigger a use-after-free in htab_map_alloc() [1]

htab_map_alloc() lacks a call to lockdep_unregister_key() in its error path.

lockdep_register_key() and lockdep_unregister_key() can not fail,
it seems better to use them right after htab allocation and before
htab freeing, avoiding more goto/labels in htab_map_alloc()

[1]
BUG: KASAN: use-after-free in lockdep_register_key+0x356/0x3e0 kernel/locking/lockdep.c:1182
Read of size 8 at addr ffff88805fa67ad8 by task syz-executor.3/2356

CPU: 1 PID: 2356 Comm: syz-executor.3 Not tainted 5.9.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 lockdep_register_key+0x356/0x3e0 kernel/locking/lockdep.c:1182
 htab_init_buckets kernel/bpf/hashtab.c:144 [inline]
 htab_map_alloc+0x6c5/0x14a0 kernel/bpf/hashtab.c:521
 find_and_alloc_map kernel/bpf/syscall.c:122 [inline]
 map_create kernel/bpf/syscall.c:825 [inline]
 __do_sys_bpf+0xa80/0x5180 kernel/bpf/syscall.c:4381
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45deb9
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f0eafee1c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000001a00 RCX: 000000000045deb9
RDX: 0000000000000040 RSI: 0000000020000040 RDI: 405a020000000000
RBP: 000000000118bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007ffd3cf9eabf R14: 00007f0eafee29c0 R15: 000000000118bf2c

Allocated by task 2053:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:666 [inline]
 htab_map_alloc+0xdf/0x14a0 kernel/bpf/hashtab.c:454
 find_and_alloc_map kernel/bpf/syscall.c:122 [inline]
 map_create kernel/bpf/syscall.c:825 [inline]
 __do_sys_bpf+0xa80/0x5180 kernel/bpf/syscall.c:4381
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 2053:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
 slab_free mm/slub.c:3142 [inline]
 kfree+0xdb/0x360 mm/slub.c:4124
 htab_map_alloc+0x3f9/0x14a0 kernel/bpf/hashtab.c:549
 find_and_alloc_map kernel/bpf/syscall.c:122 [inline]
 map_create kernel/bpf/syscall.c:825 [inline]
 __do_sys_bpf+0xa80/0x5180 kernel/bpf/syscall.c:4381
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88805fa67800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 728 bytes inside of
 1024-byte region [ffff88805fa67800, ffff88805fa67c00)
The buggy address belongs to the page:
page:000000003c5582c4 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5fa60
head:000000003c5582c4 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 ffffea0000bc1200 0000000200000002 ffff888010041140
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88805fa67980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88805fa67a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88805fa67a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                    ^
 ffff88805fa67b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88805fa67b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: c50eb518e262 ("bpf: Use separate lockdep class for each hashtab")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/hashtab.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index da59ba978d17230684276001dce1de8e7816cb12..23f73d4649c9c9eaf6246f1088ddfee2d3875ea9 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -141,7 +141,6 @@ static void htab_init_buckets(struct bpf_htab *htab)
 {
 	unsigned i;
 
-	lockdep_register_key(&htab->lockdep_key);
 	for (i = 0; i < htab->n_buckets; i++) {
 		INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
 		if (htab_use_raw_lock(htab)) {
@@ -455,6 +454,8 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
 
+	lockdep_register_key(&htab->lockdep_key);
+
 	bpf_map_init_from_attr(&htab->map, attr);
 
 	if (percpu_lru) {
@@ -546,6 +547,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 free_charge:
 	bpf_map_charge_finish(&htab->map.memory);
 free_htab:
+	lockdep_unregister_key(&htab->lockdep_key);
 	kfree(htab);
 	return ERR_PTR(err);
 }
@@ -1364,9 +1366,9 @@ static void htab_map_free(struct bpf_map *map)
 
 	free_percpu(htab->extra_elems);
 	bpf_map_area_free(htab->buckets);
-	lockdep_unregister_key(&htab->lockdep_key);
 	for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
 		free_percpu(htab->map_locked[i]);
+	lockdep_unregister_key(&htab->lockdep_key);
 	kfree(htab);
 }
 
-- 
2.29.1.341.ge80a0c044ae-goog

