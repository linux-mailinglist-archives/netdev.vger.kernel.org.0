Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DC467C9B8
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 12:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbjAZLVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 06:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237071AbjAZLVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 06:21:39 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5521043F
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 03:21:37 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id t13-20020a056902018d00b0074747131938so1512052ybh.12
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 03:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kaLix+60oDtOneEpPDkqVyHSqHClO1JtVyCqsOnb1zk=;
        b=oGCpVqr7lQqCE5HE1qG7sLQwXuK2deNEmzWGvLbc7bj/k76c58I0TtDtRCss5/lPfe
         FrTost+F0F+zPYVnbCaDZ8qr2mExB4U2eP6VW/tLQTgTgolvw3/wIHpyDZlu0HFd5NOS
         q7XpypXYTctmTbEVO5yGfYrO6w5qWqy075f/fIb5NnCwpRPxtFdilPDhpKygpuhaLVkn
         y9Uo5AhJyrToMuPRLUk7hw73+yI002wk0pnlTsXxzVF3jtN363yWvDy2h7WD2kvi5Xcf
         oI89MLmBuzd12I587WkEAZ3iMIVG377ulZze+PnaEt+Jc7X2dJjhwpq/rymzH/DKwL9S
         Zi9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kaLix+60oDtOneEpPDkqVyHSqHClO1JtVyCqsOnb1zk=;
        b=vIcGH1YPidkJTw0KiQkSYRjDGyIjh4U8ULqVAnEdiHHaKl8JDHBxec/GFIvf3Z1cUe
         lFOc3c2nzjx2qQIJDhiSrQiBMnvPIovnmuJsDwvHNEvEySmFYVZDic6buIkVAvrQ9G7u
         l8bNzWFAEtVC33Y0pKWsL1Avx4xyoq7M3606IQQtb62+R3jw/dsOLX433sHd8b7BpMaS
         87nRqfnISHfH/hbQQO6xDh++5YSUCcI6FMMCneYKkOrls8WFQ1fMFalehF3WK8a/tYy2
         1wz4cJtHnXk0kNU+/ssb51/Ex7MbtMp5mdUrOCdB7x6YA7IiM/u6toT/rAEycMtjviwB
         LIAw==
X-Gm-Message-State: AFqh2krN2YX9CVMmB1HTUtgEkZiVF4QejF/4KR8rqS+VM4ovmd/6MKvT
        XSKGbIK0PXVvRMXl9akxIgs+RA/3msu/Bw==
X-Google-Smtp-Source: AMrXdXsOpuosRdjuxpZLUsAPGGl3BG6Vol/laMPoK06K6oQcpNrYS7eXS5RpbNDj8Q5/JT8+cmPpb1E2x+rIEQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:690c:852:b0:4d7:eb11:6bf7 with SMTP
 id bz18-20020a05690c085200b004d7eb116bf7mr4222528ywb.235.1674732097225; Thu,
 26 Jan 2023 03:21:37 -0800 (PST)
Date:   Thu, 26 Jan 2023 11:21:30 +0000
In-Reply-To: <20230126112130.2341075-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230126112130.2341075-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126112130.2341075-3-edumazet@google.com>
Subject: [PATCH net 2/2] xfrm: annotate data-race around use_time
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>
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
---
 net/xfrm/xfrm_policy.c | 11 +++++++----
 net/xfrm/xfrm_state.c  | 10 +++++-----
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index e9eb82c5457d03727ff7fff30e2f8493ea23fd05..47d3a485b8659768af6e675d60ddb13b7377ff34 100644
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
index 5f03d1fbb98ed79900f61c783eba34dbfd99abfe..00afe831c71c49cde41625e7960a8441d0be69ab 100644
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
2.39.1.456.gfc5497dd1b-goog

