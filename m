Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A56C4706CC
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244404AbhLJRSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:18:55 -0500
Received: from mga18.intel.com ([134.134.136.126]:53879 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229821AbhLJRSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 12:18:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639156519; x=1670692519;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uLa8nYiciLaQG0+KKXDkyZWMbz+NCZDj0dXLmtVa31I=;
  b=daJ9OHdPjU+QkYtmCfYpS0jzvJd+DMGwCnQTs1tgp+LlJb849usZJHUr
   4VvXoKL8vszy0TDGxANPeqxw3tlnQg6DhdlC0cXrkUXQO6UNS8XadomNb
   ai8CO0SBVkrpU7fulO/HUmP/tjaGEuxIeH2GQCm5eG/j6jE7GUChXBQkz
   fPvpb8UwNWyng5xNBXHeDqI1+x3J8/DBTrvsOh02RSABSnM6OXg3x0b2Q
   XfZuuduCoc0ZfPWrTtJyPeH1eG8EdXq1r7eS0cyqXYuEc/tDR2XbbiPZI
   nfjaT7XwnK6YjzezP47Pe4m5DXm7ulBWPXNjLbXnkGym6W/quOjoh1U7y
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="225252033"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="225252033"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 09:15:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="612988910"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 10 Dec 2021 09:15:17 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next] xsk: wipe out dead zero_copy_allocator declarations
Date:   Fri, 10 Dec 2021 18:15:11 +0100
Message-Id: <20211210171511.11574-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zero_copy_allocator has been removed back when Bjorn Topel introduced
xsk_buff_pool. Remove references to it that were dangling in the tree.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.h           | 1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h | 2 --
 include/net/xdp_priv.h                               | 1 -
 3 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
index ea88f4597a07..bb962987f300 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
@@ -22,7 +22,6 @@
 
 struct i40e_vsi;
 struct xsk_buff_pool;
-struct zero_copy_allocator;
 
 int i40e_queue_pair_disable(struct i40e_vsi *vsi, int queue_pair);
 int i40e_queue_pair_enable(struct i40e_vsi *vsi, int queue_pair);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
index a82533f21d36..bba3feaf3318 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
@@ -35,8 +35,6 @@ int ixgbe_xsk_pool_setup(struct ixgbe_adapter *adapter,
 			 struct xsk_buff_pool *pool,
 			 u16 qid);
 
-void ixgbe_zca_free(struct zero_copy_allocator *alloc, unsigned long handle);
-
 bool ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 cleaned_count);
 int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 			  struct ixgbe_ring *rx_ring,
diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
index a9d5b7603b89..a2d58b1a12e1 100644
--- a/include/net/xdp_priv.h
+++ b/include/net/xdp_priv.h
@@ -10,7 +10,6 @@ struct xdp_mem_allocator {
 	union {
 		void *allocator;
 		struct page_pool *page_pool;
-		struct zero_copy_allocator *zc_alloc;
 	};
 	struct rhash_head node;
 	struct rcu_head rcu;
-- 
2.33.1

