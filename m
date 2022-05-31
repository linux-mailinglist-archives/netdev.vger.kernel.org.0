Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB8C5391F3
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 15:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244215AbiEaNli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 09:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbiEaNlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 09:41:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75E2E51305
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 06:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654004494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KF/b/a26jlJnictKCbpYP24z2GEMrbXRw67L/GMdAoc=;
        b=fZo2w9ywn3yB7D6uxd4M0mYbQbxkerEVI9jZ6/Runz7tVt/s3qLcWwzyJSD0vCoHXfEFzq
        cKQIiZbDu0QtekKLATZ9ze2mVsLvlwF4vE/fDggeD0nb6yGuNNvCsh8TMKXBfOvIL3080r
        jdkSRbAGOYR99Gu7ng2GSRpMqk2QBnU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-ZYPeKXaCP2i_SlaX26ur1Q-1; Tue, 31 May 2022 09:40:46 -0400
X-MC-Unique: ZYPeKXaCP2i_SlaX26ur1Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2251D803D5B;
        Tue, 31 May 2022 13:40:45 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.195.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AE4040885A1;
        Tue, 31 May 2022 13:40:42 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, cmclachlan@solarflare.com, brouer@redhat.com,
        netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Tianhao Zhao <tizhao@redhat.com>
Subject: [PATCH net 2/2] sfc/siena: fix wrong tx channel offset with efx_separate_tx_channels
Date:   Tue, 31 May 2022 15:40:34 +0200
Message-Id: <20220531134034.389792-3-ihuguet@redhat.com>
In-Reply-To: <20220531134034.389792-1-ihuguet@redhat.com>
References: <20220531134034.389792-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tx_channel_offset is calculated in efx_allocate_msix_channels, but it is
also calculated again in efx_set_channels because it was originally done
there, and when efx_allocate_msix_channels was introduced it was
forgotten to be removed from efx_set_channels.

Moreover, the old calculation is wrong when using
efx_separate_tx_channels because now we can have XDP channels after the
TX channels, so n_channels - n_tx_channels doesn't point to the first TX
channel.

Remove the old calculation from efx_set_channels, and add the
initialization of this variable if MSI or legacy interrupts are used,
next to the initialization of the rest of the related variables, where
it was missing.

This has been already done for sfc, do it also for sfc_siena.

Fixes: 3990a8fffbda ("sfc: allocate channels for XDP tx queues")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
index f4919e7ee77b..032b8c0bd788 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.c
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
@@ -298,6 +298,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1;
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
+		efx->tx_channel_offset = 0;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		rc = pci_enable_msi(efx->pci_dev);
@@ -318,6 +319,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1 + (efx_separate_tx_channels ? 1 : 0);
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
+		efx->tx_channel_offset = 1;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		efx->legacy_irq = efx->pci_dev->irq;
@@ -954,10 +956,6 @@ int efx_set_channels(struct efx_nic *efx)
 	struct efx_channel *channel;
 	int rc;
 
-	efx->tx_channel_offset =
-		efx_siena_separate_tx_channels ?
-		efx->n_channels - efx->n_tx_channels : 0;
-
 	if (efx->xdp_tx_queue_count) {
 		EFX_WARN_ON_PARANOID(efx->xdp_tx_queues);
 
-- 
2.34.1

