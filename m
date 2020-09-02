Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E372325AD46
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 16:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgIBOgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 10:36:19 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:51398 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726618AbgIBOgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 10:36:11 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 71B2B6009C;
        Wed,  2 Sep 2020 14:36:10 +0000 (UTC)
Received: from us4-mdac16-17.ut7.mdlocal (unknown [10.7.65.241])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6F6DB2009A;
        Wed,  2 Sep 2020 14:36:10 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.174])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F1B8F1C0054;
        Wed,  2 Sep 2020 14:36:09 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id ABF5B1C0080;
        Wed,  2 Sep 2020 14:36:09 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep 2020
 15:36:04 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 1/5] sfc: add and use efx_tx_send_pending in tx.c
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <d3c81ab7-6d2e-326f-e25e-e42095ce9e66@solarflare.com>
Message-ID: <1edd44e5-a73a-149f-fe0c-96969627d211@solarflare.com>
Date:   Wed, 2 Sep 2020 15:35:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d3c81ab7-6d2e-326f-e25e-e42095ce9e66@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25640.003
X-TM-AS-Result: No-3.555900-8.000000-10
X-TMASE-MatchedRID: 7k7c1meM2Cj6mS2x8PRvpsZkWeHTuv2uAKbvziCwm7j2u2oLJUFmGMiT
        Wug2C4DNl1M7KT9/aqAnsasxq4/76mJZXQNDzktSGjzBgnFZvQ4TcSAXT4xW4LJlZWzEYNxAbnj
        BcAybL/ynQFe+ESmb0wbYbps2GRg0V3LZOzkjrY+iAZ3zAhQYggeCHewokHM/e7ijHq7g9oadNC
        251TPFyrxzOVuPy6ov5GzdUnKKAE5WmVSbj8vwrNUcSZdVkdtz+LljbN4c70MTLunq7JxcvUFhN
        Q5NCwwg0d9L2XyFbWnUPEKgrYXxxo9oUcx9VMLgOX/V8P8ail1yZ8zcONpAscRB0bsfrpPIqxB3
        2o9eGckrmQHTr2S7jieB9cuRcVaonvPRL2YHViS8+X6w8/WcVlbjK6gV4EVIg3CLcpYSGvmnWRG
        wVBanyVBxQmiUr9slxlOi1Fh8+TXpsag+4i8C+Hzm6hivSaZZop2lf3StGhISt1bcvKF7ZNkrC8
        mOIB+LwL6SxPpr1/I=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.555900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25640.003
X-MDID: 1599057370-n0UwdVncKUAo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using efx_tx_queue_partner(), which relies on the assumption
 that tx_queues_per_channel is 2, efx_tx_send_pending() iterates over
 txqs with efx_for_each_channel_tx_queue().

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/tx.c | 59 ++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 727201d5eb24..71eb99db5439 100644
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
+		if (q->xmit_more_available)
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
+	tx_queue->xmit_more_available = true;
 
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

