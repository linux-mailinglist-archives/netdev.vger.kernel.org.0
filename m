Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9082168EE2C
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjBHLnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjBHLnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:43:33 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDFF4615B
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:43:31 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id AC3862065B;
        Wed,  8 Feb 2023 12:43:29 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hRqsYTEK2Gvl; Wed,  8 Feb 2023 12:43:28 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2EEFF2066F;
        Wed,  8 Feb 2023 12:43:27 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 2099380004A;
        Wed,  8 Feb 2023 12:43:27 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 8 Feb 2023 12:43:26 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Wed, 8 Feb
 2023 12:43:26 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 77DF03182EBB; Wed,  8 Feb 2023 12:43:25 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 5/6] xfrm: annotate data-race around use_time
Date:   Wed, 8 Feb 2023 12:43:21 +0100
Message-ID: <20230208114322.266510-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230208114322.266510-1-steffen.klassert@secunet.com>
References: <20230208114322.266510-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

KCSAN reported multiple cpus can update use_time
at the same time.

Adds READ_ONCE()/WRITE_ONCE() annotations.

Note that 32bit arches are not fully protected,
but they will probably no longer be supported/used in 2106.

BUG: KCSAN: data-race in __xfrm_policy_check / __xfrm_policy_check

write to 0xffff88813e7ec108 of 8 bytes by interrupt on cpu 0:
__xfrm_policy_check+0x6ae/0x17f0 net/xfrm/xfrm_policy.c:3664
__xfrm_policy_check2 include/net/xfrm.h:1174 [inline]
xfrm_policy_check include/net/xfrm.h:1179 [inline]
xfrm6_policy_check+0x2e9/0x320 include/net/xfrm.h:1189
udpv6_queue_rcv_one_skb+0x48/0xa30 net/ipv6/udp.c:703
udpv6_queue_rcv_skb+0x2d6/0x310 net/ipv6/udp.c:792
udp6_unicast_rcv_skb+0x16b/0x190 net/ipv6/udp.c:935
__udp6_lib_rcv+0x84b/0x9b0 net/ipv6/udp.c:1020
udpv6_rcv+0x4b/0x50 net/ipv6/udp.c:1133
ip6_protocol_deliver_rcu+0x99e/0x1020 net/ipv6/ip6_input.c:439
ip6_input_finish net/ipv6/ip6_input.c:484 [inline]
NF_HOOK include/linux/netfilter.h:302 [inline]
ip6_input+0xca/0x180 net/ipv6/ip6_input.c:493
dst_input include/net/dst.h:454 [inline]
ip6_rcv_finish+0x1e9/0x2d0 net/ipv6/ip6_input.c:79
NF_HOOK include/linux/netfilter.h:302 [inline]
ipv6_rcv+0x85/0x140 net/ipv6/ip6_input.c:309
__netif_receive_skb_one_core net/core/dev.c:5482 [inline]
__netif_receive_skb+0x8b/0x1b0 net/core/dev.c:5596
process_backlog+0x23f/0x3b0 net/core/dev.c:5924
__napi_poll+0x65/0x390 net/core/dev.c:6485
napi_poll net/core/dev.c:6552 [inline]
net_rx_action+0x37e/0x730 net/core/dev.c:6663
__do_softirq+0xf2/0x2c7 kernel/softirq.c:571
do_softirq+0xb1/0xf0 kernel/softirq.c:472
__local_bh_enable_ip+0x6f/0x80 kernel/softirq.c:396
__raw_read_unlock_bh include/linux/rwlock_api_smp.h:257 [inline]
_raw_read_unlock_bh+0x17/0x20 kernel/locking/spinlock.c:284
wg_socket_send_skb_to_peer+0x107/0x120 drivers/net/wireguard/socket.c:184
wg_packet_create_data_done drivers/net/wireguard/send.c:251 [inline]
wg_packet_tx_worker+0x142/0x360 drivers/net/wireguard/send.c:276
process_one_work+0x3d3/0x720 kernel/workqueue.c:2289
worker_thread+0x618/0xa70 kernel/workqueue.c:2436
kthread+0x1a9/0x1e0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

