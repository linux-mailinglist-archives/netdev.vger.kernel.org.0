Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDDE50BAEB
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 16:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449071AbiDVPBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449076AbiDVPBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:01:42 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F17F5C871
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 07:58:41 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id DA3D0320133;
        Fri, 22 Apr 2022 15:58:38 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhuk0-00079O-NF; Fri, 22 Apr 2022 15:58:36 +0100
Subject: [PATCH net-next 07/28] sfc/siena: Rename functions in
 efx_channels.h to avoid conflicts with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 15:58:35 +0100
Message-ID: <165063951574.27138.17359005147161713372.stgit@palantir17.mph.net>
In-Reply-To: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Habets <martinh@xilinx.com>

For siena use efx_siena_ as the function prefix.
Several functions are only used inside efx_channels.c for Siena so
they can become static.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx.c          |   42 +++++-----
 drivers/net/ethernet/sfc/siena/efx_channels.c |  107 +++++++++++++------------
 drivers/net/ethernet/sfc/siena/efx_channels.h |   67 +++++++---------
 drivers/net/ethernet/sfc/siena/efx_common.c   |   14 ++-
 drivers/net/ethernet/sfc/siena/ethtool.c      |    2 
 drivers/net/ethernet/sfc/siena/farch.c        |   13 ++-
 drivers/net/ethernet/sfc/siena/selftest.c     |   10 +-
 drivers/net/ethernet/sfc/siena/siena_sriov.c  |    2 
 8 files changed, 129 insertions(+), 128 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index b488c2c3580e..f54f3619705a 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -43,11 +43,11 @@
  *
  *************************************************************************/
 
-module_param_named(interrupt_mode, efx_interrupt_mode, uint, 0444);
+module_param_named(interrupt_mode, efx_siena_interrupt_mode, uint, 0444);
 MODULE_PARM_DESC(interrupt_mode,
 		 "Interrupt mode (0=>MSIX 1=>MSI 2=>legacy)");
 
-module_param(rss_cpus, uint, 0444);
+module_param_named(rss_cpus, efx_siena_rss_cpus, uint, 0444);
 MODULE_PARM_DESC(rss_cpus, "Number of CPUs to use for Receive-Side Scaling");
 
 /*
@@ -284,11 +284,11 @@ static int efx_probe_nic(struct efx_nic *efx)
 		/* Determine the number of channels and queues by trying
 		 * to hook in MSI-X interrupts.
 		 */
-		rc = efx_probe_interrupts(efx);
+		rc = efx_siena_probe_interrupts(efx);
 		if (rc)
 			goto fail1;
 
-		rc = efx_set_channels(efx);
+		rc = efx_siena_set_channels(efx);
 		if (rc)
 			goto fail1;
 
@@ -299,7 +299,7 @@ static int efx_probe_nic(struct efx_nic *efx)
 
 		if (rc == -EAGAIN)
 			/* try again with new max_channels */
-			efx_remove_interrupts(efx);
+			efx_siena_remove_interrupts(efx);
 
 	} while (rc == -EAGAIN);
 
@@ -316,7 +316,7 @@ static int efx_probe_nic(struct efx_nic *efx)
 	return 0;
 
 fail2:
-	efx_remove_interrupts(efx);
+	efx_siena_remove_interrupts(efx);
 fail1:
 	efx->type->remove(efx);
 	return rc;
@@ -326,7 +326,7 @@ static void efx_remove_nic(struct efx_nic *efx)
 {
 	netif_dbg(efx, drv, efx->net_dev, "destroying NIC\n");
 
-	efx_remove_interrupts(efx);
+	efx_siena_remove_interrupts(efx);
 	efx->type->remove(efx);
 }
 
@@ -373,7 +373,7 @@ static int efx_probe_all(struct efx_nic *efx)
 		goto fail4;
 	}
 
-	rc = efx_probe_channels(efx);
+	rc = efx_siena_probe_channels(efx);
 	if (rc)
 		goto fail5;
 
@@ -399,7 +399,7 @@ static void efx_remove_all(struct efx_nic *efx)
 	efx_xdp_setup_prog(efx, NULL);
 	rtnl_unlock();
 
-	efx_remove_channels(efx);
+	efx_siena_remove_channels(efx);
 	efx_remove_filters(efx);
 #ifdef CONFIG_SFC_SRIOV
 	efx->type->vswitching_remove(efx);
