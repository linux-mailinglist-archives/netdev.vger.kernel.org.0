Return-Path: <netdev+bounces-8059-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5D9D72298C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:48:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CE5F2812E6
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8318420995;
	Mon,  5 Jun 2023 14:45:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F81C20993;
	Mon,  5 Jun 2023 14:45:19 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254809E;
	Mon,  5 Jun 2023 07:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685976318; x=1717512318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wq9FbPgQmIW+or2JkT+LNCE92fGd6AdakPXgGmuXIAA=;
  b=l4KSNjl62YdaeMS4ScS9NwjxV4G+pNMdaInqHvc6H5EhT3NBo3qonI9d
   kkJLjHcPPvocrnIjvEQnaZLNqPhKs+UW0PAjn69V9xefnP6jIDh8XllOW
   6DSJl1JcRYbepiWnPYpYaneUJ1xsW6iyManTh8L0NNfLHqqUQHaZMBNc7
   lnuBg7WidvUqCSNqzUjUut3cfSEaX3U1W3vyVjCQA+G6ZZsgXFXv12rEQ
   AIVj8uB9blXCvrkxhC3Z8g6jFi35Hog7jcK7p/Jko0ewKAdJ+fP0KDSRG
   YT+4RRQjxoopkTOQ+eGqy1vt5LT9yyyAYOfWfS3IXS6cMqoTUbtTtkZbW
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="442757889"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="442757889"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 07:45:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="798464203"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="798464203"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Jun 2023 07:45:15 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	bjorn@kernel.org,
	tirthendu.sarkar@intel.com,
	maciej.fijalkowski@intel.com,
	simon.horman@corigine.com
Subject: [PATCH v3 bpf-next 08/22] xsk: add support for AF_XDP multi-buffer on Tx path
Date: Mon,  5 Jun 2023 16:44:19 +0200
Message-Id: <20230605144433.290114-9-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230605144433.290114-1-maciej.fijalkowski@intel.com>
References: <20230605144433.290114-1-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>

For transmitting an AF_XDP packet, allocate skb while processing the
first desc and copy data to it. The 'XDP_PKT_CONTD' flag in 'options'
field of the desc indicates the EOP status of the packet. If the current
desc is not EOP, store the skb, release the current desc and go
on to read the next descs.

Allocate a page for each subsequent desc, copy data to it and add it as
a frag in the skb stored in xsk. On processing EOP, transmit the skb
with frags. Addresses contained in descs have been already queued in
consumer queue and skb destructor updated the completion count.

On transmit failure cancel the releases, clear the descs from the
completion queue and consume the skb for retrying packet transmission.

For any invalid descriptor (invalid length/address/options) in the middle
of a packet, all pending descriptors will be dropped by xsk core along
with the invalid one and the next descriptor is treated as the start of
a new packet.

Maximum supported frames for a packet is MAX_SKB_FRAGS + 1. If it is
exceeded, all descriptors accumulated so far are dropped.

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
---
 net/xdp/xsk.c       | 117 +++++++++++++++++++++++++++++++++-----------
 net/xdp/xsk_queue.h |  13 +++--
 2 files changed, 97 insertions(+), 33 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 29bda8452e2c..1f20618df5dd 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -393,7 +393,8 @@ bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
 	rcu_read_lock();
 	list_for_each_entry_rcu(xs, &pool->xsk_tx_list, tx_list) {
 		if (!xskq_cons_peek_desc(xs->tx, desc, pool)) {
-			xs->tx->queue_empty_descs++;
+			if (xskq_has_descs(xs->tx))
+				xskq_cons_release(xs->tx);
 			continue;
 		}
 
@@ -539,24 +540,32 @@ static void xsk_consume_skb(struct sk_buff *skb)
 	xs->skb = NULL;
 }
 
