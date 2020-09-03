Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACF825CC57
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgICVe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:34:27 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:54430 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726323AbgICVe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:34:26 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B78E2600A4;
        Thu,  3 Sep 2020 21:34:25 +0000 (UTC)
Received: from us4-mdac16-66.ut7.mdlocal (unknown [10.7.64.78])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B696F8009E;
        Thu,  3 Sep 2020 21:34:25 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.33])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3B16C80068;
        Thu,  3 Sep 2020 21:34:25 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C8057A80083;
        Thu,  3 Sep 2020 21:34:24 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep 2020
 22:34:19 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 1/6] sfc: add and use efx_tx_send_pending in tx.c
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <02b2bb5a-f360-68cb-3c13-b72ced1ecd7b@solarflare.com>
Message-ID: <28858994-b9b8-4eaf-6cdf-6c8a795d3dce@solarflare.com>
Date:   Thu, 3 Sep 2020 22:34:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <02b2bb5a-f360-68cb-3c13-b72ced1ecd7b@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25642.007
X-TM-AS-Result: No-6.607800-8.000000-10
X-TMASE-MatchedRID: eeuAzniZeKD6mS2x8PRvpsZkWeHTuv2uAKbvziCwm7hCwV2XZkTdFlk/
        EVZFlSou4xcmXNXi1XgK9eDbwbqQJtpsFVyqUNwXuwdUMMznEA/Uk/02d006RR1rVWTdGrE4cij
        MZrr2iZ2t2gtuWr1Lmtr+D80ZNbcyJxdeG1t7y2ZlpwNsTvdlKT39vrXxKlsdkueVLa3gC5Inui
        +WQ9elLauJWV8kfA540NbMX/xarLkQNpMbgEWrDfSG/+sPtZVku8ZgmQ167rXDra5IbmQvVk1zo
        9VwQLtweKAgXV2D5LYpW5WIjBhq2OuGtoxRdOqKamOGWbsSIFcr9gVlOIN/6uLsQIDmr3S5LLer
        TDWsZma3nYtm781u4xdbug1FfrKlqMLr8w1TE6gjCTunWqnclgeCHewokHM/e7ijHq7g9oadNC2
        51TPFyocIrST8bc6RqJMxjqDCkeejJwaIeQ4C0Ge0F1HB9i2hqnabhLgnhmi9K1jOJyKSa+cpBb
        gC4g5britgqDn1kA4/nPI684Cn3vOomksYZmRqngIgpj8eDcC063Wh9WVqgtZE3xJMmmXc+gtHj
        7OwNO2FR9Hau8GO7jlEhB5R1/Gwn3mRT3w18SWimm5S/ztBsD7sEzbZSSwDqyZ+8hfPBZfAvpLE
        +mvX8g==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.607800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25642.007
X-MDID: 1599168865-xvRnrpf5fNKv
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using efx_tx_queue_partner(), which relies on the assumption
 that tx_queues_per_channel is 2, efx_tx_send_pending() iterates over
 txqs with efx_for_each_channel_tx_queue().
We unconditionally set tx_queue->xmit_pending (renamed from
 xmit_more_available), then condition on xmit_more for the call to
 efx_tx_send_pending(), which will clear xmit_pending.  Thus, after an
 xmit_more TX, the doorbell is un-rung and xmit_pending is true.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c       |  2 +-
 drivers/net/ethernet/sfc/ef100_tx.c   | 14 +++----
 drivers/net/ethernet/sfc/farch.c      |  2 +-
 drivers/net/ethernet/sfc/net_driver.h |  4 +-
 drivers/net/ethernet/sfc/tx.c         | 59 ++++++++++++++-------------
 drivers/net/ethernet/sfc/tx_common.c  |  4 +-
 6 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 0b4bcac53f18..316e14533e9d 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2367,7 +2367,7 @@ static void efx_ef10_tx_write(struct efx_tx_queue *tx_queue)
 	unsigned int write_ptr;
 	efx_qword_t *txd;
 
