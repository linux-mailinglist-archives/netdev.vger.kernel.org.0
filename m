Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB7E0E4DCF
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394667AbfJYOCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505312AbfJYN5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:57:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DCD4222CE;
        Fri, 25 Oct 2019 13:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011854;
        bh=itu8u6XZH3Cf69v2c8xvFTnUCGWk0DrtvFGM5duP8IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rp4O6luVTpisPSFP13Lji5+3OsvA1yjh+pDY1+0evogVWR9DM4kk1IlXXw+PJZUkz
         UzyS5G4Q73pYVWqc/Bq2DBMkr5gufSmjnu2jMoC+Y2EP1QuyPSU2uKh++/aFSP1qlk
         V6gaFDxGcxCWZ6KU0qipwUhQWRBDUzXNUpvLe9bs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/25] sch_netem: fix rcu splat in netem_enqueue()
Date:   Fri, 25 Oct 2019 09:57:00 -0400
Message-Id: <20191025135715.25468-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135715.25468-1-sashal@kernel.org>
References: <20191025135715.25468-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 159d2c7d8106177bd9a986fd005a311fe0d11285 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 5 +++++
 net/sched/sch_netem.c     | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index f59acacaa2652..37876d842f2e6 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -305,6 +305,11 @@ static inline struct Qdisc *qdisc_root(const struct Qdisc *qdisc)
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
index 787aa52e5991c..6266121a03f9a 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -469,7 +469,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	 * skb will be queued.
 	 */
 	if (count > 1 && (skb2 = skb_clone(skb, GFP_ATOMIC)) != NULL) {
-		struct Qdisc *rootq = qdisc_root(sch);
+		struct Qdisc *rootq = qdisc_root_bh(sch);
 		u32 dupsave = q->duplicate; /* prevent duplicating a dup... */
 
 		q->duplicate = 0;
-- 
2.20.1

