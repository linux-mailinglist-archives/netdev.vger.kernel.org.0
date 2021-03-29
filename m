Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B91234D5BE
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 19:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhC2RIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 13:08:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:51883 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230298AbhC2RIE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 13:08:04 -0400
IronPort-SDR: 2qURFyaH5lqpPdZngIkHKNWhlfqiQAAGokm+BsIJo13FQdVzSW9vfyo3+Za/hY9n2rj+nATZeH
 rdYGmj/ChA1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="178720137"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="178720137"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 10:08:01 -0700
IronPort-SDR: BP4e4Yj/vm1Y35jvZRfAB20loV4KRcklhMDHQt4lMC/NZWBFBeMS6qjMk0yDi1I1iFRodQRQWQ
 9KwZobrrjEog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="606447283"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 29 Mar 2021 10:08:01 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 8/8] igc: Add support for XDP_REDIRECT action
Date:   Mon, 29 Mar 2021 10:09:31 -0700
Message-Id: <20210329170931.2356162-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210329170931.2356162-1-anthony.l.nguyen@intel.com>
References: <20210329170931.2356162-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

Add support for the XDP_REDIRECT action which enables XDP programs to
redirect packets arriving at I225 NIC. It also implements the
ndo_xdp_xmit ops, enabling the igc driver to transmit packets forwarded
to it by xdp programs running on other interfaces.

The patch tweaks the driver's page counting and recycling scheme as
described in the following two commits and implemented by other Intel
drivers in order to properly support XDP_REDIRECT action:
  commit 8ce29c679a6e ("i40e: tweak page counting for XDP_REDIRECT")
  commit 75aab4e10ae6 ("i40e: avoid premature Rx buffer reuse")

This patch has been tested with the sample apps "xdp_redirect_cpu" and
"xdp_redirect_map" located in samples/bpf/.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 84 ++++++++++++++++++++---
 1 file changed, 73 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 5ad360e52038..10765491e357 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -26,6 +26,7 @@
 #define IGC_XDP_PASS		0
 #define IGC_XDP_CONSUMED	BIT(0)
 #define IGC_XDP_TX		BIT(1)
+#define IGC_XDP_REDIRECT	BIT(2)
 
 static int debug = -1;
 
