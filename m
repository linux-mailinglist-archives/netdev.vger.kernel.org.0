Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3282A65FF
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbgKDOKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730019AbgKDOJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:09:56 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D3BC0613D3;
        Wed,  4 Nov 2020 06:09:56 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id z24so16726275pgk.3;
        Wed, 04 Nov 2020 06:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ufTyCT2pMTgNA7C6M66JqcRbCYMojzXJdvFS3omWjsg=;
        b=FMM6T2W0QUATA7ZOklbC45++200vI8c9nAWczfyULREkfsX1Kqdz2qR4iL4BN8u3Yn
         1TRm/B0nXP9t+HXicSpXdG1t14dBaw+Q3i6b0LWRoe6tM/Okyf5sFXjaXT3/aahaXac6
         +ERg/8s8Llo2Ya5tkEKwP40ATFmbVXp1zRxL2aOSZ42t86bizQPPGeYxdIFugiSzirPD
         Bp0yOMHcBh7oAtYbEPg60cj/vYep/pUdnjazswbtSJ3PZyctuWG8V/TJR3p4NpMVjRsJ
         aJ6NbuTcNjW3xOHTIlcEfGc0XMJdKX4bhW4+hEzccBO5QrA0Shz2hkxByFvk8vzODHd8
         drVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ufTyCT2pMTgNA7C6M66JqcRbCYMojzXJdvFS3omWjsg=;
        b=Gvxl5jyP4To6fMl7eTtvWPuBuCEyj+cBSGClCvs8I/mmKYiFFmkpGNkIHQHXGWe1GG
         iqpQuVc93+ydGlsMoKGXVYadJ+qD1i1RvodSse5iZ0QrLlx3m695bbvrVYmvm1ztLssq
         zEk4KSAC0i0rb0IcOd1BshjhVc4bi3ADiabgvWWmO6k7sSgU50TDxixgV8AgqkxBsQOa
         3bEn4nViBjJ6mMLnoshsjDP6FkOJuQjYepKav1Nwkse4v7GvXfLSKJJji/oClgTiGST+
         nTahBuvbiWNlbfpjSCCHdZIBEJEQxM1zW9ITWxNXV7udcywPk8VoypG7jo4XYUnh9+xS
         pXeQ==
X-Gm-Message-State: AOAM530Q2uoJux3TKVzcUtGiNi+yxqOAvDcK2k5btUQXcUWTYT1uJUhZ
        Wxw8A/lrIcl/GbMYIVaMuKc=
X-Google-Smtp-Source: ABdhPJykm108/rCOikMAhuf6A0/pjoGXjXL9cgTTLxvpyGUlixQGgQFCzAV/ImD6icupYgcs1mQlhw==
X-Received: by 2002:a05:6a00:148a:b029:18b:1ce6:4741 with SMTP id v10-20020a056a00148ab029018b1ce64741mr10213535pfu.49.1604498995537;
        Wed, 04 Nov 2020 06:09:55 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q123sm2724818pfq.56.2020.11.04.06.09.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 06:09:55 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 5/6] xsk: introduce batched Tx descriptor interfaces
Date:   Wed,  4 Nov 2020 15:09:01 +0100
Message-Id: <1604498942-24274-6-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Introduce batched descriptor interfaces in the xsk core code for the
Tx path to be used in the driver to write a code path with higher
performance. This interface will be used by the i40e driver in the
next patch. Though other drivers would likely benefit from this new
interface too.

Note that batching is only implemented for the common case when
there is only one socket bound to the same device and queue id. When
this is not the case, we fall back to the old non-batched version of
the function.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xdp_sock_drv.h |  7 ++++
 net/xdp/xsk.c              | 43 ++++++++++++++++++++++
 net/xdp/xsk_queue.h        | 89 +++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 126 insertions(+), 13 deletions(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 5b1ee8a..4e295541 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -13,6 +13,7 @@
 
 void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries);
 bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc);
