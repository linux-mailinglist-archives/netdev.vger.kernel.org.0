Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F002D72C9
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 10:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393633AbgLKJ04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 04:26:56 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:49018 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404450AbgLKJ0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 04:26:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0UIE-Rji_1607678745;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UIE-Rji_1607678745)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 11 Dec 2020 17:25:45 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     magnus.karlsson@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev@vger.kernel.org (open list:XDP SOCKETS (AF_XDP)),
        bpf@vger.kernel.org (open list:XDP SOCKETS (AF_XDP)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH bpf-next] xsk: save the undone skb
Date:   Fri, 11 Dec 2020 17:25:44 +0800
Message-Id: <8c251b09e29f5c36a824f73211a22e64460d4e4e.1607678556.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can reserve the skb. When sending fails, NETDEV_TX_BUSY or
xskq_prod_reserve fails. As long as skb is successfully generated and
successfully configured, we can reserve skb if we encounter exceptions
later.

Especially when NETDEV_TX_BUSY fails, there is no need to deal with
the problem that xskq_prod_reserve has been updated.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/net/xdp_sock.h |  3 +++
 net/xdp/xsk.c          | 36 +++++++++++++++++++++++++++---------
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 4f4e93b..fead0c9 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -76,6 +76,9 @@ struct xdp_sock {
 	struct mutex mutex;
 	struct xsk_queue *fq_tmp; /* Only as tmp storage before bind */
 	struct xsk_queue *cq_tmp; /* Only as tmp storage before bind */
+
+	struct sk_buff *skb_undone;
+	bool skb_undone_reserve;
 };
 
 #ifdef CONFIG_XDP_SOCKETS
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index e28c682..1051024 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -435,6 +435,19 @@ static int xsk_generic_xmit(struct sock *sk)
 	if (xs->queue_id >= xs->dev->real_num_tx_queues)
 		goto out;
 
+	if (xs->skb_undone) {
+		if (xs->skb_undone_reserve) {
+			if (xskq_prod_reserve(xs->pool->cq))
+				goto out;
+
+			xs->skb_undone_reserve = false;
+		}
+
+		skb = xs->skb_undone;
+		xs->skb_undone = NULL;
+		goto xmit;
+	}
+
 	while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
 		char *buffer;
 		u64 addr;
@@ -454,12 +467,7 @@ static int xsk_generic_xmit(struct sock *sk)
 		addr = desc.addr;
 		buffer = xsk_buff_raw_get_data(xs->pool, addr);
 		err = skb_store_bits(skb, 0, buffer, len);
-		/* This is the backpressure mechanism for the Tx path.
-		 * Reserve space in the completion queue and only proceed
-		 * if there is space in it. This avoids having to implement
-		 * any buffering in the Tx path.
-		 */
-		if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
+		if (unlikely(err)) {
 			kfree_skb(skb);
 			goto out;
 		}
@@ -470,12 +478,22 @@ static int xsk_generic_xmit(struct sock *sk)
 		skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
 		skb->destructor = xsk_destruct_skb;
 
+		/* This is the backpressure mechanism for the Tx path.
+		 * Reserve space in the completion queue and only proceed
+		 * if there is space in it. This avoids having to implement
+		 * any buffering in the Tx path.
+		 */
+		if (xskq_prod_reserve(xs->pool->cq)) {
+			xs->skb_undone_reserve = true;
+			xs->skb_undone = skb;
+			goto out;
+		}
+
+xmit:
 		err = __dev_direct_xmit(skb, xs->queue_id);
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */
-			skb->destructor = sock_wfree;
-			/* Free skb without triggering the perf drop trace */
-			consume_skb(skb);
+			xs->skb_undone = skb;
 			err = -EAGAIN;
 			goto out;
 		}
-- 
1.8.3.1

