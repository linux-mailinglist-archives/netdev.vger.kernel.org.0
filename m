Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894D22CA4AB
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403819AbgLAN54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 08:57:56 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:45890 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388303AbgLAN5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 08:57:55 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0UHDREtM_1606831020;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UHDREtM_1606831020)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Dec 2020 21:57:00 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     magnus.karlsson@intel.com, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev@vger.kernel.org (open list:XDP SOCKETS (AF_XDP)),
        bpf@vger.kernel.org (open list:XDP SOCKETS (AF_XDP)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH bpf V3 2/2] xsk: change the tx writeable condition
Date:   Tue,  1 Dec 2020 21:56:58 +0800
Message-Id: <508fef55188d4e1160747ead64c6dcda36735880.1606555939.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1606555939.git.xuanzhuo@linux.alibaba.com>
References: <MW3PR11MB46023BE924A19FB198604C0DF7F40@MW3PR11MB4602.namprd11.prod.outlook.com>
 <cover.1606555939.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1606555939.git.xuanzhuo@linux.alibaba.com>
References: <cover.1606555939.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the tx writeable condition from the queue is not full to the
number of present tx queues is less than the half of the total number
of queues. Because the tx queue not full is a very short time, this will
cause a large number of EPOLLOUT events, and cause a large number of
process wake up.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c       | 16 +++++++++++++---
 net/xdp/xsk_queue.h |  6 ++++++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 9bbfd8a..6250447 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -211,6 +211,14 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len,
 	return 0;
 }
 
+static bool xsk_tx_writeable(struct xdp_sock *xs)
+{
+	if (xskq_cons_present_entries(xs->tx) > xs->tx->nentries / 2)
+		return false;
+
+	return true;
+}
+
 static bool xsk_is_bound(struct xdp_sock *xs)
 {
 	if (READ_ONCE(xs->state) == XSK_BOUND) {
@@ -296,7 +304,8 @@ void xsk_tx_release(struct xsk_buff_pool *pool)
 	rcu_read_lock();
 	list_for_each_entry_rcu(xs, &pool->xsk_tx_list, tx_list) {
 		__xskq_cons_release(xs->tx);
-		xs->sk.sk_write_space(&xs->sk);
+		if (xsk_tx_writeable(xs))
+			xs->sk.sk_write_space(&xs->sk);
 	}
 	rcu_read_unlock();
 }
@@ -436,7 +445,8 @@ static int xsk_generic_xmit(struct sock *sk)
 
 out:
 	if (sent_frame)
-		sk->sk_write_space(sk);
+		if (xsk_tx_writeable(xs))
+			sk->sk_write_space(sk);
 
 	mutex_unlock(&xs->mutex);
 	return err;
@@ -493,7 +503,7 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 
 	if (xs->rx && !xskq_prod_is_empty(xs->rx))
 		mask |= EPOLLIN | EPOLLRDNORM;
-	if (xs->tx && !xskq_cons_is_full(xs->tx))
+	if (xs->tx && xsk_tx_writeable(xs))
 		mask |= EPOLLOUT | EPOLLWRNORM;
 
 	return mask;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index cdb9cf3..9e71b9f 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -264,6 +264,12 @@ static inline bool xskq_cons_is_full(struct xsk_queue *q)
 		q->nentries;
 }
 
+static inline u32 xskq_cons_present_entries(struct xsk_queue *q)
+{
+	/* No barriers needed since data is not accessed */
+	return READ_ONCE(q->ring->producer) - READ_ONCE(q->ring->consumer);
+}
+
 /* Functions for producers */
 
 static inline bool xskq_prod_is_full(struct xsk_queue *q)
-- 
1.8.3.1