-	tx_queue->xmit_more_available = false;
+	tx_queue->xmit_pending = false;
 	if (unlikely(tx_queue->write_count == tx_queue->insert_count))
 		return;
 
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index a09546e43408..8d478c5e720e 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -131,7 +131,7 @@ void ef100_notify_tx_desc(struct efx_tx_queue *tx_queue)
 	efx_writed_page(tx_queue->efx, &reg,
 			ER_GZ_TX_RING_DOORBELL, tx_queue->queue);
 	tx_queue->notify_count = tx_queue->write_count;
-	tx_queue->xmit_more_available = false;
+	tx_queue->xmit_pending = false;
 }
 
 static void ef100_tx_push_buffers(struct efx_tx_queue *tx_queue)
@@ -373,14 +373,14 @@ int ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 	}
 
 	if (__netdev_tx_sent_queue(tx_queue->core_txq, skb->len, xmit_more))
-		tx_queue->xmit_more_available = false; /* push doorbell */
+		tx_queue->xmit_pending = false; /* push doorbell */
 	else if (tx_queue->write_count - tx_queue->notify_count > 255)
 		/* Ensure we never push more than 256 packets at once */
-		tx_queue->xmit_more_available = false; /* push */
+		tx_queue->xmit_pending = false; /* push */
 	else
-		tx_queue->xmit_more_available = true; /* don't push yet */
+		tx_queue->xmit_pending = true; /* don't push yet */
 
-	if (!tx_queue->xmit_more_available)
+	if (!tx_queue->xmit_pending)
 		ef100_tx_push_buffers(tx_queue);
 
 	if (segments) {
@@ -400,9 +400,9 @@ int ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 	/* If we're not expecting another transmit and we had something to push
 	 * on this queue then we need to push here to get the previous packets
 	 * out.  We only enter this branch from before the 'Update BQL' section
-	 * above, so xmit_more_available still refers to the old state.
+	 * above, so xmit_pending still refers to the old state.
 	 */
-	if (tx_queue->xmit_more_available && !xmit_more)
+	if (tx_queue->xmit_pending && !xmit_more)
 		ef100_tx_push_buffers(tx_queue);
 	return rc;
 }
diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index 0d9795fb9356..b6f67a0cc882 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -320,7 +320,7 @@ void efx_farch_tx_write(struct efx_tx_queue *tx_queue)
 	unsigned write_ptr;
 	unsigned old_write_count = tx_queue->write_count;
 
