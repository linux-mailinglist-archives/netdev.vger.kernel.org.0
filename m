Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3722B788F
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 09:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgKRIZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 03:25:20 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:40324 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726274AbgKRIZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 03:25:19 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UFnFPS6_1605687912;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UFnFPS6_1605687912)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 Nov 2020 16:25:12 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     bjorn.topel@intel.com
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] xsk: change the tx writeable condition
Date:   Wed, 18 Nov 2020 16:25:09 +0800
Message-Id: <b7b0432d49ab05064efb85f1858b6e6f9e1274bd.1605686678.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1605686678.git.xuanzhuo@linux.alibaba.com>
References: <3306b4d8-8689-b0e7-3f6d-c3ad873b7093@intel.com>
 <cover.1605686678.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1605686678.git.xuanzhuo@linux.alibaba.com>
References: <cover.1605686678.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the tx writeable condition from the queue is not full to the
number of remaining tx queues is less than the half of the total number
of queues. Because the tx queue not full is a very short time, this will
cause a large number of EPOLLOUT events, and cause a large number of
process wake up.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 net/xdp/xsk.c       | 20 +++++++++++++++++---
 net/xdp/xsk_queue.h |  6 ++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 7f0353e..bc3d4ece 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -211,6 +211,17 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len,
 	return 0;
 }
 
+static bool xsk_writeable(struct xdp_sock *xs)
+{
+	if (!xs->tx)
+		return false;
+
+	if (xskq_cons_left(xs->tx) > xs->tx->nentries / 2)
+		return false;
+
+	return true;
+}
+
 static bool xsk_is_bound(struct xdp_sock *xs)
 {
 	if (READ_ONCE(xs->state) == XSK_BOUND) {
@@ -296,7 +307,8 @@ void xsk_tx_release(struct xsk_buff_pool *pool)
 	rcu_read_lock();
 	list_for_each_entry_rcu(xs, &pool->xsk_tx_list, tx_list) {
 		__xskq_cons_release(xs->tx);
-		xs->sk.sk_write_space(&xs->sk);
+		if (xsk_writeable(xs))
+			xs->sk.sk_write_space(&xs->sk);
 	}
 	rcu_read_unlock();
 }
@@ -442,7 +454,8 @@ static int xsk_generic_xmit(struct sock *sk)
 
 out:
 	if (sent_frame)
-		sk->sk_write_space(sk);
+		if (xsk_writeable(xs))
+			sk->sk_write_space(sk);
 
 	mutex_unlock(&xs->mutex);
 	return err;
@@ -499,7 +512,8 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 
 	if (xs->rx && !xskq_prod_is_empty(xs->rx))
 		mask |= EPOLLIN | EPOLLRDNORM;
-	if (xs->tx && !xskq_cons_is_full(xs->tx))
+
+	if (xsk_writeable(xs))
 		mask |= EPOLLOUT | EPOLLWRNORM;
 
 	return mask;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index cdb9cf3..82a5228 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -264,6 +264,12 @@ static inline bool xskq_cons_is_full(struct xsk_queue *q)
 		q->nentries;
 }
 
+static inline __u64 xskq_cons_left(struct xsk_queue *q)
+{
+	/* No barriers needed since data is not accessed */
+	return READ_ONCE(q->ring->producer) - READ_ONCE(q->ring->consumer);
+}
+
 /* Functions for producers */
 
 static inline bool xskq_prod_is_full(struct xsk_queue *q)
-- 
1.8.3.1

