Return-Path: <netdev+bounces-3732-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B98A3708788
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 20:08:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75012280A57
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2379449B3;
	Thu, 18 May 2023 18:06:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941B3449B1;
	Thu, 18 May 2023 18:06:11 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADCBC2;
	Thu, 18 May 2023 11:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684433170; x=1715969170;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tHcLMTkuK8RFIe6q3fYVgEI06b/qhxmSTSet7FSe1rQ=;
  b=GLkIFbdAgBIABhwHxUQsD7uBhttLi5coaZefnWFUxgZVMmY3uLyz2vjA
   iufztd9FoNrjRKPNQA8hqVX4wmlrSPZDMkfwT7WL6HErwmBwacZITG2n9
   yCRsLDX6TI2aFZCRrdT+MlnWra7imK0piypWFF2QqYJSUQ+T6YaUUjo1I
   IFMvl3JKz/m23f+Pr7LEGI1L4S6FHD1VGnwjfOTdxetHlKZ05iv7PiSwl
   81yT7RCCw2p3bF7gnyDtcKgVP5Zcqltz+5rtc0c3nf5hEa9qbJQJtKFcM
   N8Nc5fDMSIclERopQC4t+04Q50q3qx7fsRerr3Vlzy1SFkX+IioDLUkyv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="350984798"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="350984798"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 11:06:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="948780228"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="948780228"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga006.fm.intel.com with ESMTP; 18 May 2023 11:06:07 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	tirthendu.sarkar@intel.com,
	maciej.fijalkowski@intel.com,
	bjorn@kernel.org
Subject: [PATCH bpf-next 06/21] xsk: introduce wrappers and helpers for supporting multi-buffer in Tx path
Date: Thu, 18 May 2023 20:05:30 +0200
Message-Id: <20230518180545.159100-7-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
References: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
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

In Tx path, xsk core reserves space for each desc to be transmitted in
the completion queue and it's address contained in it is stored in the
skb destructor arg. After successful transmission the skb destructor
submits the addr marking completion.

To handle multiple descriptors per packet, now along with reserving
space for each descriptor, the corresponding address is also stored in
completion queue. The number of pending descriptors are stored in skb
destructor arg and is used by the skb destructor to update completions.

Introduce 'skb' in xdp_sock to store a partially built packet when
__xsk_generic_xmit() must return before it sees the EOP descriptor for
the current packet so that packet building can resume in next call of
__xsk_generic_xmit().

Helper functions are introduced to set and get the pending descriptors
in the skb destructor arg. Also, wrappers are introduced for storing
descriptor addresses, submitting and cancelling (for unsuccessful
transmissions) the number of completions.

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
---
 include/net/xdp_sock.h |  6 ++++
 net/xdp/xsk.c          | 74 ++++++++++++++++++++++++++++++------------
 net/xdp/xsk_queue.h    | 19 ++++-------
 3 files changed, 67 insertions(+), 32 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 36b0411a0d1b..1617af380162 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -68,6 +68,12 @@ struct xdp_sock {
 	u64 rx_dropped;
 	u64 rx_queue_full;
 
+	/* When __xsk_generic_xmit() must return before it sees the EOP descriptor for the current
+	 * packet, the partially built skb is saved here so that packet building can resume in next
+	 * call of __xsk_generic_xmit().
+	 */
+	struct sk_buff *skb;
+
 	struct list_head map_list;
 	/* Protects map_list */
 	spinlock_t map_list_lock;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 86d8b23ae0a7..29bda8452e2c 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -480,19 +480,65 @@ static int xsk_wakeup(struct xdp_sock *xs, u8 flags)
 	return dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id, flags);
 }
 
-static void xsk_destruct_skb(struct sk_buff *skb)
+static int xsk_cq_reserve_addr_locked(struct xdp_sock *xs, u64 addr)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&xs->pool->cq_lock, flags);
+	ret = xskq_prod_reserve_addr(xs->pool->cq, addr);
+	spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
+
+	return ret;
+}
+
+static void xsk_cq_submit_locked(struct xdp_sock *xs, u32 n)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&xs->pool->cq_lock, flags);
+	xskq_prod_submit_n(xs->pool->cq, n);
+	spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
+}
+
+static void xsk_cq_cancel_locked(struct xdp_sock *xs, u32 n)
 {
-	u64 addr = (u64)(long)skb_shinfo(skb)->destructor_arg;
-	struct xdp_sock *xs = xdp_sk(skb->sk);
 	unsigned long flags;
 
 	spin_lock_irqsave(&xs->pool->cq_lock, flags);
-	xskq_prod_submit_addr(xs->pool->cq, addr);
+	xskq_prod_cancel_n(xs->pool->cq, n);
 	spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
+}
+
+static u32 xsk_get_num_desc(struct sk_buff *skb)
+{
+	return skb ? (long)skb_shinfo(skb)->destructor_arg : 0;
+}
 
