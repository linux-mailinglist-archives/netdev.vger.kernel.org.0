Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB4947612F
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 19:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344078AbhLOSzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 13:55:35 -0500
Received: from mga18.intel.com ([134.134.136.126]:24022 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344072AbhLOSzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 13:55:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639594513; x=1671130513;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GRrGATW9Q8cGPxl82Dc63IVG+WZSxYNjipZPugDtlws=;
  b=FpAsMoOupHWKcVwuttZ4mPbuPm8a5O8kdVrkO/lTeKjDss46TLt//btD
   oL9MZIutwNWnRmqw6relzK5EbL0TSvCzx0fROT/zkoh/ONj2D0Auz+u0U
   ZZVrO8GH1HAcZlXYwbHRmZ2ooJjD7S78ILfsMDm+GNZvX/XUNjZwGakSo
   Ups6HDYCUwBNKn4f6RT9yEjVg2bju2rtWpgaXQ5rr6sLiAY9+xCFW426N
   FCX2QKyzXmR0RaonO/jQdZ/wxjhZZsGtMrktK2BW6F0HbTALKloIM475i
   1+6Vl16U7YwyjBgJ7YYT4YRKTM91/l6uzJPFiDUESSs91Xwjun7hHXFWh
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="226169614"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="226169614"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 10:54:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465729952"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2021 10:54:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Piotr Raczynski <piotr.raczynski@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 7/9] ice: use prefetch methods
Date:   Wed, 15 Dec 2021 10:53:53 -0800
Message-Id: <20211215185355.3249738-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
References: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The kernel provides some prefetch mechanisms to speed up commonly
cold cache line accesses during receive processing. Since these are
software structures it helps to have these strategically placed
prefetches.

Be careful to call BQL prefetch complete only for non XDP queues.

Co-developed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Testing Hints:
Run AF_XDP socket and then terminate it or run xdp2
sample and send some traffic into the port.

Performance numbers for xdp2 sample are not noticeably
affected by introducing branch from this patch.

 drivers/net/ethernet/intel/ice/ice_txrx.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 12a2edd13877..de9247d45c39 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -3,8 +3,9 @@
 
 /* The driver transmit and receive code */
 
-#include <linux/prefetch.h>
 #include <linux/mm.h>
+#include <linux/netdevice.h>
+#include <linux/prefetch.h>
 #include <linux/bpf_trace.h>
 #include <net/dsfield.h>
 #include <net/xdp.h>
@@ -219,6 +220,10 @@ static bool ice_clean_tx_irq(struct ice_tx_ring *tx_ring, int napi_budget)
 	struct ice_tx_desc *tx_desc;
 	struct ice_tx_buf *tx_buf;
 
+	/* get the bql data ready */
+	if (!ice_ring_is_xdp(tx_ring))
+		netdev_txq_bql_complete_prefetchw(txring_txq(tx_ring));
+
 	tx_buf = &tx_ring->tx_buf[i];
 	tx_desc = ICE_TX_DESC(tx_ring, i);
 	i -= tx_ring->count;
@@ -232,6 +237,9 @@ static bool ice_clean_tx_irq(struct ice_tx_ring *tx_ring, int napi_budget)
 		if (!eop_desc)
 			break;
 
+		/* follow the guidelines of other drivers */
+		prefetchw(&tx_buf->skb->users);
+
 		smp_rmb();	/* prevent any other reads prior to eop_desc */
 
 		ice_trace(clean_tx_irq, tx_ring, tx_desc, tx_buf);
@@ -2265,6 +2273,9 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 		return NETDEV_TX_BUSY;
 	}
 
+	/* prefetch for bql data which is infrequently used */
+	netdev_txq_bql_enqueue_prefetchw(txring_txq(tx_ring));
+
 	offload.tx_ring = tx_ring;
 
 	/* record the location of the first descriptor for this packet */
-- 
2.31.1