@@ -662,7 +662,7 @@ static void efx_update_name(struct efx_nic *efx)
 {
 	strcpy(efx->name, efx->net_dev->name);
 	efx_siena_mtd_rename(efx);
-	efx_set_channel_names(efx);
+	efx_siena_set_channel_names(efx);
 }
 
 static int efx_netdev_event(struct notifier_block *this,
@@ -827,12 +827,12 @@ static void efx_pci_remove_main(struct efx_nic *efx)
 	BUG_ON(efx->state == STATE_READY);
 	efx_siena_flush_reset_workqueue(efx);
 
-	efx_disable_interrupts(efx);
-	efx_clear_interrupt_affinity(efx);
+	efx_siena_disable_interrupts(efx);
+	efx_siena_clear_interrupt_affinity(efx);
 	efx_nic_fini_interrupt(efx);
 	efx_fini_port(efx);
 	efx->type->fini(efx);
-	efx_fini_napi(efx);
+	efx_siena_fini_napi(efx);
 	efx_remove_all(efx);
 }
 
@@ -852,7 +852,7 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
 	rtnl_lock();
 	efx_dissociate(efx);
 	dev_close(efx->net_dev);
-	efx_disable_interrupts(efx);
+	efx_siena_disable_interrupts(efx);
 	efx->state = STATE_UNINIT;
 	rtnl_unlock();
 
@@ -921,7 +921,7 @@ static int efx_pci_probe_main(struct efx_nic *efx)
 	if (rc)
 		goto fail1;
 
-	efx_init_napi(efx);
+	efx_siena_init_napi(efx);
 
 	down_write(&efx->filter_sem);
 	rc = efx->type->init(efx);
@@ -942,22 +942,22 @@ static int efx_pci_probe_main(struct efx_nic *efx)
 	if (rc)
 		goto fail5;
 
-	efx_set_interrupt_affinity(efx);
-	rc = efx_enable_interrupts(efx);
+	efx_siena_set_interrupt_affinity(efx);
+	rc = efx_siena_enable_interrupts(efx);
 	if (rc)
 		goto fail6;
 
 	return 0;
 
  fail6:
-	efx_clear_interrupt_affinity(efx);
+	efx_siena_clear_interrupt_affinity(efx);
 	efx_nic_fini_interrupt(efx);
  fail5:
 	efx_fini_port(efx);
  fail4:
 	efx->type->fini(efx);
  fail3:
-	efx_fini_napi(efx);
+	efx_siena_fini_napi(efx);
 	efx_remove_all(efx);
  fail1:
 	return rc;
@@ -1136,7 +1136,7 @@ static int efx_pm_freeze(struct device *dev)
 		efx_device_detach_sync(efx);
 
 		efx_siena_stop_all(efx);
-		efx_disable_interrupts(efx);
+		efx_siena_disable_interrupts(efx);
 	}
 
 	rtnl_unlock();
