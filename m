Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B49473B30
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 03:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhLNC6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 21:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbhLNC6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 21:58:11 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0E1C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 18:58:10 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id g19so16668932pfb.8
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 18:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ftt/2g7KLww9t/K/wDgcyd21kcWI24YRIuT8eUsGniY=;
        b=AYtDxAqE/929WrLiqrf/FNgXiyuYodSp9jmbFY3tl/yzwgRa+0fSE57/QjVyTUxNFX
         mwLaUcE4sa4EDX92a5wCZVoQTh01fr8cXA9ZIzjeIWQmSFrUBqpt6wBfziz9m36rUzgl
         hVovTE+dPLtMd4rumBglFpM+d7dN8NmkH4GJ+fVffqrOiMaMogXESw3i7a3UFlm5ZQpS
         Fm3gdG0ahN11kNdIZXa6QUrFTQFv+7qacA46+45AD0CgXgSpt+Iz0kXlwFMW7azIItDo
         ov2H1XIWUdH51uRqzfydLfP2a/Br5P76joR1XOOLQDyh7wdKBeEsleZZl6vjJnU0zsMi
         fLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ftt/2g7KLww9t/K/wDgcyd21kcWI24YRIuT8eUsGniY=;
        b=6Pj0hqGS4pFnzEhFHpNh0cdSw7+L7sIa5DSr2oblS26NpXIdrKEamA1W7HSp3EKwDK
         e/Zqz4lwejXDLvArljNKFSZJ0Cz8aq9E0Gbyye0b74KGuS2qP9EQsSD9D+g84sIXIB17
         gR9hBGV2Di9ZEvPmYyCfA56Glgvi0zvIeUW4iGXlzne7eo90vlf5NwSq8sX08vs1A+4e
         /3Vqx281dA6LCEXi72o425LlREK1K70A01Qw3ubyaiLhZh+/SM9R6sjXDE5nHZAkQZ8q
         JyIvXIf3GmvGyrS73PF9gqBHtPFUrz4S4PLgonIwNWkp6S3QGAIUiXwCZF/wu6SarGOQ
         /MDA==
X-Gm-Message-State: AOAM531+c9EjCBSaoytJwjBSTM/tKUfqyyLntFbcj9iDOfVeBwmqpZw2
        bjL8rENbhlPoC2tOv1KFjw8=
X-Google-Smtp-Source: ABdhPJyz/jNd6i1cAtRxC0j5nuRJNubMcswgog41jhATQz+HmZVpgOmJ1BvqEVjf31V3NXf9ggzlAg==
X-Received: by 2002:a63:d008:: with SMTP id z8mr1811478pgf.623.1639450690206;
        Mon, 13 Dec 2021 18:58:10 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5cbb:7251:72ab:eb48])
        by smtp.gmail.com with ESMTPSA id c2sm13966604pfv.112.2021.12.13.18.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 18:58:09 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] ipv6: use GFP_ATOMIC in rt6_probe()
Date:   Mon, 13 Dec 2021 18:58:06 -0800
Message-Id: <20211214025806.3456382-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot reminded me that rt6_probe() can run from
atomic contexts.

stack backtrace:

