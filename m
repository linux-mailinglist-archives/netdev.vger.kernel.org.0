Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA95134754
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbgAHQNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:13:06 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:57674 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726186AbgAHQNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:13:06 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DC4118008D;
        Wed,  8 Jan 2020 16:13:03 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 Jan 2020 16:12:58 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 10/14] sfc: move channel alloc/removal code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Message-ID: <6d5e9aca-ea70-53f7-db3f-67b20c5e5988@solarflare.com>
Date:   Wed, 8 Jan 2020 16:12:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25154.003
X-TM-AS-Result: No-9.726600-8.000000-10
X-TMASE-MatchedRID: MzIr6dWIThAfs6+GayVk3ZxVZzZr7+O7qeqeEI2dZm3bPo1XmMVNoDIT
        bLcB52Rfg7b/ZwFX9mNTvVffeIwvQwUcfW/oedmqjQlVVwSbjyfuo8ooMQqOsgdkFovAReUoaUX
        s6FguVy19MHuAhPGsHvTi/SmPY4Fu12zJK2teDhBEVqQW9BvtqVjWwaUPviNZ8CWGWvy/Nx3Ez0
        Mzg4hHNlxjThc/i1uzzFJDwZAhIMQ5s4xK97Sm/4lSWYvdSPSYovA/6ONsv0q8YDH/UBNnm9i3r
        fix4Ph2Rb0uqlwbMEBIlvni0qYHOgvRW9YsnxpV34b00P59ZxlcaNB/u5yQq3N4oJrDvdmBwv9A
        ibJlKnDVy1G1jO4I4o/tpHFu3IisXGHdKAJjDWq+ZPZVRF6GWgCm784gsJu496Y0U2Rd33lAafc
        xQhn7e0Ir/OXnA2DuKrvlDT1h3462ILqdj6sZoBz2MDiYujy5pKS8Vb1YbZ1IyDY579vwTIeMLo
        I43uMiw6TQKyu8TFvNzo/a3DiYpmsSifOXO6Tr1bFtmBqqFLSF2KmeplaU3otPd6yYZB/A4Tf2m
        qZbfNj81rI4dvVUOP+TTirA8jJqBsdYbEqwgW5wju9EALAXQkloPruIq9jT+mu6gemw925rQgSR
        g6yiRXEI2hcmxjaGuzqF6W+9RbEWpcsfW0Y5Zvbta0OAYFzy64sVlliWKx9Nfs8n85Te8r2jEZA
        BTymNrSFs54Y4wbX6C0ePs7A07RD7Pzr2apMz0t0ccteCeDfBBpaoMcmPU1ccGuz4EhgzGGf827
        +wl8BTdPdAbRmIl0uFvzEYSdV+
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.726600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578499985-uq6lY8Kh7J66
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reallocation and copying code is included, as well as some housekeeping
code.
Other files have been patched up a bit to accommodate the changes.

Small code styling fixes included.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c          | 420 ----------------------
 drivers/net/ethernet/sfc/efx.h          |   4 -
 drivers/net/ethernet/sfc/efx_channels.c | 440 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_common.c   |  11 -
 drivers/net/ethernet/sfc/siena_sriov.c  |   1 +
 5 files changed, 441 insertions(+), 435 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 8c1cf4cb9c14..955fcf714992 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -96,13 +96,6 @@ static unsigned int rx_irq_mod_usec = 60;
  */
 static unsigned int tx_irq_mod_usec = 150;
 
-/* This is the first interrupt mode to try out of:
- * 0 => MSI-X
- * 1 => MSI
- * 2 => legacy
- */
-static unsigned int interrupt_mode;
-
 /* This is the requested number of CPUs to use for Receive-Side Scaling (RSS),
  * i.e. the number of CPUs among which we may distribute simultaneous
  * interrupt handling.
@@ -244,349 +237,11 @@ void efx_remove_eventq(struct efx_channel *channel)
  *
  *************************************************************************/
 
