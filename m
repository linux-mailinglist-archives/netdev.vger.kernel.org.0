Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15215B9CC4
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 16:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiIOORa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 10:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiIOORT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 10:17:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CFE9D10D
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 07:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663251422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2lGGc487buovx7KKRP2aYPRI7QvR9cUJyxYPWnpfBJs=;
        b=UPHI9sgjXP0/tSOEST2if2imUVuOVQvu/g0j043+gACPGufPOg7Rf+78QRhOEyH8fxrsCz
        o5QQTW0yV+LJfFXxdqADUu+7HJkZF7iLkGNBeOyw6Ym2iOvRSRpOiNoCqAQLHNl2gPT0Pr
        z3F8Blab76YPm3OcxYl/CoKnRS/N/OQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-G7yTdk9wOxKpP7AwFq12GQ-1; Thu, 15 Sep 2022 10:16:57 -0400
X-MC-Unique: G7yTdk9wOxKpP7AwFq12GQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6A441C04B67;
        Thu, 15 Sep 2022 14:16:56 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.192.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A539492CA2;
        Thu, 15 Sep 2022 14:16:55 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Tianhao Zhao <tizhao@redhat.com>
Subject: [PATCH net] sfc/siena: fix TX channel offset when using legacy interrupts
Date:   Thu, 15 Sep 2022 16:16:53 +0200
Message-Id: <20220915141653.15504-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As in previous commit for sfc, fix TX channels offset when
efx_siena_separate_tx_channels is false (the default)

Fixes: 25bde571b4a8 ("sfc/siena: fix wrong tx channel offset with efx_separate_tx_channels")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/siena/efx_channels.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
index 017212a40df3..f54ebd007286 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.c
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
@@ -320,7 +320,7 @@ int efx_siena_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1 + (efx_siena_separate_tx_channels ? 1 : 0);
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
-		efx->tx_channel_offset = 1;
+		efx->tx_channel_offset = efx_siena_separate_tx_channels ? 1 : 0;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		efx->legacy_irq = efx->pci_dev->irq;
-- 
2.34.1

