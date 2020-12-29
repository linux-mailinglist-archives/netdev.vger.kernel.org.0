Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F162E6EF3
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 09:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgL2Id0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 03:33:26 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:59191 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbgL2Id0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 03:33:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0UK7gJ7u_1609230761;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UK7gJ7u_1609230761)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 29 Dec 2020 16:32:41 +0800
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
        KP Singh <kpsingh@kernel.org>,
        netdev@vger.kernel.org (open list:XDP SOCKETS (AF_XDP)),
        bpf@vger.kernel.org (open list:XDP SOCKETS (AF_XDP)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH bpf-next] xsk: build skb by page
Date:   Tue, 29 Dec 2020 16:32:41 +0800
Message-Id: <3fab080e36b322b6749190ad6054d53c67658050.1609230615.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <CAJ8uoz2Enx-WwY6RmCp0RXBG2U3BUpagw-X8hQChPResHCM-XA@mail.gmail.com>
References: <CAJ8uoz2Enx-WwY6RmCp0RXBG2U3BUpagw-X8hQChPResHCM-XA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is used to construct skb based on page to save memory copy
overhead.

Taking into account the problem of addr unaligned, and the
possibility of frame size greater than page in the future.

The test environment is Aliyun ECS server.
Test cmd:
```
xdpsock -i eth0 -t  -S -s <msg size>
```

Test result data:

size 	64	512	1024	1500
copy	1916747	1775988	1600203	1440054
page	1974058	1953655	1945463	1904478
percent	3.0%	10.0%	21.58%	32.3%

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 net/xdp/xsk.c | 68 ++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 51 insertions(+), 17 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index ac4a317..7cab40f 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -430,6 +430,55 @@ static void xsk_destruct_skb(struct sk_buff *skb)
 	sock_wfree(skb);
 }
 
+static struct sk_buff *xsk_build_skb_bypage(struct xdp_sock *xs, struct xdp_desc *desc)
+{
+	char *buffer;
+	u64 addr;
+	u32 len, offset, copy, copied;
+	int err, i;
+	struct page *page;
+	struct sk_buff *skb;
+
+	skb = sock_alloc_send_skb(&xs->sk, 0, 1, &err);
+	if (unlikely(!skb))
+		return NULL;
+
+	addr = desc->addr;
+	len = desc->len;
+
+	buffer = xsk_buff_raw_get_data(xs->pool, addr);
+	offset = offset_in_page(buffer);
+	addr = buffer - (char *)xs->pool->addrs;
+
+	for (copied = 0, i = 0; copied < len; ++i) {
+		page = xs->pool->umem->pgs[addr >> PAGE_SHIFT];
+
+		get_page(page);
+
+		copy = min((u32)(PAGE_SIZE - offset), len - copied);
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
+	skb->dev = xs->dev;
+	skb->priority = xs->sk.sk_priority;
+	skb->mark = xs->sk.sk_mark;
+	skb_shinfo(skb)->destructor_arg = (void *)(long)addr;
+	skb->destructor = xsk_destruct_skb;
+
+	return skb;
+}
+
 static int xsk_generic_xmit(struct sock *sk)
 {
 	struct xdp_sock *xs = xdp_sk(sk);
@@ -445,40 +494,25 @@ static int xsk_generic_xmit(struct sock *sk)
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
+		skb = xsk_build_skb_bypage(xs, &desc);
 		if (unlikely(!skb))
 			goto out;
 
-		skb_put(skb, len);
-		addr = desc.addr;
-		buffer = xsk_buff_raw_get_data(xs->pool, addr);
-		err = skb_store_bits(skb, 0, buffer, len);
 		/* This is the backpressure mechanism for the Tx path.
 		 * Reserve space in the completion queue and only proceed
 		 * if there is space in it. This avoids having to implement
 		 * any buffering in the Tx path.
 		 */
-		if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
+		if (xskq_prod_reserve(xs->pool->cq)) {
 			kfree_skb(skb);
 			goto out;
 		}
 
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

