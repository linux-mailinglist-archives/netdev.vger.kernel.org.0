Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D2525AD49
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 16:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgIBOgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 10:36:55 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:56702 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726285AbgIBOgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 10:36:44 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 54E0B60155;
        Wed,  2 Sep 2020 14:36:44 +0000 (UTC)
Received: from us4-mdac16-21.ut7.mdlocal (unknown [10.7.65.245])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B0F9F800B4;
        Wed,  2 Sep 2020 14:36:43 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.175])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2DB8E2800A7;
        Wed,  2 Sep 2020 14:36:42 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 678817000AC;
        Wed,  2 Sep 2020 14:36:42 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep 2020
 15:36:26 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 2/5] sfc: use tx_queue->old_read_count in EF100 TX
 path
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <d3c81ab7-6d2e-326f-e25e-e42095ce9e66@solarflare.com>
Message-ID: <6c1deaca-102d-40bb-5ffe-9507f01a8788@solarflare.com>
Date:   Wed, 2 Sep 2020 15:36:22 +0100
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
X-TM-AS-Result: No-4.229900-8.000000-10
X-TMASE-MatchedRID: B4VcMIpPJ800hZmSa+ztRMzSKGx9g8xheouvej40T4gd0WOKRkwsh1ym
        Rv3NQjsE4aBLis6ititw5T4Iaj538mJZXQNDzktSMiMrbc70Pfdc1jwHBugxQIxRWJphhsrcrzM
        i7F2pFcpny03aprSl5E4r6tWjD8M+YAgEin+2ERDiHyvyXeXh5sHWhOU1PTVYNCjbDif9OIzSJJ
        cbp1Y+W8Q1xvPMAvfZDvP/tkcd5GOMQmg2+WN4O095wQijrwBLfS0Ip2eEHny+qryzYw2E8Jkw8
        KdMzN86KrauXd3MZDUYmhvFbntAL6TRb8tZ3yWI26UtHqFTik1hKMIvwkzgVs1EcebW768Tg5qe
        iqlH6shWa9YJ+3+CBf2iSrkndGlHB+RsQUnQHf3jCHw9x1eKskODDY5/BuEsoxrk6Q2mIeSJ+wv
        7oJjhGclmajRS8yWxQwymtxuJ6y0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.229900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25640.003
X-MDID: 1599057403-2gRDV7kY_GZZ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As in the Siena/EF10 case, it minimises cacheline ping-pong between
 the TX and completion paths.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_tx.c   |  8 ++++++--
 drivers/net/ethernet/sfc/net_driver.h | 14 ++++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index a09546e43408..47d67b1e379b 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -359,15 +359,19 @@ int ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 		goto err;
 	ef100_tx_make_descriptors(tx_queue, skb, segments);
 
-	fill_level = efx_channel_tx_fill_level(tx_queue->channel);
+	fill_level = efx_channel_tx_old_fill_level(tx_queue->channel);
 	if (fill_level > efx->txq_stop_thresh) {
+		struct efx_tx_queue *txq2;
+
 		netif_tx_stop_queue(tx_queue->core_txq);
 		/* Re-read after a memory barrier in case we've raced with
 		 * the completion path. Otherwise there's a danger we'll never
 		 * restart the queue if all completions have just happened.
 		 */
 		smp_mb();
-		fill_level = efx_channel_tx_fill_level(tx_queue->channel);
+		efx_for_each_channel_tx_queue(txq2, tx_queue->channel)
+			txq2->old_read_count = READ_ONCE(txq2->read_count);
+		fill_level = efx_channel_tx_old_fill_level(tx_queue->channel);
 		if (fill_level < efx->txq_stop_thresh)
 			netif_tx_start_queue(tx_queue->core_txq);
 	}
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 338ebb0402be..2358d35bffb5 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1692,6 +1692,20 @@ efx_channel_tx_fill_level(struct efx_channel *channel)
 	return fill_level;
 }
 
+/* Conservative approximation of efx_channel_tx_fill_level using cached value */
+static inline unsigned int
+efx_channel_tx_old_fill_level(struct efx_channel *channel)
+{
+	struct efx_tx_queue *tx_queue;
+	unsigned int fill_level = 0;
+
+	efx_for_each_channel_tx_queue(tx_queue, channel)
+		fill_level = max(fill_level,
+				 tx_queue->insert_count - tx_queue->old_read_count);
+
+	return fill_level;
+}
+
 /* Get all supported features.
  * If a feature is not fixed, it is present in hw_features.
  * If a feature is fixed, it does not present in hw_features, but

