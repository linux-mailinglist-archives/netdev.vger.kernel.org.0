Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B01DE0792
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732471AbfJVPii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:38:38 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:53328 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730305AbfJVPii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 11:38:38 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 82C64B40073;
        Tue, 22 Oct 2019 15:38:36 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 22 Oct 2019 16:38:30 +0100
From:   Charles McLachlan <cmclachlan@solarflare.com>
Subject: [PATCH net-next 2/6] sfc: perform XDP processing on received packets.
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
References: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
Message-ID: <1c193147-d94a-111f-42d3-324c3e8b0282@solarflare.com>
Date:   Tue, 22 Oct 2019 16:38:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24994.003
X-TM-AS-Result: No-13.326000-8.000000-10
X-TMASE-MatchedRID: uYxUjFvNHQ0+6i2bZm4t0H4neC0h7SADRf40pT7Zmv5jLp8Cm8vwFwoe
        RRhCZWIByf4UUiPmFLpvKSmu7qXbvpMKhvRh/ZfePwKTD1v8YV5MkOX0UoduuVVkJxysad/I30b
        F0wRKFgcAwXM9XSqdidiDk+yT34MY6mVaoLU6Wk6iAZ3zAhQYglB1e7/F/vq5R2YNIFh+clEiXP
        plbaN/6tsNO4qO4Yb21qqYER4Oo4hYKI4f2iLMS3IA6GYWLWr2SuH+GfgmQGd0u//5asbq02rjw
        a8vt1tRnQjJAxcisD19RkGNRq91k6mVqZPhikVTNVRz+HwqL4LRayXNFLOD1I67Sl4uKDg2fh0r
        u/N0dpcbxEdfXvPiw3YCQ/i3yCkmQQ84pWdizi3J/bVh4iw9hqjT5YxblDKJoA1qZKkyr6H1Zeb
        7KEkrKIaY8++vYXQIFvQfEvM1H5TnmDJKPFuKfodlc1JaOB1T6KbGBEfATCYz988bphElUd5QZV
        AH5Zt2gwAROyf5s1nj/GqJSvOAKdfQ7AU9Ytd4i82UiskMqczaCn4DqCiXNou6fTXJM2TryaS/5
        aNY9R59nXBYBc7+9ZNgfsIadgPVMyjHimwQk9IqsMfMfrOZRXyuCDd9Nsmv6Ocpa1n0tMtZNLoW
        1a4YrCZs+i7ennPUN8eHxrg3vgJlJTodqNqEzqubsOtSWY2QkZOl7WKIImpvmJzqtHKHjwtuKBG
        ekqUpOlxBO2IcOBb3KG7F38QnbSL4+BOxCVdF0C7UNyDTnPIaD3ouea5ZZHWnlGxCqKay
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--13.326000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24994.003
X-MDID: 1571758717-kJFo7-sZn6vK
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a field to hold an attached xdp_prog, but never populates it (see
following patch).  Also, XDP_TX support is deferred to a later patch
in the series.

Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        |   4 +-
 drivers/net/ethernet/sfc/net_driver.h |   7 ++
 drivers/net/ethernet/sfc/rx.c         | 121 +++++++++++++++++++++++++-
 3 files changed, 130 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 2fef7402233e..2f1d851c7fd2 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -340,6 +340,8 @@ static int efx_poll(struct napi_struct *napi, int budget)
 
 	spent = efx_process_channel(channel, budget);
 