@@ -1152,7 +1152,7 @@ static int efx_pm_thaw(struct device *dev)
 	rtnl_lock();
 
 	if (efx->state != STATE_DISABLED) {
-		rc = efx_enable_interrupts(efx);
+		rc = efx_siena_enable_interrupts(efx);
 		if (rc)
 			goto fail;
 
diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
index 5e22edc51ad2..0c261a2f0f96 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.c
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
@@ -25,7 +25,7 @@
  * 1 => MSI
  * 2 => legacy
  */
-unsigned int efx_interrupt_mode = EFX_INT_MODE_MSIX;
+unsigned int efx_siena_interrupt_mode = EFX_INT_MODE_MSIX;
 
 /* This is the requested number of CPUs to use for Receive-Side Scaling (RSS),
  * i.e. the number of CPUs among which we may distribute simultaneous
@@ -34,7 +34,7 @@ unsigned int efx_interrupt_mode = EFX_INT_MODE_MSIX;
  * Cards without MSI-X will only target one CPU via legacy or MSI interrupt.
  * The default (0) means to assign an interrupt to each core.
  */
-unsigned int rss_cpus;
+unsigned int efx_siena_rss_cpus;
 
 static unsigned int irq_adapt_low_thresh = 8000;
 module_param(irq_adapt_low_thresh, uint, 0644);
@@ -89,8 +89,8 @@ static unsigned int efx_wanted_parallelism(struct efx_nic *efx)
 {
 	unsigned int count;
 
-	if (rss_cpus) {
-		count = rss_cpus;
+	if (efx_siena_rss_cpus) {
+		count = efx_siena_rss_cpus;
 	} else {
 		count = count_online_cores(efx, true);
 
@@ -100,7 +100,8 @@ static unsigned int efx_wanted_parallelism(struct efx_nic *efx)
 	}
 
 	if (count > EFX_MAX_RX_QUEUES) {
-		netif_cond_dbg(efx, probe, efx->net_dev, !rss_cpus, warn,
+		netif_cond_dbg(efx, probe, efx->net_dev, !efx_siena_rss_cpus,
+			       warn,
 			       "Reducing number of rx queues from %u to %u.\n",
 			       count, EFX_MAX_RX_QUEUES);
 		count = EFX_MAX_RX_QUEUES;
@@ -249,7 +250,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 /* Probe the number and type of interrupts we are able to obtain, and
  * the resulting numbers of channels and RX queues.
  */
-int efx_probe_interrupts(struct efx_nic *efx)
+int efx_siena_probe_interrupts(struct efx_nic *efx)
 {
 	unsigned int extra_channels = 0;
 	unsigned int rss_spread;
@@ -361,7 +362,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 }
 
 #if defined(CONFIG_SMP)
-void efx_set_interrupt_affinity(struct efx_nic *efx)
+void efx_siena_set_interrupt_affinity(struct efx_nic *efx)
 {
 	const struct cpumask *numa_mask = cpumask_of_pcibus(efx->pci_dev->bus);
 	struct efx_channel *channel;
@@ -380,7 +381,7 @@ void efx_set_interrupt_affinity(struct efx_nic *efx)
 	}
 }
 
-void efx_clear_interrupt_affinity(struct efx_nic *efx)
+void efx_siena_clear_interrupt_affinity(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -389,17 +390,17 @@ void efx_clear_interrupt_affinity(struct efx_nic *efx)
 }
 #else
 void
-efx_set_interrupt_affinity(struct efx_nic *efx __attribute__ ((unused)))
+efx_siena_set_interrupt_affinity(struct efx_nic *efx __always_unused)
 {
 }
 
 void
-efx_clear_interrupt_affinity(struct efx_nic *efx __attribute__ ((unused)))
+efx_siena_clear_interrupt_affinity(struct efx_nic *efx __always_unused)
 {
 }
 #endif /* CONFIG_SMP */
 
-void efx_remove_interrupts(struct efx_nic *efx)
+void efx_siena_remove_interrupts(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -422,7 +423,7 @@ void efx_remove_interrupts(struct efx_nic *efx)
  * is reset, the memory buffer will be reused; this guards against
  * errors during channel reset and also simplifies interrupt handling.
  */
-int efx_probe_eventq(struct efx_channel *channel)
+static int efx_probe_eventq(struct efx_channel *channel)
 {
 	struct efx_nic *efx = channel->efx;
 	unsigned long entries;
@@ -441,7 +442,7 @@ int efx_probe_eventq(struct efx_channel *channel)
 }
 
 /* Prepare channel's event queue */
-int efx_init_eventq(struct efx_channel *channel)
+static int efx_init_eventq(struct efx_channel *channel)
 {
 	struct efx_nic *efx = channel->efx;
 	int rc;
@@ -461,7 +462,7 @@ int efx_init_eventq(struct efx_channel *channel)
 }
 
 /* Enable event queue processing and NAPI */
-void efx_start_eventq(struct efx_channel *channel)
+void efx_siena_start_eventq(struct efx_channel *channel)
 {
 	netif_dbg(channel->efx, ifup, channel->efx->net_dev,
 		  "chan %d start event queue\n", channel->channel);
@@ -475,7 +476,7 @@ void efx_start_eventq(struct efx_channel *channel)
 }
 
 /* Disable event queue processing and NAPI */
-void efx_stop_eventq(struct efx_channel *channel)
+void efx_siena_stop_eventq(struct efx_channel *channel)
 {
 	if (!channel->enabled)
 		return;
@@ -484,7 +485,7 @@ void efx_stop_eventq(struct efx_channel *channel)
 	channel->enabled = false;
 }
 
-void efx_fini_eventq(struct efx_channel *channel)
+static void efx_fini_eventq(struct efx_channel *channel)
 {
 	if (!channel->eventq_init)
 		return;
@@ -496,7 +497,7 @@ void efx_fini_eventq(struct efx_channel *channel)
 	channel->eventq_init = false;
 }
 
-void efx_remove_eventq(struct efx_channel *channel)
+static void efx_remove_eventq(struct efx_channel *channel)
 {
 	netif_dbg(channel->efx, drv, channel->efx->net_dev,
 		  "chan %d remove event queue\n", channel->channel);
@@ -562,7 +563,7 @@ static struct efx_channel *efx_alloc_channel(struct efx_nic *efx, int i)
 	return channel;
 }
 
-int efx_init_channels(struct efx_nic *efx)
+int efx_siena_init_channels(struct efx_nic *efx)
 {
 	unsigned int i;
 
@@ -576,7 +577,7 @@ int efx_init_channels(struct efx_nic *efx)
 
 	/* Higher numbered interrupt modes are less capable! */
 	efx->interrupt_mode = min(efx->type->min_interrupt_mode,
-				  efx_interrupt_mode);
+				  efx_siena_interrupt_mode);
 
 	efx->max_channels = EFX_MAX_CHANNELS;
 	efx->max_tx_channels = EFX_MAX_CHANNELS;
@@ -584,7 +585,7 @@ int efx_init_channels(struct efx_nic *efx)
 	return 0;
 }
 
-void efx_fini_channels(struct efx_nic *efx)
+void efx_siena_fini_channels(struct efx_nic *efx)
 {
 	unsigned int i;
 
@@ -672,7 +673,7 @@ static int efx_probe_channel(struct efx_channel *channel)
 	return 0;
 
 fail:
-	efx_remove_channel(channel);
+	efx_siena_remove_channel(channel);
 	return rc;
 }
 
@@ -700,7 +701,7 @@ static void efx_get_channel_name(struct efx_channel *channel, char *buf,
 	snprintf(buf, len, "%s%s-%d", efx->name, type, number);
 }
 
-void efx_set_channel_names(struct efx_nic *efx)
+void efx_siena_set_channel_names(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -710,7 +711,7 @@ void efx_set_channel_names(struct efx_nic *efx)
 					sizeof(efx->msi_context[0].name));
 }
 
-int efx_probe_channels(struct efx_nic *efx)
+int efx_siena_probe_channels(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 	int rc;
@@ -732,16 +733,16 @@ int efx_probe_channels(struct efx_nic *efx)
 			goto fail;
 		}
 	}
-	efx_set_channel_names(efx);
+	efx_siena_set_channel_names(efx);
 
 	return 0;
 
 fail:
-	efx_remove_channels(efx);
+	efx_siena_remove_channels(efx);
 	return rc;
 }
 
-void efx_remove_channel(struct efx_channel *channel)
+void efx_siena_remove_channel(struct efx_channel *channel)
 {
 	struct efx_tx_queue *tx_queue;
 	struct efx_rx_queue *rx_queue;
@@ -757,17 +758,23 @@ void efx_remove_channel(struct efx_channel *channel)
 	channel->type->post_remove(channel);
 }
 
-void efx_remove_channels(struct efx_nic *efx)
+void efx_siena_remove_channels(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
 	efx_for_each_channel(channel, efx)
-		efx_remove_channel(channel);
+		efx_siena_remove_channel(channel);
 
 	kfree(efx->xdp_tx_queues);
 }
 
-int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
+static int efx_soft_enable_interrupts(struct efx_nic *efx);
+static void efx_soft_disable_interrupts(struct efx_nic *efx);
+static void efx_init_napi_channel(struct efx_channel *channel);
+static void efx_fini_napi_channel(struct efx_channel *channel);
+
+int efx_siena_realloc_channels(struct efx_nic *efx, u32 rxq_entries,
+			       u32 txq_entries)
 {
 	struct efx_channel *other_channel[EFX_MAX_CHANNELS], *channel;
 	unsigned int i, next_buffer_table = 0;
@@ -844,7 +851,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 		channel = other_channel[i];
 		if (channel && channel->type->copy) {
 			efx_fini_napi_channel(channel);
-			efx_remove_channel(channel);
+			efx_siena_remove_channel(channel);
 			kfree(channel);
 		}
 	}
@@ -884,7 +891,7 @@ efx_set_xdp_tx_queue(struct efx_nic *efx, int xdp_queue_number,
 	return 0;
 }
 
-int efx_set_channels(struct efx_nic *efx)
+int efx_siena_set_channels(struct efx_nic *efx)
 {
 	struct efx_tx_queue *tx_queue;
 	struct efx_channel *channel;
@@ -979,7 +986,7 @@ static bool efx_default_channel_want_txqs(struct efx_channel *channel)
  * START/STOP
  *************/
 
-int efx_soft_enable_interrupts(struct efx_nic *efx)
+static int efx_soft_enable_interrupts(struct efx_nic *efx)
 {
 	struct efx_channel *channel, *end_channel;
 	int rc;
@@ -995,7 +1002,7 @@ int efx_soft_enable_interrupts(struct efx_nic *efx)
 			if (rc)
 				goto fail;
 		}
-		efx_start_eventq(channel);
+		efx_siena_start_eventq(channel);
 	}
 
 	efx_mcdi_mode_event(efx);
@@ -1006,7 +1013,7 @@ int efx_soft_enable_interrupts(struct efx_nic *efx)
 	efx_for_each_channel(channel, efx) {
 		if (channel == end_channel)
 			break;
-		efx_stop_eventq(channel);
+		efx_siena_stop_eventq(channel);
 		if (!channel->type->keep_eventq)
 			efx_fini_eventq(channel);
 	}
@@ -1014,7 +1021,7 @@ int efx_soft_enable_interrupts(struct efx_nic *efx)
 	return rc;
 }
 
