Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA985F516B
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfKHQp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:45:29 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:37855 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfKHQp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 11:45:29 -0500
Received: by mail-pf1-f202.google.com with SMTP id z21so5392571pfr.4
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 08:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jrdAuLwFDZo961ObmXe7PlcHQXD8Sve71PQRliy245Q=;
        b=T8AdHJ5PP6E3gIEPVt/6D4NxbHJPLkwjk6QBe+6832eigOsQQTwZ+ik4MuOY31f+R7
         eKXM6sUbFPeIAQptPgX8YO1UZKFJW4YosoLP4m+YtxIY3YXlOZNq3SsF6Sti4nGciock
         kngLy2MMqPltS9hdqZW9TpiHzULMJslWS281WNjiy1vOyuTcKnRfcpOuOZnTrCmYceOr
         IUeLpDEI/uJDKpTOlxmuTJKAvSQwobf0FWQDNVtgR6pAlWwFm5cgkGNk9/WkobNqQSYq
         AZ2fFNoy4SdTIX5Nhhvr23nEYtdciwsZ9IdOuBqVtUFnYgLrO4liEh3m/O21N6++ZjsP
         dizg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jrdAuLwFDZo961ObmXe7PlcHQXD8Sve71PQRliy245Q=;
        b=nKnOELaxbZJ+16tw4f/v0QCPsjdH3Unavzq2cG8MlX4A/v5npri1dzl4ic+SpMG8HG
         O8KXnOKUTUWKfsztoL9mIBVRKAadnhiOHLdOX0EFaS/ShDS5fsradEPQrT3AgH+ODNAt
         kLzvEnQo+2k9MdRa9j5F2qkjmncoQilNgOUVC9oQfACdoS73ehvyaWLpHZ2jwTCZrzgH
         j/ReTD/a8Y9JkQZI7AhG/f5EPFB6yPhWLLugLargAGBdnKkFwmlMEen80nS6GJQ0VSeT
         utG+S6k5DNqONQaRw747UV/2oYes01RA9+i2E1tfVIXf+KaGTDUhF5eHko0XhYm67wVR
         bvrg==
X-Gm-Message-State: APjAAAVh+AkLeWWICx24U3NHWBiLeSP+wOtOSsGzuLmllWtX2+ScrBEW
        I89giYqfy0t/X7mFYHz2FLnBW12OrTj19A==
X-Google-Smtp-Source: APXvYqxwU/iXocnDiEhtWks7pVxIu7iL4SDx+92mWPbZQhQokY0Vuzts8KIygsQkRAUH7IS1stOsj+OY0OGRig==
X-Received: by 2002:a63:1703:: with SMTP id x3mr13336252pgl.263.1573231527868;
 Fri, 08 Nov 2019 08:45:27 -0800 (PST)
Date:   Fri,  8 Nov 2019 08:45:23 -0800
Message-Id: <20191108164523.211656-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next] net/sched: annotate lockless accesses to qdisc->empty
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KCSAN reported the following race [1]

BUG: KCSAN: data-race in __dev_queue_xmit / net_tx_action

read to 0xffff8880ba403508 of 1 bytes by task 21814 on cpu 1:
 __dev_xmit_skb net/core/dev.c:3389 [inline]
 __dev_queue_xmit+0x9db/0x1b40 net/core/dev.c:3761
 dev_queue_xmit+0x21/0x30 net/core/dev.c:3825
 neigh_hh_output include/net/neighbour.h:500 [inline]
 neigh_output include/net/neighbour.h:509 [inline]
 ip6_finish_output2+0x873/0xec0 net/ipv6/ip6_output.c:116
 __ip6_finish_output net/ipv6/ip6_output.c:142 [inline]
 __ip6_finish_output+0x2d7/0x330 net/ipv6/ip6_output.c:127
 ip6_finish_output+0x41/0x160 net/ipv6/ip6_output.c:152
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0xf2/0x280 net/ipv6/ip6_output.c:175
 dst_output include/net/dst.h:436 [inline]
 ip6_local_out+0x74/0x90 net/ipv6/output_core.c:179
 ip6_send_skb+0x53/0x110 net/ipv6/ip6_output.c:1795
 udp_v6_send_skb.isra.0+0x3ec/0xa70 net/ipv6/udp.c:1173
 udpv6_sendmsg+0x1906/0x1c20 net/ipv6/udp.c:1471
 inet6_sendmsg+0x6d/0x90 net/ipv6/af_inet6.c:576
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0x9f/0xc0 net/socket.c:657
 ___sys_sendmsg+0x2b7/0x5d0 net/socket.c:2311
 __sys_sendmmsg+0x123/0x350 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]
 __se_sys_sendmmsg net/socket.c:2439 [inline]
 __x64_sys_sendmmsg+0x64/0x80 net/socket.c:2439
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

