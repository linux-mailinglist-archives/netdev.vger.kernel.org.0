Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555E42FEC46
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 14:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbhAUNtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 08:49:45 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:34074 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729157AbhAUNtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 08:49:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0UMRARD7_1611236830;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UMRARD7_1611236830)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 21 Jan 2021 21:47:10 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     bpf@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 3/3] xsk: build skb by page
Date:   Thu, 21 Jan 2021 21:47:09 +0800
Message-Id: <340f1dfa40416dd966a56e08507daba82d633088.1611236588.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1611236588.git.xuanzhuo@linux.alibaba.com>
References: <cover.1611236588.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1611236588.git.xuanzhuo@linux.alibaba.com>
References: <cover.1611236588.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is used to construct skb based on page to save memory copy
overhead.

This function is implemented based on IFF_TX_SKB_NO_LINEAR. Only the
network card priv_flags supports IFF_TX_SKB_NO_LINEAR will use page to
directly construct skb. If this feature is not supported, it is still
necessary to copy data to construct skb.

---------------- Performance Testing ------------

The test environment is Aliyun ECS server.
Test cmd:
```
xdpsock -i eth0 -t  -S -s <msg size>
```

Test result data:

size    64      512     1024    1500
copy    1916747 1775988 1600203 1440054
page    1974058 1953655 1945463 1904478
percent 3.0%    10.0%   21.58%  32.3%

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/xdp/xsk.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 86 insertions(+), 18 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 4a83117..38af7f1 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -430,6 +430,87 @@ static void xsk_destruct_skb(struct sk_buff *skb)
 	sock_wfree(skb);
 }
 
+static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
+					      struct xdp_desc *desc)
+{
+	u32 len, offset, copy, copied;
+	struct sk_buff *skb;
+	struct page *page;
+	void *buffer;
+	int err, i;
+	u64 addr;
+
+	skb = sock_alloc_send_skb(&xs->sk, 0, 1, &err);
+	if (unlikely(!skb))
+		return ERR_PTR(err);
+
+	addr = desc->addr;
+	len = desc->len;
+
+	buffer = xsk_buff_raw_get_data(xs->pool, addr);
+	offset = offset_in_page(buffer);
+	addr = buffer - xs->pool->addrs;
+
+	for (copied = 0, i = 0; copied < len; i++) {
+		page = xs->pool->umem->pgs[addr >> PAGE_SHIFT];
+
+		get_page(page);
+
+		copy = min_t(u32, PAGE_SIZE - offset, len - copied);
+
+		skb_fill_page_desc(skb, i, page, offset, copy);
+
+		copied += copy;
+		addr += copy;
+		offset = 0;
+	}
+
+	skb->len += len;
+	skb->data_len += len;
+	skb->truesize += len;
+
+	refcount_add(len, &xs->sk.sk_wmem_alloc);
+
+	return skb;
+}
+
+static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
+				     struct xdp_desc *desc)
+{
+	struct sk_buff *skb;
+
+	if (xs->dev->priv_flags & IFF_TX_SKB_NO_LINEAR) {
+		skb = xsk_build_skb_zerocopy(xs, desc);
+		if (IS_ERR(skb))
+			return skb;
+	} else {
+		void *buffer;
+		u32 len;
+		int err;
+
+		len = desc->len;
+		skb = sock_alloc_send_skb(&xs->sk, len, 1, &err);
+		if (unlikely(!skb))
+			return ERR_PTR(err);
+
+		skb_put(skb, len);
+		buffer = xsk_buff_raw_get_data(xs->pool, desc->addr);
+		err = skb_store_bits(skb, 0, buffer, len);
+		if (unlikely(err)) {
+			kfree_skb(skb);
+			return ERR_PTR(err);
+		}
+	}
+
+	skb->dev = xs->dev;
+	skb->priority = xs->sk.sk_priority;
+	skb->mark = xs->sk.sk_mark;
+	skb_shinfo(skb)->destructor_arg = (void *)(long)desc->addr;
+	skb->destructor = xsk_destruct_skb;
+
+	return skb;
+}
+
 static int xsk_generic_xmit(struct sock *sk)
 {
 	struct xdp_sock *xs = xdp_sk(sk);
@@ -446,43 +527,30 @@ static int xsk_generic_xmit(struct sock *sk)
 		goto out;
 
 	while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
-		char *buffer;
-		u64 addr;
-		u32 len;
-
 		if (max_batch-- == 0) {
 			err = -EAGAIN;
 			goto out;
 		}
 
-		len = desc.len;
-		skb = sock_alloc_send_skb(sk, len, 1, &err);
-		if (unlikely(!skb))
+		skb = xsk_build_skb(xs, &desc);
+		if (IS_ERR(skb)) {
+			err = PTR_ERR(skb);
 			goto out;
+		}
 
-		skb_put(skb, len);
-		addr = desc.addr;
-		buffer = xsk_buff_raw_get_data(xs->pool, addr);
-		err = skb_store_bits(skb, 0, buffer, len);
 		/* This is the backpressure mechanism for the Tx path.
 		 * Reserve space in the completion queue and only proceed
 		 * if there is space in it. This avoids having to implement
 		 * any buffering in the Tx path.
 		 */
 		spin_lock_irqsave(&xs->pool->cq_lock, flags);
-		if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
+		if (xskq_prod_reserve(xs->pool->cq)) {
 			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 			kfree_skb(skb);
 			goto out;
 		}
 		spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 
-		skb->dev = xs->dev;
-		skb->priority = sk->sk_priority;
-		skb->mark = sk->sk_mark;
-		skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
-		skb->destructor = xsk_destruct_skb;
-
 		err = __dev_direct_xmit(skb, xs->queue_id);
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */
-- 
1.8.3.1

