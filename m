Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0FF34D5BD
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 19:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhC2RIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 13:08:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:51885 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230418AbhC2RIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 13:08:01 -0400
IronPort-SDR: ftcURbCKDcLLpb7mrLamBiDzQe4k+88R+Eq3c6ecX9Yvt7I89Ij4M97iB4cg8PKKxpzRf5ZxBK
 syJdhKVj0WYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="178720132"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="178720132"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 10:07:59 -0700
IronPort-SDR: ZUE/enII3RjuKxH3rXfUCDq5fCXew7nzNp9v31jBfwxXD7+q5QW6feOAckswtRWI6+E+H+zmmK
 9swO1j2Sbong==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="606447265"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 29 Mar 2021 10:07:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 3/8] igc: Introduce igc_get_rx_frame_truesize() helper
Date:   Mon, 29 Mar 2021 10:09:26 -0700
Message-Id: <20210329170931.2356162-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210329170931.2356162-1-anthony.l.nguyen@intel.com>
References: <20210329170931.2356162-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The RX frame truesize calculation is scattered throughout the RX code.
This patch creates the helper function igc_get_rx_frame_truesize() and
uses it where applicable.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 29 ++++++++++++++---------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1afbc903aaae..d6947c1d6f49 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1509,6 +1509,22 @@ static void igc_rx_buffer_flip(struct igc_rx_buffer *buffer,
 #endif
 }
 
+static unsigned int igc_get_rx_frame_truesize(struct igc_ring *ring,
+					      unsigned int size)
+{
+	unsigned int truesize;
+
+#if (PAGE_SIZE < 8192)
+	truesize = igc_rx_pg_size(ring) / 2;
+#else
+	truesize = ring_uses_build_skb(ring) ?
+		   SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
+		   SKB_DATA_ALIGN(IGC_SKB_PAD + size) :
+		   SKB_DATA_ALIGN(size);
+#endif
+	return truesize;
+}
+
 /**
  * igc_add_rx_frag - Add contents of Rx buffer to sk_buff
  * @rx_ring: rx descriptor ring to transact packets on
@@ -1544,12 +1560,7 @@ static struct sk_buff *igc_build_skb(struct igc_ring *rx_ring,
 				     unsigned int size)
 {
 	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
-#if (PAGE_SIZE < 8192)
-	unsigned int truesize = igc_rx_pg_size(rx_ring) / 2;
-#else
-	unsigned int truesize = SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
-				SKB_DATA_ALIGN(IGC_SKB_PAD + size);
-#endif
+	unsigned int truesize = igc_get_rx_frame_truesize(rx_ring, size);
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
@@ -1574,11 +1585,7 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
 					 unsigned int size)
 {
 	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
-#if (PAGE_SIZE < 8192)
-	unsigned int truesize = igc_rx_pg_size(rx_ring) / 2;
-#else
-	unsigned int truesize = SKB_DATA_ALIGN(size);
-#endif
+	unsigned int truesize = igc_get_rx_frame_truesize(rx_ring, size);
 	unsigned int headlen;
 	struct sk_buff *skb;
 
-- 
2.26.2