+static void xsk_drop_skb(struct sk_buff *skb)
+{
+	xdp_sk(skb->sk)->tx->invalid_descs += xsk_get_num_desc(skb);
+	xsk_consume_skb(skb);
+}
+
 static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
 					      struct xdp_desc *desc)
 {
 	struct xsk_buff_pool *pool = xs->pool;
 	u32 hr, len, ts, offset, copy, copied;
-	struct sk_buff *skb;
+	struct sk_buff *skb = xs->skb;
 	struct page *page;
 	void *buffer;
 	int err, i;
 	u64 addr;
 
-	hr = max(NET_SKB_PAD, L1_CACHE_ALIGN(xs->dev->needed_headroom));
+	if (!skb) {
+		hr = max(NET_SKB_PAD, L1_CACHE_ALIGN(xs->dev->needed_headroom));
 
-	skb = sock_alloc_send_skb(&xs->sk, hr, 1, &err);
-	if (unlikely(!skb))
-		return ERR_PTR(err);
+		skb = sock_alloc_send_skb(&xs->sk, hr, 1, &err);
+		if (unlikely(!skb))
+			return ERR_PTR(err);
 
-	skb_reserve(skb, hr);
+		skb_reserve(skb, hr);
+	}
 
 	addr = desc->addr;
 	len = desc->len;
@@ -566,7 +575,10 @@ static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
 	offset = offset_in_page(buffer);
 	addr = buffer - pool->addrs;
 
-	for (copied = 0, i = 0; copied < len; i++) {
+	for (copied = 0, i = skb_shinfo(skb)->nr_frags; copied < len; i++) {
+		if (unlikely(i >= MAX_SKB_FRAGS))
+			return ERR_PTR(-EFAULT);
+
 		page = pool->umem->pgs[addr >> PAGE_SHIFT];
 		get_page(page);
 
@@ -591,33 +603,56 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 				     struct xdp_desc *desc)
 {
 	struct net_device *dev = xs->dev;
-	struct sk_buff *skb;
+	struct sk_buff *skb = xs->skb;
+	int err;
 
 	if (dev->priv_flags & IFF_TX_SKB_NO_LINEAR) {
 		skb = xsk_build_skb_zerocopy(xs, desc);
-		if (IS_ERR(skb))
-			return skb;
+		if (IS_ERR(skb)) {
+			err = PTR_ERR(skb);
+			goto free_err;
+		}
 	} else {
 		u32 hr, tr, len;
 		void *buffer;
-		int err;
 
-		hr = max(NET_SKB_PAD, L1_CACHE_ALIGN(dev->needed_headroom));
-		tr = dev->needed_tailroom;
+		buffer = xsk_buff_raw_get_data(xs->pool, desc->addr);
 		len = desc->len;
 
-		skb = sock_alloc_send_skb(&xs->sk, hr + len + tr, 1, &err);
-		if (unlikely(!skb))
-			return ERR_PTR(err);
+		if (!skb) {
+			hr = max(NET_SKB_PAD, L1_CACHE_ALIGN(dev->needed_headroom));
+			tr = dev->needed_tailroom;
+			skb = sock_alloc_send_skb(&xs->sk, hr + len + tr, 1, &err);
+			if (unlikely(!skb))
+				goto free_err;
 
-		skb_reserve(skb, hr);
-		skb_put(skb, len);
+			skb_reserve(skb, hr);
+			skb_put(skb, len);
 
-		buffer = xsk_buff_raw_get_data(xs->pool, desc->addr);
-		err = skb_store_bits(skb, 0, buffer, len);
-		if (unlikely(err)) {
-			kfree_skb(skb);
-			return ERR_PTR(err);
+			err = skb_store_bits(skb, 0, buffer, len);
+			if (unlikely(err))
+				goto free_err;
+		} else {
+			int nr_frags = skb_shinfo(skb)->nr_frags;
+			struct page *page;
+			u8 *vaddr;
+
+			if (unlikely(nr_frags == (MAX_SKB_FRAGS - 1) && xp_mb_desc(desc))) {
+				err = -EFAULT;
+				goto free_err;
+			}
+
+			page = alloc_page(xs->sk.sk_allocation);
+			if (unlikely(!page)) {
+				err = -EAGAIN;
+				goto free_err;
+			}
+
+			vaddr = kmap_local_page(page);
+			memcpy(vaddr, buffer, len);
+			kunmap_local(vaddr);
+
+			skb_add_rx_frag(skb, nr_frags, page, 0, len, 0);
 		}
 	}
 
@@ -628,6 +663,17 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 	xsk_set_destructor_arg(skb);
 
 	return skb;
+
+free_err:
+	if (err == -EAGAIN) {
+		xsk_cq_cancel_locked(xs, 1);
+	} else {
+		xsk_set_destructor_arg(skb);
+		xsk_drop_skb(skb);
+		xskq_cons_release(xs->tx);
+	}
+
+	return ERR_PTR(err);
 }
 
 static int __xsk_generic_xmit(struct sock *sk)
@@ -667,30 +713,45 @@ static int __xsk_generic_xmit(struct sock *sk)
 		skb = xsk_build_skb(xs, &desc);
 		if (IS_ERR(skb)) {
 			err = PTR_ERR(skb);
-			xsk_cq_cancel_locked(xs, 1);
-			goto out;
+			if (err == -EAGAIN)
+				goto out;
+			err = 0;
+			continue;
+		}
+
+		xskq_cons_release(xs->tx);
+
+		if (xp_mb_desc(&desc)) {
+			xs->skb = skb;
+			continue;
 		}
 
 		err = __dev_direct_xmit(skb, xs->queue_id);
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */
+			xskq_cons_cancel_n(xs->tx, xsk_get_num_desc(skb));
 			xsk_consume_skb(skb);
 			err = -EAGAIN;
 			goto out;
 		}
 
-		xskq_cons_release(xs->tx);
 		/* Ignore NET_XMIT_CN as packet might have been sent */
 		if (err == NET_XMIT_DROP) {
 			/* SKB completed but not sent */
 			err = -EBUSY;
+			xs->skb = NULL;
 			goto out;
 		}
 
 		sent_frame = true;
+		xs->skb = NULL;
 	}
 
-	xs->tx->queue_empty_descs++;
+	if (xskq_has_descs(xs->tx)) {
+		if (xs->skb)
+			xsk_drop_skb(xs->skb);
+		xskq_cons_release(xs->tx);
+	}
 
 out:
 	if (sent_frame)
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 4190f43ce0b0..2d2af9fc2744 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -175,6 +175,11 @@ static inline bool xp_validate_desc(struct xsk_buff_pool *pool,
 		xp_aligned_validate_desc(pool, desc);
 }
 
+static inline bool xskq_has_descs(struct xsk_queue *q)
+{
+	return q->cached_cons != q->cached_prod;
+}
+
 static inline bool xskq_cons_is_valid_desc(struct xsk_queue *q,
 					   struct xdp_desc *d,
 					   struct xsk_buff_pool *pool)
@@ -190,17 +195,15 @@ static inline bool xskq_cons_read_desc(struct xsk_queue *q,
 				       struct xdp_desc *desc,
 				       struct xsk_buff_pool *pool)
 {
-	while (q->cached_cons != q->cached_prod) {
+	if (q->cached_cons != q->cached_prod) {
 		struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
 		u32 idx = q->cached_cons & q->ring_mask;
 
 		*desc = ring->desc[idx];
-		if (xskq_cons_is_valid_desc(q, desc, pool))
-			return true;
-
-		q->cached_cons++;
+		return xskq_cons_is_valid_desc(q, desc, pool);
 	}
 
+	q->queue_empty_descs++;
 	return false;
 }
 
-- 
2.34.1


