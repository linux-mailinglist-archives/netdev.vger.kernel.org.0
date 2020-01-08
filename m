Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E887134766
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbgAHQNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:13:38 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:58794 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729406AbgAHQNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:13:37 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DF75580078;
        Wed,  8 Jan 2020 16:13:35 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 Jan 2020 16:13:31 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 12/14] sfc: move event queue management code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Message-ID: <d131e337-a3a4-f2be-fe09-ffb8f62c5a37@solarflare.com>
Date:   Wed, 8 Jan 2020 16:13:28 +0000
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
X-TM-AS-Result: No-7.531100-8.000000-10
X-TMASE-MatchedRID: lfGdq6L8jcOh9oPbMj7PPPCoOvLLtsMhqnabhLgnhmgGmHr1eMxt2UAc
        6DyoS2rIj6kCfX0Edc6tL1mMSnuv12ZRsKzcNsjWPja3w1ExF8RvV3/OnMClWkoPLn6eZ90+i9w
        qKeXPJfXcduZrEPeRqdowwOiDsiJWn6xXepMP3Wfuykw7cfAoIA73P4/aDCIF4PRrWDwT3UuE4T
        brDWha8jcCzqGyq+hi61qs6S/TXDJBJacAbR6CMSAI8aJmq0jwD6NL4tGmXzXVRHSWcoxJBlP/r
        SiKhsFs073azePq4H3VsBNB+zMi6reKX67VygxzUyxW4vmvLt3rixWWWJYrH01+zyfzlN7yvaMR
        kAFPKY3dB/CxWTRRu9bFCwAgdKkSLTVYpafbAHNCwLCn2X5pJcil2t6QcD01/i4jTPuQoJ1roGl
        XXM+AgJRMZUCEHkRt
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.531100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578500017-NLUqgDUMg_D1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c          | 92 -------------------------
 drivers/net/ethernet/sfc/efx_channels.c | 91 ++++++++++++++++++++++++
 2 files changed, 91 insertions(+), 92 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 8ac299373ee5..4bce5c739974 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -128,98 +128,6 @@ static int efx_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **xdpfs,
 			ASSERT_RTNL();			\
 	} while (0)
 