-void efx_soft_disable_interrupts(struct efx_nic *efx)
+static void efx_soft_disable_interrupts(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -1033,7 +1040,7 @@ void efx_soft_disable_interrupts(struct efx_nic *efx)
 		if (channel->irq)
 			synchronize_irq(channel->irq);
 
-		efx_stop_eventq(channel);
+		efx_siena_stop_eventq(channel);
 		if (!channel->type->keep_eventq)
 			efx_fini_eventq(channel);
 	}
@@ -1042,7 +1049,7 @@ void efx_soft_disable_interrupts(struct efx_nic *efx)
 	efx_mcdi_flush_async(efx);
 }
 
-int efx_enable_interrupts(struct efx_nic *efx)
+int efx_siena_enable_interrupts(struct efx_nic *efx)
 {
 	struct efx_channel *channel, *end_channel;
 	int rc;
@@ -1085,7 +1092,7 @@ int efx_enable_interrupts(struct efx_nic *efx)
 	return rc;
 }
 
-void efx_disable_interrupts(struct efx_nic *efx)
+void efx_siena_disable_interrupts(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -1099,7 +1106,7 @@ void efx_disable_interrupts(struct efx_nic *efx)
 	efx->type->irq_disable_non_ev(efx);
 }
 
-void efx_start_channels(struct efx_nic *efx)
+void efx_siena_start_channels(struct efx_nic *efx)
 {
 	struct efx_tx_queue *tx_queue;
 	struct efx_rx_queue *rx_queue;
@@ -1114,16 +1121,16 @@ void efx_start_channels(struct efx_nic *efx)
 		efx_for_each_channel_rx_queue(rx_queue, channel) {
 			efx_init_rx_queue(rx_queue);
 			atomic_inc(&efx->active_queues);
-			efx_stop_eventq(channel);
+			efx_siena_stop_eventq(channel);
 			efx_fast_push_rx_descriptors(rx_queue, false);
-			efx_start_eventq(channel);
+			efx_siena_start_eventq(channel);
 		}
 
 		WARN_ON(channel->rx_pkt_n_frags);
 	}
 }
 
