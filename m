Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C72C669EBE
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjAMQvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjAMQv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:51:26 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A44D33D56
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 08:48:52 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id t13-20020a056902018d00b0074747131938so23354226ybh.12
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 08:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ibjdhIq9KZkxGR6gXmOHRdFtKa5Ph/AVNcsSFHae/y4=;
        b=YB/ZXo9LEeTl4jQyceqXdfs6/wAt2EPSbvFwnDHhRfGRrPUSHFy/gH4wYI0QA18QJi
         ojLMgUJQGFtqJ7gWHw2/JaY7DChQwwa9pObJ29X4cToRP872TsW3IUFSyl99Ops3vHjR
         qTZbBY3RisZC6GJdOQLXzn3KV8hWDNRj9vMJ1se6K9sftbY+27p4T/n2U25GesfiaUoD
         jnA1GsNCKeAdLU4d1RVKKdvdD2e4BMmqj9FU6syHWjj3MABMDyCSQtjN+9bFHyLRe6vh
         GNyw1/pN78wx2cGfSi+ChXrANT2kAptHOzp37YbQh/qGiw7HsPR4mq96w/5zz9gEZKJ2
         RsXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ibjdhIq9KZkxGR6gXmOHRdFtKa5Ph/AVNcsSFHae/y4=;
        b=xHtGMqGpc46mi8BPIRfboD8PwDMNQUFJX802fKAYqJPfY9kcmVSAeQhC5ud/6PJEAI
         jze7oIngiY++E+8DEZEr4WySIeXl5FHbup04sV0RbRyJJhSHjb/s5shIonYfLCMumLlw
         f+wnrkT/YeEfa5HHFlmvGeP68OlUrSpr1625msUKsGJaDgM9mqXBiF8R1Yixa428QTbo
         D7rSmo+cyaivFu5DZPFG180/HWwfZsWC1xI3kn8/PGl9lpWV/ORwM+Iv+JvYjMwAHVIk
         QlhiwZUYEzDjLBjgaWo9cDDWB9eHZCpuP8NkGwmPPmwTS7WLmN0cn+sc4zb61AeGpByN
         EdpA==
X-Gm-Message-State: AFqh2ko7UT8tBTuU/PaGA9+473oSPnydEVqpn4eWCD64rFESC6RIqcNT
        h3WYF0p+oEJHRfA9Id6skCWWGhw6lYpPGw==
X-Google-Smtp-Source: AMrXdXsoQTJp05QNxlM4kcQW31FF/W2or2B/7QULgV4BYFKoOEAKAtb8PQlNioWngoMYK6T6HYbGihKt5jasCQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0d:ca4b:0:b0:4e0:c29f:af8a with SMTP id
 m72-20020a0dca4b000000b004e0c29faf8amr115421ywd.136.1673628530578; Fri, 13
 Jan 2023 08:48:50 -0800 (PST)
Date:   Fri, 13 Jan 2023 16:48:49 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113164849.4004848-1-edumazet@google.com>
Subject: [PATCH net] net/sched: sch_taprio: fix possible use-after-free
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Alexander Potapenko <glider@google.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a nasty crash [1] in net_tx_action() which
made little sense until we got a repro.

This repro installs a taprio qdisc, but providing an
invalid TCA_RATE attribute.

qdisc_create() has to destroy the just initialized
taprio qdisc, and taprio_destroy() is called.

However, the hrtimer used by taprio had already fired,
therefore advance_sched() called __netif_schedule().

Then net_tx_action was trying to use a destroyed qdisc.

We can not undo the __netif_schedule(), so we must wait
until one cpu serviced the qdisc before we can proceed.

Many thanks to Alexander Potapenko for his help.

