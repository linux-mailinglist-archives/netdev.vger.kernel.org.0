Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC99ABD358
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 22:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731642AbfIXULa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 16:11:30 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:42982 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfIXULa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 16:11:30 -0400
Received: by mail-pf1-f201.google.com with SMTP id w16so2266949pfj.9
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 13:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=EAxk/vpTW85+fdEn51w+V/fox+dGr1e3pjgJ/YxuSEo=;
        b=SlKokI/QTB1WoxyQDuWodVHOyuFht+W5MCd/oOoHLnUXtiHSjdTmjqWHmpR+AFt/uL
         QemmZlZgHI8R4F1AwXP0tvwsx76MxOi+gYCjwEzE9hGBRdBB0AZiixy9jUPjYtqv6UJk
         8bWIe+tQAyuwnJcdITK3415Lm8aTvYSFi7LD6X3OlkYgWP0jXHH+zEXR9tzDlWXcFLXL
         GekyaI88uwxbOX7KfXMMGIqXVKBCi8QwuuuMOFDv8y6q/8qbR8k9bmgZOyToNSRmM6Fx
         HEfKjF0WSZ8hl8eHPUpip4i6523ZoLKPUmaiQaDpHRZjJjmkizzlj/9tww4sQ8oJipR7
         rXKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=EAxk/vpTW85+fdEn51w+V/fox+dGr1e3pjgJ/YxuSEo=;
        b=jeb0OtIJbF1vPTwHw9XWsmQ2cscxo0GmnZrhERVJ76aJqcvxRZGhAsrRLwQr9dVW9X
         3mn0if3+xd6eSzvsDJ5JJZuUd0H9WNmUexnpGO1+a8GTjLYjDu8C15m2hqtH19A1+zah
         Lenq4TTd0o4xUl/EvXVR6QTLyrfXVtclC24VYEtrH2Y+3Txh2BaF8fpYUGfbwfg7QllJ
         V0BShCzTnK0qH5BdfrgBKwjtAbkcCZ6scwVLr43H/CdU+dfSFImT21/L0o15TlCONNrD
         bW6W8VlTfIJAmX1MjdoKpUdwUW4vipexejfaeqx36ChqYKlwltbcVvBIBYKehFM7x+mv
         kIuQ==
X-Gm-Message-State: APjAAAWeIZHiFfBzu4DuxC4UWjT46jGCtHOtP7Vs5YTyMyIlzz/6NfAm
        /ws89Eceq3A6UmfOKz6YMrlYtjS5WypOjQ==
X-Google-Smtp-Source: APXvYqy1jG3gL34cpdFkJcZFz6Mki/b9oTUDCgzgtRZy7Rozw0rGdEfr1LWI3IuMvJd7foUr0z4dvLJUeXxQRg==
X-Received: by 2002:a63:121c:: with SMTP id h28mr4777390pgl.336.1569355889601;
 Tue, 24 Sep 2019 13:11:29 -0700 (PDT)
Date:   Tue, 24 Sep 2019 13:11:26 -0700
Message-Id: <20190924201126.77301-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [PATCH net] sch_netem: fix rcu splat in netem_enqueue()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qdisc_root() use from netem_enqueue() triggers a lockdep warning.

__dev_queue_xmit() uses rcu_read_lock_bh() which is
not equivalent to rcu_read_lock() + local_bh_disable_bh as far
as lockdep is concerned.

