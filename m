Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C038838B5D8
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 20:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbhETSRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 14:17:03 -0400
Received: from mga17.intel.com ([192.55.52.151]:9108 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233920AbhETSQy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 14:16:54 -0400
IronPort-SDR: EF8zoROBSloHTK6J/9P3Og5J78SF/BIbRLgE6ro3+NPPtFMAYeR4PWRko/0icbDRcKJboQDdSl
 CTJi9hgw8tnQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9990"; a="181579464"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="181579464"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 11:15:33 -0700
IronPort-SDR: q96eFXaJ6aCCH18x1cPcv37tsB17ATTeBUufuoKgQATpTXBUv4FRFk/Dp7R/8YPKm3MfNpVPus
 PelQXiEK6PsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440670759"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 20 May 2021 11:15:32 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next v2 7/9] igc: Replace IGC_TX_FLAGS_XDP flag by an enum
Date:   Thu, 20 May 2021 11:17:42 -0700
Message-Id: <20210520181744.2217191-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210520181744.2217191-1-anthony.l.nguyen@intel.com>
References: <20210520181744.2217191-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

Up to this point, Tx buffers are associated with either a skb or a xdpf,
and the IGC_TX_FLAGS_XDP flag was enough to distinguish between these
two case. However, with upcoming patches that will add AF_XDP zero-copy
support, a third case will be introduced so this flag-based approach
won't fit well.

In preparation to land AF_XDP zero-copy support, replace the
IGC_TX_FLAGS_XDP flag by an enum which will be extended once zero-copy
support is introduced to the driver.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h      |  8 ++++++--
 drivers/net/ethernet/intel/igc/igc_main.c | 25 ++++++++++++++++++-----
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 25871351730b..4815c520652b 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -390,8 +390,6 @@ enum igc_tx_flags {
 	/* olinfo flags */
 	IGC_TX_FLAGS_IPV4	= 0x10,
 	IGC_TX_FLAGS_CSUM	= 0x20,
-
-	IGC_TX_FLAGS_XDP	= 0x100,
 };
 
 enum igc_boards {
@@ -408,12 +406,18 @@ enum igc_boards {
 #define TXD_USE_COUNT(S)	DIV_ROUND_UP((S), IGC_MAX_DATA_PER_TXD)
 #define DESC_NEEDED	(MAX_SKB_FRAGS + 4)
 
+enum igc_tx_buffer_type {
+	IGC_TX_BUFFER_TYPE_SKB,
+	IGC_TX_BUFFER_TYPE_XDP,
+};
+
 /* wrapper around a pointer to a socket buffer,
  * so a DMA handle can be stored along with the buffer
  */
 struct igc_tx_buffer {
 	union igc_adv_tx_desc *next_to_watch;
 	unsigned long time_stamp;
+	enum igc_tx_buffer_type type;
 	union {
 		struct sk_buff *skb;
 		struct xdp_frame *xdpf;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ebb57d82e4dd..4e1327a5a61e 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -191,10 +191,17 @@ static void igc_clean_tx_ring(struct igc_ring *tx_ring)
 	while (i != tx_ring->next_to_use) {
 		union igc_adv_tx_desc *eop_desc, *tx_desc;
 
-		if (tx_buffer->tx_flags & IGC_TX_FLAGS_XDP)
+		switch (tx_buffer->type) {
+		case IGC_TX_BUFFER_TYPE_XDP:
 			xdp_return_frame(tx_buffer->xdpf);
-		else
+			break;
+		case IGC_TX_BUFFER_TYPE_SKB:
 			dev_kfree_skb_any(tx_buffer->skb);
+			break;
+		default:
+			netdev_warn_once(tx_ring->netdev, "Unknown Tx buffer type\n");
+			break;
+		}
 
 		igc_unmap_tx_buffer(tx_ring->dev, tx_buffer);
 
@@ -1360,6 +1367,7 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 
 	/* record the location of the first descriptor for this packet */
 	first = &tx_ring->tx_buffer_info[tx_ring->next_to_use];
+	first->type = IGC_TX_BUFFER_TYPE_SKB;
 	first->skb = skb;
 	first->bytecount = skb->len;
 	first->gso_segs = 1;
@@ -1943,8 +1951,8 @@ static int igc_xdp_init_tx_buffer(struct igc_tx_buffer *buffer,
 		return -ENOMEM;
 	}
 
+	buffer->type = IGC_TX_BUFFER_TYPE_XDP;
 	buffer->xdpf = xdpf;
-	buffer->tx_flags = IGC_TX_FLAGS_XDP;
 	buffer->protocol = 0;
 	buffer->bytecount = xdpf->len;
 	buffer->gso_segs = 1;
@@ -2305,10 +2313,17 @@ static bool igc_clean_tx_irq(struct igc_q_vector *q_vector, int napi_budget)
 		total_bytes += tx_buffer->bytecount;
 		total_packets += tx_buffer->gso_segs;
 
-		if (tx_buffer->tx_flags & IGC_TX_FLAGS_XDP)
+		switch (tx_buffer->type) {
+		case IGC_TX_BUFFER_TYPE_XDP:
 			xdp_return_frame(tx_buffer->xdpf);
-		else
+			break;
+		case IGC_TX_BUFFER_TYPE_SKB:
 			napi_consume_skb(tx_buffer->skb, napi_budget);
+			break;
+		default:
+			netdev_warn_once(tx_ring->netdev, "Unknown Tx buffer type\n");
+			break;
+		}
 
 		igc_unmap_tx_buffer(tx_ring->dev, tx_buffer);
 
-- 
2.26.2