-void efx_stop_channels(struct efx_nic *efx)
+void efx_siena_stop_channels(struct efx_nic *efx)
 {
 	struct efx_tx_queue *tx_queue;
 	struct efx_rx_queue *rx_queue;
@@ -1144,8 +1151,8 @@ void efx_stop_channels(struct efx_nic *efx)
 		 * temporarily.
 		 */
 		if (efx_channel_has_rx_queue(channel)) {
-			efx_stop_eventq(channel);
-			efx_start_eventq(channel);
+			efx_siena_stop_eventq(channel);
+			efx_siena_start_eventq(channel);
 		}
 	}
 
@@ -1295,7 +1302,7 @@ static int efx_poll(struct napi_struct *napi, int budget)
 	return spent;
 }
 
-void efx_init_napi_channel(struct efx_channel *channel)
+static void efx_init_napi_channel(struct efx_channel *channel)
 {
 	struct efx_nic *efx = channel->efx;
 
@@ -1304,7 +1311,7 @@ void efx_init_napi_channel(struct efx_channel *channel)
 		       efx_poll, napi_weight);
 }
 
-void efx_init_napi(struct efx_nic *efx)
+void efx_siena_init_napi(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -1312,7 +1319,7 @@ void efx_init_napi(struct efx_nic *efx)
 		efx_init_napi_channel(channel);
 }
 
