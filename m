Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1909225B3E
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 11:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgGTJTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 05:19:02 -0400
Received: from mga05.intel.com ([192.55.52.43]:40721 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728052AbgGTJTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 05:19:01 -0400
IronPort-SDR: NQBaI0y5YqaXOTPwy7Y9vDaICckRthURu3qwwJEdkKLybkFvQCadfELGMt3LgrBwDWBUAC1Kkn
 FxHG6AE0BpjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9687"; a="234729945"
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="234729945"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 02:19:01 -0700
IronPort-SDR: D9LplAkuq/uf16cvlh7yHbWRCQBQgUIM5LHgiysqevo1UvMGL+rJ60QCXXAORFYnYKNfKql7To
 6AbIkkQFdYqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="431549160"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.34.51])
  by orsmga004.jf.intel.com with ESMTP; 20 Jul 2020 02:18:57 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next v3 09/14] xsk: rearrange internal structs for better performance
Date:   Mon, 20 Jul 2020 11:18:09 +0200
Message-Id: <1595236694-12749-10-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595236694-12749-1-git-send-email-magnus.karlsson@intel.com>
References: <1595236694-12749-1-git-send-email-magnus.karlsson@intel.com>
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
index 8f1dc4c..b4d6307 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -36,34 +36,37 @@ struct xsk_dma_map {
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
 	dma_addr_t *dma_pages;
 	struct xdp_buff_xsk *heads;
 	u64 chunk_mask;
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

