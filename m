Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD69523392
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242963AbiEKM76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242909AbiEKM74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:59:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 55F9C233A51
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 05:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652273994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Uzyphoone9dun6eWsNNqyVHjKSm0nir2+SJSWtq2h4=;
        b=VXmeTly51Yyvin79MhwwqvjwEYHyf2MCrlvaZJqI7qfgkxbr+8XreE47Sz2OfjAFoUF5Ah
        dHDKCD64kIllQLHpZMbyKMUnmd6vniCnCCTWffLXVSzXX4CeYqG/xGh4gW2L/MMu1XKPEd
        oL1lfwb+aFdAxEujqGR7p+WcaCOHvHo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-srr0Zu0oMTGIOn0oqwu-8Q-1; Wed, 11 May 2022 08:59:51 -0400
X-MC-Unique: srr0Zu0oMTGIOn0oqwu-8Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AED9680B91A;
        Wed, 11 May 2022 12:59:50 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33FBB438EE3;
        Wed, 11 May 2022 12:59:48 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        amaftei@solarflare.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Tianhao Zhao <tizhao@redhat.com>
Subject: [PATCH net 1/2] sfc: fix wrong tx channel offset with efx_separate_tx_channels
Date:   Wed, 11 May 2022 14:59:40 +0200
Message-Id: <20220511125941.55812-2-ihuguet@redhat.com>
In-Reply-To: <20220511125941.55812-1-ihuguet@redhat.com>
References: <20220511125941.55812-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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

Fixes: 3990a8fffbda ("sfc: allocate channels for XDP tx queues")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 40df910aa140..da2db6791907 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -241,14 +241,9 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
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
@@ -324,6 +319,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1;
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
+		efx->tx_channel_offset = 0;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		rc = pci_enable_msi(efx->pci_dev);
@@ -344,6 +340,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1 + (efx_separate_tx_channels ? 1 : 0);
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
+		efx->tx_channel_offset = 1;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		efx->legacy_irq = efx->pci_dev->irq;
@@ -979,10 +976,6 @@ int efx_set_channels(struct efx_nic *efx)
 	struct efx_channel *channel;
 	int rc;
 
-	efx->tx_channel_offset =
-		efx_separate_tx_channels ?
-		efx->n_channels - efx->n_tx_channels : 0;
-
 	if (efx->xdp_tx_queue_count) {
 		EFX_WARN_ON_PARANOID(efx->xdp_tx_queues);
 
-- 
2.34.1