write to 0xffff88813e7ec108 of 8 bytes by interrupt on cpu 1:
__xfrm_policy_check+0x6ae/0x17f0 net/xfrm/xfrm_policy.c:3664
__xfrm_policy_check2 include/net/xfrm.h:1174 [inline]
xfrm_policy_check include/net/xfrm.h:1179 [inline]
xfrm6_policy_check+0x2e9/0x320 include/net/xfrm.h:1189
udpv6_queue_rcv_one_skb+0x48/0xa30 net/ipv6/udp.c:703
udpv6_queue_rcv_skb+0x2d6/0x310 net/ipv6/udp.c:792
udp6_unicast_rcv_skb+0x16b/0x190 net/ipv6/udp.c:935
__udp6_lib_rcv+0x84b/0x9b0 net/ipv6/udp.c:1020
udpv6_rcv+0x4b/0x50 net/ipv6/udp.c:1133
ip6_protocol_deliver_rcu+0x99e/0x1020 net/ipv6/ip6_input.c:439
ip6_input_finish net/ipv6/ip6_input.c:484 [inline]
NF_HOOK include/linux/netfilter.h:302 [inline]
ip6_input+0xca/0x180 net/ipv6/ip6_input.c:493
dst_input include/net/dst.h:454 [inline]
ip6_rcv_finish+0x1e9/0x2d0 net/ipv6/ip6_input.c:79
NF_HOOK include/linux/netfilter.h:302 [inline]
ipv6_rcv+0x85/0x140 net/ipv6/ip6_input.c:309
__netif_receive_skb_one_core net/core/dev.c:5482 [inline]
__netif_receive_skb+0x8b/0x1b0 net/core/dev.c:5596
process_backlog+0x23f/0x3b0 net/core/dev.c:5924
__napi_poll+0x65/0x390 net/core/dev.c:6485
napi_poll net/core/dev.c:6552 [inline]
net_rx_action+0x37e/0x730 net/core/dev.c:6663
__do_softirq+0xf2/0x2c7 kernel/softirq.c:571
do_softirq+0xb1/0xf0 kernel/softirq.c:472
__local_bh_enable_ip+0x6f/0x80 kernel/softirq.c:396
__raw_read_unlock_bh include/linux/rwlock_api_smp.h:257 [inline]
_raw_read_unlock_bh+0x17/0x20 kernel/locking/spinlock.c:284
wg_socket_send_skb_to_peer+0x107/0x120 drivers/net/wireguard/socket.c:184
wg_packet_create_data_done drivers/net/wireguard/send.c:251 [inline]
wg_packet_tx_worker+0x142/0x360 drivers/net/wireguard/send.c:276
process_one_work+0x3d3/0x720 kernel/workqueue.c:2289
worker_thread+0x618/0xa70 kernel/workqueue.c:2436
kthread+0x1a9/0x1e0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

value changed: 0x0000000063c62d6f -> 0x0000000063c62d70

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 4185 Comm: kworker/1:2 Tainted: G W 6.2.0-rc4-syzkaller-00009-gd532dd102151-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: wg-crypt-wg0 wg_packet_tx_worker

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_policy.c | 11 +++++++----
 net/xfrm/xfrm_state.c  | 10 +++++-----
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index ed0976f8e42b..5c61ec04b839 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -336,7 +336,7 @@ static void xfrm_policy_timer(struct timer_list *t)
 	}
 	if (xp->lft.hard_use_expires_seconds) {
 		time64_t tmo = xp->lft.hard_use_expires_seconds +
-			(xp->curlft.use_time ? : xp->curlft.add_time) - now;
+			(READ_ONCE(xp->curlft.use_time) ? : xp->curlft.add_time) - now;
 		if (tmo <= 0)
 			goto expired;
 		if (tmo < next)
@@ -354,7 +354,7 @@ static void xfrm_policy_timer(struct timer_list *t)
 	}
 	if (xp->lft.soft_use_expires_seconds) {
 		time64_t tmo = xp->lft.soft_use_expires_seconds +
-			(xp->curlft.use_time ? : xp->curlft.add_time) - now;
+			(READ_ONCE(xp->curlft.use_time) ? : xp->curlft.add_time) - now;
 		if (tmo <= 0) {
 			warn = 1;
 			tmo = XFRM_KM_TIMEOUT;
@@ -3661,7 +3661,8 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		return 1;
 	}
 
-	pol->curlft.use_time = ktime_get_real_seconds();
+	/* This lockless write can happen from different cpus. */
+	WRITE_ONCE(pol->curlft.use_time, ktime_get_real_seconds());
 
 	pols[0] = pol;
 	npols++;
@@ -3676,7 +3677,9 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 				xfrm_pol_put(pols[0]);
 				return 0;
 			}
-			pols[1]->curlft.use_time = ktime_get_real_seconds();
+			/* This write can happen from different cpus. */
+			WRITE_ONCE(pols[1]->curlft.use_time,
+				   ktime_get_real_seconds());
 			npols++;
 		}
 	}
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 5f03d1fbb98e..00afe831c71c 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -595,7 +595,7 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 	}
 	if (x->lft.hard_use_expires_seconds) {
 		time64_t tmo = x->lft.hard_use_expires_seconds +
-			(x->curlft.use_time ? : now) - now;
+			(READ_ONCE(x->curlft.use_time) ? : now) - now;
 		if (tmo <= 0)
 			goto expired;
 		if (tmo < next)
@@ -617,7 +617,7 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 	}
 	if (x->lft.soft_use_expires_seconds) {
 		time64_t tmo = x->lft.soft_use_expires_seconds +
-			(x->curlft.use_time ? : now) - now;
+			(READ_ONCE(x->curlft.use_time) ? : now) - now;
 		if (tmo <= 0)
 			warn = 1;
 		else if (tmo < next)
@@ -1906,7 +1906,7 @@ int xfrm_state_update(struct xfrm_state *x)
 
 		hrtimer_start(&x1->mtimer, ktime_set(1, 0),
 			      HRTIMER_MODE_REL_SOFT);
-		if (x1->curlft.use_time)
+		if (READ_ONCE(x1->curlft.use_time))
 			xfrm_state_check_expire(x1);
 
 		if (x->props.smark.m || x->props.smark.v || x->if_id) {
@@ -1940,8 +1940,8 @@ int xfrm_state_check_expire(struct xfrm_state *x)
 {
 	xfrm_dev_state_update_curlft(x);
 
-	if (!x->curlft.use_time)
-		x->curlft.use_time = ktime_get_real_seconds();
+	if (!READ_ONCE(x->curlft.use_time))
+		WRITE_ONCE(x->curlft.use_time, ktime_get_real_seconds());
 
 	if (x->curlft.bytes >= x->lft.hard_byte_limit ||
 	    x->curlft.packets >= x->lft.hard_packet_limit) {
-- 
2.34.1

