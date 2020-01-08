Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B984134751
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgAHQMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:12:47 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:50832 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726186AbgAHQMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:12:46 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D72F64C0089;
        Wed,  8 Jan 2020 16:12:44 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 Jan 2020 16:12:37 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 09/14] sfc: move channel start/stop code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Message-ID: <cac04a2f-2412-6b2a-901c-070d4445368f@solarflare.com>
Date:   Wed, 8 Jan 2020 16:12:34 +0000
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
X-TM-AS-Result: No-2.546100-8.000000-10
X-TMASE-MatchedRID: jT9P5y0g8a4a2WR+3qSRhRouoVvF2i0ZAf1C358hdK9jLp8Cm8vwFwoe
        RRhCZWIBNAOocBQj98a6M1wBej8T3SHhSBQfglfsA9lly13c/gHnaaW2UTafyDQ881NaGbKnmS4
        YK5QOxoeh+5TQMTvxqOaY4xzH9gkeHL8Nny3PUIs+NrfDUTEXxJKLNrbpy/A0SMg2Oe/b8EztWS
        lUMT+KYq1dsnE60qldZGD4LO/vDAwB5jDL4tJv0xIRh9wkXSlFRwDU669267wRxZBQI0dbZ/q6o
        Zn8ant9mHFkUzeY31wGV/SQcQ9ni4eBgdpbkPh8sFSKfGPIprUTyBlrYQQNzaRea8wUAdQ6wQiQ
        3MWIPEvF5T46BHstYun9F1eeSv2pSCk2aRMRMZy2FZ3uVRBKVcoioCrSMgeKJX3t9Sm95f+I670
        cXedtNtpTvcHSSI8FU0Qk439E9DPAb0/TWUXFZeLzNWBegCW2XC3N7C7YzreNo+PRbWqfRMprJP
        8FBOIa3t33ETLZnc7hbO5SPEObmoT1yIjhg9R0OFxAHIIt2OuRLl1/mW2gs4wJY6PW8EqcElpii
        z2kfJvZpX3mrzri0zZPHVPAbSqyUHdwKGmJRotDgw2OfwbhLKMa5OkNpiHkifsL+6CY4RlXTTnZ
        wS8L+UMMprcbiest
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-2.546100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578499965-MOinipyo4c_E
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also includes interrupt enabling/disabling code.
Small code styling fixes included.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c          | 119 ---------------
 drivers/net/ethernet/sfc/efx_channels.c | 190 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_common.c   |  69 ---------
 3 files changed, 190 insertions(+), 188 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 530185636afd..8c1cf4cb9c14 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1086,125 +1086,6 @@ void efx_clear_interrupt_affinity(struct efx_nic *efx __attribute__ ((unused)))
 }
 #endif /* CONFIG_SMP */
 