-void efx_fini_napi_channel(struct efx_channel *channel)
+static void efx_fini_napi_channel(struct efx_channel *channel)
 {
 	if (channel->napi_dev)
 		netif_napi_del(&channel->napi_str);
@@ -1320,7 +1327,7 @@ void efx_fini_napi_channel(struct efx_channel *channel)
 	channel->napi_dev = NULL;
 }
 
-void efx_fini_napi(struct efx_nic *efx)
+void efx_siena_fini_napi(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -1337,13 +1344,13 @@ static int efx_channel_dummy_op_int(struct efx_channel *channel)
 	return 0;
 }
 
-void efx_channel_dummy_op_void(struct efx_channel *channel)
+void efx_siena_channel_dummy_op_void(struct efx_channel *channel)
 {
 }
 
 static const struct efx_channel_type efx_default_channel_type = {
 	.pre_probe		= efx_channel_dummy_op_int,
-	.post_remove		= efx_channel_dummy_op_void,
+	.post_remove		= efx_siena_channel_dummy_op_void,
 	.get_name		= efx_get_channel_name,
 	.copy			= efx_copy_channel,
 	.want_txqs		= efx_default_channel_want_txqs,
diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.h b/drivers/net/ethernet/sfc/siena/efx_channels.h
index 64abb99a56b8..10d78049b885 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.h
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.h
@@ -11,42 +11,35 @@
 #ifndef EFX_CHANNELS_H
 #define EFX_CHANNELS_H
 
-extern unsigned int efx_interrupt_mode;
-extern unsigned int rss_cpus;
-
-int efx_probe_interrupts(struct efx_nic *efx);
-void efx_remove_interrupts(struct efx_nic *efx);
-int efx_soft_enable_interrupts(struct efx_nic *efx);
-void efx_soft_disable_interrupts(struct efx_nic *efx);
-int efx_enable_interrupts(struct efx_nic *efx);
-void efx_disable_interrupts(struct efx_nic *efx);
-
-void efx_set_interrupt_affinity(struct efx_nic *efx);
-void efx_clear_interrupt_affinity(struct efx_nic *efx);
-
-int efx_probe_eventq(struct efx_channel *channel);
-int efx_init_eventq(struct efx_channel *channel);
-void efx_start_eventq(struct efx_channel *channel);
-void efx_stop_eventq(struct efx_channel *channel);
-void efx_fini_eventq(struct efx_channel *channel);
-void efx_remove_eventq(struct efx_channel *channel);
-
-int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries);
-void efx_set_channel_names(struct efx_nic *efx);
-int efx_init_channels(struct efx_nic *efx);
-int efx_probe_channels(struct efx_nic *efx);
-int efx_set_channels(struct efx_nic *efx);
-void efx_remove_channel(struct efx_channel *channel);
-void efx_remove_channels(struct efx_nic *efx);
-void efx_fini_channels(struct efx_nic *efx);
-void efx_start_channels(struct efx_nic *efx);
-void efx_stop_channels(struct efx_nic *efx);
-
-void efx_init_napi_channel(struct efx_channel *channel);
-void efx_init_napi(struct efx_nic *efx);
-void efx_fini_napi_channel(struct efx_channel *channel);
-void efx_fini_napi(struct efx_nic *efx);
-
-void efx_channel_dummy_op_void(struct efx_channel *channel);
+extern unsigned int efx_siena_interrupt_mode;
+extern unsigned int efx_siena_rss_cpus;
+
+int efx_siena_probe_interrupts(struct efx_nic *efx);
+void efx_siena_remove_interrupts(struct efx_nic *efx);
+int efx_siena_enable_interrupts(struct efx_nic *efx);
+void efx_siena_disable_interrupts(struct efx_nic *efx);
+
+void efx_siena_set_interrupt_affinity(struct efx_nic *efx);
+void efx_siena_clear_interrupt_affinity(struct efx_nic *efx);
+
+void efx_siena_start_eventq(struct efx_channel *channel);
+void efx_siena_stop_eventq(struct efx_channel *channel);
+
+int efx_siena_realloc_channels(struct efx_nic *efx, u32 rxq_entries,
+			       u32 txq_entries);
+void efx_siena_set_channel_names(struct efx_nic *efx);
+int efx_siena_init_channels(struct efx_nic *efx);
+int efx_siena_probe_channels(struct efx_nic *efx);
+int efx_siena_set_channels(struct efx_nic *efx);
+void efx_siena_remove_channel(struct efx_channel *channel);
+void efx_siena_remove_channels(struct efx_nic *efx);
+void efx_siena_fini_channels(struct efx_nic *efx);
+void efx_siena_start_channels(struct efx_nic *efx);
+void efx_siena_stop_channels(struct efx_nic *efx);
+
+void efx_siena_init_napi(struct efx_nic *efx);
+void efx_siena_fini_napi(struct efx_nic *efx);
+
+void efx_siena_channel_dummy_op_void(struct efx_channel *channel);
 
 #endif
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 2f53bb9446d6..fb6fb345cc56 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -432,7 +432,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 	efx->txq_wake_thresh = efx->txq_stop_thresh / 2;
 
 	/* Initialise the channels */