-/* Allocate and initialise a channel structure. */
-struct efx_channel *
-efx_alloc_channel(struct efx_nic *efx, int i, struct efx_channel *old_channel)
-{
-	struct efx_channel *channel;
-	struct efx_rx_queue *rx_queue;
-	struct efx_tx_queue *tx_queue;
-	int j;
-
-	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
-	if (!channel)
-		return NULL;
-
-	channel->efx = efx;
-	channel->channel = i;
-	channel->type = &efx_default_channel_type;
-
-	for (j = 0; j < EFX_TXQ_TYPES; j++) {
-		tx_queue = &channel->tx_queue[j];
-		tx_queue->efx = efx;
-		tx_queue->queue = i * EFX_TXQ_TYPES + j;
-		tx_queue->channel = channel;
-	}
-
-#ifdef CONFIG_RFS_ACCEL
-	INIT_DELAYED_WORK(&channel->filter_work, efx_filter_rfs_expire);
-#endif
-
-	rx_queue = &channel->rx_queue;
-	rx_queue->efx = efx;
-	timer_setup(&rx_queue->slow_fill, efx_rx_slow_fill, 0);
-
-	return channel;
-}
-
-/* Allocate and initialise a channel structure, copying parameters
- * (but not resources) from an old channel structure.
- */
-struct efx_channel *efx_copy_channel(const struct efx_channel *old_channel)
-{
-	struct efx_channel *channel;
-	struct efx_rx_queue *rx_queue;
-	struct efx_tx_queue *tx_queue;
-	int j;
-
-	channel = kmalloc(sizeof(*channel), GFP_KERNEL);
-	if (!channel)
-		return NULL;
-
-	*channel = *old_channel;
-
-	channel->napi_dev = NULL;
-	INIT_HLIST_NODE(&channel->napi_str.napi_hash_node);
-	channel->napi_str.napi_id = 0;
-	channel->napi_str.state = 0;
-	memset(&channel->eventq, 0, sizeof(channel->eventq));
-
-	for (j = 0; j < EFX_TXQ_TYPES; j++) {
-		tx_queue = &channel->tx_queue[j];
-		if (tx_queue->channel)
-			tx_queue->channel = channel;
-		tx_queue->buffer = NULL;
-		memset(&tx_queue->txd, 0, sizeof(tx_queue->txd));
-	}
-
-	rx_queue = &channel->rx_queue;
-	rx_queue->buffer = NULL;
-	memset(&rx_queue->rxd, 0, sizeof(rx_queue->rxd));
-	timer_setup(&rx_queue->slow_fill, efx_rx_slow_fill, 0);
-#ifdef CONFIG_RFS_ACCEL
-	INIT_DELAYED_WORK(&channel->filter_work, efx_filter_rfs_expire);
-#endif
-
-	return channel;
-}
-
-static int efx_probe_channel(struct efx_channel *channel)
-{
-	struct efx_tx_queue *tx_queue;
-	struct efx_rx_queue *rx_queue;
-	int rc;
-
-	netif_dbg(channel->efx, probe, channel->efx->net_dev,
-		  "creating channel %d\n", channel->channel);
-
-	rc = channel->type->pre_probe(channel);
-	if (rc)
-		goto fail;
-
-	rc = efx_probe_eventq(channel);
-	if (rc)
-		goto fail;
-
-	efx_for_each_channel_tx_queue(tx_queue, channel) {
-		rc = efx_probe_tx_queue(tx_queue);
-		if (rc)
-			goto fail;
-	}
-
-	efx_for_each_channel_rx_queue(rx_queue, channel) {
-		rc = efx_probe_rx_queue(rx_queue);
-		if (rc)
-			goto fail;
-	}
-
-	channel->rx_list = NULL;
-
-	return 0;
-
-fail:
-	efx_remove_channel(channel);
-	return rc;
-}
-
-void efx_get_channel_name(struct efx_channel *channel, char *buf, size_t len)
-{
-	struct efx_nic *efx = channel->efx;
-	const char *type;
-	int number;
-
-	number = channel->channel;
-
-	if (number >= efx->xdp_channel_offset &&
-	    !WARN_ON_ONCE(!efx->n_xdp_channels)) {
-		type = "-xdp";
-		number -= efx->xdp_channel_offset;
-	} else if (efx->tx_channel_offset == 0) {
-		type = "";
-	} else if (number < efx->tx_channel_offset) {
-		type = "-rx";
-	} else {
-		type = "-tx";
-		number -= efx->tx_channel_offset;
-	}
-	snprintf(buf, len, "%s%s-%d", efx->name, type, number);
-}
-
-void efx_set_channel_names(struct efx_nic *efx)
-{
-	struct efx_channel *channel;
-
-	efx_for_each_channel(channel, efx)
-		channel->type->get_name(channel,
-					efx->msi_context[channel->channel].name,
-					sizeof(efx->msi_context[0].name));
-}
-
-int efx_probe_channels(struct efx_nic *efx)
-{
-	struct efx_channel *channel;
-	int rc;
-
-	/* Restart special buffer allocation */
-	efx->next_buffer_table = 0;
-
-	/* Probe channels in reverse, so that any 'extra' channels
-	 * use the start of the buffer table. This allows the traffic
-	 * channels to be resized without moving them or wasting the
-	 * entries before them.
-	 */
-	efx_for_each_channel_rev(channel, efx) {
-		rc = efx_probe_channel(channel);
-		if (rc) {
-			netif_err(efx, probe, efx->net_dev,
-				  "failed to create channel %d\n",
-				  channel->channel);
-			goto fail;
-		}
-	}
-	efx_set_channel_names(efx);
-
-	return 0;
-
-fail:
-	efx_remove_channels(efx);
-	return rc;
-}
-
-void efx_remove_channel(struct efx_channel *channel)
-{
-	struct efx_tx_queue *tx_queue;
-	struct efx_rx_queue *rx_queue;
-
-	netif_dbg(channel->efx, drv, channel->efx->net_dev,
-		  "destroy chan %d\n", channel->channel);
-
-	efx_for_each_channel_rx_queue(rx_queue, channel)
-		efx_remove_rx_queue(rx_queue);
-	efx_for_each_possible_channel_tx_queue(tx_queue, channel)
-		efx_remove_tx_queue(tx_queue);
-	efx_remove_eventq(channel);
-	channel->type->post_remove(channel);
-}
-
-void efx_remove_channels(struct efx_nic *efx)
-{
-	struct efx_channel *channel;
-
-	efx_for_each_channel(channel, efx)
-		efx_remove_channel(channel);
-
-	kfree(efx->xdp_tx_queues);
-}
-
-int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
-{
-	struct efx_channel *other_channel[EFX_MAX_CHANNELS], *channel;
-	u32 old_rxq_entries, old_txq_entries;
-	unsigned i, next_buffer_table = 0;
-	int rc, rc2;
-
-	rc = efx_check_disabled(efx);
-	if (rc)
-		return rc;
-
-	/* Not all channels should be reallocated. We must avoid
-	 * reallocating their buffer table entries.
-	 */
-	efx_for_each_channel(channel, efx) {
-		struct efx_rx_queue *rx_queue;
-		struct efx_tx_queue *tx_queue;
-
-		if (channel->type->copy)
-			continue;
-		next_buffer_table = max(next_buffer_table,
-					channel->eventq.index +
-					channel->eventq.entries);
-		efx_for_each_channel_rx_queue(rx_queue, channel)
-			next_buffer_table = max(next_buffer_table,
-						rx_queue->rxd.index +
-						rx_queue->rxd.entries);
-		efx_for_each_channel_tx_queue(tx_queue, channel)
-			next_buffer_table = max(next_buffer_table,
-						tx_queue->txd.index +
-						tx_queue->txd.entries);
-	}
-
-	efx_device_detach_sync(efx);
-	efx_stop_all(efx);
-	efx_soft_disable_interrupts(efx);
-
-	/* Clone channels (where possible) */
-	memset(other_channel, 0, sizeof(other_channel));
-	for (i = 0; i < efx->n_channels; i++) {
-		channel = efx->channel[i];
-		if (channel->type->copy)
-			channel = channel->type->copy(channel);
-		if (!channel) {
-			rc = -ENOMEM;
-			goto out;
-		}
-		other_channel[i] = channel;
-	}
-
-	/* Swap entry counts and channel pointers */
-	old_rxq_entries = efx->rxq_entries;
-	old_txq_entries = efx->txq_entries;
-	efx->rxq_entries = rxq_entries;
-	efx->txq_entries = txq_entries;
-	for (i = 0; i < efx->n_channels; i++) {
-		channel = efx->channel[i];
-		efx->channel[i] = other_channel[i];
-		other_channel[i] = channel;
-	}
-
-	/* Restart buffer table allocation */
-	efx->next_buffer_table = next_buffer_table;
-
-	for (i = 0; i < efx->n_channels; i++) {
-		channel = efx->channel[i];
-		if (!channel->type->copy)
-			continue;
-		rc = efx_probe_channel(channel);
-		if (rc)
-			goto rollback;
-		efx_init_napi_channel(efx->channel[i]);
-	}
-
-out:
-	/* Destroy unused channel structures */
-	for (i = 0; i < efx->n_channels; i++) {
-		channel = other_channel[i];
-		if (channel && channel->type->copy) {
-			efx_fini_napi_channel(channel);
-			efx_remove_channel(channel);
-			kfree(channel);
-		}
-	}
-
-	rc2 = efx_soft_enable_interrupts(efx);
-	if (rc2) {
-		rc = rc ? rc : rc2;
-		netif_err(efx, drv, efx->net_dev,
-			  "unable to restart interrupts on channel reallocation\n");
-		efx_schedule_reset(efx, RESET_TYPE_DISABLE);
-	} else {
-		efx_start_all(efx);
-		efx_device_attach_if_not_resetting(efx);
-	}
-	return rc;
-
-rollback:
-	/* Swap back */
-	efx->rxq_entries = old_rxq_entries;
-	efx->txq_entries = old_txq_entries;
-	for (i = 0; i < efx->n_channels; i++) {
-		channel = efx->channel[i];
-		efx->channel[i] = other_channel[i];
-		other_channel[i] = channel;
-	}
-	goto out;
-}
-
 void efx_schedule_slow_fill(struct efx_rx_queue *rx_queue)
 {
 	mod_timer(&rx_queue->slow_fill, jiffies + msecs_to_jiffies(10));
 }
 
