Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F574BC467
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 02:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240927AbiBSA5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:57:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240839AbiBSA4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:56:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A22C22819B4
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645232160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=26cyHpnSpm698G+iZsPMivgAiB0L3AbE+uqfVDX3Hc4=;
        b=UyAo3PXqNHnEj/TeFr6NTziMuTj0LFfDwhA1R3fbgZoZb0OJ10rMIdd/9VKX0+BjiuFz80
        hcV3Tyg6aGUxhctqB4wL/zBxdbEwjC11YuhoDlBjWEoKsJz8TZIR1W7Dffc4HlEamZfhme
        2KtxrESwboG/FP32Wdu9fyQXO7v2wvw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-8McBCT1aN72Ggigosg1PgQ-1; Fri, 18 Feb 2022 19:55:54 -0500
X-MC-Unique: 8McBCT1aN72Ggigosg1PgQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E13D9801AA6;
        Sat, 19 Feb 2022 00:55:51 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-39.pek2.redhat.com [10.72.12.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1725462D58;
        Sat, 19 Feb 2022 00:55:18 +0000 (UTC)
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
Subject: [PATCH 14/22] spi: spi-ti-qspi: Don't use GFP_DMA when calling dma_alloc_coherent()
Date:   Sat, 19 Feb 2022 08:52:13 +0800
Message-Id: <20220219005221.634-15-bhe@redhat.com>
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
 drivers/spi/spi-ti-qspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-ti-qspi.c b/drivers/spi/spi-ti-qspi.c
index e06aafe169e0..6c4a76a7a4b3 100644
--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -867,7 +867,7 @@ static int ti_qspi_probe(struct platform_device *pdev)
 	qspi->rx_bb_addr = dma_alloc_coherent(qspi->dev,
 					      QSPI_DMA_BUFFER_SIZE,
 					      &qspi->rx_bb_dma_addr,
-					      GFP_KERNEL | GFP_DMA);
+					      GFP_KERNEL);
 	if (!qspi->rx_bb_addr) {
 		dev_err(qspi->dev,
 			"dma_alloc_coherent failed, using PIO mode\n");
-- 
2.17.2