-	efx_start_channels(efx);
+	efx_siena_start_channels(efx);
 
 	efx_ptp_start_datapath(efx);
 
@@ -447,7 +447,7 @@ static void efx_stop_datapath(struct efx_nic *efx)
 
 	efx_ptp_stop_datapath(efx);
 
-	efx_stop_channels(efx);
+	efx_siena_stop_channels(efx);
 }
 
 /**************************************************************************
@@ -713,7 +713,7 @@ void efx_siena_reset_down(struct efx_nic *efx, enum reset_type method)
 		efx->type->prepare_flr(efx);
 
 	efx_siena_stop_all(efx);
-	efx_disable_interrupts(efx);
+	efx_siena_disable_interrupts(efx);
 
 	mutex_lock(&efx->mac_lock);
 	down_write(&efx->filter_sem);
@@ -766,7 +766,7 @@ int efx_siena_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
 				  "could not restore PHY settings\n");
 	}
 
-	rc = efx_enable_interrupts(efx);
+	rc = efx_siena_enable_interrupts(efx);
 	if (rc)
 		goto fail;
 
@@ -1035,7 +1035,7 @@ int efx_siena_init_struct(struct efx_nic *efx,
 
 	efx->mem_bar = UINT_MAX;
 
-	rc = efx_init_channels(efx);
+	rc = efx_siena_init_channels(efx);
 	if (rc)
 		goto fail;
 
@@ -1061,7 +1061,7 @@ void efx_siena_fini_struct(struct efx_nic *efx)
 	kfree(efx->rps_hash_table);
 #endif
 
-	efx_fini_channels(efx);
+	efx_siena_fini_channels(efx);
 
 	kfree(efx->vpd_sn);
 
@@ -1225,7 +1225,7 @@ static pci_ers_result_t efx_io_error_detected(struct pci_dev *pdev,
 		efx_device_detach_sync(efx);
 
 		efx_siena_stop_all(efx);
-		efx_disable_interrupts(efx);
+		efx_siena_disable_interrupts(efx);
 
 		status = PCI_ERS_RESULT_NEED_RESET;
 	} else {
diff --git a/drivers/net/ethernet/sfc/siena/ethtool.c b/drivers/net/ethernet/sfc/siena/ethtool.c
index 8d59e95b4951..7aa621e97212 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool.c
@@ -198,7 +198,7 @@ efx_ethtool_set_ringparam(struct net_device *net_dev,
 			   "increasing TX queue size to minimum of %u\n",
 			   txq_entries);
 
-	return efx_realloc_channels(efx, ring->rx_pending, txq_entries);
+	return efx_siena_realloc_channels(efx, ring->rx_pending, txq_entries);
 }
 
 static void efx_ethtool_get_wol(struct net_device *net_dev,
diff --git a/drivers/net/ethernet/sfc/siena/farch.c b/drivers/net/ethernet/sfc/siena/farch.c
index 9fc5c6ebbfec..6ee6ca192a44 100644
--- a/drivers/net/ethernet/sfc/siena/farch.c
+++ b/drivers/net/ethernet/sfc/siena/farch.c
@@ -747,12 +747,13 @@ int efx_farch_fini_dmaq(struct efx_nic *efx)
  * completion events.  This means that efx->rxq_flush_outstanding remained at 4
  * after the FLR; also, efx->active_queues was non-zero (as no flush completion
  * events were received, and we didn't go through efx_check_tx_flush_complete())
- * If we don't fix this up, on the next call to efx_realloc_channels() we won't
- * flush any RX queues because efx->rxq_flush_outstanding is at the limit of 4
- * for batched flush requests; and the efx->active_queues gets messed up because
- * we keep incrementing for the newly initialised queues, but it never went to
- * zero previously.  Then we get a timeout every time we try to restart the
- * queues, as it doesn't go back to zero when we should be flushing the queues.
+ * If we don't fix this up, on the next call to efx_siena_realloc_channels() we
+ * won't flush any RX queues because efx->rxq_flush_outstanding is at the limit
+ * of 4 for batched flush requests; and the efx->active_queues gets messed up
+ * because we keep incrementing for the newly initialised queues, but it never
+ * went to zero previously.  Then we get a timeout every time we try to restart
+ * the queues, as it doesn't go back to zero when we should be flushing the
+ * queues.
  */
 void efx_farch_finish_flr(struct efx_nic *efx)
 {
diff --git a/drivers/net/ethernet/sfc/siena/selftest.c b/drivers/net/ethernet/sfc/siena/selftest.c
index 1985f5fc0a8f..7e24329bc005 100644
--- a/drivers/net/ethernet/sfc/siena/selftest.c
+++ b/drivers/net/ethernet/sfc/siena/selftest.c
@@ -58,14 +58,14 @@ static const char payload_msg[] =
 	"Hello world! This is an Efx loopback test in progress!";
 
 /* Interrupt mode names */
-static const unsigned int efx_interrupt_mode_max = EFX_INT_MODE_MAX;
-static const char *const efx_interrupt_mode_names[] = {
+static const unsigned int efx_siena_interrupt_mode_max = EFX_INT_MODE_MAX;
+static const char *const efx_siena_interrupt_mode_names[] = {
 	[EFX_INT_MODE_MSIX]   = "MSI-X",
 	[EFX_INT_MODE_MSI]    = "MSI",
 	[EFX_INT_MODE_LEGACY] = "legacy",
 };
 #define INT_MODE(efx) \
-	STRING_TABLE_LOOKUP(efx->interrupt_mode, efx_interrupt_mode)
+	STRING_TABLE_LOOKUP(efx->interrupt_mode, efx_siena_interrupt_mode)
 
 /**
  * struct efx_loopback_state - persistent state during a loopback selftest
@@ -197,7 +197,7 @@ static int efx_test_eventq_irq(struct efx_nic *efx,
 		schedule_timeout_uninterruptible(wait);
 
 		efx_for_each_channel(channel, efx) {
-			efx_stop_eventq(channel);
+			efx_siena_stop_eventq(channel);
 			if (channel->eventq_read_ptr !=
 			    read_ptr[channel->channel]) {
 				set_bit(channel->channel, &napi_ran);
@@ -209,7 +209,7 @@ static int efx_test_eventq_irq(struct efx_nic *efx,
 				if (efx_nic_event_test_irq_cpu(channel) >= 0)
 					clear_bit(channel->channel, &int_pend);
 			}
-			efx_start_eventq(channel);
+			efx_siena_start_eventq(channel);
 		}
 
 		wait *= 2;
diff --git a/drivers/net/ethernet/sfc/siena/siena_sriov.c b/drivers/net/ethernet/sfc/siena/siena_sriov.c
index f12851a527d9..1020b72e1c68 100644
--- a/drivers/net/ethernet/sfc/siena/siena_sriov.c
+++ b/drivers/net/ethernet/sfc/siena/siena_sriov.c
@@ -1043,7 +1043,7 @@ efx_siena_sriov_get_channel_name(struct efx_channel *channel,
 static const struct efx_channel_type efx_siena_sriov_channel_type = {
 	.handle_no_channel	= efx_siena_sriov_handle_no_channel,
 	.pre_probe		= efx_siena_sriov_probe_channel,
-	.post_remove		= efx_channel_dummy_op_void,
+	.post_remove		= efx_siena_channel_dummy_op_void,
 	.get_name		= efx_siena_sriov_get_channel_name,
 	/* no copy operation; channel must not be reallocated */
 	.keep_eventq		= true,

