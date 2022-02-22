Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908084BF99C
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbiBVNmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbiBVNmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:42:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 146B18B6F9
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 05:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645537313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yMzIBslOmEwLm1+JPMEGfd0LnE8itJitz00d+JQMTH0=;
        b=Bj1UDYqFCl5TxAe0dUyCLGQGUGQyLmRTFoZ8b4rd1rU/rZNzrdNlDh4UgW//pdqKm8aMmL
        HXp128uE9mcxkGK0XLxDxoUDLHbc3050hU6GeNs6SR0369Z97/XKpCdPS/abA8HE3fmKiU
        zPMSjo3rHlBbirLkZnPzSDKEAVDtBC0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-FAtRKxoTPCSI4BkRN1m69A-1; Tue, 22 Feb 2022 08:41:50 -0500
X-MC-Unique: FAtRKxoTPCSI4BkRN1m69A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED30A1006AA5;
        Tue, 22 Feb 2022 13:41:46 +0000 (UTC)
Received: from localhost (ovpn-12-122.pek2.redhat.com [10.72.12.122])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 145E96FAFE;
        Tue, 22 Feb 2022 13:41:46 +0000 (UTC)
Date:   Tue, 22 Feb 2022 21:41:43 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, cl@linux.com, 42.hyeyoo@gmail.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        vbabka@suse.cz, David.Laight@aculab.com, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: [PATCH 1/2] dma-mapping: check dma_mask for streaming mapping allocs
Message-ID: <YhToFzlSufrliUsi@MiWiFi-R3L-srv>
References: <20220219005221.634-1-bhe@redhat.com>
 <20220219005221.634-22-bhe@redhat.com>
 <20220219071730.GG26711@lst.de>
 <20220220084044.GC93179@MiWiFi-R3L-srv>
 <20220222084530.GA6210@lst.de>
 <YhSpaGfiQV8Nmxr+@MiWiFi-R3L-srv>
 <20220222131120.GB10093@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222131120.GB10093@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For newly added streaming mapping APIs, the internal core function
__dma_alloc_pages() should check dev->dma_mask, but not
ev->coherent_dma_mask which is for coherent mapping.

Meanwhile, just filter out gfp flags if they are any of
__GFP_DMA, __GFP_DMA32 and __GFP_HIGHMEM, but not fail it. This change
makes it  consistent with coherent mapping allocs.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 kernel/dma/mapping.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 9478eccd1c8e..e66847aeac67 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -543,10 +543,11 @@ static struct page *__dma_alloc_pages(struct device *dev, size_t size,
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
-	if (WARN_ON_ONCE(!dev->coherent_dma_mask))
-		return NULL;
-	if (WARN_ON_ONCE(gfp & (__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM)))
-		return NULL;
+	if (WARN_ON_ONCE(!dev->dma_mask))
+                return NULL;
+
+	/* let the implementation decide on the zone to allocate from: */
+        gfp &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM);
 
 	size = PAGE_ALIGN(size);
 	if (dma_alloc_direct(dev, ops))
-- 
2.31.1