WARNING: suspicious RCU usage
5.3.0-rc7+ #0 Not tainted
-----------------------------
include/net/sch_generic.h:492 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
3 locks held by syz-executor427/8855:
 #0: 00000000b5525c01 (rcu_read_lock_bh){....}, at: lwtunnel_xmit_redirect include/net/lwtunnel.h:92 [inline]
 #0: 00000000b5525c01 (rcu_read_lock_bh){....}, at: ip_finish_output2+0x2dc/0x2570 net/ipv4/ip_output.c:214
 #1: 00000000b5525c01 (rcu_read_lock_bh){....}, at: __dev_queue_xmit+0x20a/0x3650 net/core/dev.c:3804
 #2: 00000000364bae92 (&(&sch->q.lock)->rlock){+.-.}, at: spin_lock include/linux/spinlock.h:338 [inline]
 #2: 00000000364bae92 (&(&sch->q.lock)->rlock){+.-.}, at: __dev_xmit_skb net/core/dev.c:3502 [inline]
 #2: 00000000364bae92 (&(&sch->q.lock)->rlock){+.-.}, at: __dev_queue_xmit+0x14b8/0x3650 net/core/dev.c:3838

stack backtrace:
CPU: 0 PID: 8855 Comm: syz-executor427 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 lockdep_rcu_suspicious+0x153/0x15d kernel/locking/lockdep.c:5357
 qdisc_root include/net/sch_generic.h:492 [inline]
 netem_enqueue+0x1cfb/0x2d80 net/sched/sch_netem.c:479
 __dev_xmit_skb net/core/dev.c:3527 [inline]
 __dev_queue_xmit+0x15d2/0x3650 net/core/dev.c:3838
 dev_queue_xmit+0x18/0x20 net/core/dev.c:3902
 neigh_hh_output include/net/neighbour.h:500 [inline]
 neigh_output include/net/neighbour.h:509 [inline]
 ip_finish_output2+0x1726/0x2570 net/ipv4/ip_output.c:228
 __ip_finish_output net/ipv4/ip_output.c:308 [inline]
 __ip_finish_output+0x5fc/0xb90 net/ipv4/ip_output.c:290
 ip_finish_output+0x38/0x1f0 net/ipv4/ip_output.c:318
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip_mc_output+0x292/0xf40 net/ipv4/ip_output.c:417
 dst_output include/net/dst.h:436 [inline]
 ip_local_out+0xbb/0x190 net/ipv4/ip_output.c:125
 ip_send_skb+0x42/0xf0 net/ipv4/ip_output.c:1555
 udp_send_skb.isra.0+0x6b2/0x1160 net/ipv4/udp.c:887
 udp_sendmsg+0x1e96/0x2820 net/ipv4/udp.c:1174
 inet_sendmsg+0x9e/0xe0 net/ipv4/af_inet.c:807
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:657
 ___sys_sendmsg+0x3e2/0x920 net/socket.c:2311
 __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]
 __se_sys_sendmmsg net/socket.c:2439 [inline]
 __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2439
 do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/sch_generic.h | 5 +++++
 net/sched/sch_netem.c     | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 43f5b7ed02bdbad6f5dba54ba79b8f1b9d144d16..637548d54b3ee9bdb0edd10a1667e81a40a6ef74 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -494,6 +494,11 @@ static inline struct Qdisc *qdisc_root(const struct Qdisc *qdisc)
 	return q;
 }
 
+static inline struct Qdisc *qdisc_root_bh(const struct Qdisc *qdisc)
+{
+	return rcu_dereference_bh(qdisc->dev_queue->qdisc);
+}
+
 static inline struct Qdisc *qdisc_root_sleeping(const struct Qdisc *qdisc)
 {
 	return qdisc->dev_queue->qdisc_sleeping;
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index f5cb35e550f8df557f2e444cc2fd142cab97789b..0e44039e729c72be52d0bf65568b3641e7f910d8 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -476,7 +476,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	 * skb will be queued.
 	 */
 	if (count > 1 && (skb2 = skb_clone(skb, GFP_ATOMIC)) != NULL) {
-		struct Qdisc *rootq = qdisc_root(sch);
+		struct Qdisc *rootq = qdisc_root_bh(sch);
 		u32 dupsave = q->duplicate; /* prevent duplicating a dup... */
 
 		q->duplicate = 0;
-- 
2.23.0.351.gc4317032e6-goog

