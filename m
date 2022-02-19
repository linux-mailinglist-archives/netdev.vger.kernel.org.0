Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603BF4BC43B
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 02:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbiBSA6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:58:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240977AbiBSA5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:57:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF51C28BF5D
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645232218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=EELMh9yLzKq2YhWaWmX86e66jZD5FrMdWsd0v+UKIFQ=;
        b=SUMjYzcTLrTPEZDwLtdtcE8hyPi4rD3LI5WECT0lQFZRIWcqUngGXlBRY/jzN39LJye3Ap
        414ga08N6O17uAxkIIXslZ2QdhfxGf//Z4hIYCCbDEcIuQmucuoUg2D6WOqyeIJXz0mA3q
        clq+P0FbvQHvQccv6Xv1DNvDupZj6BY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-407jO7cuM6-rsOc9SkRHhg-1; Fri, 18 Feb 2022 19:56:55 -0500
X-MC-Unique: 407jO7cuM6-rsOc9SkRHhg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DA1B1091DA1;
        Sat, 19 Feb 2022 00:56:52 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-39.pek2.redhat.com [10.72.12.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C6CE62D60;
        Sat, 19 Feb 2022 00:56:37 +0000 (UTC)
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
Subject: [PATCH 19/22] ethernet: rocker: Use dma_alloc_noncoherent() for dma buffer
Date:   Sat, 19 Feb 2022 08:52:18 +0800
Message-Id: <20220219005221.634-20-bhe@redhat.com>
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

Use dma_alloc_noncoherent() instead to get the DMA buffer.

[ 42.hyeyoo@gmail.com: Use dma_alloc_noncoherent() instead of
  __get_free_pages.

  Fix memory leak. ]

Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: davem@davemloft.net
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/rocker/rocker_main.c | 59 +++++++++--------------
 1 file changed, 23 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 3fcea211716c..b23dd9b70d8d 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -193,20 +193,17 @@ static int rocker_dma_test_offset(const struct rocker *rocker,
 	int i;
 	int err;
 
-	alloc = kzalloc(ROCKER_TEST_DMA_BUF_SIZE * 2 + offset,
-			GFP_KERNEL | GFP_DMA);
+	alloc = dma_alloc_noncoherent(&pdev->dev,
+				ROCKER_TEST_DMA_BUF_SIZE * 2 + offset,
+				&dma_handle,
+				DMA_BIDIRECTIONAL,
+				GFP_KERNEL);
 	if (!alloc)
 		return -ENOMEM;
+
 	buf = alloc + offset;
 	expect = buf + ROCKER_TEST_DMA_BUF_SIZE;
 
-	dma_handle = dma_map_single(&pdev->dev, buf, ROCKER_TEST_DMA_BUF_SIZE,
-				    DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(&pdev->dev, dma_handle)) {
-		err = -EIO;
-		goto free_alloc;
-	}
-
 	rocker_write64(rocker, TEST_DMA_ADDR, dma_handle);
 	rocker_write32(rocker, TEST_DMA_SIZE, ROCKER_TEST_DMA_BUF_SIZE);
 
@@ -215,14 +212,14 @@ static int rocker_dma_test_offset(const struct rocker *rocker,
 				  dma_handle, buf, expect,
 				  ROCKER_TEST_DMA_BUF_SIZE);
 	if (err)
-		goto unmap;
+		goto free;
 
 	memset(expect, 0, ROCKER_TEST_DMA_BUF_SIZE);
 	err = rocker_dma_test_one(rocker, wait, ROCKER_TEST_DMA_CTRL_CLEAR,
 				  dma_handle, buf, expect,
 				  ROCKER_TEST_DMA_BUF_SIZE);
 	if (err)
-		goto unmap;
+		goto free;
 
 	prandom_bytes(buf, ROCKER_TEST_DMA_BUF_SIZE);
 	for (i = 0; i < ROCKER_TEST_DMA_BUF_SIZE; i++)
@@ -231,14 +228,11 @@ static int rocker_dma_test_offset(const struct rocker *rocker,
 				  dma_handle, buf, expect,
 				  ROCKER_TEST_DMA_BUF_SIZE);
 	if (err)
-		goto unmap;
-
-unmap:
-	dma_unmap_single(&pdev->dev, dma_handle, ROCKER_TEST_DMA_BUF_SIZE,
-			 DMA_BIDIRECTIONAL);
-free_alloc:
-	kfree(alloc);
+		goto free;
 
+free:
+	dma_free_noncoherent(&pdev->dev, ROCKER_TEST_DMA_BUF_SIZE * 2 + offset,
+			     alloc, dma_handle, DMA_BIDIRECTIONAL);
 	return err;
 }
 
@@ -500,20 +494,13 @@ static int rocker_dma_ring_bufs_alloc(const struct rocker *rocker,
 		dma_addr_t dma_handle;
 		char *buf;
 
-		buf = kzalloc(buf_size, GFP_KERNEL | GFP_DMA);
+		buf = dma_alloc_noncoherent(&pdev->dev, buf_size,
+				&dma_handle, direction, GFP_KERNEL);
 		if (!buf) {
 			err = -ENOMEM;
 			goto rollback;
 		}
 
-		dma_handle = dma_map_single(&pdev->dev, buf, buf_size,
-					    direction);
-		if (dma_mapping_error(&pdev->dev, dma_handle)) {
-			kfree(buf);
-			err = -EIO;
-			goto rollback;
-		}
-
 		desc_info->data = buf;
 		desc_info->data_size = buf_size;
 		dma_unmap_addr_set(desc_info, mapaddr, dma_handle);
@@ -526,11 +513,10 @@ static int rocker_dma_ring_bufs_alloc(const struct rocker *rocker,
 rollback:
 	for (i--; i >= 0; i--) {
 		const struct rocker_desc_info *desc_info = &info->desc_info[i];
-
-		dma_unmap_single(&pdev->dev,
-				 dma_unmap_addr(desc_info, mapaddr),
-				 desc_info->data_size, direction);
-		kfree(desc_info->data);
+		dma_free_noncoherent(&pdev->dev, desc_info->data_size,
+				     desc_info->data,
+				     dma_unmap_addr(desc_info, mapaddr),
+				     direction);
 	}
 	return err;
 }
@@ -548,10 +534,11 @@ static void rocker_dma_ring_bufs_free(const struct rocker *rocker,
 
 		desc->buf_addr = 0;
 		desc->buf_size = 0;
-		dma_unmap_single(&pdev->dev,
-				 dma_unmap_addr(desc_info, mapaddr),
-				 desc_info->data_size, direction);
-		kfree(desc_info->data);
+		dma_free_noncoherent(&pdev->dev,
+				     desc_info->data_size,
+				     desc_info->data,
+				     dma_unmap_addr(desc_info, mapaddr),
+				     direction);
 	}
 }
 
-- 
2.17.2

