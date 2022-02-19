Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B45F4BC44F
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 02:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240866AbiBSA4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:56:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240869AbiBSAzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:55:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63DF427AFE4
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645232124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=DZGh4bIHBOmHOiALkgVaQHB6FPGaLxO56EvLhQh60X4=;
        b=Z12fQk4s/bSyJI6yHts5A5TNML9Sje2Ut/hKRx+05qk5L/EN9bLIqTMZ8pu/H2pp9qJJet
        cijPyg1wTOJl0HWjsE/08fnMCz7sZkNdpikVWdLkpWZu8S7v+Ehbp0BC6AqK5a/5Q5kQgN
        uojgFKHvOpSrU/AJiNkNo0PYteOqj6A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-b_nDA3aCMyKcIv_TXZ3MAg-1; Fri, 18 Feb 2022 19:55:21 -0500
X-MC-Unique: b_nDA3aCMyKcIv_TXZ3MAg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B4341006AA0;
        Sat, 19 Feb 2022 00:55:18 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-39.pek2.redhat.com [10.72.12.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7366162D56;
        Sat, 19 Feb 2022 00:55:09 +0000 (UTC)
From:   Baoquan He <bhe@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, 42.hyeyoo@gmail.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        David.Laight@ACULAB.COM, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: [PATCH 13/22] spi: atmel: Don't use GFP_DMA when calling dma_alloc_coherent()
Date:   Sat, 19 Feb 2022 08:52:12 +0800
Message-Id: <20220219005221.634-14-bhe@redhat.com>
In-Reply-To: <20220219005221.634-1-bhe@redhat.com>
References: <20220219005221.634-1-bhe@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dma_alloc_coherent() allocates dma buffer with device's addressing
limitation in mind. It's redundent to specify GFP_DMA when calling
dma_alloc_coherent().

[ 42.hyeyoo@gmail.com: Update changelog ]

Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 drivers/spi/spi-atmel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 9e300a932699..271dacf3b7d2 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1516,14 +1516,14 @@ static int atmel_spi_probe(struct platform_device *pdev)
 		as->addr_rx_bbuf = dma_alloc_coherent(&pdev->dev,
 						      SPI_MAX_DMA_XFER,
 						      &as->dma_addr_rx_bbuf,
-						      GFP_KERNEL | GFP_DMA);
+						      GFP_KERNEL);
 		if (!as->addr_rx_bbuf) {
 			as->use_dma = false;
 		} else {
 			as->addr_tx_bbuf = dma_alloc_coherent(&pdev->dev,
 					SPI_MAX_DMA_XFER,
 					&as->dma_addr_tx_bbuf,
-					GFP_KERNEL | GFP_DMA);
+					GFP_KERNEL);
 			if (!as->addr_tx_bbuf) {
 				as->use_dma = false;
 				dma_free_coherent(&pdev->dev, SPI_MAX_DMA_XFER,
-- 
2.17.2