write to 0xffff8880ba403508 of 1 bytes by interrupt on cpu 0:
 qdisc_run_begin include/net/sch_generic.h:160 [inline]
 qdisc_run include/net/pkt_sched.h:120 [inline]
 net_tx_action+0x2b1/0x6c0 net/core/dev.c:4551
 __do_softirq+0x115/0x33f kernel/softirq.c:292
 do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1082
 do_softirq.part.0+0x6b/0x80 kernel/softirq.c:337
 do_softirq kernel/softirq.c:329 [inline]
 __local_bh_enable_ip+0x76/0x80 kernel/softirq.c:189
 local_bh_enable include/linux/bottom_half.h:32 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:688 [inline]
 ip6_finish_output2+0x7bb/0xec0 net/ipv6/ip6_output.c:117
 __ip6_finish_output net/ipv6/ip6_output.c:142 [inline]
 __ip6_finish_output+0x2d7/0x330 net/ipv6/ip6_output.c:127
 ip6_finish_output+0x41/0x160 net/ipv6/ip6_output.c:152
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0xf2/0x280 net/ipv6/ip6_output.c:175
 dst_output include/net/dst.h:436 [inline]
 ip6_local_out+0x74/0x90 net/ipv6/output_core.c:179
 ip6_send_skb+0x53/0x110 net/ipv6/ip6_output.c:1795
 udp_v6_send_skb.isra.0+0x3ec/0xa70 net/ipv6/udp.c:1173
 udpv6_sendmsg+0x1906/0x1c20 net/ipv6/udp.c:1471
 inet6_sendmsg+0x6d/0x90 net/ipv6/af_inet6.c:576
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0x9f/0xc0 net/socket.c:657
 ___sys_sendmsg+0x2b7/0x5d0 net/socket.c:2311
 __sys_sendmmsg+0x123/0x350 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]
 __se_sys_sendmmsg net/socket.c:2439 [inline]
 __x64_sys_sendmmsg+0x64/0x80 net/socket.c:2439
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 21817 Comm: syz-executor.2 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: d518d2ed8640 ("net/sched: fix race between deactivation and dequeue for NOLOCK qdisc")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Davide Caratti <dcaratti@redhat.com>
---
 include/net/sch_generic.h | 6 +++---
 net/core/dev.c            | 2 +-
 net/sched/sch_generic.c   | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index a8b0a9a4c686541d175ea5b543c0ec3c9d7c9e79..d43da37737be230f1b745fdc30409c13854c5628 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -148,8 +148,8 @@ static inline bool qdisc_is_percpu_stats(const struct Qdisc *q)
 static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
 {
 	if (qdisc_is_percpu_stats(qdisc))
-		return qdisc->empty;
-	return !qdisc->q.qlen;
+		return READ_ONCE(qdisc->empty);
+	return !READ_ONCE(qdisc->q.qlen);
 }
 
 static inline bool qdisc_run_begin(struct Qdisc *qdisc)
@@ -157,7 +157,7 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 	if (qdisc->flags & TCQ_F_NOLOCK) {
 		if (!spin_trylock(&qdisc->seqlock))
 			return false;
-		qdisc->empty = false;
+		WRITE_ONCE(qdisc->empty, false);
 	} else if (qdisc_is_running(qdisc)) {
 		return false;
 	}
diff --git a/net/core/dev.c b/net/core/dev.c
index bb15800c8cb5cee148dc8adb659426f856ddd060..1c799d486623d5f144d1f7017c7b56133c06f07a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3607,7 +3607,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	qdisc_calculate_pkt_len(skb, q);
 
 	if (q->flags & TCQ_F_NOLOCK) {
-		if ((q->flags & TCQ_F_CAN_BYPASS) && q->empty &&
+		if ((q->flags & TCQ_F_CAN_BYPASS) && READ_ONCE(q->empty) &&
 		    qdisc_run_begin(q)) {
 			if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED,
 					      &q->state))) {
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 8561e825f401e312081b6160ac8ee88405336f56..5ab696efca951313372c3dfda0c2da52e97f4975 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -652,7 +652,7 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
 	if (likely(skb)) {
 		qdisc_update_stats_at_dequeue(qdisc, skb);
 	} else {
-		qdisc->empty = true;
+		WRITE_ONCE(qdisc->empty, true);
 	}
 
 	return skb;
-- 
2.24.0.432.g9d3f5f5b63-goog

