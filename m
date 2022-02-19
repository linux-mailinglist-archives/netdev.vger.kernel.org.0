Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773574BC3CB
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 01:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240553AbiBSAx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:53:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240555AbiBSAx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:53:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1B0F279939
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645231988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=4eBpIp3xNf3Z3MhpRo9fDF4+jM3Uhq696cCINmzzUGw=;
        b=La3RalOPFHtyNqX0sC0SXCBamUZfkBoCpdZgyE79GnTOTzr6gWuNPrKg0Q2r6RJsFlwIHF
        629CbcepF+IIJZjPzBW4kKJBIYrdIWiRmJSkKxwPMdS2wDqWWlweaB6h6xSN2kW7e7QsUZ
        5pFncQZh3/3FB2vZrufIAjPdHYQGDkM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-SBz-l_hRPqC3JCneYaqqow-1; Fri, 18 Feb 2022 19:53:05 -0500
X-MC-Unique: SBz-l_hRPqC3JCneYaqqow-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 093B31091DA0;
        Sat, 19 Feb 2022 00:53:02 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-39.pek2.redhat.com [10.72.12.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0852B62D4E;
        Sat, 19 Feb 2022 00:52:48 +0000 (UTC)
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
Subject: [PATCH 02/22] net: moxa: Don't use GFP_DMA when calling dma_alloc_coherent()
Date:   Sat, 19 Feb 2022 08:52:01 +0800
Message-Id: <20220219005221.634-3-bhe@redhat.com>
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

From: Hyeonggon Yoo <42.hyeyoo@gmail.com>

dma_alloc_coherent() allocates dma buffer with device's addressing
limitation in mind. It's redundent to specify GFP_DMA when calling
dma_alloc_coherent().

Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 15179b9529e1..8fc2c2e71c2d 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -495,7 +495,7 @@ static int moxart_mac_probe(struct platform_device *pdev)
 
 	priv->tx_desc_base = dma_alloc_coherent(&pdev->dev, TX_REG_DESC_SIZE *
 						TX_DESC_NUM, &priv->tx_base,
-						GFP_DMA | GFP_KERNEL);
+						GFP_KERNEL);
 	if (!priv->tx_desc_base) {
 		ret = -ENOMEM;
 		goto init_fail;
@@ -503,7 +503,7 @@ static int moxart_mac_probe(struct platform_device *pdev)
 
 	priv->rx_desc_base = dma_alloc_coherent(&pdev->dev, RX_REG_DESC_SIZE *
 						RX_DESC_NUM, &priv->rx_base,
-						GFP_DMA | GFP_KERNEL);
+						GFP_KERNEL);
 	if (!priv->rx_desc_base) {
 		ret = -ENOMEM;
 		goto init_fail;
-- 
2.17.2

