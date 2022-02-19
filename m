Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040534BC43D
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 02:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbiBSA5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:57:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241038AbiBSA52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:57:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1FBCA2804DD
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645232204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=/y0XKs0dIaXiTJCDs4pP0SCRY3JMgE3839iRkTVhm8s=;
        b=B82Gyxmkfy2SqRdkCwxfRjN417yqk8pq9S5683KjeVPDnj/lxWTU6RA3tZF/0w5DE67T10
        l7jQauckz8xrj59yH96TCviTLeK6N+YUzuYTcWBKqI4/pMibX2C4LK9CTz3Z9M3NdwszOc
        VGtQwHKxV1LtQ49uW3qfbmEpteT5ZXo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-d1x5YKnqPheP2aWNdoPuLg-1; Fri, 18 Feb 2022 19:56:40 -0500
X-MC-Unique: d1x5YKnqPheP2aWNdoPuLg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E74E1006AA3;
        Sat, 19 Feb 2022 00:56:37 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-39.pek2.redhat.com [10.72.12.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E55B062D4E;
        Sat, 19 Feb 2022 00:56:28 +0000 (UTC)
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
Subject: [PATCH 18/22] net: ethernet: mtk-star-emac: Don't use GFP_DMA when calling dmam_alloc_coherent()
Date:   Sat, 19 Feb 2022 08:52:17 +0800
Message-Id: <20220219005221.634-19-bhe@redhat.com>
In-Reply-To: <20220219005221.634-1-bhe@redhat.com>
References: <20220219005221.634-1-bhe@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dmam_alloc_coherent() uses struct dma_devres to manage data, and call
dma_alloc_attrs() to allocate cohenrent DMA memory, so it's redundent
to specify GFP_DMA when calling.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 89ca7960b225..55b95f51ac75 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1533,7 +1533,7 @@ static int mtk_star_probe(struct platform_device *pdev)
 
 	priv->ring_base = dmam_alloc_coherent(dev, MTK_STAR_DMA_SIZE,
 					      &priv->dma_addr,
-					      GFP_KERNEL | GFP_DMA);
+					      GFP_KERNEL);
 	if (!priv->ring_base)
 		return -ENOMEM;
 
-- 
2.17.2