[1]
BUG: KMSAN: uninit-value in queued_spin_trylock include/asm-generic/qspinlock.h:94 [inline]
BUG: KMSAN: uninit-value in do_raw_spin_trylock include/linux/spinlock.h:191 [inline]
BUG: KMSAN: uninit-value in __raw_spin_trylock include/linux/spinlock_api_smp.h:89 [inline]
BUG: KMSAN: uninit-value in _raw_spin_trylock+0x92/0xa0 kernel/locking/spinlock.c:138
 queued_spin_trylock include/asm-generic/qspinlock.h:94 [inline]
 do_raw_spin_trylock include/linux/spinlock.h:191 [inline]
 __raw_spin_trylock include/linux/spinlock_api_smp.h:89 [inline]
 _raw_spin_trylock+0x92/0xa0 kernel/locking/spinlock.c:138
 spin_trylock include/linux/spinlock.h:359 [inline]
 qdisc_run_begin include/net/sch_generic.h:187 [inline]
 qdisc_run+0xee/0x540 include/net/pkt_sched.h:125
 net_tx_action+0x77c/0x9a0 net/core/dev.c:5086
 __do_softirq+0x1cc/0x7fb kernel/softirq.c:571
 run_ksoftirqd+0x2c/0x50 kernel/softirq.c:934
 smpboot_thread_fn+0x554/0x9f0 kernel/smpboot.c:164
 kthread+0x31b/0x430 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slub.c:3258 [inline]
 __kmalloc_node_track_caller+0x814/0x1250 mm/slub.c:4970
 kmalloc_reserve net/core/skbuff.c:358 [inline]
 __alloc_skb+0x346/0xcf0 net/core/skbuff.c:430
 alloc_skb include/linux/skbuff.h:1257 [inline]
 nlmsg_new include/net/netlink.h:953 [inline]
 netlink_ack+0x5f3/0x12b0 net/netlink/af_netlink.c:2436
 netlink_rcv_skb+0x55d/0x6c0 net/netlink/af_netlink.c:2507
 rtnetlink_rcv+0x30/0x40 net/core/rtnetlink.c:6108
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0xf3b/0x1270 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x1288/0x1440 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0xabc/0xe90 net/socket.c:2482
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2536
 __sys_sendmsg net/socket.c:2565 [inline]
 __do_sys_sendmsg net/socket.c:2574 [inline]
 __se_sys_sendmsg net/socket.c:2572 [inline]
 __x64_sys_sendmsg+0x367/0x540 net/socket.c:2572
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 6.0.0-rc2-syzkaller-47461-gac3859c02d7f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 include/net/sch_generic.h | 7 +++++++
 net/sched/sch_taprio.c    | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index d5517719af4ef22282f0a15b132f8e8a07ae4179..af4aa66aaa4eba8f2eacdd00bc8fef31165c6a90 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1288,4 +1288,11 @@ void mq_change_real_num_tx(struct Qdisc *sch, unsigned int new_real_tx);
 
 int sch_frag_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
 
+/* Make sure qdisc is no longer in SCHED state. */
+static inline void qdisc_synchronize(const struct Qdisc *q)
+{
+	while (test_bit(__QDISC_STATE_SCHED, &q->state))
+		msleep(1);
+}
+
 #endif
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 570389f6cdd7dbab5749dc06d886555305cbf623..9a11a499ea2df8d18c9c062496fdcbcf5a861391 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1700,6 +1700,8 @@ static void taprio_reset(struct Qdisc *sch)
 	int i;
 
 	hrtimer_cancel(&q->advance_timer);
+	qdisc_synchronize(sch);
+
 	if (q->qdiscs) {
 		for (i = 0; i < dev->num_tx_queues; i++)
 			if (q->qdiscs[i])
@@ -1720,6 +1722,7 @@ static void taprio_destroy(struct Qdisc *sch)
 	 * happens in qdisc_create(), after taprio_init() has been called.
 	 */
 	hrtimer_cancel(&q->advance_timer);
+	qdisc_synchronize(sch);
 
 	taprio_disable_offload(dev, q, NULL);
 
-- 
2.39.0.314.g84b9a713c41-goog