-/**************************************************************************
- *
- * Event queue processing
- *
- *************************************************************************/
-
-/* Create event queue
- * Event queue memory allocations are done only once.  If the channel
- * is reset, the memory buffer will be reused; this guards against
- * errors during channel reset and also simplifies interrupt handling.
- */
-int efx_probe_eventq(struct efx_channel *channel)
-{
-	struct efx_nic *efx = channel->efx;
-	unsigned long entries;
-
-	netif_dbg(efx, probe, efx->net_dev,
-		  "chan %d create event queue\n", channel->channel);
-
-	/* Build an event queue with room for one event per tx and rx buffer,
-	 * plus some extra for link state events and MCDI completions. */
-	entries = roundup_pow_of_two(efx->rxq_entries + efx->txq_entries + 128);
-	EFX_WARN_ON_PARANOID(entries > EFX_MAX_EVQ_SIZE);
-	channel->eventq_mask = max(entries, EFX_MIN_EVQ_SIZE) - 1;
-
-	return efx_nic_probe_eventq(channel);
-}
-
-/* Prepare channel's event queue */
-int efx_init_eventq(struct efx_channel *channel)
-{
-	struct efx_nic *efx = channel->efx;
-	int rc;
-
-	EFX_WARN_ON_PARANOID(channel->eventq_init);
-
-	netif_dbg(efx, drv, efx->net_dev,
-		  "chan %d init event queue\n", channel->channel);
-
-	rc = efx_nic_init_eventq(channel);
-	if (rc == 0) {
-		efx->type->push_irq_moderation(channel);
-		channel->eventq_read_ptr = 0;
-		channel->eventq_init = true;
-	}
-	return rc;
-}
-
-/* Enable event queue processing and NAPI */
-void efx_start_eventq(struct efx_channel *channel)
-{
-	netif_dbg(channel->efx, ifup, channel->efx->net_dev,
-		  "chan %d start event queue\n", channel->channel);
-
-	/* Make sure the NAPI handler sees the enabled flag set */
-	channel->enabled = true;
-	smp_wmb();
-
-	napi_enable(&channel->napi_str);
-	efx_nic_eventq_read_ack(channel);
-}
-
-/* Disable event queue processing and NAPI */
-void efx_stop_eventq(struct efx_channel *channel)
-{
-	if (!channel->enabled)
-		return;
-
-	napi_disable(&channel->napi_str);
-	channel->enabled = false;
-}
-
-void efx_fini_eventq(struct efx_channel *channel)
-{
-	if (!channel->eventq_init)
-		return;
-
-	netif_dbg(channel->efx, drv, channel->efx->net_dev,
-		  "chan %d fini event queue\n", channel->channel);
-
-	efx_nic_fini_eventq(channel);
-	channel->eventq_init = false;
-}
-
-void efx_remove_eventq(struct efx_channel *channel)
-{
-	netif_dbg(channel->efx, drv, channel->efx->net_dev,
-		  "chan %d remove event queue\n", channel->channel);
-
-	efx_nic_remove_eventq(channel);
-}
-
 /**************************************************************************
  *
  * Channel handling
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 65006af28210..21bd71daf5a0 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -388,6 +388,97 @@ void efx_remove_interrupts(struct efx_nic *efx)
 	efx->legacy_irq = 0;
 }
 
+/***************
+ * EVENT QUEUES
+ ***************/
+
+/* Create event queue
+ * Event queue memory allocations are done only once.  If the channel
+ * is reset, the memory buffer will be reused; this guards against
+ * errors during channel reset and also simplifies interrupt handling.
+ */
+int efx_probe_eventq(struct efx_channel *channel)
+{
+	struct efx_nic *efx = channel->efx;
+	unsigned long entries;
+
+	netif_dbg(efx, probe, efx->net_dev,
+		  "chan %d create event queue\n", channel->channel);
+
+	/* Build an event queue with room for one event per tx and rx buffer,
+	 * plus some extra for link state events and MCDI completions.
+	 */
+	entries = roundup_pow_of_two(efx->rxq_entries + efx->txq_entries + 128);
+	EFX_WARN_ON_PARANOID(entries > EFX_MAX_EVQ_SIZE);
+	channel->eventq_mask = max(entries, EFX_MIN_EVQ_SIZE) - 1;
+
+	return efx_nic_probe_eventq(channel);
+}
+
+/* Prepare channel's event queue */
+int efx_init_eventq(struct efx_channel *channel)
+{
+	struct efx_nic *efx = channel->efx;
+	int rc;
+
+	EFX_WARN_ON_PARANOID(channel->eventq_init);
+
+	netif_dbg(efx, drv, efx->net_dev,
+		  "chan %d init event queue\n", channel->channel);
+
+	rc = efx_nic_init_eventq(channel);
+	if (rc == 0) {
+		efx->type->push_irq_moderation(channel);
+		channel->eventq_read_ptr = 0;
+		channel->eventq_init = true;
+	}
+	return rc;
+}
+
+/* Enable event queue processing and NAPI */
+void efx_start_eventq(struct efx_channel *channel)
+{
+	netif_dbg(channel->efx, ifup, channel->efx->net_dev,
+		  "chan %d start event queue\n", channel->channel);
+
+	/* Make sure the NAPI handler sees the enabled flag set */
+	channel->enabled = true;
+	smp_wmb();
+
+	napi_enable(&channel->napi_str);
+	efx_nic_eventq_read_ack(channel);
+}
+
+/* Disable event queue processing and NAPI */
+void efx_stop_eventq(struct efx_channel *channel)
+{
+	if (!channel->enabled)
+		return;
+
+	napi_disable(&channel->napi_str);
+	channel->enabled = false;
+}
+
+void efx_fini_eventq(struct efx_channel *channel)
+{
+	if (!channel->eventq_init)
+		return;
+
+	netif_dbg(channel->efx, drv, channel->efx->net_dev,
+		  "chan %d fini event queue\n", channel->channel);
+
+	efx_nic_fini_eventq(channel);
+	channel->eventq_init = false;
+}
+
+void efx_remove_eventq(struct efx_channel *channel)
+{
+	netif_dbg(channel->efx, drv, channel->efx->net_dev,
+		  "chan %d remove event queue\n", channel->channel);
+
+	efx_nic_remove_eventq(channel);
+}
+
 /**************************************************************************
  *
  * Channel handling
-- 
2.20.1


