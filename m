Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5784BC446
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 02:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbiBSA7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:59:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241015AbiBSA6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:58:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E455827F2BF
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645232255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=VzXzJB2PJKullCIvRUJRQ/3FG4DX8V+bJRm6qvn5FmA=;
        b=QQaLSNbH1SsuKasjrtZqJCNqN+Di0U3z2a672H27kUdCe7qDR7AwLLrp+dT+89m6mzgImM
        0fxroyzlA0JXcDz4RKo0ZFHvM+/ngmB/ZHkOw3pB0U8W6OZ5j6ANCUtZNl3XS2VP6GjdOE
        qauSPI/9qadgtlX87IsKNHhDZK+A4dA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-DtD3djaMMzmALzLGQE-47g-1; Fri, 18 Feb 2022 19:57:31 -0500
X-MC-Unique: DtD3djaMMzmALzLGQE-47g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 943B21006AA0;
        Sat, 19 Feb 2022 00:57:28 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-39.pek2.redhat.com [10.72.12.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E930262D4E;
        Sat, 19 Feb 2022 00:57:18 +0000 (UTC)
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
Subject: [PATCH 22/22] mtd: rawnand: Use dma_alloc_noncoherent() for dma buffer
Date:   Sat, 19 Feb 2022 08:52:21 +0800
Message-Id: <20220219005221.634-23-bhe@redhat.com>
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

Use dma_alloc_noncoherent() instead of directly allocating buffer
from kmalloc with GFP_DMA. DMA API will try to allocate buffer
depending on devices addressing limitation.

[ 42.hyeyoo@gmail.com: Use dma_alloc_noncoherent() instead of
  __get_free_page() and update changelog.

  As it does not allocate high order buffers, allocate buffer
  when needed and free after DMA. ]

Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: christian.koenig@amd.com
Cc: linux-mtd@lists.infradead.org

---
 drivers/mtd/nand/raw/marvell_nand.c | 55 ++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/drivers/mtd/nand/raw/marvell_nand.c b/drivers/mtd/nand/raw/marvell_nand.c
index 2455a581fd70..c0b64a7e50af 100644
--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -860,26 +860,45 @@ static int marvell_nfc_xfer_data_dma(struct marvell_nfc *nfc,
 	struct dma_async_tx_descriptor *tx;
 	struct scatterlist sg;
 	dma_cookie_t cookie;
-	int ret;
+	dma_addr_t dma_handle;
+	int ret = 0;
 
 	marvell_nfc_enable_dma(nfc);
+
+	/*
+	 * DMA must act on length multiple of 32 and this length may be
+	 * bigger than the destination buffer. Use this buffer instead
+	 * for DMA transfers and then copy the desired amount of data to
+	 * the provided buffer.
+	 */
+	nfc->dma_buf = dma_alloc_noncoherent(nfc->dev, MAX_CHUNK_SIZE,
+						&dma_handle,
+						direction,
+						GFP_ATOMIC);
+	if (!nfc->dma_buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+
 	/* Prepare the DMA transfer */
-	sg_init_one(&sg, nfc->dma_buf, dma_len);
-	dma_map_sg(nfc->dma_chan->device->dev, &sg, 1, direction);
-	tx = dmaengine_prep_slave_sg(nfc->dma_chan, &sg, 1,
+	tx = dmaengine_prep_slave_single(nfc->dma_chan, dma_handle, dma_len,
 				     direction == DMA_FROM_DEVICE ?
 				     DMA_DEV_TO_MEM : DMA_MEM_TO_DEV,
 				     DMA_PREP_INTERRUPT);
 	if (!tx) {
 		dev_err(nfc->dev, "Could not prepare DMA S/G list\n");
-		return -ENXIO;
+		ret = -ENXIO;
+		goto free;
 	}
 
 	/* Do the task and wait for it to finish */
 	cookie = dmaengine_submit(tx);
 	ret = dma_submit_error(cookie);
-	if (ret)
-		return -EIO;
+	if (ret) {
+		ret = -EIO;
+		goto free;
+	}
 
 	dma_async_issue_pending(nfc->dma_chan);
 	ret = marvell_nfc_wait_cmdd(nfc->selected_chip);
@@ -889,10 +908,16 @@ static int marvell_nfc_xfer_data_dma(struct marvell_nfc *nfc,
 		dev_err(nfc->dev, "Timeout waiting for DMA (status: %d)\n",
 			dmaengine_tx_status(nfc->dma_chan, cookie, NULL));
 		dmaengine_terminate_all(nfc->dma_chan);
-		return -ETIMEDOUT;
+		ret = -ETIMEDOUT;
+		goto free;
 	}
 
-	return 0;
+free:
+	dma_free_noncoherent(nfc->dev, MAX_CHUNK_SIZE, nfc->dma_buf,
+			     dma_handle, direction);
+
+out:
+	return ret;
 }
 
 static int marvell_nfc_xfer_data_in_pio(struct marvell_nfc *nfc, u8 *in,
@@ -2814,18 +2839,6 @@ static int marvell_nfc_init_dma(struct marvell_nfc *nfc)
 		goto release_channel;
 	}
 
-	/*
-	 * DMA must act on length multiple of 32 and this length may be
-	 * bigger than the destination buffer. Use this buffer instead
-	 * for DMA transfers and then copy the desired amount of data to
-	 * the provided buffer.
-	 */
-	nfc->dma_buf = kmalloc(MAX_CHUNK_SIZE, GFP_KERNEL | GFP_DMA);
-	if (!nfc->dma_buf) {
-		ret = -ENOMEM;
-		goto release_channel;
-	}
-
 	nfc->use_dma = true;
 
 	return 0;
-- 
2.17.2