@@ -1505,11 +1506,18 @@ static void igc_process_skb_fields(struct igc_ring *rx_ring,
 }
 
 static struct igc_rx_buffer *igc_get_rx_buffer(struct igc_ring *rx_ring,
-					       const unsigned int size)
+					       const unsigned int size,
+					       int *rx_buffer_pgcnt)
 {
 	struct igc_rx_buffer *rx_buffer;
 
 	rx_buffer = &rx_ring->rx_buffer_info[rx_ring->next_to_clean];
+	*rx_buffer_pgcnt =
+#if (PAGE_SIZE < 8192)
+		page_count(rx_buffer->page);
+#else
+		0;
+#endif
 	prefetchw(rx_buffer->page);
 
 	/* we are reusing so sync this buffer for CPU use */
@@ -1677,7 +1685,8 @@ static void igc_reuse_rx_page(struct igc_ring *rx_ring,
 	new_buff->pagecnt_bias	= old_buff->pagecnt_bias;
 }
 
-static bool igc_can_reuse_rx_page(struct igc_rx_buffer *rx_buffer)
+static bool igc_can_reuse_rx_page(struct igc_rx_buffer *rx_buffer,
+				  int rx_buffer_pgcnt)
 {
 	unsigned int pagecnt_bias = rx_buffer->pagecnt_bias;
 	struct page *page = rx_buffer->page;
@@ -1688,7 +1697,7 @@ static bool igc_can_reuse_rx_page(struct igc_rx_buffer *rx_buffer)
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((page_ref_count(page) - pagecnt_bias) > 1))
+	if (unlikely((rx_buffer_pgcnt - pagecnt_bias) > 1))
 		return false;
 #else
 #define IGC_LAST_OFFSET \
@@ -1702,8 +1711,8 @@ static bool igc_can_reuse_rx_page(struct igc_rx_buffer *rx_buffer)
 	 * the pagecnt_bias and page count so that we fully restock the
 	 * number of references the driver holds.
 	 */
-	if (unlikely(!pagecnt_bias)) {
-		page_ref_add(page, USHRT_MAX);
+	if (unlikely(pagecnt_bias == 1)) {
+		page_ref_add(page, USHRT_MAX - 1);
 		rx_buffer->pagecnt_bias = USHRT_MAX;
 	}
 
@@ -1776,9 +1785,10 @@ static bool igc_cleanup_headers(struct igc_ring *rx_ring,
 }
 
 static void igc_put_rx_buffer(struct igc_ring *rx_ring,
-			      struct igc_rx_buffer *rx_buffer)
+			      struct igc_rx_buffer *rx_buffer,
+			      int rx_buffer_pgcnt)
 {
-	if (igc_can_reuse_rx_page(rx_buffer)) {
+	if (igc_can_reuse_rx_page(rx_buffer, rx_buffer_pgcnt)) {
 		/* hand second half of page back to the ring */
 		igc_reuse_rx_page(rx_ring, rx_buffer);
 	} else {
@@ -1844,7 +1854,8 @@ static bool igc_alloc_mapped_page(struct igc_ring *rx_ring,
 	bi->dma = dma;
 	bi->page = page;
 	bi->page_offset = igc_rx_offset(rx_ring);
-	bi->pagecnt_bias = 1;
+	page_ref_add(page, USHRT_MAX - 1);
+	bi->pagecnt_bias = USHRT_MAX;
 
 	return true;
 }
@@ -2040,6 +2051,12 @@ static struct sk_buff *igc_xdp_run_prog(struct igc_adapter *adapter,
 		else
 			res = IGC_XDP_TX;
 		break;
+	case XDP_REDIRECT:
+		if (xdp_do_redirect(adapter->netdev, xdp, prog) < 0)
+			res = IGC_XDP_CONSUMED;
+		else
+			res = IGC_XDP_REDIRECT;
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
@@ -2081,6 +2098,9 @@ static void igc_finalize_xdp(struct igc_adapter *adapter, int status)
 		igc_flush_tx_descriptors(ring);
 		__netif_tx_unlock(nq);
 	}
+
+	if (status & IGC_XDP_REDIRECT)
+		xdp_do_flush();
 }
 
 static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
@@ -2090,7 +2110,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 	struct igc_ring *rx_ring = q_vector->rx.ring;
 	struct sk_buff *skb = rx_ring->skb;
 	u16 cleaned_count = igc_desc_unused(rx_ring);
-	int xdp_status = 0;
+	int xdp_status = 0, rx_buffer_pgcnt;
 
 	while (likely(total_packets < budget)) {
 		union igc_adv_rx_desc *rx_desc;
@@ -2118,7 +2138,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 		 */
 		dma_rmb();
 
-		rx_buffer = igc_get_rx_buffer(rx_ring, size);
+		rx_buffer = igc_get_rx_buffer(rx_ring, size, &rx_buffer_pgcnt);
 		truesize = igc_get_rx_frame_truesize(rx_ring, size);
 
 		pktbuf = page_address(rx_buffer->page) + rx_buffer->page_offset;
@@ -2149,6 +2169,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 				rx_buffer->pagecnt_bias++;
 				break;
 			case IGC_XDP_TX:
+			case IGC_XDP_REDIRECT:
 				igc_rx_buffer_flip(rx_buffer, truesize);
 				xdp_status |= xdp_res;
 				break;
@@ -2171,7 +2192,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 			break;
 		}
 
-		igc_put_rx_buffer(rx_ring, rx_buffer);
+		igc_put_rx_buffer(rx_ring, rx_buffer, rx_buffer_pgcnt);
 		cleaned_count++;
 
 		/* fetch next buffer in frame if non-eop */
@@ -5111,6 +5132,46 @@ static int igc_bpf(struct net_device *dev, struct netdev_bpf *bpf)
 	}
 }
 
+static int igc_xdp_xmit(struct net_device *dev, int num_frames,
+			struct xdp_frame **frames, u32 flags)
+{
+	struct igc_adapter *adapter = netdev_priv(dev);
+	int cpu = smp_processor_id();
+	struct netdev_queue *nq;
+	struct igc_ring *ring;
+	int i, drops;
+
+	if (unlikely(test_bit(__IGC_DOWN, &adapter->state)))
+		return -ENETDOWN;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	ring = igc_xdp_get_tx_ring(adapter, cpu);
+	nq = txring_txq(ring);
+
+	__netif_tx_lock(nq, cpu);
+
+	drops = 0;
+	for (i = 0; i < num_frames; i++) {
+		int err;
+		struct xdp_frame *xdpf = frames[i];
+
+		err = igc_xdp_init_tx_descriptor(ring, xdpf);
+		if (err) {
+			xdp_return_frame_rx_napi(xdpf);
+			drops++;
+		}
+	}
+
+	if (flags & XDP_XMIT_FLUSH)
+		igc_flush_tx_descriptors(ring);
+
+	__netif_tx_unlock(nq);
+
+	return num_frames - drops;
+}
+
 static const struct net_device_ops igc_netdev_ops = {
 	.ndo_open		= igc_open,
 	.ndo_stop		= igc_close,
@@ -5125,6 +5186,7 @@ static const struct net_device_ops igc_netdev_ops = {
 	.ndo_do_ioctl		= igc_ioctl,
 	.ndo_setup_tc		= igc_setup_tc,
 	.ndo_bpf		= igc_bpf,
+	.ndo_xdp_xmit		= igc_xdp_xmit,
 };
 
 /* PCIe configuration access */
-- 
2.26.2

