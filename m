Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04CF0E7306
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 15:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389758AbfJ1N7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 09:59:32 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:48808 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389744AbfJ1N7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 09:59:31 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6F9F934006A;
        Mon, 28 Oct 2019 13:59:29 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 28 Oct 2019 13:59:24 +0000
From:   Charles McLachlan <cmclachlan@solarflare.com>
Subject: [PATCH net-next v2 2/6] sfc: perform XDP processing on received
 packets
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
References: <74c15338-c13e-5b7b-9cc5-844cd9262be3@solarflare.com>
Message-ID: <38a43fa5-5682-ffd9-f33e-5b7e04d50903@solarflare.com>
Date:   Mon, 28 Oct 2019 13:59:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <74c15338-c13e-5b7b-9cc5-844cd9262be3@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25006.003
X-TM-AS-Result: No-13.600000-8.000000-10
X-TMASE-MatchedRID: UGoB4lYkpIY+6i2bZm4t0H4neC0h7SADRf40pT7Zmv7uLrWPHZAw8n1p
        a9OL1UpKkW2IDKfJAh99RUb2O19k1dH8IadT2ypElchF+IvkllNMhH/KpYxyu2MunwKby/AXCh5
        FGEJlYgHJ/hRSI+YUum8pKa7updu+kwqG9GH9l94/ApMPW/xhXkyQ5fRSh265VWQnHKxp38jfRs
        XTBEoWBwDBcz1dKp2JjqENNDU9BQetiF+p+9BY6eFgDmzNVVKo+eBf9ovw8I2o8aocg8ZmI4opg
        HeEYgzImcOEUrtHi1/D6kydICBLzzbcsMCH+ZLFX1J8nCIowYAIKj6WwO7KdVma/WcvS4PR642u
        COdFG24756qWTYonJyHaDCxveEAZIkzJoP2DD5cJ6xTeI+I0LMu99zcLpJbChjImQ+/UdrXmgxo
        pSnfJ0xZvXPLNjljLWMvM97iKdtDRy8F9w/GAEyyKzJY7d2nbAKbvziCwm7gcNByoSo036XPWWD
        Y7hSSVtO4MFsdgn4i1eyUKehLesc8mYlxUf1axgFdEw7Z/6OSo0+WMW5QyiaANamSpMq+h9WXm+
        yhJKyiGmPPvr2F0CBb0HxLzNR+U55gySjxbin6HZXNSWjgdU+imxgRHwEwmM/fPG6YRJVGukLB2
        Wb4Lb1rooy1QbANnEj1NnWJcw6yx1+dQDOvXhOdnG4+P1pj7urOlC+PL0QDbspKx4YOD3Sc5aFl
        jLyodRD6o1B/tspJ0/uEmq/YsB5V3tqGQeN1KCOayy0lXubRtpkC5N7OtOSgVbxW7FDOVNKstJo
        U2sBQZ7QlMp/RYIpsoi2XrUn/JyeMtMD9QOgAYvR9ppOlv1vcUt5lc1lLgoGRyAacnhaaNuiAOW
        HQNJqcidGwUJuFqYKul77XVhnbtIyOX5+jK537cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--13.600000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25006.003
X-MDID: 1572271170-e58i9LaKtNht
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a field to hold an attached xdp_prog, but never populates it (see
following patch).  Also, XDP_TX support is deferred to a later patch
in the series.

Track failures of xdp_rxq_info_reg() via per-queue xdp_rxq_info_valid
flags and a per-nic xdp_rxq_info_failed flag. The per-queue flags are
needed to prevent attempts to xdp_rxq_info_unreg() structs that failed
to register.  Possibly the API could be changed in the future to avoid
the need for these flags.

Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        |   5 +-
 drivers/net/ethernet/sfc/net_driver.h |  12 +++
 drivers/net/ethernet/sfc/rx.c         | 128 +++++++++++++++++++++++++-
 3 files changed, 143 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 2fef7402233e..bd0424414781 100644
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
@@ -774,6 +776,7 @@ static void efx_stop_datapath(struct efx_nic *efx)
 		efx_for_each_possible_channel_tx_queue(tx_queue, channel)
 			efx_fini_tx_queue(tx_queue);
 	}
