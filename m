Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275F448C2E6
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 12:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346997AbiALLOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 06:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237932AbiALLOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 06:14:50 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FDCC06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 03:14:49 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso11265750pjm.4
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 03:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4mYYz6XiVeVg9KFkJ1cvtceKy58rpSgf17QL+DlDr5Q=;
        b=UQ1zpM0xazRrrWALkf7RiwxM5Hnaa74Cv6pcRtA//sx0bfctkIAOvg12VOzdbFpz8e
         Bna7vRXlS4P6V+yoGTM51fT6AgV1Xh5pGPhcrnAV4Zgp2J7RuSBRYSJXrDItN5JIDNpo
         1Lbf2IIw5Iqff03LFDb6tKJRAKLu9oSVUv3f6m/0p2onjIEJxCAuStoQRALrBOn2sxnv
         YxAr99UUZjTYM+uHZkLU8Pwi3v8qZULdf9AAexkRtHk1e8kGVe31UsDi+sKIkyvBWLJ3
         jghUcWq5fcDBFI9DWj2cgSsGlitDmFn7puKuQnpQLyQ5bntFKq8bD/5mc96Ld+EtXuvv
         XxKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4mYYz6XiVeVg9KFkJ1cvtceKy58rpSgf17QL+DlDr5Q=;
        b=o7RplCnhLjJcaoPKiW9+Rph07LtZ0hgEhmJB/u/eXig6fAA7rhl347MAijZ/1QNVy9
         so13IsV7AKODmPnuVFqDmlwUO5inBC7rgpSy3ufI98rwUyOypTtmcTlHADdoFJX3WHi6
         1djBiwp3B5eU5LirPfNegqA9YqWKJSxaTNf+3T7Cr2h4vJUgBoztGRlDCmVJAlsHxNdy
         rnerk9JnOfEpQIFcgugouuivP/ZYJzpHg9/y4j0xDsL2MoKGKOM4t/eiJ2+El1ktagTt
         QMYTxYHSHQNyxTdpiwvblNGtCl+T2U5yCGMdcpKe6cvffUlPqgLzyWQjw7BN8Jx3/rIF
         I+FQ==
X-Gm-Message-State: AOAM532dChEMmv1YqEy9ia5rCiDrO2C/zvvE/kb9luj+gU18rNQblb2y
        AhngGrv+dbOgC9WfZkovp+c=
X-Google-Smtp-Source: ABdhPJxs0zmsiTKO4Zw7C2b8sBq8fpLETKfvBF2CxvUKQqVE5HThlova7wV3gY0MubwV1U1IeRAb4w==
X-Received: by 2002:a62:cd02:0:b0:4bd:8f59:dc4e with SMTP id o2-20020a62cd02000000b004bd8f59dc4emr8986155pfg.64.1641986089190;
        Wed, 12 Jan 2022 03:14:49 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d4:f730:8e14:abc3])
        by smtp.gmail.com with ESMTPSA id a14sm2746833pfv.18.2022.01.12.03.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 03:14:48 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] ref_tracker: use __GFP_NOFAIL more carefully
Date:   Wed, 12 Jan 2022 03:14:45 -0800
Message-Id: <20220112111445.486446-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot was able to trigger this warning from new_slab()
		/*
		 * All existing users of the __GFP_NOFAIL are blockable, so warn
		 * of any new users that actually require GFP_NOWAIT
		 */
		if (WARN_ON_ONCE(!can_direct_reclaim))
			goto fail;

Indeed, we should use __GFP_NOFAIL if direct reclaim is possible.

Hopefully in the future we will be able to use SLAB_NOFAILSLAB
option so that syzbot can benefit from full ref_tracker
even in the presence of memory fault injections.

WARNING: CPU: 0 PID: 13 at mm/page_alloc.c:5081 __alloc_pages_slowpath.constprop.0+0x1b7b/0x20d0 mm/page_alloc.c:5081 mm/page_alloc.c:5081
Modules linked in:
CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__alloc_pages_slowpath.constprop.0+0x1b7b/0x20d0 mm/page_alloc.c:5081 mm/page_alloc.c:5081
Code: 90 08 00 00 48 81 c7 d8 04 00 00 48 89 f8 48 c1 e8 03 42 80 3c 30 00 0f 84 f0 ea ff ff e8 3d 82 09 00 e9 e6 ea ff ff 4d 89 fd <0f> 0b 48 b8 00 00 00 00 00 fc ff df 48 8b 54 24 30 48 c1 ea 03 80
RSP: 0018:ffffc90000d272b8 EFLAGS: 00010246

