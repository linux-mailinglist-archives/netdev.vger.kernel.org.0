Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCCF539D4A
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 08:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349919AbiFAGg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 02:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349913AbiFAGgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 02:36:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B7AB28D693
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 23:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654065379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vzn3II9luuYbFGtUWmW5IG8OrwUIx8mvBtoG2PI2yU8=;
        b=YTWy8lUm2m8TmQ9V7fIOT6b9HDWm/LmtjpfOLA/0Ysk6pjZg7bNu44JM0nU3evKw1oDPIN
        K5a4wAiauw1hdBRDC2r0dq0gugAFrVSnqZySzFV1ARIs7PPpBdqwDALf1ZWKgtkkWt3VNo
        NquUHNC8z8hrHeVXwVgFhsN41bYvXtg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-DU39BN_ANreplYrTL7qQlg-1; Wed, 01 Jun 2022 02:36:17 -0400
X-MC-Unique: DU39BN_ANreplYrTL7qQlg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 300FE18E5313;
        Wed,  1 Jun 2022 06:36:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27377492C3B;
        Wed,  1 Jun 2022 06:36:15 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, cmclachlan@solarflare.com, brouer@redhat.com,
        netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Tianhao Zhao <tizhao@redhat.com>
Subject: [PATCH net v2 2/2] sfc/siena: fix wrong tx channel offset with efx_separate_tx_channels
Date:   Wed,  1 Jun 2022 08:36:03 +0200
Message-Id: <20220601063603.15362-3-ihuguet@redhat.com>
In-Reply-To: <20220601063603.15362-1-ihuguet@redhat.com>
References: <20220531134034.389792-1-ihuguet@redhat.com>
 <20220601063603.15362-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
 drivers/net/ethernet/sfc/siena/efx_channels.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
index 2465cf4d505c..017212a40df3 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.c
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
@@ -299,6 +299,7 @@ int efx_siena_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1;
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
+		efx->tx_channel_offset = 0;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		rc = pci_enable_msi(efx->pci_dev);
@@ -319,6 +320,7 @@ int efx_siena_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1 + (efx_siena_separate_tx_channels ? 1 : 0);
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
+		efx->tx_channel_offset = 1;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		efx->legacy_irq = efx->pci_dev->irq;
@@ -958,10 +960,6 @@ int efx_siena_set_channels(struct efx_nic *efx)
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

