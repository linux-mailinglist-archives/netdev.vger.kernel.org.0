Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBA24BC43E
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 02:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240772AbiBSA6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:58:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240780AbiBSA6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:58:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4650527B984
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645232244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=/uPDi55pRUcHbTO6mcPLVkug8AZozuHSmFt5BW/lQT4=;
        b=U09ZCGEb0xDqBmaKKAVlFjYas7jzY/EyDQQ65vNchEZxmsFt3AZ6z1y7SSsDYN9p/3Ik1S
        x098dbRFNlfKFYYgNvXvz4Svs60VCIB4lHGosOOT1MdGTY38n0IBJhLvcCjUdLlLdgH8A6
        wPlJJK8HrsWmJ3n4itzWtORoqbqpbCs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-9PQUe-MNMqyEq0z_Q9Xzhw-1; Fri, 18 Feb 2022 19:57:21 -0500
X-MC-Unique: 9PQUe-MNMqyEq0z_Q9Xzhw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5848A801AA6;
        Sat, 19 Feb 2022 00:57:18 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-39.pek2.redhat.com [10.72.12.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90B3562D57;
        Sat, 19 Feb 2022 00:57:04 +0000 (UTC)
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
Subject: [PATCH 21/22] mmc: wbsd: Use dma_alloc_noncoherent() for dma buffer
Date:   Sat, 19 Feb 2022 08:52:20 +0800
Message-Id: <20220219005221.634-22-bhe@redhat.com>
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

Use dma_alloc_noncoherent() instead to get the DMA buffer.

[ 42.hyeyoo@gmail.com: Only keep label free.

  Remove unnecessary alignment checks. it's guaranteed by DMA API.
  Just use GFP_KERNEL as it's called in sleepable context.

  Specify its dma capability using  dma_set_mask_and_coherent() ]

Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org
---
 drivers/mmc/host/wbsd.c | 45 +++++++++--------------------------------
 1 file changed, 9 insertions(+), 36 deletions(-)

diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 67ecd342fe5f..50b0197583c7 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1366,55 +1366,28 @@ static void wbsd_request_dma(struct wbsd_host *host, int dma)
 	if (request_dma(dma, DRIVER_NAME))
 		goto err;
 
+	dma_set_mask_and_coherent(mmc_dev(host->mmc), DMA_BIT_MASK(24));
+
 	/*
 	 * We need to allocate a special buffer in
 	 * order for ISA to be able to DMA to it.
 	 */
-	host->dma_buffer = kmalloc(WBSD_DMA_SIZE,
-		GFP_NOIO | GFP_DMA | __GFP_RETRY_MAYFAIL | __GFP_NOWARN);
+	host->dma_buffer = dma_alloc_noncoherent(mmc_dev(host->mmc),
+					WBSD_DMA_SIZE, &host->dma_addr,
+					DMA_BIDIRECTIONAL,
+					GFP_KERNEL);
 	if (!host->dma_buffer)
 		goto free;
 
-	/*
-	 * Translate the address to a physical address.
-	 */
-	host->dma_addr = dma_map_single(mmc_dev(host->mmc), host->dma_buffer,
-		WBSD_DMA_SIZE, DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(mmc_dev(host->mmc), host->dma_addr))
-		goto kfree;
-
-	/*
-	 * ISA DMA must be aligned on a 64k basis.
-	 */
-	if ((host->dma_addr & 0xffff) != 0)
-		goto unmap;
-	/*
-	 * ISA cannot access memory above 16 MB.
-	 */
-	else if (host->dma_addr >= 0x1000000)
-		goto unmap;
-
 	host->dma = dma;
 
 	return;
 
-unmap:
-	/*
-	 * If we've gotten here then there is some kind of alignment bug
-	 */
-	BUG_ON(1);
-
-	dma_unmap_single(mmc_dev(host->mmc), host->dma_addr,
-		WBSD_DMA_SIZE, DMA_BIDIRECTIONAL);
-	host->dma_addr = 0;
-
-kfree:
-	kfree(host->dma_buffer);
-	host->dma_buffer = NULL;
-
 free:
+	dma_free_noncoherent(mmc_dev(host->mmc), WBSD_DMA_SIZE, host->dma_buffer,
+			     host->dma_addr, DMA_BIDIRECTIONAL);
+	host->dma_buffer = NULL;
 	free_dma(dma);
-
 err:
 	pr_warn(DRIVER_NAME ": Unable to allocate DMA %d - falling back on FIFO\n",
 		dma);
-- 
2.17.2

