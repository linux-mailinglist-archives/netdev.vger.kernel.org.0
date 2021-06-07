Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB36639E117
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhFGPr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:47:29 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:60590 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231246AbhFGPr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 11:47:28 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UbeGQ3Q_1623080735;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0UbeGQ3Q_1623080735)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Jun 2021 23:45:35 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     Tony Lu <tonylu@linux.alibaba.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH net-next] tcp: avoid spurious loopback retransmit
Date:   Mon,  7 Jun 2021 23:45:34 +0800
Message-Id: <20210607154534.57034-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found there are pretty much loopback TCP retransmitions
on our online servers. Most of them are TLP retransmition.

This is because for loopback communication, TLP is usally
triggered about 2ms after the last packet was sent if no
ACK was received within that period.
This condition can be met if there are some kernel tasks
running on that CPU for more than 2ms, which delays the
softirq to process the sd->backlog.

We sampled the loopback TLP retransmit on our online servers,
and found an average 2K+ retransmit per hour. But in some cases,
this can be much bigger, I found a peak 40 retrans/s on the
same server.
Actually, those loopback retransmitions are not a big problem as
long as they don't happen too frequently. It's just spurious and
meanless and waste some CPU cycles.

I also write a test module which just busy-loop in the kernel
for more then 2ms, and the lo retransmition can be triggered
every time we run the busy-loop on the target CPU.
With this patch, the retransmition is gone and the throughput
is not affected.

Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 include/linux/skbuff.h |  7 +++++--
 net/ipv4/tcp_output.c  | 31 +++++++++++++++++++++++++++----
 net/xfrm/xfrm_policy.c |  2 +-
 3 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dbf820a50a39..290e0a6a3a47 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1131,9 +1131,12 @@ struct sk_buff_fclones {
  * Returns true if skb is a fast clone, and its clone is not freed.
  * Some drivers call skb_orphan() in their ndo_start_xmit(),
  * so we also check that this didnt happen.
+ * For loopback, the skb maybe in the target sock's receive_queue
+ * we need to ignore that case.
  */
 static inline bool skb_fclone_busy(const struct sock *sk,
-				   const struct sk_buff *skb)
+				   const struct sk_buff *skb,
+				   bool is_loopback)
 {
 	const struct sk_buff_fclones *fclones;
 
@@ -1141,7 +1144,7 @@ static inline bool skb_fclone_busy(const struct sock *sk,
 
 	return skb->fclone == SKB_FCLONE_ORIG &&
 	       refcount_read(&fclones->fclone_ref) > 1 &&
-	       READ_ONCE(fclones->skb2.sk) == sk;
+	       is_loopback ? true : READ_ONCE(fclones->skb2.sk) == sk;
 }
 
 /**
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index bde781f46b41..f51a6a565678 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2771,6 +2771,20 @@ bool tcp_schedule_loss_probe(struct sock *sk, bool advancing_rto)
 	return true;
 }
 
+static int sock_is_loopback(const struct sock *sk)
+{
+	struct dst_entry *dst;
+	int loopback = 0;
+
+	rcu_read_lock();
+	dst = rcu_dereference(sk->sk_dst_cache);
+	if (dst && dst->dev &&
+	    (dst->dev->features & NETIF_F_LOOPBACK))
+		loopback = 1;
+	rcu_read_unlock();
+	return loopback;
+}
+
 /* Thanks to skb fast clones, we can detect if a prior transmit of
  * a packet is still in a qdisc or driver queue.
  * In this case, there is very little point doing a retransmit !
@@ -2778,15 +2792,24 @@ bool tcp_schedule_loss_probe(struct sock *sk, bool advancing_rto)
 static bool skb_still_in_host_queue(struct sock *sk,
 				    const struct sk_buff *skb)
 {
-	if (unlikely(skb_fclone_busy(sk, skb))) {
-		set_bit(TSQ_THROTTLED, &sk->sk_tsq_flags);
-		smp_mb__after_atomic();
-		if (skb_fclone_busy(sk, skb)) {
+	bool is_loopback = sock_is_loopback(sk);
+
+	if (unlikely(skb_fclone_busy(sk, skb, is_loopback))) {
+		if (!is_loopback) {
+			set_bit(TSQ_THROTTLED, &sk->sk_tsq_flags);
+			smp_mb__after_atomic();
+			if (skb_fclone_busy(sk, skb, is_loopback)) {
+				NET_INC_STATS(sock_net(sk),
+					      LINUX_MIB_TCPSPURIOUS_RTX_HOSTQUEUES);
+				return true;
+			}
+		} else {
 			NET_INC_STATS(sock_net(sk),
 				      LINUX_MIB_TCPSPURIOUS_RTX_HOSTQUEUES);
 			return true;
 		}
 	}
+
 	return false;
 }
 
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index ce500f847b99..f8ea62a840e9 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2846,7 +2846,7 @@ static int xdst_queue_output(struct net *net, struct sock *sk, struct sk_buff *s
 	struct xfrm_policy *pol = xdst->pols[0];
 	struct xfrm_policy_queue *pq = &pol->polq;
 
-	if (unlikely(skb_fclone_busy(sk, skb))) {
+	if (unlikely(skb_fclone_busy(sk, skb, false))) {
 		kfree_skb(skb);
 		return 0;
 	}
-- 
2.19.1.3.ge56e4f7

