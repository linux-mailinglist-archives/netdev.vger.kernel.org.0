Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122CD25AD52
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 16:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgIBOhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 10:37:37 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:37170 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728073AbgIBOhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 10:37:21 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2742D600E2;
        Wed,  2 Sep 2020 14:37:21 +0000 (UTC)
Received: from us4-mdac16-53.ut7.mdlocal (unknown [10.7.66.24])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 24ADE2009B;
        Wed,  2 Sep 2020 14:37:21 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.40])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9EA77220068;
        Wed,  2 Sep 2020 14:37:20 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 576F0BC0068;
        Wed,  2 Sep 2020 14:37:20 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep 2020
 15:37:01 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 3/5] sfc: use efx_channel_tx_[old_]fill_level() in
 Siena/EF10 TX datapath
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <d3c81ab7-6d2e-326f-e25e-e42095ce9e66@solarflare.com>
Message-ID: <727d78d7-aa74-1920-a5fa-796881afb923@solarflare.com>
Date:   Wed, 2 Sep 2020 15:36:46 +0100
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
X-TM-AS-Result: No-6.967300-8.000000-10
X-TMASE-MatchedRID: oOTqEOEfBbscAZrHLi86M8ZkWeHTuv2uAKbvziCwm7jBSouFRjh0Andd
        uDm7lgGn8XVI39JCRnSjfNAVYAJRAr+Q0YdVmuyWnFVnNmvv47tLXPA26IG0hN9RlPzeVuQQ8b1
        mXTqetmzERx+bb7v/+VLil+9DIcvM1x7q6N2snafHmyDJSEsI2z39vrXxKlsd1l38M6aWfEgU45
        rKCfVRMXChf2aWJ/fe1rs6dM2A4+ROi++CZQcQcodlc1JaOB1TD6NL4tGmXzXc9j0JdwtdWaPFj
        JEFr+olA9Mriq0CDAg9wJeM2pSaRd934/rDAK3zUpXqgxV1N6nTkz4ESBI6DHBM7r9Rch7Ub3mg
        1ALZ3OlGCULcizy/4b72rZBe1NOXftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.967300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25640.003
X-MDID: 1599057441-6ICPZX4MDH2E
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of open-coding the calculation with efx_tx_queue_partner(), use
 the functions that iterate over numbers of queues other than 2 with
 efx_for_each_channel_tx_queue().

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/net_driver.h |  4 ----
 drivers/net/ethernet/sfc/tx.c         | 14 ++++++--------
 drivers/net/ethernet/sfc/tx_common.c  |  5 +----
 3 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 2358d35bffb5..08c4858fc604 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1681,10 +1681,6 @@ efx_channel_tx_fill_level(struct efx_channel *channel)
 	struct efx_tx_queue *tx_queue;
 	unsigned int fill_level = 0;
 
-	/* This function is currently only used by EF100, which maybe
-	 * could do something simpler and just compute the fill level
-	 * of the single TXQ that's really in use.
-	 */
 	efx_for_each_channel_tx_queue(tx_queue, channel)
 		fill_level = max(fill_level,
 				 tx_queue->insert_count - tx_queue->read_count);
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 71eb99db5439..713b129f9b83 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -59,13 +59,12 @@ u8 *efx_tx_get_copy_buffer_limited(struct efx_tx_queue *tx_queue,
 
 static void efx_tx_maybe_stop_queue(struct efx_tx_queue *txq1)
 {
-	/* We need to consider both queues that the net core sees as one */
-	struct efx_tx_queue *txq2 = efx_tx_queue_partner(txq1);
+	/* We need to consider all queues that the net core sees as one */
 	struct efx_nic *efx = txq1->efx;
+	struct efx_tx_queue *txq2;
 	unsigned int fill_level;
 
-	fill_level = max(txq1->insert_count - txq1->old_read_count,
-			 txq2->insert_count - txq2->old_read_count);
+	fill_level = efx_channel_tx_old_fill_level(txq1->channel);
 	if (likely(fill_level < efx->txq_stop_thresh))
 		return;
 
@@ -85,11 +84,10 @@ static void efx_tx_maybe_stop_queue(struct efx_tx_queue *txq1)
 	 */
 	netif_tx_stop_queue(txq1->core_txq);
 	smp_mb();
-	txq1->old_read_count = READ_ONCE(txq1->read_count);
-	txq2->old_read_count = READ_ONCE(txq2->read_count);
+	efx_for_each_channel_tx_queue(txq2, txq1->channel)
+		txq2->old_read_count = READ_ONCE(txq2->read_count);
 
-	fill_level = max(txq1->insert_count - txq1->old_read_count,
-			 txq2->insert_count - txq2->old_read_count);
+	fill_level = efx_channel_tx_old_fill_level(txq1->channel);
 	EFX_WARN_ON_ONCE_PARANOID(fill_level >= efx->txq_entries);
 	if (likely(fill_level < efx->txq_stop_thresh)) {
 		smp_mb();
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 793e234819a8..02f7c772d261 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -242,7 +242,6 @@ void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
 {
 	unsigned int fill_level, pkts_compl = 0, bytes_compl = 0;
 	struct efx_nic *efx = tx_queue->efx;
-	struct efx_tx_queue *txq2;
 
 	EFX_WARN_ON_ONCE_PARANOID(index > tx_queue->ptr_mask);
 
@@ -261,9 +260,7 @@ void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
 	if (unlikely(netif_tx_queue_stopped(tx_queue->core_txq)) &&
 	    likely(efx->port_enabled) &&
 	    likely(netif_device_present(efx->net_dev))) {
-		txq2 = efx_tx_queue_partner(tx_queue);
-		fill_level = max(tx_queue->insert_count - tx_queue->read_count,
-				 txq2->insert_count - txq2->read_count);
+		fill_level = efx_channel_tx_fill_level(tx_queue->channel);
 		if (fill_level <= efx->txq_wake_thresh)
 			netif_tx_wake_queue(tx_queue->core_txq);
 	}

