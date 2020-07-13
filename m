Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B5D21B824
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 16:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgGJORT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 10:17:19 -0400
Received: from mga06.intel.com ([134.134.136.31]:32693 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgGJORR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 10:17:17 -0400
IronPort-SDR: PpCIfwTXz1CBbxH8QVtWfbtwapjRbmDh0ER/3QvPHLiKiwMYZm3nvMGYY/kc+KqVQbUSAR8D6w
 vrOuZKHTnbEQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="209731667"
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="209731667"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 07:17:16 -0700
IronPort-SDR: JWDRAnvqhf2ltb20jDL6WfjG8TPVGwfdpumAqXAo/CXcoQPUXk7FcmmZbferi6Ej/o6Iw/yLXl
 2dAdgyGVUa1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="428575438"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.54.29])
  by orsmga004.jf.intel.com with ESMTP; 10 Jul 2020 07:17:12 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next v2 07/14] xsk: move addrs from buffer pool to umem
Date:   Fri, 10 Jul 2020 16:16:35 +0200
Message-Id: <1594390602-7635-8-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594390602-7635-1-git-send-email-magnus.karlsson@intel.com>
References: <1594390602-7635-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replicate the addrs pointer in the buffer pool to the umem. This mapping
will be the same for all buffer pools sharing the same umem. In the
buffer pool we leave the addrs pointer for performance reasons.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xdp_sock.h  |  1 +
 net/xdp/xdp_umem.c      | 22 ++++++++++++++++++++++
 net/xdp/xsk_buff_pool.c | 21 ++-------------------
 3 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index fa1d127..6b99c80 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -18,6 +18,7 @@ struct xsk_queue;
 struct xdp_buff;
 
 struct xdp_umem {
+	void *addrs;
 	u64 size;
 	u32 headroom;
 	u32 chunk_size;
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index a871c75..372998d 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -39,11 +39,27 @@ static void xdp_umem_unaccount_pages(struct xdp_umem *umem)
 	}
 }
 
+static void xdp_umem_addr_unmap(struct xdp_umem *umem)
+{
+	vunmap(umem->addrs);
+	umem->addrs = NULL;
+}
+
+static int xdp_umem_addr_map(struct xdp_umem *umem, struct page **pages,
+			     u32 nr_pages)
+{
+	umem->addrs = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	if (!umem->addrs)
+		return -ENOMEM;
+	return 0;
+}
+
 static void xdp_umem_release(struct xdp_umem *umem)
 {
 	umem->zc = false;
 	ida_simple_remove(&umem_ida, umem->id);
 
+	xdp_umem_addr_unmap(umem);
 	xdp_umem_unpin_pages(umem);
 
 	xdp_umem_unaccount_pages(umem);
@@ -193,8 +209,14 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (err)
 		goto out_account;
 
+	err = xdp_umem_addr_map(umem, umem->pgs, umem->npgs);
+	if (err)
+		goto out_unpin;
+
 	return 0;
 
+out_unpin:
+	xdp_umem_unpin_pages(umem);
 out_account:
 	xdp_umem_unaccount_pages(umem);
 	return err;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 09ef2a7..9e50d2e 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -35,26 +35,11 @@ void xp_del_xsk(struct xsk_buff_pool *pool, struct xdp_sock *xs)
 	spin_unlock_irqrestore(&pool->xsk_tx_list_lock, flags);
 }
 
-static void xp_addr_unmap(struct xsk_buff_pool *pool)
-{
-	vunmap(pool->addrs);
-}
-
-static int xp_addr_map(struct xsk_buff_pool *pool,
-		       struct page **pages, u32 nr_pages)
-{
-	pool->addrs = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
-	if (!pool->addrs)
-		return -ENOMEM;
-	return 0;
-}
-
 void xp_destroy(struct xsk_buff_pool *pool)
 {
 	if (!pool)
 		return;
 
-	xp_addr_unmap(pool);
 	kvfree(pool->heads);
 	kvfree(pool);
 }
@@ -64,7 +49,6 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 {
 	struct xsk_buff_pool *pool;
 	struct xdp_buff_xsk *xskb;
-	int err;
 	u32 i;
 
 	pool = kvzalloc(struct_size(pool, free_heads, umem->chunks),
@@ -87,6 +71,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 	pool->frame_len = umem->chunk_size - umem->headroom -
 		XDP_PACKET_HEADROOM;
 	pool->umem = umem;
+	pool->addrs = umem->addrs;
 	INIT_LIST_HEAD(&pool->free_list);
 	INIT_LIST_HEAD(&pool->xsk_tx_list);
 	spin_lock_init(&pool->xsk_tx_list_lock);
@@ -104,9 +89,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 		pool->free_heads[i] = xskb;
 	}
 
-	err = xp_addr_map(pool, umem->pgs, umem->npgs);
-	if (!err)
-		return pool;
+	return pool;
 
 out:
 	xp_destroy(pool);
-- 
2.7.4