+	efx->xdp_rxq_info_failed = false;
 }
 
 static void efx_remove_channel(struct efx_channel *channel)
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 7394d901e021..a5a5055969fb 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -369,6 +369,8 @@ struct efx_rx_page_state {
  *	refill was triggered.
  * @recycle_count: RX buffer recycle counter.
  * @slow_fill: Timer used to defer efx_nic_generate_fill_event().
+ * @xdp_rxq_info: XDP specific RX queue information.
+ * @xdp_rxq_info_valid: Is xdp_rxq_info valid data?.
  */
 struct efx_rx_queue {
 	struct efx_nic *efx;
@@ -400,6 +402,8 @@ struct efx_rx_queue {
 	unsigned int slow_fill_count;
 	/* Statistics to supplement MAC stats */
 	unsigned long rx_packets;
+	struct xdp_rxq_info xdp_rxq_info;
+	bool xdp_rxq_info_valid;
 };
 
 enum efx_sync_events_state {
@@ -900,6 +904,7 @@ struct efx_async_filter_insertion {
  * @loopback_mode: Loopback status
  * @loopback_modes: Supported loopback mode bitmask
  * @loopback_selftest: Offline self-test private state
+ * @xdp_prog: Current XDP programme for this interface
  * @filter_sem: Filter table rw_semaphore, protects existence of @filter_state
  * @filter_state: Architecture-dependent filter table state
  * @rps_mutex: Protects RPS state of all channels
@@ -925,6 +930,8 @@ struct efx_async_filter_insertion {
  * @ptp_data: PTP state data
  * @ptp_warned: has this NIC seen and warned about unexpected PTP events?
  * @vpd_sn: Serial number read from VPD
+ * @xdp_rxq_info_failed: Have any of the rx queues failed to initialise their
+ *      xdp_rxq_info structures?
  * @monitor_work: Hardware monitor workitem
  * @biu_lock: BIU (bus interface unit) lock
  * @last_irq_cpu: Last CPU to handle a possible test interrupt.  This
@@ -1059,6 +1066,10 @@ struct efx_nic {
 	u64 loopback_modes;
 
 	void *loopback_selftest;
+	/* We access loopback_selftest immediately before running XDP,
+	 * so we want them next to each other.
+	 */
+	struct bpf_prog __rcu *xdp_prog;
 
 	struct rw_semaphore filter_sem;
 	void *filter_state;
@@ -1088,6 +1099,7 @@ struct efx_nic {
 	bool ptp_warned;
 
 	char *vpd_sn;
+	bool xdp_rxq_info_failed;
 
 	/* The following fields may be written more often */
 
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 85ec07f5a674..6fabb1925ff1 100644
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
+	int err;
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
+		err = xdp_do_redirect(efx->net_dev, &xdp, xdp_prog);
+		if (unlikely(err)) {
+			efx_free_rx_buffers(rx_queue, rx_buf, 1);
+			if (net_ratelimit())
+				netif_err(efx, rx_err, efx->net_dev,
+					  "XDP redirect failed (%d)\n", err);
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
@@ -764,6 +872,19 @@ void efx_init_rx_queue(struct efx_rx_queue *rx_queue)
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
+		efx->xdp_rxq_info_failed = true;
+	} else {
+		rx_queue->xdp_rxq_info_valid = true;
+	}
+
 	/* Set up RX descriptor ring */
 	efx_nic_init_rx(rx_queue);
 }
@@ -805,6 +926,11 @@ void efx_fini_rx_queue(struct efx_rx_queue *rx_queue)
 	}
 	kfree(rx_queue->page_ring);
 	rx_queue->page_ring = NULL;
+
+	if (rx_queue->xdp_rxq_info_valid)
+		xdp_rxq_info_unreg(&rx_queue->xdp_rxq_info);
+
+	rx_queue->xdp_rxq_info_valid = false;
 }
 
 void efx_remove_rx_queue(struct efx_rx_queue *rx_queue)