+u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *desc, u32 max);
 void xsk_tx_release(struct xsk_buff_pool *pool);
 struct xsk_buff_pool *xsk_get_pool_from_qid(struct net_device *dev,
 					    u16 queue_id);
@@ -128,6 +129,12 @@ static inline bool xsk_tx_peek_desc(struct xsk_buff_pool *pool,
 	return false;
 }
 
+static inline u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *desc,
+						 u32 max)
+{
+	return 0;
+}
+
 static inline void xsk_tx_release(struct xsk_buff_pool *pool)
 {
 }
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index b71a32e..dd75b5f 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -332,6 +332,49 @@ bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
 }
 EXPORT_SYMBOL(xsk_tx_peek_desc);
 
+u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *descs,
+				   u32 max_entries)
+{
+	struct xdp_sock *xs;
+	u32 nb_pkts;
+
+	rcu_read_lock();
+	if (!list_is_singular(&pool->xsk_tx_list)) {
+		/* Fallback to the non-batched version */
+		rcu_read_unlock();
+		return xsk_tx_peek_desc(pool, &descs[0]) ? 1 : 0;
+	}
+
+	xs = list_first_or_null_rcu(&pool->xsk_tx_list, struct xdp_sock, tx_list);
+
+	nb_pkts = xskq_cons_peek_desc_batch(xs->tx, descs, pool, max_entries);
+	if (!nb_pkts) {
+		xs->tx->queue_empty_descs++;
+		goto out;
+	}
+
+	/* This is the backpressure mechanism for the Tx path. Try to
+	 * reserve space in the completion queue for all packets, but
+	 * if there are fewer slots available, just process that many
+	 * packets. This avoids having to implement any buffering in
+	 * the Tx path.
+	 */
+	nb_pkts = xskq_prod_reserve_addr_batch(pool->cq, descs, nb_pkts);
+	if (!nb_pkts)
+		goto out;
+
+	xskq_cons_release_n(xs->tx, nb_pkts);
+	__xskq_cons_release(xs->tx);
+	xs->sk.sk_write_space(&xs->sk);
+	rcu_read_unlock();
+	return nb_pkts;
+
+out:
+	rcu_read_unlock();
+	return 0;
+}
+EXPORT_SYMBOL(xsk_tx_peek_release_desc_batch);
+
 static int xsk_wakeup(struct xdp_sock *xs, u8 flags)
 {
 	struct net_device *dev = xs->dev;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 74fac80..a85c7e9 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -199,6 +199,33 @@ static inline bool xskq_cons_read_desc(struct xsk_queue *q,
 	return false;
 }
 
+static inline u32 xskq_cons_read_desc_batch(struct xsk_queue *q,
+					    struct xdp_desc *descs,
+					    struct xsk_buff_pool *pool, u32 max)
+{
+	u32 cached_cons = q->cached_cons, nb_entries = 0;
+
+	while (cached_cons != q->cached_prod && nb_entries < max) {
+		struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
+		u32 idx = cached_cons & q->ring_mask;
+
+		descs[nb_entries] = ring->desc[idx];
+		if (unlikely(!xskq_cons_is_valid_desc(q, &descs[nb_entries], pool))) {
+			if (nb_entries) {
+				/* Invalid entry detected. Return what we have. */
+				return nb_entries;
+			}
+			/* Use non-batch version to progress beyond invalid entry/entries */
+			return xskq_cons_read_desc(q, descs, pool) ? 1 : 0;
+		}
+
+		nb_entries++;
+		cached_cons++;
+	}
+
+	return nb_entries;
+}
+
 /* Functions for consumers */
 
 static inline void __xskq_cons_release(struct xsk_queue *q)
@@ -220,17 +247,22 @@ static inline void xskq_cons_get_entries(struct xsk_queue *q)
 	__xskq_cons_peek(q);
 }
 