CPU: 1 PID: 7461 Comm: syz-executor.2 Not tainted 5.16.0-rc4-next-20211210-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_usage_bug kernel/locking/lockdep.c:203 [inline]
 valid_state kernel/locking/lockdep.c:3945 [inline]
 mark_lock_irq kernel/locking/lockdep.c:4148 [inline]
 mark_lock.cold+0x61/0x8e kernel/locking/lockdep.c:4605
 mark_usage kernel/locking/lockdep.c:4500 [inline]
 __lock_acquire+0x11d5/0x54a0 kernel/locking/lockdep.c:4981
 lock_acquire kernel/locking/lockdep.c:5639 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5604
 __fs_reclaim_acquire mm/page_alloc.c:4550 [inline]
 fs_reclaim_acquire+0x115/0x160 mm/page_alloc.c:4564
 might_alloc include/linux/sched/mm.h:253 [inline]
 slab_pre_alloc_hook mm/slab.h:739 [inline]
 slab_alloc_node mm/slub.c:3145 [inline]
 slab_alloc mm/slub.c:3239 [inline]
 kmem_cache_alloc_trace+0x3b/0x2c0 mm/slub.c:3256
 kmalloc include/linux/slab.h:581 [inline]
 kzalloc include/linux/slab.h:715 [inline]
 ref_tracker_alloc+0xe1/0x430 lib/ref_tracker.c:74
 netdev_tracker_alloc include/linux/netdevice.h:3860 [inline]
 dev_hold_track include/linux/netdevice.h:3877 [inline]
 rt6_probe net/ipv6/route.c:661 [inline]
 find_match.part.0+0xac9/0xd00 net/ipv6/route.c:752
 find_match net/ipv6/route.c:825 [inline]
 __find_rr_leaf+0x17f/0xd20 net/ipv6/route.c:826
 find_rr_leaf net/ipv6/route.c:847 [inline]
 rt6_select net/ipv6/route.c:891 [inline]
 fib6_table_lookup+0x649/0xa20 net/ipv6/route.c:2185
 ip6_pol_route+0x1c5/0x11e0 net/ipv6/route.c:2221
 pol_lookup_func include/net/ip6_fib.h:580 [inline]
 fib6_rule_lookup+0x52a/0x6f0 net/ipv6/fib6_rules.c:120
 ip6_route_output_flags_noref+0x2e2/0x380 net/ipv6/route.c:2629
 ip6_route_output_flags+0x72/0x320 net/ipv6/route.c:2642
 ip6_route_output include/net/ip6_route.h:98 [inline]
 ip6_dst_lookup_tail+0x5ab/0x1620 net/ipv6/ip6_output.c:1070
 ip6_dst_lookup_flow+0x8c/0x1d0 net/ipv6/ip6_output.c:1200
 geneve_get_v6_dst+0x46f/0x9a0 drivers/net/geneve.c:858
 geneve6_xmit_skb drivers/net/geneve.c:991 [inline]
 geneve_xmit+0x520/0x3530 drivers/net/geneve.c:1074
 __netdev_start_xmit include/linux/netdevice.h:4685 [inline]
 netdev_start_xmit include/linux/netdevice.h:4699 [inline]
 xmit_one net/core/dev.c:3473 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3489
 __dev_queue_xmit+0x2983/0x3640 net/core/dev.c:4112
 neigh_resolve_output net/core/neighbour.c:1522 [inline]
 neigh_resolve_output+0x50e/0x820 net/core/neighbour.c:1502
 neigh_output include/net/neighbour.h:541 [inline]
 ip6_finish_output2+0x56e/0x14f0 net/ipv6/ip6_output.c:126
 __ip6_finish_output net/ipv6/ip6_output.c:191 [inline]
 __ip6_finish_output+0x61e/0xe80 net/ipv6/ip6_output.c:170
 ip6_finish_output+0x32/0x200 net/ipv6/ip6_output.c:201
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x1e4/0x530 net/ipv6/ip6_output.c:224
 dst_output include/net/dst.h:451 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ndisc_send_skb+0xa99/0x17f0 net/ipv6/ndisc.c:508
 ndisc_send_rs+0x12e/0x6f0 net/ipv6/ndisc.c:702
 addrconf_rs_timer+0x3f2/0x820 net/ipv6/addrconf.c:3898
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x675/0xa20 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>

Fixes: fb67510ba9bd ("ipv6: add net device refcount tracker to rt6_probe_deferred()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 4d02a329ab6004169ebd31c5474ce8be5553d569..03be0e6b4826521b262b0ac98433f0d25f86c1f1 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -658,7 +658,7 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 	} else {
 		INIT_WORK(&work->work, rt6_probe_deferred);
 		work->target = *nh_gw;
-		dev_hold_track(dev, &work->dev_tracker, GFP_KERNEL);
+		dev_hold_track(dev, &work->dev_tracker, GFP_ATOMIC);
 		work->dev = dev;
 		schedule_work(&work->work);
 	}
-- 
2.34.1.173.g76aa8bc2d0-goog

