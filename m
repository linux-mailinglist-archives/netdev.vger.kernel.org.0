Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DBC34D5BA
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 19:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhC2RIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 13:08:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:51883 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231178AbhC2RIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 13:08:01 -0400
IronPort-SDR: WhRr6nFE0OvOoWIJw0nJDAtULYN6Mg3O24CI7Hrhro/XP0zHDzH5xmpmABJsgYfSaUj9H9M9Gx
 dXM0wiFHNOrQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="178720126"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="178720126"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 10:07:59 -0700
IronPort-SDR: uQthlEBq/KV/5XmO9ZyG1SlG5N/DPMAW+G02HUUGCWqg4/dhH3yf02J1qvxt4QrzSv9gFSFipy
 +XU7TPOydBHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="606447258"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 29 Mar 2021 10:07:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 2/8] igc: Introduce igc_rx_buffer_flip() helper
Date:   Mon, 29 Mar 2021 10:09:25 -0700
Message-Id: <20210329170931.2356162-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210329170931.2356162-1-anthony.l.nguyen@intel.com>
References: <20210329170931.2356162-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The igc driver implements the same page recycling scheme from other
Intel drivers which reuses the page by flipping the buffer. The code
to handle buffer flips is duplicated in many locations so introduce
the igc_rx_buffer_flip() helper and use it where applicable.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 43 +++++++++++------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e1e38d797f29..1afbc903aaae 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1499,6 +1499,16 @@ static struct igc_rx_buffer *igc_get_rx_buffer(struct igc_ring *rx_ring,
 	return rx_buffer;
 }
 
+static void igc_rx_buffer_flip(struct igc_rx_buffer *buffer,
+			       unsigned int truesize)
+{
+#if (PAGE_SIZE < 8192)
+	buffer->page_offset ^= truesize;
+#else
+	buffer->page_offset += truesize;
+#endif
+}
+
 /**
  * igc_add_rx_frag - Add contents of Rx buffer to sk_buff
  * @rx_ring: rx descriptor ring to transact packets on
@@ -1513,20 +1523,19 @@ static void igc_add_rx_frag(struct igc_ring *rx_ring,
 			    struct sk_buff *skb,
 			    unsigned int size)
 {
-#if (PAGE_SIZE < 8192)
-	unsigned int truesize = igc_rx_pg_size(rx_ring) / 2;
+	unsigned int truesize;
 
-	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buffer->page,
-			rx_buffer->page_offset, size, truesize);
-	rx_buffer->page_offset ^= truesize;
+#if (PAGE_SIZE < 8192)
+	truesize = igc_rx_pg_size(rx_ring) / 2;
 #else
-	unsigned int truesize = ring_uses_build_skb(rx_ring) ?
-				SKB_DATA_ALIGN(IGC_SKB_PAD + size) :
-				SKB_DATA_ALIGN(size);
+	truesize = ring_uses_build_skb(rx_ring) ?
+		   SKB_DATA_ALIGN(IGC_SKB_PAD + size) :
+		   SKB_DATA_ALIGN(size);
+#endif
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buffer->page,
 			rx_buffer->page_offset, size, truesize);
-	rx_buffer->page_offset += truesize;
-#endif
+
+	igc_rx_buffer_flip(rx_buffer, truesize);
 }
 
 static struct sk_buff *igc_build_skb(struct igc_ring *rx_ring,
@@ -1555,13 +1564,7 @@ static struct sk_buff *igc_build_skb(struct igc_ring *rx_ring,
 	skb_reserve(skb, IGC_SKB_PAD);
 	__skb_put(skb, size);
 
-	/* update buffer offset */
-#if (PAGE_SIZE < 8192)
-	rx_buffer->page_offset ^= truesize;
-#else
-	rx_buffer->page_offset += truesize;
-#endif
-
+	igc_rx_buffer_flip(rx_buffer, truesize);
 	return skb;
 }
 
@@ -1607,11 +1610,7 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
 		skb_add_rx_frag(skb, 0, rx_buffer->page,
 				(va + headlen) - page_address(rx_buffer->page),
 				size, truesize);
-#if (PAGE_SIZE < 8192)
-		rx_buffer->page_offset ^= truesize;
-#else
-		rx_buffer->page_offset += truesize;
-#endif
+		igc_rx_buffer_flip(rx_buffer, truesize);
 	} else {
 		rx_buffer->pagecnt_bias++;
 	}
-- 
2.26.2

