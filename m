Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D652B4262
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729672AbgKPLOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbgKPLOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 06:14:00 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2CCC0613CF;
        Mon, 16 Nov 2020 03:14:00 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id y7so13759052pfq.11;
        Mon, 16 Nov 2020 03:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pZBIYR9Vsszru6gWE0NAdBHVbZCybbTOMnigiUKuqKA=;
        b=o8zOWKeXFeroKrE1LWWiYr/9QCAEfXcCx8ROTvETgOfOo3ACYv9TdiscoMRs/+Mzi+
         WSM6edIDjaHPrjuygOrchcoGvpnl+YqBaBsQaNHwHmwhLjePMQMzIuBoPbWZlH2QnxVB
         hdMl6b3/j0kBcmfYlTGZXD2LBQGJCfLbVkrjT5Lm4uOzURbTfgNy5/zgMTNXy2LY3GPl
         GmTe9PNXPlpryY7CWzt3mVHsicLZjU4Bb6TI0KHcauBGJgZY/O8/Iq0DYdY/KYt7F6LZ
         9Wn8fcgnKzNwUGM2JxBgUSd2ETlYalwQn16kG2Xgne7c6m84BqfjFSlHaMkWmlTPe0RH
         xlwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pZBIYR9Vsszru6gWE0NAdBHVbZCybbTOMnigiUKuqKA=;
        b=LdpCoME2ZT5S0oCQ0d1FdUmzF3QIoUF+JeQhaZJeUruCuaTSOs5H3+MXNiz7U3tyFA
         2zlAvjjmaOn4LK3Ui86J6HbAtPv+3SD1OXIW2f1ufFn6II3oiv6FXozagmohJcTZ4Cul
         TnxA/iYC7bRJTnGRM76nHJjpYWqt0UQr67GbIjPqivAHgNtIHvTKeKt+QwaXhsQZTbVG
         Jf/eRm4sB5LLu9gn7k6+w5cpKjBBEZYQybotR/OBsao7DlHKYCE+EA3Nu5xWUIncZjVR
         giNQB7oJsVcbP4kDMwIkeb8PPGUa+ZG/BnURPGbgw3I3iIG6xyUWIIHhCfnsZeg2a0ZH
         ZQjQ==
X-Gm-Message-State: AOAM533ZaaLYID+NxLswGbWu1Wh7BjHr/fPKIy3U+BZkrtta9URUJrkw
        bUKJhHSIq1o1itOF/9Ycrns=
X-Google-Smtp-Source: ABdhPJz8KgiVNYOz4K9DL7/5E04urJP/WDBKsJKwE6qHP6R2zsukEMXFyd9SaRlF4eBgvGyx3BJ9wA==
X-Received: by 2002:a17:90a:ea92:: with SMTP id h18mr3020886pjz.14.1605525240162;
        Mon, 16 Nov 2020 03:14:00 -0800 (PST)
Received: from localhost.localdomain ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id u24sm19486826pfm.81.2020.11.16.03.13.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2020 03:13:59 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, kuba@kernel.org, john.fastabend@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v3 4/5] xsk: introduce batched Tx descriptor interfaces
Date:   Mon, 16 Nov 2020 12:12:46 +0100
Message-Id: <1605525167-14450-5-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605525167-14450-1-git-send-email-magnus.karlsson@gmail.com>
References: <1605525167-14450-1-git-send-email-magnus.karlsson@gmail.com>
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
 net/xdp/xsk.c              | 57 +++++++++++++++++++++++++++++
 net/xdp/xsk_queue.h        | 89 +++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 140 insertions(+), 13 deletions(-)

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
index cfbec39..b014197 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -332,6 +332,63 @@ bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
 }
 EXPORT_SYMBOL(xsk_tx_peek_desc);
 
+static u32 xsk_tx_peek_release_fallback(struct xsk_buff_pool *pool, struct xdp_desc *descs,
+					u32 max_entries)
+{
+	u32 nb_pkts = 0;
+
+	while (nb_pkts < max_entries && xsk_tx_peek_desc(pool, &descs[nb_pkts]))
+		nb_pkts++;
+
+	xsk_tx_release(pool);
+	return nb_pkts;
+}
+
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
+		return xsk_tx_peek_release_fallback(pool, descs, max_entries);
+	}
+
+	xs = list_first_or_null_rcu(&pool->xsk_tx_list, struct xdp_sock, tx_list);
+	if (!xs) {
+		nb_pkts = 0;
+		goto out;
+	}
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
+
+out:
+	rcu_read_unlock();
+	return nb_pkts;
+}
+EXPORT_SYMBOL(xsk_tx_peek_release_desc_batch);
+
 static int xsk_wakeup(struct xdp_sock *xs, u8 flags)
 {
 	struct net_device *dev = xs->dev;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 74fac80..b936c46 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -199,6 +199,30 @@ static inline bool xskq_cons_read_desc(struct xsk_queue *q,
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
+			/* Skip the entry */
+			cached_cons++;
+			continue;
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
@@ -220,17 +244,22 @@ static inline void xskq_cons_get_entries(struct xsk_queue *q)
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
@@ -249,16 +278,28 @@ static inline bool xskq_cons_peek_desc(struct xsk_queue *q,
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
@@ -268,18 +309,23 @@ static inline bool xskq_cons_is_full(struct xsk_queue *q)
 
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
@@ -304,6 +350,23 @@ static inline int xskq_prod_reserve_addr(struct xsk_queue *q, u64 addr)
 	return 0;
 }
 
+static inline u32 xskq_prod_reserve_addr_batch(struct xsk_queue *q, struct xdp_desc *descs,
+					       u32 max)
+{
+	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
+	u32 nb_entries, i, cached_prod;
+
+	nb_entries = xskq_prod_nb_free(q, max);
+
+	/* A, matches D */
+	cached_prod = q->cached_prod;
+	for (i = 0; i < nb_entries; i++)
+		ring->desc[cached_prod++ & q->ring_mask] = descs[i].addr;
+	q->cached_prod = cached_prod;
+
+	return nb_entries;
+}
+
 static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
 					 u64 addr, u32 len)
 {
-- 
2.7.4