-int efx_soft_enable_interrupts(struct efx_nic *efx)
-{
-	struct efx_channel *channel, *end_channel;
-	int rc;
-
-	BUG_ON(efx->state == STATE_DISABLED);
-
-	efx->irq_soft_enabled = true;
-	smp_wmb();
-
-	efx_for_each_channel(channel, efx) {
-		if (!channel->type->keep_eventq) {
-			rc = efx_init_eventq(channel);
-			if (rc)
-				goto fail;
-		}
-		efx_start_eventq(channel);
-	}
-
-	efx_mcdi_mode_event(efx);
-
-	return 0;
-fail:
-	end_channel = channel;
-	efx_for_each_channel(channel, efx) {
-		if (channel == end_channel)
-			break;
-		efx_stop_eventq(channel);
-		if (!channel->type->keep_eventq)
-			efx_fini_eventq(channel);
-	}
-
-	return rc;
-}
-
-void efx_soft_disable_interrupts(struct efx_nic *efx)
-{
-	struct efx_channel *channel;
-
-	if (efx->state == STATE_DISABLED)
-		return;
-
-	efx_mcdi_mode_poll(efx);
-
-	efx->irq_soft_enabled = false;
-	smp_wmb();
-
-	if (efx->legacy_irq)
-		synchronize_irq(efx->legacy_irq);
-
-	efx_for_each_channel(channel, efx) {
-		if (channel->irq)
-			synchronize_irq(channel->irq);
-
-		efx_stop_eventq(channel);
-		if (!channel->type->keep_eventq)
-			efx_fini_eventq(channel);
-	}
-
-	/* Flush the asynchronous MCDI request queue */
-	efx_mcdi_flush_async(efx);
-}
-
-int efx_enable_interrupts(struct efx_nic *efx)
-{
-	struct efx_channel *channel, *end_channel;
-	int rc;
-
-	BUG_ON(efx->state == STATE_DISABLED);
-
-	if (efx->eeh_disabled_legacy_irq) {
-		enable_irq(efx->legacy_irq);
-		efx->eeh_disabled_legacy_irq = false;
-	}
-
-	efx->type->irq_enable_master(efx);
-
-	efx_for_each_channel(channel, efx) {
-		if (channel->type->keep_eventq) {
-			rc = efx_init_eventq(channel);
-			if (rc)
-				goto fail;
-		}
-	}
-
-	rc = efx_soft_enable_interrupts(efx);
-	if (rc)
-		goto fail;
-
-	return 0;
-
-fail:
-	end_channel = channel;
-	efx_for_each_channel(channel, efx) {
-		if (channel == end_channel)
-			break;
-		if (channel->type->keep_eventq)
-			efx_fini_eventq(channel);
-	}
-
-	efx->type->irq_disable_non_ev(efx);
-
-	return rc;
-}
-
-void efx_disable_interrupts(struct efx_nic *efx)
-{
-	struct efx_channel *channel;
-
-	efx_soft_disable_interrupts(efx);
-
-	efx_for_each_channel(channel, efx) {
-		if (channel->type->keep_eventq)
-			efx_fini_eventq(channel);
-	}
-
-	efx->type->irq_disable_non_ev(efx);
-}
-
 void efx_remove_interrupts(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index f288d13d4d09..e0d183bd0e78 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -33,6 +33,196 @@ MODULE_PARM_DESC(irq_adapt_high_thresh,
  */
 static int napi_weight = 64;
 
+/*************
+ * START/STOP
+ *************/
+
+int efx_soft_enable_interrupts(struct efx_nic *efx)
+{
+	struct efx_channel *channel, *end_channel;
+	int rc;
+
+	BUG_ON(efx->state == STATE_DISABLED);
+
+	efx->irq_soft_enabled = true;
+	smp_wmb();
+
+	efx_for_each_channel(channel, efx) {
+		if (!channel->type->keep_eventq) {
+			rc = efx_init_eventq(channel);
+			if (rc)
+				goto fail;
+		}
+		efx_start_eventq(channel);
+	}
+
+	efx_mcdi_mode_event(efx);
+
+	return 0;
+fail:
+	end_channel = channel;
+	efx_for_each_channel(channel, efx) {
+		if (channel == end_channel)
+			break;
+		efx_stop_eventq(channel);
+		if (!channel->type->keep_eventq)
+			efx_fini_eventq(channel);
+	}
+
+	return rc;
+}
+
+void efx_soft_disable_interrupts(struct efx_nic *efx)
+{
+	struct efx_channel *channel;
+
+	if (efx->state == STATE_DISABLED)
+		return;
+
+	efx_mcdi_mode_poll(efx);
+
+	efx->irq_soft_enabled = false;
+	smp_wmb();
+
+	if (efx->legacy_irq)
+		synchronize_irq(efx->legacy_irq);
+
+	efx_for_each_channel(channel, efx) {
+		if (channel->irq)
+			synchronize_irq(channel->irq);
+
+		efx_stop_eventq(channel);
+		if (!channel->type->keep_eventq)
+			efx_fini_eventq(channel);
+	}
+
+	/* Flush the asynchronous MCDI request queue */
+	efx_mcdi_flush_async(efx);
+}
+
+int efx_enable_interrupts(struct efx_nic *efx)
+{
+	struct efx_channel *channel, *end_channel;
+	int rc;
+
+	/* TODO: Is this really a bug? */
+	BUG_ON(efx->state == STATE_DISABLED);
+
+	if (efx->eeh_disabled_legacy_irq) {
+		enable_irq(efx->legacy_irq);
+		efx->eeh_disabled_legacy_irq = false;
+	}
+
+	efx->type->irq_enable_master(efx);
+
+	efx_for_each_channel(channel, efx) {
+		if (channel->type->keep_eventq) {
+			rc = efx_init_eventq(channel);
+			if (rc)
+				goto fail;
+		}
+	}
+
+	rc = efx_soft_enable_interrupts(efx);
+	if (rc)
+		goto fail;
+
+	return 0;
+
+fail:
+	end_channel = channel;
+	efx_for_each_channel(channel, efx) {
+		if (channel == end_channel)
+			break;
+		if (channel->type->keep_eventq)
+			efx_fini_eventq(channel);
+	}
+
+	efx->type->irq_disable_non_ev(efx);
+
+	return rc;
+}
+
+void efx_disable_interrupts(struct efx_nic *efx)
+{
+	struct efx_channel *channel;
+
+	efx_soft_disable_interrupts(efx);
+
+	efx_for_each_channel(channel, efx) {
+		if (channel->type->keep_eventq)
+			efx_fini_eventq(channel);
+	}
+
+	efx->type->irq_disable_non_ev(efx);
+}
+
+void efx_start_channels(struct efx_nic *efx)
+{
+	struct efx_tx_queue *tx_queue;
+	struct efx_rx_queue *rx_queue;
+	struct efx_channel *channel;
+
+	efx_for_each_channel(channel, efx) {
+		efx_for_each_channel_tx_queue(tx_queue, channel) {
+			efx_init_tx_queue(tx_queue);
+			atomic_inc(&efx->active_queues);
+		}
+
+		efx_for_each_channel_rx_queue(rx_queue, channel) {
+			efx_init_rx_queue(rx_queue);
+			atomic_inc(&efx->active_queues);
+			efx_stop_eventq(channel);
+			efx_fast_push_rx_descriptors(rx_queue, false);
+			efx_start_eventq(channel);
+		}
+
+		WARN_ON(channel->rx_pkt_n_frags);
+	}
+}
+
+void efx_stop_channels(struct efx_nic *efx)
+{
+	struct efx_tx_queue *tx_queue;
+	struct efx_rx_queue *rx_queue;
+	struct efx_channel *channel;
+	int rc;
+
+	/* Stop RX refill */
+	efx_for_each_channel(channel, efx) {
+		efx_for_each_channel_rx_queue(rx_queue, channel)
+			rx_queue->refill_enabled = false;
+	}
+
+	efx_for_each_channel(channel, efx) {
+		/* RX packet processing is pipelined, so wait for the
+		 * NAPI handler to complete.  At least event queue 0
+		 * might be kept active by non-data events, so don't
+		 * use napi_synchronize() but actually disable NAPI
+		 * temporarily.
+		 */
+		if (efx_channel_has_rx_queue(channel)) {
+			efx_stop_eventq(channel);
+			efx_start_eventq(channel);
+		}
+	}
+
+	rc = efx->type->fini_dmaq(efx);
+	if (rc) {
+		netif_err(efx, drv, efx->net_dev, "failed to flush queues\n");
+	} else {
+		netif_dbg(efx, drv, efx->net_dev,
+			  "successfully flushed all queues\n");
+	}
+
+	efx_for_each_channel(channel, efx) {
+		efx_for_each_channel_rx_queue(rx_queue, channel)
+			efx_fini_rx_queue(rx_queue);
+		efx_for_each_possible_channel_tx_queue(tx_queue, channel)
+			efx_fini_tx_queue(tx_queue);
+	}
+}
+
 /**************************************************************************
  *
  * NAPI interface
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index f1c487de3f04..d0fc51a108bf 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -238,30 +238,6 @@ void efx_start_monitor(struct efx_nic *efx)
  *
  *************************************************************************/
 
-void efx_start_channels(struct efx_nic *efx)
-{
-	struct efx_tx_queue *tx_queue;
-	struct efx_rx_queue *rx_queue;
-	struct efx_channel *channel;
-
-	efx_for_each_channel(channel, efx) {
-		efx_for_each_channel_tx_queue(tx_queue, channel) {
-			efx_init_tx_queue(tx_queue);
-			atomic_inc(&efx->active_queues);
-		}
-
-		efx_for_each_channel_rx_queue(rx_queue, channel) {
-			efx_init_rx_queue(rx_queue);
-			atomic_inc(&efx->active_queues);
-			efx_stop_eventq(channel);
-			efx_fast_push_rx_descriptors(rx_queue, false);
-			efx_start_eventq(channel);
-		}
-
-		WARN_ON(channel->rx_pkt_n_frags);
-	}
-}
-
 /* Channels are shutdown and reinitialised whilst the NIC is running
  * to propagate configuration changes (mtu, checksum offload), or
  * to clear hardware error conditions
@@ -342,51 +318,6 @@ static void efx_start_datapath(struct efx_nic *efx)
 		netif_tx_wake_all_queues(efx->net_dev);
 }
 
-void efx_stop_channels(struct efx_nic *efx)
-{
-	struct efx_tx_queue *tx_queue;
-	struct efx_rx_queue *rx_queue;
-	struct efx_channel *channel;
-	int rc = 0;
-
-	/* Stop RX refill */
-	efx_for_each_channel(channel, efx) {
-		efx_for_each_channel_rx_queue(rx_queue, channel)
-			rx_queue->refill_enabled = false;
-	}
-
-	efx_for_each_channel(channel, efx) {
-		/* RX packet processing is pipelined, so wait for the
-		 * NAPI handler to complete.  At least event queue 0
-		 * might be kept active by non-data events, so don't
-		 * use napi_synchronize() but actually disable NAPI
-		 * temporarily.
-		 */
-		if (efx_channel_has_rx_queue(channel)) {
-			efx_stop_eventq(channel);
-			efx_start_eventq(channel);
-		}
-	}
-
-	if (efx->type->fini_dmaq)
-		rc = efx->type->fini_dmaq(efx);
-
-	if (rc) {
-		netif_err(efx, drv, efx->net_dev, "failed to flush queues\n");
-	} else {
-		netif_dbg(efx, drv, efx->net_dev,
-			  "successfully flushed all queues\n");
-	}
-
-	efx_for_each_channel(channel, efx) {
-		efx_for_each_channel_rx_queue(rx_queue, channel)
-			efx_fini_rx_queue(rx_queue);
-		efx_for_each_possible_channel_tx_queue(tx_queue, channel)
-			efx_fini_tx_queue(tx_queue);
-	}
-	efx->xdp_rxq_info_failed = false;
-}
-
 static void efx_stop_datapath(struct efx_nic *efx)
 {
 	EFX_ASSERT_RESET_SERIALISED(efx);
-- 
2.20.1