-bool efx_default_channel_want_txqs(struct efx_channel *channel)
-{
-	return channel->channel - channel->efx->tx_channel_offset <
-		channel->efx->n_tx_channels;
-}
-
-static const struct efx_channel_type efx_default_channel_type = {
-	.pre_probe		= efx_channel_dummy_op_int,
-	.post_remove		= efx_channel_dummy_op_void,
-	.get_name		= efx_get_channel_name,
-	.copy			= efx_copy_channel,
-	.want_txqs		= efx_default_channel_want_txqs,
-	.keep_eventq		= false,
-	.want_pio		= true,
-};
-
-int efx_channel_dummy_op_int(struct efx_channel *channel)
-{
-	return 0;
-}
-
-void efx_channel_dummy_op_void(struct efx_channel *channel)
-{
-}
-
 /**************************************************************************
  *
  * Port handling
@@ -1100,52 +755,6 @@ void efx_remove_interrupts(struct efx_nic *efx)
 	efx->legacy_irq = 0;
 }
 
-int efx_set_channels(struct efx_nic *efx)
-{
-	struct efx_channel *channel;
-	struct efx_tx_queue *tx_queue;
-	int xdp_queue_number;
-
-	efx->tx_channel_offset =
-		efx_separate_tx_channels ?
-		efx->n_channels - efx->n_tx_channels : 0;
-
-	if (efx->xdp_tx_queue_count) {
-		EFX_WARN_ON_PARANOID(efx->xdp_tx_queues);
-
-		/* Allocate array for XDP TX queue lookup. */
-		efx->xdp_tx_queues = kcalloc(efx->xdp_tx_queue_count,
-					     sizeof(*efx->xdp_tx_queues),
-					     GFP_KERNEL);
-		if (!efx->xdp_tx_queues)
-			return -ENOMEM;
-	}
-
-	/* We need to mark which channels really have RX and TX
-	 * queues, and adjust the TX queue numbers if we have separate
-	 * RX-only and TX-only channels.
-	 */
-	xdp_queue_number = 0;
-	efx_for_each_channel(channel, efx) {
-		if (channel->channel < efx->n_rx_channels)
-			channel->rx_queue.core_index = channel->channel;
-		else
-			channel->rx_queue.core_index = -1;
-
-		efx_for_each_channel_tx_queue(tx_queue, channel) {
-			tx_queue->queue -= (efx->tx_channel_offset *
-					    EFX_TXQ_TYPES);
-
-			if (efx_channel_is_xdp_tx(channel) &&
-			    xdp_queue_number < efx->xdp_tx_queue_count) {
-				efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
-				xdp_queue_number++;
-			}
-		}
-	}
-	return 0;
-}
-
 static int efx_probe_nic(struct efx_nic *efx)
 {
 	int rc;
@@ -2022,31 +1631,6 @@ static const struct pci_device_id efx_pci_table[] = {
  *
  **************************************************************************/
 
-int efx_init_channels(struct efx_nic *efx)
-{
-	unsigned int i;
-
-	for (i = 0; i < EFX_MAX_CHANNELS; i++) {
-		efx->channel[i] = efx_alloc_channel(efx, i, NULL);
-		if (!efx->channel[i])
-			return -ENOMEM;
-		efx->msi_context[i].efx = efx;
-		efx->msi_context[i].index = i;
-	}
-
-	/* Higher numbered interrupt modes are less capable! */
-	if (WARN_ON_ONCE(efx->type->max_interrupt_mode >
-			 efx->type->min_interrupt_mode)) {
-		return -EIO;
-	}
-	efx->interrupt_mode = max(efx->type->max_interrupt_mode,
-				  interrupt_mode);
-	efx->interrupt_mode = min(efx->type->min_interrupt_mode,
-				  interrupt_mode);
-
-	return 0;
-}
-
 void efx_update_sw_stats(struct efx_nic *efx, u64 *stats)
 {
 	u64 n_rx_nodesc_trunc = 0;
@@ -2829,10 +2413,6 @@ static struct pci_driver efx_pci_driver = {
  *
  *************************************************************************/
 
-module_param(interrupt_mode, uint, 0444);
-MODULE_PARM_DESC(interrupt_mode,
-		 "Interrupt mode (0=>MSIX 1=>MSI 2=>legacy)");
-
 static int __init efx_init_module(void)
 {
 	int rc;
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 6ff454f2cb62..2b417e779e82 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -203,10 +203,6 @@ static inline bool efx_rss_active(struct efx_rss_context *ctx)
 	return ctx->context_id != EFX_EF10_RSS_CONTEXT_INVALID;
 }
 
-/* Channels */
-int efx_channel_dummy_op_int(struct efx_channel *channel);
-void efx_channel_dummy_op_void(struct efx_channel *channel);
-
 /* Ethtool support */
 extern const struct ethtool_ops efx_ethtool_ops;
 
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index e0d183bd0e78..bd5bc77a1d5a 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -18,6 +18,16 @@
 #include "nic.h"
 #include "sriov.h"
 
+/* This is the first interrupt mode to try out of:
+ * 0 => MSI-X
+ * 1 => MSI
+ * 2 => legacy
+ */
+static unsigned int interrupt_mode;
+module_param(interrupt_mode, uint, 0444);
+MODULE_PARM_DESC(interrupt_mode,
+		 "Interrupt mode (0=>MSIX 1=>MSI 2=>legacy)");
+
 static unsigned int irq_adapt_low_thresh = 8000;
 module_param(irq_adapt_low_thresh, uint, 0644);
 MODULE_PARM_DESC(irq_adapt_low_thresh,
@@ -33,6 +43,436 @@ MODULE_PARM_DESC(irq_adapt_high_thresh,
  */
 static int napi_weight = 64;
 
+/***************
+ * Housekeeping
+ ***************/
+
+int efx_channel_dummy_op_int(struct efx_channel *channel)
+{
+	return 0;
+}
+
+void efx_channel_dummy_op_void(struct efx_channel *channel)
+{
+}
+
+static const struct efx_channel_type efx_default_channel_type = {
+	.pre_probe		= efx_channel_dummy_op_int,
+	.post_remove		= efx_channel_dummy_op_void,
+	.get_name		= efx_get_channel_name,
+	.copy			= efx_copy_channel,
+	.want_txqs		= efx_default_channel_want_txqs,
+	.keep_eventq		= false,
+	.want_pio		= true,
+};
+
+/**************************************************************************
+ *
+ * Channel handling
+ *
+ *************************************************************************/
+
+/* Allocate and initialise a channel structure. */
+struct efx_channel *
+efx_alloc_channel(struct efx_nic *efx, int i, struct efx_channel *old_channel)
+{
+	struct efx_rx_queue *rx_queue;
+	struct efx_tx_queue *tx_queue;
+	struct efx_channel *channel;
+	int j;
+
+	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
+	if (!channel)
+		return NULL;
+
+	channel->efx = efx;
+	channel->channel = i;
+	channel->type = &efx_default_channel_type;
+
+	for (j = 0; j < EFX_TXQ_TYPES; j++) {
+		tx_queue = &channel->tx_queue[j];
+		tx_queue->efx = efx;
+		tx_queue->queue = i * EFX_TXQ_TYPES + j;
+		tx_queue->channel = channel;
+	}
+
+#ifdef CONFIG_RFS_ACCEL
+	INIT_DELAYED_WORK(&channel->filter_work, efx_filter_rfs_expire);
+#endif
+
+	rx_queue = &channel->rx_queue;
+	rx_queue->efx = efx;
+	timer_setup(&rx_queue->slow_fill, efx_rx_slow_fill, 0);
+
+	return channel;
+}
+
+int efx_init_channels(struct efx_nic *efx)
+{
+	unsigned int i;
+
+	for (i = 0; i < EFX_MAX_CHANNELS; i++) {
+		efx->channel[i] = efx_alloc_channel(efx, i, NULL);
+		if (!efx->channel[i])
+			return -ENOMEM;
+		efx->msi_context[i].efx = efx;
+		efx->msi_context[i].index = i;
+	}
+
+	/* Higher numbered interrupt modes are less capable! */
+	if (WARN_ON_ONCE(efx->type->max_interrupt_mode >
+			 efx->type->min_interrupt_mode)) {
+		return -EIO;
+	}
+	efx->interrupt_mode = max(efx->type->max_interrupt_mode,
+				  interrupt_mode);
+	efx->interrupt_mode = min(efx->type->min_interrupt_mode,
+				  interrupt_mode);
+
+	return 0;
+}
+
+void efx_fini_channels(struct efx_nic *efx)
+{
+	unsigned int i;
+
+	for (i = 0; i < EFX_MAX_CHANNELS; i++)
+		if (efx->channel[i]) {
+			kfree(efx->channel[i]);
+			efx->channel[i] = NULL;
+		}
+}
+
+/* Allocate and initialise a channel structure, copying parameters
+ * (but not resources) from an old channel structure.
+ */
+struct efx_channel *efx_copy_channel(const struct efx_channel *old_channel)
+{
+	struct efx_rx_queue *rx_queue;
+	struct efx_tx_queue *tx_queue;
+	struct efx_channel *channel;
+	int j;
+
+	channel = kmalloc(sizeof(*channel), GFP_KERNEL);
+	if (!channel)
+		return NULL;
+
+	*channel = *old_channel;
+
+	channel->napi_dev = NULL;
+	INIT_HLIST_NODE(&channel->napi_str.napi_hash_node);
+	channel->napi_str.napi_id = 0;
+	channel->napi_str.state = 0;
+	memset(&channel->eventq, 0, sizeof(channel->eventq));
+
+	for (j = 0; j < EFX_TXQ_TYPES; j++) {
+		tx_queue = &channel->tx_queue[j];
+		if (tx_queue->channel)
+			tx_queue->channel = channel;
+		tx_queue->buffer = NULL;
+		memset(&tx_queue->txd, 0, sizeof(tx_queue->txd));
+	}
+
+	rx_queue = &channel->rx_queue;
+	rx_queue->buffer = NULL;
+	memset(&rx_queue->rxd, 0, sizeof(rx_queue->rxd));
+	timer_setup(&rx_queue->slow_fill, efx_rx_slow_fill, 0);
+#ifdef CONFIG_RFS_ACCEL
+	INIT_DELAYED_WORK(&channel->filter_work, efx_filter_rfs_expire);
+#endif
+
+	return channel;
+}
+
+static int efx_probe_channel(struct efx_channel *channel)
+{
+	struct efx_tx_queue *tx_queue;
+	struct efx_rx_queue *rx_queue;
+	int rc;
+
+	netif_dbg(channel->efx, probe, channel->efx->net_dev,
+		  "creating channel %d\n", channel->channel);
+
+	rc = channel->type->pre_probe(channel);
+	if (rc)
+		goto fail;
+
+	rc = efx_probe_eventq(channel);
+	if (rc)
+		goto fail;
+
+	efx_for_each_channel_tx_queue(tx_queue, channel) {
+		rc = efx_probe_tx_queue(tx_queue);
+		if (rc)
+			goto fail;
+	}
+
+	efx_for_each_channel_rx_queue(rx_queue, channel) {
+		rc = efx_probe_rx_queue(rx_queue);
+		if (rc)
+			goto fail;
+	}
+
+	channel->rx_list = NULL;
+
+	return 0;
+
+fail:
+	efx_remove_channel(channel);
+	return rc;
+}
+
+void efx_get_channel_name(struct efx_channel *channel, char *buf, size_t len)
+{
+	struct efx_nic *efx = channel->efx;
+	const char *type;
+	int number;
+
+	number = channel->channel;
+
+	if (number >= efx->xdp_channel_offset &&
+	    !WARN_ON_ONCE(!efx->n_xdp_channels)) {
+		type = "-xdp";
+		number -= efx->xdp_channel_offset;
+	} else if (efx->tx_channel_offset == 0) {
+		type = "";
+	} else if (number < efx->tx_channel_offset) {
+		type = "-rx";
+	} else {
+		type = "-tx";
+		number -= efx->tx_channel_offset;
+	}
+	snprintf(buf, len, "%s%s-%d", efx->name, type, number);
+}
+
+void efx_set_channel_names(struct efx_nic *efx)
+{
+	struct efx_channel *channel;
+
+	efx_for_each_channel(channel, efx)
+		channel->type->get_name(channel,
+					efx->msi_context[channel->channel].name,
+					sizeof(efx->msi_context[0].name));
+}
+
+int efx_probe_channels(struct efx_nic *efx)
+{
+	struct efx_channel *channel;
+	int rc;
+
+	/* Restart special buffer allocation */
+	efx->next_buffer_table = 0;
+
+	/* Probe channels in reverse, so that any 'extra' channels
+	 * use the start of the buffer table. This allows the traffic
+	 * channels to be resized without moving them or wasting the
+	 * entries before them.
+	 */
+	efx_for_each_channel_rev(channel, efx) {
+		rc = efx_probe_channel(channel);
+		if (rc) {
+			netif_err(efx, probe, efx->net_dev,
+				  "failed to create channel %d\n",
+				  channel->channel);
+			goto fail;
+		}
+	}
+	efx_set_channel_names(efx);
+
+	return 0;
+
+fail:
+	efx_remove_channels(efx);
+	return rc;
+}
+
+void efx_remove_channel(struct efx_channel *channel)
+{
+	struct efx_tx_queue *tx_queue;
+	struct efx_rx_queue *rx_queue;
+
+	netif_dbg(channel->efx, drv, channel->efx->net_dev,
+		  "destroy chan %d\n", channel->channel);
+
+	efx_for_each_channel_rx_queue(rx_queue, channel)
+		efx_remove_rx_queue(rx_queue);
+	efx_for_each_possible_channel_tx_queue(tx_queue, channel)
+		efx_remove_tx_queue(tx_queue);
+	efx_remove_eventq(channel);
+	channel->type->post_remove(channel);
+}
+
+void efx_remove_channels(struct efx_nic *efx)
+{
+	struct efx_channel *channel;
+
+	efx_for_each_channel(channel, efx)
+		efx_remove_channel(channel);
+
+	kfree(efx->xdp_tx_queues);
+}
+
+int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
+{
+	struct efx_channel *other_channel[EFX_MAX_CHANNELS], *channel;
+	unsigned int i, next_buffer_table = 0;
+	u32 old_rxq_entries, old_txq_entries;
+	int rc, rc2;
+
+	rc = efx_check_disabled(efx);
+	if (rc)
+		return rc;
+
+	/* Not all channels should be reallocated. We must avoid
+	 * reallocating their buffer table entries.
+	 */
+	efx_for_each_channel(channel, efx) {
+		struct efx_rx_queue *rx_queue;
+		struct efx_tx_queue *tx_queue;
+
+		if (channel->type->copy)
+			continue;
+		next_buffer_table = max(next_buffer_table,
+					channel->eventq.index +
+					channel->eventq.entries);
+		efx_for_each_channel_rx_queue(rx_queue, channel)
+			next_buffer_table = max(next_buffer_table,
+						rx_queue->rxd.index +
+						rx_queue->rxd.entries);
+		efx_for_each_channel_tx_queue(tx_queue, channel)
+			next_buffer_table = max(next_buffer_table,
+						tx_queue->txd.index +
+						tx_queue->txd.entries);
+	}
+
+	efx_device_detach_sync(efx);
+	efx_stop_all(efx);
+	efx_soft_disable_interrupts(efx);
+
+	/* Clone channels (where possible) */
+	memset(other_channel, 0, sizeof(other_channel));
+	for (i = 0; i < efx->n_channels; i++) {
+		channel = efx->channel[i];
+		if (channel->type->copy)
+			channel = channel->type->copy(channel);
+		if (!channel) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		other_channel[i] = channel;
+	}
+
+	/* Swap entry counts and channel pointers */
+	old_rxq_entries = efx->rxq_entries;
+	old_txq_entries = efx->txq_entries;
+	efx->rxq_entries = rxq_entries;
+	efx->txq_entries = txq_entries;
+	for (i = 0; i < efx->n_channels; i++) {
+		channel = efx->channel[i];
+		efx->channel[i] = other_channel[i];
+		other_channel[i] = channel;
+	}
+
+	/* Restart buffer table allocation */
+	efx->next_buffer_table = next_buffer_table;
+
+	for (i = 0; i < efx->n_channels; i++) {
+		channel = efx->channel[i];
+		if (!channel->type->copy)
+			continue;
+		rc = efx_probe_channel(channel);
+		if (rc)
+			goto rollback;
+		efx_init_napi_channel(efx->channel[i]);
+	}
+
+out:
+	/* Destroy unused channel structures */
+	for (i = 0; i < efx->n_channels; i++) {
+		channel = other_channel[i];
+		if (channel && channel->type->copy) {
+			efx_fini_napi_channel(channel);
+			efx_remove_channel(channel);
+			kfree(channel);
+		}
+	}
+
+	rc2 = efx_soft_enable_interrupts(efx);
+	if (rc2) {
+		rc = rc ? rc : rc2;
+		netif_err(efx, drv, efx->net_dev,
+			  "unable to restart interrupts on channel reallocation\n");
+		efx_schedule_reset(efx, RESET_TYPE_DISABLE);
+	} else {
+		efx_start_all(efx);
+		efx_device_attach_if_not_resetting(efx);
+	}
+	return rc;
+
+rollback:
+	/* Swap back */
+	efx->rxq_entries = old_rxq_entries;
+	efx->txq_entries = old_txq_entries;
+	for (i = 0; i < efx->n_channels; i++) {
+		channel = efx->channel[i];
+		efx->channel[i] = other_channel[i];
+		other_channel[i] = channel;
+	}
+	goto out;
+}
+
+int efx_set_channels(struct efx_nic *efx)
+{
+	struct efx_channel *channel;
+	struct efx_tx_queue *tx_queue;
+	int xdp_queue_number;
+
+	efx->tx_channel_offset =
+		efx_separate_tx_channels ?
+		efx->n_channels - efx->n_tx_channels : 0;
+
+	if (efx->xdp_tx_queue_count) {
+		EFX_WARN_ON_PARANOID(efx->xdp_tx_queues);
+
+		/* Allocate array for XDP TX queue lookup. */
+		efx->xdp_tx_queues = kcalloc(efx->xdp_tx_queue_count,
+					     sizeof(*efx->xdp_tx_queues),
+					     GFP_KERNEL);
+		if (!efx->xdp_tx_queues)
+			return -ENOMEM;
+	}
+
+	/* We need to mark which channels really have RX and TX
+	 * queues, and adjust the TX queue numbers if we have separate
+	 * RX-only and TX-only channels.
+	 */
+	xdp_queue_number = 0;
+	efx_for_each_channel(channel, efx) {
+		if (channel->channel < efx->n_rx_channels)
+			channel->rx_queue.core_index = channel->channel;
+		else
+			channel->rx_queue.core_index = -1;
+
+		efx_for_each_channel_tx_queue(tx_queue, channel) {
+			tx_queue->queue -= (efx->tx_channel_offset *
+					    EFX_TXQ_TYPES);
+
+			if (efx_channel_is_xdp_tx(channel) &&
+			    xdp_queue_number < efx->xdp_tx_queue_count) {
+				efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
+				xdp_queue_number++;
+			}
+		}
+	}
+	return 0;
+}
+
+bool efx_default_channel_want_txqs(struct efx_channel *channel)
+{
+	return channel->channel - channel->efx->tx_channel_offset <
+		channel->efx->n_tx_channels;
+}
+
 /*************
  * START/STOP
  *************/
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index d0fc51a108bf..fe74c66c8ec6 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -884,17 +884,6 @@ int efx_init_struct(struct efx_nic *efx,
 	return rc;
 }
 
-void efx_fini_channels(struct efx_nic *efx)
-{
-	unsigned int i;
-
-	for (i = 0; i < EFX_MAX_CHANNELS; i++)
-		if (efx->channel[i]) {
-			kfree(efx->channel[i]);
-			efx->channel[i] = NULL;
-		}
-}
-
 void efx_fini_struct(struct efx_nic *efx)
 {
 #ifdef CONFIG_RFS_ACCEL
diff --git a/drivers/net/ethernet/sfc/siena_sriov.c b/drivers/net/ethernet/sfc/siena_sriov.c
index dfbdf05dcf79..83dcfcae3d4b 100644
--- a/drivers/net/ethernet/sfc/siena_sriov.c
+++ b/drivers/net/ethernet/sfc/siena_sriov.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include "net_driver.h"
 #include "efx.h"
+#include "efx_channels.h"
 #include "nic.h"
 #include "io.h"
 #include "mcdi.h"
-- 
2.20.1