RAX: 0000000000000000 RBX: ffff88813fffc300 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff88813fffc348
RBP: ffff88813fffc300 R08: 00000000000013dc R09: 00000000000013c8
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc90000d274e8 R14: dffffc0000000000 R15: ffffc90000d274e8
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffefe6000f8 CR3: 000000001d21e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __alloc_pages+0x412/0x500 mm/page_alloc.c:5382 mm/page_alloc.c:5382
 alloc_pages+0x1a7/0x300 mm/mempolicy.c:2191 mm/mempolicy.c:2191
 alloc_slab_page mm/slub.c:1793 [inline]
 allocate_slab mm/slub.c:1938 [inline]
 alloc_slab_page mm/slub.c:1793 [inline] mm/slub.c:1993
 allocate_slab mm/slub.c:1938 [inline] mm/slub.c:1993
 new_slab+0x349/0x4a0 mm/slub.c:1993 mm/slub.c:1993
 ___slab_alloc+0x918/0xfe0 mm/slub.c:3022 mm/slub.c:3022
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3109 mm/slub.c:3109
 slab_alloc_node mm/slub.c:3200 [inline]
 slab_alloc mm/slub.c:3242 [inline]
 slab_alloc_node mm/slub.c:3200 [inline] mm/slub.c:3259
 slab_alloc mm/slub.c:3242 [inline] mm/slub.c:3259
 kmem_cache_alloc_trace+0x289/0x2c0 mm/slub.c:3259 mm/slub.c:3259
 kmalloc include/linux/slab.h:590 [inline]
 kzalloc include/linux/slab.h:724 [inline]
 kmalloc include/linux/slab.h:590 [inline] lib/ref_tracker.c:74
 kzalloc include/linux/slab.h:724 [inline] lib/ref_tracker.c:74
 ref_tracker_alloc+0xe1/0x430 lib/ref_tracker.c:74 lib/ref_tracker.c:74
 netdev_tracker_alloc include/linux/netdevice.h:3855 [inline]
 dev_hold_track include/linux/netdevice.h:3872 [inline]
 netdev_tracker_alloc include/linux/netdevice.h:3855 [inline] net/core/dst.c:52
 dev_hold_track include/linux/netdevice.h:3872 [inline] net/core/dst.c:52
 dst_init+0xe0/0x520 net/core/dst.c:52 net/core/dst.c:52
 dst_alloc+0x16b/0x1f0 net/core/dst.c:96 net/core/dst.c:96
 rt_dst_alloc+0x73/0x450 net/ipv4/route.c:1614 net/ipv4/route.c:1614
 ip_route_input_mc net/ipv4/route.c:1720 [inline]
 ip_route_input_mc net/ipv4/route.c:1720 [inline] net/ipv4/route.c:2465
 ip_route_input_rcu.part.0+0x4fe/0xcc0 net/ipv4/route.c:2465 net/ipv4/route.c:2465
 ip_route_input_rcu net/ipv4/route.c:2420 [inline]
 ip_route_input_rcu net/ipv4/route.c:2420 [inline] net/ipv4/route.c:2416
 ip_route_input_noref+0x1b8/0x2a0 net/ipv4/route.c:2416 net/ipv4/route.c:2416
 ip_rcv_finish_core.constprop.0+0x288/0x1e90 net/ipv4/ip_input.c:354 net/ipv4/ip_input.c:354
 ip_rcv_finish+0x135/0x2f0 net/ipv4/ip_input.c:427 net/ipv4/ip_input.c:427
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline] net/ipv4/ip_input.c:540
 NF_HOOK include/linux/netfilter.h:301 [inline] net/ipv4/ip_input.c:540
 ip_rcv+0xaa/0xd0 net/ipv4/ip_input.c:540 net/ipv4/ip_input.c:540
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5350 net/core/dev.c:5350
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5464 net/core/dev.c:5464
 process_backlog+0x2a5/0x6c0 net/core/dev.c:5796 net/core/dev.c:5796
 __napi_poll+0xaf/0x440 net/core/dev.c:6364 net/core/dev.c:6364
 napi_poll net/core/dev.c:6431 [inline]
 napi_poll net/core/dev.c:6431 [inline] net/core/dev.c:6518
 net_rx_action+0x801/0xb40 net/core/dev.c:6518 net/core/dev.c:6518
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd kernel/softirq.c:921 [inline] kernel/softirq.c:913
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913 kernel/softirq.c:913
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164 kernel/smpboot.c:164
 kthread+0x405/0x4f0 kernel/kthread.c:327 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295 arch/x86/entry/entry_64.S:295

Fixes: 4e66934eaadc ("lib: add reference counting tracking infrastructure")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 lib/ref_tracker.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index 0ae2e66dcf0fdb976f4cb99e747c9448b37f22cc..a6789c0c626b0f68ad67c264cd19177a63fb82d2 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -69,9 +69,12 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
 	unsigned long entries[REF_TRACKER_STACK_ENTRIES];
 	struct ref_tracker *tracker;
 	unsigned int nr_entries;
+	gfp_t gfp_mask = gfp;
 	unsigned long flags;
 
-	*trackerp = tracker = kzalloc(sizeof(*tracker), gfp | __GFP_NOFAIL);
+	if (gfp & __GFP_DIRECT_RECLAIM)
+		gfp_mask |= __GFP_NOFAIL;
+	*trackerp = tracker = kzalloc(sizeof(*tracker), gfp_mask);
 	if (unlikely(!tracker)) {
 		pr_err_once("memory allocation failure, unreliable refcount tracker.\n");
 		refcount_inc(&dir->untracked);
-- 
2.34.1.575.g55b058a8bb-goog

