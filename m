Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16AF20B072
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgFZL2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:28:47 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:54688 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728507AbgFZL2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:28:47 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2A17F20054;
        Fri, 26 Jun 2020 11:28:46 +0000 (UTC)
Received: from us4-mdac16-75.at1.mdlocal (unknown [10.110.50.193])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 286D86009B;
        Fri, 26 Jun 2020 11:28:46 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.103])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B880022004D;
        Fri, 26 Jun 2020 11:28:45 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 81F1B980066;
        Fri, 26 Jun 2020 11:28:45 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 12:28:40 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 04/15] sfc: don't try to create more channels than we
 can have VIs
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <1a1716f9-f909-4093-8107-3c2435d834c5@solarflare.com>
Message-ID: <22d5e57d-94b0-cb7f-3e64-2848f3ae498e@solarflare.com>
Date:   Fri, 26 Jun 2020 12:28:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1a1716f9-f909-4093-8107-3c2435d834c5@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25504.003
X-TM-AS-Result: No-0.979600-8.000000-10
X-TMASE-MatchedRID: f7KopCu05GL1Vo7bzQFJmcebIMlISwjb+kAbwAcaQfEhNSb1tn2Gvdno
        quRwHY3Bq0tSd83RkY26sghyELan/KH2g9syPs888Kg68su2wyFWBIFOJdPznFOitEi5p2m0cij
        MZrr2iZ2t2gtuWr1Lmtr+D80ZNbcyX1pUqhSEdY7W4Mz461fsHACm784gsJu49rtqCyVBZhiklr
        f/qUIG98ygz/0VjAwgVqqmN8PuBb/m6Kwuq5YazDIjK23O9D33Oq7WO79QiacIxs8bpapULKPFj
        JEFr+olA9Mriq0CDAg9wJeM2pSaRSrJhLSjJRVmfDE1ENiZhEM3P1RywRNzk0ZhSErnOy7YOmPP
        koSMMED8EIez1Zp6jmvzKNRnIA4sQSBAIRZUSEEcqNg+372buKPgCixeKjc2McKpXuu/1jVAMwW
        4rY/0WO2hZq8RbsdETdnyMokJ1HRyBhhCd0s8856oP1a0mRIj
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.979600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25504.003
X-MDID: 1593170926-jvRrN5L0-aun
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calculate efx->max_vis at probe time, and check against it in
 efx_allocate_msix_channels() when considering whether to create XDP TX
 channels.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c         | 18 ++++++++++++++----
 drivers/net/ethernet/sfc/efx_channels.c |  7 +++++++
 drivers/net/ethernet/sfc/net_driver.h   |  1 +
 drivers/net/ethernet/sfc/siena.c        |  1 +
 4 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 4b0e3695a71a..c99fedb315fe 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -601,10 +601,14 @@ static int efx_ef10_probe(struct efx_nic *efx)
 	 * However, until we use TX option descriptors we need two TX queues
 	 * per channel.
 	 */
-	efx->max_channels = min_t(unsigned int,
-				  EFX_MAX_CHANNELS,
-				  efx_ef10_mem_map_size(efx) /
-				  (efx->vi_stride * EFX_TXQ_TYPES));
+	efx->max_vis = efx_ef10_mem_map_size(efx) / efx->vi_stride;
+	if (!efx->max_vis) {
+		netif_err(efx, drv, efx->net_dev, "error determining max VIs\n");
+		rc = -EIO;
+		goto fail5;
+	}
+	efx->max_channels = min_t(unsigned int, EFX_MAX_CHANNELS,
+				  efx->max_vis / EFX_TXQ_TYPES);
 	efx->max_tx_channels = efx->max_channels;
 	if (WARN_ON(efx->max_channels == 0)) {
 		rc = -EIO;
@@ -1129,6 +1133,12 @@ static int efx_ef10_dimension_resources(struct efx_nic *efx)
 			  ((efx->n_tx_channels + efx->n_extra_tx_channels) *
 			   EFX_TXQ_TYPES) +
 			   efx->n_xdp_channels * efx->xdp_tx_per_channel);
+	if (efx->max_vis && efx->max_vis < channel_vis) {
+		netif_dbg(efx, drv, efx->net_dev,
+			  "Reducing channel VIs from %u to %u\n",
+			  channel_vis, efx->max_vis);
+		channel_vis = efx->max_vis;
+	}
 
 #ifdef EFX_USE_PIO
 	/* Try to allocate PIO buffers if wanted and if the full
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index c492523b986c..2c3510b0524a 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -175,6 +175,13 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 		efx->n_xdp_channels = 0;
 		efx->xdp_tx_per_channel = 0;
 		efx->xdp_tx_queue_count = 0;
+	} else if (n_channels + n_xdp_tx > efx->max_vis) {
+		netif_err(efx, drv, efx->net_dev,
+			  "Insufficient resources for %d XDP TX queues (%d other channels, max VIs %d)\n",
+			  n_xdp_tx, n_channels, efx->max_vis);
+		efx->n_xdp_channels = 0;
+		efx->xdp_tx_per_channel = 0;
+		efx->xdp_tx_queue_count = 0;
 	} else {
 		efx->n_xdp_channels = n_xdp_ev;
 		efx->xdp_tx_per_channel = EFX_TXQ_TYPES;
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 1afb58feb9ab..7bc4d1cbb398 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1022,6 +1022,7 @@ struct efx_nic {
 	unsigned next_buffer_table;
 
 	unsigned int max_channels;
+	unsigned int max_vis;
 	unsigned int max_tx_channels;
 	unsigned n_channels;
 	unsigned n_rx_channels;
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index 891e9fb6abec..6462bbe2448a 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -276,6 +276,7 @@ static int siena_probe_nic(struct efx_nic *efx)
 	}
 
 	efx->max_channels = EFX_MAX_CHANNELS;
+	efx->max_vis = EFX_MAX_CHANNELS;
 	efx->max_tx_channels = EFX_MAX_CHANNELS;
 
 	efx_reado(efx, &reg, FR_AZ_CS_DEBUG);

