Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8B0520FEB
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238202AbiEJItR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 04:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238203AbiEJItP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 04:49:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4133C2A3778
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652172312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Fmj5zsMWUjo4ZEcl7lSpNPy9bf2T7j+Knl6kLajk+k=;
        b=SM9aeLj87jZFgOHeT/5lAbfoM2NC2/lVNyJXO7zP4FEkI5iCEH+Ofy8Ljib1qkKa72oRP/
        t6xiw+bwuXfKWMLZ/qJcfHH7kUqjxmJhnARDv9V4+IZ0TDIYe3eo96CDMK8uotOdyPuVsk
        RL6ODWW2y+LEPf7egR40mwqjAmRv0vI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-a-use5GQNhK5KDmEkg21mA-1; Tue, 10 May 2022 04:45:07 -0400
X-MC-Unique: a-use5GQNhK5KDmEkg21mA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FC2A3C11A03;
        Tue, 10 May 2022 08:45:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D513F413721;
        Tue, 10 May 2022 08:45:04 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        ap420073@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next 5/5] sfc: move tx_channel_offset calculation to interrupts probe
Date:   Tue, 10 May 2022 10:44:43 +0200
Message-Id: <20220510084443.14473-6-ihuguet@redhat.com>
In-Reply-To: <20220510084443.14473-1-ihuguet@redhat.com>
References: <20220510084443.14473-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All parameters related to what channels are used for RX, TX and/or XDP
are calculated in efx_probe_interrupts or its called function
efx_allocate_msix_channels.

tx_channel_offset was recalculated needlessly in efx_set_queues. Remove
this from here since it's more coherent to calculate it only once, in
the same place than the rest of channels parameters. If MSIX is not used,
this value was not set in efx_probe_interrupts, so let's do it now.

The value calculated in efx_set_queues was wrong anyway, because with
the addition of the support for XDP, additional channels had been added
after the TX channels, and efx->n_channels - efx->n_tx_channels didn't
point to the beginning of the TX channels any more.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index f6634faa1ec4..b9bbef07bb5e 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -220,14 +220,9 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 	n_channels -= efx->n_xdp_channels;
 
 	if (efx_separate_tx_channels) {
-		efx->n_tx_channels =
-			min(max(n_channels / 2, 1U),
-			    efx->max_tx_channels);
-		efx->tx_channel_offset =
-			n_channels - efx->n_tx_channels;
-		efx->n_rx_channels =
-			max(n_channels -
-			    efx->n_tx_channels, 1U);
+		efx->n_tx_channels = min(max(n_channels / 2, 1U), efx->max_tx_channels);
+		efx->tx_channel_offset = n_channels - efx->n_tx_channels;
+		efx->n_rx_channels = max(n_channels - efx->n_tx_channels, 1U);
 	} else {
 		efx->n_tx_channels = min(n_channels, efx->max_tx_channels);
 		efx->tx_channel_offset = 0;
@@ -303,6 +298,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1;
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
+		efx->tx_channel_offset = 0;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		rc = pci_enable_msi(efx->pci_dev);
@@ -323,6 +319,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1 + (efx_separate_tx_channels ? 1 : 0);
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
+		efx->tx_channel_offset = 1;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		efx->legacy_irq = efx->pci_dev->irq;
@@ -952,10 +949,6 @@ int efx_set_queues(struct efx_nic *efx)
 	unsigned int queue_num = 0;
 	int rc;
 
-	efx->tx_channel_offset =
-		efx_separate_tx_channels ?
-		efx->n_channels - efx->n_tx_channels : 0;
-
 	/* We need to mark which channels really have RX and TX queues, and
 	 * adjust the TX queue numbers if we have separate RX/TX only channels.
 	 */
-- 
2.34.1