-static inline bool xskq_cons_has_entries(struct xsk_queue *q, u32 cnt)
+static inline u32 xskq_cons_nb_entries(struct xsk_queue *q, u32 max)
 {
 	u32 entries = q->cached_prod - q->cached_cons;
 
-	if (entries >= cnt)
-		return true;
+	if (entries >= max)
+		return max;
 
 	__xskq_cons_peek(q);
 	entries = q->cached_prod - q->cached_cons;
 
-	return entries >= cnt;
+	return entries >= max ? max : entries;
+}
+
+static inline bool xskq_cons_has_entries(struct xsk_queue *q, u32 cnt)
+{
+	return xskq_cons_nb_entries(q, cnt) >= cnt ? true : false;
 }
 
 static inline bool xskq_cons_peek_addr_unchecked(struct xsk_queue *q, u64 *addr)
@@ -249,16 +281,28 @@ static inline bool xskq_cons_peek_desc(struct xsk_queue *q,
 	return xskq_cons_read_desc(q, desc, pool);
 }
 
+static inline u32 xskq_cons_peek_desc_batch(struct xsk_queue *q, struct xdp_desc *descs,
+					    struct xsk_buff_pool *pool, u32 max)
+{
+	u32 entries = xskq_cons_nb_entries(q, max);
+
+	return xskq_cons_read_desc_batch(q, descs, pool, entries);
+}
+
+/* To improve performance in the xskq_cons_release functions, only update local state here.
+ * Reflect this to global state when we get new entries from the ring in
+ * xskq_cons_get_entries() and whenever Rx or Tx processing are completed in the NAPI loop.
+ */
 static inline void xskq_cons_release(struct xsk_queue *q)
 {
-	/* To improve performance, only update local state here.
-	 * Reflect this to global state when we get new entries
-	 * from the ring in xskq_cons_get_entries() and whenever
-	 * Rx or Tx processing are completed in the NAPI loop.
-	 */
 	q->cached_cons++;
 }
 
+static inline void xskq_cons_release_n(struct xsk_queue *q, u32 cnt)
+{
+	q->cached_cons += cnt;
+}
+
 static inline bool xskq_cons_is_full(struct xsk_queue *q)
 {
 	/* No barriers needed since data is not accessed */
@@ -268,18 +312,23 @@ static inline bool xskq_cons_is_full(struct xsk_queue *q)
 
 /* Functions for producers */
 
-static inline bool xskq_prod_is_full(struct xsk_queue *q)
+static inline u32 xskq_prod_nb_free(struct xsk_queue *q, u32 max)
 {
 	u32 free_entries = q->nentries - (q->cached_prod - q->cached_cons);
 
-	if (free_entries)
-		return false;
+	if (free_entries >= max)
+		return max;
 
 	/* Refresh the local tail pointer */
 	q->cached_cons = READ_ONCE(q->ring->consumer);
 	free_entries = q->nentries - (q->cached_prod - q->cached_cons);
 
-	return !free_entries;
+	return free_entries >= max ? max : free_entries;
+}
+
+static inline bool xskq_prod_is_full(struct xsk_queue *q)
+{
+	return xskq_prod_nb_free(q, 1) ? false : true;
 }
 
 static inline int xskq_prod_reserve(struct xsk_queue *q)
@@ -304,6 +353,20 @@ static inline int xskq_prod_reserve_addr(struct xsk_queue *q, u64 addr)
 	return 0;
 }
 
+static inline u32 xskq_prod_reserve_addr_batch(struct xsk_queue *q, struct xdp_desc *descs,
+					       u32 max)
+{
+	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
+	u32 nb_entries, i;
+
+	nb_entries = xskq_prod_nb_free(q, max);
+
+	/* A, matches D */
+	for (i = 0; i < nb_entries; i++)
+		ring->desc[q->cached_prod++ & q->ring_mask] = descs[i].addr;
+	return nb_entries;
+}
+
 static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
 					 u64 addr, u32 len)
 {
-- 
2.7.4