-	tx_queue->xmit_more_available = false;
+	tx_queue->xmit_pending = false;
 	if (unlikely(tx_queue->write_count == tx_queue->insert_count))
 		return;
 
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 338ebb0402be..adc138f9d15f 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -244,7 +244,7 @@ struct efx_tx_buffer {
  * @tso_fallbacks: Number of times TSO fallback used
  * @pushes: Number of times the TX push feature has been used
  * @pio_packets: Number of times the TX PIO feature has been used
- * @xmit_more_available: Are any packets waiting to be pushed to the NIC
+ * @xmit_pending: Are any packets waiting to be pushed to the NIC
  * @cb_packets: Number of times the TX copybreak feature has been used
  * @notify_count: Count of notified descriptors to the NIC
  * @empty_read_count: If the completion path has seen the queue as empty
@@ -292,7 +292,7 @@ struct efx_tx_queue {
 	unsigned int tso_fallbacks;
 	unsigned int pushes;
 	unsigned int pio_packets;
-	bool xmit_more_available;
+	bool xmit_pending;
 	unsigned int cb_packets;
 	unsigned int notify_count;
 	/* Statistics to supplement MAC stats */
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 727201d5eb24..c502d226371a 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -268,6 +268,19 @@ static int efx_enqueue_skb_pio(struct efx_tx_queue *tx_queue,
 }
 #endif /* EFX_USE_PIO */
 
+/* Send any pending traffic for a channel. xmit_more is shared across all
+ * queues for a channel, so we must check all of them.
+ */
+static void efx_tx_send_pending(struct efx_channel *channel)
+{
+	struct efx_tx_queue *q;
+
+	efx_for_each_channel_tx_queue(q, channel) {
+		if (q->xmit_pending)
+			efx_nic_push_buffers(q);
+	}
+}
+
 /*
  * Add a socket buffer to a TX queue
  *
@@ -336,21 +349,11 @@ netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb
 
 	efx_tx_maybe_stop_queue(tx_queue);
 
-	/* Pass off to hardware */
-	if (__netdev_tx_sent_queue(tx_queue->core_txq, skb_len, xmit_more)) {
-		struct efx_tx_queue *txq2 = efx_tx_queue_partner(tx_queue);
-
-		/* There could be packets left on the partner queue if
-		 * xmit_more was set. If we do not push those they
-		 * could be left for a long time and cause a netdev watchdog.
-		 */
-		if (txq2->xmit_more_available)
-			efx_nic_push_buffers(txq2);
+	tx_queue->xmit_pending = true;
 
-		efx_nic_push_buffers(tx_queue);
-	} else {
-		tx_queue->xmit_more_available = xmit_more;
-	}
+	/* Pass off to hardware */
+	if (__netdev_tx_sent_queue(tx_queue->core_txq, skb_len, xmit_more))
+		efx_tx_send_pending(tx_queue->channel);
 
 	if (segments) {
 		tx_queue->tso_bursts++;
@@ -371,14 +374,8 @@ netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb
 	 * on this queue or a partner queue then we need to push here to get the
 	 * previous packets out.
 	 */
-	if (!xmit_more) {
-		struct efx_tx_queue *txq2 = efx_tx_queue_partner(tx_queue);
-
-		if (txq2->xmit_more_available)
-			efx_nic_push_buffers(txq2);
-
-		efx_nic_push_buffers(tx_queue);
-	}
+	if (!xmit_more)
+		efx_tx_send_pending(tx_queue->channel);
 
 	return NETDEV_TX_OK;
 }
@@ -489,18 +486,24 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 
 	EFX_WARN_ON_PARANOID(!netif_device_present(net_dev));
 
-	/* PTP "event" packet */
-	if (unlikely(efx_xmit_with_hwtstamp(skb)) &&
-	    unlikely(efx_ptp_is_ptp_tx(efx, skb))) {
-		return efx_ptp_tx(efx, skb);
-	}
-
 	index = skb_get_queue_mapping(skb);
 	type = skb->ip_summed == CHECKSUM_PARTIAL ? EFX_TXQ_TYPE_OFFLOAD : 0;
 	if (index >= efx->n_tx_channels) {
 		index -= efx->n_tx_channels;
 		type |= EFX_TXQ_TYPE_HIGHPRI;
 	}
+
+	/* PTP "event" packet */
+	if (unlikely(efx_xmit_with_hwtstamp(skb)) &&
+	    unlikely(efx_ptp_is_ptp_tx(efx, skb))) {
+		/* There may be existing transmits on the channel that are
+		 * waiting for this packet to trigger the doorbell write.
+		 * We need to send the packets at this point.
+		 */
+		efx_tx_send_pending(efx_get_tx_channel(efx, index));
+		return efx_ptp_tx(efx, skb);
+	}
+
 	tx_queue = efx_get_tx_queue(efx, index, type);
 
 	return __efx_enqueue_skb(tx_queue, skb);
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 793e234819a8..187d5c379a37 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -78,7 +78,7 @@ void efx_init_tx_queue(struct efx_tx_queue *tx_queue)
 	tx_queue->read_count = 0;
 	tx_queue->old_read_count = 0;
 	tx_queue->empty_read_count = 0 | EFX_EMPTY_COUNT_VALID;
-	tx_queue->xmit_more_available = false;
+	tx_queue->xmit_pending = false;
 	tx_queue->timestamping = (efx_ptp_use_mac_tx_timestamps(efx) &&
 				  tx_queue->channel == efx_ptp_channel(efx));
 	tx_queue->completed_timestamp_major = 0;
@@ -116,7 +116,7 @@ void efx_fini_tx_queue(struct efx_tx_queue *tx_queue)
 
 		++tx_queue->read_count;
 	}
-	tx_queue->xmit_more_available = false;
+	tx_queue->xmit_pending = false;
 	netdev_tx_reset_queue(tx_queue->core_txq);
 }
 

