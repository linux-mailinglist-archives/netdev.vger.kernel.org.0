Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 950A2E9546
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 04:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfJ3D3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 23:29:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:43132 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726994AbfJ3D3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 23:29:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 20:29:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,245,1569308400"; 
   d="scan'208";a="205673659"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Oct 2019 20:29:12 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 8/9] ice: add build_skb() support
Date:   Tue, 29 Oct 2019 20:29:09 -0700
Message-Id: <20191030032910.24261-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030032910.24261-1-jeffrey.t.kirsher@intel.com>
References: <20191030032910.24261-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Driver is now prepared for building the skb around the existing Rx
buffer, so introduce the ice_build_skb responsible for it. Make use of
XDP's data_meta as well.

I've observed around 30% less CPU consumption with build_skb Rx path, in
comparison to legacy Rx. What stands behind such result is the avoidance
of flow_dissector (which we were diving into via eth_get_headlen) and no
memcpy calls.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 60 ++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 71c4464934af..8e3a69d3884d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -790,6 +790,60 @@ ice_get_rx_buf(struct ice_ring *rx_ring, struct sk_buff **skb,
 	return rx_buf;
 }
 
+/**
+ * ice_build_skb - Build skb around an existing buffer
+ * @rx_ring: Rx descriptor ring to transact packets on
+ * @rx_buf: Rx buffer to pull data from
+ * @xdp: xdp_buff pointing to the data
+ *
+ * This function builds an skb around an existing Rx buffer, taking care
+ * to set up the skb correctly and avoid any memcpy overhead.
+ */
+static struct sk_buff *
+ice_build_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
+	      struct xdp_buff *xdp)
+{
+	unsigned int metasize = xdp->data - xdp->data_meta;
+#if (PAGE_SIZE < 8192)
+	unsigned int truesize = ice_rx_pg_size(rx_ring) / 2;
+#else
+	unsigned int truesize = SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
+				SKB_DATA_ALIGN(xdp->data_end -
+					       xdp->data_hard_start);
+#endif
+	struct sk_buff *skb;
+
+	/* Prefetch first cache line of first page. If xdp->data_meta
+	 * is unused, this points exactly as xdp->data, otherwise we
+	 * likely have a consumer accessing first few bytes of meta
+	 * data, and then actual data.
+	 */
+	prefetch(xdp->data_meta);
+#if L1_CACHE_BYTES < 128
+	prefetch((void *)(xdp->data + L1_CACHE_BYTES));
+#endif
+	/* build an skb around the page buffer */
+	skb = build_skb(xdp->data_hard_start, truesize);
+	if (unlikely(!skb))
+		return NULL;
+
+	/* must to record Rx queue, otherwise OS features such as
+	 * symmetric queue won't work
+	 */
+	skb_record_rx_queue(skb, rx_ring->q_index);
+
+	/* update pointers within the skb to store the data */
+	skb_reserve(skb, xdp->data - xdp->data_hard_start);
+	__skb_put(skb, xdp->data_end - xdp->data);
+	if (metasize)
+		skb_metadata_set(skb, metasize);
+
+	/* buffer is used by skb, update page_offset */
+	ice_rx_buf_adjust_pg_offset(rx_buf, truesize);
+
+	return skb;
+}
+
 /**
  * ice_construct_skb - Allocate skb and populate it
  * @rx_ring: Rx descriptor ring to transact packets on
@@ -996,12 +1050,14 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		if (!size) {
 			xdp.data = NULL;
 			xdp.data_end = NULL;
+			xdp.data_hard_start = NULL;
+			xdp.data_meta = NULL;
 			goto construct_skb;
 		}
 
 		xdp.data = page_address(rx_buf->page) + rx_buf->page_offset;
 		xdp.data_hard_start = xdp.data - ice_rx_offset(rx_ring);
-		xdp_set_data_meta_invalid(&xdp);
+		xdp.data_meta = xdp.data;
 		xdp.data_end = xdp.data + size;
 
 		rcu_read_lock();
@@ -1038,6 +1094,8 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 construct_skb:
 		if (skb)
 			ice_add_rx_frag(rx_ring, rx_buf, skb, size);
+		else if (ice_ring_uses_build_skb(rx_ring))
+			skb = ice_build_skb(rx_ring, rx_buf, &xdp);
 		else
 			skb = ice_construct_skb(rx_ring, rx_buf, &xdp);
 
-- 
2.21.0