+static void xsk_destruct_skb(struct sk_buff *skb)
+{
+	xsk_cq_submit_locked(xdp_sk(skb->sk), xsk_get_num_desc(skb));
 	sock_wfree(skb);
 }
 
+static void xsk_set_destructor_arg(struct sk_buff *skb)
+{
+	long num = xsk_get_num_desc(xdp_sk(skb->sk)->skb) + 1;
+
+	skb_shinfo(skb)->destructor_arg = (void *)num;
+}
+
+static void xsk_consume_skb(struct sk_buff *skb)
+{
+	struct xdp_sock *xs = xdp_sk(skb->sk);
+
+	skb->destructor = sock_wfree;
+	xsk_cq_cancel_locked(xs, xsk_get_num_desc(skb));
+	/* Free skb without triggering the perf drop trace */
+	consume_skb(skb);
+	xs->skb = NULL;
+}
+
 static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
 					      struct xdp_desc *desc)
 {
@@ -578,8 +624,8 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 	skb->dev = dev;
 	skb->priority = xs->sk.sk_priority;
 	skb->mark = xs->sk.sk_mark;
-	skb_shinfo(skb)->destructor_arg = (void *)(long)desc->addr;
 	skb->destructor = xsk_destruct_skb;
+	xsk_set_destructor_arg(skb);
 
 	return skb;
 }
@@ -591,7 +637,6 @@ static int __xsk_generic_xmit(struct sock *sk)
 	bool sent_frame = false;
 	struct xdp_desc desc;
 	struct sk_buff *skb;
-	unsigned long flags;
 	int err = 0;
 
 	mutex_lock(&xs->mutex);
@@ -616,31 +661,20 @@ static int __xsk_generic_xmit(struct sock *sk)
 		 * if there is space in it. This avoids having to implement
 		 * any buffering in the Tx path.
 		 */
-		spin_lock_irqsave(&xs->pool->cq_lock, flags);
-		if (xskq_prod_reserve(xs->pool->cq)) {
-			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
+		if (xsk_cq_reserve_addr_locked(xs, desc.addr))
 			goto out;
-		}
-		spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 
 		skb = xsk_build_skb(xs, &desc);
 		if (IS_ERR(skb)) {
 			err = PTR_ERR(skb);
-			spin_lock_irqsave(&xs->pool->cq_lock, flags);
-			xskq_prod_cancel(xs->pool->cq);
-			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
+			xsk_cq_cancel_locked(xs, 1);
 			goto out;
 		}
 
 		err = __dev_direct_xmit(skb, xs->queue_id);
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */
-			skb->destructor = sock_wfree;
-			spin_lock_irqsave(&xs->pool->cq_lock, flags);
-			xskq_prod_cancel(xs->pool->cq);
-			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
-			/* Free skb without triggering the perf drop trace */
-			consume_skb(skb);
+			xsk_consume_skb(skb);
 			err = -EAGAIN;
 			goto out;
 		}
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index ad81b19e6fdf..4190f43ce0b0 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -297,6 +297,11 @@ static inline void xskq_cons_release(struct xsk_queue *q)
 	q->cached_cons++;
 }
 
+static inline void xskq_cons_cancel_n(struct xsk_queue *q, u32 cnt)
+{
+	q->cached_cons -= cnt;
+}
+
 static inline u32 xskq_cons_present_entries(struct xsk_queue *q)
 {
 	/* No barriers needed since data is not accessed */
@@ -324,9 +329,9 @@ static inline bool xskq_prod_is_full(struct xsk_queue *q)
 	return xskq_prod_nb_free(q, 1) ? false : true;
 }
 
-static inline void xskq_prod_cancel(struct xsk_queue *q)
+static inline void xskq_prod_cancel_n(struct xsk_queue *q, u32 cnt)
 {
-	q->cached_prod--;
+	q->cached_prod -= cnt;
 }
 
 static inline int xskq_prod_reserve(struct xsk_queue *q)
@@ -392,16 +397,6 @@ static inline void xskq_prod_submit(struct xsk_queue *q)
 	__xskq_prod_submit(q, q->cached_prod);
 }
 
-static inline void xskq_prod_submit_addr(struct xsk_queue *q, u64 addr)
-{
-	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
-	u32 idx = q->ring->producer;
-
-	ring->desc[idx++ & q->ring_mask] = addr;
-
-	__xskq_prod_submit(q, idx);
-}
-
 static inline void xskq_prod_submit_n(struct xsk_queue *q, u32 nb_entries)
 {
 	__xskq_prod_submit(q, q->ring->producer + nb_entries);
-- 
2.34.1


