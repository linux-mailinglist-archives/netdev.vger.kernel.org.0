Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9720725566F
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 10:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgH1I1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 04:27:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:23538 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728717AbgH1I1b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 04:27:31 -0400
IronPort-SDR: KBpCXOAdIIgXf+1DHEoy88BqpxCbSC1WoPSFU/p6ZTIJylLpDj3hTX8Z6otxvVJhvldpwBupwH
 bFTK7Ki1crwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="156634021"
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="156634021"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 01:27:15 -0700
IronPort-SDR: FaCIU5KMPFvV97h+FG89IBs7Pk+vLpedorSvPAUfw6NOVPM4KsWqkBNYvywIsA6x6GqW+3cy1h
 JQFdJ0u7MPbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="444762770"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.36.33])
  by orsmga004.jf.intel.com with ESMTP; 28 Aug 2020 01:27:11 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next v5 09/15] xsk: rearrange internal structs for better performance
Date:   Fri, 28 Aug 2020 10:26:23 +0200
Message-Id: <1598603189-32145-10-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
References: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rearrange the xdp_sock, xdp_umem and xsk_buff_pool structures so
that they get smaller and align better to the cache lines. In the
previous commits of this patch set, these structs have been
reordered with the focus on functionality and simplicity, not
performance. This patch improves throughput performance by around
3%.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock.h      | 13 +++++++------
 include/net/xsk_buff_pool.h | 27 +++++++++++++++------------
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 282aeba..1a9559c 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -23,13 +23,13 @@ struct xdp_umem {
 	u32 headroom;
 	u32 chunk_size;
 	u32 chunks;
+	u32 npgs;
 	struct user_struct *user;
 	refcount_t users;
-	struct page **pgs;
-	u32 npgs;
 	u8 flags;
-	int id;
 	bool zc;
+	struct page **pgs;
+	int id;
 	struct list_head xsk_dma_list;
 };
 
@@ -42,7 +42,7 @@ struct xsk_map {
 struct xdp_sock {
 	/* struct sock must be the first member of struct xdp_sock */
 	struct sock sk;
-	struct xsk_queue *rx;
+	struct xsk_queue *rx ____cacheline_aligned_in_smp;
 	struct net_device *dev;
 	struct xdp_umem *umem;
 	struct list_head flush_node;
@@ -54,8 +54,7 @@ struct xdp_sock {
 		XSK_BOUND,
 		XSK_UNBOUND,
 	} state;
-	/* Protects multiple processes in the control path */
-	struct mutex mutex;
+
 	struct xsk_queue *tx ____cacheline_aligned_in_smp;
 	struct list_head tx_list;
 	/* Mutual exclusion of NAPI TX thread and sendmsg error paths
@@ -72,6 +71,8 @@ struct xdp_sock {
 	struct list_head map_list;
 	/* Protects map_list */
 	spinlock_t map_list_lock;
+	/* Protects multiple processes in the control path */
+	struct mutex mutex;
 	struct xsk_queue *fq_tmp; /* Only as tmp storage before bind */
 	struct xsk_queue *cq_tmp; /* Only as tmp storage before bind */
 };
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 356d0ac..38d03a6 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -39,9 +39,22 @@ struct xsk_dma_map {
 };
 
 struct xsk_buff_pool {
-	struct xsk_queue *fq;
-	struct xsk_queue *cq;
+	/* Members only used in the control path first. */
+	struct device *dev;
+	struct net_device *netdev;
+	struct list_head xsk_tx_list;
+	/* Protects modifications to the xsk_tx_list */
+	spinlock_t xsk_tx_list_lock;
+	refcount_t users;
+	struct xdp_umem *umem;
+	struct work_struct work;
 	struct list_head free_list;
+	u32 heads_cnt;
+	u16 queue_id;
+
+	/* Data path members as close to free_heads at the end as possible. */
+	struct xsk_queue *fq ____cacheline_aligned_in_smp;
+	struct xsk_queue *cq;
 	/* For performance reasons, each buff pool has its own array of dma_pages
 	 * even when they are identical.
 	 */
@@ -51,25 +64,15 @@ struct xsk_buff_pool {
 	u64 addrs_cnt;
 	u32 free_list_cnt;
 	u32 dma_pages_cnt;
-	u32 heads_cnt;
 	u32 free_heads_cnt;
 	u32 headroom;
 	u32 chunk_size;
 	u32 frame_len;
-	u16 queue_id;
 	u8 cached_need_wakeup;
 	bool uses_need_wakeup;
 	bool dma_need_sync;
 	bool unaligned;
-	struct xdp_umem *umem;
 	void *addrs;
-	struct device *dev;
-	struct net_device *netdev;
-	struct list_head xsk_tx_list;
-	/* Protects modifications to the xsk_tx_list */
-	spinlock_t xsk_tx_list_lock;
-	refcount_t users;
-	struct work_struct work;
 	struct xdp_buff_xsk *free_heads[];
 };
 
-- 
2.7.4