+	xdp_do_flush_map();
+
 	if (spent < budget) {
 		if (efx_channel_has_rx_queue(channel) &&
 		    efx->irq_rx_adaptive &&
@@ -651,7 +653,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 	efx->rx_dma_len = (efx->rx_prefix_size +
 			   EFX_MAX_FRAME_LEN(efx->net_dev->mtu) +
 			   efx->type->rx_buffer_padding);
-	rx_buf_len = (sizeof(struct efx_rx_page_state) +
+	rx_buf_len = (sizeof(struct efx_rx_page_state) + XDP_PACKET_HEADROOM +
 		      efx->rx_ip_align + efx->rx_dma_len);
 	if (rx_buf_len <= PAGE_SIZE) {
 		efx->rx_scatter = efx->type->always_rx_scatter;
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 7394d901e021..f920d4924626 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -369,6 +369,7 @@ struct efx_rx_page_state {
  *	refill was triggered.
  * @recycle_count: RX buffer recycle counter.
  * @slow_fill: Timer used to defer efx_nic_generate_fill_event().
+ * @xdp_rxq_info: XDP specific RX queue information.
  */
 struct efx_rx_queue {
 	struct efx_nic *efx;
@@ -400,6 +401,7 @@ struct efx_rx_queue {
 	unsigned int slow_fill_count;
 	/* Statistics to supplement MAC stats */
 	unsigned long rx_packets;
+	struct xdp_rxq_info xdp_rxq_info;
 };
 
 enum efx_sync_events_state {
@@ -900,6 +902,7 @@ struct efx_async_filter_insertion {
  * @loopback_mode: Loopback status
  * @loopback_modes: Supported loopback mode bitmask
  * @loopback_selftest: Offline self-test private state
+ * @xdp_prog: Current XDP programme for this interface
  * @filter_sem: Filter table rw_semaphore, protects existence of @filter_state
  * @filter_state: Architecture-dependent filter table state
  * @rps_mutex: Protects RPS state of all channels
@@ -1059,6 +1062,10 @@ struct efx_nic {
 	u64 loopback_modes;
 
 	void *loopback_selftest;
+	/* We access loopback_selftest immediately before running XDP,
+	 * so we want them next to each other.
+	 */
+	struct bpf_prog __rcu *xdp_prog;
 
 	struct rw_semaphore filter_sem;
 	void *filter_state;
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 85ec07f5a674..4a23ffff8ac2 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -17,6 +17,7 @@
 #include <linux/iommu.h>
 #include <net/ip.h>
 #include <net/checksum.h>
+#include <net/xdp.h>
 #include "net_driver.h"
 #include "efx.h"
 #include "filter.h"
@@ -27,6 +28,9 @@
 /* Preferred number of descriptors to fill at once */
 #define EFX_RX_PREFERRED_BATCH 8U
 
+/* Maximum rx prefix used by any architecture. */
+#define EFX_MAX_RX_PREFIX_SIZE 16
+
 /* Number of RX buffers to recycle pages for.  When creating the RX page recycle
  * ring, this number is divided by the number of buffers per page to calculate
  * the number of pages to store in the RX page recycle ring.
@@ -95,7 +99,7 @@ void efx_rx_config_page_split(struct efx_nic *efx)
 				      EFX_RX_BUF_ALIGNMENT);
 	efx->rx_bufs_per_page = efx->rx_buffer_order ? 1 :
 		((PAGE_SIZE - sizeof(struct efx_rx_page_state)) /
-		 efx->rx_page_buf_step);
+		(efx->rx_page_buf_step + XDP_PACKET_HEADROOM));
 	efx->rx_buffer_truesize = (PAGE_SIZE << efx->rx_buffer_order) /
 		efx->rx_bufs_per_page;
 	efx->rx_pages_per_batch = DIV_ROUND_UP(EFX_RX_PREFERRED_BATCH,
@@ -185,6 +189,9 @@ static int efx_init_rx_buffers(struct efx_rx_queue *rx_queue, bool atomic)
 		page_offset = sizeof(struct efx_rx_page_state);
 
 		do {
+			page_offset += XDP_PACKET_HEADROOM;
+			dma_addr += XDP_PACKET_HEADROOM;
+
 			index = rx_queue->added_count & rx_queue->ptr_mask;
 			rx_buf = efx_rx_buffer(rx_queue, index);
 			rx_buf->dma_addr = dma_addr + efx->rx_ip_align;
@@ -635,6 +642,103 @@ static void efx_rx_deliver(struct efx_channel *channel, u8 *eh,
 		netif_receive_skb(skb);
 }
 
+/** efx_do_xdp: perform XDP processing on a received packet
+ *
+ * Returns true if packet should still be delivered.
+ */
+static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
+		       struct efx_rx_buffer *rx_buf, u8 **ehp)
+{
+	u8 rx_prefix[EFX_MAX_RX_PREFIX_SIZE];
+	struct efx_rx_queue *rx_queue;
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff xdp;
+	u32 xdp_act;
+	s16 offset;
+	int rc;
+
+	rcu_read_lock();
+	xdp_prog = rcu_dereference(efx->xdp_prog);
+	if (!xdp_prog) {
+		rcu_read_unlock();
+		return true;
+	}
+
+	rx_queue = efx_channel_get_rx_queue(channel);
+
+	if (unlikely(channel->rx_pkt_n_frags > 1)) {
+		/* We can't do XDP on fragmented packets - drop. */
+		rcu_read_unlock();
+		efx_free_rx_buffers(rx_queue, rx_buf,
+				    channel->rx_pkt_n_frags);
+		if (net_ratelimit())
+			netif_err(efx, rx_err, efx->net_dev,
+				  "XDP is not possible with multiple receive fragments (%d)\n",
+				  channel->rx_pkt_n_frags);
+		return false;
+	}
+
+	dma_sync_single_for_cpu(&efx->pci_dev->dev, rx_buf->dma_addr,
+				rx_buf->len, DMA_FROM_DEVICE);
+
+	/* Save the rx prefix. */
+	EFX_WARN_ON_PARANOID(efx->rx_prefix_size > EFX_MAX_RX_PREFIX_SIZE);
+	memcpy(rx_prefix, *ehp - efx->rx_prefix_size,
+	       efx->rx_prefix_size);
+
+	xdp.data = *ehp;
+	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
+
+	/* No support yet for XDP metadata */
+	xdp_set_data_meta_invalid(&xdp);
+	xdp.data_end = xdp.data + rx_buf->len;
+	xdp.rxq = &rx_queue->xdp_rxq_info;
+
+	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
+	rcu_read_unlock();
+
+	offset = (u8 *)xdp.data - *ehp;
+
+	switch (xdp_act) {
+	case XDP_PASS:
+		/* Fix up rx prefix. */
+		if (offset) {
+			*ehp += offset;
+			rx_buf->page_offset += offset;
+			rx_buf->len -= offset;
+			memcpy(*ehp - efx->rx_prefix_size, rx_prefix,
+			       efx->rx_prefix_size);
+		}
+		break;
+
+	case XDP_TX:
+		return -EOPNOTSUPP;
+
+	case XDP_REDIRECT:
+		rc = xdp_do_redirect(efx->net_dev, &xdp, xdp_prog);
+		if (rc) {
+			efx_free_rx_buffers(rx_queue, rx_buf, 1);
+			if (net_ratelimit())
+				netif_err(efx, rx_err, efx->net_dev,
+					  "XDP redirect failed (%d)\n", rc);
+		}
+		break;
+
+	default:
+		bpf_warn_invalid_xdp_action(xdp_act);
+		/* Fall through */
+	case XDP_ABORTED:
+		efx_free_rx_buffers(rx_queue, rx_buf, 1);
+		break;
+
+	case XDP_DROP:
+		efx_free_rx_buffers(rx_queue, rx_buf, 1);
+		break;
+	}
+
+	return xdp_act == XDP_PASS;
+}
+
 /* Handle a received packet.  Second half: Touches packet payload. */
 void __efx_rx_packet(struct efx_channel *channel)
 {
@@ -663,6 +767,9 @@ void __efx_rx_packet(struct efx_channel *channel)
 		goto out;
 	}
 
+	if (!efx_do_xdp(efx, channel, rx_buf, &eh))
+		goto out;
+
 	if (unlikely(!(efx->net_dev->features & NETIF_F_RXCSUM)))
 		rx_buf->flags &= ~EFX_RX_PKT_CSUMMED;
 
@@ -731,6 +838,7 @@ void efx_init_rx_queue(struct efx_rx_queue *rx_queue)
 {
 	struct efx_nic *efx = rx_queue->efx;
 	unsigned int max_fill, trigger, max_trigger;
+	int rc = 0;
 
 	netif_dbg(rx_queue->efx, drv, rx_queue->efx->net_dev,
 		  "initialising RX queue %d\n", efx_rx_queue_index(rx_queue));
@@ -764,6 +872,16 @@ void efx_init_rx_queue(struct efx_rx_queue *rx_queue)
 	rx_queue->fast_fill_trigger = trigger;
 	rx_queue->refill_enabled = true;
 
+	/* Initialise XDP queue information */
+	rc = xdp_rxq_info_reg(&rx_queue->xdp_rxq_info, efx->net_dev,
+			      rx_queue->core_index);
+
+	if (rc) {
+		netif_err(efx, rx_err, efx->net_dev,
+			  "Failure to initialise XDP queue information rc=%d\n",
+			  rc);
+	}
+
 	/* Set up RX descriptor ring */
 	efx_nic_init_rx(rx_queue);
 }
@@ -805,6 +923,7 @@ void efx_fini_rx_queue(struct efx_rx_queue *rx_queue)
 	}
 	kfree(rx_queue->page_ring);
 	rx_queue->page_ring = NULL;
+	xdp_rxq_info_unreg(&rx_queue->xdp_rxq_info);
 }
 
 void efx_remove_rx_queue(struct efx_rx_queue *rx_queue)
